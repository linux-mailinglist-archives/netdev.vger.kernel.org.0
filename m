Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5CE2CE5ED
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgLDCrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:47:13 -0500
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:4739
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbgLDCrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:47:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4xbTasyodzI/5eQ8j1QDogrsIIWZZgmhMtezbFx8AezRby1l0qgEwy5kMXO3TbMeW/cu64lkWgMy6ofKTM/yk4ytGeIZOcS24vKzm1STYhu8AGbaOC7i1t85svsx0tpDfPDhCTKSWembS5j3oGxRoRjp+Ybv0dLuafxb5ie/dgOIVW55aqgY1mB4EbNGe5qDprfVvoREOwUJMG4anXjdEdv2eIczfcnTtijUYGCPMLN1z+TFOkt/dUICZxQJmf3YKP+8XRK65nlquj+NVaCRDlFJPUkNVHe9RpwENbg9I7fluPu2Y1r0+KyLBp7iJ5gTa87jtWS/Vh1s9ESEE3oRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VC0q4JUt3eJmeRWw6RpfBywRG7ys7Zg/SafeGs6Z4/o=;
 b=XBTRgMsA53RsmwZ+kbEpIp9gHXPFIm8U8/JRwr5Yurx2aobMaX2gxKfLEkGkYkxrgF+nUmgAvyQ1cWk/mfoTyqp3Za+Yl8Qf51OK5J/YwYCt0gRnqFZpzLts/ump/iR5HJjxAshsH2Kt4paJft89Wjkp4ygP4FKGBrh4WlzLrhiwqfGlq+xKVCBoIgKlAb4JY9St+9Amc3qDlHdh6LinBWG0jw/KDbNAsjcvqxqOiezu0SLzHCRkrFAnFMFC6cGOiwt4dFiAb5QQce81K6fQKndajSP4S5CqeNLZfmhl9fY7TXmvPIWs2ErdIXT/5TJb2yfkG+jaXGZDupXCsDaN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VC0q4JUt3eJmeRWw6RpfBywRG7ys7Zg/SafeGs6Z4/o=;
 b=lEvJNmzlGpxBJis01myelw563ckhvAK8v2ocKxrihwWXkRMSC2i0kUqM8ABgw/SUdeY40mt3YgyWz/VvVCYrEx+y3nywW7tqBAJFjotGRMt64bQ+zU2CoDq2Wdz281fXfBDj30RTgAwdS817ef6pfWu4boipyCTkdKvobeeOySY=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 02:46:22 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 02:46:22 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V2 0/5] patches for stmmac
