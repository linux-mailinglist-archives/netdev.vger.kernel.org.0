Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7975AE258
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbiIFIWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiIFIWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:22:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80088.outbound.protection.outlook.com [40.107.8.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C23272FFF;
        Tue,  6 Sep 2022 01:22:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lR9gln8cb8//TaAtUdhfr/I7TYSMKIIQJ2+Pw79CGXXIpHIoBnjVlCEmxghnknH3RwzefqYsEIO9GzOBictgQuHzXOHJurR28WS0HKTypjkww4HHE64Vp2gn1/Z+X6t+X25Wu4K3QGOm87DsU9AV1FX2ixjtvxSnrzLrwXR46vlzjuIoupYnY+aADW+BwyfCAm7rvJND6SdUDki9XUWt/ruQhr+v8ZOleH/gP6TMTQdflUjuTXoTHu5nXrG+h6B+nTLzy5bdV8ZqFkAGTvnG9T6EMLBPq7kYK2bWlVkE0rJpQTnNpjtW2+T3srLnlrw9QK9KENfFFIkuOIN+2Aldbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1M4x/gfQtitekY+Iv5AO4y7UdrrC+qbvH9GZv1rNp0=;
 b=FiFbxmRjs/TSlG7/e94AQXjGvqodRHZbUIuV5zjGeYeni4cvNh2aDFy6xxcvAMsGlWBxWERUpCojGWw9fe9ExPTr8VKRhp6RTK7OSv1vMHLm9r5Wx26Tmz1bKNkhpX+IP7mHfOv+zFc8XsFYSdk+vWdj3AJSieebx4CCLzEZ48EydAeCWMWOzzsaTfwuWj66P5oWBBqntAF+TINTAmN7QKgX7cvM5cGYAV+skUryLgTna6DD6bwy7KEdS+SJ7x0Xo39wP4rgjbRQC64mBUTvamHOO1kSLSTklUl/IOx5L+rK3nXwowiKSVLsvYbrVgkJpBbkqEcEXy2G9tsb59WE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by DU0PR01MB8877.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:350::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 08:22:25 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::792e:fa13:2b7e:599]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com ([fe80::792e:fa13:2b7e:599%7])
 with mapi id 15.20.5588.012; Tue, 6 Sep 2022 08:22:25 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v7 0/3] net: ethernet: adi: Add ADIN1110 support
Date:   Tue,  6 Sep 2022 11:22:00 +0300
Message-Id: <20220906082203.19572-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR08CA0231.eurprd08.prod.outlook.com
 (2603:10a6:802:15::40) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2639b3f-ad04-41a0-f044-08da8fe0ed83
