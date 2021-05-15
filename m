Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FDB3814E0
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 03:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhEOBOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 21:14:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhEOBOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 21:14:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F0mEV5010858;
        Fri, 14 May 2021 18:13:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=c3JKaMg5a1EN+/TuiQdNFqF6gHGgR1m/MtZODWcJaGY=;
 b=D4PDyV7sTDaV4QZMh4X2jqGAINxF9QXp0Wk7SIwdHEwrDsxQ+SgBvN5Hnk4UrHsg1Fim
 dUVIyyE9rxZp2oKZ5CMpvVN0MjYpED8y9Eykn22oVBx46+n+Tf4oYanhQzMcDClItx0G
 t457+f3TPmJb7wG8SFofAla17CCBVQzJlbw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38j1gtgp4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 May 2021 18:13:12 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 18:13:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdedH5XzVj9tIqiwqjDi7DMHDQpxsnvvSKOL3B8uk0z+Go1exxmSv+5vmiXe7FtDTcqEBeU65t0LahHfDB/FrLUHL+MkMpLJ3Zimb6qMmPt+CFRPDm2GqxFTx5TPSMLSMFrWziUYOzFzBN4UuXiXDBAfnOhOS2o4fNjPQBsBHtd+6Jkmk3UiJzBkFLX0fFTls8x68H2TS/GJrHVS7V0g5V2qAksfgAxLsMfjtrfuAMoRThjKrWIt8u5YMZQ67+eiveS91XppXgu+pomQjvHVu7WliTk5adn4ulYGN8ITdz0Is2MTN1r4gbmGtMMw9dYQbBKRVdafE8cRLkw9lpBQMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3JKaMg5a1EN+/TuiQdNFqF6gHGgR1m/MtZODWcJaGY=;
 b=kN1okJFV23EuwEaKeT8HQcAVUyi65bXBThrTJS5+4Q+5yKRunxHa3O/bsT2Jj6v0Y/YfHiNtW6UGXyscaTHccu2wZBqufAjyGVXlvXUmeh0cA+0ZVQgKqFWKPG2r8AhGmciS2/4WuqK3scECJslrWS6F+tKFZ+4H+eOQwLUt0qA4BQfPdGKeIY03PBhXLUiQKyXvLouvI2PwXWFSQvTX7noPJP/PJ0KurA2O5nf0/tIQXIgvykjcypvDVsS3ht8LnRjXncTeBED2K62W4ZpG/wtVJJA8vzxBJlWUlISP0PgHWL5ymPgKWpr5C8V4hulJYQOyjpo85a1lHL12w4mPfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 01:13:08 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 01:13:08 +0000
Date:   Fri, 14 May 2021 18:13:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests
 at receiving the final ACK.
Message-ID: <20210515011305.eeblnqnov4xlcjfy@kafai-mbp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
 <20210510034433.52818-8-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210510034433.52818-8-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:717c]
