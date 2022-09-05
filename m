Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E38B5AD5CA
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 17:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbiIEPJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 11:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbiIEPJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 11:09:03 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2049.outbound.protection.outlook.com [40.107.20.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D1A57549;
        Mon,  5 Sep 2022 08:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haP56CwMEcger632FPPqctCF0LLBqCO3JPX35VzNV3fItYsOZdWA9RnTv1HeLo0zhgs6k4qFh25umdFn395DRNw7+6c+PSJxTlfvTp7zXzok6R/Olt9SPI4PDxo545ugLMx4fFOO3DijmdkbFcmPc1MXkJOSsWAFi7744xEiFu6f/HX+3glAvspMay3Pg5Wh3f86T/EMOvlK7nxtGt0GCef/JuP0pkXbcI66RDc1/+HJpsbxrmXMxA36jtGnt3ck04TJ3L+ZPHQjnQMIYoA8he4KlcO334B1qSQmvODUjPPrcclxSXtcomD/hBEfhLxfZ8bfrVDDxrJUGlh+KbzVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LrwjBkna2UBQbjgf/grZ2cYBchJ2Mol9BBKmKn9cvo=;
 b=hg4OYarrs46DR+SXzaQLi+ZQAWfV7VnHY0/IwwQsUAFK8Gp3RKfH3iIUw4lRKzCLtm+STIw1taLkzeWVwRf6PP4hisS0O+KXFQhHS71LGxtwekdDhw7LwLiotQk+aaMro4I/fyJ67qsU7t4Fd9whpQeGJyg/njdVTuIspKpLV6kfFe8FPwWbmOde+X0aoX949hwhQ9PGGhXN73G8CsO4sCdfzm5lETnZX3YwR52/5sI4LQrpud+BrJNz7SUWjm4Slm7CplB62Z3ORz+5bR3X5BBk+GdXdLpULU1CgoKl/coM7Z++3cC28OVvWt3ghsDvaNNc+H7+r5Tnh3uFqPFWMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by DU2PR01MB8655.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:2fa::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 15:08:58 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::792e:fa13:2b7e:599]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com ([fe80::792e:fa13:2b7e:599%7])
 with mapi id 15.20.5588.012; Mon, 5 Sep 2022 15:08:57 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v6 0/3] net: ethernet: adi: Add ADIN1110 support
