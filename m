Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFDC55C768
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiF0HHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiF0HHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931245F6A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9M8m+WNbxUMpsFvFv/aGf4aXat3Uv8vuykJ8WMcamJxFc9KUR3LiFxEhBVT+PGR4TbY07HpCwAm3RMLkbgEu4dNmdJHHdwSxj0fSmjae+tTFiYr+mAW6NkJKb5CGXVwK7E34buyxY2hFBgkGNEsu0FR8UkahGPqWt+aher/5T7l5oggyKvxDfpwReL+eCU7b0Edrwe0sb8sVYPFLNoZEtyWQ/yZcYKOcfY5hx8TkBhEbw5/Cxhd1pQYfpsVJ387IcaiYmmMP1MYHeQIvwOcBOMRKSISBmNlYSWvbBYSCyuSbFZvwETRekJDnEDiua3Kj1HP3OiS7I+5lOqJ0Hn2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDrUbaQmojulzNb9PrLRB8qtJOwayQJoiaA0ZPxDjwE=;
 b=IWNK0nZgBq6F3Q/Rci7gvNATaj1rdmfVM2pWB5RPDuog0mz7SALyMu1UVv/fiG+rhO2esLjl2TlNJVPskk3JzMCx0dHPcqNFnIZJgZkhb4aWDzAkEr6AJzroovh7CGT78NyrdGlQVvfcO/ne8jt+jojGqnYRi6eTwn1GIzTS/aAjg84e6qDcTzeu2Gs9tG6k1sAMX8ocrPXF9zfYORLfWeGV9wmJm0CRwBwPZNM/6qsbYYq+oeDXlmj0JxrDKsQLH+Sd8Lg5/T4GEkNuxuu2vvz/J3zcvnGsYJ1/mcRXls+dsycBY4NAMUFLoSLldYbJqRXpYgEhFNKbZKf/jWewaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDrUbaQmojulzNb9PrLRB8qtJOwayQJoiaA0ZPxDjwE=;
 b=Xf3nk3jFfci4pknd9xa88lWY+kCl2g+ulUFV66anRgwm83vg/7VQHu/0rNTCJuXiVz9HuVbCa3fHfZnDvi1mTUU8r1CUmQw2/HZXEmw883Y3TexEfOLSGsjDFIBCfIdY5MeI2+P2s3Zauky4i0kXESFx+d1Nd5xYjHvZ0n7Vo0Ho9ZxwG7QU3OfWbDfnz0Xt54NRgm0yVYktVGRprziwU/JFkjqQDii5nKDtKdXbmzFjzWdhSwgYet4Q/EfmdAQYn9CuCdtLfvWhKI1VhiF8hIjLyUjT6HSv8KUjYg5DMcnIjCjqgSxzHOQnUfLfkGEIZtd1f0/sBC+VQtLQVYNdkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/13] mlxsw: Unified bridge conversion - part 4/6
