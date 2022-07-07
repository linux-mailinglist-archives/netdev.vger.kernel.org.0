Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289C356A1C5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 14:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiGGMNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 08:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiGGMNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 08:13:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60F225D7
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 05:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjV2dl9IWhEIQOkLh5Zmwb4drfU1Fwub8QiBgDCg/1PJ+IAjv/NtH2E5pc8HhtRTEdYnOIhGz+pZnbouKnxEsFc777eNR0v6Efbsc0j3TQXFMnrvyjjjGFqH4ZuBi0hU8CSgunIl4/8krq9vCfJG0RauNG/dzFxebzuxdaG9soCMZqLhLGKOGb+wiS61oU7mKff4QJVDiCDjB/ntcOd2J+qAqIeF7/0WfJ1eos7PRBLtk1M3waOVA7MDum+ASRhAiwZ8e9FtVcv/fX64jcspI2M9Z+/MJlFgOun7iN/0WOOlOGwJDf+XB03TGbxaXg/VIive3eVWa2P/k1EK6uGOYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8InPLWJVdEwISxFkSGruRnxR9q+56Pow5/ttB6QyV/A=;
 b=Sv6Qslj6sb6ZXctCCLBoQOxZZ5GfFxu8J76Grc8Xsa3GFHk2fC1k8JGOCBRv/onf/fn/NR7nPaiCdl8jLu0Ecs4aAKhaAUVpmfwqCk4A4ZvI6Gc1BN9HsDzJBvwnSHv7LoAG71P8Hboedwk+6JY3Q61ELuxf4Y0K0hZuwccFcj/Vl/s/oBUTu1NUOWtNXrZVCDW6/8zVrhaFT+ROoAvIptZpLp6urrFnIeA3TzFGaWWqNHCShX4F63eYptRkebUeEQSLPH6muvpy6VfdU9FKVdC2PfefMxvHUcnkSXBj8/H8ioGhw7YDD8N/8Wst//bF0/rapa+FSOLZsKM7nwMKbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8InPLWJVdEwISxFkSGruRnxR9q+56Pow5/ttB6QyV/A=;
 b=uLovFRgnS+r/unekCNhg5v1DU9j2g5KZmdzZwpxh+4OjmvyBqJxd6s7u3P8hd+5/sokDZGPUf0Bs5j6bheF7j+jehi9uwXhAhljKlsBfvkK/ySnU4hspZhToV6ta//ODpxPuuHXD8eJT2i75PCrL/ToxkjiwLs6LUFO3+xCZxMtP8FKon5olnhrNNHyLY2WBVQ/5b4FDE/Y+46PnBjrkpodBUTwnxcHDNG+PFqpEbwjBr/T+I+8QibyX3DNIbnFt+c6uADz05TmBs/Y3U+p5CvufKeFWqXIjn0Dsbng3mVDZhpbS1RZSpO/+WvrrBwz1evO+zCRv68RsDg8hl7j9ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN1PR12MB2558.namprd12.prod.outlook.com (2603:10b6:802:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 12:13:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 12:13:31 +0000
Date:   Thu, 7 Jul 2022 15:13:25 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [RFC PATCH net-next 1/3] selftests: forwarding: add a
 vlan_deletion test to bridge_vlan_unaware
