Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A085437BA48
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhELKZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhELKZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:25:49 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2A3C061574;
        Wed, 12 May 2021 03:24:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z130so538177wmg.2;
        Wed, 12 May 2021 03:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2C2FoO6CrkTJpcGiem/5LfYRMsdprpFU1pFNFre5PRM=;
        b=UZt1xRZmGhJF5Q0uJVIwFG7zBYENuHPzd2yyk7MoecrDBUTaz+qH6YbdtdxOHjNZA4
         WHEszknrv/D0p4ucYQb4SENgApeYpo2RJEidLP6phMKnPR1H1MFHQ5Zvhm5axSeXhAKw
         ZUCfAnrxru2NQ2c4o93OX0+cQd35q7ttFl4xWg11or2L/DbNgyilaKrVORfA/u0Gs9Ng
         +xxJ9FSBLmRU3NrAgMFIuOzp0W3J0cbO5roy3n8aa5IP3KzxbxYHnM4htryEKxUGM1/2
         WgLBronUHl1H/yjxk43q9KSgmJDqwco8hxRZoAT+UYP+n1nF+2JkKOjuiSCAIbt4zD+5
         lB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2C2FoO6CrkTJpcGiem/5LfYRMsdprpFU1pFNFre5PRM=;
        b=a7gXgTOwuyEQNELPei0nPCkIx1JpHiYhuM1SfTcsAEBGebj8DNwnobTEtypoRrC8+A
         FT4TB5U/vEfIPfzBDH0L2w3QyKbDw7XxtoIFuIC1BSgIxlzyRZ0SnuKRIds2s/LnLzGM
         fRu6UtAXlWCFWCFvjv/u/5aNJn0e59dAGKCs3+kZAYlKdEhn7YHav7goi1C9fybf4LCy
         3sldDJVZU68/dbEWuivqBz3ZEEH/2/ebwtGAv1540nrXYWAYiVV3ef4oS8AumwPba7Y6
         FmcoyUxBtn6EGeQ5rRYRw9jAAtdpdhFf2rf0hug11rU54wbkm92ESYiNpywhj0IKpI1x
         8P0A==
X-Gm-Message-State: AOAM530FhCsbJ/xp0ekIrwRM/bqS0xYIm5O2bD0jw0sqmzKEtxuO1jCH
        dSvdR8z26ruAywPsIo98TougV8HGEPC4lbYAX64=
X-Google-Smtp-Source: ABdhPJwKtvHD6waVQCEBi+xcuxQD0bG0NpXRy5dEl4DqO0SBz7bIBuK10YObBGgXav/mX4UGb12zYjAr1ncXww7lj9w=
X-Received: by 2002:a7b:c312:: with SMTP id k18mr38162819wmj.89.1620815079575;
 Wed, 12 May 2021 03:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <YJup3/Ih2vIOXK2R@mwanda>
In-Reply-To: <YJup3/Ih2vIOXK2R@mwanda>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 12 May 2021 15:54:28 +0530
Message-ID: <CA+sq2Ce0yA1Deh=q_Ne0qNGebwmGOfnMmV75_foKxbXnPnXOwA@mail.gmail.com>
Subject: Re: [PATCH net] octeontx2-pf: fix a buffer overflow in otx2_set_rxfh_context()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 3:42 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> This function is called from ethtool_set_rxfh() and "*rss_context"
> comes from the user.  Add some bounds checking to prevent memory
> corruption.
>
> Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index f4962a97a075..9d9a2e438acf 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -786,6 +786,10 @@ static int otx2_set_rxfh_context(struct net_device *dev, const u32 *indir,
>         if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
>                 return -EOPNOTSUPP;
>
> +       if (*rss_context != ETH_RXFH_CONTEXT_ALLOC &&
> +           *rss_context >= MAX_RSS_GROUPS)
> +               return -EINVAL;
> +
>         rss = &pfvf->hw.rss_info;
>
>         if (!rss->enable) {
> --
> 2.30.2
>

Acked-by: Sunil Goutham <sgoutham@marvell.com>
