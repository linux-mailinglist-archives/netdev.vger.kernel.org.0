Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C3552292
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiFTRDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiFTRDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:03:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548E81AD88;
        Mon, 20 Jun 2022 10:03:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id m14so10275768plg.5;
        Mon, 20 Jun 2022 10:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5nWic3wt4rEd7IHyJHcsCaXRi2cbtwKrH1SqRuKrhdc=;
        b=kwvYpUPndXW4O2AupEGe7zLxqGkuAhPQAcN5LrTQL52C8mHk19AosIUETxNhFV8JDZ
         bf2rs/paLYW+4Yx5CPFN0rDtUQdR7M5+OSkc8OofYTNe2O74AyjnN9ivl+sqOT/ToVmL
         PUbcHLPNbPT9qcm11va4EvnANGXa8sOUfNLRrLG6AZRbZPafQFjs/wguvowxbskOTmBk
         beJZ53mIwy4v8W1zox+c56VOdOVSV7pCzbUQOyiqbti6ajEk7QAKGDyXQky3npiD9GHJ
         vUX/8V87XzvIjE7ZtOkJDkoNfl7LYcsz+xzZzDgWD5540XxL5fACClh4s2fXZIjGzBbC
         chBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5nWic3wt4rEd7IHyJHcsCaXRi2cbtwKrH1SqRuKrhdc=;
        b=MqjDc+vBlS6p61aJ1rdduQAs6ZruGeeyNbSPAgRAgUMwQb1y9LJQGgtAoel3SlPrSF
         Hwjy4AZZ/97+vUHsDl8lEqO7JGpYGqoUiEgshEyw66AddCzg0MaCR2PCwvdWqcW4osmB
         JUC9csrhtwMYKMu+7FiFtzvUPyp7d8IIrOe/jvLEnEx0z/4PvOnub09Tvv4ECEUGez8U
         /lsTMzoClZ6iZ7xWs2xEIIYeWf54Ihka/Uwa4LbGXyeaiGLIewn1KnxdQTMB0yN+L18p
         PygGsg2VKLR9N7FRybrlV7jEj2wStOWujnZWQ21bm/joUuo3uQtI8hUeJmSWQieo54E7
         43uA==
X-Gm-Message-State: AJIora/gSKe6/MefdENlWkI1tnS8Z7Byrh7o7uPUJQfLiTM2w+uNgZle
        R387CzucdGTiiW6sGj9Uv30=
X-Google-Smtp-Source: AGRyM1vLl2wdnVhASKld6HUA6ykav5F5PCXSbDWe1/3AsP2eo47E0cYGdZ98n9DVg5idOW66oGo9Cw==
X-Received: by 2002:a17:902:f688:b0:16a:1dfe:9712 with SMTP id l8-20020a170902f68800b0016a1dfe9712mr8187189plg.112.1655744614735;
        Mon, 20 Jun 2022 10:03:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ja18-20020a170902efd200b001677d4a9654sm2800481plb.265.2022.06.20.10.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 10:03:33 -0700 (PDT)
Message-ID: <c40cc5fb-a84d-23f2-a400-c01b5b419bc9@gmail.com>
Date:   Mon, 20 Jun 2022 10:03:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net] net: phy: smsc: Disable Energy Detect Power-Down in
 interrupt mode
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Simon Han <z.han@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org
References: <439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/22 04:04, Lukas Wunner wrote:
> Simon reports that if two LAN9514 USB adapters are directly connected
> without an intermediate switch, the link fails to come up and link LEDs
> remain dark.  The issue was introduced by commit 1ce8b37241ed ("usbnet:
> smsc95xx: Forward PHY interrupts to PHY driver to avoid polling").
> 
> The PHY suffers from a known erratum wherein link detection becomes
> unreliable if Energy Detect Power-Down is used.  In poll mode, the
> driver works around the erratum by briefly disabling EDPD for 640 msec
> to detect a neighbor, then re-enabling it to save power.
> 
> In interrupt mode, no interrupt is signaled if EDPD is used by both link
> partners, so it must not be enabled at all.
> 
> We'll recoup the power savings by enabling SUSPEND1 mode on affected
> LAN95xx chips in a forthcoming commit.
> 
> Fixes: 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling")
> Reported-by: Simon Han <z.han@kunbus.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>   drivers/net/phy/smsc.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 1b54684b68a0..96d3c40932d8 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -110,7 +110,7 @@ static int smsc_phy_config_init(struct phy_device *phydev)
>   	struct smsc_phy_priv *priv = phydev->priv;
>   	int rc;
>   
> -	if (!priv->energy_enable)
> +	if (!priv->energy_enable || phydev->irq != PHY_POLL)

phy_interrupt_is_valid() may be more appropriate, since you are assuming 
that you either have PHY_POLL or valid "external" PHY interrupt but 
there is also the special case of PHY_MAC_INTERRUPT that is not dealt with.

>   		return 0;
>   
>   	rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> @@ -210,6 +210,8 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
>    * response on link pulses to detect presence of plugged Ethernet cable.
>    * The Energy Detect Power-Down mode is enabled again in the end of procedure to
>    * save approximately 220 mW of power if cable is unplugged.
> + * The workaround is only applicable to poll mode. Energy Detect Power-Down may
> + * not be used in interrupt mode lest link change detection becomes unreliable.
>    */
>   static int lan87xx_read_status(struct phy_device *phydev)
>   {
> @@ -217,7 +219,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
>   
>   	int err = genphy_read_status(phydev);
>   
> -	if (!phydev->link && priv->energy_enable) {
> +	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {

phy_polling_mode()?

>   		/* Disable EDPD to wake up PHY */
>   		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
>   		if (rc < 0)


-- 
Florian
