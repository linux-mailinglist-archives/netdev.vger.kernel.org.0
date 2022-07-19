Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE14579649
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbiGSJ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiGSJ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:26:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0684A1BE8D
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658222803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eTkbwHV0mOtp0z/6cX28miDp8MHqUdj7J5ZyCOHAibQ=;
        b=Fef/AEoi/StO4QLy4KBfZuk9b0ffkraxy8V5tWJ9L0LMphkoVhiHf7k6XlXzvujELxLn4b
        GFAg9K4WVDoiL1EfGZwM/VKhn07p7K5glCGPA0WFHKAimcqh6EOeoK1gGvsEzz2qCjP/8V
        XGkxnCUv6R6Rl+a4rm2rFG8A77ONWEc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-PsjH-cMHO0iOmr5rrYbGqw-1; Tue, 19 Jul 2022 05:26:41 -0400
X-MC-Unique: PsjH-cMHO0iOmr5rrYbGqw-1
Received: by mail-qt1-f198.google.com with SMTP id v6-20020ac87486000000b0031ee0ae1400so6607718qtq.14
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eTkbwHV0mOtp0z/6cX28miDp8MHqUdj7J5ZyCOHAibQ=;
        b=ZhEEEyMv0QJq/mOE3tZ4bRVNjmB8M6tCDRoY3BPLuVkye31y4Ojp6xfUmVK3MQAopb
         8ouqHSdKb5B6h5ikasX41Yc5olAbFoMv9C0pruuXMyvMuOAtT8eS4fnpqQHJtuMjHvZt
         ui96yuj8Kmzdn6CvGVF1z8WKGmFLzVSWLyRn/J2L2ptELne2XtoEcCYd7BVS7jltK6fX
         3dW2jR2PcPfFfMUBQR8dUfJ6diyQ10D6WdXhaktiUTfQ+8SYh1WUWZ9aFXxjNpKXYc/Z
         rNfWt3Blz86TMdG+/pjYJJ9Ejuqn/Gtg6eQ8EiCFf5dshtUsTA+kq2Of2R66OrYPSagB
         dj8Q==
X-Gm-Message-State: AJIora/0xNNi2RJ7t6WxyFzkEjc/GoqcTp7w/LLSgSDG9K57TQyIKLDY
        sw3qSBo8KdrfmhGaSObJF2CA5Ae9fELgwAT2bePN1FzNpgl6/mvJdK9f0MRvjXFKoNzlzvO1Dmc
        hKUsWFfJ/jAEg8MQQ
X-Received: by 2002:ac8:5f88:0:b0:31e:f6dd:8f13 with SMTP id j8-20020ac85f88000000b0031ef6dd8f13mr3850071qta.186.1658222801452;
        Tue, 19 Jul 2022 02:26:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tYwWkPsogu92WD69xPrFD8ieER9ewEMGjIxtpW12bu4A8xXH8X7r+dVbw98IyMHM+vkMD/6Q==
X-Received: by 2002:ac8:5f88:0:b0:31e:f6dd:8f13 with SMTP id j8-20020ac85f88000000b0031ef6dd8f13mr3850055qta.186.1658222801205;
        Tue, 19 Jul 2022 02:26:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id dm53-20020a05620a1d7500b006b4880b08a9sm14168481qkb.88.2022.07.19.02.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 02:26:40 -0700 (PDT)
Message-ID: <43ff0071f0ce4b958f27427acebcf2c6ace52ba0.camel@redhat.com>
Subject: Re: [PATCH v3 net-next 5/5] net: ethernet: mtk_eth_soc: add support
 for page_pool_get_stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Date:   Tue, 19 Jul 2022 11:26:36 +0200
In-Reply-To: <8592ada26b28995d038ef67f15c145b6cebf4165.1657956652.git.lorenzo@kernel.org>
References: <cover.1657956652.git.lorenzo@kernel.org>
         <8592ada26b28995d038ef67f15c145b6cebf4165.1657956652.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-16 at 09:34 +0200, Lorenzo Bianconi wrote:
> Introduce support for the page_pool stats API into mtk_eth_soc driver.
> Report page_pool stats through ethtool.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/Kconfig       |  1 +
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 40 +++++++++++++++++++--
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
> index d2422c7b31b0..97374fb3ee79 100644
> --- a/drivers/net/ethernet/mediatek/Kconfig
> +++ b/drivers/net/ethernet/mediatek/Kconfig
> @@ -18,6 +18,7 @@ config NET_MEDIATEK_SOC
>  	select PHYLINK
>  	select DIMLIB
>  	select PAGE_POOL
> +	select PAGE_POOL_STATS
>  	help
>  	  This driver supports the gigabit ethernet MACs in the
>  	  MediaTek SoC family.
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index abb8bc281015..eba95a86086d 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3517,11 +3517,19 @@ static void mtk_get_strings(struct net_device *dev, u32 stringset, u8 *data)
>  	int i;
>  
>  	switch (stringset) {
> -	case ETH_SS_STATS:
> +	case ETH_SS_STATS: {
> +		struct mtk_mac *mac = netdev_priv(dev);
> +		struct mtk_eth *eth = mac->hw;
> +
>  		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++) {
>  			memcpy(data, mtk_ethtool_stats[i].str, ETH_GSTRING_LEN);
>  			data += ETH_GSTRING_LEN;
>  		}
> +		if (!eth->hwlro)

I see the page_pool is enabled if and only if !hwlro, but I think it
would be more clear if you explicitly check for page_pool here (and in
a few other places below), so that if the condition to enable page_pool
someday will change, this code will still be fine.

Thanks!

Paolo

