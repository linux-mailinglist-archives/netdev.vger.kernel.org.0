Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532F3359815
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhDIIio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:38:44 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:60167
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232358AbhDIIii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:38:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeGgbzNx2cIyVIhPMetVsvHc2wnto8aOspOO1WBLveckg6CYOqmEXmdw1X2NUM8ARDJTeFl8Em91m2qSZsZBrJane4xpjo2A0IVnSu3vl4ga8TIJIR9rZBxahc9b89b8O/wI6GB97bzIrkCgw6OHgfDqbn0EHN09dpS8T2WU0mfEryoUasrmIbH4fyKk6S0kquKucxp8D8O1jje+w7T9JOrkvfEuhqrM/qyU9/97SaRljT+vQSog70hd+oGx1br+Ebz/PJj0vhlpbr3po0J+bSD6WWLNA5Ll6lvjlCPWllvbzOppT4teldZwhHM3AnexzAyLdLWvYq7w5PW+6eN6QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMlg2fxi4P7R0H3wJXlXTRCG+pYcSmWvSfNx9ui2a+Y=;
 b=Ii878GK+RWlD1U2bt7CmTa5HqT/ICieSfHwxTpk+8VrCef0gJ0qDw6iyesUX7a7AvJwydYtrwyG8EIscUrbxXNwJWVyraOuvFsHVMZf/GemYH9aZEdh3xpCU+RDbVfpAB8q7Nt2PpVjOTOPL5+U1EmuQu7SLx2I625fdBzNBeihDer3d4cw8Sb8hRHHa3xVQgTcfl5T8Q8+copaGwGyvUsipiGRWVqdx9+QYyytbXShKfTGyWUOq5Gz842uDI9erqavDOUbKgJGwUGDr7tai3cFeR+YKSCURReTktOzmO32C7gur5oQVuhUuzaKc2aLOEBQtMX22fkSPeLer3Ae0cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMlg2fxi4P7R0H3wJXlXTRCG+pYcSmWvSfNx9ui2a+Y=;
 b=nqLp2zi2Q6aR5aJJthgii3op+LqdYtGwVSuHElOIZAnHaEoW84JDq5WaaDqgbOZBMJzgvN8y88089OOJ9b1rwBX1n/cO1wtehtAzmfERFatXBKACopjOPsBxM5q8awqIZ9P+jiH8kudZU0YOi6LBXQ3Mc4rpEz7U7VdLa+aBPcA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7400.eurprd04.prod.outlook.com (2603:10a6:10:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 08:38:23 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 08:38:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] of_net: add property "nvmem-mac-address" for of_get_mac_addr()
