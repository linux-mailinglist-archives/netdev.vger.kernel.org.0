Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165643DA81E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbhG2P60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:58:26 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64006 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238080AbhG2P5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:57:30 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TFoohx024602;
        Thu, 29 Jul 2021 15:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=JD/Um6qhNRUP3hsOFm9nSY8sCXq7O806zH0ntQUqcrQ=;
 b=pwtBYdsKIO/timc2+P5CGKglEDX19mdbWB7GZV8KJZhsAkhwo16f80lvKRbXtQZ3MZUH
 bQr/Qm5V8Ms6dGRepJheklmsfqqKIWsDHYZcPpp/7R4pB26y+Exbu8rEqysHuIkIk8c6
 kOq2kZf9ovaFAnTBL6W1CLLuBViFxwaRC4jac+BZnmR4km8Hmhb1rFI3X2CN6vNg8DsC
 v8TIGRQImsHsBgIQKVeE3uizEtVyFvK0h+Ho+I3wMMs1k/VfHKSQyl9jrdxXEtCkw7Km
 Vrdabuho9IJfMMzsqo7/zDxjIkAhiFaKbpKcl2jwQBywjdvftFa2Rt1HXReOQ5jbt9Qo hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=JD/Um6qhNRUP3hsOFm9nSY8sCXq7O806zH0ntQUqcrQ=;
 b=IVIFgmJ6nFEwoTt+eLVDsph9ziO1GxU0AgPAmqaJn+NCcQxfxjpWuIhE2JxUoYRKadZ8
 UiWqe06Ykx9tJ2Tta4jwDFPGv99cWGcFLOElmOQjRJgCvc+1r/gMOJTEIKotz8Y21xtk
 peSFkCDY5kCtMY9TWXIhaqDw53MlAKYJUk4Bix8wWZ2mWPql12HzfmPsWWobdjtjUrvS
 nVh9EiEszLA8YJ7qcLcK8m3xzx6Wz+pESzkBO4921vehHT964eupfbRZsIsQIfW1S9Bg
 PbGIMtkLpLTycakfHcs6b+5vvxB5MZJaXuNO9zjFF+V1OfKd8RhxgaGfAjPlD0i/Oc/+ /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3rukh1ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 15:57:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TFtnZd041365;
        Thu, 29 Jul 2021 15:57:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3030.oracle.com with ESMTP id 3a234ercb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 15:57:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP33eSOp0wrLW1fRcDvwOlp0K/pKWLKLwcg2mt0zBfIGf82AZHaxF5HTiVym/fyQeMfymNqZ7PMTWI2DTidfWB0eJJ/jWBRZWi4RRJyKICJtlafYa3Gx7k1XzDtFUOF8PFKSx9xSyA0QvNIpKYghctFIfbjq7wUSOw5tLR9+h6NSLT4YDtKmg9p/FqMFBbgZwN+cxl/XRvNGCURBVs/hx53Mg3fBZQ/iQOlGyMAmgTljqja8Kw9OxzkBCfgcknthHIN0r7GDcPAfUtnoEb4fjY5te828dGR/tC/Yai6EPsuDwyr3iSp7EjWBo9PSpCvmYfqbnVG1SU6r6oGm9YMgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JD/Um6qhNRUP3hsOFm9nSY8sCXq7O806zH0ntQUqcrQ=;
 b=GxMKhy76FO1gCpceDHptzcdnP9ytgO/81Ko7tsAWkIbVYEiMUgsKRJMKWrtGyq2MD9wDXnnRHE7gjwSvdUlE/STU2GXwR2otK9ZZJFqIp/wv4Nso9TRhWe3h+dn4tog4NZ+jHObkAE38SG91irdo07HU6JItKvKiT7e/6TmXoKmybbRvOYDbaEOLh+onL61aXSwuWYoVeMXUcVRk7zC3Fais1j5OQTMyo4HHE4kWRF7e+7wwrudPJXK9YDEZhDsFziR7MjXZcmAPt/a4twj/Vg0YU9Gylfl/ymgFNL3tYdWh4gUrDPVKBqokgEQUyEaDXi8n9R9ANKm0JzFGGtJuMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JD/Um6qhNRUP3hsOFm9nSY8sCXq7O806zH0ntQUqcrQ=;
 b=nbUPAkCG7p3v8e+aO80F7eCsut+A0UYCgKxvhwr2gLLdwfKd9j7pLccGssV7CxZsIcygcPDd3Os9EsCF8QzRWWxtEd7oYCVTUm7oVYNP6pH3TsvHqEqxykyYcODbOG1qM33C83E2J/a761u/8HR+dwaUuqpl3k/hw+47zz5vQPo=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN8PR10MB3507.namprd10.prod.outlook.com (2603:10b6:408:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Thu, 29 Jul
 2021 15:57:20 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::55d:e2da:4f66:754d]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::55d:e2da:4f66:754d%4]) with mapi id 15.20.4373.023; Thu, 29 Jul 2021
 15:57:20 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, stable@vger.kernel.org,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org
