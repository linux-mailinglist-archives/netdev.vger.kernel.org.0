Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BFF167F77
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgBUOBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:01:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45886 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgBUOBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:01:31 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j58rP-0003Ct-I7; Fri, 21 Feb 2020 15:00:55 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id BC53B100EA2; Fri, 21 Feb 2020 15:00:54 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Will Drewry <wad@chromium.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC patch 09/19] bpf: Use BPF_PROG_RUN_PIN_ON_CPU() at simple call sites.
In-Reply-To: <202002201616.21FA55E@keescook>
References: <20200214133917.304937432@linutronix.de> <20200214161503.804093748@linutronix.de> <87a75ftkwu.fsf@linux.intel.com> <875zg3q7cn.fsf@nanos.tec.linutronix.de> <202002201616.21FA55E@keescook>
Date:   Fri, 21 Feb 2020 15:00:54 +0100
Message-ID: <87lfownip5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> On Wed, Feb 19, 2020 at 10:00:56AM +0100, Thomas Gleixner wrote:
>> Vinicius Costa Gomes <vinicius.gomes@intel.com> writes:
>> > More a question really, isn't the behavior changing here? i.e. shouldn't
>> > migrate_disable()/migrate_enable() be moved to outside the loop? Or is
>> > running seccomp filters on different cpus not a problem?
>> 
>> In my understanding this is a list of filters and they are independent
>> of each other.
>> 
>> Kees, Will. Andy?
>
> They're technically independent, but they are related to each
> other. (i.e. order matters, process hierarchy matters, etc). There's no
> reason I can see that we can't switch CPUs between running them, though.
> (AIUI, nothing here would suddenly make these run in parallel, right?)

Of course not. If we'd run the same thread on multiple CPUs in parallel
the ordering of your BPF programs would be the least of your worries.

> As long as "current" is still "current", and they run in the same order,
> we'll get the same final result as far as seccomp is concerned.

Right.

Thanks,

        tglx
