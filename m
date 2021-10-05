Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC324221A1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhJEJFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:05:39 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:41801
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233554AbhJEJFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 05:05:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sla4n4fLy82ptVH3PKxME0VKY6iq54sQyas8TcxzDWSi5YCLHJFnGJeTQjkbixJxihl6sXNK6TCYE1oEp4lrWm16ltaw+ztfqWC1+WuSSkdmz3llteRer44kzqNMEEaUTAOq7UBYMKLS4a2cnS/v3TP7UJCrHD0Uj5EPG1jxpfNCJdIobMIwSPN8/RrceEYKPKXm+5vPUe4RyErOxM5o545kA/EsppgCA1NRzp5R08rxYWa0VpUEKVcG5A8GohxlPdUiY0ewugLMZAh4UTHr7vrW4XcwhBnY7wXVuMxsEeWcHJAUVLaT2IV6tnNs2sKTz39dfhN/QX2Vj7jIeI4i1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aALjxYzpG6U7du0D5xeY3KlZtfe5dAgXkpPk06mvRjI=;
 b=NonR8yb7VA9Z27FMDlMXzO3zdGCA1CfOr4M6YPpYOg+v9S/yggQca1O/D8UOpMSviGY1BJUcRN6x9So5hJoqdP8BCpSywaXmRBq02rXhH5+yOQZiajGWADTHHNg776I+3bnFCwoz1Ffw+jt5aFYcUV+LSo5gh3uYy6pQSNOL8C7UMBppOr0iEIWRQKYPws3xLHpbC+RXZSkXdMt8jzDXq6LnaIomPvISFTHuNv1rEbvBoqblboml526z0IyLXruV8ydOGGZOistLR9J9EZ3TxzXqAMWExWsmZB/weUI/JvPjNF6V9SluXnAuIMOxnnAOuyRCIWX671mwQSScJVhOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aALjxYzpG6U7du0D5xeY3KlZtfe5dAgXkpPk06mvRjI=;
 b=IhUCo8orqe79IirBPJmwo2msCyioYNkho2eArnCo/P036xuGsGExwr9i8CocaM4sIQpyNlwwQj3bQR0EwIqWufR5U7b2wnxCF0Lb791H14h2VaN73NaKFfnhtbQClV04/wa2SrR0ZALfWixdOLrQoTRRcJDF+AaSnWOxq2zS3QEwfcls3CimWxwocwjE3dy7SseAe1mc5i2bJgtYpu3isVRXXVkRowwXM8hAJ7cQ9Sp3JYMtS31Z2t3NEpNPCBln4qVpBUhwlU51Drbx//26i8uXFzy2P4jOFw1AvqzOMayT94wtwwMTOlY1QVxRQzMMiV4woh0tdZGAyp+/fHl/SA==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.21; Tue, 5 Oct
 2021 09:03:46 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%7]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 09:03:46 +0000
Subject: Re: [PATCH net 1/2] net: bridge: use nla_total_size_64bit() in
 br_get_linkxstats_size()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20211005010508.2194560-1-eric.dumazet@gmail.com>
 <20211005010508.2194560-2-eric.dumazet@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <8d6dc3dd-16cb-28dc-7870-29ff1708ca96@nvidia.com>
