Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388C44DCC9F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbiCQRih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiCQRig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:38:36 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99DA21A8B8
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:37:19 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so7278357oos.9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UxfkyqN39/+bak5fA+jCQ155m49ZGPHNTkFPSIDrqtU=;
        b=iTiC/r5Pp/bXQFGldR0YtD4ajdTo6UbIGSeiqaaCjRsA5DZ/dJpOIMK+xDmyZVM3N9
         nvG4sAth4FvuxGBTGeiFKNoNS9HerclAFObGhzOLG1UJFb3aE5Esn7sKoic3Q3BtenCH
         2WMI1XMazh1aTMTDxt5W4RXiKaHrThy2HsPb0fqYYgSIItfWzDGPrGJaNz4II2fTy0qZ
         mvaNDSdaY9FOj3AnHQohokh3ElOtwrpbblBTMwNvwu38VOdBcMl0u8VGE45oaKJML1gN
         +r3ufbpvYS89z5oZCKSufzfF/dDjusxIVvIQESeM4/tTsP2HbM0FFhtuj75sooRg6JtN
         tJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UxfkyqN39/+bak5fA+jCQ155m49ZGPHNTkFPSIDrqtU=;
        b=Frpc8cGUPFshhP+DL4grjAW7h6DsPSMwa4LYexMiCd2cHoA9faVelNsWCM993lO0aw
         qTEGM675xySEtM5JUToylfUICrcKiiRykx3eFEz229BRbp/5o8d9hi9kUS2HxKdNywo+
         Kpk5W6CQ+y52tw4vy84Ry2JdzbUlgwPNSscpAo2ApTx7T72qKd1C2ReYYcZgSU1v7IoT
         RNN99nit4KSEQwYdX06guq8V2943AIbWbuurfdsOCvO8wA1w9Jl2MP3N1w1h8BUrcQPN
         RZTvQhMhrC8dC5bfiqHYrMBJ3NG7ZWGiBkt78vNvYw90wYCyUN7Qlb8XDukRZOdo0v70
         Am9g==
X-Gm-Message-State: AOAM532+N1FMypEPOACHUSpkSqOP5hOznJugrQKC21o/bb6h6TU/p4Za
        3CChoVrfsaMHyceRrwCXL5abhVJ22pxsQU84piI8sg==
X-Google-Smtp-Source: ABdhPJwU7VqrHzhpZmDODH+uRH4Qu1Gsv0f7FRy9B+8v9DfWHLEqm/1RbaZQph4Ts1jqk7oYTfMzvJVmWS/Epsg6VjU=
X-Received: by 2002:a4a:3c47:0:b0:320:f0d5:25a7 with SMTP id
 p7-20020a4a3c47000000b00320f0d525a7mr1758400oof.58.1647538639136; Thu, 17 Mar
 2022 10:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220316075707.61321-1-andy.chiu@sifive.com> <1be44aa629465d0cb70ec26828bf70f83d55f98f.camel@calian.com>
In-Reply-To: <1be44aa629465d0cb70ec26828bf70f83d55f98f.camel@calian.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Fri, 18 Mar 2022 01:37:08 +0800
Message-ID: <CABgGipU3n8g750kQj3ZgoMwXOLQAsM5d+HDRBWoiGEcZ9-uCSw@mail.gmail.com>
Subject: Re: [PATCH] net: axiemac: initialize PHY before device reset
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        radhey.shyam.pandey@xilinx.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for pointing that out.

Though it is weird, it should be safe to do that. The reset of the
MDIO interface would not affect any r/w through the bus afterwards
since the driver would re-initialize the MDIO interface whenever it
uses `mdiobus_write()` or `mdiobus_read()` for bus transactions.
However, some of the very first packet on the rx side might get
processed incompletely since `phylink_of_phy_connect()` will
eventually call `phy_resume()`, which brings the phy active earlier
than the reset of the core.

The reason why we have this change in ordering is that the clock of
our PCS/PMA PHY is sourced from the SGMII ref clock of the external
PHY, which is not enabled by default. The only way to get the PCS/PMA
PHY stable here is to start the clock (initialize the external PHY)
before the reset takes place. We have limited clock sources on the
vcu118 FPGA board, and this happens to be our way to configure it. I
think it is a hack on both sw and hw, but still wonder if anyone under
such hw configuration, if exist, would like to have the patch.

               |<---ref clock-----|
+----------+---^---+         +------+
| Xilinx's |  PCS/ |         | Ti's |
| Ethernet |  PMA  |--SGMII--| PHY  |
|          |  PHY  |         |      |
+----------+-------+         +------+
      |--------|--- MDIO---------|

loop-in: radhey.shyam.pandey@xilinx.com

Andy


Andy
