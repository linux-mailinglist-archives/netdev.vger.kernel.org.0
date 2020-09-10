Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A952639A4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 03:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgIJB7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 21:59:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728405AbgIJBh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 21:37:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08A0YJwO026692;
        Wed, 9 Sep 2020 17:36:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/bmbXX8ON4+KWDnfZ0X47fHwaGcdGvuFSdKkfjBhdPA=;
 b=rSiaCP6y2y5n5RQS1+c7WuBf5ji0QQVWfLMsvAZewKSCI4meGuxKlHpJhnv2c/OqBC+P
 lAsolJWqkJ61FRJpkpPf/z2p7ob6amjSjqstOEo4X3C7blANxTAHrad+6hAl+g+mLShi
 M4CL1hOhwzEMa6GbnpeZ1xyuGlZO2fLd5WQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33efrwqfn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Sep 2020 17:36:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 17:36:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfGOVq7+IzBVKSNwW1X2iT5C41t2LbDtpeXfZ3BhbatCfcGZXp8MWBbwpe9fqAc6slCsHSF1xQ4w2FL0JT3p6PCp6qLUVUxLaTwHzsVPqqyGCxJk7+CqmS4MXS9FRjPrHGSdOZ7i5nG5+PNmZVj2RAdhQn0xJv59umV4WSYJG4weuij/FFaimOFh2w2I7OfTmRL+9c/xgysG+VTaGEzB5uKpV2DyQBD6682iH9samdU2KmPnwuw45GqZeFyXRquXLxaH8g4T4JX3euUaOfm3qXtbQC2SBu+pBcvndqElmRFFTWKi44ANsJdbbio+zZhQEkxBVLnaT9jv8F85x9HNlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bmbXX8ON4+KWDnfZ0X47fHwaGcdGvuFSdKkfjBhdPA=;
 b=kVk0ex/gwvjXVz5i6z8d2QrCs1nBwb9ZuoxFCxoEIUJbpxeoT2O4U4QkpwQQQgh7r3yXa6qzHIY1gzjxt84hmYRGhnyM83Qurgl3g9YYQzbWnmXlS2mFGCNcMdX/lr3d1AqrWhuURcNIwTxhj8u1rKciHedDWdd6ejr5TQfex4UjflrPiAvs0suzj/wQF6hvcIg9D2gJ05FPcfi+zumSvEHBEZxeNkpZOtH6u1OMRnVSEs5PTW2xwDBqonPNWMZAOIB2G8qJuVe1HZPu+GA2kb564ZhBj3Y3H4IUg57LleWEdFRpRV9W3JpxZtlNbFmZUGiZrgXmI/fKanUU2dY8pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bmbXX8ON4+KWDnfZ0X47fHwaGcdGvuFSdKkfjBhdPA=;
 b=hnohUHbqmRXCWrWgXaDQwocTeP5zm8tcEgCDFfWF+d155pixBLQ5hSalwPQh7J64uwUf6xXra2FfAoFZ7aOen5hGmyh0pPNXGJYLoE7uClAAf0rVQWX5FTzECxZzDdDmjynvJ3B/whGtaYeNPM+bZlY0NIalGtAHSha92bOvFic=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.18; Thu, 10 Sep
 2020 00:36:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 00:36:13 +0000
Date:   Wed, 9 Sep 2020 17:36:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Neal Cardwell <ncardwell@google.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] tcp: increase flexibility of EBPF
 congestion control initialization
