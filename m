Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A165F1D20
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 17:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJAPBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 11:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJAPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 11:00:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9265DFF0;
        Sat,  1 Oct 2022 07:59:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7psDqoiLrowETsTxbDZucWtUpb2mUHcWHZ/Um/FFlTgW9TE0mUJSXbFci8emjjpSghiTUGZ2Dn/tUzaes7Rb0My7JWngbxTkf1sHltjM+WOczbq2XZANY/7wogff69h4tm1SSBqQg0bNgN7bw39xUwVOAaWsi4wNgzGjmH2VdisWIbe0rWEnwHgqMUm3Pl14cvcpohmyLD9nAbsqIF8XHNyBxHZJWnIXOh9JAEux/GKWdb0D8FL3czFEs78ApsQMvGhMNnw6HuItZlod22QPrWOm9npCLGhkjU2bdQwGlZEyTDBYU8s2KYQ9VSGjpxy318COXOXCeSNDwmMrZgNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QUVH/3JWJBP1Si9vvcJT87VjRoHeZjTl52mdbSoxgw=;
 b=TE+6YkcHhrwW7w898bcmvKzB+S22NxNzgcAzMmZW7bt/MCR2rcZ3wl59BorYqp5+jmeO0ijo04ANNL3vLCGfMTvQLWqx0pktHJM5CmB1BcCeVDITUxEv33C5ULtWNnTSgsFwxuHBPPfsaFoH0zojjzeWUkLcwS78DSuKP/pqbu8iwCWZE7fyZSf932f35MPTyuAsMWc69PmdKMp2HFAAWFMqU7JQjjI3fq0fq3RnUe1H0p289VcyRA4xL0dDgWa4/bgGz3kj9vAN9HlHK3piCMQ7QHz+EztZVp2BH/53eXT/oJvCX7v7zxEYMoVZrMu48R7C7AfDEYxVhQRny5u5BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QUVH/3JWJBP1Si9vvcJT87VjRoHeZjTl52mdbSoxgw=;
 b=USMNnR/qN7Z3fY3yO1iVK0D94ithP1oQyipv/JjHMJYXs2hFjMPbTrJ1Urjea4PfrBLjf5OJbo58XXEgJN7IZIWLTNCGNd9h8c0+fIxuuddXqudo75M/Sh/IBf6CXpkWxbw64fviflvVYbo66GFFzCSXmwss2FkleHVNM8EdhUGLDTEToy6eocHwdHE4HZZIePGcNLdT/iUXCmvQoFVysoVLhhJasAatfkazxswEB0lcQJ++zGp3ChX+lpCoxtQogPCa9amyEuX3RcvrxvudqcBnLZ/4mt8n53MxTykkxSMlYu0VZa3Ba/vv1HfK3Tkaseq7lor0YfMAyb11kBCf1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4397.namprd12.prod.outlook.com (2603:10b6:806:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sat, 1 Oct
 2022 14:59:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 14:59:37 +0000
Date:   Sat, 1 Oct 2022 17:59:30 +0300
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
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/2] bridge: link: enable MacAuth/MAB
 feature
