Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D23C3256C0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhBYTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:32:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234840AbhBYTaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 14:30:15 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PJPkwo016281;
        Thu, 25 Feb 2021 11:29:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9mHCP4w9MolImRyPkB5fkaDnMsckKc2b7gc7l6Vtr6s=;
 b=c52CNHutsslLXbbHFSaUWS0z9VrdYgAKO6vAQM2ajpARmB2e3oA2likqlVCuMGp3cYV0
 NZj7dsudGrZKTKN5zeJ+dwyiogZVwF3WpG7H+fKuwomokVeH9NCFeHOW8mi7X08PPgZ3
 IsuYOJy+JdsMxfS1pHGEcvracxWMGwuzJrE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36xd17j87s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Feb 2021 11:29:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Feb 2021 11:29:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcmDbap/gRjtxFRmS3PV2RyEsF3FGDxsnXlhHozstRBh1xQQKuF9s3wj5aXPL17jCDeYs6RxF1Um/4SWAAwQoQbXzdtcc6UsrPZ807Pjwptg1TBtGURQ7QJMj7ek4Bdno1n60JyBvROkhuYOlaQBdPhUTGl7yHwUwi6rYUIPUvJ7xoJOIxw2dbWlKs9z4aTJW6irysXL1ta2XIcfhXyX5Rl/+PZXWxxSHipHHI7JHrQuIQzCN27Q2LEVOk82u4ud70qlEBxXiR7UvhlOJLvGQXLWI1ewjVHtiHp37s1kBX6BM1nX9fvAWrN9FHrqCrzZ8UxZaryIWl6woyndMsgpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mHCP4w9MolImRyPkB5fkaDnMsckKc2b7gc7l6Vtr6s=;
 b=Yc/b32R0g+xTrp5KuqD103HZ1/rm9I5SWjJ3ErlnT0UmAc+P4nEH2cZTNCpV/TdGf70cl9IIWGY5mJ0M6I7ufNZ0YfHGjeAVjRvgTh5JsdDZXC90q61BX7f6y9VCM4+m+2fXoo8tgUq3MYwjctLWqOoDmZeiVI+OwfzsE71vW4dTpSulbkpRjjZ/2P1BZTcllv8lNHDZUuTx9yseBvDK9cTqAcVJqGv8XCNBOwrfl5gb0TVruzVphxny7YOJFtVyRHcEO6TnwkKS8L/cFrBqYBaMM/3w7GivO5wN/jX3wgUs+94m3ACdgCQ+BUM5N03s0Ik5fNm5PoAWOx6z1ibCQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 19:29:02 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 19:29:02 +0000
Date:   Thu, 25 Feb 2021 11:28:59 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, kernel test robot <lkp@intel.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH v5 bpf-next 1/6] bpf: enable task local storage for
 tracing programs
Message-ID: <20210225192859.pfvkox7dgz236b3w@kafai-mbp.dhcp.thefacebook.com>
References: <20210223222845.2866124-1-songliubraving@fb.com>
 <20210223222845.2866124-2-songliubraving@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223222845.2866124-2-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:e351]
