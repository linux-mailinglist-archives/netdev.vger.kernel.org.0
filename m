Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6D66D0DE2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjC3SjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjC3Si7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:38:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A520EC7C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF522B829D2
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A54C4339C;
        Thu, 30 Mar 2023 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680201524;
        bh=GvjZIO2gAHRSZfbzpMXxIj759h+LYDh1RwzxhaWpsLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H630dE0+Z6mC/PQorik1wmSuG7egRbz+MtwqufTpGaIgq70j2DKeIavji0s8rcsvg
         vlMqnqn/9FiW8muHTuQVaLBXnAazOUNZpbnkvblC+QIkmyXbDPx2KVQgAOv0LIpFY0
         kvGO4Z6czUmPIGfdc71TRXnE+aaTYIoBf2Gg4Rg5pRx8zV9whN4KuxLtr8zvzkvZ0j
         5MaB7dwnt0bLAMKUc7K1hBgb8hRchNbm1ByTeXCjaDv5Z95rwAuBnLYKINGv/NZCvC
         u4zaCx979fBkUagDFUUNmXWoeJvde3yvpaXqzmHU1wWz8dJQ1zA/sSHB1c5QXcpZXp
         twGsV3DzLqfBg==
Date:   Thu, 30 Mar 2023 21:38:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: ethernet: mtk_eth_soc: fix flow block
 refcounting logic
Message-ID: <20230330183840.GW831478@unreal>
References: <20230330120840.52079-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330120840.52079-1-nbd@nbd.name>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:08:38PM +0200, Felix Fietkau wrote:
> Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
> call flow_block_cb_incref for a newly allocated cb.
> Also fix the accidentally inverted refcount check on unbind.
> 
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
