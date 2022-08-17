Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D903B597381
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbiHQQDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240243AbiHQQC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:02:59 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E49F1AD;
        Wed, 17 Aug 2022 09:02:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVW6cLI/5qw18zEOATQuxAOSZdya42jwS9cO0TMAzNOIofa+RL3D5h6kJMyUx0wfLe7a7rtXz2JqKX3qZZkCm+MwNADdREfYTa8e+W2xYyzLgveRHyfnGitR/X99cOJ0Zl5IoLDHtyjJw/H06/AbZuqUhmll/7JR7If1sinjCOlfT4QHa5/Kv1l5XAD7R99UoYbVWRmRrfsEocqC6aZnDVMkhr2yiKyY7UsyCOc+QWk8JCB9oOa9gReDic5Fq5e5CbUPCNNKUobSO9L3IhZx4qCSauoeXfiQvvUnoCDsNsQ46gD9d3P5KdHXptnsYhUuJxeLXjHVaDR3Sl/B4ho+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFtAYWIW7UCzgA/ZLZg1qASx1aHZIH6LQPC7muD11TM=;
 b=CjJ0UPGjQzdnE8V27e5k+57n+2mHa0+rUaP4beugX0zRo0aVZJz23pSALhh88s7hSMDGNqwOwF+gzg95AqSIuNKmAS85PSRBCMYGnR+A+evJZNKUocLz8azhb3pwvbWuh6wCli9v2qkoH8NdxEGY8gwngFOI9arQBwet8j3lA71Oj5N/v3AvA7Up4hpw3jjNGLGU2LhM50sRWV4xaS8AQ58ALVDoyOsFl2bH7cVrntIweotz8DTFMoUG4/nEqZApUYLuPa+k7nPRhHFU21gsbnYxEGlmCirJHavQMtSIDLxe+cyAgVluGn5LeL1ZBe9UAFDiDQ2+Bl70Wev6DZogdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by AM6PR01MB5734.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:fc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 16:02:54 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Wed, 17 Aug 2022 16:02:54 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v4 0/3] net: ethernet: adi: Add ADIN1110 support
