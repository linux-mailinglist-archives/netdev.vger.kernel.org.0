Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9BD4327A0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhJRTcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:32:41 -0400
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:51809
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231739AbhJRTck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 15:32:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hj5rT3Zbe9OC5JEGaC3t/240TEkA0OY83jy8z4dk76TzwT/PXYTKlz4krRfrT+MP3Y/c8h+jdgnq8NngXyt4nmf1m+SLb7+xuPqhYMHR1Cs/QS9c7UF04KG1ZmJbc/04oWg2bFtUhYs2cnqE1gwri7v0HMPm/c2m2yr+At4+CLGHaLsZWYizUMCu5kIDtCRjg/6T+UghUwut5YySpEMugjOW/Q2wZJYG68bpXeoaQF9c06as1oULvU91EZBPXnprW04KReD/fnCJtzRecM567z56qlLZfo9PGusmanqYgL8t5CnTrqD69u4YRepYsBJ1yly6LDMnO4JqEdXG2LpqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0WGgPgHNu2siqvwAFVGNJXHt+mdtjvopMpNnc9rBvY=;
 b=OCjj/8tfNRzpvMCTZVOQDq+YxKhKt3ARA+2RIuUxP3Z5JoNSFHdLSCEvE+E7a3AisCbq0oVSub1GP8HVsc8KsyywzBElc2WsJ2XgQ5Ce/lpPfruBj/+7yvpCMdw7USDaH4sva22P8OdjzfbTscaS5RWzDKCYOB9MwhvLqlkrVBpfgX1N3ZmiP+gmBmQGlyTY9KsG5JiPi+LoX6TJCpSI/G/6C5bOsvBHm3rzuW4VGH4xRD+pJHQdQZo/eW4dleiuoajdVbUy/hXe4tJhe2Nv5okPlLClGbgig12EIPAFilP+Kv1SyaP3W+gWP3hVNnFsl2IOhsp+4GI8ehl+uN46iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0WGgPgHNu2siqvwAFVGNJXHt+mdtjvopMpNnc9rBvY=;
 b=rRHJ+UHWpC3OU2vnpOyyOoByg248M/PGGCn62iQGRec3pEsh/N3bWOfCbYTkOtaPHZMVX+GknITvagje2qPAK42rZyl5JPxVrs0qn1dcHhxTa2TpTaHGBOQ2SJrIW8BoErRxLCIhMOfYD269xIZceMQ+dCw7yXPuB7/CUYtRa3E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4430.eurprd04.prod.outlook.com (2603:10a6:803:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 19:30:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 19:30:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 0/4] New RGMII delay DT bindings for the SJA1105 DSA driver
