Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D925E22FE46
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgG1ABh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG1ABh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 20:01:37 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90FD020729;
        Tue, 28 Jul 2020 00:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595894496;
        bh=5Hcb80XAAu69G78tPEHAD6OQzHkzsXfULdMeDtfyX+g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fWpdcb4tLEV5db3gqa4qSwYnSgBQMzVJ8QXp/ZclV2NxqOOmH5akcKAF38HYJsEut
         z9DlgSbDc50m/eSgbkgyYyOGbxbnQRiAZVhgyv+5JkkIoeeo3MCc5eQPrmEmTl/TiR
         UuMENUXM2H756XTtDnZFIGQVgS4t8p1mGnzfOi8c=
Received: by mail-lf1-f50.google.com with SMTP id y18so9965347lfh.11;
        Mon, 27 Jul 2020 17:01:36 -0700 (PDT)
X-Gm-Message-State: AOAM530eYnCBWaxMihx1Pgac9qNlQfa1+WJotsq7co6KFQYow89rsNQB
        jPDX7H2vy9DrvY4h9h1OXr00X+c14AC+OTBnMXo=
X-Google-Smtp-Source: ABdhPJxEgJQZzV6k1Zb+GKKi6Q7W+dfHBy8e3/bhRjtvslS1qGKhYT5OAk/r1IndCqgqkmJ+NFqW726NdKnW6YKTJu0=
X-Received: by 2002:a19:ec12:: with SMTP id b18mr12947411lfa.52.1595894494954;
 Mon, 27 Jul 2020 17:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-13-guro@fb.com>
In-Reply-To: <20200727184506.2279656-13-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 17:01:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Bk3Xbu2bcb0aJw_McMWXnUL90jj1qQK1a_e126GpESA@mail.gmail.com>
Message-ID: <CAPhsuW7Bk3Xbu2bcb0aJw_McMWXnUL90jj1qQK1a_e126GpESA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 12/35] bpf: refine memcg-based memory
 accounting for xskmap maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:25 PM Roman Gushchin <guro@fb.com> wrote:
>
> Extend xskmap memory accounting to include the memory taken by
> the xsk_map_node structure.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/xdp/xskmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 8367adbbe9df..e574b22defe5 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -28,7 +28,8 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
>         struct xsk_map_node *node;
>         int err;
>
> -       node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
> +       node = kzalloc(sizeof(*node),
> +                      GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
>         if (!node)
>                 return ERR_PTR(-ENOMEM);
>
> --
> 2.26.2
>
