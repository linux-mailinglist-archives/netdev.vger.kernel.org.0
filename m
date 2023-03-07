Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AED6AFA8A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCGXfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCGXer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:34:47 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC324ABAD9;
        Tue,  7 Mar 2023 15:33:59 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v16so13822364wrn.0;
        Tue, 07 Mar 2023 15:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678232037;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EkNaxXiMy7dB/CrQfOiflJv5/zBXe0f/wSftJOqjPTs=;
        b=I0EQtsf9xtV2ehvI+faofQ58gjc4ZydAC68khJeEksSH1rhQD/n4WgRIUsQu+EY2TL
         KcL/UawUoIDbRQSyH3rV1QyaoUIDSnrZ+SBiQkunnbW6Ax+ndjKEtjnI9aNJN3ZqzXTB
         q9cdGqdluLApOFQioTUcZA4grcwG1olMdiDNZ5+ZuyXtefpZZHyHDiodyQBMxXgZ3zSF
         V+PkJGIS2R1UXl9IGOLOue+f8/yX2K6Hq+dzZfKmG0hkDcSa6qB5E7j4u4Y0nan7fZ4x
         UdrU8fhjs5N5SZalVQdiWSR/tNlHlmeDBFuL0WV+xFNbNn/07+/z/hPQFSuGeYMkozgR
         Ms3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678232037;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EkNaxXiMy7dB/CrQfOiflJv5/zBXe0f/wSftJOqjPTs=;
        b=YX485z8O9NqBdcXSktysp3XDPV+yO3J+hzLbNVOtFMAKEwwgcP6ERP8NwQZhM1Eids
         9urjAm2847RZesBNpZ1BHzljIpGXHbMoAoKdVbM83HAeIRhJG0URH0wc9tBsJX4fYD5O
         Makbd/Ce8jAWJlZpfC47QK7CQEhNMv86KfU0mErZtl/iGkxYcqnlSaxpMDJO4kKH21wg
         fyWLnNpNcKrtIy+quIUDRBgo+ewi6vRNPgFgw5pJeRltci6xhxeGNKJMtmGqHX7edbc7
         7RejsBO8BiNnrAIDBly8QbiGSZMBhgqQu4xN9smD3j5mcSKbc7ko4bg6C0cifI8c14nB
         ubdQ==
X-Gm-Message-State: AO0yUKWWIX1CbNvvVJzwOtiW/MSEaul45TUJ3tiozFAj5e/771y4nPZs
        f1/qaSVCg8tLDZsV6wMMDHg=
X-Google-Smtp-Source: AK7set+LWjjzrdvVfaBUwqng1pTIQRvZqWOtnZ08kw66e0Pnm2ILtlPlvo1bsvLwii2gYhC1QyMMFg==
X-Received: by 2002:a5d:5746:0:b0:2c9:5dd8:2978 with SMTP id q6-20020a5d5746000000b002c95dd82978mr10764040wrw.59.1678232037233;
        Tue, 07 Mar 2023 15:33:57 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id x17-20020adfdcd1000000b002c5804b6afasm13832424wrm.67.2023.03.07.15.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 15:33:57 -0800 (PST)
Date:   Wed, 8 Mar 2023 01:33:54 +0200
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
Subject: Re: [PATCH net 2/2] net: dsa: mt7530: set PLL frequency only when
 trgmii is used
Message-ID: <20230307233354.y3srdoggy2yzugnq@skbuf>
References: <20230307220328.11186-1-arinc.unal@arinc9.com>
 <20230307220328.11186-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307220328.11186-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 01:03:28AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> As my testing on the MCM MT7530 switch on MT7621 SoC shows, setting the PLL
> frequency does not affect MII modes other than trgmii on port 5 and port 6.
> So the assumption is that the operation here called "setting the PLL
> frequency" actually sets the frequency of the TRGMII TX clock.
> 
> Make it so that it is set only when the trgmii mode is used.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index b1a79460df0e..961306c1ac14 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>  	switch (interface) {
>  	case PHY_INTERFACE_MODE_RGMII:
>  		trgint = 0;
> -		/* PLL frequency: 125MHz */
> -		ncpo1 = 0x0c80;
>  		break;
>  	case PHY_INTERFACE_MODE_TRGMII:
>  		trgint = 1;
> -- 
> 2.37.2
> 

NACK.

By deleting the assignment to the ncpo1 variable, it becomes
uninitialized when port 6's interface mode is PHY_INTERFACE_MODE_RGMII.
In the C language, uninitialized variables take the value of whatever
memory happens to be on the stack at the address they are placed,
interpreted as an appropriate data type for that variable - here u32.

Writing the value to CORE_PLL_GROUP5 happens when the function below is
called, not when the "ncpo1" variable is assigned.

	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));

It is not a good idea to write uninitialized kernel stack memory to
hardware registers, unless perhaps you want to use it as some sort of
poor quality entropy source for a random number generator...
