Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5AC4AC7C7
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbiBGRlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377034AbiBGR1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:27:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F59C0401D5;
        Mon,  7 Feb 2022 09:27:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cf2so15600654edb.9;
        Mon, 07 Feb 2022 09:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pgxUaFOaYP/VF1UKbR3CFfO2LLqwxcytIuF5DRTGuyg=;
        b=VkJsGQ5HdCahJ7rTPARn6Zpx0H9Gswx84AQDp47qqji95meZql8AF9u4Z7YrPZPETQ
         QoAxBWvFeMOv+r3hz3ejvWKCE3KmR3oUtWh/KCro9fIAxcDpKjESBi7La2tP57CVQpSk
         5iGihLVcyhaMso6tEmxJipRKJ2ccOMpjqGGLW1tkFaJhnJBHB5zJ7XAcTjd3xYTL9xwn
         MUy93w0LfCn9gcY/XOH8PvUF+qkHkhWLWwVr33bbYu+hFPfHNqPzYxOsiOQ9nAM+QJ9Y
         IXL/EsQl5cVbCQ3juTpV+xqJobvkn4EXpCcmIKWPAvdOSL5G4L54/gs9UiQ0r1k/H0Mj
         WeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pgxUaFOaYP/VF1UKbR3CFfO2LLqwxcytIuF5DRTGuyg=;
        b=Cy8VPEVlPc0di+RO5DlSQq1i9MjNoMnvkpPKcGLnXxStsLgopbuoD4ye2G5n60YuJg
         XAlCHpQQY++uzapfe+/BhP7X2GHiLeXGV6EGqnaKzNWMP+y+X/uFGrqMhjb4stnc3tHG
         h6k8yAc8f2aklUgdBk/jywgy6lksOo3EzjySt7KKFLyhKJ+V0O86aGzpQfJooypuLGLn
         Yk3piyGy8r24AmguzsaBtpflTWKN7G0DwK3xPmgjdKwY1ZvpkWMAWMuORvXfBBkWI8Dy
         wVNa3AFm/nYmcAw5p7xoKNIROPIpO/lPQTnEDMOH/i+8GjpuclFvPytT5EmJt2REcVb5
         xlJQ==
X-Gm-Message-State: AOAM531pgpBmjwlrjJ07joeL0hQ9yVkfICl65TK/sVEeZ2nAfm2nFkLi
        LUIJo7cGf71M/9jPt4992wE=
X-Google-Smtp-Source: ABdhPJwlS6KnbE0GJO6PNJcPUf36QAcdY36Ydt1Q/k248onSpOffCg4lNAIsIbuVB1NWWNqiZEsQhg==
X-Received: by 2002:a05:6402:35d4:: with SMTP id z20mr518464edc.13.1644254837145;
        Mon, 07 Feb 2022 09:27:17 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id a11sm5606253edv.76.2022.02.07.09.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:27:15 -0800 (PST)
Date:   Mon, 7 Feb 2022 19:27:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v8 net-next 06/10] net: dsa: microchip: add support for
 phylink management
Message-ID: <20220207172713.efts4o7b7xor37uu@skbuf>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207172204.589190-7-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:52:00PM +0530, Prasanna Vengateshan wrote:
> +static void lan937x_apply_rgmii_delay(struct ksz_device *dev, int port,
> +				      phy_interface_t interface, u8 val)
> +{
> +	struct ksz_port *p = &dev->ports[port];
> +
> +	/* Clear Ingress & Egress internal delay enabled bits */
> +	val &= ~(PORT_RGMII_ID_EG_ENABLE | PORT_RGMII_ID_IG_ENABLE);
> +
> +	if (interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +	    interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +		/* if the delay is 0, let us not enable DLL */
> +		if (p->rgmii_tx_val) {
> +			lan937x_update_rgmii_tx_rx_delay(dev, port, true);
> +			dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
> +				 port);
> +			val |= PORT_RGMII_ID_EG_ENABLE;
> +		}
> +	}
> +
> +	if (interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> +	    interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +		/* if the delay is 0, let us not enable DLL */
> +		if (p->rgmii_rx_val) {
> +			lan937x_update_rgmii_tx_rx_delay(dev, port, false);
> +			dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
> +				 port);
> +			val |= PORT_RGMII_ID_IG_ENABLE;
> +		}
> +	}
> +
> +	/* Enable RGMII internal delays */
> +	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, val);
> +}
> +
> +void lan937x_mac_config(struct ksz_device *dev, int port,
> +			phy_interface_t interface)
> +{
> +	u8 data8;
> +
> +	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> +
> +	/* clear MII selection & set it based on interface later */
> +	data8 &= ~PORT_MII_SEL_M;
> +
> +	/* configure MAC based on interface */
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		lan937x_config_gbit(dev, false, &data8);
> +		data8 |= PORT_MII_SEL;
> +		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		lan937x_config_gbit(dev, false, &data8);
> +		data8 |= PORT_RMII_SEL;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +		lan937x_config_gbit(dev, true, &data8);
> +		data8 |= PORT_RGMII_SEL;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		lan937x_config_gbit(dev, true, &data8);
> +		data8 |= PORT_RGMII_SEL;
> +
> +		/* Apply rgmii internal delay for the mac */
> +		lan937x_apply_rgmii_delay(dev, port, interface, data8);

I think the agreement from previous discussions was to apply RGMII delay
_exclusively_ based on the 'rx-internal-delay-ps' and 'tx-internal-delay-ps'
properties, at least for new drivers with no legacy. You are omitting to
apply delays in phy-mode = "rgmii", which contradicts that agreement.
I think you should treat all 4 RGMII cases the same, and remove the
interface checks from lan937x_apply_rgmii_delay.

> +
> +		/* rgmii delay configuration is already applied above,
> +		 * hence return from here as no changes required
> +		 */
> +		return;
> +	default:
> +		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
> +			phy_modes(interface), port);
> +		return;
> +	}
> +
> +	/* Write the updated value */
> +	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
> +}
