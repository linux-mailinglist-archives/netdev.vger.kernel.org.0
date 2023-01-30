Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A41680A37
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbjA3J5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbjA3J5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:57:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5B030184;
        Mon, 30 Jan 2023 01:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D79B1B80EBC;
        Mon, 30 Jan 2023 09:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EFFC433D2;
        Mon, 30 Jan 2023 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675072550;
        bh=eQum8BvEG4rRObKjEyM9pnllkgIf+dV5Kliwi0Rsi+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FHmN+/PbSG5PwAgzwNbC8hurQsVAPj6HnhL0/z3e47qcwkRUkLP+haZXY7epqhnMd
         C9WNl8aEa81qRZeFOi6MNECfOjw/ZJSjuThkjHK3BV1qvaMdefvC/kJZbUHXfMJKGW
         mjI4G+OV+fQeKSLELtDB41n6l3I2gKCxAJRWDr88W/tS63FNJHzPx2MfdZ89cHWUby
         ebgncIc/PuuNf0EkF5qiyfstt0rnqBUus/R4rtSLcArLUvVBfun5AI1ieKcbIocm1A
         6BgeLnjWMPQxLtPFwvcl/zL47fmaQt0YoCLaLMJVaZNdvluQY/bvx5jWoIGPhbEP2x
         +r555dEmKxPfg==
Date:   Mon, 30 Jan 2023 11:55:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
Subject: Re: [net-next PATCH] octeontx2-af: Removed unnecessary debug
 messages.
Message-ID: <Y9eUIfUkwf69ntJm@unreal>
References: <20230130035556.694814-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130035556.694814-1-rkannoth@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 09:25:56AM +0530, Ratheesh Kannoth wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> NPC exact match feature is supported only on one silicon
> variant, removed debug messages which print that this
> feature is not available on all other silicon variants.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> index f69102d20c90..ad1374a12a40 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> @@ -200,10 +200,8 @@ void npc_config_secret_key(struct rvu *rvu, int blkaddr)
>  	struct rvu_hwinfo *hw = rvu->hw;
>  	u8 intf;
>  
> -	if (!hwcap->npc_hash_extract) {
> -		dev_info(rvu->dev, "HW does not support secret key configuration\n");
> +	if (!hwcap->npc_hash_extract)
>  		return;
> -	}
>  
>  	for (intf = 0; intf < hw->npc_intfs; intf++) {
>  		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf),
> @@ -221,10 +219,8 @@ void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
>  	struct rvu_hwinfo *hw = rvu->hw;
>  	u8 intf;
>  
> -	if (!hwcap->npc_hash_extract) {
> -		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
> +	if (!hwcap->npc_hash_extract)
>  		return;
> -	}
>  
>  	for (intf = 0; intf < hw->npc_intfs; intf++) {
>  		npc_program_mkex_hash_rx(rvu, blkaddr, intf);
> @@ -1854,16 +1850,12 @@ int rvu_npc_exact_init(struct rvu *rvu)
>  	/* Check exact match feature is supported */
>  	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
>  	if (!(npc_const3 & BIT_ULL(62))) {
> -		dev_info(rvu->dev, "%s: No support for exact match support\n",
> -			 __func__);
>  		return 0;
>  	}

You should remove () brackets here too.

>  
>  	/* Check if kex profile has enabled EXACT match nibble */
>  	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
>  	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
> -		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX profile\n",
> -			 __func__);
>  		return 0;
>  	}

Same comment.

>  
> -- 
> 2.25.1
> 
