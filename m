Return-Path: <netdev+bounces-5410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF43711333
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17BDA2815A8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A2C200C5;
	Thu, 25 May 2023 18:08:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4D61F95C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:08:22 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::628])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB29119
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:07:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isj6DyJNVE5+fZP9VWI4ZRD6Py6OlD2pugFtUe0jkHU59hjKPowxQ9bC5TcEbmxGJRZuILP9rvUegWBIjN8LqhRE7rjMPkMyertBPLaIjr14i5FGmonXZYj4sktyDZNOsU4AGLT/C8T7nb9RCbPceWEXRM8naRSoPNIJR0Qbtyenmc4ekMc5JmGRxs5Z7rJgMu/NlrM/eH1bC6USgQVcIEoCMNNmc8V/ZIV6zaHZoPw9oQfusAna0I23YhQys5cGtDz431hgsKhUia3B1jW8EZa0TLjhX7grNvT5fMyKk2JpZWZgLINShDwU8a1UZgkhmr5+URtApzxYieffgXV4/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQOe+R85romfIIq4Z9HRkFsUZ4w/+B6ltHhcI6nPAGU=;
 b=TugYCFRLbQhXdx7fMjNBCigWopAaVKOrNJylpqBTmhtIzfWR2qQmYeEjlhj3oRTo0irXk0Xed2am4F16txv8FTfzEalObWtYWm2gnS3BQTheQzZIfEXOwbU0Fqukz0w1ArBBTmCc29M4kccxt2ZCMJ7MiK7FBaGlEvRquNhovDq13whDIhwbx60tqcdyqpq3yHQvbmdm/WIvvMmo7bpOKuNX/JKQuSSe0vgWNHAuA9iZB+BF8YJVaXA3KoWxjo7IRErpoM4a9EaS40GQHnIUVW+ItI97WrBUw3AA/kGNhYdEIK2i/b0RHxeqYZKDBT7Y9tFEd1734RhhIZsGDsLKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQOe+R85romfIIq4Z9HRkFsUZ4w/+B6ltHhcI6nPAGU=;
 b=4V4mxrRZsbTf8H7Tf8mSZdmBb5/07SaOJIbWVVttPHqiPiRs5o+ruBsGJEpDw2kDWHpxzh5Gdc6IdPn4f8kuQq+uNkklfoJT3a2cbV9D3wLKJbtrwiKxzzT77KGbwCJ76bebipb6jwVdn9KZDsc0/DZYFQ7KmuHQrVnC8ah+WP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by MN2PR12MB4286.namprd12.prod.outlook.com (2603:10b6:208:199::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 18:07:42 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::74ba:d6fc:d7b5:60aa]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::74ba:d6fc:d7b5:60aa%4]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 18:07:42 +0000
Message-ID: <cc2aab32-35be-f11a-6bf1-aeb522019456@amd.com>
Date: Thu, 25 May 2023 23:37:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net] amd-xgbe: fix the false linkup in xgbe_phy_status
To: Tom Lendacky <thomas.lendacky@amd.com>, netdev@vger.kernel.org
Cc: Sudheesh Mavila <sudheesh.mavila@amd.com>,
 Simon Horman <simon.horman@corigine.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
References: <20230525101728.863971-1-Raju.Rangoju@amd.com>
 <62beadfd-9de1-9fa8-f62f-b8eb8cf355b8@amd.com>
