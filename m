Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF0D459138
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbhKVP0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbhKVP0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:26:23 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC34C061714;
        Mon, 22 Nov 2021 07:23:17 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso29241988otf.12;
        Mon, 22 Nov 2021 07:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jnJTDOpTKtgCzlerhl3sO+dkRR54JA6Jd1FEJJh0098=;
        b=BQIJZz2iFkM5zS9DSc8NNwnffUemWB1t44MFlAZFEveq2US7RJtX8Jz46CUiM0/S98
         45cGokoQIZ60ybZOsjAs77nq0DUpexoBs+XyUmw15vINHbzY4DonTGQBRyXAYanjhq6T
         XQqiy5EH67US4Ub54AdW9K+LmOrgL2JQPyOheS+RsxR+udQR7oQrX/DHhJWHX+2gT+RI
         DLiWmw0DXIoC4Catp0Tp4w6ih+fuFX4x3sNSSxjK/G0TMa85/4Kw0zSjIhqMml13URmp
         BGrtPZF4N8RRoP/JojRpaHXB7n84G1KtM/xyPsZdq5HAW/ODjAACxDj55gzLrWtICYKm
         rNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jnJTDOpTKtgCzlerhl3sO+dkRR54JA6Jd1FEJJh0098=;
        b=FtJ5TlJQbR7/6vejApv1d0mXEnaabXP1QQPN5AuddefW5r+kGIYShdzUzq0uT3j2yD
         eppnWrf0FyUnnOsfVEO3TyAkxflpZOBgleHmKMgAZ0H8D1ogtQyQoSCjgeHCwTrSaS48
         XRUrL/ZjlTm5a3q04YehptF2yv3RyN3SrW9J486J87Mx5ixCFWLsFiPtM0tW87st1rqO
         llr36HT3iuhAzyfzGgnzJ6d/4pwXTYQxmdMZgwE/G3JjgI4l2VDOu0o7HwrPD5VPvITS
         ltGJQkO9OrGmtMaThVAtBRN+UNpdjibSFIN7kJPnKXFalhv7mKO06i7HjLYxM7Na9q8F
         WEfw==
X-Gm-Message-State: AOAM533Bryn28DpK5aLo3VLRNScePkpmkSP6y2EXqERyqMiiRnjQbvJJ
        2llm6wQ/k2tLVv03oqMIC6K4gpfdtnA4YrLeK7I=
X-Google-Smtp-Source: ABdhPJwEs8Zwxw2wcFFmlhfwx1qL0qBF14Q8nWhm/KH6WlNpgKUNibY7fKEqa5S0ngjFbydQCHNlSIOQQCqUkCwS1y0=
X-Received: by 2002:a05:6830:2b25:: with SMTP id l37mr24895367otv.298.1637594596639;
 Mon, 22 Nov 2021 07:23:16 -0800 (PST)
MIME-Version: 1.0
References: <498b1a0a7a0cba019c9d95693cd489827168b79e.1637517554.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <498b1a0a7a0cba019c9d95693cd489827168b79e.1637517554.git.christophe.jaillet@wanadoo.fr>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 22 Nov 2021 10:23:05 -0500
Message-ID: <CADvbK_du8Oya986Ae9YJ+w5kkexE5S5mvAb+DWod-1_F85=sgA@mail.gmail.com>
Subject: Re: [PATCH] net-sysfs: Slightly optimize 'xps_queue_show()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        atenart@kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 2:38 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> The 'mask' bitmap is local to this function. So the non-atomic
> '__set_bit()' can be used to save a few cycles.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/core/net-sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 9c01c642cf9e..3be3f4a6add3 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1452,7 +1452,7 @@ static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
>
>                 for (i = map->len; i--;) {
>                         if (map->queues[i] == index) {
> -                               set_bit(j, mask);
> +                               __set_bit(j, mask);
>                                 break;
>                         }
>                 }
> --
> 2.30.2
>
The similar optimization can seem to be done in br_vlan.c and br_if.c as well.
