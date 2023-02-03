Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D413968A509
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjBCV4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjBCV4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:56:31 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DB07B79A;
        Fri,  3 Feb 2023 13:56:27 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id bg26so4895959wmb.0;
        Fri, 03 Feb 2023 13:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WLYRWm36jDHyrJ/xX9LMtctKjSCkN3DC4rkS0zbuYQE=;
        b=Qk+HYzdq+zR56sRUSNTwsQqSHz9Sav9H9gHScDEHhj1gdB2XTpsn0dq/KvP4gB9oIs
         UJ3gGIyW+rVWFBVaCSrBpaHjFswBgn8e8AioqGgp+zYzda9mXfphwms03d92QzmVe6qT
         0xQgE5RlpBGNVBGGGGJtAIsP1A4N6uw8PfswAdyhFCG3VzxnDXF1gQghV9+GJ1AMez9q
         WEhsAkVKNIFyUXD+EWKPaRdRVALD/ZgtfXUKNi3pK8o8zAjETmGo5+yyFz50CRpFWgJl
         PJgJnuEN+orNPxUQNAPKf9/zWsYrPh+iQ8Va8VMGHMLA7Gzd+rv959eH4WQuQLu7C/QO
         9JsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLYRWm36jDHyrJ/xX9LMtctKjSCkN3DC4rkS0zbuYQE=;
        b=BQghyl+pAS7ubPWt608vT2LzRrdOPjp58wQwHtPgQMBj8VCFWItAaqqPdbDjUUqar/
         y/wG1zfJPtaz+mMDH4htsgznrFVnj1gGt2Pxl3RK50cUxZx6JUDVw9rGjE90QSLxWXe+
         /uGwOz9fW4ucBOXYN+GFp+lZNLRhNJToBB3SmW0t3gLAi82msE4rWCcPx/4hh0MzPb91
         njB9EPhJcb+4Rh1SFpLKWARtQ5fFtEL2XvBNepLZzLbhbe5A09Z2Ea7ozWUuu0sfd7VW
         zAnpAjfSKC7SU9WXf0+t7htDZCWAYkx/hS4GQx+F6aQD4RRXr1NV3+WfcRdR3in+DXQf
         DRFQ==
X-Gm-Message-State: AO0yUKUzLM2v5H+aXD8O5PZctLqDk0C6dvDLlnGU4eZANqUelEhAeqwN
        JHPqaZIlvvsoHjcErJeo5m4=
X-Google-Smtp-Source: AK7set8WbE4oVAMvAPbuXINI7wua/bASKG9onl4W65ZkN77tNd4gw8BIkIAl2J2XDFKgBRNuGMtbFg==
X-Received: by 2002:a05:600c:4f83:b0:3db:1a41:663a with SMTP id n3-20020a05600c4f8300b003db1a41663amr11248121wmq.20.1675461385802;
        Fri, 03 Feb 2023 13:56:25 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c314900b003dfeea6a85csm1428578wmo.31.2023.02.03.13.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 13:56:25 -0800 (PST)
Date:   Fri, 3 Feb 2023 23:56:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 8/9] net: ethernet: mtk_eth_soc: switch to external PCS
 driver
Message-ID: <20230203215622.z6mzsu37dipwg2bd@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
 <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
 <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:06:10AM +0000, Daniel Golle wrote:
>  int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
>  {
>  	struct device_node *np;
>  	int i;
> +	u32 flags;
> +	struct regmap *regmap;
>  
>  	for (i = 0; i < MTK_MAX_DEVS; i++) {
>  		np = of_parse_phandle(r, "mediatek,sgmiisys", i);
>  		if (!np)
>  			break;
>  
> -		ss->pcs[i].ana_rgc3 = ana_rgc3;
> -		ss->pcs[i].regmap = syscon_node_to_regmap(np);
> -
> -		ss->pcs[i].flags = 0;
> +		flags = 0;
>  		if (of_property_read_bool(np, "pn_swap"))
> -			ss->pcs[i].flags |= MTK_SGMII_FLAG_PN_SWAP;
> +			flags |= MTK_SGMII_FLAG_PN_SWAP;
>  
>  		of_node_put(np);
> -		if (IS_ERR(ss->pcs[i].regmap))
> -			return PTR_ERR(ss->pcs[i].regmap);
>  
> -		ss->pcs[i].pcs.ops = &mtk_pcs_ops;
> -		ss->pcs[i].pcs.poll = true;
> -		ss->pcs[i].interface = PHY_INTERFACE_MODE_NA;
> +		regmap = syscon_node_to_regmap(np);

Not supposed to use "np" after of_node_put().

> +		if (IS_ERR(regmap))
> +			return PTR_ERR(regmap);
> +
> +		ss->pcs[i] = mtk_pcs_create(ss->dev, regmap, ana_rgc3, flags);
>  	}
