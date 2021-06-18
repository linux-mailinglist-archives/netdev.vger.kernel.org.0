Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8233AC888
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhFRKOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:14:51 -0400
Received: from mail-bn8nam08on2050.outbound.protection.outlook.com ([40.107.100.50]:29440
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231881AbhFRKOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXqHBECJqueY5ElH6QCcZQgQx/O7NjNh24yuKMQac43pDgzS4xUvI5Kz8H7LzAYQLyiIDb3WRZz0zOxtWxdoGPMwvQWOeajaWojqUlbC14GyeWfovhMIMEz3sMwiUzPsvFr26+VDBmRsbRQw+jDB2nGSkSyvQOzbJcWcTXP3KUzxwjheErAWB99jfcR6HEc9elV8r/aI6Hp6AtzjVdB1j7TAZeVtFm/TVtqoCyM12nB53gAGr9vp0RKqS4SHtLYAQrrYPjMa10/M8s1cHU8Gmc821xNPOWoa6WXisVGwZWpjQ4SAy2LwaF28zKSQrmlKx6rrry0dGr6U26BJpVLGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8ymBOaT7fdjda4eQd3+azcQcApZtzF7FNoDVGA8xmc=;
 b=hlfWE9NgSoV/49adNwIC4Lku39CmAhuFQcw1ZJXKWwUMeapHF064bc13AsEBuHDJb8P0N5GW/WRAWdvQj2cIxl/uGDetZcwRPEJBNGJ/g3NpKJWBDSdlVrPQ1dnbX9Sq7DYR1eri1WEWkMJaeS38gjsIhBaZVhhRs1z9wXuKLfsUbS+FfKRMx9le5QuhMTx6sLghjTuLwKYWdw+x+SHjVMuKZ4u/KoSlRAgKCgmGn1hDpFsNBlSEALpc9FDDVmzO2L1ZmkcKC6mWNeYjAA6decKLC9d55lQO3w6nbAedcRMIyzkNui3rseYrJ5g1M6uj2qSIzlZLUBuvHpaoAIkWiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8ymBOaT7fdjda4eQd3+azcQcApZtzF7FNoDVGA8xmc=;
 b=EVa4AugCKT1AnsHqy+6/kSFkV7uqXgzvm6K0gCcmTqmPFu7SZBdzgixIae1cy4vAmJiXYOTHA1GL0P0B878zmq29yUn1F2jn3R75QvvBBdWtUe1HcG62g0QjXSmdhyFHv21D7pcn1K6Y/pcDYxlN/13ZHq1sbtFhqoTZvWH0Mqx1rdKtq27gusI2To9ZCl14h8jBRaL8OjYXOvkKYWC5Rnh9PsVVIX17AYLd7E8vWFI5W92DspvBhYP2gBhWgw96Xt2ZxfPSfnvoNUEeSoOwbDkSuUshTZo8s17E6weT7pnaQM/d2f/cp9oLZWeHiFmSPJZSk6BgDhbfxtnpZpqldg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5151.namprd12.prod.outlook.com (2603:10b6:5:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Fri, 18 Jun
 2021 10:12:40 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3%3]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 10:12:40 +0000
Subject: Re: [PATCH] net: bridge: remove redundant continue statement
To:     Colin King <colin.king@canonical.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210618100155.101386-1-colin.king@canonical.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <2bf73453-1bd9-3f3a-ecc7-7e0003c886e4@nvidia.com>
Date:   Fri, 18 Jun 2021 13:12:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210618100155.101386-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.127] (213.179.129.39) by ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Fri, 18 Jun 2021 10:12:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15e05ead-e610-472f-f328-08d932419a98
X-MS-TrafficTypeDiagnostic: DM4PR12MB5151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5151E53E88A048F05B222D97DF0D9@DM4PR12MB5151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJC3HOPWKKH5vXZGWR8pS17J+7fCx57UEoTU/cnJtOgp8QrVDoBE0ONPYv3eDvU1bp6+tvhG1D8c8xIBbkGnPyUcSS0YW50qaZNITjQJxwKTkUOWBpb5s6M8oaAAbYk6if6uPWvx3/+LrtFeC1jJXo45qxkogrUh6AAeMQXFBHfY4oxot4WDuitRXYFCjMotHBZM4UGfwqOE+3KaeWoIB1sk9EQfPzID4a0S2Lkmxc+q5ang/DGRc09CpECJJll9mCM+ghisYBgkNwOqXhX3Fwb1P/XIndFBS3bRMX5jwu8lECraiPUSv3h95+NG+cPzQu3h1Eml7+cOdT0c0fs0sh2DZY4NzSbH0fYsfBFyqAX0mtReA40yUj3D5I6iVbz57gEUBLkYxlYR1vREefZbibfvL0DiicZSCEuL4MpGhYEYPPkyBn71qxNr93qlY0WB+mHlaXGex6hCy+UA+EtSAH3q7OAYJ2sbRGSWqC97tYT46mAHLbBx1LNxKQQvMdailvUe98RXgIqoZQYDde7OO3YgACIovkjSEkxApbk6QrcSrL0AeyF+k4EFq1tYsMKLRx7D3g5SKcB9MhPO+0C4Fp8ELwIMafv4nC25jYimlg0Ab4wliAxe+MKDhyx5hiijs+pVauWmFmWh0eNQ1Q/YPH4VvKwvgqbhWyTtciwOrPbmTZ/q9BDcABwueE94YqTb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(2906002)(66946007)(66476007)(6486002)(31696002)(5660300002)(4744005)(26005)(8676002)(8936002)(66556008)(83380400001)(31686004)(16526019)(110136005)(316002)(36756003)(38100700002)(6666004)(956004)(86362001)(186003)(478600001)(2616005)(4326008)(53546011)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmhZOXVrVFhEdWxBb0l6VExLTlFnaVRVOVlUdGFxRmNEeEMxQ0RBbXhtT3dl?=
 =?utf-8?B?Q1M3bkRSbzJrY0pVSzc1blRrWmlNc1B5eER1SkdrdGQ4aDg2d3lxdnQ2MGtZ?=
 =?utf-8?B?dmE4OU0vQXJTZXdlUVV1YkEvT1YzMTZVa0UwVFM3M05aaFN0cDN5eDJCZ3Z1?=
 =?utf-8?B?dVVpZGZXVjUzSGhXNCt4bGhoblRNQnpDdTVlOTVOZ2NTTGRIdStHSHJ1YUlr?=
 =?utf-8?B?QWgyVUVSVDZyYmFBSlFabDN2My9JWitIUkFrSFRQU3FzRTNvdVM5NnQzNDNv?=
 =?utf-8?B?TDYrWkhLQ1JSMGV4TW1VWGpoK3NQQTNaMFRyQ1lyNWh1U1lwNWpjM2VDUllS?=
 =?utf-8?B?ZkZJODZqQzhPS244dkJLbE95OC9zR2t2c3dRNmdaNnhJblFEWjJuOGUwZHRF?=
 =?utf-8?B?ajd3a0ozUHF4VnR3QlltSk4wWGswQk5wbVdzTEZVWCs0dmtBQVdYQVNEbjRO?=
 =?utf-8?B?YzhLMUpxLzhzM0dOMTBzb3hBdUZZRWhQY0lPTElERDFnVWZyekZQbTVSeG1r?=
 =?utf-8?B?bUFzakRqdkNCNDZ0cVJqdE54bWpLRlRBNERtKzRsVEVBRlo5YW0yTDI0V0Nn?=
 =?utf-8?B?dVNLL0t2YjNpUDFXUDFQckZoRUpKcGdUMEJjaUg4RTdEMWpoeUwvSkpHd2hN?=
 =?utf-8?B?eFNOK3hZeWIwakp2Nk5ReDZ2VjMxb2s1L1NVQzN6eDUvdjBjcVNuUDZqL29l?=
 =?utf-8?B?NWVjMElYNnJrRHJTcVVzTUtIR0cvWVM2WDhvam5YaTlrWFBjTkJGMzN6Z2Vk?=
 =?utf-8?B?dWpjTDBENVlHRnozZnpCZGlOMWsra0NJSjRlY0VJcWZpeVFMSUVxTlh3MUQ5?=
 =?utf-8?B?MFNiZjRjMTNHSm5iMUJZWFVKcjJvV1lyM20rRmo1VWFRRTkzUWtyb1ZYS28r?=
 =?utf-8?B?cmJsRDlHSUc1bnJjL0E3enZKbFdLbU0rNnVoQ21jNzJTOUp4T0xYU3FDN3JD?=
 =?utf-8?B?VzVNcFd3eEltK3BHcXArZ0hySXRNMm93cnlocEhTcm04T2hWSEg0S0NhVGpT?=
 =?utf-8?B?T2tIVWR0UFd4a0pmZXVmWE5ML3pDSXc2NUtsU3N1c0FQSHlDOFNGVjgySmRB?=
 =?utf-8?B?Z1BUTm85SHRxczkyRUlWbERCYzVoelJqdE5sOWE2L3FkdEw3NDd2Z3hoaHR3?=
 =?utf-8?B?K2hEWWExRTJFVVlrc0NGOU4wRS8zTW9yRi95eEx1NXVqWURYQUVYUVpyZ0Mz?=
 =?utf-8?B?Q0NGaEk1OTMzaHdMd0VGWVI1Ymg5VHVidllPUHp5R1J3M1VqUGV5TFNvNzEw?=
 =?utf-8?B?YVJBNzZOSWpjU2JpelF5WEN0OG9mTXEycCs3NmNhQmlsUjh3bEJ0M2Zacm10?=
 =?utf-8?B?SXdyaWFsL0JXWnFOUkVmeVRyTGozNmlvT0NZYzFoQjN5NmhrTCt5QksvdVQv?=
 =?utf-8?B?WlRmd250NmFtMHhjYTJaK0VIS3pNWk1XSXQrb3gwNmxzeUgzYjRnTGRPcHow?=
 =?utf-8?B?YjZOT21iMDIvLy83UDU5YnRUYm9sQmh5R05xZ3hDZlNncWk0bjRadGtvY09h?=
 =?utf-8?B?aERCcEhObUUxS2tBWWJsZUdOWHllM2R5eTdjT1hhY2pqV2RPU0FwRnpoakw4?=
 =?utf-8?B?OFlOeFJIWkF3eUFNMEhON1JkU1FuYndLb0hwUkFlNFR4b2MvbDJjZjlOWXNj?=
 =?utf-8?B?ZFNOeWRvZDliSVZIR2dYcHNBczBYSUVCWHFURXpOdTYzUm9yZGhkdEVtR3Zi?=
 =?utf-8?B?VVl1TFFzTmNGTVUrbUdVVUJCMnJwVk56VUp2b1VjM1h1RW0rUlFzVDNJZEVv?=
 =?utf-8?Q?oRyDs5Wm7M981BtqmF6I9k6kBw3ZrB6BRWGCx42?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15e05ead-e610-472f-f328-08d932419a98
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 10:12:40.0411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oeGmXak8vXpQlkj+TX02hvIyIZRUvm+gJbrLMfAvOE85AdbzXFBFbotp7Y3Va3eHhS1+WCjkd4LrAAGgtn+Jkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/06/2021 13:01, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement at the end of a for-loop has no effect,
> invert the if expression and remove the continue.
> 
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/bridge/br_vlan.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index da3256a3eed0..8789a57af543 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -113,9 +113,7 @@ static void __vlan_add_list(struct net_bridge_vlan *v)
>  	headp = &vg->vlan_list;
>  	list_for_each_prev(hpos, headp) {
>  		vent = list_entry(hpos, struct net_bridge_vlan, vlist);
> -		if (v->vid < vent->vid)
> -			continue;
> -		else
> +		if (v->vid >= vent->vid)
>  			break;
>  	}
>  	list_add_rcu(&v->vlist, hpos);
> 

This should be targeted at net-next. Thanks,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
