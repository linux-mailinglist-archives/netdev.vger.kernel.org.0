Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9051B320DFE
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhBUVgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhBUVff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:35 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB56C061797
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:12 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n20so130943ejb.5
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Usl1rqCbmOEg2pvdQd27xpHlcodyRAZEdfcp9vyKaM8=;
        b=uKXfmdO7v5tynRiQVcfJf59XFi1G2UMTAGvPGArnPeAcGcjlAbpH/pvl9WNagippA9
         WwOYYBdhl0MbKjOqf1vJoxm/HhUEvad713TD0PbJiIjKcQZfojLttY8o/b0jvjNoiI3x
         oT65Vu3jHxZwy7aAfGzqYMW8Xb6M5Zraw3SxA/zTuTNvu6jptpsAlnO7ij1Hp22t8EES
         OqNgBT4dtUi5GtlbGF2eU3qDgtdmC22xiPKGyaaNAxn83L2oUz0+TrYvX1z4WflSXySc
         4poBI+fV+hU29xfivyRKFLBJLxYxphkf/OdoP2DOuaZ370Pyi5LMt3QrydW284ZmlIjM
         uLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Usl1rqCbmOEg2pvdQd27xpHlcodyRAZEdfcp9vyKaM8=;
        b=dhmi9K4ybEXlC0TWDZP0mKxrIMXhRIeDYLB/WI1k4LJBLdG8zyGUmONrwfVrob+VgH
         tjaohfsL0rnOeKWnL/Bprh2AjIQQ+yiKTC0o5Bv/3SkaP5erh5h7bGJqYyP7jOQLSrwJ
         k8w9AG0TffGHaF9hbLFv+F8dxYQQgfakG+Pj/Eb2JCJAYMnvSEt43JjANFwzagtX3/O7
         KrrAY/vq+TvJuJlPzlo0Mk60iJI3NgxdHqDG/+fnCTXz8Frw11O6yuDo6d7uVxO/ylo5
         xjy5OdEyL38SwGdfrbs/R9k6URCEUc60mHlmsc12jCt8oVb4jNTSdI7oiedW0+ZLRS3s
         VhNA==
X-Gm-Message-State: AOAM533PZnmTpE7TlOK1n7jWVbq5ahSAvQtAFJjZ+qoZ1/TjE3fMDmOJ
        6PoncrqeRd/X+e2Bgvs+Q3zCWB9qedM=
X-Google-Smtp-Source: ABdhPJxJPUODwF0gH0LfZrROO4rmpRRQDz+J+jpVwIl3JSe0B5Ju8uGcuMRsl0Jcdl0N7wuQItowHQ==
X-Received: by 2002:a17:906:4e1a:: with SMTP id z26mr17902658eju.349.1613943251267;
        Sun, 21 Feb 2021 13:34:11 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:10 -0800 (PST)
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
Subject: [RFC PATCH net-next 06/12] Documentation: networking: dsa: document the port_bridge_flags method
Date:   Sun, 21 Feb 2021 23:33:49 +0200
Message-Id: <20210221213355.1241450-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
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
---
 Documentation/networking/dsa/dsa.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 19ce5bb0a7a4..3c6560a43ae0 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -597,6 +597,17 @@ Bridge layer
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
+  CPU port, and flooding towards the CPU port should also be enabled, in lack
+  of an explicit address filtering mechanism in the DSA core.
+
 Bridge VLAN filtering
 ---------------------
 
-- 
2.25.1

