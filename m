Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0D46BAA2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbhLGMHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:07:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13596 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236069AbhLGMHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:07:11 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B79A93G019273;
        Tue, 7 Dec 2021 12:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=e3iAK7B0QK+fe/96TFkoifEWzOL1noWm0XurUn0nCN8=;
 b=FrREOj3FDDgZSv3jUREAbSQ+6JUjZAfSuACsVeWw/FJ7mvM9wd1G4vjFoQMF9vhQcBzy
 iqfW1eTUu4DmybQ5PYnhJvOvdVm7S2y7ThjkAU3jX9y0hsAAZ3TWCy7yLt6R5CFAK7lW
 0YJg5+m8X6oeXg0Nnv5uac+PMR5Z56zepMWCUOU3w6FPzNLMqQO5dYm46x9iLaGN4oB7
 FpRCwYLbrt8JapVLqswbZFI+dxRa9Tr76CjMxXMice8ki9wTNe696pizLkayyPFWjpfz
 8z2fLcn8pnerusHrxqbT6Jmq/T/rBg+DHO4GtMYV33L1EZHcDnZBqaePbnj8Fbl328dX YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csbbqnhvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 12:03:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B7C1DoS017803;
        Tue, 7 Dec 2021 12:03:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3030.oracle.com with ESMTP id 3csc4t5xjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 12:03:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWMr3Bs2srK5o0BrOvn26ynWINr5drTGTV0e6fQbKOo39vViM7G/FE9IrOrfGvpDp3alyXXelffCZxLlkt0sCGhDu9yiaACRFxEgCVCDr73bghOC7S6Uf7ZIFXxAl8T432wQWCKpxMZPjzSDm1dlolW5d174tSSPTngGqWW4uxGm0bSpuR1mxlwVITvH4CwsEKCVXy4RoCrMOJUkGqnEW/MDSSskOeEqiouWZ/6Gpnii4W/nEux5lde4Awm3YT5R6rT8M/3jP/HcENJHhH+dDtl+E/4pt/xtCUw6RNjYxMsGSwfM2gYJVr2ifG+pU15XLooGUPPAHiEp4FENj5jjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3iAK7B0QK+fe/96TFkoifEWzOL1noWm0XurUn0nCN8=;
 b=AWzfyWjYm2g2GX20TFPql39wTgFVRf9HNKohse9YLhVOKzy4ErsC04rGp/y+yhUEgM2Yb4pVU9i0N94w+IpleNBkp+9sGWpS0xCGSC+2NOiu3TNXtXPWO75oFJVMQumAxySeR3vXaSBLwaDloc4gZnZKLKI7rSfRwg80jaFeSbcBMI9PfiLSlFgbcc0yS0fzDQEtGQXWvsGhFyNegi4D2MViig7kxdKEqcYoVIsJiuy+iRBmuEQbvWS6mu5fldiygN3oazfWufX/452ZKyTBGDFdt4p7+bhD1OoXFtkqO4wscPDQL6LqF5XuQwr4/w/hnX9VZbhdzPT3nFR89AgfVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3iAK7B0QK+fe/96TFkoifEWzOL1noWm0XurUn0nCN8=;
 b=TbvbkRiWKRi+Hnk98wVKpaCH6z8AWvUyecBpu8RNayrruqSfrJGBd0F0ZpTnvQWh0XXsTq4rc6EDuHRJobeyqsDiA6O7CpTlsInmlJPTExuoVW0TRpfmIuOU+3zDHqSzzH74bHM567VEP4PsnOHD9UAOzstQYtyv7pjCo9gMIrs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4483.namprd10.prod.outlook.com
 (2603:10b6:303:98::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 12:03:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.023; Tue, 7 Dec 2021
 12:03:31 +0000
Date:   Tue, 7 Dec 2021 15:02:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH v5 net-next 10/12] flow_offload: add reoffload process to
 update hw_count
