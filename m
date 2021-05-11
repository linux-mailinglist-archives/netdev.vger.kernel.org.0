Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35B637A3B6
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhEKJbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:31:45 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:41056
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231302AbhEKJbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:31:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SB+WjFVtUObjTGI9FU/eT4i3UjMO5HeC7ZOwy3oWti7VJbs0aCnEpBXJxGUhw/C1eWTr4prt/SkAwVs+/klSXEqHK57kdjv03jp5sl1JtxFbJyxCS+1Yj2IxnsRYCUre9+K/0RKbOTvdxw3g4WBWArPH/g8slP0mSpaFoDVYZqI+AbcZhz/3HjMABkDerur4W0jpZ/K73l6KVSRlUa04IC1JeJMxtpMF0MUzmndIfbRpAzlFVResU0kXu42f2aGEnxtcOfUohX5rAqufKaNoIh7P2l0B/GqWKOgHRjosAPLd7+67txVKNPVydUlVMjd95EOBxlt01F5kavh3vSk4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aocN83HuzwP32rnj53taPT09V0+IeF7AOLl2bmoJm7c=;
 b=ahuvns+eNj1vpUPgMKkGsH2puu1Nq9ZYqV/zusmJrSmfC8y2d8KtbJVtNohVp5RLR+7ENVwCkCl9/BT4YjTZElo8Wv0WlA+kDz+lxhYBo4SR1wj4rqw9VnGjO629Hl+kQfi4uZk09klhMYvkNX++gWapdnRaGTnhE6AusWlmiTgDVvWEWYwcu2QnWthCkH5D1rbRFEKoOg7gELrrZIikm7sigDInL6oaXx7xfnLpbhtCLMLjXcoZKI63ue7MR9CIrVuFdWdQ/wPqmmD3uQFgmxuS2+gF/Ms9RiiPFwAq/M9VbAuHAF7MrZiBU6sLxb+sGO2OhXX+baheTQ+rXE7qWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aocN83HuzwP32rnj53taPT09V0+IeF7AOLl2bmoJm7c=;
 b=slXROiDICI4p6PyLq89dot+pG9A3A0CccsSmVP15GD5+Ggl+f/GFmhJkzdK/6IUe9dFwuycrujpeYi4UzgOlZef7rpe+ZtNsFusIEUpwFHc8/823W+3b/YN70PZgLYdnb629Wc65Rn8idG/ZhxhSCyqaGAd4np2d5r+IojaAiMxqEL0AmrjWhnXe1ITjcJ5I+RoIEX/Kn5gvqXUR+OjBIpdJVrqi4LLlDaLsaccs7mbsGxOeic5Zi+pGrAcbo5FwOkgm27/5kmwRmY3tNlBBZZgbrXIm+AQfp/VHvIUCeCERV0SO4mBgz1svVyflYxaACjRtDUuZYL349Oe10Y+Ibg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 09:30:34 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:30:34 +0000
