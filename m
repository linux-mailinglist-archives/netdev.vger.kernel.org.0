Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC2320E02
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBUVhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhBUVfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:40 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDEAC0617AB
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id g5so26132881ejt.2
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkeIZN6BvC8G7vw9Xk24CHI2DtH74P7wJKSIqfDVoRc=;
        b=NRcJgBNrKZSy0AMF/sOoLTQ7vGdlduK6aFw1Lz01EWGy+3pt+x/vFWbn5KxO7gi4kb
         9dXtxVkmunAZOBGEV3e+gxtuFn8nrc8IxcuhCuzhKe6yhGeW+t30oFmR/G8OgqcQAKGR
         7Buppp9+eR5EK9JYP8mxCUl3WSbDlr7egySDlxPYE+ad3k0/ZAzge/6xS80AvzFmp8Zb
         6D1BLNoQtuIQpXDNwIQyRtkI+6+Zuw+TdMbdMOA3tRIHI+1A2Lf7Vh1FoSJhDvp4tVWv
         kx3LdwcOmuM9YABCpeuTo3cvqf7mZx/IeDHxQzDQV9yhKtxr9tdjhghU3GeHB9zeDlG3
         zWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkeIZN6BvC8G7vw9Xk24CHI2DtH74P7wJKSIqfDVoRc=;
        b=n98y75BbRBxRCZe4yGT90e9vNbJiBPoXktuW8X0Yq4ddbhsDKSTE8/sjyXIPqs/Fi8
         yg9O+LwCxMGrejT7IuW6CAefxiPdjJdGDaWKJClOa31ccVi2RSdTSe+FAZjUdDtZaDRA
         cLiPYn4VXNOIF7NQSmCh+jGHW/dGHaH6XyTxTe4KED9MmxrOIijoeKHEkpMQiXvhkA6W
         9NLpfust+aTBUuOuGwYC70A8JH9TREPl9MRHkYyzD6TWcEXlY+5IEc9S7CimhbpWY3AS
         6AJ/f/yS676B3pVmIS+9C2WFt97hh4O/WtqJ0Ij0DPyrT0lXDovqn0N1YFMS3IzNdNdX
         FJBg==
X-Gm-Message-State: AOAM532r2RTq4OV1B4w419wFOyJFwSQRyY8o4ByTYo6LbNlENgwEADtg
        fmLcWYQaCNAPkWPC3U4O8ZHr9O2uBCo=
X-Google-Smtp-Source: ABdhPJw5QP0TC9zPjdbGAocgM2Nzu0rm81Y7IX9QZiCnr3guK4/BNafPwsuurM0yTOXVYaF0o0yr9w==
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr17488154ejk.538.1613943255144;
        Sun, 21 Feb 2021 13:34:15 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 10/12] Documentation: networking: dsa: add paragraph for the HSR/PRP offload
Date:   Sun, 21 Feb 2021 23:33:53 +0200
Message-Id: <20210221213355.1241450-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add a short summary of the methods that a driver writer must implement
for offloading a HSR/PRP network interface.

Cc: George McCollister <george.mccollister@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index bf82f2aed29a..277045346f3a 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -760,6 +760,38 @@ to work properly. The operations are detailed below.
   which MRP PDUs should be trapped to software and which should be autonomously
   forwarded.
 
+IEC 62439-3 (HSR/PRP)
+---------------------
+
+The Parallel Redundancy Protocol (PRP) is a network redundancy protocol which
+works by duplicating and sequence numbering packets through two independent L2
+networks (which are unaware of the PRP tail tags carried in the packets), and
+eliminating the duplicates at the receiver. The High-availability Seamless
+Redundancy (HSR) protocol is similar in concept, except all nodes that carry
+the redundant traffic are aware of the fact that it is HSR-tagged (because HSR
+uses a header with an EtherType of 0x892f) and are physically connected in a
+ring topology. Both HSR and PRP use supervision frames for monitoring the
+health of the network and for discovering the other nodes.
+
+In Linux, both HSR and PRP are implemented in the hsr driver, which
+instantiates a virtual, stackable network interface with two member ports.
+The driver only implements the basic roles of DANH (Doubly Attached Node
+implementing HSR) and DANP (Doubly Attached Node implementing PRP); the roles
+of RedBox and QuadBox aren't (therefore, bridging a hsr network interface with
+a physical switch port is not supported).
+
+A driver which is able of offloading certain functions of a DANP or DANH should
+declare the corresponding netdev features as indicated by the documentation at
+``Documentation/networking/netdev-features.rst``. Additionally, the following
+methods must be implemented:
+
+- ``port_hsr_join``: function invoked when a given switch port is added to a
+  DANP/DANH. The driver may return ``-EOPNOTSUPP`` and in this case, DSA will
+  fall back to a software implementation where all traffic from this port is
+  sent to the CPU.
+- ``port_hsr_leave``: function invoked when a given switch port leaves a
+  DANP/DANH and returns to normal operation as a standalone port.
+
 TODO
 ====
 
-- 
2.25.1

