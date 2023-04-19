Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D0D6E7E55
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjDSPfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjDSPfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:35:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE448AF
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWwvsWEZMzU+NZAW2hHctapHIjPOQTbl7Es6cjFNUYNIgTN9SNDuxYi3lBf4m9YGAH4vOxq1Z2j3xdccC6oVuzJMXWXB65XfLw+d5isrKCEYNbnKD7opQX73B/OfigAwAzXDR1cz8G4JkLjKAqI9xHZZzwLLYKN8xBChv7E/hG0ABb1vlibCsHUnv6gEQKDy4NvFch9N1VlLKEvJYie2n92qsm/we/F6Q9xLfAPhiaCQUITYoMQ1RywA83gQzmMrZlRgYgt5mll/dYPRlbFY/fKrg4Z6XzFw/E4PjSa4XoefLWzTKoYoCdpbpwMQlDb/m367DdXy4YDN49V6RAVudA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qrEMH4BQbSQbJiTLD3+R9DLamA6We3+0Ydw66iZgbo=;
 b=nUj/8mVURmzlcV2Fx25g5aJ6TqO/nF3svajkL4PLXWOFT856Bpiq4LaQZctvBAGUdSMERGDgozCb82AL0CZcny43kjn6ihxKn3sWdt0TAdWEwsu4SAD7EPLxEHVUxDsXM/enejj1lB72Z5ZwsH2/7I0ke8Y1XNFHp/wisbwhwyQh+SIIMx+5bSqdkHpXZfzij3RpAsBeV/VGb1hFQfzw3fdOFFhYJ/PTxKsAWRmuDJhOeFz39YFk8+SMpCh6vZI1KVOCX6Td8HPd5EMs7gBjEWlU2iQUgKuPrR7IWjOZSTQWcI1GY5HGMxPVczUT0JIMz090ekxa8FrbPLPaWDRNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qrEMH4BQbSQbJiTLD3+R9DLamA6We3+0Ydw66iZgbo=;
 b=rtp3+mit0HHb6OYOxIkDZ5UgfgTK0Fq0lP9PxoOy6pcrxsr2MOuThZ2U+0P0pQjmgfDVIB6To7e+aFEK8gIlAE/ZlJzln6mERUXKfKjK8qD4QnF08ho6SjZ/FEPpWHlnCBzmXggKpspAae7LtXqHuhqcn9XK3xvVQt/2GWzaZ+7w9dOlIS2TFNOv87NhAogxRUiBySVJzY6Gu9U4ewZL6wECROqwiELsI1K8XyhT8vc26oOub/vOFZ33HLWsUhB97lpDne5Kn2i8Dkeh+p1un+WNXAJ7qQxA8yWyqeQqNESfAFbyn0gWiiVvcprOKZfE/HrBWrBbBigyEs+AWI1mpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5375.namprd12.prod.outlook.com (2603:10b6:5:389::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 15:35:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:35:41 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 0/9] bridge: Add per-{Port, VLAN} neighbor suppression