Subject: Re: [net-next v2 10/11] net: bridge: mcast: add ip4+ip6 mcast router
 timers to mdb netlink
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-11-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <04761487-8abe-830e-7cf1-84a270d58ff5@nvidia.com>
Date:   Tue, 11 May 2021 12:30:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-11-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0137.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0137.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Tue, 11 May 2021 09:30:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 137aa674-4d73-44c8-f9f7-08d9145f6d71
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5416F682A27883FA0C8FA0E8DF539@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oS1Ell+eBjl9kvrzNdkOrcrwvl9LWscW5GCTS1Qzm4GYyPTTLmeAbf5WOesDS/fPCXMj7auOKbCuAMaW+6fOe3o/znqazrLZ8fNzSWYQgIUQY1qkmcRrjPUa7/dlw17hJKm4agyiX/DLGXDiAOn8GuQUbbOG6BS+D4g3P9+24C3tJtXHPDr+X8n0obyyPeBi3TG3YeMQAjsoOn/3krZWDyBWGhaFTCS6V6t+Bc9zPryAm1NOD8dar8hlZZOlUpGwwDTlvyDVFCoPRW9WoxA6keyVT9F1iM3yQBBhMNQmZ4+mATBprm7E229lOc18A9rCMvK7nACqfM2I82jSH8sgz1q8I/BTgrJVTzwsVE/EEBjkH+p0UU0DJxweJqFjXu4+8Zbg0WhTD5BJKPz6S+rgA8ITFTjpb0UnH6xcwj2YIG2XssSqS8h7XoHfdpg0hQxz0WqygP9jlIa1v2d5JCmPVLb5R+ejLzcAVnKyLzYVvyP8Ph+C7slzLmurgWn4G7KogQY5VE6DbVUvNLy+PdAIPpd5TBthOpUwBq67BJSdTCPdYJcXatGrb7OllvDQ7vPsZ/tbf3JY1Avr9Ydz7ScXQElMOGjmnlpPvQtydh6h22XdRJENy+fC9xoSY9h3XFvVMbNp/bsqTiSU1NbFEjtpGqayCGA9Aj5dvCn3ppEvkfRRy466fVZVCb6Y89DeTmcD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6486002)(31696002)(66556008)(26005)(8676002)(5660300002)(4326008)(54906003)(53546011)(6666004)(498600001)(66946007)(16576012)(86362001)(66476007)(8936002)(956004)(2616005)(36756003)(31686004)(83380400001)(66574015)(16526019)(2906002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUdYUE0wQjVzVkFjMEdaZ1UrQmdEWlJqZWtvWGZteVduRG80U3EwVTl3VUZa?=
 =?utf-8?B?U1A5QW5Bak1XUmtVMWczWGp5cVcyQW5MWWViRk9VbHY0cG83YWsrS3JldnlF?=
 =?utf-8?B?WHR3WjVJcjVDZGtEdC9MQk1lZVNZa29JK2R1REVqVVBUTm1uMmR2K1I4SThp?=
 =?utf-8?B?L2pUWE1jckw4b3dzY2tCcURicFFrb0pjbUx6ZGNFRVhWOEx4VUpNVWZMOGk5?=
 =?utf-8?B?WEFMZExldDhsdUtyWWhWVDZycW1panhqQjVrTDVHY2dOOHdBd3ROWFY3eTVz?=
 =?utf-8?B?REdSeWJGcEMrUWFOMi84RDVDRXZqUTJwbFFycTRuRHFQQm9OSi9yazlXRkVR?=
 =?utf-8?B?TUxmTzdiUU4zSGFUZmwwNjZvWEYwaldyRHJLWXA5R0EvdE1mZWlYcXNKQVMy?=
 =?utf-8?B?TUs3QTJ2cXlMUWo3MkJWTnBuSkxsdEFYSUlnQzcwUkVNZFphSHFOem9DV0dm?=
 =?utf-8?B?L290M1BHbGdHZUh3WWpFeWhvbHFxZkg3Y25zMU1WMENZenRjOUl6amVWWVdy?=
 =?utf-8?B?dUdwK2owWnlwb1dIb1pUYkRjNno1azM4bVppMUFGb2kvMEQzZUdkWm9XOStO?=
 =?utf-8?B?YmdWeWJDOFF5Qk5LenpmUEhSaGU0b3YxSXB5MWU0bmRIT3lpMXJ6d3BpMmdw?=
 =?utf-8?B?WTh2YjQrbkl0Ri9oOXJBQ0g2TUtqeVFwOURZNFM3RGtMQnV1SlVOVkUrMHJ4?=
 =?utf-8?B?b1l4YkVrWHovblBlQzlrYXh1K0xHTVRHTEprbzVZUkVtbklEQkptdDcyYmxS?=
 =?utf-8?B?M1ZBbVFWd3l6U0R1bW1DZnVCTVBERllKYkZKeFFzaGphbGFVQXVLUy9oWUN2?=
 =?utf-8?B?bTdMRTZJS1VOd29qSlRmZVo1d3VHY1N1blRISENOQ2EzcEEraklFTW5lU1h0?=
 =?utf-8?B?bkduRXd2MGtmVCs5V0hEOFJjdHhvb1MvZUFhbElqQXE5Q3BzQlBobFVEa2Zs?=
 =?utf-8?B?TGRFY3JZOGxnaWp2bFREQ2NWMXFLVE1peUNzWnhTVmlTS2R1ODk4QThicHM3?=
 =?utf-8?B?VWw4YzQ1STVBSmpLZGp6Q0pKWHltL3JsZFJZRTJEVE0zWllsWGE3ZnNmbWdy?=
 =?utf-8?B?V1hwQmtpdFZhb0tVYXhWUzhVcXNtOXpSenRzUFRqN1lBTE8zWjRPVUxpM3k1?=
 =?utf-8?B?akNoejA3OUlwVXJjZUgvSXhXcStkUXJTMlhTbldna3ZWaHBkYnUyUU00dllu?=
 =?utf-8?B?SCtaZzJjaGI2TXF4V0JsbHFNRTJ1eS9mSzY1K2prZWJvajBvK1phamZzL0dv?=
 =?utf-8?B?Tjh4M0lMKytEZ1RQSFBCVVU1SCtRRUxIdFJJWVk1M05pSUFqb3RlOUo1UVRV?=
 =?utf-8?B?Q1IzWXJteXpuOEhNckR3bXpsSCtjZGQ3UlBPbWVKVXpMV05CbnZLelk0amYz?=
 =?utf-8?B?aWpGOEJwQ1JHQkVmRGVEcUw3WHNjb1ZvZyt1NFZhVU5TNWtjazJ1T1FqTDlm?=
 =?utf-8?B?UVFtbmMwcDdzWVpsRTN5cjcranBYdTgxaDc0MGZrSE02YXN1SWNDUlNsMTRI?=
 =?utf-8?B?Z3lhbHNZaWdMUFkwZHNMWi9BY3FVMlF1VlhXRVJ3eWY3YkpJb3lOSmloOGFq?=
 =?utf-8?B?UjBKK05vYkszOGUrUnBacXFTWXJubUNEck02NWRIYnZxVVppTlBaamw4WmZm?=
 =?utf-8?B?Z2Irbms2eGVodEdsdUIzeitCZjBhR2tlK0VESEFPZFRGeXFDdXlqaHFkUG1E?=
 =?utf-8?B?L2NDMTBMY1pJWjlsRUU2SDFaSHUzamw1MCs1OHlBSWNNb05YL1QzUlIxdmdW?=
 =?utf-8?Q?2SCIbc9whc8l2qy51cncA1QqWcMLP4FXFW2nP0P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137aa674-4d73-44c8-f9f7-08d9145f6d71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:30:34.1116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgwvF0Va0n6JLLeeggO9KqVkjT2frIv4xDSMzD1L0k6DHSERjH5B/U2SO76ub4qEdnLgFjmqLwnqJpixwWNG9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
> Now that we have split the multicast router state into two, one for IPv4
> and one for IPv6, also add individual timers to the mdb netlink router
> port dump. Leaving the old timer attribute for backwards compatibility.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  include/uapi/linux/if_bridge.h | 2 ++
>  net/bridge/br_mdb.c            | 8 +++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 13d59c5..6b56a75 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -627,6 +627,8 @@ enum {
>  	MDBA_ROUTER_PATTR_UNSPEC,
>  	MDBA_ROUTER_PATTR_TIMER,
>  	MDBA_ROUTER_PATTR_TYPE,
> +	MDBA_ROUTER_PATTR_INET_TIMER,
> +	MDBA_ROUTER_PATTR_INET6_TIMER,
>  	__MDBA_ROUTER_PATTR_MAX
>  };
>  #define MDBA_ROUTER_PATTR_MAX (__MDBA_ROUTER_PATTR_MAX - 1)
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 3c608da..2cdd9b6 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -79,7 +79,13 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
>  		    nla_put_u32(skb, MDBA_ROUTER_PATTR_TIMER,
>  				max(ip4_timer, ip6_timer)) ||
>  		    nla_put_u8(skb, MDBA_ROUTER_PATTR_TYPE,
> -			       p->multicast_router)) {
> +			       p->multicast_router) ||
> +		    (have_ip4_mc_rtr &&
> +		     nla_put_u32(skb, MDBA_ROUTER_PATTR_INET_TIMER,
> +				 ip4_timer)) ||
> +		    (have_ip6_mc_rtr &&
> +		     nla_put_u32(skb, MDBA_ROUTER_PATTR_INET6_TIMER,
> +				 ip6_timer))) {
>  			nla_nest_cancel(skb, port_nest);
>  			goto fail;
>  		}
> 