Date:   Mon, 18 Oct 2021 22:29:48 +0300
Message-Id: <20211018192952.2736913-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0160.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AS8PR04CA0160.eurprd04.prod.outlook.com (2603:10a6:20b:331::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 19:30:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b274cf11-6491-48a3-7154-08d9926dbce6
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-Microsoft-Antispam-PRVS: <VI1PR04MB443098B783587C1C7E9354B4E0BC9@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBah41+RHS3jPj9s2avI+/lJcyLBOmnUK7tp62RBmzyPu5PYxaCdNctAbux5l6tyiJL2Q/NLWW6fB6VE4C9yLRAUgPre4mQJiiNjfFtE4Oz6/qDNwSjqslrT5IN5BMTFKyUY+F0WstnW3GvUspVSpsKwDTvnM4mSW6Cjylmb4ZuAC0wWxSevg0sBBb9Cv+0Cax0uPZxSnXATZt/aeVhgi79nRbYUusdyLNr8j7SZdEVSOHtGknrvFbhGImvyqHjpYFH2onauUW8/0JdOi1STOQmVd1LFptaVeQBo+owFKR8zBPE8QpAYY4Yav+g3RnIz0kS7lz7Y2nCQGn4VlQXgcX3TXmhCuLVSrr8PLllm5nLo9ply/Y5grtmnWLHIpKOA9wi/pQptgs0ikupil9W1UvPWI7V78QjktzGp28Y6skXsJdYlyxDIPKcrWnvSktNfd9//fpga0GYE16tJO+xbxK4Lz1nMJRz7hf6vijnJQkFIU6d2rUB/wtki26Shsgbapcx7VvIOHhxTw/72I6GUOxuA5/Okxe1O2JpR965vpgKLGGW+VzDZ5V2TeerSaE+dXGvoFUdV9LlmeREHesGmVMehk3Hez3GQmRHII5MQzisdeHz1lsqvHcB+KGv2uAxAoiHFjuDmu7xiIPUmNSx3t2Q/C+h3dX8Fi8CKapF0fojiC1mpGQcxI4ERdhw6pA5Vw3JCYrKMIWxCgLiWVT8a7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(86362001)(5660300002)(83380400001)(2616005)(66946007)(66476007)(38350700002)(38100700002)(956004)(186003)(6486002)(316002)(44832011)(66556008)(508600001)(36756003)(6506007)(1076003)(6666004)(52116002)(110136005)(4326008)(54906003)(8936002)(6512007)(2906002)(7416002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C620tpXhO0wLpRa3M91u9FuTsZ2/xIjrbQdsV+PcvjvE0r1yTqZVE66jdWPu?=
 =?us-ascii?Q?P+jrIRlGrKcFHpjaMeKGJWt+EXcvzQh9oLS8fEjPZJ+/VJ9mNgLkQ9UvUd74?=
 =?us-ascii?Q?l/PVArKPw0wKNQtS1H/ELHfn2RIqC6XLasyKwvONWNltHfT8wSHZtTjF94nd?=
 =?us-ascii?Q?N3/IJCPTXJkmKSDC0Yyf3pQ+sxdOz/umLsnG47BBsQi6k/v/7nFuiE7mhGrH?=
 =?us-ascii?Q?3BesNRz/zvBE6ljV1pn7W/uU+zw4w86Bu5HqltppkEF/M6XV5waeVd+NpQGO?=
 =?us-ascii?Q?x4kqECskgUsh4iBHPmzVKKcsNKDRdPHewlSkKChSohC925t2XVttaTsmH9Ey?=
 =?us-ascii?Q?kUjuY4q5tDbqiPaXhsrZK9Oq3ufhjFwixDZFdLIHy/pQVpjmBsrB4j2qCPQE?=
 =?us-ascii?Q?L3bXfhQMDyTHuEXGYoxTQ/WOATRnzjhmRv/g4rsGsf0GevkGZd4eJoxlQivg?=
 =?us-ascii?Q?HdtSi9GPywbQh5LTR3pBOZvkCAuTQcKOC9ysktUaPPkb51N8GJ/Cu1y628ec?=
 =?us-ascii?Q?3kqCQDlATIXdo3JerdcWAYxghE2BJpUf7aSjmn7cWxvdLQjCRtxjdlUTEUAh?=
 =?us-ascii?Q?sojWRjT3pAZKoDB1BaR8/wdhp78zOxe+1l6AnwKecqGoXe9poNnqUq9pweyf?=
 =?us-ascii?Q?ZKCN3TfV/ngsmThbThAaFaPnpfvdek5JpnJ1DWvO8cFXhDokEmoOM3+8zMb4?=
 =?us-ascii?Q?rmi0aCrm0eE5FUqMyS8AiLAFNuK+RZsJ8pN6T6J0uzKY0v67QLoEVjzrSMe9?=
 =?us-ascii?Q?GxWT+di0t6qhtZtZz0K6y1sgQ+lSFbPzmi+xrurT7mSX9OqAzHNzXGgABFxP?=
 =?us-ascii?Q?7TXLN5j0NAK5gaLeAwh2jPL/c1ihc4vfShGvtDTS6yZSzdx3uI2d9D0l55gR?=
 =?us-ascii?Q?FriBOhEb+iW29v71BiXqrE6Qn+MqYIdJuUY9Pk7zii8xPoX8cz2aCHP0EwtO?=
 =?us-ascii?Q?KFtY416+3vClj5N5iRxGtUGmNZkZBbzPkK+7oxNVC4WsWDiY91lgxE0qTdEf?=
 =?us-ascii?Q?5QKdas6mWZfGWF3V+PXZa8AkfNkcq+B/IUbJWkXbsqNE2TY02zfZClwlmcga?=
 =?us-ascii?Q?2zFG8pMK5/YK+TxNfdC2uKibKETly5sWfdRrHStZvwUiihYoHeuKATdtWdr+?=
 =?us-ascii?Q?g4PPvrtjDbBWHwi7eoH/13Qo8n7rXkGX1FCVGWFd1P4cN4Pz8xUmZMO6880h?=
 =?us-ascii?Q?mfRDCUUUaQ5j4dW6Fv+A/o7uRf3eHWkglXQkKXfAyLZVtsSvvUwbk+eRCaIM?=
 =?us-ascii?Q?vig76TG8W100D5tD/ZA2RseU0LZATOeSu/XvePuCTigdugJGuk6PIADv9yYc?=
 =?us-ascii?Q?oN3iV+ijsqOm6KgKE2NHE1YR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b274cf11-6491-48a3-7154-08d9926dbce6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 19:30:26.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zai/2q71Cak9UBdUvGiVQctneVf1oQOIhYq5Y6HWKeg0tWcX88LHeGMe1ChMQBw7kDyr4KqK+7qOARyAym48jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During recent reviews I've been telling people that new MAC drivers
should adopt a certain DT binding format for RGMII delays in order to
avoid conflicting interpretations. Some suggestions were better received
than others, and it appears we are still far from a consensus.

Part of the problem seems to be that there are still drivers that apply
RGMII delays based on an incorrect interpretation of the device tree,
and these serve as a bad example for others.
I happen to maintain one of those drivers and I am able to test it, so I
figure that one of the ways in which I can make a change is to stop
providing a bad example.

Therefore, this series adds support for the "rx-internal-delay-ps" and
"tx-internal-delay-ps" properties inside sja1105 switch port DT nodes,
and if these are present, they will decide what RGMII delays will the
driver apply.

The in-tree device trees are also updated to follow the new format, as
well as the schema validator.

Changes in v2:
- removed devicetree patches, to be sent via Shawn Guo's tree
- fixed yamllint indentation warnings

Vladimir Oltean (4):
  dt-bindings: net: dsa: sja1105: fix example so all ports have a
    phy-handle of fixed-link
  dt-bindings: net: dsa: inherit the ethernet-controller DT schema
  dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
  net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties for
    RGMII delays

 .../devicetree/bindings/net/dsa/dsa.yaml      |  7 ++
 .../bindings/net/dsa/nxp,sja1105.yaml         | 43 +++++++++
 drivers/net/dsa/sja1105/sja1105.h             | 25 ++++-
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 35 +++----
 drivers/net/dsa/sja1105/sja1105_main.c        | 94 ++++++++++++++-----
 5 files changed, 157 insertions(+), 47 deletions(-)

-- 
2.25.1

