Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EFB3EC65C
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhHOA5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 20:57:21 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:4858
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233237AbhHOA5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 20:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYVhQTWA5I/mSx21v0UzGs97jLq6NVjDElPmDrzqNkaJL7djSDpGw6FRlaDu/hHrYnQ/H10T3hBCls9CRl8FLch/+5K2/z7z5B82+zuDqFk0GKxhfXxeJIEILiXRbA/M7oYsWu/xC4aXQ8mFF0CEZefkg1t6D3wL09Gg1jBFo/S81F68Pgaiem8jZNrzOAIcPVSkZ8y1/FSYSDL2LqgMAPlCfWLdhexlukOaEuSzUYP6Ih5B4ogz6728n7mYEhQEYdJxBrQCBrmeuu9IdjpFK5BFBGBfj5SUmbY2KrHInvuf98Mm9qaPHOkSAlGxtH6tKb7H49lI31Bi10WCt/W4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPc0mwn5TH0YE3SYTvQ9kptOQug96qKZX0eisIZSEP0=;
 b=S7Ov2SC1B1Ed4aas9UwFlZuoeKXDi449hRZNxfKa9IMc9K6jC3O8yVdFxxCyVT8rrwzSxUg72xuYE9KIHf2OjDEp2AJNwmmYtkCtLQbNrEDYsDFCnkjnILafYB4JnLDvDMldYtcBTA2STs2rn9DbzSuIhs/LO8teQFnvjsnj9R1BWIgg05Ys1E/geGhrUfCvvCrPYYz/V6JuUU7CFll3v/Njf1Yjd6BsZryt3cq4FTdUrNfPGKPzfvRfRNhyyKhFC1+D2ArKQ1AJZ+YSr6DUaciwtwUgB3tRI1TKasv4iBsY58kWW4X6WFRu5FPWkn4bVljraKarkTiUZ3hwSatVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPc0mwn5TH0YE3SYTvQ9kptOQug96qKZX0eisIZSEP0=;
 b=Ajq045FS5Lbsvz+ZgIB1J1Jz8K+l84efYyj+u1shHuvW9RtvEwkidSghY99Jk7QnzwSYq+H2ySDDXbgUxRWnrIOGbJMuVFw6AM1OV7pvXQxciZd8OyegCUI7/k+4wsTOCOzlAeiluaHtIeitewD1GTZfLH/7DuJn/hs8n5nNkiw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Sun, 15 Aug
 2021 00:56:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 00:56:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/2] Convert ocelot to phylink
