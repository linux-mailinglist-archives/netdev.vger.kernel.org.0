Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65F3201AAE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436694AbgFSSsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387625AbgFSSsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:48:01 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1F8C06174E;
        Fri, 19 Jun 2020 11:48:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id v3so3171873wrc.1;
        Fri, 19 Jun 2020 11:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2cQtcf9Cc8HNAYAi/pesxyAz+aCGr3mqS0Z1a/8kPSk=;
        b=s2ywuiTrkygxpYW77F6gJjXn55ULLMhxPLrWqSAIkRhsxo3QVLxhl7SCPKrRKB9l9P
         vbi5VFWykfuyw8nW+YSspOjhrLrxntqE1hlOjE/OmNkOcukyYT1AGzhC3W0zLcp5Sm1B
         flk09jMp0v24XqKiVPc7bVzp30AHl5nO7QhWfQd8/lmVD36TyFLImBTLpFM1IRsJVhBQ
         eoI3qFWXAzbi20HJueI0tK4WHt/B4+ACdblwOsK2ChLJt5zJTy1E2wLcXktS5IH/L1gR
         MS2tS/Ir2WIG/gGDOloHJSrF4raWWBMEzp5Su0lfQU003twRj4SBS6BXvBqv9LNTyRL8
         tK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2cQtcf9Cc8HNAYAi/pesxyAz+aCGr3mqS0Z1a/8kPSk=;
        b=I9pu7UAC5X0yh8+U4qeGtpXEBZuGGiLWTMsNUH/cVpxoAa1qDO8Suxk3g7/1ARl/qH
         CdsSRlu0r26RlERMgU8EVCOGR/xxD0K0vTc4weH89yz72ACi4P5/dc6RN70EBAf16guR
         MQpywFpeOtCCTZmp+CSXcHmm2ZY/wfwThcPd5HORHUn3hnu9RKYGA2k/sg42SZmzfDUI
         I1COhc9qBE5rGZweuQiAh9C9C7HjGcyAAye0GqaBiREFVPaDCrtgsnFPl1qUqH6A3rzk
         g+MdQEiaC4fFRQtmwJoXtnX2MbKBkr3OBD8nNOCNaRey1ATkNduHI4eBMDuEuTuPBvNq
         MoLQ==
X-Gm-Message-State: AOAM530fUak5c6+IWsJhPhh0INFwhldhceub2Nz4axdvA+V9Vo3Z2o2b
        WvtXAFJ1nBELSF6sTOYINzJmAuby
X-Google-Smtp-Source: ABdhPJxWvUUSM6jkoOxj1gwyMDJg2C7DTy8kVRBkR86mNLd2N62xk7TGBbBhBFl0tXD0/2VCkZ97vg==
X-Received: by 2002:adf:f512:: with SMTP id q18mr5949635wro.38.1592592479706;
        Fri, 19 Jun 2020 11:47:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l17sm7283143wmi.3.2020.06.19.11.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 11:47:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Dajun Jin <adajunjin@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH net v2 0/2] net: phy: MDIO bus scanning fixes
Date:   Fri, 19 Jun 2020 11:47:45 -0700
Message-Id: <20200619184747.16606-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series fixes two problems with the current MDIO bus scanning
logic which was identified while moving from 4.9 to 5.4 on devices that
do rely on scanning the MDIO bus at runtime because they use pluggable
cards.

Changes in v2:

- added comment explaining the special value of -ENODEV
- added Andrew's Reviewed-by tag

Florian Fainelli (2):
  of: of_mdio: Correct loop scanning logic
  net: phy: Check harder for errors in get_phy_id()

 drivers/net/phy/phy_device.c | 6 ++++--
 drivers/of/of_mdio.c         | 9 +++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.17.1

