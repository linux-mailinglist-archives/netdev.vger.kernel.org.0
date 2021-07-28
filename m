Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC4D3D8B69
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhG1KIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:08:15 -0400
Received: from mail-dm6nam10on2130.outbound.protection.outlook.com ([40.107.93.130]:3681
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231392AbhG1KIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 06:08:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPrMqswO1568PDhKQNh9flXWkVmYOSxhqTLZagge4ZuSApiMMzHZX9oFMc7tXe/t9rZHMKPnSIwFrF/kI1RjSIrVRVkmmDUT6VHo9HWQhz9SNCA2j3oLa2YPZeFpCTolqg2VwgomoOx6pWffeyGGymR5CDtaXOWVTOtGjUGTBRNQ81GO/gpvDEwFTlKkOWpYHE5/KwiqmD9A6wZ0ijSvrlmN+dMm/QAeqhGXqyPho4GqQRyjuVwk4a3W6+SJVS8mfW70B0701L0m3Yy4yc0v8Db+gojsMWy56xL52UDLys8erV8Zt62VcEngZsVpb4pljbqOAR9ufYQsoVm/PrfCAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqk2aFcnfZh2f4cIFAU3ncLzloxiKnCltuZs9uQD2Go=;
 b=P6R1NgdxO22cWd+wKee+a2pZC9CKi2Smi2ajKaPNUbKtN4HZ1PiHjlUQCGMvJzSHGmZUitd9tNs1Gkyv0AdGMz94PpUtGBWGelm+dbGYCrl0R7YDr5PlbvGJnfQ//3RervaJXjPKazjex5L9ZOJc5N11MCJgfGMXgpIv5oP79K4qaJiEEfdQMxnAtjZMWWes5c4DS+mVnswyba42f9NB8309ecpZVdmy5mZwNPGlIUPdiH+1HxrLEw/5tOq6wAF2Xy7W+jipvQMDsd5tTRod7ByKGzlueVbdG/9JnOwW9tcthTB+4/vJL4Y4SZJjOhyuC4dvmgsXg1CkNhJTKKj+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqk2aFcnfZh2f4cIFAU3ncLzloxiKnCltuZs9uQD2Go=;
 b=teyhrMmI28GC+K0OdSHG3AYzzPsm90DS3VCDhXpPtby7Cs0/toUdONWyWpfrc+APIX8LyAWtjMlMJwNmpmC8PLDN3F1b1HuLgSQ7f8YhEoBtFYCKuvIzeyDqZYP2HV5anFYFqo2AYWG4/rt/kZHxQ/tmwSmIU/7dZdtd6ajy460=
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM8PR13MB5190.namprd13.prod.outlook.com (2603:10b6:8:1::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18; Wed, 28 Jul 2021 10:08:12 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::3c5f:ccfc:c008:b4aa]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::3c5f:ccfc:c008:b4aa%3]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 10:08:12 +0000
Subject: Re: [PATCH net-next] nfp: flower-ct: fix error return code in
 nfp_fl_ct_add_offload()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, simon.horman@corigine.com,
        kuba@kernel.org, davem@davemloft.net, yinjun.zhang@corigine.com
References: <20210728091631.2421865-1-yangyingliang@huawei.com>
 <0776b133-91f0-33ef-edc9-8f275798d44b@corigine.com>
 <20210728095635.GT25548@kadam>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <35c3cfdf-3125-655d-befd-430bd08c9345@corigine.com>