Date:   Fri,  9 Apr 2021 16:37:51 +0800
Message-Id: <20210409083751.27750-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
References: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:202:2::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:202:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 08:38:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7369d7f5-bfca-4e5d-ecc8-08d8fb32d5be
X-MS-TrafficTypeDiagnostic: DBAPR04MB7400:
X-Microsoft-Antispam-PRVS: <DBAPR04MB7400412548B59D02684A7383E6739@DBAPR04MB7400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOd+7uLQY+y1r0UllORq1FZHWca/zhjsdUHMXE7EZnJIh3/foEc4KQEaXxuEQ1fXG5lHvEAWTnPHTA9Ft+MF/0QdupAGy30ZXMPdEBWB/mqS7swlw3koR2bhR5ny+Wpz+v0nLmPUMd6Sp/PEoN8ObtF/i+78ettuMZVAoN64KVsJCPL/0vyPblrT20MVKcz7ujAwnojCWttitg2wd83aUngo2OWd574q57TSEEZhkr3E0c40UnKz3wMBrjuWn7VrFMXEp21Bf1xZSyc88o4ajc8ALuD5Er/EwAvom2vv8NglCA0QxxnXIqnGJzcnMhs6tgUv3AKRiCnZgwql4fu0wORq4vn2RyRy2xbJV7VxfNS3DxbAMcst3pVMPM+g/otCHu0cYKkOeCeXEP/U4uNccTiIVH0rwsThwMnSyPRWxTl4MTB9Y+rowdtxbXQAxfyWIu45AU8bgrGRorXYaIPY5WGTzYZHQH2feAJgNabm65isFB7M/bxnkAn7E4+F8Pv7zC2hAkrX9jbWcCXu032NYjgwQAoJKWSJi+VsX9BZjbBw/gHe3Usb6hvyfVu9qQszPPFS2wHQN7NiRaTv+caFb7OUlHLqRX6fIUqCQy+dQa/uD5HSQxJpRkDJSLZctQp2Gj78mKHLDEu7QNNgiw7pey+S5dWAo/wZXSsv8HqsrwT5Ue3IbwOoLlEcusyQVXa03g8xfx1Y8TZ5odG6f9lU8EFjlGqzAN1/2bONdsxJbGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(38100700001)(7416002)(38350700001)(6486002)(6506007)(956004)(186003)(6512007)(2616005)(478600001)(36756003)(4326008)(5660300002)(6666004)(4744005)(2906002)(16526019)(316002)(8676002)(8936002)(66476007)(52116002)(66556008)(69590400012)(86362001)(1076003)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mWlQT1Hvc0GxtXfb81wMkUO4R8iK9qGaUZTYrYTPLn+d2NvdTdGsMdyP+HXt?=
 =?us-ascii?Q?rubWh0rJXJWl7XouZptYyw0r+Vjk80yk/QS5b1xd0qtlDD+tks0VoOF9Bb9z?=
 =?us-ascii?Q?jLDd/iBSHZ7NRAtdx6J/jI2mqmQkpRZRA9oVzBMxvzgpOK8gImZIRCa4kbef?=
 =?us-ascii?Q?T5bKYxDIRBGp0yEVysP6tgcx8P1rQiuIkoZVsQ5PpnuVW7bstcfx09AmsSo7?=
 =?us-ascii?Q?2ybCyEUHCvRibBW5jfPlhZ9c5duFiMqeFqjF1EwlplZsTJc4ItIvfOTVOH8H?=
 =?us-ascii?Q?Nsgd0dJvPq7wCgoTfxYZCliG+lY4Q7q5FHKWnHN22uMMpOGALRVzfnO2h+1W?=
 =?us-ascii?Q?nOkpdGBpIQHdNuOFTjHrjKTrVkISDIkx+XkY9TvIakhptfzkFU30ear6KXqS?=
 =?us-ascii?Q?0/xIJziO9DB9b9F5rRX/EmXfHXJ1QiQv94v3PqSZjLnkbFlGwSycQs3tMsb4?=
 =?us-ascii?Q?lAcoinAL2McpwFu/4g2iRjSX/wdQcrMGk7IXKEbZBfBrkMA05HQH0UQA0vt2?=
 =?us-ascii?Q?HMSgbWTpwB4P3hfpaTOtni80RHEZx4sld/5AnOJB5cnszvbLQ3ihltUxkFJR?=
 =?us-ascii?Q?guVg/mU1SEMdOz+kPEcTlcjCRL7wlxcjotccsOU0PNJuffD6VdHQ8FqrEcEY?=
 =?us-ascii?Q?unL3ryZW7rCPJd0LmbkrJa+GsTFgSBfMb38JuuQkDoz5/kbCpUdVC+j/Nlqn?=
 =?us-ascii?Q?HiYgQNAFYz1qt6URoVpiifx6sXf+dDbcccZDYH75HKESxQbum9hEQ4h5To/7?=
 =?us-ascii?Q?6+YQRVybpqT9yMgoHx56TdJ4VGvmJyTL4UM26nXLMM04NEcnK1Ak1znPHeR9?=
 =?us-ascii?Q?Y/koELERRVamtezuZUQbvhvUX8fjwwNsTa4W59In65XkZQVGwB61jRngXfeX?=
 =?us-ascii?Q?1IypIkXsuuv7+LBclUBRZmjQCRIhHGB+qGSCEykBCLZK8YnPxL0Tq7rfFfA/?=
 =?us-ascii?Q?EPDO1krvjEBGoryIiGtvaTeP30KQB8qy+iY45E6LI7DByolEvkfY0cGe5Xc+?=
 =?us-ascii?Q?ioCSHrKfZxRtdx6AsqdhyRhKAcE1Iu6Idzt0oc9gCSycnfrAr4YP4f5IcxGO?=
 =?us-ascii?Q?0RgtKyD/6eLndvKW8n/LDiH2flL/BBJjK5217DfRtGUrqbf2Wki3aSCrbOhS?=
 =?us-ascii?Q?6rU70xcEDEeHG0AqtJZ1J/PXhyq22gcUpjqxiSl48pe7YzYKPvoEy8tIDXwr?=
 =?us-ascii?Q?J8hYROCW0fB1R2hPnP7mX8rA99UCmSNctClxMmDDkBm3WB+Ty6Pbg8lgnZXV?=
 =?us-ascii?Q?4sp1uzBJ5YXNULd+k/+9z88EXF+RwPstEu+DJ9P63bHpPwACH6cI/8PqwNm0?=
 =?us-ascii?Q?vRKwEsKZwgwGbkm1pN9O8ypA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7369d7f5-bfca-4e5d-ecc8-08d8fb32d5be
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:38:22.9415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbnGTN/+Ob8ikH1G27e9lDLAfnCQFYGkXtu4L+SnZtoDdE16MNBlWA1QhXc1Az5ZmssmEPlGZJq1q+977JZnuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

If MAC address read from nvmem cell and it is valid mac address,
.of_get_mac_addr_nvmem() add new property "nvmem-mac-address" in
ethernet node. Once user call .of_get_mac_address() to get MAC
address again, it can read valid MAC address from device tree in
directly.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/of/of_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 6e411821583e..20c3ae17f95f 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -116,6 +116,10 @@ const void *of_get_mac_address(struct device_node *np)
 	if (addr)
 		return addr;
 
+	addr = of_get_mac_addr(np, "nvmem-mac-address");
+	if (addr)
+		return addr;
+
 	return of_get_mac_addr_nvmem(np);
 }
 EXPORT_SYMBOL(of_get_mac_address);
-- 
2.17.1

