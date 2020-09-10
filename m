Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649F4264CAB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgIJSSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:18:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50814 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgIJSRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:17:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AIFrDa006801;
        Thu, 10 Sep 2020 11:17:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EER3p3jA5L93VpuDAo5SrrbuS7LP3Cm3cioIbKdqN4Q=;
 b=illB5+WAPB9PJ541G2GDI0a7YeNUOj9YdUXZL5fEIddO8V8iHY1g/YwA3UQcuBVpoAJY
 I6CtIRhrEoYWW+PSwU2VHmDPRvrc2YkEnzuVOqjL3vp/CjgDgEKHJep3jwFmt+CSf+SJ
 Jbr8i5jlQoeM2XkO3ERprEelxnvfnLT2DUg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33f8bfcqta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Sep 2020 11:17:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 11:17:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJYu0Z5S3O/gNdy33VZbTtvln/qkxiSAvViP1E1urxBHZhJlBb2juaPR6mWaJHM5t5Qba+NYYafHV4gw4eEDVx1QugoiTv35CK35G5BS+cSUqSKPhIgbSovJV6XsYTMdG8lxA84cRc5DNTJ5b7mnqkxJIgDrx2JsZ/HUdzsdUnub/99va4UnbGwiW5HdXNzsU7EE4zKo7n4kazo2XKep6wwsyQ4pcUHOxMScAmQ2WTTdyRdVYk7AGRaTs4Js46Am4Ji5NHHx1pZc5Sgl4NCCZXkNmqIGWWdy6pOzrxHPCVJgpOJLh3w27DZrstHlAJNPa8nqmRTKyg8NPa1Wc9LbOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EER3p3jA5L93VpuDAo5SrrbuS7LP3Cm3cioIbKdqN4Q=;
 b=QlWqEdYJb17VO56qeF4oJRZnmde2LWaqtwZWN1psGFSnhHYUjyZPennc9L2+VBdxHFcWivnFe06531rZ0lvj1mrcqwrEVkXoMyLf8dzbeWQq/g/2AEyrNiF6roskp8Lse+klZWBUTMCaEAXTKImDjWUavCCf9AbYw5NsKvCAAPpSEssVqZOAP7tg6OkCPe5ZMuBwHAOvEGm2xldWia7OrqwByBcvtjOQD2bfNyoksIUtXXqbPHm8YyKOXS+KPu00O92fOv11AgYjeLM3ZWgTY+uW5D4wiHBv7meRKzTJGsTQAOOzll5/gBIXmeDrTsjEoQK49UAi8kBESiHp/oQGxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EER3p3jA5L93VpuDAo5SrrbuS7LP3Cm3cioIbKdqN4Q=;
 b=Dj65ykm2EiRQiTqDc9Sij/bUzky4/AXBJqtPG3nr4PUDKrkEGNxIdPVTerZtQKRRxaTVOR9vHnNPgDkQCWE9pl7jNKRnHS+gvZr8XTzTcSZHgUe4i0H1Ap5vGDGBQCTVS35FjbK3SbKfgU49s8UN3aKjRdvsWgA8pkKl6FJLT/Q=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 18:17:01 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 18:17:01 +0000
Date:   Thu, 10 Sep 2020 11:16:54 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Neal Cardwell <ncardwell@google.com>
CC:     Alexei Starovoitov <ast@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/5] tcp: increase flexibility of EBPF
 congestion control initialization
Message-ID: <20200910181654.abyts7h5s2vznqhe@kafai-mbp>
References: <20200910140428.751193-1-ncardwell@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910140428.751193-1-ncardwell@google.com>
X-ClientProxiedBy: MWHPR21CA0033.namprd21.prod.outlook.com
 (2603:10b6:300:129::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:f5ef) by MWHPR21CA0033.namprd21.prod.outlook.com (2603:10b6:300:129::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.0 via Frontend Transport; Thu, 10 Sep 2020 18:17:00 +0000
X-Originating-IP: [2620:10d:c090:400::5:f5ef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a034cce0-1718-47e9-3fef-08d855b5b637
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2197B557B71D497E2C31860BD5270@BYAPR15MB2197.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cT2qpNLPNCkFkCAvmzNh7WeleKGCF1lSu47SpMo9NA1XjYNJIPlQUQzNHzhMFpIhu13Nj/gRAmadas9U6HFnkgnXpZ6BDoxqitHtr7q/9nfGhF9Thc6xap+NU9CaidmWriNj9ZQ4BzLKWUGBpoQgvbv5UW2W2Cjun70MVtGxlmoFVKGKHcsc5rYp7LTmqtI7eqs+fFhIHCQlvxBgOs1v7YFKjtXtSFNgUA9pge4kzey/5DkqM3r/ava9tr95eLxWrixnXmWXErBE40R8Wnx83tPkMDNfcFbywxxKWaZwP72H6N23rOAWEyHAjVab+Vv+kZtjOKiFGEtEXS+j8mCOUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(6496006)(83380400001)(52116002)(9686003)(55016002)(186003)(1076003)(16526019)(8676002)(478600001)(86362001)(5660300002)(8936002)(66556008)(66946007)(66476007)(316002)(2906002)(6916009)(4326008)(6666004)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mz9TX2XT6UFUSgecCCOze7KTzIoXC/ccrTEz0USNkN6gUspcCceJfAneprwgQr1ZUJwcKhn5TiKYrJM/GXvwer0ryeJrwzCpmixpFv7WelIEU7x9RkZCvZMDK1bp8nd2mu/xfvRuQRVaH1uEfdLUHPDlu61SoIt5ERBCE5chyIv9NNKsnkIHsvny8Lo8RevW6b/pZRMbT3jVt4rI17EnPrPhS800EupnvvBtj4BwpqX18DtX3jBfMMw6C7eKgWuY93xyL0Cgr/Vq88X5MzQgavsuB7UbnK0yxajlIauD2L3KPgfxyJmt9mmvn4ntU5B/XPCYz7UZCW7SWcZ2eK4A4+e9zfPifI8scpzK7K5fk0C1r+FxevvchilFD/XbmyiQJKDrGlu/Y3Uv7QdQUIlO25VNqVsTLGbEX2KxXqyxqPffbmERXPvBfrJtGy6qYU2rKhyQV74TrY5uHYNFHUhuHSoKLZpOlFA7312IaCZKEtwxHeYe6UjcEhQkEhbgRziNCd1Y5Gv0gqTSSIu5rnhK+NRjHPY1MApwn0jpM8qhoYnyxhEXqLTJTF7MMbKQsAV9lH8/j1lUpm5OmG5xzt+AIEMD5K2kCZTaVMJRWfyIOdq/+YfUrtrlzpbyVm8TE8gtc5TGQQX/cUeIfL+HVT548LIaNuEvSv89jXcxFNiEMY+0Bv2/Bsct2Gvf2zXGWX7J
X-MS-Exchange-CrossTenant-Network-Message-Id: a034cce0-1718-47e9-3fef-08d855b5b637
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 18:17:00.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WfZGbpEMse0M6TngliEDl9varteG/kqtuXc2fEH5q3E1GLVQay4BBkW80Bo6NJg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_08:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=869 suspectscore=1 clxscore=1015
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100169
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:04:23AM -0400, Neal Cardwell wrote:
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
> 
> changes in v2:
> 
> o rebase onto bpf-next
> 
> o add another follow-on simplification suggested by Martin KaFai Lau:
>    "tcp: simplify tcp_set_congestion_control() load=false case"
Acked-by: Martin KaFai Lau <kafai@fb.com>
