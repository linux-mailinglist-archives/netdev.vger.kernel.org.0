Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4319190B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgCXS0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:26:05 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37709 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbgCXS0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:26:04 -0400
Received: by mail-qk1-f195.google.com with SMTP id x3so8810580qki.4
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 11:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iEmpsAyt9B1Qcdkh4hlRJzHYHPiVdMatdhGGO+kX6u0=;
        b=XviXDdgRMR3A1ee54Wowb70vIsLpggnUxurOugFzJ+rMRbEWy19ZdXhIQG8po0nuoq
         +zQF77o09zsBvEAMrLmPfUbOj/iB/K7nHwJmK5u3waH0Ns6p9BDbathMFtZ6NE3rNO/a
         eUJzkjun1iZzOBflcQHA8PWiD8khlP9p5A0R0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iEmpsAyt9B1Qcdkh4hlRJzHYHPiVdMatdhGGO+kX6u0=;
        b=OFdRBpXV/6bJnn0j41K+7cdEl9gC0LB0JO2Rr0SRnYt1z8T1vA8LR2QRfAtx9lrbjH
         mU0RFJKEb+qpfz6N3uqLVJjWhO+t42AipN8zMwtbEUpZWKaZ5xGzHgxsYKPmluWrZqK8
         WJnkNkMhzdG2iuZTUj7AGjU1ZLrrYueAJSjGMLFRrRSMcJ49dITE+P3iyujGNALxFkf7
         og96WMj6fFrna0nduspwgsy2kQl/02XsR6s8T+1PzfpNzPHoOp/qUW2Gi4DY1X3kUATP
         0GrWq9SNgCeD48zsGa2YZLkw6i7V+LNT1nkxz5zdmvEAOcONut6F0RC4QuUwPe4V9H9Q
         IH8Q==
X-Gm-Message-State: ANhLgQ1H8mkj5WLzTT9ALCu3K2FN+ZtZxKZdKY1ZKIAybQxQUY0ezxbt
        t2hBpVxOE2Chzto7wOuizk2bXQ==
X-Google-Smtp-Source: ADFU+vsDFgrzlLzo7PWHXfC4Na59e1GjR7LhLOqmWSGaiqojVW66Z6eiEsCwPhPF2x51Legtscepqg==
X-Received: by 2002:a05:620a:1250:: with SMTP id a16mr12752127qkl.497.1585074361932;
        Tue, 24 Mar 2020 11:26:01 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y5sm14014261qkb.123.2020.03.24.11.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:26:01 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:26:01 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Will Deacon <will@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Documentation: Clarify better about the rwsem non-owner
 release issue
Message-ID: <20200324182601.GC257597@google.com>
References: <20200322021938.175736-1-joel@joelfernandes.org>
 <87a748khlo.fsf@kamboji.qca.qualcomm.com>
 <20200323182349.GA203600@google.com>
 <20200324081538.GA8696@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324081538.GA8696@willie-the-truck>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:15:39AM +0000, Will Deacon wrote:
> On Mon, Mar 23, 2020 at 02:23:49PM -0400, Joel Fernandes wrote:
> > On Sun, Mar 22, 2020 at 08:51:15AM +0200, Kalle Valo wrote:
> > > "Joel Fernandes (Google)" <joel@joelfernandes.org> writes:
> > > 
> > > > Reword and clarify better about the rwsem non-owner release issue.
> > > >
> > > > Link: https://lore.kernel.org/linux-pci/20200321212144.GA6475@google.com/
> > > >
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > 
> > > There's something wrong with your linux-pci and linux-usb addresses:
> > > 
> > > 	"linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,
> > > 
> > > 
> > > 	"linux-usb@vger.kernel.org Kalle Valo" <kvalo@codeaurora.org>,
> > 
> > Not sure. It appears fine in the archive.
> 
> Hmm, I don't think it does. Here's the copy from LKML:
> 
> https://lore.kernel.org/lkml/20200322021938.175736-1-joel@joelfernandes.org/
> 
> Which works because it's in the To: correctly. But both linux-pci and
> linux-usb were *not* CC'd:
> 
> "linux-usb@vger.kernel.org Kalle Valo" <kvalo@codeaurora.org>
> "linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>
> 
> and searching for the message in the linux-pci archives doesn't find it:
> 
> https://lore.kernel.org/linux-pci/?q=Reword+and+clarify+better+about+the+rwsem+non-owner+release+issue
> 
> So it looks like there is an issue with your mail setup.

Hi Will and Kalle,
Thank you for confirming it. You are right, the archive shows the issue. I
will double check my client and see what's going on.

thanks,

 - Joel

