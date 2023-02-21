Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD95869E481
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbjBUQ00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbjBUQ0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:26:24 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2051.outbound.protection.outlook.com [40.107.105.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DE12A159;
        Tue, 21 Feb 2023 08:26:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/5r0u55YsEimRhbVykDRaLLPR4ugUQ7mblivE+O0x69nSWlFHRdh/aZ65G3RfooYyZjMwDZ+Tq6v2jfiAQgAtE44E5sfQTLrk5cjYnBTW/hcRn+numFMQtkc5A28UYM3XIcZAymbSlUuuH8vxv0tjs1bbNejyp59Tq2iawscNpeBEWcZeQLskg4ccfNPWrUeTZOvVrrXW6qOco09YM13AW1rzJ0Cp1oOeBW+RcN6zGA/0t0/PfScdaqMCiQm1tKjx0v8Xf1sU0UclH9X/8tKHid90GiLCYmVKRD+lVuXRijNf7uPDfxhnvy9ZApizkUjHg797HXElbz3MoLLoQNeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3V72DmCiuE8pcMsNcA07EDPaTSVfydYjdimetTIbzM=;
 b=RNbHXgSnhjm03Dq38XYRpEacZdHdz4CNRPzC1gzFFIp5jtOEdDBIRus8mBy4vcxNfjruSqrUpxIut8iuj91pCzkzsz4OISa/zTEcMy4ifuCdG1028dqTJucMBuDrETcHGSSTieqIptq2d+twOYFTN4u34aNpMWfsGGKVslHoqkYWAShQE02/bEE1G/N1iAfQMOgTpbX8fGUz6WAk4X1A1n1DnoeyisR0lx+K+MGZlmzrXSKoyVkNfhXWwGgH8D+mmeAU4q6vUn2kCH6YjX/IFhEb63HMdFHgExc2QgYP7as3XBh+fyKVPDEalVr7YuvelbEs8XZ7FWhOSOUz6hWmKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3V72DmCiuE8pcMsNcA07EDPaTSVfydYjdimetTIbzM=;
 b=DT3g30wFywdu12vthdrDtNCQxk/pS+SP1Mv0TOxlhD8wpb+y1PvNC59KzEMbHbtTeurt+Rezo3YnVaxH5bhT26MIjc17cZwDf03gXlzAixuZtwICwU6c+y4c5cLFn/Bfarxrq6JleeC4sZMQ9YzsDQiXipG2DcU/blXqeFuBE3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by PAXPR04MB8672.eurprd04.prod.outlook.com (2603:10a6:102:21f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:26:20 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe%6]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:26:20 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v4 0/3] Add support for NXP bluetooth chipsets
