Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46296AC86F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjCFQoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCFQn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:43:57 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::70d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB2239295;
        Mon,  6 Mar 2023 08:43:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ezhie/dpzdHt5Ox3DFvVMc2e8oNt5b4/915+GIHxvPR7EmdIUR0gsm00/GDqxRzl3pglPPahKGi4GXg4lf0RwGYCi0+eucDP31C3IQ+p2MnjD+1hpWXatF1xm0QhdKkCpp4U5YE4ShnUav9BjVhKvGuAz0BvmqjLB1eOq+/yYlzvo9AJ1SOyL4HaHSFIy7U76HN7X2CMZpUerAM6dRxrY+lKfdo+8mAxiZBqd2jEZsqlHVYYcp7ZhxttozwDAuuQXxk6GyL3+hKdEN+jlUqgp9D+PBFSkeoOHixApA63IFPYulFCbgQrn/1fG9FF5Y5t7XYQJ2MUYs3iwmvb+IO8wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJ2OKtaQd27XTInakus2DCN2mSnDcLYdKThUmA7rQSU=;
 b=JTNeEju6MIhix5frj2pSB1uKS2eJbPCglIRiBOPW1K2V5Vx6g2QN5/NxU2XCW8dFsshALGti9a9kKajHDp1vt1ebDVWrhGRNR6W9FtHYHV0fy9ODBnB+nnbYooPUpQC5mHQg7bfSIu2iGP5uPmyZnvvsLLiG60J1pt5KyDrIL7OJ5hdUMGQHjDuYhPhIJc/JTjB6lv2jhKkAiR1F4VDT5BdInFcFrDVEMzDkLzmE+tNGVz3VQrlN2UKZaaK6fGud2RzxsrwjBIkBMPYOAaLuI3DwcV9H6pGUPjCCKze2DZcL9Atr0q0IuNzFv2ro8WzcxU8AxhKRS9OMaZAhxcHbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJ2OKtaQd27XTInakus2DCN2mSnDcLYdKThUmA7rQSU=;
 b=nRQCZd+Rij1fXRG8/Q4OnXyE8fveJX4uXCgRSQbg3gJNbtz6dY/HybWzopjCcRe6tsjcM/w+VKu5xwdhJZUyHM2GefxZrtCReIHlsAUF+2+H6XrqLMee6RnlZTSZ0CtyEYKo5glQJd4xQIezh/b9c7imKYSlsGx2DbOVhN0fIl0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4972.namprd13.prod.outlook.com (2603:10b6:510:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 16:35:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 16:35:19 +0000
Date:   Mon, 6 Mar 2023 17:35:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next 5/6] netfilter: use nf_ip6_check_hbh_len in
 nf_ct_skb_network_trim