Subject: [PATCH 5.4.y 0/0] Missing commit 580e4273 causing: general protection fault in tcf_generic_walker
Date:   Thu, 29 Jul 2021 10:57:33 -0500
Message-Id: <1627574254-23665-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:d3::22) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.40) by SA0PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:d3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 15:57:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e464dd-7b33-4350-137e-08d952a98c58
X-MS-TrafficTypeDiagnostic: BN8PR10MB3507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR10MB3507FDDB55696D4F654CCBCDE6EB9@BN8PR10MB3507.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5l+KsO0HAkCk8QfMT/UkSTknxlzLmo8uKKyYvmh1ExQ52I+tDQ0QRA5ecrUD1L7AQbyVmVLZnBiUxYdk00i/KTdz1SFVspZvggFFoDib99zspzEzBGp0YO0P9KloPbkCvhRHcmq+H0k34P3oO7Uxd0Ro/PY8X0vZJA17Suw0m/XGmMXdWWu7HGqANclCisTpQK0iFVxQ9m2/Kz3pvXKMJbigq0nDuJQB/Ft8azE92kycaXMl85MYRIpSp2P5FQ/JblWn05kvmBhVLXhW8SXWQj7v1uHn93LOn0lSxANBljdh+KIfFIy4ZNngqTThWHILDzRtKIuwByISOQzJS4+bdZEIxoRQjufwlPHgG7lzdztsLuU/K6YVJlIczl8GmwkeAZh7Hcc0Jx+osW8P8e4edju3aA/Libb8jISDRiTsoJ+OZGQgZ4iZ6ze//lz0J3GlYWU1qRCG+Jpjkk+6JUcpDybPZ5Z1rEHTwYAXsh5zoJYiy20oV+cCyCFqXCy/GPxp4X6zhxSRzq4C2f+EI5Jlro274fVNqul+kFf/MS/VXizeZ854Ku0Grw6Vtx7HPKBHNqZ4YUzARMEZwcv530vuEBe5AsT4Cs4tt4iv85gXBthHBhtqfE8Eh4dM7UVHFzFW8v6cJtWPKdkQzODD9z+cQuR6CUxbWzwwrVnPz2U+fHwwUWEDvJVqOMs0rwzKNzm/BQngFsqYRjqNhvdeEPaAIsx1JGzGKNmdjWEGCM67D0V1W1yIa+kksw6oVpbK8bROcnvJCzCgVxw10Nr3J4RB1A9Sz2JyNK50KWE12lTLpNeFiPkeU7ElfsdAiEbOzIBwshY4dKMCpsmu2PrEYE3d8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(44832011)(38100700002)(2906002)(6486002)(38350700002)(2616005)(6512007)(6666004)(956004)(186003)(26005)(478600001)(316002)(86362001)(52116002)(8936002)(6506007)(83380400001)(5660300002)(36756003)(8676002)(66946007)(4326008)(966005)(66556008)(66476007)(45080400002)(6916009)(41533002)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?98sGw61cTRobyz3aR4vjHn83T+Ot0BWLAA5XFWMXzsyhtGlULgPh9GZMYaSl?=
 =?us-ascii?Q?5efizsHSJV8cZibbYhu4v/xE4xeyxFobE+5QEm5v/cJMOcc63anQtJDfFnAO?=
 =?us-ascii?Q?TR+xbJaw5PZJx9hald9kxSedV1C8I+GANNE2Hu8bKiJW+rQlKhWY8/QsYIuW?=
 =?us-ascii?Q?4dgYMyL70DjBI1JNRykTSssKX8peLSCVRR4WsnaAsuBXUfJawEjTSMUqntTj?=
 =?us-ascii?Q?aFXltGTM4I4lHWqkfh3jENcMsAJqTGRIJcechNSABbWMqt06SyAilF8TWbpf?=
 =?us-ascii?Q?4WpoMNYyJgFAcU5L2YxLx7UvpQ7TM1yMDmD4MitgJrdhST8gTNGF7tAwe4q3?=
 =?us-ascii?Q?ndCGqsi9P0CbYsvkCEM59Bweg6fkyyXTbt6cd57IlLYa8FsE8OTRQbgUnROz?=
 =?us-ascii?Q?eUUg19WuGpgbmuOx0hvbjCgJ82TpR6vNnXfnirt1lVAdtYLhdbHDXlnPPwTx?=
 =?us-ascii?Q?TfclutKQwu88VlHsGrIu4lhZ2U3DrIz1WjkW31k0ZY/0rZmu/uDuNuBjFBrD?=
 =?us-ascii?Q?fGzifxG94vMphZ/A4nDEuZCPdyxBfIVIsFWpEUSfWmWEwLhk1Z/jcueoajcm?=
 =?us-ascii?Q?VqkG7z9WdxYlTpGaa/Z8oaOUvKD/Ep9OwYuS12MrVOj3AzsMJE8Mbdy6J3Ql?=
 =?us-ascii?Q?1JqTXBgQk9XokmOfRuWLEeZf9TjmBgERONVuqSGgX+oRvGEgj5V2GXzeKFIw?=
 =?us-ascii?Q?IopHSTgBTyb7N0aQqa94NtXbn1ZTXgwxKJVAY5aLcLaaEHL735EJqIxqF0HZ?=
 =?us-ascii?Q?mKC9qf4cpKzARTNCIIvNqb2HOLBHkpbNUx3rToKIz7oLsUw1DJ+oE/yQTAc3?=
 =?us-ascii?Q?4cteVhrJnrWjRB6PnlnUS+6I9hl8SZRIJjFJsmIXWYwA7fcdhcBopsk9N+gY?=
 =?us-ascii?Q?QUbhaZkBO0jHWjALEYrMXQXomJwZqpGnuzkcdvyTRbnJfmbpK9sFrEhcaLpG?=
 =?us-ascii?Q?xXKX3m29hPGJbBk6Szb9Irk+VJnBYdZ5Ge6kGNh+muHgacxA8yTCu/HGO5Nj?=
 =?us-ascii?Q?fuhi1oDLfZ0UUrlqQTz8dwPCk4tOLMw1WQF2l2o85EtqpSjR+bhS3rjfnvy0?=
 =?us-ascii?Q?i2zs2ExHVrTXy/fCCsCzn3V/t5x0wgBuWjsvOtaM5ynP1Es9XcY+x+xbZiXU?=
 =?us-ascii?Q?SULElYM42OcjdZy7tZark/OEYO3NHql69RbM9Ucv3hiqahYjGzbmrOWh0b8c?=
 =?us-ascii?Q?EekhVWmaRlmvEYauE+BymSrhWJP0780+XAeXUqUS1cbm36ZBiRFQq7kOkzIz?=
 =?us-ascii?Q?NgHR6CW4ubGm6+UXMvfR6EQVHJcC5ETythn7ecfpP/W1IlgRequTfnyWJahy?=
 =?us-ascii?Q?pw35mIhnp9AfBqn5GqlMvYzn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e464dd-7b33-4350-137e-08d952a98c58
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:57:20.8552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohG6xEzuayePoagPeiaxBgJvUF2ERxU4J2OabznDMsefoIA7WN6MXlqGF17g77lBpTUVjtCp8dauWsCmbceF4GPYm/2zpTINp9ttkN9z+Q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3507
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290100
X-Proofpoint-GUID: 2Pwg2GH5rl_SATsU1TfqtX6ag7tBQ3o7
X-Proofpoint-ORIG-GUID: 2Pwg2GH5rl_SATsU1TfqtX6ag7tBQ3o7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During Syzkaller reproducer testing on 5.4.y (5.4.121-rc1) the following warning occurred:

