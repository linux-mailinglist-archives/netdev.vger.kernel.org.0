Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC653178085
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgCCR5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:57:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36712 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732669AbgCCR5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:57:19 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023Htw16030158;
        Tue, 3 Mar 2020 09:56:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9bp7RWMVIQdfU16tB3pSaS8tTHGoDMjnBHgxQZp6fRI=;
 b=qODBHaWX/3pNoVHQQuYwjb3R3EapnIaFqIDs0f0lqGPWeCzNGCBMThEe8jN385BOJC1q
 rlXjfQXUbn95tzlgjl6pRFgzUsO+kdz/gzlaDlftjkuflOx3cqfOrg5wASE7XmPmg/9k
 TJXeg16JOktINe+7uP7YcTOeDRTriKslfq0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yht640qcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Mar 2020 09:56:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 09:56:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrBGbcne6l7m6dTnUf/yX/Mr1RgNPjsrf5gJjWFnf5hGiLTMel1Mp/5wSuBu+/7uuurQW3QYL18eZIL+yCcMVlJsR/+5OnsSeadsLoIx+Wj1JBxDStSignmJjJ00cuoJJHknSOSL4HlTE/QWvvn6n5rQ+/5vIjU8KhUnXCCt/6g53B8ye05Kh8+uh9pZgO7ncBPr8vWb5fnn5yJ1fJSwRX2eZwnG+sau6PtZYTP4bQMV51Ran/+uCzeliDFGWu7IVX9UGnV1a2lm20aAzu+WHgo9zyGc7UarI/efehm3iqB4irwpJG6ZsnuAq/mV0/G4iOzp88UUV9v/gtth6AYXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bp7RWMVIQdfU16tB3pSaS8tTHGoDMjnBHgxQZp6fRI=;
 b=n1XT+urycnwTtidEavg+q7YAZorxSlRdLepAQz8lAYFU+CzfsaQhbVSRi37N92JzWk0ZJTjQ15BYtJNLSniCbpgw36cj6ivCFesLrj0AViXBEesNp+CvmKtPwRMekrYCuXsEIAKUr1oPsmqfn4XXEl9xVV/Q/P7eEGhfoX3P7BiiGNUigIEcTauUB15MhC5cTlrZMrkTvpQetEvf6OclA1ESWvRRdl8toJeLG+Ru9ZnV/qPn7+SdzOZVgLLWQ1FOAKkfCIk1MRraDBj40gbeGNrPAax966R2JfNvSUKpDvlDjJuadqXgMs94cY1fsxWADUlbUUtIbGNU70hbHeSGYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bp7RWMVIQdfU16tB3pSaS8tTHGoDMjnBHgxQZp6fRI=;
 b=ZwB5dPujgRhT7K5NeSTKi1ZSCAQgUzNkkt5/nQJEse4RDQqPOQaGrSaKoXGsYqKLWya028AKTi/3KyFpGV8PlwvzSjLdjRJ93Lw6jxAEXA48meyyLJ2RxRkdASb5fUBTxYhMmhUALT9pee+TIgQkktUiZAXAQ8Lsy0mKmGGcz40=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2792.namprd15.prod.outlook.com (2603:10b6:a03:15c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19; Tue, 3 Mar
 2020 17:56:35 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 17:56:35 +0000
Date:   Tue, 3 Mar 2020 09:56:32 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     <john.fastabend@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        <kernel-team@cloudflare.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 5/9] bpf: sockmap: allow UDP sockets
Message-ID: <20200303175632.l6fjsbl4oa2csnco@kafai-mbp>
References: <20200228115344.17742-1-lmb@cloudflare.com>
 <20200228115344.17742-6-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228115344.17742-6-lmb@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR10CA0010.namprd10.prod.outlook.com (2603:10b6:301::20)
 To BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::7:521b) by MWHPR10CA0010.namprd10.prod.outlook.com (2603:10b6:301::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16 via Frontend Transport; Tue, 3 Mar 2020 17:56:33 +0000
X-Originating-IP: [2620:10d:c090:500::7:521b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad1b8e3b-6a51-4653-ed9b-08d7bf9c36bb
X-MS-TrafficTypeDiagnostic: BYAPR15MB2792:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2792C0CDA3D2A04346E23D0CD5E40@BYAPR15MB2792.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(366004)(189003)(199004)(4326008)(316002)(52116002)(54906003)(478600001)(9686003)(7416002)(6496006)(1076003)(55016002)(66946007)(8676002)(81156014)(66556008)(66476007)(81166006)(5660300002)(86362001)(8936002)(6916009)(16526019)(33716001)(2906002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2792;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuO+1IH/kOFHh1meJE2z6PAkPt6HoITTOFTiB4MwgghyewOyigR6zgcLosI0N4VFDhyNBJfaZt0cXFXoGecQmjLISi5UVQ3vFeBHrJUJzvSOS0ktXgVDEunf1YLabigqZGKHUWip/rsMqca2Te6QVMAXD7ftziXy55nuTjGAwNKOocqx4r6wQiokoITLx+Sf8oRo7f5mHOpDZBOuFtP7rw4O+rgSkXbYIjbYy/6t8Q8TLuMV0wsSgFqnCH2beoZBUP8WuQJnF67pCpkbNkpB+xOFb0li7gy7RGXR25o6ISPMdfee79+/QhOhh19aQQXmTZAc3eEvqV264mBEydfLaJ0LoJTf4hpsVayqnwJxIIwBl0sh0gmYr5CPkvGGAWt8zmEOyjR2h3VCAFhgFKuKDRU/ketHgx9GN9uwqPXzzMLPyzgqswWA7JO5xOES9wzf
X-MS-Exchange-AntiSpam-MessageData: 5w1kviZo6Us8eUCCEk4CatPO96kZ1QUnxI4wy6qvBk0R/tqRVnQHLaDTMNXVJPg0+ELMy+d4MW/e7isz/kgpWIlArNR6xIJxKSiavOOvhpcxuQUajA4LpJ95p9n3adr5wOJlaf6wizJjObCBnRaXr07FLfrMmiCNDXA6OFc6GR4iPX8tNIp7qzuH5L01ax5G
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1b8e3b-6a51-4653-ed9b-08d7bf9c36bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 17:56:35.3551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1xpLAny78m7F/1BSQzvUV47GSenICp6GLpl5i/U7JVcODniFk8T4yi80ErPYgUT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2792
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_06:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 11:53:40AM +0000, Lorenz Bauer wrote:
> Add basic psock hooks for UDP sockets. This allows adding and
> removing sockets, as well as automatic removal on unhash and close.
> 
> sock_map_sk_state_allowed is called from the syscall path, and
> ensures that only established or listening sockets are added.
> No such check exists for the BPF path: we rely on sockets being
> in particular states when a BPF sock ops hook is executed.
> For the passive open hook this means that sockets are actually in
> TCP_SYN_RECV state (and unhashed) when they are added to the
> sock map.
> 
> UDP sockets are not saddled with this inconsistency, and so the
> checks for both syscall and BPF path should be identical. Rather
> than duplicating the logic into sock_map_sk_state_allowed merge
> it with sock_map_sk_is_suitable.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  MAINTAINERS         |  1 +
>  include/linux/udp.h |  4 ++++
>  net/core/sock_map.c | 52 ++++++++++++++++++++++++++------------------
>  net/ipv4/Makefile   |  1 +
>  net/ipv4/udp_bpf.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 90 insertions(+), 21 deletions(-)
>  create mode 100644 net/ipv4/udp_bpf.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2af5fa73155e..495ba52038ad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9358,6 +9358,7 @@ F:	include/linux/skmsg.h
>  F:	net/core/skmsg.c
>  F:	net/core/sock_map.c
>  F:	net/ipv4/tcp_bpf.c
> +F:	net/ipv4/udp_bpf.c
>  
>  LANTIQ / INTEL Ethernet drivers
>  M:	Hauke Mehrtens <hauke@hauke-m.de>
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index aa84597bdc33..2485a35d113c 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -143,4 +143,8 @@ static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
>  
>  #define IS_UDPLITE(__sk) (__sk->sk_protocol == IPPROTO_UDPLITE)
>  
> +#ifdef CONFIG_BPF_STREAM_PARSER
> +int udp_bpf_init(struct sock *sk);
> +#endif
> +
>  #endif	/* _LINUX_UDP_H */
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index c84cc9fc7f6b..d742e1538ae9 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c

[ ... ]

> @@ -466,15 +479,20 @@ static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
>  	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
>  }
>  
> -static bool sock_map_sk_is_suitable(const struct sock *sk)
> +static bool sock_map_sk_is_udp(const struct sock *sk)
>  {
> -	return sk->sk_type == SOCK_STREAM &&
> -	       sk->sk_protocol == IPPROTO_TCP;
> +	return sk->sk_type == SOCK_DGRAM && sk->sk_protocol == IPPROTO_UDP;
>  }
>  
> -static bool sock_map_sk_state_allowed(const struct sock *sk)
> +static bool sock_map_sk_is_suitable(const struct sock *sk, bool from_bpf)
"from_bpf" seems unnecessary.

>  {
> -	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
> +	int tcp_flags = TCPF_ESTABLISHED | TCPF_LISTEN;
> +
> +	if (from_bpf)
> +		tcp_flags |= TCPF_SYN_RECV;
> +
> +	return (sock_map_sk_is_udp(sk) && sk_hashed(sk)) ||
> +	       (sock_map_sk_is_tcp(sk) && (1 << sk->sk_state) & tcp_flags);
>  }
>  
>  static int sock_map_update_elem(struct bpf_map *map, void *key,