X-MS-TrafficTypeDiagnostic: DU0PR01MB8877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RcMsaw87MLa5H/NCluJkAv9OsLbKUg+OR1MxO6t+pAb61ZNnBKGJF/H4CUfkdi7wxB2AEnAjNcAoSC9/9Y6VThkx35ZteOi0LqUf30ZOtsX02+hOpCv8DZy0Udz3W4j2GeTtsFySn1drm0ntb4V3f7fwJZkA0O8cCLW0nX5h37ddMxS9E4lF+4E71QYFeJzt6bqGQ4eVIlvKuj363cys2DYavPOFr+T+K5BDoxdSEupC3DyzYHRHUBzq6szue9HHXH9yOgCUanAT42vpprqw2FR99ADIv0htj8wbS4BldaMzVNm7dHtT60OFdhIViAPWhs/DaaTnQ+sSsfkziD7foutslLxMafgc9VMRAgkzByWpqzHAhvz3F02ym1pGo8KBJon1AEUS28yeyYMvvB61tbC0jBVM/ddbXqXLRNDastN+VOF5B9guwvh1cPshC6Iax/vU824SCJ8FLYq/X86m2xO5eM++/dtd6HrZ7Q9/uqKYrWo/nW7HQAbWhSKvMD10cOOe2dCpHRz75GFEMI1utQX/f+rS9B0iQ8YGOS0xzQw5BcBm3xynvW5aaU7KOeciVzIDae+laJm7I8ubJcDVkjIzcKFJGW3FHj6X3D5KgRFtVvPBixuAfEWiw1ZtDxU+8DMvoYP36K4+LoiX5PM65xHUEdNEJ8LyeolT1cUx/2cFlwBZdOeoMt1dpHy9E0YxSS/DD67My+5ZxCdJc8R4/6c50Yn3TpBLEQ6FNmXDRa0wDTovhLgj1wiEGxpaCnaK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(366004)(376002)(396003)(5660300002)(2906002)(66476007)(8676002)(4326008)(8936002)(66946007)(66556008)(316002)(6916009)(786003)(478600001)(7416002)(6486002)(1076003)(9686003)(6512007)(41320700001)(6506007)(26005)(52116002)(2616005)(83380400001)(186003)(6666004)(41300700001)(86362001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IbDgYpPiuZzb0hYiQVKGvv5qWErd7NghL72Yrw0F41UOGgqYCoUkXfJtxaFD?=
 =?us-ascii?Q?8o5aoH/coSyK4rP5NeL0QGWUfR3AIo1PmF0jYK4RhlEGXYg5HOKW+dI/nVPC?=
 =?us-ascii?Q?kOOh5RJDvo/QlXgHsaZbnF4cerkmeu0/56OS4gxKL8Ff7JSi0cDWz4jrVOiI?=
 =?us-ascii?Q?Z/UJJvXfaH4UhJ3vk5RbiMT4iGEa7D9ac4ec2ez7gmBz5h98UNATvO34ZRbA?=
 =?us-ascii?Q?RABw8E8ekpspE1Z4nXcPaS66fRPTRPNcUbABkyGyF5FtE/0ztDeriAmTxIbc?=
 =?us-ascii?Q?QM3Ij+VtssCbrJnZqhQg2gh3TKCfUKH9odzHrytcc3GASdwoZBOf+Q+uO61d?=
 =?us-ascii?Q?PUtTwl1a2UyHzdG/VZtTjAWPShEc77uQj+YY0kz0UrJutl5OMf4KV6L90GFi?=
 =?us-ascii?Q?eceS2/AOK4aHEUBRrfP6tPy6BL0E1dVS+CLTZLeS14gvKb11Llz13dkaGuFx?=
 =?us-ascii?Q?VCQrVqJ/CLSqSbAaXdul4803p+jfdVMSCpkx8GF2eQFf9A7abeMQCycAiQCL?=
 =?us-ascii?Q?DJenaLBZi7bRwIBCf7TbWbdWYdTNO23qmAN20BVjI/t+4u6gTVayC/4Wswzd?=
 =?us-ascii?Q?SJKzQqjJXtYd3zw5OiEo3ltqqKD8Kfzhni30mFb018eB30h49Udc/MuyHIYw?=
 =?us-ascii?Q?h6PyLv/m1EakqCOdI/KhUpWLsdNfotk55mm5Q4lBNg5jpzDGWK7sHkbGq8lv?=
 =?us-ascii?Q?CH0ufoEqd7qzH1Up0GxLTbyLRQpke2NTt593HcjOqDYcQQzwQYrw89BW1Gbz?=
 =?us-ascii?Q?ti6nPfVjyL26wfIbWyYtTRCPbyAj48T5iE6yuCPXogxRbw6SJKGAaSpkz1E5?=
 =?us-ascii?Q?0fTvjFvlRluXHHTY4ll+Rj3KoRAnan4F5XRPNyRa136WLRjwogs6kE+IJ4IP?=
 =?us-ascii?Q?IpMEvsMCIIpnDqOhjqje2V9jypuZ3lWDUcozh3tSBi543WoivmHww6kuOqBj?=
 =?us-ascii?Q?dDtR7RpG3qR0XEEMCrdNt9IBot9GihUXz/nuxBL3kgbVFZR2/TLIQK+Y+9+U?=
 =?us-ascii?Q?PnwbtH88Wb4R1RrWz31PK0Wy28RFPDYEltw2fAgIckMe6fPBMJenEaTnmuKL?=
 =?us-ascii?Q?if8r50TGe4Pf3YxzA5FaAPYC7jiZst+03Lh9+MAP/VwId2V3HaGwQq5FkFTW?=
 =?us-ascii?Q?LDhU4MEWjtnaTcKx7wrPEcsAzsPpcGy0O4oSwkrh0VcTDqiGS5KEkHEnglQM?=
 =?us-ascii?Q?+I1zhwve5YZcej/MDrQPTsN+HA06u+ZtfeebRpKIECd+giZw6hCq/iynvk3H?=
 =?us-ascii?Q?QE5N7/2URejiy50wq2S4jQDE8MPjNNoorwjDR4kA573laFDOhBKHbgRI44tj?=
 =?us-ascii?Q?b45az7UB3+gMjxnSLcLRpGQgyiubBzfXI08ihFDEiVGWPPdj/dg62UCoOH6c?=
 =?us-ascii?Q?uVDyRXCw9C9rQMD/21why1l0i/u5ukLAqyZw4A9T9WFShWpEvxniyP2Q4Vb2?=
 =?us-ascii?Q?lMf7fp6EqGOqB4aOeKs2q8X4QAIBSudneP5WDeZZHEQa2T4BxyxEivRn3Vue?=
 =?us-ascii?Q?P/FpyA+n8ro+hUoixr4uouvWsf238iyj9SzbmsV6go3OdH9+g897+vVjpnEo?=
 =?us-ascii?Q?d0FccQOshmXMR/5dA68zyaHRIjJ4TTplznmFcAu4U3MwwiP37DBOmMVGH7th?=
 =?us-ascii?Q?j+kp35QEtpCwk1IVyWzings=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: f2639b3f-ad04-41a0-f044-08da8fe0ed83
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 08:22:25.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNnk2WgZ2WpBNax//VePj6MNlv2NZFIU8o5IHvq9aM/mYu45gX6f06pc4fVr1dvGMy1QSUP0e82Av5dMeb5Qe+jhBXXbf5KM2HHD3C2MayM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR01MB8877
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

Changelog V6 -> V7:
	- fixed undeclared var. err. (deleted it during ./checkpatch fixes)

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
 drivers/net/ethernet/adi/adin1110.c           | 1627 +++++++++++++++++
 drivers/net/phy/adin1100.c                    |    7 +-
 7 files changed, 1746 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

-- 
2.25.1

