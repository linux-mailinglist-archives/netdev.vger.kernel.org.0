Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330056E0AD9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjDMJ7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjDMJ7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:07 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DEA7285
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbsIUVbTWB1GqFp5j2uTeJs4lsGBzTGdwX56y940DrN+JMM1eppkPC79Ckmzt/HLkTw0yP3VfetjTQAgyiWJlSjpV1dCtL51U8KbuC0qt/oFQ4G5nvyCoZxE+JYBxJW95PgFuUsU1jbTFx9sJfUAXGs3+97V+Ozk6NiD4BgTdoarxV/jwcNrfnH1xCG4BK5O+oOc43GaQxlTlUsm4YAGNjrDmvVNqeBFbyP1Bi3StlPKV7fruR52poP2TctMeapynsHZ/acN9s2cOEspLvGAVGWSV9RvSz3qP0Oa5ZrqPKrPXT9hrNaokwviDO/fVUgegkNlpk4+pPbvmXynzgfq/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXlAMXX7PsgaqpiH81XPYfgT7bIykepEEew2TSQ9Avg=;
 b=TVdmDiRr09lznu4k5mMUv5wvM4IJlnpPSx4g9dBLcD7hW1ql1pCaueklpGzCpjJNIr622sNvrdWs0VR18q9H0u/4ZTMYvmh+EyDJ4NJmmAUzyvqyvFCWJ8HsEtrpl/hDlhJ5BEMMkewjGgNai2ENlqdMrY9s6lyX3mi6VW1shnfQfnE4M+0fr8RPQ1Wxql1YVgBvOv+1y+vjSskvc1+y6n/TA2uGZ28TZXY81TSizvtlw2sKfkloUzDKHa1swDFnx8rqurC/D3JxK8m9nNcoWqViks8KMcDnKZVZFEfH4XUMbopB0lgGUfTqAZgpEyCm4PwTetrfyQ0l7tGA/W0Eog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXlAMXX7PsgaqpiH81XPYfgT7bIykepEEew2TSQ9Avg=;
 b=daYkTwF2csHYJDytDC4XuTJYReyX8Gg6FT9vvaDIXg1D2oxar1c1zGBEdL+SZrrKUQKC0ymzgzHulRZpPrzZ6TF+0l2G8OSRvjhZTox46fB5WR7WdQzwQQ2Fw25vMYg6LDt4VD7LqsmQ7gW5SJ0M4BeRAJdGt3cbU9lOKfeHQqbN/QYXhU3PiyvFzFJavMn0KKI7KQG7UTWLjn8nCZVyPzkuMAd69etkRPaqZ0txr5fP3uijKVlwi8j0PXVDaeRBm9NcdnBAmmR2paCcDuN1TbGj7gHoRDS1G8uhcVB8l3YR8mRrzuSgxeYVPLiCqRCajoleNU2ykz//xcMby8Kw5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW6PR12MB7070.namprd12.prod.outlook.com (2603:10b6:303:238::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 09:59:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/9] bridge: Add per-{Port, VLAN} neighbor suppression