Message-ID: <YsbN5UhjDhO8nJcJ@shredder>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705173114.2004386-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0902CA0047.eurprd09.prod.outlook.com
 (2603:10a6:802:1::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fa113b4-c26e-4717-c8e8-08da60121b8a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2558:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DamrauauT0XqfYXmTXicKelME/vIKdq3o53iNZbtdlnjS6RYkAnsnjW6r8zUQJRBUrqo/Mr9NgQ3xE/ABSE/DZ9kUlhz6y+fc9Y+fd2U9Y16yvvoNLFu+hSaKMbK+QlNNiVEtXpUxQBFsiS8p6kI2WbOWnEvZh2/2+Ie1aDj3cw/oewRb6HC4kikN8NRCfhafHFcki8ExQ/PrAxTwFbgcsRxoQvTyTSnENz7XI8QL+ml8spRtHAsh/Magahns/+BNWpqVJIUSeeW3eRBQj/Vv0TLZU6sKJhif5GR6VtPSOYESHkCSmZMjraQj4QIYTWiPUC7n0x9tbZtxaYhm7rMr4yj3npNVbm7IHcIR9SOLO7yieZu/5EZ6r1JXrq/YD2qqvCc5y+YgPd18Uh5C+8T8QAWHLoj3adZQmNmCCYKPbXKwFN+w1Q0upSyaZzKYFA2wxRBJtQ48oPdYHyYPgKjZpwUXNMT7KZDQIJuBu3cRdSUfvpK/HYbGYaHa1Q1rhm2yn8NzztSD2PNWhxF5lAN5zRggApo4/sfL5b5WL4LUYjzCEnw7bIfztRaFDHMa2iDeWTLBS+IgZvN0ZJUENm1eBFjNTqF3bqHpjH+gw181zOZn8vnQlxpSA5zk7J3rSZNFMyjH8Bw2szURExM3dmIgMUZPLPVE6LM+t2XZr/CK1SsC68qVnD1FzpvTjQ2PGXhaX6RSaXiOAQL40/i078YAepOcGc6VcCcn5/Bm9xAzYAl6HcXUOT2OlzQrWSWe2DdRJflj21q7S538wrkszWwew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(186003)(6512007)(54906003)(8676002)(6916009)(83380400001)(66556008)(66476007)(66946007)(4326008)(26005)(6506007)(38100700002)(316002)(9686003)(33716001)(41300700001)(5660300002)(6666004)(7416002)(2906002)(86362001)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EaKTOvOreWWKBkhS0Jn2z7YRBzCeuy5eYtmQzyZh38L2pUugXlyey70wjwm3?=
 =?us-ascii?Q?+7jUcxlIPKM3GypruNSpZyApUK6+QzDvrMwNe19Ea3OMXzxs9LSU/l2ROeiG?=
 =?us-ascii?Q?XWjPZHBXxUOVEVqJlrXiM5zh1niaqUAgen3D/8bPHdhauHCOgS7RbL5+h+V/?=
 =?us-ascii?Q?nliEY6Z6luqUsXzFpxzsPkZu+UZcfoyjrLSy0h8e4RRhom0pzctvbyFK780C?=
 =?us-ascii?Q?g78jdyLNf9xbi4srKOGzVh9/g4iIlCgCHu4E+JZpaCJeBxzaL9AFOKdRLxz+?=
 =?us-ascii?Q?zPaTBWZFFdbFTu8+dAUbdzUj8NwfUbgfbOjGXHjGUpkT0XnznOE0AS86osxO?=
 =?us-ascii?Q?8trzlgHgyECvJVXgiI+E98fn18ZruC5TJKsFWk0DHTHtThr2mUjCzv1AzgVH?=
 =?us-ascii?Q?JL9/l8MW2JVj9zKwuXL2Vbpen2Jn5f6RPkjNWtLL1n/x7U0nITYkUeGG1BlG?=
 =?us-ascii?Q?qXLK9kpUc08z3rqKTF4JkUb0G2Y/6saueDUp+Uw6orxvLkXrEkU3zOJREdIB?=
 =?us-ascii?Q?YgEaMaf/c3ZSs3Po7tsC2fWpZhpPIeHfl0+q7xfXYV735wHlgckQjil4ATBz?=
 =?us-ascii?Q?GDNLet2IlUc5mU+vCt3RimxL3ESQjpNx0cBsy/yMPals0GP0s1s1pibJBNOT?=
 =?us-ascii?Q?yBeZAo+lDyVkfxW4zjKbMUmQJ0qYAAPTCjaGmROKddg+Az/Bz/5ACm6NUI7l?=
 =?us-ascii?Q?7nSte5CUXx+5n014l0j4fQdI+tdEqUcDH/+6WwCEaJNbEGQlm3BFkXONM1wg?=
 =?us-ascii?Q?Nu6OKAC4p9E+SE0Kr5ox32oYyP8JNNtRgbqXTXmeLddHoyPOCktGNTGdLbVs?=
 =?us-ascii?Q?+ajQo4wnX7tkMu16w5XFFAragpjd9j539PxdxIrU4l+bGzBXQNLIvdijgH8G?=
 =?us-ascii?Q?YwvrTRBEnMtgfhWOTYWn9XV+m+tQz1lY11kymuKKQmTbQemnW88v9+zVDCik?=
 =?us-ascii?Q?agwbiP1G2tztB3qwrFSgetpGgIwcXQpEsIsj+gkv6tdTu0CRqD/bxbQ8muTj?=
 =?us-ascii?Q?RV6WYniwcliMmPyPobo0p/PBgmS4X2VVPjChJn9u72GFIADyK+5hmNUK2kt3?=
 =?us-ascii?Q?5SqvJ1JhYUnXz8Y4GhzsGFOA7ihoIIP1LJywA0LltVdSbl/w7OW1P+GyVK8z?=
 =?us-ascii?Q?cHfpm7MxqcgepZqScOqpYBFkC6rXqIBn+B/dr2RTfy9czQlp4lhT+XlREwIB?=
 =?us-ascii?Q?K7+jiaA5P316PdRD/IuDWvAk18+NysQjbrZ3IUdkf5fzUkVts/R8xXXJvYIC?=
 =?us-ascii?Q?PDaRurCySE+gC1KJdXaVpqoyGRZJUbMM9OUgxSk9i3y9JB2gCEfhO7nP78/N?=
 =?us-ascii?Q?ekJw4FPDIkp1GeDvGBtIb8d+ym24RhQkxVxSuyhymOt5jHm2tlHWvdso5vXo?=
 =?us-ascii?Q?9cjJ/fK40ZLmGIAax0XVhvic6R0Y6LPdN08MwTVCaCaGHE69d0QdDy2CDqC/?=
 =?us-ascii?Q?j2PZ7L4zex17hAq4GrUpf+IDY06SpSRoY0NSMejZiPwNtAP95TsTBT32TFNm?=
 =?us-ascii?Q?ohPpqBpijg9rklcs7n/xPaQfwR/zv2KvpnC6LGhve5R0TseTgQPv0AhQhvRD?=
 =?us-ascii?Q?vUWFcjmOxlS5ZpP6emLMLqHUTrvVJBpkBVKzGaEi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa113b4-c26e-4717-c8e8-08da60121b8a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 12:13:31.5511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlHXXx+ZyT4MqKfS+gd4Z6RUtIsWiOsOEEnHJRmpl7LKd/Z5VdczECYOiARZA4tlbJWPq03P8TzawBgByBc4eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2558
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 08:31:12PM +0300, Vladimir Oltean wrote:
> Historically, DSA drivers have seen problems with the model in which
> bridge VLANs work, particularly with them being offloaded to switchdev
> asynchronously relative to when they become active (vlan_filtering=1).
> 
> This switchdev API peculiarity was papered over by commit 2ea7a679ca2a
> ("net: dsa: Don't add vlans when vlan filtering is disabled"), which
> introduced other problems, fixed by commit 54a0ed0df496 ("net: dsa:
> provide an option for drivers to always receive bridge VLANs") through
> an opt-in ds->configure_vlan_while_not_filtering bool (which later
> became an opt-out).
> 
> The point is that some DSA drivers still skip VLAN configuration while
> VLAN-unaware, and there is a desire to get rid of that behavior.
> 
> It's hard to deduce from the wording "at least one corner case" what
> Andrew saw, but my best guess is that there is a discrepancy of meaning
> between bridge pvid and hardware port pvid which caused breakage.
> 
> On one side, the Linux bridge with vlan_filtering=0 is completely
> VLAN-unaware, and will accept and process a packet the same way
> irrespective of the VLAN groups on the ports or the bridge itself
> (there may not even be a pvid, and this makes no difference).
> 
> On the other hand, DSA switches still do VLAN processing internally,
> even with vlan_filtering disabled, but they are expected to classify all
> packets to the port pvid. That pvid shouldn't be confused with the
> bridge pvid, and there lies the problem.
> 
> When a switch port is under a VLAN-unaware bridge, the hardware pvid
> must be explicitly managed by the driver to classify all received
> packets to it, regardless of bridge VLAN groups. When under a VLAN-aware
> bridge, the hardware pvid must be synchronized to the bridge port pvid.
> To do this correctly, the pattern is unfortunately a bit complicated,
> and involves hooking the pvid change logic into quite a few places
> (the ones that change the input variables which determine the value to
> use as hardware pvid for a port). See mv88e6xxx_port_commit_pvid(),
> sja1105_commit_pvid(), ocelot_port_set_pvid() etc.
> 
> The point is that not all drivers used to do that, especially in older
> kernels. If a driver is to blindly program a bridge pvid VLAN received
> from switchdev while it's VLAN-unaware, this might in turn change the
> hardware pvid used by a VLAN-unaware bridge port, which might result in
> packet loss depending which other ports have that pvid too (in that same
> note, it might also go unnoticed).
> 
> To capture that condition, it is sufficient to take a VLAN-unaware
> bridge and change the [VLAN-aware] bridge pvid on a single port, to a
> VID that isn't present on any other port. This shouldn't have absolutely
> any effect on packet classification or forwarding. However, broken
> drivers will take the bait, and change their PVID to 3, causing packet
> loss.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Ido Schimmel <idosch@nvidia.com>
