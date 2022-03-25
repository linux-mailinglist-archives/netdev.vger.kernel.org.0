Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0DC4E7006
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 10:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiCYJe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 05:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344774AbiCYJe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 05:34:58 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150074.outbound.protection.outlook.com [40.107.15.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67362DD3
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 02:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD98knxVQl3JePYFhmIdTrw+DiwKeIpY46NRHKDJ9hSOpHbLOEa3U9CN5utTPJ1hbzhZw1Y1jegmtopfNGZWX8TWwtmmWr11Cto8YhiJsl+K76mdoCWuetBeNXjwcWXmavI4Sz4S9mWbdpv4e9BlGLiCNtDSPn7d4rSzmFaWxKvMVmbRd4YovwqXaVM9yaPLhizYbJSjaoeGKjRAyHcPQPsqkvP6Vyb9sk276tDYZCl6oYpB7+6mAGJxNn2D6Z1Rgpv3JZ6jvELcBKj+NEUocBsf76qYRtrV6xqo081M19NOX/FePV5X4zxZeoTIzFdYEZNuX+rjtdLRQQGicZ7fGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYFbO6sJS9CcI/kHUWX41In8b9lvvKC5TtcQ8BsJb04=;
 b=K4e500zHtB8e1D7FGV032mvlKoUqczoo1qXWsQdn/KjoNOLZzYUL2H2hnnPcUSJu4Uu8b5wczlnmNF/zr+UBD3zKHwqDWArc7a7HrZWhBggHftmJbbvc9vCF2xHj0FMNBADPLT7eEXrJ6KP6l9Z0n5D2Q4t70eRaUl9BT3788sDey9sJW6an4H7C0edWSAvknOHOHL6hGnqCU5UCeoOg0s1C5jbl/UUtfhoPgHh0BoaR8ghMQv6C/E9i1GG750q7zPadUojBHAVfaYQAt3A7BH9uMNxJxZcf3KiIAImQvsPUzeSH5ohtTBgg0Tt0MGG2yCoI/QhtkWaaIzdI1uqHTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYFbO6sJS9CcI/kHUWX41In8b9lvvKC5TtcQ8BsJb04=;
 b=UXkWUo7riiwgIrN8YdvX1r/SCkwzoJQzCP/+exd+2Mru60beg90GyQv3t6W7tmXwiLpxTyUDk9PdJbXgvbAr9Vy1LAsLvyVlfItY9KiqKnp3TPtFddAX33+IQxvFO2/fXR3D58A8lR5faUTnxDYnArxWi7WrETKqqX0bP7X1Oia/hMT/DqPpCGF1rYTxLxzmzjE7Ttdc0+sx/RMQ8mayYdyPx5onotgEzUwSxKC9YexERc7Zhx4oR3CWq/ilukrGj9sgT+5RrNzn2NXW0eHo7fp4/VYogtDp9gKPp2V/CzzVuZucfPCNNgsKgEdl6H9yITavQz3ubvyKmtJDururdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM0PR06MB5524.eurprd06.prod.outlook.com (2603:10a6:208:111::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 09:33:18 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8%7]) with mapi id 15.20.5081.025; Fri, 25 Mar 2022
 09:33:18 +0000
Message-ID: <13e7ebb1-2006-f22c-3708-caf4003779d1@vaisala.com>
Date:   Fri, 25 Mar 2022 11:33:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v3] net: macb: restart tx after tx used bit read
Content-Language: en-US
To:     Claudiu.Beznea@microchip.com, robert.hancock@calian.com,
        kuba@kernel.org
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
 <20220323080820.137579-1-tomas.melin@vaisala.com>
 <20220323084324.37001694@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <14152644-c44f-a011-7f26-331868831e4f@microchip.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <14152644-c44f-a011-7f26-331868831e4f@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0083.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::11) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f2c8ed2-cae3-405c-8e34-08da0e427e8d
