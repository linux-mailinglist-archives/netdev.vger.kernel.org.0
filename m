Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61486F1F18
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346192AbjD1UEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjD1UEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:04:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::70a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44620213C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:04:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjbadjtI+7qrUsrJRw9mEMlNLJFwvYFWrWKW0R2PIpw1XzYX9GKgLcsFf5LYybGBqd8LMd77uk9MvENUGsstarGWfXuDVN0FlA+y/W+hRjbcEXkyu86zJUK84xEVWexPHUrHdJEcfH9N7uwEurvj5WO6lf5G+m5TXY/400ATa3EEBQWCT3uvL4Og+zdKa/hcuBRYvGPj0SL9hh8z8ndAk/QIfcHoUv+FwyxZ3BeUo/1aHKtB5NqER8Zr5hasSsurV9/12y0ZXHS0BzuES1wPF+yich8jiEFOS9RvmszOVXeC+xJpggjEujHyXfJ/Cr2tCT6sK9I1X25DGBT1bqYFGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biIsXBSjHs8A7s6k/9OGecJoqWCBVUOpAn35CYz3kvA=;
 b=LOJraFyPEtu+Jo1c0tIHHiC06bin9IUSuXTfLeHXjvkCbOkTZdImp4oTexx+XOIlULivlf/aJUziaboZ3oDTwuJIyY9Mbo4i6b9N9izV+paHIeNlSsCvw1hRE62DbQ8his5EHiTnl48g5XLgBiwvvnXLjDyUXVFWE97BgZfNdBp1MZNdORBJKbsoP7nAsoRtgbnjoO9o8Tx2jeMemSRfE44Tgk42Ch7jfkPG8rkaK4dEQX2DA9VSs2ODHwewXIybYc1QL5GLNl9Vi09btjeuqPeBoFOw3BL8yijH8ciOogLNk510Gz65CqIr22Vs8xR6LT1zVUE3wpRvuvUAe4ZSYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biIsXBSjHs8A7s6k/9OGecJoqWCBVUOpAn35CYz3kvA=;
 b=fFM9Xxkfo4K7HC5JFpu5CAp8t+AzFla55cN+RQgf+WG90SJpF21SmQ+SgtjAhcxDFbfMTxG6e8+qj+f6QAOQJOo5mkqCuw0AhHtcaYpZ2vKH/chga7iCwEf0zSXCVoqTKYVf/ZqHqcJ7C056D7aNyP/WT/0KlLj20eyZWeby12Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5191.namprd13.prod.outlook.com (2603:10b6:8:d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.22; Fri, 28 Apr 2023 20:04:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 20:04:29 +0000
Date:   Fri, 28 Apr 2023 22:04:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCHv2 net 1/4] bonding: fix send_peer_notif overflow
Message-ID: <ZEwmxt4vvw/+2zqI@corigine.com>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
 <20230427033909.4109569-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427033909.4109569-2-liuhangbin@gmail.com>
