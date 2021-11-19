Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D25456866
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhKSC6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:20 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:60242 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234213AbhKSC6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:07 -0500
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2lSMk000941;
        Thu, 18 Nov 2021 18:54:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=PhaSuD6YLNDrgi3j/n3aO+H+AJ/gAuhMJTXgqU7eWu8=;
 b=CfzyPGJywNCY7DmzEzmijSinpxYbH4/37B0LbZ3lGvn3KXd+1sKAbaEOHGyQfRqb+oec
 TzOjLogkanfftgTydVjBjRToK5Jnxj5k/6xKjR08GV9LvdXldUW6r9EmGRv3GSSvYWkG
 S987PEm3YG4Nof1LDjWaMimUcNQCIVnDlhoBFiJx4lkqCnnk8LC149xawAd9W2y+nfGK
 D0tzWamjtdgnWBY5ix0u1uY+m5+jNy7Bi3F2vhndY9Szrhqwswy0Wk53Q4CTgpIZoSaI
 BknLULsORGOzDwd/c/ILt8sPEOT2Ib3Pb+Eqdb0zElMIywYetzQO7JHJvvjtmG1YluKd aw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ce02h84ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 18:54:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFDA20wJYZAvRji3qsQFZNkv3je5IvuU/J6zqdl57Wyj+12OH1zqwLqSTABFoAnGp+neAIo6BigGN3zLdQFwcvGyY1eSnvSAK5Ycq8/cWtFdAi7vlJ+1OENBCdHrjm3H3XkaBlI7k1+fi0Nvu3cjZY6S7nd3KboIFOnOwriDO4phKgOm3GEazVqSQBq+Cnk4fbgWR2V79OaIHQp58P5tKsYVS1HS/kyVOWl7gH87BSF5TXE8CKMCvS/5I/RTemGddcPa2+Jh0exDD6PNOk7BbFlIiktWIJw4Ko1ESUfEALkxhCSwXaCN6439eYEZkoagMAm+DLuWjK/D2XOrLB5ZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PhaSuD6YLNDrgi3j/n3aO+H+AJ/gAuhMJTXgqU7eWu8=;
 b=lWRxju1nemTnaaY0zBVKhoy795RDDm07txPri37GtBdj7F2KuDYO98+wo6izG04igIfdTusR5NvHuqS9gDu4nMm3X4oUK9kWh71Bf9AW+mUtJXqc9DYU0wTyWrEyAsgPLNoi1B7g7MtlS0G1dYR6gClE0sK71UFfuo44c4sxLYzVHCSimd1K3OwJTa1+CfktrD8FDPe5bl4ZJ5fRahn12utBIjDkX/R8fl/srwh0xwkZXMv8tqMKfCmgwEOC/v8sGxXoXeN7jvn3+KmK5JRT99Cgc5po0cOQumpsYpx8+uQ3nN9WYcuNPy5VmUUvuagXRn6otA5Bya+KO6HrUGqMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:21 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:21 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 0/6] backport patches to improve clocks management for stmmac driver
