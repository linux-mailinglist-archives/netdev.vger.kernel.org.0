Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDA65B6AAD
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 11:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiIMJ2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 05:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiIMJ2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 05:28:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8D95E315;
        Tue, 13 Sep 2022 02:28:03 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28D9DbMS023761;
        Tue, 13 Sep 2022 09:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2022-7-12; bh=FU/aVloShAvb2bhoElyeq1wmik48Jm10NgPKeIpVQGM=;
 b=eQtxtDRLOnbflrMUL4q7t7yPpN9ILQd1+A/1DCQO78svW8mTxh90Bi8lLSKhZS2hHMcZ
 hFYqMLRm66m54CYrJ41Hn60EtA9mSsfDlUlhHqpIYB8hKHDVNymhzOp7Z1SVjGSwas6h
 ZpHdO0dYwWo+s4M9RY2+V7smXgQRoBCLgdffgr3mRDjnjaIRnWGiGxh9kpvZiYrhnmug
 AGt6VIUKZF4RtEjOM4IuRz2DSOJ/54SvyjYzn6RCvu94d4OvaxRUBQlWKe9GhcEmsoyj
 OxW0+EuDfV7UzPUZtvkXU9KAT9JzeKcNZxybfyNn5WCrW4gDgLnD9BX7ERTfgTiggecs SA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jj5w2ahhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 09:27:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28D8TVqe020555;
        Tue, 13 Sep 2022 09:27:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jj6b2d662-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 09:27:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIOxy9AFwEX2kOCM5636qp7ampI6pQmRVzrarLltgoz5AErkulmHliNbsux+NXyVoTZHjy88XxDIJGD58IQGvjs8QubsJiv+haqHkHl8ud5SRVxBI8jwkffsdjlHp7yvKRbbkLUU4TThr20QQsicX/dqj3DU3Kle5k+oIBOGIisAR91zhn1WA6du+2CSqKxkMG/2v0ocqTKk9EB+DtRzL+aMLGZBagRJkNMoauVesUjdk1seToUX6sG4P7Tv6ACZm8PlOnZVpBtA9KGnnmFV/gZtKyfxbVQlSn6/b2MdTbk4kLgA4ty4pJQQmIaTI1LT/2wIIJ/JW16UD+BmOKo9/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FU/aVloShAvb2bhoElyeq1wmik48Jm10NgPKeIpVQGM=;
 b=fz49YR4LFUm7SRXqr2igODS2GOdawa+5YUL1bijKuzN0eonyog8sP2tpHv8yBdx20Wrt3kujI3xlOcvf4k2XbdVmJifTkfPD7IrJ0MaQKIGOutdsCPPxL0avkOMUH2Z57ryhc4pLfNbrK4KrYczBbBzm2wk2rqyvZnZAGtyF/k1MbQBITxF1iT27Sj/mw5m3LS09nJQ/1H5NzS4N/zs7Z4spJIwsviivkSs6OqXMC6NuP9+qjxJfZrrK32UV4jjLznIMd7S5Ec9U+JObqqDh9dw2Lj0MFolPvSatSgD9gP0BaHM4LoFEgq4C3a6E5ywyBPZrZUsL24Ao4hwb19Wp6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FU/aVloShAvb2bhoElyeq1wmik48Jm10NgPKeIpVQGM=;
 b=FhlQ2fYzwd+WOBY123DP6g8DzTcnK0A3cTN3R6FvX5b8ilt0VxQBABLzd0t/Kc7T1aW1O+XyXDLFfLrgYY4/YKDE0I6fnWR3sb5yx+5BmvrbVL8XldgvdSii4ARdmYf7Ye1ZbqbiMMe+ZLukZ9zjGv8Hz2/aSeDKMfRpBk1+2M4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB4129.namprd10.prod.outlook.com
 (2603:10b6:a03:210::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 09:27:40 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 09:27:40 +0000
Date:   Tue, 13 Sep 2022 12:27:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [PATCH net-next v5 8/9] net: marvell: prestera: Add neighbour
 cache accounting
Message-ID: <202209111637.zSGjIXwb-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908225211.31482-9-yevhen.orlov@plvision.eu>
X-ClientProxiedBy: JNAP275CA0041.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|BY5PR10MB4129:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d4c83c9-1ebd-4b2e-03d8-08da956a345d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uDP4brWoZ/BNyCKkcZZagVaJ68dWzgH8JZlT9Z5XmP398Xq9JimupX5Wt55178McoOcpAqemeaJVgyk519x3wcMlvWOQCZ8q5uOHy5ClpT+3rMrClVMtFhlJU+TRUEM37C/ntqCJjgYLdLFQtO+2Ptj7ikc28/dCbEiqZNgFeannHkIl7NWE0ZnEf5rWfQgcDdtIGdkptytO0c21OXtN/VR9aawg5gYObkJKElyfz1vBlpvBjqLlOdd1RCooAzIWTvWk2cHPU7Pu82RnrGgwOuaFjzsj0r5+gzLQY9MWQl0a4vxO5OaR++se/qd74XN3Qjdqm127nRb4GAEdVWo0877NynklR6oVDRbftJUdK0fHWal2Z01LsS6BJe1nVBmUeuaUvO7Z7sUTcoIFQd0b72zxPYUmZttFJuRSn1DiKiY+GNYSZAPVNvnvkb4kLFpd4TlRCQRJQYRhxm1jo9o5T9c+i9YHCJob3SHPwBUtuaj0tE3BspFKK0Gdm6xFSRBvyzYQoEdLz8humLAMB478bK88sA8jbE5NC1Mf4TfhmJbK/T20cgRziyFQAG9HsslVYoGgA7wmw6wApZEmt5UVrkVxGqM34EMj0rQjkDqpbdbm3lz+CZJhg2h9gegk1BGIZdzMgiyzkEX4OjumdiLmfFv+1czd2Ekyl07OjKdPRIizBFdUvkbjwY5FqmolieKnXrxeP3Q0urR6TBEXTeEVENRbqm0WMfYzmv8gBF38ptBPKblpLAAsS4+8DgeXqmH20q+6Q6bdXXDtJoGAgXWiTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(44832011)(6512007)(6666004)(6506007)(4326008)(8676002)(1076003)(316002)(86362001)(83380400001)(8936002)(9686003)(26005)(66556008)(54906003)(6486002)(966005)(7416002)(2906002)(5660300002)(66476007)(41300700001)(478600001)(66574015)(36756003)(66946007)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7WM3/4IijlQeYjvKSaNLFBCxeMZ7PGtflscISfkfBGZRdkdShgxo31KaoohG?=
 =?us-ascii?Q?U3TsjKHqpfdmtwI7isX5dI8L0wOem44XvccPeXasWJUd0c0wMiFfhzKVopp+?=
 =?us-ascii?Q?brjFDoyIhypL13L1RYbm7WdQ47xROncj6kR7Dei0nVNM8qutvl+ixTEeEYAz?=
 =?us-ascii?Q?oqd23rq2MrHOh5QqAv3osowOHnS9+O8T6X0OrX1gYGLoDoZOCtK1AXDOFfBM?=
 =?us-ascii?Q?gA7o2z9IpRMH0foZ3eqfRbfXCY7cUnJCXc03c208H5pxfrrqVm+WR0BfaVst?=
 =?us-ascii?Q?Uj8YPmvENuDk4biYvgu6eES6WjrGtbsX9ahcVN5YcER5CxG7Me9qP5xemBoB?=
 =?us-ascii?Q?I7zeoAs9edgaaFAW/WoDcoXF+GZnB24hAb2urnJdvNe8deXxKuquip51L4LK?=
 =?us-ascii?Q?e6jiYUyUmWw2culdqOgzU+epDiuKAxbgDejWiH26EI3Zd6arqzAlpYp5L81F?=
 =?us-ascii?Q?qUg3wmzEdH4+f1xVIKejR9k8JPfzQs9/beuRGxcdv+F7kbsa5DUTkTw82E8j?=
 =?us-ascii?Q?2eCa0JTsAxx4MwxE/SUOMips3SfKHYro7oIYkzIF+CuLj4q+pf2hC7pJm1j5?=
 =?us-ascii?Q?U5L7ZKOopBgTeHiuZmT/2GvXseKH5QPRfZQFNGtR/BV1aHix9BPyKwtEdDik?=
 =?us-ascii?Q?FZjK1J9oHJ5VhR+bdNht2VowZ9Iek6LVbLi+Xw54xmIB1kM3kh4AH9V2mTcx?=
 =?us-ascii?Q?mDKuACn+RQBzJIORMSzJiXCDaVbMRxjmrDzTfjhmJd1V7Q6o5lY1W54qrg24?=
 =?us-ascii?Q?YWORBgUbiqyur05LbQCDOeSDElE2l6kM/lRMm5jtbgggVX8mQ2MzBrbpvNwW?=
 =?us-ascii?Q?ewYVcDbgBT8Bq0ipbfRr8eXSCW7do7ntlpZjgHj+F7feGgFnaPNd9Ydvw1Aq?=
 =?us-ascii?Q?WJLwrpdfA9BaAns4Z/zfjY1YfOUGNGIO9Au6FyW3BIWqKcuh68eqJbTa6bI1?=
 =?us-ascii?Q?f7Ia3bgKu4Dee0szpqfZ4uajePP+YixaIlbzGA03OS68whtPSifSILLqlDAV?=
 =?us-ascii?Q?01bZtXSnBc+Exz0Eq16TY2BTSN29kyNyjEnY/5sqpBDuHDNBC3BsYtIfMqwo?=
 =?us-ascii?Q?qqjZ87hHIw2Q4pfPBSTxjJ5bA/4wvnrEYlWb1lghd5XgGkRU2+pI+uFgEiDU?=
 =?us-ascii?Q?B9lqXMWBAakvbdp6uHybN4pRLgJIbHn1qI7MjqjbX9wOH+cbWc2ejuwuHqYr?=
 =?us-ascii?Q?mCbi10r/Fm9xHVWiKwUE6xPWfeHrAEa5I8ZyvQwrQbcyyHfj+1bRCJZidF/G?=
 =?us-ascii?Q?iCUmewaTpvqHq1ZVJcWgBE1xxcf4olHKQs9+lEj06N62Y93W123+GzKd2Sed?=
 =?us-ascii?Q?4Y07REMyVkBZZlYTJbu3biSFH/PrOL/IvDBnl2iI0+ipuDDBjpdDzBKLGSei?=
 =?us-ascii?Q?bIvz38CKc81rqJ2jccZesPK5G7By1QoTRfRSzogk3pWVyEAbKFiF6OD2srRS?=
 =?us-ascii?Q?GbNx/uKcH/r5uGY/z/tfgrC8BUIQWoQvaVLz94NkvQDtORajBdAzw4pu8gkF?=
 =?us-ascii?Q?0aYrq0a1hkDxuAOlSgvjZQn0IBCtlvhcATQhrdGPAlMpvWoZ7455bvZvAbsY?=
 =?us-ascii?Q?OR9H9n330OonBe+5m3pcwrxGYd4yz72YoogqC3gKsK9mHfAo+zrYe6/ZGjGx?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4c83c9-1ebd-4b2e-03d8-08da956a345d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 09:27:40.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AFO6u/NB5qhnsx6bJavoid+7oux9uKQDfwjB87K5SAvFtJ3bLuAVelku1xu24ywHRpwuuaYvQLFQjH/3UL/FqihUasBUiXiKTuT0YLxbziM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_03,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209130041
X-Proofpoint-GUID: bXvh0PFQBdotrNYznora7dulUOJWSCwU
X-Proofpoint-ORIG-GUID: bXvh0PFQBdotrNYznora7dulUOJWSCwU
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yevhen,

url:    https://github.com/intel-lab-lkp/linux/commits/Yevhen-Orlov/net-marvell-prestera-add-nexthop-routes-offloading/20220909-065815
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9f8f1933dce555d3c246f447f54fca8de8889da9
config: openrisc-randconfig-m041-20220907
compiler: or1k-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/net/ethernet/marvell/prestera/prestera_router.c:751 __prestera_k_arb_n_lpm_set() error: uninitialized symbol 'fib_node'.

vim +/fib_node +751 drivers/net/ethernet/marvell/prestera/prestera_router.c

5a826d874f2b0e Yevhen Orlov 2022-09-09  715  static void
5a826d874f2b0e Yevhen Orlov 2022-09-09  716  __prestera_k_arb_n_lpm_set(struct prestera_switch *sw,
5a826d874f2b0e Yevhen Orlov 2022-09-09  717  			   struct prestera_kern_neigh_cache *n_cache,
5a826d874f2b0e Yevhen Orlov 2022-09-09  718  			   bool enabled)
5a826d874f2b0e Yevhen Orlov 2022-09-09  719  {
5a826d874f2b0e Yevhen Orlov 2022-09-09  720  	struct prestera_nexthop_group_key nh_grp_key;
5a826d874f2b0e Yevhen Orlov 2022-09-09  721  	struct prestera_kern_fib_cache_key fc_key;
5a826d874f2b0e Yevhen Orlov 2022-09-09  722  	struct prestera_kern_fib_cache *fib_cache;
5a826d874f2b0e Yevhen Orlov 2022-09-09  723  	struct prestera_fib_node *fib_node;
5a826d874f2b0e Yevhen Orlov 2022-09-09  724  	struct prestera_fib_key fib_key;
5a826d874f2b0e Yevhen Orlov 2022-09-09  725  
5a826d874f2b0e Yevhen Orlov 2022-09-09  726  	/* Exception for fc with prefix 32: LPM entry is already used by fib */
5a826d874f2b0e Yevhen Orlov 2022-09-09  727  	memset(&fc_key, 0, sizeof(fc_key));
5a826d874f2b0e Yevhen Orlov 2022-09-09  728  	fc_key.addr = n_cache->key.addr;
5a826d874f2b0e Yevhen Orlov 2022-09-09  729  	fc_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
5a826d874f2b0e Yevhen Orlov 2022-09-09  730  	/* But better to use tb_id of route, which pointed to this neighbour. */
5a826d874f2b0e Yevhen Orlov 2022-09-09  731  	/* We take it from rif, because rif inconsistent.
5a826d874f2b0e Yevhen Orlov 2022-09-09  732  	 * Must be separated in_rif and out_rif.
5a826d874f2b0e Yevhen Orlov 2022-09-09  733  	 * Also note: for each fib pointed to this neigh should be separated
5a826d874f2b0e Yevhen Orlov 2022-09-09  734  	 *            neigh lpm entry (for each ingress vr)
5a826d874f2b0e Yevhen Orlov 2022-09-09  735  	 */
5a826d874f2b0e Yevhen Orlov 2022-09-09  736  	fc_key.kern_tb_id = l3mdev_fib_table(n_cache->key.dev);
5a826d874f2b0e Yevhen Orlov 2022-09-09  737  	fib_cache = prestera_kern_fib_cache_find(sw, &fc_key);
5a826d874f2b0e Yevhen Orlov 2022-09-09  738  	if (!fib_cache || !fib_cache->reachable) {
5a826d874f2b0e Yevhen Orlov 2022-09-09  739  		memset(&fib_key, 0, sizeof(fib_key));
5a826d874f2b0e Yevhen Orlov 2022-09-09  740  		fib_key.addr = n_cache->key.addr;
5a826d874f2b0e Yevhen Orlov 2022-09-09  741  		fib_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
5a826d874f2b0e Yevhen Orlov 2022-09-09  742  		fib_key.tb_id = prestera_fix_tb_id(fc_key.kern_tb_id);
5a826d874f2b0e Yevhen Orlov 2022-09-09  743  		fib_node = prestera_fib_node_find(sw, &fib_key);
5a826d874f2b0e Yevhen Orlov 2022-09-09  744  		if (!enabled && fib_node) {
5a826d874f2b0e Yevhen Orlov 2022-09-09  745  			if (prestera_fib_node_util_is_neighbour(fib_node))
5a826d874f2b0e Yevhen Orlov 2022-09-09  746  				prestera_fib_node_destroy(sw, fib_node);
5a826d874f2b0e Yevhen Orlov 2022-09-09  747  			return;
5a826d874f2b0e Yevhen Orlov 2022-09-09  748  		}
5a826d874f2b0e Yevhen Orlov 2022-09-09  749  	}

fib_node not initialized on else path.

5a826d874f2b0e Yevhen Orlov 2022-09-09  750  
5a826d874f2b0e Yevhen Orlov 2022-09-09 @751  	if (enabled && !fib_node) {
5a826d874f2b0e Yevhen Orlov 2022-09-09  752  		memset(&nh_grp_key, 0, sizeof(nh_grp_key));
5a826d874f2b0e Yevhen Orlov 2022-09-09  753  		prestera_util_nc_key2nh_key(&n_cache->key,
5a826d874f2b0e Yevhen Orlov 2022-09-09  754  					    &nh_grp_key.neigh[0]);
5a826d874f2b0e Yevhen Orlov 2022-09-09  755  		fib_node = prestera_fib_node_create(sw, &fib_key,
5a826d874f2b0e Yevhen Orlov 2022-09-09  756  						    PRESTERA_FIB_TYPE_UC_NH,
5a826d874f2b0e Yevhen Orlov 2022-09-09  757  						    &nh_grp_key);
5a826d874f2b0e Yevhen Orlov 2022-09-09  758  		if (!fib_node)
5a826d874f2b0e Yevhen Orlov 2022-09-09  759  			pr_err("%s failed ip=%pI4n", "prestera_fib_node_create",
5a826d874f2b0e Yevhen Orlov 2022-09-09  760  			       &fib_key.addr.u.ipv4);
5a826d874f2b0e Yevhen Orlov 2022-09-09  761  		return;
5a826d874f2b0e Yevhen Orlov 2022-09-09  762  	}
5a826d874f2b0e Yevhen Orlov 2022-09-09  763  }

