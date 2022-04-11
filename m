Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E714FB5F8
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343807AbiDKIau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343806AbiDKIas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:30:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45D63E5E4;
        Mon, 11 Apr 2022 01:28:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B7asUw012784;
        Mon, 11 Apr 2022 08:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=b09uokbSnBmxt2gZ3KuQbd5yLG0z/3+FuURihqaGjcc=;
 b=yzdhGv79CBFz+rPFuNCi//xOZJlNq1Suzv4qN/fcT/C0YXdxw+2Dya8u6a/zpHxwUO8v
 ejibWbMpO7TVUb8Ap582b9cl5SH3vJg96srS/B+SVP7B0K96bDjau9/re/cyd1WCiaSg
 4s0xxmX1+MAhl8CuFY6nf3d/oW7/kUmaJL7gOn0bvHG/K8/5qi4m8xOZ+O3R5mcVdKoE
 FrOer1m5BZXxgF4MoLyVIxrRPON95hz9YYqqJc87pOldtmQ7wB9KPmaoq/UejnclqRAj
 q4xCfOfy5kKpOQU3UwBoi57N5BaIaBaoJ+I4Vc7+v4hKiJ18TbNUJLkX2ShQtapSqQh4 Ag== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2pttv7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 08:28:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B8KxHb038126;
        Mon, 11 Apr 2022 08:26:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k1gu7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 08:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfXLpAgBww0Pr7fMYas0fCfEX6M8mwFJEGmHIwTXIK7G1Fc/2L128eyyILteqXOy3YgC1AEWJUe8COucrarbse8TssgiJol9noIwvbmtk2bUTtpS59iNCKVGvPTV9hSk1JavH3nGXrj/4HLwjVv/HvWKNGXBGcxQZKDjacaGmj3ZB4g6gRHbWAdFqxaseDjbeDZkhskot8QDsViUaed5jp6jeioV7W9XfHV+HcmIdOKGbui1WU7GjX86WMgIGx6NLcL2gcQ7U6YpoFLPQ1+C3ADSanhE19p9aKn+TrbCv6IqzAHTicGje3ov+Kom3c8QKdfHhjltwT6mPUCjGGbY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b09uokbSnBmxt2gZ3KuQbd5yLG0z/3+FuURihqaGjcc=;
 b=dPLezKTFvrC4AwPtuYZHGZ1x+VTKMQHg5juqm1OacPGoM/W2iicda4DbCfjfLuaZh+vFVg3VjvSxrCYwpINDfqM0+l8NY6ocFq+fb0uy/gA64E5Qa1wKv1zWzTaUCO2MtVEngNqCRssc8vg4gcDsf1PzGL6ag9ikStMVxYtghIbxLxSIZsc4Z94ijlCGyJngnSAdR2FJfFGZ8jA7IVeB/AdlvkRPrbFclJGYm49RWYiYTFX7bwBRmMBH0vOZ/CUKq/u0J8E26QmKyKMtp6jYgy4oq2ateHXXtXLqc21B/3XtQvc6zvpKSqQaGmPLIAgvCKtL07sxCEBlggjMaDu46Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b09uokbSnBmxt2gZ3KuQbd5yLG0z/3+FuURihqaGjcc=;
 b=CAsgkSkF+iUmlVQA4Y9jQyoLw2EQZeXtrBu7d+dVkz8eqk1QYsT+qtxhhoJLxaF7Oh8aYKHxKVEnBp1SX1+nidyRZxU32tdyx5ZzYc7DePddrVwby4tJ7mTEiPerMIK97G6zuhkMMHuL4jZ0XXytEDiz2UM8nhuB9uofTdqln6o=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5704.namprd10.prod.outlook.com
 (2603:10b6:303:18e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Mon, 11 Apr
 2022 08:26:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5144.022; Mon, 11 Apr 2022
 08:26:47 +0000
Date:   Mon, 11 Apr 2022 11:26:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Stanislav Fomichev <sdf@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v3 2/7] bpf: per-cgroup lsm flavor
Message-ID: <202204090535.gy7lTeMG-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407223112.1204582-3-sdf@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0025.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::18)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8264f457-c5fb-45a2-6264-08da1b950463
X-MS-TrafficTypeDiagnostic: MW4PR10MB5704:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB57047DDEC2682EECCB86AD188EEA9@MW4PR10MB5704.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCDhkEpsDNXTCbkDJX66MqfjxcKgW6e0WOwEFYTqVCQSW+IwVmgOhjcogMazmKtx0ZezxtkKaGSGIoCEi5GzHT4QGYOD3CW73PRasdHFzZHHogTjG4K0FjYb7ofb0zaoW4p8zLHRUqLGcxCgXNyI3PQWiHtxT6H5YbcDHrB+Cggv36c+pfDIMvzca2ycyEPbYubnSN/ekG2k26uaneTvd1BeyJG23v7aYTsEPBgdUZzI/nhkUYssg9ViNfbKpeAFv8SBBFx3QYwn1fml3eUD8HSeiBRcXlZBKeyXlD7B6sfvSfKjWCLRsbkPFgm6EzsuATNv87nysxyDEkbY5GYi/KqcRp1wbaNra1bFF68Qkz5TvRyuuk1dpRaQYKstTPud9AfgaSQQk24GEIHQI0ySl/01cVzFDX7Q+N2ScYqu192x+pBDiy/s6ZTjg/iYUnpsnKA99SixRuI1anaY6mx9Nw5KYPbLDPmP+Whb9kYlfSrwLHOF/aDXhQHRKSDPTPFut4BG/wVaIETbNK/dQrTNkvyj84fP3Fc2Kg4eMdKRUR4VN3tWk6+4A14tcvvTBeDVGTMeTv/FRGyn6Tyg4YLos4gd4tR7g7fZxjyOwdOQGRHrvpovEIaBXaWRYIrPfXriasJFwaf7Ua+9uZBUJDQQ7KDeu8fLGpjck9ywAfnIdqQdECgTO7TJUuReJ+M44JpQtp/3E6lQnQJ+uc94cJwpRcbjB6JAYK48owstO9ZMHMFp+6pJtVz2AE5aSaIzL7F7+9ndL9UDbp09N6KMCcruEKAmJwkCLuKQ6CeDHUmXpxoTaFJkFbFZ0AA7vQW5FvmALsg4UDnisqMj32P09IfFvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(52116002)(9686003)(6512007)(66556008)(83380400001)(508600001)(26005)(186003)(1076003)(38350700002)(44832011)(6666004)(5660300002)(86362001)(6506007)(4001150100001)(2906002)(36756003)(316002)(966005)(8676002)(6486002)(66946007)(4326008)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5UxNFtlmxRqg0sc8yTQw0fa6Br/z9pHH5t5vpLk/Kcn31gd7QrwLpuxobgCa?=
 =?us-ascii?Q?AcXGDzaEeNLK+P8+PwALF6i+fcaEztaO4sRJwzI8DOY3CluDY3TqrjlK7DVR?=
 =?us-ascii?Q?3+EA9wx4P5bnMSLLrZWRlDG4UHIP/HW82k3apWoBwQ+g17Zm/bTtSIoKYFEz?=
 =?us-ascii?Q?vSyhDZNYVn8piDGtEhUpU+OjA7TcrY7iierHUApTC/nB0x8U+IkEbeaOcsM5?=
 =?us-ascii?Q?zvJ0FGqZffGjzZB5mADyWetKXVd0Ph9HS0YCj/ds/vk7UF36Zom9/PJRHhOp?=
 =?us-ascii?Q?IagZ8bAqReFbH9bhHt8oQNewPT/bL8bU7rCcoB/LB+C/3j6fzvIs5QG3lL/U?=
 =?us-ascii?Q?1dr0L8BHYHkktEbkN6JUINPUxbylePdiN/PlgLD6QKFTp5i7sSwRl8zFzzic?=
 =?us-ascii?Q?tUpVCLrzrQphQrGnVZtEOXELlSlXquhQugUf3JhK2FbiAsMOIGPFgQsDefwl?=
 =?us-ascii?Q?FqnDGkphMSIUZXZcIIPiOgp/aBX+px/Bu8ha7/Hn2jHNIH0z+M5/4RXy0JK/?=
 =?us-ascii?Q?leZasr6Q9Ru5MII0nJy2Ejh2J2KUZw+0bdOY88v7LxVZSHBVdN+M7XrxQ8hW?=
 =?us-ascii?Q?SBvT4TJNmSht1KtbYvfEp29xlBeDKIOXInDwjZtJBPwxzPzfqwulCglHrjna?=
 =?us-ascii?Q?SERmAxeQ+s6VxjEEA0iy8348RoLal+1GVeXBUtNDq7Ap2g5BxZhH3nccPDvx?=
 =?us-ascii?Q?ZWthV2vGggDFiXEBzTJDWutvxG3bnnUx4Jn0UvVE50daQ/y9nKIbEIa1nTJo?=
 =?us-ascii?Q?6I4tnLfJK8zLj2kBWOe2LXnvsSLOjrnqbJdNpCP6dTrhCERAFVi3t3o4LcOb?=
 =?us-ascii?Q?W3chOKR2mulTVZ4/3k7lyMwESD75lIvBiNtKjnAPuTFP0QaPDKyK7vGgu2Sz?=
 =?us-ascii?Q?z0rk34v1oCT0oT7/DZoaKdVsi4NxbbOtXGwBo1MsEMBjjpX8h3MVZzjdTYxg?=
 =?us-ascii?Q?5t5TNapHukVn1pbLEwtTL4zD+TIvQqo+/39gdlWzuFNBxhK1dOzDekrbAPAP?=
 =?us-ascii?Q?1xrb6DB64iuDrdTkNXAQkf+R4cuOl2LjuFCaWkHq9D9EoPxiCQ8yparbjxE5?=
 =?us-ascii?Q?80jAkyIg3/VJz8ENYV4Iou5TvCkukPEph7bY2EDhDJo03O3CdRdn/MTaVI/x?=
 =?us-ascii?Q?xW+QdXHmtdUGVWQ/O6AYA3mtLLq1jfkAejdSuc9iGmSgdCcPSgivNkef/JKL?=
 =?us-ascii?Q?Odr29zr28GBctDE4cN5CK0Ku2jKdNR3a342dHwzzhHkrW73uvbWDsYgXWjkA?=
 =?us-ascii?Q?olMQlNrvydXTnvX37h3dTLLC36KtVK8aeA3Hl8kWHWblUTZLgsoztB+lUkTb?=
 =?us-ascii?Q?2l4yMqwzSbaEo94odG6LDvaQiBoer2RnpvypANENy4GX951QS0wJiDOacQLI?=
 =?us-ascii?Q?5k5PWmDiYrDjLp3Mquq9hKQRBC8DjBslruL6/OquSLXDycFugaTuwIwA98NA?=
 =?us-ascii?Q?jp6H9+Z4B9MIjg4F3/Qi0zF+vpJxDgQPZBVciDjM/B07HX/ws1Tak9JY57Ac?=
 =?us-ascii?Q?5VnHvfom3M6Q4eolvXAwhEvLveifWYAQ4QeNDxKy6rd2wtWC0gSgP6q692em?=
 =?us-ascii?Q?93E8N1T1g1OZWgG2kOvtn5+D5QisXbbWBm8HmNlqI3GBocMfhHG7IIlLfM2t?=
 =?us-ascii?Q?y8qWza9k/iWKqtyyai8HGNuwRwQZr+8ZDtrebERVPLNro/FdPgd27R0SayEx?=
 =?us-ascii?Q?/t8pWk3Fa4YzCz+edZid1AeHMTHu5lm/5XcZTzvShqrshZ/o5oNSyabpOaw6?=
 =?us-ascii?Q?+1WIrSYq750n/cAwDCmUbhWYJqcX17U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8264f457-c5fb-45a2-6264-08da1b950463
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 08:26:46.7951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXmN4ZWqRmcfQzJRLkhCM696y2qrlU71Bki9+KUh6DQZ1lgcvCWEntPj0rZDfkZNzOsm7WcMXgFf2D+AJTtn76u7dhAcBfOHZdHhpkXQSAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5704
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_03:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110046
X-Proofpoint-ORIG-GUID: tO1yoZAHsJ3pCKah9vYXLldofl6MJ2jo
X-Proofpoint-GUID: tO1yoZAHsJ3pCKah9vYXLldofl6MJ2jo
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FAKE_REPLY_C,HEXHASH_WORD,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220408-063705
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: openrisc-randconfig-m031-20220408 (https://download.01.org/0day-ci/archive/20220409/202204090535.gy7lTeMG-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
kernel/bpf/cgroup.c:575 __cgroup_bpf_attach() warn: missing error code 'err'

vim +/err +575 kernel/bpf/cgroup.c

588e5d8766486e He Fengqing        2021-10-29  471  static int __cgroup_bpf_attach(struct cgroup *cgrp,
af6eea57437a83 Andrii Nakryiko    2020-03-29  472  			       struct bpf_prog *prog, struct bpf_prog *replace_prog,
af6eea57437a83 Andrii Nakryiko    2020-03-29  473  			       struct bpf_cgroup_link *link,
324bda9e6c5add Alexei Starovoitov 2017-10-02  474  			       enum bpf_attach_type type, u32 flags)
3007098494bec6 Daniel Mack        2016-11-23  475  {
7dd68b3279f179 Andrey Ignatov     2019-12-18  476  	u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
324bda9e6c5add Alexei Starovoitov 2017-10-02  477  	struct bpf_prog *old_prog = NULL;
62039c30c19dca Andrii Nakryiko    2020-03-09  478  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
7d9c3427894fe7 YiFei Zhu          2020-07-23  479  	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  480  	struct bpf_attach_target_info tgt_info = {};
6fc88c354f3af8 Dave Marchevsky    2021-08-19  481  	enum cgroup_bpf_attach_type atype;
af6eea57437a83 Andrii Nakryiko    2020-03-29  482  	struct bpf_prog_list *pl;
6fc88c354f3af8 Dave Marchevsky    2021-08-19  483  	struct list_head *progs;
324bda9e6c5add Alexei Starovoitov 2017-10-02  484  	int err;
324bda9e6c5add Alexei Starovoitov 2017-10-02  485  
7dd68b3279f179 Andrey Ignatov     2019-12-18  486  	if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
7dd68b3279f179 Andrey Ignatov     2019-12-18  487  	    ((flags & BPF_F_REPLACE) && !(flags & BPF_F_ALLOW_MULTI)))
324bda9e6c5add Alexei Starovoitov 2017-10-02  488  		/* invalid combination */
324bda9e6c5add Alexei Starovoitov 2017-10-02  489  		return -EINVAL;
af6eea57437a83 Andrii Nakryiko    2020-03-29  490  	if (link && (prog || replace_prog))
af6eea57437a83 Andrii Nakryiko    2020-03-29  491  		/* only either link or prog/replace_prog can be specified */
af6eea57437a83 Andrii Nakryiko    2020-03-29  492  		return -EINVAL;
af6eea57437a83 Andrii Nakryiko    2020-03-29  493  	if (!!replace_prog != !!(flags & BPF_F_REPLACE))
af6eea57437a83 Andrii Nakryiko    2020-03-29  494  		/* replace_prog implies BPF_F_REPLACE, and vice versa */
af6eea57437a83 Andrii Nakryiko    2020-03-29  495  		return -EINVAL;
324bda9e6c5add Alexei Starovoitov 2017-10-02  496  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  497  	if (type == BPF_LSM_CGROUP) {
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  498  		struct bpf_prog *p = prog ? : link->link.prog;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  499  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  500  		if (replace_prog) {
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  501  			/* Reusing shim from the original program.
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  502  			 */
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  503  			atype = replace_prog->aux->cgroup_atype;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  504  		} else {
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  505  			err = bpf_check_attach_target(NULL, p, NULL,
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  506  						      p->aux->attach_btf_id,
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  507  						      &tgt_info);
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  508  			if (err)
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  509  				return -EINVAL;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  510  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  511  			atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  512  			if (atype < 0)
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  513  				return atype;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  514  		}
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  515  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  516  		p->aux->cgroup_atype = atype;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  517  	} else {
6fc88c354f3af8 Dave Marchevsky    2021-08-19  518  		atype = to_cgroup_bpf_attach_type(type);
6fc88c354f3af8 Dave Marchevsky    2021-08-19  519  		if (atype < 0)
6fc88c354f3af8 Dave Marchevsky    2021-08-19  520  			return -EINVAL;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  521  	}
6fc88c354f3af8 Dave Marchevsky    2021-08-19  522  
6fc88c354f3af8 Dave Marchevsky    2021-08-19  523  	progs = &cgrp->bpf.progs[atype];
6fc88c354f3af8 Dave Marchevsky    2021-08-19  524  
6fc88c354f3af8 Dave Marchevsky    2021-08-19  525  	if (!hierarchy_allows_attach(cgrp, atype))
7f677633379b4a Alexei Starovoitov 2017-02-10  526  		return -EPERM;
7f677633379b4a Alexei Starovoitov 2017-02-10  527  
6fc88c354f3af8 Dave Marchevsky    2021-08-19  528  	if (!list_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
324bda9e6c5add Alexei Starovoitov 2017-10-02  529  		/* Disallow attaching non-overridable on top
324bda9e6c5add Alexei Starovoitov 2017-10-02  530  		 * of existing overridable in this cgroup.
324bda9e6c5add Alexei Starovoitov 2017-10-02  531  		 * Disallow attaching multi-prog if overridable or none
7f677633379b4a Alexei Starovoitov 2017-02-10  532  		 */
7f677633379b4a Alexei Starovoitov 2017-02-10  533  		return -EPERM;
7f677633379b4a Alexei Starovoitov 2017-02-10  534  
324bda9e6c5add Alexei Starovoitov 2017-10-02  535  	if (prog_list_length(progs) >= BPF_CGROUP_MAX_PROGS)
324bda9e6c5add Alexei Starovoitov 2017-10-02  536  		return -E2BIG;
324bda9e6c5add Alexei Starovoitov 2017-10-02  537  
af6eea57437a83 Andrii Nakryiko    2020-03-29  538  	pl = find_attach_entry(progs, prog, link, replace_prog,
af6eea57437a83 Andrii Nakryiko    2020-03-29  539  			       flags & BPF_F_ALLOW_MULTI);
af6eea57437a83 Andrii Nakryiko    2020-03-29  540  	if (IS_ERR(pl))
af6eea57437a83 Andrii Nakryiko    2020-03-29  541  		return PTR_ERR(pl);
324bda9e6c5add Alexei Starovoitov 2017-10-02  542  
7d9c3427894fe7 YiFei Zhu          2020-07-23  543  	if (bpf_cgroup_storages_alloc(storage, new_storage, type,
7d9c3427894fe7 YiFei Zhu          2020-07-23  544  				      prog ? : link->link.prog, cgrp))
324bda9e6c5add Alexei Starovoitov 2017-10-02  545  		return -ENOMEM;
d7bf2c10af0531 Roman Gushchin     2018-08-02  546  
af6eea57437a83 Andrii Nakryiko    2020-03-29  547  	if (pl) {
1020c1f24a946e Andrey Ignatov     2019-12-18  548  		old_prog = pl->prog;
324bda9e6c5add Alexei Starovoitov 2017-10-02  549  	} else {
324bda9e6c5add Alexei Starovoitov 2017-10-02  550  		pl = kmalloc(sizeof(*pl), GFP_KERNEL);
d7bf2c10af0531 Roman Gushchin     2018-08-02  551  		if (!pl) {
7d9c3427894fe7 YiFei Zhu          2020-07-23  552  			bpf_cgroup_storages_free(new_storage);
324bda9e6c5add Alexei Starovoitov 2017-10-02  553  			return -ENOMEM;
d7bf2c10af0531 Roman Gushchin     2018-08-02  554  		}
324bda9e6c5add Alexei Starovoitov 2017-10-02  555  		list_add_tail(&pl->node, progs);
324bda9e6c5add Alexei Starovoitov 2017-10-02  556  	}
1020c1f24a946e Andrey Ignatov     2019-12-18  557  
324bda9e6c5add Alexei Starovoitov 2017-10-02  558  	pl->prog = prog;
af6eea57437a83 Andrii Nakryiko    2020-03-29  559  	pl->link = link;
00c4eddf7ee5cb Andrii Nakryiko    2020-03-24  560  	bpf_cgroup_storages_assign(pl->storage, storage);
6fc88c354f3af8 Dave Marchevsky    2021-08-19  561  	cgrp->bpf.flags[atype] = saved_flags;
324bda9e6c5add Alexei Starovoitov 2017-10-02  562  
6fc88c354f3af8 Dave Marchevsky    2021-08-19  563  	err = update_effective_progs(cgrp, atype);
324bda9e6c5add Alexei Starovoitov 2017-10-02  564  	if (err)
324bda9e6c5add Alexei Starovoitov 2017-10-02  565  		goto cleanup;
324bda9e6c5add Alexei Starovoitov 2017-10-02  566  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  567  	bpf_cgroup_storages_link(new_storage, cgrp, type);
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  568  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  569  	if (type == BPF_LSM_CGROUP && !old_prog) {
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  570  		struct bpf_prog *p = prog ? : link->link.prog;
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  571  		int err;

This "err" shadows an earlier declaration

3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  572  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  573  		err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  574  		if (err)
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07 @575  			goto cleanup_trampoline;

and leads to a missing error code bug.

3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  576  	}
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  577  
af6eea57437a83 Andrii Nakryiko    2020-03-29  578  	if (old_prog)
324bda9e6c5add Alexei Starovoitov 2017-10-02  579  		bpf_prog_put(old_prog);
af6eea57437a83 Andrii Nakryiko    2020-03-29  580  	else
6fc88c354f3af8 Dave Marchevsky    2021-08-19  581  		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  582  
324bda9e6c5add Alexei Starovoitov 2017-10-02  583  	return 0;
324bda9e6c5add Alexei Starovoitov 2017-10-02  584  
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  585  cleanup_trampoline:
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  586  	bpf_cgroup_storages_unlink(new_storage);
3c3f15b5422ca6 Stanislav Fomichev 2022-04-07  587  
324bda9e6c5add Alexei Starovoitov 2017-10-02  588  cleanup:
af6eea57437a83 Andrii Nakryiko    2020-03-29  589  	if (old_prog) {
324bda9e6c5add Alexei Starovoitov 2017-10-02  590  		pl->prog = old_prog;
af6eea57437a83 Andrii Nakryiko    2020-03-29  591  		pl->link = NULL;
8bad74f9840f87 Roman Gushchin     2018-09-28  592  	}
7d9c3427894fe7 YiFei Zhu          2020-07-23  593  	bpf_cgroup_storages_free(new_storage);
af6eea57437a83 Andrii Nakryiko    2020-03-29  594  	if (!old_prog) {
324bda9e6c5add Alexei Starovoitov 2017-10-02  595  		list_del(&pl->node);
324bda9e6c5add Alexei Starovoitov 2017-10-02  596  		kfree(pl);
324bda9e6c5add Alexei Starovoitov 2017-10-02  597  	}
324bda9e6c5add Alexei Starovoitov 2017-10-02  598  	return err;
324bda9e6c5add Alexei Starovoitov 2017-10-02  599  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