Message-ID: <YzhV0hU9v7oQ+g+K@shredder>
References: <20220929152137.167626-1-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929152137.167626-1-netdev@kapio-technology.com>
X-ClientProxiedBy: VE1PR03CA0037.eurprd03.prod.outlook.com
 (2603:10a6:803:118::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4397:EE_
X-MS-Office365-Filtering-Correlation-Id: 06cc9ebb-d8e4-4ec6-098b-08daa3bd8ef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5Tp3T8kDJxs/a2oW3BY0X2cul3FxQtdDqvPcOp2MZdDRCHqkQMztlRK/TITHLDuq3eujk1X1EDT9YPdV6XoeOL17HGpZidaW+hbOyInJIKGQKF4R8CvUQ4q99u8GLgSd2yBrjOo5HhSvQ577KScf0lTAMvmwx9AGWNRPjX9aHcJDjZm8jYIYysOZQpDe6PO8Syh/7FjQVWgZWaoaCmnzNv04skyEDZqDSv60pqBfl6s2JYNhV2nQZ3BN624djLTYPWu8D48c6U0lL+UYQ5nRPTKIpDO6DS66Wo2pBH3bygnoBs4zJYAV4rbFCiZVkh8CsuFdVm+Gzm4bX4jzXcCFOlzB2WtguGhx3CN+khajmCOdOtQOf7Dk/aPJXaeXWEDp0OUBfdCMWiZaNZuMOVLLC4fZ1EI/CtHuxGv0BUQxX7u+X+1YmthXlcl+0cC04+koiq2G+PvJPlUBKLMABZpYbLPArsk2GijfkRUBaqX4MBlTJiqWMuZmEq8ZF3XRuYw3seJRZaeJO4vFs3VEd3iJIksod/TH69sJsm5rzqy5RWALzpPWcAz3zD4qUCHkLYbiBbGzpprt1KyXYJMLQRJGZLx5bdp040Jq07VUOWFbvd5YjEsasbKBRG5cr8PwQfDYMhN4AeVG+S/Nrhq69aBOeZQ3rwI+ylwt8ZTqRI8i3i9LG0S59g+ohm09CkNgMZqv1CVQkPd7f2BccSgLLBmAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(86362001)(8676002)(38100700002)(66946007)(66476007)(66556008)(4326008)(33716001)(6916009)(54906003)(316002)(7416002)(41300700001)(8936002)(30864003)(5660300002)(7406005)(83380400001)(2906002)(186003)(66574015)(478600001)(6486002)(9686003)(26005)(6512007)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QBqNhlpY6s5QyPFUBT197d6z9B8uc5pvisnSDHk3RsLpI6i1hazFqv3I4bIb?=
 =?us-ascii?Q?HPnFHYXdjSMduZ3pxoyNMb67T5KHarBFa4qLINWLfpA+vttMGyRaIj3KeZEq?=
 =?us-ascii?Q?Ucw9OitVlG5ajZ2M6YZR8bwl+NfStdtX9HSi/mKqqJPbTjALk3TzCV67fAZf?=
 =?us-ascii?Q?0/crP1gXfS3Ol6CNpYmXP2jyG7o/3+sa5dR0mFCkHKsb58jFPdRKHKbO2/ex?=
 =?us-ascii?Q?zcBj2qjohWo3sX56Yon1T8G8rRxX1iIlSdHITxPD0vNJCSbAl2xmSXd87nZD?=
 =?us-ascii?Q?8HOTbSiscFbXYAPRH3dMW6DHB2d7Z9TbBmsBHL1zameE0xfLyklxM4iOUd1s?=
 =?us-ascii?Q?Qn66zy1wOGBE74EzfVkXWNShWY6xSnurahGiN/HGd1v6VJoVlqnKX91qztZF?=
 =?us-ascii?Q?stbwY0QfuqmTor4r29WvnFeYSzGnROOTh8VlF0kQsUjpnGeLCxTP5UvO81l7?=
 =?us-ascii?Q?i77NO5At+VTheqzjtjPktOP2L7E2OoZwyDVYLaQHGQ4yYpcwvT8Ak3B8z8os?=
 =?us-ascii?Q?B/Xk5MvwL3/TgLSY1XISwCvV26byW/xfV8uCOV3ReAOU8gDuT83qJ+ejj5nG?=
 =?us-ascii?Q?uaBj9RUJUE90V5Wd3vQ92m6tdGxTXdoe5zTePLB2IoB+4/tmGc1EKpaVYnkU?=
 =?us-ascii?Q?Uw9ZhhO2iMBe3pZTVYajn3ggALkz6gEVOlOo8h2901Kjn9nTGBnof3pRjTYa?=
 =?us-ascii?Q?313GdMT5tekaX+c/ctROSi8r5+Gn8wcpukNau9Xev67dQXaGJLr2av9isLRz?=
 =?us-ascii?Q?hkoXwQqBRt+BYT0ozO77fLlZj22WyGwXfnhDgW2MhbUd9zgX9j03VyT3E389?=
 =?us-ascii?Q?9FVskDGYkNNLL1nhS0EvjYgs53nber6FBOBk8kmsDLs1CRNUiNvCP3RhhobN?=
 =?us-ascii?Q?d0jjQdh+ffCPA031ypXm0QNR01KWr9faRUkTwh6G25RVAnNyr9mHLthX5KAw?=
 =?us-ascii?Q?y1x+7iqpslEeEf09n39d5W4iMY3PbidiGnluo8zASV0VcyfQ4zc+bfw2X6T1?=
 =?us-ascii?Q?KoEBBHtiso2CQTWT0vI/LiAIeLpJZMtH4u3egmBYYSep4KtmYmhz7vJ9fuWv?=
 =?us-ascii?Q?OKY8FZKqyCmGeZAKYyibtUoYMvuerD8Waag7Znuq/uYB4kfOcJuFNZn7yG3o?=
 =?us-ascii?Q?4+lmyzzr/53U9nkGQAjd1va4rxAUCuaP9Zhg7AOZtEMDI5KwTzzjDJOOsUeg?=
 =?us-ascii?Q?f7kAE0MfXhE7SpqfWUHkyEPENZFX2Y/TWQU32ssu5MgEg1DQZt604tQyjoGa?=
 =?us-ascii?Q?JSe1q7jWOGM8CyvK2jBq7jdtBoHI5vWZKA71pIVwPBDPdhUf/Na8Ck9PCbnG?=
 =?us-ascii?Q?bq5ihmGIWBxTOOHWPjqZdfHyHoANaTo7Jjnivqw2CMSrs7HA5mljmU4zpd3M?=
 =?us-ascii?Q?wsI41ZBiUBtRidlQFKm0JwHxnEGhI+J5jwc2Cmwcu+ByYqILTr44FpvsMc//?=
 =?us-ascii?Q?Qd5zOcAzNOF2P7CWYEOypBi0p5nw3p6Fl6vwWQjrMNvY+9vb3WTt+m5aIM5m?=
 =?us-ascii?Q?+sULAD9kOQPRa0ALShCiftDr161NloYvY6IHb+Dm6cNqjsQ5g+eQ5n67JFx9?=
 =?us-ascii?Q?y29S/ywp9lfySFjIXGpsXD7UJvtJguE6ThO7NtJs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cc9ebb-d8e4-4ec6-098b-08daa3bd8ef6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 14:59:37.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9S1+D9n8LhnvMoSzxOop7gbQvU9VWg7tLuzvkAqzxTCxjPF5+JUNq+T3DNNuqF1rSAuV8aI/1uus5IQ79Gj4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4397
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 05:21:36PM +0200, Hans Schultz wrote:
> The MAB feature can be enabled on a locked port with the command:
> bridge link set dev <DEV> mab on

Please provide regular and JSON output in the commit message.

> 
> Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
> ---
>  bridge/fdb.c                   | 17 +++++++++++++++--
>  bridge/link.c                  | 21 ++++++++++++++++++---
>  include/uapi/linux/if_link.h   |  1 +
>  include/uapi/linux/neighbour.h |  7 ++++++-

IIRC, in the past David asked to either not send the uAPI files or send
them as a first patch which he then uses as a hint to sync the files
himself.

>  ip/iplink_bridge_slave.c       | 16 +++++++++++++---
>  man/man8/bridge.8              | 10 ++++++++++
>  man/man8/ip-link.8.in          |  8 ++++++++
>  7 files changed, 71 insertions(+), 9 deletions(-)
> 
> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index 5f71bde0..0fbe9bd3 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -93,7 +93,7 @@ static int state_a2n(unsigned int *s, const char *arg)
>  	return 0;
>  }
>  
> -static void fdb_print_flags(FILE *fp, unsigned int flags)
> +static void fdb_print_flags(FILE *fp, unsigned int flags, __u8 ext_flags)
>  {
>  	open_json_array(PRINT_JSON,
>  			is_json_context() ?  "flags" : "");
> @@ -116,6 +116,9 @@ static void fdb_print_flags(FILE *fp, unsigned int flags)
>  	if (flags & NTF_STICKY)
>  		print_string(PRINT_ANY, NULL, "%s ", "sticky");
>  
> +	if (ext_flags & NTF_EXT_LOCKED)
> +		print_string(PRINT_ANY, NULL, "%s ", "locked");
> +
>  	close_json_array(PRINT_JSON, NULL);
>  }