Message-ID: <202112070927.kCpOi5qD-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203122444.11756-11-simon.horman@corigine.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0068.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0068.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 12:03:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd34409a-0c9c-4438-a175-08d9b97995af
X-MS-TrafficTypeDiagnostic: CO1PR10MB4483:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB44832419D48EF83F4964A9268E6E9@CO1PR10MB4483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elgEK3JOvFCfDqY0kmtbSCg9Zgmxh7iiuWbf8DYe9sJtu8fDJo77zC9DyLj/jl4SJDM+S4FLHH9QD0cPdugpJjRkIHcaWPHLynNuSawMEDJAdx0luzIK6kgm48GlDyNpzTtrC4kGU1meGm0LXPFB39DT0ASTD7nwzw3Y60VPO+70LxuhGtv7g7XPYfl5s85/EYiVqJVIIuOpPdL55dhfYirwxKIH1Yo0y19Q7sLCm1ezl36pYLWhBa1982QpPXH7waL07Ucad+F9vLODgATDFgHeOv1UEeZyy3dyam+UtNRrO7WmktZrwO3BFm79YFVqqPt/j4H9hAkIKBk1svz77oQayH8jI/6hRETVG6lisQyNolw1UqD8xUZcb4auhIIlJKTNpFr8aXJFaHL/0xD1KZ093V3Enx1T7zJub23reFwJ0YzVqbUxHDkxYfZYXfvyEnroxW9OZ0fRL8RkqOIiaNCccs5a4+ve2oYa+pMcPwbkmQFf2V+Z0nIvFazi3AHM76aOv9zD3h18ar+r4tF25YDzmJy6b/TBudxyNt+qC13g8T2iDjiz1patZJUxjjhVnUUhXnXXuSCA/9FWOrMlUxdKSBRmSxs38jJ6uYR7rqqBVJ/lYqzdTbO0uiaSvI70UzleuNONcd0yEnKvcnBpax2PCfESbByk5pyA4VRrxzf7y2Oe7FrK68mCxhgAQSjZlsN4iPSrmIT+nJX3G5DBz38Na2X7SqeFV7GS4x82GQhkBafFs4kjxMXJvvmwKMSjBV7UernGF1eMa3vov3lO9B+lITlxlNx1Wz5lfjv+DdOY94AsQzxNRfXw5VM/Ue4R+MCZXjuhQtg8H0+TLHwBeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66946007)(966005)(1076003)(26005)(508600001)(6486002)(44832011)(9686003)(38100700002)(36756003)(38350700002)(186003)(66476007)(956004)(83380400001)(4326008)(7416002)(86362001)(4001150100001)(5660300002)(6666004)(8676002)(316002)(8936002)(52116002)(54906003)(2906002)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1KEHM2MsnT/7dCUnLS4FOioEU1ppUs4fq+fYmoaM7D99M8sN6xNznnYdW0/u?=
 =?us-ascii?Q?lxZJ2pMQCX/NJQnXM3S2qa0eCiqiwh5IsS3spu/DzTSpVT1bICfTtaiB+txn?=
 =?us-ascii?Q?28x5hqIBYKtUCYH0UdRmjmLkk/9aIxUYmNWx66HAs9MYVatzTya3XmHhUPwa?=
 =?us-ascii?Q?+ynv3e+qDaNoQlA3zKDtccyloByrFUBP2HOtid1uGqhdSWK9GJkzDH0kH1b/?=
 =?us-ascii?Q?+uxqcPA8TY4mc0+PTTvTjoGEd5X07n1uo5p9NMoubVf2TntzaN8IgOT+wW4b?=
 =?us-ascii?Q?HZ6O+aVZfZbSRP2n+HXIp9zD7SQqMsHwBqUSHB2QtiCAMnCEsLHT1uyYOiob?=
 =?us-ascii?Q?Y6zRQCeR/KNX0CPUgQT1GlKvs949s5ZExv02mkZiugbke4T9QkdBKtH/SQ46?=
 =?us-ascii?Q?pxU4a5HWDNdnuaeNapvkWLrHNYACM2bjlqKhjYHDevW7IniJtUxr7X5qUGwD?=
 =?us-ascii?Q?OcOCLYSbU84korMq4Vkj59zz0Q6bwtW5BD4VJYDdmhg4rjEdl/ZORbdytma8?=
 =?us-ascii?Q?IwyGWN17RZfTQaA1Tqw9NrM0QKNkNWa09MfTI0+Z2DuOkuCHYs7vZ/VG8qP8?=
 =?us-ascii?Q?K5M3FzGSZSYvyy/AF1trR6SIDCj1/IUyQI5Q849g0bQEoeGBr1XOA0kU8/6i?=
 =?us-ascii?Q?tWkjcEgqBpBN6hgv5RS2YVmYW67xEJ6cal5q9paw+3p92LfHHL0DiKVCVlpF?=
 =?us-ascii?Q?mHdTTn18duxIMG5+3aua5vumupROv3i6WYBXSmBGeKPQgr2+4I9zpncCKeA8?=
 =?us-ascii?Q?dPPlvmTBGTC67efscqjQKRg5qx/6mf9SBE2kwphxq+Uol/c+OTpkKu+zCzvE?=
 =?us-ascii?Q?a67KN6M7OqKSKG7oNZecniSHKY1NhqvGu09NYGsmYXBuB9iOW/nX1e8VCcae?=
 =?us-ascii?Q?q/vNP6zLRXZNpHOHtHiIAO82DHWgPG8ArUfiYwCGPd8MZF47izZmFdhy5XCc?=
 =?us-ascii?Q?Nz64GIgvmwIErPruruq8Wukt6btfaaNa5iMDBY1HWmLcbuih4Niv3MIIBPap?=
 =?us-ascii?Q?vR5DwQs5HYObBBdWTBeX06UD4h3Y0eAjo6j3bs3n6xrZxl4PTzTu925pw5lN?=
 =?us-ascii?Q?hITUe1POqD18wPpmHSav9BBvc+UE0cvxySfGmh0RDDuGTKHhoEcwe/yzb1Di?=
 =?us-ascii?Q?Qyb0zffQ+k+t8Gef0AowaE4zm+LLjkB+RRCuBJiwby5Lxx9M33jbnNjsnumv?=
 =?us-ascii?Q?j2VtsW8GOFqrLfTpadQUM7r8OeDBC47N/V5JKtQVPSQ/uQENNZbufCemTUZS?=
 =?us-ascii?Q?VAuLtX7WhF1cSxFFwMuFjvGUW7MkVL4FX6E0mxDcH+ZXQuA1o9blZ6QS30BB?=
 =?us-ascii?Q?f4IvIH4++Hh/6PHrttnw3mB41x8x6WkcfxTDdXIOh8F1LXNgGqGQjHI33OyG?=
 =?us-ascii?Q?ioJXT1O3MqMY4UrOikh9S09OrCnQxgMrH/CWrtq5s8TNbUYLTEposx+EkJu+?=
 =?us-ascii?Q?lZYTNy+ht4IkUSjYUayCW5hcd80wS3UF94VmFMSLBjlV5VHVv5cy/F59k6NV?=
 =?us-ascii?Q?2yn0fXjIVe4CJj36Zz7cnMUTAqg4TuLbM4gZw0iy1P/tYT3uMH/wXaK7o/Zi?=
 =?us-ascii?Q?vjT7kkunE2b38LnAIqkLycBhTFaZBXs7C2HLZUqpuhhEGEB2TdgIVyOSFWha?=
 =?us-ascii?Q?dWA2qJS7nmMU33YX9Lr9v3O76poAHeJRz78j4AprQioeyAgizq5B+5u2u/mF?=
 =?us-ascii?Q?3XnJ3a7Dk/rJDVC8/r21GrTv9ZM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd34409a-0c9c-4438-a175-08d9b97995af
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:03:30.9428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZICA1BnQYKMo6Y7PIEQs4Qb2h6iuk1/PijuoeXi9uwZ6KFqkPhCFzUop4DFaAIp4GCIQ0tNmjSLfGBMGinvr3t0/aX1DNlSWnj4S4fxjEA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4483
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070070
X-Proofpoint-GUID: iLJmdReMP8Wnom92L8fdCaYgkg69jRfE
X-Proofpoint-ORIG-GUID: iLJmdReMP8Wnom92L8fdCaYgkg69jRfE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

