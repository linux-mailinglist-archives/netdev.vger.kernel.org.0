Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50422B71F6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgKQXIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:08:21 -0500
Received: from mail.efficios.com ([167.114.26.124]:49092 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKQXIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:08:21 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A44BF2E563A;
        Tue, 17 Nov 2020 18:08:19 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id C-JTNgIjBoGY; Tue, 17 Nov 2020 18:08:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4352F2E5540;
        Tue, 17 Nov 2020 18:08:19 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4352F2E5540
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605654499;
        bh=ny8zTBzSRWvtAmF5MugMVF80ezhAcikgIekNu+Wm2VY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=qQjvqrFavNqucz8gJeMOH9QeGiTDiNNMO+BnulZ0iS3cmF0cD+jUTfxgRpKGtjzhv
         gAjxMH0gbtbLDSypjrZehTouWDCdvMYbgFd86CljMSSh9i6Q1UFWQqqJrrOwaqEJCV
         Lyh/dDJydcn8j7DG2uWlsXh0vdVlgYqfCg5RZqp3AHPDJpauRnzEEsqJzJN9PBrpob
         xJg5hRqeBgpsE/qYO7nNoExrVHGQE2toPy8y3QuQpWipBT2qFZSe04DMd7EIuontoc
         boPPzk61cvbQ5oow8myBu10E9Y3i7O5X2dOV5ZZ0cRsJ89gscvaUsyU8zorzbYFTpD
         Rt4Uk48u2ODhw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ozmP3F6xCWAh; Tue, 17 Nov 2020 18:08:19 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 2E3B72E5799;
        Tue, 17 Nov 2020 18:08:19 -0500 (EST)
Date:   Tue, 17 Nov 2020 18:08:19 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Message-ID: <1227896553.48834.1605654499161.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201117171637.6aeeadd7@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201117155851.0c915705@gandalf.local.home> <334460618.48609.1605648143566.JavaMail.zimbra@efficios.com> <20201117171637.6aeeadd7@gandalf.local.home>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory allocation
Thread-Index: e264swzJEzoMluVuUjdvZClcaHj7hg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 17, 2020, at 5:16 PM, rostedt rostedt@goodmis.org wrote:

> On Tue, 17 Nov 2020 16:22:23 -0500 (EST)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> If we don't call the stub, then there is no point in having the stub at
>> all, and we should just compare to a constant value, e.g. 0x1UL. As far
>> as I can recall, comparing with a small immediate constant is more efficient
>> than comparing with a loaded value on many architectures.
> 
> Why 0x1UL, and not just set it to NULL.
> 
>		do {							\
>			it_func = (it_func_ptr)->func;			\
>			__data = (it_func_ptr)->data;			\
>			if (likely(it_func))				\
>				((void(*)(void *, proto))(it_func))(__data, args); \
>		} while ((++it_func_ptr)->func);

Because of this end-of-loop condition ^
which is also testing for a NULL func. So if we reach a stub, we end up stopping
iteration and not firing the following tracepoint probes.

Thanks,

Mathieu

> 
> 
> -- Steve

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