This is a separate change. Make one patch for the MAB option and another
for the new "locked" FDB flag.

>  
> @@ -144,6 +147,7 @@ int print_fdb(struct nlmsghdr *n, void *arg)
>  	struct ndmsg *r = NLMSG_DATA(n);
>  	int len = n->nlmsg_len;
>  	struct rtattr *tb[NDA_MAX+1];
> +	__u32 ext_flags = 0;
>  	__u16 vid = 0;
>  
>  	if (n->nlmsg_type != RTM_NEWNEIGH && n->nlmsg_type != RTM_DELNEIGH) {
> @@ -170,6 +174,9 @@ int print_fdb(struct nlmsghdr *n, void *arg)
>  	parse_rtattr(tb, NDA_MAX, NDA_RTA(r),
>  		     n->nlmsg_len - NLMSG_LENGTH(sizeof(*r)));
>  
> +	if (tb[NDA_FLAGS_EXT])
> +		ext_flags = rta_getattr_u32(tb[NDA_FLAGS_EXT]);
> +
>  	if (tb[NDA_VLAN])
>  		vid = rta_getattr_u16(tb[NDA_VLAN]);
>  
> @@ -266,7 +273,7 @@ int print_fdb(struct nlmsghdr *n, void *arg)
>  	if (show_stats && tb[NDA_CACHEINFO])
>  		fdb_print_stats(fp, RTA_DATA(tb[NDA_CACHEINFO]));
>  
> -	fdb_print_flags(fp, r->ndm_flags);
> +	fdb_print_flags(fp, r->ndm_flags, ext_flags);
>  
>  
>  	if (tb[NDA_MASTER])
> @@ -414,6 +421,7 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  	char *endptr;
>  	short vid = -1;
>  	__u32 nhid = 0;
> +	__u32 ext_flags = 0;
>  
>  	while (argc > 0) {
>  		if (strcmp(*argv, "dev") == 0) {
> @@ -527,6 +535,11 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  	if (dst_ok)
>  		addattr_l(&req.n, sizeof(req), NDA_DST, &dst.data, dst.bytelen);
>  
> +	if (ext_flags &&
> +	    addattr_l(&req.n, sizeof(req), NDA_FLAGS_EXT, &ext_flags,
> +		      sizeof(ext_flags)) < 0)
> +		return -1;
> +

I believe this belongs with the "blackhole" patch.

>  	if (vid >= 0)
>  		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
>  	if (nhid > 0)
> diff --git a/bridge/link.c b/bridge/link.c
> index 3810fa04..dd69d7c3 100644
> --- a/bridge/link.c
> +++ b/bridge/link.c
> @@ -181,9 +181,14 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
>  		if (prtb[IFLA_BRPORT_ISOLATED])
>  			print_on_off(PRINT_ANY, "isolated", "isolated %s ",
>  				     rta_getattr_u8(prtb[IFLA_BRPORT_ISOLATED]));
> -		if (prtb[IFLA_BRPORT_LOCKED])
> -			print_on_off(PRINT_ANY, "locked", "locked %s ",
> -				     rta_getattr_u8(prtb[IFLA_BRPORT_LOCKED]));
> +		if (prtb[IFLA_BRPORT_LOCKED]) {
> +			if (prtb[IFLA_BRPORT_MAB] && rta_getattr_u8(prtb[IFLA_BRPORT_MAB]))
> +				print_on_off(PRINT_ANY, "locked mab", "locked mab %s ",
> +					     rta_getattr_u8(prtb[IFLA_BRPORT_LOCKED]));
> +			else
> +				print_on_off(PRINT_ANY, "locked", "locked %s ",
> +					     rta_getattr_u8(prtb[IFLA_BRPORT_LOCKED]));
> +		}

These a separate flags and need to be dumped independently. The fact
that MAB can only be enabled when the port is locked is enforced by the
kernel.

>  	} else
>  		print_stp_state(rta_getattr_u8(attr));
>  }
> @@ -281,6 +286,7 @@ static void usage(void)
>  		"                               [ vlan_tunnel {on | off} ]\n"
>  		"                               [ isolated {on | off} ]\n"
>  		"                               [ locked {on | off} ]\n"
> +		"                               [ mab {on | off} ]\n"
>  		"                               [ hwmode {vepa | veb} ]\n"
>  		"                               [ backup_port DEVICE ] [ nobackup_port ]\n"
>  		"                               [ self ] [ master ]\n"
> @@ -312,6 +318,7 @@ static int brlink_modify(int argc, char **argv)
>  	__s8 bcast_flood = -1;
>  	__s8 mcast_to_unicast = -1;
>  	__s8 locked = -1;
> +	__s8 macauth = -1;
>  	__s8 isolated = -1;
>  	__s8 hairpin = -1;
>  	__s8 bpdu_guard = -1;
> @@ -437,6 +444,11 @@ static int brlink_modify(int argc, char **argv)
>  			locked = parse_on_off("locked", *argv, &ret);
>  			if (ret)
>  				return ret;
> +		} else if (strcmp(*argv, "mab") == 0) {
> +			NEXT_ARG();
> +			macauth = parse_on_off("mab", *argv, &ret);
> +			if (ret)
> +				return ret;
>  		} else if (strcmp(*argv, "backup_port") == 0) {
>  			NEXT_ARG();
>  			backup_port_idx = ll_name_to_index(*argv);
> @@ -520,6 +532,9 @@ static int brlink_modify(int argc, char **argv)
>  	if (locked >= 0)
>  		addattr8(&req.n, sizeof(req), IFLA_BRPORT_LOCKED, locked);
>  
> +	if (macauth >= 0)
> +		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MAB, macauth);
> +
>  	if (backup_port_idx != -1)
>  		addattr32(&req.n, sizeof(req), IFLA_BRPORT_BACKUP_PORT,
>  			  backup_port_idx);
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 7494cffb..58a002de 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -559,6 +559,7 @@ enum {
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
>  	IFLA_BRPORT_LOCKED,
> +	IFLA_BRPORT_MAB,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index a998bf76..4dda051b 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -52,7 +52,8 @@ enum {
>  #define NTF_STICKY	(1 << 6)
>  #define NTF_ROUTER	(1 << 7)
>  /* Extended flags under NDA_FLAGS_EXT: */
> -#define NTF_EXT_MANAGED	(1 << 0)
> +#define NTF_EXT_MANAGED		(1 << 0)
> +#define NTF_EXT_LOCKED		(1 << 1)
>  
>  /*
>   *	Neighbor Cache Entry States.
> @@ -86,6 +87,10 @@ enum {
>   * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
>   * of a user space control plane, and automatically refreshed so that (if
>   * possible) they remain in NUD_REACHABLE state.
> + *
> + * NTF_EXT_LOCKED flagged FDB entries are placeholder entries used with the
> + * locked port feature, that ensures that an entry exists while at the same
> + * time dropping packets on ingress with src MAC and VID matching the entry.
>   */
>  
>  struct nda_cacheinfo {
> diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
> index 98d17213..0c0894eb 100644
> --- a/ip/iplink_bridge_slave.c
> +++ b/ip/iplink_bridge_slave.c
> @@ -44,6 +44,7 @@ static void print_explain(FILE *f)
>  		"			[ vlan_tunnel {on | off} ]\n"
>  		"			[ isolated {on | off} ]\n"
>  		"			[ locked {on | off} ]\n"
> +		"                       [ mab {on | off} ]\n"
>  		"			[ backup_port DEVICE ] [ nobackup_port ]\n"
>  	);
>  }
> @@ -284,9 +285,14 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
>  		print_on_off(PRINT_ANY, "isolated", "isolated %s ",
>  			     rta_getattr_u8(tb[IFLA_BRPORT_ISOLATED]));
>  
> -	if (tb[IFLA_BRPORT_LOCKED])
> -		print_on_off(PRINT_ANY, "locked", "locked %s ",
> -			     rta_getattr_u8(tb[IFLA_BRPORT_LOCKED]));
> +	if (tb[IFLA_BRPORT_LOCKED]) {
> +		if (tb[IFLA_BRPORT_MAB] && rta_getattr_u8(tb[IFLA_BRPORT_MAB]))
> +			print_on_off(PRINT_ANY, "locked mab", "locked mab %s ",
> +				     rta_getattr_u8(tb[IFLA_BRPORT_LOCKED]));
> +		else
> +			print_on_off(PRINT_ANY, "locked", "locked %s ",
> +				     rta_getattr_u8(tb[IFLA_BRPORT_LOCKED]));
> +	}

Same comment as before.

>  
>  	if (tb[IFLA_BRPORT_BACKUP_PORT]) {
>  		int backup_p = rta_getattr_u32(tb[IFLA_BRPORT_BACKUP_PORT]);
> @@ -411,6 +417,10 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
>  			NEXT_ARG();
>  			bridge_slave_parse_on_off("locked", *argv, n,
>  						  IFLA_BRPORT_LOCKED);
> +		} else if (matches(*argv, "mab") == 0) {
> +			NEXT_ARG();
> +			bridge_slave_parse_on_off("mab", *argv, n,
> +						  IFLA_BRPORT_MAB);
>  		} else if (matches(*argv, "backup_port") == 0) {
>  			int ifindex;
>  
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index d4df772e..40250477 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -54,6 +54,7 @@ bridge \- show / manipulate bridge addresses and devices
>  .BR vlan_tunnel " { " on " | " off " } ] [ "
>  .BR isolated " { " on " | " off " } ] [ "
>  .BR locked " { " on " | " off " } ] [ "
> +.BR mab " { " on " | " off " } ] [ "
>  .B backup_port
>  .IR  DEVICE " ] ["
>  .BR nobackup_port " ] [ "
> @@ -580,6 +581,15 @@ The common use is that hosts are allowed access through authentication
>  with the IEEE 802.1X protocol or based on whitelists or like setups.
>  By default this flag is off.
>  
> +.TP
> +.RB "mab on " or " mab off "
> +Enables or disables the MAB/MacAuth feature. This feature can only be
> +activated on a port that is in locked mode, and when enabled it extends the

s/activated/enabled/

> +locked port feature so that MAC address can get access through a locked

s/MAC address/a host/ ?

> +port based on acceptlists, thus it is a much simpler procedure for a
> +device to become authorized than f.ex. the 802.1X protocol, and is used
> +for devices that are not capable of password or crypto based authorization
> +methods.

This is a high level description of the option, but it is missing the
part that ties it to the "locked" FDB entries.

Speaking of which, the "locked" flag needs to be described in
man/man8/bridge.8 (in a different patch)

>  
>  .TP
>  .BI backup_port " DEVICE"
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index fc9d62fc..187ca7ca 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -2454,6 +2454,9 @@ the following additional arguments are supported:
>  .BR isolated " { " on " | " off " }"
>  ] [
>  .BR locked " { " on " | " off " }"
> +] [
> +.BR mab " { " on " | " off " }"
> +] [
>  .BR backup_port " DEVICE"
>  ] [
>  .BR nobackup_port " ]"
> @@ -2560,6 +2563,11 @@ default this flag is off.
>  behind the port cannot communicate through the port unless a FDB entry
>  representing the host is in the FDB. By default this flag is off.
>  
> +.BR mab " { " on " | " off " }"
> +- enables or disables the MAB/MacAuth feature on a locked port. It is
> +thus possible for a device to gain authorization on a locked port based
> +on acceptlists.

Why not just copy-paste the previous description?

> +
>  .BI backup_port " DEVICE"
>  - if the port loses carrier all traffic will be redirected to the
>  configured backup port
> -- 
> 2.34.1
> 