Date:   Wed, 28 Jul 2021 12:08:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210728095635.GT25548@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0500.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::7) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.1.2.53] (105.30.25.75) by LO2P265CA0500.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:13b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 10:08:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2a9b3e6-c8a2-41e6-216b-08d951af9b8b
X-MS-TrafficTypeDiagnostic: DM8PR13MB5190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR13MB51906D57F17C1F1E6884DBEF88EA9@DM8PR13MB5190.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EfX+Lh+j3+XEoINcKGRB/2rnwOekveYBVNbH1uQ1sEiWu4KMCkk2VA7MNJi3Wem9nu9li9ihOAqnO38MuPblrtJs3m8Ez3SqPVnC0bTtIkU7TlMb8O3CcjlAHcWDo6bfxdOGtmkHPGrGwTVMSKLBvrB/kmzFg0aG5LC5/WVq5uir/3QVWx3zUnkDI7uHk247ylZAsb42PB2yNFoWs/frosUeNRxWvQtjMbS5sR1sJBiMLC3lMxsNRzRcpaBe32g7h6BkOiJBBr5ZAluOLnUPObPV8OqnoTOhwsb4aSdfZ1FlkUKEOnPJc3xG4WUCQ+ddNgfbpB19p1Y8sHil28VS+aGTVTgeRYIJOu/+s/fsh8Ju3cjGFvZw4bNHgwrMlWwONdZgs2YBbI2Sq9SfXl8c8yroqsveyLAEnU47k/myfTTOwGPSZ78YtnjvznboT3OIgch2mx0haIZ6nzDqDlbZMxK7Gfpvr1i99wLilgTDd4OCASzU/wR2sVi/hZVPlrHzQcovccMteIqhPmC5uQnkl6c6qTILJ6YrOz3iE61PvqnGpJEo2dfZpxWODXzAwQRvrb8rclknw9CcxzewoxFRTp+ZwYDuAE0rSkCZd7yips3P8U6WmFv/ol3tuslDV9mqb+l9whrjAGUifM9NWQHgYxzZxiak6hESgaodI4PTXc+F1nqWXIrmxSLJ5zYQ4AUZ0PcfcJlH79IQ/Srdg+mFQDU7eXyO3tVJzHViNZdP/PzemNGvcxdfg01sG0FUAtjGhrP4rXdF+6KthXOgFpOtCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39830400003)(136003)(6486002)(478600001)(2906002)(6666004)(186003)(26005)(52116002)(86362001)(5660300002)(44832011)(36756003)(31686004)(53546011)(83380400001)(956004)(2616005)(31696002)(16576012)(316002)(66556008)(66476007)(38100700002)(6916009)(66946007)(38350700002)(8676002)(8936002)(107886003)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1RrMEtEcjQ2dSsyVkdkeTkxMmJmdGY3dFh3QzJTbEZUZW5JNjFIdm9LNzVD?=
 =?utf-8?B?ZW1lQjlrbHJ6aUxJMzZWeE1NOFUvS1hoTGQzN1RMSS9WTW51NG5zVWw4cVhz?=
 =?utf-8?B?b1BSalFYTDlNRlhBSTVZQ1Njc0R2OHJrOFo4R08zNTc0TTZmd1pmR2RKYWRN?=
 =?utf-8?B?bXp1TUQzZms1VlhuMm5waDhSWHRsYURjTWRWNTJrS2lCdjcrdU1RT2V4eFRT?=
 =?utf-8?B?cmRVc1B5NTltWTA4MmkrRW01cUYvMWJHVVV4cXA3YXBNdlV1cWI4eTJxZWZQ?=
 =?utf-8?B?TmxmcWNRSXQreVVUNFM2ZHZyYXpkQnhFZzQrQnh4YkUzMi94Q2lHcVNwNHdm?=
 =?utf-8?B?QU53QWh2VXlKemRTWEVQRlEzclBkWnFvZEJHU1k2TkNSYzI5VFpsK2JIM21P?=
 =?utf-8?B?RURsWTlPSWEyUWVlRzJSbXVKcjhOQm5ZRW84aHkxblpCdElBWUNTYnpPa3VB?=
 =?utf-8?B?MzFBdDIwcUlwOTVldVF5SFhiVG1PL3pDN2dQVlpCY3Nsckl4a3pEeE4vR1RQ?=
 =?utf-8?B?WVhvdTMwZnVpL08xejFVOWJMd1J1dTVLSEVLV1hFNEQrUWo5SUFqbzFTOTcv?=
 =?utf-8?B?QlNnU0dwbVpyU1pFai95aThZZFJzSUgwQm5qY3FSOVhENkJYV2JiemE5eSti?=
 =?utf-8?B?R3BDbmxQQzdqMVpBOU1zV29URy9pWDcvcmZBZ1A5WENpOXR4Ly9jQ3JzT1NP?=
 =?utf-8?B?YlFlWFcyY3BZSDFKZ0d0dTVZRFQvdmhZQTVUL2x6UUwvdS9FVnFJNGtITzYw?=
 =?utf-8?B?amN0ZVpleFp4MkRnU3R0OUhsWTVHT2RNaVc2WEhIRUdTQkpjQ0FSNVU1SndL?=
 =?utf-8?B?T2ljR1B3ckt1U3h6UkUxS1BrRXpiRG54YkUveG0wY2NvRHNKaWNSaFllQll4?=
 =?utf-8?B?VnJTMThqeVBFUXlVanAwa0oxOHJOYVNxeEJFcTJxVGlrcjY2TVpRcENGbU4r?=
 =?utf-8?B?WFdlMS9yVFZYYVQ3dndic0FTU2Irblp5TkVuUXdjbVVxQytHaW1EZzhvODRy?=
 =?utf-8?B?VkcwN0JDSC9vRGZPY1gySm9aeWxTd3lKaTFXQmdncEhuQlJJT0hzNVFpUDJu?=
 =?utf-8?B?dTFNN0pGWU9GZTgvdDYwNDFZK2RyTUdvcjE0Z3FCMmV4WDBDRWV6UHgxWEJE?=
 =?utf-8?B?KzRjNVBTRkVOMFBHYXZpNENlYm1UaGx5YWcrUzFvbE95WnNSa2dMalRGMHE1?=
 =?utf-8?B?cnA2OW04YlhzNGVxV1NMTkpJTWh1Vmx0bjRSK3dWS0pZZ1Z6OHZ5cEsxSmdo?=
 =?utf-8?B?dElwK2gxNXBDbFVWMWJsK01rV1VSUVNRaUY2RlQzMnM0cXBVTkUwRHc2VENr?=
 =?utf-8?B?N1V2TEJlZUtnWmNlSkd6SU42WnBjVHJ0eFI1eXQ0RUorRlVpZWJTcXJDSjdo?=
 =?utf-8?B?anJsRnA5a2l0VHkxZXRRci8yTDhVdUlmUFFyZ2Noa210VU9KSmpla3RjTkdB?=
 =?utf-8?B?VkNaSUJCQ09VY2dEWG1KM0U3OUt2ZVpncmY4R0lTZzhYTGVDNkJibU5WMVV5?=
 =?utf-8?B?TThQQ3Mycnp5ZnE5Um1ldGdIa3NieWpzNkJmMkd3eTBzaTdGZHVZdElidStR?=
 =?utf-8?B?SHJEcUdTbHJiejVvTmIvWmxiOHJuQ1A0WFZ1S0R2WEd2dlFxRDdCODRWNExE?=
 =?utf-8?B?RzJWV3licnJBNjc4T3d2TThRNTUzOHVHc3hma2w2TlNBN3AzbUE4MGkxY3F4?=
 =?utf-8?B?MHNvS24rd05qaEpFb1JxU1pOcElEYWZKUDlLdWcvWU5tdzB5cFpxQ3QxYVVy?=
 =?utf-8?Q?9Rnv8yebby6zfJOVoYVokzWZivWoxUsudngytD1?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a9b3e6-c8a2-41e6-216b-08d951af9b8b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 10:08:12.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 047WS3ZGCnhxTWUKVvEgN1O2869Nnz/UeA3efeMc63IupHMCDoPr2TFsR8TYyDlaZSv97bd66KyxPhQA98oaR3RC2cz208BEABTs5TTrxLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/07/28 11:56, Dan Carpenter wrote:
> On Wed, Jul 28, 2021 at 11:36:43AM +0200, Louis Peens wrote:
>>
>>
>> On 2021/07/28 11:16, Yang Yingliang wrote:
>>> If nfp_tunnel_add_ipv6_off() fails, it should return error code
>>> in nfp_fl_ct_add_offload().
>>>
>>> Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> Ah, thanks Yang, I was just preparing a patch for this myself. This was first reported by
>> Dan Carpenter <dan.carpenter@oracle.com> on 26 Jul 2021 (added to CC).
>>
>> 	'Hello Louis Peens,
>>
>> 	The patch 5a2b93041646: "nfp: flower-ct: compile match sections of
>> 	flow_payload" from Jul 22, 2021, leads to the following static
>> 	checker warning:
>> 	.....'
>>
>> I'm not sure what the usual procedure would be for this, I would think adding
>> another "Reported-by" line would be sufficient?'
> 
> Just leave it, it's fine.
> 
>>
>> Anyway, for the patch itself the change looks good to me, thanks:
>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> 
> Normally it would be Acked-by.  Signed-off-by means you handled the
> patch and it's like signing a legal document that you didn't violate
> SCO copyrights etc.
ack :) Thanks for the clarification, the distinction does confuse me,
thinking about it this way would definitely help.

Regards
Louis Peens
> 
> regards,
> dan carpenter
> 
