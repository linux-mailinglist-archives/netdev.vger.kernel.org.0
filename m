Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D21388B62
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 12:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345568AbhESKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 06:13:27 -0400
Received: from mail-eopbgr40104.outbound.protection.outlook.com ([40.107.4.104]:31044
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239579AbhESKN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 06:13:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2xRAFzjBJgRt779QGD8fjDI3fAJONtPS5dzZ5UiO44ZXw8QSADrV3vMcFVfik71WlrQ/mmj57y5a63113IFhfkahGWgGC5Qr+imBIeFSQYOrCFS4rGtizA1juMnnPya+tHMT+nai4UaW7Ki21kjuKUMjYg0gAPbVNvF0vHWANbDCZupmFSc47YN21+nkXDMZxNTRToAjwn5ZWzVwwXB+dzS+4IZGfVEXR0c/KPe5I5bhCAf8gvLOWo+mX/cbXtfP7xN4fRdTcSO96bQcvlf7gEK5K8oMAwzmCI/OCaS3dIWcqbrI0wmB3i2WAstGBn6dbs1rqwV7YScAHUTxtxVaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX2J0D9yqzwZwjPNUCI2mgAzG5U1XHI+ApFLaacgZ8k=;
 b=DN0PeWw9w/0jEH3dMY6kMsGIDio83NRP32el0M6NFiAtTfVy4z4lvdPthWqsWruYNAaYo0LXsMUN3t6n5KhZfkaF8EbmKjndpfv/AcjUbJHdEU8xNFJU0lVc3RRugOgfCnPg65dCPTx4JH1YU90v8LD/n0tUUdyLm9E7dywDg2fkzZ6UeTeRC9iQgQQpegCrVAh7KOBHq+t/hxgDDYxTd3WVsXifFJyfjr9ZiyK2Vlj4eLew2XHJqwfwnsIQQgl6fn7AOAL2RX+NOVPmywsX2jCm9XmhDGO0nsuzbBlZgm1CCOpJ9SUUQIdsVuZ8K2+t0VpiSETzCTpc6D8jtFJNZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IX2J0D9yqzwZwjPNUCI2mgAzG5U1XHI+ApFLaacgZ8k=;
 b=f+v5usAfR2PdO0CzqZ7SLXLueZYiu3oXj7a0mENNy+CSsYA1fwCl0/Y9mfvNO2rFYzXDcEuz92uWa2fgpA8uVfJtmxOIggxsJsrh7I/mXLwlBTVWudXlDoPrIrW2QSvBfffkx4ZJ/PZn+F/pnKcaG4QrHn5iUFQyaaqgJgV8WiM=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4120.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 10:12:05 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 10:12:05 +0000
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
 <7db860f4-eca8-172f-490d-180cf599d64c@kontron.de>
 <DB8PR04MB6795BEDCA2995C1E88E2B5B7E62B9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <58930c74-c889-e9d2-f30f-bc9f47119820@kontron.de>
Date:   Wed, 19 May 2021 12:12:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <DB8PR04MB6795BEDCA2995C1E88E2B5B7E62B9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.244.189.149]
X-ClientProxiedBy: AM4PR05CA0002.eurprd05.prod.outlook.com (2603:10a6:205::15)
 To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.17] (89.244.189.149) by AM4PR05CA0002.eurprd05.prod.outlook.com (2603:10a6:205::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 10:12:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e7d375a-d916-4920-d26f-08d91aae8dba
X-MS-TrafficTypeDiagnostic: AM9PR10MB4120:
X-Microsoft-Antispam-PRVS: <AM9PR10MB41209D5626EDD3F75EFA23DBE92B9@AM9PR10MB4120.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nfpakh7JjQACi21+ZsROQ2FWnLLSVdCUfRbMBW1kJsWAJT2YUB10DCNrndL8C4kewQs1skKtVz2aJgVyYoKQ1OAKCMymWP7NBOlBXKCUiF81rKJMH8wToi83wvNEAb2gkbMnzgOaDXb290c7KWQFhPBhz8VfW8p0sPn6XtnNlcVCyIwyAibXaP5N4jMByomFnHvZP8zQgK8NoaIhzBQlOaRQEB+ZYo/CPKChAunylUx9pz265Q5XGUeeZXC9eDIMTmh6iOQ/c8JNegyijlUgnEFJc2vXlZy/iAQUB/jA7ujO17NkqIGy6qvWN+f3pEVi+9Be3BcPT91WECLT/2nHg2tSfZwLw8Ys1/o7hyCJmSEZ4xRsIwSslCvkVEm12/0saINqoB9t0Vtr58FImdJyWHB81AZt+6XueLm0BSYiA+wwPFGIRo81cPb3GcevepZB60ukLnaiBM6SymrftdzTTrdeMCiKJBvgLrDb611o4x61o2cGkj5zTwfu+SJLJS5x5/YxJCkxMBrqSLRDif7JuUH6IGHvOXSBp6Am9XH9OLFF2xYzNA8iudRRiPwbG7A3Lj5oDK2J30MRLSyF14BCRSLLBwB4w6BGPvJMkXT04T5RkgMU0GTm3BCu7uOUnRqX+jvJ0bv4AP6C95rEmra0Y7beZZ4dYhbWCjY3Segto7GRrNphkfrvW8vHqWTIKUeDva+q2wlMXldYUnY6srYAfT5W9dFWEOzbHAltpqMJndDWo6Ww97phzBVbBpPt5tz99KqP1IiPqfjTA5OjjRD4gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(956004)(8676002)(66556008)(45080400002)(4326008)(66476007)(2616005)(36756003)(44832011)(16576012)(26005)(66946007)(316002)(478600001)(110136005)(8936002)(2906002)(54906003)(53546011)(186003)(31696002)(16526019)(966005)(86362001)(5660300002)(38100700002)(6486002)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?gb2312?B?ZGNzTERzeTBCblYrMmJlQTFOSFdFTVpxdmErY0NHV0wrQ2RYczJzYk5tWDIw?=
 =?gb2312?B?WU9rVmExMTBpUG1xZnpnaW0ydGIwTmk2LytXcjRZVGEyUnhBZlRZUEVqMXoy?=
 =?gb2312?B?S0dCV0M5ZTJRMllJelpJbXppWExPcC9vTm9nMkdlajRjQzlBMkdLL3p2bFdS?=
 =?gb2312?B?OGRXY0tGbnBwRkIvUTNMVW5ELzVyQkdaWm1NZkF5TEM2TDFyYnl1MW9ZRzNX?=
 =?gb2312?B?SzQrWFBINHFFbXZDL1FwVS8ySkVFRVhsVnBKZTA2L25FRDRPclpmQVJPQ3Mz?=
 =?gb2312?B?dUpnT0ZoSXF6SVFHajNBVEtJYWc0K3U2L2JIWjNYbTFyU1FPVnlaL2tITW1x?=
 =?gb2312?B?N1Z6c2laYjBqdVpQbmwwSWZjR0Rmd1NGVDhKZ0ExUlBDS1V6N2I4aXovek5v?=
 =?gb2312?B?eHZ2WHBKUjlocGJZTmxwRHRyaG5WelZvVW9UQmRoSndBbUUzYWNWT1N4R3p3?=
 =?gb2312?B?VTlaMElSYTdPYjduNU9zUHVEMVk3dFVZTEZGL25JUjIxaVpqVTFlUVBLMGdx?=
 =?gb2312?B?YnVnTVJiWllFQlFtV1VEYkYwQmMwV3R6Q2RzSk9TWE9kRGdYYnhpTFdGMmRz?=
 =?gb2312?B?VWVtYjZpQ0tIWTZuMFFNMFFTN2gwa0RtV0wySEt2NjBBc3BXRjlnc0FRcnJn?=
 =?gb2312?B?MlBtbzZoUEJXUjNmeGpLQTluVkQwSHFDdWprR0psWXNYU2J4QmY1b0t6QzNy?=
 =?gb2312?B?Q3ZROG9YL0xZbHRadWdjVHlrZStTb1IyMmZJdTZVeEVHVyt6R3pzVVJYV08v?=
 =?gb2312?B?eG80WE9XQmIySU15WWttOHYwRjlPd3ZmTDVnazhVMGZHM20vcjQ4SFEzSXF3?=
 =?gb2312?B?OHozRmVVQ2lwOU9ZVUY0bms0cmMyQXRZaGN4Rm5BR2xSK0kwYk93OXV5Y2E3?=
 =?gb2312?B?ZmR1VXIzNWp2VWM4S291TnIyRWY2YXVZajdnTityK2h4eTdqdENSR3RnWEMw?=
 =?gb2312?B?ckhZTjRQYkc0RXN4SlNzeUI2L2Q4L2tINXp5TW0zV09hWCt1THRxcEk1NVZl?=
 =?gb2312?B?MUNHZUFPZUNhcm5wZU9VOElsSDMxMnJ2Y0pqZWI3Rkt4aFhkR3psb1VrN0ky?=
 =?gb2312?B?MVJhem1WajZ1OXV3MEMzSnErcVlkTDhhcTJTdkU5U0RXQUxiL3c4WW5qcW1M?=
 =?gb2312?B?cXVkeU1PMkxIRm9mcGgwcVlsN0o5M1V5cm5uZFBxMGhudy9ZVzVGaTM2MXFX?=
 =?gb2312?B?dHdrRjlRcFR5dVZTSkpoR0RtQmhvcWcvalFZS21jZGZjNFRiVGgyLzBnV3Nm?=
 =?gb2312?B?MllsV1diZ0VYVEJIbmlYUHRFaEhaODNZYzhOVXFEQlkvL2lBRDAzUzFoWUp5?=
 =?gb2312?B?djIyUTlmS1pwdUZiZXBrL0tnUVE5cVNXM2RBZXloWTI0d2w2dkpwR0ZyalJy?=
 =?gb2312?B?ak1vbklnTDR2VFNQY3hEaHFTOG9GcXVQQ1ZwRVM2L2NiVjRvczArNnJHdHNk?=
 =?gb2312?B?aWwvclBISGZUY1Jobng0N1hiUTJnbmtnenQydjJtQ1JBUkpIM2pMR0Z1YW44?=
 =?gb2312?B?QVhpME9sQnBaL0VmK3lwZXQ5QVhueUpEa0tYWVNQczJvclRmcWVQeVltS0g4?=
 =?gb2312?B?cms3UUdvWi9MeXE1aFJCaTR0Yk1GeFdIVWhxYlVBbERuSW1NeHJyLzJmSVBN?=
 =?gb2312?B?UUpXY3hlY2d1TUlKWlI1U21tN1RkQUxoZEt5OG5DVTNlZzRla1R0Z3dJN2hH?=
 =?gb2312?B?cEM0MlJnY2lzWlN5YXlJcWxpS3JtWFI3anlnM1pwN0wwWkRydFA3N2t1RE5N?=
 =?gb2312?Q?J6HARvWuNoVvuK1U6eP6/ewpvT0TkP6/BZfHOD6?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7d375a-d916-4920-d26f-08d91aae8dba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 10:12:05.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAi9XFMJSQmP/rc/18HLcxsi9D63WBKbW3e2xUOSYdeR/LEIo1StFS4/ioiLn2PiLtKYVyN0ktxmVxNQ/at1CBQDxOCyADlt7j3gQFpWjUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.05.21 10:40, Joakim Zhang wrote:
> 
> Hi Frieder,
> 
>> -----Original Message-----
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>> Sent: 2021年5月19日 16:10
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Dave Taht
>> <dave.taht@gmail.com>
>> Cc: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
>> linux-arm-kernel@lists.infradead.org
>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>
>> Hi Joakim,
>>
>> On 19.05.21 09:49, Joakim Zhang wrote:
>>>
>>> Hi Frieder,
>>>
>>>> -----Original Message-----
>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>> Sent: 2021年5月18日 20:55
>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Dave Taht
>>>> <dave.taht@gmail.com>
>>>> Cc: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>> linux-arm-kernel@lists.infradead.org
>>>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>
>>>>
>>>>
>>>> On 18.05.21 14:35, Joakim Zhang wrote:
>>>>>
>>>>> Hi Dave,
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Dave Taht <dave.taht@gmail.com>
>>>>>> Sent: 2021年5月17日 20:48
>>>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>>> Cc: Frieder Schrempf <frieder.schrempf@kontron.de>; dl-linux-imx
>>>>>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>>>> linux-arm-kernel@lists.infradead.org
>>>>>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>>>
>>>>>> On Mon, May 17, 2021 at 3:25 AM Joakim Zhang
>>>>>> <qiangqing.zhang@nxp.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>> Hi Frieder,
>>>>>>>
>>>>>>>> -----Original Message-----
>>>>>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>>>>>> Sent: 2021年5月17日 15:17
>>>>>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; dl-linux-imx
>>>>>>>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>>>>>> linux-arm-kernel@lists.infradead.org
>>>>>>>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>>>>>
>>>>>>>> Hi Joakim,
>>>>>>>>
>>>>>>>> On 13.05.21 14:36, Joakim Zhang wrote:
>>>>>>>>>
>>>>>>>>> Hi Frieder,
>>>>>>>>>
>>>>>>>>> For NXP release kernel, I tested on i.MX8MQ/MM/MP, I can
>>>>>>>>> reproduce on
>>>>>>>> L5.10, and can't reproduce on L5.4.
>>>>>>>>> According to your description, you can reproduce this issue both
>>>>>>>>> L5.4 and
>>>>>>>> L5.10? So I need confirm with you.
>>>>>>>>
>>>>>>>> Thanks for looking into this. I could reproduce this on 5.4 and
>>>>>>>> 5.10 but both kernels were official mainline kernels and **not**
>>>>>>>> from the linux-imx downstream tree.
>>>>>>> Ok.
>>>>>>>
>>>>>>>> Maybe there is some problem in the mainline tree and it got
>>>>>>>> included in the NXP release kernel starting from L5.10?
>>>>>>> No, this much looks like a known issue, it should always exist
>>>>>>> after adding
>>>>>> AVB support in mainline.
>>>>>>>
>>>>>>> ENET IP is not a _real_ multiple queues per my understanding,
>>>>>>> queue
>>>>>>> 0 is for
>>>>>> best effort. And the queue 1&2 is for AVB stream whose default
>>>>>> bandwidth fraction is 0.5 in driver. (i.e. 50Mbps for 100Mbps and
>>>>>> 500Mbps
>>>> for 1Gbps).
>>>>>> When transmitting packets, net core will select queues randomly,
>>>>>> which caused the tx bandwidth fluctuations. So you can change to
>>>>>> use single queue if you care more about tx bandwidth. Or you can
>>>>>> refer to NXP internal implementation.
>>>>>>> e.g.
>>>>>>> --- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>>>>>> +++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>>>>>> @@ -916,8 +916,8 @@
>>>>>>>                                          <&clk
>>>>>> IMX8MQ_CLK_ENET_PHY_REF>;
>>>>>>>                                 clock-names = "ipg", "ahb",
>> "ptp",
>>>>>>>
>> "enet_clk_ref",
>>>>>> "enet_out";
>>>>>>> -                               fsl,num-tx-queues = <3>;
>>>>>>> -                               fsl,num-rx-queues = <3>;
>>>>>>> +                               fsl,num-tx-queues = <1>;
>>>>>>> +                               fsl,num-rx-queues = <1>;
>>>>>>>                                 status = "disabled";
>>>>>>>                         };
>>>>>>>                 };
>>>>>>>
>>>>>>> I hope this can help you :)
>>>>>>
>>>>>> Patching out the queues is probably not the right thing.
>>>>>>
>>>>>> for starters... Is there BQL support in this driver? It would be
>>>>>> helpful to have on all queues.
>>>>> There is no BQL support in this driver, and BQL may improve
>>>>> throughput
>>>> further, but should not be the root cause of this reported issue.
>>>>>
>>>>>> Also if there was a way to present it as two interfaces, rather
>>>>>> than one, that would allow for a specific avb device to be presented.
>>>>>>
>>>>>> Or:
>>>>>>
>>>>>> Is there a standard means of signalling down the stack via the IP
>>>>>> layer (a
>>>> dscp?
>>>>>> a setsockopt?) that the AVB queue is requested?
>>>>>>
>>>>> AFAIK, AVB is scope of VLAN, so we can queue AVB packets into queue
>>>>> 1&2
>>>> based on VLAN-ID.
>>>>
>>>> I had to look up what AVB even means, but from my current
>>>> understanding it doesn't seem right that for non-AVB packets the
>>>> driver picks any of the three queues in a random fashion while at the
>>>> same time knowing that queue 1 and 2 have a 50% limitation on the
>>>> bandwidth. Shouldn't there be some way to prefer queue 0 without
>>>> needing the user to set it up or even arbitrarily limiting the number of
>> queues as proposed above?
>>>
>>> Yes, I think we can. I look into NXP local implementation, there is a
>> ndo_select_queue callback.
>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsour
>>>
>> ce.codeaurora.org%2Fexternal%2Fimx%2Flinux-imx%2Ftree%2Fdrivers%2Fnet
>> %
>>>
>> 2Fethernet%2Ffreescale%2Ffec_main.c%3Fh%3Dlf-5.4.y%23n3419&amp;data=
>> 04
>>> %7C01%7Cqiangqing.zhang%40nxp.com%7Cd83917f3c76c4b6ef80008d91a9
>> d8a28%7
>>>
>> C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637570086193978287%
>> 7CUnkno
>>>
>> wn%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
>> WwiL
>>>
>> CJXVCI6Mn0%3D%7C1000&amp;sdata=pQuGAadGzM8GhYsVl%2FG%2BPJSCZ
>> RRvbwhuLy9
>>> g30bn3ok%3D&amp;reserved=0
>>> This is the version for L5.4 kernel.
>>
>> Yes, this looks like it could solve the issue. Would you mind preparing a patch to
>> upstream the change in [1]? I would be happy to test (at least the non-AVB
>> case) and review.
> 
> Yes, I can have a try. I saw this patch has been staying in downstream tree for many years, and I don't know the history.
> Anyway, I will try to upstream first to see if anyone has comments.

Thanks, that would be great. Please put me on cc if you send the patch.

Just for the record:

When I set fsl,num-tx-queues = <1>, I do see that the bandwidth-drops don't occur anymore. When I instead apply the queue selection patch from the downstream kernel, I also see that queue 0 is always picked for my untagged traffic. In both cases bandwidth stays just as high as expected (> 900 Mbit/s).
