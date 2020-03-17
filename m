Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FB1876BC
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733146AbgCQAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:25:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733127AbgCQAZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:25:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H0BFKZ012645;
        Mon, 16 Mar 2020 17:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Z+djIjS5ccmtlVsCHXl/1VDwHsQ6UjX+93LyMcNxosk=;
 b=j93u8trNcJTgUeIhITapEmmfBDrf3eUi8Us1JGZR17dMbt2nYcK7xSQzWUePD+lDQk1q
 Zbv+/SuE90ndcZjoGgFhl/nqlBZ3EBoDp1gOsD7smiWb7nxLcFWkYtLdkpiWfLtD+Z1u
 E7cCuwyOoKNLsGHkLJvZ1yIeFCvlN38TW/U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf36yk3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 17:24:57 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 17:24:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZ6lY4V8U32udqD9EuHNgLeLqg/nbIjfpCyVvLmgycyJKwwLNW7/Uq9KU9OKxUUTvXwZnZDQ2IXJlPq/TQnmgfpyQIMi07iUPcKZPYyLUpLOubaNLzfdjbUHaRIUvXqqVICdV/dXgcb3HXqhOydO3COOMZvNKo1mz/4o+mMrkXJ/960X5lbzGkCzQEqjlU9egaL0sAB6uR/G91JYYZ7zyOAmZrzkTo0p5X7Vuh3af8M6V2ju+XrUySYZCSkIkbgY0VHa7IigeyNbmNbCvfghjq+mYJhkwhmo9dRcI1hy4ocgbIu80yPjGepoTX/qX+n5gGbdm4nsx4SQlRPYgM7wHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+djIjS5ccmtlVsCHXl/1VDwHsQ6UjX+93LyMcNxosk=;
 b=hlx4e24h2tNXyFSIm2VaNOWn0zHVH2U+wo2CL41gEposOEbMsl/4jFtUi/VuZf+B/4d9wYa7afQQmPYeaEbTKvoqQHWeYGc3XKvhxXjc4M7uVRilppzf43yjBiphyEhb2ZlzDW/mswn48t2Wu9oXfOQsVX4zk8UFsv683L+dti1thReTJPhUhbb5PZAYq7jcYkmEZB2UvWz0gxiVeIMHh6xodYmzKAyFQ7zTlyerpGDW7DqXadkxPCYREghD22pVKdynrh3cL9YEwNXYdeOhr+vEMKZ+qn++tRyCxsEpuy+xnXNFjGt1TbN1AX7vT+/gBl+2kAHhgasRvkYLbvKKXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+djIjS5ccmtlVsCHXl/1VDwHsQ6UjX+93LyMcNxosk=;
 b=QTcAbtlGrvO2RKxPM+VJL3gOEcPVdH5lhYFNpbYHoFcnru8Zp2SWhIj/fD21hgXeoKySzM5eXOzGV60CTJ3g1oyHZesJwbZ2AbYHd3cHsVfJDicjWuDRIFwRzdmDV+i9/dA327G5QBqtwbDZVAxc/eXiqSwDAEay+43BnIh7OpI=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Tue, 17 Mar
 2020 00:24:55 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 00:24:55 +0000
Date:   Mon, 16 Mar 2020 17:24:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] bpftool: Add struct_ops support
Message-ID: <20200317002452.a4w2pu6vbv4cvsid@kafai-mbp>
References: <20200316005559.2952646-1-kafai@fb.com>
 <20200316005624.2954179-1-kafai@fb.com>
 <da2d5a6c-3023-bb27-7c45-96224c8f4334@isovalent.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da2d5a6c-3023-bb27-7c45-96224c8f4334@isovalent.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:102:2::33) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by CO2PR05CA0065.namprd05.prod.outlook.com (2603:10b6:102:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Tue, 17 Mar 2020 00:24:54 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95aa7314-8a36-4741-df33-08d7ca099e07
X-MS-TrafficTypeDiagnostic: BYAPR15MB2727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27275658E647A903799BBEECD5F60@BYAPR15MB2727.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(346002)(366004)(136003)(199004)(4326008)(6496006)(9686003)(55016002)(8936002)(81156014)(81166006)(2906002)(8676002)(1076003)(16526019)(186003)(86362001)(6916009)(52116002)(316002)(66476007)(4744005)(478600001)(66946007)(54906003)(66556008)(5660300002)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2727;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J61zT6kRU5JQeKE4M0iuRjg8T2tv0myia9K4D4dosI705GXfalKsSWD4MSGuGefOuGX5wa8OYtw3X5dqQOjVtyeDunz3hUUy9bDw2XmtHozyl4f8JM9KYBkmvpULqyBPQWospyXoXcvnFxdvDIHyaSVXHTmwWOeCjkDycvxtyjJAErMRhVznF4fKx8tsWUNEoHwtFO+hvEkHpLNeOqmKe1lKQbYvIi4G9GKBx/125v3AkcCc77+r5Hfd4i7FNqANib7G1Ia+HdoOMtzk/Axr4HPVYggmJvaigjHRGAN0NXuWfkANVa+SUfds0ceDBzGhtKlkNPb6GStQIck3+SBpbzqrD5pm+ft0nvtZ03FCRtkvKDGJkRlemztOOqeycEmz29xwRr4AyAEnhaurHv3RzmU5daltnK9MggaXFeQPtrASO51W8bh2qQAOkuA9IItA
X-MS-Exchange-AntiSpam-MessageData: rCfAA59bBygmV7VewEXEiANU/vh0WVzolmLMNRc5nfwG+SBFaHfAaxfiItAR8B6XkzTeueplR1XPV2bODEkS64M6pXHBKAMhq5/SiMFLvwI86pF8fwu5rxJIZEgIZTm/ghbkuvhZx+O7fAXaQyvGYTa195n0o7wk8R6qF1lH0bLAxHf1CJpcdhhhKmxNwf2P
X-MS-Exchange-CrossTenant-Network-Message-Id: 95aa7314-8a36-4741-df33-08d7ca099e07
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 00:24:55.4654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgIMVRANv6sPxXgevJnz/CGvmlT4ccHg5N0f8ObdhuZjm8J7y4kU8L31Yu4BJtCY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_11:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=989
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160098
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 11:54:28AM +0000, Quentin Monnet wrote:

> [...]
> 
> > +static int do_unregister(int argc, char **argv)
> > +{
> > +	const char *search_type, *search_term;
> > +	struct res res;
> > +
> > +	if (argc != 2)
> > +		usage();
> 
> Or you could reuse the macros in main.h, for more consistency with other
> subcommands:
> 
> 	if (!REQ_ARGS(2))
> 		return -1;
Thanks for the review!

I prefer to print out "usage();" whenever possible but then "-j" gave
me a 'null' after a json error mesage ...

# bpftool -j struct_ops unregister
{"error":"'unregister' needs at least 2 arguments, 0 found"},null

Then I went without REQ_ARGS(2) which is similar to a few existing
cases like do_dump(), do_updaate()...etc in map.c.

That was my consideration.  However, I can go back to use REQ_ARGS(2)
and return -1 without printing usage.  no strong preference here.
