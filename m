Return-Path: <netdev+bounces-1822-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B9C6FF37A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E27B21C20F5B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF2219E70;
	Thu, 11 May 2023 13:56:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11311369
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:56:39 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::61d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6041F40E0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1S1qvp9WDUqDp8CsGl5asBu4b4kEpumP0pXEfw8sgcVmZrwFBkmrFgLuBBmR0lFHZyCCCozCLZPRty3dreG3hJziuOdLDKq+PfaLcAR/aTuTSTelGoEUx0AXiLWK8qUg5LKxvQAvcAplU5ITCwxmsJ2r3PV5RkXkTIotHzVrOBQMYco1P3VAGlBm2I32MQx7J4mog9+Bf12Ez+EzP72FIdN8WEM/IHJ4rZhC57z2qwhdb59opNoTUz5Ox3xkLZt0viR8XpZ5YOsXIQzHB2j69/rCAIgKQmY3oTp55yV0Vm1FMLzfSn69BcPd7bK2vsQdPQX6uMtp0mr0SLCm2SiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PARArIY1H4o67r2jbzHFC9s68lGg3atbjQLIMHfePD0=;
 b=IPvtkr2ePKrDze/AsxYphOYRc9LvErc4BfZbeP41B9pBMETB/iRmB0GotDg90/gpTXVYdvA1qQvJmm+6LvgLArP28alR/Zpprl58s8qUDGctJoWl8TsfGrk8PcM7uU/zynVfx3d2R+jNM32GIVh44if2ICO5PWRyLQrGeLgk8Gv3lhZAO36h0KHqjlxYp3w3fJdcjYrZZH2zNNINSfIQOFMdDWzpdXqdJMI0Da5EW+0qm4YZh+WeKU/ls260RAxMDYJ8VW+wbisRAwYrHzxvdtX4GPkG2AWgmuJ0KY1fKB23j/b3cwYVuPFO31SfcN3Scs0nHoiUnwPD552F0TyQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PARArIY1H4o67r2jbzHFC9s68lGg3atbjQLIMHfePD0=;
 b=IOXC6UzszY4v8WdhB6i2vQJulQe2k4luVMmbks3PPpYt/C6hatviCfyxK+5SEm05fYLweNvVAYxaWV59KaS4tObpOR7bJGlUC0eAgsbpwzL52wBbuNBoT3RnPqGh5/8yZuawk6j7U7LrJ6HHm2FVWgR3gYkqLH+Dvd6LTIPGL8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8771.eurprd04.prod.outlook.com (2603:10a6:20b:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 13:56:34 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 13:56:34 +0000
Date: Thu, 11 May 2023 16:56:31 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add timestamp
 preferred choice property
Message-ID: <20230511135631.dzszb4zen26mtsqq@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-4-kory.maincent@bootlin.com>
 <20230412131421.3xeeahzp6dj46jit@skbuf>
 <20230412154446.23bf09cf@kmaincent-XPS-13-7390>
 <20230429174217.rawjgcxuyqs4agcf@skbuf>
 <20230502111043.2e8d48c9@kmaincent-XPS-13-7390>
 <20230511131008.so5vfvnc3mrbfeh6@skbuf>
 <20230511152550.4de3da1f@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511152550.4de3da1f@kmaincent-XPS-13-7390>
X-ClientProxiedBy: BE1P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8771:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf54e1a-2130-43e5-7660-08db52278817
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/0lEJMFDvcxfkbUorS8aU8Fm19ApFYgdkxiU14HE29UYpsQggWq/Q4OFsssprbiv7h8JunpZJHb3L2fhgDRD/cC74RlmcGGzR2KbHMWetmNFUjfVvw5oM2AzGUvKUUpxj3xKcqlPUCY4xcwqiJORummNUYJbiwGTml0c26VsqzOyZ2tkfQevbo5OFlWusiF+j33ReRgse7JfCqQP8vB2NkdLeCY7FKeyhzAUnM8wMFSggmPghlFm2bPg596IgVkBGAby1w+dlIwhv4KT7pOSUbMDHactxTy5+27ddqita5IKOHpGPbRQvuh++TzjYgwmX4Mqr99rBdYuxv2oxhIF7XccGeNBagR1246WxQJR4+a5tAow4uhmczQzZ0E8FVLq4M/Vjk9iyKgFwswqzIw8jOtiz1b2CNIfyvkHiu4VgGhKVwFZwbm8cPTP+XleujCOfLHP6ZQAsI9AsKXqDv0/C7/iWLHQzf4ytmqRCebhzSQ5BbEuHoiDw/+IACjuNkhcfADY/+ju+CznXsCwiiJjpdPUz+SFGuDKmxD3y6upU6EUCFbMamVstghxBWZ1GaNZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199021)(38100700002)(33716001)(86362001)(6916009)(41300700001)(316002)(5660300002)(186003)(7416002)(8936002)(44832011)(26005)(1076003)(8676002)(4326008)(6506007)(9686003)(6512007)(66556008)(2906002)(66574015)(66946007)(66476007)(478600001)(83380400001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?O5h6YwFH0cLkTeayEpCzQtm/0XrXyJ7+DQUb1Ryc6rlnzVV1Yrfbjw61O+?=
 =?iso-8859-1?Q?gsZbVJUFLmeVvrS0ZB6Nxwv194IfpsCHj0rxYjrQlw4aLEBj29jar6HEnr?=
 =?iso-8859-1?Q?511FZggTQp7OY5dk2zj+NCf7uYpzLRFmZFTEr7yFsbPu1tfo2mtr6WZblQ?=
 =?iso-8859-1?Q?jAc+KGILc8jA5rH0AqD0l9qKUW8uO+pG9aOHON4+iR/1QBlycLw2jRE0KV?=
 =?iso-8859-1?Q?gHO58hGqZ6o2athznp+2g6at3BYRKK763I+M8rwBnDcyrOUesvQVDT8Yo3?=
 =?iso-8859-1?Q?3yaj/Ib2eRMXwWfLazWpw0ZLujLWfyISKbg6MrS9ObzyoZinu/AEpB+3CC?=
 =?iso-8859-1?Q?xRwyRfCzF14aRBwdEOIHb8JqN1cTgeRkll5wF5pLvmKFyYL1KZej8htoIG?=
 =?iso-8859-1?Q?QL8cy80Am1MrC2zLott/KmaWQdfTLPjaJrHCTBZ0vQsO7YroJhlKtRxyMn?=
 =?iso-8859-1?Q?J0aaUdYYZXcxYCoAntYjBIseH9h0s8F2H1lS9zJdREm0Y5henonc9IrdPy?=
 =?iso-8859-1?Q?B0/pqRxUfCGmeS66LdDCqwz8zZUptunBX1JD+kfxz7dRfNQrXpstXj6UOI?=
 =?iso-8859-1?Q?6xmT/Vx+GRonybyK1j0qR2vflRZtcEFM9ramn7DTaZsQeCqcDb+pmcDnMT?=
 =?iso-8859-1?Q?oDtbpA3mG6XH7QRe8039KKDsX9YOEPyDNyzxlFkyxjDL6F1wU4zhU0h031?=
 =?iso-8859-1?Q?9Mk+7StGz/cosVL1YeNHM3r9Gy2DDJZZl7tVtyd/W5p3GtgEAQ+XpmAvyj?=
 =?iso-8859-1?Q?JvhFT/crNQxIGfGl42lbFJOg+Filr7JysZGNZ0TUd3jjwBMhXzT+kJgXre?=
 =?iso-8859-1?Q?n9lLJWKX1M6wgapObvpzyzarp1dAgJygOo+9sd8Znxz4DrwpA6n4VPZPhL?=
 =?iso-8859-1?Q?2qncbnCnlgLdYMnAfiBXjnl7L8cfbH19BfIRHzz6zKQUGvL75GYPuk7yFu?=
 =?iso-8859-1?Q?RD/vjg0u1lFLO5xLhCyL8x9BYZXy7Br67k+foHYzQLwNitzeR1V05sUtqK?=
 =?iso-8859-1?Q?ny9ixffa4VaclbtAN9FkQB/bxha05pSu03K4toGQSCv+FTfPHNTp5GB33r?=
 =?iso-8859-1?Q?cok4Xm4LPEBolfFs4XgIDXFt/PUaArg3JQSE8qxGt1Gq5kso2aE6DS8LGx?=
 =?iso-8859-1?Q?DxEVZnuQce6UOh6iSETdeBDXMYZSa7inWR6+RldebWwKnow/MAXwi4UvvR?=
 =?iso-8859-1?Q?VHvKN7BAXz+IpoTH/f0DJroFCxq2pjdJxJpGjzJhkNIleOaDciQ6BNmElE?=
 =?iso-8859-1?Q?a5OvAclKCe7FcheTmVrFDQ1mtD9VFIAsIGKgQwK/hic/Hi2gtBav0VdWf0?=
 =?iso-8859-1?Q?MRs6lM6llNaR2sxn9yYV7wCW95pI01jHlvEqkyhf6WXEXVT4wOXXpmjozQ?=
 =?iso-8859-1?Q?QqClo3hmGRgLIObmGd7m59/BYAZV88dYFK/De0emIHIqBErbJim88mybGY?=
 =?iso-8859-1?Q?skCCl0Rnbyi9XPvXWE21b+CxySSYYG0YmcJ55irl1IpsBLURR4B4R1140b?=
 =?iso-8859-1?Q?Q6gTvxV3dGwkx4PB6vEty1HDbBTy7jb2v2QtHT/o/YwmSx2v76dGFX3sQW?=
 =?iso-8859-1?Q?twNWl8vm2bF//2oWGv61dM55ECNzjm9kB688QvJB+7c4bUBIVSP7WZg5bQ?=
 =?iso-8859-1?Q?wa3fGmWuWj+7lmIEiNF4ZJ9GThPjA0AUz2Os0d4ELkr4fUZUV0AzFTWA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf54e1a-2130-43e5-7660-08db52278817
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:56:34.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edadQ8NnjTO9YMC3zHXm/0XLGiTX59d5EPMUf0l1C16ECuKLIssaewoNRi4M7+eMPCWjDQRkmz4H3pGAcCOJcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8771
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FORGED_SPF_HELO,KHOP_HELO_FCRDNS,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:25:50PM +0200, Köry Maincent wrote:
> The user may not and don't need to know which hardware timestamping is better.
> He just want to use the best one by default without investigation and
> benchmarking.
> It is more related to the hardware design of the board which should be
> described in the devicetree, don't you think? Of course it should not break
> anything and if it does, well then let the user select it in userspace.
> But if you really think my point is irrelevant then I will drop this feature.

You are putting an equality sign between user space and the end-user of
a system. A user space distribution has a lot of configuration files
where the end user isn't expected to know how to configure them all, and
that's not an argument for putting them in the kernel/device tree, is it?

I can relate to 2 examples which are closer to what I know slightly
better (Documentation/devicetree/bindings/net/dsa/dsa-port.yaml).

One is "label" (the netdev name of a switch port). It has been argued
that we should deprecate this, because udev permits selecting specific
netdev named based on hardware properties already.

I agree with this, and this is why on NXP LS1028A, we don't use "label"
in the device tree, but advise people to ship this in the rootfs:

cat /etc/udev/rules.d/10-network.rules
# ENETC rules
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.0", DRIVERS=="fsl_enetc", NAME:="eno0"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.1", DRIVERS=="fsl_enetc", NAME:="eno1"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.2", DRIVERS=="fsl_enetc", NAME:="eno2"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.6", DRIVERS=="fsl_enetc", NAME:="eno3"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:01.0", DRIVERS=="fsl_enetc_vf", NAME:="eno0vf0"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:01.1", DRIVERS=="fsl_enetc_vf", NAME:="eno0vf1"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:01.2", DRIVERS=="fsl_enetc_vf", NAME:="eno1vf0"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:01.3", DRIVERS=="fsl_enetc_vf", NAME:="eno1vf1"
# LS1028 switch rules
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p0", NAME="swp0"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p1", NAME="swp1"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p2", NAME="swp2"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p3", NAME="swp3"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p4", NAME="swp4"
ACTION=="add", SUBSYSTEM=="net", KERNELS=="0000:00:00.5", DRIVERS=="mscc_felix", ATTR{phys_port_name}=="p5", NAME="swp5"

The other example is "dsa-tag-protocol", which you'd normally expect
that user space would select through /sys/class/net/ethN/dsa/tagging and
that would be the end of the story. I was only convinced to let it live
in the device tree because a tagging protocol change might be necessary
for traffic on the port to work at all, and if traffic doesn't work,
then the kernel can't load userspace through e.g. NFS, and thus, user
space can't change this setting. In your case, I don't think this
argument applies.

I guess the general rule of thumb is - if a functionality can live outside
the kernel or of the device tree, it's probably better that it does.

