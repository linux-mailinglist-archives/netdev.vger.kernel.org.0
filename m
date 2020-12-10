Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376FE2D4F36
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgLJAIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:08:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgLJAIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:08:17 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BA00c5T015150;
        Wed, 9 Dec 2020 16:07:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YitOGn5pbX1t2+owttfMyIcv123G/Xc6bZz2m1Paoug=;
 b=Nwkjv/b5tzEchWLSR8DkEd33Rq39wZTIypjqZmcxMTTz7cPUS6wkeaoHi4r3nTG+y7sy
 caUBChtv/wBkHAl2AOaYyn9n8E6LHV6Zp6aMxFzQ4Z4Vy56PbG4AdoEdfTl0nLUhelRn
 /0drKDc7e50kwp7CI0BSvonifaMx3anbBPQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 35ac7qm70y-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 16:07:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 16:07:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsUNaHuvtvq2fXp/igi7xUbErT4XGsx6mp1SG+28c5V87Gh05bvWji+hAFEmHLsvX9+NmeGlVCXTEe9L5TuJ9vpKGwy4WbmMVkiMTT4JV/MHbhOGBK7B+796HOPkVLUsDHSIcRIuBaD6ODwcE+PWRPv3Ns+QXfRD+AbkSd1LnskynkiGaoru4nr4WTSAc/ozIVA4CoipTnIPOAbODoQTBmKvQdF5iu0foI9bJdbZCrFnP3AL3CUtPjyiWIFo3zaZyMGZLX4w6zQfkmsk2ySUTCA7p7qdwOjATpIPbN1/bZ+kbS5avK27uUp5fC8AHTuxaQojdMk22Z7Vcx1eGEfdwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YitOGn5pbX1t2+owttfMyIcv123G/Xc6bZz2m1Paoug=;
 b=MnmDkf++DZGQkG6Lqy/cds2Bmlle8vDHCZMQffQ3fepihFi7zUIfDn/YRrTBnwD8bIMs3hauaarzu1qAGUaTuSdhUBBCsMrL6wdxCsCazvxDsehZ8NvVU5QK9tIu15A/FXHa9vLFozKJFS1nx8dx6Hup9rP9hwhCe8ua9pCi8iIneyj1vJkZK7wGVyv9zaD6sG1jvu0SyCg6Pp8wlX0uCP2wvl94gUIZywBFaRlmTKG7EYScCGSllVIp7n3TIQ7W3sRMGa+kQ6JbaEqRiDIMKzL1bb6UbVFT0HqmnCaMtbIKc6zGJKtOdAkt3fHBizvPJ4wBF48HsPko3NK9Z/Vtcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YitOGn5pbX1t2+owttfMyIcv123G/Xc6bZz2m1Paoug=;
 b=FKdaC7z+QT/GYnIcfTNuYjNrXcdU43seWzcJYmK7auXt4vXmYnX1E87Djsq8oVnn5cYtEn79U59OyMP/tFzqVIdv/7Q42zllWmOIOo7V6cj5H/cmCln9nw5CxLyw5m1Def8GnNhct0Uyudarxmazznc4G+VlUOrWD7pkW6N1HYw=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Thu, 10 Dec
 2020 00:07:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Thu, 10 Dec 2020
 00:07:12 +0000