Date:   Fri,  4 Dec 2020 10:46:33 +0800
Message-Id: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0052.apcprd02.prod.outlook.com (2603:1096:4:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:46:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09041d0d-e27b-4531-83f8-08d897fec8bf
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB370760F63F44A85EF5E125F5E6F10@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jD41Dr6F1mAwDdO8PeIXCrNrK8QX3JUnVFZ2vFoiVE21YCT+GQmQYv6TWCSvQIzrmvdwHNqhFHelhrPjsXnZZH56wFBBgj0zevj+XgE7O7IoYgz/hBGLG4kam4FhVNW5jKny9c4cNLTob8qERZxk8Qbo0o8tWkqLGIeiUMCiioHLnE/Itee8AM0nLNeBmhX2s/xW2TV4Z+uNumWaEI78jeiINfcFWHhjQMqUzarEuWdi6DYoslu3wBvYbwoWPosWniWAg3lQ9q7lfbgSDqEyF8KaK2vfluHJLOqOn/r/aQSSpCV2N5Bp5m8h398emj0JbBpnSZ29xNhuREUVlx7bK6y4bRRSu1Np1hhcPSYtGOB35leliTencUe3w6SywSZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(478600001)(69590400008)(1076003)(6512007)(66946007)(2616005)(4744005)(4326008)(5660300002)(8676002)(956004)(86362001)(66476007)(66556008)(2906002)(316002)(36756003)(83380400001)(6486002)(26005)(6506007)(52116002)(16526019)(8936002)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RhTALHi5le9V11BXP6onujjWk8NPT+vKhX7HYan+K80gAcPWXd4Nm5eVNAj0?=
 =?us-ascii?Q?pPGTCdn45QLBG0PkqR8HVnNGYnC1L2t0MZvpBQizPOyd6VhtzBfklwkTYsWH?=
 =?us-ascii?Q?4tuC05QHiUVFpIxVY5q3MxxJPJvjxB2Xi42TgLyyiRIxl+mmCSDbxwZitW8x?=
 =?us-ascii?Q?BLg2bt3SdD6GMGfcS3dCXjEq5WXxAGjepq18/rUSGgn32VeLLXhXywtoeLiW?=
 =?us-ascii?Q?GElYDgxwfd8rC/DIAAQxmO/nJgN6LlizUTaxFcP7WusYbdMFn7vILk+n/PSe?=
 =?us-ascii?Q?3lYyNUwzGPizPGz3WfbblpOW/CBOSXsj8CSbg0KfqFpqm61sbprgFNRnwVA8?=
 =?us-ascii?Q?ZjsAgmmkDvnG7MQQSXGr1Z0GOQW/mPvmEn1pLri2zqyz4siuegYJ5fjIgdFS?=
 =?us-ascii?Q?6JeoXKpVQugNtvyhuRfxfzTHbz+P7c+Tl8hN9I1Xxi0nYWpenoVGaEzhQPzx?=
 =?us-ascii?Q?y/CJnRQmP57MQKAXRGTgdPrl/fKFr0TFXS0MaIsvXT+H5LiGfnjxFN2lOa2b?=
 =?us-ascii?Q?Hri7JQekJJnFi10HQdBHUfQ/Q43d5cEaNRB59eDBJ6F+B6H8hmCiJUo+jwAh?=
 =?us-ascii?Q?+6/s5Rw3tqleMdVDXW67ZWjsaqOv4/pTBKamJRp1FSPB9LlUyCrejRyWPDpK?=
 =?us-ascii?Q?tx0iN3iU9jSQppt6bHR6R64yYtcRtWRCZ2aRq7dsNIB82Pas66LBslEYnmTx?=
 =?us-ascii?Q?+1bIRlDtPVe2XDsbPyzBnNDEnfsdqkjb90mciPzynQlaQayvPAA9ykHD7RN0?=
 =?us-ascii?Q?OmDSQw4JvmOsSIrjv7Tk6VSaOE/NpZMQ9F3Ra2K1n2/kqCK7EckidxCXam9r?=
 =?us-ascii?Q?ZkEh2Acn5lu3wFaMY8cUn4dkrRF41PvfJC+OYDS+nyphFGyIXC8jM47X856B?=
 =?us-ascii?Q?hKZhbht3QS18J8M1E30ZUGhvnQIaUyEAdN/L0DsWsoDnm3YlwY4Ix+L8hFL2?=
 =?us-ascii?Q?P8SGUutkwRmA/92+K4Wo+IYp+JL/0JQr245RTApTllDyTJw9h1HG+AFAz87+?=
 =?us-ascii?Q?7YfB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09041d0d-e27b-4531-83f8-08d897fec8bf
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:46:22.2090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVscsAxhkAo5nAAFYQ95IJoao3+d5p8IWvAY+PChTmkgiERWUH7Ln/GHzkvLCn+f2/HO042akx9zwCOyf6DUYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A patch set for stmmac, fix some driver issues.

ChangeLogs:
V1->V2:
	* add Fixes tag.
	* add patch 5/5 into this patch set.

Fugang Duan (5):
  net: stmmac: increase the timeout for dma reset
  net: stmmac: start phylink instance before stmmac_hw_setup()
  net: stmmac: free tx skb buffer in stmmac_resume()
  net: stmmac: delete the eee_ctrl_timer after napi disabled
  net: stmmac: overwrite the dma_cap.addr64 according to HW design

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  9 +---
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 51 +++++++++++++++----
 include/linux/stmmac.h                        |  1 +
 4 files changed, 43 insertions(+), 20 deletions(-)

-- 
2.17.1

