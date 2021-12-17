Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51660478DC6
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhLQO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:28:06 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:57184
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230248AbhLQO2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:28:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmuP48+XbuDCfpNPtFbsOa/+oV1f29PNwkrlDEocISf5G/JYLTMZuiM3B6WTt1AkG/A2qDozRMTj2Ape0WFkOPLuVcH40DDd4l2F18OInvDAaDQ4kuaKpC4y0LuKLdEzpyXkvPMZMZtjErbP+DinJTtS4kpyyJFUlMnbGfJLo8Ot+WTd0OQHwStRdJt2kV4HvQlLeQ2jh0DsEHdP57615ct7QK3oX/WRCD65DqhlJ+qDyGE9nGYzhWli6ISgm8bunNDtdWqJtfd4FTWEdnnelNzIRJe5wHKOHn0u8am0GoFcyKuCLyZV3tZmCQvLVzbMHysHdkMmiamFKQu+nv8tIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6DAsV5Uwn8QgWpMBtX708rXYY/ykbv03e1ZXjj9+34=;
 b=Bch2elx6ByNJtxMDd0cGdAcmVLfjOeKxUHS5VYwVr5ZBL5yJRSaSJ8awNjA88NVZNPAJt0ThGbDpQUPu6/QvRJAXW6/0ZdQxwAjKMU0IeODCvGYr4mLuCEU4nIDTOirs9uHvp/PrGWvhUeiYJPatjoOwBYPCmt1du7yyk7e55OmleOs9is9pUjzklPpyU5QyWQezG3ojvKjLciBLIq55Tct+ZJChw/L4qQ01zXlDQUu5DRjfY/ho2G9GM/ZEyDtu6xl9VHYse0BGRDxMVLzK7P+KfO8mYFL49kkWC9xoOGtYCUCaqOijuyLwTCKkw/6fFa2/rAqIDG4Z+ur7I4v9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6DAsV5Uwn8QgWpMBtX708rXYY/ykbv03e1ZXjj9+34=;
 b=epjYeQLwak237vmNgukuV4FegaWX6RNqLArzJM3MArYcjT1OdGhMOsRaJLZyUtiG1YRkpss/ZBiJMCFDyPI3f1Hhe6IVnmDm3AtfDcOw22AsFJP8i1tl5USUmfVOSf9fdl6WttWvp40G98XffRiG5tygeBoEaNKbY6IIgc2Cj2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5533.namprd12.prod.outlook.com (2603:10b6:5:1bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 17 Dec
 2021 14:28:03 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 17 Dec 2021
 14:28:03 +0000
Subject: Re: [PATCH net-next 1/3] net: amd-xgbe: Add Support for Yellow Carp
 Ethernet device
To:     Raju Rangoju <rrangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com, Raju.Rangoju@amd.com
References: <20211217111557.1099919-1-rrangoju@amd.com>
 <20211217111557.1099919-2-rrangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e913ba80-59a3-413e-e18c-f7c0d48712ba@amd.com>
Date:   Fri, 17 Dec 2021 08:28:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211217111557.1099919-2-rrangoju@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:806:f3::30) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7PR18CA0019.namprd18.prod.outlook.com (2603:10b6:806:f3::30) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 17 Dec 2021 14:28:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f575874-9569-495d-ca52-08d9c1696f2b
X-MS-TrafficTypeDiagnostic: DM6PR12MB5533:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5533CEC6DCFE4EC02796B3FEEC789@DM6PR12MB5533.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vopzkmJ0xnFTWdXAS9FKMUUioTfVOemBpBt335pwG1KG/NHgS32CxIJy9oXwN+84DrW7dX4R3g1mcf2XF04nn1HhCqCX2XLRMopA9ju5EanH5l62oiBq9m6lk1m277H4a/nn1+S8hCChT0JqvEoQKRUN/gE6i7tJtyep41NRD/OuHvKdQdpmUs1tNZBB0OXd4r9XOPr0ChljfEHpjmi1InrVUPB5jINpLPSyoydwkstffxPjvGjeJmUcUMLaSVrI8+jQpXwp+rLxY8JHw0lffEwEZQ2HGpYnrRHo75W7DECrhELqo1f8ggwMNFyOh9hLXuWApTC5+Wk8l2nXoq3JGnU33VbtUIZjH3TXYT17HB/Hl5z5TvgPaLDw6mS0iGBawORYNFazweg8jgYAfCqtFPYlHGyLzR/fcpODbNJHcT7T4t/y0iJ1/aDPr97lFNhai/6jMv4g0OXtOUZ8He/1kTTTwVeEt3yI59O9HroGUhJNUXQl7seWIvoRM0AbIPps0gtXN0MTqTnCUKcEjLv/G7O71bfriVhjXrHc6csIMsXPkWoZa7leuOSbrzhthPP8iPi8slUt3P4n6rlNZrPv7qSpmDhooZ/Ys1OsxNoIqJEAToXf5fjsGiFEkpkDbj2bjEWhh4N4waoC8v21kuuyv/RPvVXcR5QB8XNSsyQRzcy4sutTm2M4ml2glALY7zySudngncI2dw8JqbS+SOb5cWg6KoJ32u2BfmWib/lmGciMDLJwwHxK96axDhuvwZo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(8936002)(66476007)(36756003)(6486002)(5660300002)(31696002)(2906002)(508600001)(4326008)(86362001)(26005)(6506007)(6512007)(66946007)(53546011)(31686004)(316002)(186003)(8676002)(66556008)(2616005)(38100700002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OG5vR01rRG13cS8reDQxcmFnWkN5OEFvUlZwMm5MM0VPQ3RQVlVkcWFvUkR6?=
 =?utf-8?B?YVArODdKMFRXWTdxZkVabE9GTG5aWXlrY1FwRDZZSEVDVDl4OC9ZSFVsbVVI?=
 =?utf-8?B?aDE1Y3ZTZ1pLMWE5eVFsTGV3ZHRPdXhzYzBBQ0JENWtFQy82KzlHdlgwWnV2?=
 =?utf-8?B?cmZPV3pEbzVtNnozTVNIak03YkxHRGtxUXZJeXViazdlTjluTDBXdUdnRm1G?=
 =?utf-8?B?eGVabUFBMzVIWk9icUViS1d1VEpqVGRYN3gvVGRPWUM2Q0V1TE9PcHhkRDcz?=
 =?utf-8?B?OWFvdkdSbU43VXQrTG9YS0Ftd3RlRko0V0RzdnNidU90RFFodG13N2xlYUNr?=
 =?utf-8?B?dVF6Y1VxL1lmd1RoSnhHeDcybEFWQmxFRlBmWW9DYkNySEgrYkxkT2hMWnNI?=
 =?utf-8?B?b29kek1YNmI1V0d0Wm91U25QT3JkS1JKcGdSdU5mT212MVdzQWdzeVdYZ1V2?=
 =?utf-8?B?N1h2c0E0cUo4cjNWV0cyMzNJNFVYb1hHZzhjYTNpUlpCVS9aSjdiSWJkdjY4?=
 =?utf-8?B?Q0EvUTJSWi85TDJXK2VRTnIzNHJvNytaam80d3BIeC9pek82UTB5T21Eems4?=
 =?utf-8?B?cFdrUXVkU1FJVWs0aHo0clUwT2Z4dnhTMy9nWm9UcjFyekcvVkwxN0M2K3pX?=
 =?utf-8?B?T3VWZ1A1a1lucFJyV25uTEwydzcwVlhOay9BNzM4OTlFUnhleDNQa1NmNERo?=
 =?utf-8?B?Zjc2WW1DcENEeUU4TmJxOHdsMkVTMExJTUh1NW4weUJteTdta05oVG5WMnVS?=
 =?utf-8?B?WVN2Q0RRcEJNbDMrZmlHUVFXMTFRbFhpRnovWmtaNERpcmk3aE80cklDYy9l?=
 =?utf-8?B?bDJNbGsra01BMTVNSXhqOHlDMWxkSjZNZ1pZY1I3blNNS1BTYVlJV2Q0VnEw?=
 =?utf-8?B?TkdBTmZDSGprK3NJTUtBNHcybUtYSjdGZmJKT0VwRXpTbUlNWE1QMlVjdE9s?=
 =?utf-8?B?clVWRlg0RUVjdVVhbjlINHI5SE8rMXJOb0ZGaFVubXlra2NYbTdtdGlIQVR2?=
 =?utf-8?B?RENKOFZ4RGYrL08zalczSmU1akhpVysyN2pVVVhHdmZrVWpkdUU1Sk51Y0Nn?=
 =?utf-8?B?VFJ0NUlvTjR4MUx5NWtOV1hlb3lIN0wzWFZlQ0FCSWkzSmJLNStid2RCUlZP?=
 =?utf-8?B?anBiUC8wTmg3UkpVNVRudis5Q0FiSm5tUHMwbkdPckVFcTV5aFNSZm0vdU84?=
 =?utf-8?B?NE5rYjhTemRPL3JVNkR2TUxGS3RlUVJPTGtxR1IvMVFDcGw4NXFLVG9tMkVR?=
 =?utf-8?B?SzlLTlN2NnhvanlPQUVaZm5SVDIybW52MW1kSmdBZEtNckQyRk5Ca3M3b3J1?=
 =?utf-8?B?NGJXTzVKZnNHaklrVWp4VTNjc2grZ0tEb1dhb092b1Q2SytvbU9JZ3NyQUhI?=
 =?utf-8?B?L295M28xOWQxam5oUnpZNXhJVkl1MHNycXVNN0xKeG1vdG5VOER1SFNhWHND?=
 =?utf-8?B?bG9keENuQmRCQXB6dzc1OWNxdlFMVUc2SUlIWGlyMjR1SUVEeXRjV0o3TVNl?=
 =?utf-8?B?SGVyK0JsbXRHYU5yaFROcStSODQ4SStaTkR5dFd0dm9xc1RuZVlrSVVEUWIw?=
 =?utf-8?B?Vy9YZFI5RjNIeEtJMEVuN2l2cnQ2b0J0U2lrV0JOMkxtb0tzaHlXNVh0L3kx?=
 =?utf-8?B?TEMwSHJiT3RsVFZVc25DVFBlUWdmWHpZbG82M0NpZEdlQlNhNzVLRVdBcmE5?=
 =?utf-8?B?TDdKNWZFc0czT2ZEdHBTUy92cURqYTRyZmsxb1hSbDZTalVmaGJHd09DQjQy?=
 =?utf-8?B?S0cxdHkrY0pYWVJiYTd3UEVtRVVTZ3Y5QVNQYWZINEdudlk1akZaVE1admo5?=
 =?utf-8?B?UlVJWE1LU1gvcVRZUEZnVHA4enNzSFhoc2VLL0M1T01wTXJFdFdBVmRyaWkw?=
 =?utf-8?B?RWYwTkN4T2JWTHdieENFaDFoVmRsUXg0NHk2akVqNlJycitnR3dWd0dKUjJJ?=
 =?utf-8?B?RndvNlJ4U2lQZ0dJd0tFeXBVSHhnMmNOYTJxTVhiTDlDZUZqV1FMVzN3L29n?=
 =?utf-8?B?d05GK2o5WlJVTTMrQmdwakxPcWQ0MWZZa21ibHZtZkRSdm83VjVTbUJtSThn?=
 =?utf-8?B?NnU4dW9kRldnQkZ4eWZYRHdoS28rYU9ja0orT1RCM2RjR041SFlqaWt4eDRF?=
 =?utf-8?B?N3YxM2puWVV4eVJEUUJ3Z1Z4bW9rZTBtQ20rYUU5SzQ3bWRyaVoyMHJjYnVK?=
 =?utf-8?Q?kP6xN2lwJdHnJpv2NRXUPhk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f575874-9569-495d-ca52-08d9c1696f2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:28:03.4525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMQ3BbXaIhaIh80ySoe7XlVYc3ZUVmdW8wPXelCnR1JtpP2liH7X5lptIAOWbBKt70bu6JoRSDQlL04nVkT8oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5533
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 5:15 AM, Raju Rangoju wrote:
> From: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> Yellow Carp Ethernet devices use the existing PCI ID but
> the window settings for the indirect PCS access have been
> altered. Add the check for Yellow Carp Ethernet devices to
> use the new register values.
> 
> Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-common.h |  2 ++
>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 12 ++++++++----
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> index 533b8519ec35..0075939121d1 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
> @@ -898,6 +898,8 @@
>   #define PCS_V2_WINDOW_SELECT		0x9064
>   #define PCS_V2_RV_WINDOW_DEF		0x1060
>   #define PCS_V2_RV_WINDOW_SELECT		0x1064
> +#define PCS_V2_YC_WINDOW_DEF		0x18060
> +#define PCS_V2_YC_WINDOW_SELECT		0x18064
>   
>   /* PCS register entry bit positions and sizes */
>   #define PCS_V2_WINDOW_DEF_OFFSET_INDEX	6
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> index 90cb55eb5466..39e606c4d653 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> @@ -274,10 +274,14 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	/* Set the PCS indirect addressing definition registers */
>   	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> -	if (rdev &&
> -	    (rdev->vendor == PCI_VENDOR_ID_AMD) && (rdev->device == 0x15d0)) {
> -		pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
> -		pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
> +	if (rdev && rdev->vendor == PCI_VENDOR_ID_AMD) {
> +		if (rdev->device == 0x15d0) {
> +			pdata->xpcs_window_def_reg = PCS_V2_RV_WINDOW_DEF;
> +			pdata->xpcs_window_sel_reg = PCS_V2_RV_WINDOW_SELECT;
> +		} else if (rdev->device == 0x14b5) {
> +			pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
> +			pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
> +		}

Hmmm... now that I look at this, pdata->xpcs_window... won't be set for 
non RV or YC platforms, right?  All rdev devices should have an AMD vendor 
ID and therefore always take the if path. But only RV and YC will set the 
values. So this needs to be reworked.

Thanks,
Tom

>   	} else {
>   		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
>   		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
> 
