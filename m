Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8976239EC8C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhFHDDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:03:23 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:45942
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230266AbhFHDDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:03:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1E1AWi3icXp9whSbOEmrba/gmjVGyhPIojL5XYyfwofULBcrG+Dx+4rlDo/MpWnFklB3rApFDNG6p6N+w+sS74i18ofUKVauuT12eNp2sU/xQmZZZtSyBtJp1bewTXbvGGOU/zkKQ5AFpH/9NJxdbSIgCoaTTPbZwNxE9xqDIsfjEM3UD2zn/HhmQJwXCqphP2NGgR6LLSdp2vx9h/S4KkjTGEQEqhD/fe+VP/xpjQROhLp2Js0/kBlqvL7ltzrBGLpXy5aps/7qODGG6i+hersCZEHk78zOZWNrA6lcKNoK5KHEbd1mn9efkkNYzu5NXcDEDgt0aP1BUZwXGWOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKuGHE1fCh7gBbhwlOxBGwtEgxgXSjjKHAwmnpPX0Dg=;
 b=HDky6UZN+2ZvPZKr0J1xeH0ym/XeS6VbY0o5jcu9MyH9DQb9nX0vOoAbodFCQZYx3+vPKOmwxnSeYvu/aLvCbcZBTO1TEj/NJklVc6bfV/plviWRlCIPLyHH+CzX3qkUpnlAaL8ujSuS9gLB69b/yPD2+KsxUylkgnnn39I+FrQYfWOK92QQ9nx7yna/j38dXAcvWps1yUvhj1ChM0whrXOUBXVyrv/+bibRfC/RqF/Ruj/pRXDwzrfqz5llQ11+gMezfAOTEG4EEmMNd3C6eWg0Q7WPiC4cD7p8DDwFDrO1x/kM/wE4S2aUVP/ugSOM3dRpNQi0ltmK1fHIm9gAow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKuGHE1fCh7gBbhwlOxBGwtEgxgXSjjKHAwmnpPX0Dg=;
 b=WHpdLgp7UQ4R1JB+oBvVmOa9sK5R9a6tLlYd0u1/OfgsnoRD1s2uUZe4mAjxWzlGNTo4SejIgBF9dKHUltaQ0t6ALRwzcKetqX/lU0h4ss3JfMz5T7z5B/jloi+WP4EBldFGea7M1cF8bg9bW/3RgfuryA4neVlW9k2Ev0u+scs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Tue, 8 Jun
 2021 03:01:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:01:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 0/4] net: phy: add dt property for realtek phy
