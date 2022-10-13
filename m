Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414AB5FD956
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 14:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJMMl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 08:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJMMlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 08:41:24 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B876F3F335;
        Thu, 13 Oct 2022 05:41:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iD4K/rW2jkcPcPyzZ0YQxK32e9+yNZGqFzBQXFGVdQ/BwuNHGFm/lE+BIdjwknnaAd34zPKfvbXQ6inF+NNbei882o3KMukb2LBdzonjr76iS0lt9zHSWV5kNeDOxrwnJVAsMWxBUYXP97rgmRonm/owEFsv+Li0L+AKEWxEVgLKBxbummoasKo/lsaZgo9zTveKDIe1OsqZ/jlCUjjBXBr/KemG2YH/NcjBazm50NHm7wRnQP387pmRKmMqOjWYGqrVnvRkzoclm8WrlQwKKBQqCMrjbJQIAx/VYgghAjsWyJ8Fxe8FGWJXb/79Kb1j5QeOHS/KI3jvmnCPZWL7+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTOb6aZuMNrXGoFL+bY/yASFEjXcUko4NcXLXmZb7Qs=;
 b=Add3diYAvZBcWov4EvwWTDbfOzldHQOtAaaLHZdvYzLPWLnzbUUa4Lpj3U9vX/LQeSfjmDchgkBn7rp+952PEzdZVdC4ZdXrP9sJvUAZSu44OHsqTEQ5AmiJ2Xt2/XOzlFVcUsp2EiUhKHXhDln0dDdwHU22jYmJqAxS/xiSFAPG2a0IQ2WsxpOb3R5jMxJgB2cq/mY9zO5JtZY19WK7RaWKcUFEAudhPnEe49kSo25YSOePajhh9GKCug0tJ5H4sS9130cv4WuIdsC3rm6qPU3GMFgerUYhD89/BioyxbhTTqcouBU+M7QX2DXxCnf+mMktcVAUNHjnPNfDbC+oAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTOb6aZuMNrXGoFL+bY/yASFEjXcUko4NcXLXmZb7Qs=;
 b=aRHYCHQP8fbcbDi3lqpuj9Fb4gE9ffWyzE3CSAiPjKYHusPD2H6F0SpJIX+3Qi3aPy7b09jNL5tiPUYdfBl7qFnJmyOAnrmeAM2h9Jji+F8Aa75GfSzufRcIzY5RCUJphpEbmEQJ3hvad8HqZkitTlnE3GT4b4n3bnIH5qOEpQHoOjyfBW9EKprfmrn2eMXQjkIBGO8ThFummdndMxkU1NZobOI9ZBAFqU83peHYjcfnoP3Un3jHmlWNKusc9rbKiqmo6+XbHoOC4BwGVf9Jx/un11RhDKYAJPK+Qxp4I/eLhR5IfGqjksJgFRGhtVdGxS0awXtdtiY35k6aJXPUlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6550.namprd12.prod.outlook.com (2603:10b6:930:42::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Thu, 13 Oct
 2022 12:41:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%6]) with mapi id 15.20.5676.031; Thu, 13 Oct 2022
 12:41:22 +0000
Date:   Thu, 13 Oct 2022 15:41:15 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
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
Subject: Re: [PATCH v7 net-next 1/9] net: bridge: add locked entry fdb flag
 to extend locked port feature
Message-ID: <Y0gHa99Z70TkKtR5@shredder>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
 <20221009174052.1927483-2-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009174052.1927483-2-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1PR04CA0137.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6550:EE_
