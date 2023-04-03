Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B326D5376
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjDCVZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjDCVZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:25:33 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5764C21;
        Mon,  3 Apr 2023 14:25:24 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i5-20020a05600c354500b003edd24054e0so20657468wmq.4;
        Mon, 03 Apr 2023 14:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680557123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIR23tVTvNCqVdOLn9EZ+Au8EAUJ7AiO6u6/9Nuexhc=;
        b=NfT05tNQvxCUfD2aerk9b1zGCfDZSUJHGA9DhvC76SDQcKo2ztcfkMJODvLFwdcGIe
         k37WdPTfn6c1QciK7LFx/Dy9hAEB1Hcu0phVqroV6ZMfpSgDwsCzG9J+vDq3azM6AuGy
         0F2QOD13dz7f4fJwZ9f7CWYiVca8IIYoxec8s2/BoeLNR2sTeI69/Cs+NHv0MGOMTDFd
         wrwEbAIi50OyV1xv1vugxyvWi/Y4RCJxf5p/sm8o5swl+7jvkE41H9i+yzXijUbBZDXF
         9y4Gq45/uIadFK2X/J4Jvjs77il7Z2jrJLkbnkM8kmcWYE1QMifxN81cK4o79m1MtVbH
         H2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIR23tVTvNCqVdOLn9EZ+Au8EAUJ7AiO6u6/9Nuexhc=;
        b=lUPGef08lNnjPRFzm2sngXu/k0HRqit62/QZj8Wb0XQ7DJCGwmMTGoXCmQqM6A6ref
         9f+3QuUG9Rmf2JvqBptASJtwrAX/jyaGRDg57NaeLzSlO/l9k75wHV+aempb2j54VW1D
         h9S/6H7NQYGQn5SrQfqFrkhyE/oC3+s1hFc3Y06N+r/hYpxRcmQbm9l93yxbBGbV3Lg1
         +P18/crZPNeyHJUu8MqZ/VrxBrYncM2cMHK8ouEBSsN1g165G8lCIey/jmV4+aXWl/SG
         Alqa7AzXGGz+AUtudFSK8MJl0Soz4LxAnE2YR/TXp7iFOujEdKOXRhluAcPhwTnkQqGW
         jALA==
X-Gm-Message-State: AAQBX9eVuMZ4pBE44XQHGRUUed+INMhejoB7nCepl0FJbyGrLQv91+7d
        TDIc1svZYo0XPMsbbE5S/fE=
X-Google-Smtp-Source: AKy350bZY6EtR7wvHBKIrt7OS1qjTi8Wveiqtqxq+rdf48JdfURnCCSj2CHGoO8P92DrFcHB1L9uPw==
X-Received: by 2002:a7b:c5cd:0:b0:3ea:d611:f8 with SMTP id n13-20020a7bc5cd000000b003ead61100f8mr531737wmk.38.1680557122734;
        Mon, 03 Apr 2023 14:25:22 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7651-4500-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7651:4500::e63])
        by smtp.googlemail.com with ESMTPSA id g19-20020a05600c311300b003ee74c25f12sm20405564wmo.35.2023.04.03.14.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:25:22 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     michael.wei.hong.sit@intel.com
Cc:     alexandre.torgue@foss.st.com, andrew@lunn.ch,
        boon.leong.ong@intel.com, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, hong.aun.looi@intel.com,
        joabreu@synopsys.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        pabeni@redhat.com, peppe.cavallaro@st.com,
        peter.jun.ann.lai@intel.com, weifeng.voon@intel.com
Subject: RE [PATCH net v5 2/3] net: stmmac: check if MAC needs to attach to a PHY
Date:   Mon,  3 Apr 2023 23:24:34 +0200
Message-Id: <20230403212434.296975-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230330091404.3293431-3-michael.wei.hong.sit@intel.com>
References: <20230330091404.3293431-3-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