X-ClientProxiedBy: MWHPR19CA0056.namprd19.prod.outlook.com
 (2603:10b6:300:94::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:717c) by MWHPR19CA0056.namprd19.prod.outlook.com (2603:10b6:300:94::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Sat, 15 May 2021 01:13:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9016737-c652-4bb9-6ba6-08d9173e99e0
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3192018EFC85D38E477FB8E4D52F9@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUYlQ9SulVEBIW4k7ND9w1CarUNiBXcSxhNrdzrMt323LCe0hCqV6PyCXtVw66rJbk/eDTmSYKAN/xn/S6rI76eV9AQUBqP96JIUUDyvi1Kzulj1p0DDMxHSCOVMrfz8ioC6ggYrxQzS23CjYcqcSMUkK95hpF54vHLmfn3fhygl/Bi0j066x9P1fGWr6stUFiXVnjsWh/9sP9WrbHZPnfi3YhtzJtfkMpvymp2aw/P+YmK6kEzrPyc4FaMR+L6ShlkxTS0N/ryz9HVHtDptFf2A/X8ZfVhwV42llafbQHOKLdUq3CHnPgT+NGXyHb5nWit7KSqTjpa+1bLqe4t8TCjPuuAzAQOr0AAC/onR7XweksJzdgmVZnpCVSSJpLt9AyisvDRqdCf7K8NOLQ7ulTirFIfsGNkeOiqbUjJriNHT76LTnV0pQQMZZVTLI2jhjxItUew3swABfGG75elHpXyAUccewoJp7lrdQB3r9WU/rBQ8AX4Lg7QJlFhCC56VgSUDT8n2gORoMfU9mZRnXN0B07IfZjTNSydVEicAePWEdkcS8/A97rdw+2Ts5XX9siqWVKbhdbft31eLVtjMzBimMTrp6IdOFANBkMIgLf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(38100700002)(55016002)(5660300002)(83380400001)(7416002)(1076003)(4326008)(8936002)(33716001)(8676002)(6496006)(66556008)(66946007)(478600001)(9686003)(186003)(16526019)(52116002)(6916009)(66476007)(86362001)(54906003)(2906002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xDThUDd7CBYht8hLn/9yCw+btroFmlBbc53ttUaiGqjhokY3Ne4PHg55O0P1?=
 =?us-ascii?Q?7/Kb1wAi7JRxTNrrMiEs4JutLUXOlhkU4xhD/38h/vxybfH/FFosZ3XrbOF8?=
 =?us-ascii?Q?3bSAj2hTrOQUMfvQeAFCJKnxZ4a6lJ/rBMYLA633EyU/kpNQvNyYq9vPJePw?=
 =?us-ascii?Q?G88mL56QxbFVdomrxEGFKOSgRiFBdJoNVAx2gLBAxwrh2xwcXtw+RnqTSaEn?=
 =?us-ascii?Q?MDyKCGohnjg4/+uwPxQrQ96BgQ69yZY+EQNS2qcwHwsef57+SkydcGpbk82I?=
 =?us-ascii?Q?Fy8Z1UaSHOJekhEImUS29Qyg7JWvSN+G8dQVAsB81yY0rBsZ/AZedsGNrYII?=
 =?us-ascii?Q?ioLb4a7xy7eSe7ksQrwMvWlsAZMlZvdveu40mKdtwX/1UA5XxOMM8S3wifH5?=
 =?us-ascii?Q?9kXK6sLqeTfsmPkfX/62TfIC+Vod0zWU/SpDvUZBRLTTenT0WjAXKQwyO4LM?=
 =?us-ascii?Q?3CbXqUWTOUgQ9wJitxTYMaPJ4qmc0B6M/HkwichV1MV8M7TEO41YrcpDhubX?=
 =?us-ascii?Q?I8CQAFMjLpS9RuU/J0wcSsYhFepQ1QOpsqMOgPCfltnphehRo5xTe1dLfsya?=
 =?us-ascii?Q?GlOPRIeR26N1SJn8c+X2QABUwAWzNUARHHGowuNbNA3JwZUgfZ6rCXFBrFAE?=
 =?us-ascii?Q?lzL7F7fNYs/5iYz4GCxJ5qc0lDRPFgkDQ8kx7gpcXkl+cKPBRC54T42ll4L8?=
 =?us-ascii?Q?KLT6aOYNWlDFEP/CRXHeuMRyudeC0mM8iEO1IXuKcGHPcHh/2LU3nLNzUtcX?=
 =?us-ascii?Q?YnFitVgbkr6gE0tMrhOUzQpwBgH8rGgQ6kr0qjjQdPPZSKZI47gzmeWIvPKb?=
 =?us-ascii?Q?LvA9hKBbDPvjrqOaWJ8zMWvK93KXRGl802zUyjeZRzneQgmeice/z17BfI+k?=
 =?us-ascii?Q?lYelHCVe7e9kcV9nugGGgNeE5Dp1SEGccPEm7ksLoQd50SG5a/Rhn4/fDyHg?=
 =?us-ascii?Q?k1saGVWxKrvPYn5nH0kXZZ64Qw/mUZClwDxWcdHr/kRmGI9QiTWX0Z4qPyVR?=
 =?us-ascii?Q?GFKTY2ik3tzb0czTx5FQ9DiOnT1mpx/1EitcygjePdTXbp2AYsWvl9AejEZp?=
 =?us-ascii?Q?JmwI9D2TmkPVtxvdAA4QED3CWUL3PkmbsTA8nnD0NEtOgs16VzzDKupEyHWS?=
 =?us-ascii?Q?GgFL1d1JSFTAPMY9lEAy659uihShCVyNZN2L1983Bx8neqlqA3cYqcm+VpE8?=
 =?us-ascii?Q?Cr7MfelVgA93aOMq6zvgZXeElrfLLGnxbvxdjDT4CjirZmKKHi+Sd7ekg6w6?=
 =?us-ascii?Q?feiN4srCWhfVCvUNQquAq2/mCnis2TcEq8CCvyplEsq0U9Xx9tuzASmQWYkO?=
 =?us-ascii?Q?ejGB81HleHrZW7APsHNieOu3l1IOXNDDRGYdywkl8kkHVQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9016737-c652-4bb9-6ba6-08d9173e99e0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 01:13:08.8217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgeCRsDzt+B94K1kO2FNzjUZ7RBMZ9w2av/t/nZZkMeOg0VjzgeU+bqjLunaci85
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jnOOj7Bb2MT5xsNYdbPHbT6CsM-RoCBb
X-Proofpoint-ORIG-GUID: jnOOj7Bb2MT5xsNYdbPHbT6CsM-RoCBb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_11:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:44:29PM +0900, Kuniyuki Iwashima wrote:
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index e690d1cff36e..fe666dc5c621 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1075,10 +1075,38 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
>  	if (own_req) {
>  		inet_csk_reqsk_queue_drop(sk, req);
>  		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
In the migration case 'sk != req->rsk_listener', is sk the right
one to pass in the above two functions?

> -		if (inet_csk_reqsk_queue_add(sk, req, child))
> +
> +		if (sk != req->rsk_listener) {
> +			/* another listening sk has been selected,
> +			 * migrate the req to it.
> +			 */
> +			struct request_sock *nreq;
> +
> +			/* hold a refcnt for the nreq->rsk_listener
> +			 * which is assigned in reqsk_clone()
> +			 */
> +			sock_hold(sk);
> +			nreq = reqsk_clone(req, sk);
> +			if (!nreq) {
> +				inet_child_forget(sk, req, child);
> +				goto child_put;
> +			}
> +
> +			refcount_set(&nreq->rsk_refcnt, 1);
> +			if (inet_csk_reqsk_queue_add(sk, nreq, child)) {
> +				reqsk_migrate_reset(req);
> +				reqsk_put(req);
> +				return child;
> +			}
> +
> +			reqsk_migrate_reset(nreq);
> +			__reqsk_free(nreq);
> +		} else if (inet_csk_reqsk_queue_add(sk, req, child)) {
>  			return child;
> +		}
>  	}
>  	/* Too bad, another child took ownership of the request, undo. */
> +child_put:
>  	bh_unlock_sock(child);
>  	sock_put(child);
>  	return NULL;
