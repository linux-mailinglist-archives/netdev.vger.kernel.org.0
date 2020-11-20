Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8452BB1D4
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgKTR4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:56:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727421AbgKTR4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 12:56:10 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKHsq32026006;
        Fri, 20 Nov 2020 09:55:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AWE/ABXLERkTEiAqEbFnLkfWw3Yveqj5Q7RlhDk8bT4=;
 b=clvWPgSa7AFMHiQ7W3A4PzDQLUqcovMVq0/7brvbChkkGf9miyMe0pbQHbNqUHt93oMr
 raDudDD4iKHYHlVWuTplQ14KovRvYIhSkgrLvDGEOTkZ+9Tpmdq8wW0YBBv1vkfZPQZz
 t8RCIBeHrNan6m1GShXodBXJfYiCI/4KQsE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34x9f9txa1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 09:55:56 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 09:55:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwHFU4BKrLEDJtkGAHlnhtnwsssVHYvmqQB0UwOQzet4bnbBRJqZWMTRn8useqqu4a7PKFCTwx2q5XwO3vmwrx4CcdAp6EbliU/kWozNhQt9UU8yE++EspLzgR62kGLjV/sie3s5UOhEEinbNuc0gJC+D8R/McXybHb0NvHS42psH5ZTw9aVa6CvZWfOfAU1w/v9U91EPzzgZxH+KG1vpE30eZgSiulzWKjBYmIPq//tfD0UGQywbUQntxuIYktuLv+Xpn6PbRFLD46heFXlQbOtU1lzyHfavkKhsQj1U4aBrZJCAV2mEXz+7DHIqPajlOKAEWxPO0UL/b4j7vIMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWE/ABXLERkTEiAqEbFnLkfWw3Yveqj5Q7RlhDk8bT4=;
 b=iiRPqM/lpOVBO4T0ekrO5qObUtzgfwfLZt+N1sIJgti5aPUS5InL9r8hrlQbflnNcafw6Jav3myXgDOOdQqiic5Rop4OvKSahThkG7HIK6Bq1QhB3rF9NQjwZ+zSO0Zsb4PPzb2zwOv8aS60HKyXOu4dln9xVu82kjju+xPmvlfedTRIJ0P/LH25n2JSl4+9NPAy85B44iEltsgGjKlY9l50HDwlAMRwDWDDDl6ehs9WkvS8vIDr1vjOt1A0sqdo8iHhQYC5uxAeo5coAqvukJ0d9JvywDT/2zDDgWATPbiRG05aG+XCtdN7ej/FS4Fp/fMmoeYu6VnTlmYCLGmGKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWE/ABXLERkTEiAqEbFnLkfWw3Yveqj5Q7RlhDk8bT4=;
 b=lVzzTRIHWefCU4qmhsOyjYpIIB+gj1IlOTJmN1yKcCglm5D/pga9oy4PKHFhyDuHv12wxkTq/4zX7dOB2nzcoiCWz0DJkF5Ynjn69Mt4DVW1ygEErUON10IUjMmCmzCcpiRxhnPxnpgGjaoag4EZJIe18jYwvNc2+sIU7q7g3b8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 17:55:51 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 17:55:51 +0000
Date:   Fri, 20 Nov 2020 09:55:45 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: fix bpf_put_raw_tracepoint()'s use of
 __module_address()
Message-ID: <20201120175545.c6y7wuj3v5icxrq7@kafai-mbp.dhcp.thefacebook.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-2-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-2-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: CO2PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:104:4::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by CO2PR04CA0166.namprd04.prod.outlook.com (2603:10b6:104:4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 17:55:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 883d0bb4-10ab-4d6d-6251-08d88d7d84c8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB226307F8B1C5EF2334D4C57BD5FF0@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gmRWbY78pSiCy9GEYB6Ip9dSUoxbioG/xFXxd2TqlQqH7oIDaD/fB9mZ2hs+Hlx5Tt13Mp5tPcm4X2L50qgoifkcMGQblLKysp5TOzdTg0+uy8CfxJg1pxw++foFTZ5Qmqrpcgtev0ughBh1ToSxy2nT/y267AK3KwW9vsMF+4z9LymTYz3ToFuGkLPH/3VPsTHECYyAWiTorzJLY5PytGcT8VTpqlwVKT4ytMeFTLCFAjK3a3c/IdejkXfxzXBosKlXrIvocbqm286XXQbQTg8h+rp68QttxHEsLecZnNMXgP+3GKEgv1SQkpZAWA2O343SU82MhkaL41PbtmI+cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(83380400001)(5660300002)(8676002)(6916009)(55016002)(16526019)(66946007)(66476007)(9686003)(186003)(66556008)(7696005)(52116002)(1076003)(2906002)(6666004)(478600001)(316002)(4326008)(8936002)(86362001)(558084003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JE2RLMnLSWAXDRZC3ic2xwWFwcH5onC75WGsYAv01PI7XdrHYaUe0zQFhrIeqARP4xMAEdMyGlKSc45DAIV4n37ZmkBN5DNE8jR5WwpjW8D9ltLE72ca2PzT6dA+8zJycgTBRGgRjY9TajY03Vt49A4A5fWv7/dZ6RcCvdqiZkj/q7xj+xrsvFhMklcmsVmqhIqIsc2QEgejOySYtkxJcyy7y09VxMyiMpH6rdtHQWffbz2YJn8dMWEo2E3BZkfdwS2WhYQE/p+q6geMMEV3XqU0Of+RHEBbFAo0AatzO4T2wxS6Ton8dzuWSm8x10vsIIJPPiZHApBw9dreZUH3tg9VavV+5LmpZP4moKH28r3DoLixasWC0ljlP2Vkl9lU7iKj9qhwTYtsQKiBuSAedgM0aPZGmIu4PDbd6dZPsIvCcLCVPpJdzfmG+fI43gKVt/G8eiAYh3KI13RcFrDJIJO265eEeAHVxNiM37Syh6FNUyxpPKd37ZpUDzITWbzNxLS0E77dsbT9KHTYhY6ntH8GONZf40VmvQWlT4tEiQrVosbCwfHh5RMpx9sOElfrGJpGH1dt8vba3y44o2DTcv2HSOtDKrk4XP5LfiRRd7ZLZLIn9XSZdLBTtgU9hX0S6U2mRJaQ9S34JdG7EHeTHRWUnxrkjE/A+yP++VZmdT1tNuZLzA4Y682FAF0tmO0bHsiIPtKxmBsj+wENii983mWOmOwP5MD/Fyi+EVvOw/E+SeZ0lZzMwIg1VX6F6P9uP6rbYxH4m96+dxC+BuO/ohJILskL8HO9vytLrYd9O8ROA0qJ2aPLC4U1grR7Vafy3tXxjcyY1JLUAj2WpkgVWZsfOnnFDMXb4/JztxYa8dcJ94qfjAu/1a48kYPMmywbR3QrBvVDT5UWR3beKMGLmtadBOpwfnd2ssd0/sEf8Rg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 883d0bb4-10ab-4d6d-6251-08d88d7d84c8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 17:55:51.4116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMSMwLJePpgd3WoEJjLYavJ8CpI1T4ywJ84A2ufqRp9FPFdaQx1vJgnWjts9w8D9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_12:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=824 suspectscore=1
 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0 adultscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:39PM -0800, Andrii Nakryiko wrote:
> __module_address() needs to be called with preemption disabled or with
> module_mutex taken. preempt_disable() is enough for read-only uses, which is
> what this fix does.
Acked-by: Martin KaFai Lau <kafai@fb.com>
