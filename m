Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA2665EB22
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbjAEMyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjAEMx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:53:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDAE5C1C6;
        Thu,  5 Jan 2023 04:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA18619F2;
        Thu,  5 Jan 2023 12:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEADC433D2;
        Thu,  5 Jan 2023 12:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672923185;
        bh=8sOhPJ6cEQDBx/95tSr2Zy0CaclDzG+It2Q7DiPrlYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTBcf5JBi2vKT7ruzwq9M5Q0/T5Qtl6xJgqhbME/6TBDRC0XzlDFnU67xkFML5lp9
         +Pfe6U53KBlwvQce7HwUD288NYvt3EqwM6S2yHQghy6c75/zEqmFSOxyH3I8Ez6vC6
         YtrzsYPZ+JJXcINRfhvAKvWK4zphjc25MrrRWEWgXU4Yme3NMztUXHtPusYvbsu9bK
         S9jH5rcamdXGkuisOWWvmecE5lfPp4NNMeJkln0OXHowjqZiOA7MULv3NIPIy5w5Wl
         pIqm2j51ZURq9KHLd7ebECHdtVyOYwDbkkLdq1Z2e4N6quFUcdDDFDFGDJPqo/Gwb2
         TL0+fjmJGakAw==
Date:   Thu, 5 Jan 2023 14:53:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        Angela Czubak <aczubak@marvell.com>
Subject: Re: [net PATCH] octeontx2-af: Fix LMAC config in
 cgx_lmac_rx_tx_enable
Message-ID: <Y7bILQI/tu7ag3ae@unreal>
References: <20230104163220.954-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104163220.954-1-hkelam@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 10:02:20PM +0530, Hariprasad Kelam wrote:
> From: Angela Czubak <aczubak@marvell.com>
> 
> PF netdev can request AF to enable or disable reception and transmission
> on assigned CGX::LMAC. The current code instead of disabling or enabling
> 'reception and transmission' also disables/enable the LMAC. This patch
> fixes this issue.
> 
> Fixes: 1435f66a28b4 ("octeontx2-af: CGX Rx/Tx enable/disable mbox handlers")
> Signed-off-by: Angela Czubak <aczubak@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index b2b71fe80d61..724df6398bbe 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -774,9 +774,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
>  
>  	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
>  	if (enable)
> -		cfg |= CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN;
> +		cfg |= DATA_PKT_RX_EN | DATA_PKT_TX_EN;
>  	else
> -		cfg &= ~(CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN);
> +		cfg &= ~(DATA_PKT_RX_EN | DATA_PKT_TX_EN);

I don't see any usage of CMR_EN after this change. You can delete that
define too.

Thanks

>  	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
>  	return 0;
>  }
> -- 
> 2.17.1
> 