Message-ID: <ZAYWP1FbItjLN48Y@corigine.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411027934a79f0430edb905ad4b434ec6b8396e.1677888566.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM0PR06CA0144.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: eef9b2b5-2e79-42af-6b72-08db1e60c5d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhpGcXs7MNcK6Iba1u6Zlba8tnyfMK1epSgguakLYi5f/b0fJUUhunTkOgBVqoPcTcQrELnrZN4rYk/xTaDCkpDfTgrA5ZXIY4OyqEjhLz1AL8dDYQWZlAnUtflkebsu4TVQS6AeeFrbavUexWxzksEtK+nqFLxiXOo6FprxWGwo3aWBcucjY7IOQktmh9YZflAfviGZ4bs5WB2ztixDbxr1uKQQ+fKdqFR6k+DZRhFbYEvzgQfR3hkXhyqh2Hp112M2tZTif9qnOML/Zs55uGgGM/HdMFm/DuvREFyss8OTlTNHMPk7R5MLczOI0coWmgmYxq9U/ULbFICn3oooZDK0zk6ZXwch4NmQ64xZGLtkVprdzVc5k4xIyegLeu1XKk/BmXS+v/TYLVPUgr7rwruYUBuqBeN1uTMWt9jPXL9k6xJbgaDRa2U07/RW3Zj8Sxfho9sBgIkqC4/L5KcVL/je5/sV1KV3N+5Mg+DuGy5M7mKdI22py1BHewjBzLK8G1cx/ycBmp8hD7qrHqHCn7iPPt9IBnvBXpifkz8L99O3YlId/6uXvdFukRXwBLB/YRPZf04H6jjThQE/kvUxN+zR5GGys8FhEJFb/u2eslLiWWBdVAFTrJxzlEB1Aa0Jnwe2LwiahJe5vBj+T2B2FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39840400004)(136003)(366004)(376002)(451199018)(8936002)(5660300002)(7416002)(44832011)(66946007)(66556008)(2906002)(66476007)(8676002)(6916009)(4326008)(54906003)(316002)(478600001)(6666004)(36756003)(6512007)(6506007)(6486002)(2616005)(41300700001)(86362001)(83380400001)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OGQVI9wYanQtxDvqIudCJYIg35OLamG3akQq+vIonUhXqJGvf7EEV5yQcx6n?=
 =?us-ascii?Q?X6w2TG/bTfRpA3kxQ77B3X/B3SJU5SG2mT89tfaNUWopcBSp16kcmBUTklNm?=
 =?us-ascii?Q?9PRgFRdFKmkxe+d26ONnxNtbV+RM9dVHyMDwOCENIgs0HTsH1Mm7HXT6pe/b?=
 =?us-ascii?Q?zxMT7J4bgXD/RDYEeTQNBuqclI2Sg3KpRwmcpu9v7bMC6kiGcSYR+Xs5oUzN?=
 =?us-ascii?Q?IfxnbK94HjrqwD2zpO3hTcC3pFgNOfrdQXx0tj3SzErtpxHSXSZme8OLWmkw?=
 =?us-ascii?Q?yyWbug/USalbJWeEyeVp+POa4Fwc8TP+0OpQjqGutuNK+NXoSx6s+64gRfpr?=
 =?us-ascii?Q?5flj9lZdpA4vN+4mwIdnvOwiEc/JnSYlJUyZ5c9QwqKigh5bQaG/uccNtgiu?=
 =?us-ascii?Q?siKTVgIzaFUFYvyh4YhmKyUGuVAfVsR268N6RO5Lprt9Vvb1pShN0jcThhz5?=
 =?us-ascii?Q?VMbHlc48e5QSbRN8YCCH7WMkqBbiyv7R3BUi1ZGc4EL+cyUJNlTGgUcmu10p?=
 =?us-ascii?Q?1OI+frE6fMTYmpdcs09IT9whSmP5A5tLoX8S6H0Y9ZioU7prKCj1PDdT41SL?=
 =?us-ascii?Q?f+g69AtS2TMqAntPf1Ipx3tuDGedKonngr7It/yaVtb/Wp/1Gk7MeL5G54AD?=
 =?us-ascii?Q?fvDk6UCSJGpJKvNzZ7u0sFWAt1x87BcXxuprxetKW3es61C+m2i/PCG+H1Q1?=
 =?us-ascii?Q?y5DwPCsuSVFE4XYxnYLW3HQDYKRqai1gJtYWlOeT8MuwDs2Tdm/hWmgKlqSZ?=
 =?us-ascii?Q?lQWVPVmyW99s2JN0IVuyqk03aDkep9xUNtjkFnFiOEeTjMmzxHwHLx/IQdo0?=
 =?us-ascii?Q?9lYMRA5KN8gZiOouecpqakABrlOlDNUFtuWMLkDjGbGV30yfZTiEBLkr94HV?=
 =?us-ascii?Q?MdVaPyO7AYcL41Q2m0ElOxbiUK+te0KZMzRZ/AGlMYR0uklZjy6uLVrEF6dj?=
 =?us-ascii?Q?BxeOhKYiZow1urXwYUk0v7RwnljbqJw/XPMPWGq6NXzUsC+ATDFcVhKoHi0H?=
 =?us-ascii?Q?BgmoWGvcZJY9hhfeM+EmVyCv2Ehz/mUI78ev/H6GaFt73xOrT367GeuZhvD2?=
 =?us-ascii?Q?ff4kMDsBi7uP6AfCR76UDd0nXMWkY2Bogi3OkRaINRa1qu6akpKWKjA0nzhd?=
 =?us-ascii?Q?MGIVYw6Eq+D/qCXCoRZ+rS10eCWi9u35ghciXvaWJHkeseMicBuBduZsGlAB?=
 =?us-ascii?Q?5xoskdlgg9c55qX14Ssy8fSb5dvUc72rblnIeU7NIEcpEVfs68T1XPTbCcqK?=
 =?us-ascii?Q?goTwXdVs5Vj2TKWNWdgC3xyREPahTya20aU0fMB9GZA/9RenOw000jI7s8cP?=
 =?us-ascii?Q?OCUHae3qCem+gSk8pDfTvmTc2qFombssO4S4ZN2W77vlTLgWHySp0sLwWi9g?=
 =?us-ascii?Q?TwewBmj8e3Q4005rx7vh/RhqbZ4Qtjl9R5o4TgBZHfT1vtqslGSN9LXiUjCE?=
 =?us-ascii?Q?ELXoVl5KelGrpK0BiBxNcrS5ik2wxk3Il8rbPgQcaPPBIX4RSAJJ0Z7FAC0x?=
 =?us-ascii?Q?p6CXfMW+JJp9vzJaAKaHJ8Jap17KC0z2ibprYsmYI03FmjJfiZoKm9NFLPcM?=
 =?us-ascii?Q?U80VjNQrtFmxlH4aFC0kCTgT0Lf2LglSHWIqSVt5hqQqy8TTFW5TqseOZcJO?=
 =?us-ascii?Q?lrr4uUxW0gqQjVFAYsgp8ocnU2dUNXmUjpBUbJUE2sPt1IKl2qBW5U55YSR7?=
 =?us-ascii?Q?MbSH6g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef9b2b5-2e79-42af-6b72-08db1e60c5d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 16:35:18.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U0e+nEALYSNKmBbhUPtw0v3vwh5AsCqR9jK6BykFTf99Zi1p7W+H8u3+q3cOTs1D4nb3d0q4zY1wfjxZqtvLC0JoccKRAiE0BDNgSI+8SEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:12:41PM -0500, Xin Long wrote:
