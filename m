Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CA363CD30
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiK3CNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiK3CNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:13:05 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087AC2CDD2;
        Tue, 29 Nov 2022 18:13:03 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AU20Skn023195;
        Tue, 29 Nov 2022 18:12:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=48a8xvnCjN2yFPl3mIlM2COBFLYJ9xQAYTtaW68alm4=;
 b=SAZkcHpWPbL6H+CHVprGS+wgzy0S4Iqcr1h2wZJF7BBw8v4+9ByQovR+z66j6XuWeEAS
 9LYsK+Sy0FlHOPhm0SzfIPkHZeTpPnvFBEsY9AiZNtPQvPK3u0TsLrQDcAc0/VN6mi2k
 58Z2qnD4Y011o+vDMVjj+GqAJm4feL6OQbsYRHfkJLIEs3q6xy8u3bE2+Li4+SdN1eI1
 N4oGrLIvlfXZ+5PiHYqfaRxsvxl3/7ivRhaXgV+FvpPDtlUtiS5AL1JgzEY9OX6VKa0u
 XX+nLh64PjYUDgIYmcIkI9o/lqBcdmjVrwF8jUQ0wPrvUXrKObBIh/J8S8wtGtIlP48J Jg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3ey92tw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 18:12:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hcm71zjQNtVy+nXtf/oISpzWkZ2jQRVhEknl1iQZ2LTeKJ6RwahpBdvFq6Io4NoL9YmXp076p6UoL77SopYMhrbImFtsK1bzP1ClY6zv6Der+VmhUgF5I+CQH8LiQjqHJOjHwOcL6NoMcSx98+xWTN1SVnRJXwtQoIA/qJgdLumx9upJ7FaTdcxj7e5t5gA01hGPYC+27FVB9VmMCJlzs5FGsBTmqF98stPq3ggf+08lzVa8Z5XtBUuYa1OPwc82L/QP0jMA6oDti3vN3DtsZ9a8ckxaZn6Kpy+OUVwR5bpCm3vSxCV7McqNOvqnaLklStSg3LyyIOkDnNleq3SaWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48a8xvnCjN2yFPl3mIlM2COBFLYJ9xQAYTtaW68alm4=;
 b=c2mM6dAdz8x2b6XOL7Hn+AwzyUaYoVaozlZnKzncwT5hWLQt7COMc0wkFsiXHYwGjohNeAXtBrBjpFWv1OTyZKMUpj/nElCjGcXRKVLt9BHSR6UQaZYH7BTT7qw2nMkrXnsZA+SJyAq8W4t3p1wpQxgDxriL3Sx9vpp50tts9nWQYRhlO2uOjpzdoBHavnJExHnHe16hxMA10GL5Fze3By86+EfZhLTgWs9lwLiAWfW6R5pwXvthdT9/rW+W2fSYmLBp9jcEmjdKjAvSPN79H34aSoL/9ZUKPvBgadYJQ7NXpEfytjOD4SStkvVsrL7KYsvXKknfz9eNpMuWD45Jxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SA2PR11MB5148.namprd11.prod.outlook.com (2603:10b6:806:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 02:12:45 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b%3]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 02:12:45 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v3][net-next][PATCH 0/1] net: phy: Add link between phy dev and mac dev
