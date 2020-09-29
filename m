Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF9227BCC4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgI2GGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:06:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43334 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI2GGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:06:46 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T6492V003641;
        Mon, 28 Sep 2020 23:06:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=e2nI/7sfLhH1IlRBnp3T/u7Y8iNKfe4O725bGxsrvyM=;
 b=W+u9HRcZZ4HBSws84vTfmbAFDFZEjY5pQj3lJ7Akt9IEqWKIaJwt5UkSQxi6FEqMWlTQ
 QOUXxszV6Di1YeVeTZ2LHFB4HeBjptLfRw4e3EoPPaOv45AfjOYy0513rQqyWFObwBvI
 dAN4u8j2eBMFrPSqBVAs1vblaSVlpLrV5u4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33t3fhbbja-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Sep 2020 23:06:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Sep 2020 23:06:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhF/EwJ+407tyM8TO3X2bOaq/pUVu3EyUu/wO2QpDvudG03IFrpDTLKwL/f6nT5XgBFRTdiiPW1aCdr+QTCfrlzUjSV7kxSg5NqDXtNmKzASn9jrSk5ZSW858qeyKKDqS+eyZ3z+EufP95mn1jNZJQnoeMwgU5/q3EXK3/43yTrZr84A9qQ3OyIlZYx66aToVGNQ8I3F3fSp2bFE19Vhsn8B6qHLf7FJQDEUroQrG+4/PgYpBOXsQB5PlXEK7nbzbbkEbJ2Pxc2jr6pNtKQ8hq90bitbj+MCsZk0GzqAz4UqUT/qKK1FUDsYOh5uZLiCJpXDBMKM3rmdla80vkfvvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2nI/7sfLhH1IlRBnp3T/u7Y8iNKfe4O725bGxsrvyM=;
 b=c/DWXsEFf3KTEhuLxwJguQlawxwFmzPf30Ya+pc7Rkxa9LQsUe4v96G+/D2JXRXDdT0bxMGYCiE9U98r08c8f8AP8WKkZe20QCefY5y4pg9QYf9PC3dIGZLe759XTDM2wdMRNfTm4nio42VODhdnkU4XpcbR22oGaQLn7feE2SKZ0AI13MpJrcwx78X1SX4LBSb5sSRgxdNghsj3YhDmD4E3+t9xtd79H6AE2ElsGmAXogoLehrJ2KffDh0KpYPRSkOHCcUfQFLHzhs7kRY/Rcm2qfpxHlkvyyLkr2XUEbvD6Iwwm7cD91sTLFJw22FDtrQ4Y+5lKFGtdxLegCeuXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2nI/7sfLhH1IlRBnp3T/u7Y8iNKfe4O725bGxsrvyM=;
 b=NDrWcf3OiIZeAUYPip0COA8b87AK/tgH7T3f0UYNVw2N6+RPP8cjIyQCxFbaz5P2s17CPyZpEUTjAaipTqHK2hiO5YF1Sp084XXkVHGZRFa6kpiY5UuMQ5YTDJ4uMIAtqStp0xnlaqVlRDriMQ6ipyT0YCkyUOsJ1gMLeJAffBE=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3207.namprd15.prod.outlook.com (2603:10b6:a03:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 06:06:24 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 06:06:24 +0000
Date:   Mon, 28 Sep 2020 23:06:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <kernel-team@cloudflare.com>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/4] selftest: bpf: Test copying a sockmap
 and sockhash
Message-ID: <20200929060619.psnobg3cz3zbfx6u@kafai-mbp>
References: <20200928090805.23343-1-lmb@cloudflare.com>
 <20200928090805.23343-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928090805.23343-5-lmb@cloudflare.com>
