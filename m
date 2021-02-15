Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A231C3C9
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhBOVtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:49:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8025 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBOVtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:49:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602aec2d0000>; Mon, 15 Feb 2021 13:48:29 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 21:48:27 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 21:48:25 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 15 Feb 2021 21:48:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Px5PeqX5TAjFZWWVaIJwZhAoguZnsCBj3tqcoh0jxqULJkh/1f/QMObGZEWM9ig/k6aLMKjlmw758AAppkgwK8V48ye0FM2eoFspzvfXdNI9L5HQEs9r023N0isxZMcqe8PU5eCyrsfnf7eW/ZgwyDvW+MOhWqRWIJiGM9QwKuyYW+lRdx6cJiv67EHlm2VPhRyxLrk2d5a+0BNZEpyuaP4froPP4IONDi/PavkckoCNdx/n7wn/nU2Dfp9gvw73woGhgGoMGoPV9ASO1k/WCi4EgqI6/OgO2fvnbtKSf+5Ej1WQlzRYExVaK36A4Tex9r2ArQlOyJGFDh7GBkU6SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBvfzZlfgSot80yVDID7HSZib476fi8SkxSJHNxwjr4=;
 b=MITuqBzghnzAUcYfwMCy1VvUjz214mAVrVe9QvFUdk2DZUJ7NPmf19FeNOrz/LRgqQCctAcSMn5v9rgBI7zC6jzfl9+ruAcFosBN1+E4hkRmwlaTBisPqdQg3q03Qhq3/kR/SVTvw4A1HFs1syXKE/HdswWjjqnl97pdABf5XFUUndHwltXxpOGTQ1z3c3qbToa0b8L/iUuOsMLrHUnJJhmZkttZPHygxBve3Smmv+Zsbp0v76faCG1WMcBuZQnRSMIk1B0xd6gEwRxAQUc0QQF673/zxMrOzgnVwcNFGJqgRQ7FfTBDX3akU0582r1kdh64zRCkXZe8aLyyxyvf3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4089.namprd12.prod.outlook.com (2603:10b6:5:213::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Mon, 15 Feb
 2021 21:48:22 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.041; Mon, 15 Feb 2021
 21:48:22 +0000
Subject: Re: [PATCH net-next 0/2] Fixing build breakage after "Merge branch
 'Propagate-extack-for-switchdev-LANs-from-DSA'"
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>
References: <20210215210912.2633895-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b49bdae9-eff2-e46c-5f13-cb90a704bfc7@nvidia.com>
Date:   Mon, 15 Feb 2021 23:48:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210215210912.2633895-1-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GVAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::11) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.177] (213.179.129.39) by GVAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Mon, 15 Feb 2021 21:48:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3310def8-e8c9-4b69-4b44-08d8d1fb6a61
X-MS-TrafficTypeDiagnostic: DM6PR12MB4089:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4089C9F7ED807596BE98F41BDF889@DM6PR12MB4089.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h3Jzrb9loT7mO5WNsBYpETXnpOoMbAHhafjSaddq6Klx/S3IjLEJZQJ3C5Fz9tonnrzBKj126T9X8LxB/+OaQN1sIMIwVHf+OcefrGMNPeT3yhwa36wsozbdsJBL5RJmVyewcS6VVuktuyQ7elNCN0fdS/uhKIoGlrOjj/tCXLlmmGZ30QnQZAhfRroAxZ07djPRJMKu+VZnQhj22SZvLut3ZBqzRE/x1mClHJfbOVeTXqQt7kthRJAmrwU5v/swkwZqbE7DQk06XxvMjBnCKY1OJLTDpu3+dKBi68ToOMeKRSlf2nuNCMu3i5BWacDqbtDJtjuW06rCEXRq1M3D+rr5gTNuJIzOmw+a8geElVdbCl5JIIFQmYhkRAZGNNIM+DKl7giISF2BKSa8woadxGLYEDzxL/jhaZPkxCxv84hzVxGN3E/mzDi6eeMobFexs2YbBufpgP/q6aXogrsl7JdqE5UCydNmKGuOvel4rk+B3Jl4+ccfjVmdwpo4dUSWnjD2l7bBfosvDht871DYnuGLty6G4HKmvYZ+6fMJfHgqHT0SNpkDqYnb5aKD8v3aAEqE1yLLadhkGxEoJd5WlSUyz2AA71z5FTLpneRs5gE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(66476007)(2616005)(956004)(66946007)(83380400001)(31686004)(36756003)(66556008)(16526019)(478600001)(186003)(8936002)(26005)(31696002)(6486002)(5660300002)(53546011)(6666004)(2906002)(107886003)(110136005)(4744005)(16576012)(316002)(86362001)(8676002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cWhDSjY3Q1VyQVhBd2lyOC96ZXV4STh4azFPc3ZaUXpzY0lxZTVLWHl5alh1?=
 =?utf-8?B?dy91YlJoTEFtYVdXY2t4TjhIZ2NlNGVPd1U2VFJRZlQ3cXJ4OG9uczNJMzJN?=
 =?utf-8?B?N0JsTkJ5bzhlaGxpTUhqaWJwdStlTURTd3FvNjNYcURUdXE3U0RqdDhiWmhN?=
 =?utf-8?B?dDYxc0poMDQ5U2ZXVHpJN3lOL01FVDZ6c3lhWVJycFZ0MVZHUDN6Z1o2SVRz?=
 =?utf-8?B?UFVJeGl0cFczQ0c4L2hUb2JoUVR4R1BGUTBrWEFiUWtFMEFtYWxXOFhWQ0Ex?=
 =?utf-8?B?UWxHYmpaLzlMamRWd1dRd2lBSjYrU2daYyt5NDI1M3NycUliUE5hd0N5ZGhQ?=
 =?utf-8?B?bjRBMlRKZHlmbFArSVVYengyYVp0Q0M3TTF5cHlGbXUxZFJBb2xBUUFwd1Ft?=
 =?utf-8?B?ZUF6ZHp1VUh0Q3puTGNBNG5OcEN0ZjZFcDNkQ2ZFZkszYkozbEVtVUtSYlhz?=
 =?utf-8?B?am4wK3I3bDU2Tmt4YnNKRnZQNkRRSGtKbC9HMUVKUXFYd0JRNEVNckpXaDZG?=
 =?utf-8?B?WGRLMEJFMzk3Q1dXdXdzeVBteHpLZGtOTUtHaHkvNk1oQnlBcUlNUFBWR1Y5?=
 =?utf-8?B?TWtkOTErOGltUVkzSEk0bzllaGlNUXNmdEk5TWhvVWllb1ZIcjZFY05TL2Va?=
 =?utf-8?B?cDJ1REk1VWYvTEtTdUltUlJidS8zV3BtY2o4OVQ1a0N3dkVRdnArMFVBV0Ja?=
 =?utf-8?B?MkxZUkdFM0tQOTI0UGRZaUZYd2p0eFdzMWg1UVJhcmxVSzJIMzdXVHdzZmNl?=
 =?utf-8?B?a2hPRXoyZzRHd1Mra0c2K2lTQzVKRFYxZUZlY280dTlKVEpUZFZhYm5vMk81?=
 =?utf-8?B?d3gxVFk2b2FqeXJtNUUxZXd3VmNHOGJtanZ2SUlSRXdwaU1oUWlEc09JK2pH?=
 =?utf-8?B?NXVRU2k2ek1oZ3E5MmZPR1hmYXc1MUhSSmlSbWFVQ1RLd1Q3cmhQSTN0VmRB?=
 =?utf-8?B?K1B2ZlI0b2FKcjRocWR5bytiamQ2UFBITHNZT1RaSmd4ZDF4bHBubFY3d2F4?=
 =?utf-8?B?bXlwVlFIMDdxeFBuTkROVUFOaEpNa1B1ZFJzSmFwa0RQZ2VCN0l0UkE3YUVH?=
 =?utf-8?B?a081S1k2ZktDWTN1WnE3eHpvNU14TUsrUC9MaXM0QnpPY2FaTTViOHFweXlZ?=
 =?utf-8?B?QnQ5TUY5YU92MEJXTUp2Y3RxTEZQTTdGZFhEUkNJU2dXKzhoSTljclVmUHVO?=
 =?utf-8?B?QTEvZWdQMHhSemF4R0ozaGxZR0lqZnJNOFMzbXFzSFNmcFBYbjZzcnZnRWx2?=
 =?utf-8?B?eFhPYzMrTzM4aUJ5QTZLWWpTY25YdVFNelQyYTZ4NlozcVpNQ1Z5K2NWL0Mx?=
 =?utf-8?B?dVV6emJlZlZrZjlJZHprUmpMbFJRREhMc3lLcjhGdG9yaldMU3VwUGhoOWRT?=
 =?utf-8?B?S2FDMUdvSllXSlJ2eitHUWZkQVB2ZGZSN0tkSzV0bXdzUUFzODJxTmdKYkJm?=
 =?utf-8?B?ODE2V3VDc28zWW1nNWE3azJCbElJZSt0elNBRXEyZnc5M2lORFRldzRiaUlZ?=
 =?utf-8?B?NFQvL2JKcVV6eVhZNVRQdHhNRjVETGhSb2M2R1RRNUcxNXpvM2lCcjVOK2xr?=
 =?utf-8?B?bGJ2eFhKUFJJUDlLS0VZaEs0bDFZS2ZuNmhOVUlrRzFuc215cVpnckhDQ3dF?=
 =?utf-8?B?WklYa2xmQTJsRllzejJnb3k3MVdyTHlJMnp0N05YV1EzMjEvSjNyaFJEbzc1?=
 =?utf-8?B?UC9BWGRJc0VQTFRvV1JLTk1zTlRsN0dMRnMwQTl6a0FzSVhkNUVLeVBJcHRm?=
 =?utf-8?Q?IzDebT2AQPGaHzFeNAD8mna8fKPWrfSaF91ReeQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3310def8-e8c9-4b69-4b44-08d8d1fb6a61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2021 21:48:22.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rjau4r68RHwIuOKN7iu0REmsxjQsPwMm5STapLB4Q+p1gIA/FZwYnnxGcfSvzeau5slOLgBfHWWsUf2IoCpxOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4089
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613425709; bh=kBvfzZlfgSot80yVDID7HSZib476fi8SkxSJHNxwjr4=;
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
        b=OWOHd8I8kJePDoU7vt+lyNwWtNmE7JfTjW+a/XM+LooRD/fS6Hk9ylICIfLHzvXwy
         9/YOfxQvVHl9xXQiUkXYGBWHtagXnw71tMtl2BJ0LVQISVspn/RbIYbm3OnXbPqK+D
         /KhqPdTX0RRD67rTOJM78IlX8NvLBA+gV4ZdBZLSPhKKqFH8qvxu+e3wV2EQ9xgRzs
         vmtozij1/FkOhTsUb8KzmMckhTxEBBXFByxxSSty7XhPcjVXeD0zDe//6cI4zgSwwu
         gtMbsGco/aifywe59yPxaM8lshQjhqXpqgT5xLIa3Bbd/yDd98Av3rNRRzI8R6MyAv
         94MjeWOhiiFZQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2021 23:09, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There were two build issues in the 'Propagate extack for switchdev VLANs
> from DSA', both related to function prototypes not updated for some stub
> definitions when CONFIG_SWITCHDEV=n and CONFIG_BRIDGE_VLAN_FILTERING=n.
> 
> Vladimir Oltean (2):
>   net: bridge: fix switchdev_port_attr_set stub when CONFIG_SWITCHDEV=n
>   net: bridge: fix br_vlan_filter_toggle stub when
>     CONFIG_BRIDGE_VLAN_FILTERING=n
> 
>  include/net/switchdev.h | 3 ++-
>  net/bridge/br_private.h | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 

This was unexpected. :) Thanks for fixing these so quickly.
FWIW:
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