general protection fault in tcf_generic_walker
https://syzkaller.appspot.com//bug?id=a85a4c2d373f7f8ff9ac5ee351e60d3c042cc781

This missing upstream commit is needed to fix the crash in 5.4.y:
580e4273d7a883ececfefa692c1f96bdbacb99b5 net_sched: check error pointer in tcf_dump_walker()

debugfs: Directory 'sg0' with parent 'block' already present!
blktrace: debugfs_dir not present for sg0 so skipping
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN NOPTI
CPU: 0 PID: 16603 Comm: syz-executor.7 Not tainted 5.4.135-rc1-syzk #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:tcf_dump_walker net/sched/act_api.c:236 [inline]
RIP: 0010:tcf_generic_walker+0x3ac/0xbd0 net/sched/act_api.c:340
Code: 31 ff 48 89 de e8 e4 92 b9 f5 48 85 db 74 44 e8 aa 91 b9 f5 49 8d 7c 24 30 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 08 00 0f 85 06 07 00 00 49 8b 5c 24 30 48 2b 9d 18 ff ff ff
RSP: 0018:ffff888048f37240 EFLAGS: 00010212
RAX: 0000000000000004 RBX: 0000000100261497 RCX: dffffc0000000000
RDX: 00000000000006e0 RSI: ffffffff8bbbbc06 RDI: 0000000000000020
RBP: ffff888048f37388 R08: ffff888046e61740 R09: ffffed10091e6e3c
R10: ffffed10091e6e3b R11: ffff888048f371df R12: fffffffffffffff0
R13: 00000000ffffffff R14: 0000000000000000 R15: ffff8880665488c0
FS:  00007fdde8ed0700(0000) GS:ffff88810b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fb21000 CR3: 0000000050326000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000600
Call Trace:
 tunnel_key_walker+0x91/0xe0 net/sched/act_tunnel_key.c:577
 tc_dump_action+0x748/0xf50 net/sched/act_api.c:1524
 netlink_dump+0x53b/0xe80 net/netlink/af_netlink.c:2247
 __netlink_dump_start+0x5a2/0x7d0 net/netlink/af_netlink.c:2355
 netlink_dump_start include/linux/netlink.h:233 [inline]
 rtnetlink_rcv_msg+0x707/0xb00 net/core/rtnetlink.c:5222
 netlink_rcv_skb+0x178/0x490 net/netlink/af_netlink.c:2480
 rtnetlink_rcv+0x21/0x30 net/core/rtnetlink.c:5277
 netlink_unicast_kernel net/netlink/af_netlink.c:1305 [inline]
 netlink_unicast+0x561/0x710 net/netlink/af_netlink.c:1331
 netlink_sendmsg+0x8c9/0xda0 net/netlink/af_netlink.c:1920
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x155/0x190 net/socket.c:657
 ____sys_sendmsg+0x738/0x8c0 net/socket.c:2284
 ___sys_sendmsg+0x10f/0x190 net/socket.c:2338
 __sys_sendmsg+0x115/0x1f0 net/socket.c:2384
 __do_sys_sendmsg net/socket.c:2393 [inline]
 __se_sys_sendmsg net/socket.c:2391 [inline]
 __x64_sys_sendmsg+0x7d/0xc0 net/socket.c:2391
 do_syscall_64+0xe6/0x4d0 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4595f9
Code: fc ff 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 42 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fdde8ecfc48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002e680 RCX: 00000000004595f9
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000004
RBP: 000000000077bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf0c
R13: 0000000000021000 R14: 000000000077bf00 R15: 00007fdde8ed0700
Modules linked in:

Cong Wang (1):
  net_sched: check error pointer in tcf_dump_walker()

 net/sched/act_api.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
1.8.3.1

