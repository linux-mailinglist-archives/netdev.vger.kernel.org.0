Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AA25A3852
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 17:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbiH0PTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH0PTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 11:19:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF583FA01;
        Sat, 27 Aug 2022 08:19:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jf8iD2VWNWSNak9AyPCaRymwgAZtN253+nVlElfkOhhDPQvmxwkuHS47qmvSRm/frrEWH5hnPfa3KT02Cxtm5dlMX7SA7Id2UbTr1g1Q2oU/s2Skf/W+Rd+INgicWdnXT7QiXagSbxKJWXJ25I6JIiYZDZtu7i8TI1xSKonMuQ76A0RG/vso2kJZDO4UQUlPq5h4u6V2dpDca7MQyRQlelMm2qQ91t/x3b3ZuqbT2n3uBmSbblq959yvdwYdp64iBjthd0OG2++sl834ypdMzFodyze7mFtHpVAS5GtmSTj7Wmf5MQrojO4EOHkv0Qz0/iGDrhpWKRkIijNFif3/dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khDW3a22wMfvB0Ciwx9Vs3jJCDNLmXL+yGA1akJm1XY=;
 b=kF/BWFPlvbUlL0P2b3TC2DHG0MS7sVq/tRSPX8EJYl8qevQj3tCTJQIC3fObN3a3RzDqQgn24Sac0MEHnyrYWu1dcQzKZNxq8mnsqGhfoMSmn9kHEdMN7mEFNPhbNKUNLSlin+35KZ5hIYa1PN/uMwntSqk/L1x9+WLDdVmouRzjplvjtt1xvrt/0IgEQW9Ypmip4J5BQaTkWwMY/ssAvUiGdSBn4e3sgzaLe53qJH6wGMLvYrZWLo7lLYZd9rGtIfSCJTiPy2xL/AbDk6vnbRRozNHo18PlCWOqDTrKwoSNHjgG88KJVh8Pohu7h5r5+f660oNTeyY/scbbEZkR4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khDW3a22wMfvB0Ciwx9Vs3jJCDNLmXL+yGA1akJm1XY=;
 b=UWbEkhMjMveErCXb/dIh2QodYKPBO417vT7ckPjxFXAV0lAsdgJA+xkLUt9h1dgvnxnMmIzdymvk9x6M+855Wd6FW0tEUTISolG0RgoZqFvmIWsr+Q7bhBSXJbuMWIb/m5QGNZiRBGZwNMkseBQHT82zY7EAB/ZcBaCpJE828FOYov8WIQT/8t3iYpGTB1FA1VmyODppnpDLF/idFs6XzAJ7yr/OB8NLJm1LnN7UUnSuUPhDLAGgIl3lBNyv7yIgyA7Kh1TNPJ988b+Eaxj4F5WwG/apE3efkGaNH6AFTJF24bfo39VV20CJH/u5LFPqeQeH7Oo5XwxpGeho7bAQ3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Sat, 27 Aug
 2022 15:19:13 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Sat, 27 Aug 2022
 15:19:12 +0000
Date:   Sat, 27 Aug 2022 18:19:06 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag
 to extend locked port feature