Date:   Wed, 17 Aug 2022 19:02:33 +0300
Message-Id: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE1P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::20) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2be243d-5a64-4b25-d1fe-08da8069f17a
X-MS-TrafficTypeDiagnostic: AM6PR01MB5734:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgpKqVUmPEd2j42n6SdZGsxGIAIJ7LlKfk2mWPZ6B8r3vWK7hSjB2Qd/ntFLt3t3YxR0Z5EZeiozwAFQUkjfRyoADXhcXaaigwGn7cucnLrvBRT6ENoMSC6KmyX/aU8VngOtCVj31HENRMF0AMsyxK8RCV+Cv1JsP3hNZ4cOLnQRRmWrsSsgV9UqelihF9cY/xHCJurroOFREJq6QaUSw42f5m48qWfhzRu+f+iS8+xHwxvIxrFyXzxobpfJ8euOara75tVjuuhx9wanOCRrwNbG4mhAkbA+6drEzmZEHrjNSw7BhtaWoYxGvhclyaHCDbLchZa354gP7OSX+VgjavN5kEAv3d5P+35w5QGDAJR9zZsk6xg6C81aEuwhyesgoeS2JfGanuQorahuVQ5TK5xiTmNR40a+RVoJUpOmMurxEFI9ZRG+Js5IQAJPMeeoZA2RlMxlrSD+eIyZ/Aa3v12PBb/V4rloAe7vLuC/K3E7AuKMizfr+uMap6jcxvcoCJrea146aKTtxSrtJWA0u+GIX8+GsLw69IqHDhePJSFDw7SPTqihoR/JEz0uqs07SnQrGezjJ6dFkYKj0S7SeMUeXnxXvJ/0q6L7/bpj751NS/zjMnIf0LSm3guTLqjhzAtZdiWFLQWXv1b3k/QTWvRdggm3kwAf+NyUYaPw65qvF/2KpeGywgYZrIcl0tsqJEn+TNjDv/pI+F89rQzYYkzoyFn9MkZlFsDbwq0bsoI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(376002)(346002)(39860400002)(1076003)(6666004)(6486002)(6512007)(52116002)(83380400001)(6506007)(5660300002)(9686003)(186003)(41300700001)(786003)(316002)(41320700001)(2616005)(7416002)(478600001)(2906002)(4326008)(86362001)(6916009)(66946007)(66556008)(8676002)(66476007)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LL6shLp9RHSgbzgvrZhi/XZCz5Cc1aDkeatlR4bFoTzhMy0hWKMO2ZQlQWeC?=
 =?us-ascii?Q?2OLsXsQyndgHmu9YoSm8OfJlm5tYK3R4WWT89NeSWmID3YDxiza/yVsFfrCV?=
 =?us-ascii?Q?kdU97K2L+nZDBV/LQwIZOIDm2Lq5uAShXxVRW6flRynfhnFM5StLgHPreg7Y?=
 =?us-ascii?Q?nYlTg+0YmTzoY5ubMFAYH+M2Tk5epixF//U4/eHC/1iyFQVxEaox70REsZNj?=
 =?us-ascii?Q?JgQD28SCocqGofImKxquurLXZTVo+310iJcsJ1qa9Zo1L9adMyMp4uNpMAW8?=
 =?us-ascii?Q?Gvk0hQQq6s8dpFnw7o4JmpscGaQMc4YWhmB6T5W1L/bn8vSRN+vSXll1/sdg?=
 =?us-ascii?Q?I7hyIegBvclA9sQTcnVzVDb4Sq26icsK3wGOx/AuRvWoP224EEvwWMpeHRiy?=
 =?us-ascii?Q?i6ImruJBgAPdPtEvchGZA0FJKHnbHL9/2jBj1KW7G3DbBlGeT36lICnWAGXm?=
 =?us-ascii?Q?o20bwScAQeX7Vg3VQmyt7p4wgmFMvcyh7POwPlFSjSQAg9aMBcHSoikCRAEs?=
 =?us-ascii?Q?NIHlI7LqV5XaFkEH50PJxHa9vLR3Bl3QndVQtvsD95drF1+GatrdSvd2KMde?=
 =?us-ascii?Q?yNVyp5UGvghki13RmqS4QX0VFJVkEivoy6+GT78O2AaU3QFqzdL/P8sgaFSq?=
 =?us-ascii?Q?Evqko9FC1fkk8fZJbD06txumCNbWpxEj+u4/nm7cXnh531FVpHKKwzK/5sCx?=
 =?us-ascii?Q?s6huUrHZPIISCzZLYYcqOJMcg+v0zgTruRsIZx6B94bCdbDKG7+wAi+m7Z+L?=
 =?us-ascii?Q?2ZfMfvc+w+Plnc7XYEylhx2DvzAi/Y9xMY+t93hAJLVB3GtGge+/QEHqd2Tp?=
 =?us-ascii?Q?0veZokxOxeoQmbL0OgkNwpZjBRhvmYXimLCJlKq1T0svpvzKg1QocL+KscJU?=
 =?us-ascii?Q?+fwa7ADRdZ17CMe37+4+N5gzfRoVt5d/hsiAdydzqxrG9FyzzxL3T9PIinXA?=
 =?us-ascii?Q?zfBWw43rcA7JDbuGySSuuR3PH+hFoG09rHBkWGVykpTaHQ42M1IK9LUIfdmE?=
 =?us-ascii?Q?e0ngGzG+sOGwtvTeoogktg3gAskzPYXbHKTO9pd+VTbTu1zwQ7E+/DXPjLRR?=
 =?us-ascii?Q?OrUEq3xmb74oVGxeFxbhb1F89eoPw16fyRmWhbDYoSq79S5PbYVm5q3fWWUK?=
 =?us-ascii?Q?Lc7uKpZyyvQI7tjD3YsG/4zjoI3eV6xMZhVFBYjZBVX7WwT6f42JXSE6//Mv?=
 =?us-ascii?Q?eEiGFbjf6pxt0kCdqUL0/bP4IysB/ng8aJpGqB91nzQzxzc1FlJqU9S5muDL?=
 =?us-ascii?Q?ayZdhhruVzIhx/JgKrRZzkb/EkVxzhvSpEbaP1dI8hO/Xgf/G1hypJ5b1to9?=
 =?us-ascii?Q?fZu1ksmj+FfRgtqXVN9cbo5rMw9OzN/EeV51UyCZloS37wOOKmbeo2GuSLph?=
 =?us-ascii?Q?8jqUqAz/RTKdj5Pp9YDYzjB6RKNdpMkvQTZc6f2Q5li/ppIs/Sv+Usq8xdJD?=
 =?us-ascii?Q?SkuxWMRiwo572bsg2buo5H+soXycotwebGk5SXXf+elEGNTxGYtnJxgtMVF1?=
 =?us-ascii?Q?30MwI/Ma8y8n5vFS7BClGFnUiCNvTpgRiPsw7FqXVQ5kH3h6dLK8sKZmuI9G?=
 =?us-ascii?Q?6GGKtOcLFoNXgqGARxK+hu06U30vey/R6yreeTQG/2stGFpU0+ppby4DRCah?=
 =?us-ascii?Q?uDPhxO54IHBrrs/RW+LAwz+ninVJGIDKt94qH3kXrKfr0pqyPbmwPzVDnNFR?=
 =?us-ascii?Q?A19kLQ=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: c2be243d-5a64-4b25-d1fe-08da8069f17a
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:02:54.1063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwQWaQkrvEmk6qs/cX58dVjVFrnHcjFxcZQ7PemH4KL7dSEKQbj9xVw1fPf+vpWONbE/XnEeJTR/hOQqiCq8e1o2DuhMIvuPznduvsa4W7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR01MB5734
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

Changelog V3 -> V4:
	- removed address-cells/size-cells properties from binding and example
	- fixed dt-schema warnings

 .../devicetree/bindings/net/adi,adin1110.yaml |   77 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/adi/Kconfig              |   28 +
 drivers/net/ethernet/adi/Makefile             |    6 +
 drivers/net/ethernet/adi/adin1110.c           | 1445 +++++++++++++++++
 drivers/net/phy/adin1100.c                    |    7 +-
 7 files changed, 1564 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c

-- 
2.25.1

