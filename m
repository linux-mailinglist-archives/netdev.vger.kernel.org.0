Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF82B70DB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgKQVW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:22:26 -0500
Received: from mail.efficios.com ([167.114.26.124]:45334 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgKQVWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 16:22:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 0C7E22E4533;
        Tue, 17 Nov 2020 16:22:24 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 3HtepbJml7JF; Tue, 17 Nov 2020 16:22:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B5EC62E48B3;
        Tue, 17 Nov 2020 16:22:23 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com B5EC62E48B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605648143;
        bh=PXqhEjZMAdpGDq5EtZwgnWt5f+BNVFmPUhm3+bOyFR0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Tw9cRcgaXPVyHKi40MN9iOSfhO5xKJRdw+VA7ggRRC9kzgjQzUdThFe5+tmMZR9EU
         QcyYpCQsDpuIMZzC9CmYz/lkoE9k6Fn/2gtOpXDZz0B/kBFyxEAFkNha42bOJfw01A
         mmQaUl3/Rfq6C3XLIxU5XvNXXiw32CsqAXnw61rn/5PT9ep/qaMS1jPzACOlG9PUoo
         6Pud/t7/khyWU2zJDC/je8+2OI/9dyiM6SZT1qflMyymL8pXMKfx4SgL31j7tdF5S7
         1DLMGpXwxKkGR/iSMK987WYTXWBp8mvdnBbI+AGGo6vkzwj9iocbO0bILppKDFmS8S
         VQz8sFI0pIicQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id K29gqlNIp7JB; Tue, 17 Nov 2020 16:22:23 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id A31222E48B2;
        Tue, 17 Nov 2020 16:22:23 -0500 (EST)
Date:   Tue, 17 Nov 2020 16:22:23 -0500 (EST)
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
Message-ID: <334460618.48609.1605648143566.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201117155851.0c915705@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home> <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com> <20201117142145.43194f1a@gandalf.local.home> <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com> <20201117153451.3015c5c9@gandalf.local.home> <20201117155851.0c915705@gandalf.local.home>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory allocation
Thread-Index: UdsIJ96gFLhqXRumJL7PS/UT274UmA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 17, 2020, at 3:58 PM, rostedt rostedt@goodmis.org wrote:

> On Tue, 17 Nov 2020 15:34:51 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
[...]

> If it comes down to not trusting calling a stub, I'll still keep the stub
> logic in, and just add the following:

If we don't call the stub, then there is no point in having the stub at
all, and we should just compare to a constant value, e.g. 0x1UL. As far
as I can recall, comparing with a small immediate constant is more efficient
than comparing with a loaded value on many architectures.

Thanks,

Mathieu
 
-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
