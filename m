Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82EC1CB662
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEHRx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:53:57 -0400
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:33097 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgEHRx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:53:57 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2020 13:53:55 EDT
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id CE949C11CA;
        Fri,  8 May 2020 10:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1588959849;
        bh=LfwR1rz+Z+hb8NIaubQZuh2b+/7q7plb71PyTbBnWVI=;
        h=From:To:Cc:Subject:Date;
        b=W3PYUQayAGWnQuMFPfEycIn4QE7//UnWX/zr+lKUg1JJ1hjHsW8SMJ5EiKiSZ9YZ1
         +g4SOWcT/e5JKonyK4dBEMsa3ucDfZXXUkpkKk0bpl4jVQEpIjhhhCMzGGCCIZwTtw
         KagZb72zFs1JdMWiqqmNx4QKcpifJvUJJpui+T2U=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     linville@tuxdriver.com, jiri@resnulli.us, ivecera@redhat.com,
        idosch@mellanox.com, roopa@cumulusnetworks.com,
        pschmidt@cumulusnetworks.com, aroulin@cumulusnetworks.com
Subject: [PATCH ethtool] ethtool: add support for newer SFF-8024 compliance codes
Date:   Fri,  8 May 2020 10:44:07 -0700
Message-Id: <1588959847-46505-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Schmidt <pschmidt@cumulusnetworks.com>

This change adds support for newer compliance codes defined in
SFF-8024.

Standards for SFF-8024
a) SFF_8024 Rev 4.9 dated Jan 8, 2020

Signed-off-by: Paul Schmidt <pschmidt@cumulusnetworks.com>
Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
---
 qsfp.c  | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 qsfp.h  |  36 ++++++++++++++++++++
 sfpid.c |  68 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+)

diff --git a/qsfp.c b/qsfp.c
index d0774b0..a8b69c9 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -375,6 +375,107 @@ static void sff8636_show_transceiver(const __u8 *id)
 			printf("%s 100G Ethernet: 100G ACC or 25GAUI C2M ACC with worst BER of 10^(-12)\n",
 					pfx);
 			break;
