Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 469FE5F838
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfGDMeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:34:12 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44343 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbfGDMeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:34:12 -0400
Received: by mail-lf1-f66.google.com with SMTP id r15so4126489lfm.11;
        Thu, 04 Jul 2019 05:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WZGgIFqntPiBjka+Oo35Sy0erf1ztfXIu7MoeeCl7sI=;
        b=U9w9DXvX6ZI9Ka2kloHxm/f4bFuu9xySWFoJtdxm/VYD4Rkc+XAKcMy5K7CBhciu02
         SEq/+/Pio+BB9Rco4ZaD6BQbo6UwGX6CfbA1orS2o/JIML3G8areymFCYg7SLLSgm3y2
         Cnp97gucU6HsG/BSS9GfAu2abg4TzfWCJELRa/XBgL1f/xeIB3En/q4vqN48n5X6v7fy
         x47DQ9CxjWYjlNCwtb+lMVZAz1Xj+t38c8RSSwnnzhmdHJu6mqPPM6G7fucCRDrfcmjN
         htaCUlrr8Pu2JHWIcLLuzeYPjlMTFg3a3UkK9gM+OPsHnkqzEMY4VnSl/1mq6NmYB0cV
         MwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WZGgIFqntPiBjka+Oo35Sy0erf1ztfXIu7MoeeCl7sI=;
        b=anVep3fciviRt4QnTG02L59A3HEUgknfjws8vkkqY765ZbYNB6T1InsRm/kpBcOlVD
         T+gbDHxCtyK7j1wsKAp4Lkq068MJhe8Cy64gOVqLghaoKXPEwUe+dLZ6UjFmEgye1bEX
         AehmWzsAUPz508fJw4FINQfqPBXmWhoG9Z066XUXwvIqDhnNE0OEwdQlaY1pZ2CQcGjt
         8kuNez7tEPk2tmELCbhppzaxqqy0kgCZSvBHiFZayaQO6HYT7QWldKp7Su28/uGwwj1D
         xFqih3a4Zati+vVJLktTU98BCmBfAAM0KN4rwsJaM4AmIsBNnRlwiuXRbpeD1rRiP1Ne
         NYbA==
X-Gm-Message-State: APjAAAXVBkqAcYg7FBQZ0u+yAwA/UTpPPfOW0bRWRp1oSS3XkIB7lFkW
        f9/WHfU2pyV9MwwZILbF6zI=
X-Google-Smtp-Source: APXvYqySbtfjf5ef9HvwH/IVOxIOPBsJfR47YKZt5UHXpmB0NuOgbexAL27Jj/lAMUuPKodQ3L6YNA==
X-Received: by 2002:ac2:4351:: with SMTP id o17mr1633834lfl.100.1562243649805;
        Thu, 04 Jul 2019 05:34:09 -0700 (PDT)
Received: from rric.localdomain (83-233-147-164.cust.bredband2.com. [83.233.147.164])
        by smtp.gmail.com with ESMTPSA id b25sm866069lfq.11.2019.07.04.05.34.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 05:34:08 -0700 (PDT)
Date:   Thu, 4 Jul 2019 14:34:00 +0200
From:   Robert Richter <rric@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, ast@kernel.org, daniel@iogearbox.net,
        akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list@lists.sf.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/3] module: Fix up module_notifier return values.
Message-ID: <20190704123359.jumjke6p7p5r7wbx@rric.localdomain>
References: <20190624091843.859714294@infradead.org>
 <20190624092109.805742823@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624092109.805742823@infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.06.19 11:18:45, Peter Zijlstra wrote:
> While auditing all module notifiers I noticed a whole bunch of fail
> wrt the return value. Notifiers have a 'special' return semantics.
> 
> Cc: Robert Richter <rric@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: oprofile-list@lists.sf.net
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  drivers/oprofile/buffer_sync.c |    4 ++--
>  kernel/module.c                |    9 +++++----
>  kernel/trace/bpf_trace.c       |    8 ++++++--
>  kernel/trace/trace.c           |    2 +-
>  kernel/trace/trace_events.c    |    2 +-
>  kernel/trace/trace_printk.c    |    4 ++--
>  kernel/tracepoint.c            |    2 +-
>  7 files changed, 18 insertions(+), 13 deletions(-)

Reviewed-by: Robert Richter <rric@kernel.org>
