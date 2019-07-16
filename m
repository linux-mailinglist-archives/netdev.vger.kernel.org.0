Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091E96B17C
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbfGPWCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:02:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33905 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387785AbfGPWCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:02:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so3876128pgc.1
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 15:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2z9KNQXlh1uTspFy4ArQuvTJcR1Rzwr1DildJveu51k=;
        b=Nj4Apsx7+yF16h8Bgn0/aVZptTaAfrLBte4ocvydTpKDQLn5zJH9m64VOqx0AGgMOA
         9HALNTV6H66Ed1+hvZ8A79pTZKqASniWSBiSgJO+3qYxy/a0f7aH4C2yghsLt+aKszer
         Ko+jVULH3Uc8rJuQR+id5tzBt3QHpebPG2tfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2z9KNQXlh1uTspFy4ArQuvTJcR1Rzwr1DildJveu51k=;
        b=KQWFfFodC/nZRgDRLMI77wJAxfJTp11kMhKBroIx5igmKuwzYa25LetinQT0MsGn2W
         DhWZJB0hCDt+6rFvjWxpxqIu3BpYfDOR8xK0bDA4TAMiw9m+gGi1u1ehsGJTkxQAMl6i
         qZj4kFP4mav3M0E2E0M9vdqZd18Uv0fuuxg2FS+NnSJ6K2Atjsb3ICVjR62AMoSQG+8o
         Tk/GfN+c1YaQyLCxTLuTuXd8zfuj2WDfHvocA7ZkZR03AQYN3UPYjojItdcsfixZ3nwF
         k86hCF4+kBMcOwgEEwxuEQqha1qdLeWbocoESAaMQpsfKK3Pmfoy2pi92TeAQPz/ACgt
         KnOA==
X-Gm-Message-State: APjAAAWLCQrO1SRD+MHrPWCdcUNAnYIS2BVqRn9XakjSfT6YJ/4KgGb8
        SJ/jmlGt7bx44bEiTal9LKo=
X-Google-Smtp-Source: APXvYqxaEDRbasy8NySgdX0n0Gtordok4+zLKu64dtBW+xFIbgsDp3e73uVzAdPXDqTAj25BPb/h3Q==
X-Received: by 2002:a65:500a:: with SMTP id f10mr5773696pgo.105.1563314527534;
        Tue, 16 Jul 2019 15:02:07 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id z4sm36091350pfg.166.2019.07.16.15.02.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 15:02:06 -0700 (PDT)
Date:   Tue, 16 Jul 2019 18:02:05 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/9] rcu: Add support for consolidated-RCU reader
 checking (v3)
Message-ID: <20190716220205.GB172157@google.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-3-joel@joelfernandes.org>
 <20190716183833.GD14271@linux.ibm.com>
 <20190716184649.GA130463@google.com>
 <20190716185303.GM14271@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716185303.GM14271@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:53:03AM -0700, Paul E. McKenney wrote:
[snip]
> > > A few more things below.
> > > > ---
> > > >  include/linux/rculist.h  | 28 ++++++++++++++++++++-----
> > > >  include/linux/rcupdate.h |  7 +++++++
> > > >  kernel/rcu/Kconfig.debug | 11 ++++++++++
> > > >  kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
> > > >  4 files changed, 67 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > > > index e91ec9ddcd30..1048160625bb 100644
> > > > --- a/include/linux/rculist.h
> > > > +++ b/include/linux/rculist.h
> > > > @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> > > >   */
> > > >  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> > > >  
> > > > +/*
> > > > + * Check during list traversal that we are within an RCU reader
> > > > + */
> > > > +
> > > > +#ifdef CONFIG_PROVE_RCU_LIST
> > > 
> > > This new Kconfig option is OK temporarily, but unless there is reason to
> > > fear malfunction that a few weeks of rcutorture, 0day, and -next won't
> > > find, it would be better to just use CONFIG_PROVE_RCU.  The overall goal
> > > is to reduce the number of RCU knobs rather than grow them, must though
> > > history might lead one to believe otherwise.  :-/
> > 
> > If you want, we can try to drop this option and just use PROVE_RCU however I
> > must say there may be several warnings that need to be fixed in a short
> > period of time (even a few weeks may be too short) considering the 1000+
> > uses of RCU lists.
> Do many people other than me build with CONFIG_PROVE_RCU?  If so, then
> that would be a good reason for a temporary CONFIG_PROVE_RCU_LIST,
> as in going away in a release or two once the warnings get fixed.

PROVE_RCU is enabled by default with PROVE_LOCKING, so it is used quite
heavilty.

> > But I don't mind dropping it and it may just accelerate the fixing up of all
> > callers.
> 
> I will let you decide based on the above question.  But if you have
> CONFIG_PROVE_RCU_LIST, as noted below, it needs to depend on RCU_EXPERT.

Ok, will make it depend. But yes for temporary purpose, I will leave it as a
config and remove it later.

thanks,

 - Joel
 
