Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E1938794C
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349457AbhERM46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 08:56:58 -0400
Received: from mail-db8eur05on2135.outbound.protection.outlook.com ([40.107.20.135]:49120
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349474AbhERM4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 08:56:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFIrFzcEzRctM4m2UqZNttF3qXqNj/SwqHVvOkICZIJTrSHXyORkcc/e0ihaUp5m3XYMAg9jQhBajFruKZrpRmcMw9wn+JwV49W9avG8V7VFxu4MByWEgDBSW/1v+MmcpRIRgVcuoe21FW0MRJxRhcG3ZxM6Y9PmjDd2zDfiLpDPNcXFyRDFpb0C/PxIoXXUDJVmtjk3JDyB0WnErDQueE8e4C13+Y7b3YahwDH2yP5fc3kqNyZoSCihf7T8ZapSeI+OjbN62rGJeDHHuJLYE3+gIQehld73mfOYCMxDAJXZjFEEEA63ph/S9XxFdfPGZKUhKqoGpEeHzgE9OlqHtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8o55QXD0/X0BTC/tkGDBuIvxh6+GRD/5+TdVug754U=;
 b=MjshJNahOJ6h09XMBGyGdwoAhIXQloNNuCJTTGbHbvMhebV+dzaXTUX/6oxG5IBgdwgJ+aLtLZUfTVvBujf6cxcun/D/YBcPlFnn1+J2R4mYKJ7PM2HqhctG39MbkhC+wVjv03yVh37B0xw17wq3CYA/+QpAokhPx/VWP6K4w+iuPZHS+1Dh3P6rcu5bWEj2d0hLZG18qjBYFbW6dMutaHtM+jVFO2hODGVN9JKNeYvF+LpQu51OU+FvObBAD8TPo3SsBE643qGtumReQ3mt6tXxSEv4h6fpD/7POkTrMND9p5UiZsJCdlSiyhuY7LSTsWD8ksxKyc29DhV6HjUF2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8o55QXD0/X0BTC/tkGDBuIvxh6+GRD/5+TdVug754U=;
 b=QlB3vxg2K3VkVu1JmnS8oirgjmy1O+sd9RZkhcnGAwhSElQMUuIIvstYxJ1gWMGCmfNZfrIPvW4dif9ZcFJL0Rp3ovN+Cy4J9h6OkuIsH/LIqm95Uy2qFiS9dIq6G9+n4ZQBVCMyj1oRjAV1xNoS2CK9FYQdt/MwPYnQ0N9skbg=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3554.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Tue, 18 May
 2021 12:55:24 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 12:55:24 +0000
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
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <9b9cd281-51c7-5e37-7849-dd9814474636@kontron.de>
Date:   Tue, 18 May 2021 14:55:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <DB8PR04MB6795DD09B08C29C89C418E4EE62C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [77.246.119.226]
X-ClientProxiedBy: AM9P193CA0018.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::23) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.103.119] (77.246.119.226) by AM9P193CA0018.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 12:55:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34eb5ad3-3244-4d1c-0f0c-08d919fc33da
X-MS-TrafficTypeDiagnostic: AM0PR10MB3554:
X-Microsoft-Antispam-PRVS: <AM0PR10MB35543B6FAB8630F44B70E942E92C9@AM0PR10MB3554.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHDiqF18v688Z+FgcV9kT3PsvqDk5JgbAzWXoh03bS10Q3K8NdCoUOVdSEf49fvdDSsbjbQDKlB42hkI3dPFo5NoToN4IgVI+1hKcenBWM/fa/5/6EqnjNH4PX9/pGLFI8VZubmyPN0e/M+MfPrs8Dvq0GKLiKWl93Gn+Mu4VAcTpszGFI0PUp9VWZF4uTiBVBlU1VS2lSGMVE95ClNIB/uRMvlE3qXKpXEC5HGCasoFe+6GHz6bk95B3GpzWL/B8N8ghU6haWYykFMSpP496Mh3iA8fU3JirY0RYPbZ6dCYddtKYs+vi8K5owTkSCW9tMqQy0LTEkAtbAmTZafQDwPEklATZgssrbW5c1vA6of28YtwHOBK2C9RLUBbwDdoLa7n4byyB/6GbX0min2b4/Jo7gATxmG6F7lPgMETnbtvTG70viGx4550oiRmftlbK6NnGhG0ybNH9hcybjvEa4zNWESG1FWgXpuDjrisP3pvdAVvksHwtiMGsLU3//zbNmjsjYnPyjt9KIwkEz0FBJYgrybo/HSZFpzNfmXwZ8WelJg0fV+cdP0WmIbtr++ztzwNuo5zWeRE45d4baU34NBb0uTKdxS2DNwk/qcAKSx9Ifn3tzLA1zEThtobZcMs7oBUrQ4+p3X1lrjUPJ4k73o3gr56HEE3aZUxqaGMIZUePbdSh7uKgZeawp437W9QaiqbF52m3bJ+NivZiZ7yPnEZH+WgG21qV+MZSMQ3vcEQ1izS8wQae1Rtm+mMaQ+zZ4yfWMG1Vjki9dLglmJxyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(44832011)(6486002)(8936002)(5660300002)(956004)(186003)(478600001)(45080400002)(4326008)(16526019)(16576012)(316002)(66574015)(110136005)(66946007)(26005)(8676002)(83380400001)(54906003)(66476007)(966005)(66556008)(31696002)(86362001)(53546011)(38100700002)(2616005)(31686004)(2906002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ek5TMFRtdUVvdFFkQjgzT2FwR3lJK1VJaEhzODdNTUhnVStGdThyKzNQRDFS?=
 =?utf-8?B?T2RnUmRiZTFocUZuanZLTDBVOUZGcUQ5UU9HK2l3V3FjTkVheENnaFFFWlox?=
 =?utf-8?B?QkpZdjh4T2s1SGFQMlpxTFhLTXd0Z2lkenpxMHdqalJPTTg2M1lPejl1S2Qx?=
 =?utf-8?B?QmQwampEMUZ1M0VheDQ4c2pyamlCeUk4dmtnWTJucEFLTVpkb1crd0swSzNr?=
 =?utf-8?B?WXI1aVJNY2g4VEVBYTJtanQ4c04xOWhGVitkazFFNDQ2RjlGL2dUMEE4QWpj?=
 =?utf-8?B?UUF1MEpPWUh4Tm5oSTE4bm9OZ280WkdnOFdLbWxVOTNtVExDNG1DRnQyaUk5?=
 =?utf-8?B?a3dEOVJmNGRqSklrVlUxY2FTRUVna3RXWFFpVHpycDFDem95ajR6dFlac1VD?=
 =?utf-8?B?NU0zUlIrY3NwdVFyZmlmaVhDWE00R0tZZWJGa1NqY1pXSy9Td3N2bHAybk40?=
 =?utf-8?B?UTRIZkFzS3ZQTFVJSXp4YThMYW9GeWJ3UGlMbkRkb1ZncENqT3FXeGtmeVFK?=
 =?utf-8?B?VE1qOU9STUtORzcwZTc4VTVLUGcxMEVxOUhFdUdlQm1oQXNidW5iSHlJSXd1?=
 =?utf-8?B?RnZmUVdQSkZ0cllka3F0TlBJdUpENmZTMnhCaC8yL3B4WWhhQ2RVUFJnNGFj?=
 =?utf-8?B?T1Y5V1JWWTBSTU9CRFJCT2dlNFlKWjRMb0RBeVd4TDIzYnVXd3dQd2lwSVRk?=
 =?utf-8?B?azJKcklEUzU1Sms1dVlxZHRja3pqUTFERXVxbnhHYWNCdE9VdjMxc002WTZl?=
 =?utf-8?B?VWRRNmhEYUtwWjZENEtaRXR1RzlrMjFpOVQzT3R0ZGVSMFNRNURoOHNFVllU?=
 =?utf-8?B?YUJLSW9tWEkwRXJ4TldteXZ0OTV0YTlud2E5L2ticFg3dEsrT1RFenREK1Iy?=
 =?utf-8?B?aTdLeEJUdlg2WlVNSTZXZytVMGlYUzcrSWJYUVBJYllBUUptbzZDTWFXbEpW?=
 =?utf-8?B?TEc1cGpyZHpvYlRSeFFvWHZueXVPUWJjQ3U5NXVEMFBkQmx5dmhHbUFDdk9n?=
 =?utf-8?B?ZGlHaUhMbmFpWXBoRFBNclowS2JTUnNZNHdJN3dIYXU0UG9NdmZvNDlkUjU0?=
 =?utf-8?B?cFErNzFSUXVmcUlWODJmcmRKNWpFOFBDc0xmZDZjNklpdmJjc0QzWTZ4OW4v?=
 =?utf-8?B?Z0J0bElCTzBmOGw4MWMyOUZBQWJJTGVjNzI5cHJieEQ5MnBhcWtyQ0Z0SExU?=
 =?utf-8?B?L25UQVNZYXQ3TFJLN1ZLaEMzYjUyUTk2aVBkNGluYUNVRGVCYW9IbkozOEto?=
 =?utf-8?B?WjhCcmhiT21JRnVidXEvN3dnV1c1U3p0ZDREQ1NtNTc2SC9NVXM0ZXl4VVlJ?=
 =?utf-8?B?ZkZWaUVpcWJLU2FpSS9CeDZ2VlJRdU0xTitJTE9LUG5mVjRjNldKM0dma0VL?=
 =?utf-8?B?aGdtL3JacHdmODZ6WUJVaTBwd01YeEVzVXZCNHpFYU1BQUxKVzYzWWVHVTNS?=
 =?utf-8?B?Ly9vS2x4YXdOZ2FjRnRqZEFveHlDVkozbHhvLzZjK2x6OG5ReU1JRWxYTUN5?=
 =?utf-8?B?cWNjUng5V0tBdnZEVEQvamErcGRuYnlSa2dnd0dBVW1sVDBpVk9IUzBLN05L?=
 =?utf-8?B?QXZmU1dKaERFSTZkK1ltOHFGUDN4MVpPZDlPMG41c2tmWHE2dWFrSWhpbkV6?=
 =?utf-8?B?VWwzUVdUZjB0QlpLK3RJNjZBZlZCN0w1NlZFMHZzeFFicXRrcHU1dkJtOVpD?=
 =?utf-8?B?MDZWWFpENU5vKzhFZ1pHWG9xRmkxU1pzMFdoODdxTUZvejNHSVQrdkZBOFdW?=
 =?utf-8?Q?tKUjFf++32JuEkg7muXV3n4amQnVkxwfPZDGjWQ?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 34eb5ad3-3244-4d1c-0f0c-08d919fc33da
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 12:55:24.3606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmrCCvtjZcyWcbF9dG89AC/hKJBOdMJIDmP07vHTO78waPrCISKXm2N9pv4g+OVu+h/5vQ3lm2z91MBOs8FCE37j+0/XlZp9lLatlDGOlNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3554
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.05.21 14:35, Joakim Zhang wrote:
> 
> Hi Dave,
> 
>> -----Original Message-----
>> From: Dave Taht <dave.taht@gmail.com>
>> Sent: 2021年5月17日 20:48
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: Frieder Schrempf <frieder.schrempf@kontron.de>; dl-linux-imx
>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>> linux-arm-kernel@lists.infradead.org
>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>
>> On Mon, May 17, 2021 at 3:25 AM Joakim Zhang <qiangqing.zhang@nxp.com>
>> wrote:
>>>
>>>
>>> Hi Frieder,
>>>
>>>> -----Original Message-----
>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>> Sent: 2021年5月17日 15:17
>>>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; dl-linux-imx
>>>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>> linux-arm-kernel@lists.infradead.org
>>>> Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>
>>>> Hi Joakim,
>>>>
>>>> On 13.05.21 14:36, Joakim Zhang wrote:
>>>>>
>>>>> Hi Frieder,
>>>>>
>>>>> For NXP release kernel, I tested on i.MX8MQ/MM/MP, I can reproduce
>>>>> on
>>>> L5.10, and can't reproduce on L5.4.
>>>>> According to your description, you can reproduce this issue both
>>>>> L5.4 and
>>>> L5.10? So I need confirm with you.
>>>>
>>>> Thanks for looking into this. I could reproduce this on 5.4 and 5.10
>>>> but both kernels were official mainline kernels and **not** from the
>>>> linux-imx downstream tree.
>>> Ok.
>>>
>>>> Maybe there is some problem in the mainline tree and it got included
>>>> in the NXP release kernel starting from L5.10?
>>> No, this much looks like a known issue, it should always exist after adding
>> AVB support in mainline.
>>>
>>> ENET IP is not a _real_ multiple queues per my understanding, queue 0 is for
>> best effort. And the queue 1&2 is for AVB stream whose default bandwidth
>> fraction is 0.5 in driver. (i.e. 50Mbps for 100Mbps and 500Mbps for 1Gbps).
>> When transmitting packets, net core will select queues randomly, which
>> caused the tx bandwidth fluctuations. So you can change to use single queue if
>> you care more about tx bandwidth. Or you can refer to NXP internal
>> implementation.
>>> e.g.
>>> --- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>> +++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
>>> @@ -916,8 +916,8 @@
>>>                                          <&clk
>> IMX8MQ_CLK_ENET_PHY_REF>;
>>>                                 clock-names = "ipg", "ahb", "ptp",
>>>                                               "enet_clk_ref",
>> "enet_out";
>>> -                               fsl,num-tx-queues = <3>;
>>> -                               fsl,num-rx-queues = <3>;
>>> +                               fsl,num-tx-queues = <1>;
>>> +                               fsl,num-rx-queues = <1>;
>>>                                 status = "disabled";
>>>                         };
>>>                 };
>>>
>>> I hope this can help you :)
>>
>> Patching out the queues is probably not the right thing.
>>
>> for starters... Is there BQL support in this driver? It would be helpful to have on
>> all queues.
> There is no BQL support in this driver, and BQL may improve throughput further, but should not be the root cause of this reported issue.
> 
>> Also if there was a way to present it as two interfaces, rather than one, that
>> would allow for a specific avb device to be presented.
>>
>> Or:
>>
>> Is there a standard means of signalling down the stack via the IP layer (a dscp?
>> a setsockopt?) that the AVB queue is requested?
>>
> AFAIK, AVB is scope of VLAN, so we can queue AVB packets into queue 1&2 based on VLAN-ID.

