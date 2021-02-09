Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB3131458B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBIBWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:22:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhBIBWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:22:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191JrHT105782;
        Tue, 9 Feb 2021 01:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mhCfD80h0cpW2adQlm0o6e0Bll1L4SQRPr9z5RrrLwY=;
 b=f4O2VWIM5SpeN1Fmk5mfMzaB0V1DNDhS63jprLPJTmjFcJhAghAZWsUiP1/vIDnJtKLM
 B9iWbkqU10zBQ+hchxJyLsnK6FeRJpYb2Ak2aSOK8DZM9LB+HeXFRBQ9fGn+D95wB2T9
 56gnCBP59RzsoItRNpcB0/pLBvtxPea+XGfv7s1ltwZ0URwb3/aEnVYE215spFyAIQCV
 d9rreVmIAlegzG58tpaiP9L1vWn8SjoSW1u2Xtt+AZDLk2fMdWVJRfplZQjgbtAbU608
 HNXqjLmsRAzgEyAjU0Z7MfSFa03WUr11rwpNrIAOynlr9REDxLJpoSPrvu/+e5n0g6fh Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrmwv2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 01:20:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1190evgL080123;
        Tue, 9 Feb 2021 01:20:15 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2053.outbound.protection.outlook.com [104.47.38.53])
        by userp3030.oracle.com with ESMTP id 36j51vck6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 01:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhknsMY8MRZ8pWcCzEXzefOnQ/5fClmpaEOZP6YDFAUE7VPn9pULNNdOlQ87PFMSsYC8ot/FEeE74zw5Mz/vd07d38TcDo4IalqUBFa8CHNDZH2toS/HjQ5cnqwyNcqt9xn0U7TztiN9UDEejlvQtP80CHOXEgL8jfqTjUEYASSRKZtV9KqJhYel7uXPyudc9d1FTofjTqqiC0O5hO9gtr74NxX9wvDXMzD58UJhXv7ugG5apXJkA2LjG4jKwlxJG03pafFVpD++c4j+ytIvSV4QFeToQwx5A27ZdWqJsOKT6Vf6uvDUMU9Z2h4HQm/qo5S2Yb/6T6y3aJj3HvlOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhCfD80h0cpW2adQlm0o6e0Bll1L4SQRPr9z5RrrLwY=;
 b=fuUAOklE3qFd1akafc0Yrec7xU2s4VVniHRXyhCIaeVrHkBY4LevnSXw6EDpRBUfU03Fdl56NlVf3r93gyEZtMeHxVl0pr7o/C0HNRdB+aENgcGsSwPtJ4qQCPdvdxrYasKfE4aFSbApty/9ij+Fn+2SLizY1A7w8f7wPepbhVcjqBp6iQ3R2pegVTgGX/L3JYbHqJ1KXzGREYJSW9M03aN1jA2cvFnRbmbupRoJABtw9O2574aCFO/oXvzas2qZIMrGx0DnkrG50pwujuHO4UirgqbAA789cmQARfPjwo2Qq6Ncr+PED/Tf/30RGYP8PiJWOib7yIHEE8AtTbmxCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhCfD80h0cpW2adQlm0o6e0Bll1L4SQRPr9z5RrrLwY=;
 b=W7cED/edtXfXVt2lZub6OmzSFDrlSpthPpnqSxE91gXjy77nGFnYgsy+jrgbuGBfuO91zrHOSmYQXRxpQGca53knWjXQFzuqzm5YcucJs7NXXmMOsEH2IT9VH5aD5PGKEPy9EA1t+/neDWYnbb7Txnqo6VsnVwc9bz3E+NEzcQU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB4308.namprd10.prod.outlook.com (2603:10b6:a03:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Tue, 9 Feb
 2021 01:20:13 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 01:20:13 +0000
Subject: Re: [PATCH 2/3] mlx5_vdpa: fix feature negotiation across device
 reset
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
 <20210208053500.GA137517@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <061486d5-6235-731b-d036-f5d5e9fac22e@oracle.com>
Date:   Mon, 8 Feb 2021 17:20:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210208053500.GA137517@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: SJ0PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:a03:333::24) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by SJ0PR03CA0109.namprd03.prod.outlook.com (2603:10b6:a03:333::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.21 via Frontend Transport; Tue, 9 Feb 2021 01:20:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b00704b-8c22-4b15-b07a-08d8cc98d9bc
X-MS-TrafficTypeDiagnostic: BY5PR10MB4308:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43081CDA493582C8EFE934F5B18E9@BY5PR10MB4308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9Ni+OhdzXOWwYPRfC3YUoeRJJelNsbAWY6JLDmHVDAnMGjZotnUXj9byouJIpV9GmMzAbrTkWkP02h4wj+WwCoMYv55j76iKKNUmGZpd8VHCOPAYd4aMx4Qvfm7CrBLrY+pBe6DVwYUR9lD0GfudzCsJJ6vKoDcccr+MPUDMABC3pgqfvt4y6YQY/p+xSgp5U0hzuMPONysmBl6W1h9+gVbQ80mnK60XwVuXvPbsdd272xUXLKB/ZkRgM92HOA0T2h84gYHry4aw6+9MCU2JDf12QsHEcWYtwC+2BjmeP7YYs3vTwBQbmrI25OT6ufz2h6ipxP+GUI+yPYnD4uMUnBvONG6qhdOtRay/Wk/TFZej23JsxN8SA0IJCWpjYi3uav3zeu78cAw/XDHxMbace9ctffSK7pGy8lKFEt//TPAqcM03M+b4oNxRUAq0KisNp1Ayn1J4AQqu9yUCr5VF64YELDa548zaT9ZCRDJ/2g7OEyQOgfDMnOTnbzevFLWnR4yYWkiJiSPcrzS2V3CFIQ0eu1hOrnt9bxX9+SDZ+6OSSzhS0T95K24ud6vgskBZ8CNveztWtW+mLcyb2OsKuG/VIQBOaFEzuoW2A1GRBk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(366004)(136003)(31696002)(6916009)(36756003)(53546011)(26005)(83380400001)(8676002)(5660300002)(478600001)(36916002)(16526019)(4326008)(2906002)(6486002)(66556008)(66946007)(8936002)(31686004)(66476007)(86362001)(316002)(956004)(2616005)(186003)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGJCV08yUWdEM3lsK0VpWHNWUzEwM0IvNGpTajBoNEpiSXBHL2wxamFYTmg2?=
 =?utf-8?B?Z3VvWnhmczlNWXRqQVNCY2pMWTN0NG9sUkhGTElvYzl6WWx4eG5XK2JtbTYr?=
 =?utf-8?B?TUZrTU5qMmdOMWlZTE1MMDNOWGRTWC9MWFBkZEVXV3k4NXQyWU9mT25QTTRB?=
 =?utf-8?B?U0dNUHVTVkEvNHI5RTE2YklORW9BK2owT1ZrTUFaenZNa0FldTVuNFRxOVE0?=
 =?utf-8?B?ai9qa3R0SzVtVEowUUwvU0V6cXdIYkpQRWpZRk1SaVJXMWl0MUlKWE0xa3lK?=
 =?utf-8?B?SmZucitPdEJzQk5YM3BCeDFwSFgyZGV1VEc1bE5rL1NiaDRCTUVZVUVtYm4w?=
 =?utf-8?B?YzBsZXZXdk5XT0lFUmxxNlZrK2d1OU1EdnlyeDVKMkpkUTNLZ2t5Ui91cnFu?=
 =?utf-8?B?dStXaFNHUjZoL1pGRmgyL0k1ZkxXazY0Q3p1N1ZuQi9VN3d3RDRFaVQrUmlC?=
 =?utf-8?B?TUppcm1Db09XL0lKUG12bjBtLzZXc25zSDBZempoN1J6NHF1eS9hR2FoVFBU?=
 =?utf-8?B?MDBHUjZSMVdHQ29CclIyOWRRM1dWYTdqU3I5NENhTnVSL1JqanpmS2ZzOHo5?=
 =?utf-8?B?L2xmZFlYWU9mOUZRT2UxNHkzYkN4VUFUbFVFeHJsYi9uT2h2TXRac1R3RHJz?=
 =?utf-8?B?R1RlNUhPZzN3ZUlaTGZxWk80bXE4NXhvRU1sWk5HV3ZRbnZ1cjQ1VXJqRkZm?=
 =?utf-8?B?WVAyR3FjL1hUZytBQ3pWTzA2ODFhdnlWMlVRMkROcjBxNTdmakpmRGk2ZWRK?=
 =?utf-8?B?SkY5TFlTd1kwbTFGblJ6Nlp2eENhYTZ6RHZId0xzdnZTYklmNDFWMUowV2Ny?=
 =?utf-8?B?cXh1Q2hzS1BhQjI4SFh2bm5CMUEyelNrby9RMlBaUk03V2NGOWpPcDZYenhF?=
 =?utf-8?B?UnM2dVEyRThRM1pVWE5yZ3RHZ2hlb25hUzZYa2tyM1Y3K2VkbEx4a3FQYlZW?=
 =?utf-8?B?ZEJhcEpSbWpSOVZBNUoraDZ2c2IxajlaZjlsRDE4dENFemFFakx4T1BuZ1hT?=
 =?utf-8?B?aG5TUFRGMUd1RXg2dE91RkpnRHJHT3AwaDVldWI2cU9wWEdieEdiTUVxQ3hX?=
 =?utf-8?B?VkFMY0szWEJLMG9nWTg1RGp1cm1KR1cwbjNNdEptNGtNSTd2dlhKR09IdCtJ?=
 =?utf-8?B?VjY2Mk92c2htOUkvQWJhTzM5UGVJbnljMS9ZMk1TRS9Icm9nT0tSbnhFVU9U?=
 =?utf-8?B?K3d2WDFGdFVQckp1dHloWFA3SndPanNCY05uandYeTJ4MTZIZjAzaHNSK2N5?=
 =?utf-8?B?WWhuOWl6MUZEengxc3AraEtlNnRkV1ZKcjF2Z29ZVXJOZjhsam41Ly9DenlU?=
 =?utf-8?B?eC90M1luYVJHQ0MyZW1HT0k0ZVlxWGVHa216Nm1QRXExRW9PWEpPYnVRR2hQ?=
 =?utf-8?B?N2pNWUxsWWpMME5kYzZSRGYxd1VpaDl1b1BVY1JMMFE3RDZyMnpaK0VRL1Av?=
 =?utf-8?B?K09oRnI5Wi92ZGxSRlkvN1h2aUNQdXc0MW8xMnhBNERuTTc1cGZLc1NacVNS?=
 =?utf-8?B?WEJBNW4xSjJwVDdMcUk5ejk3RTZpTys2NEVmaWVPaWVyUW5NaUJqU3ozei8y?=
 =?utf-8?B?cmdzdDc0aGN4MkI5U3VBWmNsNnRrRzg5cjZBVnlKMVBZUTAvNnl0YVdMdTNz?=
 =?utf-8?B?Tk9pYU0zVFd0UzEyOUgyWmlOWDMyemtIQkRTZGlzL25NRDYwRU5kdGRXWlFV?=
 =?utf-8?B?TDZVakFrVUV6UC9qZ29TeDRVOHVaNEpJWlFvZzdBRnFmYTlpQnZ6UmRyTjhO?=
 =?utf-8?Q?BlLpE3a+NEa7wm/Nvgl0nOwBG8DRsalA26ichXE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b00704b-8c22-4b15-b07a-08d8cc98d9bc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 01:20:13.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUnMoWTQ13C1SlyFuEf8Ripyg72+8B3FPzZI3ttKgZELOZ+8kd9E1G7GnKtacIypllyBBxiNcXeruc1hxnWH9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4308
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2021 9:35 PM, Eli Cohen wrote:
> On Sat, Feb 06, 2021 at 04:29:23AM -0800, Si-Wei Liu wrote:
>> The mlx_features denotes the capability for which
>> set of virtio features is supported by device. In
>> principle, this field needs not be cleared during
>> virtio device reset, as this capability is static
>> and does not change across reset.
>>
>> In fact, the current code may have the assumption
>> that mlx_features can be reloaded from firmware
>> via the .get_features ops after device is reset
>> (via the .set_status ops), which is unfortunately
>> not true. The userspace VMM might save a copy
>> of backend capable features and won't call into
>> kernel again to get it on reset. This causes all
>> virtio features getting disabled on newly created
>> virtqs after device reset, while guest would hold
>> mismatched view of available features. For e.g.,
>> the guest may still assume tx checksum offload
>> is available after reset and feature negotiation,
>> causing frames with bogus (incomplete) checksum
>> transmitted on the wire.
>>
>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index b8416c4..aa6f8cd 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1788,7 +1788,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>   		clear_virtqueues(ndev);
>>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>   		ndev->mvdev.status = 0;
>> -		ndev->mvdev.mlx_features = 0;
>>   		++mvdev->generation;
>>   		return;
>>   	}
> Since we assume that device capabilities don't change, I think I would
> get the features through a call done in mlx5v_probe after the netdev
> object is created and change mlx5_vdpa_get_features() to just return
> ndev->mvdev.mlx_features.
Yep, it makes sense. Will post a revised patch. If vdpa tool allows 
reconfiguration post probing, the code has to be reconciled then.

>
> Did you actually see this issue in action? If you did, can you share
> with us how you trigerred this?
Issue is indeed seen in action. The mismatched tx-checksum offload as 
described in the commit message was one of such examples. You would need 
a guest reboot though (triggering device reset via the .set_status ops 
and zero'ed mlx_features was loaded to deduce new actual_features for 
creating the h/w virtq object) for repro.

-Siwei
>
>> -- 
>> 1.8.3.1
>>

