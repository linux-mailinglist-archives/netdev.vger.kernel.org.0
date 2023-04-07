Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106E46DAFB2
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbjDGPb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240427AbjDGPbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:31:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::71d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638E5B45D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0MoHw8RvqEPPBhVLapWB+K7tWq5fRxxFKgVG2yiJtYsbsl0nlmutFC6paEXZy+sinD1uRQ/v/Qvpc8UnT/I7/S84ALx3V+1Q0BIOVFRiPN6MTfS7EWLkv7MTZQlEU0A4bukkIKwZUhcDIDKS9ZI6pNm+NXauMi5d3OLlmcKys9GBfbsuP+H/s4t4YgAlMATxVjpaiG13wCULjZz1Nn6+t9An1FRzKZlIUt5Bn8E6C9C/5R2C3MBmdw+qPoDsDA1KSvpbTCqojco59TACGr3Ud2jcnXM7Idnp6ctmVZP4ND+zS6NbsdlsajWsXW8erxWCWk3G3L+YcOJ2jFZacW5qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6aZc2BHhtTspJphOu0NXe0SIdcaDBQEpTv5MQs4al4=;
 b=WYuNSApaUClw/L5gr22gCx7fS0+ofGPQ9ULxwQcn4gCxzc2UVW0bsRLdI7WrJyWWlxVVDRvkorpfOUIkfGmZB2W07N67MVm/aysy1KXgEHKBcAroxiUddVe6TeAy3ncnXppoJU5aksvRlWiuWnruZjV+hsSnMFujHxtNtoFFYqAD3BzrZIexlH728YrRUkGWlPIEtqStGWJhCbmYSWKq/mVw06trjn+lnKtr4WCBSuBt2dnp7qpv6FAHR0sjefXGncK1+k7MjQqu6rU2wvLlq5rrExDi6rTotSypPmy3NsiIUW9KqmLdyVuzzZyv4Ylt+xpn8pL2fVcR/fVOUIZ//g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6aZc2BHhtTspJphOu0NXe0SIdcaDBQEpTv5MQs4al4=;
 b=GCpwMmGIB/TNuAtWbVnTlJJa4EOXGXUmn7JbFtQynskHsa/WPP8Eb59VVUGJZ51gOjSTvOM5ze5RbvarkGWSGxp1VOZ+XgfVO0gELpEr+CAmilY8l2mPdZLEE1MSvSOsLnmZw+mwtfRoV4xZls3Ubt+qSJe8uJ2vZ4/1y/7XCoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5842.namprd13.prod.outlook.com (2603:10b6:510:150::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 15:31:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 15:31:29 +0000
Date:   Fri, 7 Apr 2023 17:31:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv2 net-next] bonding: add software tx timestamping support
Message-ID: <ZDA3SZ5PHqfif7AK@corigine.com>
References: <20230407061228.1035431-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407061228.1035431-1-liuhangbin@gmail.com>
X-ClientProxiedBy: AS4PR10CA0013.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5842:EE_
X-MS-Office365-Filtering-Correlation-Id: a7400dc1-dc80-4107-0c5c-08db377d2863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7+xhOe8tlJuAEZ4zCCr9AbfngwIBnZH65kbfbZvHsd1zdFpD17H1shMFE648hE9Vphhe0nfD1B3m5saOukWSxL57PP/orWTWcw8I+7sSSuS7PkOOZgpCDZ9/GY8qmfOy3Q+05lKdxBBLHEuZq827lnbB/6HWozayObAtxPh3VA/6zYNafgQE60lewmVNWZd1G1nP4Rez+QemKqrSGQoN8SpswUhZlC13kdP0LlXYBqn0u9Aq+jzqjxEXXqsMbqmVDQzZpzkgBrsZVXxzvTFTOWRZ5051LZF50SvZsFQLw+3DQL/zrqqLv2NR+n+q/FYEB5yfLfOwsMwskDsGRD0MJX8cunDjNrmW8T4MWfilTSaT0Tm5RihtPBhopeUGdqwcaki/ibFBzzU22UJQLgC7qPuWT0mWAxn2RLIRn/3qX2jgrgRo5mc8BTglSq0QUbau9MCnML5uiXRJseVwbEv5l3Ax7bO8dTtEn4M0aD/v2nWoxIKCEeXeVyYNOtMGkaQLHxSnRnKYvmDAyMTCtQd+gU/4oEGY3mYmlEYKdPbPXMyUKqTtPjt9M4McDmVHZh+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(346002)(366004)(39840400004)(451199021)(44832011)(186003)(6512007)(2616005)(6506007)(6486002)(8676002)(6666004)(83380400001)(5660300002)(8936002)(7416002)(41300700001)(66556008)(4326008)(316002)(2906002)(66946007)(54906003)(66476007)(36756003)(6916009)(478600001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R0Wgoabn6rgSA8F8VzkwCgZRyyqNE36qDjzj9ALbwnD+WGkgNCFxTkK6lIXA?=
 =?us-ascii?Q?7gXctp/4Sk5EmteqAA/XoR8RKHi/pdAHG6DbvomIDrh9fJ6mJvueOw35TWzO?=
 =?us-ascii?Q?B79/x1ZvqLvaimajtUjR4xYP4cii5heg+rcUosANc3ETii0ok1wEq6k+gimc?=
 =?us-ascii?Q?Kfspi1aRY+8+vX74ljaHKnbPf/Y5tDGTtui8Z4qhOvJyflUR55B0eHpt44Ca?=
 =?us-ascii?Q?cQiivBZs6NNO63q9R3tLY6EsmBfaGqj9bsUST3BAom9zwIuaG3orwi/DzSMw?=
 =?us-ascii?Q?nMeey4M2nCRGNhUOMuhdTM5duYE4lWHOfywP7uPaLfqTdZFVR85fpOpoSic+?=
 =?us-ascii?Q?S3jmASNoFxfkDiSugncGOxxDoBphzS4ufK2puMrHWPZnvmByPxtwS55s946Q?=
 =?us-ascii?Q?nnXhjAD79cwt3YfVy95b4utBecCUs7lPzdCxEsczYa7f7tXNvyJanfprBWGM?=
 =?us-ascii?Q?VXmnk4N8zCSGsY1KGFEVS88yuAOB5WwklSjWwbiWOn1KunomuB4/6HRUtdQV?=
 =?us-ascii?Q?nHIk29/elyBvuRdD1vBm2Qs1apnpcs2E1RSDXIhd1jaYui59zA5hs28TOFm9?=
 =?us-ascii?Q?VCCjcU/NUoPYHV0urQX6PRrsdKm5v9o1DvJ7mm3H57Tj1ddpnnC7Zj2BlsFc?=
 =?us-ascii?Q?uSTxTYr7fB7BZ1GJm4ERha4MRmIEbATDnZ8UgN3jOkYn6UM+4KkAjG8nGyVf?=
 =?us-ascii?Q?msQDr/H5pdzERZy4Lc5SybKX43HTbf7X5+MioZd0xiesLLPgY33tiKHTOGKb?=
 =?us-ascii?Q?QdlWwrSJNBJMBf74t1gKQM1bfmB/G8J8H64IOHjCqoSngwUAdd3ZusNsN2pc?=
 =?us-ascii?Q?GTzNSU9PBxEBYyifRr00Yvyocios3bQtKrjdWYdAaDFqauW2z/8aRhWPsMWW?=
 =?us-ascii?Q?atSGzx/7xYBkbLc/zDnrl/aaB67OuM3pE46xvb/EA36LHHjSg7nxlUxJHihH?=
 =?us-ascii?Q?V6VqEFf9DVZrH5I/f3s10hvtB+KO4Rv9rihUU1Y0iA5LpcEAgcGd8quvtkJs?=
 =?us-ascii?Q?9PgKazDDh9Qt0bh9hoTLxrDqHNFbMd8fprA2r14eT745oiSZKUrVc7Nf+K8P?=
 =?us-ascii?Q?EKsaIwuSC6JTaX31kf5OGS+C+0lOm5EfOHc/cX51jZPQBNOKb2KNNRwY+3Ki?=
 =?us-ascii?Q?BCLCWbKbD8mvH5/jx2YErg1k9dRYP11oFsNl3jFHqE+vz2jHGS+muPDOHlYI?=
 =?us-ascii?Q?keZtQsmbhWXHJ40UV0TGxsa5SWwoK+hPTmdBLV/ee6yJGdsFFd1O7tbboy7W?=
 =?us-ascii?Q?E9MkTP6dq4iLFhTiCh5h5O7baP0J06IvSxk7lagFeh5P/f/5RUxM8XMMlRQO?=
 =?us-ascii?Q?6xnNRceFs0jUoUp1HsuqAhwWJHi6OFjxKuPPeDGQg1M4JdkmWDwImugLQ+Ir?=
 =?us-ascii?Q?SwrX2G9YgTbzUtztMVmk1zVReqrnc38b5/Uzbq8fWUtM1rOc24mytUlFa1Zx?=
 =?us-ascii?Q?m1AAzyro4Kjg8psTavWOCoztficJ20aaQbZ+Z37aMbOXXSPFbfBC+MkxtqCu?=
 =?us-ascii?Q?UhHBOoCsrRHdg9M84v3biT9sZJMVNcd4qv+arqF6CiOvbdeNKrubTx6cJ7yV?=
 =?us-ascii?Q?WGj2uPRtPk0pEpVisBPDkHa5fmptsD0v3RN9GYADLAhkASXZSpxb/ENVb3d4?=
 =?us-ascii?Q?VBkVOvOnKnrrZGi1YHGfr4sjOA4gRNjbg21WG2JWtFOSRIiVRngrUhwdpbSP?=
 =?us-ascii?Q?NyQT7w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7400dc1-dc80-4107-0c5c-08db377d2863
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 15:31:29.5377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uVCbXzDnqLXWHlGxu654/BfmJZjjjI9HUDfVvicuu0fL8Dhj1/vSm6IwmW1Ko2CApHB2ng02Y1PjFHqwNUBqNgvlQE5J/xAHZ+AA2RI4vmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5842
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 02:12:28PM +0800, Hangbin Liu wrote:
> Currently, bonding only obtain the timestamp (ts) information of
> the active slave, which is available only for modes 1, 5, and 6.
> For other modes, bonding only has software rx timestamping support.
> 
> However, some users who use modes such as LACP also want tx timestamp
> support. To address this issue, let's check the ts information of each
> slave. If all slaves support tx timestamping, we can enable tx
> timestamping support for the bond.
> 
> Suggested-by: Miroslav Lichvar <mlichvar@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

...

> @@ -5707,10 +5711,41 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>  			ret = ops->get_ts_info(real_dev, info);
>  			goto out;
>  		}
> +	} else {
> +		/* Check if all slaves support software rx/tx timestamping */
> +		rcu_read_lock();
> +		bond_for_each_slave_rcu(bond, slave, iter) {
> +			ret = -1;
> +			dev_hold(slave->dev);
> +			ops = slave->dev->ethtool_ops;
> +			phydev = slave->dev->phydev;
> +
> +			if (phy_has_tsinfo(phydev))
> +				ret = phy_ts_info(phydev, &ts_info);
> +			else if (ops->get_ts_info)
> +				ret = ops->get_ts_info(slave->dev, &ts_info);
> +
> +			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) == \

nit: no need for the '\' for line continuation.

> +				    SOF_TIMESTAMPING_SOFTRXTX) {
> +				dev_put(slave->dev);
> +				soft_support = true;
> +				continue;
> +			}
> +
> +			soft_support = false;
> +			dev_put(slave->dev);
> +			break;
> +		}
> +		rcu_read_unlock();
>  	}
