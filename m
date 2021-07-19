Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9601A3CCE5C
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbhGSHVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:21:36 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:19204
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234441AbhGSHVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 03:21:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+6lpT/lIkDlKuxT5bRpQDu5m0IK3ikAn5kdN+XQxidWWUuGAchXrhomLkECVbZ11Z72TkFRmvYUprWtoIfFgIva/0V9DcPJ6/o3RcLUjiSOEcTlqIa1yq/xJfNeOny6+yv8u3g3RQWJFr9A/762sOcJZPkhCfEihKrRVXlF2pWoVPd4t2dA+4ef3CS+wknuyPHK7jUlj08sJNpLCMPEA92c+F+2m9XpMrIRB9ZP/bRMvGe7pKwFeW+aw/Vrjqqc/butVpUQiNlkZCTonawyW0xl+BpCp71HbWxDxdQUM1d/r3nv4I/MYKxg7ClCXXL17Sw+3ZzpR6Q5+aUfs802VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0iZJcfdw1IR1Sf2QMekcgGlnsZNfJiOwrK7i4xp+S4=;
 b=R3CA3cIB/M3U4aFIZRY2HklJEtuWmE4D64/GUNOSl3PzXximW0FxWACOBiwr6Tv90+SV+NKm0MyTMnpSKd0MCnaSrMFvrlVuO8DAG4FQVfQlPcZXeZGnM/P/eSKuEqrxWKTVw1vPwylTFy2HbA8bSc24GBZNFtjtnGCg1TgdysY8XfNhw4ne1c3+5GJ2LfjtaqbjAHrvQEMuLVYfpgasiQcgTjjxoPIgh5WXDdjVHp8wbX/cQaoa4bubbYR29ML+yMorCTUA7uRiicqWDnOXY7+EyGq8aj8cZAIupu7rZfynVR3uDbdUXf9Kj+0w8ktdyQuPmtVv2XhzUlgJpjS5CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0iZJcfdw1IR1Sf2QMekcgGlnsZNfJiOwrK7i4xp+S4=;
 b=dfUImDhpV1omubw6TNo0jdQiBdEU1pVoiw9NGdgLyFdZymjrNe1/DNCmAE+WBXa1b43o7Jb3bMm72MhOvlt9OGNIKc7HKoxBThdB65ufGXZew+sfCV2vIdz+XWBMRr1hSIRHiqOYeYNY+JZs3vkeJAVlN3U7/1DceUCbAAkxKpI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7100.eurprd04.prod.outlook.com (2603:10a6:10:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 07:18:34 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 07:18:34 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next V1 0/3] dt-bindings: net: dwmac-imx: convert