Date:   Tue, 5 Oct 2021 12:03:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211005010508.2194560-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.239] (213.179.129.39) by ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 5 Oct 2021 09:03:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f597662d-2299-4762-17b7-08d987df0991
X-MS-TrafficTypeDiagnostic: DM6PR12MB5567:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5567B00F18868E58A899F7A5DFAF9@DM6PR12MB5567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAprEfLpm9EW3U81e1UfBGOQtGoF71uK/phs+SFn38Qibjrj3az2Z8Xt9S9NNlHaIrebWYJf7jufF1dC4xZGErbNkKOBXvIHruQ9DRDMc+gU2Soq18CVZKvKdnrDpfuJNJhc8xIMyi4Wl3Uo1Z3a5uNqhnQqEix6A4trj07K4+VYsd5KXrbWRFFTSI8GwwiKKnq1LIrfS02d3LPqwlK7V8RzTP1UnqB/o9L1jAh/RECXv685oEa0scrYKnsQ8hl4Vs2g1bXgJ13dsODS6BrK9UqBBxXXKKDL9QTDCMyo4wcPT0LCeKtF4s9NqbMntFfEKK4egdvHIN0VSV1//bs8CDlEDfM/16fUWJn8uCxvi9vpJKIGGPFxQM6xxkHwjgPULHdC41houCygBZWl5izzCN/l0JPPIbBHg6dnJ+K+SIXOC4yUbUO6k2fzuC/wiYaevy4ZcI3wr69xt3/7vD1YT6APlJJyjMLNfB9u9ak3TPW8KfC2nIJqRZzZW2wyWR0wL7aRLMgtQ71NgdZJxRzNLetBF3uO+oIyqgAhCliJmBPOYYyDT3c/WVz1eShlTwG36KB7guQDCF2RS3XVt/8+2H3ETw4tPzXMSD6oEVgv2RB6ENW57HZxNCVntQNEvnLgqY7QgVwQPgIDUqxwGFWFMA/fzgeO6fNHZru3tAIbIX1HQncdjDOLtBtbQT8Mt2S93cOlTu8XyCUNM9/yCqWEifgxcNMyO5920rasWJ8C/zg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(53546011)(16576012)(66946007)(86362001)(6666004)(316002)(110136005)(38100700002)(66476007)(66556008)(36756003)(31686004)(8676002)(2906002)(508600001)(54906003)(2616005)(186003)(956004)(4326008)(8936002)(26005)(83380400001)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3IrS0ZXWDhnMlBHZ1V1V0IxWUk2Vm9LMnMzbVUvSmk2RHk4VDdMTGR5bURh?=
 =?utf-8?B?YThoT0tPWEV1WjljbVdWdDA2RzFMM0NYemdESmJPN1l2QnpsclZ6VGF2Zkhj?=
 =?utf-8?B?b1lkb0xRcnVPS3hRQjJhNkhpcFFzQnExQVlVNWhsT1ZEZDZaaTFuTERseWUr?=
 =?utf-8?B?WjFncnUxUkdOS1FpU3h3bXA5eEtGNHdDaDk1N1FqYlB4bkhXTHNjWWt1akZT?=
 =?utf-8?B?Y25OeTF2UHZwN3paZnlYT3phakdLK2xReVQ4TnBKc2ZTM1hMZjYwUzg0anhx?=
 =?utf-8?B?eXRmREozb05Uenh2NFBTRnpBckNJVks5Uklsd0hUQWVNaDh2NWhuczUrTjlR?=
 =?utf-8?B?dXUxeWZoallHaElnbWF5S3g4VDYzYlZVQUQ3VWE1MmRiL2JIUE0xeGxCbXRn?=
 =?utf-8?B?R2NVdFM4QW05MmZ0TDJmSWNpN0d1RHV0SDhIeGRBdjJCVUhrVWJCbjhYSVlI?=
 =?utf-8?B?aUN5SWpwTGgrUzE5ZmN3OExPVHRUcEoyTVRuSHp1ZmVRMVozNmM2RzBQYlI0?=
 =?utf-8?B?aG5RWWdEeE1QUlpORUVEVStUdEhuSkkra1ZPRk9RN2FZM0c2S2J2em1oazh2?=
 =?utf-8?B?VmwvejVKOGlBVVJBeFE1bVZWK09iWkNRQ1NUTXRxcTNmK3dUTzJEaCtvaUtQ?=
 =?utf-8?B?OVBxQkYwTjAyWmlZNldrS0FKNXNkbEk1dHYxTFp3NFJaWk52eUo5eTlGamZ3?=
 =?utf-8?B?NXV0ekVUcnFEV1VWQmxYVklVYzN5RDNHd1N2N3FGRU1IbWdMSDhNQ3hKSEZs?=
 =?utf-8?B?UlkrZU9YNnN3UDFzOUJCaC92Vklqbkk1NnUvUHBSTWdJY04zb0cvN1FkaTBP?=
 =?utf-8?B?cHp5YStjWXhvZmFsdWlDU21lTDJTWHB5VW9RZHl6ZmpuNWhTRTBmVk1DTUwx?=
 =?utf-8?B?ZkM3QUluM3MyL3V0ZVN4UWpueVFhQUdDYVNMcE1vaWszSVdTcGNQb1h1UXQ5?=
 =?utf-8?B?RWlMNlFXS3BGSko4T3lMay9NZVY1NytiNXhNRTRZRW9JRHF5M1dpeHpsWnBi?=
 =?utf-8?B?R0FQYTNvVlpOenBrc1h2KzlrTmhZUStoNlRPRTNGaStxT1F4RWFWYWEzK3la?=
 =?utf-8?B?ditCNHc0VW5CWEtEb2V6eGczMGNKREh0MkZLa1NabVBMRUIwU01RblM4dHU0?=
 =?utf-8?B?ek9CN3ZCaEJueU56WmNtS2R0VUhnTHpUdWhiSDZMT01RZzMxTGsrbm80TXNt?=
 =?utf-8?B?SmphUi9Jd2JMdUpDWWpVcWVVVWYwQ1dKRHl5VVRSd2txdnRObWNxSnpVVE56?=
 =?utf-8?B?SmREaERRbEhwZ1oyeDJtSzVvdXd4eUdCclpCT2NkMk9FU0tsWElGMVRKSXk5?=
 =?utf-8?B?RDkwV2htY1Z2WEhDV21udVQzeEx5cmRLZGpRL0lULzNxQjJXalZzZFN3TnNM?=
 =?utf-8?B?dFJhZC9vWW9Gaitta0RZZlJmdHVVbGczdzZNMzRCRURsb0d4N0Y2MXlPN2xK?=
 =?utf-8?B?M3hLUFRSaEtYWmFhUWVRa1hpQWRPR09RcGhnZE9JYkFCdUtabXhxelEzSUZy?=
 =?utf-8?B?NGNrRm1iam9OTjBTaXNVU1dpbDUzNm5oSFZ4MUQ0Rm5zNkQxcjBUVTRNdXRx?=
 =?utf-8?B?QW02L1g0OHRnbUZ5SDRGYVdnSWloZnZQa3Z3Wm1yUjlVdkFwdG5wZnhybWxJ?=
 =?utf-8?B?dU5vSGl0eFdEVEdoRmNnK1REL3U3enNnRURyamtKRTNialdaSSs1NVRMckx3?=
 =?utf-8?B?NXY3UjduYnY3RVdhaUpHV0tnTkV0NjJPVGNwSmZmekJXckJURi9tNlNVYldE?=
 =?utf-8?Q?B4eQy5yNcjTxSzMclQCpXZzVDE3/uApT/d55KED?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f597662d-2299-4762-17b7-08d987df0991
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 09:03:45.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZl73S9h6Mqh904XUCqmpvWB4/HnSDiDRv0gY3V6DXSmUmuEZzMaJOvzKTqIJCXKO70fIobzJhKfPyzY+zAm0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2021 04:05, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> bridge_fill_linkxstats() is using nla_reserve_64bit().
> 
> We must use nla_total_size_64bit() instead of nla_total_size()
> for corresponding data structure.
> 
> Fixes: 1080ab95e3c7 ("net: bridge: add support for IGMP/MLD stats and export them via netlink")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  net/bridge/br_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 6c58fc14d2cb2de8bcd8364fc5e766247aba2e97..29b8f6373fb925d48ce876dcda7fccc10539240a 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1666,7 +1666,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
>  	}
>  
>  	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
> -	       nla_total_size(sizeof(struct br_mcast_stats)) +
> +	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
>  	       nla_total_size(0);
>  }
>  
> 

Good catch. Thanks,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

