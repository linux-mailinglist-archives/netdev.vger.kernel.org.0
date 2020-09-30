Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41E427F3B8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgI3U7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:59:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3U7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:59:14 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UKwr5q020608;
        Wed, 30 Sep 2020 13:58:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LxGMTWg7uvgAuvpHPx5/yQtr+v9AYxWFQ42CreidAX8=;
 b=CLjGNPxtAdE9Wd376jqv/DBdmMnCvQ6+YRZy/mVq+ks78nNRdV7/ayAA0Et569B4Q9cB
 T+1x6EPlPREHfXRYAo96P3+xVT/a4aJRGgmGiu5pu6gQggfnyslar6tM8RBktRUtF+C9
 1mmxgTgve9MGWVjgig5xnaUsGYcIFsHClZA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v6jxgcej-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 13:58:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 13:58:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meSXbmQxMcMnnspyGTQKuFGAJ0w3W1mojlHxYCiFhYs3Bzv9FaqSK5eTbVMtdhZg0qKd0u+woLJ/fNZTXqQxJjJtJocC8gKP3IXn/khVtbDMAKUcqsUzE42cfa9Al09x6utF15lNVdjkcGuMj3agdcC6yxMoVzs38Lj/pqgrFgM02ArEEQoB5qRLGBQuu0IUUhm350/l9HiyFLfAU1+eOlLBPO2M65vA+y7atf4Nes9grDliWwmmolt44irWLmfO3SKj2QhOuKd/vfhb5ZgSShb4/EI53wtIT3zoYYUqLrDg1m5par6Jx0sx7H/vyOpMvMG9F9+49HwFxDEwsyGTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxGMTWg7uvgAuvpHPx5/yQtr+v9AYxWFQ42CreidAX8=;
 b=fX8GiMVyFBW4bCoJtHCQmJshKG9hMxkKmp04rOrjtqtqS9ikC+F3/eJANPo+xG8F6CAU7R5eilRgR+5C8qyfzyOXY5O3Ihs2HP3xPGu5/7ZSSPPpRlnpDd5LTlHsuLRzTFe4XADaogKW7CahDXOgGcUoV5gMv2wPcfG7c7DUM/4zwXlrQn46iO7G2+cTsX8+ERO92NhcDQTHTjpdxeVlRhAGE82Vc5+6es3FvFdqi8GWeZptNZW8BojPiZI7n2oH6UDiMIHGbbvTUiz8Q3mLU4cPlkGM8u2O1u+Yty0BZ1iqCmZ68g5i7+ZXD2ysgbQHB/ETBOPm7kVmnZYPOjaocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxGMTWg7uvgAuvpHPx5/yQtr+v9AYxWFQ42CreidAX8=;
 b=a92qJZZF9vlx1b9rIQGaDAsv/YeC7ybAYHl7VjEHoCR4n4reOCkj8MLrDLtGskA45tVtXTCFiLC0v83Z7hP9EKI4OcoVwp/HIMa0RYr9ZKfnY5KwcNA3tDU40VfS+fuUEZPXujXyTjEmuFh18Qohme0WED36BDXbESNuweq8Z8w=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2261.namprd15.prod.outlook.com (2603:10b6:a02:8e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 20:58:54 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 20:58:54 +0000
Date:   Wed, 30 Sep 2020 13:58:47 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH bpf] bpf: fix "unresolved symbol" build error with
 resolve_btfids
