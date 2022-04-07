Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A5D4F77B6
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbiDGHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiDGHjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:39:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DB165D15
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:37:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3eUt7FFXWo5a/m9bAfNIPfs6eWeMwXYJ4KQelsyPRRgMJP+TtT2mlCa+keatbyZi6bNkGQQJNcijLKQdXtbFs9rqebbhaKOP0mH/rH+6nl4vRan+/JtIpA4BbQDe+/ul5fTE83d0BNUDH+dWf1l/SdTCwxtpLCQCXUrkCLftsFI0kV7IWWM5+hzUh7A1OIHW4ey29k3Gx1Ua912ArSP+ZDn8R/2aTUKFMqcJUQYpqB3UQLqTcm3BCr7R9mKIG2RXFXOPs9Etmry+D2OTmI9zOinvYkp1k1F2wAe43c09UJ59cBXC91uP9jb0P5rGE1LcyfaKdDpnpetZ28FBd1eOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPmxmgZxXYerindtPN4ZQqNB6AiOCwcy5nXa30eqXwM=;
 b=d/xoquOPFUtISr67C9R/D19Fo9KuSzjy7b5wvIpM5ofDzVEfscbb4o+Rn9HmJyjGuuh6fxXA8inl67wusUvKrlg8EmPwuHLUObjJ4xwOLovmp9vs+2E4TFw19z0aXmB7U8rrM5MCnls808l8j+CX9KI7kCjDgfC3EsClqyiCmRKT/lEftAUPTDrhAKU+66/1d4/ypfJ4QDrqqFrl/TihaTw0Z2J3OCq3srBZzZc3WImKglruZzALuo2Xmj+vmVNtCUZjWxv0Pi4gqdUCfTABHNMdprvQXPayeb8Iktk8jNN55yGlBhkEZhNt0oBUNxoaw7xX8/ezX6Ds9+6Vu8igdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPmxmgZxXYerindtPN4ZQqNB6AiOCwcy5nXa30eqXwM=;
 b=BkROuU2L0f9rdg2HrENd/T9E/tMFNp1cSBI7G66xAMiHaKFIFNIauQLMugzrcBSGj8UyZGd5R2fTpMEMHZiv0wacYna90w4VQN9gMmosw+Y0FxKEiqv8iyjSm5QvGCN5u6RRHRYF8sNQfTuF1iSoRYVSoCSF1ho5O2r6cPRizdi8wq2EspX+gDJ7RhVaBbGWnEWwF9SA6mUprTqYDLPzDmahMYQ7lrx0OObvAZ7ycCq3nv462b9liS6XblfO660HSq9Lk6WUdJJW7/aaXndDxEusLA2uRM0pNivCmjus8tLWgHaxbV1Y+U9DRdc2d8Jjykwwbf1fBUFX5cnl2/6ofQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:37:37 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:37:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/14] net/sched: Better error reporting for offload failures
