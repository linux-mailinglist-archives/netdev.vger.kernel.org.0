Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1265F4B1
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbjAETjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbjAETin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:38:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E4E5F5E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:37:10 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id x22so92342954ejs.11
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 11:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/T+0TSWvX7XMU5zcmgn1cajtX/i2zl7juylDQXfwXGI=;
        b=HXgxlkLPhL45xjEgUEo0UDT5iFmp8K/h+LYbIb9ghczKzxouw5VPIJXZ18FF+snIBj
         Pxgm9WfufD8VzQsXccw9cNcZ7RLk4PkYBGjmbD3kfsTNmt4j8Fn97ALi3oBMzNd+sjMr
         vjzVSn87z7cgF7XB4UaDh5CvFlRMmf6SMOgIGTEqD1t6H80gqpuZowGsQm/JxU9Y8uO0
         RudiRMqbNWn7yKNFxBGG2AzHiS+ZzOhOfu0UXaRprGQzW95VNFvAQk06IRN2PfXGuHD+
         mae7xt+9saG0qUsgNSomIp6q+jpmBHjscSsE3A/29vgDppx81aaKLX5LU+jOqH0O9Enc
         j6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/T+0TSWvX7XMU5zcmgn1cajtX/i2zl7juylDQXfwXGI=;
        b=dxg385ChadK4vEb/BIIDzWqy1iFP2aTuKkfxiZAXN59oGNumuJB12mFC1qCPtDh+xD
         akajI1rfTNpVYeG3NX3EIBYkC2bSosyCpOR73PYp2178TmcGgxwURNdJZGRpF1WabWf0
         5VK3uaAscrvY0Lu3Wmiv3aZ/Z2qn2zXCz9A3PANowYUlMcfZci3jh00r8VtWeAvo4mPR
         veV7d8bwr9oiVB+G8AzCzF0NF3omZbLa/YkxOhLMK5fc1678B163Xs6A+t//rHRP4SGH
         OtXpIVqObbSQyRiisE5lCw5px6USHDwhDD4mctgjqc58zKfiN0zumxFUu28XYx77wXy0
         FVkw==
X-Gm-Message-State: AFqh2krixQD9JriiWIRymTF4SRr5o3TjX9A0eqIv1qbsiSHCQ8FKngiD
        x5GZaaYcJKKn7eQI66cKbZode62H7Io=
X-Google-Smtp-Source: AMrXdXtLXakFl2wuP2Q7vt4kLGf3IjnXaEclRh97ndKJsjuFnaymJGC4R9BorW9oWQoHTTkfrJLh8g==
X-Received: by 2002:a17:906:78c:b0:7ad:e52c:12e6 with SMTP id l12-20020a170906078c00b007ade52c12e6mr45018515ejc.41.1672947428762;
        Thu, 05 Jan 2023 11:37:08 -0800 (PST)
Received: from ?IPV6:2a01:c22:6f70:be00:e858:2f7f:ab42:ac0? (dynamic-2a01-0c22-6f70-be00-e858-2f7f-ab42-0ac0.c22.pool.telefonica.de. [2a01:c22:6f70:be00:e858:2f7f:ab42:ac0])
        by smtp.googlemail.com with ESMTPSA id u17-20020a1709061db100b0084c70c27407sm11264790ejh.84.2023.01.05.11.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 11:37:08 -0800 (PST)
Message-ID: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
Date:   Thu, 5 Jan 2023 20:37:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20230105180408.2998-1-hau@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
In-Reply-To: <20230105180408.2998-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.2023 19:04, Chunhao Lin wrote:
> rtl8168h has an application that it will connect to rtl8211fs through mdi
> interface. And rtl8211fs will connect to fiber through serdes interface.
> In this application, rtl8168h revision id will be set to 0x2a.
> 
> Because rtl8211fs's firmware will set link capability to 100M and GIGA
> when link is from off to on. So when system suspend and wol is enabled,
> rtl8168h will speed down to 100M (because rtl8211fs advertise 100M and GIGA
> to rtl8168h). If the link speed between rtl81211fs and fiber is GIGA.
> The link speed between rtl8168h and fiber will mismatch. That will cause
> wol fail.
> 
> In this patch, if rtl8168h is in this kind of application, driver will not
> speed down phy when wol is enabled.
> 
I think the patch title is inappropriate because WoL works normally on
RTL8168h in the standard setup.
What you add isn't a fix but a workaround for a firmware bug in RTL8211FS.
As mentioned in a previous review comment: if speed on fibre side is 1Gbps
then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP side.

Last but not least the user can still use e.g. ethtool to change the speed
to 100Mbps thus breaking the link.

> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 24592d972523..83d017369ae7 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -1199,6 +1199,12 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>  	}
>  }
>  
> +static bool rtl_mdi_connect_to_phy(struct rtl8169_private *tp)

A comment would be helpful so that a reader of the code knows
what it's good for. A brief description of the non-standard
setup with the internal PHY connected to another PHY in media
converter mode would be good.

> +{
> +	return tp->mac_version == RTL_GIGA_MAC_VER_46 &&
> +		tp->pci_dev->revision == 0x2a;
> +}
> +
>  static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
>  {
>  	switch (tp->mac_version) {
> @@ -2453,7 +2459,8 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
>  		rtl_ephy_write(tp, 0x19, 0xff64);
>  
>  	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> +		if (!rtl_mdi_connect_to_phy(tp))
> +			phy_speed_down(tp->phydev, false);
>  		rtl_wol_enable_rx(tp);
>  	}
>  }

