Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BE86BA43D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 01:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCOAq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 20:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCOAq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 20:46:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E143250D;
        Tue, 14 Mar 2023 17:46:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ek18so38123228edb.6;
        Tue, 14 Mar 2023 17:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678841185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTzP8PV/k7hn5ySvaalQhoPOaZQQSzTzzd7nJ9iaxqs=;
        b=KpPDrUhRoylDbLnSBva8ESLP9jKTFaue2Z8EjTuFS5I8DZ20F9M69EDyyuoAuH0eQw
         P0FaahJiMpTcI1chW5eH8YcFd12iprXRM/mgYeVtfNvUARkZvy062mxtMQFbfjUrj5zN
         iqZh3y7XAjhHd/MTRvROd97+j57o0hBuT7B8oL6YfUaNaD+/TGUF9n/NZ9EW+1zXnnd9
         a5H1oTFQtNr7lFq58mv7Vx7y3T5pP20ZSNLz6VbZmPM796KIK/g6kydHbTUCL3tj2jnx
         t/3o8WfeaOJXURu9peymrU+uBbzCoQtcL2NcMbm9e5ds1O03RG8az984KXKSVfSBHQTq
         FRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678841185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTzP8PV/k7hn5ySvaalQhoPOaZQQSzTzzd7nJ9iaxqs=;
        b=tMPnDVlvW441E8c95uPBY4fbvu/1RnRmFBNuaAumcspsHgugVZt0prGqkXBATLF2B9
         6Ln0/cJ5KsxspbmPMMIj/NXkzKKInA5o+rj7o2mY/Av3BrKyr9ibmZkHoN8UZ/bs47gs
         lGYIx+p6AKlPzljaAL92LDoQqAArtWXKm1x5XOJsReR62AgVcNJYcYWl0dUJw/ibj2od
         4XbZorw2rN7P/8wZ6rmAd1Hjwm8jMx7n33nGzV4hN+row74QOK+EpR+lspWyjMhOhuzx
         Jb9Ou3Ga4M+j466PCcMaRrp6gA5b3RwowU2xQMs1bwGp8PmQPEd2VUG3BZvQvgQfNLhW
         NmxA==
X-Gm-Message-State: AO0yUKUz0U9rwxQdzYleodcjDCYw6PdlPou8SSJtM7qRGZWU1EADYIkL
        YUn26j7/0gGe5CQYEoC1Z2g=
X-Google-Smtp-Source: AK7set+Op+PdChW2bk4sM1l0mYPTUdl+5ud49p2zpol3gxJxfY0SezHaCawg78gKlMcKWMF6l9WeaQ==
X-Received: by 2002:a17:906:a450:b0:88d:9cf8:2dbb with SMTP id cb16-20020a170906a45000b0088d9cf82dbbmr4656921ejb.12.1678841184986;
        Tue, 14 Mar 2023 17:46:24 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bt20-20020a0564020a5400b004fb419921e2sm1658450edb.57.2023.03.14.17.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 17:46:24 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:46:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v3 08/14] net: phy: marvell: Implement
 led_blink_set()
Message-ID: <20230315004622.yxhxrslblgxylubd@skbuf>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314101516.20427-9-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:15:10AM +0100, Christian Marangi wrote:
> +static int m88e1318_led_blink_set(struct phy_device *phydev, u32 index,
> +				  unsigned long *delay_on,
> +				  unsigned long *delay_off)
> +{
> +	u16 reg;

Same problem here.

> +
> +	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
> +			     MII_88E1318S_PHY_LED_FUNC);
> +	if (reg < 0)
> +		return reg;
> +
> +	switch (index) {
> +	case 0:
> +	case 1:
> +	case 2:
> +		reg &= ~(0xf << (4 * index));
> +			reg |= MII_88E1318S_PHY_LED_FUNC_BLINK << (4 * index);
> +			/* Reset default is 84ms */
> +			*delay_on = 84 / 2;
> +			*delay_off = 84 / 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return phy_write_paged(phydev, MII_MARVELL_LED_PAGE,
> +			       MII_88E1318S_PHY_LED_FUNC, reg);
> +}
