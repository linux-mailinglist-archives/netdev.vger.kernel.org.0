Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCA839BA6F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFDODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 10:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFDODy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 10:03:54 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281E2C061766;
        Fri,  4 Jun 2021 07:01:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b11so11292545edy.4;
        Fri, 04 Jun 2021 07:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tr2i7KhaSRVl6BNfUgrjIy56m1Gz6XCmL4WKOFyh1m0=;
        b=VcL/98pe6Ec46brSbqGvfpxM7IS/nirWjIzEOm7++Z+FqL3YIYYqNFQ0EMHGAY8X4G
         jMQI8JEiNyfN8jC9cDkPTCKX8gSSoJLZJWEP72KAJBFdTiaoVkdbG8+vr9+rJOLJWs5N
         IjDXC0V/U9zKrr3O3xih1O5dBKzOANBxnIfFLICdVPembhBlqfG2Hk4H5+wKczAbe7Pt
         b/R2hOK78iZfSvhPVHUVveYf0mYr35eTCVRkgunfm97dZVcAN6jacSFkTTzX6WLg59HC
         woAQjL3+iYId6kx9MY1F8uaWPagOlQu7jpJxaCWtf7l7HqYA67futHv/TwF0vRdQacX5
         JGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tr2i7KhaSRVl6BNfUgrjIy56m1Gz6XCmL4WKOFyh1m0=;
        b=l/BJbGgVbo7ujygzqImhHQxzkv4C08rwA2rYOZWwamvrta14RUR2gLmqoENuxyz1W8
         uU11DopvVU9w/xvHsUP0cVd0aZBKDxRAKXEzgtUxgk/oWp8F6/JZ0Qbq+2k2Hk1/It1T
         I4dthgiDGEP6aAVrgEMrD80GRHThCxds/kNzOXMgDR7bBYB6IpjuL5rfDkZAskZ+lcD6
         mVZL9Gn5hS1FtjEoweJD1aVBPdCpRkJKotm1lOoIydQ6oV4NKMgB81GPLg0ug/8I71PG
         M3NxKR8lsJkXiYy4NZUy66CkyauJiNhnqLwuDDVqfle5ZPpsQzvVnoPh7agzw1DVEt2j
         7+oA==
X-Gm-Message-State: AOAM533bMWcLaAgs0fF2w7sFGAoann92ItO+piorBUD9wIh4wQSOWnSD
        J+MNIBzfgmjTwswEiFNa3/I=
X-Google-Smtp-Source: ABdhPJyM9Zu4cetw2Jaqh1MmFKx29X158pmqB7nZJWwsgAYnxeJWaWCmU1ES8dbb82cK3vnPG7XxyQ==
X-Received: by 2002:a05:6402:885:: with SMTP id e5mr4942657edy.248.1622815315624;
        Fri, 04 Jun 2021 07:01:55 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a22sm2804513ejv.67.2021.06.04.07.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 07:01:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/4] Convert NXP SJA1105 DSA driver to YAML
Date:   Fri,  4 Jun 2021 17:01:47 +0300
Message-Id: <20210604140151.2885611-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is an attempt to convert the SJA1105 driver to the YAML schema.

The SJA1105 driver has some custom device tree properties which caused
validation problems in the previous attempt:
https://patchwork.kernel.org/project/netdevbpf/patch/20210531234735.1582031-1-olteanv@gmail.com/

So now we are removing them, hoping that this will make the conversion
easier to accept.

In order to do that, we introduce a new PHY interface type, "reverse RMII",
which is like "reverse MII" (aka MII as a PHY) but for the reduced data
width version of the protocol. This is a direct replacement for an rmii
fixed-link. Now, rmii fixed-link interfaces behave as a MAC, and rev-rmii
fixed-link interfaces behave as a PHY.

Vladimir Oltean (4):
  net: phy: introduce PHY_INTERFACE_MODE_REVRMII
  net: dsa: sja1105: apply RGMII delays based on the fixed-link property
  net: dsa: sja1105: determine PHY/MAC role from PHY interface type
  dt-bindings: net: dsa: sja1105: convert to YAML schema

 .../bindings/net/dsa/nxp,sja1105.yaml         |  89 ++++++++++
 .../devicetree/bindings/net/dsa/sja1105.txt   | 156 ------------------
 .../bindings/net/ethernet-controller.yaml     |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  92 ++++-------
 include/linux/phy.h                           |   4 +
 6 files changed, 127 insertions(+), 216 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt

-- 
2.25.1

