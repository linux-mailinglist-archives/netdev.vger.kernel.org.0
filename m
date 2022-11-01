Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A8961528E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKATwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 15:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKATwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 15:52:44 -0400
X-Greylist: delayed 799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 12:52:43 PDT
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645861BE9E;
        Tue,  1 Nov 2022 12:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x4C12LDS9wwvkrJnkZmG6Ds3JPzjHGQkWYbH1hJx6iY=; b=pRS7H3mRoqrRQa6i9YOi/LYLhD
        df1NmiHZx10N0PxRijT87mi02CTTAPFp4uCXC7Oq15+6kkxoEJZ/BfVPTgj1SdKfo7Vgn87NXGvtm
        pN7Ml86l9yEx+oIXA4yM3Cr9jwStf1JRdHBI4b0bznd7Abb3qSVwhTesT3SYbx8575LQ=;
Received: from p200300daa71950003c313de20777bbcd.dip0.t-ipconnect.de ([2003:da:a719:5000:3c31:3de2:777:bbcd] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1opx6C-00Glcp-04; Tue, 01 Nov 2022 20:39:00 +0100
Message-ID: <5d8e00d4-830d-19ff-a3cb-59bd81618903@nbd.name>
Date:   Tue, 1 Nov 2022 20:38:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <Y2FvtampxpDGua2p@makrotopia.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] net: ethernet: mediatek: ppe: add support for flow
 accounting
In-Reply-To: <Y2FvtampxpDGua2p@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.11.22 20:12, Daniel Golle wrote:
> The PPE units found in MT7622 and newer support packet and byte
> accounting of hw-offloaded flows. Add support for reading those
> counters as found in MediaTek's SDK[1].
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  11 +-
>   drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   1 +
>   drivers/net/ethernet/mediatek/mtk_ppe.c       | 122 +++++++++++++++++-
>   drivers/net/ethernet/mediatek/mtk_ppe.h       |  23 +++-
>   .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
>   .../net/ethernet/mediatek/mtk_ppe_offload.c   |   7 +
>   drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 ++
>   7 files changed, 178 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 789268b15106ec..5fcd66fca7a089 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -4221,6 +4223,7 @@ static const struct mtk_soc_data mt2701_data = {
>   	.hw_features = MTK_HW_FEATURES,
>   	.required_clks = MT7623_CLKS_BITMAP,
>   	.required_pctl = true,
> +	.has_accounting = false,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma),
>   		.rxd_size = sizeof(struct mtk_rx_dma),
> @@ -4239,6 +4242,7 @@ static const struct mtk_soc_data mt7621_data = {
>   	.required_pctl = false,
>   	.offload_version = 2,
>   	.hash_offset = 2,
> +	.has_accounting = false,
>   	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma),
> @@ -4259,6 +4263,7 @@ static const struct mtk_soc_data mt7622_data = {
>   	.required_pctl = false,
>   	.offload_version = 2,
>   	.hash_offset = 2,
> +	.has_accounting = true,
>   	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma),
> @@ -4278,6 +4283,7 @@ static const struct mtk_soc_data mt7623_data = {
>   	.required_pctl = true,
>   	.offload_version = 2,
>   	.hash_offset = 2,
> +	.has_accounting = false,
>   	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma),
> @@ -4296,6 +4302,7 @@ static const struct mtk_soc_data mt7629_data = {
>   	.hw_features = MTK_HW_FEATURES,
>   	.required_clks = MT7629_CLKS_BITMAP,
>   	.required_pctl = false,
> +	.has_accounting = true,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma),
>   		.rxd_size = sizeof(struct mtk_rx_dma),
> @@ -4315,6 +4322,7 @@ static const struct mtk_soc_data mt7986_data = {
>   	.required_pctl = false,
>   	.hash_offset = 4,
>   	.foe_entry_size = sizeof(struct mtk_foe_entry),
> +	.has_accounting = true,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma_v2),
>   		.rxd_size = sizeof(struct mtk_rx_dma_v2),
> @@ -4331,6 +4339,7 @@ static const struct mtk_soc_data rt5350_data = {
>   	.hw_features = MTK_HW_FEATURES_MT7628,
>   	.required_clks = MT7628_CLKS_BITMAP,
>   	.required_pctl = false,
> +	.has_accounting = false,
>   	.txrx = {
>   		.txd_size = sizeof(struct mtk_tx_dma),
>   		.rxd_size = sizeof(struct mtk_rx_dma),
You can leave out the .has_accounting = false assignments.

> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
> index 2d8ca99f2467ff..bc4660da28451b 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -545,6 +592,16 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
>   	wmb();
>   	hwe->ib1 = entry->ib1;
>   
> +	if (ppe->accounting) {
> +		int type;
> +
> +		type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
> +		if (type >= MTK_PPE_PKT_TYPE_IPV4_DSLITE)
> +			hwe->ipv6.ib2 |= MTK_FOE_IB2_MIB_CNT;
> +		else
> +			hwe->ipv4.ib2 |= MTK_FOE_IB2_MIB_CNT;
> +	}
Use mtk_foe_entry_ib2() here.

> @@ -654,11 +711,8 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
>   			continue;
>   		}
>   
> -		if (found || !mtk_flow_entry_match(ppe->eth, entry, hwe)) {
> -			if (entry->hash != 0xffff)
> -				entry->hash = 0xffff;
> +		if (found || !mtk_flow_entry_match(ppe->eth, entry, hwe))
>   			continue;
> -		}
What is the reason for this change?

- Felix
