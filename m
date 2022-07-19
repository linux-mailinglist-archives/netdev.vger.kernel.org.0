Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF425798A0
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 13:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbiGSLjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 07:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGSLjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 07:39:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5602341987
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 04:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQa/wyeINcWBrlN0LhJ02mwKDxXt+dkdHzFzBWXBHoAFGDrM2hxO32qTQJUvsrSmnSXsUkYZ1rZo7+YQ/ubNnB7/r+/j+LHtgxvfUT/RVF0wBWudYasy6SlpfcfLkBynDRYwi4yNJ6WxIknOb+ao1253TbHs8ZMGHDiHFlahzxIg3vcDQU3OHLOa+ypbVd8dKGHDhBTur+ynVSBgalOa3V7BfhNXR2JbvgpMKaf2yQ9MnKq93AQCCrf93NY6xCFDNsqUa4fYqDyiaHtL2KsY2gSsIr+H7HTv8r0njuEo4u4KejHfM1S9CZDAlmOz5vlr8joVJ4gTuu09sKM/XuJ+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7e6xnqKNswFkkgGkwQccYFZzxKvfdah6CzAn03r3B4o=;
 b=ZkZh3EpmG67tuwvLmpItdNjv+Hb7v/XJ1+mXm0Nfc5tonZD2Hrzy121NF7ZuxxDFA54BmGaWfaRn+g/XFYqznka7cKtb61+cXwSwZekAVIVwdWnbAzSrj2Ww193twK9VOJotLTp7zE0gKPjGrXWzu3XP9PkJIH8Z/ZeasK7/LJ+/bO/6tE2odwgZKEc53pXT0QSaQZkT0xdUg2I+g/ySrWYP/vqBGJ5K91LdFrOKe/1JJoN8f6B3TiJf2jAiAIyQp1MtDpbL5wCHpJcunCJn9YgPg3ypT3ZawFcfVtR/Q0YzyJDfdEaLnZlVYWdj9sHJyZadiCubo5vW8ny5mPOXjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7e6xnqKNswFkkgGkwQccYFZzxKvfdah6CzAn03r3B4o=;
 b=dvmFxr0JhyRF1wnU1rBmRaDXIP/UTPpn+SxBWzKjzAVlKHM5d24s+ZZIYCDzyQbkfGxWn6aqZXo3Vs7oEctK9FGHPlF5lLIGOWcDxJEWDWcWoiKcBtAlBZ9wEZA3RK/lJn2UbzFkgNaTR0F4wiDusUsWyFY+gNJ/OL5vB+iBnOuKVrPb2wmKJ13tP10UBic4s/fobRzqgLzKZObDPstxsuLT8Jniz1MdacN/c63Sx0qjmWeyBYCveM6e+V1YCIwzDkL5SAJ+5q1DC2qWd6W3yTvrUkmMIwsWlT26/2t3sVpnYXaabhP/ezem538gkvlcL2u+eEGEcbzP3JS2SUorRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3130.namprd12.prod.outlook.com (2603:10b6:5:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 19 Jul
 2022 11:39:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 11:39:13 +0000
Date:   Tue, 19 Jul 2022 14:39:07 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 01/12] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtaX2536pQXe0+f1@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-2-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-2-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR04CA0092.eurprd04.prod.outlook.com
 (2603:10a6:803:64::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e90fe70-fe17-4b97-72ac-08da697b4df6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3130:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1MQeZvpPpgjc/cE7bpEM2Zccvj4Fzl4fYyv7+mOmFBomm6PMO1XYhTSLDilt6qj+XGlR2XWaMqg9ncU6r7Ai/PNaAVILMpWxEP1L5PQgbqq8Y/32nNxeNf7ZOOl05yu32P+Egmtzneu/ihdpfxUaqyHF4F6qhxzVgPJqwPCBiFDdeRQ3XGfZnian+ZQGVzwGSDICzunTuIJUzByuNY9Pw+CvpEeYE18hNsOo0XTGwdmrmBFgqZ44VA1LtmptJZD7fYoSkP7CAjJPbyKSSh0m33+BcVeNhZ63yflKZP6odOnVPYv6kyuGxWs7RIAI4XDMCX3Tp1pfDFbdyfMDCtkN0UAj0TvQAQfyGaeLyEJy4CShjlaBWmiYhR++VrQBmzFpLPycRreIrQLGJhTd/EWT8dig9YFaxIPpOYJ3uqvRhrTvhoDya/rsTJw8xirrbXVLhQ/t1sKPgVhNLKKjTZ1t/Oit5FE5lzOGHo80Z7Ag7INtOSWraT6BLZHNO1mInHPWDyWAD4T27//TKt8bVzBY3KIN4eR2LuEuwXd2MSS9sLl/wVWQDnUiUHKWKNWN2hieCjAKxRDktdVWAnbsrS1bGH/10BAFoD6fj22KpsHtimwbvWNEfSWOhLnoL13oKM0bxTObycpa4Wq2ophJgh2W7dEAuxthUDMNuoXHv+c7EN8jIgY60AgKmaXCrlVZbRmjSVBmD3YntWOGXzW8+Ss1ABSFTgXNHqABmDTVVUtoAvuvT4MFyZD5sPOCWaiZlXMhBDf0sF6lSvEAg8cGh+pVmoXnwkBOpv+FlniThFJZxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(316002)(8936002)(66476007)(4326008)(66556008)(66946007)(38100700002)(8676002)(6506007)(6916009)(19627235002)(9686003)(83380400001)(26005)(6512007)(41300700001)(33716001)(6666004)(186003)(478600001)(2906002)(5660300002)(6486002)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0GlM4yxmOZFuWjKrLXgLgs0Q0aF4HAFzFybn+cKbzO1GRHhSYcR/DVri6+vu?=
 =?us-ascii?Q?lN3fQcVQVN+ZtE4HtWWmzANEIQErIQ1TSBJOh9muGaXhqim/lbUck87RqtIJ?=
 =?us-ascii?Q?SVOJtynPk9x/co9xgdXUaJG5GFn/4i8LaqibGV/sE7NMVIVc6VTozNqbtkSP?=
 =?us-ascii?Q?SVvcK0E7IUTu8cMDspm2zWAhTol7ScOBVGTSbyzEAuO/Sl+l9ufl/KOc/CZH?=
 =?us-ascii?Q?eVMkRjV2xX4F/nqZtjtZfEeZ30j6ni+UoSM+/56xy+CMG9b2uBHIFk56VSLb?=
 =?us-ascii?Q?dUyNRmRKFQPXprlPEmQXkQ0v4Wghkj3rN9HyUiQiCb0GIHXZ9uOxH/7uTAKk?=
 =?us-ascii?Q?4aVdzxSf/ddl1bsjZr3MN6bzw5zR4ig0ud07Nbha/EcCU1vW7KwuUaTAZApV?=
 =?us-ascii?Q?g8P+N14nAw/f3hXHti2B9DX2sy2eeVnnCTrq+mnSolLBMELVcO1SJSXyc9gh?=
 =?us-ascii?Q?yNHgyMQenQ6DVEDWW4LHS+Ztdz8JW7KTThDIJrvAHfEUSNhPL/a4Mzfkj8DL?=
 =?us-ascii?Q?lj6rz9wX69x2xcC8Xt1BuImLEvsbIdGQ0tqxY9TagUPyeJKyCRr4aeHZs8+4?=
 =?us-ascii?Q?QdhYZGorqrPbxmrayR/tuSWq4uvKeD2j4xq0qvFZrPBc4sIzg9IH89u6n5/O?=
 =?us-ascii?Q?eTYu4dO23y61Wjnd0UzFCpnVBsqmrtTv6RONjTr3Wv3LvRPJ/e9sN7JHVkKb?=
 =?us-ascii?Q?iF9xBhkz7Jl8AdUUaf4lICzDFczYFHIN+TMjijHdetKxjmQN3tY+aYgc8hNk?=
 =?us-ascii?Q?RcrK7jYtvVMpXm0lk5avSNodAvuWsP2NxIf5LIcgtEW8xmMBroqKEu1PPaxe?=
 =?us-ascii?Q?oIAc7sFGOpSBdY/oLV3jOPoJiw7gIBvQ6zIsrAah9a2d2NDHfCc9tFlQcPkW?=
 =?us-ascii?Q?Qf/BDe/fU0qvZQmp+R2dUkhvo+0z1ICZvKqOpInKbAy1j5kVPgjodqnDvoau?=
 =?us-ascii?Q?9StyofiQziJK51yT5WzqeBn2Bd9IV7WhAGljW8hjb8pQSzz66566GrzBVV7h?=
 =?us-ascii?Q?r6nYhnpcy3CdGTcznMajJeOUNNuBP1uTNWp25EOC7WOvJxuQp3Zf7z1RMWoO?=
 =?us-ascii?Q?ilMtu/sfK6gtp4MedU2aWdwcY7WHuPMiENcCUvS2P4NJdfu3MHryWRh3xuAr?=
 =?us-ascii?Q?mZNxa0r6dEsASAC4KLpKNi+Q9p3REVWPbwgDztMNy2Wp23qfiOWBq3TO+4lN?=
 =?us-ascii?Q?QpKiS8a0IfghpTTR6iluBs1hmUv6XCp/BwzpcIISxNHsO/t3gdQh3SgvOFT7?=
 =?us-ascii?Q?H5tQY9rQuxbeOZgpuDWd6Ckuyccs1+rYWJ2xLvPp73q2cMhJLImQHAKPv9h0?=
 =?us-ascii?Q?vVuJVj8eyS1LCyWlEJ5Py8wVAfnpSTHymGiDITuH7xA9azEf9Ave86KqGmpt?=
 =?us-ascii?Q?1pumU1xlfBBL2NHWTBbO/30Ih6kEAEcUKwrEFmca0/FQhmF9H6EyubLclF/k?=
 =?us-ascii?Q?0eHJK6F9xBCbR9QpWPrykJIVUKCaivkk8rVxPLYF2hkUa2Ob1luEfLB3ndZA?=
 =?us-ascii?Q?nwM33Sg+9myZJ06m79w1J74nNTK+Ld0HBGYQQQtevYT54N4HFyYkxp/dPQVl?=
 =?us-ascii?Q?/lxpnrh20Fbau9jlKiFUps+k2mhhlkDpja31sMQQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e90fe70-fe17-4b97-72ac-08da697b4df6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 11:39:13.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5f+7ieWWNOcd3F6AxYM+iNme0PoqpMuZBO/i9j/O1xXyvzxsdk6ERyLjrUyo3G+3+npBRNUtW3CqQEe+u5d/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3130
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -6511,9 +6566,11 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
>  	int err = 0;
>  
>  	mutex_lock(&devlink_mutex);
> +	rcu_read_lock();
>  	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>  		if (!devlink_try_get(devlink))
>  			continue;
> +		rcu_read_unlock();
>  
>  		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>  			goto retry;
> @@ -6537,7 +6594,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
>  		idx++;
>  retry:
>  		devlink_put(devlink);
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  	mutex_unlock(&devlink_mutex);
>  
>  	if (err != -EMSGSIZE)

The pw CI is complaining about this:

New errors added
--- /tmp/tmp.Lx7CWX0u9n	2022-07-18 23:56:05.513142294 -0700
+++ /tmp/tmp.SFcuLwts4X	2022-07-18 23:56:49.917188829 -0700
@@ -0,0 +1,2 @@
+../net/core/devlink.c: note: in included file (through ../include/linux/rculist.h, ../include/linux/dcache.h, ../include/linux/fs.h, ../include/linux/highmem.h, ../include/linux/bvec.h, ../include/linux/skbuff.h, ...):
+../include/linux/rcupdate.h:726:9: warning: context imbalance in 'devlink_nl_cmd_info_get_dumpit' - unexpected unlock

Might need something like:

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0e8274feab11..5a39a02b6ed6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6611,6 +6611,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 			err = 0;
 		else if (err) {
 			devlink_put(devlink);
+			rcu_read_lock();
 			break;
 		}
 inc:

