Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0580D16374C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgBRXgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:36:51 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35229 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgBRXgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:36:50 -0500
Received: by mail-pj1-f66.google.com with SMTP id q39so1694106pjc.0;
        Tue, 18 Feb 2020 15:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bTzxD9TcFYcChEJJr98YzSBO8WFXRduTV9HuNB7JAI0=;
        b=uwceS1lBwDXOZIZaX98KUbUeiIKQYJmtbXvRktMiGsvOP/lZwsEj6NTczMS0EmOVtE
         6NQeRrWHDcbavsVfdxKUICBZ+fYZEjYwt8v8jx7wxKin6XOTP/8Vvtf5ZNVmqMRmBZ8Z
         a/LIK+1eFNrtc0AbOP6ds5wvmpQPgPCx9NOTanOFQqU0ok4W6VavErSkyLQT1XjMVS4w
         x7VJKg+y/nDoHEnjysAHc70yw7KKF51SI/NnkOD9MptqHZr9tZeDg0ndMZKcPbvtwpW9
         k6rczakekV0Ht82e3uL/ZDqleQOLY/o6zaqcwNZ8P+89QJfDV9CzOe5XkwiSbeI9vr8Z
         a+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bTzxD9TcFYcChEJJr98YzSBO8WFXRduTV9HuNB7JAI0=;
        b=srF1BEB7tS0f1N1M//P4nXUzhKl4vDvR6NzI8dodavIzS7rRuCWEprxr7BXNo7+qKs
         Dw3Nd4WyMNTYu8anGWtMz/pa4qBKnwKccQfwRt352QshPXTSge8vQxTvEyGOBskx47mI
         jpucuYPvrWn7M3hO1MKTk8mNvsbNcW2g/y+piNQ/4PJKaAZa4bYAJKe4dufwG+3SR6vm
         3FvgNwqKhE88u41zyIg2O7qq9xGXjrWXEQe1Rh4P3GT4MnPMk5KBtRsph4Rw7yI7TTeK
         oQPrFXgT7S5ReJzFH8S/4ixaIx7kYeZ8Yhwj4KBOy1Ybhc8IddB/wyXObnS0tGUTVESt
         udeQ==
X-Gm-Message-State: APjAAAVXQ6npScRnoTLeXkn5nW1Y5GME7KuzbWccgTg3FhNccl52Vexo
        48kZ3HjShW45ry55KW5yGHg=
X-Google-Smtp-Source: APXvYqzNtI9Cmyr0xksX/kuZPbU/WRWO1EWsEb8gLhMo5G+UefucY3zihUkjbYj8A4ORpQGFiCKxQg==
X-Received: by 2002:a17:902:8a85:: with SMTP id p5mr23934536plo.154.1582069009699;
        Tue, 18 Feb 2020 15:36:49 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:dd54])
        by smtp.gmail.com with ESMTPSA id s13sm3824655pjp.1.2020.02.18.15.36.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 15:36:48 -0800 (PST)
Date:   Tue, 18 Feb 2020 15:36:42 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 14/19] bpf: Use migrate_disable() in hashtab code
Message-ID: <20200218233641.i7fyf36zxocgucap@ast-mbp>
References: <20200214133917.304937432@linutronix.de>
 <20200214161504.325142160@linutronix.de>
 <20200214191126.lbiusetaxecdl3of@localhost>
 <87imk9t02r.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imk9t02r.fsf@nanos.tec.linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 08:56:12PM +0100, Thomas Gleixner wrote:
> 
> > Also, I don't think using __this_cpu_inc() without preempt-disable or
> > irq off is safe. You'll probably want to move to this_cpu_inc/dec
> > instead, which can be heavier on some architectures.
> 
> Good catch.

Overall looks great.
Thank you for taking time to write commit logs and detailed cover letter.
I think s/__this_cpu_inc/this_cpu_inc/ is the only bit that needs to be
addressed for it to be merged.
There were few other suggestions from Mathieu and Jakub.
Could you address them and resend?
I saw patch 1 landing in tip tree, but it needs to be in bpf-next as well
along with the rest of the series. Does it really need to be in the tip?
I would prefer to take the whole thing and avoid conflicts around
migrate_disable() especially if nothing in tip is going to use it in this
development cycle. So just drop patch 1 from the tip?

Regarding
union {
   raw_spinlock_t  raw_lock;
   spinlock_t      lock;
};
yeah. it's not pretty, but I also don't have better ideas.

Regarding migrate_disable()... can you enable it without the rest of RT?
I haven't seen its implementation. I suspect it's scheduler only change?
If I can use migrate_disable() without RT it will help my work on sleepable
BPF programs. I would only have to worry about rcu_read_lock() since
preempt_disable() is nicely addressed.
