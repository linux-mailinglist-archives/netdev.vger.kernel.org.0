Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBA2388927
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 10:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244179AbhESILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 04:11:39 -0400
Received: from mail-eopbgr00129.outbound.protection.outlook.com ([40.107.0.129]:36430
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237647AbhESILi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 04:11:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDFNSMd1+K3ayjr9YjzzcrhCw4EUQSIaeuUZ7pkqQX4X0gX47qQV/rIyS+2G3Nf4amjy+nGSou8yUqJlLQr0RhKMqPtMsoV5rZbPGUx3utGwckwqcv5a628IiRqjpDVj0eHkRNbJetfZT/nCYH63ZIui9tbU6Kwl5iHSn2TEBXox1y00QeXwZgtpOu4a56t0UlMg+cLW8oeareHCKFVj2WxN5KBvCCCiMZ6bl3A4OZPrIJd5PxaGqroF3WDLdnSJpJ9SFPPTE6RuqscNVFRb/gGDDtKrsIGK4+IlWPokOXBHWj/bUMkfGarQLLDwJhubpZGLMfygSMD2cgt9R6gtcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdOhLnNAqSu9NhGHJxDfX78181GZPVw8XlhcRV/sON0=;
 b=aXh5juIuo+YuTsYEaBpJJnDQIgmRSBFl/gG4/10ZQQ7AGjZj5t1UqvJCM19SqLr9tWtJn6Us729GIH9yegu8XuYSi1PHqgFi+MuSo7Psci7/H/nYrpyJoeRHLVCAwXVOo0HB9mOg2k9Wt5majcUfC1OK7iqstKGPC0uaGMeOVH8OA2+Ho+GRSmD4apQngcKcZlh3mUmTgEhKr2iqm4btX7aR7y+z47vo5Z2QQRsNBoADkXQ+1/asFed7zMJELNJ7MA2ljfmsYoYkrLouSYyaN2Txop9tvA+cJ04v1rGgQXcWj6OTs/idCupmwJIueuqN088WO1lIFhGiCnv+I/N0nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdOhLnNAqSu9NhGHJxDfX78181GZPVw8XlhcRV/sON0=;
 b=nknsY2krQSor8FH9FlUC/UdDoerw72v9IGTmT3pCTZG0zPLR0gq1hwRBhZuwkZYjXvUcgG4sQzUcTipm7zDRZo8H5D4gauHEpsICwCzGCinsVFFz+ACeky9zTOp+E/V7RGrqwOozJ9/uqzY6COVpchzM9x7LZjB1rxf/GE1SwcQ=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB3992.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 08:10:16 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 08:10:16 +0000
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Dave Taht <dave.taht@gmail.com>
Cc:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <DB8PR04MB67957305FEAC4E966D929883E6529@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67958B0138DDDDEAD20949FAE6519@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <494cd993-aa45-ff11-8d76-f2233fcf7295@kontron.de>
 <DB8PR04MB6795A2B708CED18F77EEE0A7E62D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <CAA93jw5qShao9bjEXOd8wHOakxFLzfm+Ws=_iVetzEFD9wT2aw@mail.gmail.com>
 <DB8PR04MB6795DD09B08C29C89C418E4EE62C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <9b9cd281-51c7-5e37-7849-dd9814474636@kontron.de>
 <DB8PR04MB67956FF441B3592320E793DEE62B9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <7db860f4-eca8-172f-490d-180cf599d64c@kontron.de>
Date:   Wed, 19 May 2021 10:10:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <DB8PR04MB67956FF441B3592320E793DEE62B9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.244.189.149]
X-ClientProxiedBy: AM6P194CA0071.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::48) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.17] (89.244.189.149) by AM6P194CA0071.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 08:10:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caa5aaec-74bc-4b51-4fb0-08d91a9d8925
X-MS-TrafficTypeDiagnostic: AM9PR10MB3992:
X-Microsoft-Antispam-PRVS: <AM9PR10MB3992BD62DD1FC8890EE5C441E92B9@AM9PR10MB3992.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCx1rfU+ZQlw/7iXBhEeGCrw8crMUYifxAtUa46qoMMov5UzH1no5H4RuHBYfFi2cHKLdC9vxvY66gjTVq0DdJCwqG4UtPUgFREN/F4KXiivAOQR9BECzd7KhsK2UWfM9RpNtr0gbyd7BsE2Wy9bgJcgZuymJYO8B32DMnmR8vDjYQXBXsbQ0ePXth2qhXJPCeFOeYQGtD9gAdhhJm/PLRoFuB3FXkHgTY3WwI6sl2fyc0CmX7GLhOg3bUaUlpnKssLN78Z/4Q4vlainz6yd/9AOzOdrgeReaNQGoWJVlwkItC0ceVDUWU1J+X7UD2B9XEIb7MtwYBuIJ3KwQHWA1X8dB+3vvxMJ3pYTpP41yl4GQkAHAuSowzRL1GPVmHjo2iiFPaNrccLkMvwWFM4cC2JcmCIUm5WKgK2EsS6C0UB0roCNqjMxoOEOoq31uWRMCPI4fQ5dBH8Fzz8WWatA8nbDyT0rLSF9JZa/jpOgcj9mCz2GUzYI3AiCpneGeWLroZxEVbCF/BuokdsCThPoRrBDe6uW5o2MQHmat1lAiCGM5zSqtvMSq7KmV8vKxsWCDj8AGORrEFDVkyIBltPSFDFMcA8Dbp480ZYKq5dnG7TXWRts2lSaBDOuemSDvZAGS96n2LFKX0W3ewITuE5TirJPrvV1IDPzlOC1hhys7W8H/klI6z7zXEr6sVEeDdG6YRdPGah5+53HO9Ef7+GNJRmTOUHJc+WQEcuD88w4iMnpK4xBuJgxI4sjs5/icYge7fZcEXS/8V1dm0t2UirwAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(45080400002)(5660300002)(8936002)(16526019)(83380400001)(8676002)(6486002)(38100700002)(54906003)(186003)(31686004)(86362001)(66946007)(66476007)(31696002)(966005)(110136005)(53546011)(4326008)(16576012)(2616005)(66556008)(956004)(44832011)(26005)(478600001)(2906002)(36756003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R0lGZm1Jc2hwZDdrRWRPc2Q1Y1V4VkJxM2VnWHdGWTRsTHM3bVY3a1Rpd0sz?=
 =?utf-8?B?czFMM0w3ZVlZWFo2UDFOUFJ6Z2FHRDI0MDFCY21kSHFkWkI5aEJiYlhoSUdv?=
 =?utf-8?B?b3NjcUw4NlhIdnl0VGtobW43RGRDS2xnbTVNejFQUEFzNy9ZVTZWZXYyN0Vm?=
 =?utf-8?B?MFJGaGtDd3duS3VEcTYvN1RWTWpET0hqam50QnY1VnFpeDIwTGJZWmhNVjhS?=
 =?utf-8?B?VzFFVlFMYVpNZjJ6WUdkeTdqS0MyVEZKQmFyMEFOV0NkSE1wWk1ZclU5am52?=
 =?utf-8?B?dUlUdWZFM3JURlNXbW0vTnM2dUMzVkh5RmNYaUo1bmk3NzFpVGNnbzhlRWto?=
 =?utf-8?B?VzcwVWhZVFR5RHM4RHZKQU4xd3lycW1mUTgrbVd5NjJzTGNoZTFtNFNZWmdF?=
 =?utf-8?B?Rm9pejQ4Z2YxdkxQbFBYK3VBZGNFcmpaU0JpeHNZMmN6NTVBREtubnNaaTEy?=
 =?utf-8?B?WERBTjZsWUIwTFFDcnkzR2tjVExwcHNIUTRXRllQdjZZcUgwRTlWVG4wSlAr?=
 =?utf-8?B?TnM4cFFQcUQrbTNsa0M4aXpiNmN1cHYvN3lPUkxZdFN1eUtDMWFUYWVzb3dL?=
 =?utf-8?B?NkxqbmhJTTF6WGZwNkFiTGdoQzlmdlk3aVBydUx4d0E5aHJQays1VzBzV1lh?=
 =?utf-8?B?ei9OSXhsMlJGeG1JUDArTGpXWVZqSmFMWmFjUjhGaGk1bVYvbVM5akdrcEdz?=
 =?utf-8?B?MU9JZkhlT0NOemg2WjEreEc2dndYNmVrekc1d3NkSUhMNmFiTU1uV0pOT2hI?=
 =?utf-8?B?Y1ptbHVQQWtWYTBtdVNLeGNCUnhsblRURWc2Z1JvRVhuT3dWT2NBWVlqZEI5?=
 =?utf-8?B?VW9Ma243VXJCQTV3RHlITTFLMHFpVXphQlBHL0lZZ0lCVlV1MFRoVmZEU1kr?=
 =?utf-8?B?TFV3VkpwNVc4Wit1b1BpTkZXYW9hdEw2VExzNUxYK2F6UHpCeFRwR1ZzaGpI?=
 =?utf-8?B?OGR0MlhxZEp1ekg2ZHdwVHBhZVc0c2V3bGlzS29uYmRRODRmaDFmUXZLd3h4?=
 =?utf-8?B?QnZzd1lFREEwa3VpVUoxL0pYWjAzMm9aS2FGTHlueDllNnVicWRqVWZPVkJD?=
 =?utf-8?B?S3FWaG5RZFJ6Y3BURmV3cEtZa3M5Tm44MUI2clorUGdYL010Y01seG9hSG1q?=
 =?utf-8?B?QnJ5V2w1ZUtDbDljK1NMeTJBTStpWC8wUzZnRUZPM1QxVHN5Vldjd1pQUTJI?=
 =?utf-8?B?TGV0ckFvYnhSbWV2YnZCYWZUMEVHcThzNmllZGxERTlQa3V2bzMzTktHSzJq?=
 =?utf-8?B?NXBMbkhpNXY1Tm9MdCt1ZG9BYlcyNXZNdnV3bCt6R0dpYksyMERIOGVCQkN3?=
 =?utf-8?B?QitVRDNPNVlPazZFMXlzQlRBREI4ZWczK2p4dUNDZVl3SloydnVLN25kSEN6?=
 =?utf-8?B?a3B3RGRFRzRmS0lGaktZVkd3R2VxOFVqREo0RzU3RW82U0E5NDNuQmpPbVpx?=
 =?utf-8?B?K3NkVGFSVkdUREJ2UCtzQ3NjMThqMnZOK0FUdUpEK1JMWlhBUVB6RTFrenlG?=
 =?utf-8?B?UXJ5b2E2NENyZm44NE9TcVpUZnM0WXZkVlhTSUhmRXJKWXVNQXlvVlJlbEZi?=
 =?utf-8?B?ZU5aNWNxNGhraEhMYUI3c29hWkswWmhWOWxBWWp3N3dReFA1OGc3RUgwTHAw?=
 =?utf-8?B?Y0pRSWNuZTd6bnlVR2tFaXNXWWNVTklwNW1tTFkvRTRKYS8yazJGcDRPVDdY?=
 =?utf-8?B?Smpuclp2UUlLVXBOdXpKa2hsM0lodk5DV2RkR0pwd0h4aW5FVW1HNVZFREVR?=
 =?utf-8?Q?AsQl4i48yt7JM3OAWFyn8A/sbpMX65PcnSyDAAJ?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: caa5aaec-74bc-4b51-4fb0-08d91a9d8925
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 08:10:16.6425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xt+DfGivvzu4TrEltWeRRk2ePSuGK3yan5RmTsk8d6AsesbneR+0bKllXnTSQA/tehU5h4Gcq8m5PWPn8yit2e4r+R2mJw+8yTJK6qdmjXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB3992
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On 19.05.21 09:49, Joakim Zhang wrote:
> 
> Hi Frieder,
> 
>> -----Original Message-----
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>> Sent: 2021年5月18日 20:55
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Dave Taht
>> <dave.taht@gmail.com>
>> Cc: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
>> linux-arm-kernel@lists.infradead.org
>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>
>>
>>
>> On 18.05.21 14:35, Joakim Zhang wrote:
>>>
>>> Hi Dave,
>>>
>>>> -----Original Message-----
>>>> From: Dave Taht <dave.taht@gmail.com>
>>>> Sent: 2021年5月17日 20:48
>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>> Cc: Frieder Schrempf <frieder.schrempf@kontron.de>; dl-linux-imx
>>>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>> linux-arm-kernel@lists.infradead.org
>>>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>
>>>> On Mon, May 17, 2021 at 3:25 AM Joakim Zhang
>>>> <qiangqing.zhang@nxp.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> Hi Frieder,
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>>>> Sent: 2021年5月17日 15:17
>>>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; dl-linux-imx
>>>>>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>>>> linux-arm-kernel@lists.infradead.org
>>>>>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>>>
>>>>>> Hi Joakim,
>>>>>>
>>>>>> On 13.05.21 14:36, Joakim Zhang wrote:
>>>>>>>
>>>>>>> Hi Frieder,
>>>>>>>
>>>>>>> For NXP release kernel, I tested on i.MX8MQ/MM/MP, I can reproduce
>>>>>>> on
>>>>>> L5.10, and can't reproduce on L5.4.
>>>>>>> According to your description, you can reproduce this issue both
>>>>>>> L5.4 and
>>>>>> L5.10? So I need confirm with you.
>>>>>>
>>>>>> Thanks for looking into this. I could reproduce this on 5.4 and
>>>>>> 5.10 but both kernels were official mainline kernels and **not**
>>>>>> from the linux-imx downstream tree.
>>>>> Ok.
>>>>>
>>>>>> Maybe there is some problem in the mainline tree and it got
>>>>>> included in the NXP release kernel starting from L5.10?
>>>>> No, this much looks like a known issue, it should always exist after
>>>>> adding
>>>> AVB support in mainline.
>>>>>
>>>>> ENET IP is not a _real_ multiple queues per my understanding, queue
>>>>> 0 is for
>>>> best effort. And the queue 1&2 is for AVB stream whose default
>>>> bandwidth fraction is 0.5 in driver. (i.e. 50Mbps for 100Mbps and 500Mbps
>> for 1Gbps).
>>>> When transmitting packets, net core will select queues randomly,
>>>> which caused the tx bandwidth fluctuations. So you can change to use
>>>> single queue if you care more about tx bandwidth. Or you can refer to
>>>> NXP internal implementation.
>>>>> e.g.
>>>>> --- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>>>> +++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>>>> @@ -916,8 +916,8 @@
>>>>>                                          <&clk
>>>> IMX8MQ_CLK_ENET_PHY_REF>;
>>>>>                                 clock-names = "ipg", "ahb", "ptp",
>>>>>                                               "enet_clk_ref",
>>>> "enet_out";
>>>>> -                               fsl,num-tx-queues = <3>;
>>>>> -                               fsl,num-rx-queues = <3>;
>>>>> +                               fsl,num-tx-queues = <1>;
>>>>> +                               fsl,num-rx-queues = <1>;
>>>>>                                 status = "disabled";
>>>>>                         };
>>>>>                 };
>>>>>
>>>>> I hope this can help you :)
>>>>
>>>> Patching out the queues is probably not the right thing.
>>>>
>>>> for starters... Is there BQL support in this driver? It would be
>>>> helpful to have on all queues.
>>> There is no BQL support in this driver, and BQL may improve throughput
>> further, but should not be the root cause of this reported issue.
>>>
>>>> Also if there was a way to present it as two interfaces, rather than
>>>> one, that would allow for a specific avb device to be presented.
>>>>
>>>> Or:
>>>>
>>>> Is there a standard means of signalling down the stack via the IP layer (a
>> dscp?
>>>> a setsockopt?) that the AVB queue is requested?
>>>>
>>> AFAIK, AVB is scope of VLAN, so we can queue AVB packets into queue 1&2
>> based on VLAN-ID.
>>
>> I had to look up what AVB even means, but from my current understanding it
>> doesn't seem right that for non-AVB packets the driver picks any of the three
>> queues in a random fashion while at the same time knowing that queue 1 and 2
>> have a 50% limitation on the bandwidth. Shouldn't there be some way to prefer
>> queue 0 without needing the user to set it up or even arbitrarily limiting the
>> number of queues as proposed above?
> 
> Yes, I think we can. I look into NXP local implementation, there is a ndo_select_queue callback.
> https://eur04.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsource.codeaurora.org%2Fexternal%2Fimx%2Flinux-imx%2Ftree%2Fdrivers%2Fnet%2Fethernet%2Ffreescale%2Ffec_main.c%3Fh%3Dlf-5.4.y%23n3419&amp;data=04%7C01%7Cfrieder.schrempf%40kontron.de%7Ce4a99819cb6e444f598f08d91a9aad39%7C8c9d3c973fd941c8a2b1646f3942daf1%7C0%7C0%7C637570073897801363%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=S3HNVF8acDLJUJR89W1oI%2F28eTJhe18209l70eqVvXQ%3D&amp;reserved=0
> This is the version for L5.4 kernel.

Yes, this looks like it could solve the issue. Would you mind preparing a patch to upstream the change in [1]? I would be happy to test (at least the non-AVB case) and review.

Thanks
Frieder

[1] https://source.codeaurora.org/external/imx/linux-imx/commit?id=8a7fe8f38b7e3b2f9a016dcf4b4e38bb941ac6df