[...]
> @@ -1144,10 +1145,11 @@ static int stmmac_init_phy(struct net_device *dev)
>  	if (fwnode)
>  		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
>  
> +	phy_needed = phylink_expects_phy(priv->phylink);
>  	/* Some DT bindings do not set-up the PHY handle. Let's try to
>  	 * manually parse it
>  	 */
> -	if (!fwnode || ret) {
> +	if (!fwnode || phy_needed || ret) {
Unfortunately this breaks Ethernet on my X96 Air board (the .dts file
can be found upstream in:
arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dts)

Working boot-log:
# dmesg | grep dwmac
[    3.699961] meson8b-dwmac ff3f0000.ethernet: IRQ eth_wake_irq not found
[    3.700944] meson8b-dwmac ff3f0000.ethernet: IRQ eth_lpi not found
[    3.707196] meson8b-dwmac ff3f0000.ethernet: PTP uses main clock
[    3.713688] meson8b-dwmac ff3f0000.ethernet: User ID: 0x11, Synopsys ID: 0x37
[    3.720201] meson8b-dwmac ff3f0000.ethernet:         DWMAC1000
[    3.725387] meson8b-dwmac ff3f0000.ethernet: DMA HW capability register supported
[    3.732832] meson8b-dwmac ff3f0000.ethernet: RX Checksum Offload Engine supported
[    3.740301] meson8b-dwmac ff3f0000.ethernet: COE Type 2
[    3.745491] meson8b-dwmac ff3f0000.ethernet: TX Checksum insertion supported
[    3.752504] meson8b-dwmac ff3f0000.ethernet: Wake-Up On Lan supported
[    3.758993] meson8b-dwmac ff3f0000.ethernet: Normal descriptors
[    3.764813] meson8b-dwmac ff3f0000.ethernet: Ring mode enabled
[    3.770629] meson8b-dwmac ff3f0000.ethernet: Enable RX Mitigation via HW Watchdog Timer
[   13.565781] meson8b-dwmac ff3f0000.ethernet end0: renamed from eth0
[   14.036061] meson8b-dwmac ff3f0000.ethernet end0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   14.255617] meson8b-dwmac ff3f0000.ethernet end0: PHY [mdio_mux-0.0:00] driver [RTL8211F Gigabit Ethernet] (irq=33)
[   14.265404] meson8b-dwmac ff3f0000.ethernet end0: No Safety Features support found
[   14.267977] meson8b-dwmac ff3f0000.ethernet end0: PTP not supported by HW
[   14.275723] meson8b-dwmac ff3f0000.ethernet end0: configuring for phy/rgmii-txid link mode
[   17.394262] meson8b-dwmac ff3f0000.ethernet end0: Link is Up - 1Gbps/Full - flow control rx/tx

Non-working boot-log:
# dmesg | grep dwmac
[    3.730072] meson8b-dwmac ff3f0000.ethernet: IRQ eth_wake_irq not found
[    3.731053] meson8b-dwmac ff3f0000.ethernet: IRQ eth_lpi not found
[    3.737303] meson8b-dwmac ff3f0000.ethernet: PTP uses main clock
[    3.743795] meson8b-dwmac ff3f0000.ethernet: User ID: 0x11, Synopsys ID: 0x37
[    3.750311] meson8b-dwmac ff3f0000.ethernet:         DWMAC1000
[    3.755498] meson8b-dwmac ff3f0000.ethernet: DMA HW capability register supported
[    3.762944] meson8b-dwmac ff3f0000.ethernet: RX Checksum Offload Engine supported
[    3.770412] meson8b-dwmac ff3f0000.ethernet: COE Type 2
[    3.775603] meson8b-dwmac ff3f0000.ethernet: TX Checksum insertion supported
[    3.782615] meson8b-dwmac ff3f0000.ethernet: Wake-Up On Lan supported
[    3.789106] meson8b-dwmac ff3f0000.ethernet: Normal descriptors
[    3.794924] meson8b-dwmac ff3f0000.ethernet: Ring mode enabled
[    3.800738] meson8b-dwmac ff3f0000.ethernet: Enable RX Mitigation via HW Watchdog Timer
[   13.052942] meson8b-dwmac ff3f0000.ethernet end0: renamed from eth0
[   13.594285] meson8b-dwmac ff3f0000.ethernet end0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   13.825578] meson8b-dwmac ff3f0000.ethernet end0: PHY [mdio_mux-0.0:00] driver [RTL8211F Gigabit Ethernet] (irq=33)
[   13.831358] meson8b-dwmac ff3f0000.ethernet end0: no phy found
[   13.836229] meson8b-dwmac ff3f0000.ethernet end0: __stmmac_open: Cannot attach to PHY (error: -19)

Reverting this patch fixes that problem.

I think the reason is a logic error in the patch:
As you can see the PHY is found and attached (my understanding is
that this happens through phylink_fwnode_phy_connect()). But we now
also go to that if block below even fwnode != NULL && ret == 0 (which
indicates that phylink_fwnode_phy_connect() was successful). Inside
that if block priv->plat->phy_addr then has the default value (-1)
that was set in stmmac_probe_config_dt().

I am running out of time for today. Could you please look into this
and follow up with a patch (on top of this one, as this one has
already been applied) that considers your original issues as well as
the case of my board (I suspect that all Amlogic boards that are
supported upstream are affected)? Please keep me Cc'ed so I can test
your additional patch and then add my Tested-by.


Thank you!
Martin
