Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6216AE73
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgBXSOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:14:50 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50803 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXSOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:14:50 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6IFA-0001yV-FE; Mon, 24 Feb 2020 19:14:12 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A0404104088; Mon, 24 Feb 2020 19:14:11 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V3 10/22] bpf: Provide bpf_prog_run_pin_on_cpu() helper
In-Reply-To: <20200224145643.474592620@linutronix.de>
References: <20200224140131.461979697@linutronix.de> <20200224145643.474592620@linutronix.de>
Date:   Mon, 24 Feb 2020 19:14:11 +0100
Message-ID: <87v9nvn98s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> + * preempt_disable/enable(), i.e. it disables also preemption.
> + */
> +static inline u32 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
> +					  void *ctx)

I'm a moron. Let me resend this one.

> +{
> +	u32 ret;
> +
> +	migrate_disable();
> +	ret = __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nopfunc);
> +	migrate_enable();
> +	return ret;
> +}
>  
>  #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
>  