Date:   Tue,  8 Jun 2021 11:00:30 +0800
Message-Id: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0151.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:01:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e2bd3c6-044f-4478-348c-08d92a29b5a6
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2904CBD4FC58BBE1CA674615E6379@DB6PR0402MB2904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhRlyEMJHDVfffXgmBAlWF4xiO5e+B7ZDPu6KNB8oQesa+nXLOXgQAkVtvBpXtrPBNHY9l+vU+wJJynytnlVXmnxhoTvhJPVzSGd6ZhMaujnBVHoZOxtN0OFL6qnyYP5z/BNdKljnV6x+KKNK6DqCOHoAV3w+bhqYdS3Rx30XWSiZN1r/yv6B0TwRQsWw/tPhzZaimQQhp2qdxjxqIVK/fZm9JJV+Xzo08D/E9JprzbQ1KF1OyK9WoMq/AVgMkQpDBv2ek67m9Ztz1Ek+v/cUxBDfVSiBwM1gOPFyfPxVt+O7uVuAtYRrdjv3MvOJe0b8eK40wnVs0Om/vlRQi+Yd0/w3Dlg7VDFfb2bvAVJa6Hi3BPrG3HzZcuXYN5iJCjet8eILkJVjq2yx+KlrFbrqgvhxGbQj57FPv8joaeJZrv3mhKULtfgRgNhNl+BXJmQDQHTQ8AHq5vhGIvIYn9QJUg8hB4/P3Ih7N5NCUUwTnxkfvL/M/Up3wUR5BDfb5xYahi35r4RK3a03VU/raxbUtRLduGocN4WAVWL6gJcOdm9Y9hrcxnEDlfiFgGKxVT6jutRs2K4ecLVLfBgGnA6C4BoLluXA8ZkkRbG2NRdjmU+7S0e0/NgAgnXqE4smaDxnKoeYtug6FeaJDounb4KEUIZImvRrZC+UzonztbbUbpSkuy6yJJkCVBzFcOUekV4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(83380400001)(6666004)(38350700002)(4744005)(86362001)(7416002)(6486002)(52116002)(16526019)(6512007)(6506007)(38100700002)(4326008)(2906002)(66476007)(66556008)(8936002)(956004)(316002)(66946007)(5660300002)(8676002)(186003)(26005)(2616005)(1076003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mX6+WbyJxTRKNq1a9ATvEhlroWQpkXLjXpJnY82STT96qyJ/N0A9pa4Mxav6?=
 =?us-ascii?Q?ms1CrQJsJCrLzH6MeBzeJRArSNmF6uNt6BqUxyIxI0/ijSOnYeZgwN82nJWe?=
 =?us-ascii?Q?9SMcXrNorjvVGh/Bj7tT8rfvNj5jTzh+zQacskM3B2Tqq9gjQxEnlsFKpjAr?=
 =?us-ascii?Q?88wAEuyTKUoKQtbnCfbb/e6bnjYOPUxFhHspivi0M5EbQ2vV+SQVFCKiKOY6?=
 =?us-ascii?Q?lcr+frZ/Ccq2Tfb2j5wy5r9AdmybMzeD5SW/JsOzhbGeZguU6zwONIO5nviP?=
 =?us-ascii?Q?S4jjQlbYf5jY+U0D+72+4QHVvsgTQP947EH0LQ/kC6RxSCPUkf/uckd7FA+X?=
 =?us-ascii?Q?PpV72+VOE2pOgUvM0ZEo42CHOsr/jIUc29i+6/SDGcdB1mqqPf8AJ1tW1ZwV?=
 =?us-ascii?Q?+yQld7qoZyuH9WlH9NtYSzc7PMoMe3jit540PwrGkg2Osp1TYUHGWMxohLkO?=
 =?us-ascii?Q?NIw3z5JIC0R/RyVOhSx75QUv7Ft/7Wrzy1PkCGRQkc6GCIGDRdowR1jkMMXT?=
 =?us-ascii?Q?E5xvxiyys9PJblhPKn9GhOIBLKY5RJjJvDuPj8z9kdi6zh+hDQwS3brpiZCr?=
 =?us-ascii?Q?x9Yj6aVq/oo5wAubNbL0mUWIj6d4tbrLoWnv/LGsxMsYzYByViICAiIfhm34?=
 =?us-ascii?Q?eeloP5jacWj7cTBZ3AP8cc0UI5SJecVqrQP1Cu7vL0rNupqg1UDnkleonkwA?=
 =?us-ascii?Q?JlWYnL50LkGBSYpjoUn8nMe2feg8AXlo8ZumneQUmy1WS985esZwcS5Fgl3M?=
 =?us-ascii?Q?eg4RouFtCAsjo1BDM2Gi3bWd5sOZn7TBOStCW0u3jAXV47STUqbOLE/kJ4CG?=
 =?us-ascii?Q?6G0AdaWRNPmhuTeANnYHGkxFCiti5Mnoxuc+T868PsTDMmZnVtdFMdugx7i/?=
 =?us-ascii?Q?gXmi9iheM8zZyvgVmHRwLw7kXIFFGgv+MnpH5hZL4DiLX8rSE4DBG8ZgK0dA?=
 =?us-ascii?Q?AjJ3xoUq0AFmBmdkroL9hbb6Srukbe/njcyrOv5SaSOqX6t2Oq0pRxxadcfF?=
 =?us-ascii?Q?zTOhjatmCUv9+mXX5s4tucp0lYP/7ZN56Z3QDoWOswx5jkY+uybiW4JRlVdo?=
 =?us-ascii?Q?gbeRb2yryGAbk97IEbvvrSV9g1MO9C3082pgC2r2Yg0tEeIUGmFzCUqJ+JEc?=
 =?us-ascii?Q?KrKPCMWiv3oXhY1NOGa8aaPNAdaXqiNiLhM3AkBs0a5on2wGckPXr4JerClJ?=
 =?us-ascii?Q?+u30kr0y929aL7j8b10DhqdmqvckPZr2Nx8u+HjayECGX5ZwRwcln/O7VwmN?=
 =?us-ascii?Q?4X0Nvefb0U/Sww7lWbQAz0dFCsxBe5D8yglX1JumbYJ4nvw7e9JPScL+5lXV?=
 =?us-ascii?Q?pAjaUEwg/W1zRWmUvOYnXydJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2bd3c6-044f-4478-348c-08d92a29b5a6
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:01:28.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6JEk+Hn0ZL/eOW8oV3iN36ql9LQ+515noGj3SyY/amRUBkfDZ/FxdEYNu+D/GwThz29IS9Tij2mnXy81ImGMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt property for realtek phy.

---
ChangeLogs:
V1->V2:
	* store the desired PHYCR1/2 register value in "priv" rather than
	using "quirks", per Russell King suggestion, as well as can
	cover the bootloader setting.
	* change the behavior of ALDPS mode, default is disabled, add dt
	property for users to enable it.
	* fix dt binding yaml build issues.

Joakim Zhang (4):
  dt-bindings: net: add dt binding for realtek rtl82xx phy
  net: phy: realtek: add dt property to disable CLKOUT clock
  net: phy: realtek: add dt property to disable ALDPS mode
  net: phy: realtek: add delay to fix RXC generation issue

 .../bindings/net/realtek,rtl82xx.yaml         | 45 +++++++++++
 drivers/net/phy/realtek.c                     | 75 ++++++++++++++++++-
 2 files changed, 116 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml

-- 
2.17.1

