Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865771277A2
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfLTI5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:57:23 -0500
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:6231
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727169AbfLTI5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:57:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xpns2UgxfUKxRXaHRLf/i45YVXsNVW08vSNDEvi95DnAbMqxRVdFGSADI5FhO9xQP3A2JZj+93+IRKhgWL8kjBtcNmx3FCY594MrXEatpOkWr1bkC/UXln4ETm6q5nAoGReo9LbUTPsObK9F73Hez+GWXGDJatrWEp2mKgW4B+0Fmwgx2JfLOVrSrUuB/ft8oAtL9rJAnNbw0Afcld8L9IU8pQn88Jdt47BvTS1wc2CcQmZ7c6syg/tD3ZY7tkmBfaVQkXjrhk8W1zWu7yHShOmkUS9K9x/M7QNi0wie6DUgsVM/IFof7Pku1CZakAHM7e+6bZ1213uG47xGdxKgCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lig4wAPT9grsjl6xgWuOpn8bXgCbztF7LAQFrekMqiQ=;
 b=SvckeVozOXkZUoyLgN3p8psJ8MYcmOfzZOD0CdliZGPxYnLKKQoytt/IaPH0bGDGw31aNHm8Ak6Hp6Z1iGzv4Sj2yABhfICVWQiEu97MfUDCEL2RBW9j99He2g1t1f27oPge3W3iKEI5vXdflsbR3m75x/ktq091RjNkDhsqwgV+k4GnXFVZlmnsKfu/ChTo8NXCY5w3KgWVO7KFtAm1x3MvM2fHMl8vKW9+jGt46rOPVbYWXZb9f/O+3q+gLj7WkVGP60IwQc1edmhZj5FDsORf0Fyr/oJEWvzt/9NqBpCVa1W9J42B9PMSQhM0VRzW/BqjjRxtaIYni8q3XkjS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lig4wAPT9grsjl6xgWuOpn8bXgCbztF7LAQFrekMqiQ=;
 b=HM3fnH0hV/MBOrGpFDPzD0Pp/exc6Tf7SW+wFHoRYz9P4ENhUUroDCNy6J3lodsexD2ndI+TLBkjVw+Rc8NTByfhZMsu4sATDllqC05+OgJRuHnjetQquBxk81J3sQT20G8JSK9/VXExpYibLdhNCycP4gXNWBSLghemjkEeer8=
Received: from DM6PR02CA0099.namprd02.prod.outlook.com (2603:10b6:5:1f4::40)
 by DM6PR02MB5449.namprd02.prod.outlook.com (2603:10b6:5:7a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14; Fri, 20 Dec
 2019 08:57:16 +0000
Received: from SN1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by DM6PR02CA0099.outlook.office365.com
 (2603:10b6:5:1f4::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.15 via Frontend
 Transport; Fri, 20 Dec 2019 08:57:16 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT037.mail.protection.outlook.com (10.152.72.89) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2559.14
 via Frontend Transport; Fri, 20 Dec 2019 08:57:15 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5x-0003Dj-Ts; Fri, 20 Dec 2019 00:57:13 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5s-000102-8b; Fri, 20 Dec 2019 00:57:08 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBK8v7fo010844;
        Fri, 20 Dec 2019 00:57:07 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5q-0000zj-SZ; Fri, 20 Dec 2019 00:57:07 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 1A4A91053D0; Fri, 20 Dec 2019 14:27:06 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next v2 3/3] net: emaclite: Fix arm64 compilation warnings
Date:   Fri, 20 Dec 2019 14:27:00 +0530
Message-Id: <1576832220-9631-4-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
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
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(428003)(249900001)(199004)(189003)(6636002)(6266002)(107886003)(70206006)(70586007)(42186006)(316002)(36756003)(5660300002)(2616005)(42882007)(336012)(8676002)(81156014)(6666004)(8936002)(2906002)(356004)(450100002)(4326008)(26005)(498600001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB5449;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f203fc20-d603-4287-1fdf-08d7852a9cab
X-MS-TrafficTypeDiagnostic: DM6PR02MB5449:
X-Microsoft-Antispam-PRVS: <DM6PR02MB5449FB2CAEDCCCA8F293EAA9D52D0@DM6PR02MB5449.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-Forefront-PRVS: 025796F161
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StXt8q5Qev4cd9/oe69Qea+HqomDwJxkgOZJoadztCgsWY63xnuyZc4GSMVEQzYYLuzTHiRHBakd4OklCEg9OWRKC6acgG3ykOxeiAZakZaEteXFdsVAjoCeMywCzJR2ZzEsLNDJFDb0aXJYTuDdf+giDu3vflRce94OFlUG2lCBPZ4ukuDxqI7Fhl7vKMCezK6JHkxKJ3gVUWyuDxCNauZnuOuW3AeueIbGXBLkQO3npBznMfVFgG3h2aZ4gRAsWY+TrA+PRpYy0CG+huK0AHKykY3AbSw53SQqtr3WSai+Gme4JLMJlmTcTu/0VcCxzXvd4TPNCwBlh+Y9uEkGqB64+LfeJywV6UKu8/PB9G3sW21fvX9AJrBg3f0Xcaib7SqNVkrY2iK0m24Ww6GwZFT/GoaU+6dmqg3B7NVqwtqnaxYgp/msN7dQlk+ATtTT
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2019 08:57:15.8304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f203fc20-d603-4287-1fdf-08d7852a9cab
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5449
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
Changes for v2:
None
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

