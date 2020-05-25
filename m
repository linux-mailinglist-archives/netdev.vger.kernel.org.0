Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071F81E0793
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgEYHOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:14:20 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:1606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbgEYHOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 03:14:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUoopE6M1CitbXhNu6Tx8cxtZRWLnC4eKvJCOnvwx105ICrEkTVnuTzsinV5w9WbvnmhnJ9odol1nCaHOCyCyGhgUsq6WQP0IOfriCK5qfHou41YzAoTNPSQpVt2UcGmFsepTV879PEmMTkFdep5E4Lu88APsKS3PPQl2WAbYhRS0plEU7iS+4t7yODM2s4u3YMN/TZGJbHZgs+yVMzCMaZ6/ajkzwJEhPkZi6eqd6jT6J/Z9DEebmfc6s9CHSHR+mEGuG/8OsMiKRt4paXM5bwUkOEwBOEymjMG3Jv4snmV8rNiI79ys+8d0ATXJ53REbjJ1dY3gwKVulKFwthz4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE5Az9QNVxAJFtEazPnsur/dFXvAntJJJUTGNV+gkI4=;
 b=NDM7tLzt3zMuI8w6BcYnk3cZu5Vko6oGEWxTfkW7wXm4jz9h5TcmBFm9PXTVoym9Dm4+gpNFnkhv4K0YnVgIICYsTOhYgSp8d1v2V+RkG0KXPtu5u+2Zw4npyCi8ohGlW1cpc3yjdi7+IrVL/tS9KAoZGBXQ1s9K+DzWpRlC+iypo3RVjswY5dIAu7SocXljnn34gMwYsmHRcgFrj/sX+Gq7QntwZy5Q0cVVGicKdk25BLoIVqVg1TDB2NYQhdklKzFXaYQCm0g1kuKEkxinyCufiO5mZbirvkBOlBOUBUxHGUquPSnB+SmyZxTOM4KbEAIeHyWZr10hAPBthkPqNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE5Az9QNVxAJFtEazPnsur/dFXvAntJJJUTGNV+gkI4=;
 b=jyArtrmeJaVbZ80xHNbFw2VrLHv8bTzh1wtx8ByQTD2FRXE+2tjDXGmpeFJdzs5non6m02RlqdzjmPRC4aMUp+MAWfRwc/d5/wXhfzdKFOGCzdazjxA5q2XNENrVXKD2vhzHvdd3exfozHJVqDsrYxHNFaSsEqG5QzwXiJV9LRQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3735.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 07:14:15 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 07:14:15 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v2 0/4] net: ethernet: fec: move GPR reigster offset and bit into DT
Date:   Mon, 25 May 2020 15:09:25 +0800
Message-Id: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0213.apcprd06.prod.outlook.com (2603:1096:4:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 07:14:12 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 024cf56d-b16a-45b2-f59f-08d8007b3b64
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3735B7D71E6EB1416EF4F0A0FFB30@AM6PR0402MB3735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bd+kbeu5GRFDj3J6aHYzLzu66EfAPfSUaO38X+oIMvTvdqrx25Bc46tZkxNpxYMmNO5evL1iLJNzWe7vcPfreXlwXpx1RQodYqCrEEuz8Ndfbw4X+1KfHj+Rt/EqcxB0cZcOX6guim1h1CkgdVZZ0Q0DIRLY/HU2sylCVp9WTFJvjjU5p0QoGscVR8K6+gGq4bZrvO0q2j3jhY03fXsfRWaI56RqgxHt3jwMSSMiP2B5FAo9FKQBd7R7Kl120rzP2MwM4o7fB+cLLqmz5xq9TraBDYQaoZetbeggRKcwO6S+iaVRCSoKW0Mcvw5AQRDG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(956004)(2616005)(66476007)(52116002)(6506007)(66556008)(66946007)(86362001)(36756003)(26005)(5660300002)(6486002)(16526019)(186003)(6512007)(2906002)(8676002)(9686003)(478600001)(8936002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZrXJfy3w1J2ftJLI1Bv7r7b3hXECXpzzMelXR/8xt529sgGSnh3rRLh3XvFpDmJrnqYllsv/sMQ2uC1ncY7Z6o6AVsCNpW7OxXzXUJA9sGp+XD0e2QH9nWR9MtnStiEtlc8tp7Nmse/fDorhA9tM8SeA8JRX3EXpujuHWy+a/73Hy9t2gOjAYtqxdfEYRGXzxuHPWgymp/cyF9irZrlnB5Lx+KYpd58SVxh0RccLPDPNDsA4VMfacdeTP+9TN9BasLYfDG4lcHP85S7pp5gHqE3I+/Cp0hrNO23oN/W16dliHdXKOYl4j6EGAY2b2lU2ghTDZtbrsaDnUldU39Jje33OeEGDr8o7fvHwn6It90GymYIkpBnMRwljK1/XpF/6GlCtSm4mw9nRx5GjJLb77V8XQiMobTu8V4x5ruLezlLHFYeYxD8qyCkKXEbY+YFymq5TQDzRat94EE9uqoHWC/YcLjZZeKFaVlINBSYMUd8=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024cf56d-b16a-45b2-f59f-08d8007b3b64
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 07:14:15.2843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXjt51Bw2AUrzVqnRtutMwP6nuOn6Oxm3PupTBy5rQb3usUKYbJXpW+C7/KZALmA3Vb4yWDYQV6qyIaHXYdnJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The commit da722186f654 (net: fec: set GPR bit on suspend by DT configuration) set the GPR reigster offset and bit in driver for wol feature.

It bring trouble to enable wol feature on imx6sx/imx6ul/imx7d platforms that have multiple ethernet instances with different GPR bit for stop mode control. So the patch set is to move GPR reigster offset and bit define into DT, and enable imx6q/imx6dl/imx6sx/imx6ul/imx7d stop mode support.

Currently, below NXP i.MX boards support wol:
- imx6q/imx6dl sabresd
- imx6sx sabreauto
- imx7d sdb

imx6q/imx6dl sarebsd board dts file miss the property "fsl,magic-packet;", so patch#4 is to add the property for stop mode support.


v1 -> v2:
 - driver: switch back to store the quirks bitmask in driver_data
 - dt-bindings: rename 'gpr' property string to 'fsl,stop-mode'
 - imx6/7 dtsi: add imx6sx/imx6ul/imx7d ethernet stop mode property

Thanks Martin and Andrew for the review.


Fugang Duan (4):
  net: ethernet: fec: move GPR register offset and bit into DT
  dt-bindings: fec: update the gpr property
  ARM: dts: imx: add ethernet stop mode property
  ARM: dts: imx6qdl-sabresd: enable fec wake-on-lan

 Documentation/devicetree/bindings/net/fsl-fec.txt |   7 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi            |   1 +
 arch/arm/boot/dts/imx6qdl.dtsi                    |   2 +-
 arch/arm/boot/dts/imx6sx.dtsi                     |   2 +
 arch/arm/boot/dts/imx6ul.dtsi                     |   2 +
 arch/arm/boot/dts/imx7d.dtsi                      |   1 +
 arch/arm/boot/dts/imx7s.dtsi                      |   1 +
 drivers/net/ethernet/freescale/fec_main.c         | 103 +++++++---------------
 8 files changed, 47 insertions(+), 72 deletions(-)

-- 
2.7.4