> For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
> and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
> length for the jumbo packets, all data and exthdr will be trimmed
> in nf_ct_skb_network_trim().
> 
> This patch is to call nf_ip6_check_hbh_len() to get real pkt_len
> of the IPv6 packet, similar to br_validate_ipv6().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
> index 52b776bdf526..2016a3b05f86 100644
> --- a/net/netfilter/nf_conntrack_ovs.c
> +++ b/net/netfilter/nf_conntrack_ovs.c

...

> @@ -114,14 +115,20 @@ EXPORT_SYMBOL_GPL(nf_ct_add_helper);
>  int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
>  {
>  	unsigned int len;
> +	int err;
>  
>  	switch (family) {
>  	case NFPROTO_IPV4:
>  		len = skb_ip_totlen(skb);
>  		break;
>  	case NFPROTO_IPV6:
> -		len = sizeof(struct ipv6hdr)
> -			+ ntohs(ipv6_hdr(skb)->payload_len);
> +		len = ntohs(ipv6_hdr(skb)->payload_len);
> +		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP) {

nit: if you spin a v2,
     you may consider reducing the scope of err to this block.

> +			err = nf_ip6_check_hbh_len(skb, &len);
> +			if (err)
> +				return err;
> +		}
> +		len += sizeof(struct ipv6hdr);
>  		break;
>  	default:
>  		len = skb->len;
> -- 
> 2.39.1
> 