Date:   Sun, 15 Aug 2021 03:56:20 +0300
Message-Id: <20210815005622.1215653-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0192.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR0P264CA0192.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Sun, 15 Aug 2021 00:56:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b69e1a-09f8-48ef-978d-08d95f878ecb
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301AC54E99B6789105451A1E0FC9@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NfUFd6PovrkuK78IUGQW/G+tuVGERBPetBSxtShlLBFhqf9dAdqWXHhXEtZhO/6M41uvoYp5gRwQGTDUT2BMdkMoGVWKat9xcYH0944/eZQfvcRirVsmtUxc2NLXtL86E3jKuxjm5olvidsmvpreaVVkL9h7A+Oe7KLY9ewfrNFXuaSuzaMSaRDuhi9MO88+ZZxdLH7T6wJtGgRfa6IUi5P3xM7JIuS0iOLq3zndMaRY8k15kj54IwsBT5WCw6HcEnYrrn1jo6rmSzsJIVSTyzNZLNLm49EpDSS9VHEZ/YVyvxGT3kn+Ukf3fncGjykpeSKC6x20dd9VC5JUma+Oxwx1cTWCzCSpOKz3OIz00TQRUPs+awR/JnWAasN4WNrR/PI3KHqre00+FCjD5776MMK7aeFxoBKM8gK1tLhLhNnxXRm3UYFjRNHGaNTpFCfuXli22gJrb6lCqrc+kWYwbioPMv2885KWohEbfdN+RN7k5/voXTK3ZmXc8gD9dnOk84AKcPrjjj5UELO0rxrTDclTD9bDb04OMGt46fp3MXzmuzqyoiVbBj4UxsktQfu3gARxDptEdlGth6IEZ2WbvquiTA4LfNW1cGL+XWPwdvAUuV/5HGLErCYRQaHn3MrzZCOntaz73ow6EWofTQwsOJx4m3GnFcVR+sC+Fd203b3dew61AVkEYoY4ZPL9APu5U/dnwOr2f4TIEY8EhzdPEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(508600001)(8936002)(186003)(6512007)(6666004)(1076003)(52116002)(86362001)(5660300002)(36756003)(2906002)(6506007)(38100700002)(38350700002)(66946007)(83380400001)(44832011)(7416002)(66476007)(66556008)(54906003)(6486002)(110136005)(956004)(26005)(8676002)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DELTHZD3DOYELZvSeffe2itpOsZQ0tAv6cven/NNx0ZLoRnmwYZXw+nSDM/U?=
 =?us-ascii?Q?u0yFV0P9zGcbYw5pMNjkhochsjxsqcPCPCV32UeGMkgKs9r+HRm/nOCJ0n6x?=
 =?us-ascii?Q?1Rb3j0jXb0gURKeZd7w9Rpik21L5MRRliY8owllxA9gNLYHK0r2+SMR+JNrx?=
 =?us-ascii?Q?zYd1Y/rsYLqxd7Fe5iKPJOdp/VRouSs48Z90FHbzbg53kqkb6YD/r5wTCAWV?=
 =?us-ascii?Q?sxp/21rQpf00CbQUyPl33fIdaTAjswnYGpR6SUcYGaQer0pYBx3efvQEVaMO?=
 =?us-ascii?Q?U9taxY0eEHPZxZCBobabvJ5mqLC2vJx/c4SYQc9qvGWNuGlc7GCdQ3pxurUM?=
 =?us-ascii?Q?udPxKTVKtMy4x3ybzxbMJ9tEZGonHxH2rFBygzIGDinim62YOG5AoOwl+r8H?=
 =?us-ascii?Q?YTJimfF8vNWoGW1rNK9URIu6WyeSrh8g3sEvV2B/3NYJzCRMQWg/sAwMOjvy?=
 =?us-ascii?Q?nXNlUPRajr9uul/EVqyqQAnPmKYHSlpOZr6pVxFVYRo8JmjNoZ0Ly0IXNAoq?=
 =?us-ascii?Q?IIsBUi9umOpmZkk1E7zd9zvhs7pMSpTrETxWUD9MCzWS+/V5DMgITqnhakSR?=
 =?us-ascii?Q?qmbu6Ho4uitAwiY9HgbhXacxY398U1Ugio6BaqucvFqqzCEKiJ8HnMkOnMIo?=
 =?us-ascii?Q?ZhCKuzlAN6hLf0wKudntL0x/j+zgxAdWC6koqFL3YXdyDVE4v0t2rWLJcmRz?=
 =?us-ascii?Q?xXnJH6kZ7tov7MbTdAQAzUsFMZXvagXD58Zt3mVxUkpFiBJ+uV1LRYJUUQLB?=
 =?us-ascii?Q?6nZtgxBn5MQB/1dh9KIjCZne7UbIzKIehGW9krtAyoZAPKOg3/5MJLc+y2SK?=
 =?us-ascii?Q?JFK2iehGxcOz2Ywb0qjyf3Vt9W28eQm6DkLZ6SQul1HCuXduKvRzgjG+m5ys?=
 =?us-ascii?Q?L0X5F8Pho3pCNLtrp8g868En13UUEDJ6TZprUrEJsSNnKw3Ca8VwsWOr+FfT?=
 =?us-ascii?Q?4MMPwwhonxVk05X3eU82uPOv6O03iSmYqH6MzMt2O7BFhte0nspMLDGq+DaM?=
 =?us-ascii?Q?iYqDxbbdFPle/f8zN5YeJHUVpaNZ+wc/3bTrub8/YJvCLHLP4r2m0dLTxhpQ?=
 =?us-ascii?Q?QzGcJBGjs+wkwCc/7DxtTj8uY90fMNRqfVbLmgpzJWCmDlBPFewBxMvrYvxR?=
 =?us-ascii?Q?DYYSuJ0s6Qk7imf9QYGfK9q62fJKWAOYsb/MAoinV1QONyz/MB6J5lTFTFZP?=
 =?us-ascii?Q?nohqEH9m3NP3heQPL4j9r2zx4PX2eG5GK9l7oDP649O1uk1e+bCzc3jKeOek?=
 =?us-ascii?Q?UXbPrAdJCmOg/UrfOgOwulC1F6fhmncyQPIscR4YFh2lixteLBil4/Ebqx+6?=
 =?us-ascii?Q?GlgsZ42QX/aUhgJSmTXQbqA+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b69e1a-09f8-48ef-978d-08d95f878ecb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 00:56:47.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fq/nKRq10Kf7VVUtH4AlXGQEkso6lJLapGS0ItGUZTDiztdTZLCQnXXjM1eqKi9J3CiF3ihEz8hbxeUNdKn8TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switchdev and felix dsa drivers are interesting because they
target the same class of hardware switches but used in different modes.

Colin has an interesting use case where he wants to use a hardware
switch supported by the ocelot switchdev driver with the felix dsa
driver.

So far, the existing hardware revisions were similar between the ocelot
and felix drivers, but not completely identical. With identical hardware,
it is absurd that the felix driver uses phylink while the ocelot driver
uses phylib - this should not be one of the differences between the
switchdev and dsa driver, and we could eliminate it.

Colin will need the common phylink support in ocelot and felix when
adding a phylink_pcs driver for the PCS1G block inside VSC7514, which
will make the felix driver work with either the NXP or the Microchip PCS.

As usual, Alex, Horatiu, sorry for bugging you, but it would be
appreciated if you could give this a quick run on actual VSC7514
hardware (which I don't have) to make sure I'm not introducing any
breakage.

Vladimir Oltean (2):
  net: dsa: felix: stop calling ocelot_port_{enable,disable}
  net: mscc: ocelot: convert to phylink

 drivers/net/dsa/ocelot/felix.c             | 109 +--------
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/ethernet/mscc/Kconfig          |   2 +-
 drivers/net/ethernet/mscc/ocelot.c         | 174 ++++++++------
 drivers/net/ethernet/mscc/ocelot.h         |  11 +-
 drivers/net/ethernet/mscc/ocelot_net.c     | 254 +++++++++++++++++----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  59 +----
 include/soc/mscc/ocelot.h                  |  21 +-
 8 files changed, 339 insertions(+), 292 deletions(-)

-- 
2.25.1

