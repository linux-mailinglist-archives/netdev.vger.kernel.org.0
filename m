Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308F815C9B5
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBMRrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:47:40 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44361 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgBMRrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:47:39 -0500
Received: by mail-qk1-f195.google.com with SMTP id v195so6470465qkb.11;
        Thu, 13 Feb 2020 09:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QqYQBHl3dLMvD5Z6qSR6RJN0d5WnItMFfOyEDAwMXCo=;
        b=Ki5E6dMoRZTUfdResgbYtn48OiDJhJPt96efZpVZTxXU67/iLnRdLnKFw9WEU17QuL
         9ioG/sMDQHwiaAceH9BlAVI9a9EOTUJGm08R9ZowZop97ko6cxgIURBG+An33EitrxTm
         cX3MJZ/GOoSXQCQJq+hi5x4r1J/xLale9rxUVyImfQLWEJ9yHSmoxqXZn4OPHS3THAVW
         eDG05oPrM5tcP08hokvE+qfGHn6Cm3TjOOvUsggVbOpQIJnITD1Z6d+IYstqNRQSmiPr
         N3e1lMd305ayw9ONHgRzU/7w0t3rUSD6VMbwIO22+UuNPaq5DYkb9RJhfZgac6gLkhXg
         kM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QqYQBHl3dLMvD5Z6qSR6RJN0d5WnItMFfOyEDAwMXCo=;
        b=uXFdQ9mCWNxXDR3kvDVc1KFl0tE9oQ4RCeBpgWsMAEaGRROGPFGxs7Cuxci7S5J80g
         8Z1fi4Nljjm7ZIixUvRBhUTn7A3HaLKvZiD1bSQnG95yoGXDc+Jv1m3QEZSYmIVUhHKa
         rEl5U9+Xms75hd6Mt6wAcPD20L8wq/D7vutF8ZRUSbwCfbAe3lLEkunvDpx5Sv/D9Mse
         O2Glh67+EZEa7K5XLPoX/caYrUsFcEYIsS/eB4p3OSjv4kabnf8BrFNI6SmQn+/J/Fa+
         BswSd+Tn3zNjQsODhkCg22s8FQ0Oi5vdEL15rEeuYzNSvfi4+yxp1GVMSNOwCcAlZnPI
         pZZQ==
X-Gm-Message-State: APjAAAWOav5BP/FCr6lY5FCHh4At30jMOEwFF1Qi1J7aPtuCSYvMAgB8
        UVRGbMI5J7L2pKys7gISBWZUHoGw0pSpt7X+wE0=
X-Google-Smtp-Source: APXvYqyfayhltEAhkoqdbYnchFW7sXFhdJb0s2Oi1gjy6iPWMTHeIVsV9b6s9/hHeFf05GQusuipitPcvO+Zhv/+n8M=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr16976934qkj.36.1581616057237;
 Thu, 13 Feb 2020 09:47:37 -0800 (PST)
MIME-Version: 1.0
References: <20200213152416.GA1873@embeddedor>
In-Reply-To: <20200213152416.GA1873@embeddedor>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Feb 2020 09:47:25 -0800
Message-ID: <CAEf4Bzae=Afp_4FGgeFy+=kk64nm1vhRso2zF3j7Qdst66RFZw@mail.gmail.com>
Subject: Re: [PATCH] bpf: queue_stack_maps: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 7:22 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---

Sure, why not, though I don't think that's the only one (e.g.,
bpf_storage_buffer's data is zero-length as well).

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/queue_stack_maps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
> index f697647ceb54..30e1373fd437 100644
> --- a/kernel/bpf/queue_stack_maps.c
> +++ b/kernel/bpf/queue_stack_maps.c
> @@ -19,7 +19,7 @@ struct bpf_queue_stack {
>         u32 head, tail;
>         u32 size; /* max_entries + 1 */
>
> -       char elements[0] __aligned(8);
> +       char elements[] __aligned(8);
>  };
>
>  static struct bpf_queue_stack *bpf_queue_stack(struct bpf_map *map)
> --
> 2.25.0
>