Date:   Mon, 19 Jul 2021 15:18:18 +0800
Message-Id: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:4:54::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0067.apcprd02.prod.outlook.com (2603:1096:4:54::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 07:18:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0d0c6a4-75f9-4efb-593e-08d94a856b79
X-MS-TrafficTypeDiagnostic: DB8PR04MB7100:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB7100CFD5D42DD97FB48B8734E6E19@DB8PR04MB7100.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HD0I6tNDr2AoFQ7a6tjqTUi4v54/yeJ2D6Py8VSj4qtn/mG4SgdRekzRBe4yl0ohDo+fuyrqNz8OrWqDcfuwsgQxaDCblEdHLXzT9S/wg8cllbKctz+uE6fmpt6qhMf/NA60fhu68s64CU0ifnRsh6T5ov/OUEXu8wovafLAOkUYSzQ+oLkw49CrnJvYN2duaGAkE2Cks1ESGgYL00f+WUvFKI5SkvAaoiVv0aD+6nqNqHptw1YIfjJfzsKsAB3ltwVKgPMXk8a6WP6YGQANVPXW/+WnVq60kbXsY3eO5rghTEoTGph97WWq7hqs1GsfgTdxI+/KGREXCQvCllCfEu8HB+QcUlkcVFDY98eGqiEWJNwSEmr3mJP2o35iY0nGYfXfXdgxlvUW8zXzR+7eB++BLGGn04BT1UhGwIEMuhKzL7rePo8cWbSEj/lsqgBNShB2h1mtkOnzDpZAwLLY/UUBLPnnUufhwc+6NGgk3k/FHrVc1HBKZhOXTJyZuR6Hm+KWS+wAsqgKjzlm0BS+3JTVqoCz9LbDl2GhL2UzrH9krepZmQZFggjr58yzkn86q5fxCUHya5P60qRgMQa8N4DtWRTiBa/e2A+FFWAqZiS3dMMloy92PEH/FhMCRiHT6S2A++LcITuBjQpZ9uhgG6klmldH26xMQjWmMhJ6FHlQ9WT9/M5EPwMN/oVYbeXu6J/iuxwe0jX4BarSQ2w2lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(52116002)(1076003)(5660300002)(956004)(2616005)(6512007)(4326008)(4744005)(7416002)(66476007)(38350700002)(38100700002)(6666004)(26005)(8676002)(66556008)(8936002)(36756003)(6486002)(66946007)(83380400001)(508600001)(186003)(2906002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5t9J+qOqXhyXRglFAgjHia+u3u4TovX5MdjrLg3io3JI98zKkI6HXkywvOYR?=
 =?us-ascii?Q?ItbosZTG8UgZCZcAOqU5h4CT57D4QwGcopCIQLJlQ8cNfgeWF02spet3M5uY?=
 =?us-ascii?Q?v7j38P0E4YTU46sH1CfV9K/2wA4OJlmhw3fhSoGEb06rc9n3h8JyBeoFtnji?=
 =?us-ascii?Q?UrzmpZ6yx3/yHfLnyLA8sR5khqtArZicR9bOwrz6h6GWmxvT+f1dEjUMlpAk?=
 =?us-ascii?Q?EQtiKjNig3dz1VWN/vZZcBSUsAaU2+5TvppuEE9S+0V8p+ROmzzR55ph4Uet?=
 =?us-ascii?Q?zqhA3iwZYbOc2fwvQMsPu+d1a3Bw9zEmK7AAJdjeCTq4IcdK4urbmVcrW8hO?=
 =?us-ascii?Q?Nc16rkMILtb8anSVTA0ioDZRK6kn8mxSXlK7/L4ixVDqWCzSduqrcnInqb27?=
 =?us-ascii?Q?Fto/5XOVPxUCa8ACabg7d99dLSUlE1Zx8BHQo1OM0fwcpPNd3+Ymhpk0ZUk7?=
 =?us-ascii?Q?quC1GnZrEDkoF2qpWzsH56jxkdDLn21iKm95T1x/3Ad+2upcblGUyrbFgEqr?=
 =?us-ascii?Q?5CsillIyHwE/BuMsxsXC/d2VKBS6n5i5dkXuGCFyh6Wn5JLFWvsVGnTahb/X?=
 =?us-ascii?Q?wtakzTijlBU50mjv9DRJX/t64YoS4vt9RzxULexKccP6ghlLQhdxkgNl94FW?=
 =?us-ascii?Q?+MG0iMnhQSG4qkMMMEJLU+x8/4bvpgs/DdP8ZjDekT/CFAn1S/rzj/L4ZiQr?=
 =?us-ascii?Q?J1W3c3Kz46plTAc6zh/DQakJK35O1NDLCsRy/KoIOoqxyiC9mXOY//7ZTIGE?=
 =?us-ascii?Q?qAZvdmLIQJEceHaZMNDsFhQeP6u4DgFmcR/LmNDaATN/VhWgKdSVu2YfqLu6?=
 =?us-ascii?Q?39WeBNApy/n4TDbtflTQ+o3RpEKJfH6Y7HoWdHa1a1BR4eOQItznGo9jAxc/?=
 =?us-ascii?Q?ERiOgPK0mPuYPZINgkPzUHbr+0K6TbdcWABpNezQCqFVeHQ4+3bNoX9eNAZp?=
 =?us-ascii?Q?VRw7WVxLoN4CR8Si4ac5ZxWIj+BqCUS88U/NlymDIZshofJVXgk/IWdV0D9N?=
 =?us-ascii?Q?ymhDyL27Umtvqv4oYo34FF9P+DRGK9RgTcdTOJEMWGiMdFp02MJmKSBfZhjp?=
 =?us-ascii?Q?qztWhki4C/cq4FNETNt2Rec6eAJvvILbP7vr9Lzl07pUHYPusEVQS8rR37JW?=
 =?us-ascii?Q?WdcHXBcnSFMcjeSc06MF59xqHViJqBUqJBi6sBweTbUAs4JXyIax3JhqbHXG?=
 =?us-ascii?Q?KXtkNnu7CbnKqzw702iuNXzp6yIhPCToxq/P+fcC8z0U9XZ5GoCyRy1Y84Rg?=
 =?us-ascii?Q?QQEyWGIzyzaYruUiKbTnB1nj6ppcnOZ21RekJrKsywPZZcmdeeaxeUtQ+QOX?=
 =?us-ascii?Q?c560p2rX6DFRXRV/MYkmyIbu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d0c6a4-75f9-4efb-593e-08d94a856b79
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 07:18:34.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9MXQ2j+myrCPZ4WJjtlTZYXYDg4mDmmNObE2u3i6XOpa/aqTIe0xLZufyNsW2G3Z3SmQVxA7ag6OAWj6ySckQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to convert imx dwmac binding to schema, and fixes
found by dt_binding_check and dtbs_check.

Joakim Zhang (3):
  dt-bindings: net: snps,dwmac: add missing DWMAC IP version
  dt-bindings: net: imx-dwmac: convert imx-dwmac bindings to yaml
  arm64: dts: imx8mp: change interrupt order per dt-binding

 .../devicetree/bindings/net/imx-dwmac.txt     | 56 -----------
 .../bindings/net/nxp,dwmac-imx.yaml           | 93 +++++++++++++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |  3 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi     |  6 +-
 4 files changed, 99 insertions(+), 59 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/imx-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml

-- 
2.17.1

