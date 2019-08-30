Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1A0A2BA2
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfH3ArK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53203 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfH3ArH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id t17so5496468wmi.2
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WMwdBlNOrBWO77HHiyJpkgNTQOv44nXnUcl235N4nNU=;
        b=Jxgb5feBM1Raul6HIHT7MWMLP3rcvDZy/IP+Dfx7pz+dfGlW3D/eXX4pjoKckRazPj
         GBe9nSglovNaMNNjy+FQdMhU9LhbDa9HZ3DL/toOj1//q2ItCYeCKoQl0snlts1zhujh
         +k0TPhNU4R4P5yaIa52gQNZvwa0uZpIigix088pUc4DQnv10PcZhiw4/w/Pg7kBPQejV
         qKHD15pWZwKIHqJKcGemB9sxvqXIDj74ZHxubMRLIH6u0RbvInIcGwvEo8bY7IYjmE/X
         r5CIwBIGkZ3PxODzdT8TpstHpcnOiReW+vvgfCUKp1WGUYkb8rKk+FXI1PRRk4sNCfYY
         owTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WMwdBlNOrBWO77HHiyJpkgNTQOv44nXnUcl235N4nNU=;
        b=inhgjR4z5oQecsOT/41Xsc1OjtxOf+jEgSknxTVy18r7oUAg0qgzTOfwZTy9eio6Oh
         2g5KuRRMdeoepFoq8+qRwcsw1ApBQCB2Sxzy1P4JXquVLDk2f2Wg0zbcOKGkRt0pY/Up
         oU0cv3SBSbOcXZm0ca1EvMKD4ksgMqtB0rkOamPAlLR0q6d0hkXFsf0DhfkBBf2g4qv3
         1hINGapwmxvzrrfM3B6CcI1Z7QeYL99fiVvH1KdRRU9NnToo8bbUTgqlQw0P+M5c4Jvq
         40aLPGSt4nBL0LBxugqLiTeKiw3CNeAauMl7Ml+ignPAM+IZAKyFqSI9xmYeTXkKu2gS
         hVJA==
X-Gm-Message-State: APjAAAXcJzDQ4SDbC5N3SHcJV9vVE+wxzNYC5dXlV+HefMQBJAP0ROYU
        xbmw2oGXxvzzn6tZ3jLF/po=
X-Google-Smtp-Source: APXvYqxNnypntZ2Sj6sHvwKdzyq/dDnJhsrsq0Xe3sgzIcH3Io/0eDkh2VjNA3xwREPEKMHGEw9JBA==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr14615592wmk.97.1567126025428;
        Thu, 29 Aug 2019 17:47:05 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:47:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 13/15] net: dsa: sja1105: Make HOSTPRIO a kernel config
Date:   Fri, 30 Aug 2019 03:46:33 +0300
Message-Id: <20190830004635.24863-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
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
index 55424f39cb0d..4dc873e985e6 100644
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
index 4b393782cc84..0c03347b6429 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -388,7 +388,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
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

