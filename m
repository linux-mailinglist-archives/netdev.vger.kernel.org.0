Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62C14D3112
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiCIOjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiCIOjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:19 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130073.outbound.protection.outlook.com [40.107.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF817122F74;
        Wed,  9 Mar 2022 06:38:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RChnBvB3+0+6ft38gpc+9NPv9ZePISCTAYTdBKiFqGZ5PVgbErPJ9x0o94lAWCX6cJNvgrRJU7Ol9M7lk7R+XVoPcw21chb72S93GxpHNgXZoN4QwSfuPceFot3cugR6uO4lv5C4M92Ea6+DUFBs8r08OTBfrrmIJaQ5NO0otHa5hS2JZvfnSVPJPbSLA7lGGCvRnlrNzzhQG5K6dnO3v/o6MeQ4ORggC4CbGYfeVl4PzR2eYRXdMpANpLpMXsL8khEo2FBsivf8XtmQGpr1BO95iEDDbNbt3PbKBIoKX+aI2L2QaJbYNEf/ylt1kZQXiivtFsqeDyEJsDXG9OOMIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0VCasTUXaeikggrAN81JeYfa2grSxUwVk1CW6TATm0I=;
 b=VsVZM4BbQ0rBUqlsPR8Xyu3oHhfuX4tskloeE3V6xRmbrMX/3WtzeHl7DlDvJ5d2tJwOcBkdhtPXR3CZMRhHFfvKd9iNpuOl2O4JqF314U0gP1791Vo5AJH/PzODvq4YKKwOZr3geM0u64ZB+QGSfWDnLxi0Yl+37hkMM/t2R0d/AaBYyTBt5fKgTyP/+qriuBlndeP5pCorsgpHdsKaH5e+em6Y2UpizHlYktjvDOEn6duNC4eiBqrnLDO2V+NgEc06nFEOjYyV63OVHrgdzj8z49PWzcGNCTD9Eyi6VdITWjM/yljyBMwhrjIFq0hckdWxOgAxaMSZOZd/WdVkmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VCasTUXaeikggrAN81JeYfa2grSxUwVk1CW6TATm0I=;
 b=C19uuXhbg0E81fO8/79ACaJak4q1D3s6DeWcuquit4xDNJmITrO2CQAwD6LRbujlaUmqaqeetCDx2keVzae0+ks5qW4dM4YHvGfoW0H77TE2klti0dzlURk8kevb2mP9OXKTa5KLH1hYmdXAXXcXSeyMAN1MIjKIJpOkC+XQ/20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6223.eurprd04.prod.outlook.com (2603:10a6:803:fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 14:38:17 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:17 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/8] dpaa2-mac: add support for changing the protocol at runtime
Date:   Wed,  9 Mar 2022 16:37:43 +0200
Message-Id: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dc4170c-3462-4fcd-56b1-08da01da72f6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6223:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6223C8069314543A91894672E00A9@VI1PR04MB6223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnnrRrRNpNMjLTa8egYJS6iYtEPvliQn/xT3VEkA+Lb65PjdjhUXD3CiFXGKDYp1UEPr24/vAZMxJhv4uQoq9NFp3ArszJPGCsDBQSqFPEQI8zlM0dIFoidzWEuYT4DfaDVnHaC4x8P1/s7yzEx3Dt/gnq10Q0+LJAqw4sUgXP6RgGbqy7pX4lzoJuPkkH0Dw7TkiRMhhyu7bR8OnLa5dAYZd99QIOAHJdDI2yQl1ixKo/rBxTZvrbgJxoa9Ax2qbFNMkh3nFO0XAJep21s3X2iTqNBxMdT+1gUJ7wYRJfbZ58fVjZbxHmo0ZrZHDzZVVyY9eO1xq8YE9M6oP1ip31nJABZ2n9EBy6avTt6xAxKZbhaSWmmQSP0pokwhi9yUOfRCaQvGqrzW3Auem0jPuL7nvUDSiMYz5/kMNYREpAJuW4t6g1dyQIBCzhtq15O+o/7fjjVw86nI4jo88GBWSh0S0HUk8Z7AsfdBlSxCf1g4yz7/VMiQ8JfpXbNlJcMkoEqn+072tEag9/2/NxTkx3sHunM/SMW/e+ZshAFy20CLSa92WinfsM1QP6a+H+qiMPlx7fEkIulubvVCXw1wPqDdBf9O9Nb1c3sW81FdKmwJsjXzzY5d//18nrAqDczy5GC6Se4iRu9PEbt7g7ZUtvI3jy/RjoncqIubF4hVND+oec1gYBcumxquLbBW17O8vZVXY4gNlQDTNSQ/LE+pRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(86362001)(44832011)(52116002)(36756003)(66476007)(66556008)(8936002)(66946007)(8676002)(26005)(5660300002)(498600001)(2906002)(4326008)(6666004)(83380400001)(38350700002)(38100700002)(6486002)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s0wkzB3d4xr4kw/jHQPkW8FKXT5k/Ige0HeXpcKLnqxMh3Cr59NLCfs5hr8U?=
 =?us-ascii?Q?L9Re5re9ucUq72xrW20Ur+7Umj1FNQpz6ppv4aZHCFmzyPwvXllqIAIKzneY?=
 =?us-ascii?Q?QOLZpolp520jPd4PsSrIxSCpbSSRbMOSyky/5wBueqK5uAVkz3u4JljHLr9s?=
 =?us-ascii?Q?jYACgXWVvS8TKksSUUDq8+yPwdpgn1JZ/NDgsl25mZ1OqgzHYagoEPegyDhE?=
 =?us-ascii?Q?Gmul5TSexCxQOCZSFeP3yef9Uko32z1V0VXjPIvCz/cg9+IR7CnsWDKqlXrI?=
 =?us-ascii?Q?jdWtwCv2D5ddzDutFzCLYNfuKiIjemhoGj8LLzXDekqxqzkSCVyrfq4PVK1E?=
 =?us-ascii?Q?yTKNd3WEdXC52FHFaLEcfHxgmrNXJRqk45P8XjUIS+7mo9sQNB8pFyEThwGq?=
 =?us-ascii?Q?jckxlfD6ShRYn2qXUZe+MwVdg9vQ1BMbR3WQbhtXj1GCGr+avaOiYhMkosk1?=
 =?us-ascii?Q?LLNeRrPNQAsTiJDP9haIA2UBbX3l6H3LaSsL4MBwh+5BqdElHLpKbwvWwmvH?=
 =?us-ascii?Q?7cfk5e6VhsyZJXHvGobuuqG5DPGoMaFjMCI3X2v3C8/f+LhlqLiPuEWGm40m?=
 =?us-ascii?Q?sbxhOrKJ/gwyYWpEGRRQACgXClkckTbrk1eXx2uMJaNpbI2El5KaW3F+MjJw?=
 =?us-ascii?Q?tjS7cBxucATpU+1gHcRtnfFg1TUn61najHTUZIr/+uHNjTT8mPid6uNLFNs0?=
 =?us-ascii?Q?lBqVezjlKxHGu/JR5qoA/BWzjTd6TIJqmtu2JPsRXg9v8LQW2gkd+qtXNtS0?=
 =?us-ascii?Q?GSFuHZzGn03xsmeye4QkQ9bZ/Dwv+jJ28Ikauj/grkT1j+QkW/0OjtZAdewa?=
 =?us-ascii?Q?N/ShnSfM7AjPlwyKgBGeKq7Bz/YLPkqOh3gmS7lCuF4z+s+8Dq+7zrNTF/5V?=
 =?us-ascii?Q?Nu4sqAs+1GUwd3XTvRlwAmY3qGWCVrLgtP5auVbSTMV30IJVwIPeLj+3FcQR?=
 =?us-ascii?Q?OOF6d0IbgKj6WrGxUkAF2jScDqPVHWSjv7dgWh8J1od4DB16EUtt24LBVU8t?=
 =?us-ascii?Q?iUec9Es90tO8f5iGhgoTxp0KfZlbY55IULloPTqIDS9EY4SuPqv3dt4AeUKc?=
 =?us-ascii?Q?8SzZ3h25lBFWhmLnRkkEY+ANwU/RT0whpxdjh0JKihQYR6xgDn1f8xJ+Wd36?=
 =?us-ascii?Q?0DqX+crVTo8JWB/Xg/yEjj+P7ohgtl0fH6OsduB1ovDhUA/SjnVOGYfNiGln?=
 =?us-ascii?Q?M6PLsGyhTJWoTwBtqezA7N45rhEwRjga0QkttaScZXgAI+DZ0f2kCqREdh5E?=
 =?us-ascii?Q?MwNB3Z/s4RR8y8kIpW5kYLI2QxVdkqU0b34xqqpqGwymejZMW/nW2wDESCaD?=
 =?us-ascii?Q?/U1Id0lC31efNZmCHUGkCAddAy0ZwwnIgfK3I0QW5jVmiDSg+lO9KKc4lesi?=
 =?us-ascii?Q?CYkQkCiQOt4r/6+QDrTM2hPCR9lysYRkIOg8zO7EuPQOn2YlOdpNJr5to2ni?=
 =?us-ascii?Q?Cg6R3lC7HPT78hUgd9Gg91oipPBbJJPYkZ3E4L5ObwBYCxGsoZc2SZwR6tel?=
 =?us-ascii?Q?4AJV/4jrKM2Hps+vnU8NWAmjyD8WsfcfqoWOdM10ZBuNKbVoegXU7nCYsDVz?=
 =?us-ascii?Q?cS4QppF6q/h/tohT2kqTyB5fL5FxtWbXqjdHjaPeWO5NmuSr3CKWTqnQRXrg?=
 =?us-ascii?Q?498+cPWGyMBiTiB5ZpKafBw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc4170c-3462-4fcd-56b1-08da01da72f6
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:17.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6dC57Dxxee1deflqqEq1Bu3NGQBWYHJNu8/v3MlGH6vskGr/WtvBuc+7bNUmZqsUyhE/sjLyegV0Wo8tVXJ0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6223
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for changing the Ethernet protocol at
runtime on Layerscape SoCs which have the Lynx 28G SerDes block.

The first two patches add a new generic PHY driver for the Lynx 28G and
the bindings file associated. The driver reads the PLL configuration at
probe time (the frequency provided to the lanes) and determines what
protocols can be supported.
Based on this the driver can deny or approve a request from the
dpaa2-mac to setup a new protocol.

The next 2 patches add some MC APIs for inquiring what is the running
version of firmware and setting up a new protocol on the MAC.

Moving along, we extract the code for setting up the supported
interfaces on a MAC on a different function since in the next patches
will update the logic.

In the next patch, the dpaa2-mac is updated so that it retrieves the
SerDes PHY based on the OF node and in case of a major reconfig, call
the PHY driver to set up the new protocol on the associated lane and the
MC firmware to reconfigure the MAC side of things.

Finally, the LX2160A dtsi is annotated with the SerDes PHY nodes for the
1st SerDes block. Beside this, the LX2160A Clearfog dtsi is annotated
with the 'phys' property for the exposed SFP cages.

Ioana Ciornei (8):
  phy: add support for the Layerscape SerDes 28G
  dt-bindings: phy: add the "fsl,lynx-28g" compatible
  dpaa2-mac: add the MC API for retrieving the version
  dpaa2-mac: add the MC API for reconfiguring the protocol
  dpaa2-mac: retrieve API version and detect features
  dpaa2-mac: move setting up supported_interfaces into a function
  dpaa2-mac: configure the SerDes phy on a protocol change
  arch: arm64: dts: lx2160a: describe the SerDes block #1

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml |  71 ++
 MAINTAINERS                                   |   7 +
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |   4 +
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi |  41 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 164 ++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   8 +
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   5 +-
 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  12 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  |  54 ++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |   5 +
 drivers/phy/freescale/Kconfig                 |  10 +
 drivers/phy/freescale/Makefile                |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c      | 629 ++++++++++++++++++
 14 files changed, 995 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

-- 
2.33.1

