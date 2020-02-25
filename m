Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69A416C0F1
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgBYMg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:36:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:52876 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgBYMg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:36:56 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6ZRg-0002g5-4R; Tue, 25 Feb 2020 13:36:16 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 135EB101226; Tue, 25 Feb 2020 13:36:15 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
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
Subject: Re: [patch V3 06/22] bpf/trace: Remove redundant preempt_disable from trace_call_bpf()
In-Reply-To: <20200225003351.vvsrgyta47ciqhvo@ast-mbp>
References: <20200224140131.461979697@linutronix.de> <20200224145643.059995527@linutronix.de> <20200224194017.rtwjcgjxnmltisfe@ast-mbp> <875zfvk983.fsf@nanos.tec.linutronix.de> <20200225003351.vvsrgyta47ciqhvo@ast-mbp>
Date:   Tue, 25 Feb 2020 13:36:15 +0100
Message-ID: <8736aykfnk.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> On Mon, Feb 24, 2020 at 09:42:52PM +0100, Thomas Gleixner wrote:
>> > But looking at your patch cant_sleep() seems unnecessary strong.
>> > Should it be cant_migrate() instead?
>> 
>> Yes, if we go with the migrate_disable(). OTOH, having a
>> preempt_disable() in that uprobe callsite should work as well, then we
>> can keep the cant_sleep() check which covers all other callsites
>> properly. No strong opinion though.
>
> ok. I went with preempt_disable() for uprobes. It's simpler.
> And pushed the whole set to bpf-next.
> In few days we'll send it to Dave for net-next and on the way
> to Linus's next release. imo it's a big milestone.
> Thank you for the hard work to make it happen.

Thank you for guidance and review!

      tglx
