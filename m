Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF3D5A3983
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiH0Sea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiH0Se1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:34:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A26BA1A75;
        Sat, 27 Aug 2022 11:34:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Su5ud5bxDHxEt+cz3h1vB7nv8U/4nT4WqGGMizNT77B0SoGWOCAO4r6GbBx+CR5LNAGst8NyOc9tc0l7B9CDTg06rvOQ4Y+5TiYrRvJIsnCzkZ5GVGeslwAR+Jek9YBSQVjkkn5+P27/BD+xMhIbjq4yDT6cX5zXdyzcSmUgpRqONNd6P0372nDp/7zTj8CzYREXTpKGTeHyRsd/sBGAZEGF3FQTZdvWtP7B+zj87e8kmxleFWKw67k4FLWhXZ44lTDAm93x9bnWXWFy4o4zymyBXwkfe3u/NvZYNV2pLDy/r3MpGmcUbptBq1OkJ7iccBQH6DQMWQZQgrklv4+J0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2zKEe2WpPkQsCm9Emx4T56l4ghxotjkOXeaugFlX20=;
 b=j02Gx1b/KvWNQMMKtoXQP49DVlm7F8uzKxDNTNsgI1wXQbco9vWbrvou5r3fPxDSQO1KKHMJjmB2hSWqGw4b0BvdvGzH230xEEgMkUoLnFOx0/kEmKjs3ivxt/oDA80twReE71m42ZqFm5x0nfgrvN99ixvXTnL8LuRqz3n476dBVnN/mLKu3/BFqhX+FcYLRuKU4MXm8CwkpdQOtOwJizoVnOojSGp3cDNkr/4PI1WV8OUp36ikzcOyVE35wwA9dT9qv7ZtpKkL2/id9N5QsR2dHsvduGgbq8p5tfywcfaBvXEomBkiWr/uRRlyrvGUQT9tgDQSWvaZGJvUv3F2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2zKEe2WpPkQsCm9Emx4T56l4ghxotjkOXeaugFlX20=;
 b=IYhrKQipjnaKq8ePaUTD1JWYBTvn3bVHXWUJh3SPomCwtAeOQBZXSHxZBR9NBh85rin6Z1bt9qdfuwARYRxHEUxZU1q1dKLytffX1fE1GlmG2LMXNtY8Fcg/nRz4qtYXTDEA1sq6GPge3x82YSNcW/+NsnCjCS/UUZqbPJ/W4rQ/vvdVTN1X4m7RbVBbNqTYK41mzyzM6t7IwKU5UTQzErn7HwNgEB76MeaixCI9o/QNmCe1MLeC7p/LIKsdxB0cddbwuEq04+QN7fENz5rNuk8r2+8Nl+HlwgjZ85Jz3Vq0E5ClIM6Y/KioVNul3IZof9i8nt/8/nGbcS95bHP3tA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Sat, 27 Aug
 2022 18:34:24 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Sat, 27 Aug 2022
 18:34:24 +0000
Date:   Sat, 27 Aug 2022 21:34:18 +0300
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
Subject: Re: [PATCH v5 net-next 2/6] net: switchdev: add support for
 offloading of fdb locked flag
