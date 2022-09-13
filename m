Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA555B6D36
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiIMM1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiIMM1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:27:08 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0791E3E2;
        Tue, 13 Sep 2022 05:27:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPkBAdKgVCqDL/jPYqKD6ViYVola7TyWF1mt1feWyTpLgvAZrmPO6dbRoYrTldRY+4qsoFNRUADk6/BBh+5Xjd7ADJMPSpshXaSNUEY2l6cDyZav/xL19Hw69W4P2MB+TLWNOYeJsRNVANkt3kAlpltL052bzbx2fuPYpaGPyxT7t6/tlDWxSUnxt9tFgm5yWgP6LZa+JYTiH9SAW6k6E+VsPrOzaahoJd/gK7b2ZheRif/3k4PXdYnOXARLsh4MgVz8XGNlbnW63dgrP3ZbcNd4prgofP8peMtcfRD4sKs8ypug2bhKNQFt7vz12WnIGrXXM46ENgr6mlQk3MC1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8QHyX78UhinV67ehG3Im7DrSJrZBJKUTD5B7q806CA=;
 b=e/sjLoPHWdDro+7VQphEQpzdDed3OJkShfJLoVqwYfIvSk5brUwWnk3dTEnEvuIvEMjzDfwgJzxGGt3jfL+5NGfW8uQMC2Yhy1ZmaEXOZGpipG+MzWPm2K075OJleDwAv4Gfthh8JWHAj8TYNBkb3CIL1VZwcFzvDXDni7o2XhVzQlZ8kqV3mLK5kei13ltAhLHscDxgBO0wjo8EGSJ0L99qIoGzdkBYC1Ad0fsMk01Ut9LRJQbtmMBqF+Q6ehEbF9cR/VS+0hwlLQxMuFMA9AV7x4FInALeH+KjQfRMW19O2qfVd5zU0cfggB7Il94zZ3ou55s/m/AEUBLXWcmmSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by AM8PR01MB7931.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:3da::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 12:26:59 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::1829:8b89:a9e5:da36]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::1829:8b89:a9e5:da36%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 12:26:59 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v8 0/3] net: ethernet: adi: Add ADIN1110 support