+		case SFF8636_ETHERNET_100GE_DWDM2:
+			printf("%s 100GE-DWDM2 (DWDM transceiver using 2 wavelengths on a 1550 nm DWDM grid with a reach up to 80 km)\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_100G_1550NM_WDM:
+			printf("%s 100G 1550nm WDM (4 wavelengths)\n", pfx);
+			break;
+		case SFF8636_ETHERNET_10G_BASET_SR:
+			printf("%s 10GBASE-T Short Reach (30 meters)\n", pfx);
+			break;
+		case SFF8636_ETHERNET_5G_BASET:
+			printf("%s 5GBASE-T\n", pfx);
+			break;
+		case SFF8636_ETHERNET_2HALFG_BASET:
+			printf("%s 2.5GBASE-T\n", pfx);
+			break;
+		case SFF8636_ETHERNET_40G_SWDM4:
+			printf("%s 40G SWDM4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_100G_SWDM4:
+			printf("%s 100G SWDM4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_100G_PAM4_BIDI:
+			printf("%s 100G PAM4 BiDi\n", pfx);
+			break;
+		case SFF8636_ETHERNET_4WDM10_MSA:
+			printf("%s 4WDM-10 MSA (10km version of 100G CWDM4 with same RS(528,514) FEC in host system)\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_4WDM20_MSA:
+			printf("%s 4WDM-20 MSA (20km version of 100GBASE-LR4 with RS(528,514) FEC in host system)\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_4WDM40_MSA:
+			printf("%s 4WDM-40 MSA (40km reach with APD receiver and RS(528,514) FEC in host system)\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_100G_DR:
+			printf("%s 100GBASE-DR (clause 140), CAUI-4 (no FEC)\n", pfx);
+			break;
+		case SFF8636_ETHERNET_100G_FR_NOFEC:
+			 printf("%s 100G-FR or 100GBASE-FR1 (clause 140), CAUI-4 (no FEC)\n", pfx);
+			break;
+		case SFF8636_ETHERNET_100G_LR_NOFEC:
+			printf("%s 100G-LR or 100GBASE-LR1 (clause 140), CAUI-4 (no FEC)\n", pfx);
+			break;
+		case SFF8636_ETHERNET_200G_ACC1:
+			printf("%s Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_200G_AOC1:
+			printf("%s Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_200G_ACC2:
+			printf("%s Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_200G_A0C2:
+			printf("%s Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below\n",
+					pfx);
+			break;
+		case SFF8636_ETHERNET_200G_CR4:
+			printf("%s 50GBASE-CR, 100GBASE-CR2, or 200GBASE-CR4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_200G_SR4:
+			printf("%s 50GBASE-SR, 100GBASE-SR2, or 200GBASE-SR4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_200G_DR4:
+			printf("%s 50GBASE-FR or 200GBASE-DR4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_200G_FR4:
+			printf("%s 200GBASE-FR4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_200G_PSM4:
+			 printf("%s 200G 1550 nm PSM4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_50G_LR:
+			printf("%s 50GBASE-LR\n", pfx);
+			break;
+		case SFF8636_ETHERNET_200G_LR4:
+			printf("%s 200GBASE-LR4\n", pfx);
+			break;
+		case SFF8636_ETHERNET_64G_EA:
+			printf("%s 64GFC EA\n", pfx);
+			break;
+		case SFF8636_ETHERNET_64G_SW:
+			printf("%s 64GFC SW\n", pfx);
+			break;
+		case SFF8636_ETHERNET_64G_LW:
+			printf("%s 64GFC LW\n", pfx);
+			break;
+		case SFF8636_ETHERNET_128FC_EA:
+			printf("%s 128GFC EA\n", pfx);
+			break;
+		case SFF8636_ETHERNET_128FC_SW:
+			printf("%s 128GFC SW\n", pfx);
+			break;
+		case SFF8636_ETHERNET_128FC_LW:
+			printf("%s 128GFC LW\n", pfx);
+			break;
 		default:
 			printf("%s (reserved or unknown)\n", pfx);
 			break;
diff --git a/qsfp.h b/qsfp.h
index b623174..3215932 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -496,6 +496,42 @@
 #define	 SFF8636_ETHERNET_100G_AOC2		0x18
 #define	 SFF8636_ETHERNET_100G_ACC2		0x19
 
+#define  SFF8636_ETHERNET_100GE_DWDM2        0x1A
+#define  SFF8636_ETHERNET_100G_1550NM_WDM    0x1B
+#define  SFF8636_ETHERNET_10G_BASET_SR       0x1C
+#define  SFF8636_ETHERNET_5G_BASET           0x1D
+#define  SFF8636_ETHERNET_2HALFG_BASET       0x1E
+#define  SFF8636_ETHERNET_40G_SWDM4          0x1F
+#define  SFF8636_ETHERNET_100G_SWDM4         0x20
+#define  SFF8636_ETHERNET_100G_PAM4_BIDI     0x21
+#define  SFF8636_ETHERNET_4WDM10_MSA         0x22
+#define  SFF8636_ETHERNET_4WDM20_MSA         0x23
+#define  SFF8636_ETHERNET_4WDM40_MSA         0x24
+#define  SFF8636_ETHERNET_100G_DR            0x25
+#define  SFF8636_ETHERNET_100G_FR_NOFEC      0x26
+#define  SFF8636_ETHERNET_100G_LR_NOFEC      0x27
+/*  28h-2Fh reserved */
+#define  SFF8636_ETHERNET_200G_ACC1          0x30
+#define  SFF8636_ETHERNET_200G_AOC1          0x31
+#define  SFF8636_ETHERNET_200G_ACC2          0x32
+#define  SFF8636_ETHERNET_200G_A0C2          0x33
+/*  34h-3Fh reserved */
+#define  SFF8636_ETHERNET_200G_CR4           0x40
+#define  SFF8636_ETHERNET_200G_SR4           0x41
+#define  SFF8636_ETHERNET_200G_DR4           0x42
+#define  SFF8636_ETHERNET_200G_FR4           0x43
+#define  SFF8636_ETHERNET_200G_PSM4          0x44
+#define  SFF8636_ETHERNET_50G_LR             0x45
+#define  SFF8636_ETHERNET_200G_LR4           0x46
+/*  47h-4Fh reserved */
+#define  SFF8636_ETHERNET_64G_EA             0x50
+#define  SFF8636_ETHERNET_64G_SW             0x51
+#define  SFF8636_ETHERNET_64G_LW             0x52
+#define  SFF8636_ETHERNET_128FC_EA           0x53
+#define  SFF8636_ETHERNET_128FC_SW           0x54
+#define  SFF8636_ETHERNET_128FC_LW           0x55
+/*  56h-5Fh reserved */
+
 #define	 SFF8636_OPTION_2_OFFSET	0xC1
 /* Rx output amplitude */
 #define	  SFF8636_O2_RX_OUTPUT_AMP	(1 << 0)
diff --git a/sfpid.c b/sfpid.c
index ded3be7..da2b3f4 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -191,8 +191,76 @@ static void sff8079_show_transceiver(const __u8 *id)
 		printf("%s Extended: 100G AOC or 25GAUI C2M AOC with worst BER of 10^(-12)\n", pfx);
 	if (id[36] == 0x19)
 		printf("%s Extended: 100G ACC or 25GAUI C2M ACC with worst BER of 10^(-12)\n", pfx);
+	if (id[36] == 0x1a)
+		printf("%s Extended: 100GE-DWDM2 (DWDM transceiver using 2 wavelengths on a 1550 nm DWDM grid with a reach up to 80 km)\n",
+		       pfx);
+	if (id[36] == 0x1b)
+		printf("%s Extended: 100G 1550nm WDM (4 wavelengths)\n", pfx);
 	if (id[36] == 0x1c)
 		printf("%s Extended: 10Gbase-T Short Reach\n", pfx);
+	if (id[36] == 0x1d)
+		printf("%s Extended: 5GBASE-T\n", pfx);
+	if (id[36] == 0x1e)
+		printf("%s Extended: 2.5GBASE-T\n", pfx);
+	if (id[36] == 0x1f)
+		printf("%s Extended: 40G SWDM4\n", pfx);
+	if (id[36] == 0x20)
+		printf("%s Extended: 100G SWDM4\n", pfx);
+	if (id[36] == 0x21)
+		printf("%s Extended: 100G PAM4 BiDi\n", pfx);
+	if (id[36] == 0x22)
+		printf("%s Extended: 4WDM-10 MSA (10km version of 100G CWDM4 with same RS(528,514) FEC in host system)\n",
+		       pfx);
+	if (id[36] == 0x23)
+		printf("%s Extended: 4WDM-20 MSA (20km version of 100GBASE-LR4 with RS(528,514) FEC in host system)\n",
+		       pfx);
+	if (id[36] == 0x24)
+		printf("%s Extended: 4WDM-40 MSA (40km reach with APD receiver and RS(528,514) FEC in host system)\n",
+		       pfx);
+	if (id[36] == 0x25)
+		printf("%s Extended: 100GBASE-DR (clause 140), CAUI-4 (no FEC)\n", pfx);
+	if (id[36] == 0x26)
+		printf("%s Extended: 100G-FR or 100GBASE-FR1 (clause 140), CAUI-4 (no FEC)\n", pfx);
+	if (id[36] == 0x27)
+		printf("%s Extended: 100G-LR or 100GBASE-LR1 (clause 140), CAUI-4 (no FEC)\n", pfx);
+	if (id[36] == 0x30)
+		printf("%s Extended: Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below\n",
+		       pfx);
+	if (id[36] == 0x31)
+		printf("%s Extended: Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below\n",
+		       pfx);
+	if (id[36] == 0x32)
+		printf("%s Extended: Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below\n",
+		       pfx);
+	if (id[36] == 0x33)
+		printf("%s Extended: Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below\n",
+		       pfx);
+	if (id[36] == 0x40)
+		printf("%s Extended: 50GBASE-CR, 100GBASE-CR2, or 200GBASE-CR4\n", pfx);
+	if (id[36] == 0x41)
+		printf("%s Extended: 50GBASE-SR, 100GBASE-SR2, or 200GBASE-SR4\n", pfx);
+	if (id[36] == 0x42)
+		printf("%s Extended: 50GBASE-FR or 200GBASE-DR4\n", pfx);
+	if (id[36] == 0x43)
+		printf("%s Extended: 200GBASE-FR4\n", pfx);
+	if (id[36] == 0x44)
+		printf("%s Extended: 200G 1550 nm PSM4\n", pfx);
+	if (id[36] == 0x45)
+		printf("%s Extended: 50GBASE-LR\n", pfx);
+	if (id[36] == 0x46)
+		printf("%s Extended: 200GBASE-LR4\n", pfx);
+	if (id[36] == 0x50)
+		printf("%s Extended: 64GFC EA\n", pfx);
+	if (id[36] == 0x51)
+		printf("%s Extended: 64GFC SW\n", pfx);
+	if (id[36] == 0x52)
+		printf("%s Extended: 64GFC LW\n", pfx);
+	if (id[36] == 0x53)
+		printf("%s Extended: 128GFC EA\n", pfx);
+	if (id[36] == 0x54)
+		printf("%s Extended: 128GFC SW\n", pfx);
+	if (id[36] == 0x55)
+		printf("%s Extended: 128GFC LW\n", pfx);
 }
 
 static void sff8079_show_encoding(const __u8 *id)
-- 
2.20.1

