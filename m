Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A7A6A7D8D
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCBJWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCBJVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:21:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93383B3EA;
        Thu,  2 Mar 2023 01:21:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2596E61548;
        Thu,  2 Mar 2023 09:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A911AC433D2;
        Thu,  2 Mar 2023 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677748898;
        bh=cOTeCtj7ndRx/yOBQ/xH7JUbBavYYcRLlMhD50aq8hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l0Zi3Zr8ZQsz3ayPTPfBqRRnxVJQkC6RzCQ0JbNTE/s+O93w6pDsIRyWo5cH1R5mp
         PZnhT8/iOkCsxawERFoUUCI2404AwOzHebXvUpcCowYm1IbGGm4DERD9DAZ+WJmYLt
         Zh1cvvFb98nMYcFFLP88j3aZnTvkMWY2H8nHOufy8c+l5dv0UHdgqQVGCNBEQEeq9o
         3OI2fXdB0SMn5POai1sYkNlWNIDQ+uD07OFeLic8+OjvluRG1O/oaWZmoMBMpKgTcO
         jYjqHP5hjA8iWGrc6bCtwbMBEh3d+PWyplwXxzeGQgsMY5uucuTCtuQJ40kaBp/Hhq
         SXx6H+jL08TSg==
Date:   Thu, 2 Mar 2023 11:21:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
Subject: Re: [net PATCH] octeontx2-af: Fix start and end bit for scan config
Message-ID: <20230302092133.GB561905@unreal>
References: <20230302032855.831573-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302032855.831573-1-rkannoth@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 08:58:55AM +0530, Ratheesh Kannoth wrote:
> for_each_set_bit_from() needs start bit as one bit prior
> and end bit as one bit post position in the bit map
> 
> Fixes: 88fffc65f940 (octeontx2-af: Exact match scan from kex profile)

This is wrong Fixes line. It should be:
Fixes: 812103edf670 ("octeontx2-af: Exact match scan from kex profile")

Thanks

> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> index 327d3c6b1175..9c7bbef27e31 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> @@ -603,9 +603,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
>  	 * exact match code.
>  	 */
>  	masked_cfg = cfg & NPC_EXACT_NIBBLE;
> -	bitnr = NPC_EXACT_NIBBLE_START;
> -	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
> -			      NPC_EXACT_NIBBLE_START) {
> +	bitnr = NPC_EXACT_NIBBLE_START - 1;
> +	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg, NPC_EXACT_NIBBLE_END + 1) {
>  		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
>  		key_nibble++;
>  	}
> -- 
> 2.25.1
> 
