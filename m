Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD48856B3BE
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbiGHHmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbiGHHme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:42:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC32D7D1D2;
        Fri,  8 Jul 2022 00:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEJydwc+4dwPu0952oa3t4di+w0l2/+uAhHK2vaf/kJXhoyHVheUGFIE8lQwLgAp1biZ/0tffgCoClW5MAppKAZaeSuum9OrqqXepadj4G3ZxuBOjdecmp4e8MEUB0Yh79lmuVY6m2UahMmzFh5rVQNX9SkovqZZslFRsPN/JsVf4Td2SHRT6jSl99h1qLXpsN/pyroMHMkcgy1N0q6sSBgbTHImbRO9875VB5vbcWEFUar+2mgJQuNoLxB5GrOk9UnWBSZ0Ql9fRHF8QrM6DWezQ9GkLamfW45JwsUWIifBv4YtxwNbbhVjE7MBunC1PuxVemCxxEE6Lps5StzfyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCclO4cyBG0UgpR99d6vTiPx5/YE3cqxnNlqy/18IW4=;
 b=njsE4ltUBjEsv1bJpJTZwx0YNLG1/aeR7VqJl9Zg1mjsf8PlIg4mgfdhi/4+75F+pKmIcpjIv0EMO0r/8y7V1bFkZ1HyX9fgOLC+EH8CqzpusqH0cHva5DakLQX/JPpLZDftzPt+MttoHL5M2EOC6qEtK+IA4g788URqHPKUfl6l/4a8Gq+yLYbySx+PSqtkuYcMbx2Jojl1Nq4w3Q79/5mGTxBYztr9VS7RCw5yEy7Y1Brfirb91zckExZxZ9ex+zIzTO6TtU5FMtY51/qweeiE1+fuW35X819/D4CbMcwewxXx6zmBn1gNtjAjyX69LtsF3Mz8IKxn8uLQeqFnNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCclO4cyBG0UgpR99d6vTiPx5/YE3cqxnNlqy/18IW4=;
 b=QBA6LBzwNKvbC4ERWTLKihyoSdW2A7GEJzeXpT8Z+g++uieClU4YPhL7/Yd49afMfPYznUvLFXjjVz2CHbkjyVPxsnzt4cBQ9DGstwZ6lgLbXggVsvSPE4u31MDm/ZBMJlZLuxzo6d3ebBk2MbC7qo5XNzYS9Pa6ePZIPnJiSbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by MN2PR03MB4958.namprd03.prod.outlook.com (2603:10b6:208:1ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 07:42:32 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5395.020; Fri, 8 Jul 2022
 07:42:32 +0000
Message-ID: <11893064-a25b-245c-2fb6-77af7cabd15e@synaptics.com>
Date:   Fri, 8 Jul 2022 09:42:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com
References: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
 <20220704070407.45618-2-lukasz.spintzyk@synaptics.com>
 <YsKV+BFUIt7UN7xP@kroah.com>
From:   Lukasz Spintzyk <lukasz.spintzyk@synaptics.com>
In-Reply-To: <YsKV+BFUIt7UN7xP@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::16) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61387dfb-05ae-45ef-ebfd-08da60b56a50
X-MS-TrafficTypeDiagnostic: MN2PR03MB4958:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z0dmiULqJde9TonU27Eys6GpfBABUAtC2zhGYhxcSwq79gjYbkKbDm9qh/+X2iroAg83T97XM4XGvkN9pSEoCWXa27XRUFcHuny+hKshaBTHFKcSQxbhd1FO5Oihr8rTZ5GrpoVpNOdGT/OqkrMZoiX/VzNI/H/hzyzzllUYDrtom/5ohZ54wDdPeBLxJeTiTiOVC+gh/e9c5d+3JQcuOeuVZYT5OmlVBBdN4pPXq9rXy9goflGCi4ZGdEY5XKMXeE3tWXmWTh2PT27aiOfJdJCDvj//Z7TBCBRFtq80HjwRcdmf4KxH39u7uPCHDgIjVIWJCggcVhjYjf+fMcddinwLiJkpRrmcIuC1r65lgVAhcDIu3UD17SXE6x8f5iUSdHU1TtlnjuVd6qJdGA52iwFeqAYQgAmgtw/T3CLJOQ6BUTA3Erk3HLjmJMLBSey5VyE42yW1JEwsD9SVYQkBCESJcMBUqzIYfrLYAkHwrnHbsZLZRAQU/ql6gYUnosc2iJrieLWKqSXPbHmtL1viH1lms8O9Kb6/O7nXHvZk6ZE5EQlPygNC8AJOI2MCkUXYhZgKHCsPglzrXqvfaD7SmzEDO4DQXdtiYYRZEqKbh8DKssK2IDHaM/cGKn92+j3YUF6OALqjYyN5irJ0eMHgfRSzL4JyW4oL4s+1Rym1GvYoZp+Zj9htGJ5LPlPcDwdW6BOmVIijSfoz/J2tkXds9fOOGcS74T9Z/cONoizFYL4Gr02YMXRQeSMUEerYuUGS6w47cGHDcfq9lJXNvQokfXtT9KYxgk6Z0+NXfDi3j84U82t1ZmnTm+MI+jmUiK6zUaKRzt4uRssqN5XL9q321OzV3trutxboHzbJRvmtkFmnaEDVcfVuY5MImyFV04ah
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(396003)(366004)(39860400002)(66946007)(86362001)(478600001)(31696002)(38100700002)(36756003)(38350700002)(41300700001)(44832011)(8936002)(53546011)(6506007)(52116002)(26005)(2616005)(186003)(107886003)(6512007)(2906002)(66476007)(66574015)(83380400001)(6916009)(6486002)(316002)(8676002)(6666004)(19627235002)(66556008)(4326008)(31686004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTRNWWdwdzB1YUZ5T2JFMTR0cVFpOXQzaGlvWjM1cUdHRFoxaGFWM2lVOTY4?=
 =?utf-8?B?bE0rZzk0VVFJTnBUM3ZyK2t2MnBIUEdLZXo3ZzRHalV0Q3BFZEU5Z2h3NmJZ?=
 =?utf-8?B?Vk5ieGI0NmZWNFBWVGpWRVE5T1VyWnp0bWFBcnExcmVnNnRvcGhMa1FpMkdv?=
 =?utf-8?B?dlZsdEVPZ05paHc0OGRaR0ZCVk9ZY2c4VXBQZHBUZmRhek5sUnR0UEZSaG1W?=
 =?utf-8?B?TS9FV3E4Sytnb1JuSy9xVnZvS1hIQkF0OUhOL0IyK0hHcW04L1V1UHRBWmMy?=
 =?utf-8?B?b2dtOGVjUUVQdllGQzV2MytCWEhrM2FlM0pkYk1lTXkrMlRYb1FMKzJoTFZs?=
 =?utf-8?B?cHZpL1BXcm1WNjJpZ0VVcitQa1AzSVhVSThPOGNaN2tyV2htSlVEeW1YYklL?=
 =?utf-8?B?ZUZtcDQ4c3BQN0I5c1dTRFhFUitjSThHbndxYzF0TUkycm9ZSUtpbExzS3l3?=
 =?utf-8?B?SFVKQ3pMazhQYVpZNHJoUGhsWGdnMHd5U3RlZkZnVjRJdTRhUFN2d25rWEVq?=
 =?utf-8?B?S09OcjJ6S0JzVWoxc1RXaEk3VHR5Z3FuT0lCRjB1MmZxeG5YQ1V0aXlMSE9u?=
 =?utf-8?B?ckFzNWtBdEI1SHJUTERBVk1DcDJhOG80SVMzM0pIeXl1WDVxSWM3WGF3Y1hP?=
 =?utf-8?B?WlVsQzhndFlyZWdrNFB3NTUzbXU0MTMrdFB0L29mUk5lenEva3JyaFRYUGU2?=
 =?utf-8?B?YmkyclN0cTlrLzJsTjJ6SW42eTcvYitWOUhsN2JwWHR2bkZNeHl0YWNvU3dJ?=
 =?utf-8?B?blNSbFNTOFBGaDgzWnhEZ3BnUiswTE40ZzFlZklrZG5GVFNPRXB0YnAyUE1h?=
 =?utf-8?B?S3dFc09pR0w0dE9PTm9SN2lOaU1ScXdBYnRMQjR4d1Bvc294M3Rwc1JzL1N4?=
 =?utf-8?B?WGN0ZTB0bjFkYmpRdk5RKzFVWE1qNktYbVpweGtDZXk4VldacmpsVGwyNGFI?=
 =?utf-8?B?RTJEQUlJbnF2d2RtaTcxVlZXeEk1SThMMmhscmtjUTBtVlc1YjVSSkk2ZjB6?=
 =?utf-8?B?STl2OWVEQmZ6TEFuTll3WjdobHliQ3EzbEVzNmdmVFg4ZnRPWEJLWU05VXZ6?=
 =?utf-8?B?TGNDdGswSkVzeTN2ZFVEMXJUTDJxVUxRNGxHNEQzSkVLS0o2dWVVOFp3ZFVm?=
 =?utf-8?B?ZmlzUkVwSDNSUEFlUUNnbTA5dGxCd3BaTnpGNlRKWmNtWDZMVllueDdMb3R6?=
 =?utf-8?B?eTNwVEhFYmdIMWFDSEQzSEdDTEdmbHdSSHlOZDhIa0c3K0Y1MnJJSFhYakh6?=
 =?utf-8?B?MnVneUZCL2VWRGgxcEUxRE5wZmEvM2RSb1lPdXNZTHlFUkx2aEhybnppZHNQ?=
 =?utf-8?B?ZHFRTkQ1Uko2SnFuN1FwZmxXeFRYYjZsaU56SW9xd1Y5cG82T005bXhVL1hG?=
 =?utf-8?B?VzhxQWRtcER2T3NkSCtCZVI4UXN4bk92UldIVlFETkJBWExnMkRmeVdSN1pl?=
 =?utf-8?B?RTBqSUNSUTJmT2diRUJsZHVZcG84bDdjQW9sN2s4Zzg1MTB2T0RpUUhSWWh0?=
 =?utf-8?B?a0VzcGZ4T0diZTR2TWJPWXg2bGtwN2U4d1llZ1d5d3N2cTg4NUpxMmRleUEw?=
 =?utf-8?B?dzVxcWZZNlhFb1BHVlVtb3RUaWM3ekRZOVZhZGxMR2xzT3FTVTU4Z2F3T2hw?=
 =?utf-8?B?WVJ5cVNUWHBjalZZOXRaeGJiRHdGbVdTbHRmUUQwbmlvTEh4TThkS29HQUxR?=
 =?utf-8?B?SUc3bk1kbHpscFNKb3QvQU15clUrZ3ZNTEhXdGJob2d4bmFQMjduYTF5cmFp?=
 =?utf-8?B?U2VWR2RZc1g0TEkwYzBwYWl2OGluSk1ZdTBYMTJrbjdEL2VpZ3BaWkJOOGNv?=
 =?utf-8?B?YUltM1ZKRGo4WHFrVzhJNWRRUlVhTWt1YXo2TllsbnpTblVNMkw3aStBRGlV?=
 =?utf-8?B?T09oS2RoR1VEbFpvd3Q2a0JQNVBsMEF2K216bW44RHBMWWNNczc4VUM1M2hI?=
 =?utf-8?B?TmZ4WmlBVUM5ZjRsM0pXREhmYTl3MjIxaU9zbVNCakRYcUZIM0g4YUljNkhG?=
 =?utf-8?B?eU13QlhLWG1ERzI4b05MdHoxd29ZRkNWbDJyQ3RxQWtrNmplMkNpZllVYTN1?=
 =?utf-8?B?L3RTOEF6NzFsNEVNMytEOUlDc3c0Kys3dUZka1d0T1BCSk5WRkZhczZYaGE5?=
 =?utf-8?Q?IUHoJ3YVBc52OJM3yPZUIU9Ni?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61387dfb-05ae-45ef-ebfd-08da60b56a50
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 07:42:32.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAknjNHFjZthmiAfQHbmKFd8CeXkpGH4yiQ9NOC2y0y0g5spFcLlsZqPwzBSAvDywfvI42dkrUNPwifrim0kGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4958
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 09:25, Greg KH wrote:
> CAUTION: Email originated externally, do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> 
> On Mon, Jul 04, 2022 at 09:04:06AM +0200, Łukasz Spintzyk wrote:
>> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
>>
>> This improves performance and stability of
>> DL-3xxx/DL-5xxx/DL-6xxx device series.
>>
>> Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
>> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
>> ---
>>   drivers/net/usb/cdc_ncm.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
>> index d55f59ce4a31..4594bf2982ee 100644
>> --- a/drivers/net/usb/cdc_ncm.c
>> +++ b/drivers/net/usb/cdc_ncm.c
>> @@ -2,6 +2,7 @@
>>    * cdc_ncm.c
>>    *
>>    * Copyright (C) ST-Ericsson 2010-2012
>> + * Copyright (C) 2022 Synaptics Incorporated. All rights reserved.
> 
> As I ask many times for other copyright additions, when making a change
> like this, for such a tiny patch, I want to see a lawyer from your
> company also sign off on the patch proving that they agree that this
> line should be added.
> 
> thanks,
> 
> greg k-h

Ok, I will contact company's layer and will be back with updated patches 
if needed.
thanks
Łukasz Spintzyk
