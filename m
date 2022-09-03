Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4805ABF68
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiICOtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 10:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiICOtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 10:49:49 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2047.outbound.protection.outlook.com [40.107.96.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FEC14085;
        Sat,  3 Sep 2022 07:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyUylIJz15wJp2aCV38P245OeypVsAqsHDRpKnr+b6qzgSiovGJWRzTtjzVYtoljhhHC1IkXHLlAn9voJV9U6TlVdR7lVEu8wPs+XEUIjd1KX10M5Ihf1L8CA2+xLB41u2shjxlU6ES0ThABkKtHQ0SyidNOHAfJYj7Bu/O1/Q/CVjmj21RF6QRO+0LkR1+jROj8gzGFIACThcfqmTGNXBB4iaKWWKShlo+3F2hHhPOPFWpZfoNqT5M9bifDGRX03nmTFd+exRURgkI0TIi3W8Q1ic6v6CGAmSjLi/WqNsO+o2qU3Cl7od3B2Vx+VfMfqAcA3mExbbLZZzcQXU9DJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjhX63khefmEPOZBGQ4oiXb3rTJ+88WV+CjkJ1/kR5g=;
 b=OKNmQl/iVou4gNQYYO8HE/zagqrI1ciWnh8CXNKNS86fO8CjewSq3h83ArjWb8nfml2YqJQMuqEXe9yf4SOLGY43vcqRO+HiQu72Cc6G/0xXitAoCUkG1zjKBihZgaOpjmytx5vi9W5aYk4DF6qJAlhYcXl7NKW59ipNriDUXjjaz/ajRo4NZnRS3v0Wpf32O3WHG8dPUqsaULDhBZXubVTXoWNa1fUTkjISrkUmIRVwzMHD/qEGKDyvDkTa98YK/JKY2MYB996gzCBSOiWhzVqeeZXuzDrnmxF7Ro6EvU0uUpWsMQ+z5mPDG8OjppxjpOFQVvyCW6bIPzB0pKrXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjhX63khefmEPOZBGQ4oiXb3rTJ+88WV+CjkJ1/kR5g=;
 b=hesk5c84ZzuLcFFSvtHMnnaNVqSbzwCTMIQzQbmOA4m1VEdj25+7zUhImKEs+nwPP/KXYWG6Dq6m9ohaDd+9SReqTxY5hYrQoKQcgZvnRSpwUPCiW4PlISrW1ulA8zRkbnjbY+QhU3KQhGU4VYu+a/waXp5AbO5YAofn+Ad7gTs8H1NpqT26osMIkeRT26lZL/SDL3XdQQkA2JXl8xcsHd8tSe2NOni0ijWjn1llczEKl9Ro49asKJYHh23oVHF9DEhcYgu+V7+UusVn5d/C6pPDKlun42+omO+O68uxweG8SbTXgvEnM8MP5ZdteZdM2Wzq73DJiHC58sJaIECA3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by CH0PR12MB5234.namprd12.prod.outlook.com (2603:10b6:610:d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Sat, 3 Sep
 2022 14:49:46 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Sat, 3 Sep 2022
 14:49:46 +0000
Date:   Sat, 3 Sep 2022 17:49:39 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
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
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <YxNpg76H9ma2zNhZ@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
 <YwpgvkojEdytzCAB@shredder>
 <b28717f593461865bbfa6bf12e99a2a1@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b28717f593461865bbfa6bf12e99a2a1@kapio-technology.com>
X-ClientProxiedBy: VI1PR06CA0162.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::19) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e633807e-d1c6-4302-ca37-08da8dbb8b56
X-MS-TrafficTypeDiagnostic: CH0PR12MB5234:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RL9XyU04O7kKKSbGscy7EMW//AjAYM+zqS1X5ILt7nYrmJS0RFu9R0uyrDs79GTDDpWZO/J8ZQZrhfMFJ7EG1LdugqmTb4TLK9Uo2qMIuIOBuQzgdrNc78MjgJ8CRIS/OQ0CyXo7LTA5joNHxJXE0xoRaNFeLvRFxD+s/l3dRMPCVmsnHt1c801wjHlfJoDM2X2+o/9sE12bA/0xBXt6YBsCkTGMScuAxiajzcFwy8D3hOYvK7o9UzTFv1KLdmfqBvjdG5flkcprjkVYSwwMhglmCFXOf8kvoEdmnV/gAd+1G0cPoIbeGqaZj78PEH27HJnDV27augSu5Bj6s6E2+tF3iX9JbcYNyFHqO+Sy2ezsibJpqSVQ4rP/3/zAF35oACgaARsnJ2jrUYfaghT4+rlxC2XbE0UAyv96+wIhRK8POkkue8gLmDzx856FMH4OSmTvLH2eJ/2MCvIlUxdSNyzHumfgHKeFwTlvCD/oAE9f7IeTf9dcJCH9lGWCg9vE1H2dpvIL9qrV5Gx8QPCgLgviCRQPFNSu77n4t/kaqfiLBMjClPgHWD6Ny9uQdM1t6uWYMCW2JjH0uGam/2oCNTG7C8lpvfgSXjniIuENb4n2hC6jj2g1DD3BnFHX00WPPpTidqPPRl6QIPX1/wxI1bNNuW7sE9p6IsKytekNfXHbrBQPaXrDfs8N3Bgf9g7Ke1Ll4OivugXDx9U/dWZ0Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(4326008)(83380400001)(8676002)(66946007)(66476007)(66556008)(5660300002)(8936002)(4744005)(7416002)(7406005)(6506007)(26005)(53546011)(6666004)(478600001)(6486002)(41300700001)(186003)(6512007)(9686003)(316002)(6916009)(86362001)(54906003)(33716001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gOSlLBjAUVRGbUIikaO0eu0oyttN7zWB+io+gms0ihmdyb5K5wDeJi2UN6u?=
 =?us-ascii?Q?U6F0Rb3LXB5fuOPgJ2YFxBF8i+8zOsI2RVhoCOC8pQGDkWPttoikK0X2/yrS?=
 =?us-ascii?Q?/DbBhepxN7/4OM4Mfl7YJgQdwxS4IfggyznAsF8gojkTQujI+uoZTEPOtyAo?=
 =?us-ascii?Q?IGmzxtod6TFtaiNc2uE44rDEwcon7dCUgvCT/TPTecR59whveMFsPw+2H8ZN?=
 =?us-ascii?Q?pkFUu1aW4s2jDJss/PR1v5jVwoFwO1awEEv8q3xiWEQ/w9CvJVWNSHZv+P7X?=
 =?us-ascii?Q?fDeZK1K+hmesscALueHhHAo536LDW6ro4KZ2sm7YNmKhJVpKXy2ceY/0joJo?=
 =?us-ascii?Q?mIGDHGqlOeYtBQywKsqe0AFoevmRNxEMnqzG+pAMMaBOivAmGxiPwM8LHawB?=
 =?us-ascii?Q?7KuYufTNjAQPsSN4Pl7xP1Mkze3ZFKhhuErGeKzoMmY+RrT6sdARVESuGnyl?=
 =?us-ascii?Q?TIruZVZr+YiE277Fagcf2V7wanQ53Vs+85qx8ZspIZWUE6P1rGtmFngv0ZDc?=
 =?us-ascii?Q?YjOh7RhLdMqrt0790HbXZXIk5WmIlNks6bL4wN0+vpTNqc7ixeKoV2zyVzoL?=
 =?us-ascii?Q?8djik+Nu4J8Du/ZlNLn0+wQsuYz60of5gC9WwJzgFzi6zE6ZmYr4QauETX7P?=
 =?us-ascii?Q?sLlB4KsccfNZdtXRN0qIMStnAzLbun/LGiGW3VLOoyvC9BfTDrb/ZPBdwN5W?=
 =?us-ascii?Q?oOfohwbDz5Q+ezx4Q+r2+ryfHPZRSPKMltMTbMWjW3uvrCq1nK0KWHZu1nkU?=
 =?us-ascii?Q?NZ+m8RCoQWnXG8sD7fLxg8/rznAW8e+Yh2ZrN5UePpD2+NZsmX1crt0o6v8d?=
 =?us-ascii?Q?anE8XZBrvKv5XBavciCwHtq3h/00VZsx36kBwF/ahYlPvfsWpl/Q5fkox4x4?=
 =?us-ascii?Q?FQ+TK3gZk7YLhRSlVdyriUIVTsLYjMM8l9MvddhWzBf8wiMYHeBOcVap7ffE?=
 =?us-ascii?Q?hizq7JrEzsEbETpkj0i0vcmx0kXPKm6VUcDDcIjGxkAwx7E89FL+w+XZaZIH?=
 =?us-ascii?Q?Ww+8wsn4MU9ryKarOtwwMWqAxEIK+EuwkYKlKPLgTq3aSG4JsPtLgOSqpUWj?=
 =?us-ascii?Q?QxkKWz3nfHCweot4OGa6KR9avL9NXBbpFJWGMr3QMP1dRhpJsV29BGlK0RoH?=
 =?us-ascii?Q?mekzqGLe4edaUFgKmszbEmbd4a7Idef5dzejF3bdzydhqTwRJU7jsLRgmV02?=
 =?us-ascii?Q?tllWT3oZ3df4cRvyqLb4zNVka6sF3UPbNqj7A9vADvcU7y6jl21t0aaAWMz/?=
 =?us-ascii?Q?9qEXcp11ERpyp9ZI/daTK02WQ3o19nwy5eDJaygRSBV2+MumuDZTJrCOXclB?=
 =?us-ascii?Q?kSodCNeWKl2zvZ5vnilz8xLtZvCD+qDtFCiGqsyXZgjwRSH6LUTSPIgXB0j0?=
 =?us-ascii?Q?ILNsjHBHYZD6//anStiv8TrGDPn+sgq2OzV9fNB47kDKukCrvgeNZZjDPOju?=
 =?us-ascii?Q?0IYTKqbxQUq0sS4uJODdqr0OO0auEW0UjHCQPbxn9tfAxsMk62e8lHUDcKk8?=
 =?us-ascii?Q?e7S2JlZdrMPFd2uaiTj1p3jHj6ds8xw4qGkYo1eINEYXhSTk79jXWG08ferJ?=
 =?us-ascii?Q?i8aDOUI0au1NZk4DbArqDd+u8ropDjAQnk0Suz01?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e633807e-d1c6-4302-ca37-08da8dbb8b56
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2022 14:49:46.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXfPbhslE+SnxzmPzzHxsUlGlKTdH0WAGSGSktryMDe0XVfVJTxgh7kguuU0NDy9GrI9mcHdLSN3DhC4E884Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5234
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 06:07:59PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-27 20:21, Ido Schimmel wrote:
> > On Fri, Aug 26, 2022 at 01:45:38PM +0200, Hans Schultz wrote:
> 
> > > +	$MZ $h2 -q -t udp -a $mac -b rand
> > > +	bridge fdb show dev $swp2 | grep -q "$mac vlan 1 master br0"
> > > +	check_err $? "Locked port station move: Entry not found on
> > > unlocked port"
> > 
> > Looks like this is going to fail with offloaded data path as according
> > to fdb_print_flags() in iproute2 both the "extern_learn" and "offload"
> > flags will be printed before "master".
> > 
> 
> The output shows like:
> 74:e1:e1:2c:4f:18 dev eth8 vlan 1 master br0 extern_learn offload sticky
> locked blackhole
> 
> "sticky" will of course become "permanent", but I can still make it more
> resilient by piping grep.

OK.

> 
> I suppose that I will keep the "sticky_no_roaming" test even though it is
> not really needed here anymore?

You can send it separately if you want.
