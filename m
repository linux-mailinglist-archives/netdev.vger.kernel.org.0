Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C6E2B88EE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgKSAMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:12:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47606 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgKSAMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 19:12:33 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ09qeo017820;
        Wed, 18 Nov 2020 16:12:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tc2oL29Wdc23czgb3Vf0U+XeGyYclG6bhu3DTd864eU=;
 b=TAVOz2SekhZGcsgQ9rUbvp2I+7ymmcVcPiFMXTbTP+iNFqoOk1j7fTXn7aMjpQUaEK3C
 y+7fTysMJl1W2dgA9KnuUEEOdfqSCHNfhMuw016LIpr1gliV3JQtYhoq8lja+tMgZfwg
 ZgX5Fegjcy2AVU2fj2sAyQUtI/8QXbPmqzE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhjq2bbx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 16:12:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 18 Nov 2020 16:12:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPsux386a7MN+tV6LgLsBQ0hllyfKmqbfZKiKd9Ju7KlfJUcNr+uvoPFiAeBhE/p8BnmOfV4VQskgvK0YBizi4oElUuNlXlYVKsB6cJ5dL8mTpCWTINA/zQKKv68gmv94WoAAaHt9FEQQCToUhxQj2hk3vKAs/23SWADqenedO3iXaFKfE3OR/NG4VfVgQEXZx6WP2KKzp/Qr9FZHJ7WM8EiVUfXimCBoEitjn/7r+q6vcKcrDWA/RBOVUJ0YSec8ayDz/+h8HMbKjGhYzsMpEuM0uAb6MLwcjhRIxHwZRX2xqXkbsdplSqpufTBcPbFOa3XNF13XHrad51WNNwZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc2oL29Wdc23czgb3Vf0U+XeGyYclG6bhu3DTd864eU=;
 b=l+wvnXPzgXsJ8SZZE8EdS6Z/1vjEQoMLqI6euzgJ7SS7IEM6bIhDotqeZCEt3h2qpphYFA6j9XBhlgTpILtF8r+yvpd58FWYq2OypUG/+GYQD0SgTojvpY7rhFDKDL3qBnaKxV4hq5/1hZ1ANzUBRJIb16URwC9Zy4w6/TJcuv9KU5QCN0o3BgxAsg3SUjtVqqnTHCoy/rCD/L1ivL5wdNRXj6SooON0a5ra+dCA4inKfqpMA5nphQoql0yPwx6fdYk1uqac6cgXBd7ffEldx9w5/yJNIw2L9SlCXVYmTPA8wj5PHpGhHU5kdqmkFrz5VIAoqu/WWVvNAR9mrgxyqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc2oL29Wdc23czgb3Vf0U+XeGyYclG6bhu3DTd864eU=;
 b=We9/bkcoCYg4hBDf4EtvJ46qVlu2KAgEeDpX3ZuKANPFMCk7YIpfbkfjZ8q9eVi3LI3hKMChLrBA4LrWMuQbSYQZHCPWxzEf2zV7xl2ploh22iwucSUX50xG31ajtT9hKPlw3uvK0UtDXYk871HnQxYNGGeOZaXASa6P4F3/mho=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2888.namprd15.prod.outlook.com (2603:10b6:a03:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Thu, 19 Nov
 2020 00:12:00 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 00:12:00 +0000
Date:   Wed, 18 Nov 2020 16:11:54 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 6/8] bpf: Add cookie in sk_reuseport_md.
Message-ID: <20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
 <20201117094023.3685-7-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117094023.3685-7-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:301:1::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR11CA0008.namprd11.prod.outlook.com (2603:10b6:301:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 00:11:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec3b1afa-cf6b-47e4-712f-08d88c1fbc4c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2888:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2888079B10C8EA004907F13AD5E00@BYAPR15MB2888.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qo7bkQoLWWVje2NZbpdT7Wg5s/HW0DgkaaC9JqaL2y+kB8WoW8wDjIjTczoa5ErKSmGxvT94ItwvCabjlJuvevUaXqNvbgrE1Ab8vXaicyPNFATSqo1ownowzBv3MXXCrlfvSZTzf4D302I5q9qQYBo6Junm2qibOl4xB2vNJwS1AZeyFNbE/DLujINdW1CEAkd0inPiHRcohYnRmncdK4AA3f0PWjvqKw0Iy/KtYMn8uADzzF8iExRlg0krskM3xRaC+47UOnWUb7ePmQbAkYFyIAc/2NDFRksX6wDPDwlKJVKHLry0dMxnxjhnL0jErmGKbptbx3NIgb2WIMl9iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(6916009)(1076003)(55016002)(316002)(4326008)(2906002)(7416002)(66946007)(86362001)(66476007)(66556008)(8936002)(478600001)(9686003)(7696005)(5660300002)(6506007)(52116002)(16526019)(186003)(83380400001)(8676002)(54906003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KO4ek74Wnu/ynX4Ebm2uhmDonck0yUNj4iVDyIJ4orINxaYGO3OrDX73aIwLE4mq4DbzFVQpvsB0sCYHsWbh8hn2B5LYfQWQKzzhrSRt1kBwi0557Q0XPtqUCuiZdu7sDceTNhdUALQ6oQkDea1Uzk9lSfZQAza1f8J7cBIsQk1iI0i3Z+h3shldOB+ehsrrXZl+ct+2BUsKXiI5Oxe+K7fJHa00Hb/KH/Ueo1ZmYA6GqV38JgzKdihr6u4yfMoZzBb2iwHQlBu42NeriJQitLN+si4qallmjWC8t8oQJmOk/Pw/tmV/CrzkPUjrfXqRpy4OFrG7djKbLttLp4QFZegL+2Br/JFLDK3O3tKncAE2F3Kdm7PBw0SQoRBS2ogay93iAsnjUGyro7YfN6nFtfRtaENVYwmupnoGM2j8XZ1FhS3As2XHQXgPgx78Of1l1a2Y1142vHbUtvUxYtU6gm0KF07ZBjmh0JJIQcrFCc45jMivyPlEIgWazIH4S5gtKVPwhS5TqoZgF9cuFXdn7lKc0HmfagS+NhmkigqmHKgZXHsskCZME7cNEaYxAXGRuhVj/hkKSNnHHn07VoJiZZe6pwt0ZrbnuVv40Ef4t/wqAPKguRNOF8mn28/uU1LWSXZYCj++ow1h8BLsao9fFd+x/UKBXStcQEVQyotyIEqhSQrebQWIpQlc1moxIJcHZ/mUhQ6MHSNpqvesu4O+8hOgA2Sv/ujAfgAKq1sgNAGX1LJSsYdztUrbR95ucgZQlPwfDp0NBLytpixGUg664i/eu1XUOYMm73yNeCU9RQ0wikP0eXoDZachlw1zFHTxcna1L4IXaKKWcBz45TtNvDbMmeekHPgmTjiX9dSEGlXIocXMqoDHSxMtYfRo1oWDvwk8Qg7fM4ewt98jEs5NGVnOChgB7hyUt53pTToPeUY=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3b1afa-cf6b-47e4-712f-08d88c1fbc4c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 00:12:00.6794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eSMZheRY4rby7GKoRs3fDInU8JWZzIG2Pn2iJosEbpGoCW5HiuuMyLFrfN+pvu6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2888
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=1
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180165
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:40:21PM +0900, Kuniyuki Iwashima wrote:
> We will call sock_reuseport.prog for socket migration in the next commit,
> so the eBPF program has to know which listener is closing in order to
> select the new listener.
> 
> Currently, we can get a unique ID for each listener in the userspace by
> calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.
> This patch exposes the ID to the eBPF program.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/linux/bpf.h            | 1 +
>  include/uapi/linux/bpf.h       | 1 +
>  net/core/filter.c              | 8 ++++++++
>  tools/include/uapi/linux/bpf.h | 1 +
>  4 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 581b2a2e78eb..c0646eceffa2 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1897,6 +1897,7 @@ struct sk_reuseport_kern {
>  	u32 hash;
>  	u32 reuseport_id;
>  	bool bind_inany;
> +	u64 cookie;
>  };
>  bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
>  				  struct bpf_insn_access_aux *info);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 162999b12790..3fcddb032838 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4403,6 +4403,7 @@ struct sk_reuseport_md {
>  	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
>  	__u32 bind_inany;	/* Is sock bound to an INANY address? */
>  	__u32 hash;		/* A hash of the packet 4 tuples */
> +	__u64 cookie;		/* ID of the listener in map */
Instead of only adding the cookie of a sk, lets make the sk pointer available:

	__bpf_md_ptr(struct bpf_sock *, sk);

and then use the BPF_FUNC_get_socket_cookie to get the cookie.

Other fields of the sk can also be directly accessed too once
the sk pointer is available.
