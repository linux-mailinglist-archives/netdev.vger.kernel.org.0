Return-Path: <netdev+bounces-1700-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF356FEEB0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABFA91C20EF8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912011F196;
	Thu, 11 May 2023 09:24:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3151B919
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:24:31 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F43A90;
	Thu, 11 May 2023 02:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDsOBg89+wiNFaFvE7ZT+kNn2LrHsBlgkcq+mV/uKN5dWv2NDmuMT+UAl+CApl3glVOU99moy0JslPXam7tTv4QmjZIqdv2MOKEF4lenYCEOrETmoVknCzeH19xalkd1SPIvLZkG0W/4Hq0uEv+FNmERSM3FIq3sQLEBsE90svouchXa2jxI4rHoqtUo+CPYNWREJG0RnuxBH1BM9iuzXlOqlyht5BQfZxCs15dmWxG3We1d5gpXRcI01njtP2cJuGOx3Xa+x3Bv5JXwxXVEz5k9iBt/cvXfj762qXLe053tLfv8UBnSrM9Vj8ZR4kzZMpZmmDyjpfxuEeE3kuJp6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ge0I1GSaijyMm/gzvm8TupRG/nuDzWJr+Uk0cylogr0=;
 b=imfYlSJSkVl1f75SL3F+GXT5GkzkyL2qzn07Id+GPzRNuYn/6s3FDecYJ/SLsy4JuJJzq/XMKGadI+bniKZ2bKYpLL2sFqnxDfvHW7bGOrEOl7JjnzlxV7oWnPQnTONzXbNR4O8JeQaKxdfgQMa1oaUkjWkzxtsyCwkQDei7YWY0WOkWHbgSkQjzqG5myf1fbWJldncYLOL5zURR8fQSknrerhIo9Me/hoeh21hpT8PpYOHDxkr5CVgyBqZtyeToHET6arOmBYA7Vp5FGWbqTqLXdvtsUW9BOIK8sq0TEueQVS3W0sWu4zQ7/loRqnGoOEykmYteEDkF8mxQrYJLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge0I1GSaijyMm/gzvm8TupRG/nuDzWJr+Uk0cylogr0=;
 b=A3gbspr5W+fsXgGSQShvIUdXsyOs1F/5f3mUjYQcCqLqPpPsA6izG4XNByVFYEBSDVXwsK1tH4bzcAJXsNTlOQmTHYe3xlRpqtnNYJNE1u2hHnMUK2qN9VmkuNu4Kw+mrMD/3wV+bxJG81nr7xd+jZ+SvEkbpcuH6IBzDrvLevI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS0PR13MB6233.namprd13.prod.outlook.com (2603:10b6:8:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 09:24:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 09:24:25 +0000
Date: Thu, 11 May 2023 11:24:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: Reorder fields in 'struct
 nf_conntrack_expect'
Message-ID: <ZFy0QjGpUCOfaSxA@corigine.com>
References: <5cdb1f50f2e9dc80dbf86cf8667056eacfd36a09.1683564754.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cdb1f50f2e9dc80dbf86cf8667056eacfd36a09.1683564754.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR02CA0175.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS0PR13MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b7f2ce8-fbc9-4d7f-46e7-08db5201833e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0DBsRw3UjY2Jp7d2qbsrZykjU+3Lb5e4CZpS3u3yy+A5u+QfaPHGRB2ywhkXQ/Ue6bBjEhv6NlSuLHaro+zxUK5L6lHqrvvkYvRH3zXzteq1Txxa7Tnt0ZvXjyyN13NySzg7w1fv7AeOdfMQVzv/rIXjUIfdj4bXr89XwjgT+bF39oQ9fSbeOUFgH0CIbDwouav8+vwtHCzRZWfy8/YVqhACYBRi/uN4zxs7pU+CIhJEj5IK8n8aG2qK6HC+jbwD/wx2R1lVlxg+Nyo9WZIFp1lQhY8/2CmWiR7kBL5t3/ZgThLi9SZuLEt59zYm4km2A8gN2XHmZU6t3/JNKk5TiuY/x1tDz/99phXP6VPP87ahr+K7JWG/3GG7UHVmLJ13h7mkRMrr11z9fGVvJKe3R8648QhuJke3KNqftx5EUhTHPdGEsTlTq/yi4zMrXEgN7qD+Xn7wvoLhjZSHMzWJec0yt2WQ2zRdWR+VElpnuSToDkFbOL4sSKXa23qciNuRclVGH9LOODbcStxPv2+hmFwt9K2h7HUHKm+5mI08qvYb7s0ZsfC9P1b+QZiNSk9vVByHZc3lMF1TIkLc/XAqn9EIJ6faigImcadYAbBOEDg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(366004)(396003)(346002)(376002)(451199021)(2616005)(6512007)(6506007)(186003)(2906002)(6486002)(44832011)(4326008)(5660300002)(66476007)(66946007)(66556008)(8936002)(36756003)(478600001)(8676002)(54906003)(6666004)(7416002)(41300700001)(38100700002)(316002)(6916009)(83380400001)(86362001)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G2lDX+87Fv6DX4X8OYuV63OucXZvl9qLMwc3Mltk1mfWfBMaNQ3zX88rDgQ4?=
 =?us-ascii?Q?1q1HdTqcT1JOMh6l8QdyOrYzr9QtRSMkz4ttY+ZXkvG5a1W9lBkRoBByv830?=
 =?us-ascii?Q?oYjJcl2EN1qiuDECpMoe4l4zH2PD3/Ql1m9fjTXq+jPT1OCb/Cwls5/LCALR?=
 =?us-ascii?Q?nJcacLxnw89Kxxm0QEs5RByPp/7kLPHDXPSC8Hg5Ud/d6ijDkFgbSxhUhJ+F?=
 =?us-ascii?Q?eKsEVyxg3o/76A/NPwOl/MpqFz/HZxLMg2gNeqrcxTxxKSHBGmIpfUJcUnfh?=
 =?us-ascii?Q?LOA/ANx5kw/0BS85l/ym30e6ucrlI5/mJ9z/f9fz2LFX7r5xvNva8nZuOg3X?=
 =?us-ascii?Q?jrARFaSVDOu1WPQWvW4wXwIuM5V04vF+6QzSQg2kqjXQPPSBZS+MjJKH9gtr?=
 =?us-ascii?Q?iWZQ3DbZIIVlIS1Le1Wd0K24Xo9/xOBjey2CvchWlnzqvbDe63n46W2VRdTt?=
 =?us-ascii?Q?Tny0nPanWtPpLFXvbvm/XFM12WU4BlluSBoGzb5KrwsIDxxr7gj3xe76HYN5?=
 =?us-ascii?Q?wSwo+D4meIoYj/L+6jSM59kJKjxI9ekUGcXqhcrEecnTWbKNHZMmaQ2NZWVL?=
 =?us-ascii?Q?QLpF7/TlWE42+dbEyvvnnGGd3L9Ez40bAj2Jug332/8Sq3XH86vjQhNOb+3l?=
 =?us-ascii?Q?y1y9GIEI7Ca6UCwk13BDFu55fpvbcxNjY+Z4ub3qEufnPuX6ny20jknFW1Bf?=
 =?us-ascii?Q?ONt5sChJNOfjagfSUYeCR/PMC+CB17M++9kX1SKQ89NUyucbizhvThsMYkeq?=
 =?us-ascii?Q?UXLtf422zmXswYkokFEt6YOQwr2+xKeEGlhZET48tQuHKEonZxjyFTz6is2C?=
 =?us-ascii?Q?yQpsm0nQr+MxuScXXigDHU3IEMIbTY2h6XWR2pSGTmfvQXpV6hRiqx+Sec2w?=
 =?us-ascii?Q?a7zcu8Av0bYrcKBkFc0nOj/x77FPvzjEpQOXih/u8NGhciXgD2Ija62trMIE?=
 =?us-ascii?Q?SfD6KtNA10M50XOjbAU1DHCNjdEN4XiN6blKsy4GpJ3Gs9aZWWlbFHeA2MzP?=
 =?us-ascii?Q?FI5VkNVpANeCL1PacdYa7EAeLkvCqhIp/WBWB0IA07H3Bp1EhY+Cv+qXS9eQ?=
 =?us-ascii?Q?97Rp7RVCFmyDSG2RMx2OYA08KthfjCGSHysnlrX55BWtHMEzUooiIKnGrMpv?=
 =?us-ascii?Q?gYlkshHZkjzP+CanMZiJcqKmhPEDgw5LsvvuEkqeDWOoXdBhjpxHmqDEkpoz?=
 =?us-ascii?Q?AhYN2OhnuvUfNUANA5dLrFPhingGfn1AwgmazXy2pm5Ym3FFzPOhwOD8dYAa?=
 =?us-ascii?Q?Rz+EJzFqr8s6TWf+lR/hObgzjEe077R4nEqGqvDUckBMyX6eSLXb/lgHjLOk?=
 =?us-ascii?Q?SNuyI9ms5cuDxoX/YY9Zv3hoaW4+sQFRQ5eGQgYhQdI1CGupW3nJzmvC2Uql?=
 =?us-ascii?Q?Ex4i0QevDNy892AjcbUjjCQY01oCQtDO/8M23j4apwLajFneNsFcKJSAWue/?=
 =?us-ascii?Q?kGQHBpLHSkaHRFOOZbtkfDuY/DIi1Hc4zEbASEwq10O3sjrL7ASf9Eicq63W?=
 =?us-ascii?Q?h9c+6AXhM0u6Yc5IREgJzOI2YYZi9/AhzYI1/XSYNJM+QvTbAT07VmOSLKX1?=
 =?us-ascii?Q?kie+SLIwZQfhbetngD25W95KbaYo+TnMvQCvFwWGR5cUjQ6V1PqMdbztmBgG?=
 =?us-ascii?Q?FzwKj6dH35oHIK2TyrPVv673ajsnc4MCKfUQNUa3IRFIeVMXhy/TF+PKlUk8?=
 =?us-ascii?Q?wfq2cg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7f2ce8-fbc9-4d7f-46e7-08db5201833e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 09:24:25.5670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjliOasLcp14cF2YBl+8NywmO8a5s/okT93rlHCmZjSqTJT1p/O33JV5ft5RC4iuIKDvBf3KfpAE8hf+bo/2LFO+7VrmWm1RLW3jNb3M7x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR13MB6233
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 06:53:14PM +0200, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce holes.
> On x86_64, this shrinks the size of 'struct nf_conntrack_expect' from 264
> to 256 bytes.
> 
> This structure deserve a dedicated cache, so reducing its size looks nice.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks, this much nicer to me.

I slightly concerned that there may be implications for
fields that were on the same cacheline now being on different cachelines.
But only very slightly.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> Using pahole
> 
> Before:
> ======
> struct nf_conntrack_expect {
> 	struct hlist_node          lnode;                /*     0    16 */
> 	struct hlist_node          hnode;                /*    16    16 */
> 	struct nf_conntrack_tuple  tuple;                /*    32    40 */
> 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
> 	struct nf_conntrack_tuple_mask mask;             /*    72    20 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	void                       (*expectfn)(struct nf_conn *, struct nf_conntrack_expect *); /*    96     8 */
> 	struct nf_conntrack_helper * helper;             /*   104     8 */
> 	struct nf_conn *           master;               /*   112     8 */
> 	struct timer_list          timeout;              /*   120    88 */
> 	/* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */
> 	refcount_t                 use;                  /*   208     4 */
> 	unsigned int               flags;                /*   212     4 */
> 	unsigned int               class;                /*   216     4 */
> 	union nf_inet_addr         saved_addr;           /*   220    16 */
> 	union nf_conntrack_man_proto saved_proto;        /*   236     2 */
> 
> 	/* XXX 2 bytes hole, try to pack */
> 
> 	enum ip_conntrack_dir      dir;                  /*   240     4 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	struct callback_head       rcu __attribute__((__aligned__(8))); /*   248    16 */
> 
> 	/* size: 264, cachelines: 5, members: 15 */
> 	/* sum members: 254, holes: 3, sum holes: 10 */
> 	/* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
> 	/* last cacheline: 8 bytes */
> } __attribute__((__aligned__(8)));
> 
> 
> After:
> =====
> struct nf_conntrack_expect {
> 	struct hlist_node          lnode;                /*     0    16 */
> 	struct hlist_node          hnode;                /*    16    16 */
> 	struct nf_conntrack_tuple  tuple;                /*    32    40 */
> 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
> 	struct nf_conntrack_tuple_mask mask;             /*    72    20 */
> 	refcount_t                 use;                  /*    92     4 */
> 	unsigned int               flags;                /*    96     4 */
> 	unsigned int               class;                /*   100     4 */
> 	void                       (*expectfn)(struct nf_conn *, struct nf_conntrack_expect *); /*   104     8 */
> 	struct nf_conntrack_helper * helper;             /*   112     8 */
> 	struct nf_conn *           master;               /*   120     8 */
> 	/* --- cacheline 2 boundary (128 bytes) --- */
> 	struct timer_list          timeout;              /*   128    88 */
> 	/* --- cacheline 3 boundary (192 bytes) was 24 bytes ago --- */
> 	union nf_inet_addr         saved_addr;           /*   216    16 */
> 	union nf_conntrack_man_proto saved_proto;        /*   232     2 */
> 
> 	/* XXX 2 bytes hole, try to pack */
> 
> 	enum ip_conntrack_dir      dir;                  /*   236     4 */
> 	struct callback_head       rcu __attribute__((__aligned__(8))); /*   240    16 */
> 
> 	/* size: 256, cachelines: 4, members: 15 */
> 	/* sum members: 254, holes: 1, sum holes: 2 */
> 	/* forced alignments: 1 */
> } __attribute__((__aligned__(8)));
> ---
>  include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
> index 0855b60fba17..cf0d81be5a96 100644
> --- a/include/net/netfilter/nf_conntrack_expect.h
> +++ b/include/net/netfilter/nf_conntrack_expect.h
> @@ -26,6 +26,15 @@ struct nf_conntrack_expect {
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conntrack_tuple_mask mask;
>  
> +	/* Usage count. */
> +	refcount_t use;
> +
> +	/* Flags */
> +	unsigned int flags;
> +
> +	/* Expectation class */
> +	unsigned int class;
> +
>  	/* Function to call after setup and insertion */
>  	void (*expectfn)(struct nf_conn *new,
>  			 struct nf_conntrack_expect *this);
> @@ -39,15 +48,6 @@ struct nf_conntrack_expect {
>  	/* Timer function; deletes the expectation. */
>  	struct timer_list timeout;
>  
> -	/* Usage count. */
> -	refcount_t use;
> -
> -	/* Flags */
> -	unsigned int flags;
> -
> -	/* Expectation class */
> -	unsigned int class;
> -
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  	union nf_inet_addr saved_addr;
>  	/* This is the original per-proto part, used to map the
> -- 
> 2.34.1
> 
> 

