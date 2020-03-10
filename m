Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6795D1803E4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCJQqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:46:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54908 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgCJQqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:46:55 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AGYMLi019795;
        Tue, 10 Mar 2020 09:46:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tcqK5Eq2wAzx4dmg19YSjpdRFPwAQK4BVtIoIkii7Zk=;
 b=nJlyvKvmTRQQj21WY+J/skBBDpG70nBdRZFbGJwANK9p7ti8q+6PnwC7rNRVRDCUBwkK
 Xzv5c2fYgORrGcYYv87cYtxFBirNHvvVSBhczejxtI9fwAOWbcqLu2UEa8kQWQB1J5Oa
 zsg+wZ7QaYCxeR6wbaOJcZqa8h7MBVoGIOc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yntmuddk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Mar 2020 09:46:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 09:46:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FosTndJtC+lCZKrGZOrKDd4vCv9G2IM7PjOsz9jMY9Qnm+4P0Oi6Wvp+U0TRkWrrgjXbXHnoK9Tj2LyXYDJfFkZpdKON5SgKEmcW3PuRDgSJzkrPNKeT/NWqGSeDFzGZtkQl/FbWs+4xXUT47UjZZxJNx3KYtfXiGwchhV0578AAeXmAjXZosUVDQrSjFVyuoNU1wI81J+9ISzLhwSDpO5gqIP43bjnZNPdvho3uMxrqdfh6CnduUOp2cBFCmQg0V/DEg3+h7+49GjUqpNpS+TpfTPFn5TwFhMLIOydXjFbj6u15C56QqjYcSD7k+WNd2IdT5vu40EBZ73OLFofrDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcqK5Eq2wAzx4dmg19YSjpdRFPwAQK4BVtIoIkii7Zk=;
 b=k4Acx73i2yynI+Sd0Xzb4RQRAfwbaHgjKdAFIq8sqVcWcJS/afZqyxYr3WHGfSgyDA+SCX59x9Pij21YeqpF+YLLJDvsvV94kdPTKsXGTXCsnxl9hglo57AcJjHqkM1CWZTxpZ13EBavB4yhlPkeFU4W7XiuY0pE0yYFRNDCIdgfSnpxndL6dlwt+6UAkANzbOLynUG10VwLrArRux3n4Ww+tzdYiyIeObnKpHzpus2dub16A4oH92uxU1SbdFb7RKngFjEbA140jxo4SI5FUeS2m8rhgtSWvkp50i1GdmxaDHIBR0Hc7QLFFdmaVsiD8mYM+9qP7ZmC/nNikWyvCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcqK5Eq2wAzx4dmg19YSjpdRFPwAQK4BVtIoIkii7Zk=;
 b=AIe820trcXUfEvsTOFFZtJFGgYTd0OxDRHNc/UjFKQA7HycqCXxapTyQJzJW++a4yRkhyQHU3eJQWQQK4LGFTLFd8LgLZm4BfX22uVSyuvAAdjZtSmhU5ILlMi9OPxXJAmswmP3CahJHj07F9puMO0NfWZXvsadpQTPHG4icu2Q=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3429.namprd15.prod.outlook.com (2603:10b6:a03:10c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 16:46:35 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Tue, 10 Mar 2020
 16:46:35 +0000
Date:   Tue, 10 Mar 2020 09:46:27 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf 0/2] Fix BTF verification of enum members with a
 selftest
Message-ID: <20200310164627.zb3pponhlsweqk45@kafai-mbp>
References: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:104:3::20) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:f2f3) by CO2PR06CA0062.namprd06.prod.outlook.com (2603:10b6:104:3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 16:46:34 +0000
X-Originating-IP: [2620:10d:c090:400::5:f2f3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4767a69-f074-48ea-16aa-08d7c5129866
X-MS-TrafficTypeDiagnostic: BYAPR15MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB342929C806D4C809D7934977D5FF0@BYAPR15MB3429.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(9686003)(1076003)(16526019)(478600001)(33716001)(86362001)(15650500001)(2906002)(55016002)(6496006)(5660300002)(52116002)(8936002)(186003)(66556008)(66946007)(6916009)(54906003)(81156014)(6666004)(81166006)(4326008)(8676002)(66476007)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3429;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /uvJdqALQyKT5bLT7IcqsIUIypaiOA01slljSwBGKZ732m7S08SYtsaQPY2ZTyuLMFSW7Lpy41g/icQRoUz4GAoaOg0afrvi8WXYtNcEUGh0LyEZVUCRHvw4fzEcqBYHpaZREd5+u/7JVG0DIh5YBpV2rP5qnW38jf31ugRkJw10/N7Pa1Fb2X6WaPePUsHvXKJDFnz8ElOCs38embOwrUs0aFCqujbshBFPdeL+zWve5n5l2awcqyaN24NYXUwg1DB9Od+jVMBN37D5bDOgARfFVyRQVlj77N7qdvp9nj2jC/YcQ7ym4JRci9uEOE7jIIkhCc6V7IRzpt6uwKRDOFd4sau07sN1DOA5DBS+dcV1/hFt0ClaiDvp0eNCsm46ys7P4NZuAGX7xkMutcQxEQK+XJeve8M0ys5jjRGrhgdYNa0pQyQ7GLjdj4n+6ano
X-MS-Exchange-AntiSpam-MessageData: /MikHsI9XmYcPoN49cp8fWyZbGX9RpG5QBOklt9jiv06/muizC4hlkY3I/6KWHY6gr0DMk+OE0l9Evf5hpJqOugH5fkfrCb5KTnJ66MNBbcIesoeoqPwqRy9MmIV034A6d7ho5NgUNDsKyz7a3hGthUEPoo9R0aMz3fVRH7bQ/nHhpkyeXy0pV9m+LNYLumd
X-MS-Exchange-CrossTenant-Network-Message-Id: f4767a69-f074-48ea-16aa-08d7c5129866
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 16:46:35.5123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiSlNCbMvFuRu3q8GAJix5tEh9DVR1b1PqJW6n2K9INHIGId7W82WLoKZwr6UiXC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3429
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_11:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 clxscore=1011 suspectscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100103
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 04:32:28PM +0900, Yoshiki Komachi wrote:
> btf_enum_check_member() checked if the size of "enum" as a struct
> member exceeded struct_size or not. Then, the function compared it
> with the size of "int". Although the size of "enum" is 4-byte by
> default (i.e., equivalent to "int"), the packing feature enables
> us to reduce it, as illustrated by the following example:
> 
> struct A {
>         char m;
>         enum { E0, E1 } __attribute__((packed)) n;
> };
> 
> With such a setup above, the bpf loader gave an error attempting
> to load it:
> 
> ------------------------------------------------------------------
> ...
> 
> [3] ENUM (anon) size=1 vlen=2
>         E0 val=0
>         E1 val=1
> [4] STRUCT A size=2 vlen=2
>         m type_id=2 bits_offset=0
>         n type_id=3 bits_offset=8
> 
> [4] STRUCT A size=2 vlen=2
>         n type_id=3 bits_offset=8 Member exceeds struct_size
> 
> libbpf: Error loading .BTF into kernel: -22.
> 
> ------------------------------------------------------------------
> 
> The related issue was previously fixed by the commit 9eea98497951 ("bpf:
> fix BTF verification of enums"). On the other hand, this series fixes
> this issue as well, and adds a selftest program for it.
> 
> Changes in v2:
> - change an example in commit message based on Andrii's review
> - add a selftest program for packed "enum" type members in struct/union
Acked-by: Martin KaFai Lau <kafai@fb.com>