Date:   Fri, 19 Nov 2021 10:53:53 +0800
Message-Id: <20211119025359.30815-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d8a707b-4262-427c-635f-08d9ab07e2b1
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4951CCB98BD845046BD19A15F19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qCat4ktycxrzzz5BNuqpyJc/gLsxjAt3mIDXo2P1hu4MTawJJXFB9LPlVvZd4e0gVbI7A/U9RI2HR2REXwqyGnenJFvU9j9/sMSbJS84dIfMYuTC/96xarhytBXMgR/4TQFCCWv4IcVsX6vRIHmWDCtd9OFoGk3QBkgmGsmjo6gxE25JrPUAEWd1pg21QWPgXlXVN29o9lBg6CVkSgXKxJrQhJBJdFS7Lx68UqxvBfYCVDUbltKX0v2e3ex0JMWJBM0WL3qbWC/nYyJ1WzH4JTF+ylQQWDw9Rj8Ueg5J6bj+wmSm288XAvEopnTynGppD3924RLgRS88Td/qUOmjKzaVOTIEKMPpp2OSl6idAxgamEE561DsnC1tQBXo+TDG91ZK9c738s/O/Oy4rSK6JfZI6v0x2aIb08GRCaBx4iHYLeFpl3oPQXoLfA36iwaDoQmvlBvhUKD3ddQztCygBfUAbCldk289+rq90Zto18n0HT+NnR0etxDbSZqKj5SuNEgGpqjOKghjXHs30//32GHSuAWuX2jtufmsRAIjX+HsFTEuoJlrU8/Yp+tjP5vdmVIdnqHCWoRkd+P8e6ysxl5DgZPRqvbW1kCI36L7C/FxAlV72mAY4yjsD9CPX4L8bNIFdNrEoPb9vaXIlaIZX4A+E4fw6Dd2A4BBA6pW9K+D19kpGqcunjZt4F8z9GfV+ZmKYV4XJd+DavNXzltnpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(8936002)(45080400002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YL4ndlGFPQluq2SZ01+Q9U6Yr1JAbQABlfqFQX1MMYZdkWnFuzsYFBun9sGr?=
 =?us-ascii?Q?wImQp+kzoIMsJ0+x23JCbxs9Y8Q6KWnP3dPmC5srkGdlCgmBOaW1dPxQ/YmG?=
 =?us-ascii?Q?JBZvk2WisGKzp+2/sw6eMWB3UnSHIF6xw4ZwdsNQFPyaVFviiGIxBME5u+Ot?=
 =?us-ascii?Q?pSuFyMc8oDT/1025etlPZSqHMtVmPgVKEkkr2RacWO7KjoHp1b0RWR2xybm6?=
 =?us-ascii?Q?CsV0ofboVqO28bqMu+7EMqi7m3dV8JlljvH2AXIkeEDUdKAY8yzKjODilCti?=
 =?us-ascii?Q?f8HS4VdFnpE3QZelxR5r/QQB1Ejioi5MSLRr+NSEtAAB3PH3yrFUZ5V1Zf32?=
 =?us-ascii?Q?iLXJMRoGIm0rXpVjd4qVuMMDbBo7PSQ0ekTHNVKmwu63+fYiqa03rwAs4vUy?=
 =?us-ascii?Q?wKCkY5e44TlmwLdaslp1s85AEnkS7pKCMSryVyhJWB89HxpmtNmJ61hBVr3Z?=
 =?us-ascii?Q?gC3mjj07cmvhvrBBOjzpt1jIThMkBLj3wcIEu+kUS2qpKR8yOU+qzrTZECqT?=
 =?us-ascii?Q?1Yks8keyrfxlotrgnHw81FR65oM1xsdE3M+1Tx3+JyLXheaXzx5KUrH6cGUo?=
 =?us-ascii?Q?M6yNPyYm/kMyazuZ8BrMgHafMo8hFZ9bGWLgGLAhv6Scwb/NCq5eS9gdS+K5?=
 =?us-ascii?Q?NXFwe6JOZJ4V6XdDgKuq7HM1KNAkEzvFJuscULNEs+tuclnUrv3g5JmLo89/?=
 =?us-ascii?Q?3uPVvfPeUY5QWY4Yq6Ko8GrK9zsVk9bAAPEW82caeXPgt5RnxWrt2wZvJZ4m?=
 =?us-ascii?Q?Yx6uWXlwlJfCnMbKj7oBZPwq/HloUrD1sGpxKytD3RhNrF9Tmbsv68BsnUzr?=
 =?us-ascii?Q?6Q3PupCbU0QMYrBw1z0qQ7yNsTvtVdhSYggKCmIvR+FiDfaxyPelOKlSBIjs?=
 =?us-ascii?Q?vVhdT8F3EaeBRKRz1O6ysKXCvHlVYeyaOpyOYRP3H0U3uYZvp+mq85fpnWbH?=
 =?us-ascii?Q?8M6mBhcPICWoPsiHR6hyKW9psmOJ7hXLWBwXDFVvam+Fg3ZoLasn5WRIRs6M?=
 =?us-ascii?Q?qfSTevnpsuwkgoamdcHAmDxMTzDdI02pkekRty4eb3o30qUUpG+EOQ+cyfwQ?=
 =?us-ascii?Q?H4U4j1hkwe2zF5AXZSXdJCHtjKljhfyIlhezRiZgapGfe+IKkC45QjfYa2Ok?=
 =?us-ascii?Q?LEzTilbGXLueAQi1uKj+YAo7tZ4UB10d29LYd6c2CVtCOoE4lO9OTG9joOX2?=
 =?us-ascii?Q?zbV9YJ9ZAxnWtDOpJIl9d7iBSy18cac9JbpUPwyzkJkagoXcWjbkrusf71UZ?=
 =?us-ascii?Q?MP1ItMEHNMU1Df0V7fYQDxLl/Ywysna0XZ7fcdICTVU+pZBrA5MG/P4OMwjc?=
 =?us-ascii?Q?J86GKHpmZM8qXw/+eAOuGrZSNZ7CslBbcuNizRfeJuf5s4BSs9mXpf/2qmyh?=
 =?us-ascii?Q?tyH9tAY7ufm0OkjZKIltC+Hv89v9rgPx0x1HUqZ9ODtmbFyK+tXJBRenaG8w?=
 =?us-ascii?Q?6y83WYpwGErEnviZqH2YJzUSE9/27B6jO96c7WVoWC4wHl5vLk/GZiqZLeVk?=
 =?us-ascii?Q?I2RN3RF+yGRdLN+yT9u42c7L3g1N6y+3R6tATXHpDVne1iyeAJmd95/Y5Gmz?=
 =?us-ascii?Q?AZlPYdkkxEW779fZU8fOk/yoEAFKd3BCwL/klNOn3A29bkiuW+kmu8Q5fKNm?=
 =?us-ascii?Q?J/DmE0OF3rgF6mEKzKNdl/I=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8a707b-4262-427c-635f-08d9ab07e2b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:20.9925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObiEWV3C/lqJ9kZSneSSB0OFXUNASD4fz9j3gQAqPqwGsXdYMZ2HvxObPsPiD7i9As8FI3v119TuiqvUP4yCUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: mm3aUvB7Wzs0xlFOKfaukAvf49qwKQcJ