Date:   Tue, 13 Sep 2022 15:26:26 +0300
Message-Id: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0102MB3166:EE_|AM8PR01MB7931:EE_
X-MS-Office365-Filtering-Correlation-Id: 865ff186-9225-4249-69f6-08da958340d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l72XeLIj7a2oA7bSs+4D04y6ZXrKBxGSjyBX8d/6SuyYar933YGKyYAplK/c2qwiT0z3HBy5mMIP0QijHYF/aI0etibCuKWA+b1KUMoHAZ2XZkG7ZdwX5IPGAUJMFmPf9LxcTvI2F7W228eSe0tDZBBTeRTDYQ3TgW3loXqIygJGWfcNv+fODLGDlPEzR/syUZAuC7rVWXZVCtn4cU7xiEsAZTq0e7RsoI+fvcetByLmaozCsCAgCbZbGdEuC+x790Fti17an8EO7wjpNenUZBg+hZ4PYzs3toyWWNlPGWfxQfKO4fdVlJSPlEsdURiidWJ6bgyU8Xm56lGBce8xDij3EIikMUXMQL9LuqZKG5AfLH8BBBAfJI4fTK3MIaNhuvBWflcrDPl8rOUZ7inTafrDUoe2n6YfB/LEhKXOihXixW0bB5JPNao2bnoXy/T7OpSiumj49S9tJHW02fvtwULsEKS6V/78h/OXW683nf8OKw/a400YknJQBScC/TGShvZRKZFjgpS6e1ZPjEzX9sKtfMBkPaPwtihRfZu5v/IqRvZI46KFFjjTUFKYJ9iuIG6w07ozGSDRtQQCfJoK99h1P1cykZYN2Ac3T3+fOTvD9i7tMovYuetsMWQ4PPjHZn+UwNf5ciFr2mFfTxi0z3TWpFfmrTb8zGY3sSIF23SFU1ulhI6LQXh7EFz9Pfk5KROpMEEyRdtX+t12KOfRwuImW8nSKpsV8bDVOqftCB9zWuVzOhkSUsbAkInlxQlE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(38350700002)(6916009)(2906002)(66556008)(52116002)(86362001)(5660300002)(8676002)(6666004)(478600001)(66946007)(786003)(316002)(26005)(4326008)(6486002)(1076003)(7416002)(186003)(41300700001)(41320700001)(8936002)(9686003)(83380400001)(38100700002)(66476007)(6512007)(2616005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6ckauCvt+EH7A565LyaxGdtX2ebRgtpUZueMfK1FIMTi2KcJ+6JG8Z3ePEU?=
 =?us-ascii?Q?kxVzPycNDTQHM2kQn0QqYuu5npM9MqkJLmLISioHbznrWSiQK2FirxJBPB+J?=
 =?us-ascii?Q?NHdVagqqzc4UcOLTT2R1k37zwxvEj8F7loMqJ5BfSax8Yf5neqBQvCPfWYMa?=
 =?us-ascii?Q?EjcYtRFdNFEb+0kpLR824Z3TtTqAXCQu7jGLqafR5W91azz1U+6vhdQ5eaQf?=
 =?us-ascii?Q?gp5G8FRJOCodPH0craPDj9JiQJGm0maUDsWoVoLzBJetT636nBtYjQhzaqqa?=
 =?us-ascii?Q?h2sauNmanJNeaxJo4o4P1w49yGL+8gnAsoi0rO+nzkgqF8heT6ReHbe4trdN?=
 =?us-ascii?Q?JE96bV8LLb99j/oiHwZ0copFo4kBeh1gsZM/MAI3fL+p3/0ahPygsEsBvJn2?=
 =?us-ascii?Q?U4+nOoguZCDdidD+QZ/ToWPPy+8aeBRdyU+DFbhuSvMR9wCNe8mFa6rOHfoU?=
 =?us-ascii?Q?s7H1mARPm4J9HQSGMNQqeJ+AEWthVI0I5IcfCoYLRR5RxGuR/hLPR+zndPWP?=
 =?us-ascii?Q?aQBeD1PikTid7MmfUZDc+RuskV5TCcJ1Fm2nOMeG2+PWSc4lFxtyzkJEqJ+l?=
 =?us-ascii?Q?xoPS1Ds9SWH9SbXQw+t1//AeQOJ0GfoUgt5SVotbMvGu31QlI/RVVwFDT6SK?=
 =?us-ascii?Q?Xqwf9YVKfbty0LnKTseQSngjyOOEdIclSJuMx32xZOngpx61ThgLBNZPbZdp?=
 =?us-ascii?Q?Najfu1zM69pNVySu7tc88Zog1YiBFvNxGtDsygAHErIuRhSX6rbOAdvh8Yfx?=
 =?us-ascii?Q?dmORfq39V746hsN8GrhhwOdv7Dp/ViJwxUGk6n6BTRTnofE8GFtPkwsTNVRW?=
 =?us-ascii?Q?Aa3vp94XHkekh3QkX1cU4lRRMBcQG2W+Qj8I8cwjLHT6ibj7utx4Jdeobzef?=
 =?us-ascii?Q?iq9Qtd6VD4qFIpDcX0fdiFbDXEpYyN9+mWIJdT2QhZdMdZm8KISvU5mcF0YC?=
 =?us-ascii?Q?NM9rXFHCl5yDkTGybM9a/uSQDNz0X0r5gIM0yDnNEAm+rnEbzeRlSFJLnC9x?=
 =?us-ascii?Q?fGKQL4emLXA/ZhndswaI1N6XBweLWdqCh1bu6Z5DYK8x7+kqlkwB2rWDBEoC?=
 =?us-ascii?Q?QBCI/aJKKsNJ9fXAfOYLGeYGI4Auv7r1Pr8OyNHtG2k/z+kZx0wtbnQWjFCh?=
 =?us-ascii?Q?tcqusRqLymd7xHmHShTaXuobQzQhb4Fw1MFfNcr/wheep6ow00kR4cdeW7p3?=
 =?us-ascii?Q?NPHgYCSIfl2Y8pth83+dX09rR310nLdiAToUghkBvVGYwZ+U1Gq0HAaSaqMB?=
 =?us-ascii?Q?JxKSH9bfiin+TY7WL3pVoYMjjolwLFnHG6XfvC2CNonoQik3h/DVqpl247Az?=
 =?us-ascii?Q?5DO7KQ3HW1vjMWxiVn8/urpw8t3IjutUjcgZ8wuZyety6n/KdOIixloPN/6j?=
 =?us-ascii?Q?78lGIa1DS06bi4VnVdPVNeuXD7pRlcB9MDWvHxQB89sQ+n7Hy+FXxxB6QxTw?=
 =?us-ascii?Q?U8jWXDMg1HO5Ovr8/VCIt3lFRWnYMhQTKjAGZo428r0XrA8qLgN0re8vauNw?=
 =?us-ascii?Q?uLuw29AekBAcQXEmAgbu8Vy79vvK/1wLYjGCDSnrVXTgAiMJxIZUAeWV3jry?=
 =?us-ascii?Q?My2mpsZ3jxxgq3mZdZFeZxZCkQzu+WhftU8iNcYfuvCaQ57HVIRHLdJ5Ez5L?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 865ff186-9225-4249-69f6-08da958340d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 12:26:59.0569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMO5jwjWKdQTNlh93HT2Lkfbaj77Gww5Vfnog/dOFwSBP70C/+lHWKWF0fQ2q6Bkr7R/sUwS3z9hQLCQ0Z/h5qTEbhITrMRRmGtIYAUeSF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR01MB7931
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

Changelog V7 -> V8:
	- in adin1110_port_set_blocking_state(): fix possible path where mutex would remain
	locked after return
	- in adin1110_setup_notifiers(): switched to the goto format of error checking/cleanup
	- where trivial, reduced lines under 80 columns
	- fixed over 100 columns warnings

 .../devicetree/bindings/net/adi,adin1110.yaml |   77 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/adi/Kconfig              |   28 +
 drivers/net/ethernet/adi/Makefile             |    6 +
 drivers/net/ethernet/adi/adin1110.c           | 1696 +++++++++++++++++
 drivers/net/phy/adin1100.c                    |    7 +-
 7 files changed, 1815 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

-- 
2.25.1