Date:   Wed, 9 Dec 2020 16:07:07 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Message-ID: <20201210000707.cxm2r57mbsq2p6uu@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-6-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201144418.35045-6-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:55be]
X-ClientProxiedBy: BYAPR11CA0106.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::47) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:55be) by BYAPR11CA0106.namprd11.prod.outlook.com (2603:10b6:a03:f4::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 00:07:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 393a6ac7-fcf8-4669-45ab-08d89c9f8ba4
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4087A2AA904D5AFC66981160D5CB0@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2yp1L5PcWcgmSVeZ2gnHo/ZHxC++Kybs3oXgbJaTya64Fv9/wWOrh5Bl+RckeNyCXRcoiXI1wHD2nwtTwSmG8XTWVd/AxqB1Vd2i5VK6D1gqjtw75WXjqD8voTD0M301lMWFcnNhLpNUMRTQ2eosXQ63T3Y7/qauuURNTmnsJXhoLOuTRAF+YfLVEpSFEZ3Ee34yQ76xICVjUFyUt0OZknNE4jXvZPqj2rF33m2FvLn26h3f3w2FUoDd3iKmZlPIMyJCxWYV4m7iY0okzgEXA+cu3zbLVl1S84y7GLna5+nZhOSkuO8/EpyEDNEUo8KU6cO2xa5QJN1ODgySBmmdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(83380400001)(6506007)(6916009)(8936002)(6666004)(66476007)(66556008)(1076003)(5660300002)(16526019)(86362001)(54906003)(9686003)(4326008)(7416002)(186003)(52116002)(7696005)(8676002)(2906002)(66946007)(55016002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kKbLKuOb0dVfG825Y04EJLAFL4sYK0biE8r6DVDwGjI+tj2ngzroXMoglDHW?=
 =?us-ascii?Q?ct8jbozWWk1Pk1tRppJnG4yBewdZUrPeJlsVwHr9pBvXMCDEVwo91bbq34q1?=
 =?us-ascii?Q?vZ33xd6E1LwWK8IrVba21eKU/ksCPrCFTVbN82eKgyMsRg4YGwhuqkIqb1/d?=
 =?us-ascii?Q?SJJdYaS5368qiGk4KdTS631yY3k9xVfU1bccQ/M5+Arc+81JsibDy/hC2AwD?=
 =?us-ascii?Q?35nQ09x2tsR29RM3QyV3+h6XHS3xCJo1ReZgne1Wv5djyXXwnhbJdvEsEdGa?=
 =?us-ascii?Q?zI8eXpeFe7p0hxZKUMDNSpfCzZQai5ymV6RtEIvLF/BtjO4ckuVJW6q00p0+?=
 =?us-ascii?Q?GJFZ0Ba59cOfC98tslcKEtJKqwaacdi7VREPQn8Eb6R+vYjmkC7c/qgdC+zL?=
 =?us-ascii?Q?rEAB1Yu9g3uyJam0SyS4/xsXIXucPBBoIErd/MjP+BMu1JFHGmKKesBlAXAQ?=
 =?us-ascii?Q?hZEWOXDYQPSeRBPHiAASxNO/oriJ0s4Ee49zuWusGSFRrFJzq7+3LWuUKbjb?=
 =?us-ascii?Q?pdmiaButWSJB1d+JpSnB7txLrMaFNQXWIG7HIX3PBUM9swp1g8AfmW9Hm3xD?=
 =?us-ascii?Q?0T0StSgWoJkeRO+0iOJ/Hjx4CrNR3E8n+TsjPHF3lk02VZ+ABBtKa7BcTbtm?=
 =?us-ascii?Q?vKZIFhs+44lB+KwtAGwOEfrtoD9I9++QfzhoFAcbwn0UfHo9CZ9mJrAQ9hH+?=
 =?us-ascii?Q?ebnAY4UuFAke6EVwLLkFyeQGzTYyKhab1wNyklrCNZTCxXFXVHwclC47qcsJ?=
 =?us-ascii?Q?DiW3Ahoi/GdV5bhpfhbtfwU+jGuNEcNj6ORNTo6p9ZtTLAKr3cvKfuQ4b7D5?=
 =?us-ascii?Q?JpVGBTPpqJKRLuHHnXEiejAVff0J1/nBRfaW7AdCTSYZ8PIdGwvCBlzj2S0U?=
 =?us-ascii?Q?1vUGRTYExzJFy3/GSK2CEfAk0Cs/d5qoVDDia3tx9xUq5+XDmoceEeDC2cn+?=
 =?us-ascii?Q?IYX5Hr19H59Z+Z7VR2QwH54FjuX+3uynRm4IplmOJG8jWGySIWnhWgzi7xHL?=
 =?us-ascii?Q?axlWUHK8KV3UqZZOjHwy9wwVSg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 00:07:12.8187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 393a6ac7-fcf8-4669-45ab-08d89c9f8ba4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jykzFuqjOOAzRqVCaDnihq/Zlqq3kYssILL3OYxVCEbue7TgrlY0N8YpNjV7Bqxv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_19:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=1
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090166
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:44:12PM +0900, Kuniyuki Iwashima wrote:
> This patch renames reuseport_select_sock() to __reuseport_select_sock() and
> adds two wrapper function of it to pass the migration type defined in the
> previous commit.
> 
>   reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
>   reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST
> 
> As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
> requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
> patch also changes the code to call reuseport_select_migrated_sock() even
> if the listening socket is TCP_CLOSE. If we can pick out a listening socket
> from the reuseport group, we rewrite request_sock.rsk_listener and resume
> processing the request.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/net/inet_connection_sock.h | 12 +++++++++++
>  include/net/request_sock.h         | 13 ++++++++++++
>  include/net/sock_reuseport.h       |  8 +++----
>  net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
>  net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
>  net/ipv4/tcp_ipv4.c                |  9 ++++++--
>  net/ipv6/tcp_ipv6.c                |  9 ++++++--
>  7 files changed, 81 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 2ea2d743f8fc..1e0958f5eb21 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
>  	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
>  }
>  
> +static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
> +						 struct sock *nsk,
> +						 struct request_sock *req)
> +{
> +	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
> +			     &inet_csk(nsk)->icsk_accept_queue,
> +			     req);
> +	sock_put(sk);
not sure if it is safe to do here.
IIUC, when the req->rsk_refcnt is held, it also holds a refcnt
to req->rsk_listener such that sock_hold(req->rsk_listener) is
safe because its sk_refcnt is not zero.

