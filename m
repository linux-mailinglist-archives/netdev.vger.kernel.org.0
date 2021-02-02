Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4766C30C2FE
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhBBPGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:06:46 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6593 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhBBORI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:17:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60195eb60000>; Tue, 02 Feb 2021 06:16:22 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 14:16:21 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 14:16:19 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 14:16:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K02h0+/QlBH2C+y6URZbvNIVaL8MCthBnfAvPRXD8ujv3XNv9JVgTi3auap2UM9FmIE3uArQTpPXwU4V5CyQgMqP9XFhppLiNgE1SJ/0Av4lSw70x2+12WmLoUZq9xu1kYeFwR1Xue+jjXLzyXrgJiFqyDJ1By09TCKWUj8k5OoB/VBJuGwdLr1LwSbRVdRjTUrl1aJOzolfDfWvL8w2OiJHhVK3HBws3VqdBmcz16u1AmV/PR1dzgR0Xv/ouaYE3NFFQt2XyhyLg2kBR5aJ9Fc4e+OaFlqNZtMK/2OvdFSfwJNpJR66ywiR+AybLd4n4DqM0qn8YRe8FWWWQ1Lk6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsL7qfg+zKynB5Z7OSyECdPUdFbLmsetrFPFxTBwbOU=;
 b=WlZeIMFLkdQcPEyA7/29M9CxFbGTg5144ti8KlbStpwCtshg8vhlmo5gGMQ4p9VTkoBu+ABRaixTsXhD3hqbGYgMsYWtFLvzm1TVexAU8FSEUsnPykpdXK75+c7LjDbNGq5H08bPDyuwgJTNfGL09VKsNnVpLfGMzIXVywFcekU0hDD6puOAqtQObsUNEHVg24X77dZ0WoFzRQTXUfDvvm9jI17YMskCvur+WZqUz4P/iRHkdc+mdYRR1Nh08jzOEPeh+gkoIcoMOyZfD+STdIwTZi7J5xsmQ3fHdjO302X4vaR1nKdt2V+9AUMpJjrmboDqsyIv7X/D3mAo3H2zdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1292.namprd12.prod.outlook.com (2603:10b6:3:73::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.24; Tue, 2 Feb 2021 14:16:17 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::edba:d7b5:bd18:5704%4]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 14:16:17 +0000
