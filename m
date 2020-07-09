Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8466921A9BC
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGIV1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:27:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36782 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbgGIV1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 17:27:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069L8kM9014679;
        Thu, 9 Jul 2020 14:27:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=l5qUOcDF4zNcBrB47aXMCP0zUZamw+Eof0I4QVyb24A=;
 b=CsY/Rdo8PmhVaGdsyHLR93YwiNX0W8+f0SZKt+BjJt8rbHMIh+XExjuv4VOvrIqPqT6/
 fqCrOpiIQ+Uy9TYi10kBz6UMgyF43u9wiDGj2k6cqy84Q32ldRWLeahTjGtmmQVP5uha
 76bECRKoXofBHkQNWGNoWfLZsw84RtPz4Co= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 325k2cetgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Jul 2020 14:27:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 9 Jul 2020 14:27:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2CwN1+XoFARcuLfwb1aLGLI/2bub7QH7PjlRPDzb9If5JM41uhxYeX+DgVm6o4Lh+l0Mk10Y9cao6hf0XTWsoo5eSG/IVwfiwu4wLTJ3/bcrgKwYQj+3nJnlK5qm/u6zmGlnMuH0ifEwSFcpdfpyWvt80SdEP5oXYBgleH0VNdkdwjWZHsL7HGI6sl0aq2ycaAqtnRs+BfR1XYTew6IKAQZaUL2XX4TQUuwTSKVrTWo5x7N2C/O5oSxgXDXSPoJ7ttFjJ+s8wWDz5LvwjzhRjUHGgKhwBnYrGaIef6vIjnX4RFSaE/Eb6/zmoFGENl1MQRFT6p/sjtxF2C8dnXEMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5qUOcDF4zNcBrB47aXMCP0zUZamw+Eof0I4QVyb24A=;
 b=PmPjoC57LpkmAPKxIutdkNAyP5gWoOgyz2vAhMdWCYiXpCExzBNigkoptttBMSF9KHG4F5J1I6gBoZvZdZPW9I+UnzSo1IcmluNAr/s4NVAh90aRn7XZilcioWLdwgD3sXON2rMD7bIcG+D+56ToF7sUwqUbabwq9/MGpzOsjxj9DpLUqTz9B33pZIkICA4zLU1gknl5YYflXQMc4l3IhjqgDXwPXcJD5ppHbXdWl6K/5WlHxnpuA9tjwnXc5q+KzKvpcnz0dT3evPSKaFaJKpTZq4ry5rNeILaczM5mDYRpLqN5B9W4qz7E9Z8La5g3Qm7ICYt9o3u+gQfwO7UVRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5qUOcDF4zNcBrB47aXMCP0zUZamw+Eof0I4QVyb24A=;
 b=T4ZSD01mRSUkOhNhDXANKRNQdQ8d09tPvsv1XAa7/XTT2yiSCkqoLmLMqjGX16XgWChc4ObrJCg7DB7k+OvZvgvHr9KZe1zh5KTi1co63hJKD2EHFia8nVsd4mFEKbaRxd8RtcCvAoIRwulfWM3OfX5C1bzuPRv1Dki5Yo5AwrY=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2406.namprd15.prod.outlook.com (2603:10b6:a02:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Thu, 9 Jul
 2020 21:27:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3174.023; Thu, 9 Jul 2020
 21:27:17 +0000
Date:   Thu, 9 Jul 2020 14:27:16 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf 1/2] bpf: net: Avoid copying sk_user_data of
 reuseport_array during sk_clone