X-ClientProxiedBy: SJ0PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::6) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e351) by SJ0PR03CA0121.namprd03.prod.outlook.com (2603:10b6:a03:33c::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 19:29:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d6e1724-cf15-43ef-1a1a-08d8d9c39b04
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2821023D7E9329AFF6AAEBE8D59E9@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDjN4T6KybW3mRLQIpC3apSUsLD6H6ix5CXdW3bO+UN0VJte6JthCI7FUdFisljvdMccYuXG4HdEEQ1z4pDDz34RtX4GewZpqCPYfWTFY6y4hlkrL2r25LzfJDGm86iK5sexUeRWsm2jkT/BhLd7MBulRHPcS0oAuvJyI2SakDe/0MO8E37MPJoHsNhfshKP8rP5yM4W4nVV8Fu9HgCyh5hvJw0qKF+7xeOUuTuliQqg5s0qjhb9n8DYHyNkj4Jz87ShNXpelK3AAvQ8bJGea406LEDcpjGJmuGzjcWDMD7bwNCw4nbBbMvyWP99R0Zy8lPutl9wqgQTlnP7PrdZiVI4v9raVH1483X6zFzwgBIQgFCiNxerJyHaK9OVX4oXu8RdmlVMC1uhJRee2GvoejgVnyXpf85GHyIDO87GtJd7SNWgHlnCx41+37TywM5Wj9ZVsYGEGapmZjFGRxGPoioKtBFRIbvNGTM2j3KgEieSfycGGarqhw26hrR44nrXg9HuXTbtlAEMkTs5NVk1Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(396003)(366004)(316002)(5660300002)(1076003)(186003)(52116002)(16526019)(54906003)(7696005)(6636002)(9686003)(66476007)(6862004)(4326008)(66556008)(66946007)(478600001)(55016002)(8936002)(8676002)(2906002)(86362001)(83380400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IBGWfyvuWY2pOtwPjxC/0rEogdW2rbi3LAG4LaP0vurjhn7N11N09xPJPO/k?=
 =?us-ascii?Q?rFStJA2XGaHjTDAqT0ux3RxzNiG0r4EDURv1VOwgRtVFba4hrfa7PSm/747q?=
 =?us-ascii?Q?y0a3OI/teZ/vlDTcAKs+IS2hZ7c6O79rkCGtlpZTAIYV4rtU+R/MzphVKv4b?=
 =?us-ascii?Q?fWMPo3pHDoWH1p+stp+8Yjsx04gf2UYfV/uHKDd+tYdIEyQh1IRk9Ogr9BIy?=
 =?us-ascii?Q?e8WBBYMCYS80l3lWgHfXL1gS08+Bc+Qamuu0WI+RBeWzMdXZJzxmLekHIoGg?=
 =?us-ascii?Q?5Y29rDa+cdGBWfCWjBoam+QClSUrre8V9DmY5FECBoCPM4ZH/oik++147+OW?=
 =?us-ascii?Q?C8iCnZ0mxuFa8dBvH9ZPhXc+cS3C/33KaX+9+Ly4iC8cMcmT1XfKkAmodwvb?=
 =?us-ascii?Q?AI9Cwm0qCvYppIgszW1XZ6JDwU+ak1dL32JYjDEVkCTUD+a2NxJHsMGX2cq2?=
 =?us-ascii?Q?zRWwlBkCBKOKokflfVa3Uvq+cBdh6BoXrEWLbuKGxJa+ODi6hksJi1QZDNye?=
 =?us-ascii?Q?KmhAfOpODptJ1AyglIhNer0Acfuu6nC2RT6gshr9jn12eCSxWHhvtt2mCiw8?=
 =?us-ascii?Q?RHVDnGoKm8o5dxMJIjzXM68+3jaBGuKxZPLFnnQyhxRkMafK9q9xzfoiqWOg?=
 =?us-ascii?Q?y6mtoneik69Tn/FKfPodHusRvhZcm/5JiyrRO9oNqFK3ymIOonch+cOPcG2B?=
 =?us-ascii?Q?uFXxBPdJKV0S4kHlxEUXqQSDazrmVC5oIx7kQ0gs9zruW6EA/pFeRh93+E8m?=
 =?us-ascii?Q?RBdIceRLmVjHG15mB0ivoEHs8vXY/wAjhbLaM7k5LMrf18mKW2+opBQC1fWW?=
 =?us-ascii?Q?DStZy8NEqWOX0UoZX7tewJP41aKKgb0Omx2p58b+NrdrzZtkH2ycL0iueACv?=
 =?us-ascii?Q?5CSAPFJRN4F/QN88xX0lX7yI8tIL/S/C0wmqJ0GrVsvY48VbwhXKmJ1I/gkq?=
 =?us-ascii?Q?pfXmK3vVfqbG7pOCRV1VZIJFzUqCgBr3+ENT/HPxSb4LJcu5xdS1d2fIWN8v?=
 =?us-ascii?Q?WQA4FTrpgRjejzOtpenZcNTN/YULECVf/xVNPqP3lTsqr1IQGSHzKu3Ug8dT?=
 =?us-ascii?Q?QkayuQu1rKY24KU9KFV3bParMXKp5/NCYzaN/PxBzTFS3irKD74DAbL9tEPR?=
 =?us-ascii?Q?2KCR/NCwfnXJjna+6CAZ1DwBxzQP4umpphqxkm4nnjNMbSwA9z7H4t0hZgFd?=
 =?us-ascii?Q?CVpyS20F6Q0hr8pdJ1o3l/1C+oc5tmbk06Y4hBbcJ+3QYQiAl2F9uPvBS2rJ?=
 =?us-ascii?Q?CCU8R6DV8wLvi26a2BP5PQHod7HAS5321p3LAzDbFUeiNWDtHoxz+vjKAuy4?=
 =?us-ascii?Q?ghhwxyi5gGTkJjwP0j9S/3CFfVZobK6dVYpP+D2l8s0o/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6e1724-cf15-43ef-1a1a-08d8d9c39b04
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 19:29:01.9010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfuzQgpHY0d9zFK4orS5Uj5ZQ9cCC05MVQtZYFlrYNxYwll63fkBlXUw0wUqKp5t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_11:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=767 impostorscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250146
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 02:28:40PM -0800, Song Liu wrote:
> To access per-task data, BPF programs usually creates a hash table with
> pid as the key. This is not ideal because:
>  1. The user need to estimate the proper size of the hash table, which may
>     be inaccurate;
>  2. Big hash tables are slow;
>  3. To clean up the data properly during task terminations, the user need
>     to write extra logic.
> 
> Task local storage overcomes these issues and offers a better option for
> these per-task data. Task local storage is only available to BPF_LSM. Now
> enable it for tracing programs.
> 
> Unlike LSM programs, tracing programs can be called in IRQ contexts.
> Helpers that access task local storage are updated to use
> raw_spin_lock_irqsave() instead of raw_spin_lock_bh().
> 
> Tracing programs can attach to functions on the task free path, e.g.
> exit_creds(). To avoid allocating task local storage after
> bpf_task_storage_free(). bpf_task_storage_get() is updated to not allocate
> new storage when the task is not refcounted (task->usage == 0).
Acked-by: Martin KaFai Lau <kafai@fb.com>