Date:   Mon, 27 Jun 2022 10:06:08 +0300
Message-Id: <20220627070621.648499-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0350.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0727539-bf0e-442d-56a7-08da580ba2b1
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPhKSx2mpU/vrjBLjs1cgaIN3KTKXXXgk9r0xc222b5wMADJpX0oO+eO27HCiif0jiP2RQRoANJJiSlk8vPrw4pSB+JfNqlGx9virHROw9WaqcBVzkR0KKg5oaeti1NUPjsFrSr0s4Q2fUnY9DgNN4dJaY1JNRZ31wSI14hb9WR2AyhOT8PH5mVF70OcKHb8nq92rXqVM2ae0DTRDejA0VSmopLRRGn2Ad6bYc4dLxI/Da2gvkclNGSgP2R0PpBGyOQGzCPuAa0If2mmbaTm9Vt46lbfamFU89LBLxwamQf38qN40ptr69QUCKw32OvFVxolOpRIPTl2fvjtRCaeCtAJFj2olBWZttbd8Ox3YakLGjKd6J7ia8A6E6HxfWtmTep6RmI/rQIdR3XENDEecF3TnR13FezVfAmVB1vcid6uH5ZjqMo8EAyfW2cv/GFy7EMlTBznhmSy0ko9SEmVN/gmwCl6Q0zIyQgOjF5n2ZvL//e/06/ijsYM5tn0TXyatx1bDkUjKa5erw4mxw8PhvaQh69mGtbNVP0nCrBpfm/84zaGX+T1W9m5Ez9gscOQeXUsmul4e7dQJj5ZJC/FCnh7ehNqEb6BCpSWRD/E1+JmVQVcTIAyFEIODwHe5hN9dyhmY+bHrWyP2bVmCiaPvcNPJO9iQzMcyRzMbY9bDxkMrS4BWJVwRcz/+bzFsBwwe94cNsccO/3dCT/xyPrzc6uRsvglhC83uY4ANGgPBcCH7LSo5WULGC1VQo884jOg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(66574015)(6512007)(2616005)(36756003)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oN8VuO7HZ4Kl0EeqNJSxYWNHiGhHt9PPRwPQi8e8fklR9CCgnwt+JsA7NcNe?=
 =?us-ascii?Q?asa8kVERJF0BXh2xX9jL0QhXoK8ZB0ARyoihwSxx9mKAKmpTKBtkfnlh70+6?=
 =?us-ascii?Q?2t5xrwbGt+PRbTDnvw4uKMCvnXqiIHpD26Pp7d7ta3NPdlzJ5Nk5IYHP8wHD?=
 =?us-ascii?Q?jLj6Wt4TWr/HTs/9M8YENewM2svDJXI5VM8AlJw54NOyG6LDH01s/v68EcLB?=
 =?us-ascii?Q?2QzDnOMke1AH6FuvO+8EzJfPaj/Vx0UjznLMY/Ku+SjaWjrSl5vOS5e6nriY?=
 =?us-ascii?Q?0tu9rGHjHlIcr6O5qZtBg12JJmHjitbyUFIOE5y9bqWa3UxvY0xvv4I51JF+?=
 =?us-ascii?Q?NH/bVK5KQZnh2Q+Dt17uVKA6Is/VL5IDQjys0eBeRVhscpURv1MZyhT5mSnG?=
 =?us-ascii?Q?7eBNRPfUN2QKgzKZvMmrTd/8Xwefb3Q+DGrdpOtuGK4EwzD89eqg6X6ULFk2?=
 =?us-ascii?Q?Pt+BdwZy/5PPTZFAqs1I1qmlSIviKJxnw99iMKAqywvUMuKugNnk8/jSXdfn?=
 =?us-ascii?Q?JWjTS2MZ53avgEZit4FjWBiGyGMCVhfjG0Op56Gp2Pk7LZUq41/GK3h8CyHi?=
 =?us-ascii?Q?urHDGInjmNZNrasgiLxx7kCciwWYAzBDSpSvgCFZgRa1g/nJKTXgB6Iav21s?=
 =?us-ascii?Q?1XFyb3aWqbA+QvVJxAn17pgjkUzeudFi5LTX+SB6GzmTVNJ9DPHu6YagayBU?=
 =?us-ascii?Q?26c599z9J8JywGYvyYI14eULPN+s9yWtrOcOsXAwhrqjI4fW7Hhsni1qyxDb?=
 =?us-ascii?Q?jG/Xo+jTSeBR/iU/JAupIC3i1ao+K6Z3Xt2cC2Er6lTilmygghzzxQ5aWaUr?=
 =?us-ascii?Q?aVCbZPS22T/hVl72qVgYLzQZ+IoAPb0A9OIZOyBAJq2F9YcOSKrnJLO/UrUL?=
 =?us-ascii?Q?TKCtKFi+aiol+hx1qYkycJ1oaYhJlcAFd4I1vkfsDsT6Yuu9rBi+cY7mpCpE?=
 =?us-ascii?Q?MbIi9orpM6qJVeNMOBR3S4RYChiySGpO2eUWOGYQhk4jMhvIVNVocqOs6DuL?=
 =?us-ascii?Q?M7p3sgtOsPRSWHlSwpBgKMDEuW7VqqFiH0KEOBRfkPmcMm7/V6FESymN1/Nk?=
 =?us-ascii?Q?COxpwKJrdI5mY6u+fczlH2YAtnaLzZbbS02o/GUFey7ovCI6SkRwhPs7Dsiw?=
 =?us-ascii?Q?DZz0+Hfi/IUQu6L5etvr2/f2J5Zap1v686jvTEcixy8B63wj9EOh8vhCMx7e?=
 =?us-ascii?Q?1XwQN0B76nuOuz9bbpYe4i8cMF43RItYcN+gK7g0RnWEYF8lvhk3jyQnsour?=
 =?us-ascii?Q?TqinecQtHuTMgtdDTpGKkWmGTAJz4IjvMpmnKwnQS2+c3H+rwfcxgWYIEWe4?=
 =?us-ascii?Q?sgg0KNrLjUnmZ7m4jjfy/JEetl86lYVvE41MxqRJ40sSA65WroeJRauvv/u5?=
 =?us-ascii?Q?VuJ+pPbHSYlNDEyvgUj01e+FbPF6Zd3fJ9ztsTPReg5J1wzKlsGhmV90rIkq?=
 =?us-ascii?Q?zpg8d6nVEXyw/v/TqAEs0tcvD6jE9aoZi7VvWNbtE+pcy+U8Rd96Jat2wgKD?=
 =?us-ascii?Q?sRpQ9Nyv1rKH1sal3NxjjU41Zni2c+uQiI6i2aepRO4MOUksuxdgtJDHB84j?=
 =?us-ascii?Q?B6C8q46YJ3+CqjylibhKTAfbx/ELFSfaQIh4aBkX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0727539-bf0e-442d-56a7-08da580ba2b1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:02.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iu2x0Ti2bvOlooZSEMzFDQ4RnIXzi3DzpVKKrhlNjtt1g436w3Rwz730PpFA2qeS6XLXzvlcbYu1/9AbABT9+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the fourth part of the conversion of mlxsw to the unified bridge
