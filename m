Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECD530E194
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhBCR6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:58:13 -0500
Received: from mail.efficios.com ([167.114.26.124]:57748 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbhBCR6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:58:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EAD922E1B81;
        Wed,  3 Feb 2021 12:57:25 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Laf33Bz6ph5V; Wed,  3 Feb 2021 12:57:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 3A8F32E1B08;
        Wed,  3 Feb 2021 12:57:25 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 3A8F32E1B08
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1612375045;
        bh=+Qap7N2Y/QmVqgqw+bVa1bnoy5TmfjVjhj7na064KEk=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=dOFQGDDKyyE2kjOazY1VDl/JsFGLVRbVBZVoCesYWWf2WNd8aqI3/z32qGsvFO/dK
         YYIJTVzftkNRZMfQ6Jzaj9Woc9pr7HBCt3n4x7PO1+bQmuhile/fCdlUE0JqRMQAoB
         vF50DRX+wvWaIrU2/mTrdEnFZOU+GlVyADVPW6CacmpKvL76gDh78fbq6OF7tr7QEq
         HHTTeNOCatEYjuVJO2m2PHGzyYW6BWDfOeJmn2UuujkISHCzouk79FPheykY5Liv5P
         E783dsRkSk7uhKiluz2e77C7lhpi4ZqFATE0SSJ+PZTf29SjyUDTVnVyLmQeuG5IQ2
         8KVPBt6BNyDOQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JOJTxMAyXdTv; Wed,  3 Feb 2021 12:57:25 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 0FFD42E1959;
        Wed,  3 Feb 2021 12:57:25 -0500 (EST)
Date:   Wed, 3 Feb 2021 12:57:24 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
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
        Florian Weimer <fw@deneb.enyo.de>,
        syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com,
        syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com,
        Matt Mullins <mmullins@mmlx.us>
Message-ID: <1836191179.6214.1612375044968.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210203160550.710877069@goodmis.org>
References: <20210203160517.982448432@goodmis.org> <20210203160550.710877069@goodmis.org>
Subject: Re: [for-next][PATCH 14/15] tracepoint: Do not fail unregistering a
 probe due to memory failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3996 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3996)
