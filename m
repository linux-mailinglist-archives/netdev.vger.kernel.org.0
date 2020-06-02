Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663881EB52A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgFBFYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:22 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44676 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgFBFYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B28AF1A00EC;
        Tue,  2 Jun 2020 07:24:16 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EF7891A0B6E;
        Tue,  2 Jun 2020 07:24:06 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4F55B40327;
        Tue,  2 Jun 2020 13:23:55 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 09/10] net: dsa: felix: correct VCAP IS2 keys offset
Date:   Tue,  2 Jun 2020 13:18:27 +0800
Message-Id: <20200602051828.5734-10-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of IS2 IP4_TCP_UDP keys are not correct, like L4_DPORT, L4_SPORT
and other L4 keys. It causes the issue that VCAP IS2 could not filter
a right dst/src port for TCP/UDP packages.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index fceba87509ba..539f3c062b50 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -730,17 +730,17 @@ struct vcap_field vsc9959_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_DIP_EQ_SIP]		= {118,   1},
 	/* IP4_TCP_UDP (TYPE=100) */
 	[VCAP_IS2_HK_TCP]			= {119,   1},
-	[VCAP_IS2_HK_L4_SPORT]			= {120,  16},
-	[VCAP_IS2_HK_L4_DPORT]			= {136,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {120,  16},
+	[VCAP_IS2_HK_L4_SPORT]			= {136,  16},
 	[VCAP_IS2_HK_L4_RNG]			= {152,   8},
 	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {160,   1},
 	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {161,   1},
-	[VCAP_IS2_HK_L4_URG]			= {162,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {163,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {164,   1},
-	[VCAP_IS2_HK_L4_RST]			= {165,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {166,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {162,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {163,   1},
+	[VCAP_IS2_HK_L4_RST]			= {164,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {165,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {166,   1},
+	[VCAP_IS2_HK_L4_URG]			= {167,   1},
 	[VCAP_IS2_HK_L4_1588_DOM]		= {168,   8},
 	[VCAP_IS2_HK_L4_1588_VER]		= {176,   4},
 	/* IP4_OTHER (TYPE=101) */
-- 
2.17.1

