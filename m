Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD704C13A1
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbiBWNMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240727AbiBWNMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:12:31 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C685E75F
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:12:03 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h15so27092467edv.7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bx50SKy78RP4R1YROr6Jpdecx5Dy3lu/VCxM9FDLuOs=;
        b=ZGZAT2izzV7UgSv7VLT794mAoOKvFrijXgG5lxiTKy4zqG3gES+hEGrTmiAO4suUjy
         laZrJn7BYK6443ENbTnf+/PdL/AFcMYJ1F9ZfP97aGm9eQgnLNc40z54TtxVWuvZSvjf
         MlWMtJGoc15qdY8MuuasJHjKB0bLG2DntMiKZPPuUZNhqPSdxnYtHanT+AR1q8ygTVSu
         hl1VrsX54lxaDvIsHNMdh/3VXthzrNP0H4181NCr9CZZarbFB9mPsVmQCGR3T6raTaSB
         Y/Ui58yYVWFjesp050oqB5LVBWD7IWbQK9cytXGEF6BgI/7yo1xRJsAfnLBHVHxNr5l+
         eeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bx50SKy78RP4R1YROr6Jpdecx5Dy3lu/VCxM9FDLuOs=;
        b=bVtP8Ds8NX1vv5xh2JKd3bFE63yYDgQgoJolRslBegnLzMWkEs3xnBmVGwJEhYKZTB
         NF96G5a28g/HV/YR7cFPHa9eOabMoybkR84+x8cpmqLZV8+pbuBAn3whpHy3hdPDKGpT
         siLqZUkt+mVaTQziLeJl8uN08gHwFi9I/J+C4IpwIpz7Mtz9wdDOCUTw/4iQK04ygCCL
         3dB0A2EhLYtp+dLwnCToxIqM0qTu05BTQ2ZEa7rmnC/HUaFRW4EMGNjqTplkD1vJkTh9
         0M4oBebiVejHmmz/yh4hbkxEo15pnfEDzDqDt6h0PNkqg9XXoh7282wz+LeBoEMAYSmN
         b3Qg==
X-Gm-Message-State: AOAM532/47036ApL3a5RTvIMgrvF+CJiUY9ktfflV7x8FFiRBCZeZJWh
        ZgjdovpEIG5TjgaURk2zIvWjiZ8Opb0=
X-Google-Smtp-Source: ABdhPJwO2m0wpqW6G+xKOFGVgVXeld2qoX5ryAz3Z3SO0nMKxlBmN9gwvJqMjo3gYP9EKa/BqylWeQ==
X-Received: by 2002:a50:a68b:0:b0:413:3b43:ae02 with SMTP id e11-20020a50a68b000000b004133b43ae02mr2333951edc.11.1645621922293;
        Wed, 23 Feb 2022 05:12:02 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id j20sm8352979edt.67.2022.02.23.05.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:12:01 -0800 (PST)
Date:   Wed, 23 Feb 2022 15:12:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next v2 01/10] net: dsa: mt7530: fix incorrect
 test in mt753x_phylink_validate()
Message-ID: <20220223131200.673xmc6euwkyphzy@skbuf>
References: <YhYbpNsFROcSe4z+@shell.armlinux.org.uk>
 <E1nMpuT-00AJoW-Dq@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nMpuT-00AJoW-Dq@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Feb 23, 2022 at 11:34:17AM +0000, Russell King (Oracle) wrote:
> Discussing one of the tests in mt753x_phylink_validate() with Landen
> Chao confirms that the "||" should be "&&". Fix this.
> 
> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index f74f25f479ed..69abca77ea1a 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2936,7 +2936,7 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
>  
>  	phylink_set_port_modes(mask);
>  
> -	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
> +	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
>  	    !phy_interface_mode_is_8023z(state->interface)) {
>  		phylink_set(mask, 10baseT_Half);
>  		phylink_set(mask, 10baseT_Full);
> -- 
> 2.30.2
> 

Since the "net" pull request for this week is scheduled to happen rather
soon, I think you should split this and send it to "net", so that you
won't have to wait when you resend as non-RFC.
