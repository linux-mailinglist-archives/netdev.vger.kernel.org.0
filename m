Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE542ABB2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhJLSQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:16:11 -0400
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:12704
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232387AbhJLSQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:16:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqioyE6B5YKVYBocgYJazajXXqw6MgAKgE2B6Gn4+5ZVo3AWaMyzDL3v/Oo9CtmF47oqLgWKyu4CXBzSgp7kItBAE6yfd3SCoqnXyckn/ECk/oo4EAVRCnIAn5c6+SyLnUc8qwKJerYUJz6Ps9pZ1FKjXHShe5lA9eb42Qn1pRSyfbkte9FTIm3qfhdDkRACYB+eUYYcwOWcjsrsOFZQU4uTS7OwjVI+NgxV2DtauorZY8vqW6lJGA11kNKYql2BB63fWoP3tHQENoedmxqVJr8ZGPrrsCgu47zRKA9fM0R4kjzM3n7q6G4JEuIJ8XzfWH19qG7mpr3vmYBpXv3PNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oazv1YQBTYQUCOKkj94CaAmCt5tPyLDjXiBwuab1oiQ=;
 b=X/UHUMn/J21cAfc+ssu77652jGxg0MIlpOEFQCEtgJ6hzYLMxZoecHlWo3mMskaq0VKcAvHneWCL7xgYdHbWRZ7yqQh9nsB80LhVG29trAq+w5DU/gufW2vRE4YGOh/wE7h0S1kjVTYEVMU+nvpiZjqpBBekpXVOUoqfi//d1S/u5kjQmtETwQk1aKVeS2stlg1KXPUq3tXZ0kJzLTfCztcQMp6riBnua2fc+8jLOET3TVtqax4Gu0NAEA1KyKVWD7vecjTQYv2HpaRpNsVkzHuSyefzFZWSJ6LqrGfqFtrlIMSq8zJMEKLj49x0RPXG/mRD/401T8kNL5tyYouKnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oazv1YQBTYQUCOKkj94CaAmCt5tPyLDjXiBwuab1oiQ=;
 b=yulm236B6IkN+Wb5MrPDvp2hOjm7gbw5KqrCN4oZp2LE+97viXwk25k7Lgekhm0JE7f6zsY0CrbojZVty8/b3Chl+4MPveRGO7rJvAtCRMe5JGqLcVqUqvCGu6UNvE7khkg8ppFG9YWp3Yf/QCYwN2IS8vCykFJPaYzeCh23/+4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5342.namprd12.prod.outlook.com (2603:10b6:5:39f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 18:14:06 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:14:06 +0000
Subject: Re: [PATCH v2 2/2] net: amd-xgbe: Enable RRC when auto-negotiation is
 enabled
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raju.Rangoju@amd.com,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
References: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
 <20211012180415.3454346-2-Shyam-sundar.S-k@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1b803d76-8579-b567-da39-3cbd01c7c74d@amd.com>
Date:   Tue, 12 Oct 2021 13:14:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211012180415.3454346-2-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0074.namprd05.prod.outlook.com
 (2603:10b6:803:22::12) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by SN4PR0501CA0074.namprd05.prod.outlook.com (2603:10b6:803:22::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Tue, 12 Oct 2021 18:14:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab3189a0-c2c7-4f7d-69fd-08d98dac13e7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5342:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5342CF7E9193CFD16E3C0985ECB69@DM4PR12MB5342.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slQr0jHqfV02LSLAI+aE9BAN2TVNJ5xZddG6azNo9rSXI987nqdAIxE/bCrcvM2txlS2NKLgdfYr0QL+Rvc72fecUTwT3lD7PyzNfgtzv5EXdfpIuFOD+6ZlkCYju6T5fQlKbBe9/vRKWbugQeoymQfdU0hUzi/ZxPu5rTSntXl5IDSBM6W64A9/nnsukZWAYFmK5h9t6LEGCARH9urkjRgTxwObzSSZiAMVAEXcCtCZL1fRVWnhLXsSsSwtZM3ydnlyzwXt/pnd9iJ8fSCjw+h0A2GOxj6Il89D9mINMYVN64CuGBuCDsC9fscsA5EnYWJMQkWyNjYokfNNfY2NxzzaUX/5OVe+v3w/YFHzTQDe24k+kWlKZTRiTkANYlFyFupKwZSsVy6OmuY67nDKpKLFcpqWAEdWoG+8z+EGAJQBnMErivujdQNCdgtVzWQkWs9HC9qbMHB7tF9Wt7/IGpv5z3852GHqk93/APQNSHmwXATA0nwYTKvRmXPul9vzVrQvbvbGksuv7G66eIm6Zafj9SqbLOhuQuC1HePZeDTxTCaOmGMBboPlDkVI2gVYzr0TdZsmcUKBN3Z91jyFdoFRdI5uIwt7vlsj3kuThK/JWBiD6R3Y540LGlhGxiDEzE4LTuaFyFYmkzyvss/WjggjgHIY87rhsu+g5b6gAG+IbQ+zHSbmoZsTICZz7VtdL5E3fjrworWcxDONcPyfSQorDuDnuW42trMj9uIbC137DtSs7M8eucU7q+65fNq/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(956004)(83380400001)(53546011)(2616005)(5660300002)(8936002)(316002)(31696002)(2906002)(16576012)(186003)(8676002)(26005)(4326008)(508600001)(31686004)(38100700002)(66946007)(6486002)(66556008)(36756003)(110136005)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SitNUFhJLzRrTFBIRktGSG54ampSakJvdm01OTBRalFac2VBNjNzVzg5VTIv?=
 =?utf-8?B?RXIyWGJtbkcwcm02YmlEYklSR0NQQnNmbmN6azVZaTFTdW9IMzEyQ20rZVhN?=
 =?utf-8?B?SnNhaHlVT3FDcERqUGdIaHpHZzlneW5nLzRXWnU1Um5tbW40Y0syYjYrYVhq?=
 =?utf-8?B?QnlWanBjb21MWk5MdDVPL0lzd0Z6QzNTQjZKQjN5S3pRbkV3TGFzNjU1Z0l0?=
 =?utf-8?B?Q2l5OVJtRjVKcG9pY1Rxc2lKZWprTGNPY040QXZxK21CUXZVb0RqTS9JMXRT?=
 =?utf-8?B?OVVIaWQyd1h2Vk45QlRmMGtYVmsxTEMxdHFibjJqTDNtQ0VzVm5XaWFWS1M5?=
 =?utf-8?B?NTRJZ09Sdlo5ekc3UWxWakFrNk95azZkUUJmWWdvaENTQkpDK3EwTWZDbHlS?=
 =?utf-8?B?U2hXQWFBV1hsdEJlVk54NmNZWTJaQVdNNkljTWJRLzVsZk9OZ2lUelNPZ0dL?=
 =?utf-8?B?YXdtVHBGeE84bGhZVng1ZzNOWE5kSUhMdEJ3cVp1RjNnZVFybnNER1d0MHR0?=
 =?utf-8?B?dTM5MkRrY2JyS1BJcHp0SERkZ3BrcWZObitaVkVpOGFDdFdocnVhYkJwZ3Fn?=
 =?utf-8?B?VjRxWHRpV2JsYmR0cGJTRG1SalpVem40UWhFR1ZQL01xNnNzZkNRTVozWlQv?=
 =?utf-8?B?cWJlMXNaNHk5Nm5wVy9EelQzTUg2VXF5M1pQTWxNSWNxdXNhb2VYREpDbWcz?=
 =?utf-8?B?ak4vdXluWTFTUzFLTWF2Vm00ZDFza09Tckd1MnMrdGxqWHdadlB4dXRvQjdP?=
 =?utf-8?B?eUlwV1B4a0dMMHl0ZzZvamhBd0lwR05xZkZoWXJJR2QyWUpDcC9RSXBjbXkv?=
 =?utf-8?B?NkxVbTBISm5LaXhpTENhM0dNQThNQk1WNTJxUXRQTVFMdWFsTVJBMFJ6RDRl?=
 =?utf-8?B?ZFVFM3d3SjlWMzN6SXppR0l3SEVGajJHZ2dtMkllUUpMRVk0M0g4UTRFVTR1?=
 =?utf-8?B?WExpcmdrMjRLYzlRYlZrYjFKcHlkRXhEaURWTzhXc1dWQXhpVjlMbHFiRk5X?=
 =?utf-8?B?bXQ5cGVTWUlnY255YklwaWZtMDdzUUpid3laVFBUSVE4NkxIV1FCRHo0MDhS?=
 =?utf-8?B?VTF4Q3lOVlJCcFdWZmF4azkvQTY4MkVBbm5pQUp3M2RYcFlKWE0wYy9WeWVC?=
 =?utf-8?B?WG5NVWhSVkhGUkMyM3BESWlNc1Zwd0ZQaTlIYVh3QXBCYllQR1R1djRtTi91?=
 =?utf-8?B?NndqWXNkTlgwS3RBZUhnN0hUZXFKekJNb0NOTytXYjVIVUpWcTd0Y3d1UVdX?=
 =?utf-8?B?MUNUQmV3TjJiY0dvZlFUZklvVU96aFE4MlZab3dTbnVyenRRS1dqTXFYYnFu?=
 =?utf-8?B?MUVrbjZXRXNnV1l3cG5wN1FnQ2FrbHVkU1R2dDBONUpJa2I2dCtRV0d6bUJE?=
 =?utf-8?B?aEdWVjJwd0xLbG1YQm05bUdQZU5nbENvbktqdEE1UXZLYURCVzc1d3hGeU5z?=
 =?utf-8?B?OS93S0hBaThTUjJ1RnBEcGJkMzhnT1V2OEF1cWlsUzV6UVgyNEgwUXpadHJF?=
 =?utf-8?B?SHdoclg4Vjl3YnpFWmQyMW1CL1E1SndIOWlWdDRYcUJCZlI1bjlHY2xTSlQy?=
 =?utf-8?B?QWNWZ0l5b2ZtWEpkc3BueUxkMWpxWTgxWG4ySXNCVHZremNkS3BpVVgwTHdu?=
 =?utf-8?B?NElueSttQXozeG1odGE0SDVNbHBGQmx1MHUraU5QZXd5VHk4d0tIOVd2SlMr?=
 =?utf-8?B?UW1kRDQ1dCt5Wmx1c3dCTGErbzJ6RHMvR3puTFQxWDdxM1BsZk5MZzNTT0JO?=
 =?utf-8?Q?+I5W0HmH++Ih1VNfIxMKtGQVkzv3YfamszWZQo3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3189a0-c2c7-4f7d-69fd-08d98dac13e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 18:14:05.8510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBVAyWDNFIBRm5/Cno5wi+1z8NVhp3Okl2h3bX8FcSw9rvQTX5ZKa1JsM/Qfi7WyjstijdmKwvUoJefJZOiSxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 1:04 PM, Shyam Sundar S K wrote:
> Receiver Reset Cycle (RRC) is only required when the
> auto-negotiation is enabled.
> 
> Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v2: no change
> 
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 4465af9b72cf..1a11407e277c 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -2642,7 +2642,9 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
>   	/* No link, attempt a receiver reset cycle */
>   	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
>   		phy_data->rrc_count = 0;
> -		xgbe_phy_rrc(pdata);
> +		/* RRC is required only if auto-negotiation is enabled */
> +		if (pdata->phy.autoneg == AUTONEG_ENABLE)
> +			xgbe_phy_rrc(pdata);
>   	}
>   
>   	return 0;
> 