> +	sock_hold(nsk);
> +	req->rsk_listener = nsk;
> +}
> +

[ ... ]

> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 361efe55b1ad..e71653c6eae2 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -743,8 +743,17 @@ static void reqsk_timer_handler(struct timer_list *t)
>  	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
>  	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
>  
> -	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
> -		goto drop;
> +	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {
> +		sk_listener = reuseport_select_migrated_sock(sk_listener,
> +							     req_to_sk(req)->sk_hash, NULL);
> +		if (!sk_listener) {
> +			sk_listener = req->rsk_listener;
> +			goto drop;
> +		}
> +		inet_csk_reqsk_queue_migrated(req->rsk_listener, sk_listener, req);
> +		icsk = inet_csk(sk_listener);
> +		queue = &icsk->icsk_accept_queue;
> +	}
>  
>  	max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
>  	/* Normally all the openreqs are young and become mature
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index e4b31e70bd30..9a9aa27c6069 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1973,8 +1973,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  			goto csum_error;
>  		}
>  		if (unlikely(sk->sk_state != TCP_LISTEN)) {
> -			inet_csk_reqsk_queue_drop_and_put(sk, req);
> -			goto lookup;
> +			nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, skb);
> +			if (!nsk) {
> +				inet_csk_reqsk_queue_drop_and_put(sk, req);
> +				goto lookup;
> +			}
> +			inet_csk_reqsk_queue_migrated(sk, nsk, req);
> +			sk = nsk;
>  		}
>  		/* We own a reference on the listener, increase it again
>  		 * as we might lose it too soon.
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 992cbf3eb9e3..ff11f3c0cb96 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1635,8 +1635,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
>  			goto csum_error;
>  		}
>  		if (unlikely(sk->sk_state != TCP_LISTEN)) {
> -			inet_csk_reqsk_queue_drop_and_put(sk, req);
> -			goto lookup;
> +			nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, skb);
> +			if (!nsk) {
> +				inet_csk_reqsk_queue_drop_and_put(sk, req);
> +				goto lookup;
> +			}
> +			inet_csk_reqsk_queue_migrated(sk, nsk, req);
> +			sk = nsk;
>  		}
>  		sock_hold(sk);
For example, this sock_hold(sk).  sk here is req->rsk_listener.

>  		refcounted = true;
> -- 
> 2.17.2 (Apple Git-113)
> 
