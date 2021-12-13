Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AAA473240
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238566AbhLMQwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:52:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46334 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhLMQwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:52:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC2F61184;
        Mon, 13 Dec 2021 16:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1929C34603;
        Mon, 13 Dec 2021 16:52:07 +0000 (UTC)
Date:   Mon, 13 Dec 2021 11:52:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Xiaoke Wang <xkernel.wang@foxmail.com>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] tracing: check the return value of kstrdup()
Message-ID: <20211213115206.5a7b9f0c@gandalf.local.home>
In-Reply-To: <tencent_B595FC0780AC301FE5EE719C50FC8553280A@qq.com>
References: <tencent_B595FC0780AC301FE5EE719C50FC8553280A@qq.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 15:59:04 +0800
Xiaoke Wang <xkernel.wang@foxmail.com> wrote:

> Note: Compare with the last email, this one is using my full name.
> And I am sorry that yesterday I did not notice the bugs in trace_boot.c had been
> already patched.
> kstrdup() returns NULL when some internal memory errors happen, it is
> better to check the return value of it.

Can you please resend this as a normal patch, and not a reply to this email
thread.

Thank you,

-- Steve


> 
> Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
> ---
>  kernel/trace/trace_uprobe.c | 5 +++++
>  1 files changed, 5 insertions(+)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 225ce56..173ff0f 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -1618,6 +1618,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
>  	tu->path = path;
>  	tu->ref_ctr_offset = ref_ctr_offset;
>  	tu->filename = kstrdup(name, GFP_KERNEL);
> +	if (!tu->filename) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
>  	init_trace_event_call(tu);
>  
>  	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;

