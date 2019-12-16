Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838D9120502
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfLPMIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:08:50 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:6149
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727383AbfLPMIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 07:08:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNJOg6bpp/wMpKrvtRWYe5/WrfjE57nEAdgLB5Or+rIwXIRKgTYW+FUvbs+ImJKU4Zjcz0VTfr7jeKjeXY1C0Nn+bj0F5HKBTdkRtMBg6CZmj9NT30TqXA1oQRamvll55cw8C/lgY/jKAwGyqdVxITGcTMTIsZClyP+uAEtKSwUGVVaPIWmA2JaOlxyNppH41WJjy6uKHXDCf3lTJal0iJGdzR+oJpOGfGbs+ylS9ta+Q4PTUdao+09pxA2sRGPvG8U/B28Q7MQ97HnC+6WQsDtvUHxzCxw7oC8pjurhCBoP8gHxv6Beak1lRhKFKJ1qOZk12yRLuYrJHJni1rlekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBCFQwd3d+v8DAd6a0gpnoZB48tO0AIfG5VoTw6oApA=;
 b=GjkwUt7hsb6mjZ5cVS04mppaspbreFYPxRnZMWwceW9ivPFnqSHiIVnH2N+5kMGy43dXxPXn7WtYNh5dipDUF4svN1sQ7nUd5DcwABx7Hw9rpzYs3OA/U3cCDMHw76hu8m4VeIs2uH5WBUCEtuLyh9Xgsw1x/xSk8ge6sZSZp3+5sfcmOMWXkNj5XLf6Wc3nhvAv4zpVL97/eb/tkqVlAp8mVb5Qo/O7Gq3jNgf5DKZyqHe2upl/u2eA5JqytFvi3bDFR/yJ/dl/1D2wQwPHwnWJ/4Bppl5JNNZi9IzjROx5rXmIM2Ud1NoFZBE8U1xm19lj1A3L7odHnEzgBPBbwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBCFQwd3d+v8DAd6a0gpnoZB48tO0AIfG5VoTw6oApA=;
 b=Lew8wZjTbTjkoPj9YNExK4jrmkiyBhFXAtg9uYLZKCh89PzXofX4sprZVQjFNSj5brYl+WXGz0dZAA5ANsojpU57DmSI19W5PIRPRQCdoyZPylq2tzeyEOwHkKkhNm+Fz9U4Xy4hyGHBC3+kVEQI+O3aaYZbVod3+VbDFEZllJA=
Received: from DM6PR06CA0019.namprd06.prod.outlook.com (2603:10b6:5:120::32)
 by SN6PR02MB4366.namprd02.prod.outlook.com (2603:10b6:805:a6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.18; Mon, 16 Dec
 2019 12:08:39 +0000
Received: from CY1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::8) by DM6PR06CA0019.outlook.office365.com
 (2603:10b6:5:120::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.18 via Frontend
 Transport; Mon, 16 Dec 2019 12:08:39 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT031.mail.protection.outlook.com (10.152.75.180) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2538.14
 via Frontend Transport; Mon, 16 Dec 2019 12:08:39 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAz-0001lB-FS; Mon, 16 Dec 2019 04:08:37 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAt-0000wj-QK; Mon, 16 Dec 2019 04:08:31 -0800
Received: from xsj-pvapsmtp01 (smtp-fallback.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBGC8Ur0024884;
        Mon, 16 Dec 2019 04:08:31 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAs-0000wO-Bp; Mon, 16 Dec 2019 04:08:30 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 916481053CF; Mon, 16 Dec 2019 17:38:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 3/3] net: emaclite: Fix arm64 compilation warnings
Date:   Mon, 16 Dec 2019 17:38:10 +0530
Message-Id: <1576498090-1277-4-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576498090-1277-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1576498090-1277-1-git-send-email-radhey.shyam.pandey@xilinx.com>
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
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(428003)(249900001)(199004)(189003)(356004)(70206006)(6666004)(70586007)(5660300002)(6636002)(2616005)(498600001)(107886003)(42186006)(316002)(8936002)(81156014)(81166006)(2906002)(336012)(8676002)(450100002)(4326008)(42882007)(6266002)(36756003)(26005)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4366;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57c84f0b-36ad-4cae-667a-08d78220af9d
X-MS-TrafficTypeDiagnostic: SN6PR02MB4366:
X-Microsoft-Antispam-PRVS: <SN6PR02MB4366064C3F1A7990AF2BE0D4D5510@SN6PR02MB4366.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-Forefront-PRVS: 02530BD3AA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JruE5Vt8+rtnK6KRhEZ6utrHJJTNN6XWA7BaMxKg/ebrm32yakyjx3/uD2uA9H7/hVKRUwc7yf+ZByY+rae0nqeMqa5kArK+3c+EAn0JoVzhA2tRJTI7en/mqZ860Mv4HHfbn95uQS7eHMxzyz+3UNSXEPMDfJqDuYRaXkUOZU1WguKFsPAdIJzYuuKOFfhos7iWjV7IHLNPi6uWSKtqldSg8tXFfyxSgPsbs0oURRmmbL+XLG7xNemXCqeBLRVjk5Os2ie82ddbkMks6HcFgiP5d94fJYi20/9H/sq5YCdP32CeATsD1EpWUuXcANcL73WUyorBQu0zruY3tEn0/n6YRO0DTRDIj3W8Yk1XlyEUVx4lcLaOjVVGFwMST0sidocmBdFaPSOXhywIGJlA5QSNUeoaDFF1BZjbrj7TmzFUqPnOJU9ji8R/SPG639trpaOahzbILCtI2Sql0NB/8B5XLlJJlKkeeCpqd7tqpJpyKGq5CFWMwvkUyl/UBOZJ
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2019 12:08:39.1375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c84f0b-36ad-4cae-667a-08d78220af9d
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4366
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
index 4aa6752..cfb051a 100644
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

