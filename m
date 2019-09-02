Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01178A5B5E
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfIBQ03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37496 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBQ0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id d16so15214658wme.2
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FIUwuQaxYMMCuDP1ZPE9jPgGlXe+Gh1QehnDcUb4cwo=;
        b=sDliT576TCiOSlOFmsrW++ZXDvtKd0UnSocqzqzn44JxXWGy0TPFmSNPBaC7KcX7gU
         LleDySut4nwYkb9lMQp2h52tfkXea+tjz6mndDzea4lAmwinE3ImieBaSTrrns9s6QgX
         oZHfN0bmrqxo3fIFRjZ60YIVZViqfcDTXCyuBVpMjY/bAbpUSBnLjroXCvM2MgnBmXRk
         99pwR17kL6vI/voIwiNe3tRvjjzi+AvGwzXM8wQE9DzHmfBPnyr0f1q98TSBP+V+S7HK
         yOrj/4qRKzkeA8zxggQWDOjHFxQVZk67ixjxCJ8KGSdR4PBbOxqTWbXoxq0Qxk7sLxdt
         mpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FIUwuQaxYMMCuDP1ZPE9jPgGlXe+Gh1QehnDcUb4cwo=;
        b=a9n0MPWGOVsSn/4LGZqGwAbBAWm8bZA7nUZagAf1cIebNteNUDsl9vry6Ud+Q1yMMP
         2A14kvJTP4D1Ex8WSKu5xVjeElbuvMMNqAozGmB0E2nhbraSGYG/npRGN6T2fxolQ3Tm
         4LRfO9KVRuzk5P2MFKdhYYYcrtJDkoOOpAnpVPYXmi0jh6ILxNDx6nT9z8MVPl8ReBj+
         OxT6fhUmQ8WOQrcVGImWrAqoWnGOSkdN2LnF4W4xYAcMG5skhd7ATkqn5ruztrLA9KRw
         r9XdN5oajyR5ztHE7kE8Lr2+6sNWzAis0gbIJB61K3BP3ufyiYC6lr8yBLEc+tPAndcJ
         ypuA==
X-Gm-Message-State: APjAAAXcvgCZYJGjA/VCQU/n+8nGdLL4PVJMDKkVvt5cylP1Jtb4P+tW
        VdzxpS+arF1oMLk4bZlb1CsI+N6hjvU=
X-Google-Smtp-Source: APXvYqyDOnWUW1MMlMDfLpJuKb2ofYQgzUrWoTVuvNHHLf00sY+l3R6kE32MsfHDrKEl0aNZEwsq2A==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr39335671wmj.113.1567441582054;
        Mon, 02 Sep 2019 09:26:22 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 13/15] net: dsa: sja1105: Make HOSTPRIO a kernel config
Date:   Mon,  2 Sep 2019 19:25:42 +0300
Message-Id: <20190902162544.24613-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
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
Changes since RFC:
- None.

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