Message-ID: <20200709212716.fvuas7m5dvlotwnj@kafai-mbp>
References: <20200709061057.4018499-1-kafai@fb.com>
 <20200709061104.4018798-1-kafai@fb.com>
 <7535d0e3-e442-8611-3c35-cbc9f4cace8c@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7535d0e3-e442-8611-3c35-cbc9f4cace8c@iogearbox.net>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e463) by BY3PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:217::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Thu, 9 Jul 2020 21:27:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:e463]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99fb4cf2-5084-4f5f-e95a-08d8244edb0b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2406:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24060525C666C73F2307DBACD5640@BYAPR15MB2406.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 04599F3534
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esqVdFd7lebLAw4M+CY4AJW/bowamWNiTITHLjs8ahl/LOfh6697O3eLIOVbeu5k2ER30NWoK8g3JaSpMihSs8FpItV9So1tmxDMrXfUPmG1a9I+MPRTb1H7PIFfvjZ5SUt9xhf//J6+hQn9BBCEKE1pjpHByd7Ndpe4WQ+jVZpMd1wd7KHZQyY+F6t+rwnzRl6fq2En1L4Vwtdb7jWZO4zTur8WnB+ppIVsdXEdYH+hxhCQppFEh4IbXGMmFDDkV/dky/yDimxugpSPLaz7ULytx3HEEvkPumxLhTU4cpIXA2/p9G/AE2rq7NYCzbubuiZy7Kfsw1wftLWWrqjv6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(33716001)(2906002)(83380400001)(8676002)(478600001)(316002)(53546011)(5660300002)(186003)(8936002)(16526019)(66946007)(52116002)(66476007)(66556008)(1076003)(6916009)(6496006)(4326008)(86362001)(9686003)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HQXtLtqvRtsYPiuhke9k/UEE+12FMdPCXGwtCZl2hN5d08I9Pwr71pABLKq9Dvgknw6wPMmfgYN0Br5PE79U8JEo76aoOa/0l5pBUVSQ6mm9mDYmhdLR2YZID8Kfq47X1R1TOYIaq1NoTWudoepuSj3XAh8YpUGqPrm+DhJmx9t1gLHHw7U9vUteQ1tWOd2fMGw8xfEuZSsxGJQupbufxxmDZyKfteuj368WI9jYGZVTeYevINgr5gWi3humjqCPCucQwH9+oXYaSZrEMBxUOUizbJZwWNV9CzU7pDyDsf2QaHy36cJx7anFn6ZF4i4dIMBdHvIhoiGxQ9ocexc9fxTuV5JROAVLKvEpkdwkSJMQUobJJjK8Toi8goXTsuj7wB6yyuhyt4K8TK6/qH1UfzM0pCUUSy+S2h7uS9sNulCzpRoMLPcwHfgnogx2l74i3ZazDQ8MrkmowPtyxBxDqU44Z5T6zsF/gs9gCOh6cdQQ4tRWWKb5xqIhGzD+ViZsCyevsxZyfAr1V4+SV7Eipg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fb4cf2-5084-4f5f-e95a-08d8244edb0b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 21:27:17.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2RD/80muyZYxpdd4TRYvkoWR+ypc9fYsM/IM2eS4jLSYfbz7MGTxqgvSTZMSRNB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_11:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 10:07:59PM +0200, Daniel Borkmann wrote:
> On 7/9/20 8:11 AM, Martin KaFai Lau wrote:
> > It makes little sense for copying sk_user_data of reuseport_array during
> > sk_clone_lock().  This patch reuses the SK_USER_DATA_NOCOPY bit introduced in
> > commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if tagged").
> > It is used to mark the sk_user_data is not supposed to be copied to its clone.
> > 
> > Although the cloned sk's sk_user_data will not be used/freed in
> > bpf_sk_reuseport_detach(), this change can still allow the cloned
> > sk's sk_user_data to be used by some other means.
> > 
> > Freeing the reuseport_array's sk_user_data does not require a rcu grace
> > period.  Thus, the existing rcu_assign_sk_user_data_nocopy() is not
> > used.
> 
> nit: Would have been nice though to add a nonrcu API for this nevertheless
> instead of open coding.
Agreed.  I will create a follow-up patch to bpf-next later.

I had created (READ|WRITE)_ONCE_SK_USER_DATA() earlier but then noticed
there is no use on the READ_ONCE in that particular call, so ditched the
idea.  I think it does not matter much and should just use READ_ONCE also.
