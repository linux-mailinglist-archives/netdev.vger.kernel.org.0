Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4516C6C471E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCVKB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCVKBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:01:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281B40C4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xos9D6+ZOpF2Xk+p2DtHX/sOh4kacLZJRDeqtU6AOJ7f+sj2bgGQ1igNIiSxdCmfic1sPVT6vWK8FT42qhk2fICYu6M7ktbT1T/7d4/YFToP66otzGOXpeXHEhhHuBToM6vpgUDxkyWrfGSRKwUNBGky1GiEGYIbSqSJOGs3HXCH02QyYrnZpIQDfZ5fUxZ8a4Vi6BQCAXomv2qzuyeb/3e9X/DGGnzDBaBki6xSpuCp+NBQTBWvlOJmdNO2IZx3AedGQ29xjZPhExsOYT1O6OZU7KD2+N+x1GyoHO6/B9Zn2ibciQqhYIeuYMCJ439yAEaqXSIW6V6k3SBmExJ+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v27bZP8lYc1gwpifrdIXjloD3dtQcqj2mcvbYRXuw/c=;
 b=NPAuqMSZm/QD18XmB+Q6zMXb5n+ABwBi0Rj86Eqkrb3XI2rXOSlntbt7FL6evC9ZLG6H12y8jrnnGJdybToBKKT9JRyZzKkcQidC5L5kwhDWzU3DbU2y7wncy02lzUYP6fpGgtTVg6+5O0TFkBjRTgCy7lo94nPqTTuJpnvL1d60a9P9LY1+ubjem5hZJ/2OV+jqrSrGyCZe8NXsro/9vfwi8sMVfKT2VzfKNIKu05I5dko3fEQNwdAKaWqxz9X8z97osyR9G2zPygdbnOq82I01x6Ee3IS9dKSkuCW+RCJ1JnvzE4VzIAbv5B/mxsSkI2vwgnO8HOtga2orKXUHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v27bZP8lYc1gwpifrdIXjloD3dtQcqj2mcvbYRXuw/c=;
 b=hQ3Ex9vkFg+Yx9EW5bF/lGZH3CCpsV+vbPhGECyevUQue4WbkymcEtalbCS2KDG53+0nzrIq6haTKkMRQ4Rxb17AG8RYr1xBj4ePBsqriLe9bkr6UWRKXSg29YvGBQ/gL0ipiMlrCcBhgxTfp4RsyjoEyOHWPG73Druurns5Cpz2O3UoZMc3h9Zf3uRxJfW2hs7zzN04eNPhDRkScX92OALfXNqP3vxnRgHxJ/rGOlhfIr+9MYJFlM3tAxuOnbp3dUGN8cGdSPdJtT47BYsmf3UA9I83ywayUY3ZxsIzSbgdvVNqKgzp1uQgzuKL6909VD0gAJm9wH9aI+XKp5wghg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 10:01:22 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 10:01:22 +0000