Message-ID: <20200930205847.7pj5pblqe6k6v64q@kafai-mbp.dhcp.thefacebook.com>
References: <20200930164109.2922412-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930164109.2922412-1-yhs@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:300:ed::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR20CA0030.namprd20.prod.outlook.com (2603:10b6:300:ed::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 30 Sep 2020 20:58:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49ce58ad-fcf5-4468-3e76-08d86583a3f9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2261:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2261D6D96BDFD6BF9AE61FB6D5330@BYAPR15MB2261.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +C5LSzbRVC5pMNIgiOrYpyhK5o3W2sKipta8r3/VOo1PavL90oOzBgATnsp1ozoSa41R3qWLssvhcES9WwY8P7/lGKBweeKNNoKWX55ESY5uyv00d32L+2NV+XMQ9KbW2V75ehRK6R4oYe6J/DImMY73bTuqNuhyUDC9Yh2MCv4f4TpuLA5rWaFg3CtEotZ2Cw2S2mAPnUe7jmkU/qAm6VibDYiVyITm7pSyUmifKWkFQJoBK8lOiXVHuncQmcPAbCO6IbnAPKhjjxVvO6ufqPZs/LSpwXHiluoGqmn15qL0kTg6W7mY1mVXVp+w2O4fCltl1QtbgC+MgrgJ33tKxZG2r1BKaE5j4RHMVLeEsTrw1jGY/gZ7NLm7cJbfaFl87KueljKOYZSP03/sCY4BAA9vdx5/XRlCMc7IVDs8fdU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(6666004)(8936002)(478600001)(316002)(54906003)(86362001)(5660300002)(66476007)(66556008)(66946007)(2906002)(83380400001)(1076003)(6636002)(8676002)(4326008)(6862004)(16526019)(7696005)(52116002)(186003)(9686003)(6506007)(55016002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ysVamsDs7a1BvTIopMkc7CvM9baIJO3+gK9HxK/VBuGKvV+YC5ZIx73iSTSNxp9ZcBUlc5AGb7P702jdIerbdGGvbTMKRE3JNQ/WKRpqw0py+RjRT7fvi5jgIA+47V3ZzImdvDqZgROVfBHjiqjZ/TMX4/1n2fs5g1Jtp6NJLIvEapPtmp31WDzAMQMspKdzv0vVCajJBO/LKHsyqZmxqOkXkLchC0MW/gCP84+YwZTYj4li11KJ7Hs5Usf+Iq+GEj/y14oVyIUWUGmd0FwRE9BY02I67T/Mg7wBMJ7XXMZ/sCCpFCRLL/xzOAttPOlmtveP0I06WeW1GZzhLxV82sqDRZlFdh3yibnZqQx372JOwtnEJutq/XIRVH1CA/6gFemPsP5urwZ2evTkk5E1eGbpOJCi/4cWNmTpiBB+hMLplr/CBS06iyjCEJT7w/Dgj4QAHw+7FTaGYNhDb0rIh5RO0CXZEXFpnGax8DwHYsQyhxVeUWxWHGkt/aAYq3hFY/HGUT9GTKuKCDzNaJH0gEcJ4B/q/K+kbna15yRVsgq0GtE0gupav6hm731AO4GVTO/HvHKO1theKF6YAK442L2bxScuiamEXTeQA8m94hbFssQxThWdlHAYnwkPmBgZVycnb5u5+n4l96RfOZJLmRfSS0Dwc9iluFthrUCZrVOT/iQ3ZxPJbvwVjuApb5bB
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ce58ad-fcf5-4468-3e76-08d86583a3f9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 20:58:54.3894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17EL25c5tdWnZl740vR2aTFPOwVcecEURsMf06kUaqqRWNqPtKwoXrSQrplitsO7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 suspectscore=1 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300171
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 09:41:09AM -0700, Yonghong Song wrote:
> Michal reported a build failure likes below:
>    BTFIDS  vmlinux
>    FAILED unresolved symbol tcp_timewait_sock
>    make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
> 
> This error can be triggered when config has CONFIG_NET enabled
> but CONFIG_INET disabled. In this case, there is no user of
> structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
> types are not generated for these two structures.
> 
> To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
> macro if CONFIG_INET is not defined.
> 
> Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/btf_ids.h | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 4867d549e3c1..d9a1e18d0921 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -102,24 +102,36 @@ asm(							\
>   * skc_to_*_sock() helpers. All these sockets should have
>   * sock_common as the first argument in its memory layout.
>   */
> -#define BTF_SOCK_TYPE_xxx \
> +
> +#define __BTF_SOCK_TYPE_xxx \
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
>  	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
>  
> +#define __BTF_SOCK_TW_TYPE_xxx \
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
> +
> +#ifdef CONFIG_INET
> +#define BTF_SOCK_TYPE_xxx						\
> +	__BTF_SOCK_TYPE_xxx						\
> +	__BTF_SOCK_TW_TYPE_xxx
> +#else
> +#define BTF_SOCK_TYPE_xxx	__BTF_SOCK_TYPE_xxx
BTF_SOCK_TYPE_xxx is used in BTF_ID_LIST_GLOBAL(btf_sock_ids) in filter.c
which does not include BTF_SOCK_TYPE_TCP_TW.
However, btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] is still used
in bpf_skc_to_tcp_timewait_sock_proto.

> +#endif
> +
>  enum {
>  #define BTF_SOCK_TYPE(name, str) name,
> -BTF_SOCK_TYPE_xxx
> +__BTF_SOCK_TYPE_xxx
> +__BTF_SOCK_TW_TYPE_xxx
BTF_SOCK_TYPE_TCP_TW is at the end of this enum.

Would btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] always be 0?

>  #undef BTF_SOCK_TYPE
>  MAX_BTF_SOCK_TYPE,
>  };
> -- 
> 2.24.1
> 