X-ClientProxiedBy: AM4PR0202CA0015.eurprd02.prod.outlook.com
 (2603:10a6:200:89::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5191:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b2ae9b-b033-41bd-994d-08db4823c64a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCSrDOTVWnAKatFuLBK8g+05N2dzdpsN822Wv1atmMp6irxDAR98xYdclC+oJLJImDfVtQo0/b37lDbzM35Mfecu3iJKYsKT374b9ZQfUzxec4dtKcR0BbE/k8262GnyfLjV6bTzVIvzXbBSX1Moj4kDOHD8Cwq4de8vaOO5jrAvf2N/Pv3bsthzqE7uFEpNxO8cEDQPnQ9pXOJiNnCPfgQGhB79b0bempb7zGr1JZhPYibh8QVpbX83D/sdCTW+GwKLKhaArRPIs7Wo0rItESRE4JPwlIIErnjmPokxY0h8vwbG5PtYeZnuvkbWVPT/h8xa7oOyFa6lTQ0ohUfnlSHqdLVCWy4GVsAnsdFlTn7P0GAws0xme0XTK7tJuPwyCKSN79zdQKMx85t2Id/8phPTeLZYHnDTBm6gr7uHjCh3JMchJ7Ly7Pjt2pgM0xA359kGap4rEQ9LzqllEoRbPaltDYsvvEN1FDmlFDpzgObzs1o6zkT6enDXCm5BoL2ThnwKGbGxteDq/D7LzG4hsj9Ej8YR8+Af0l/hC172UIQF1UjO9AVBZ6bNNGx6++dn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39840400004)(366004)(136003)(451199021)(86362001)(4744005)(2906002)(36756003)(54906003)(6486002)(186003)(83380400001)(2616005)(6666004)(6506007)(6512007)(44832011)(478600001)(66556008)(66476007)(66946007)(4326008)(5660300002)(316002)(38100700002)(41300700001)(6916009)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xbQ/IBU7eTAPNTTn4r5E8BYo3pqmN5SJjJWfz4/6dBOcFtEFpoEuRmtI+0tw?=
 =?us-ascii?Q?Z9a31yopCzUW7+oYsgG/pkKiRd1JvrVYMg4NI12a+Y6Ld8o7x+17L5pL9J99?=
 =?us-ascii?Q?tOWqVBO/Va33V5phL1fi7k/diR7l9OTLP+wI3WwpvyLcxu3aohGzVgyfeKgm?=
 =?us-ascii?Q?gkqAhsV8eWq7ghpiJ3l9wzV5ZSb4bN66QEPyLM9xlrrriOgE6okYCrmK5e7S?=
 =?us-ascii?Q?kYRwzlnSvDleo6V5cYcc+LK0q8mn3ncoH7j+GE8VLaax54iLDsTmnDhTIxL/?=
 =?us-ascii?Q?g51klv/shnr3Cla0gCojkLe0Kji08G9qxa0nJYQSjaEMNBpKkFk0m2vjW8O0?=
 =?us-ascii?Q?XB45T4I1tK0UBnjwUqid4mBMrkFx+UlKj0voJ4ZrkHQ47mVDu8itNgZLSPmL?=
 =?us-ascii?Q?JlSt1Q/IOnuHTR99hSi919kIzWshibszj+aXRa/r0ana1lQDLT6qSu5xHMSj?=
 =?us-ascii?Q?DUeDDoEPDzXf8h9IVS0OeGhXFOUNeoLG8pT6Rkznl7x3zV9NAuQ+pkhK32FA?=
 =?us-ascii?Q?/AFcJEMWMM7LuaZLUG4xL88qb9Qng48RswCwtrMx2UqkHcxLw8MgA7FauoZA?=
 =?us-ascii?Q?3pg1RGEpOiihSod9mDMTCVaB/JU1Gfp6Bxv9WvQ/mVoaHl++3t3gHP7mL/Kw?=
 =?us-ascii?Q?PI4pWMVn9YCtpBNSIdqOeSykqLJslwgt/LuFtARGgYM0X+KjU7qdHOYnAzrM?=
 =?us-ascii?Q?59pNtEzWCPpXg3/CERyjpbhLJq0uzbUXuhmKBQ1aWQmVbtd/0Pc1VcgORekp?=
 =?us-ascii?Q?etGQM5GI5/d0PEnCEKG5qZ8Uz41C7Ea21IArjcR5cQrFMIxvdTIT2gANduXx?=
 =?us-ascii?Q?po8NvxAdkdCdc8aen24QdQfnEwhkQr884OYBsxAplSxwJW5yma0nuvFypR7Z?=
 =?us-ascii?Q?PVNUbAk45M6nDg/z9xDa8B796P7D3fVJjgFwykXhEO4HaWwSDlKeX/ou1PDu?=
 =?us-ascii?Q?J0yz899yXMjJZtLlCwyPgMsOCYOvNfXfTgahO3f1H/KGcDAhjigJHoGkjuxi?=
 =?us-ascii?Q?zB3Pqa8XqI0TYWBsdxl89y8xsL5GukP1PQ1X1N2/si2vjsFiHPJUjBcekt/w?=
 =?us-ascii?Q?UhwCq69ZtXJ+iyLWhizPnsoevFRBm4anedxFTSEVy/eBECPfebhCRvpjBHvX?=
 =?us-ascii?Q?dJ3j3CVODJbJUYKth/qn1RzUB+41QSUr9NqUH+S1orZLK8zO5AKvMQfVp7j5?=
 =?us-ascii?Q?3Jr1cpj2GCpvCpmyUaiVuHMEUKfMhex+KxkImI+mhcsZ1YprF0PHWpIrMjJI?=
 =?us-ascii?Q?AEhKlObNmHaXZXZxzeBXxfpg9G8QOFja7PXB25ldg70NV8//DHhk0Ei/uSn0?=
 =?us-ascii?Q?WJcnWKjCVc/YHrU/hUqJE26xdf1Bn33IFMiu+vfEWB7jfNioEEcO2D0pb35+?=
 =?us-ascii?Q?vqcHbVQ8wnZV+rfmt6uASLYlPJ1kEFjHRwpfr6khECnd0T4Oi59zdbffz5Sq?=
 =?us-ascii?Q?cYquyNm6JQSEerbSvE9IpoXmRIN0kpNF6eLX2w2jblF1l9KJvVIaghUQKmdp?=
 =?us-ascii?Q?DOBXCmOHVPrx6gVm9ip7tARkZfG8HRh7zHCc73HxoP9vQIkcKyJLTw6HnS1p?=
 =?us-ascii?Q?KvbFEy3PZTaGOFZB3oHRwS54kfIYuXf6KQ9tuOcUoKdZ6OIJHlZu6/vnnGtP?=
 =?us-ascii?Q?nZJtJTaiFXtXCU8H7gViadI6m8xw9GbwAxAnReWjE9woInwUmyR13YUM0A/C?=
 =?us-ascii?Q?hADsHg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b2ae9b-b033-41bd-994d-08db4823c64a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 20:04:29.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDmWSsQ/9MNbon9Nv/3SUY+7fhrAuOISnhC/1IoRcFP/49QScb1XOJfSDou4/Qj/Ptyh+cGtvNJKeP90w/TO53aBhYA+PvX6f9bOMqP+irU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5191
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 11:39:06AM +0800, Hangbin Liu wrote:

...

> diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> index c2d080fc4fc4..09a501cdea0c 100644
> --- a/drivers/net/bonding/bond_netlink.c
> +++ b/drivers/net/bonding/bond_netlink.c
> @@ -244,6 +244,12 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
>  	if (data[IFLA_BOND_PEER_NOTIF_DELAY]) {
>  		int delay = nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
>  
> +		if (delay > 300000) {
> +			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_BOND_PEER_NOTIF_DELAY],
> +					    "peer_notif_delay should be less than 300s");
> +			return -EINVAL;
> +		}

Hi Hangbin,

can this limit be implemented using NLA_POLICY_MAX() in bond_policy ?

> +
>  		bond_opt_initval(&newval, delay);
>  		err = __bond_opt_set(bond, BOND_OPT_PEER_NOTIF_DELAY, &newval,
>  				     data[IFLA_BOND_PEER_NOTIF_DELAY], extack);

...
