Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D44183A14
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCLT6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:58:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23000 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgCLT6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:58:44 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CJtpkq027752;
        Thu, 12 Mar 2020 12:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fFaBTJNSNdr/CVu9bi65rloAhWDMUaguHEkxYxptz4s=;
 b=LYi27cFIEnyUErph9Cf183Le5XPad4FaXlkOHRInvI6tvP1nZ/60oZ9rnyFRNYk89AM8
 WEnwiKISFp3Zyl4xmq1cNTU9xTiKGtHxOQAT5/rKE/iZR4cyeeMdlKhrfdKoUiqjslW7
 4k1MGyJTJbrMx8hVuI1oDIz8VquYOFNK5ZI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7fggs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Mar 2020 12:58:32 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 12:58:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIcbVcub9NoS8k99JkKcjgHkxo914wu6ILLkBA4LB++m4xJQq1u2dspbIHpPdIfmNs4VMZ0KBCsnVAtCxq6TzyJ4tQLY4iOrp3yVpL+QUxDp5+RJf5w4CKB/OYvao0HbMftlZ2xfpj796fXklAAs7sC95VoO0HdathARQyeuZGI2hbPs9hkS+ly3Rk7JAlKxuCtSARvFJVduboF94VFDvH4OcgqxxVRy47mtI2StXAdFzGGOTHAVIr4mNtiArsd252rCFp3ftau/l8z7b0YLEwmXP61kUhRhtJKI4OwvslhYImcuml4W3xlLOjb1QQ17owGRMFMMOkxndjUCMOCewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFaBTJNSNdr/CVu9bi65rloAhWDMUaguHEkxYxptz4s=;
 b=e4qxyxBYkdyjYTMHxUvAv4dX3P9o8eyPbpvB1YK5tGI6m9c9a0ACxA64JDrVlew6aqP7PiakBc85V7oXCbJ/5mfTXl6MR2H0xcnKanMTxXFJx9XIU4k7AhfHzpuiq8QAWEaDTMEqZ45YOwSte6ixn4tlUfUNESXMDkfNT5GWJeCjKXKPy5PXqhIUwxMNd9UNvFhd+HvKiDX5yJfoTKFclJhjc3zAQec48VERuJwNbONLGP33+RmcpXtHWKK3APHrfp0k2H5w4jd9xRUIfTxKidhKWM7y9oisGzru8Lb1zua87rtQUKr9ox2bfxhgNO3iUhFZhVIylXQmJU6Ok25FDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFaBTJNSNdr/CVu9bi65rloAhWDMUaguHEkxYxptz4s=;
 b=ZhUYItPtyGkaxkWF+LSkAgsbd3wp21Xxd2Na2ZV6HAYdjPjq4/oRVfNuJ1fvgHmoMtvEr3mzjDVPExGuKjotfeZrLSruU+nnZ2WFm73QqHwpzPCbX8RJDUWDNS63EARrVEVVdJmAcioMbAbccAIU4DgrMHA38rpNUAKwdJbH2T8=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Thu, 12 Mar
 2020 19:58:30 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 19:58:30 +0000
Date:   Thu, 12 Mar 2020 12:58:27 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>, Quentin Monnet <quentin@isovalent.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: split BTF presence
 checks into libbpf- and kernel-specific parts
Message-ID: <20200312195827.h3xxc2gesrmiv57t@kafai-mbp>
References: <20200312185033.736911-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312185033.736911-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR17CA0062.namprd17.prod.outlook.com
 (2603:10b6:300:93::24) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fd85) by MWHPR17CA0062.namprd17.prod.outlook.com (2603:10b6:300:93::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Thu, 12 Mar 2020 19:58:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:fd85]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05afedfe-1952-46c2-42d5-08d7c6bfbc59
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB226351BD5F973C4AB36A17F4D5FD0@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(346002)(376002)(396003)(199004)(2906002)(4744005)(316002)(4326008)(55016002)(81166006)(66556008)(1076003)(9686003)(86362001)(66946007)(8676002)(8936002)(81156014)(6862004)(66476007)(33716001)(6636002)(186003)(16526019)(478600001)(6496006)(5660300002)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2263;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zQ/WP6QALDYZkx5DdWRtUiR2XuZaPFFT9aDDWFFUZd4I4WxRrZsXAA9k7Y7t68LBpsVsOUWx0rsbFJgNde6FrU3/nPdLBSMi4A5ymACKMOLXP9GMv6CR/a6kknjk0fWF5ShUj+htCNdwmKu31Kj0nyuU80ToMtN0LwHvAnfjh8VnDB61rer3IXCcyBZgOQhbFPPFYDsSCjKY7aE0kGtBfN/EA3t+lKvG+jATM6zpf2nS27mqBxW9jtPyeWzH1/rojB4YMKBjLm/xsdOd5dRsIArQ4Ppv5kMVbnnGjKpoItV0+6+wCMTWs5SBGeg44OwpIKQeLv9LeL3Yztdpa3Q9xYfxo4BsUbid5Nif+uwQCxhfZjZm4/WlO5zGTJRhOgqG4rNGKfnXmGucYGOgBv4SfE7/6rAAsthyn3EcSdPPD9kXXzqaVhEMcTPx5ljh+0Sj
X-MS-Exchange-AntiSpam-MessageData: XaM2bfN8q+onftAAf53qvm6FPr6UfZx14x7t/s50S2KTfTidw9bAwjJJhLzgIefrnH77q81v9yM9DB/akqHNQHm63n3wHG5DCiIb5kqkdFQLPUwkHAh7vP3KDW5TO1olAXXPRCgXssMM7Pj/blv4HZxGe7pTM3/YDPcOAI94XtTfOHvR4O6eCpGeJBwKZfmQ
X-MS-Exchange-CrossTenant-Network-Message-Id: 05afedfe-1952-46c2-42d5-08d7c6bfbc59
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 19:58:30.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbwQcUeNiANSF3zNTwgDJjqvXqmMZ3kwZ6FuklndS+hQMLTNZVOnTrTu/9QGSRw3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_14:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=696
 clxscore=1011 malwarescore=0 adultscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003120098
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 11:50:33AM -0700, Andrii Nakryiko wrote:
> Needs for application BTF being present differs between user-space libbpf needs and kernel
Nit. This line looks too long for commit message.

> needs. Currently, BTF is mandatory only in kernel only when BPF application is
> using STRUCT_OPS. While libbpf itself relies more heavily on presense of BTF:
>   - for BTF-defined maps;
>   - for Kconfig externs;
>   - for STRUCT_OPS as well.
> 
> Thus, checks for presence and validness of bpf_object's BPF needs to be
> performed separately, which is patch does.
Acked-by: Martin KaFai Lau <kafai@fb.com>
