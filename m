Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3971F587F9B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiHBQAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbiHBQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:00:07 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B634ABFC;
        Tue,  2 Aug 2022 09:00:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNUtn8V9Q1k+HB29EXmoSXYIvt3qXemkE01EGMEZtKDdoqFOQ6tPRhfINHfJfF4SJrXR/0FucIE4luIFq1tx8PIpnuulUth/DX6Zhk9wk6CheSdzBJ2FfmfKXXWaq3LzbZ4CvQea7mXytBCCVN+bUkYGHzBV/tO3HnBUGUgII0rgGJ7COB8p3pBOhZg3wnGr9bOHC2SlapuLljOTBIdwDyNYSLTl29NAm+UB41Z7VRDo0DVZUh5kVi2d2+ULuOW0WNGIn+fDGH11w2XI4JWE1M0dt1YwFJgtcGOdD9/L/Oy/ZrlLTTYR/U+nnWX6vibl2oSduVT+xVij9TKA0lBbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKVFDdnBWk8revBQEEbzV/armHbUUvzGiViJgaxSFe0=;
 b=jCRuaFNt7jHxC2o1fKGbieD8OXc7LLZGqCd+0RctSnP97GjmnKDaT+1n3acelFj6Gv4GtU3RF7L719Ei+DzGgQN6NEfBwjVtbHuE/ZrCPxSRI/fonXDSIQnFHkZr37I3pTypp/eohRyiR9ipDKjX9YR9yvHCXZTdXeiDZrxiC/J0aTcy51A0/wB/XZtmNBTYb08BhBOYN07tx2zUKOdqE95l9bquZfu5x1WUzZF3TMt90iPPEaVBTrU5xYp3fwrVf+0c40HoIoKjOfEVTnWjbTmGLxymtX2keDs2tvkavz1D2DNZrlimvFxnx5PjE7SFva4I2a3/5OLLjJUVAvCTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by AM9PR01MB7252.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:2cf::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10; Tue, 2 Aug
 2022 16:00:00 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::85e9:83cf:765b:ca12]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::85e9:83cf:765b:ca12%5]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 16:00:00 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v3 0/3] net: ethernet: adi: Add ADIN1110 support