url:    https://github.com/0day-ci/linux/commits/Simon-Horman/allow-user-to-offload-tc-action-to-net-device/20211203-202602
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 43332cf97425a3e5508c827c82201ecc5ddd54e0
config: i386-randconfig-m021-20211203 (https://download.01.org/0day-ci/archive/20211207/202112070927.kCpOi5qD-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
net/sched/act_api.c:946 tcf_register_action() error: we previously assumed 'ops->id' could be null (see line 926)

vim +946 net/sched/act_api.c

ddf97ccdd7cb7e WANG Cong        2016-02-22  909  int tcf_register_action(struct tc_action_ops *act,
ddf97ccdd7cb7e WANG Cong        2016-02-22  910  			struct pernet_operations *ops)
^1da177e4c3f41 Linus Torvalds   2005-04-16  911  {
1f747c26c48bb2 WANG Cong        2013-12-15  912  	struct tc_action_ops *a;
ddf97ccdd7cb7e WANG Cong        2016-02-22  913  	int ret;
^1da177e4c3f41 Linus Torvalds   2005-04-16  914  
ddf97ccdd7cb7e WANG Cong        2016-02-22  915  	if (!act->act || !act->dump || !act->init || !act->walk || !act->lookup)
76c82d7a3d24a4 Jamal Hadi Salim 2013-12-04  916  		return -EINVAL;
76c82d7a3d24a4 Jamal Hadi Salim 2013-12-04  917  
ab102b80cef28c WANG Cong        2016-10-11  918  	/* We have to register pernet ops before making the action ops visible,
ab102b80cef28c WANG Cong        2016-10-11  919  	 * otherwise tcf_action_init_1() could get a partially initialized
ab102b80cef28c WANG Cong        2016-10-11  920  	 * netns.
ab102b80cef28c WANG Cong        2016-10-11  921  	 */
ab102b80cef28c WANG Cong        2016-10-11  922  	ret = register_pernet_subsys(ops);
ab102b80cef28c WANG Cong        2016-10-11  923  	if (ret)
ab102b80cef28c WANG Cong        2016-10-11  924  		return ret;
ab102b80cef28c WANG Cong        2016-10-11  925  
d99abedd4989e7 Baowen Zheng     2021-12-03 @926  	if (ops->id) {
                                                            ^^^^^^^
This code assumes "ops->id" can be NULL.

d99abedd4989e7 Baowen Zheng     2021-12-03  927  		ret = tcf_pernet_add_id_list(*ops->id);
d99abedd4989e7 Baowen Zheng     2021-12-03  928  		if (ret)
d99abedd4989e7 Baowen Zheng     2021-12-03  929  			goto err_id;
d99abedd4989e7 Baowen Zheng     2021-12-03  930  	}
d99abedd4989e7 Baowen Zheng     2021-12-03  931  
^1da177e4c3f41 Linus Torvalds   2005-04-16  932  	write_lock(&act_mod_lock);
1f747c26c48bb2 WANG Cong        2013-12-15  933  	list_for_each_entry(a, &act_base, head) {
eddd2cf195d6fb Eli Cohen        2019-02-10  934  		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
d99abedd4989e7 Baowen Zheng     2021-12-03  935  			ret = -EEXIST;
d99abedd4989e7 Baowen Zheng     2021-12-03  936  			goto err_out;
^1da177e4c3f41 Linus Torvalds   2005-04-16  937  		}
^1da177e4c3f41 Linus Torvalds   2005-04-16  938  	}
1f747c26c48bb2 WANG Cong        2013-12-15  939  	list_add_tail(&act->head, &act_base);
^1da177e4c3f41 Linus Torvalds   2005-04-16  940  	write_unlock(&act_mod_lock);
ddf97ccdd7cb7e WANG Cong        2016-02-22  941  
^1da177e4c3f41 Linus Torvalds   2005-04-16  942  	return 0;
d99abedd4989e7 Baowen Zheng     2021-12-03  943  
d99abedd4989e7 Baowen Zheng     2021-12-03  944  err_out:
d99abedd4989e7 Baowen Zheng     2021-12-03  945  	write_unlock(&act_mod_lock);
d99abedd4989e7 Baowen Zheng     2021-12-03 @946  	tcf_pernet_del_id_list(*ops->id);
                                                                               ^^^^^^^^
This line dereferences it without checking.

d99abedd4989e7 Baowen Zheng     2021-12-03  947  err_id:
d99abedd4989e7 Baowen Zheng     2021-12-03  948  	unregister_pernet_subsys(ops);
d99abedd4989e7 Baowen Zheng     2021-12-03  949  	return ret;
^1da177e4c3f41 Linus Torvalds   2005-04-16  950  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