Date:   Mon,  5 Sep 2022 18:08:28 +0300
Message-Id: <20220905150831.26554-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR0801CA0083.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::27) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7dfb5e9-ef20-4dcf-53f1-08da8f508dee
X-MS-TrafficTypeDiagnostic: DU2PR01MB8655:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2vgVjneB0G0rMn3jWzcYEd7wuHqFsNcJCrJcxkn8RFZq5Ud/wKV0EkIbAWMdkRzCEVSQc3lp9rCQBkxuUBsjKYRAWKYSuBpnjSuTvYg6NJXUxr76o43HBdA3/EONJZuSc182yo2w/KzL/IUYSxsyApq8Eagx3E6KOo4CVFTk9pfk53VXsFzS/+JRi0cYYiJ6PcXq7x8vJGGGfddYlNAG6Ey/nomsoUi5h4J9VgJahS6vCCxhhlZyxNw2iLNsqqK5AFCm7QKavevWLPDErwH5JQt4D+PDrXij0NRc8ULcx0Bm9E0uPpM8RPuJ9LhsL6FDaiXgZehsqcVOFVaWOse3itA2O4+xqX/EcE700XUUjfPpl53VvPz9IEvdc8dKNpqAJ3qj/FrPh4mSPyUcvkJpviG3I3pDvvXbVFcn7NUjZaSNgUote7clNOHXAY1moVtwCbnCZLdCEIBuxlf12EQg8RWMtUEWC7VqFFsaPtVClMg9YQSr+2yMuxSctcQXlLzAdB/SFf7IwbHJ8cVg/X+UPsGuLIXw7adtkiBF4sBiJy3x76kpQr1qi83nDTPC0Yh2uRdSxbhdT+fD0DG3hHn3dZHSNGUEhDA9BRuLa+rDpQSjOAm5v2NEV11zQTaAamxn8fKPUu34AWW8bcVHKsYFUQyhBkhJvyn398vw4AxxKvPSCDbvtnGMHzRpIQ/PGp8Wvi16YNJkdWozOW3x/n+zN+F1OgfkXFTSLTfQNSURkrIT7YozIwz6lJmzIZp7H3nuMwGD45mWQvLP8B7o2zQyTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(376002)(366004)(396003)(66556008)(6486002)(66476007)(2906002)(4326008)(66946007)(316002)(478600001)(786003)(6916009)(5660300002)(41320700001)(8936002)(7416002)(8676002)(83380400001)(38350700002)(86362001)(38100700002)(52116002)(6506007)(6666004)(9686003)(1076003)(26005)(41300700001)(6512007)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FqNVR2cJoJ5Uh76Qb94crMLGYP+0ANoHup9XdpYu24v3msOwj9XtlnDGDtRX?=
 =?us-ascii?Q?jqRNPw/JplCUNc0eegRzYkrA0Gz84Q2PwRSmQo6m4GmwpjKjkzBM8QOBG4f7?=
 =?us-ascii?Q?75LugM1z6fInYQx2qYwPe7YkHT4FYLDJhUloKTsfWUPHlWxLfMvpuXYRd37G?=
 =?us-ascii?Q?t4Uyx2BLwJHzCui77UvahGXuDXwYyp3GHoO+y7E9d7L9EkvKz8RWH2WL2ow0?=
 =?us-ascii?Q?ywFKhMjnS5KvfGobGtLWaju3KIL7HYyIluspLkl76r1N/50+KrcOFR/Lwh6E?=
 =?us-ascii?Q?BH0URiOpjJQynCfHSimVG/gy3qJshBHkyF2oD8QZ1Iyut95Nw3mgcrLFGyB5?=
 =?us-ascii?Q?7NIBJ6xus6lSsIrWuEB1r8DDhE+KQFOOOmsd46XLUEvZYwFa0NdBxfVYhn0s?=
 =?us-ascii?Q?nMDsKZvqA/211oA+OX0mNkrnMRJhZHWG7HirFXWfTZchuWEo2O830sCgrfc+?=
 =?us-ascii?Q?PWOgMoF4Huoyi+CPF7M2DDjWaWMP8m2bUTI4YtGnaraFcNYvpLn1FXfzWWc8?=
 =?us-ascii?Q?vA5qLipn5tVletbEM1CZ/eY93CqVsNGxNQjeA3S3XCOQpB1uSgrZUg6O3lhH?=
 =?us-ascii?Q?2Woq8WXVHo6zHd8GrhYanSvTmaJ4pa+Aa2UwwFif7wu43l8PwNrLZhNgl9Mg?=
 =?us-ascii?Q?Lp6sTIoyfkYa0nB6qshoX5tYIFxCkuiCGy/WNdNqHdGk97bS4tEMBy4Nw1/u?=
 =?us-ascii?Q?xGPgKiCD9EaX9/0vq1vNL3yAWSGs2YJqpjpLYFQpj0z2/lfEu35gbHeUsZBL?=
 =?us-ascii?Q?jeMNpaY0d0O3WAB5wWmbn+qEFjdt2/8sg8zuNIJRNpub2jCCASCeL/dt6O9+?=
 =?us-ascii?Q?KOrLkQ2s0oneY4z6UrIoVUTPvPoonPFxn7D7kbTIHQalX16of/EoNtpdA+Kv?=
 =?us-ascii?Q?kg5QCaMetGRm6H8hNzmUKayDCnjRo1qWQFSY5bVIY1kyt2YgQxH4sl/wPFXF?=
 =?us-ascii?Q?a4FS1V+ygImmngxwWIR5JUdQ98JAiLAHUC8gscy4QRtKZ+KRqx7awt8uh1AG?=
 =?us-ascii?Q?cKqWNMg0MkljOkpSXtkW1WURgA7oLBUTHCf8gofVNVFfSRUfd4Cmlb5hDsw9?=
 =?us-ascii?Q?yxu8Ald0q1Aq8W8s5utC9/07kzaSNv6wGZqHWlUVI8eSzULexRcDPogfNXHG?=
 =?us-ascii?Q?IDo+lv5vWIYvNZCZrzETn5sjlLK3fMwGCbW8tvhfYdaxglcXbcotErCjyrV4?=
 =?us-ascii?Q?P+8zmxQO2KpuzFm4pzIFY/ypwLdKPu9jzklHPMt0Pb9ubHweqgRO7CP+X2wD?=
 =?us-ascii?Q?DXZzQ2Kv74EDfxlnHd7yOuZ3dHioFEUnPkTsENpbWMss0uC7//rN47WDYia5?=
 =?us-ascii?Q?7zZSv9pj5Jo7UmOBOt/cm/DOS0ZOJfjUG1Z0x34Ulieqgz9bIK+sN/DIhZ8D?=
 =?us-ascii?Q?nNuOW+Xi5OJNyldYHmyqmkJpcMSzO0Qo22mbciJdkb0tdniNAAvgPISrkWY0?=
 =?us-ascii?Q?xcXCJvTIzUwdSX8UGPgALU6UG6Dsmvo8R3v+KSApWTXzC0Rep3Iadbn1SfuM?=
 =?us-ascii?Q?MBuJgz03IAwmnB8eKjwXXzWqWyxfKjBrbEpJ1Obg06YvzyP61o94GdwfZLJi?=
 =?us-ascii?Q?rrlxiswYve93u7zLWXvvj4kS9iuDq7LCqjcAmogOINSmJrZcPo0yi6q22UNG?=
 =?us-ascii?Q?s0DoooI2usy1RAn7qjUEzpw=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: e7dfb5e9-ef20-4dcf-53f1-08da8f508dee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 15:08:57.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rkf9zZ8sqJ/UUn5jEo0tBKk557DwcoLJVyXpXUgMW7IrY3gwJjkIy4E5wdEdwNbtjWesgJP1btZ7Q1D4RZlRrWG8p8y6rSsI6UpVrBqnegU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR01MB8655
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
designed for industrial Ethernet applications. It integrates
an Ethernet PHY core with a MAC and all the associated analog
circuitry, input and output clock buffering.

