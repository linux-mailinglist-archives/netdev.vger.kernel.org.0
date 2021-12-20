Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7350447AAB0
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhLTNxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:53:54 -0500
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:61888
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229979AbhLTNxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 08:53:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvJW4wXXCn1oGYFwAmFhl9l7y9Wr48OILNoOrucyfpd/BzMQA6vR6f7BgudgJsZaDHN2k4UYiZs22P4rOpv5MmnBIsENe+QQpQ7p7+WezZF/zvCEqaHka5cTx4Wbg6Qvj73OSBMPWJfBOyojW4zjHefCmG3K0VftBObECBVB6vkxBAzqaryt/ZKl7l0/iXC09atQbd/HQ++GCjPlleRMgWypfpSEEAJXq362JSIQd2utN8DHZOLxv/YXtJ/4nUuNR1eRA62ltaZE0bNJpxn8gPTazGMhynu11YLTTRYWkOe/W8kUe56HPh8gWP0eVaENKwykXwqSFXxNPWh638ebZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygzFGoy5+GIMaAiMYAdVDs2m1qGXKcPmjEKvOu2DLeE=;
 b=UiXIMIkm3tNBKoUDekmayw2YA++Iu56H4k4+OqIgv1lB6IL/eeN2k2bwSdkclTu0BOL6fmZf9Lkdn/P63xoVYIQO0igIy1bx+60i8VITz2DkoleYpp5QjCxotqSC4Ko0r4LwbzLjW0Sm/fZNZCRYnX6SFJR0XZpNH7kvqh7NSoLLd+lRpKA9S2y3ZNFkHHv1ufrDdUDXKa92N8Yr41Tz5H5cmZZ6tKUy8C7wPP92gjFnkIaVs9CZjl7Qkb/z5uKF1P2H7yDBYsxSUw9yWm8HPXFvaZJ/dwpCCS/dKh/bENnOqrKODbsulC2xy5mTi1MUpzzOzargbsn+AsSB0NeZng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygzFGoy5+GIMaAiMYAdVDs2m1qGXKcPmjEKvOu2DLeE=;
 b=ktOvngCd/BiKiRXTQXB5GsTacOmlBp+o4XjZI7kw/0lu6E9RRfT8VoSN6+dwxcMkMq2WMH/St6nlLoYzYaARmtrV16aA5QRP2LMuZuXsRNY/fPHObbeCfAbU66k+O687rsHtW6jsC5aeBkefcIyJzdTvHaXRP49iXGgjx3aduV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by DM6PR12MB3420.namprd12.prod.outlook.com (2603:10b6:5:3a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 13:53:51 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::101c:b284:d085:c7ee]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::101c:b284:d085:c7ee%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 13:53:51 +0000