Date:   Tue,  2 Aug 2022 18:59:44 +0300
Message-Id: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::19) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a260023b-abdc-4400-9408-08da74a00e1f
X-MS-TrafficTypeDiagnostic: AM9PR01MB7252:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTaGmDhI7AVf9Ip/RHtvRfYm2SDe1ogfw6uzNbZjHtiqCdN1JlWihEU7ajoAasN43xPOxmLcn/4nGrQmgv2zeBOk5KqVJsdyYGN9DaSx1sB3oT5pniwWz+0ah3QZi+1DjRayYcpvF3PhXnrlp7W4JdiVD9T1O77bVaE1oN1q1YDHI34Jh8PdDfMqa9mu6jG9atvE0Meju9D2Fs58W8MtU7g+Lhy6OvviDDn1Wwj52C+x/6c9gBaEOaNoP6+ry5mUgOB9hr0wppaLvJ9dPr+16fMNYB1fYWLXtzqkvTeAUBI4dSSxO7i9C8GhxoYQNEGFGUwm1fuWsIyY5816+qHfeatA5ssfyagk2nVuTztIHt7R4GWM+pN5p56vP2yykkv2fORuOimZLvuzeHUtdJlbTdwhgXUINno2N+LP6ct0VcrnJk1nrp/rzqpL6Co4+ftir4J+pcMgVrkGYIjSSt8rDLA96hky+1j5DD7p7qB/5P9QwMFj0oI/U0jwUlGgmODwbC+XAZMLa4QJv6KKjeZo32oK5RBJ2VD2OCNQHLrjc/P5ifhpbC0aSvwN9oKHF+3GQ5b4jXXb7SrVgOi9zVTmcGsLZ+38Z7Sao9wCCkRbwLyNWheGjgCfKkLsYe8eBv7iVl4LagP0U6/asiisFGrMi9kIhVqtim5orvy9h8QKUAOPY6439kv652TGKghiO+LMqnb8jcetGvkf2Spm/J3xfyATniw7gpKaKlMTzBlUk8Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39850400004)(376002)(346002)(136003)(41300700001)(2906002)(2616005)(83380400001)(86362001)(6666004)(6916009)(52116002)(6506007)(1076003)(9686003)(6512007)(186003)(38100700002)(7416002)(6486002)(5660300002)(66476007)(66946007)(66556008)(8936002)(478600001)(8676002)(4326008)(41320700001)(786003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uIU/TGNwtXAATGkO5yeb53pr+rfp8nTp0KIbGyAwBNMDeK9wsv+ExAtT0qql?=
 =?us-ascii?Q?i8Uh3m94lhDw1KXB9ZcM+AhfNewLMwzmPyYCNbGkfSfvc98brAH5vDyYqiWi?=
 =?us-ascii?Q?lQvc+/NNUd+WR83xOw/ppOVlqJ+sy9JTJCoCYsxSRBHdKk8cJv0rdwHFJZB0?=
 =?us-ascii?Q?LZKN1Eko8mbLpMLfz2dynK6ExWwOmE9hDeN6gxG4BqYZ8YNUaGebjnjllfaN?=
 =?us-ascii?Q?1Eb8e8Hzf0ZGr4oC2zxCCZ3pzzufb59S2eR2AzukxeB6zjdA3QAk28ePRSKi?=
 =?us-ascii?Q?pwS0t17aVRhA44x4IyYllLvcffv9qpmrnDSRZzq+piO+b0/W9yOZyO7I8xiw?=
 =?us-ascii?Q?jRjEu6MiLkYkyHQHz9eTUJqcPIEZuScV3RHteQIxHJkzl7dJSXyOrYifpyi5?=
 =?us-ascii?Q?b9cCIKhbrtvHJ2sembompGgkdIiowsOoKOGKTcyC31nj8rXnQDN2O91eA3bN?=
 =?us-ascii?Q?Z711NzscAUOiXJLXhFYHe5d25kdlna8UxspUZwffyn3AvGCVhw45VRlFsM5u?=
 =?us-ascii?Q?+ygEYTVi6rlw2PeALuSs52gWLul6tGj2GPVZqwl4/AsI7DNW7TsOmOnEFYAY?=
 =?us-ascii?Q?90FuquMtcmrKHwbvKLDw+/s848qo9+GbT/Qg4k+YDwFe21+YNHynZmDt4UAt?=
 =?us-ascii?Q?Q+py6QisKwI135gjZ6izxUe2Sl4ZhSIm8bD/x2uJNV7tdI9lqJahUL/tZj8+?=
 =?us-ascii?Q?B6REIRGMVc3I6bxjgiP2y2NlkfozAF9aOe/+EJlHuzZlBB8bY0JszalWc/nN?=
 =?us-ascii?Q?sKo/Li5UO9inTOvFgqU+E7609fF0xqXhV8x9MAFZhM6J09ejQ2sqWSy3uhAk?=
 =?us-ascii?Q?xSfXhmw6p4lP2YVR6STSWWXd9MYmmdtvPX1NDZRw0ZxQNdblQWqTHAHDgJYS?=
 =?us-ascii?Q?CpFxpnGmw0/eDKJ6i36N7HjgMVBzki8S/3Xk2RDJJ8Ir2AMfPuq2H5CzTZdw?=
 =?us-ascii?Q?zv1KBCaSLTkEojSVBaL7rNzqOvykWcJknAUBZwYNK78YITdVH4o2PVI7Z5nH?=
 =?us-ascii?Q?lQaddl/Wx57hTRWr04b7qrvd95nVOX0PrLGNmGqqooYrGGOX0zqp/S2Q248s?=
 =?us-ascii?Q?1/5oPE6NGf34PmBWBBpOPUDq0kQoJ4Ih13MmP+rMENKZBRMvq90w4oIpXYGu?=
 =?us-ascii?Q?P1Kj79hQ8Hzio+ehZK7fTQhpatHIdWXYBQXe3EUQ/V91aWjLV7W/6PQIABPZ?=
 =?us-ascii?Q?PETILi83fp+PJh4i/igm8kRcZj1/nDDzaxH/207dGOaxZ5+D/ztlNBDb1F3A?=
 =?us-ascii?Q?SPRPUY31ZWm4RUpZXMlSL25htuzzQ7wyI7QEgGv1V1Z5scOU1yNe3IqJ3Rzh?=
 =?us-ascii?Q?YxQOdnRK/CEckiYPFYQHot6fz8joE3RYWk4rU6hOHT8GbFB2vrmoje7ES8zY?=
 =?us-ascii?Q?zGpGgGS/fcoPHGh7ocPNHo5DRchTtaPwLD9Cj5xQ/lfZ7mh2oq++njkFrdb1?=
 =?us-ascii?Q?8GahJeYHL8mBCP1/57TCW9XtbA6dwcsusASnaXa47BR5oIw+SSRmd1HODH02?=
 =?us-ascii?Q?ZJIPlQ7iWLC0ewskbytTYoJXNje61sKgW/1flgWu8XhenSGT+FKqDJHqho97?=
 =?us-ascii?Q?FVGOy1H1+jD3uCb7TTTD5Jvw70ahdcilatBH5PCdOFUTEmBREynOs3vRrGA/?=
 =?us-ascii?Q?Aj21rN2KTwIl8/5RcfcUHoDg/lvWAUxZmtdmcCLw35ExEDg8YX8fjjwtbZec?=
 =?us-ascii?Q?NDnScQ=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: a260023b-abdc-4400-9408-08da74a00e1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 16:00:00.8292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yjBTdDIMaQMl7bXdMAz8WCHxfx9DAjOO6B27xaT/lXfsDyTxrOvunQ6bHBtO79MwxG5+h0rLICY5+YhpKDUNX9RTp5SDIH/Q7BSwxzGiAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR01MB7252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Supports both VEB and VEPA modes. In VEB mode multicast/broadcast
and unknown frames are handled by the ADIN2111, sw bridge will
not see them (this is to save SPI bandwidth). In VEPA mode,
all forwarding will be handled by the sw bridge, ADIN2111 will
not attempt to forward any frames in hardware to the other port.

Alexandru Tachici (3):
  net: phy: adin1100: add PHY IDs of adin1110/adin2111
  net: ethernet: adi: Add ADIN1110 support
  dt-bindings: net: adin1110: Add docs

Changelog V2 -> V3:
	- removed used of cpu_to_le16() for reg address, it was generating sparse complaints and it
	was not needed as FIELD_GET works fine no matter if host CPU is LE/BE
	- moved variable definitions in reversed tree
	- changed probe_capabilities from MDIOBUS_C22_C45 to MDIOBUS_C22
	- use phy_do_ioctl() instead of phy_mii_ioctl()
	- in adin1110_read_fifo(): receive frame from SPI directly in the skb, used skb_pull()
	to move data* past the custom protocol header
	- split MDIO read/write SPI bus locking to avoid holding the lock in readx_poll_timeout()
	- in adin1110_probe_netdevs(): moved devm_register_netdev at the end of function in order
	to have IRQs and notifiers setup before device going live
	- added possibility to set different Host MAC addresses per port
	- added spi-peripheral-props.yaml to allOf:

 .../devicetree/bindings/net/adi,adin1110.yaml |   82 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/adi/Kconfig              |   28 +
 drivers/net/ethernet/adi/Makefile             |    6 +
 drivers/net/ethernet/adi/adin1110.c           | 1445 +++++++++++++++++
 drivers/net/phy/adin1100.c                    |    7 +-
 7 files changed, 1569 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

-- 
2.25.1

