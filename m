Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F239670A9
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfGLN4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:56:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42622 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfGLN4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:56:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so4574861pgb.9
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 06:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WDiv0t+R3uRl5W7qmXtAoSiEHEHdxKx4ml5mjXWh+Pg=;
        b=QYqkLEGFA1/hJ7msrSJEUejaFTfoP3QzQQ0XbAHmT9Csl4VlQGRIXmlO2ywQXQvND+
         Hrz0eSA/du87KWMiWhvfsSxGBDZW8Y6Afvn5Q1TceLQvp9r9CvlEbDnZIeTmNrviry7U
         wYHovwF3+TslYJyFDr+Shjrc4RZtnIq4XuqVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WDiv0t+R3uRl5W7qmXtAoSiEHEHdxKx4ml5mjXWh+Pg=;
        b=ar5AHuDndbskcnp1T+fU5lK0+rPQCOsd58o35NEkScMStRf36OxG/wnv56tmMoWop0
         oTYAsF4nORVuIhnxRRv4OFQFViO7VrDTDwC0JIH/LghENGKhhroQAnfwEK1Wa83/Cpj2
         FGgTD64lJfO3Ltief6zSFa7qoBwPIOoPPHHKI1Q1D7+r0pkZI6sJNnDmeHLHqTeb1ngK
         WPbr0XcGsSRzKclOp79a0VRvUDz/YFHxIq8c9PpoJwbCT5oqmAy5V6brl4PtGyTSbJ3P
         OjWyKPPkfbfvW/GEf4mNCEyYg2XTlL+nS3+QDw0zz7z5xN4hNFqJ/NGzrQx/ILyoVRIV
         zmsQ==
X-Gm-Message-State: APjAAAUAxgRgfP12t4wkkXgP7aiFnzwoc0yasoM45sSyELHNMn21c1cB
        Ad3pKyQ2eKSy0XqN2oBjJ5Q=
X-Google-Smtp-Source: APXvYqzJEhVDBzSiRVeb97C/BOIrGCC92lhrBy1TO8FxsLTYA0YSdLtl7eAeD1UPch8SID4lyw/Qag==
X-Received: by 2002:a63:b1d:: with SMTP id 29mr11024618pgl.103.1562939792240;
        Fri, 12 Jul 2019 06:56:32 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h16sm9673070pfo.34.2019.07.12.06.56.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 06:56:31 -0700 (PDT)
Date:   Fri, 12 Jul 2019 09:56:29 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712135629.GH92297@google.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712121200.GC21989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121200.GC21989@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 02:12:00PM +0200, Oleg Nesterov wrote:
> On 07/11, Joel Fernandes (Google) wrote:
> >
> > +int rcu_read_lock_any_held(void)
> 
> rcu_sync_is_idle() wants it. You have my ack in advance ;)

Cool, thanks ;)

- Joel