X-MS-TrafficTypeDiagnostic: AM0PR06MB5524:EE_
X-Microsoft-Antispam-PRVS: <AM0PR06MB55246BDD252303B7AD067346FD1A9@AM0PR06MB5524.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UQEjdGHhJ9/xdQKPTGc3SXc/D6466DlTgsH/rzt1LCWB9JHGwq5/4wDCzvGuk4eie+zlxJ0KGJ4hgRBXtjIwFH66VCt3f+h2Ug9KddvcKBe1q9Q+74clCZzdVgpm9mJStLM5c4gS8r0lfh/IYlMB1Q8lnL/zeFQQ9w3TXpX4dWHDHREfCg1EBU9XZRQJ58oIfFL2DqJjawFlYiPwBzzLLeU2kAWHQhNt+7XxmV7wOlCGa4NzK4h9pV388O3CkK8hnVVcq1xvrXVAa21uDin+MOHEYa8Cqs6PL37++NH8OkYPo2OxwHXhaVFA5pfdmOvwJyZ/O20TzM1yOJGHa4fXq71EXQzC89aR0M0JQXG2RX2qAr+l6UxDNZA+FafUkIKwBTJEjVyH4KdACg8zc/JIuI2jC5YkMbWiLPqTOzshNqZ5H/qxTChh0QFczWZnKNwcIgENtuBv5QxWz4vABqRY0lzwr4yelIV5hpb/AjCJ2373mLxoJZRk5pSOqUIZMG2zJMAkhmSPv3MjhA7XztcgzCDFT+3PE2zAH4YMalkHYIyUsoE0lshN8KQbwtTej9afmnXfbFs17wYeiU62u77K14WqpzthMTRsv/hHyVmKXhHK5ztRPRB9MLYTuzqvetF8b0Rr2ZNvmbopNGXcnKPU6Z1ZgfyS4aHT+CDvYpCDT+7TvwkC0gG/suhSJRPOm80Pc6U25RXlefmoWALpifHuQ6feHZEsYOx8GhQkijezSI6y2kj3hSCCcmJCMGkjACGmmkBpJp3qgd6ecOY2jMD/7HGyTwrHlf+b4qTu681zMo0HYuh12BJGzGf838/5Gh4M2HFSyHZhIyz1BoAgFhFaHg7z90CMlygeXSgkpfPcfs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(86362001)(66476007)(8936002)(38350700002)(38100700002)(26005)(186003)(83380400001)(5660300002)(44832011)(66556008)(36756003)(66946007)(31686004)(2906002)(52116002)(8676002)(4326008)(6506007)(2616005)(45080400002)(6666004)(53546011)(6512007)(508600001)(966005)(6486002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTlYTzJLckUweDVjcEl1RGhrbGRLTVhDbXBLTU4rTWZGVk1Ic0MrVExYT0o1?=
 =?utf-8?B?c2dYUHJEUTNSYkJYN2dXRXVndTBNOXQ2VnVDU3pnUHVWOHBZOVhMajJOQlVK?=
 =?utf-8?B?QnE5dkhpNE5pVEtmZzBqV1BYU0VWRjlWQnlIZHgvK2FKTWhVcFZ4cDRFRFdo?=
 =?utf-8?B?Z1dmTXRYWEVwS0VkMks1MmNmUXdTend6NitERDJ6Z09BTUFWTEtSazBiTXht?=
 =?utf-8?B?QmRkQ2o5amVxVm1pMW5GcVpHN1BYSHpnQzVUS0lhUXYzOGZseldLWmNuKy9h?=
 =?utf-8?B?WUZKbUZtbm55Z0k4ZmVzZnM2b2Noa3N0ZTZZT2pZWUVsUXhWZXJuWlluSTFV?=
 =?utf-8?B?OHlFenh0MFhxblE5NlNkQnZJM2FwNEh5aDRDNEs4VXRqT0xrMkhLZE1tUi9w?=
 =?utf-8?B?bEhLbVJKam9rLy9YbnppWis0OFZieFNnYWJ6S1BydEZCQ1RMNGJrYzhyeDl0?=
 =?utf-8?B?Mm1qK1dtUitidlpTU3cydElUMmxCYjhVU1dFTlo0dnFSb2t1SWlIZCt6WW13?=
 =?utf-8?B?TVZUcVJkL2t4NHo4d1U3dyt3RXZWUnZXbHhGekVTWnVQSnlMcmltZTBjeEdI?=
 =?utf-8?B?SThRMHZlRHAwMGgxak1Xb1NURlQzU0VmcHh5ZnF0R0lNRXlPSjRjeTJBa2Rl?=
 =?utf-8?B?ZDRpZW1nTTJpVVRCSXdUWWNRalQwOWlnaXRJdG9vOWNYMUFFS1pPbFdXbzRM?=
 =?utf-8?B?Tll1bFc1OFdnZ3B2V2JFQmJYNlh6SFg1c0dxQk4xRzhHTGFDVHI5eTR2NGVT?=
 =?utf-8?B?NzBCYnJ4VkNub0F0b0hRa2xUc1NkcEVmV04zSFF0RW9mMWFYYlJ2TS9pelpK?=
 =?utf-8?B?Rm5ZdXllQVlzUDB3Vnc1S3RERUl3WHkwSDM4VXYwdHIrWis5ZVJjSDRNcng5?=
 =?utf-8?B?S0tIWlRabkQwZWwzSnBaNEJRYmdBbmxXd0xsMU1jdmZOdkNsbERzYU8xS0dN?=
 =?utf-8?B?NUJKTFowT2hVTkJwclJrT016cXQ0elB4dnRIWHNUamlWeWtURm1NWlo4YkFv?=
 =?utf-8?B?ZUFLOFVmdkY3ZVVvRFQwTmcyUXJ4SnZTQVowbXlpOW85RmV3QjFSSU85MWMy?=
 =?utf-8?B?dHFMZlZ5K2RsczA2c2pESGxFanR6ZERJVmxKNjQyYlBLZ2crbndVZU9naVNC?=
 =?utf-8?B?TXlxMFk0bEpiUTNyTVhhZE4vM1N1STNiMDRtTnQvbFlPbXFsb1l1c3N6cVlp?=
 =?utf-8?B?d0NYVHZsS05ZbXM3RWsyTlZ1clMrR0l5cWJ2VlFOcVZBTjNnYnduVGF1NjEx?=
 =?utf-8?B?T3lMTkEwQlNvdXQzbzJsMnRXZnVmUEQrM2ZWWm9MTG1uTkNEUXh1NlcrcTA2?=
 =?utf-8?B?SUhpMFREZjBTVkFHSFE2NER1U3N2clNhTlZlUm5ZMlVBVE5ZVUIxRFBvRmtC?=
 =?utf-8?B?ZXVQSEZVZTJhMzFlalpiUytuempJcC9TYzRLWThvY1pwZVBqcTAya0VLcHlv?=
 =?utf-8?B?a255enZFaU02bC9DNVM0bkFLTUZjbXhwVHdSQTVJU1dMUFYxKzZBcmxLT1FL?=
 =?utf-8?B?ZkZqblhvb0FUOHNUSkk0MVcrYlBQdGoyRy9ZVWgvT05ZYnJtVkc2d0Irb0Vh?=
 =?utf-8?B?eloyU0RvYUFXcHoydHZkdnNhMDJtZEY4VzlHNnc4Y1pHdXV3OUc1K2RVdS9z?=
 =?utf-8?B?bXVSQ2dIWDJZMzd2YmErbTVKeHAzbTFPQU9VQ2FKQlpkdllJSXJ3MDJrcnQ3?=
 =?utf-8?B?TWlML2U4OFRNVE05eURUUW5TRElKMDBCcWY5eERLT0VYSThFNFAwK3cxTWxK?=
 =?utf-8?B?eEFnWlJWSDdXZzdwQUpWNzZYa3g3bXBnc2d3cEo3Qmt2NnJnMndOZlVBU3ZT?=
 =?utf-8?B?WGY2Q0lDdjRRSTR5eU52dmNLM0p5YzE4V1BHbjNOVFUyZ09qTzFuUkI3VGFa?=
 =?utf-8?B?VWdhaW0vREhzREQzS0xYTnlicWRvZ2QzL2t0VUpBY2RoY1NQdHdlcGdkVXlV?=
 =?utf-8?B?dG1wLzlya0pzbXNLRlQxS25BblRHMERYd29TaU9TVEg3alhhOVR2bXQ3cnN3?=
 =?utf-8?B?MlpQMkJrdTEwVWtIaC85K01kUVFPQW1aMGN3WmIrS2NSNkxFcTMrYlFLVWgy?=
 =?utf-8?B?UDU2QVhZVWF5SHUyaTBmNUJ6RWltOWVTWEo2b3RGcWRtL3RzWXdpL2xUNGRR?=
 =?utf-8?B?U0RpMUJFaHBzTVR6N056WDZVSWN0NXZJdmdTNUN0NU5pby8rSDZFV01CRnJP?=
 =?utf-8?B?cnY2SDF3TVQ4TjlGaXZLMGQ0a1I4QWF5MWF2UkF2NWdBNyttSndMVHlVVmh0?=
 =?utf-8?B?dUd1OCtwWnNUbzAvK0liK0pQcHdwOHlnMjg4bXF6S2ZDUUVSa0o0WTBIQk42?=
 =?utf-8?B?UG8zN2ZiQWVjaE9TaVBSQm11bXNvcFBhSDdadWd2MWlkWFp0ZTFLV01IOGE2?=
 =?utf-8?Q?Y287rgexBUKnfDUE=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f2c8ed2-cae3-405c-8e34-08da0e427e8d
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 09:33:18.1901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXgvdnQOjx5jBbodOIvAsw5I5VUfX3BgI/bdsIw+D7faZkRYEAwbnNejG5XcbEk3c2ezEe544v2dmgm9fv3lGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB5524
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 25/03/2022 10:13, Claudiu.Beznea@microchip.com wrote:
> Hi,
> 

>>>>
>>>> Any chance you remember more details about in which situation restarting TX
>>>> helped for
>>>> your use case? was tx_qbar at the end of frame or stopped in middle of
>>>> frame?
> 
> I look though my emails for this particular issue, didn't find all that I
> need with regards to the issue that leads to this fix, but what can I tell
> from my mind and some emails still in my inbox is that this issue had been
> reproduced at that time only with a particular we server running on SAMA5D4
> and at some point a packet stopped being transmitted although TX_START had
> been issued for it. In that case the controller fired TX Used bit read
> interrupt.
> 
> The GEM datasheet specifies this "Transmit is halted when a buffer
> descriptor with its used bit set is read, a transmit error occurs, or by
> writing to the transmit halt bit of the network control register"
> 
> Also, at that point had a support case open on Cadence and they confirm
> that having TX restarted is the good way.
> 
> At the time of investigating the issue I only found it reproducible only on
> one SoC (SAMA5D4) out of 4 (SAMA5D2, SAMA5D3 and one ARM926 based SoC). All
> these are probably less faster than ZynqMP.
> 
> Though this IP is today present also on SAMA7G5 who's CPU can run @1GHz and
> MAC IP being clocked @200MHz. Even in this last setup I haven't saw the
> behavior with used bit read being fired too often.
> 
> By any chance on your setup do you have small packets inserted in MACB
> queues at high rate?

Thanks for elaborating on your case.

Frames are two descriptors long (header + one) and packets ~1450 bytes.
with iperf it's relatively easy to trigger this situation, but this is 
also seen with "normal" traffic. It just take longer to trigger.


thanks,
Tomas


> 
>>>
>>> Which kernel version are you using? Robert has been working on macb +
>>> Zynq recently, adding him to CC.
>>
>> We have been working with ZynqMP and haven't seen such isses in the past, but
>> I'm not sure we've tried the same type of stress test on those interfaces. If
>> by Zynq, Tomas means the Zynq-7000 series, that might be a different
>> version/revision of the IP core than we have as well.
>>
>> I haven't looked at the TX ring descriptor and register setup on this core in
>> that much detail, but the fact the controller gets into this "TX used bit read"
>> state in the first place seems unusual. I'm wondering if something is being
>> done in the wrong order or if we are missing a memory barrier etc?
> 
> That might possible especially on descriptors update path.
> 
>>
>> --
>> Robert Hancock
>> Senior Hardware Designer, Calian Advanced Technologies
>> https://eur03.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.calian.com%2F&amp;data=04%7C01%7Ctomas.melin%40vaisala.com%7C1aaf00e981f14742b92108da0e3754c1%7C6d7393e041f54c2e9b124c2be5da5c57%7C0%7C0%7C637837928068621708%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=230PlqUdZGct3lBAd39A0Zm8hxIgh5jovRRrQJ%2BXVyc%3D&amp;reserved=0
> 
