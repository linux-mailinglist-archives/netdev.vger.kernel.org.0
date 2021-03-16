Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB6933D2F2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhCPLZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhCPLYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BADC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dm8so21050029edb.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WpW69oiat4AL/7w4xQSBuoH/oWbmSWU7a7v5E8qqiQ=;
        b=CMjDT384YMzd4wobuTGXuKG0PgXxyiaBEXNvJCVINBKhW1HdSbH8k57W1H4Ew6GQrk
         8tEZ+6b613kyeMifInEqRZ9m3sMT0zVrzM8yUQaEO2ZZOYw3LyXQlWIsGDQJ8Vgpx+tO
         FK821w2b/wAjmsuoZh4TqYVInTQsQKWil91RWE8bKl2EPTGhvMcj2ZRWPHfv61fglhCA
         N4MUK8Lq9rkNDYtgRp6C4i7otoJvttEta1H7KMeFH6rBg2ZQO1ZPyP6RAXllK0tuPob8
         q7Z+XaDIOAy+RS8d32+KiQ1x4dmXJWOUpKdsGTD4o+1bDzZTXTDhiGnt+8Nw+dc6Zadn
         3jww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WpW69oiat4AL/7w4xQSBuoH/oWbmSWU7a7v5E8qqiQ=;
        b=pF9OYLoIVJsMEvsiPL9Mz72qVht96fqs3Cxh7BHuAfFsz3LyYx4jLEndcPZFQSNUpB
         4WEtXwhrMoByvWMAOpcrs6f+LhoIxlyNVHtoYY78iLsgjvJs+FGgFZ83XdUUuhdxs0sB
         E9W+MeVOVUcdLDWjAnkbNhhGkOebRIPc6aRCnxf/27DTuZpSnJXtZcw1VZWYIumzowB2
         OgaUjlbLlsFWtIgKh6bpRNFwGTpZFTxXusUWih6tO6q0+pi6UF6BTfkRQBO6zE2SKAY7
         7SoeOlpv7LP8cL4z/5Md5NFN+V7MoSqc9i09O+aEcu9IVdTARwF1r9pqsw3yP02YWswB
         zR4g==
X-Gm-Message-State: AOAM530aSdR27xYL9RGKVfLdwT4pGRV2BPQwWW0RbekWq730mBZI43dK
        qrJOoOzRMqa4vKscyUB5wxgEW5AileQ=
X-Google-Smtp-Source: ABdhPJzE6fidlH8F/qPlZrg7JVftCcYvAmknxOfbEh8tIK4GouNtgSDoLR4QWV6ww/ODfEjx75qezg==
X-Received: by 2002:aa7:db01:: with SMTP id t1mr35605918eds.77.1615893876828;
        Tue, 16 Mar 2021 04:24:36 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 10/12] Documentation: networking: dsa: add paragraph for the HSR/PRP offload
Date:   Tue, 16 Mar 2021 13:24:17 +0200
Message-Id: <20210316112419.1304230-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add a short summary of the methods that a driver writer must implement
for offloading a HSR/PRP network interface.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: George McCollister <george.mccollister@gmail.com>
---
 Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 0daafa2fb9eb..69040e11ee5e 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -787,6 +787,38 @@ to work properly. The operations are detailed below.
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
+health of the network and for discovery of other nodes.
+
+In Linux, both HSR and PRP are implemented in the hsr driver, which
+instantiates a virtual, stackable network interface with two member ports.
+The driver only implements the basic roles of DANH (Doubly Attached Node
+implementing HSR) and DANP (Doubly Attached Node implementing PRP); the roles
+of RedBox and QuadBox are not implemented (therefore, bridging a hsr network
+interface with a physical switch port does not produce the expected result).
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

