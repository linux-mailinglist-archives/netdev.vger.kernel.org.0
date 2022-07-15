Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815165765D9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbiGORYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiGORYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:24:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5211564ED;
        Fri, 15 Jul 2022 10:24:49 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w12so7119861edd.13;
        Fri, 15 Jul 2022 10:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uzkdv8Dc9Ar4VBcn4GaayOprsDjBshT27fyNEPPxRGo=;
        b=JUwWMv0ZzCp2g0wjmfhiQKPpxgYLDVk8Bg2DyDo9Nv2vPSfd4QlapKyKP8FZdKkrFc
         7eERvbWxPsVlaTQHmvMnihm8UJCfDaon/IhDJ8mvs6GITYempO4YeZ1VtXWCAuoagOLv
         04kwSfFeHfEoT/OCXdSWWkEcjSqjW188bJ9P0NEkeOEl+xrSTHN4CtXpYHNDWUBbLpxO
         YD8S2ulqe8kgtWrzgGCR/v0e9vq97PtpYq0TKnQmouIaPzHtQqB7Wf4vDH6PqEoZ/T3a
         OWjGLeSDymCeGZusix2ILZHOmKUODHHj7EEle1ll1IaHPOcgkO2XQwId7AHbJu5Mnq7G
         CKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uzkdv8Dc9Ar4VBcn4GaayOprsDjBshT27fyNEPPxRGo=;
        b=H2xmzqhW9hGRIthOQGOGpq3K19Pn+FxpIR9y6xKidDePlYCpLpabOL+k7DZDim6trd
         ZfiWBKNNbp73Y9wOF582D6zKOAduWFwOxmJ49yJNwUdf7qTiv9DyeVef+mSbj7UETrH7
         BZOXJLh9TJl68gqoqgsYT4M/ihCfKvS5TB+UwtRiMfGjdBsBXajoP3aBSUeum1SbZHlL
         iSD4JTXej5Rw8+HVmmNdFEAzDSZAisceUkxO7XVHHjBKXo5DWcZeIg/y3Ld5LbQF++ml
         F/sM0sQWLjnM6z8Li3CKGT3OiwtKEHwTtJQVqbSyKkqri9Jm3m483d1T/XKToaxPhblP
         iV0A==
X-Gm-Message-State: AJIora+EMatIYa7EXy3xq68CylQG/qiNLq9AcuogvVMLeprp9wwOLFxR
        4xupJt7HXxJ6s9DSZb83OMk=
X-Google-Smtp-Source: AGRyM1vuepFFiSFjYf3MRujnZNcXH+xzL522xFIr0DTGyEcuYI+92aAtZbe7Ugkj9wCdR0bqIYTxKw==
X-Received: by 2002:a05:6402:2802:b0:43a:9098:55a0 with SMTP id h2-20020a056402280200b0043a909855a0mr20176419ede.179.1657905888078;
        Fri, 15 Jul 2022 10:24:48 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id fu20-20020a170907b01400b0072af2460cd6sm2228086ejc.30.2022.07.15.10.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 10:24:47 -0700 (PDT)
Date:   Fri, 15 Jul 2022 20:24:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220715172444.yins4kb2b6b35aql@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:01:37PM +0100, Russell King (Oracle) wrote:
> DSA port bindings allow for an optional phy interface mode. When an
> interface mode is not specified, DSA uses the NA interface mode type.
> 
> However, phylink needs to know the parameters of the link, and this
> will become especially important when using phylink for ports that
> are devoid of all properties except the required "reg" property, so
> that phylink can select the maximum supported link settings. Without
> knowing the interface mode, phylink can't truely know the maximum
> link speed.
> 
> Update the prototype for the phylink_get_caps method to allow drivers
> to report this information back to DSA, and update all DSA
> implementations function declarations to cater for this change. No
> code is added to the implementations.
> 
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
(...)
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index b902b31bebce..7c6870d2c607 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -852,7 +852,8 @@ struct dsa_switch_ops {
>  	 * PHYLINK integration
>  	 */
>  	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
> -				    struct phylink_config *config);
> +				    struct phylink_config *config,
> +				    phy_interface_t *default_interface);

I would prefer having a dedicated void (*port_max_speed_interface),
because the post-phylink DSA drivers (which are not few) will generally
not need to concern themselves with implementing this, and I don't want
driver writers to think they need to populate every parameter they see
in phylink_get_caps. So the new function needs to be documented
appropriately (specify who needs and who does not need to implement it,
on which ports it will be called, etc).

In addition, if we have a dedicated ds->ops->port_max_speed_interface(),
we can do a better job of avoiding breakage with this patch set, since
if DSA cannot find a valid phylink fwnode, AND there is no
port_max_speed_interface() callback for this driver, DSA can still
preserve the current logic of not putting the port down, and not
registering it with phylink. That can be accompanied by a dev_warn() to
state that the CPU/DSA port isn't registered with phylink, please
implement port_max_speed_interface() to address that.
