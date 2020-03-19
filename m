Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0BB18C223
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgCSVRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:17:04 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:54485 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSVRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:17:04 -0400
Received: by mail-wm1-f53.google.com with SMTP id f130so3152598wmf.4
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sWyunr+XWtaLEVZTiYx/YNNmEESTYEdODyYWqbvCOSE=;
        b=Q2oZayp73ki/IKu6ki9NwYudLzg+/wQqsLIj6fTNTZHLJekVZr6eNcUii43XPCMamp
         i0z9dcR9bYdeL+WPzIzBuILWpKYqVGeF7WkrD4eE9N4d4fE44u1HZJ9F+0iyjQK6bt53
         lKrbdvj92VnCPFVnXEVzN+uiSVlR7Y2kPMM9mpqjXINwm5klkLcXuRtTn2Durjcpg5oh
         ZdQFkmUbplSWQ+chh10Cy31jCTZIVlOtqKdiy/4MyzNo7I3ugdu9qVIs1d6z6h+cSsYU
         z5vN7uYrpfEQOsfMznRh0l8y58AhnoQ7chS8d02W+uL9x+GZ2W9X4BwgI9izv9SIjDVl
         8i5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sWyunr+XWtaLEVZTiYx/YNNmEESTYEdODyYWqbvCOSE=;
        b=M6HyRMd+AxcXwtrn/Q8FYI10BqhDFL/l4eJXK5+pHuvI6nVbQ1RG6c02Nt/Z9dlqQJ
         wVzlQsp2MfL61qLO3CoDEHqefdCEIRcTKQ3gEqNy4etAvjgdxS1eal2nmn83DidrrIBd
         Xi8mMyvu52KFGxsqPSeOWt01oC6Tj6T+fKsmh/ORUGj0aqVQR1uiHIXzdCFFwbL63zOz
         Mduds3+QzFPHof9kvA6iJ55rgkYJXBkv7I42UHrSSqk1aZRyYhZh/eBmF2SRkN4GpyOa
         Cx+4TN/sgPd3gJXIqTTIBlsefcavgHhA4J1u46Q474l4Mh1Ds9/KpbhTvYYOA6ljTCmQ
         049w==
X-Gm-Message-State: ANhLgQ1CVQFQ3X7rOmpVfrCMm8OJOW0gYh/HK/u9hLnmqYVHdKofnQ/A
        ZcmI4g7MI16KnXacHbvgLgI=
X-Google-Smtp-Source: ADFU+vuTMuR3EBPUlQYeR9fEpKPiTRxPfXx3ShRjnWXkvEEwGxqpf0eIYzneNJxp+Vyn3o7B0qkN+Q==
X-Received: by 2002:a1c:ac88:: with SMTP id v130mr6138648wme.34.1584652622209;
        Thu, 19 Mar 2020 14:17:02 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id l13sm5117655wrm.57.2020.03.19.14.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 14:17:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net-next 0/4] MSCC PHY: RGMII delays and VSC8502 support
Date:   Thu, 19 Mar 2020 23:16:45 +0200
Message-Id: <20200319211649.10136-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series makes RGMII delays configurable as they should be on
Vitesse/Microsemi/Microchip RGMII PHYs, and adds support for a new RGMII
PHY.

Vladimir Oltean (4):
  net: phy: mscc: rename enum rgmii_rx_clock_delay to rgmii_clock_delay
  net: phy: mscc: accept all RGMII species in vsc85xx_mac_if_set
  net: phy: mscc: configure both RX and TX internal delays for RGMII
  net: phy: mscc: add support for VSC8502

 drivers/net/phy/mscc/mscc.h      | 21 +++++++++-------
 drivers/net/phy/mscc/mscc_main.c | 43 +++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 12 deletions(-)

-- 
2.17.1

