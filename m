Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5292B4791BD
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbhLQQoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:44:01 -0500
Received: from mail-bn8nam11on2112.outbound.protection.outlook.com ([40.107.236.112]:27296
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235932AbhLQQn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 11:43:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfHa0PgYUYKwZsn28/6/l7y/LJHbmlDSlL7K8H9x5z53igqkOadtAjYeFc4z+UqqXTxqckN/NKvcZz2c8AV7LlYGO8mYfTLt63cZcCIk+CMI6ZVXGh/x2G5Nb+oJHnpVkly2r6Ix4vHE9KG0t4u/6Y3g3oeIU5xzWrlMRlrnAdG3+LU8Xukxa//Xu2LmIGf0VjMnC6Y4N011V88AD+Tzs3ACmcBLE4pWIU7zSywL7Jkr2Lc1BPjdOW5kiydy1b+Zt87r6cRMlKU/FIOI6advhuTerscbOd7RGzyDM9roKBn1QYF7O7k8u5vA0bH8BDl05bldgr9SwjLInZaZ7d65zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90ODRF2Hh/V81dE+VsMS0XSbLVfjlgVxoFvyBJGTsUw=;
 b=bPm3swWxV3u0+ZywLdmpIcGJWo9Hqoz1J30i14zsk89AfE8CBS79gIhKJ+EMwFcP18uzKfkJT547X5eqC6oWY//Pq59iQfyraZIGEF/HlC6rBD1nQKnH6i+1lekn4PGouGQuhbLBS7Xdkno3MxyZ3nls62QchNXiAt36vXBldJbRciKTAvJKBd8de2kBqHF/7yyvp9PjC4uKX7zFvNy6XJh17o70pPyDKnbQ3l1CsjFengoVqYQ2tDLFxc07e/iuPdA8JM25SW+8G1l/EEkzN7Tm2QZOi0L/zqBdiiDDwKgIcAwcfa8B7wDMxBMuERTm4mNvF70ePQYgmJljuFttbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90ODRF2Hh/V81dE+VsMS0XSbLVfjlgVxoFvyBJGTsUw=;
 b=vB8WvJrnp4O+TDQ85LMlQcWCttCknk27HsxDFnqWJ7WAQyXyRzoksvCLmA1MRcXijTbtrNFS1NMnyfq1DgU6OA/oInMfrCup1tVjkFNI+XcD3LxIvsM0lS68/YY24X7UDt5f/EqwfEcdNJ1nVfPazvw1xBLmKPKFkaTR1BpXGYU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4969.namprd13.prod.outlook.com (2603:10b6:510:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Fri, 17 Dec
 2021 16:43:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 16:43:55 +0000
Date:   Fri, 17 Dec 2021 17:43:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH v7 net-next 00/12] allow user to offload tc action to net
 device
Message-ID: <20211217164345.GA3717@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR03CA0105.eurprd03.prod.outlook.com
 (2603:10a6:208:69::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 548b117f-3753-43d7-e015-08d9c17c6a78
X-MS-TrafficTypeDiagnostic: PH0PR13MB4969:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB4969A3FA78CDFEDD026BDDB8E8789@PH0PR13MB4969.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRU8l4QAHXQ80vxtIJvvafQyjpEDA1ikGFQklhkNdRAE7t/heGrS6vbiFk+jFlQY8e0y6eqBPM6DQvf7+7cZNcOasQJFx6QFuaD34wnBMRO+X/SKxXHw7PYH+Ma3PBNMCQhoqc8uFbUEfuHPotWYecDatOxbDyCyaqRZXYBQJiQlJku6iQNyzmAraW6qnR3U9T9CenT2DznCdOCQKzk2wFe8+2Tt9s5e9+9F92jpSPVUfJSDuPr2iCRq9+Hr+4s2nyGc0Yj3okU8D+Cz6eqv42qT0SLCe0zHBaetuvIDIFNjdGrQ8IBMAlu5AZ1r9Vn98jKWKKOpcqqTzK3ma/wyNIsDjOCOWvA68Jabmk2kDiq7DOeNmyFKpdHe34vQ+llwPCr7baXYZid3TGGd2jiCSTga3DwR3aFcNU8o2syWIAoHMcCq85w5TFujiOE+MBlSqhbXm+c46eBfUVG64JfLlGPwWO5smhl4IUA0yEmSZgJM9OvGcyjejF1Di8vSFpNHXpcuLnIvhowQDSku3CNH5YHQUNy9ybdYK9444MXBv2ku3kyJ3QA0o3ju52kvKB6n+iXTeh19z2LBhGloKZ5lsqtPjvlPJ7xI7DaDWcsKAVqGqCmWLb5bA+Z+BcxCxmR6KoxNOAznZutja/AAOs1b9ELblGaSQ/PO9xjSfWyZmll1CanvmjN5MmJGHFuGlokV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39830400003)(52116002)(83380400001)(38100700002)(6486002)(66946007)(44832011)(7416002)(66556008)(36756003)(33656002)(4326008)(5660300002)(2906002)(66476007)(2616005)(186003)(8936002)(110136005)(6506007)(316002)(107886003)(86362001)(6666004)(1076003)(6512007)(54906003)(8676002)(4744005)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DbSTkaUcRYVncuEZsX5U11F5yoEzC/hPN6Zj6MPJk468ZqKO+1mjCw+v3KAN?=
 =?us-ascii?Q?6o79K9jsXMPcOG1/RCxPyOoaxXu+Ye/lHzoPVAuz3y2zSUW5BXYRD/GCD2Zu?=
 =?us-ascii?Q?3T8AbUUeHG6eIUwxZRbDZXi8jrij+8GzdT7/YwaMiGfuTKvDo2SrqglcFVuW?=
 =?us-ascii?Q?La3UvgmB1QpN0Flgs1BBYtWNyB/2ZF0QVvDWMYEwNF5EMw9CsAwdMnUT81zz?=
 =?us-ascii?Q?gIHXDJbEOOBg/1q016tIO6M/KEbQy4N0J46vAU+LoLOMhRTbHN+/zKUMAWV3?=
 =?us-ascii?Q?53SFSsO36qFH/9YVciKjWcioZcNotbq0nHqI1NYRCKTAxL2l+AP25hY0X8s/?=
 =?us-ascii?Q?mev3gZ/WICpo346ZNlbXpgbFccFY3bIDiuMutPPWDY0MBFfBCI60T+uRl+Ed?=
 =?us-ascii?Q?GAgDDgI/EOt/UFS0F4yAWHxSo1mVinX2ZVHGJdjVlU9GMDRO5ksAlB43XcV+?=
 =?us-ascii?Q?OP7Bk6/h3BH8mNBIr2FusGGjXvz8/PRWQLpQthjoDIEggWUSCJMUOrfBh63L?=
 =?us-ascii?Q?lpv/8Wexfk9rtS0xeHgYZGC/bkv7ZCTudQ4VPpzomy9fJ8oGni03tpwbfws8?=
 =?us-ascii?Q?DBQfHW4aBjv3q49LR6iz8GIL5odySFD+Mp2PZnUcy5jB5LtZC5BW/Wcm8UD7?=
 =?us-ascii?Q?LS/wcY61U1ekGe/JkfmaxgwkTh8KudJVdL0wuE4kp0D2bznd0nRG9/73mQkv?=
 =?us-ascii?Q?gD3f5kHp1zmcnrkx5eYs3HL43J67YDya7Crz/MmiEN0ND2XHSjWSjSX3/Mhf?=
 =?us-ascii?Q?u081bEGOoM3iiHuWaf0qwjnjN7jowQwBl+JmM3M01furow2dA0sxV4Z5pRHu?=
 =?us-ascii?Q?emHb0k8Flf74MAPbbGyVH4UPCYfFgU2qxewylD1Vk7QVYiI1yI3KhKWauQnB?=
 =?us-ascii?Q?W/YU6Yk6nlEZdXs1S4y7PMhxUpgceLK9bZ6Rx9lEWh3pOp6KYqwYK7K1MKKO?=
 =?us-ascii?Q?Xv12p6ARi1LYKcOFlOVd4l+OXvAEcaZ3Yi7Fl3mQUopWgSD0XEiTym1Yth7j?=
 =?us-ascii?Q?HMZxqshcI4TeF3KUA+lVsHs+dca66xIyoZnWirKZ9BWUV572vbZ8is+Y7nxE?=
 =?us-ascii?Q?Wpl64kaAFBkd76mgutug898bcBknJdMZhk1/uV5mKNLahVNodemnPS1ZpU7V?=
 =?us-ascii?Q?QjmRqKQliWyJvm5GdyXXwcPeCw3+rZNJQ5NtsoyvD6C3nCh/2wJ7NrozZn+Y?=
 =?us-ascii?Q?KSSr7kNc9/4lVVcSsUMfLD14Cxy66ufJKer3sdGU++XRc7plfctmlkGJYeW7?=
 =?us-ascii?Q?zalvp9jtPNUQBtGXruTgzl7hsfBs207yt1oeCSoM87hQho3YXWRMQ0itg2ca?=
 =?us-ascii?Q?3gIGGYuSujd+S4roR5jX2v2bkKvhQAAiOirWpKW7Eduo69zXwrem3HtVOAaR?=
 =?us-ascii?Q?84SJSnHdfviLy39q56vyPUxdgPoZBPpsje9pU4jW7R4NTlVk5veipx5wczd1?=
 =?us-ascii?Q?GNOs6eU1aGO8kaBq0k2XcLtF0KS8SuFkkbCD1146ZrutFOF5QpJg7GfqqXZs?=
 =?us-ascii?Q?oU+dNfmUCYslwcR6PErEegWC9tjoWVGlk0nQ77wFqb1/BjOB6UZuwzOJKpdq?=
 =?us-ascii?Q?B+SQxhVS+FSxUvxeQAm8amq468G5ykOwFGh0HWuVaTdqdEU2oXgBFhxAAeSz?=
 =?us-ascii?Q?sUkctVsVOF4JaFh8WnwQKofPDTgUvdXaX5aKT1f8kuxsQ5rCWCbnXGGo4Pw8?=
 =?us-ascii?Q?8q8Ecar3B/kbN5xadAXZF53+KCHs8fR4moireQHUO37A7YcrqUWbCslT837S?=
 =?us-ascii?Q?oJYNIb01MHOA70JXB+wS9XhkPxIp4jE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548b117f-3753-43d7-e015-08d9c17c6a78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 16:43:55.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SiOMxH8bfZB6fFroFiZagzVIM13gKnWHViCaK0hYMKIRX620qBmK0Us0A3qv4vdJ76cperowFOuPvtDCWBi6LgFcmzJzixuvg1+2SgFmFzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4969
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 03:21:38PM +0100, Simon Horman wrote:
> Baowen Zheng says:
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.

...

Sorry, I seem to have made an error and posted slightly out of date
patches. I'll work on posting the correct patches.

Please ignore this series.