Thread-Topic: tracepoint: Do not fail unregistering a probe due to memory failure
Thread-Index: GtmxsYito0gcoBg/ByOH+HQKBrh4xA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- On Feb 3, 2021, at 11:05 AM, rostedt rostedt@goodmis.org wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> The list of tracepoint callbacks is managed by an array that is protected
> by RCU. To update this array, a new array is allocated, the updates are
> copied over to the new array, and then the list of functions for the
> tracepoint is switched over to the new array. After a completion of an RCU
> grace period, the old array is freed.
> 
> This process happens for both adding a callback as well as removing one.
> But on removing a callback, if the new array fails to be allocated, the
> callback is not removed, and may be used after it is freed by the clients
> of the tracepoint.
> 
> There's really no reason to fail if the allocation for a new array fails
> when removing a function. Instead, the function can simply be replaced by a
> stub function that could be cleaned up on the next modification of the
> array. That is, instead of calling the function registered to the
> tracepoint, it would call a stub function in its place.
> 
> Link: https://lore.kernel.org/r/20201115055256.65625-1-mmullins@mmlx.us
> Link: https://lore.kernel.org/r/20201116175107.02db396d@gandalf.local.home
> Link: https://lore.kernel.org/r/20201117211836.54acaef2@oasis.local.home
> Link: https://lkml.kernel.org/r/20201118093405.7a6d2290@gandalf.local.home
> 
> [ Note, this version does use undefined compiler behavior (assuming that
>  a stub function with no parameters or return, can be called by a location
>  that thinks it has parameters but still no return value. Static calls
>  do the same thing, so this trick is not without precedent.
> 
>  There's another solution that uses RCU tricks and is more complex, but
>  can be an alternative if this solution becomes an issue.
> 
>  Link: https://lore.kernel.org/lkml/20210127170721.58bce7cc@gandalf.local.home/
> ]
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@chromium.org>
> Cc: netdev <netdev@vger.kernel.org>
> Cc: bpf <bpf@vger.kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Florian Weimer <fw@deneb.enyo.de>
> Fixes: 97e1c18e8d17b ("tracing: Kernel Tracepoints")
> Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
> Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
> Reported-by: Matt Mullins <mmullins@mmlx.us>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Tested-by: Matt Mullins <mmullins@mmlx.us>
> ---
> kernel/tracepoint.c | 80 ++++++++++++++++++++++++++++++++++++---------
> 1 file changed, 64 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 7261fa0f5e3c..e8f20ae29c18 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -53,6 +53,12 @@ struct tp_probes {
> 	struct tracepoint_func probes[];
> };
> 
> +/* Called in removal of a func but failed to allocate a new tp_funcs */
> +static void tp_stub_func(void)
> +{
> +	return;
> +}
> +
> static inline void *allocate_probes(int count)
> {
> 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
> @@ -131,6 +137,7 @@ func_add(struct tracepoint_func **funcs, struct
> tracepoint_func *tp_func,
> {
> 	struct tracepoint_func *old, *new;
> 	int nr_probes = 0;
> +	int stub_funcs = 0;
> 	int pos = -1;
> 
> 	if (WARN_ON(!tp_func->func))
> @@ -147,14 +154,34 @@ func_add(struct tracepoint_func **funcs, struct
> tracepoint_func *tp_func,
> 			if (old[nr_probes].func == tp_func->func &&
> 			    old[nr_probes].data == tp_func->data)
> 				return ERR_PTR(-EEXIST);
> +			if (old[nr_probes].func == tp_stub_func)
> +				stub_funcs++;
> 		}
> 	}
> -	/* + 2 : one for new probe, one for NULL func */
> -	new = allocate_probes(nr_probes + 2);
> +	/* + 2 : one for new probe, one for NULL func - stub functions */
> +	new = allocate_probes(nr_probes + 2 - stub_funcs);
> 	if (new == NULL)
> 		return ERR_PTR(-ENOMEM);
> 	if (old) {
> -		if (pos < 0) {
> +		if (stub_funcs) {

Considering that we end up implementing a case where we carefully copy over
each item, I recommend we replace the two "memcpy" branches by a single item-wise
implementation. It's a slow-path anyway, and reducing the overall complexity
is a benefit for slow paths. Fewer bugs, less code to review, and it's easier to
reach a decent testing state-space coverage.

> +			/* Need to copy one at a time to remove stubs */
> +			int probes = 0;
> +
> +			pos = -1;
> +			for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> +				if (old[nr_probes].func == tp_stub_func)
> +					continue;
> +				if (pos < 0 && old[nr_probes].prio < prio)
> +					pos = probes++;
> +				new[probes++] = old[nr_probes];
> +			}
> +			nr_probes = probes;

Repurposing "nr_probes" from accounting for the number of items in the old
array to counting the number of items in the new array in the middle of the
function is confusing.

> +			if (pos < 0)
> +				pos = probes;
> +			else
> +				nr_probes--; /* Account for insertion */

This is probably why you need to play tricks with nr_probes here.

> +		} else if (pos < 0) {
> 			pos = nr_probes;
> 			memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
> 		} else {
> @@ -188,8 +215,9 @@ static void *func_remove(struct tracepoint_func **funcs,
> 	/* (N -> M), (N > 1, M >= 0) probes */
> 	if (tp_func->func) {
> 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> -			if (old[nr_probes].func == tp_func->func &&
> -			     old[nr_probes].data == tp_func->data)
> +			if ((old[nr_probes].func == tp_func->func &&
> +			     old[nr_probes].data == tp_func->data) ||
> +			    old[nr_probes].func == tp_stub_func)
> 				nr_del++;
> 		}
> 	}
> @@ -208,14 +236,32 @@ static void *func_remove(struct tracepoint_func **funcs,
> 		/* N -> M, (N > 1, M > 0) */
> 		/* + 1 for NULL */
> 		new = allocate_probes(nr_probes - nr_del + 1);
> -		if (new == NULL)
> -			return ERR_PTR(-ENOMEM);
> -		for (i = 0; old[i].func; i++)
> -			if (old[i].func != tp_func->func
> -					|| old[i].data != tp_func->data)
> -				new[j++] = old[i];
> -		new[nr_probes - nr_del].func = NULL;
> -		*funcs = new;
> +		if (new) {
> +			for (i = 0; old[i].func; i++)
> +				if ((old[i].func != tp_func->func
> +				     || old[i].data != tp_func->data)
> +				    && old[i].func != tp_stub_func)
> +					new[j++] = old[i];
> +			new[nr_probes - nr_del].func = NULL;
> +			*funcs = new;
> +		} else {
> +			/*
> +			 * Failed to allocate, replace the old function
> +			 * with calls to tp_stub_func.
> +			 */
> +			for (i = 0; old[i].func; i++)
> +				if (old[i].func == tp_func->func &&
> +				    old[i].data == tp_func->data) {
> +					old[i].func = tp_stub_func;

This updates "func" while readers are loading it concurrently. I would recommend
using WRITE_ONCE here paired with READ_ONCE within __traceiter_##_name.

> +					/* Set the prio to the next event. */

I don't get why the priority needs to be changed here. Could it simply stay
at its original value ? It's already in the correct priority order anyway.

> +					if (old[i + 1].func)
> +						old[i].prio =
> +							old[i + 1].prio;
> +					else
> +						old[i].prio = -1;
> +				}
> +			*funcs = old;

I'm not sure what setting *funcs to old achieves ? Isn't it already pointing
to old ?

I'll send a patch which applies on top of yours implementing my recommendations.
It shrinks the code complexity nicely:

 include/linux/tracepoint.h |  2 +-
 kernel/tracepoint.c        | 80 +++++++++++++-------------------------
 2 files changed, 28 insertions(+), 54 deletions(-)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