X-Originating-IP: [2620:10d:c090:400::5:d609]
X-ClientProxiedBy: MWHPR19CA0013.namprd19.prod.outlook.com
 (2603:10b6:300:d4::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:d609) by MWHPR19CA0013.namprd19.prod.outlook.com (2603:10b6:300:d4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Tue, 29 Sep 2020 06:06:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dccced7a-9940-4689-290f-08d8643dcb9d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3207:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3207D7DF7C4663C431D27F72D5320@BYAPR15MB3207.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+Jird2P3zI5Yjz4zv5YIpIl5QGnR4lFqnfWKaUVb3vx41N4/bqyun1iN/9WSg42N8zjfimm9+N0BbXbIaRrYCgKr7IvV8Al9qC4wqm0k/Rol9x39y0Jx5b5DFiehjsnJ23FLM+cNl+D7XTNkCFIgTKRw5sSRTaL4HtaQa0BNh+mq7sdrHE/d9Va67TxbncAhPFz003amE2qv9PmNdSK8K0HHwmM4Nu+n0B893p7Aj2QqJvDSc1VPb6VStV3dr9KnqQ6yYXbV6nbcZzzdrZvVjOk8bzexXAkG+Am6EMgigFWpl9QDT2vHdspe8ZoMyy+fn7oabxwhlwP0oO00nj/IzYbIWSL35RqgZe8HAqMhKRCP2nkgQdosfNIB/+dQ+J6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(136003)(39860400002)(5660300002)(52116002)(54906003)(55016002)(9686003)(16526019)(6496006)(186003)(1076003)(2906002)(86362001)(33716001)(4326008)(66946007)(66556008)(66476007)(4744005)(6666004)(8936002)(478600001)(6916009)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KO9B5rnMvt4gMZzJd4r8EHbSccTinm4kceJIFkmW5B/wDQvddj+JqnQx6wj8xqKXo62tJRXF9wrF0Hl5x57/dZJeMoppf9s+qwtvevFishgQMLWp3aHc0d0K4cG82cLfnlkXcEHmFHu1ooOUGTZzWErH5hF7mS9CpGHUEBgkNmTP3l+J2X0+0ZiOm2kWJBul9eOFiX/2rhP7rzf1LEj/Smjy3O+ysls90TCP44AeLU8haBsmfVN6JyUA+DPrBZRoTX655fHGGPvshcNdmz9Y9Yu0zrOcio79ALsGJPjnfJzicP2mHmMXCAK3ZQ6P4VFI5LEYaRWXP8Cj6YxDr5RxNrMvBAIP9nqv/6S6ybVQyHtGwJtDCEqUzyFzvpTkeJkVYc1k88jBKOKkdiTTh+SOdAlmqVkLbJt17HeO0qEpdQd24+pEUE4vZJt544rhevstNJ2ztpFmU+ILCrvtBln5gSz+wpH0z2W7XxnaYoP0ZA9doONCo+NeqGdtQ45TuwfveSSgoV3V9nQLBz2UF3HLXy1VXrBEkiB68GE2lXHBzfn59Ayhif6xp4NtL6ElxnlggngTqM0XQJQdz4tCf5D0Fxr8jjoIehk0GorU2eidr90ACpYvsx9QDrmEt3wH+zpSXJ8/OEIEy29SmIMW1/caPxNuPzstYccRtoY2l5nKKFQL61MmxPlDp7s34IjspDD/
X-MS-Exchange-CrossTenant-Network-Message-Id: dccced7a-9940-4689-290f-08d8643dcb9d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 06:06:24.6961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHZKHIML8+aMAfPc5mVgKTNDAFYy1exdKvrqIBCkDc6RjJciYzXiHIkOFPSpnr/f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3207
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=820
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290060
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:08:05AM +0100, Lorenz Bauer wrote:

[ ... ]

>  SEC("iter/sockmap")
> -int count_elems(struct bpf_iter__sockmap *ctx)
> +int copy(struct bpf_iter__sockmap *ctx)
>  {
>  	struct sock *sk = ctx->sk;
>  	__u32 tmp, *key = ctx->key;
>  	int ret;
>  
> -	if (key)
> -		elems++;
> +	if (!key)
> +		return 0;
>  
> -	if (sk)
> +	elems++;
> +
> +	/* We need a temporary buffer on the stack, since the verifier doesn't
> +	 * let us use the pointer from the context as an argument to the helper.
Is it something that can be improved later?

others LGTM.
