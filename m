Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05B3B294A
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404213AbfINBU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:20:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38130 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404104AbfINBU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 21:20:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id l11so33644361wrx.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 18:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WageKf3tiLcGJXkwuvUwwt6YUOfeHJ5Xny9x7qmZIVc=;
        b=icW7WWIrDxSm8hLk2SfD1Qfyea7ouEHhMDaEJtbJT5Q5dX3ZnuS794iu36yY0o1ZJg
         b0XGfcyYTAUo+JGr+3bbo0DoWTKXm/kjV1R87AW8gTt/JOrC9PJTVu/BuKSIBUgvQ3aB
         IX+1vCPJx0/wPuBQgUtsyhEwAffPQLmxCJJBuRHB9ZJVfo2OlXbabCkyW33ftFPK9DbC
         yIToTygOEdK2sdQYNIW9H7EMTj4wrkNkf7XHgkU0RxBw+chjRBXxt44kzq+2tFLrBnRi
         PwhRJiAklQZQnFz+8Fpjj947OhNf60SRmBgtNrbCxXZXCZTYIpBcvX0AnvuAspdlTcvx
         fR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WageKf3tiLcGJXkwuvUwwt6YUOfeHJ5Xny9x7qmZIVc=;
        b=cNdRTcJpcqqfkZNpIZ5ShV3Flprm4NUSq6A1onC9T39yzsLmUdvib+OPk7fqlOx04U
         K5qgp0UVnBVzLgqb8YdNWgD1XKOqUVfCVJpvxv2BnsgA5xukw2ptfFTMhvWSbh5mOXoU
         cjvdRK18OAN0fI7Mbu29sEZ39+KTF28fML7OoLVvRoOlHSvNOULWM9RoNOTWjGG6WG9q
         rqWoNr3NBeXPFdHW+VoaVRyX6uo4BfybVs2FqAKk99y3mr1GwAvh7XilJZ02Ag0z6u+b
         SCicW6X2R46loy8T3/n2UOYLNGrKHHZJaw9LQPsj5qbODgU2wLfjoCIt32xW34/1QsFX
         CVqg==
X-Gm-Message-State: APjAAAVxbMiByAbWboROjtbQhHTdIx6EP+Jd6tPPpdK3IegbgPFyiUNd
        8aIXm6KfiOSeBHZZLJdxby0=
X-Google-Smtp-Source: APXvYqy2WQiktn1mJlJTERQhoWVxR0iMEQcBJRsVbry04/kRuiTZ+CmDosVlxV9Hhxsw0oshfG5MUA==
X-Received: by 2002:a05:6000:b:: with SMTP id h11mr12097408wrx.270.1568424055376;
        Fri, 13 Sep 2019 18:20:55 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id o14sm21857979wrw.11.2019.09.13.18.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 18:20:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 5/7] net: dsa: sja1105: Make HOSTPRIO a kernel config
Date:   Sat, 14 Sep 2019 04:18:00 +0300
Message-Id: <20190914011802.1602-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190914011802.1602-1-olteanv@gmail.com>
References: <20190914011802.1602-1-olteanv@gmail.com>
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
Changes since v1:
- None.

Changes since RFC:
- None.

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