Date:   Thu,  7 Apr 2022 10:35:19 +0300
Message-Id: <20220407073533.2422896-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0002.eurprd05.prod.outlook.com
 (2603:10a6:803:1::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b0ed86b-bf20-4ba9-516d-08da18697d1f
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB018809F18448A79217611A4CB2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sX/TXO3VjyT7H8bpQSa56fpf8gP/9wBhN1c6ozEBCX4RTOjdn6nT4BkIGam8gYBgV4q/ffnnPJfSEW6NrU04H5zQ/FFPvwMjeTT3/97s1xydneooEh/NC+MVjL4SWF/mNSNg67/0NSut432FF7cKBm9XnGpnGr3aZilkgiwNXVVZH3evf0sv8ppnwwaR/cqugMq2caLar/Jy8pViBkc1J0H3LQ/9kpdDBOKL+lJtaokbF9OZBxX7hh++Fyshc3MKhDwLlt/iST5P7KUq8+xM5aplKIInXFTszfWOjmpi2F7GKNes7y0W7iln6aehoj6ox61DYE/zdIVdsFVa5b8mRsINWNvamY/aCN/ACYoh25/UM9Mz28NVe4VIt7cBSUsrvNGRovg1vIroot/o4esPb4xN3BC+4hsXgkb8CguLxnhaLqRq9jDwrY49fL1hGZY3ergy+xNqPyrm4bivQi4n88DiOnouaE4oJi6H6LqioH1fEOpzNiqKigEbbRAr2TzY1y4dIQuIL2L6xyV19Lg+D2CA6LxICCc5UWvohADdvx0P6NSOqgj36rON6U/R9MYDJhF2yL+qa96siQKVgtLckur7utz26E2MatCA1Cc/Velp0u9Lddru1tJLaVfD14xHXeoYw0nLu9MxZ3RW6z/D0giPPfz0TeKhee2vxuFls2Gh25GNSdzlQms1OdLsuLuraF9pHdMraJKy5X/zTj54J35oyhTOroXt3fKRlgrgS8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(6666004)(38100700002)(186003)(26005)(2906002)(6512007)(83380400001)(6506007)(1076003)(36756003)(316002)(6916009)(508600001)(6486002)(966005)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4NyxTEbUvsdQRrqRlee1SLnN2B79aep9ZQUMJwfx1YsNSTxiVplQgYwKHdjN?=
 =?us-ascii?Q?8N12npblZ/G6te6F68ijy65xJEkkrqx1ct12ax/FVyqW4xuKvyY/EO96cr3w?=
 =?us-ascii?Q?AuyXWWC9R3TnIykYP5TbEdhEQZiua3sDReC8pEgYngGTsi2ZO7FD2099nDNE?=
 =?us-ascii?Q?C1l2gEl4uoK0lWG0WrB4UAIeMTX0C5KrMkKErNqi1/ZSD5fJ+vrzsrdw1z6C?=
 =?us-ascii?Q?PmQz3yzrFKU/UrSjd0Li2k57vN8To1Nltmljp3UqR/qnEtO/AAhhKXszD1I4?=
 =?us-ascii?Q?pOzopOAgD4ojVVS4fOUjnHtdrctvWmlO3AZZ9ha90YrT/DQQOCj6hQAJUOqy?=
 =?us-ascii?Q?gOnVfboCE+s354XfIvME04X29bod/5tqW3WHgwgp8i0o3gkG4UjjAzq9KDCy?=
 =?us-ascii?Q?oW0kumBQiK2UZjSgH9il1GzydQM1W3kmocHS3bcPdedqUVqEBgZge6ColqsJ?=
 =?us-ascii?Q?RQlaM9jmI4tdPVElQl9NWtaOjCkterWj59W9IbH4HxlMACEBWARsd00aqgCG?=
 =?us-ascii?Q?8vRFc8uvzN0a3Wfke+zJPmFCgxWGTDBuLVSo1JT+4XnY5sr/G5yvARmJImbU?=
 =?us-ascii?Q?uN/3zoAC0nrVIWCoy5AOUuZce2vxZXjDaLuvj3Sn/0Y2eU6Qz5uBcdwf+Bf2?=
 =?us-ascii?Q?YKcjUbVaVBFnOo7Tai0CCzzi0jCAr/Qjj4sATp/3GR2fru2t8zdNSioq12Os?=
 =?us-ascii?Q?jN2ubgtEHC/LhMLn4tDy+BFYpTDPHrFnNop6k59wIjIrP/9t1FNYP9CTcOmx?=
 =?us-ascii?Q?dci3gr1y6+Wt0IJfQCuFdynfBpfmLYTPbtJ7q+A/M73yMiBpLiQdw57Vt+tY?=
 =?us-ascii?Q?sH1BPRZHU5b0WCEkM5loJ+BxWD3FwRDTf7DqjGr2+neYuLfVDpvXxtZH1xnr?=
 =?us-ascii?Q?LKASs8mfhPhMKkdtVud0xemttZiZlYHTgm5mr/gyvFfriKN28hIOgEpueA1Y?=
 =?us-ascii?Q?y1OE3xU+QA6S6Oq/qDcYVRMBSHJjtJloKBeMfi9ulD6bJLDeUIRNNWmX5sFK?=
 =?us-ascii?Q?J4aBu7ZftbfbRWklhUkkinQmLkPz01Ykah8FjRzUXAL5MwhiDxIdXsYz0sX+?=
 =?us-ascii?Q?y72lpI7yHLAbzCrFk1NkRPwaC6AR5y+6xBKViaJWO6WKvKMX2Z+PDyRI36CK?=
 =?us-ascii?Q?1uSNxLal2/zzMgMPZVLpAaARPbCIh2TlM9swkkzjQsu/73CkHMfWYO+UQLIu?=
 =?us-ascii?Q?yAlUWvm2LJtv8XNGrJ5pkvqbWqmM6tNlchLrMkI3hIw7jAKqm+eEfdm0+MM1?=
 =?us-ascii?Q?4oitj66qvkzlkMgmzCMXibJZUZSMxJ/+9sxswnLwBaRnUGe9QALvC+wXGOqW?=
 =?us-ascii?Q?oJXGOVYdY44nJEujUvwZFaWuX3ZrUCYbg5MTeyY0eoWo9XackwDweMzTvkri?=
 =?us-ascii?Q?tovm0isnJ0s/UsqW5mK1/vPtMbyQYVxnrzYABkR50UzrDoD+Eoitt+6J0Vnw?=
 =?us-ascii?Q?+0SNh+9FKVbM8ar4vbIInjYLs2ygwrJYLM2+vsZu7n8oKoC+jnrJqxWSZcdX?=
 =?us-ascii?Q?7xgYXTW4ysyQUtW3jTY+FLHLpmlpupfY52TVIdCCFo896sBtxj3JuQ7Mm86H?=
 =?us-ascii?Q?NbPNinj74Tv+zJNBfeShdmsoU0WXiEUdvmELfBwbGmHqjwQxoDYBouotcMMh?=
 =?us-ascii?Q?INg/bDalTIhW6K7sMEzhTnrg93C5Pv7VWwDHgaDbgYpLiKfqQQo06ZR7km+y?=
 =?us-ascii?Q?Yi3t2+K+Wxm4TNq24tC9I6cvdwhNBuxVmjO52Z/U6XInQOH18RyXwF/RUv52?=
 =?us-ascii?Q?PmeDHF16kg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0ed86b-bf20-4ba9-516d-08da18697d1f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:37:37.7121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+JnvOmP675eMfFBpdJ7116KwCZ3INEv5j/2JikVy84CLwH+7hcjWdTotV52p/5vf+/chxggwSUefWrhEzxPHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0188
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

This patchset improves error reporting to user space when offload fails
during the flow action setup phase. That is, when failures occur in the
actions themselves, even before calling device drivers. Requested /
reported in [1].

This is done by passing extack to the offload_act_setup() callback and
making use of it in the various actions.

Patches #1-#2 change matchall and flower to log error messages to user
space in accordance with the verbose flag.

Patch #3 passes extack to the offload_act_setup() callback from the
various call sites, including matchall and flower.

Patches #4-#11 make use of extack in the various actions to report
offload failures.

Patch #12 adds an error message when the action does not support offload
at all.

Patches #13-#14 change matchall and flower to stop overwriting more
specific error messages.

[1] https://lore.kernel.org/netdev/20220317185249.5mff5u2x624pjewv@skbuf/

Ido Schimmel (14):
  net/sched: matchall: Take verbose flag into account when logging error
    messages
  net/sched: flower: Take verbose flag into account when logging error
    messages
  net/sched: act_api: Add extack to offload_act_setup() callback
  net/sched: act_gact: Add extack messages for offload failure
  net/sched: act_mirred: Add extack message for offload failure
  net/sched: act_mpls: Add extack messages for offload failure
  net/sched: act_pedit: Add extack message for offload failure
  net/sched: act_police: Add extack messages for offload failure
  net/sched: act_skbedit: Add extack messages for offload failure
  net/sched: act_tunnel_key: Add extack message for offload failure
  net/sched: act_vlan: Add extack message for offload failure
  net/sched: cls_api: Add extack message for unsupported action offload
  net/sched: matchall: Avoid overwriting error messages
  net/sched: flower: Avoid overwriting error messages

 include/net/act_api.h           |  3 ++-
 include/net/pkt_cls.h           |  6 ++++--
 include/net/tc_act/tc_gact.h    | 15 +++++++++++++++
 include/net/tc_act/tc_skbedit.h | 12 ++++++++++++
 net/sched/act_api.c             |  4 ++--
 net/sched/act_csum.c            |  3 ++-
 net/sched/act_ct.c              |  3 ++-
 net/sched/act_gact.c            | 13 ++++++++++++-
 net/sched/act_gate.c            |  3 ++-
 net/sched/act_mirred.c          |  4 +++-
 net/sched/act_mpls.c            | 10 +++++++++-
 net/sched/act_pedit.c           |  4 +++-
 net/sched/act_police.c          | 20 ++++++++++++++++----
 net/sched/act_sample.c          |  3 ++-
 net/sched/act_skbedit.c         | 10 +++++++++-
 net/sched/act_tunnel_key.c      |  4 +++-
 net/sched/act_vlan.c            |  4 +++-
 net/sched/cls_api.c             | 22 ++++++++++++++--------
 net/sched/cls_flower.c          | 14 ++++++--------
 net/sched/cls_matchall.c        | 19 +++++++------------
 20 files changed, 128 insertions(+), 48 deletions(-)

-- 
2.33.1

