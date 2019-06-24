Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B9350D28
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfFXOBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:01:07 -0400
Received: from mail.efficios.com ([167.114.142.138]:47618 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbfFXOBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:01:06 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 1F7B81E5846;
        Mon, 24 Jun 2019 10:01:05 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 30tAHu-OSvYj; Mon, 24 Jun 2019 10:01:04 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 8165B1E5831;
        Mon, 24 Jun 2019 10:01:04 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 8165B1E5831
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1561384864;
        bh=jc8emB4G4DxkJzWoVya72U2d4KhEjMEUsAUMMkYgQZg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=VRVt6rcQHjCVHpY12SUnfvqlKUBvg1qfQjZJd0XJbcWX4BQjiksIwFvj7U9rk0k4w
         SDzLnSaHbDP1KXbm8Sh1yANLrmDpZpKiNFMIiLp+y9ZL24ctCzMDsacLQw5JaSVete
         VmnbGGquOkVhdsMO4gxWpT5mf2ItkyFKwn/RPXXJTfJn8/Bh+fXD7hqN3ldc3nfz3O
         xkzg2h9uAUKrUBuG2SlEmK0CGuYJAXyFrzwFA0sAHOBuhFX3mQB6tgAkvAjVOo69VE
         VavVADsPFOi8CSochiTy/3DU5WMMQp/aADvnBhVdpq9eYpNYb7U+67m9/jTd9JMepV
         HY/AvTjjRk+QA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id dJQ_J6pq8rdl; Mon, 24 Jun 2019 10:01:04 -0400 (EDT)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 541671E582B;
        Mon, 24 Jun 2019 10:01:04 -0400 (EDT)
Date:   Mon, 24 Jun 2019 10:01:04 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, jikos@kernel.org,
        mbenes@suse.cz, Petr Mladek <pmladek@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Richter <rric@kernel.org>,
        rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        paulmck <paulmck@linux.ibm.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list@lists.sf.net, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Message-ID: <320564860.243.1561384864186.JavaMail.zimbra@efficios.com>
In-Reply-To: <20190624092109.805742823@infradead.org>
References: <20190624091843.859714294@infradead.org> <20190624092109.805742823@infradead.org>
Subject: Re: [PATCH 2/3] module: Fix up module_notifier return values.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.12_GA_3803 (ZimbraWebClient - FF67 (Linux)/8.8.12_GA_3794)
Thread-Topic: module: Fix up module_notifier return values.
Thread-Index: wEhc4w1xfyhyzFRK4s3Hnq/quVAuEQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 24, 2019, at 5:18 AM, Peter Zijlstra peterz@infradead.org wrote:

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

Thanks Peter for looking into this, especially considering your
endless love for kernel modules! ;)

It's not directly related to your changes, but I notice that
kernel/trace/trace_printk.c:hold_module_trace_bprintk_format()
appears to leak memory. Am I missing something ?

With respect to your changes:
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

I have a similar erroneous module notifier return value pattern
in lttng-modules as well. I'll go fix it right away. CCing
Frank Eigler from SystemTAP which AFAIK use a copy of
lttng-tracepoint.c in their project, which should be fixed
as well. I'm pasting the lttng-modules fix below.

Thanks!

Mathieu

--

commit 5eac9d146a7d947f0f314c4f7103c92cbccaeaf3
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Mon Jun 24 09:43:45 2019 -0400

    Fix: lttng-tracepoint module notifier should return NOTIFY_OK
    
    Module notifiers should return NOTIFY_OK on success rather than the
    value 0. The return value 0 does not seem to have any ill side-effects
    in the notifier chain caller, but it is preferable to respect the API
    requirements in case this changes in the future.
    
    Notifiers can encapsulate a negative errno value with
    notifier_from_errno(), but this is not needed by the LTTng tracepoint
    notifier.
    
    The approach taken in this notifier is to just print a console warning
    on error, because tracing failure should not prevent loading a module.
    So we definitely do not want to stop notifier iteration. Returning
    an error without stopping iteration is not really that useful, because
    only the return value of the last callback is returned to notifier chain
    caller.
    
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

diff --git a/lttng-tracepoint.c b/lttng-tracepoint.c
index bbb2c7a4..8298b397 100644
--- a/lttng-tracepoint.c
+++ b/lttng-tracepoint.c
@@ -256,7 +256,7 @@ int lttng_tracepoint_coming(struct tp_module *tp_mod)
                }
        }
        mutex_unlock(&lttng_tracepoint_mutex);
-       return 0;
+       return NOTIFY_OK;
 }
 
 static


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
