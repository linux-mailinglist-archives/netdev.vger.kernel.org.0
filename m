Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DBD2CEC78
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgLDKsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:48:05 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:19320 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgLDKsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 05:48:04 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fca13ba0000>; Fri, 04 Dec 2020 18:47:22 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Dec
 2020 10:47:18 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Dec 2020 10:47:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJTDtunYPsnkvSluXX/6mWp2/jgyBlRaBggEF8bItT6oqCDT7kB1AwysBv6svNiLTcPRXVULn2Kniuvs3FWWMN907lO9gD+nJBgFmcabn2ZOY8xoKFzRLmhhtbhTaZ0iIMAsvPAhoR6rFxMSdG+9J7LMgMLPo4Z3MetO+6Ou00ftuEcofHzIQJJSppwZEZxLO1AUNwjOUKzX9MFRBELLTTr2yCzodIUH2vASYB+Rhu3McfqrOafbpkYtWCzQ+VPOPTmc0aXpOnjrne+DNo57F1dN5LZLOnMMKTJRawifLFgAGSY3RKC0EYpFrVeOUxphbVktjd+rZ6IOT3yFNMHvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY474EomvXmpAfK4uZdCSxpmELGgktXwCaXptW1Xi/w=;
 b=RkpCaVfxSAiUDKyqOnNXS/yYFvkbsTOeBNZ4J2CJ/NvwTCLRV7igBCh/kNXM8jtZEjtdk+xuKHaKrjGlgwjVtuoKCZN17IYVFOUta8qtPse850sf/7/yFnrUMdCoz5OkYWjJZXDTqJ8onsbq9BcHlqukz/wcpNWPavCxB04ftQrtG4O/vBSbv00EETDusV5NDc74kIjr2iwNEtfGgs2cZyBVTdoJfuNsujE2pebzck3CGlkeDdKshQDhMd9sKleRE+sRi5ev3oB1NsUKBiyDMYzLiEsCdlcfn7b4mHI+is375SwezBpbsoHs2rwWiB2f911Uc15fojrmrJXhtVUWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB3465.namprd12.prod.outlook.com (2603:10b6:5:3a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Fri, 4 Dec 2020 10:47:15 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3632.017; Fri, 4 Dec 2020
 10:47:15 +0000
Subject: Re: [PATCH net] net: bridge: vlan: fix error return code in
 __vlan_add()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1607071737-33875-1-git-send-email-zhangchangzhong@huawei.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b90689c4-ffa9-d3ca-2cd4-f39e84446639@nvidia.com>
Date:   Fri, 4 Dec 2020 12:47:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <1607071737-33875-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::24) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.129] (213.179.129.39) by ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 10:47:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8c29b2b-f898-4186-1e4a-08d89841f696
X-MS-TrafficTypeDiagnostic: DM6PR12MB3465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3465651AE251B1A2D1B6DC41DFF10@DM6PR12MB3465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nICrYPt/cRCYsmECgJSpEDer8Oj7DYxs+M+uO3/kvfMsnle0m82LvBnDStAIdR0kXWk8iQhy0oMpIjjLxMTiH7MvdOXkgI4wElaMwHUQfcJGr+NCALl561a3zcv/DSEpPMfrVQWlOG5/nvZX2bH+bbho7Wh7nqosXZs1lfgLOK0TzGsCORm4akNeeZpvq+PJE1No73OzEvxkxDuhI7lQiXB3aNITECN+xAOGMJO3T51+/0TniO7gg8qzE7vpkaFaPBrWd9uhBaDhlKpIfwPBlessDYr/+GmYZiKHMaOnSvnpO1kkvSvrf/CbjrOCS1FQcwsyxY7ExWFn+VGAPc4o58BsxB2EMVjg9JwE1uifARuOEJuGd2D5rKjRb/YqjYpTXosycYbsu+KoLY9NzQPK1soNeIaMS1YyEogCkKy9cqU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(8936002)(16576012)(2906002)(6486002)(83380400001)(956004)(36756003)(26005)(16526019)(186003)(66946007)(66476007)(53546011)(31686004)(66556008)(2616005)(31696002)(8676002)(5660300002)(478600001)(4326008)(110136005)(6666004)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?angzMjA0czJPMFlJbjNCaEJhRzlNbFBhUll6ZFgvcHAwTmtwUHIxczU4ZzNw?=
 =?utf-8?B?L2p3b3ZJWFZoTmVXK21odEhCZHJtYTg5VmNYdlByZ01aL3VvNWpDSThsRzdv?=
 =?utf-8?B?V3JqVjJpWGFyQ3lJbnVuQkVXaFdFTDBlYUJaMW45ZW1aMjFwWjZYamFDRWVx?=
 =?utf-8?B?RWJIYlVCREhmN2JHZ1JPNURsekRBRHNZZDN0U1p3R1lqNXMxbFNOV1lSV3JP?=
 =?utf-8?B?dm92K3lLOWVNaFpsbFFhTUYzMFVoYmRUeXBIbVZwZXNhcmg5UjNYMVBrUGVV?=
 =?utf-8?B?TkNmc01FWlU2bSs5bUFqQ2ZrQjBwY3JDSk9naFFmUWprc3laRGcyaFVVQ2FL?=
 =?utf-8?B?WUlSSno0WnN5YVRETVgreXMrc2hLRVVuVnhoYVdQektkVkNROStjelR2MVVV?=
 =?utf-8?B?M3Z4RnBvQitudkkxTDdWTHZMK1BVZmFzUkVqN2ZIc0J0UXJlNFRnOWJ1eEs4?=
 =?utf-8?B?SnE2bHh4UVUyWEE0SnFlRG8reUtpNEpyQnNmY2lCVFVJWWNUSXl2UVEzRGN0?=
 =?utf-8?B?S25idGRYZUM3Wm5hZTU1d1B2d1Z3YUxiL0dBcG9ZdFYzS3RCcGhRbisrSE94?=
 =?utf-8?B?cTRlN2xGcEY2OUkwcjVRR2tFK2ZUZFF5MDBLWWs3L3RKWXp6OWNJNHl3QXJn?=
 =?utf-8?B?c3UvWDFlaFJiSkZ5ZWdkaTAycFI0bGJyZ2NRYjl4NlJLd2l1c0FseGJFWjBa?=
 =?utf-8?B?U1BjekdFV3dwRWl4Wk5PdlZyZjErcm01ZldTRUUrbzhiMk5nWUtHR1IxRGNQ?=
 =?utf-8?B?M1dKcWJqUVBTdEJDZnlqYUw2UjY4V0pkamhSWmFJUnRIYm81dkl0ZFpGcGVh?=
 =?utf-8?B?cGpseDNlTVFTaTA0U2xETndkSDhEbGtHUEpzWXBlRkR4dyt6eDVFanhIdjRX?=
 =?utf-8?B?UFYrQk1WaFBoK3lmYzV6STM1cmU3YWlibDVSMWJwdWpQVFUySU55Ukw5ZGN2?=
 =?utf-8?B?dTlVWGRkYXJEOUUxRGtBUFJicDhma0xBa0Q0U2J1N1gwYStxakluVlhqbnQ2?=
 =?utf-8?B?aXB6QWVrRHdWTitzV2l3MWpUWjdCV1dld2xvUEJjSzVqKzB3L2NJVW9tWHlJ?=
 =?utf-8?B?Mm9STUUxQ3QxVm4vRk1CMDd1SnQva25GR3k0VFpXQnVlRThGQzBSUGRHbEQy?=
 =?utf-8?B?RDdFdmRFeDczYmNkN01XdXhoZm1lRHZJejhvRWxwWURmTHdWakIwb1ZCd0F1?=
 =?utf-8?B?WnV0dk43elVybjI0aDVLQ09JOEp1R0ZESnBoemRyVE9EaHRvdGpTS3dUSHpK?=
 =?utf-8?B?M1VYakFEVjZtaUthNWhNNDBNQzdVMVkrL21IT0I0OHRFdjdjc2FCUWNJcnVk?=
 =?utf-8?Q?MsSlICiM0F6bb/q7vkJzoqCQYpCRllmilS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c29b2b-f898-4186-1e4a-08d89841f696
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 10:47:15.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9G+TdlhhuIEDkqhAbyFymx6kR9fhpg3tVJvZZCnA9idakFFtjkvyKyDXavvHbGeeBlw8gL6HWPN5Ui8PfPz2LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3465
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607078842; bh=WY474EomvXmpAfK4uZdCSxpmELGgktXwCaXptW1Xi/w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=hddLOleZ01qaI2O02vHI4O+9XrX54pmbETrzz161Y66CuBj2FLC2HUxNcr0eCWboj
         rnFSxPmiWwt8f0X00jikxLy8XisDLdym5UYA0bnLKmUNaCxM+QGplEDGKQ+CJwe2nq
         yOJ9blU7Am9sPDyiK/q9cEDZWsLv3Pz541hcCKe8Z3v6247phznZ0J6DZ7DXBpi63V
         4fJLDyuamu2/sg5lneZD+O5xlfgMcCXDQtj8f1odE0WxR+TK+7iYEjckKicASBIY5o
         HmS4jBnVHhPzeoWbAq9yrOXZHAmiezch/IzYHCDKRNkGh4GbJbur4KpQBD3CZdb4fZ
         Hwl8MvvpYzWQQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12/2020 10:48, Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: f8ed289fab84 ("bridge: vlan: use br_vlan_(get|put)_master to deal with refcounts")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  net/bridge/br_vlan.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 3e493eb..08c7741 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -266,8 +266,10 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
>  		}
>  
>  		masterv = br_vlan_get_master(br, v->vid, extack);
> -		if (!masterv)
> +		if (!masterv) {
> +			err = -ENOMEM;
>  			goto out_filt;
> +		}
>  		v->brvlan = masterv;
>  		if (br_opt_get(br, BROPT_VLAN_STATS_PER_PORT)) {
>  			v->stats = netdev_alloc_pcpu_stats(struct br_vlan_stats);
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