Message-ID: <Ywo16vHMqxxszWzX@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-2-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826114538.705433-2-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1P194CA0047.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::36) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15e2b5d1-4848-43c9-f89a-08da883f7f38
X-MS-TrafficTypeDiagnostic: DS7PR12MB6237:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0WJVMo0TAEqv5AoEqKjE4AOqM2VvBRjGovGWwYSOjt/afdtmR/dDWjePsAB2OfzmUjDhcELVAQOgiRDO6krWeWGOd0IFGIe5p1ckJCWEHgAELabbkD/Yj9H671q7BKAwAVAzJ3kgKIbFEwHy88XNY3tzcg/FtBN9ZshfHproMVkSguVwWZRHIQlxAtEs0WU0GApGa3SxeBv7BWp4ywXgT+4kimiJxvqprAR/8gghRPbT27cyp0Tk+eeh25D7uQEB1uk0UgmyqHByFNxxowZEgxX1KKHWDsCbcN5WJYl6wmkeTPc0n+WbafjsJna51rMCpuJenV/NlUpMw25Id20wZeDs6qti7tdvidO5IMaAPat1BsTduXDY2RIAXP2YtS6258iPy80UrJ/gcTevDB/bw1qJ8kPHx7K+O4C+AXLtSfIKZXEZzzyJe1ovHGQclqrpk/759SiHCd9bse6rmf13l/GOrqaX5LoJ/82XDn6ENJiiwWbF8Xhv5dvHrk/5+mAKxjvjd5tQGHxAv2d2VveKM4UcJC36EUsBd1rBV02wwZFOyKY2DUacH/4z/W76iVC1z+5MGVZCKrlHlJQ4R395bDhs9wSzpOozORTABEIDzrKO1bVEVe0XxZ+BInG9ZAOwhJL10CR4X9YanXZqQXZ/fBJlEUEEf1HyIiOWd2xWMvADRAZs13W+XYGQv5QrdzOX89335tmxKEhDD2rTvO33A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(86362001)(38100700002)(316002)(54906003)(6916009)(2906002)(6666004)(7406005)(66476007)(66946007)(7416002)(5660300002)(66556008)(8676002)(4326008)(66574015)(186003)(83380400001)(478600001)(26005)(6486002)(6506007)(33716001)(41300700001)(9686003)(6512007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SfuhZGFnQAImrWAeAkGECEgRIvjJ68mh8cgX3EQLLWB2kBwsX+ZldV9lX0Nl?=
 =?us-ascii?Q?ZQj/MWVRj3fYkBi73CMd8E03R9h9BDOY18JQM2t3877IhLxfF/1HLrvzW9c/?=
 =?us-ascii?Q?zPjvkQwXOMRSK3u27MlTgIOsNPMS2rivemu42f1XLaqQbK2mv2z5pkrbwJiw?=
 =?us-ascii?Q?UBb90L4jYEDtjbx6BpQEWoKS/XMDEqDBfTAeoFhQqsEBrXso0cC6/TuJRPlX?=
 =?us-ascii?Q?rurFFd9MAqebKyjA5FlfGNzTVOWGSHef7t1SScm4GWcJe13bjHWG2o+4BxsC?=
 =?us-ascii?Q?gY6tucENe3e59o6tNWMMojAxK0lNBVMpq6BDIapIsRKrrE3vsUFQDhCVrhMH?=
 =?us-ascii?Q?cy9r3h+c6mEK15hTR2HWtojcIa63DsS2/RTDWqvKTolf2e/Wy6JS3gJx8wUH?=
 =?us-ascii?Q?Eq735/toSCM51TLEIJH7TifLWVZrkC6eNEr8up8r2nvUp1L3v4wQYQQD3my3?=
 =?us-ascii?Q?U7uRwTgmBVaEKChi56OMT9EiSx19DY3D4teDZ4jLLpIuEWaVmy2ozurXMsKO?=
 =?us-ascii?Q?xqewB1v/AJTLqfWTf9GrL1WQV0OdY4yiP9OZMmuQ6iXAZ4omk6az4W8ab636?=
 =?us-ascii?Q?dRJl1xn6rLucEHlQDpaV1a+V/875KAtKO0Wm/35g+1OeyiZnUSp+3D0TSBG5?=
 =?us-ascii?Q?S3HQn/cHjeh6KV5somefB5W6L7rsEnSJ+v6dgAJjmkK9BDUXtjIuzP1fFInV?=
 =?us-ascii?Q?Y0QVlW2hkDBvmJY33TpfDH7P+qsCjgs0wwS0N/iMBlJ/qRQfB17vVQyPouhz?=
 =?us-ascii?Q?zfRUrwHzDHeawrEM8ry79lo7WMDH6EhKmtYuN9gaHPiuugReRVNp89yZgU7H?=
 =?us-ascii?Q?IPHoj/jXnIL2V/LhOLKB1ra1olO6bMD4OB9GxoX5JTmHmpYwzwnjy7lmpwzU?=
 =?us-ascii?Q?8I598CM44jom1aAmZt4lLGMZ3jUYJq7oLhhm8RjXRHDk4kU/eoB8u0qtbd6b?=
 =?us-ascii?Q?jeO/iNr55EWfM40707EFkhYKa1ut3b6TPyNtzyl4eV9J1ociy09tIbllL5QP?=
 =?us-ascii?Q?aNKh8WZeTX5QAG3L8pfv9y/R70gImn48mrE6blEOH/wkYviao9nY0oN8vUsw?=
 =?us-ascii?Q?9eJKVg6UlVEhremWtJO9PaapEaGQHGORh7Xd8pi1nOlDa0r9kOLjGMLtEgWb?=
 =?us-ascii?Q?Sf8PAB7Kx7bjtem8KgPX2I9DDIdC5DYeJnHUiATjLVVEMpY1he/iV0zmxvgD?=
 =?us-ascii?Q?aN01HzyTG2L2H8QyS2p5GTSLB2MpYAfk+0OTQksRlU7lzSVNvYt4wXlToU5H?=
 =?us-ascii?Q?x8f+b+7A96uYOFG950Rojrx5/ulGdIA1TxLp8W8sU4zgrBj+LHLJBJRQ5OAr?=
 =?us-ascii?Q?fz+yi4iDRuYKfgjA9oAG/+LWB9ntIMFb++ULTNygZL2aUTPCYKxqG6m9rone?=
 =?us-ascii?Q?nfTr0LM7HKfGQhqx3ryvIkTM45b9dAWi7Qz8M2FUm0pcDZt7kuLrp7kTWR7G?=
 =?us-ascii?Q?BLDqS4BDIFdjfxMkctKp3IcTFwm+Xm2Xz8ttBjy1dPmQMV8WCdAn1qCG7TRl?=
 =?us-ascii?Q?1t6ieFhXGs+dvrxA084a80bbM8y48mBk3rXstoSxz6MzQ74wI4Uhaei3621u?=
 =?us-ascii?Q?uDAFbehtGavsbTlWxWTYv3CFLvtFdMqnwp+aQc75?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e2b5d1-4848-43c9-f89a-08da883f7f38
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2022 15:19:12.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++3F6nq+ng4J/JYiUvatWkhvY2+u9CEhARtCL6b9lP94OlJOlXpl7tzE3lWnn8CMLaq9uxnZ9s5+bCebr7V8KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 01:45:33PM +0200, Hans Schultz wrote:
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index a998bf761635..bc1440a56b70 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -52,7 +52,9 @@ enum {
>  #define NTF_STICKY	(1 << 6)
>  #define NTF_ROUTER	(1 << 7)
>  /* Extended flags under NDA_FLAGS_EXT: */
> -#define NTF_EXT_MANAGED	(1 << 0)
> +#define NTF_EXT_MANAGED		(1 << 0)
> +#define NTF_EXT_LOCKED		(1 << 1)
> +#define NTF_EXT_BLACKHOLE	(1 << 2)

A few lines below in the file there is a comment explaining
NTF_EXT_MANAGED. Please document NTF_EXT_LOCKED and NTF_EXT_BLACKHOLE as
well.

>  
>  /*
>   *	Neighbor Cache Entry States.

[...]

> @@ -1082,6 +1095,16 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>  		modified = true;
>  	}
>  
> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags)) {
> +		clear_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
> +		modified = true;
> +	}

Should be able to use test_and_clear_bit():

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..e5561ee2bfac 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1082,6 +1082,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
                modified = true;
        }
 
+       if (test_and_clear_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
+               modified = true;
+
        if (fdb_handle_notify(fdb, notify))
                modified = true;

> +
> +	if (test_bit(BR_FDB_BLACKHOLE, &fdb->flags)) {
> +		clear_bit(BR_FDB_BLACKHOLE, &fdb->flags);
> +		modified = true;
> +	}

This will need to change to allow user space to set the flag.

> +
>  	if (fdb_handle_notify(fdb, notify))
>  		modified = true;
>  
> @@ -1178,6 +1201,12 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>  		vg = nbp_vlan_group(p);
>  	}
>  
> +	if (tb[NDA_FLAGS_EXT] &&
> +	    (nla_get_u32(tb[NDA_FLAGS_EXT]) & (NTF_EXT_LOCKED | NTF_EXT_BLACKHOLE))) {
> +		pr_info("bridge: RTM_NEWNEIGH has invalid extended flags\n");
> +		return -EINVAL;
> +	}
> +
>  	if (tb[NDA_FDB_EXT_ATTRS]) {
>  		attr = tb[NDA_FDB_EXT_ATTRS];
>  		err = nla_parse_nested(nfea_tb, NFEA_MAX, attr,
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 68b3e850bcb9..3d48aa7fa778 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -110,8 +110,19 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>  
>  		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
> +		    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
> +			if (!fdb_src || (READ_ONCE(fdb_src->dst) != p &&
> +					 (p->flags & BR_LEARNING))) {

It looks like you are allowing a locked port to:

1. Overtake a local entry. Actually, it will be rejected by
br_fdb_update() with a rate limited error message, but best to avoid it.

2. Overtake an entry pointing to an unlocked port. There is no reason
for an authorized port to lose communication because an unauthorized
port decided to spoof its MAC.

> +				unsigned long flags = 0;
> +
> +				if (p->flags & BR_PORT_MAB) {
> +					__set_bit(BR_FDB_ENTRY_LOCKED, &flags);
> +					br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
> +				}
> +			}
>  			goto drop;
> +		}
>  	}

How about the below (untested):

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 68b3e850bcb9..9143a94a1c57 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -109,9 +109,18 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
                struct net_bridge_fdb_entry *fdb_src =
                        br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
 
-               if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
-                   test_bit(BR_FDB_LOCAL, &fdb_src->flags))
+               if (!fdb_src) {
+                       if (p->flags & BR_PORT_MAB) {
+                               __set_bit(BR_FDB_ENTRY_LOCKED, &flags);
+                               br_fdb_update(br, p, eth_hdr(skb)->h_source,
+                                             vid, flags);
+                       }
+                       goto drop;
+               } else if (READ_ONCE(fdb_src->dst) != p ||
+                          test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
+                          test_bit(BR_FDB_LOCKED, &fdb_src->flags)) {
                        goto drop;
+               }
        }

The semantics are very clear, IMO. On FDB miss, add a locked FDB entry
and drop the packet. On FDB mismatch, drop the packet.

Entry can roam from an unauthorized port to an authorized port, but not
the other way around. Not sure what is the use case for allowing roaming
between unauthorized ports. 

Note that with the above, locked entries are not refreshed and will
therefore age out unless replaced by user space.

>  
>  	nbp_switchdev_frame_mark(p, skb);
> @@ -943,6 +946,10 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
>  	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
>  	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
>  	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
> +	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
> +
> +	if (!(p->flags & BR_PORT_LOCKED))
> +		p->flags &= ~BR_PORT_MAB;

Any reason not to emit an error if MAB is enabled while the port is
unlocked? Something like this (untested):

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 5aeb3646e74c..18353a4c29e1 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -944,6 +944,12 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
        br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
        br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
 
+       if (!(p->flags & BR_PORT_LOCKED) && (p->flags & BR_PORT_MAB)) {
+               NL_SET_ERR_MSG(extack, "MAB cannot be enabled when port is unlocked");
+               p->flags = old_flags;
+               return -EINVAL;
+       }
+
        changed_mask = old_flags ^ p->flags;
 
        err = br_switchdev_set_port_flag(p, p->flags, changed_mask, extack);

>  
>  	changed_mask = old_flags ^ p->flags;
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 06e5f6faa431..048e4afbc5a0 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -251,7 +251,9 @@ enum {
>  	BR_FDB_ADDED_BY_EXT_LEARN,
>  	BR_FDB_OFFLOADED,
>  	BR_FDB_NOTIFY,
> -	BR_FDB_NOTIFY_INACTIVE
> +	BR_FDB_NOTIFY_INACTIVE,
> +	BR_FDB_ENTRY_LOCKED,
> +	BR_FDB_BLACKHOLE,
>  };
>  
>  struct net_bridge_fdb_key {
> -- 
> 2.30.2
> 
