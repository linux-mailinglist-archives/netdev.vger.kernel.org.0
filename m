Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260D034720C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhCXHH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbhCXHH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:07:29 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F2C061763;
        Wed, 24 Mar 2021 00:07:28 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo557930wmq.4;
        Wed, 24 Mar 2021 00:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LknztGgqkN///91+7Wug8dejmfXPPMToN8QWuG2wkMU=;
        b=dgAtPKFUuWUjQ37dOc0OLRQ0W9XnjH6AH5XU+e3dkmMhR8GOQCP+fNdliZAZiSlf9Q
         6VULApcmccdCtUVHvey5bDGWLcozs2T2kLB5K0suVa6Rxk4KCMfdgQhtzsnLIyGAbzXy
         ccZ6FAg6rHsVUfTlG6/E7kTWzbnR+IQffaThyQH3U4k0Q8Wqkl1v31MMmFamw+HJ0Msy
         XA+77Z/l7ctIY7ZCK7Kz6xqZx2IvGq56aBKu8A4QXEYVwMI6bOszq4b0WLhFRhMV5HoI
         wt9+wjNbDoP6KBFVlhn/rAKoD5WQlQ3hfdVoGXHgpFlrNr2W6xiwR/5qEXCN7LxAv9DM
         dsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LknztGgqkN///91+7Wug8dejmfXPPMToN8QWuG2wkMU=;
        b=ID3sI41Dk3JOkqzcR8RrlZTXcY65EzknE/4vFePnhbgbirVmeEAbx8PAzFfcnbBBGh
         HYeOz5VSvVMgVygaGg0p23V9wyLSiSVn3lcr/qi+SwzPOp2ActfuNRvS2O6akR/Wajli
         DeIa20/i/zqYNRewJ1y/NWN4s9KSz7ljfbMIXe02y55H48xpv67wqkA1If9WGPYdpF0N
         3n8ezqEr4xKLoTEDIMJA07uNjS/n+xKEP4SoSqJsVkT6tLNwoXMMgKl/VXRAC5eceXR3
         j+H4MdoWugvXg6Z341srE4nPNsRKpuP3SG15xx1Y07ktfOB5MY76k9JajYZ9rEUVsImh
         xJnw==
X-Gm-Message-State: AOAM5319hDQeEjwbhzvWwRglHhwOQ5DBKcaG5vwEwiffsuvRF0zP8hrt
        jHJUa2rXjDBh4YTbZjNVeY3c1JlcEW276uKx+G3ESX7yYeM=
X-Google-Smtp-Source: ABdhPJy0wnrY40S+myN8rvn+oXVBzTkCjecFMbUqih6KehEfQvOmvYIj8UWdYmlrUNybkx14OeUW0Xe9NcHgLb5GPQQ=
X-Received: by 2002:a05:600c:47d7:: with SMTP id l23mr1421587wmo.155.1616569647596;
 Wed, 24 Mar 2021 00:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210323123245.346491-1-colin.king@canonical.com>
In-Reply-To: <20210323123245.346491-1-colin.king@canonical.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 24 Mar 2021 12:37:15 +0530
Message-ID: <CA+sq2CekDZgxec43sBOZ4nLJwVE=PdGdHwYogWAPvyCNwZ0Wnw@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-af: Fix memory leak of object buf
To:     Colin King <colin.king@canonical.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 6:07 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the error return path when lfs fails to allocate is not free'ing
> the memory allocated to buf. Fix this by adding the missing kfree.
>
> Addresses-Coverity: ("Resource leak")
> Fixes: f7884097141b ("octeontx2-af: Formatting debugfs entry rsrc_alloc.")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> index 8ec17ee72b5d..9bf8eaabf9ab 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> @@ -253,8 +253,10 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
>                 return -ENOSPC;
>
>         lfs = kzalloc(lf_str_size, GFP_KERNEL);
> -       if (!lfs)
> +       if (!lfs) {
> +               kfree(buf);
>                 return -ENOMEM;
> +       }
>         off +=  scnprintf(&buf[off], buf_size - 1 - off, "%-*s", lf_str_size,
>                           "pcifunc");
>         for (index = 0; index < BLK_COUNT; index++)
> --
> 2.30.2
>

Thanks for the fix,
Acked-by: Sunil Goutham <sgoutham@marvell.com>
