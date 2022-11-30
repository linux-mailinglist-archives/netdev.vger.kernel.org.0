Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180B463D551
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiK3MQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiK3MQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:16:02 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C292B62D
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:16:01 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d1so26789634wrs.12
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=duZmZFIurozEAQ1bvz5E0UHRAWplyevgCKCKZZqIelo=;
        b=IDLnwkxaWEFt//1+1HJfZQk+XbamYSHxbxN2JNFHHOVFbG4Lrfpt/8/2wtBXXS9IkW
         08uSjrAbTKFoTcWh5ahh7vp4+mghRV5Q3HVbcXUNGlXDlSD/o70/T7jcwTMOEWMIfMJK
         hwVXX2jm8yoY6Z1rgOj19fmDMrsHpv/8kDQeoBlsMMj1lx3qb2X5sMoFjT29BNz6lGsA
         Bd801H7sUdIY90+WmThT69T/GLCefKXbIGyPaHyKsjNWsIihlV/UhHFUISiGjs3pv0BO
         sovs6kC/h37arRJ6P+M6X4a3znnlXKXKBOEzGxbmWeKB+kX6EpdiFstSZwbhyVDx9d0F
         ElAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=duZmZFIurozEAQ1bvz5E0UHRAWplyevgCKCKZZqIelo=;
        b=XJdDfrXqUXw1TNz+pgXTLrPQUgpplyi8Iy6Xe0TNCwIt9QmEI93Ap8RdpVXzEuy9gU
         zKyyvzWjdfEas5vATtpMA9zaSxYXWaOF9Pcu2mW09WlnlQY40ozxvy9uFVFhwj4512+w
         Uf6CePtwJlHeGD1jmy2cl12Nr4DiFP/j2dz1je/cxP5D1t2VAf/VBUDHpYaxtqRrTb0k
         vu9VKxldkuTWUcVlpdeDnFlDy92rV/JO89FCOEHWSWpxXPiipNyUmbRoB9llQ5udUvZW
         Jkw/zFmwQUtoyhiiY4C6bPzLfnXawCLnY+Y5bREZjU09R4TDqmP7GvyieSX7Nqlkm0t/
         aIKQ==
X-Gm-Message-State: ANoB5plrrpvfEIrHI7r5pRCvz6TZ0sF0J4vkR1tNsY4SXoExzHrqL0qa
        LtxSPIi9qsMWQKKDF9D2T8TBzvesBdw3+A==
X-Google-Smtp-Source: AA0mqf7GE3zXSXRhXSZIxpCCSMrl8WRJFLNyPNtkoH/zMjaRJ1YYD8vh6IanL+WJXdjDMjYdqNmXvg==
X-Received: by 2002:a5d:44c8:0:b0:242:2a46:6ff9 with SMTP id z8-20020a5d44c8000000b002422a466ff9mr2058943wrr.371.1669810559835;
        Wed, 30 Nov 2022 04:15:59 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm5795416wmn.47.2022.11.30.04.15.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:15:59 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:16:02 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     netdev@vger.kernel.org
Subject: Help on PHY not supporting autoneg
Message-ID: <Y4dJgj4Z8516tJwx@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev group,
I am looking for someone willing to help me on a problem I encountered
while trying to implement a driver for a PHY that does not support
autoneg. On my reference HW, the PHY is connected to a stmmac via MII.

This is what I did in the driver:
- implement get_features to report NO AN support, and the supported link
  modes.
- implement the IRQ handling (config_intr and handle_interrupt) to
  report the link status

The first problem I encountered is: how to start the PHY? The device
requires a bit (LINK_CONTROL) to be enabled before trying to bring up
the link. But I could not find any obvious callback from phylib to
actually do this. Eventually, I opted for implementing the
suspend/resume callbacks and set that bit in there. Is that right? Any
better option?

With that said, the thing still does not work as I would expect. When I
ifconfig up my device, here's what happens (the ncn_* prints are just
debug prinktks I've added to show the problem). See also my comments in
the log marked with //

/root # ifconfig eth0 up
[   26.950557] socfpga-dwmac ff700000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   26.962673] ncn_soft_reset
[   26.966345] ncn_config_init
[   26.969168] ncn_config_intr
[   26.972211] disable IRQs   // OK, this is expected, phylib is resetting the device
[   26.975062] ncn_resume     // not sure I expected this to be here, but it does not harm
[   26.977746] socfpga-dwmac ff700000.ethernet eth0: PHY [stmmac-0:08] driver [NCN26000] (irq=49)
[   26.986861] ncn_config_intr
[   26.990045] ncn_config_intr ret = 8000, irqs = 0001
[   26.994958] ncn_handle_interrupt 8000
[   26.998941] ncn_handle_interrupt 8001
[   27.002752] link = 1, ret = 0829       // there I get a link UP!
[   27.016526] dwmac1000: Master AXI performs any burst length
[   27.022128] socfpga-dwmac ff700000.ethernet eth0: No Safety Features support found
[   27.029999] socfpga-dwmac ff700000.ethernet eth0: IEEE 1588-2008 Advanced Timestamp supported
[   27.039425] socfpga-dwmac ff700000.ethernet eth0: registered PTP clock
[   27.049388] socfpga-dwmac ff700000.ethernet eth0: configuring for phy/mii link mode
[   27.057155] ncn_resume  // I don't fully understand what happened since the link up, but it seems the MAC is doing more initialization
[   27.061251] ncn_handle_interrupt 8001
[   27.065100] link = 0, ret = 0809 // here I get a link down (???)

From there on, if I read the LINK_CONTROL bit, someone set it to 0 (???)
This bit lies in the control register (Clause 22, address 0).

/root # mdio-tool -i eth0 -r -a 0
clause 22 register @eth0 0x0000 --> 0x0000   // ????? That explains the link down, though

If I manually set the LINK_CONTROL bit, then I magically get the link up

/root # mdio-tool -i eth0 -w -a 0 0x1000
[   81.276504] ncn_handle_interrupt 8001
[   81.280345] link = 1, ret = 0829
clause 22 register @eth0 0x0000 <-- 0x1000[   81.284442] socfpga-dwmac ff700000.ethernet eth0: No phy led trigger registered for speed(10)

/root # [   81.297690] socfpga-dwmac ff700000.ethernet eth0: Link is Up - 10Mbps/Half - flow control off

I've also tried a completely different approach, that is "emulating"
autoneg by implementing the config_aneg, aneg_done and read_status
callbacks. If I do this, then my driver works just fine and nobody seems
to be overwriting register 0.

Any clue on what I might be doing wrong here?

Thank you in advance for any help you might provide.
Regards,
Piergiorgio

