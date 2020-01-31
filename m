Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A023B14EBF9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgAaLsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:48:16 -0500
Received: from mail-bn7nam10on2040.outbound.protection.outlook.com ([40.107.92.40]:6142
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728408AbgAaLsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:48:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDzkYzZQqhaVOEGxFWAIEsu+6CA7rAimFupKyj/alns08sfi7y1gC/hBQvdipLjZu8pXvuLFNqxOiLY5yfgfjxmSPg2yIiCSLtoKajDqxQ4aRGKxRw8kYqZnaB00+H86VVqT+Wu4YvKHZLN+u76bN9QYnTUOqOip2GQcLNfaOCaW3Z5jsXgh1cX3SoVXSSM+JSuoFujErRg1lwHIoIObBETb6go1LUJ3cx3sSIqKqR35hjx875UW1UZJdlhsYpTDh0WqaEUvQMbPt89SLqRGMXy5kl2qcFLXkkq7isr2uCEAmLJebotlAN7ch8QZiqvmkwp2x07OGWLiePzxiFENRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r86wrFN6jnIdDEGeOWWlI2LRDqGN5bheUkemUa7JVLw=;
 b=mvgm2rgxfy5LXr/bne/GU3lfQ1wmRe1tOemsYcZ7lmL6W4QlCLN8Kse8WLZOcM/YxDEMzqb2J2jSEqQtEnWPH4io5zM9NOVVEDhQ3WYe9moMTglGO7gJMTcaE1eIL0Xo36WEfC8QCr0rmqUOFvBaayCan6GMmkq7/wVo5+lDn3rpWfKOZuNw2WYctmjTbuQcbobAfB0FqF/c2ybACZsGzcqj/F+G5hPI16v0F16hoNbWIZGRFQa2bKp+bLCJw+DkkYh6mFNR5/Um1u/Xye6CBcBbhS4W2WoQ3ETJfsU0cP8L9iGJ5s31NqqPER8jUEIHi2AMdjdysLgHmjVLxo1dLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r86wrFN6jnIdDEGeOWWlI2LRDqGN5bheUkemUa7JVLw=;
 b=fD1UVeyK/7NInNbwaIPgwvGCiRax5Ua2K5/FRJs4VnLL4Dw7bA0fqs1UNmx2tEY0jmkuVACe/4YNaXNJaLhFdNDasIyxWuuuXH/RH8pGeXfd+44wh+r4BaTjoP4PBn0mOl6NCJJJ9DpF3bS28bRXeCFCvm4XF0c1nb6il4/epmg=
Received: from BYAPR02CA0055.namprd02.prod.outlook.com (2603:10b6:a03:54::32)
 by BL0PR02MB5473.namprd02.prod.outlook.com (2603:10b6:208:8b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19; Fri, 31 Jan
 2020 11:48:13 +0000
Received: from CY1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BYAPR02CA0055.outlook.office365.com
 (2603:10b6:a03:54::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.25 via Frontend
 Transport; Fri, 31 Jan 2020 11:48:12 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT033.mail.protection.outlook.com (10.152.75.179) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 11:48:12 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmS-0006bP-2O; Fri, 31 Jan 2020 03:48:12 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmM-0004pn-Tp; Fri, 31 Jan 2020 03:48:06 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VBm5I8012168;
        Fri, 31 Jan 2020 03:48:05 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmL-0004op-E5; Fri, 31 Jan 2020 03:48:05 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 9F068100114; Fri, 31 Jan 2020 17:18:04 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v3 -next 3/4] net: emaclite: Fix arm64 compilation warnings
Date:   Fri, 31 Jan 2020 17:17:49 +0530
Message-Id: <1580471270-16262-4-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No-1.563-7.0-31-1
X-imss-scan-details: No-1.563-7.0-31-1;No-1.563-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(346002)(39850400004)(428003)(249900001)(199004)(189003)(2616005)(4326008)(6266002)(107886003)(498600001)(82310400001)(36756003)(6666004)(356004)(316002)(42186006)(81166006)(2906002)(70206006)(8936002)(26005)(70586007)(42882007)(5660300002)(8676002)(450100002)(81156014)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB5473;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 265ceccf-a178-4135-e1b2-08d7a643736f
X-MS-TrafficTypeDiagnostic: BL0PR02MB5473:
X-Microsoft-Antispam-PRVS: <BL0PR02MB54732CE408D2DBFB35C03E9AD5070@BL0PR02MB5473.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbA5TN6fgEXxPwW3LapmvF8g+RPJml9wN5Kbv9uwrNlVrhmG/ZtIfDqSohQpoCyWfcD5B0fRmdv5CKsL2aQZ/M1J00iWfpPY6WiSRIGc7RVRxKIPlN5pfMAbcDyx9V6xmw4VPyeO5nYKjnKBrDHJSL2r65cLwPPuI8zz8KLKvd/ePJYVjHYkerdQLQ2LI/fBZ8tV5Tw6ygRmoXkw5VPDakZHCK0f5xUb0Td/9ht6pj5sAwROJBiMpHXKI52i2GzDYk+FZ0qyvGxLnDrgkHmRTSOq+UcNLVTMV6K7eQS2ZQSHJw9n/8YBY4kejAjUJdG3Z4WAcCdHLxx6AWZMrDwHjhNHHoGBka8XMfgNrgAAKOZ6FfxeIG268mkWS3nAO9ol5Vi+2x5XSb9aVVSssD5m6hvcbC/4sSOMq9zG9HdtKzIJGlj7k377I7w3Q6YvBTfR
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 11:48:12.4995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 265ceccf-a178-4135-e1b2-08d7a643736f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5473
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

Recast pointers with ulong instead of u32 for arm64.
This patch fixes these compilation warnings:

drivers/net/ethernet/xilinx/xilinx_emaclite.c:
In function =E2=80=98xemaclite_send_data=E2=80=99:
drivers/net/ethernet/xilinx/xilinx_emaclite.c:335:35:
warning: cast from pointer to integer of different size [-Wpointer-to-int=
-cast]
   addr =3D (void __iomem __force *)((u32 __force)addr ^
                                   ^
drivers/net/ethernet/xilinx/xilinx_emaclite.c:335:10:
warning: cast to pointer from integer of different size [-Wint-to-pointer=
-cast]
   addr =3D (void __iomem __force *)((u32 __force)addr ^
          ^
drivers/net/ethernet/xilinx/xilinx_emaclite.c:
In function =E2=80=98xemaclite_recv_data=E2=80=99:
drivers/net/ethernet/xilinx/xilinx_emaclite.c:397:36:
warning: cast from pointer to integer of different size [-Wpointer-to-int=
-cast]
    addr =3D (void __iomem __force *)((u32 __force)addr ^
                                    ^
drivers/net/ethernet/xilinx/xilinx_emaclite.c:397:11:
warning: cast to pointer from integer of different size [-Wint-to-pointer=
-cast]
    addr =3D (void __iomem __force *)((u32 __force)addr ^
           ^
drivers/net/ethernet/xilinx/xilinx_emaclite.c:
In function =E2=80=98xemaclite_rx_handler=E2=80=99:
drivers/net/ethernet/xilinx/xilinx_emaclite.c:97:42:
warning: cast from pointer to integer of different size [-Wpointer-to-int=
-cast]
 #define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
                                          ^
drivers/net/ethernet/xilinx/xilinx_emaclite.c:612:10:
note: in expansion of macro =E2=80=98BUFFER_ALIGN=E2=80=99
  align =3D BUFFER_ALIGN(skb->data);
          ^~~~~~~~~~~~
In file included from ./include/linux/dma-mapping.h:7,
                 from ./include/linux/skbuff.h:31,
                 from ./include/linux/if_ether.h:19,
                 from ./include/uapi/linux/ethtool.h:19,
                 from ./include/linux/ethtool.h:18,
                 from ./include/linux/netdevice.h:37,
                 from drivers/net/ethernet/xilinx/xilinx_emaclite.c:12:
drivers/net/ethernet/xilinx/xilinx_emaclite.c:
In function =E2=80=98xemaclite_of_probe=E2=80=99:
drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191:4:
warning: cast from pointer to integer of different size [-Wpointer-to-int=
-cast]
    (unsigned int __force)lp->base_addr, ndev->irq);
    ^
./include/linux/device.h:1780:33: note: in definition of macro =E2=80=98d=
ev_info=E2=80=99
  _dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
                                 ^~~~~~~~~~~

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/=
ethernet/xilinx/xilinx_emaclite.c
index 7f98728..96e9d21 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -94,7 +94,7 @@
 #define ALIGNMENT		4
=20
 /* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignmen=
t. */
-#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
+#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((ulong)adr)) % ALIGNMENT)
=20
 #ifdef __BIG_ENDIAN
 #define xemaclite_readl		ioread32be
@@ -332,7 +332,7 @@ static int xemaclite_send_data(struct net_local *drvd=
ata, u8 *data,
 		 * if it is configured in HW
 		 */
=20
-		addr =3D (void __iomem __force *)((u32 __force)addr ^
+		addr =3D (void __iomem __force *)((ulong __force)addr ^
 						 XEL_BUFFER_OFFSET);
 		reg_data =3D xemaclite_readl(addr + XEL_TSR_OFFSET);
=20
@@ -394,7 +394,7 @@ static u16 xemaclite_recv_data(struct net_local *drvd=
ata, u8 *data, int maxlen)
 		 * will correct on subsequent calls
 		 */
 		if (drvdata->rx_ping_pong !=3D 0)
-			addr =3D (void __iomem __force *)((u32 __force)addr ^
+			addr =3D (void __iomem __force *)((ulong __force)addr ^
 							 XEL_BUFFER_OFFSET);
 		else
 			return 0;	/* No data was available */
@@ -1186,9 +1186,9 @@ static int xemaclite_of_probe(struct platform_devic=
e *ofdev)
 	}
=20
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=3D%d\n",
+		 "Xilinx EmacLite at 0x%08X mapped to 0x%08lX, irq=3D%d\n",
 		 (unsigned int __force)ndev->mem_start,
-		 (unsigned int __force)lp->base_addr, ndev->irq);
+		 (unsigned long __force)lp->base_addr, ndev->irq);
 	return 0;
=20
 error:
--=20
2.7.4

