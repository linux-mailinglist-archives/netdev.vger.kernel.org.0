Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BA118793C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 06:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgCQF3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 01:29:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbgCQF3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 01:29:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H5LImV016848;
        Mon, 16 Mar 2020 22:29:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=W2J0qLyoqYKMnbMOf5tUo0xy8+7PMd/Tp3obhLUpRlY=;
 b=UyU2TAlGd4tkRvCf+kLFyAASADuNRaCvgrU9RLmRPvnS5JqsUJIH3T102cXRkik3fXjv
 ZFyimlqvL/3bp5dLHcCMUeHbc764ddAsPZ+6MB418dfpUQ/dNu6zgunDJB2IkEJv3Uh+
 m88na7iv8YVuJUAOqZHg7AHa76QnQOmYjEY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf9qrj2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 22:29:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 22:29:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egspr8fKrLFNrcusMz2tEAVHJq6tBtGD8XvvTfWPjz68trfdlCppqMaPndnqkx6AwaQw3BUbcbFU49xNTawslxpLhD7RBFPq669HnH/IG0lx06h0bddPD8kRvRdoSMgEB6RmJ9t1uslNEAB2xT7JA2WpRltzaOLyot90dCIkhRLkVq9YBqOP0jU6kYlodSgudQFo7fHw2J740YRHNGRbmu9ZBXYFksnlIsKs1YcpZtbyymKCYNUvEryJ1gz/PkwGUN4Ma4F54VS0Srkxt4A0sC/4pHoFZ8JXNrjWVPC6XIgpJyEcSuU6h3QvNglLkV9SYQLseNrbojPtBVExe84rng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2J0qLyoqYKMnbMOf5tUo0xy8+7PMd/Tp3obhLUpRlY=;
 b=PhgZAQ5eM568BcPQPIVymkstKXW/GIleDO0UiwB1oqNnoi5wceyCU8tPC10xGNhBC0fFkpU/mYq8ixborAUFSoCeO0D2aWNaSoMpJPjQaU8Eg/qjMfqGwKVLb/yBcuKNUz3+yFZs1Oy40+hYDynY0VbxMXVkDmODppi7Y24e4yY8Wp6JHCLI/Q1PFVnNN0gsS/eC44lEph0coEI0urRFydY2J+vfGpQtKDSmiZdQA88dOcE/H0hDiskoUNI8jP+qO21zAaZbc4OjK4NsKgCU1Zq7VdYp/n6W/y/MQgqK40gr6S651leIAmA9b6bQ+oJ+11wXJqM29OzUp9BjhMK57g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2J0qLyoqYKMnbMOf5tUo0xy8+7PMd/Tp3obhLUpRlY=;
 b=Gn6m+452cMiR4lTDuYWidPHuWZi3DHad9dq1rKo1YiCnM3i1ADJIfviqMjZ/5NxNWdsd/2mJQrVEc1DHln7qkH/HnvNNWLAWGAXGRPV8MoN2EVZRdVVqPE/JjsGQt4esB9zm/oRAZA95vnmJITJIKEovzUmSC3Ke1+/pGk58I88=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2664.namprd15.prod.outlook.com (2603:10b6:a03:15a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Tue, 17 Mar
 2020 05:29:01 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 05:29:01 +0000
Date:   Mon, 16 Mar 2020 22:28:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] selftests/bpf: fix test_progs's parsing of
 test numbers
Message-ID: <20200317052859.bwwa3hqqstb6uvjs@kafai-mbp>
References: <20200314013932.4035712-1-andriin@fb.com>
 <20200314013932.4035712-2-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314013932.4035712-2-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR1601CA0003.namprd16.prod.outlook.com
 (2603:10b6:300:da::13) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR1601CA0003.namprd16.prod.outlook.com (2603:10b6:300:da::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Tue, 17 Mar 2020 05:29:00 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b659017-1984-46cd-fd2c-08d7ca3419c6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2664FBA79F4FFD52FA9B0EC5D5F60@BYAPR15MB2664.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(346002)(39860400002)(396003)(199004)(81166006)(8676002)(81156014)(86362001)(55016002)(4744005)(316002)(33716001)(6636002)(8936002)(6862004)(9686003)(2906002)(478600001)(5660300002)(6496006)(4326008)(16526019)(186003)(52116002)(1076003)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2664;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GbQdZF7Sg7vmV+MHpQUgEI84SG7+7whJF5JFgc9z6olRF8HpqbtUpqI1+/RThRb4UzQOlJ0wGERtJEbrxjmHn8xIXxAbAYjJAHdCk2wL83fxt7wQsbeHcm0lo8F0VIhjgiMhU+kcXpFvhZ3B1aSAXCWqWUKwwx0fr4umRv92DSqpZjN2IHZPeolLN83HwXRuRTtcAlB+6BZkHAhdn4kK55hdldi6KKlK6rNAetmnwS0p2xUpsVk4D60tudQz6mCMsmcrdnD5W/jDMauBK/rxy3Md6AQj6MW9l3dSHE51BJzdfVPJ31u1x/gxjuqMXbEdAnKPkRHiR5VcXxscyOIRPKpb8hf/iQSylRVR1UgRl5c3mlW1R6OUNWZCDmb+nnDwdMzkuHhbYd+q4of6kylgHxk/MT4/hMN7o+NLXNdYTCXV8mwOUOAVtNT/FXdYVyh
X-MS-Exchange-AntiSpam-MessageData: IaHx2erpseMaGNOrIfhaIr1VDq8CxbsZn5zTy6EonHPjsr2aUl73a+Tb3RQ7zqKsJdyVbFwyYDRuMSaoEXIQWs2LKNDXq2ThqQY6zElzUOd59MfkDEWF4MnL/JYc93CAaJTLaaC6/2vIPVmFcpeyID8ORn2JuGuGZ1F8PbRbFkHKF+jUhCPdF3qJJJBSt1A6
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b659017-1984-46cd-fd2c-08d7ca3419c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 05:29:01.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6eJdXcYsEEbbT9W0Q6pNP5GKSzUfDNmFotjy50ZngZdPgCNULCrUuXqw9L2omGv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2664
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_01:2020-03-12,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0 mlxlogscore=795
 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 06:39:31PM -0700, Andrii Nakryiko wrote:
> When specifying disjoint set of tests, test_progs doesn't set skipped test's
> array elements to false. This leads to spurious execution of tests that should
> have been skipped. Fix it by explicitly initializing them to false.
Acked-by: Martin KaFai Lau <kafai@fb.com>
