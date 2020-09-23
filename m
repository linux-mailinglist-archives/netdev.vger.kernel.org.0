Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49377275CC2
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgIWQFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWQFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:05:50 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54943C0613CE;
        Wed, 23 Sep 2020 09:05:50 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h9so165524ybm.4;
        Wed, 23 Sep 2020 09:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E41XMWZCyk157fAUcngXrYCkdtxC8XoEP2uzIyD60V0=;
        b=KfXzm0cU0SR0OTLaMOeP8vx6n0pF5kOFGKxb9ltYsf9yibrrg3bbiguA5Hzkt5zdrO
         NvLo3bljzH4fMQylbntazlSXJr27F+OEa+TEeDWQF53SH1co0JQyUCpVkdyZxpcflBQm
         DoUoPiEX7CKGlPmhBxzAduxqtg4sfW7nD7jl8cukfwRVo02uwv55AWt++JLlEYHERBep
         yiVLTf+ZoICYP37HjroOGiesoB3gcn2xReIiHNgReYkntS8d0YZk6tTeiS1wiuuzn1su
         XNw/cIa5v20noeN1+PyfsYfrfm6f8avZqKsYsKVs8krqC2UnCeIJTzwdWnLhTvwGFb0w
         u21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E41XMWZCyk157fAUcngXrYCkdtxC8XoEP2uzIyD60V0=;
        b=DXJYtirL5hX7RbpGinXABp2z+RQG3e9SF60ZNfW7Iq+K22COSlFclAG9XFDl3u6JN8
         BXxes+8w57Hmu8IyNUXry5twCp24F0qyigy9NdHsYygV1+CK7J285dsmz5uwZhb338hg
         2DG8n+ZawTiKZZGRYNRvFJGkzeiQ9mkNqzJSCCLd7jc4B5HJFOJUm2P0oz685Yu362h+
         RnDuCuIqi1bsrcwLQ95mnfLjp35ZRSOo/S6xswyY5iymSJpvkyn+qQnBynrVBu/ypf9K
         /PjLTdwqO0MBe94SNfqIVAlGTqV0aO0076NmRk34/0beRsb1uE3wNwLuZ96rqp5HqrkD
         Zyug==
X-Gm-Message-State: AOAM530+vkccn9jfrwukOipAJjXejZlJsztLsOeHux60ZtsaKaOio1zj
        KkqFhPr8usZXLcbVnYqvoRRjjc3eVOjQBsPCdMo=
X-Google-Smtp-Source: ABdhPJwu1pcne+ABMS5bp6qeTMixQEwwVPNS2BbreASfuOzLieRjm9a/GBCC0Zm8O6ljrXiNHWyPEZB6QPk16b4rbCs=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr976613ybz.27.1600877149599;
 Wed, 23 Sep 2020 09:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200923160156.80814-1-lmb@cloudflare.com>
In-Reply-To: <20200923160156.80814-1-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 09:05:38 -0700
Message-ID: <CAEf4BzZJQBdW72TRCuW7q0c3kke1Qan59fDzV0DKN_EOAgXGaw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: explicitly size compatible_reg_types
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:03 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Arrays with designated initializers have an implicit length of the highest
> initialized value plus one. I used this to ensure that newly added entries
> in enum bpf_reg_type get a NULL entry in compatible_reg_types.
>
> This is difficult to understand since it requires knowledge of the
> peculiarities of designated initializers. Use __BPF_ARG_TYPE_MAX to size
> the array instead.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> ---

I like this more as well.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/verifier.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 15ab889b0a3f..d7c993ded26a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4002,7 +4002,7 @@ static const struct bpf_reg_types const_map_ptr_types = { .types = { CONST_PTR_T
>  static const struct bpf_reg_types btf_ptr_types = { .types = { PTR_TO_BTF_ID } };
>  static const struct bpf_reg_types spin_lock_types = { .types = { PTR_TO_MAP_VALUE } };
>
> -static const struct bpf_reg_types *compatible_reg_types[] = {
> +static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
>         [ARG_PTR_TO_MAP_KEY]            = &map_key_value_types,
>         [ARG_PTR_TO_MAP_VALUE]          = &map_key_value_types,
>         [ARG_PTR_TO_UNINIT_MAP_VALUE]   = &map_key_value_types,
> @@ -4025,7 +4025,6 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
>         [ARG_PTR_TO_ALLOC_MEM_OR_NULL]  = &alloc_mem_types,
>         [ARG_PTR_TO_INT]                = &int_ptr_types,
>         [ARG_PTR_TO_LONG]               = &int_ptr_types,
> -       [__BPF_ARG_TYPE_MAX]            = NULL,
>  };
>
>  static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> --
> 2.25.1
>
