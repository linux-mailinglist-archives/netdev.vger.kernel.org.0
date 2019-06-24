Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99274519FD
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731909AbfFXRu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:50:59 -0400
Received: from mail.efficios.com ([167.114.142.138]:56186 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfFXRu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:50:58 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 048B225B682;
        Mon, 24 Jun 2019 13:50:57 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id kubqiW463fQT; Mon, 24 Jun 2019 13:50:56 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 7489F25B67D;
        Mon, 24 Jun 2019 13:50:56 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 7489F25B67D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1561398656;
        bh=YgTDjKzulnpRdHN03BOtIF36ow3kBCQn4Ff76WlCgv4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=rLqqpYL/J/9XfjfblU5xlkvGWUSmihnJQ1Jj+o+LyOs12tFBNAr1nEfFtsTTbHkTC
         z3JpCf3sxds6+xj+N6N+eAdu7PLH7IjyKqW4xBvTXwFly76m0Z2u1YBoTOLJczUkM0
         af9cCewWfDNX+TUVdoyv4nYvprFyIJtB1nvenD1tXHWmGLa8EHo2puqwvwnu2QYy1W
         PvyXm2wRevcjxansTh7n/NsUEb3gbqk1qJ6384uCbaMkHkEfq9bKz3fzKAtgks5juq
         4N4+Q4+vUaz04xgJ2Fxkw02Rkug7uDoWxy7xwJKtj0Bu9sdZNz+g/zGn2CWy9wYqoC
         9BAjlgFEQGuLA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 6I-HKbAyDBuh; Mon, 24 Jun 2019 13:50:56 -0400 (EDT)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 575FD25B675;
        Mon, 24 Jun 2019 13:50:56 -0400 (EDT)
Date:   Mon, 24 Jun 2019 13:50:56 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     "Joel Fernandes, Google" <joel@joelfernandes.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, jikos <jikos@kernel.org>,
        mbenes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Richter <rric@kernel.org>,
        rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        paulmck <paulmck@linux.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list <oprofile-list@lists.sf.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <2125299316.352.1561398656224.JavaMail.zimbra@efficios.com>
In-Reply-To: <20190624155213.GB261936@google.com>
References: <20190624091843.859714294@infradead.org> <20190624092109.805742823@infradead.org> <320564860.243.1561384864186.JavaMail.zimbra@efficios.com> <20190624155213.GB261936@google.com>
Subject: Re: [PATCH 2/3] module: Fix up module_notifier return values.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.12_GA_3803 (ZimbraWebClient - FF67 (Linux)/8.8.12_GA_3794)
Thread-Topic: module: Fix up module_notifier return values.
Thread-Index: YqiVsEGYR43tan1IptAyCZzN3mIl4w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 24, 2019, at 11:52 AM, Joel Fernandes, Google joel@joelfernandes.org wrote:

> On Mon, Jun 24, 2019 at 10:01:04AM -0400, Mathieu Desnoyers wrote:
>> ----- On Jun 24, 2019, at 5:18 AM, Peter Zijlstra peterz@infradead.org wrote:
>> 
>> > While auditing all module notifiers I noticed a whole bunch of fail
>> > wrt the return value. Notifiers have a 'special' return semantics.
>> > 
>> > Cc: Robert Richter <rric@kernel.org>
>> > Cc: Steven Rostedt <rostedt@goodmis.org>
>> > Cc: Ingo Molnar <mingo@redhat.com>
>> > Cc: Alexei Starovoitov <ast@kernel.org>
>> > Cc: Daniel Borkmann <daniel@iogearbox.net>
>> > Cc: Martin KaFai Lau <kafai@fb.com>
>> > Cc: Song Liu <songliubraving@fb.com>
>> > Cc: Yonghong Song <yhs@fb.com>
>> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> > Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
>> > Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
>> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > Cc: oprofile-list@lists.sf.net
>> > Cc: linux-kernel@vger.kernel.org
>> > Cc: netdev@vger.kernel.org
>> > Cc: bpf@vger.kernel.org
>> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> 
>> Thanks Peter for looking into this, especially considering your
>> endless love for kernel modules! ;)
>> 
>> It's not directly related to your changes, but I notice that
>> kernel/trace/trace_printk.c:hold_module_trace_bprintk_format()
>> appears to leak memory. Am I missing something ?
> 
> Could you elaborate? Do you mean there is no MODULE_STATE_GOING notifier
> check? If that's what you mean then I agree, there should be some place
> where the format structures are freed when the module is unloaded no?

Yes, the lack of GOING notifier is worrying considering that GOING
performs memory allocation.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
