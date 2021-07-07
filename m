Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952C53BE388
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 09:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhGGHaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 03:30:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35394 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230327AbhGGH36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 03:29:58 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1677MSJ4004811;
        Wed, 7 Jul 2021 07:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=/6jmmIyR5Cfs+FRGnafueR8vJJJTgPHYCb1Jdx+g7ks=;
 b=SedGYvcwQxuJfI/XAJm30vPfxChWM1fqKJ3VM4BudZ6VuCzr5HdLrIES/xDIST+RGbtb
 4LBvggxJaNLopb+/55JZLz+vdYk41nzhG88hu3/qsIEuHcm8xUuMRh9//Y4PwmponoWw
 6u1QrlTsAHp9AwItNR87950LmrXu/mRjkphBwjH02gv/X97CdatutBmIdrlmAQSRro25
 QvT7nKXBLEXAtRgJ+l7v5jaBxhAunVbyqfluoB8JRxWv5zVKDK4+alFRIm2ThAzHImLk
 b3ci3u3Zx9mLrjga9aWZorC7TBPTxu/3E8UT3KehccJrzpfxVi0Yto8NmMToUVt3Dz/9 ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39kw5k48n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 07:26:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1677Q6a8089597;
        Wed, 7 Jul 2021 07:26:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 39jd12v4xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 07:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBNXppuNsBWQx3FMVoS72bzyf7gLezgn56NNBbte2JcZvVnMLsGubx+xUIVu1KXAxXNW/7IC4jX8n1LGNV8ZJWQBlT+zgR70nmhuG+69cvpfZORMo0KHdhvEvAoISkaOYXt19DLT+URYB2NXuttmKU/xjaYphJr1/s4oTwpCO0TJzdM91gEZQEGlfI29LtFElW0NF2+I5KKdBWmwY30V/zgJrYrms4BwsUln8BqwfkFAwIJXICKQ0vxgJeXxuqQqH/E7mIK5C9OwR3DTT3EWvAuD0tOA5zS4j6D+sdOnzyVzxicT0s09HNJUVb8nidpH/NCs/kQHU6/ajGtg8X9+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6jmmIyR5Cfs+FRGnafueR8vJJJTgPHYCb1Jdx+g7ks=;
 b=LOhIxdN397/VKjEHoHFG5BeJzmz80Vc3L75qWcNPo/vavvpCTJAf2qlpFTJ7CZkjZ6r7HCu5eZ8CvIdeBF8pVGMWu4xnxObEL4Rl4NcsQ9kV9ap6OBi0qeSYfXzTgE42Sxz58ZHJm1tyxXUUIaDw00AOwrJjiQ1URAinnytXd+Y+WEl8UD6b2ttr5lPYx2cP/OP7g/i6c8Ss/V5FJb9dYpieLqjIGWy/cX7CuHA4yREPsJkB7zKsgFY/5ekS9IdE15SvlDVKi2LCRPOdPogNa91XI0jHotsV88pA5zKMVt3eF8ncAhLl+5OKzCh0J66+zCvs3ZFjrEJHoakBxQJ5VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6jmmIyR5Cfs+FRGnafueR8vJJJTgPHYCb1Jdx+g7ks=;
 b=T1EVry6U1YIQjO7S3H4pWU+Ib1aUSI+LBr1sq15E4XkEAulqPuQun8t9IZrBANZq1FxHzNbpHp3z/zNzh5kjzSzFevVk9oI1+4G9Mba661SVDSetwR9f6cMfZVmEB0FNMK76crqIs9yK9npQ0tz28z2QQPilBKZcHySGLJMym98=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4466.namprd10.prod.outlook.com
 (2603:10b6:303:9b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Wed, 7 Jul
 2021 07:26:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 07:26:49 +0000
Date:   Wed, 7 Jul 2021 10:26:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org,
        Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>,
        dsahern@kernel.org, nikolay@nvidia.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linus.luessing@c0d3.blue,
        Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Subject: [kbuild] Re: [PATCH] net: Allow any address multicast join for IP
 sockets
Message-ID: <202107070208.yXD584kP-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706011548.2201-2-callum.sinclair@alliedtelesis.co.nz>
Message-ID-Hash: 4WP6TBKLK3TRXLK5CYY6B7WK3WKDC45P
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0173.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by MR2P264CA0173.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Wed, 7 Jul 2021 07:26:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecbc477f-ba05-4cd4-7514-08d9411894fa
X-MS-TrafficTypeDiagnostic: CO1PR10MB4466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4466C66AA4E95B2A96F9F7CE8E1A9@CO1PR10MB4466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXmF9HtrhFwFuxJYrEqxjxWHoaX8wW7B57v7JeFfkfT2FAD5vMO3IRImhGEhjEyBtW/PuTwEoxSnpruYiBL9BLKEQnE7MdmvLyqridQPEFcBx8sBCM5ElvOb/BzPO8mYrvSguh2GOjElBtv4Fg5jMxVgtsu6Ob5YN44ktY611vgmD1grbPfHXIWnGSp7jEPUj6rYts0m7HcBTtkFpj0m3UVhdkQBgxtAdjUeefRyXAZCU2D7Liw0H6xY1A7IfhflI8gFLJHYwS6Ut4cOYt0IZQxB1RycI4oE6lCIDhBsWWZvRmddvTTWAioxNAR02dw/9kjaCRFGcJnTZe6oHw09ItBjIvqLPJjngPUIrd62JVu7McGYesytITrioy5wh5yj7yqzEfnrv4CJpHcZubSRNm0Kk3Y7DghbDU4Bnrx5buVsUjwshiTNX+kRbsdG8c+6wQYdvJHQj9+LL+QaBvHqxKSCYLSZ8Z43C1dk1z5aASGclC/eeuWP1fV1eFzeGIiZ/okkgYoTvaITmaGut73RdL7qSdRoq4tmQuxXlr7XO0Bf6dI3ZMd3xN92Awy3WnIkFuYD3Y+esS4dCxOM9uUHjyKM/jpVCtrGn3D92RVTGQVZr2DF8Jal6WnTtWZWMJWvcFiG5PlUPr7AiEaiFlieotv45q5+1uiczLJYgE+PtpF860u1HVsqIlGtbIWM3sFHSXHPITrpXJ2BPc7uLDaQEVngB7ZOR7RJyjfQsS80c+QXZEUmAog7xk9lkO0GH2p4CVItDeLBe8fkpBNjwLGmddfbxyBBGc94nokwzCPVCznfYpxC41Zr64BpopArWjy5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(478600001)(956004)(44832011)(26005)(1076003)(186003)(9686003)(83380400001)(8676002)(6666004)(966005)(8936002)(38100700002)(38350700002)(5660300002)(316002)(6496006)(66946007)(66476007)(66556008)(36756003)(6486002)(86362001)(52116002)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DTrMmJlxlg1GwUObrjT8KCA7LX8emyEJDEApn1AmSWAgnChE1yq5mEj9PeRZ?=
 =?us-ascii?Q?p2v4rIG4t05Vmpz+YwS8IUqHBSCdQrZFxSSos5ICgJmSZACJ/pIEct6aykKx?=
 =?us-ascii?Q?b82XwR5Zhcx6WjMAz44KtdrPFzeTMtNbHgkaYpivDFBNRK2xHBg23e66FwT8?=
 =?us-ascii?Q?rUdWl79sZyD/SMoUoF0d/NFhVNrx2mM9ZRE7VotjzywBRBmy4fy55BpYsz7Q?=
 =?us-ascii?Q?3GZUoMjzgyprYcIL48ngY8uEFaJVLUkYQLTQBjQThAqpa9m/h3DjZIygHHi1?=
 =?us-ascii?Q?1GWWLF5OUykGkN2DVU48fuszjXOeCf4zlLjoKmHNoCAZ297OI9pnp6PSBQH4?=
 =?us-ascii?Q?l02QzBhuD0o9L5137s4vttVoqkeDgX5M1bCrf4l1kFMgEUEsu+9TI7UTLAgS?=
 =?us-ascii?Q?qGJtG3Dskz0ZcoPzDnZWbKbCyyTbWEwtc8nNFvgYSmmi81hqZ1+l7FQuiO0l?=
 =?us-ascii?Q?mmvvP2vnPpgbzC5/zj7vCEdG/pOaoxfgb81QzbrQeRc3GHqzQR8BP5lFKQIF?=
 =?us-ascii?Q?HdeDabhYZQ2bdRlRWk3mDCYAwfmJKRkHcMNnR+sEQSt24SstEHzx8FM4MXXT?=
 =?us-ascii?Q?jaXMaAe3XNeu+O1N5zTxS9Ycdw41WKVxqDGAVtRwlVg2xxxxpKZtGqwLod1l?=
 =?us-ascii?Q?MXZ23ZLB32G4gKx2QCvcJel/eDeIIwK2dDtd60IY7FT6bIJPpDU47GRMkANd?=
 =?us-ascii?Q?LcSDV7XjLLn2RTR1QjVOQPI2IUjYV4c7FDOrwzkwDXfCEtn4mB3Gbbs5d2gj?=
 =?us-ascii?Q?NRW/S934h9hSmm1AAV4Kr8VeEqjKcFrVH3WPyKMoc2mxriclfbLBLazL7t6i?=
 =?us-ascii?Q?SOANp5j1RwxxYMH7RefVLc3mY+J2FB7d43YUShWz3hza5QvMNn3FScBKu5Xo?=
 =?us-ascii?Q?rhemL0tCPuaKyW3w9jEmbLq3g0XUufHszBeMD04q+u5wqGvIJlS2pqn5+31C?=
 =?us-ascii?Q?U6gd/8oohX1Ksmx0FfgW7hjZiP44U4RaZ2r6RWrvd3LjcM2B0o3bcwnp7c4b?=
 =?us-ascii?Q?FW9Qimk2HsYD4Z7HTvLnIaiZJ/3UmYAmPq4GiwoWqg55E/l+LzdFwt+f1Vhe?=
 =?us-ascii?Q?XBVF4JIDRGatXyCQY65W50A89L+UWaBtyikz2Uy6sg2nFLX1jop0nA7KLC5M?=
 =?us-ascii?Q?kIWyeS9/JBIullSGRaRRkOJl9Q7MhobwrMZ3szJsmn0LgQZKr9i3CgAoKbn6?=
 =?us-ascii?Q?dKARaEW4tY0gggvbqNx436PfRxuPoVEKVebXQpz7ASonELHLWV3TY9LG68Ro?=
 =?us-ascii?Q?/FCHGrDXRuPo2uaiCwGn1DePgtT/ooE/+R1xhVoxXqNtAk2QP9vk4yla9tvY?=
 =?us-ascii?Q?jhG3RdcNB9DgepxGXwhf6L/F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbc477f-ba05-4cd4-7514-08d9411894fa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 07:26:48.9145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwGbZjlKigZeVI6aW+yXVDiof5Z1TyTU1gPrPnvVl9Q0OOootP8y4lSfKB9M/P29MiTtQfRxl6gzMvEwGnUaY4VpZmNgYoDaPfJ1uJqvj7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070042
X-Proofpoint-GUID: paaS6AugzUnnI42WnRqQecLl3YChi6Dw
X-Proofpoint-ORIG-GUID: paaS6AugzUnnI42WnRqQecLl3YChi6Dw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Callum,

url:    https://github.com/0day-ci/linux/commits/Callum-Sinclair/net-Allow-any-address-multicast-join-for-IP-sockets/20210706-091734 
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git  79160a603bdb51916226caf4a6616cc4e1c58a58
compiler: m68k-linux-gcc (GCC) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

cppcheck possible warnings: (new ones prefixed by >>, may not real problems)

>> net/ipv4/igmp.c:1432:9: warning: Uninitialized variable: im [uninitvar]
    return im;
           ^

vim +1432 net/ipv4/igmp.c

b05967ad8bde7d Callum Sinclair 2021-07-06  1416  static struct ip_mc_list *ip_mc_hash_lookup(struct ip_mc_list __rcu **mc_hash,
b05967ad8bde7d Callum Sinclair 2021-07-06  1417  					    __be32 mc_addr)
b05967ad8bde7d Callum Sinclair 2021-07-06  1418  {
b05967ad8bde7d Callum Sinclair 2021-07-06  1419  	struct ip_mc_list *im;
b05967ad8bde7d Callum Sinclair 2021-07-06  1420  	u32 hash;
b05967ad8bde7d Callum Sinclair 2021-07-06  1421  
b05967ad8bde7d Callum Sinclair 2021-07-06  1422  	if (mc_hash) {
b05967ad8bde7d Callum Sinclair 2021-07-06  1423  		hash = hash_32((__force u32)mc_addr, MC_HASH_SZ_LOG);
b05967ad8bde7d Callum Sinclair 2021-07-06  1424  		for (im = rcu_dereference(mc_hash[hash]);
b05967ad8bde7d Callum Sinclair 2021-07-06  1425  		     im != NULL;
b05967ad8bde7d Callum Sinclair 2021-07-06  1426  		     im = rcu_dereference(im->next_hash)) {
b05967ad8bde7d Callum Sinclair 2021-07-06  1427  			if (im->multiaddr == mc_addr)
b05967ad8bde7d Callum Sinclair 2021-07-06  1428  				break;
b05967ad8bde7d Callum Sinclair 2021-07-06  1429  			}
b05967ad8bde7d Callum Sinclair 2021-07-06  1430  	}

"im" not intialized on else path.

b05967ad8bde7d Callum Sinclair 2021-07-06  1431  
b05967ad8bde7d Callum Sinclair 2021-07-06 @1432  	return im;
b05967ad8bde7d Callum Sinclair 2021-07-06  1433  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org 
_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

