Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E0F33D2E8
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhCPLYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhCPLYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:34 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4310DC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c10so71410078ejx.9
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CpCfl0bYoqF8thfkebTAWyvngGslCFJA8QRSmeXy8FY=;
        b=GnALewWZyYlwLIpd2iHSwMNU+6PMVGXRv54kh4/zE/Gknpg26r01LAhFpsEWOUt1JT
         tu3+79xQKR0f58eP7ZzjPvv3lOMmE6SAFI3auo3Dq6T8fx6NNP8VgqLUCgx+kK+QLdAf
         x6Vq4b9H6A/xf9Qg10fdXZK07iopSxAu4ipf6ilHZylRukeKWrDD/NYC26OX+8oUsDxf
         5CTAi8YXQm/fok2JRbCIKR7l57Yzz8zQd2c9HrM8+E621i9oq8aMvAYwXffhW1jdohUB
         cBfu/RANnGhcGvQMmsI8ESCh/Xam4aRqVAwh5oEkyTGUp3rQC3iYMVvJqfhlpFfpqU14
         XnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CpCfl0bYoqF8thfkebTAWyvngGslCFJA8QRSmeXy8FY=;
        b=Nb0OyyRV+v1Lo4V+c90cAMWuu6A0193c/Y/num6Yl3V72Ofg5TpiWnqLW2r29TQwB3
         GmT516PN/i+yEmq440UkgtSKLK1+zwAeMQMqeUrn4/o8uD6myBs800HTnhe6RmtkTs8C
         iIV5IU4MxPXfifhKVPOfsILCi9NHXjonhTWTk+To0ZrNUeOXX9NP7RcxcfcuykxWHHzL
         DvHdoGx55tzPB9CuSPGaf8hhRFgT96I0k/ivzredGmrFV7VPIfrOjvXBc9C2CXC9Jl1Q
         u9Stmt1JRy6oXmTA9waN4MnurceEQCKh+zpE1YM4Ph6/7SRUDKf74CMKiRfin8OIiMFd
         DmOQ==
X-Gm-Message-State: AOAM5327c3iFbtyaUb8Sdtl3yLVMAI6DzUftarPiD3htqg8W1c8qce4b
        VVPS5CNd5DbsgiWrMjL+jEOErIv7CYw=
X-Google-Smtp-Source: ABdhPJxNFQ3cocJIerukkPp+ayNMdzIbPn5ja4nrwP60B4GELCqTwNCL6vH4fgHUnapfZd3AblqDJw==
X-Received: by 2002:a17:907:9808:: with SMTP id ji8mr29183537ejc.333.1615893872784;
        Tue, 16 Mar 2021 04:24:32 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 06/12] Documentation: networking: dsa: document the port_bridge_flags method
Date:   Tue, 16 Mar 2021 13:24:13 +0200
Message-Id: <20210316112419.1304230-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The documentation was already lagging behind by not mentioning the old
version of port_bridge_flags (port_set_egress_floods). So now we are
skipping one step and just explaining how a DSA driver should configure
address learning and flooding settings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/dsa/dsa.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index b90a852e5329..9c287dfd3c45 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -619,6 +619,17 @@ Bridge layer
   computing a STP state change based on current and asked parameters and perform
   the relevant ageing based on the intersection results
 
+- ``port_bridge_flags``: bridge layer function invoked when a port must
+  configure its settings for e.g. flooding of unknown traffic or source address
+  learning. The switch driver is responsible for initial setup of the
+  standalone ports with address learning disabled and egress flooding of all
+  types of traffic, then the DSA core notifies of any change to the bridge port
+  flags when the port joins and leaves a bridge. DSA does not currently manage
+  the bridge port flags for the CPU port. The assumption is that address
+  learning should be statically enabled (if supported by the hardware) on the
+  CPU port, and flooding towards the CPU port should also be enabled, due to a
+  lack of an explicit address filtering mechanism in the DSA core.
+
 Bridge VLAN filtering
 ---------------------
 
-- 
2.25.1

