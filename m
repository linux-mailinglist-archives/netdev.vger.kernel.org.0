Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F8A443979
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 00:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhKBXU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 19:20:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25504 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231304AbhKBXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 19:20:24 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2LaU7b016313;
        Tue, 2 Nov 2021 16:17:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kQ88uqXDYdnGAvk2nORgNASL5pmHcRrOARuXTv2NyjE=;
 b=NOrd0OALJN4RIu9xIcJIJOs8Rk5C20cnXrqDMWYV5QJfIzpBPoNAaJ7E3y7nT2N+p68p
 03/m010Q4q/r/iWJTn3/heYaEgaEg55RgoKSAUjdIz3wj0Lze4yr+inSKtzzwyell069
 977gYczUW0Ej66nHCIRz7polr1GRinirCgA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c3dd30n81-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Nov 2021 16:17:46 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 2 Nov 2021 16:17:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYiOMQfzKaUMlo4rygzp7KNlwpNHTw7azgDGj8p8FrnTZYr8JDv2XEppzrSNY4cu4UYdyH0bODYitoY38m34GIi2IyMMrf+XqYSz4SL1pCElr6fMp4rDJNV+uYkG7l5VO88GOdyB8kyq8Ek80JYmFv/+O4wBuFAaRBp1aM9IbV1cTSX0BBl7cw2F4WNqWzFiyoP+Mx6SUcqdmj16+UnWmO97FqU3XzexMr2urtyztGSo+UFeBHjJTs2iPs8pVrufNgCA3oeRb4G/QAm6OxJbd4Du12pGEfhDb1IacxrC7urXncrwv3MmSYznK9rw+KTI2wKvHvjLwNZQvO6bMYC1cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQ88uqXDYdnGAvk2nORgNASL5pmHcRrOARuXTv2NyjE=;
 b=i50PR/844Kkk1SsFlSJMV7a2L1GvH0ImfYzDMOzSQjxjs7PPtY+jyF11UoC4iROHvocl20117uFnybr8ea0r68DOZpSBdLvMQ+inTd4f2W2m3XZdpkvMadgyDPLklbsrkGkc6FG/JSAhcnb8CP4ZS/LFckb497UhQ/Jens+KjH+aid+Mtuo2wH0TNfir3kin/UK38mjnB4mB+iNAL+uBaHozrVTGLGmZK291aJqjnn68w7P9h80+r82e3dmlBSwu23wKUNjSaUHNoBCeRtqCSSRYfjCYO1au4nLsgSBSaO+wlxPn/Svd9+6V85f7HfU2g/6YczF78kr3v0dvvU37Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2349.namprd15.prod.outlook.com (2603:10b6:805:26::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Tue, 2 Nov
 2021 23:17:40 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 23:17:40 +0000
Date:   Tue, 2 Nov 2021 16:17:37 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
CC:     <brakmo@fb.com>, <mitradir@yandex-team.ru>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>, <ycheng@google.com>,
        <zeil@yandex-team.ru>
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20211102231737.nt6o7jehcm7qzjbx@kafai-mbp.dhcp.thefacebook.com>
References: <863fdf13-b1f4-f429-d8ac-269f9ceaa747@gmail.com>
 <20211102183235.14679-1-hmukos@yandex-team.ru>
 <eb593fea-b5a5-c871-a762-a48127e91f75@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eb593fea-b5a5-c871-a762-a48127e91f75@gmail.com>
X-ClientProxiedBy: MW4PR04CA0374.namprd04.prod.outlook.com
 (2603:10b6:303:81::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:20d) by MW4PR04CA0374.namprd04.prod.outlook.com (2603:10b6:303:81::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 23:17:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d89079f0-4bc3-4db9-b49d-08d99e56f748
X-MS-TrafficTypeDiagnostic: SN6PR15MB2349:
X-Microsoft-Antispam-PRVS: <SN6PR15MB23492A472F9512427EF25449D58B9@SN6PR15MB2349.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/fFPFBMUQ8Nd5EBHkUP/N0jfcRO/bAy2U/8FVJF4PXz08+/d7f52blbaWWRs8iQS83ezcxpqgk2DWyMO7Xc+w22X1gzJ7SqpCbzdBe/H49tfjXuXblkkz+fJbbnv07GqWu0vG0b1/2JxrEKJcBbWYxIw42SAXzhH2hPLf4KZ/S2UTlfUEoDLntQSHa7M5a2pGRB6T7D+eE/RLPSXVYxjcrGUKNYCkMG7zuhDzzTqXna6Ydf20nfX/Gm9N4cR4tdfFGUZq+0d+wUBnSzeObdqkmn80bIAQ995Zu7hW2rQHm1JMeAQOIpgv0sZD92gh4QIo0yUvqcvgeBfJINxZkcydzCZk1zsjbI9ZSRC+wslMdpGM8tTWcz6vULZsdmuSPpC2t4TDywqG6WDKg3aA0AjHvXP8iPXSwHoa6SHKSwXQevTVxAmbMys0LPeDg53/Pa9pW6mhze0hglRdyqbzXuO8bemWQNJ89mGWLdqYek708Ua+CbuJF/9s+jJGZKYNSEUy3JaEJpevJ+Lwqd6PPW2dGsx9zJRTIRenR4xUjqwUg5HGmCqcsUNzwbvr1msivMsROVIn6tRvGw38km1ExuxrSW7/hRB1ASVAIGIKBzW8Ef38sqIs4jIzsep7eJa0U8TFQPuiE/U0ImYO0SEUAOsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(83380400001)(508600001)(4326008)(9686003)(66476007)(186003)(8676002)(66556008)(66946007)(8936002)(1076003)(53546011)(6506007)(7696005)(52116002)(2906002)(5660300002)(86362001)(110136005)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nM0C9EwpzmFIi1charDkfAG2extZkz6TPghryifrLW8UwXI7qSu0v0S1bbwl?=
 =?us-ascii?Q?J3jj1lRAxnFceitnBdevs6YbsxKNLcu5uMqsQiljZUGl29+hn/jsQxPUN6XD?=
 =?us-ascii?Q?Q3Ocv3u68rSeME0UqThZaE+8Jx253a7lGWQc4U3G7PPQlKTRN/5s06R4rDwm?=
 =?us-ascii?Q?8LSYFmRSL/OmZz9mWcG60QaLP56HU2LkjQGhkp2vrKnVZpStrz0XYJC8C3Vq?=
 =?us-ascii?Q?vaSUgQgLdxZLF3Aadyws24M0wiyDvwU0neHar2Ll+LyQ0VkG/cMEUildXPJF?=
 =?us-ascii?Q?8JLaC8IuanWTxcrtATysAmQFfP7g4oBDZEOhfmGXz2USbtPnowZ4woqjzBL9?=
 =?us-ascii?Q?Cvr8xXwi/Bc3GAI97agaHM3PsgIKV3zvXWS2k8DAZqKgpJXWrAcP5FQAw3qQ?=
 =?us-ascii?Q?NUhq4i/ye6II6lEuEKbTeXH2KFenJnlHNAaSeEYxoC6K7WNLUbnY10lovOvf?=
 =?us-ascii?Q?2krtlWrdTc2H7C7FNM+Av84VJdnSW4IhWl6xyCKl4mzHmCaIpHegScjvupJP?=
 =?us-ascii?Q?9NITJAileI/54AP491Aa/3rsRWU+/lfLRdb2/WqjDzg6TBgWoyZ8MoIAJVxU?=
 =?us-ascii?Q?HgGzqX+n7sAJ/8orp8UcXB5y4aI/KxXOfGOt6u6talCPh9SfIrbHEMaHMmlx?=
 =?us-ascii?Q?lPilaSfnVtmzanYUwGQ8wAMzxs0terzCW8ZMEJ6uGAqwXG/WQmXfSZEvlCZ4?=
 =?us-ascii?Q?dU2K4lQCgjnJn61a6FbJvvEA5I1K41/qyZ5cUS2i14Cado58hcs73YGP0MoK?=
 =?us-ascii?Q?WmaizUjND5Rl+T5hLiKZsRTuxLp8ZZ8DDgBq+tn6EVSZuhv4Ecx7EMDj/Qq/?=
 =?us-ascii?Q?O0J1zVFReejKHcSjC5kT0GSP4ofH5G+1jCpicquwExjpF6obNtPEHRfZ98DS?=
 =?us-ascii?Q?DauWJc64uMzeHeK+CT7xVb9ju4gDOQ6vSlJcJV724h94XllYS92APCp7NiXf?=
 =?us-ascii?Q?NBh0ldVoCQpVYKMmuwd+kIhu3zAz0ZrDUoOsVQqk9aYvubBiBVlHY+WOTg8U?=
 =?us-ascii?Q?3VHMDf19soo4rGM2hsv8SoO9T8Jjo4bzx6GP1B7ztqL0jgb+48tdBXPdwpQV?=
 =?us-ascii?Q?M8Re9JYkDKWDZSE/iRFg+rVMP3jz78B3d1jYbJ1smMVR7v9R6t24B5TcLj/z?=
 =?us-ascii?Q?O1tUySWL80EwgAqppbBP9EuhD7p/VjcoIb9iuVtBUn/862yefbVc9vvynNs4?=
 =?us-ascii?Q?pdgThJk0MNT/0ZXXD0vW9qIJsNBuWVJn0Zrz0jff5Y5AjHFJyVvmmXBBWEej?=
 =?us-ascii?Q?hSoUxt2ISHmZYxuKX3yCmNwbMQEoVr6hTQ8fslqzUsG1m+MB3VwZQsJc278h?=
 =?us-ascii?Q?NOpISMC1agT7WAEM7UY/XpuJfzp16CwfnVF3HzgJCRjFerFgy3Eu1QtbJbW/?=
 =?us-ascii?Q?+qZFtNGvikpQjauN/IUM7wXTZa/l9aGwp2V1pUKLc/3eSl6LLJJ3EbhZSn+D?=
 =?us-ascii?Q?WzZaX/0TFuZyf/oRO8jp+INid9roFHuUmgQCx/EhR0etba8pqI4oQ8dBHhvz?=
 =?us-ascii?Q?eG4KyTLFPfHU+vbYfUSR9+5qRhymN3GaA3JtL1tQIMiObRa2n3+HHPTxBQ3u?=
 =?us-ascii?Q?nZlCwCkGzfM/LH2SCNLu1J+jUiZFMbkt0oTT4FlO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d89079f0-4bc3-4db9-b49d-08d99e56f748
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 23:17:40.5377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJwfnO88GmGrvBvG/8yivxsSxG11AjBN3Z1wthmOxOCGI/XXcPY4Z0LraCA9nyzG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2349
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: AlafD23Pyz7VQlVVBMC_XvliV_uSXpmW
X-Proofpoint-ORIG-GUID: AlafD23Pyz7VQlVVBMC_XvliV_uSXpmW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=953 clxscore=1015 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 03:06:31PM -0700, Eric Dumazet wrote:
> 
> 
> On 11/2/21 11:32 AM, Akhmat Karakotov wrote:
> > When setting RTO through BPF program, some SYN ACK packets were unaffected
> > and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> > option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> > and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> > retransmits now use newly added timeout option.
> > 
> > Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> > ---
> >  include/net/request_sock.h      | 2 ++
> >  net/ipv4/inet_connection_sock.c | 2 +-
> >  net/ipv4/tcp_input.c            | 8 +++++---
> >  net/ipv4/tcp_minisocks.c        | 4 ++--
> >  4 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> > index 29e41ff3ec93..144c39db9898 100644
> > --- a/include/net/request_sock.h
> > +++ b/include/net/request_sock.h
> > @@ -70,6 +70,7 @@ struct request_sock {
> >  	struct saved_syn		*saved_syn;
> >  	u32				secid;
> >  	u32				peer_secid;
> > +	u32				timeout;
> >  };
> >  
> >  static inline struct request_sock *inet_reqsk(const struct sock *sk)
> > @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
> >  	sk_node_init(&req_to_sk(req)->sk_node);
> >  	sk_tx_queue_clear(req_to_sk(req));
> >  	req->saved_syn = NULL;
> > +	req->timeout = 0;
> >  	req->num_timeout = 0;
> >  	req->num_retrans = 0;
> >  	req->sk = NULL;
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 0d477c816309..c43cc1f22092 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
> >  
> >  		if (req->num_timeout++ == 0)
> >  			atomic_dec(&queue->young);
> > -		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> > +		timeo = min(req->timeout << req->num_timeout, TCP_RTO_MAX);
> 
> I wonder how much time it will take to syzbot to trigger an overflow here and
> other parts.
> 
> (Not sure BPF_SOCK_OPS_TIMEOUT_INIT has any sanity checks)
Not now.  It probably makes sense to take this chance to bound
it by TCP_RTO_MAX.