ADIN1110 MAC-PHY encapsulates the ADIN1100 PHY. The PHY registers
can be accessed through the MDIO MAC registers.
We are registering an MDIO bus with custom read/write in order
to let the PHY to be discovered by the PAL. This will let
the ADIN1100 Linux driver to probe and take control of
the PHY.

The ADIN2111 is a low power, low complexity, two-Ethernet ports
switch with integrated 10BASE-T1L PHYs and one serial peripheral
interface (SPI) port.

The device is designed for industrial Ethernet applications using
low power constrained nodes and is compliant with the IEEE 802.3cg-2019
Ethernet standard for long reach 10 Mbps single pair Ethernet (SPE).
The switch supports various routing configurations between
the two Ethernet ports and the SPI host port providing a flexible
solution for line, daisy-chain, or ring network topologies.

The ADIN2111 supports cable reach of up to 1700 meters with ultra
low power consumption of 77 mW. The two PHY cores support the
1.0 V p-p operating mode and the 2.4 V p-p operating mode defined
in the IEEE 802.3cg standard.

The device integrates the switch, two Ethernet physical layer (PHY)
cores with a media access control (MAC) interface and all the
associated analog circuitry, and input and output clock buffering.

The device also includes internal buffer queues, the SPI and
subsystem registers, as well as the control logic to manage the reset
and clock control and hardware pin configuration.

Access to the PHYs is exposed via an internal MDIO bus. Writes/reads
can be performed by reading/writing to the ADIN2111 MDIO registers
via SPI.

On probe, for each port, a struct net_device is allocated and
registered. When both ports are added to the same bridge, the driver
will enable offloading of frame forwarding at the hardware level.

Driver offers STP support. Normal operation on forwarding state.
Allows only frames with the 802.1d DA to be passed to the host
when in any of the other states.

When both ports of ADIN2111 belong to the same SW bridge a maximum
of 12 FDB entries will offloaded by the hardware and are marked as such.

Alexandru Tachici (3):
  net: phy: adin1100: add PHY IDs of adin1110/adin2111
  net: ethernet: adi: Add ADIN1110 support
  dt-bindings: net: adin1110: Add docs

Changelog V5 -> V6:
	- removed VEPA/VEB settings support.
	- added support for FDB add/del. 12 hardware entries are available
	- ethernet frames with an unknown dest MAC address will just be forwarded to the host, not
	sent back on the other port. SW bridge will decide what to do instead.
	- HW forwarding takes places only for broadcast/multicast/FDB matches
	- in adin1110_ndo_set_mac_address(): use eth_prepare_mac_addr_change()
	- in adin1110_start_xmit(): removed locking
	- in adin1110_tx_work(): rate limit errors
	- in adin1110_net_stop(): disable RX RDY IRQs for the given port
	- in adin1110_port_bridge_join(): on bridge join forward to host based on the bridge's address
	- in adin1110_netdev_ops: replaced .ndo_do_ioctl with .ndo_eth_ioctl

 .../devicetree/bindings/net/adi,adin1110.yaml |   77 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/adi/Kconfig              |   28 +
 drivers/net/ethernet/adi/Makefile             |    6 +
 drivers/net/ethernet/adi/adin1110.c           | 1624 +++++++++++++++++
 drivers/net/phy/adin1100.c                    |    7 +-
 7 files changed, 1743 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

-- 
2.25.1

