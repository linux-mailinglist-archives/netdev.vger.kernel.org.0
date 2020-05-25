Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EDC1E12B4
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731488AbgEYQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:32:06 -0400
Received: from mail-eopbgr150055.outbound.protection.outlook.com ([40.107.15.55]:53683
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729338AbgEYQcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:32:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7wxc2MnfFllhMOzrhvr+tBZ2mpVm4LLnfkxNXQCquDjTtPBpS8ZWBQDVrEnF5ruS3R1zYaEH7W/PNjVrx3rPzqIr3u3Fujtw1PJ9Ge+8j+FUbE330Y63wfYi1sk997H5XxenDApPicbjPoSV5Zgcujgz2Xb8wvPI2TXRroSlh8x0zHxmfft/RXj96cnZ4PH63dlv2sE275ymqxSATaOam/oZ+TtMvoiZXoHLDm0NrDlKvLd6LfH03MAFpDPummuo4LSnsxkzxea8vYLBKvWBngwuj12P71hNWN50ZPvpOHpllQwBeMllLtgnbbriH+p6+/eMy7k4lS3MSPs0jxQ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZrN9tfbO+/rriMulpv6avpShKjS9KNkbMTf39Tmr1I=;
 b=dnejsFoRDu/K2FjfaD2Ql4x4E19L9vpUNBt3hYNM/RTrUxjb2WDXIBbaodT/XyAKiGVmIuPAH7OLlVEfZdBI7mJkDZQ4FK1ONxecNordWtjazLXhJ40JT6HzVcKeYg8x3aOfr+zxoV6zlyPuiOAcoDKjDsOfAWUkq8YMxjUO4Fe0iaS7XzLNsKxPF0qOxiKZye1NNFLiFWQ/oNsh7KvAir/23RKMngPIPGl4gTnBY+kwD8i/ueRXd0A6pH1suCnpPznMsiw4GoRuB09wsGrDjRtUzDTX0Cp/qI5BrQr/3VJMWQQ3hG94TeuXTMlREMmKy+orf7LgQ0cXWYBwCx+tsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZrN9tfbO+/rriMulpv6avpShKjS9KNkbMTf39Tmr1I=;
 b=klgZcxqaPhc6FC5nkX2JVLqEICxXkAAoXx5Dyb+ZVusw+IaQwUi8sBcK39ZXdrMUurAowNkbE5NcWLeYjRazdCPbvCHVdWtC/XwegaEZGNr7FEYUBz386/t7OTpU/6UUhFPdM9w5T9RvleDeyYPe01YGcMFytNT3F2cdzly1E+k=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3846.eurprd04.prod.outlook.com
 (2603:10a6:209:18::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 16:32:02 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 16:32:02 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v3 0/4] net: ethernet: fec: move GPR reigster offset and bit into DT
Date:   Tue, 26 May 2020 00:27:09 +0800
Message-Id: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 16:31:58 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b68bafb-51b7-4c7f-7ab9-08d800c92707
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3846CFED0D6EE3E29252A36AFFB30@AM6PR0402MB3846.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c63RMmq/8U8YGoijYaNzOUvu9yBpSuYrjwIB5DUciEM77Y4JxXRiLmdKiQPl/dqlE/5y79jjdTsvwofLnGP721xy6PCvCKhP8pAf9a0G5suiHjP9++vRGjreOfXUOQZz6/0ZbMEai3a0rNBMTn4Q9DxXdd40nDkVT9em6eWTCw3MLxehsRDubL4T/jCS0JnkITpqSRdJ1VkbcI1sWIOqsu6vG6484wIkeI/uMV+XS/yNPc66XUL1EAYZbRdTYwvP2+/XB1VPIxa4kbFYrDq0MnaBiz+GwihL+5//co8Y5ijGjbfshGNuWzHJiGpJfwYD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(6512007)(9686003)(4326008)(36756003)(16526019)(86362001)(6666004)(316002)(6506007)(2906002)(52116002)(5660300002)(26005)(186003)(66556008)(8936002)(66946007)(66476007)(956004)(2616005)(478600001)(6486002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /+4jiRXF6jNpeLHiKK+vguCym8Xqm1PI6nq+J7BKYuUexyRdkHAdfFHXr6Gk6QwwLmsbecWK7RRzQTYoyjsw4UZYpqYiuPSoLw4r1QXTO81BkyDCBGO01ElHaJzpTCgCt8LAY9YX3Woe8SfaLhDXoF3ZPh8xhbUIw7Nnd5rY7Gwy6jaFPj0dhxJTTKyc2zei4XuICqzgO9npl7GCxroVI8G2n+b8ptEpNvdf+FSHbN35EguotXLpda635H+HJAQhx0JpTY8bmbyUg46RhuWlO8II/P+gsKHloWQASOmplHQEdzdo0xu7MUIoUC3wiRfxQo5bDvHOND5VYgPfaoc3rgRxAZEzbU9NQYVte0hfJSD/o08KhYnQylnssTkv+4FJsQg3Swz5vN+CUD0b2SjOhx5TAi1S5f24HrJb8VbXlX5Qe66PWLTWr/M1b/mHKkFDzPxDTTpHruLYvT4z3Jn0I3rQ34uQwslTI/GG/94TyqTlR1yfY/BShsGzrbjXw3/H
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b68bafb-51b7-4c7f-7ab9-08d800c92707
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 16:32:02.0001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKdYjIkdek2wsYcjwdeWgBs6CfueVBO4TJUQZkXiqM3eGY0u+O4rM22pKSGPmy64Th+nFtRwWy8VSbIn4raXyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The commit da722186f654 (net: fec: set GPR bit on suspend by
DT configuration) set the GPR reigster offset and bit in driver
for wol feature support.

It brings trouble to enable wol feature on imx6sx/imx6ul/imx7d
platforms that have multiple ethernet instances with different
GPR bit for stop mode control. So the patch set is to move GPR
register offset and bit define into DT, and enable imx6q/imx6dl
imx6qp/imx6sx/imx6ul/imx7d stop mode support.

Currently, below NXP i.MX boards support wol:
- imx6q/imx6dl/imx6qp sabresd
- imx6sx sabreauto
- imx7d sdb

imx6q/imx6dl/imx6qp sabresd board dts file miss the property
"fsl,magic-packet;", so patch#4 is to add the property for stop
mode support.


v1 -> v2:
 - driver: switch back to store the quirks bitmask in driver_data
 - dt-bindings: rename 'gpr' property string to 'fsl,stop-mode'
 - imx6/7 dtsi: add imx6sx/imx6ul/imx7d ethernet stop mode property
v2 -> v3:
 - driver: suggested by Sascha Hauer, use a struct fec_devinfo for
   abstracting differences between different hardware variants,
   it can give more freedom to describe the differences.
 - imx6/7 dtsi: correct one typo pointed out by Andrew.

Thanks Martin, Andrew and Sascha Hauer for the review.

Fugang Duan (4):
  net: ethernet: fec: move GPR register offset and bit into DT
  dt-bindings: fec: update the gpr property
  ARM: dts: imx: add ethernet stop mode property
  ARM: dts: imx6qdl-sabresd: enable fec wake-on-lan

 Documentation/devicetree/bindings/net/fsl-fec.txt |  7 +++++--
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi            |  1 +
 arch/arm/boot/dts/imx6qdl.dtsi                    |  2 +-
 arch/arm/boot/dts/imx6sx.dtsi                     |  2 ++
 arch/arm/boot/dts/imx6ul.dtsi                     |  2 ++
 arch/arm/boot/dts/imx7d.dtsi                      |  1 +
 arch/arm/boot/dts/imx7s.dtsi                      |  1 +
 drivers/net/ethernet/freescale/fec_main.c         | 24 +++++++++++------------
 8 files changed, 25 insertions(+), 15 deletions(-)

-- 
2.7.4