Message-ID: <YwpjqpmG0YaisS9J@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-3-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826114538.705433-3-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1PR09CA0078.eurprd09.prod.outlook.com
 (2603:10a6:802:29::22) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abc6e43c-8be5-45ed-45d0-08da885ac3b4
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RIk6SllFeVH7gKq4EViFTlknFuzpHLG+19EttF07qr3l8kjhlFNvngjBfQrbzsv0FxwWD95woG6Wc2MlVX24tMO9leiw96Lbn7Yl+E50n6/vtAKpKSTJlY2fBzFOCNsR4541uE3WBFvxBe4bnkobeFLO/SgeRpX9hMAXpvgIlxI34yMJZs6APw7BujwKO5S1xA4D4I/tf9nOC2LSJq83PtvhFG3ET26Erwr+BUOfhtMQejGQz0sOJ5dvTXXHJU1hylvxFG1bVafWAitd78x8l6wyAl/Cu1/xlUu0PRRFpQk1fbYbYYLTzN3LYbRymcYEKRlBACitCM8N8ZqguXyO3g6j9wR/ZDMQqVpslH3Yo6OTzOLq52m/TlBFpLzDc7fpkaH4S9JGAmLulStWp3/96vtXUQswManOYj3uHCQH7BF6D7nF+7kMO6bs5QE1Rdboe78HydMtSs0ZmcUNvKyz3jrXSeFKFx7x/5p+CQwakX088TIFA7QYEcTfhhgG032pFYO5flFCgQxyIi8bPMJRN9Q4CMl/pERp7cLe89PSyXLZgjXIdAsT9XLFxZZ8M5TkBnQxD/FrB3CpZaZDfoGPaEGwMaoFm18ZTXKo/Q5FglO0mf4jlEV5roymop0DEPoWGJCbFqGHqb2RMumVXu8Ylr8kPsq2HQFKVrSuTOrS8FIidzFNhK9LsdzxURLCq3EniijsidQ3N3x4M8vJ4u3noQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(396003)(346002)(376002)(39860400002)(8676002)(7416002)(7406005)(4326008)(186003)(5660300002)(66556008)(66946007)(66476007)(6666004)(6486002)(41300700001)(478600001)(33716001)(26005)(6506007)(6512007)(9686003)(38100700002)(86362001)(83380400001)(6916009)(8936002)(2906002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dM0jHhN9s0q3FhKRYFnLUsBgNxdWy/OJzh0O+wUze7cy8NDWkm1KE+MDyuaF?=
 =?us-ascii?Q?vGFJEhbn/gbEwiuCGNv5GhgjVjRncWjadjbPjyIID1FjZGe4U0x/9Ex83YfC?=
 =?us-ascii?Q?p7IiHeUZUE87P8VLkSEpV0J8BjKV0hfY2JQpu+Wso8kl7Ur/Uu0Q/XpmHAJq?=
 =?us-ascii?Q?oONtTsAZE4NQvJfGLzOBm+CiLBEwVxuPYoHOskqWmpyt4f4EgIzMmuzaWmxW?=
 =?us-ascii?Q?yJY91h3As1RBrwJouNyWY4X3F2qQX93+9rzdz7TaWNxaHZvERhoF7jvMNIAi?=
 =?us-ascii?Q?X5t053afs8i8h1UeLnwcue8yrVzmnBdnHfgIheux5teQquAk9Xwy5HnhcCSF?=
 =?us-ascii?Q?VU2id96Io/IH0XHFZ83IXxHyaZSLUF522hZsXp33st+3FYMWDbX7w0w5Nnl/?=
 =?us-ascii?Q?q1cowp8VLjPljlxMnIx+Yc9cEaW/eI59kiCfV/f6jzc/0SdQ6PKRcOSy2jaX?=
 =?us-ascii?Q?Aut95AGnfFC5YYBayCILxSb1ZMmlb6B2DBaP5dYNZJ+pTcbDnwCsAIHPxi1v?=
 =?us-ascii?Q?kyigW0IXBUg6QAqNU7DfN68OP78xchsjgeZ98cbLP8djlB5JcQ7vOic6cZDk?=
 =?us-ascii?Q?HylPAwTAWuloTfIwf8Y8q9cImIgcjc6Rt7gMR59Wobm6RSCN2XObuLxfqGW3?=
 =?us-ascii?Q?Hj0Yo8MGOz6w3IOH2Ai6OuzpcssKFCkLEdOKSQb6GzJp/qszrQwG7+6ALBY1?=
 =?us-ascii?Q?gH8SvO2R/hxdqJ2v3x+sud0MiagIp068jPAWM6AZUxJOShmuFv+Ct3Vs8TmP?=
 =?us-ascii?Q?t87ijd8YcYQcVYqV3J6iOuVKCbG9z3DZn9nKAKRAHOWCcdTxSNd2PrXmpAdV?=
 =?us-ascii?Q?2ImtHwDIOSBzoXSmevCF2ndFvAWBh1jsuaeuCS8Qo0vehxWLOwW2dWTt4D5i?=
 =?us-ascii?Q?1MLr2ZgJkPNq+kHy0N9R3SOrHYrq9g6yvkG9DtrY1CkWkP9nYBcdn0jZ/pxR?=
 =?us-ascii?Q?mcNrBDbESrZFl+w+lTKvCqiQZK+S/SYt+mXmqaUMcJRVRD7AI2aPPhIpdlO+?=
 =?us-ascii?Q?m2ljD1FJSjr5Trcydg88K0VV8DwlXognn3pkSMYzg4KDEVHT7QwWKfrBALnV?=
 =?us-ascii?Q?hmzkh6wreRz95NRVzedAL0mbtDm2oHFW5PxorUyo6lQMqCBrN+GC9o4IeUMd?=
 =?us-ascii?Q?FQzLzJqTfOFfLBNuGfwDlukSP4L1Q8+mPVfgGqFabUVhTIBpybpce/Ma0HZC?=
 =?us-ascii?Q?PLtBdrhTemooPuyqhkz/vmSN0iAgENEmbLBICkfAh7WOMYVLe+Cs8sqOODdk?=
 =?us-ascii?Q?L3JQ+eDNa75SJRsPfLzPYjgN+dT/SrNS7ZO6tgN+0rwAdA1Wjyh4w8D6FPR7?=
 =?us-ascii?Q?RxzD9fwJbYcoELQ9eJTEfcpjJ6vWMwFSuXpTQjKFGM7Gdy2lQ8l7A0qhciXP?=
 =?us-ascii?Q?b42XbRobv+sQ3HhZ9wTsRxzrsZq1c66gpT9d0ABKqWb6jqrkOOOZz5VkmkRm?=
 =?us-ascii?Q?eMDl8ykRRA71GsuYD3MadHDWS+8xG1SEK3iSaOV2GWQeldfWrRG0LCJ1fsoO?=
 =?us-ascii?Q?yC4OT7Rjp7Hnw2PQoX5hifGxagqcnuU+YPxtM92jIBpKmhbh6fw+jOp03hgM?=
 =?us-ascii?Q?cDkDFq6It/X5PpcyxjQV/NPdNl8RkjWREXWWkKfX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc6e43c-8be5-45ed-45d0-08da885ac3b4
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2022 18:34:24.1589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z69RAzFS0nFZOzE//Hah+qlE/b1K/XyPd194cHmA8yHMAWFmG3nrbMzshBPaczSt2N85yk8WP+Lgw4ZRwA4FFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 01:45:34PM +0200, Hans Schultz wrote:
> @@ -1403,6 +1404,15 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>  		if (!p)
>  			flags |= BIT(BR_FDB_LOCAL);
>  
> +		if (locked)
> +			flags |= BIT(BR_FDB_ENTRY_LOCKED);
> +
> +		if (blackhole)
> +			flags |= BIT(BR_FDB_BLACKHOLE);
> +
> +		if (sticky)
> +			flags |= BIT(BR_FDB_STICKY);
> +

While reviewing the test cases it occurred to me that the else branch
(FDB entry already exists) needs modifications as well. Something like:

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..48f842a71597 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1397,6 +1397,21 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
                        modified = true;
                }
 
+               if (local != test_bit(BR_FDB_LOCAL, &fdb->flags)) {
+                       change_bit(BR_FDB_LOCAL, &fdb->flags);
+                       modified = true;
+               }
+
+               if (locked != test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags)) {
+                       change_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags);
+                       modified = true;
+               }
+
+               if (blackhole != test_bit(BR_FDB_BLACKHOLE, &fdb->flags)) {
+                       change_bit(BR_FDB_BLACKHOLE, &fdb->flags);
+                       modified = true;
+               }
+
                if (swdev_notify)
                        set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);

>  		fdb = fdb_create(br, p, addr, vid, flags);
>  		if (!fdb) {
>  			err = -ENOMEM;
