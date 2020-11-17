Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051262B71F3
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKQXFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:05:53 -0500
Received: from mail.efficios.com ([167.114.26.124]:48338 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgKQXFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:05:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 120D32E572F;
        Tue, 17 Nov 2020 18:05:52 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 55Cdjqm2TOjt; Tue, 17 Nov 2020 18:05:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C2F392E572E;
        Tue, 17 Nov 2020 18:05:51 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com C2F392E572E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605654351;
        bh=4EF5Pyi9GurCoXIT1YIBSNpuGGryjRU/WtX91KjzkWk=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=fd6lbXHkF4L3gy4LMwDQMF56a1l97+Al8jnBzfWblTIxc6H5OOueNc3cVcouMvIHo
         HkL5IRyXtcOBEzDDBjns1AgGfABE3jLN47sHjqlsAuvNHXPfNlXLXPTbhn9pytO3ib
         Iib531WdH8viGhWQNPNsd/uvqZx2D+kwAIih8XYP+XbNA1F4dw2JWpnrygzQqhpHI+
         qJPvQT0jY/hnrMxnng1Fh8HxxIHsRKVGyTeX0X8QyBUfmq4HuJvslXqcZSYSjjlx50
         LrgjIlCe+spHwgiPDihC/XqmexXOYRNq7ODRk/ii7KIMTgQ22sQ8eACYsje/zxmpFf
         WcfH+ltNeOaJg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M9rmpwAeEYN0; Tue, 17 Nov 2020 18:05:51 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id B07312E5722;
        Tue, 17 Nov 2020 18:05:51 -0500 (EST)
Date:   Tue, 17 Nov 2020 18:05:51 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     paulmck <paulmck@kernel.org>, Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <609819191.48825.1605654351686.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201116171027.458a6c17@gandalf.local.home>
References: <00000000000004500b05b31e68ce@google.com> <20201115055256.65625-1-mmullins@mmlx.us> <20201116121929.1a7aeb16@gandalf.local.home> <1889971276.46615.1605559047845.JavaMail.zimbra@efficios.com> <20201116154437.254a8b97@gandalf.local.home> <20201116160218.3b705345@gandalf.local.home> <1368007646.46749.1605562481450.JavaMail.zimbra@efficios.com> <20201116171027.458a6c17@gandalf.local.home>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3975 (ZimbraWebClient - FF82 (Linux)/8.8.15_GA_3975)
Thread-Topic: don't fail kmalloc while releasing raw_tp
Thread-Index: rDgx+9686j10JxC+vTlp4lzx8j00fQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Nov 16, 2020, at 5:10 PM, rostedt rostedt@goodmis.org wrote:

> On Mon, 16 Nov 2020 16:34:41 -0500 (EST)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

[...]

>> I think you'll want a WRITE_ONCE(old[i].func, tp_stub_func) here, matched
>> with a READ_ONCE() in __DO_TRACE. This introduces a new situation where the
>> func pointer can be updated and loaded concurrently.
> 
> I thought about this a little, and then only thing we really should worry
> about is synchronizing with those that unregister. Because when we make
> this update, there are now two states. the __DO_TRACE either reads the
> original func or the stub. And either should be OK to call.
> 
> Only the func gets updated and not the data. So what exactly are we worried
> about here?

Indeed with a stub function, I don't see any need for READ_ONCE/WRITE_ONCE.

However, if we want to compare the function pointer to some other value and
conditionally do (or skip) the call, I think you'll need the READ_ONCE/WRITE_ONCE
to make sure the pointer is not re-fetched between comparison and call.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
