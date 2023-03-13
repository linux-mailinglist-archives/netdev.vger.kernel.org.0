Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047606B7E0E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCMQtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjCMQtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:49:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2135.outbound.protection.outlook.com [40.107.220.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3342448D;
        Mon, 13 Mar 2023 09:48:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMp22yQFObIUzt/pLJR+rYvB+Xl3x0vUkgEnRzyqf7TgMXIwNGsUt0cqmBzWotEvs8p2PmfNDejMX+zhR7aA+hoUj8ifcZmup7YCWSfKbQOEI4WA6ZKvBf6L3uHX6ZUn3IEAAUFUmouw897CdBgYyTC2zJC0jL7RoNi2EXYTn53qhhOp1VlSUIXagHY/9u3gnwt687lvT/RuYKure7Bik5NM0SBUxtlezBAS8/txVEbM0dbicsqSU0WHAFsz7Kmuu2URTT/Bj0x+3ZeZA10M2pniwbGc1DMVYqrIkCS/AyKozsskGfMwIKeLcfcASA2lAqjd+vta5g/9w7LCd9Ko7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ah1sfTVQ9SwTtYI4d+7AiTWRjLZfjlIRQhOnuzKCwIo=;
 b=evUsFY/Bi+EzBr6YUerUI/YgVvnT+u78G1QbKfkynUPj6p/9ouEtRIjFmkfpkEDUFEInTBKgxOVz4+SjZG/ZMrl2o58Cf2nZqAjQQ9bSG3ZiujYhSs7haNY0YrAfk0PzfiDWWPy95hSWSUe9OFMBGaB2wPMyPGDZ2wwbKpqO4aYh4/VO3KkPIZaoPRIlq6vkNiMz1TjZ38j3nQ8bqkj0KKvRyTH53VX6LuHoJos5mLVKBmhqKUbJ46kHebd0WBygwqMfQdihzOXfCAscixuH2ajREBnudMTDlzNMpADfxPWcmDtvHMn9Di/4Y+n0m/RC5C2zQQdJHd3yBKTeBUFnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ah1sfTVQ9SwTtYI4d+7AiTWRjLZfjlIRQhOnuzKCwIo=;
 b=wILbV4qS2B2VvEhS2gyyb7i1ix0XVQj2soyVhhjI4c1nsTds2Nm4HpaHhBFUeXQgKR7G4QbafJZSrEnYAxIGCCJw1yDQ3kfGhpH8JnZB8P12Rm34ew5CXVSzDcdovDZuiBwDhrPuPgznspTMKZ0wRzn2/ybqBjD7EGDKpivvWrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5322.namprd13.prod.outlook.com (2603:10b6:303:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:48:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:48:29 +0000
Date:   Mon, 13 Mar 2023 17:48:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH net-next] net: geneve: accept every ethertype
Message-ID: <ZA9T14Ks66HOlwH+@corigine.com>
References: <20230312163726.55257-1-josef@miegl.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312163726.55257-1-josef@miegl.cz>
X-ClientProxiedBy: AS4P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5322:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c0334dc-fd44-4a9b-3fbf-08db23e2c5d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FYSfteSEd6/wkf45YgLbMvZMpXqAkrZ5nNzpwOKbeC5dNK1i0byGVMTF7KnS+Yi/vwY5Udiqhox4aE0Snf/yViRCeQwvWSsWuzBphD3b2GtfQL9tyhcMSt+31f68tQWYDim6AM6VVnSF6r8jBZL+jtEcrMNdhPBaWRkMqbAzBQ7LmP2Jl/D1ONv47/kxTEoE01A7ZvkrFt7/rZqwwJyDhvZXWKTvZEj8Br65AooMY6KjLc/oRWV7+9BPGR0IF0orfPL8uFJXxZdzfCwYnFaj17WcUClb9Io783+xYn1RhIzzD6xsrszzMNxC/IIjADlO8SkruRQFp1YkOf8CskN47nNIoqBV6BLYNBst/FpbdiCyZKMLOdDfM7u/36GwnoyzA97MDySvz7KdLdHlOgL+mJgok9MInQ3RGg1uO/QIrN9W54WaGsnbsgY71B7cYwpQmKqV9bv0hd1TCvm6SDQUTEd1Vx9oATOJjJ1QAFKWfD5C8ElrT9RHuIt2HHNIasKvV/m48qSFHOQtHHhi1SeZXZtxdwbMdzqdzR1rm1IW6X9aElHGFWrOKZR5I36QeahIbLyz+IXQGgIgKbJW0RXcBArKGKQ7xaJa53GbW5ucAIBS+ppnYpjcqvlP1A3ziTP/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(396003)(376002)(346002)(366004)(451199018)(86362001)(36756003)(38100700002)(66476007)(8676002)(4326008)(6916009)(66946007)(66556008)(41300700001)(54906003)(8936002)(478600001)(316002)(5660300002)(44832011)(2906002)(2616005)(83380400001)(6486002)(186003)(966005)(6506007)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rHPDMyEwTpcmsZW3PO6+FyZyGyv8o3FOQCeJAFhk/f/JTrxrOAKqrH23CC7g?=
 =?us-ascii?Q?yhmvjf4ZJOMH2yK5sgzRs5J8YMPG7PZSc5gTcAZwsVqZs4TU4NWxf1m8duoC?=
 =?us-ascii?Q?oZGMxf4QkRVvERgTEl2VrSgm9mSaNO3RCslLIHLUjjG0bbub4LG83XCWI1Wo?=
 =?us-ascii?Q?Bu9az85g5IItLfRnj2Re7XrWdSXAmAxkQB3wzSQ2Z9ysXaT2tO8ngcxrsGzC?=
 =?us-ascii?Q?KLxttQTzLvwjc6LjtQXoO5vo/VAEuFJm8MPwPge5kcrJKt5aNGNN0p9Hb088?=
 =?us-ascii?Q?rUEJMjc09pWYi2jyHX2ndb5q7Umet8MaHQ+ke8tt/1qvcqxc8+eWD34wyzzf?=
 =?us-ascii?Q?5FAlS7UQ1y8KFcveyNJ+TnbheF+ToKV7wQPOMQAkefzrwfOaGh0Z3n7E3fsw?=
 =?us-ascii?Q?l1gTBE5PzdfuHfScDwWt3K9zCciPk7eT/6JY5Ay7ljIlXd7N2GVusZvOMbUU?=
 =?us-ascii?Q?zF6vuFVNSfsGEy3CPEURMTVWfsV1Q805TgHzOdK/sQ4atjyNrXMPUHafheL1?=
 =?us-ascii?Q?ZKN+1ShT6mNpPD8p1sCpu5EtWE9AgBTTQtHNLi1fFd73NPt8KV/SEECEmsW9?=
 =?us-ascii?Q?NhrxaigABUxkd5uvyybjadXiBzRxi6Z7c+x6Q9Yeptb7YQ6r/OltNjJ07QOR?=
 =?us-ascii?Q?GFjc4WbZS+pV9/IcnTE2YfphSo7edSC9g9K0FyVTz1/8Mrbb+81Ft1wmB0Zf?=
 =?us-ascii?Q?kzftGBQOF6esQXoLLW1ITRqxCwtc50/6X5AsWJIHJCwf2J8z5UNuMLcIeHax?=
 =?us-ascii?Q?fH5ecM0FI4q7Tow0vwGzHlLB3RUnQBYUvPqf/IR9tiKDoIx/S4KKiLFtumVT?=
 =?us-ascii?Q?EJFl4wA1jtd8AofVqJ66zcsCDz2gI/A4fePdtDEPzn1azqiQ4r+BHFuEH8Qk?=
 =?us-ascii?Q?2YkJ2vD5DZN1puUWVmVcpWNRqpRPik6u+OuxXFw2Niy6HVOOweQvLn0CHpK4?=
 =?us-ascii?Q?hD94Omu3MTdcTHYiyG+/tF0FO9XUOY3Vzkmd39do/9R6ur1SUl7m+m7PAQAN?=
 =?us-ascii?Q?QlnRIQgIY8CDPuyMlRZgAdljLdrTET9drO3sNGsEbrAkC9lSvR8DMsn8dpbt?=
 =?us-ascii?Q?vS+u3XSueuGROjQYdHIrqT5YI312xl8jHz7cm7Ddig/osLLtdfO3I7f4rANy?=
 =?us-ascii?Q?XQtSz9Vr+LWiTSiqu81ayrodPF7EalhH6YPqsKuV3CknUFfxj9JzrXpgny8p?=
 =?us-ascii?Q?DaH7hUST6/Jh00/S0O6HwIwXiVVlk+AtUXbE/N8I4nqkiXIr7ILvVVtmie+f?=
 =?us-ascii?Q?fXkVxGMo18BUWDS3cpuBy597Aaw+mLV+0G58d4BJI/NIKCHnzFjxlzfpcfqS?=
 =?us-ascii?Q?QIj8UrSPyblTMK9UvyOX56ePfWqZsgb/uPc1rJDOMqm1u3gn9O0adr71KVHQ?=
 =?us-ascii?Q?zmiNNjLYUPeX+3ZHxEmcOSrGmjyl2d6/hzniGCK3Z0lW/ITseC5oGpIXgNdC?=
 =?us-ascii?Q?2aHVGTMUGBlwGAl8CBLSIe10Gy57L2t0gdBNlQ+lovmHDUQ8ZslzKAvwnMY7?=
 =?us-ascii?Q?C4d3WWLv2X7jVtvg9MYi+YVwjyATlkQ3ewQELKtjnS8hxDQrS2mdN4pVd+/Q?=
 =?us-ascii?Q?mJARn4jDQOPPLUy6cHj/bcrwiWhqdGJfgyN+pABuqu0hk1BVjZEdOQQgVjiQ?=
 =?us-ascii?Q?/2eWracrFExFc36tHwRyPu+W4QstwCTBaSDyj1QYsEhm6xdwGxct+umvCjhe?=
 =?us-ascii?Q?zIePAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0334dc-fd44-4a9b-3fbf-08db23e2c5d8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:48:29.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBer7Yjj3rXRnvC1h+wIc81y5AsNIdaTIl4dL1eoJ3qSMFGmWPWTTVUyKuKEw1kMMxgRx2Y1Pa2SATpyklpKlbfmztGixG54nsy0Vi3ojIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5322
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Pravin

On Sun, Mar 12, 2023 at 05:37:26PM +0100, Josef Miegl wrote:
> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> field, which states the Ethertype of the payload appearing after the
> Geneve header.
> 
> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> use of other Ethertypes than Ethernet. However, it imposed a restriction
> that prohibits receiving payloads other than IPv4, IPv6 and Ethernet.
> 
> This patch removes this restriction, making it possible to receive any
> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> set.
> 
> This is especially useful if one wants to encapsulate MPLS, because with
> this patch the control-plane traffic (IP, IS-IS) and the data-plane
> traffic (MPLS) can be encapsulated without an Ethernet frame, making
> lightweight overlay networks a possibility.

Hi Josef,

I could be mistaken. But I believe that the thinking at the time,
was based on the idea that it was better to only allow protocols that
were known to work. And allow more as time goes on.

Perhaps we have moved away from that thinking (I have no strong feeling
either way). Or perhaps this is safe because of some other guard. But if
not perhaps it is better to add the MPLS ethertype(s) to the if clause
rather than remove it. This would be after any patches that enhance the
stack to actually support this (I'm thinking of [1], though I haven't
looked at it closely).

[1] [PATCH net-next] net: geneve: set IFF_POINTOPOINT with IFLA_GENEVE_INNER_PROTO_INHERIT
    Link: https://lore.kernel.org/netdev/20230312164557.55354-1-josef@miegl.cz/


> Signed-off-by: Josef Miegl <josef@miegl.cz>
> ---
>  drivers/net/geneve.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 89ff7f8e8c7e..32684e94eb4f 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -365,13 +365,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>  	if (unlikely(geneveh->ver != GENEVE_VER))
>  		goto drop;
>  
> -	inner_proto = geneveh->proto_type;
> -
> -	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
> -		      inner_proto != htons(ETH_P_IP) &&
> -		      inner_proto != htons(ETH_P_IPV6))))
> -		goto drop;
> -
>  	gs = rcu_dereference_sk_user_data(sk);
>  	if (!gs)
>  		goto drop;
> @@ -380,6 +373,8 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>  	if (!geneve)
>  		goto drop;
>  
> +	inner_proto = geneveh->proto_type;
> +
>  	if (unlikely((!geneve->cfg.inner_proto_inherit &&
>  		      inner_proto != htons(ETH_P_TEB)))) {
>  		geneve->dev->stats.rx_dropped++;
> -- 
> 2.37.1
> 