Date:   Tue, 21 Feb 2023 21:55:38 +0530
Message-Id: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DU2PR04MB8600.eurprd04.prod.outlook.com
 (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|PAXPR04MB8672:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c053a81-145c-4177-8bb8-08db14285d5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGNInHsgKnBir9eqjXVpfjje9rhSWA5Vu4puSov7HWFGFbReuXE71Vr1p68fP9qvLHJ3mn7GAJhda+iHCbDLIM5lTlj12t0mY4Z+7tCH+7GMFevCQalSbCkQKfEklX9DEfGlRvOF0FDBuLgepsjcKv9UjlR6AFT6zGDHRR70jE2Kj6ZxjstQ/ZBu2SZ44p5zCSKFFa6AhGExd29sp5yUbhbgECLJ8BxHodHaoCVfGmg43D6Xkr0PT4EdGW4aCRps5LqJfnD694/0lT0qyaWMkGn4KNaT+1ef90bxQkJZeK8dxpX5qBlc4QLhDNCuGabSTTqgJlaqENfgQ48CNxYoP4jVN5FrVlDQqHOmU+2v9psbT66AOvBI0X9VJ6O/ugXbLwYopB4EvDEDxb0EdppcImZ1JLzA2ZUfA6UJXPQ/EC/xmphfg610PQJFCAKRt8/94PJswmwYkaOw1sLKLqYKslZShFynRNU0JjTJVBME5doTmmeRv0iZby+ofRNFotIjf9PSJk5chJoFyVTNrQ7IbBLu97oiHBL2rfF032JQ/ZOiVJ9z3W+VMd69hLl55kxUY3lHQMZxSfjJBGfihU/9n7lJQUaBhIRVHt6tq3LmyLyPtJ1KS0gISSP7kZt4C/u+fYZO534EAmMHrglfy+9TeIFMTA8mvhcerc8zVDuyNKIPjtPLkP3KCAYqikoT1xZdJH1utRcPeeTpm6GCOiKX/N7T0BgkBEa6xRZ20+NDFuU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(86362001)(36756003)(41300700001)(5660300002)(7416002)(2906002)(38100700002)(38350700002)(83380400001)(921005)(8936002)(66476007)(66946007)(66556008)(52116002)(478600001)(8676002)(6486002)(186003)(316002)(26005)(2616005)(4326008)(6512007)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UIs53xEyjR4Rw0QBQ7np+9KEH6Pm6nZtEelX3VJ0n9MLFh+oHj/x8q0QmlIA?=
 =?us-ascii?Q?geGUSyMhYYvwroaVF3z9FTZO3H7wVrt4qqFqcu+WcgLsLj+bvLT1gRRktgd2?=
 =?us-ascii?Q?XLflfRte6Lc52cWWA2wiJY5A54zLzzT2pF/+UbTC0hrCeSd5lN79k7T8ipJ4?=
 =?us-ascii?Q?oV4s9boJkBoh+gOiQPMKhwAK4yzzl8rwiSLx3EAWfJFx7LQILyEu+NsondwD?=
 =?us-ascii?Q?2qLpkTUa6LRQDedggbGWHmgV0thXEtBpQ+gnNJVyqxbBIndtYDvqoVZcP06X?=
 =?us-ascii?Q?V28FrcJDvULZCPuaP4DvtPCsI8sKF46Bz5Ljg9uDYeqaFvUoGPrrZTbJ7SAi?=
 =?us-ascii?Q?xPCTyXhpfcrpyhrDDmaB5+O3gBndLHN/syW2al/esQAtlrrzbmOgHfqh31BW?=
 =?us-ascii?Q?/TAkixA/KC2hXr4ARzCjC0yO17+7ViIHfYTg9QlljQhkZVB/Ly0FMW2IhhZT?=
 =?us-ascii?Q?DmjCDBrVOQGgGXKzyseCROgSNqG32oxniGZAiRbPbUg6C4F8D4qLkpmiYhqU?=
 =?us-ascii?Q?TG+GkMWO0YaAosH1C8tCtozyXBnoXjH6NwFbdNQP/eCqk4vwiV9MNZ7lH44X?=
 =?us-ascii?Q?V2srTFnletoBtK3Ljcr/xoxLkF80yPPY61uvOwDxBecqKzoa4msFHihRiht0?=
 =?us-ascii?Q?SnAJqbptedtxAaqTMZun5BqXCFa3eNPkgNTlG61lZGNcCBK0tX4gFSQeRV5a?=
 =?us-ascii?Q?g/SPkb415WZvU5evsPew6UliDtD9VPuV9e2M8KwTrve/T4gmfYhBof8WvN5z?=
 =?us-ascii?Q?eDCK3DXEzI58kVUrROmDE2uC5CbXkbU0BM7rL+qx32a6IVOFNEd2R7C3RQvC?=
 =?us-ascii?Q?J6O1NMR8drRz8n0RM6N3cl8EAZPOD9qQZj8Cnd9JGsKXtJ1zWGULeNW2IRYM?=
 =?us-ascii?Q?ipZLrp9br64MOYimCGdFThFNyQidfpbWtTVzhKpmUxwMuGZIXUJaIUXb/BpH?=
 =?us-ascii?Q?Pu74GAsBlKD9o4ljZeFXEcjldGwr9FIuf1rG4UELGvx0P8Uix0Spi8OzMbxt?=
 =?us-ascii?Q?IKqtdqYsKzsU/7C8frdq46eksISAtLaPcg6V9s77FCYIOIVPk8/iHHteNFdW?=
 =?us-ascii?Q?rJfVMOP8D+7ivSo1BRVp4RBY628PxoEyC7I0DXj8T1xZD+I7DHFZSPcmVqZE?=
 =?us-ascii?Q?FBMncL9WGczBE8antYPHQFLlyXL1GYuO8em81iJjt5jlmx3rwUgr+pVpNsmF?=
 =?us-ascii?Q?djU3qWBWMdzxM1zZYooT8cJd9QPWTNf7l4uJH8Xk/IgeesZFGSq3MHoslK8D?=
 =?us-ascii?Q?q3ICiIMTY/n46g+agZ5O+5FUbWTC/ibIrVq3LNvbEuKYYzxuHKQjt150WEEi?=
 =?us-ascii?Q?Ks7zYx92/Ki5rAa9gHXMDE788eeu/YW710oav5gG7GOV/44F32Augz1kFn8E?=
 =?us-ascii?Q?AY39x88iTQv8xCgNfk3MPjr1/IlQqlNZtyoBZRR7kZO5FO34dAa0Z4qWpiip?=
 =?us-ascii?Q?4uISsxtQoRpiFU2oCK+DhuW7DtLWZpRQfKyAJS/ru4iihxjKLNN8g7+FRV8S?=
 =?us-ascii?Q?NaQaFVnPXtu6WKA3fnsrJ23prWknHuPslllqYJVkyqDCbBjS2LZwxJfVrnSM?=
 =?us-ascii?Q?GB6QPnpYytGz/Q1dtEVin8pT+KvcGdRFXMibCsMwlPYMwqHKARer4uJSURo0?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c053a81-145c-4177-8bb8-08db14285d5a
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:26:20.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Vp5Cxvs2D6HICu9eAWSDgUfQiMbp1R2QImw+zlSSoEj2lWhgtQ6eVhrsy/2MUTkSX18wcCSohHuB5s+9bEU2LN/977s3O02G15ty3aUaLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8672
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a driver for NXP bluetooth chipsets.

The driver is based on H4 protocol, and uses serdev APIs. It supports host
to chip power save feature, which is signalled by the host by asserting
break over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been added to serdev-tty along
with a new serdev API serdev_device_break_ctl().

This driver is capable of downloading firmware into the chip over UART.

The document specifying device tree bindings for this driver is also
included in this patch series.

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../bindings/net/bluetooth/nxp,w8987-bt.yaml  |   38 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   11 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1292 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   17 +
 include/linux/serdev.h                        |    6 +
 8 files changed, 1383 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

