Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF560546F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiJTAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJTAUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:20:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446651119C2;
        Wed, 19 Oct 2022 17:20:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u21so27584313edi.9;
        Wed, 19 Oct 2022 17:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TrtnUYoqGb7+DWIn2wKW0pwAZCgYRtNZjuWHbm+Go84=;
        b=OY/LvWllO+fZ9dwQOFRhMLYn6VokwMtg1IXP7ROc8q55vbXISlaFlm8UnhI78XV8N3
         XB9vmFGITufrK68niyoLSQXN0/ZdUJ2Q1D1BC2uKaWCgRL3Zcau9mWM16I0uf/aYb9o3
         E9VuY0lxsWTFfHYPts66p+QVT1sx0SwZibp9WKHwMMVmyC2sdUCnTr+4Q+J9z8SDrXpa
         /wXxIDUM6JDnd70ENYyvHSbPzAVNojjgRkL34/Y+CH7ry/nlEu+t07kCV56cxSAM42HD
         3kYro3RFmgkTkfQbKVOqxdOhLGlyV0iwpSU07WLxs19jxddcJeoS0GCwLCCG3W4enT6a
         ZO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrtnUYoqGb7+DWIn2wKW0pwAZCgYRtNZjuWHbm+Go84=;
        b=DAx15YRVZlZRyb/qQVILCrOdyq+voYKchZ3hHs+67B+yKbVJmtRzo2xVB3Zq91++A6
         sdUAPe19gMdyPpD3L7j0+ga2XCmNu5vthFUooOpXku/QBfLIa4pnLu4idgW7CbsWJvH9
         G9jknQfe/oMJGCWjTUm1GzfCIoAjUx2s8tM1ZhqF8znUr2k6bLgYLBjFbWYC/dbmS/hb
         HDg0wiVIoab3HFNzEefJl8mu8orN2uxnfwz0FoFwf8ubehDsHslSkMgz5uHJ0JTd/SC7
         KLyEtuMGxoN2hLw5R2G21VLpgRSN2H96G+KU7zWsAeOaOnoXucOqumsrJRyVlF1sFu/V
         3d2g==
X-Gm-Message-State: ACrzQf19vgG4RC1mp8awhoiMuXU2SjH3mlqzCKemd0yso+4RTfPPMQy7
        cjCMv/Z3F9sMYdmHk2gZAk4=
X-Google-Smtp-Source: AMsMyM5C9c+g+OmGV7FCRnwqs1KgsWvYEjxRQRnZtShB9HiGtGC2M+MHR+j/hkNMBB0V4Wp/KSkXCQ==
X-Received: by 2002:a05:6402:2707:b0:45c:d8a3:6cfc with SMTP id y7-20020a056402270700b0045cd8a36cfcmr9920132edd.269.1666225212639;
        Wed, 19 Oct 2022 17:20:12 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906211200b0078ddb518a90sm9427035ejt.223.2022.10.19.17.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 17:20:11 -0700 (PDT)
Date:   Thu, 20 Oct 2022 03:20:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, Bryan.Whitehead@microchip.com,
        edumazet@google.com, pabeni@redhat.com,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next V4] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221020002009.iektjcnov4oyufsk@skbuf>