model.

Unlike previous parts that prepared mlxsw for the conversion, this part
actually starts the conversion. It focuses on flooding configuration and
converts mlxsw to the more "raw" APIs of the unified bridge model.

The patches configure the different stages of the flooding pipeline in
Spectrum that looks as follows (at a high-level):

         +------------+                +----------+           +-------+
  {FID,  |            | {Packet type,  |          |           |       |  MID
   DMAC} | FDB lookup |  Bridge type}  |   SFGC   | MID base  |       | Index
+-------->   (miss)   +----------------> register +-----------> Adder +------->
         |            |                |          |           |       |
         |            |                |          |           |       |
         +------------+                +----+-----+           +---^---+
                                            |                     |
                                    Table   |                     |
                                     type   |                     | Offset
                                            |      +-------+      |
                                            |      |       |      |
                                            |      |       |      |
                                            +----->+  Mux  +------+
                                                   |       |
                                                   |       |
                                                   +-^---^-+
                                                     |   |
                                                  FID|   |FID
                                                     |   |offset
                                                     +   +

The multicast identifier (MID) index is used as an index to the port
group table (PGT) that contains a bitmap of ports via which a packet
needs to be replicated.

From the PGT table, the packet continues to the multicast port egress
(MPE) table that determines the packet's egress VLAN. This is a
two-dimensional table that is indexed by port and switch multicast port
to egress (SMPE) index. The latter can be thought of as a FID. Without
it, all the packets replicated via a certain port would get the same
VLAN, regardless of the bridge domain (FID).

Logically, these two steps look as follows:

                     PGT table                           MPE table
             +-----------------------+               +---------------+
             |                       | {Local port,  |               | Egress
  MID index  | Local ports bitmap #1 |  SMPE index}  |               |  VID
+------------>        ...            +--------------->               +-------->
             | Local ports bitmap #N |               |               |
             |                       |          SMPE |               |
             +-----------------------+               +---------------+
                                                        Local port

Patchset overview:

Patch #1 adds a variable to guard against mixed model configuration.
Will be removed in part 6 when mlxsw is fully converted to the unified
model.

Patches #2-#5 introduce two new FID attributes required for flooding
configuration in the new model:

1. 'flood_rsp': Instructs the firmware to handle flooding configuration
for this FID. Only set for router FIDs (rFIDs) which are used to connect
a {Port, VLAN} to the router block.

2. 'bridge_type': Allows the device to determine the flood table (i.e.,
base index to the PGT table) for the FID. The first type will be used
for FIDs in a VLAN-aware bridge and the second for FIDs representing
VLAN-unaware bridges.

Patch #6 configures the MPE table that determines the egress VLAN of a
packet that is forwarded according to L2 multicast / flood.

Patches #7-#11 add the PGT table and related APIs to allocate entries
and set / clear ports in them.

Patches #12-#13 convert the flooding configuration to use the new PGT
APIs.

Amit Cohen (13):
  mlxsw: spectrum: Add a temporary variable to indicate bridge model
  mlxsw: spectrum_fid: Configure flooding table type for rFID
  mlxsw: Prepare 'bridge_type' field for SFMR usage
  mlxsw: spectrum_fid: Store 'bridge_type' as part of FID family
  mlxsw: Set flood bridge type for FIDs
  mlxsw: spectrum_fid: Configure egress VID classification for multicast
  mlxsw: Add an initial PGT table support
  mlxsw: Add an indication of SMPE index validity for PGT table
  mlxsw: Add a dedicated structure for bitmap of ports
  mlxsw: Extend PGT APIs to support maintaining list of ports per entry
  mlxsw: spectrum: Initialize PGT table
  mlxsw: spectrum_fid: Set 'mid_base' as part of flood tables
    initialization
  mlxsw: spectrum_fid: Configure flooding entries using PGT APIs

 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  17 +-
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  14 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  41 ++
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 147 +++++++-
 .../ethernet/mellanox/mlxsw/spectrum_pgt.c    | 351 ++++++++++++++++++
 .../mellanox/mlxsw/spectrum_switchdev.c       |  37 +-
 8 files changed, 572 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c

-- 
2.36.1

