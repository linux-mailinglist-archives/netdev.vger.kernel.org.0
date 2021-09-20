Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6572412ACC
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhIUB6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbhIUBvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:51:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F12C07E5F0
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 15:22:56 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u15so33787795wru.6
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 15:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQAwy4pCmDHOI3u6mGzWC09yM6AY5TZbAb+EzcINoJY=;
        b=l1YvkaPVcmsLmCzP/adji66ECXNL6GnStXg3pZnnxLrw8wQQ0k0pT2XGIjRmhhAbJ7
         l3XJYx6IozNpijtPCDgKp19fje2lGqqkciiR9xgjUBfn5K/umXo2o4RWKURs3/PBNN19
         TYviLxZKVDajDpntLIoLPU5R/cTjxpe5j19dNkQSnFl1LYdy3LmdXk6NPdcP00yfJSQB
         idqc7ZYKJZxGHP031t1JwCkx+8Va3+8J1rfXPSs/gn2Oip3WZUE/lRXx0pyZtdDksxPz
         KDKBif9kXhnBbr3eBTDUNkP7fi8GdpqrBKv5Nt7LbeTl5abmaXpAzKvtu5S/fXwqk8GH
         ENIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQAwy4pCmDHOI3u6mGzWC09yM6AY5TZbAb+EzcINoJY=;
        b=Ivdbde+XCC1phF9OzZkze9wke62o/Gm1fiC00elA6TpkXn2Hjf1rf3q6xSWxX6GDci
         FpKjPLeQDgXUjQuyF5T1y7EzksAQmh8rJYb95GuEvlMt1dgNu5LXTupxKNJxE5uh8K0q
         Zld+ZRYRWS28J5YEeD7pX4n8I1v0PTAtMp7Q8tG8rfn7KThgoG29/oQgqXyLuk7J9neg
         0XALvtgOhqIh7yfwwaOumKB7lBj8RecCrmGNPkOcXB3cdQWPyXrUY/RNn1g2SIlLAZss
         mMK2+D6vCZuT/dG/et9/PmH3+Rz7PtY6wf5zbCdWq35rmqpIRt2/OnghMm3zxRBGg9n6
         4JDA==
X-Gm-Message-State: AOAM530QfFK5EbRUNUVko+VGA3eNzYN7jcaGEqhJvylrTnJRSmyLfJC+
        6CgMFNX+KbA57lRyZaN26reE/d+TF9+LAOBSY4/YEt9q+QxdEg==
X-Google-Smtp-Source: ABdhPJy9EIwxCSbxw21oV3HzHr7d5RrPONZ42z/PHJcx8ml/tRKL/7PWTp2+Supfjib5qof+CvxYpNKqurTURUgCka4=
X-Received: by 2002:a05:6512:2294:: with SMTP id f20mr9928095lfu.489.1632176563813;
 Mon, 20 Sep 2021 15:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210920165347.164087-1-trix@redhat.com>
In-Reply-To: <20210920165347.164087-1-trix@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 20 Sep 2021 15:22:31 -0700
Message-ID: <CAKwvOdkSt5VymxtJ4jmOe9LM1rdy+CV7yYXhjCgOFAgbKGEPfQ@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-af: fix uninitialized variable
To:     trix@redhat.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        schalla@marvell.com, vvelumuri@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Colin Ian King <colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 9:54 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> Building with clang 13 reports this error
> rvu_nix.c:4600:7: error: variable 'val' is used uninitialized whenever
>   'if' condition is false
>                 if (!is_rvu_otx2(rvu))
>                     ^~~~~~~~~~~~~~~~~
>
> So initialize val.
>
> Fixes: 4b5a3ab17c6c ("octeontx2-af: Hardware configuration for inline IPsec")
> Signed-off-by: Tom Rix <trix@redhat.com>

Thanks for the patch, but it looks like Colin beat you to the punch.
In linux-next, I see:
commit d853f1d3c900 ("octeontx2-af: Fix uninitialized variable val")

> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index ea3e03fa55d45c..70431db866b328 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -4592,7 +4592,7 @@ static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *r
>                                  int blkaddr)
>  {
>         u8 cpt_idx, cpt_blkaddr;
> -       u64 val;
> +       u64 val = 0;
>
>         cpt_idx = (blkaddr == BLKADDR_NIX0) ? 0 : 1;
>         if (req->enable) {
> --
> 2.26.3
>


-- 
Thanks,
~Nick Desaulniers
