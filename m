Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9BA18FCA1
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCWSYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:24:01 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34481 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgCWSXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:23:52 -0400
Received: by mail-qt1-f194.google.com with SMTP id 10so12601795qtp.1
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 11:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F/E2v/x0pD9S4co1rTwzqU5wtimX1Afhqg2gi2bulTI=;
        b=FH2qRmBSbSJZwB+BSXSQMYNKeGdg7FKsSXSb1K9JlVNhBvCRpF35Y1/cWbC8uK2uBj
         sxGBJGFMVlcJsfQa8mZ95ubQaEtjdmQCqtEE3Q92O2nL8F41seejAlpR8I49wXqAeU/B
         eqkpUOGxjScSYfB1LTpqwq4PRjJgwkCS4B5OA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F/E2v/x0pD9S4co1rTwzqU5wtimX1Afhqg2gi2bulTI=;
        b=WokvGxbWcYyv4K9urQ8p1+A1ED5XA72nc0lvyMTkEwTvidg3kl0rD/w6HlkNfcqpma
         LawI5Q30VoS7trKeBc7HoH99pbGqoItg8u9iX3Ep3Z6u5nLbHDQ7CH67+RCoIix4mSx/
         JGv/VFsKMzQlOyWTJghRnRjzxnrOwjYLAUTsSmaEShZ4EGHl0KtbCbw43zLHx3Bw/MJB
         U8An9rp3DGm9EYV+EZOHgdKSUSXp44P60X7P89sKRP2sEdSaQ8dcZ4NwMDGouPRBeQ3x
         51FgWOyA4FQ8LalDWGkFL4rPQIDZLCke/W4aLd+P/kZwqMqhWuR19CC9QAMeZCRG5Th+
         xCgw==
X-Gm-Message-State: ANhLgQ0OIbck2bOSfejWH2fNAQjvQhRJNtlwsjTYkdHby2i2UdPPStrP
        +v0OTN0vZgzRX3eK1KT27PKO3Q==
X-Google-Smtp-Source: ADFU+vva33T81FQrImBGAaIoEJK5Y8QnH9XQzRThIpIuh9LK6narFxQkMI+JxtK3VLi/dxYocOD3FA==
X-Received: by 2002:ac8:140e:: with SMTP id k14mr22547629qtj.222.1584987830199;
        Mon, 23 Mar 2020 11:23:50 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id 85sm9774863qke.128.2020.03.23.11.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 11:23:49 -0700 (PDT)
Date:   Mon, 23 Mar 2020 14:23:49 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
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
Message-ID: <20200323182349.GA203600@google.com>
References: <20200322021938.175736-1-joel@joelfernandes.org>
 <87a748khlo.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a748khlo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 08:51:15AM +0200, Kalle Valo wrote:
> "Joel Fernandes (Google)" <joel@joelfernandes.org> writes:
> 
> > Reword and clarify better about the rwsem non-owner release issue.
> >
> > Link: https://lore.kernel.org/linux-pci/20200321212144.GA6475@google.com/
> >
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> There's something wrong with your linux-pci and linux-usb addresses:
> 
> 	"linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,
> 
> 
> 	"linux-usb@vger.kernel.org Kalle Valo" <kvalo@codeaurora.org>,

Not sure. It appears fine in the archive. Thomas, let me know if you wanted
me to resend the diff patch. Hopefully it squashed fine into your original
patch.

thanks,

 - Joel