Subject: Re: [PATCH 106/141] net: bridge: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <44b2e50d345f1319071a53fb191ac0a0cf3fcf37.1605896060.git.gustavoars@kernel.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <143dd4a9-b0b7-36a6-ee33-0b5cb024c1e6@nvidia.com>
Date:   Tue, 2 Feb 2021 16:16:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <44b2e50d345f1319071a53fb191ac0a0cf3fcf37.1605896060.git.gustavoars@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GVAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::11) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.157] (213.179.129.39) by GVAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 14:16:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa8eb566-773c-4b78-7806-08d8c7851aee
X-MS-TrafficTypeDiagnostic: DM5PR12MB1292:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12926F7E8FF3D5F2A9C3FBE7DFB59@DM5PR12MB1292.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vN7Y1w/sAd0xWrNkp/JAY40yRr4Kighl8AaoOZtuTLBOjo6GNRwLE3Cxf9dpsVjfsqfdI51R4tw6s1gBpoPPRQCrpH3h3iR9Z1MZtrF1c/Kr0+3UrSWzmDi7ltj4+2LlMUAt5x3VMcn0YBI4gywEL/dLE+YRejmNGkMFBpTSFkiz7FlEBomHmZ02A/9X6hoPtHCNtOJz6nm7L/Zygb5zOpEVJzOgiYA45aOmCQINFvUDvc+cdEJqkBPUyHsZuUsfkK59RA47qlgOCGhdYxISKIT7+Vlc6OAwf9gypoRA3IeNRwJvBJVRaDEhbWto2PKvFRnkIyHnRHQ84qgAh5erROo1FcfFL6Cv+RKa1MBGd7XVs842pZaJNKsOTgsd/cYlj5Zsk/1XBDpt4Kv+EnZYVVh64OP8JaZzhEr1GJiC7aZlvKFy4+54kLRIBF6lc7k0W/+CvqRDArxVyT662DS2ElqTMbZl+GckJ/di3rjtbRSmns8vUCFo/RM91aG+j7qobKaRENyaISdCxVSWqm/Q25gzrNGmYndoHnZhXLSOjKMJ9afk6t4T8usBrsd/1d6niXzWI8eDyvRc6ejx/utyeIPStwGUreGj3Pdy7uP95tgad+7NMdC0219sHB2mFIJe64BDTY9gPfF4tXdRtLJP3Ujc0+GGKuhjIrvIA3Ixos/e3PwjzLNSH6Io9FBpHz0Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(110136005)(86362001)(2906002)(53546011)(6486002)(66946007)(8936002)(83380400001)(478600001)(2616005)(4744005)(66476007)(16576012)(6666004)(316002)(16526019)(956004)(66556008)(26005)(186003)(966005)(4326008)(31696002)(31686004)(5660300002)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXk5TDhBQUZKbHR4YWJFVVhYUkpOSjE4Tlp4MVVUbnFCeGxiSFNUdGpPNlUv?=
 =?utf-8?B?Y3lFOVd4dmwzVlJmam1MTFlmWFlieHhNQ01BYzhUVTBZYjlRcEdRa2dUL1FY?=
 =?utf-8?B?SlBITTZCTXBsSU5qQ0hLaTB1elQrVDZ5QnJqSVlyRkNtejFJUDVSRjZLRmha?=
 =?utf-8?B?T0dML0lVS05pZytXeC9iYzdtTEw3TDhXanFmRVZQcnhyTkN4VHdRRjhQbmZV?=
 =?utf-8?B?OEROYUhqMzdBS2dmUzdCbWJOSkJVa1B4ejlYQ0NWNnRHakNPOEYvZDBJalVh?=
 =?utf-8?B?ZmJkRkVGdTlzaThpUVgzL3JyNGtjUTJvNCtEU0lManBxU2YyTCtxUGV5Tlgy?=
 =?utf-8?B?ZTdleXBCR0JPUVJmd2FjOFZEQlB5RGt5a2hXTmY5ZmR0dFpGV0RqSTk4RXY1?=
 =?utf-8?B?NWVkUzBIc0MxUUM3WjRWMTZHOTQ0RzNFeGpYZTZpVUhLbVdIUDVmaWNxMmpN?=
 =?utf-8?B?M3krMnZINEgzd2N1Ny9tam8vcWJodGM3TVlKRytVSm5JZStheUQ2QzRMeE9i?=
 =?utf-8?B?Tm1PVEtJQmI1dmNyQkU1WFpmWkRxczhtU1QvVVNSSnEyeHQrcWRZbFhZY1hq?=
 =?utf-8?B?dk42N3dqY1dJaXN5OVZsck9KNzZLNmNYSTlqdXhWSGpTR0dRTWo4enViOEc2?=
 =?utf-8?B?czMySU1jK2pScm9aZmN2ZmQrVy9FRUpMRHBjM1hYbUFUMTd0L05LR0hNQTht?=
 =?utf-8?B?bFZqZUNQNGZGd2pMN1R2QVlUN2UvL0dZMHBoSE91OGdwVk9JVVFLZjliaCsy?=
 =?utf-8?B?NHAzVkpocDE4WGpxWTlTZ0trQ1dSMUh2eHdTbVdCbENWUDFtQWZsMGo5VFR3?=
 =?utf-8?B?V2phb2dYalFlNi9EOC9IWGh1ckRZNklnWUF1clBlWlh3c3gxV1FXNTcxaUk5?=
 =?utf-8?B?dXhrN3o1Tkk3aGVLMzdvVWpSVU1Gc3U4YlIxQU9xdGsrZE1sQ2JKUnJxZGNC?=
 =?utf-8?B?eDBnd3N0bENpVnJKVXlGRjZkKzFsSWE0eHovWUd6SWJ6ZFZoVTNjSFFybHZo?=
 =?utf-8?B?RHEzV1RyK09haEdvZnVwWFgvMCtGZzM5cFBqUEZCN0ljNEFWS0Y0bmFtMUps?=
 =?utf-8?B?Qyt6d05rVHVhWnNGRnRSb3ZPU2J5c29OamE0QUE4MkFHYnk2RkJrUVVDZ1ZB?=
 =?utf-8?B?MkwxSTYxYzBwUmxYU1k2M3R5MHN5akRzUlNPL0JQZUJsRnNtd2J6UkxRTHEx?=
 =?utf-8?B?NkpCQTFRMHJ0VGRoVHlIc21YcG5Ic01GdEo3SkFyWERVaXBCN2RhbWlsWVhH?=
 =?utf-8?B?NkI5MDMxQVIxRVBkQzRob0prSDY5NlZyeFBEK3pLNXpwRWlhSkRhb2t5OTkw?=
 =?utf-8?B?NUJXMFM5T1ZMZGxLN1R2OVRvYlQvcXo5UFJlTjM4RERsUlg5dTY4Zitsczli?=
 =?utf-8?B?TWk2NFFSVytzaGFGemxpRXVjRTF2OWVZSTFvS3BOZHpYTVd1SEt1M0dmZDdk?=
 =?utf-8?B?eWdubXRUOUI5WVZFK0lrOVc3OFp4VkpPY1pFNVhXYnU1Qnh1ZHkrc0JYQUhu?=
 =?utf-8?B?WlRlZE02RjFDdEg4SkRDanI4bFhWa0hXSE9Ib0xyV2RoWUJXR1I3NUxDLzZC?=
 =?utf-8?B?WSt6V0pxc2dKb2k2a2RRMWNiaGYvY0dhaVBNWkF1TWh0WnJSUy9uMFFBeWw3?=
 =?utf-8?B?MW5rUHlDRjR2WmFZWnFxMVZmS1lUdmVMVzkxSGNvWE9jazNaVnBIYnNiZUht?=
 =?utf-8?B?UHlGRWVZNys2UHpLcTEvODJRMnR1ejIxbmhCTVZaSkZ0MnVXbnRtZnVHQ0li?=
 =?utf-8?Q?bpr2x5sxl41U02dLOw3SsO4+aKFCefUIb/9ryeD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8eb566-773c-4b78-7806-08d8c7851aee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 14:16:17.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abj8RM5kRWDPmVaVrKyQ+JLzpLtkTt8qn0s/npCaT3yI4pZkjIAxRX0uULmTWL+KwCzJPI2pSa8kPXwKcKkOww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1292
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612275382; bh=JsL7qfg+zKynB5Z7OSyECdPUdFbLmsetrFPFxTBwbOU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
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
        b=osREM9QiAR6Zy07bBDJYEdibzkxFUz/TZIhJNFQCyygvZ77yeuSnbMgu/APf14/W6
         8ZEVEDU9/bn6YriIVWf/ZeC7kYX9uf/ScDWf7bB9Zk9mkmHuM0AtS/O94sMYYzmeTk
         Rh1Zwrx15O7Qgd2eUHFtjbOcLT+J75nk0UrTkh2xhdMWuw18wVnKavzE1FD/sWgTM3
         V/sqB//G67azEHgJreq8ur9S88emD7VscZXO26CmXU2zmT2J//gYOEmFo+IwFBakiX
         HcPYF4M5TLOGAD5mYJj5d+zVdIMqYGKL3YrfEl/SsuyohL1bhGqRtUsNvgUTW3dXHw
         AxpCkKGmX53/Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/11/2020 20:37, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/bridge/br_input.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 59a318b9f646..8db219d979c5 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -148,6 +148,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  		break;
>  	case BR_PKT_UNICAST:
>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
> +		break;
>  	default:
>  		break;
>  	}
> 

Somehow this hasn't hit my inbox, good thing I just got the reply and saw the
patch. Anyway, thanks!

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