X-Proofpoint-ORIG-GUID: mm3aUvB7Wzs0xlFOKfaukAvf49qwKQcJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 mlxlogscore=733 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meng Li <meng.li@windriver.com>

In stable kernel v5.10, when run below command to remove ethernet driver on
stratix10 platform, there will be warning trace as below:

$ cd /sys/class/net/eth0/device/driver/
$ echo ff800000.ethernet > unbind

WARNING: CPU: 3 PID: 386 at drivers/clk/clk.c:810 clk_core_unprepare+0x114/0x274
Modules linked in: sch_fq_codel
CPU: 3 PID: 386 Comm: sh Tainted: G        W         5.10.74-yocto-standard #1
Hardware name: SoCFPGA Stratix 10 SoCDK (DT)
pstate: 00000005 (nzcv daif -PAN -UAO -TCO BTYPE=--)
pc : clk_core_unprepare+0x114/0x274
lr : clk_core_unprepare+0x114/0x274
sp : ffff800011bdbb10
clk_core_unprepare+0x114/0x274
 clk_unprepare+0x38/0x50
 stmmac_remove_config_dt+0x40/0x80
 stmmac_pltfr_remove+0x64/0x80
 platform_drv_remove+0x38/0x60
 ... ..
 el0_sync_handler+0x1a4/0x1b0
 el0_sync+0x180/0x1c0
This issue is introduced by introducing upstream commit 8f269102baf7
("net: stmmac: disable clocks in stmmac_remove_config_dt()")

But in latest mainline kernel, there is no this issue. Because commit
5ec55823438e("net: stmmac: add clocks management for gmac driver") and its
folowing fixing commits improved clocks management for stmmac driver.
Therefore, backport them to stable kernel v5.10.


Joakim Zhang (2):
  net: stmmac: add clocks management for gmac driver
  net: stmmac: fix system hang if change mac address after interface
    ifdown

Michael Riesch (1):
  net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings

Wei Yongjun (1):
  net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP

Wong Vee Khee (1):
  net: stmmac: fix issue where clk is being unprepared twice

Yang Yingliang (1):
  net: stmmac: fix missing unlock on error in stmmac_suspend()

 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |   9 --
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  87 ++++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 111 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  30 ++++-
 5 files changed, 187 insertions(+), 51 deletions(-)

-- 
2.17.1