Date:   Wed, 30 Nov 2022 10:12:15 +0800
Message-Id: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0187.apcprd06.prod.outlook.com (2603:1096:4:1::19)
 To MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|SA2PR11MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7be454-6b44-4e93-fd05-08dad2785ea5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9fckV76k8kwxCah9Rz2/oJ7REJASxj5n8NmsE1kCxS23CHDZ/k3mVqYyBZEmbE12kZo/Fk8CwMa8SpLjL90ooT3udWiApwl8l3Vdyf+MsKdcTwThfoRPl55hqkztmXE4G/HHhoA+giQan+3icTEEXH+aCrrVDVFVWSK155CTPNH48i6tktlSKDmcKrL+6dsRwbMnTpeEJhIBGdmi5OSR0jzwWTaN1Y4+e+mMUn4wsJgnw23b7Mai8//LYgWdflCwfGPPex05FXdohSrULruZmpmkTdNeTSW1+rts4mf8zMzbon7NjhA/o2594chsd+KIVGvd2BKe6BrOeZdBAdWdjtdtheb1E3MuRh5qlOwtlKGkW1kc1NqE10Ej5cLhnbKgnEEfy5+lV3bn1VUkf/3gb7HxmjmWKXvsSay09Czqevc7n0131eOrK2R9jpEdPaPobsoQt9x6KP4SvDgPxnfTt69U388Iz/YdFTVTKidJluK3pKCsOXFo7MNw1JoznwDtPxD7z4XyhYVOB0B97eNe+3r5fvgwoIggCQJXJq799MVnRFH/lxj3S8p1gXMNNCLrS1kH/r5qThxTpDoOU4GLd+JIg5y233Z5PPR5ZhDXlEreJ+LW/AzTqt0+0SsQDLdknbNJ9St6kgdlMvrLPOugi9irAACR39HTrtclD+daOzko5cLYUnh9cB75aSirRmdLLERbLjnbfNpYnvIC1H7kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39850400004)(396003)(136003)(451199015)(6486002)(478600001)(6666004)(6506007)(52116002)(86362001)(66946007)(66556008)(66476007)(8676002)(36756003)(316002)(45080400002)(38350700002)(38100700002)(2616005)(1076003)(4326008)(186003)(26005)(83380400001)(6512007)(5660300002)(44832011)(7416002)(8936002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Tpyh0zhamFdqgCiXm2sO2tojLTBj2DSlFmZ6lkGQJ8oEBpq6geykQfCxa4q?=
 =?us-ascii?Q?XRXMQypYTwglgnFH9StVJs3tBnzaLKDb9n+B3naGEMHCT3EeHpxbBdfOJAOP?=
 =?us-ascii?Q?lvYy1saH6dTPdu/H5Hq8xqvA81Hes83csFKw2aO+8VjOZTZeHhwLSq1C+RMR?=
 =?us-ascii?Q?C9CAUJ/g589+M4bAxUHDY3frYZwWVCLWsEDjAl+QbaQ4Ggvrx7FUgIZiKMal?=
 =?us-ascii?Q?XZJjYL8fJkfRW58e02oRUYUgL2imO6XfeXJWafWIyDAq8R0qyiJIi8qw0waZ?=
 =?us-ascii?Q?kHfUE51oXB4FnLBXGlDv4YPo4sltmRtt68HNFsjcVdUaMEmTw3gVr7migENc?=
 =?us-ascii?Q?PrhIjpWnFGu7z1Oj2ETtxqMrazO0Er6ILaRyqOR0IKAoYYSSfk8kX+GNPpqk?=
 =?us-ascii?Q?wYXSkdEaK1ZPCSYZARzVgV7CHkNh6S8h1YXq8v7rPVCr07LAR5tnjKV0Dndd?=
 =?us-ascii?Q?ryHVBpNHjY4ZEtqfyegiVez/t4i8PeLHBdRj9I2gMAgwxrHU41O6MwYIoFNg?=
 =?us-ascii?Q?brb19pFtboCMoGBPFGZK2TaKaunhr3owp/z5C+8YbT5tszRDHIYPjJt8tSRh?=
 =?us-ascii?Q?fxzCWlGaZ/k0iM9xcmZueGvbt1muI5ozLDTsioiA0zas74wILQCFZsSGq1oD?=
 =?us-ascii?Q?2YBqE0gpmYzHWmTn2Onq/bWT3Z0/spd3ZCe6kuopufQ8WbQLthkWtMO5nwNu?=
 =?us-ascii?Q?FfxLeRH5maUr2q5N9LoNjD4qUngQ9zff4HPLq/z4lBg3K8odBE817mj9oCxn?=
 =?us-ascii?Q?DkkCMKNTcwRJQkB8acYvxWKDJhDQC2PvyMHDHC+HRAA2u3sNzXJTVJ3oBJXy?=
 =?us-ascii?Q?uPhXsVSNI+PvFPqZHLiDEd41gsiJjUfMWLKFeY2L8lyMkcQFTb9wOcshZYiv?=
 =?us-ascii?Q?CtDGAUM2yUxMSSYF7/SWXmrnGA7zbmyseIQkbHQfFU/HB3N2HU12+NDtHqdV?=
 =?us-ascii?Q?2TGSqEqz0eDloU6Nk+kyqkIT+cHN1LVv1to11G2n5RyiAowZF0TmYRc29Mqn?=
 =?us-ascii?Q?bZJmVfotMFsjVOyNROvpA4eE2tRKudrjLCXepVTSQjjeOy/RvHydcb+hGE99?=
 =?us-ascii?Q?V8JNCA561sRkP2Xc6cgNH3IcFOmZ9s5wbVlB2hhtWIr2JZ6Lesq6gNlGyUS7?=
 =?us-ascii?Q?X9HbMymzvOixl0+N+FIenPDvVOFzaEhpGkxR+7Iy+qOss9SQvMci1nmkaD+T?=
 =?us-ascii?Q?U3px+ek9ywTvxnl49ecPqBD5122NsFD1sDmkZjW/RIh+Immkf5YjvvZIgxVW?=
 =?us-ascii?Q?s1tCiDIjmMrdScmiEK324IaIeUJbBElAkC9YBogrwoNOP0/6rm8ccOrUfMwT?=
 =?us-ascii?Q?U/V2XmVuwy5DFu/+4w3THkPCrR9FE60UGhlBQMTX7po/sJL2tTzOyjeoLs4x?=
 =?us-ascii?Q?rXS5kyEtrII+Lnv4J6gQGs59wuZxP127I3GRs7ibVl4DO/6VAtlKGw15hGTs?=
 =?us-ascii?Q?40lhA1nCFcPe+cz5bHStQ/56LLF30mpvPco4GGQmUp+VuO5HqdyK/V6rDnV1?=
 =?us-ascii?Q?lrzUn1pXmyazD+uh+xrE2okYtlRC/23McUCVoK1W2QKohFILpGLVnf5CHoYG?=
 =?us-ascii?Q?+4dQqBwHDDZ+ZigOa+gerTYrk59YxJDRLwgqLs8U6DWBBt5ePK3iBkgllAZX?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7be454-6b44-4e93-fd05-08dad2785ea5
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 02:12:45.5159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEHPvPIUcrHry2mZL4qu78CKAf/nbhwTk7os3Ec6YST8qwBYemxY5maNVPuh/VLpvZrXmqMjSi/iFMLJTWkyG+plFHuLvnAHTuK/u9nn0FU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5148
X-Proofpoint-GUID: KDFpiU1Z5ld7un_ZNphDk3wrGhNqF79O
X-Proofpoint-ORIG-GUID: KDFpiU1Z5ld7un_ZNphDk3wrGhNqF79O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_02,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=245 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211300014
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compared with v2, the comment of phydev->devlink is added, and the net-next tree is specified

If the external phy used by current mac interface is
managed by another mac interface, it means that this
network port cannot work independently, especially
when the system suspends and resumes, the following
trace may appear, so we should create a device link
between phy dev and mac dev.

  WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
  Modules linked in:
  CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
  Hardware name: Freescale i.MX6 SoloX (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __warn+0xb4/0x24c
  __warn from warn_slowpath_fmt+0x5c/0xd8
  warn_slowpath_fmt from phy_error+0x20/0x68
  phy_error from phy_state_machine+0x22c/0x23c
  phy_state_machine from process_one_work+0x288/0x744
  process_one_work from worker_thread+0x3c/0x500
  worker_thread from kthread+0xf0/0x114
  kthread from ret_from_fork+0x14/0x28
  Exception stack(0xf0951fb0 to 0xf0951ff8)

Xiaolei Wang (1):
  net: phy: Add link between phy dev and mac dev

 drivers/net/phy/phy_device.c | 12 ++++++++++++
 include/linux/phy.h          |  4 ++++
 2 files changed, 16 insertions(+)

-- 
2.25.1