References: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 11:44:25AM +0530, Raju Lakkaraju wrote:
> +static void lan743x_sgmii_regs(struct net_device *dev, void *p)
> +{
> +	struct lan743x_adapter *adp = netdev_priv(dev);
> +	u32 *rb = p;
> +
> +	rb[ETH_SR_VSMMD_DEV_ID1]                = SGMII_RD(adp, VSPEC1, 0x0002);
> +	rb[ETH_SR_VSMMD_DEV_ID2]                = SGMII_RD(adp, VSPEC1, 0x0003);
> +	rb[ETH_SR_VSMMD_PCS_ID1]                = SGMII_RD(adp, VSPEC1, 0x0004);
> +	rb[ETH_SR_VSMMD_PCS_ID2]                = SGMII_RD(adp, VSPEC1, 0x0005);
> +	rb[ETH_SR_VSMMD_STS]                    = SGMII_RD(adp, VSPEC1, 0x0008);
> +	rb[ETH_SR_VSMMD_CTRL]                   = SGMII_RD(adp, VSPEC1, 0x0009);
> +	rb[ETH_SR_MII_CTRL]                     = SGMII_RD(adp, VSPEC2, 0x0000);
> +	rb[ETH_SR_MII_STS]                      = SGMII_RD(adp, VSPEC2, 0x0001);
> +	rb[ETH_SR_MII_DEV_ID1]                  = SGMII_RD(adp, VSPEC2, 0x0002);
> +	rb[ETH_SR_MII_DEV_ID2]                  = SGMII_RD(adp, VSPEC2, 0x0003);
> +	rb[ETH_SR_MII_AN_ADV]                   = SGMII_RD(adp, VSPEC2, 0x0004);
> +	rb[ETH_SR_MII_LP_BABL]                  = SGMII_RD(adp, VSPEC2, 0x0005);
> +	rb[ETH_SR_MII_EXPN]                     = SGMII_RD(adp, VSPEC2, 0x0006);
> +	rb[ETH_SR_MII_EXT_STS]                  = SGMII_RD(adp, VSPEC2, 0x000F);
> +	rb[ETH_SR_MII_TIME_SYNC_ABL]            = SGMII_RD(adp, VSPEC2, 0x0708);
> +	rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x0709);
> +	rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070A);
> +	rb[ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070B);
> +	rb[ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070C);
> +	rb[ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070D);
> +	rb[ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070E);
> +	rb[ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070F);
> +	rb[ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x0710);
> +	rb[ETH_VR_MII_DIG_CTRL1]                = SGMII_RD(adp, VSPEC2, 0x8000);
> +	rb[ETH_VR_MII_AN_CTRL]                  = SGMII_RD(adp, VSPEC2, 0x8001);
> +	rb[ETH_VR_MII_AN_INTR_STS]              = SGMII_RD(adp, VSPEC2, 0x8002);
> +	rb[ETH_VR_MII_TC]                       = SGMII_RD(adp, VSPEC2, 0x8003);
> +	rb[ETH_VR_MII_DBG_CTRL]                 = SGMII_RD(adp, VSPEC2, 0x8005);
> +	rb[ETH_VR_MII_EEE_MCTRL0]               = SGMII_RD(adp, VSPEC2, 0x8006);
> +	rb[ETH_VR_MII_EEE_TXTIMER]              = SGMII_RD(adp, VSPEC2, 0x8008);
> +	rb[ETH_VR_MII_EEE_RXTIMER]              = SGMII_RD(adp, VSPEC2, 0x8009);
> +	rb[ETH_VR_MII_LINK_TIMER_CTRL]          = SGMII_RD(adp, VSPEC2, 0x800A);
> +	rb[ETH_VR_MII_EEE_MCTRL1]               = SGMII_RD(adp, VSPEC2, 0x800B);
> +	rb[ETH_VR_MII_DIG_STS]                  = SGMII_RD(adp, VSPEC2, 0x8010);
> +	rb[ETH_VR_MII_ICG_ERRCNT1]              = SGMII_RD(adp, VSPEC2, 0x8011);
> +	rb[ETH_VR_MII_GPIO]                     = SGMII_RD(adp, VSPEC2, 0x8015);
> +	rb[ETH_VR_MII_EEE_LPI_STATUS]           = SGMII_RD(adp, VSPEC2, 0x8016);
> +	rb[ETH_VR_MII_EEE_WKERR]                = SGMII_RD(adp, VSPEC2, 0x8017);
> +	rb[ETH_VR_MII_MISC_STS]                 = SGMII_RD(adp, VSPEC2, 0x8018);
> +	rb[ETH_VR_MII_RX_LSTS]                  = SGMII_RD(adp, VSPEC2, 0x8020);
> +	rb[ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0]    = SGMII_RD(adp, VSPEC2, 0x8038);
> +	rb[ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0]    = SGMII_RD(adp, VSPEC2, 0x803A);
> +	rb[ETH_VR_MII_GEN2_GEN4_TXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x803C);
> +	rb[ETH_VR_MII_GEN2_GEN4_TXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x803D);
> +	rb[ETH_VR_MII_GEN4_TXGENCTRL2]          = SGMII_RD(adp, VSPEC2, 0x803E);
> +	rb[ETH_VR_MII_GEN2_GEN4_TX_STS]         = SGMII_RD(adp, VSPEC2, 0x8048);
> +	rb[ETH_VR_MII_GEN2_GEN4_RXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x8058);
> +	rb[ETH_VR_MII_GEN2_GEN4_RXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x8059);
> +	rb[ETH_VR_MII_GEN4_RXEQ_CTRL]           = SGMII_RD(adp, VSPEC2, 0x805B);
> +	rb[ETH_VR_MII_GEN4_RXLOS_CTRL0]         = SGMII_RD(adp, VSPEC2, 0x805D);
> +	rb[ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8078);
> +	rb[ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x8079);
> +	rb[ETH_VR_MII_GEN2_GEN4_MPLL_STS]       = SGMII_RD(adp, VSPEC2, 0x8088);
> +	rb[ETH_VR_MII_GEN2_GEN4_LVL_CTRL]       = SGMII_RD(adp, VSPEC2, 0x8090);
> +	rb[ETH_VR_MII_GEN4_MISC_CTRL2]          = SGMII_RD(adp, VSPEC2, 0x8093);
> +	rb[ETH_VR_MII_GEN2_GEN4_MISC_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8099);
> +	rb[ETH_VR_MII_GEN2_GEN4_MISC_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x809A);
> +	rb[ETH_VR_MII_SNPS_CR_CTRL]             = SGMII_RD(adp, VSPEC2, 0x80A0);
> +	rb[ETH_VR_MII_SNPS_CR_ADDR]             = SGMII_RD(adp, VSPEC2, 0x80A1);
> +	rb[ETH_VR_MII_SNPS_CR_DATA]             = SGMII_RD(adp, VSPEC2, 0x80A2);
> +	rb[ETH_VR_MII_DIG_CTRL2]                = SGMII_RD(adp, VSPEC2, 0x80E1);
> +	rb[ETH_VR_MII_DIG_ERRCNT]               = SGMII_RD(adp, VSPEC2, 0x80E2);

What a nice DesignWare XPCS register layout... Is there any chance the
lan743x driver could use phylink and the XPCS driver from drivers/net/pcs/pcs-xpcs.c?
I'm thinking it would be nice if we could all have access to a register
dump procedure for it somehow.
