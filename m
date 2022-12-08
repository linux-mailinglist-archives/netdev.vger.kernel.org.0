Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0D646ADC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLHIol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLHIo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:44:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF202AE21
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4920861DF6
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6652C433C1;
        Thu,  8 Dec 2022 08:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670489065;
        bh=2YEakhHt3jTQkyImWYHVRYLy3q29iNcp/+rDAHl+koQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g2PKy7GBtil9gXKTSA3GRIOWGL6tjJCmD/jKvkqA3x4InT+BWk2P6vqZDnS248Fbt
         GamaAN4Bz6UoOAj8qtp7vZRgfpW9Wr5oPmMpr4XzUOE3HxqTTVlpfOe2cWsUZ6MPQq
         fvA88IvYnIolTVJZGIW3KykN/JKVwQ15Jm1QU9JwvhTxSth9r0PLlkDFrEQ+f4QNi6
         vKHbCBAYYDdEoxiZZiHxo0NY7bOC0Y9WN13FGw5FZZ+kvPqNqhgjpkbR0INg0kA9VM
         6oBfw9A1aUaKYkGqkd4mp8Kx59o7sLth+Z0LEWprm0irDaklZ6sVYZl9fj2ekO1MW7
         q5MReQeqi5qhg==
Date:   Thu, 8 Dec 2022 10:44:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com
Subject: Re: [PATCH v3 net-next 1/2] net: ethernet: mtk_wed: fix some
 possible NULL pointer dereferences
Message-ID: <Y5Gj5fgVmQLRdorx@unreal>
References: <cover.1670421354.git.lorenzo@kernel.org>
 <44cba2491b6dd1a64d0e8099efbab836e6758490.1670421354.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44cba2491b6dd1a64d0e8099efbab836e6758490.1670421354.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:04:54PM +0100, Lorenzo Bianconi wrote:
> Fix possible NULL pointer dereference in mtk_wed_detach routine checking
> wo pointer is properly allocated before running mtk_wed_wo_reset() and
> mtk_wed_wo_deinit().
> Even if it is just a theoretical issue at the moment check wo pointer is
> not NULL in mtk_wed_mcu_msg_update.
> Moreover, honor mtk_wed_mcu_send_msg return value in mtk_wed_wo_reset()
> 
> Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
> Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c     | 13 ++++++++-----
>  drivers/net/ethernet/mediatek/mtk_wed_mcu.c |  3 +++
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