I had to look up what AVB even means, but from my current understanding it doesn't seem right that for non-AVB packets the driver picks any of the three queues in a random fashion while at the same time knowing that queue 1 and 2 have a 50% limitation on the bandwidth. Shouldn't there be some way to prefer queue 0 without needing the user to set it up or even arbitrarily limiting the number of queues as proposed above?

> 
> Best Regards,
> Joakim Zhang
>>> Best Regards,
>>> Joakim Zhang
>>>> Best regards
>>>> Frieder
>>>>
>>>>>
>>>>> Best Regards,
>>>>> Joakim Zhang
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Joakim Zhang <qiangqing.zhang@nxp.com>
>>>>>> Sent: 2021年5月12日 19:59
>>>>>> To: Frieder Schrempf <frieder.schrempf@kontron.de>; dl-linux-imx
>>>>>> <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>>>> linux-arm-kernel@lists.infradead.org
>>>>>> Subject: RE: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>>>
>>>>>>
>>>>>> Hi Frieder,
>>>>>>
>>>>>> Sorry, I missed this mail before, I can reproduce this issue at
>>>>>> my side, I will try my best to look into this issue.
>>>>>>
>>>>>> Best Regards,
>>>>>> Joakim Zhang
>>>>>>
>>>>>>> -----Original Message-----
>>>>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>>>>> Sent: 2021年5月6日 22:46
>>>>>>> To: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
>>>>>>> linux-arm-kernel@lists.infradead.org
>>>>>>> Subject: i.MX8MM Ethernet TX Bandwidth Fluctuations
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> we observed some weird phenomenon with the Ethernet on our
>>>>>>> i.MX8M-Mini boards. It happens quite often that the measured
>>>>>>> bandwidth in TX direction drops from its expected/nominal value
>>>>>>> to something like 50% (for 100M) or ~67% (for 1G) connections.
>>>>>>>
>>>>>>> So far we reproduced this with two different hardware designs
>>>>>>> using two different PHYs (RGMII VSC8531 and RMII KSZ8081), two
>>>>>>> different kernel versions (v5.4 and v5.10) and link speeds of 100M and
>> 1G.
>>>>>>>
>>>>>>> To measure the throughput we simply run iperf3 on the target
>>>>>>> (with a short p2p connection to the host PC) like this:
>>>>>>>
>>>>>>>   iperf3 -c 192.168.1.10 --bidir
>>>>>>>
>>>>>>> But even something more simple like this can be used to get the
>>>>>>> info (with 'nc -l -p 1122 > /dev/null' running on the host):
>>>>>>>
>>>>>>>   dd if=/dev/zero bs=10M count=1 | nc 192.168.1.10 1122
>>>>>>>
>>>>>>> The results fluctuate between each test run and are sometimes 'good'
>>>> (e.g.
>>>>>>> ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s
>>>>>>> for 100M
>>>>>> link).
>>>>>>> There is nothing else running on the system in parallel. Some
>>>>>>> more info is also available in this post: [1].
>>>>>>>
>>>>>>> If there's anyone around who has an idea on what might be the
>>>>>>> reason for this, please let me know!
>>>>>>> Or maybe someone would be willing to do a quick test on his own
>>>> hardware.
>>>>>>> That would also be highly appreciated!
>>>>>>>
>>>>>>> Thanks and best regards
>>>>>>> Frieder
>>>>>>>
>>>>>>> [1]:
>>>>>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%
>>>>>>> 2Fco
>>>>>>> mm
>>>>>>> u
>>>>>>>
>>>>>>
>>>>
>> nity.nxp.com%2Ft5%2Fi-MX-Processors%2Fi-MX8MM-Ethernet-TX-Bandwidth-
>>>>>>>
>>>>>>
>>>>
>> Fluctuations%2Fm-p%2F1242467%23M170563&amp;data=04%7C01%7Cqiang
>>>>>>>
>>>>>>
>>>>
>> qing.zhang%40nxp.com%7C5d4866d4565e4cbc36a008d9109da0ff%7C686ea1d
>>>>>>>
>>>>>>
>>>>
>> 3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637559091463792932%7CUnkno
>>>>>>>
>>>>>>
>>>>
>> wn%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
>>>>>>>
>>>>>>
>>>>
>> WwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ygcThQOLIzp0lzhXacRLjSjnjm1FEj
>>>>>>> YSxakXwZtxde8%3D&amp;reserved=0
>>
>>
>>
>> --
>> Latest Podcast:
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.lin
>> kedin.com%2Ffeed%2Fupdate%2Furn%3Ali%3Aactivity%3A6791014284936785
>> 920%2F&amp;data=04%7C01%7Cqiangqing.zhang%40nxp.com%7Cd11b7b331
>> db04c41799908d91932059b%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%
>> 7C0%7C637568524896127548%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4w
>> LjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&am
>> p;sdata=IPW1MPLSnitX0HUttdLtZysknzokRN5fYVPXrbJQhaY%3D&amp;reserve
>> d=0
>>
>> Dave Täht CTO, TekLibre, LLC