Message-ID: <6970ef1c-dc27-b135-afbb-8b87a3348169@nvidia.com>
Date:   Wed, 22 Mar 2023 12:01:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [net-next 02/14] lib: cpu_rmap: Use allocator for rmap entries
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230320175144.153187-1-saeed@kernel.org>
 <20230320175144.153187-3-saeed@kernel.org>
 <20230321204028.20e5a27e@kernel.org>
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <20230321204028.20e5a27e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0177.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::16) To DM8PR12MB5400.namprd12.prod.outlook.com
 (2603:10b6:8:3b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:EE_|DS0PR12MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: e8aa062f-38ff-43d9-e145-08db2abc63bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZ/cyYoAPQ663Anuv5S2mUPMVTZ1zbzKBZ59Dh9P11pDTZrElqHtWiuMT/K6Kt1oJ/znMKRRukl3LgtPDgTkyQUFkFYatP8NXmVMMamgffJmDAiBTix75bSMysQcvCs3+LStEa28f/OcTdzMzlHQBogQLKM1qKDpuoS9qEA30J+ppy29aJWk/gLXxai5oanpV63OG79sGL3Rrcwt+TeJ6R54CbiuFe6nUro7BGV8KqM5E5YXvJtKF5Yxo413tVo4cEBkMGtCTe/wzZjryD3Yy30nupEBSt67gp+dFagSMQRcEbGjjqPk4Y62wkC16RZW0/WI+EeX/fo5gj842FDvq7hHU2BmXmlsaYIp5yER9G7WkP09pHC0oxtp62sCoAIp3uecAQnjvBpZ9Bzj1ytrjuqk27TocdtTgF9tSwvwTm+Xga/D8Qpv9a3DosLolV63BXGzsqSDPdzXr4/PCGKQKsd/oUn6Py66hDp5nI0ws3PHT5/IKEGW+etfeHvfrygb/qlMiQT3x2zLIGL+pVaN59pAnQyM4/v89XOVaJeZJMqacEHo3etpTtTdrV3Ld5MzxoWfzFsn1dYQkMIYnwUELEw6FEsRGjZqJrv1AVzJ1IPjWIbhfrXCZw9mAtaQU1WCERRZCfUhGarA76jb4NwHsm3gsGS/LMH7etJlvktmhSkvz3yzoz9gBdeIg6zHE4PFkLu1i6i6tKqgQGLpS3FUpnOjzY2ScVzv7dX+7rkOt4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199018)(316002)(54906003)(6666004)(107886003)(66946007)(38100700002)(4326008)(8676002)(478600001)(110136005)(31686004)(66556008)(66476007)(6486002)(2906002)(2616005)(41300700001)(186003)(26005)(5660300002)(8936002)(6512007)(86362001)(31696002)(6506007)(36756003)(53546011)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1pKQ1NQV2trQ2kvRFFBL0JudlNRMjJvZ3l4MHJOS3FFZDI4a1FuT1NnYXFT?=
 =?utf-8?B?NlJ3dFp4Y0pUZ1VBaVN2Wm4rM0pTd2ZZVzFIWGNsNG9xTWJNT1FmY2Vtdkcw?=
 =?utf-8?B?WUxpT21nTHJLUkpHZnhPRmdyb0cweEhOUFpYZllHT3FUUFU0d0VEdEFTV1NB?=
 =?utf-8?B?dC84ci9KREJucndpVDViZmtVNUZVM0VjNkEvcnNjQ1RYMnhFUHVhRUFUT1NI?=
 =?utf-8?B?R3ZNS0g3eW9RTDRyd1FIRDVkbXFOS2hycUJzdzFnTC8yeEgrRk9HblFEWm5u?=
 =?utf-8?B?a2N5YzFCVjBFcWJpRkxXeVV6MHIrWGl6SkhsZEF0R0ZTa0UyQjE3ZkEySGFS?=
 =?utf-8?B?ZkF5OWpnOGdBN1JmWWE4c3l6bVZRcjhKcHVnZlR5OW1CMDJnQVRRQjdneGZm?=
 =?utf-8?B?WC9ibWxmMXlNYnJ6a0hoY0VqczNjeFVCWERsWUxXemluVnc4OGRTRnM4eVhu?=
 =?utf-8?B?ZTVreGhIRWJqRmdTRXNGYVgvTW5OY1Vqc3hOc3o3a1dCY1phZG5nT2lWOTZq?=
 =?utf-8?B?S0srTHoydS8vQUY2ZnZoYzJFdUtQcHRZbkFHcW9jbXo2UFJkT3FyeHNabHBa?=
 =?utf-8?B?cEZaY1FFMkVCeGwwOVdHUTdBMERIQXByUTUwUDE3NzVONVpJSmhLT05SakV6?=
 =?utf-8?B?NitvMW5NUk5WN3J0a3dIcDVvY3JMcjJrNG1Hc0lSN1lwcCtnZDNpL1VtMUpI?=
 =?utf-8?B?UjlHK28xUGJoa1FOWkRxUExkYk9UN0NkSXlDdE52b1ZmUzRNQWR3MThKT3dS?=
 =?utf-8?B?T3NvUWVZdExxeldLR3laZ1dzZjVtZ0RRN3BhbHltbWdsSnNWQVdPTGFScTA5?=
 =?utf-8?B?bEwxR0NoNW9yc25aS1RpM1pHTU14QVBNZHUwUVFuZmJvTW02Rmg3MnpDOEpL?=
 =?utf-8?B?dWw5a3RCbWtWTHk3NDJSMzJMVjIrSUxDV3Q2WWhBOFV5VlovQ01wYm5RSVcx?=
 =?utf-8?B?V2srd2NzQjJPeWU3RDN4SGc3YStSdnhUYjBoRmtLaU42cldPWTcxQ1F3dHRo?=
 =?utf-8?B?VUJpRFVweFlNd2p6NzJrTG9sY0xabkZZWjdoby8wTkRZdmxlVTgwMDRrWEJH?=
 =?utf-8?B?cTJLb3h5UVBZY1RudUhFYXYrZHowRzgrSkZzRTFhazcyZmYzc3huY0J0Rnhh?=
 =?utf-8?B?NUNJRXZma2p2bXZsZmxBSWhYOWlTQnhienlxNXVacEZHTFQ0MjFGaTdEUllP?=
 =?utf-8?B?d21HdmhJcjJxc2F1cXlsVXN1bEFTMGhWME04VCtmN29aNEtuM2dYVHpxRUF6?=
 =?utf-8?B?MUxwNEQ2YmFpTVc3V1lXUk8rYTk4WHl1dVlFM3gwSzdlRXRlVmVJT2hVZEVs?=
 =?utf-8?B?djc4SnQwVkpCelVrVUJZQlVZMDVrTURZcEZCU3hNVnNWbjdzTmM4bktjTW1H?=
 =?utf-8?B?ZHRwa2lDSGpFQytCdFBPRXM5Y3VrU1NsTEx2MVJKcTdKUjAxRWh2aThtbmdt?=
 =?utf-8?B?VUJOeSt1Z1hLWE81dm1zNDlyaHo4b3hqZVJPSFVIR3ZRdFJOcVFoRUpjQW5R?=
 =?utf-8?B?Nkt1SS9YM2FJVDZaZHRscENKM0k0dEVQNGFnZkc1MUdhbS9Talp5UGZsa3lN?=
 =?utf-8?B?ZE80UlkrZjA4VjRGTTBhNC9qTWhlQ1hSQm90VFc5R0JUbjVPR29VZ2pMOUhr?=
 =?utf-8?B?SFdBa2x3REh5RDd5eThac1RJdVhzQjM5Q244ajhVNCtMdnBkbmFySUVBTXc2?=
 =?utf-8?B?TFBTQUFzNTM2UVRPTkVmRnlaSWRWYVRaS2FkOHFMN1JLc2VMNWszZzUwOFkw?=
 =?utf-8?B?c1VpakZteTMxZVN1cFJJbzZDTlJkd3VGZGhKWEczVHpTdW83dlZwTHRFVkh4?=
 =?utf-8?B?aGJ3cFllUXdBaXlwSUtZZzBNaWlNM1RMTkg1UlJiekhDbk5jK1FMNE1nWitM?=
 =?utf-8?B?OUFhUXM1NWtqMk1UMWdnU3YxaUlZeDBqZjdGUmIxeUtDU0lMNFFERFpRVE8z?=
 =?utf-8?B?QzZ2cjlWMDBESFhCYTNCMmFleGJqOTdVZEowak04TmZJNXdiK0Y4ZG1Dci9P?=
 =?utf-8?B?ZXltbVNLYTlGZXBXL0RvSit2dDgrbVE0ZXhyRTRRSDNvOXRZUFRDN1E5UHAx?=
 =?utf-8?B?TGQzWm1jcEIycjVKbFpFSkw0ajd5aVZ1UzJ3VzdEUE9Kb0VOTHo2MERjbHlP?=
 =?utf-8?Q?sx/A+PTPIvqgb1Py99jXNC0x9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8aa062f-38ff-43d9-e145-08db2abc63bb
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 10:01:22.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4u/hfH76U9vMpP7RvITwoDv44H3GTKViRcKV6p4J4ojbfCehUCD1s18PKj00J78M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6559
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/03/2023 5:40, Jakub Kicinski wrote:
> On Mon, 20 Mar 2023 10:51:32 -0700 Saeed Mahameed wrote:
>> +static int get_free_index(struct cpu_rmap *rmap)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < rmap->size; i++)
>> +		if (!rmap->obj[i])
>> +			return i;
>> +
>> +	return -1;
> -ENOSPC, why invent a special value ..
Thanks, will fix.
>
>> @@ -295,7 +307,11 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>>   	glue->notify.release = irq_cpu_rmap_release;
>>   	glue->rmap = rmap;
>>   	cpu_rmap_get(rmap);
>> -	glue->index = cpu_rmap_add(rmap, glue);
>> +	rc = cpu_rmap_add(rmap, glue);
>> +	if (rc == -1)
>> +		return -ENOSPC;
> which you then have to convert into an errno ?
>
> Also you leak glue here.
Will fix.
