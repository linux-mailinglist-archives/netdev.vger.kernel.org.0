Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF3251F67
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHYTAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 15:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYTAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:00:31 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CD4C061755
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 12:00:31 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v9so15083892ljk.6
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 12:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIZWu3166pXihdAEpw+Mp3W7uVSGrl+5DTpGsRd8suw=;
        b=lsWgElMBWLnmMhFudG5zPSTYJbQ/5EhklPtOF3MT+YYIJ2ltRqVueDGqSVXyuEp5l0
         4Fr/+4qaRi9d8qFy0aSaQoWL83iGLpaCbztACHZkNIVZGr5XeP2X9SE/mPsM0Pyw3Obj
         /AI28oA7vpsLnZgCp0GuSFsun9X2dMJUOx12jC7SC5ZdEEjmfOETQ92Dq1wKeLyTsEgG
         qV83/bSX0KsK1hrT8JRpybLwa32pPGaOpbVPwpSJldw0FmZ9r4pArY81G37TFDNnl4Wx
         klELNKwfXEIqzc18TPNPXeYsHjPN5IsvTwy6e5oLO3Na/4RvLcEAyrFoE2MZWrIEuLYr
         J70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIZWu3166pXihdAEpw+Mp3W7uVSGrl+5DTpGsRd8suw=;
        b=o9LsNRgN81q35p2QaVGd4vSJp11Ch/zf6g07GISDYyVUHZ483f+bBmyWamha/H7fHr
         9juAzvWr7AYqRRmTNqoVu2eAcii23RfwLGwK9g4b4V01DbSD8n7luB4ux2sBbAYy7hyV
         CI9smse7IB0ikPW2uRXJIVUyQyBoTap6S37eyJgvE5WyThCAJMpHizQq9PW3YRdMS5km
         ZOqE6J8QQ8LCoA0cMzV3Q+FNIPNviqTeuu9aqPWs1AakDVXCKppsfVU8s+m3azcLW9uP
         M1xGyeW5g2M5Ez+KI+lrHO7yExLXCfGWXPFUtXOhbvPVZj5NW8/FWhZEThQKnovkCj2x
         IQsg==
X-Gm-Message-State: AOAM533UFNh4eMxYAWbQk45BFXIFZB6TE0GHiW0WDY3aNttpdxIUFe1N
        GRs6+3IWyjLQhkG4kuoHzVtOg6n+FH3qwzbNIxA3Jg==
X-Google-Smtp-Source: ABdhPJzy0DbyVXrksmXBq429f3AEhs6iVcJCCucbg6NfOX6mgM9neMfFrPgpmXYuf2xLf50xjDWsZXuqT+BnUXud0Cg=
X-Received: by 2002:a05:651c:330:: with SMTP id b16mr5536957ljp.77.1598382026379;
 Tue, 25 Aug 2020 12:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200821150134.2581465-1-guro@fb.com> <20200821150134.2581465-3-guro@fb.com>
In-Reply-To: <20200821150134.2581465-3-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 25 Aug 2020 12:00:15 -0700
Message-ID: <CALvZod625bjHHpDUVYXCZ1hCqyVy133g5cSv2+bhTK_9YfR6KA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 02/30] bpf: memcg-based memory accounting for
 bpf progs
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 8:01 AM Roman Gushchin <guro@fb.com> wrote:
>
> Include memory used by bpf programs into the memcg-based accounting.
> This includes the memory used by programs itself, auxiliary data
> and statistics.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---
>  kernel/bpf/core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index ed0b3578867c..021fff2df81b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -77,7 +77,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
>
>  struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog_aux *aux;
>         struct bpf_prog *fp;
>
> @@ -86,7 +86,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
>         if (fp == NULL)
>                 return NULL;
>
> -       aux = kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
> +       aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
>         if (aux == NULL) {
>                 vfree(fp);
>                 return NULL;
> @@ -104,7 +104,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
>
>  struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog *prog;
>         int cpu;
>
> @@ -217,7 +217,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog)
>  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>                                   gfp_t gfp_extra_flags)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
>         struct bpf_prog *fp;
>         u32 pages, delta;
>         int ret;
> --
> 2.26.2
>

What about prog->aux->jited_linfo in bpf_prog_alloc_jited_linfo()?
