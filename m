Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA76438940
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 15:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJXNyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhJXNye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 09:54:34 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E4C061767
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 06:52:13 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id o42so3868241vkf.9
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 06:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=id1p4qGVhAju1dNKS9ewXd/BAGNoNoVxYAeg/MMzZkk=;
        b=S7J2ND/kmDgFgy4AH1WOhj0CUNoHlN2y+ArUyM1B26rKOQ8Ax8jXgz8ou6NJqRrH5X
         VQcJJIZ1OJBzSD7cW03ffYhT5wnSiG02IY8lj3QReK9OmkiIgUcVqfnRMlAwAGw5V7xy
         Sfp0M9wvNWJnH6aO1HhKwXg8uIpani44NbMRtNLbxZBf95TyIpc9Kd1dcYUWJ37R+/jQ
         7Pm3jQc8CodMCVtUMzgbHxXuEqZh3sgOAlDJNgoSvK/D+wRx4yM1viMwDxHPj6+Jtk8S
         jEyOe6gFlDpwZ9HrUsiaW2etn7WeNTRQwET3c5kzxi7uaAhWGwYTVIGtFwur6YjO25/6
         0K7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=id1p4qGVhAju1dNKS9ewXd/BAGNoNoVxYAeg/MMzZkk=;
        b=q6Q91SLYDjD2QM8iUu9vIjwczKi7Uq6pULAESKzF5ke6Y6CRzJQ7S13/zxsvXsUxFf
         xa6e8oUEfVMR267CmkfJRDJ2WcnZl1mFgA64F2Mk+EDAIIC4VcXwEFcsw95KVy1er42X
         JceFSZbiR6UM8p08WUKL3s6Jk7eyM287KzCknya4b3QZCTV69+RCH3/w0JrlkEHIPFzO
         7TnayB5DjYPjprKV75mIMWnvJng3cwN7aMSzC+BOOpkzyIrqtwk+NZni3VpuYpooJPYc
         hmaqC1I7NLamhuRGBJWInwNMKvb++NmNb3rVjh6/fUOBuh7p6okGhkyBiaV0BTcYKNoE
         2SKA==
X-Gm-Message-State: AOAM531AbJd83E848AGHB/Rg8FBmSkEcSKWa410eYCLLetdtcMBWqbUH
        2NEnHmbsgotkURE728o8SfkOdUIkUs4=
X-Google-Smtp-Source: ABdhPJwNv6Jt8fL1uiZ8TMGnOeW9yBozvrb9D3N9lN9CTSIumMUWM9qTgiaY6xePr8+B5ktifJFQiA==
X-Received: by 2002:a05:6122:168d:: with SMTP id 13mr10688840vkl.2.1635083532737;
        Sun, 24 Oct 2021 06:52:12 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id m14sm230465vkf.41.2021.10.24.06.52.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Oct 2021 06:52:12 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id e5so9797271uam.11
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 06:52:12 -0700 (PDT)
X-Received: by 2002:a67:e0d1:: with SMTP id m17mr10843041vsl.22.1635083531874;
 Sun, 24 Oct 2021 06:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <fb712f802228ab4319891983164bf45e90d529e7.1635076200.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <fb712f802228ab4319891983164bf45e90d529e7.1635076200.git.christophe.jaillet@wanadoo.fr>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 24 Oct 2021 09:51:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTSftgpOGxAxRE5u9o6gT_exaLtC2JkBz=iq21qe+tTTomA@mail.gmail.com>
Message-ID: <CA+FuTSftgpOGxAxRE5u9o6gT_exaLtC2JkBz=iq21qe+tTTomA@mail.gmail.com>
Subject: Re: [PATCH] gve: Fix a possible invalid memory access
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        davem@davemloft.net, kuba@kernel.org, bcf@google.com,
        gustavoars@kernel.org, edumazet@google.com, jfraker@google.com,
        yangchun@google.com, xliutaox@google.com, sagis@google.com,
        lrizzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 7:52 AM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> It is spurious to allocate a bitmap for 'num_qpls' bits and record the
> size of this bitmap with another value.
>
> 'qpl_map_size' is used in 'drivers/net/ethernet/google/gve/gve.h' with
> 'find_[first|next]_zero_bit()'.
> So, it looks that memory after the allocated 'qpl_id_map' could be
> scanned.

find_first_zero_bit takes a length argument in bits:

    /**
     * find_first_zero_bit - find the first cleared bit in a memory region
     * @addr: The address to start the search at
     * @size: The maximum number of bits to search

qpl_map_size is passed to find_first_zero_bit.

It does seem roundabout to compute first the number of longs needed to
hold num_qpl bits

    BITS_TO_LONGS(num_qpls)

then again compute the number of bits in this buffer

    * sizeof(unsigned long) * BITS_PER_BYTE

Which will simply be num_qpls again.

But, removing BITS_PER_BYTE does not arrive at the right number.


>
> Remove the '* BITS_PER_BYTE' to have allocation and length be the same.
>
> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is completely speculative and un-tested!
> You'll be warned.
> ---
>  drivers/net/ethernet/google/gve/gve_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 7647cd05b1d2..19fe9e9b62f5 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -866,7 +866,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
>         }
>
>         priv->qpl_cfg.qpl_map_size = BITS_TO_LONGS(num_qpls) *
> -                                    sizeof(unsigned long) * BITS_PER_BYTE;
> +                                    sizeof(unsigned long);
>         priv->qpl_cfg.qpl_id_map = kvcalloc(BITS_TO_LONGS(num_qpls),
>                                             sizeof(unsigned long), GFP_KERNEL);
>         if (!priv->qpl_cfg.qpl_id_map) {
> --
> 2.30.2
>
