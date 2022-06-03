Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF54E53CC46
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbiFCPZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 11:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243507AbiFCPZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 11:25:36 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCCC27152;
        Fri,  3 Jun 2022 08:25:35 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id q21so16630828ejm.1;
        Fri, 03 Jun 2022 08:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BsFKjZipbOTjUWCQRSSMQJgD00JclNvNv7Gv7B+yrU8=;
        b=M4JLXiWxSuRJFYbt5BPJdGkyNoQXlVZnC3Kbj97ggGitikrkpzh3SYa5y4tU4aoy8y
         +G0X6gPXjfMrlM2BLJeDWtAaIbWiox9nqn6xE4ITMhkFAdiVOmesKdEDm5tItpU1qZPF
         A94PqTFPnRY1LsOcxVhpIaUtA1fVBxpTVKXvIH7DWcOKYHF1XoqBi4kNhe4U82ii7faX
         ve/jVsfRKoDfx07xs+68rxEtIxMClWcvNTiwOmDZOnC7ZLIO/WVhoETXrND/b5lIHp43
         MAvTXthtvokzyDQIlVTIQkg8Aqu3dThwN7GNAKtIKjGmBYe4TAXWRA1JgYBx/1kHhCAT
         6t+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BsFKjZipbOTjUWCQRSSMQJgD00JclNvNv7Gv7B+yrU8=;
        b=Rsg1oHiBKtfvh0Axz9AC5alblQfuRfGbwFVIWzZkxPZ6bhztErqVcaMGv1Aq0hnbj1
         z3OLfz+9c/DM+M0R8l/yQouNnP3lo6Fl658+HdwPuBeDH956tw45KwP2aUhgiUWXkbRP
         7Xx2yW3rUFFmBfUK74hG+10xyGKz+Koa8xuMPL23vfUdgJzwyjhKJY7+YR12aF8Rg+4c
         G7lbPAdFsR7pHzlHHrHi//2L9CTH1jy7hj6DlfNi3/3sSXcK3CBcLNACK6FkyrHR0x6C
         7fM7T5+25HMooD5VdYEuOKR+/p92Q8WNLXUQoxLexskoUGu8Vwu0LcG9EpaWGtaV6DSH
         +7BQ==
X-Gm-Message-State: AOAM531yN0po2f0aa3uMWA1cKdcNg3K0+As+li1wCs+Utksa5HM4dsxw
        xr+63vH4pNFcQePYuT+P6iVyipjJY/T7Vex1fM0=
X-Google-Smtp-Source: ABdhPJzrwJnGaL84JtXS4Waw3Cqw/ZmtEJYT/uxuIbpHE62Y9br/lrSJdLekasDZcKyrvWXBktw5BEH6/zFZio9znQM=
X-Received: by 2002:a17:907:62a1:b0:6da:7952:d4d2 with SMTP id
 nd33-20020a17090762a100b006da7952d4d2mr8978189ejc.260.1654269934125; Fri, 03
 Jun 2022 08:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name> <1654245968-8067-1-git-send-email-chen45464546@163.com>
In-Reply-To: <1654245968-8067-1-git-send-email-chen45464546@163.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 3 Jun 2022 08:25:22 -0700
Message-ID: <CAKgT0Uc9vSEJxrev10Uc3P==+tTip7+7W=AF2uE+VB3GVyOTxg@mail.gmail.com>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
To:     Chen Lin <chen45464546@163.com>
Cc:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>, Mark-MC.Lee@mediatek.com,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, matthias.bgg@gmail.com,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 2:03 AM Chen Lin <chen45464546@163.com> wrote:
>
> When rx_flag == MTK_RX_FLAGS_HWLRO,
> rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
> netdev_alloc_frag is for alloction of page fragment only.
> Reference to other drivers and Documentation/vm/page_frags.rst
>
> Branch to use alloc_pages when ring->frag_size > PAGE_SIZE.
>
> Signed-off-by: Chen Lin <chen45464546@163.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index b3b3c07..772d903 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -1467,7 +1467,16 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>                         goto release_desc;
>
>                 /* alloc new buffer */
> -               new_data = napi_alloc_frag(ring->frag_size);
> +               if (ring->frag_size <= PAGE_SIZE) {
> +                       new_data = napi_alloc_frag(ring->frag_size);
> +               } else {
> +                       struct page *page;
> +                       unsigned int order = get_order(ring->frag_size);
> +
> +                       page = alloc_pages(GFP_ATOMIC | __GFP_COMP |
> +                                           __GFP_NOWARN, order);
> +                       new_data = page ? page_address(page) : NULL;
> +               }
>                 if (unlikely(!new_data)) {
>                         netdev->stats.rx_dropped++;
>                         goto release_desc;
> @@ -1914,7 +1923,16 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
>                 return -ENOMEM;
>
>         for (i = 0; i < rx_dma_size; i++) {
> -               ring->data[i] = netdev_alloc_frag(ring->frag_size);
> +               if (ring->frag_size <= PAGE_SIZE) {
> +                       ring->data[i] = netdev_alloc_frag(ring->frag_size);
> +               } else {
> +                       struct page *page;
> +                       unsigned int order = get_order(ring->frag_size);
> +
> +                       page = alloc_pages(GFP_KERNEL | __GFP_COMP |
> +                                           __GFP_NOWARN, order);
> +                       ring->data[i] = page ? page_address(page) : NULL;
> +               }
>                 if (!ring->data[i])
>                         return -ENOMEM;
>         }

Actually I looked closer at this driver. Is it able to receive frames
larger than 2K? If not there isn't any point in this change.

Based on commit 4fd59792097a ("net: ethernet: mediatek: support
setting MTU") it looks like it doesn't, so odds are this patch is not
necessary.