Date:   Thu, 13 Apr 2023 12:58:21 +0300
Message-Id: <20230413095830.2182382-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW6PR12MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c4f33c5-ec74-4bd7-5ab0-08db3c05b64a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xuRQQDvdir0ASQBgR+eODipZqNe9JE1TCbvS1G2ENN9Fp37WNJMkoHRlhskKho7A5zqiFhWX+JSRSfqXCArdSpCzS2Ivqq5zqhyX/yEeCnp66tv5rfhz67B7YpeqzVywaIMtOMraB7sp1qJ5CDYrIBLGQtYfMidDWbDhJK7UjifG+IbQCHqVJvZh3w1q/+7a+HNTPlAcc09X0bC62QEe42iqpFfETM3bGIU/2p0grcLc2tRn1H81It9ryQK6z1be+zCkvS4o/iuc8ArceR0x5xw1ln/Qe52dJo9lX9JJaXmbGA3Ax4u4UfTphWv1sCD6b6r0jMcqC1koqeDkbzJsOHe8ADSUop8NH4vNZQQ4uLiGemFWhrlrlTHJpJAm6bfKW6+h3/pz2vGqFlDg1WdkndwWbKf2WNMSUdMGfr44aUyF/ZJByWeRUULDHEo+17g1L/3JrU7Q747v7P62o/yL8wJSG3k1f7pg1eU7a6DviAFXuR4W8j1uvrec22qbG1HykqSi21WvRKMTVqU07fMrHS+2AqdXQBr2M07ccpus2AtblOrU8VHYEl5azjF8aKtGpeGSk2VnNW/yMM+yjBGs3U/QWHylq+cHxy5++B1hu/AVoqS2NFDo6PEa2Hjzr4bL037JUJwiHIvFGsC/H1/KVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199021)(36756003)(2906002)(26005)(478600001)(8936002)(38100700002)(2616005)(66574015)(6486002)(966005)(1076003)(6512007)(6506007)(83380400001)(186003)(5660300002)(86362001)(66476007)(4326008)(66946007)(8676002)(66556008)(316002)(107886003)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3p6Nmo4SFMraFNwWGQ3cTA1ZXE1NUNlWjczd2UwTlJWTUR1U0p0ODJGL3lW?=
 =?utf-8?B?bGxzcjVZelJJMWR2U3E4aFRGU1dqR1B4d1ZmckVOOStDbmFhM3dCeS9PSkJh?=
 =?utf-8?B?L0V0YWQrR0RWMVFMRkxzY0RHRGYrZC93dk45a0ZJQnBaY01rbUUwUzV5MUl1?=
 =?utf-8?B?UXgranJwQXlaNlVoSFBvTlRpMVA0QmFlUFFXK1FhT0Y2L25UVzRxdTN3Z1hE?=
 =?utf-8?B?cnh5Wm12K3gxZ0xUdCtuSGFWbUl6MiszNG5EL1o3WWx5U0M5VGxEemRDZ0VB?=
 =?utf-8?B?SmhqSG1IQ3pyTDNiSFpXS1phV1RBaWMyb1lUVUlSSi9lQW1lVEZ5d2I3Wi9q?=
 =?utf-8?B?TkMzdFh2UzdSNDBWWkFOWUREZXc2SGZYcTAxS2xBeHdPZWl3NVRHZkN2UVAy?=
 =?utf-8?B?SUJBTnBaZHNBQU5EVUxJVlRSdi90YUFRNHhvY2xDemFxQVIwM2FLMnYwaytK?=
 =?utf-8?B?dVlSNHY1WEdMcjNaUHkrS2htV3FYMkc1QnRsL3lURUU0ZnZQNzg2ZXA0QW9P?=
 =?utf-8?B?QVd5cW9VMU9qR2oxQTNYeFdENDJ1VUk3Mm1rNE43aC9nTUVuK1p4elFWbzVz?=
 =?utf-8?B?WFd2cmlTZHA0SFViUjYxRW9yVkgwTy9DazhqckExQjhxZGQwZmNDcUhCM3k0?=
 =?utf-8?B?dFRibFR6alpEV0ZXbWJ1QVpDeUVvb3RiS2F5TmpsYUhvS3pQYmplWUVDVDRM?=
 =?utf-8?B?NW9HVnFJL0xxVlY0d2F5ZkdWV1hJbEs4aEozTEt2d2E1TGFHQUViVjlmUXNM?=
 =?utf-8?B?Z1cyamsrdGZGcXl4UXEvUWRxQmlPdHMxUTF5WEh0TkNHWGZKR2phbkhJYmhU?=
 =?utf-8?B?OTM3djNMUm1WZUREVTY5VGFWaXBOZHQyUmhwRDd2YkNITllxK2hsQVZOOEhu?=
 =?utf-8?B?ZTVNZXQ3cTVEcnljQXlTbk0yT2V5OVJTamFneld3RmdUaTZ6VEhjbnIvYW5i?=
 =?utf-8?B?dStuenBoY25DRTc4S2FFT0pIbldwdzdPTk4rM3ZQcmd0SSswTUZLd0tKRU5q?=
 =?utf-8?B?N0g2U29xQ0VXOEhteklLK0dvWjFBdnhWaHhoTUlSZDN0UUxjUm5OQ2dOYUVz?=
 =?utf-8?B?R1cybzNPWUxKemJFRFYwUU91ckJVU1NpWStSY3lRZkhMN2ZvQXRnc1ZDZDh1?=
 =?utf-8?B?NTBvN2lWWDVJUmFBSXk5b3FMQ3FURzVxYjRIR2o4NDlKSWxWcnJweWhuOVlx?=
 =?utf-8?B?OVRaS3ErQXNRZEJUQnRBMHIzall2SC9iVEVWSSs4MFNlL2tLZ00vdkg0SHdk?=
 =?utf-8?B?YkIvVk1PK2tUZlQ3LzkzQnJtN041K2FOQnRLY0xxMjR3NGJPV0dzN3J4SVdy?=
 =?utf-8?B?NmR1cEhzck1iNlFLYUh1S0RIay9LL1hoOFRSbXVjdUlmZmlXMVhtV2FPTkhH?=
 =?utf-8?B?Q2ZobkVGTWVXck9CT2gyUTNTMHRNUHJzNDk4ZHExZHE4WFA0UmxXVm5XaFhh?=
 =?utf-8?B?ZGlGY1h0R1VQa0hmQzhISXJQMjhOdjl2Q2JTUkJ2UW40aXRESkFHUWZBQzhh?=
 =?utf-8?B?UTMvaGJka1ZROHkxL0h1QVdkSUorQ2hCL05ka0t6Y3FSTXZyaXZQWW1PbGpU?=
 =?utf-8?B?UUcvaHJNNDFkc1dQUFhIdTQ3ZDhLTTJsdXlNaUt5NnFYNEgwR0NrQWRHWFpY?=
 =?utf-8?B?d2ltb3VVcXhDakpjSWVqRlc3S2MxLzlxZjNhQ2htVWpsWG9hS0dVdU1NSkpF?=
 =?utf-8?B?TWFCcWEzQVk4SWYzUVJoMmQxYk5qZW4wbmU5cFBhcGd5WmlmWCs0TXV0bDBS?=
 =?utf-8?B?UXdmeGx6VWxma0VGM3hiclprVzFqN0g2QndyK3E4dFFwTDlVYTY4MTIyQTZD?=
 =?utf-8?B?enE0ckI5c0VHbDl6U0w1MDNkekJJNGZ3dG5neGhRY3FodFh5WC90c0pSNytw?=
 =?utf-8?B?OUdRbVlLVm9VdllJbkZiOVVNTVJ1K042NjZTdnNDdVpJWFZxRWQwT3F2eWYw?=
 =?utf-8?B?d3JYOU9ySTBtRVpRWjl5YlJBU3pSNWs3KzBielhsOXZlVHljRDFoVHVkUHRH?=
 =?utf-8?B?YWUzVndEUGV5QTFTVnhESHB0Slg0UEZ6dzgzbVVrL0ZtQzVhMW15TEltVnh3?=
 =?utf-8?B?RDdndTgrbkk2MFg4d1ZOQWxLTW1yL0c3Vm1zbG83cDE5bjNIZnVIdE5XT1Q1?=
 =?utf-8?Q?nPOsoSte19gbBMKPbATFLaFJi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4f33c5-ec74-4bd7-5ab0-08db3c05b64a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:03.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cz02nuiwol89kFPddSieXHz7rouNV4+f9XySOZBkl30qVkHsK/+DYRjgiPdILkRZhoVJKikhUwtElOvhYpllkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7070
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

[1] https://www.rfc-editor.org/rfc/rfc7432#section-10
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a42317785c898c0ed46db45a33b0cc71b671bf29
[3] https://github.com/idosch/iproute2/tree/submit/neigh_suppress_v1

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

