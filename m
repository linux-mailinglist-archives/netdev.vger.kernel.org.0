Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548546423F2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiLEIA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiLEIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C094811811
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C840B80D81
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AA3C433C1;
        Mon,  5 Dec 2022 08:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670227217;
        bh=5oxLWtvApX59L70YDd6ciffZVT6C/AZpgIfnuD5KE4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXCyY0qNKB3+hUfMSdXLw83ismiriqZvAQptyNL6xGj65Z8I5DU23WkNWbNyNtKIG
         9q5FWYP22imRbO9o3onPlIOp1/WMvp3k1l+zuHtDV6UlU6cr7VMXNRS4B+vrrsVXGp
         m3I8HTz71557ZESZH5toRxTQGDZkxXfldkRfufoLHWCNav8JdQu+xJvqgqfC1gwnmW
         bO8IRsCR+oU75IHQ5lgmuo0h8GbgPa8nCCno5Nd4uZ7PfLvJWzeYb3E/dlseOpjQAB
         nXYUkyXRYmfEL1UVs9gbfAtIoKcDNQ5SW3jEhOjeeSPAdH7e7e5Y3SoHf4GX7VgMYm
         aFKAwqJDUJx8Q==
Date:   Mon, 5 Dec 2022 10:00:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, sujuan.chen@mediatek.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v2] net: ethernet: mtk_wed: Fix missing
 of_node_put() in mtk_wed_wo_hardware_init()
Message-ID: <Y42lDNzhBeYcevRL@unreal>
References: <20221205034339.112163-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205034339.112163-1-yuancan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 03:43:39AM +0000, Yuan Can wrote:
> The np needs to be released through of_node_put() in the error handling
> path of mtk_wed_wo_hardware_init().
> 
> Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - Replace IS_ERR_OR_NULL() with IS_ERR() to check wo->mmio.regs.
> - Add net-next tag.
> 
>  drivers/net/ethernet/mediatek/mtk_wed_wo.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