Date:   Wed, 19 Apr 2023 18:34:51 +0300
Message-Id: <20230419153500.2655036-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0128.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5375:EE_
X-MS-Office365-Filtering-Correlation-Id: e1a78def-c926-4b23-7e7f-08db40ebbb84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MUAPo6bIHSyZXZoUvDhwMLtf10TDFqqa1JnMhpT2nZiD8/p2SFgTGVDZ1Hk1gvHd54COIAOo7/fAUyVmToUgFdTfaLG9gP7LcdyB0S+CddShPVaTgoJHgXx6xL1sQ3ojhbS8IYLwcw+Qg6nWVKILCW68GiT7CZqoOOYLt2b8TGc4ygbUh600uVpOcyKKWq/9zq1dAUxbF+U2EhrwUIOgBCR9ubY6nr+Nd3fNdPt10MA206JoIjwJo/JLic7p132DX355Kyb/D8jYmEz/FN2IEMJfO9sfjCNU95ZA4Z2V4zJYVhJc1BVRj9ZZV7n9PBJauN8vkLfqM5NRq/pCUgxN7bT3BQ/uRHpOQm83xHdTHAu/gZQesCbtd0Mdv4OLfUr6bQPVU8g4zZr21U1W7wc5xWxaPOu2+AVP/iWHL8CCln/gB8r1dYT448g+GnCpjKeFztmdFnT83s+whsGUJ1yGG2eDS0yFlOmSzf+k3fv5o6a2IsWiT7/jpDkCZfCu3KtriT/ZBpRHm5PEk1Mh+cTPGMZ8LWFzd6YBuuyT8aBCm6PE7zivzfIdcZpvInuqj9izQeBdP2NNQ24jEBiGXm0E90EKF7jHWW0IpAlZ6qAG97NA64R17foryemycQLx5oCnF0G6DWXRnmbwkFfwq5ESZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199021)(5660300002)(86362001)(2616005)(107886003)(966005)(83380400001)(66574015)(6512007)(186003)(6506007)(1076003)(26005)(38100700002)(8676002)(8936002)(478600001)(6486002)(316002)(6666004)(41300700001)(36756003)(4326008)(66946007)(66556008)(66476007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0ZkSEUvSHlYMXBtckdkbml5L0xJMnZybDk3ZlN2MWxMTkRTY2lua0QvdHUv?=
 =?utf-8?B?NDNtUnR2eVVyWElHTkp0NGtsSGRHbk82L3NxT1pTRHBodXQ3c0U4K0RQNUQr?=
 =?utf-8?B?NXVvaEhERlJzNTduTWcyNlEwOUlmRXpMRWRyWUVvRkVuVGxuK2ZOb2d2d25H?=
 =?utf-8?B?R1RJOVlRejA4eFRzSEJtOXFzOUpnV1IrWDd2ZnlmK2d1RU5GeHlFV0JpYk9a?=
 =?utf-8?B?anF4TDVSZTlrYTFXZUFhVkRWTHo5djJadThvaWhaNVYwWjlqYjdpdGR5alZy?=
 =?utf-8?B?M0huUWVjN0wzSDR4cXBIZjdyaGEzL2Z5Tm11V2E3a0Rpa2JiVTkvWEdhVU82?=
 =?utf-8?B?QXhNLzFMcTJwNEdrUmNWTVhBcmNVVXE0Q1hyK3BEdG4yTDRONk1oOFZ6dVk1?=
 =?utf-8?B?UThJZVFvTEtMcTB4VUdDZTY5d29xZHphb2FseGJJU2JWUzhmNW9XM2NPWlhx?=
 =?utf-8?B?Tm9McE9FOWp3VmFFTVlNbm9yMVRtZ3pURVZ6NTlZZHVBS3RmNFNkUkVtRE5Z?=
 =?utf-8?B?NEZnbVBmaFh5MjBEeVd2UHg2NzVEelU0d3g2a01sZ2svYkdtTnlWR1VtaHpD?=
 =?utf-8?B?RU52VGJ3bkRyV2tBUEZqcWgyU1RUN3l4R1RrWjYySEdDWGRtMlIyMzgwS2tG?=
 =?utf-8?B?eFZqa2Y0VXl4S3M1dTNsVXg1K1JlR1p0bm5FSWFOWVFQVndKRzlBSjRoQUlh?=
 =?utf-8?B?QnJuZWhJVVRxU3RqZE1SUHpSVzk3YmlXWWZheEtpMGY4Z05pdzQ4TE96dmU0?=
 =?utf-8?B?NzRyMzNlV0RLYVBLZDg3TWdZZHVZRURVUVVuSFplUFRkdmxsdnJpWk8yM3c0?=
 =?utf-8?B?STNZSHhhSE5sMmJTd29LRU9ROEJScW9DVWs0NGFIRVdhUkthUHluUWg3Wlh3?=
 =?utf-8?B?S0QxVlBBOFY2N2JURG1VVGtsNHhvV0VYQm9LQkZ3d2ZQdlVLRC9LN1VQS3Bu?=
 =?utf-8?B?VVc4dlI5bnZkckJjbENSS29xR0Z6dlYrTkxzR29QeC9Id3p5bEZmdTRJeDJq?=
 =?utf-8?B?a1VhTVhrcXJTRy9kempVR3Vnc1BlL2EzbEtjQ1QySCtSR0RRdGIvS0FMN00z?=
 =?utf-8?B?ZWo2SXN6ajFXNm1RSnRCQlAwL1laMG1nT2JhNDZUUDhxaGNYNW1QQUhJS013?=
 =?utf-8?B?dGVMRkV1UVJlOUxWdVo2MDZsS3BrcjlVZTAvRkRNalhwNmJoQjJVSEp2VkNY?=
 =?utf-8?B?dElPNGtGMFNreFR3bmkrMkVYNzV2Wm5WMXJXL0ZmdTN3bDBKMlFjNFB3aFNE?=
 =?utf-8?B?YW0xd3BjZm1ZTUJ4UFpFWEpOcUFsYVV0bzE3NDY0OHFtT0hkTHRmbUZyeVBI?=
 =?utf-8?B?bVJUakJheHhKNXpBWlp0ei80QVdtdi9hcW5rN21WUHdiQ0QrTmYvT2I2U1du?=
 =?utf-8?B?ZVN0b1hwbHRYcDRYOTgzVVhobTJiV0Qvd3QrQTRPTERUblBVRUNaUVg2SnMr?=
 =?utf-8?B?eHVNTDlmUFVCMGhXZjBrZUV3NzdQeGFiY1o1aEEzZmN2dG5maUtUaW9lNDQv?=
 =?utf-8?B?cHJiT0labDNxcDhHZ1R2a05MSkJ6TUpMZWZvVzhkenR3cUswMXgrSDRJelhC?=
 =?utf-8?B?cG9RbHIrQkVDWUNWc0RBc1hLdHRQdm9nb2haVFM2VmN6V1k4UmhhT3hMQ0E1?=
 =?utf-8?B?MHJTU1l1L3duSEl5dGxPV1RJSG41VnNJYUR2VHFLVWJzaW83NCtQNEtYVFFz?=
 =?utf-8?B?SGJ0eHVHa3JER2pCeXFVcm8zYlA2d3ZOSWsvNkpTc3ZDQmRoL2ZuTlNjTFEr?=
 =?utf-8?B?VlR0N0w1bGxveFZOQ3VIM21yclA0cS91RUxIR0RXSUJML2lBYncrS01iam4z?=
 =?utf-8?B?aEFjZWJGUlZ2UFp6cGJHOEhGbkFWbHlqclVnanV4M09qY3NnWHk5V295OFpt?=
 =?utf-8?B?V0hBN2RGK0p4aXQ2amtsS0tvdkl3dDBwdDRIaHZYb01zZEFBTzFBUzRacTRk?=
 =?utf-8?B?ZjZWKzAwQXh5clUxV2N0MUdYR1MrYUFVU3pDdDRFTTl0QWtTWXZHZVBqZTRv?=
 =?utf-8?B?Z1l4NHRyL1NFcm11Z1NWMUM3cTNJNFpiTWlxditLVjRtVEhHNFFPU3BTNXlr?=
 =?utf-8?B?UGNTUGFtRTFKcVVrbVBPWjl2RnQrMEl0TWw3TFVLU0dQc3g3NUVqb3N3L3RX?=
 =?utf-8?Q?hKmgO87lBIaJNd5qr9akREu0r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a78def-c926-4b23-7e7f-08db40ebbb84
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:35:41.2091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgGc6ShcLeu2r/CAQ10ptnvC3ASYxs/43B0Lrp5opUUJGDdwj/YFEKNNnO5dUk3ONfuviiE+GdT6DJkIkSp/PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5375
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background
==========

In order to minimize the flooding of ARP and ND messages in the VXLAN
network, EVPN includes provisions [1] that allow participating VTEPs to
suppress such messages in case they know the MAC-IP binding and can
reply on behalf of the remote host. In Linux, the above is implemented
in the bridge driver using a per-port option called "neigh_suppress"
that was added in kernel version 4.15 [2].

Motivation
==========

Some applications use ARP messages as keepalives between the application
nodes in the network. This works perfectly well when two nodes are
connected to the same VTEP. When a node goes down it will stop
responding to ARP requests and the other node will notice it
immediately.

However, when the two nodes are connected to different VTEPs and
neighbor suppression is enabled, the local VTEP will reply to ARP
requests even after the remote node went down, until certain timers
expire and the EVPN control plane decides to withdraw the MAC/IP
Advertisement route for the address. Therefore, some users would like to
be able to disable neighbor suppression on VLANs where such applications
reside and keep it enabled on the rest.

Implementation
==============

The proposed solution is to allow user space to control neighbor
suppression on a per-{Port, VLAN} basis, in a similar fashion to other
per-port options that gained per-{Port, VLAN} counterparts such as
"mcast_router". This allows users to benefit from the operational
simplicity and scalability associated with shared VXLAN devices (i.e.,
external / collect-metadata mode), while still allowing for per-VLAN/VNI
neighbor suppression control.

The user interface is extended with a new "neigh_vlan_suppress" bridge
port option that allows user space to enable per-{Port, VLAN} neighbor
suppression on the bridge port. When enabled, the existing
"neigh_suppress" option has no effect and neighbor suppression is
controlled using a new "neigh_suppress" VLAN option. Example usage:

 # bridge link set dev vxlan0 neigh_vlan_suppress on
 # bridge vlan add vid 10 dev vxlan0
 # bridge vlan set vid 10 dev vxlan0 neigh_suppress on

Testing
=======

Tested using existing bridge selftests. Added a dedicated selftest in
the last patch.

Patchset overview
=================

Patches #1-#5 are preparations.

Patch #6 adds per-{Port, VLAN} neighbor suppression support to the
bridge's data path.

Patches #7-#8 add the required netlink attributes to enable the feature.

Patch #9 adds a selftest.

iproute2 patches can be found here [3].

Changelog
=========

Since RFC [4]:

No changes.

[1] https://www.rfc-editor.org/rfc/rfc7432#section-10
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a42317785c898c0ed46db45a33b0cc71b671bf29
[3] https://github.com/idosch/iproute2/tree/submit/neigh_suppress_v1
[4] https://lore.kernel.org/netdev/20230413095830.2182382-1-idosch@nvidia.com/

Ido Schimmel (9):
  bridge: Reorder neighbor suppression check when flooding
  bridge: Pass VLAN ID to br_flood()
  bridge: Add internal flags for per-{Port, VLAN} neighbor suppression
  bridge: Take per-{Port, VLAN} neighbor suppression into account
  bridge: Encapsulate data path neighbor suppression logic
  bridge: Add per-{Port, VLAN} neighbor suppression data path support
  bridge: vlan: Allow setting VLAN neighbor suppression state
  bridge: Allow setting per-{Port, VLAN} neighbor suppression state
  selftests: net: Add bridge neighbor suppression test

 include/linux/if_bridge.h                     |   1 +
 include/uapi/linux/if_bridge.h                |   1 +
 include/uapi/linux/if_link.h                  |   1 +
 net/bridge/br_arp_nd_proxy.c                  |  33 +-
 net/bridge/br_device.c                        |   8 +-
 net/bridge/br_forward.c                       |   8 +-
 net/bridge/br_if.c                            |   2 +-
 net/bridge/br_input.c                         |   2 +-
 net/bridge/br_netlink.c                       |   8 +-
 net/bridge/br_private.h                       |   5 +-
 net/bridge/br_vlan.c                          |   1 +
 net/bridge/br_vlan_options.c                  |  20 +-
 net/core/rtnetlink.c                          |   2 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/test_bridge_neigh_suppress.sh         | 862 ++++++++++++++++++
 15 files changed, 936 insertions(+), 19 deletions(-)
 create mode 100755 tools/testing/selftests/net/test_bridge_neigh_suppress.sh

-- 
2.37.3

