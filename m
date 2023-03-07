Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA206AF838
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCGWHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCGWHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:07:07 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91331ADC35;
        Tue,  7 Mar 2023 14:06:57 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id bw19so13576302wrb.13;
        Tue, 07 Mar 2023 14:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678226816;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=poew1WFVSOOAzkIAHVDedf8O8LJO/urtIChEfIqjULY=;
        b=XbzFEsD/qU9AQKwecqFR+nyuaFeTbJRh0UAVYICoGWRfBC7IxrNkJxq7KxZAQtiBEN
         2AZ/I6HCd2fmK1VGB2CxnFzROKvqJpJoGY4qbaZs1GZFd9/o+2ptSWT5EZJA3kgfF2M6
         tcCpRLfsEcg6Or61srtYA28761Xk3weDhZYcw4GgPnkemg/Prh7faTstnQwz81ZdJs22
         RdVvNc3mRACdnz1JSgccSHhRIEwLCezZMdsJ5aQE0Z6KrF5D20ENfvhLf4Fg343b5hdR
         JZwMvT55aGhqLnDpXEO/loBxtSGIOhCuN9iABW83A4KBS3FtwOCRtoOF54g4zxrCDGNb
         cMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678226816;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=poew1WFVSOOAzkIAHVDedf8O8LJO/urtIChEfIqjULY=;
        b=trtavbYdNEdyKt/qEwu/WaelPkfVA6lnsHVt1GS8NRHEWguvMDSzdls13HMrvfucJe
         FX4W59QXi6vvV6gYHf9UOE7rS2KZ8I/MXN7s0tNBn3L3VbcExYDidpmgp+c0HOiE7Jxi
         Pihfv1La8U8F2xxdq0ZjLQNpX8KuI5cDdSnsX8Ppt6aOf0qSz9UqVTr/EI5TEXELubTc
         5gFd/bcHyPDQlEigUiHc3auF5fiUMHikf91wtx3B/qbfRJ40N8c3DD978zyMofN5620G
         ApxMh9hWFC4peoloA4xxNkCcqC2D7JRYKVN31iIEjeibtHUIpFcUfDyjAV+d8KT4nbiM
         h/Sw==
X-Gm-Message-State: AO0yUKUTzYBrBBMK9yVStTwSqwHmwwN/RpoQwhd0rktu1SI43BnEc/LH
        Zl/EpYKuKtliODayWpJ3cok=
X-Google-Smtp-Source: AK7set/tqn67kDe3PQ6qyDz3oZV4nsz4tDTqJ05fFnzxO/hPjHNk2bAIT/HnGkc6JKDujwwNkyejHw==
X-Received: by 2002:adf:e302:0:b0:2c7:a67:615e with SMTP id b2-20020adfe302000000b002c70a67615emr11843716wrj.0.1678226815982;
        Tue, 07 Mar 2023 14:06:55 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id p1-20020a5d4581000000b002c55551e6e9sm13670141wrq.108.2023.03.07.14.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:06:55 -0800 (PST)
Date:   Wed, 8 Mar 2023 00:06:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 1/2] net: dsa: mt7530: remove now incorrect comment
 regarding port 5
Message-ID: <20230307220652.feb33nkb74x6y4ip@skbuf>
References: <20230307220328.11186-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307220328.11186-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 01:03:27AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
> be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
> port 5") under mt7530_setup_port5().
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index a508402c4ecb..b1a79460df0e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2201,7 +2201,7 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	mt7530_pll_setup(priv);
>  
> -	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
> +	/* Enable port 6 */
>  	val = mt7530_read(priv, MT7530_MHWTRAP);
>  	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
>  	val |= MHWTRAP_MANUAL;
> -- 
> 2.37.2
> 

It's best not to abuse the net.git tree with non-bugfix patches.