Message-ID: <d22ce38e-8876-34a2-d51c-43c3f94eede9@amd.com>
Date:   Mon, 20 Dec 2021 19:23:40 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net-next 3/3] net: amd-xgbe: Disable the CDR workaround
 path for Yellow Carp Devices
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Raju Rangoju <rrangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com
References: <20211217111557.1099919-1-rrangoju@amd.com>
 <20211217111557.1099919-4-rrangoju@amd.com>
 <85ffbb22-c808-b2f6-980e-4ee6a294ed98@amd.com>
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <85ffbb22-c808-b2f6-980e-4ee6a294ed98@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0012.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::17) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2abe10cc-58e9-4186-b516-08d9c3c02798
X-MS-TrafficTypeDiagnostic: DM6PR12MB3420:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB34206B34140EE25248D71903957B9@DM6PR12MB3420.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ceqKE16AvweqPjHRQh1CnP8TQd3uasAkOLchwTYpK9dHnYZAP4V/D3xWXr9gKSauo271kUXglIBdAUiGnhfJ4fIGZUOPz6auaM7q3cQ7dg4NKJ0Bc/NgXP05d/4Oa4TiiHuTyHrc1H0Sh8DIno3B/i6vG3KFQoNZDNlSXm12n9NNyX4Nx1GDCy1E2OthhWe0TId/5rWW3NqXsWeexcFq1OHZvDizuktXvvBb3Ka/+GWbGK+ZkqPmOjRbijAENk51qNSmJspaVjSSAYnTvllj7q7YtiT5Nt7Dc25gYE7VZN4TQfQvfjNgCUezHfSQwKmoKcKvIYz2nSh4k+/goYZP8cuQk0K7mY7Q3OjyEcFMWaJZFBfS6PlbNPb0tRIHaneWCPX5Oz+2UOCXrU02Ep9ezL+PuRI5lU7iSZFEWxReMyi89pLF0ljWdulMhM53QmtWcU2Bw3F8hp2fnbpPDnoSnC7T5ivXQVplMI2+MHGe5kcV4n+IQlnHQyPAbhNQgOG4yCgkNv5Gt10789DJsd9xFPirq+FVvTrFj0o/RF9TskXcNnjae1KpsKP6Vwxszbj3xGRaVcU8EFNITTWA3OXeu7XByR2UVBSRkfOsmpxYziX/XyhcYYWdqK4XeNtNFrvQYC+ZaRd0Y5NTl52doRGStOxbnm/Ykt+KebDCDDRwLZXwjgbH27TqP+4wpZfealCKRkPErR5Ye/lh964zBW9IYsidGkqpiBmxVYgl7Un69Lo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(8936002)(83380400001)(36756003)(31686004)(6666004)(8676002)(4326008)(66476007)(66556008)(86362001)(5660300002)(316002)(31696002)(26005)(66946007)(110136005)(38100700002)(6486002)(53546011)(508600001)(186003)(2616005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UksxY0lNc2xNNk1HMkRraWNuUTFtZ0d1SXRFMHRuWGtuZDd1MThFSVdCeVh3?=
 =?utf-8?B?WVBOTUUwOTJoSzFsanpXMmNsV216Nmt6V2pLUWQ3cVZLRVNuQVBPY3lZOW1X?=
 =?utf-8?B?OE81RXBrVUo5am5XVjYwSEo4RWlHOFlTOHRqMk0yYnFrdkJQUEttQk11Y1pH?=
 =?utf-8?B?djFObGphRG55cnFORklHbHdNRmgwV3IvdVpnS3phRGdNanNUdjl6eG9JWnBQ?=
 =?utf-8?B?YlR2Y3BBZUZTSWdRNDNUSjdjMDIzd3FRRjJoZTJoMStKckEweGlPeW9YQm01?=
 =?utf-8?B?U25yOW5MN2cxOVBNYVpVMnNVY1pWVmNZazlOcnVWajZjUVFUcVo0R2FJakdH?=
 =?utf-8?B?c3BYN1lpRlR6OUpZRDM4SExsM0luNDVWQnlheUlieFFoQ2RrVkZKOEEvNDlZ?=
 =?utf-8?B?azBSSW5HYUtpVjI4QVFuRkZSQ1ZBb0FDejZXTWtMNDNFUmRsUnpaUFFaUHJj?=
 =?utf-8?B?ZE5KVC93MXRrY09WaG9oMlZYZUJqbGlRNlZxNTNqTU84R0hzTWg5Z3NoUkcw?=
 =?utf-8?B?TEdoRUZkbnNyazh6TGRSRWNvUXZNM1BoNnlJbllGYXRoMU44b1QydlVxTjg2?=
 =?utf-8?B?SndHT21JRnhYWXJzMHNKUHJFMHZid3dHampXTnBqYjBDUmdyMXQ5cEMvTnhv?=
 =?utf-8?B?ci9GN1ptTzdBWW0vTXhlNTNaWGd3UEllNUxUMDRLOVB1R1Bjb0g0Y1c3MTFS?=
 =?utf-8?B?SVUyYTZObmkveHV0MElpZFIzekZGcW9PMnk5eDZNRkRuOGZESy9lYWtsUmxa?=
 =?utf-8?B?UFY3MDRZZk1hQzZjbW9yWWpKMm9uSUE5OFhSTVllWmIzV0U0cks2ZXc5bnhM?=
 =?utf-8?B?bzRzR2h1OEJBZGl3RHVkZFVNUTZ4YW4vcUVsZUVJQ2NVQldqbFJQeldiQm9W?=
 =?utf-8?B?V2EyZmdmVk5FSE0vLzFrOTA1cnJKUXRFeU1CWVNqVEVNS2VGaUxyTHpWUHQv?=
 =?utf-8?B?eG5qeDRTSEhJaSsyWmNhT0Z2OGhNT0xUU2MwWU4vcjNJS0gxRFRTWlVMU3pz?=
 =?utf-8?B?c3U5SWpqa1hVR05pcTVFOFFlZitQN2RaTnFScytoTmFIc3c0OG41NDBhcVJK?=
 =?utf-8?B?L1dLcVRERHRDOGp1QkIwc0M0MTB0THlzRVpMM1BNWGtZenhKU1dVUDhWZ0hL?=
 =?utf-8?B?VExjbmsvblJ5MHNpVDhCejdBaVoxcEI1L2tTY1VhZ0t5a05QUUZXM28yUlVV?=
 =?utf-8?B?bndIdDk4VTlvOHphY1ZvQ1BBY0ZBRjRtOHlqVVIxNkdsVWVrQy9vMG1pV2hT?=
 =?utf-8?B?NlVqeS9rUFdNZU1WSTl1QllzQmZDRFU3d25tZmZGNUZIK1I3WVpRZFVoSjFq?=
 =?utf-8?B?S1pRYmQrSzN3V21ORjVYY0U4T0RBYWF6YWlieEJYOVc3cWcvdExvQ1U3eElm?=
 =?utf-8?B?Nnp0bkVOMWVWcUZnZTlDck9hSEUvZ1VRM2JkNkN6eDltZitKM1BMSEZnTHps?=
 =?utf-8?B?MFZUcmkzMlNQM1hZM3VjWkhmR21qUkZBemYxTW8wRGRPZFRwK2NnSUd6enBt?=
 =?utf-8?B?R3RwMUxJeXhrSnNITStldm9tY2RHdkROM3M1QzVrM1l2ai9zeVd3YlJYZENp?=
 =?utf-8?B?L0ZndkJJajZzR0s4R2lrYmtvQzR3VzZHRlhRSGVWMlVoZUVYS2s3QzZ6YTVL?=
 =?utf-8?B?aGEyTTdJdWZPaXJGY1lMN3JocTMram0weC9obVpkYzZjdzI2MlVjUzd0OU5Y?=
 =?utf-8?B?aDVuQjA0U1pkdmNvSGpyMGo5OUNsNnZaN1M0ZDNWNHNpYkhUclNRUUYxYmJD?=
 =?utf-8?B?cXFjaTc1TjJyZVlxTDNPVTZrZElQVkMzMGk4QkhkbmJiQnR1MEFEVDFtSC9y?=
 =?utf-8?B?ZXN4dnBmL3plWGJpQ3piRnlzQkxLWHgxZkNkVVpVNmI0QUJYWG0zbHBrc09h?=
 =?utf-8?B?QlBmRW1SbG9pUWMxSnNER2xsM3QyZWVKZXpJQVV2YkRWSWJzaTdLZDJUZWtG?=
 =?utf-8?B?ZEZ6UmNOQS9PQ3ZFQ0syMmpjQ3F3Mml5OXFXczJoZTFpYkxmNnpyQ1BrVkdD?=
 =?utf-8?B?dytYWStKazdvaVR0amhzZGV3aUZsVFIxMndZODdMZU00K3VhQitTNlNlQWM5?=
 =?utf-8?B?K1J2QVorRDV6eE5DaGFKSG9jak11S3RyQzlGMTFiVk1VbUJsZWE2dmkydVRq?=
 =?utf-8?B?eXJxUTVWMEh3Y3ZudEE0ZVdJZkJMSTU3VklROUxDWWdxR1A4YUhMTmpKUy93?=
 =?utf-8?Q?EjA2VKgor6aWO6L/G3dwxZc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abe10cc-58e9-4186-b516-08d9c3c02798
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:53:51.7604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhfj/9RWYxHW2RdjP/t/KtcoVgJP+1Kb9gUDeReCOJmAb6Jdo5g9y1d0vLxou+EqQvGogtUDx8NTgkWKkFi5BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/12/2021 20:00, Tom Lendacky wrote:
> On 12/17/21 5:15 AM, Raju Rangoju wrote:
>> From: Raju Rangoju <Raju.Rangoju@amd.com>
>>
>> Yellow Carp Ethernet devices do not require
>> Autonegotiation CDR workaround, hence disable the same.
>>
>> Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>> ---
>>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c 
>> b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
>> index 39e606c4d653..50ffaf30f3c7 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
>> @@ -281,6 +281,8 @@ static int xgbe_pci_probe(struct pci_dev *pdev, 
>> const struct pci_device_id *id)
>>           } else if (rdev->device == 0x14b5) {
>>               pdata->xpcs_window_def_reg = PCS_V2_YC_WINDOW_DEF;
>>               pdata->xpcs_window_sel_reg = PCS_V2_YC_WINDOW_SELECT;
> 
> Just add a blank line in between here so that the comment stands out a 
> bit more.
> 

Hi Tom, Sure, I'll fix it in next version.

Thanks,
Raju

> Thanks,
> Tom
> 
>> +            /* Yellow Carp devices do not need cdr workaround */
>> +            pdata->vdata->an_cdr_workaround = 0;
>>           }
>>       } else {
>>           pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
>> @@ -464,7 +466,7 @@ static int __maybe_unused xgbe_pci_resume(struct 
>> device *dev)
>>       return ret;
>>   }
>> -static const struct xgbe_version_data xgbe_v2a = {
>> +static struct xgbe_version_data xgbe_v2a = {
>>       .init_function_ptrs_phy_impl    = xgbe_init_function_ptrs_phy_v2,
>>       .xpcs_access            = XGBE_XPCS_ACCESS_V2,
>>       .mmc_64bit            = 1,
>> @@ -479,7 +481,7 @@ static const struct xgbe_version_data xgbe_v2a = {
>>       .an_cdr_workaround        = 1,
>>   };
>> -static const struct xgbe_version_data xgbe_v2b = {
>> +static struct xgbe_version_data xgbe_v2b = {
>>       .init_function_ptrs_phy_impl    = xgbe_init_function_ptrs_phy_v2,
>>       .xpcs_access            = XGBE_XPCS_ACCESS_V2,
>>       .mmc_64bit            = 1,
>>