Message-ID: <20200910003606.fvuupr56as4uknxn@kafai-mbp.dhcp.thefacebook.com>
References: <20200909181556.2945496-1-ncardwell@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909181556.2945496-1-ncardwell@google.com>
X-ClientProxiedBy: MWHPR17CA0075.namprd17.prod.outlook.com
 (2603:10b6:300:c2::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f23a) by MWHPR17CA0075.namprd17.prod.outlook.com (2603:10b6:300:c2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 00:36:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:f23a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1bbc2ee-2a1c-4c08-ff5f-08d855218541
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-Microsoft-Antispam-PRVS: <BYAPR15MB25828E2F2EAE063BBEBE685AD5270@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hRxyMg1VPmyePzpl3jgxrjF05gTQsWBjBqG378KErW8xKWakmdv10oIAFk9jl/BfatXzI5Kzdnkzk2YNriVMw5xtT32Di73NNCptfMiIT4q1RqBLRZLiH1i44u69Zi9Lwdj6ZXca5a6LB7fcP6KU6c6rWyFow9RnYYlMO1i9OIQRU/5GkrLU2RkJFsA3T5l98BlZ618Hd8y0exzY8Wk+z+31lIGk/tzJHZ/UJ2YR+e5DtBWKxYIeSmDxk+3ouo4cpmhOKzMN5hwuJi+HEe0QiKgWXL1zh12Qlt+/pYA++hXOu+le5rMaNNbOd6SaxUqrxemWO4HMlNLywN/8zTAgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(39860400002)(366004)(83380400001)(66946007)(9686003)(55016002)(6916009)(6666004)(5660300002)(86362001)(1076003)(2906002)(66556008)(4326008)(478600001)(8676002)(316002)(6506007)(52116002)(16526019)(8936002)(7696005)(186003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: y2rnwnLxVIbnd6wsQML9G25dO34DbBoSTGTQk2RsAVSvWXFOXKKCWjH+MHe1dCC/T8xk6wV66ZGMK3fPzTsr1AKQWqqoZgxYHPSsM0wqPHc7t0M5WSNXrJCCFI6dyjsKiRHSmQtxwgAUa8/kXRvToe0cFE2pO31d3lVhvWimHgDZWnDkgNM0IDtpRKGXl6PcOCMJJ+XqRn7nxv8jAUH8wr6dLctoVrsCAcP6CQi4tneErDATCTscb+ta04Oc3wv82/uVjypwmLMFwzgo9ON9WZBYsY2JedIqYfslUA87VNdnwzBZKzvlRCHm084UmHpERTgXgNago3Xo3Ahg/CuHK87EIE5OLBC8MOyUnhXuY31DUr4YO9Sk+8c2/O7SplUTAevkS3CqVh9ENhPU2w4L/SbDmf/SvYazt1FHvrq9cBEe6WZq+tB5bFBP2XkYYPh3a4iQlMfP3YnKnRqqPUOEClUDC+Sw0VmbYj9BwnoyN9podBn9CirBoZzgEOCXbEGXcGu7FQ59qgmAzzlvz4zWhRcebR+y7zp1xU8JLW3jYkoKH+teCjeEpNhpYwNhMXIpOb7xwL3m/0CwP6E9PjHu3skPHiMrF6lFGG+0CB0TRaUunve3gFWFbOOCJzgw3xH+0uT+RlTkuFEfe94E6HVoT99U+eHStLZ64iLsxLb/F34=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bbc2ee-2a1c-4c08-ff5f-08d855218541
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 00:36:13.4060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Avedm+5VUxinzpZLIvt5+sjczORJdztoU/eVT7ZRv6iPUM73xDSf4qWTyYP36GN+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_17:2020-09-09,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 suspectscore=1 clxscore=1015 priorityscore=1501
 spamscore=0 mlxlogscore=916 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 02:15:52PM -0400, Neal Cardwell wrote:
> This patch series reorganizes TCP congestion control initialization so that if
> EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> congestion control module immediately, instead of having tcp_init_transfer()
> later initialize the congestion control module.
> 
> This increases flexibility for the EBPF code that runs at connection
> establishment time, and simplifies the code.
> 
> This has the following benefits:
> 
> (1) This allows CC module customizations made by the EBPF called in
>     tcp_init_transfer() to persist, and not be wiped out by a later
>     call to tcp_init_congestion_control() in tcp_init_transfer().
> 
> (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
>     for existing code upstream that depends on the current order.
> 
> (3) Does not cause 2 initializations for for CC in the case where the
>     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
>     algorithm.
> 
> (4) Allows follow-on simplifications to the code in net/core/filter.c
>     and net/ipv4/tcp_cong.c, which currently both have some complexity
>     to special-case CC initialization to avoid double CC
>     initialization if EBPF sets the CC.
Thanks for this work.  Only have one nit in patch 3 for consideration.

Acked-by: Martin KaFai Lau <kafai@fb.com>