Content-Language: en-US
From: Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <62beadfd-9de1-9fa8-f62f-b8eb8cf355b8@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0181.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::19) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|MN2PR12MB4286:EE_
X-MS-Office365-Filtering-Correlation-Id: c2e18707-12d6-46d4-2b31-08db5d4aeefa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZNeTdJHwZ6aCNt3xcfYEJ5r194t8AT5qvs5XCu4tb70zZOzECfl/TwE0SzF/G1qCghgyOP62a6CBSx7Kw10HX/WB5nWhzmWdPxvM2Mhw5qRC3yaquli5Gd4FKzJ7LItvwGOFcJesc5m1vVeMTILS9eDvXQHtcl+uMjeIVcJV7A5r3KNdKpAEs/iFV0gIr3jGqZAd/4HZyDvC9tMmdJCeccsGvOy3s49JK3iaEONCUDNiASiML80birBo+E6+9W9UEDwFLbHq3r64EIICpQgwpt2ohf27cClgVegDTS0GHrUnAFXh5BuMyuY9K+QLWVkRIcnWJcnj0CH4PAAoIoolvMZXBkmjKwJjR8+ooJjbMPOcia5FZF+2FJ+P4BbNvf8768Y50gC9UIoV+C7Upa0GCOZpBhBGPHXt3zq/YsM7QrmqGTuqyWnGkI+vEPwnRiWDejL0smIKsX8hdMpCDaeiyoYxxoeHMwoYGKlnZRrC6hrLymuH6rWRBq8/2dH7t+BCmI0luB8WuJtBiQfWWIspNfY1W8GmZS0p/Wl01ZlJr6n6Zw7ZJu7ftvw9+FLiPirGia1glWsj9migbS6Apoq033CgE2P50jQUqLd6NiBqHbRtm4LX98/oVT3h49Md6zyuD0fTmxuRm5iycHQrMKwD4w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199021)(4326008)(8676002)(8936002)(36756003)(5660300002)(66946007)(66556008)(66476007)(316002)(31686004)(478600001)(54906003)(41300700001)(6486002)(6666004)(38100700002)(2906002)(53546011)(4744005)(186003)(6506007)(6512007)(2616005)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aE1iQkxFZWFHWjRYNGhoem0xejdnekh6WnFVUjFjTkVEejBseHRXeVhvRmJ0?=
 =?utf-8?B?LzJOaWtPMDNFZWVNVDhabjBtNmVSeEo0QWV3eWFrRlh1c1ZUTEd4NHdreU5L?=
 =?utf-8?B?N2h2QjVxM0R6cVBWRXBTMjV2ZjNDOGhYZWVOS3BRQnJ5WFZ1TGRrM3I3N0V0?=
 =?utf-8?B?aml1L3dSQU1XNlUwRmlYbGd2S2ZrWG92WUsrNXJObi9nSnc1dFgvSEtESFBv?=
 =?utf-8?B?U1lNZGg2SHlqMW1oQ3F0UCs5cUZXbzUyK29ZQUZ0dUdkam1Zd1Jwc1FlakhZ?=
 =?utf-8?B?Tk55NzVYVFJSd2lQd3BxWmlkcVRWakRCLy9VSms2WlplcFlNL2RFTGZWVnNY?=
 =?utf-8?B?bUNGenZoMzF3cHNQRzI2ak1kWno2clJMU0o1b1B5RzhQektUQzRtc213V2VB?=
 =?utf-8?B?T0VYRTNKTzJRckpwbERabm1yMk44UjZNUGpaNnIzVHlVbzgwMEJqbmpJTjB3?=
 =?utf-8?B?bVZwTTZtNDM5UDRrcW1tY015QTc5eUI0bG80dmRWZFEzRW8ycDFmSzZvZjl4?=
 =?utf-8?B?eHFyeUtmM2x5SFo4ZHBtaFl4R1NIOVRiT2RsTmRZUlpUK3lib2F5ajhkcHlB?=
 =?utf-8?B?OHJiVUtjODRReUNpMVBVVFdjNHBpazdWMzFCRUp3NVArajhZOXJpMjZjVU13?=
 =?utf-8?B?d1pFMmgxVUdkcS9RU0MvMnBXaDd4RWc3OWZlS21XaHpPVEltTWZBcXcyam9x?=
 =?utf-8?B?aXdnaUFkU3N5SzlPY0QyMk5ubjdxRWJ1NlduazFnZFlTUUlwOHVQMDJkeHRi?=
 =?utf-8?B?VnZzV3hLWVhMNmhhckRYU0kycjBZalJSZ2Q2ZDhjalMrRVp1alZVVXFvU3k2?=
 =?utf-8?B?L0NmbkJlK0NTV3hTbXNGOHpDeTdYWWdEMWZ1dnVsNnphdkRPSDU1L3JmV2pu?=
 =?utf-8?B?bXZmVGR4MXVib1IxUDl3dlNvSWJPWjlvaUhMM0Y0YU9MWHJmZzk3b3Fwd3Z0?=
 =?utf-8?B?R2Vqbis1NVpnYjZ6ejUwYlNRYWZnaGQxdG1mQmsrWE5QbmNsNUQ0dXBaYXBq?=
 =?utf-8?B?dVhoMjRFQzNYaW94MlhPaVlGdGZIanJQaG5lR3RySnU1alI0RnlhcWN3Q29s?=
 =?utf-8?B?d2Z6SUhQQUhBU3FPYTNVMUYxWnRSU256eENBYkhPUjJOelpHZ2Y5M3p5YzFZ?=
 =?utf-8?B?NTkwdDhrWGRBUjRPdGV6QWtjUGtaaVN6cXE0V0JLaUFPc1FiSHdHbitqYjVY?=
 =?utf-8?B?S3pPclpXZXpTRHJaZXJlS1NFUUxwUmxXK3R2eUNFRVdNc0lwaDBzWnNSNE1k?=
 =?utf-8?B?UjQxYi9teXpOUnA1OTZmWW9sQnMwdUlzYnpFSzlmYmhyeHpWMUJldW40UWhF?=
 =?utf-8?B?aERtU24wU0RveENuYXNFSHVMY05SazBWZE1qV0dMbEovaXJrVHJEbWF4OE9q?=
 =?utf-8?B?TXFBZG9OY240MVdacU9jRTJkeW9VMmtjb1lyWHQ5bTJ4ZHg4SzhWWHBNN1cr?=
 =?utf-8?B?aE9QQlpIVkJZVmk1WlJCUmdzd2JCVmRhbk15cHdINEdXb25iWk9DTFZlRnZu?=
 =?utf-8?B?U1pmT01meUM2VzBmNVZrNEtRZ05KZkZBN2Y3eUdOcDAzN2R6ODQ2QzY0NjVS?=
 =?utf-8?B?MS9kL0Nwalk1QnBoWHVQMEpodjc4c1pRbGMvTU50SDQ1S3IyalU4L0pMblYv?=
 =?utf-8?B?bXpYZXZOZXpNWHN0dE9wUDd1b1MyYXoxMGNwNkl2S3o1akh4VDZaS2RhQ0pn?=
 =?utf-8?B?dFNZbXNQU3BsTDE3Yk4vZTFIQ1AxQzR2SVFxODkrWjhXbTVSRDltak5iRmpV?=
 =?utf-8?B?Q2hZWkdIMTR5N3AwVzI4V2tuS0J4Zmc5bWpRTkhEMkoyY0RHTmxOcHBIR21a?=
 =?utf-8?B?MzVDOG5UNFg0cGRRV3hGbEErV3M0dXU5QnZrSXR3K21hSVRKM1RYaDhlR3Vl?=
 =?utf-8?B?Y0R3YlUybnFwa0tobU9tQzVBWU5ESUFLQm8ybDdDZmpZenNBR2l2dHVmb2FJ?=
 =?utf-8?B?dFNKNC9tcnlqVzFtdUx3a0ZsMU5VcHpmWXpJUDNDeUZoSmxROEFjN1lqd3NO?=
 =?utf-8?B?SlV4Yytub0xTbmgwRjUrbTNQcEFBeExEVE5iWHoxSjUrYTJJNHhYOXZYM01t?=
 =?utf-8?B?bWpIMWJLK0syQ3lPMHFOZG1VczI3ZjM2SytWL3ZjblZzQlJZYVZMNUc4Q1I4?=
 =?utf-8?B?aG9iNjU1dGhRTFJkQVcxeTlRRVgwcndYYW1VT3VyYzRVSWFzdzVpdUxidGdJ?=
 =?utf-8?Q?XcjVpaI1mc4vhdBox+KrkiGNnWfmYgYd0XhthXLqHRWq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e18707-12d6-46d4-2b31-08db5d4aeefa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 18:07:42.5688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMxLa03e1aCuGEHq8LJlcbefT9ctTVkzShC8QBVVsyIofRTOktH3HVP5PPhHC+Wyn4es8nd7lH8NzQ7sVi3Udw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4286
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/25/2023 8:11 PM, Tom Lendacky wrote:

>> @@ -1367,8 +1367,13 @@ static void xgbe_phy_status_result(struct 
>> xgbe_prv_data *pdata)
>>       pdata->phy.duplex = DUPLEX_FULL;
>> -    if (xgbe_set_mode(pdata, mode) && pdata->an_again)
>> -        xgbe_phy_reconfig_aneg(pdata);
>> +    if (xgbe_set_mode(pdata, mode)) {
>> +        if (pdata->an_again)
>> +            xgbe_phy_reconfig_aneg(pdata);
>> +        return true;
>> +    }
>> +
>> +    return false;
> 
> Just a nit (and only my opinion) for better code readability, but you 
> can save some indentation and make this a bit cleaner by doing:

Thanks Tom for the suggestion. I'll fix it in v3.

> 
>      if (!xgbe_set_mode(pdata, mode))
>          return false;
> 
>      if (pdata->an_again)
>          xgbe_phy_reconfig_aneg(pdata);
> 
>      return true;
> 
> Thanks,
> Tom
> 
>>   }
>>   static void xgbe_phy_status(struct xgbe_prv_data *pdata)

