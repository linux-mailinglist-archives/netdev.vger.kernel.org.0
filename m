Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165E252AFF0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiERBdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiERBdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:33:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C5935DC4;
        Tue, 17 May 2022 18:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 699AAB81BE7;
        Wed, 18 May 2022 01:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B3EC385B8;
        Wed, 18 May 2022 01:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652837593;
        bh=+SoCN+SFVG5flL/deCdtvEfxB8FWbtMZDFfGrT1AdEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RCa2Q8jgXuCPUaD3yoOQ5ZPNL4sm6X5FetMeK9vFyqC+WkW3oqup9K3xMKLWLBpcG
         1SNUAuPTrFtiv7VumBsOy/gG3ErdIujP9f2oldiSHo3tg4xCndis6PK9cOLlgGHhCv
         tw2t1YaMRRcg+JvvLA3ojLGtNJF3h/nf9L7IAUGIAoytntCCTwUzSaFxhv3m5aRfFG
         pbwpHM6H0i/CZxrtaSPvwNjywunCdBHmpftO3bBJVGCEJcrCUIKB7GlJLniiJ4ntFH
         aSlwbm+K5lbYDXkBwES5xv3uubwbNayZC/SmrJnQrFAKHMlxAic8lYvMYDsvl1ilvO
         UfkZbdunkINKg==
Date:   Tue, 17 May 2022 18:33:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 04/15] net: ethernet: mtk_eth_soc: add
 txd_size to mtk_soc_data
Message-ID: <20220517183311.3d4c76fe@kernel.org>
In-Reply-To: <22bd1bd88c09205b9bf83ea4c3ab030d5dc6e670.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <22bd1bd88c09205b9bf83ea4c3ab030d5dc6e670.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 18:06:31 +0200 Lorenzo Bianconi wrote:
>  	eth->scratch_ring = dma_alloc_coherent(eth->dma_dev,
> -					       cnt * sizeof(struct mtk_tx_dma),
> +					       cnt * soc->txrx.txd_size,
>  					       &eth->phy_scratch_ring,
>  					       GFP_ATOMIC);
>  	if (unlikely(!eth->scratch_ring))
>  		return -ENOMEM;
>  
> -	eth->scratch_head = kcalloc(cnt, MTK_QDMA_PAGE_SIZE,
> -				    GFP_KERNEL);
> +	eth->scratch_head = kcalloc(cnt, MTK_QDMA_PAGE_SIZE, GFP_KERNEL);

Unrelated, but GFP_ATOMIC right next to GFP_KERNEL caught my attention.
