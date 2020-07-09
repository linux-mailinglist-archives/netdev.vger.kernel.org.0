Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FF12196CD
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 05:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGIDpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 23:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGIDpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 23:45:05 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A56C061A0B;
        Wed,  8 Jul 2020 20:45:05 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id h17so395469qvr.0;
        Wed, 08 Jul 2020 20:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B4pXDEaiwBUsL8ydILkn1qTObfdMqkZpkg0ZS0TVFHY=;
        b=K1oZkb5FahNf/sRjuOcIUVdMmHfdUIroU35NlWVEz+cFlmoWLuiQaDvQ2gdyEwQ5Sf
         A30ApSPPLNyZqZuCAZROPFH8Z2kOI0TxE97Lf/W4U/d5J08VtmEh8iMtsUShWhEX96Bd
         buT8Xzc87I7mnuTB/fAD8NxGC2FcNSo/+ogCIr8dwwnYdIwnqjgys6FFA7DQJUytVPiU
         KdaACIsCB7pVNC4Uu4KYTE19tgi4XX7gW4YkrLQilxERXlnRjdplnkGj9ZhWhSltPCx1
         z21QOoUNSHwlhtQKg78RjNTGz6DixCrBSGYS5G37Ww3chwgJ7xcNS2Y7wSGBpZektOPo
         1+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B4pXDEaiwBUsL8ydILkn1qTObfdMqkZpkg0ZS0TVFHY=;
        b=RUyBmqYJeXU/pDJPtP+Q7z90GXpu+KOzffVgMCLoIgNdLX/yapvHXwFPeoM2Mbj8Iu
         OE+0pFPyFOsopOvKVzQGlq+9uWz62URA/SVOOCfwPIbeGkoRid6hP8TvIJwj9pJ8rE80
         UvEh/I4GBY3LgiJvK9NiHw8MbnvYTsvKDiGXFOoHTDSjV/gELBFFFaQ1ZIjYEll7HJKP
         pTF9FCRe7a+zL0BRe5vfUEefRNWGGWH+lDbaMr4tja/1JNACrqBPvnWssOvq0Yu4koik
         GYrXnQPMiREyklCVD++lKuxFvn54NgQ/Vo3NAmLmqVxGp0gZ3kZ/zMr7RHVb5DY6Yzlz
         oP/Q==
X-Gm-Message-State: AOAM532iQbWpkRlu9SBHSfskqLpI1OcldOZ2S1HkST4FhDdkCsFF+6v3
        Y6MpQltmwvaT6/nXS5RoG7HGpYfVyj9CMyEJvVA=
X-Google-Smtp-Source: ABdhPJxHOKslyj/PApFzsLNlXrbEcMqp863bGRFoEMpeLZ19zx0vseWbI3zfNkc0yCRjsQVyw66/PIFDtDxs/5Py0Z0=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr58907008qvf.247.1594266304173;
 Wed, 08 Jul 2020 20:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-2-jakub@cloudflare.com>
In-Reply-To: <20200702092416.11961-2-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 20:44:52 -0700
Message-ID: <CAEf4Bzby9pxaaadTAfuvBER1UnaksS3ajpE6SB79L+g3j_YdAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 01/16] bpf, netns: Handle multiple link attachments
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 2:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Extend the BPF netns link callbacks to rebuild (grow/shrink) or update the
> prog_array at given position when link gets attached/updated/released.
>
> This let's us lift the limit of having just one link attached for the new
> attach type introduced by subsequent patch.
>
> No functional changes intended.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>
> Notes:
>     v3:
>     - New in v3 to support multi-prog attachments. (Alexei)
>
>  include/linux/bpf.h        |  4 ++
>  kernel/bpf/core.c          | 22 ++++++++++
>  kernel/bpf/net_namespace.c | 88 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 107 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 3d2ade703a35..26bc70533db0 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -928,6 +928,10 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
>
>  void bpf_prog_array_delete_safe(struct bpf_prog_array *progs,
>                                 struct bpf_prog *old_prog);
> +void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
> +                                  unsigned int index);
> +void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
> +                             struct bpf_prog *prog);
>  int bpf_prog_array_copy_info(struct bpf_prog_array *array,
>                              u32 *prog_ids, u32 request_cnt,
>                              u32 *prog_cnt);
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 9df4cc9a2907..d4b3b9ee6bf1 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1958,6 +1958,28 @@ void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
>                 }
>  }
>
> +void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
> +                                  unsigned int index)
> +{
> +       bpf_prog_array_update_at(array, index, &dummy_bpf_prog.prog);
> +}
> +
> +void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
> +                             struct bpf_prog *prog)

it's a good idea to mention it in a comment for both delete_safe_at
and update_at that slots with dummy entries are ignored.

Also, given that index can be out of bounds, should these functions
actually return error if the slot is not found?

> +{
> +       struct bpf_prog_array_item *item;
> +
> +       for (item = array->items; item->prog; item++) {
> +               if (item->prog == &dummy_bpf_prog.prog)
> +                       continue;
> +               if (!index) {
> +                       WRITE_ONCE(item->prog, prog);
> +                       break;
> +               }
> +               index--;
> +       }
> +}
> +
>  int bpf_prog_array_copy(struct bpf_prog_array *old_array,
>                         struct bpf_prog *exclude_prog,
>                         struct bpf_prog *include_prog,
> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> index 247543380fa6..6011122c35b6 100644
> --- a/kernel/bpf/net_namespace.c
> +++ b/kernel/bpf/net_namespace.c
> @@ -36,11 +36,51 @@ static void netns_bpf_run_array_detach(struct net *net,
>         bpf_prog_array_free(run_array);
>  }
>
> +static unsigned int link_index(struct net *net,
> +                              enum netns_bpf_attach_type type,
> +                              struct bpf_netns_link *link)
> +{
> +       struct bpf_netns_link *pos;
> +       unsigned int i = 0;
> +
> +       list_for_each_entry(pos, &net->bpf.links[type], node) {
> +               if (pos == link)
> +                       return i;
> +               i++;
> +       }
> +       return UINT_MAX;

Why not return a negative error, if the slot is not found? Feels a bit
unusual as far as error reporting goes.

> +}
> +

[...]
