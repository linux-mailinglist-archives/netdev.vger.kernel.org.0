Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43926AC60F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCFQAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjCFP7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:59:51 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2137.outbound.protection.outlook.com [40.107.220.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD762364F;
        Mon,  6 Mar 2023 07:59:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM24MY+srXeQfY83jpZjv8JJK1RKMYUjE84g5EYi6+bBTC+ReWCezPqtci8XcONmHfjpBKRpBPvgQD1txnUVZWlqKGOTLoDItrEIxvycgvXkIGBuNBuJ9dZr4QaGIyTmL13j6ztE2IH0flNlMJF3w4oLfq32kjzpP5TodwDb8jXdNuPFt976rZPkr7byYJXclwsmn6y/gDQMMJffaETAc408CmBiHPdi0sc4X7shO/bGeSWNE9nqaswuuj41DIX4yGUwS3p75mEClawrKGDqNoWOSzSvXsQGDVQ3Y4AG/XOPk5L/NeZpngvSNxPhA88q1TUPHx4G4aAX8EyDAHyB/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCS4vOZBTp/w5bq8tDWIKzcs0J6pp4Mzw18ahy0SMmI=;
 b=fSXWi2o3iTpiTmkMn6SMlIcZSHWh3jX4uxBdBYaYZieWuVuylKtZfssrtrzU4zpFz3ZIdOpWl36F7bKNvCyA5JKhauDeTYiV302fYSlzEyOg9poKzTJXhgbsKc9rMk7eB/ZJLyq5+skVlM3CZsWTki2QVYhdV0Lg96KMbnDuXI3Jrg6vjsqDYTqWkqj3HqMsUd1pyWOYwg606v3CFxiWtNsKGJILK7x+gyZz+z9wrih+O9aOZYLKU0s8oG9FnM/grVl0iKT8d7x3pmRb9/U9E+HEOv3oXnsWYTNShHcdgq4dDFaFtTYkn828vy+gmBaP2bmEdj6SBcRV2iD5lWCEyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCS4vOZBTp/w5bq8tDWIKzcs0J6pp4Mzw18ahy0SMmI=;
 b=FBQUgWWH5iGDn04zgdWA7LGKrsQdjDqzDkrkqezSzYICx/+I43SrY7tpkwXedCcYp1R46ZZKGc/t6AinDt1Nt1oGx5dVQ5mAhdLEHibc8/TlZLCW0tNwq88CyRlky8p4UrCud9wrswOesnI/i0XESBVJRv/25bJsSKN0B3hfzOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5702.namprd13.prod.outlook.com (2603:10b6:303:17d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 15:59:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 15:59:44 +0000
Date:   Mon, 6 Mar 2023 16:59:37 +0100
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
Subject: Re: [PATCH nf-next 2/6] netfilter: bridge: check len before
 accessing more nh data
Message-ID: <ZAYN6TguobKt6Mrx@corigine.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM4PR0302CA0025.eurprd03.prod.outlook.com
 (2603:10a6:205:2::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e4a66b2-1de1-49bc-654a-08db1e5bcda1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpCSsJAWW9vvXELDEbnetU4YV8CFvkwyNr9sME7lX0ghmOqPx+2s4VDyzrhb7Dja1RY/+t3K6cyf6IU70RiTYzGViizWh95S/FPYj0sxWXbmXH7rGtUlyZP1F2xpXBvYt7bXT7rcLJKZ/w1PxT/SXd2dUA4uJFPYO9rFjErTXxGSvLBblSezp6Y+lqv01CIKpucQv3sugAqkI/8v4vXYZ0s1GUBCkvUeCibOCmtluaRPkFTg4gFuZ42EckOG1mI2rg4ovYtc/0nPTH/pWsczc4EtXNi2JSZ92+rHzboR65b2zAQfN4Ad4DZ5rwKza3L5PILYfL+SsUC1mQADa7spsh+B5Ow6heVmcf7gBFTYx9vCjoBhkUxkvy//YtU/skao/k9qSC68OAye/8Qk5tKqqap4HOVSR57erBdIZyiBEkjOq0oT96RzhZ3aRqBJrStXPsksyvYTAzoay7fp9R0dUuRlM5Yaaknq4rn26ritoLovNegSlestVSWlQgWH3YyhEJkPaWnGsCiuAuZ2oadcpDVGQpzJswar2eXpyGJGv5CDHmHx1yRrXDqbWHC8WqEOcBrB86PtQB6LntTGyOaVzcOdRC0m98XIH+/UbwYV7jTi3bk6PyK2fiu/2yzhnKGBx23+GfdSx/5YqHYldju+l8W/iF2jJxpXxkvKE2rJbmXsYyMOrK2e1S+nHSVNObe0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(346002)(396003)(366004)(451199018)(4326008)(6916009)(8676002)(54906003)(66476007)(83380400001)(66556008)(66946007)(316002)(8936002)(5660300002)(41300700001)(6666004)(2616005)(478600001)(186003)(6506007)(6486002)(6512007)(36756003)(2906002)(4744005)(44832011)(38100700002)(86362001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7ZaSmbcpGiFxt6JiWA8H0Slru0nNK/1S6op8VxuNh3TWYZVwUFBJfI3ItDi0?=
 =?us-ascii?Q?S6YCb0FefHYmWtiK+GNIeN/vu4TIZB+99mBX6KyyFcv3d27r5BZg6o/IuysI?=
 =?us-ascii?Q?an/lVIWjgLl2A33SfCd3uRRcOypxmE+vLjfxkf5vxhc8m74j3Hd/JZx90rbA?=
 =?us-ascii?Q?yinfQs0D8tig62E+93G9OBoHgqSwdp8ZQpMVZUUBr7dzVqxbHg7Lo0zL7G0p?=
 =?us-ascii?Q?ZCBKuaE++ALyE61Nh+Dqv8DzRhqFf1ut+le3DuSL0HFSpb3WrHDRdOhhYIik?=
 =?us-ascii?Q?DvL93tpGB6ATv/mIF4Mnku2wQTXL+1bA0NnHWCRfedE3TyRD8ZYG5j1gkl00?=
 =?us-ascii?Q?j0L8kSXoGnm1tt96hwzzcIGKdBTqF2xdL9JbOt/gWC225ec4mRdDu2jaQr98?=
 =?us-ascii?Q?INYpgXEC5VMmv34PLHanIXsjOyMaaI5Tm9wtaNrAZf1bCk+iqUQA5ss7hFVK?=
 =?us-ascii?Q?y/BOPw8r1Haze8fug5OApV91tnD8aOoVuzEG/TCn3chZ9yCq42vPEQ6rb7wV?=
 =?us-ascii?Q?yzLMsKXtiNWrXKgvDO1oftJJE544PlZC644ii9nyVQj7VSJ4tARqFiXvg/Sc?=
 =?us-ascii?Q?rp006CjmUV+S8gTeilmVajWmApuuWO5gzpUZywqTS7+cGcyHw1+qvBmqlNGW?=
 =?us-ascii?Q?8r8anjzgjEETARLxargJTq9uK7/IQ3MQYY4IlDuNg8HrFwDn0EaLXMI/igZ8?=
 =?us-ascii?Q?J3PY9yYyZ0UtdpVNavDR41P02UTw2U27fCt8UgRWyzNDtbaGLRL4GUTsvq/t?=
 =?us-ascii?Q?CwV6fvE5/e4Dq/U4mongpuFdZ12y3UZ2VYnoyyKATFtGaUDUDzUe9jXLFpAp?=
 =?us-ascii?Q?L1wnb5G/oPc6KWQMeId/C0k6KN5nfD0ZdI/E/ssrjMmtUxAyWDonKMhkBQav?=
 =?us-ascii?Q?5hEo0T7REqw8KqHphkn36EhYEtxMENyYmrAmUNIJX1xYwkOQxIe44q84Na8h?=
 =?us-ascii?Q?z9AR/P6gRxvA1OgIODO5WpqY7JRnzSopQGViQ0DeAgHNxnGUhC1C2sNyfKxB?=
 =?us-ascii?Q?Cr4Gx0qezfcoWOEYbHIlUgiqYoKrY6h6gmbXVzql1Mtnj4L34rYo1arqey43?=
 =?us-ascii?Q?pM8l775SDYi9BKlLuTXNINWNePrwRVcxzI11CxZW5BpuAyC2ejOXLyURBiWt?=
 =?us-ascii?Q?vDX5DS0Zm1KjM5O6YHnnec0JPdmEfSO7eQmPksOd8J2mLPe0tPnoJxp+JWhi?=
 =?us-ascii?Q?UpxFyOxYg4ZK13wtSD4iv0Br2qeZ8L8Y5XDCgNT+1v4R+t5RJ9vpU8WBatfn?=
 =?us-ascii?Q?nLrcm1vG6bFNN8huCkfCq9X/jzUlO+/LW+lLyrmeeAcU/hEzJZx186uC2yuD?=
 =?us-ascii?Q?9GikKHG55H4yrKDpSz/mclFnoAdbR1PCQ6pkkk0zY6qQZPnMD7feDt0xGQp4?=
 =?us-ascii?Q?svIKQfcoeYvkjUrv384rGEY+j/cgtUl2P5y+MS/a6nB14WHkdwFhGVya8yL3?=
 =?us-ascii?Q?Hfv5PxK5QusiQO1vHvaMgUVKQXSZG7u3lE4ydQKyIZAaAsfzvtB5zWk2yxLu?=
 =?us-ascii?Q?OcD//bqpnTT6jjg6kuyR8/lP+XoUsI+MTKVfu1fF2p9pQU9/PMfsDenFRgSx?=
 =?us-ascii?Q?tl8Yem3DZHWyUsj/pX0FjUHrJ/HpA4dfZeV8BNosD+mY9hMc9FREou1tVg9c?=
 =?us-ascii?Q?eYBmmo1aLSvQQYhO91vN1xAw2YOy9d8CNm5pgrljH7VaDqaVaE4MUOQw6fQy?=
 =?us-ascii?Q?7ddcWQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4a66b2-1de1-49bc-654a-08db1e5bcda1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 15:59:44.6007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWALaSMH/UDTDEkD8K+1tnj3ykxt870P4I8ETVXwUD3uSlrM532aY09YJ92ofQxi9Drz6KCZQB/Je28gHPNinh72o7aLPsnAcKnAXlHmIq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5702
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:12:38PM -0500, Xin Long wrote:
> In the while loop of br_nf_check_hbh_len(), similar to ip6_parse_tlv(),
> before accessing 'nh[off + 1]', it should add a check 'len < 2'; and
> before parsing IPV6_TLV_JUMBO, it should add a check 'optlen > len',
> in case of overflows.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/bridge/br_netfilter_ipv6.c | 47 ++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 5cd3e4c35123..50f564c33551 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c

...

> -	if (len == 0)
> -		return 0;
> -bad:
> -	return -1;
> +	if (len)
> +		return -1;
> +
> +	return 0;

nit: if you have to spin a v2, you may want to consider

	return len ? -1 : 0;
