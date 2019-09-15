Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB2EB2DA6
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 03:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfIOBxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 21:53:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43127 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfIOBxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 21:53:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id q17so30768123wrx.10
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 18:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UPByIG9ljeI4AHFyxF93OHWEpCFk8SqQZODce9qBxIw=;
        b=H7GDhJ6aLmN7FXbYFUIyW6/gBmlRIBdL8Gnw62eQv8zUUaSlDYmsW6N5VBgaualVoM
         bnBywBuo2qB1HpMakQC9upU5x5ispR07pSyLKsslUbIhNBzSWqeLI4VfUyr9ZKa8eSTh
         nv3TEzp/l2c5Fq5VTVvaNVZUkw9773CxKkJmvJsXqoDO8tqjUtZlmPbj64+3lQLkIKmX
         sPfl0/x2FXF0xHsa4SPzYx+AEQmzbEOHcmOjHTCcvYeYOrwZbly8slgJqLBc55cqijWS
         JgUDxanMzHLqgIEAEbYcG3CBYdOX8SDnqYerZNjL51CeQsO8I0w64TAwTS8rv8EgBNQh
         Fdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UPByIG9ljeI4AHFyxF93OHWEpCFk8SqQZODce9qBxIw=;
        b=TMHCJeX75B+cyFs09e9CA61fGwbPy1V5STct5LHuE0GUVi6qQPnS3XBRMtikIiyG8L
         7MqgOf4L82/0YOENZ+dng2PLrni1e0Ve+pCKQd6cZjMn/VK2jZCJlQdwkScQlj4Kq8Gg
         iuCs7z9+tDFLUZdUsJPlhtrq0lJFNruDHP9eMIgpwK8F1bw9iXUeEExujPPSNnt0bNf+
         YpdisKmloVlmToEeMvWapaxDTFpRBLFC8W4nittMr2qu1mA2pbfted2IKkltdKJ5P1iS
         IPPMANjbUQHpQSkc7eQdfe0VJJlt86DVbrwxb0R6RRZiNYGiRXBOwKHYoG5erdKbkxkt
         GVag==
X-Gm-Message-State: APjAAAWtc2qhzSWAlCuAcQ7NFZMHEVRR/ZtxG3Wy7Gd0yglAkRsIwSSA
        ZgWnn0iE87FqCOb0395NJvM=
X-Google-Smtp-Source: APXvYqyPy2KBHgPR/6c3PVSeMvt5q19z6H5ZEfp1lt66oNQZ4oK+zt8WK6FCDjfWr5qBldzvnavwtA==
X-Received: by 2002:a5d:6242:: with SMTP id m2mr7398335wrv.261.1568512426209;
        Sat, 14 Sep 2019 18:53:46 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id p19sm5627044wmg.31.2019.09.14.18.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 18:53:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 5/7] net: dsa: sja1105: Make HOSTPRIO a kernel config
Date:   Sun, 15 Sep 2019 04:53:12 +0300
Message-Id: <20190915015314.26605-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915015314.26605-1-olteanv@gmail.com>
References: <20190915015314.26605-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately with this hardware, there is no way to transmit in-band
QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
class for these is fixed in the static config (which in turn requires a
reset to change).

With the new ability to add time gates for individual traffic classes,
there is a real danger that the user might unknowingly turn off the
traffic class for PTP, BPDUs, LLDP etc.

So we need to manage this situation the best we can. There isn't any
knob in Linux for this, and changing it at runtime probably isn't worth
it either. So just make the setting loud enough by promoting it to a
Kconfig, which the user can customize to their particular setup.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/Kconfig        | 9 +++++++++
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 770134a66e48..e26666b1ecb9 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -17,6 +17,15 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	    - SJA1105R (Gen. 2, SGMII, No TT-Ethernet)
 	    - SJA1105S (Gen. 2, SGMII, TT-Ethernet)
 
+config NET_DSA_SJA1105_HOSTPRIO
+	int "Traffic class for management traffic"
+	range 0 7
+	default 7
+	depends on NET_DSA_SJA1105
+	help
+	  Configure the traffic class which will be used for management
+	  (link-local) traffic sent and received over switch ports.
+
 config NET_DSA_SJA1105_PTP
 	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 108f62c27c28..0b0205abc3d2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -387,7 +387,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		/* Priority queue for link-local management frames
 		 * (both ingress to and egress from CPU - PTP, STP etc)
 		 */
-		.hostprio = 7,
+		.hostprio = CONFIG_NET_DSA_SJA1105_HOSTPRIO,
 		.mac_fltres1 = SJA1105_LINKLOCAL_FILTER_A,
 		.mac_flt1    = SJA1105_LINKLOCAL_FILTER_A_MASK,
 		.incl_srcpt1 = false,
-- 
2.17.1