X-MS-Office365-Filtering-Correlation-Id: d642b567-d51b-4d6b-e266-08daad183b80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DX4nCQHAo383/x8njsXmpUjgRJjzx6uzsvfBdTWZwvXk2ip9GeG8ftRgi9gD+mPJURzoNK+vmL1EBNxQysd8pmyxVWV2BRSkjcGvOQGAM8Hy2sSj+PHsZsy2biuMcmUenhGGezv57zjQsGlNxEHhGW+WqojxbTNm4nIOCDjJJgyahr5ewq7VYEjY1rbBqWDnV2b63q7NR34Rv49sN64ylVUKu+jN/dbwRlknynl114xy3uXe4XIH+L1lfCxDGwcnvU50M7v7fgQlKs235KAVnvuZ4CH/66PAJdVx9iOp3iR92U8W9ippcYAaf5xglXuYMMOaoFK+KQoFO8n+fM3rcKCwN1zl2tlcnONGpiq8F3Fz0X0UkSd0wPLkTMC46KhccoEsOy5Tjc9EBWDKJlvYdx74qVaWVW5TGo0g3WBofJJPlyE0reLlVopwookgPmzSrw8wm/3xVquKyju7ked567LNh1605OEaeaDHLhXbu10Kmd1rfQi7z8TY3o4Pn6PXwptKxxnpQ3YLRkKxQTlv0xZTB9OJeMr/x2NO9Dq7rlv7ZClEuyO0fzBeqyDpnxC0KLF3tvotIH3DremgenvkxcuexhhlMHnzae7NTMFZAMhKtGYHOvDyBiDL8mmRjo3la0ezV8zV5H68zGQ0ym9AjT9xDh6Wa3Cpf4haXldAGrrk5+ijju7xXbBYZcslll6jFIbaCpyuslDjWxr9dD80Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(66556008)(33716001)(7416002)(8936002)(5660300002)(4326008)(41300700001)(186003)(6486002)(83380400001)(66946007)(66476007)(6666004)(38100700002)(9686003)(86362001)(6506007)(26005)(478600001)(6512007)(8676002)(316002)(6916009)(54906003)(2906002)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KdhLC7vUT5YkTUGSXcVIb8E29Q8EaAh1XEQEVLmY+PGwbz25jqNQisGwPioZ?=
 =?us-ascii?Q?aQsEK1/6AM3gMGqAfRdLCxlJ0wD44AkTet8nn1JTmN3BQWq9dRnvjhbxgUQ7?=
 =?us-ascii?Q?0CfeNmDDJRsWp3u6lyskUsaQ0vDEmddsKOaE0ZfQdI6tCDL9VFfATbLq/E2g?=
 =?us-ascii?Q?yrJh3hPjKbXg55laMwQv8mC5WWLTt8DgDmFqq91luCencGFlIY9Dd8PfJo+u?=
 =?us-ascii?Q?1TmPs/V6omoHj0NhEAIIYuPZNN6RCc5+4sTFBxZsssucu04NFpapr6cZl7F6?=
 =?us-ascii?Q?1RYMXdNo0kMiWHQr4cUzs69zQGjhf+DQs/SBxdb3K5tO1LFZ3uO0gPdG3BoG?=
 =?us-ascii?Q?UFWQdSCHWurZYRFsWwz/G6cWJZIGy1t6YEI0L6y6UF1RWiRmXC8bOx7LKMNg?=
 =?us-ascii?Q?hWSzLh17BAAmzJEeFyDLpNeZaIO2cfqS3rjJHT806J+Qw8iVuo/VRj3s5oNw?=
 =?us-ascii?Q?KajHVBSO++ZvheG2tMHksNPS4cxa3ZXdC/rkthyiwG1n9WqdtHmYFr1i99YN?=
 =?us-ascii?Q?lBbH1ZS34+Pvrl+A+hluLLSA6Ze8KUMdS8WE+gXKbxiGCSE0X2gmi064V/97?=
 =?us-ascii?Q?aqwyUg7VW/kKxCA9rv0ZO9JKwi1JFwzxTGc6abCW5N4q4SF+th3qJuYiYUbf?=
 =?us-ascii?Q?JEgQxJK0OVGvhBewyv4cu4y1NNMvLvZOs8eqdMRJkMuoSJS+n4vV1Z+MKaDI?=
 =?us-ascii?Q?6wkTGRZEuqsPMSsM60kmlRUrmA2jsfJrhnjElzdcW68gfHszdx/qFhNdP/HN?=
 =?us-ascii?Q?sS8Ve8VYXfKbfzsPU6kydLlAJOkUbaaKf3HK/u1dkK+Ry1WwVG46YdYEBbhS?=
 =?us-ascii?Q?jh/4TzMGD3ouUkyazmQJ2ibFIWljvOoL2KLYbmFnCKZjJRpgF2TGUHCQRrYd?=
 =?us-ascii?Q?X5V/m0itWrinuo/C4yk0nHuvPA3Nk3Y+Og83BLMjEvswpbIgja/oPLQd5LYj?=
 =?us-ascii?Q?Kf8h/unBH+zZtPOUI1PPR3HLo3moHDJUFoOzgCPOFNKP+gx8PEb2ZAU2chOQ?=
 =?us-ascii?Q?ZoQdF9FJ/KXgiFDrwfAQH9Io/4hBNna/GgmDvQHogzKNb6CHCN+BmEoFqf14?=
 =?us-ascii?Q?umqtHFL7VITa/McW9IX8PYqn5gTGR8CrMp2r5K7tHZDcXW/ePHTbRVrB50l2?=
 =?us-ascii?Q?oAe+aYLEifAzVZ8W8I6RMytgQ4pbSizQ4YwdpeYCm2KQGfiEF0eNxVcazQKq?=
 =?us-ascii?Q?xlu5lE3gw2BwUm/l/Ebc/VxtKvkYFpBT8WoJIKpGcRy1+Tgg/2CUxIH7YhND?=
 =?us-ascii?Q?CTIQzM2lJi8ox2hBLsGhyZD/AllJ6h4oQE2thmGCDJEweI8rzH4lJ9PSsuM7?=
 =?us-ascii?Q?jmlBCNwBYkv5q7Qx19VooIdOYG5XbRl3wmqtOCMeQjsgSA5Bi/hVp65CL1x0?=
 =?us-ascii?Q?+MgL0nysyk4T9GEuYAXwCN1/9yMjqA1DmA2WHM+y0VcxytPnfERKN3+wBtl3?=
 =?us-ascii?Q?9TIOYPt2/x982BhnrtAIOFsw//H6H9ltj5r2mMZCntPOSziMiEgfToRu8dfv?=
 =?us-ascii?Q?ZPht14TD84pEQuHyBysKjFDcV5sxD0pFH1LfAZ1CLm9OooBg3iGdkETDDsXn?=
 =?us-ascii?Q?cm+WM/jCuYD6EdJRRuHsEfQkTkdG9J2s2hPTDewj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d642b567-d51b-4d6b-e266-08daad183b80
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 12:41:21.9700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o48crjiwJYsgm3ZJhnXLaidzaNdMkn1pbwXbiodxJtAo0pNjCq4Nn8TWTgv/Jwo3ZanLIORqFwVaxp48FOjuyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6550
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 07:40:44PM +0200, Hans J. Schultz wrote:
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 74864dc46a7e..8008ceb45605 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -4035,6 +4035,7 @@ int ndo_dflt_fdb_add(struct ndmsg *ndm,
>  		     const unsigned char *addr, u16 vid,
>  		     u16 flags)
>  {
> +	__u32 ext_flags = 0;
>  	int err = -EINVAL;
>  
>  	/* If aging addresses are supported device will need to
> @@ -4050,6 +4051,14 @@ int ndo_dflt_fdb_add(struct ndmsg *ndm,
>  		return err;
>  	}
>  
> +	if (tb[NDA_FLAGS_EXT])
> +		ext_flags = nla_get_u32(tb[NDA_FLAGS_EXT]);
> +
> +	if (ext_flags & NTF_EXT_LOCKED) {
> +		netdev_info(dev, "invalid flags given to default FDB implementation\n");
> +		return err;
> +	}

I'm not sure it makes sense to deny specific flags in this case. It
might be better to just error out if NDA_FLAGS_EXT was specified.

> +
>  	if (is_unicast_ether_addr(addr) || is_link_local_ether_addr(addr))
>  		err = dev_uc_add_excl(dev, addr);
>  	else if (is_multicast_ether_addr(addr))
> -- 
> 2.34.1
> 
