Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4892C3B31D4
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhFXO6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhFXO6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:58:05 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008B7C061756;
        Thu, 24 Jun 2021 07:55:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h2so8985873edt.3;
        Thu, 24 Jun 2021 07:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5nz3mZ/tDad88qOzTDjkrEglckpTIkuvEHPec0y3JGo=;
        b=qgrI/o/QfFxa1DPd+80KvLmOprNKMnwSUeQu791eslyBFIqICKkEYnchqZCrsHeZGZ
         BtKVfTdngkDc/tKwhfQiktbSBL7miIp6mFjE0PjWwoqdHB9tJ/AyBRvymmQIRO9CEt/v
         9Vkm+K6rrXIV1vhTOptSPOX+NV1zSza4GXilKV2xCkJ5HmQiJLo181DsEtl+sDtPuqrf
         BSTo6oXq+gDhBUpADKN9rMZz+RwRJws9jmGREt3xLKWZxU/N1ItfATIfF2D3aJqFEFh+
         8WfKisLTO4a6DguCottrVwuGwYr2ZSgagNHSkPu+VarMt7ZipfFS/fXsFDExF09VZHZD
         FlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5nz3mZ/tDad88qOzTDjkrEglckpTIkuvEHPec0y3JGo=;
        b=d/4Pt/sfahOK1bShaLC/lhzuOX+aYDLdPB0i/flPxem3sdbzfAIXvi+MEGXD0+W6pL
         5k3+dJwrWrYhsZGSuNOzhuOYOo5HR8v48VaSjIrojo6aJNyPjqAU0kuaNknCCuWgVFbH
         /J23n8QoD6wffE8hvlH6Jb1mf1ftxvbbHOqmVJe73zUcRBHi1I1P7fI/zN0FLYWGVq8r
         H7pAkmIhwnKgs2bXKOfQXp+F0WqIKZp22m8Q8z/12dI9jvbiG+SzoTiU7XR6ID6rbwTA
         7U0JUA7vMG2S2aJKlAjihJ2jz36ebRVmtuPXQINywlIuKFhnU7bCpGF5b8tBirMgTZQD
         6bmQ==
X-Gm-Message-State: AOAM533abGblcKFUte1y8UVpKvN4FIRTeGlTOOqzXmA5zVUinjSTZC/D
        RODqJuuj4tbvpp/vZOGGj0A=
X-Google-Smtp-Source: ABdhPJy8f6xkx4t3REx+k7rGpqUIcuCwzjS47t2alum/EPXRJ6yRw/9BJ2eaVVYeNOh92XicsteH9A==
X-Received: by 2002:aa7:cac9:: with SMTP id l9mr7620704edt.373.1624546543594;
        Thu, 24 Jun 2021 07:55:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id n2sm2034061edi.32.2021.06.24.07.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:55:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] Documentation: net: dsa: add details about SJA1110
Date:   Thu, 24 Jun 2021 17:55:23 +0300
Message-Id: <20210624145524.944878-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210624145524.944878-1-olteanv@gmail.com>
References: <20210624145524.944878-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Denote that the new switch generation is supported, detail its pin
strapping options (with differences compared to SJA1105) and explain how
MDIO access to the internal 100base-T1 and 100base-TX PHYs is performed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/sja1105.rst | 61 ++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 7395a33baaf9..da4057ba37f1 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -5,7 +5,7 @@ NXP SJA1105 switch driver
 Overview
 ========
 
-The NXP SJA1105 is a family of 6 devices:
+The NXP SJA1105 is a family of 10 SPI-managed automotive switches:
 
 - SJA1105E: First generation, no TTEthernet
 - SJA1105T: First generation, TTEthernet
@@ -13,9 +13,11 @@ The NXP SJA1105 is a family of 6 devices:
 - SJA1105Q: Second generation, TTEthernet, no SGMII
 - SJA1105R: Second generation, no TTEthernet, SGMII
 - SJA1105S: Second generation, TTEthernet, SGMII
-
-These are SPI-managed automotive switches, with all ports being gigabit
-capable, and supporting MII/RMII/RGMII and optionally SGMII on one port.
+- SJA1110A: Third generation, TTEthernet, SGMII, integrated 100base-T1 and
+  100base-TX PHYs
+- SJA1110B: Third generation, TTEthernet, SGMII, 100base-T1, 100base-TX
+- SJA1110C: Third generation, TTEthernet, SGMII, 100base-T1, 100base-TX
+- SJA1110D: Third generation, TTEthernet, SGMII, 100base-T1
 
 Being automotive parts, their configuration interface is geared towards
 set-and-forget use, with minimal dynamic interaction at runtime. They
@@ -579,3 +581,54 @@ A board would need to hook up the PHYs connected to the switch to any other
 MDIO bus available to Linux within the system (e.g. to the DSA master's MDIO
 bus). Link state management then works by the driver manually keeping in sync
 (over SPI commands) the MAC link speed with the settings negotiated by the PHY.
+
+By comparison, the SJA1110 supports an MDIO slave access point over which its
+internal 100base-T1 PHYs can be accessed from the host. This is, however, not
+used by the driver, instead the internal 100base-T1 and 100base-TX PHYs are
+accessed through SPI commands, modeled in Linux as virtual MDIO buses.
+
+The microcontroller attached to the SJA1110 port 0 also has an MDIO controller
+operating in master mode, however the driver does not support this either,
+since the microcontroller gets disabled when the Linux driver operates.
+Discrete PHYs connected to the switch ports should have their MDIO interface
+attached to an MDIO controller from the host system and not to the switch,
+similar to SJA1105.
+
+Port compatibility matrix
+-------------------------
+
+The SJA1105 port compatibility matrix is:
+
+===== ============== ============== ==============
+Port   SJA1105E/T     SJA1105P/Q     SJA1105R/S
+===== ============== ============== ==============
+0      xMII           xMII           xMII
+1      xMII           xMII           xMII
+2      xMII           xMII           xMII
+3      xMII           xMII           xMII
+4      xMII           xMII           SGMII
+===== ============== ============== ==============
+
+
+The SJA1110 port compatibility matrix is:
+
+===== ============== ============== ============== ==============
+Port   SJA1110A       SJA1110B       SJA1110C       SJA1110D
+===== ============== ============== ============== ==============
+0      RevMII (uC)    RevMII (uC)    RevMII (uC)    RevMII (uC)
+1      100base-TX     100base-TX     100base-TX
+       or SGMII                                     SGMII
+2      xMII           xMII           xMII           xMII
+       or SGMII                                     or SGMII
+3      xMII           xMII           xMII
+       or SGMII       or SGMII                      SGMII
+       or 2500base-X  or 2500base-X                 or 2500base-X
+4      SGMII          SGMII          SGMII          SGMII
+       or 2500base-X  or 2500base-X  or 2500base-X  or 2500base-X
+5      100base-T1     100base-T1     100base-T1     100base-T1
+6      100base-T1     100base-T1     100base-T1     100base-T1
+7      100base-T1     100base-T1     100base-T1     100base-T1
+8      100base-T1     100base-T1     n/a            n/a
+9      100base-T1     100base-T1     n/a            n/a
+10     100base-T1     n/a            n/a            n/a
+===== ============== ============== ============== ==============
-- 
2.25.1

