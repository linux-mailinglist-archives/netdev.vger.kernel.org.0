Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB09645823
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiLGKtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLGKtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:49:02 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2118.outbound.protection.outlook.com [40.107.21.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC91A2F01A;
        Wed,  7 Dec 2022 02:49:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHdzQY1AzWpL/DFEeRwN+hdy6PxHy8Vdg6dzkakCU8I8bn2f3gWEQdEBA6x5qv0SuP2aPZqjkl9mSzRhLTKlLGUqtFOptz0RAUmRixLa+3Ht604e0yU6FD/Ln36+1CqK3hGDyuLhOasHTNV7tZUo7QXi+gJBLgb+UrpJyS1F27krUy8/P3HFgNwtivhJ0DdPspFYb4RxuLCviVo/6aDi35+FwxP4uRV41Mc/z4WljroeJOUmn44Wxwjah20K/WrMqnlvs1tjw/0xijFmvDYTM5AAlFIfT8lSW209BcaiVb9Xse1tqANcF7pzuurheHBcfQ1mO0zS9FNxwH1rGb5FKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUYHB1y4AfmRHGh17c59j3SXMNU3wgBvIwOJkeSMjpw=;
 b=i/DD7+fAM+FDdzbHzcoiasHwrwQ5wr/HTKvj635e3gyt0rPGcWcrqrspFclZYv/vKV82WE5iPgLIvbhNnQ/WvpByAi/WoL03ECz0RUzklGz8pMm+Ho2EVF7Cory+wrEQ9xeK0yhmFYDlLFsgOD+bU0VCpbmdJl+pVNUdhXW0YFzc7QumFMwc/lD1jJOETdkq+tnMj1n9T/iW7UoeWj4DWsYBCRebDDbOd/VZjfV8t7qucB5vpheBwr76uWfTIWsg1YPaE38I+eZiKBIGc1jzC6wuMij3Fvjrq4p0RfST1tG4o0sNkQebt7zy65T6cexwNg7w0Pm7qZ5nF+k7908J1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUYHB1y4AfmRHGh17c59j3SXMNU3wgBvIwOJkeSMjpw=;
 b=mguaHpVGujUq6j6QBqdFa6LpMW2eBP2g/+h12xaZxD7GKQfOjfnZWiWtyiUxo2DspS6Tv4pwy4dMU08DRE9zi3UyknSw9R2kE1YgpPLSPC2n2230mqSDiKaUA4yn01kg4mQTYXS3ZChw2Z5TzuGiVDSrIN/oqzlXypyfo6Odx6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prevas.dk;
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34a::22)
 by AS8PR10MB7498.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5ad::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:48:57 +0000
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::732f:4316:a0be:bdbc]) by DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::732f:4316:a0be:bdbc%3]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 10:48:57 +0000
Message-ID: <3edb5124-f01b-f77b-d929-9b360ec67593@prevas.dk>
Date:   Wed, 7 Dec 2022 11:48:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
Content-Language: en-US, da
To:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     Tim Harvey <tharvey@gateworks.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <CAJ+vNU2AbaDAMhQ0-mDh6ROC7rdkbmXoiSijRTN2ryEgT=QHiQ@mail.gmail.com>
 <6388f4ab.5d0a0220.a137.068e@mx.google.com> <4792263.31r3eYUQgx@steina-w>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
In-Reply-To: <4792263.31r3eYUQgx@steina-w>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0046.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::20) To DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:34a::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR10MB5266:EE_|AS8PR10MB7498:EE_
X-MS-Office365-Filtering-Correlation-Id: 46550be7-f824-4416-561d-08dad840a455
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvYkFahEu3UM3JFxUTDvl6xIo9KmKwleWLq4MvJokGjJIodR8D/e7VMrtM3KH2zzuN7mEeYm+V26fczGimNxAY9B6OrAtUn30MS9CF18FaXTkujwyVOGvpgEav80PjBsaoozcxGHREH/0muyax3SJu1SY4jippIZLMJz1ky4ZcEf3AJzIgZ45ppQYisTNzPlzfnRMCPWeuCGBavaU/LFVzBdJv9m8tZUg0/SWAggmN/frbUjy4WEgp/pK9zbh8dPg+BteOsRoJyU1OUaY0BVAXymCznNanVFfkr+lr/BeRU0DPHqECS1Y8YYT3k+7cG4Gia1bdc7aUUSRBkK2lL2VJPM8QxFBAiCuwTV5XbaEMKuqy87bPXt6ecVE2dehuHfSH5nQNf9uPJN6rE4lw3TpHXcl0l855vbco9/36/SsGiAHu4Y0ZOUK31RPQBD9x6aaX/YVi855eNf5jNZyVA+LWT+q7BZ33TsXAXYsxsWLOiU2harsh7HRB6teNW/jBzNLX0xAl4NxYhLy2Cyp5XfQN10aDgVSZAetF6qEOSRgRhh5dl3BGakqUJANWF0LiY/8/cbd9uPOQFONEqPB44W/BMp1XoKaJK36Ew9f8Kfcm2L8dk0wQxklDmDtGTSF4iVnDQTYA6Y9YqK4rpMkX4PbL7IdNvsgfpvZOulVPtdmw5wYy6k7i4B5Lexmcx5o06Suf/mmsgMKT2E/ydfZA3QeS6vDpddZ8zHIVl3P61Pxm5TcYQiRzhajYilICZPJ3BN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39850400004)(396003)(366004)(451199015)(478600001)(8936002)(86362001)(2906002)(54906003)(31696002)(38100700002)(8976002)(4326008)(5660300002)(7416002)(44832011)(8676002)(186003)(66476007)(6666004)(6512007)(26005)(52116002)(6506007)(41300700001)(38350700002)(110136005)(2616005)(316002)(66556008)(66946007)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0E3UEdlTG4wT3QyY2MrQWFlNVUxT3B2dlRJVUZXVnJSM0pocTZHM1VqV2pD?=
 =?utf-8?B?VmVidXVFTmFIVHpBcUswZ2wwbkxDajZNRUYrdURNRnpDVXUyRG9TWWF1aDJI?=
 =?utf-8?B?WUpjYlBPYmYza0RoZEhYVWpmQkxLVFF4dDRBTUorODRON2w4MjR2VE40VjZV?=
 =?utf-8?B?UnFuZFJrcjYzeWltUzBSWGoybHcvWjJ0TmhqRjBsN1AwcU4vaHR4QjhRdEVh?=
 =?utf-8?B?VFJ2Rjg3Q05ZMG9FRUUvVnd0bThxdU5JRFlsZ0JpZ1hqZTZ5cnNSb1Rma1dH?=
 =?utf-8?B?TFRGekx6cC90NjRkeXRlV01HLzFncDdwQ1hUcDhDUzZqK1NLREhKcmhTMjZm?=
 =?utf-8?B?UnRNM2l0bVVTLzFtTjBKejd3V1VNVkZ4TnkxaVlFQm5BLzN3VFl0OUIzYitt?=
 =?utf-8?B?bjc4dTJhNCttU09wdEpFUUtUQXFsdm9oZVdZN1MvTHFzMHNtODRPcENIYU1h?=
 =?utf-8?B?SmRiZEE1Tk1JZmtGWjRCT0JQRnNsL09OUm9ObFZrRmFQMXg2ejlCSHd1b1BZ?=
 =?utf-8?B?N2I3dnVDU0VIcXNNcVU1d3ZKY3JCcUNpSWZnODJMZGk2SkpkbUdaemxvbGc5?=
 =?utf-8?B?Y2xpN2xaSkJseFZMemdmV2ZUM2pxS3VDcE1uazBhQzJ3WkFMZHVDVGhxNTlT?=
 =?utf-8?B?aVFCYko1Qkk4ZjVuY3BwMHk3VFk5dWhnSjhZQU8yV0NNcERMNEMyYUk3Z3Y3?=
 =?utf-8?B?OUVpSWVta3BFZnJBN0UrTURRQnEyenFrYWkvcEt6bUVsUEcyQ09SZDNaNk9o?=
 =?utf-8?B?aVc5UDNJTkZTVDA2SVdGaVV6dU5BSlNpYzRHOXpWOExxZzJsMWptSW10cmlZ?=
 =?utf-8?B?cUM1czl6NHFHaVJ5TzJRN3ViWkRLdVowMUY4d2UrU0IwTDB5SlJDbDI4Ukd4?=
 =?utf-8?B?SFY2cXlqeHRacGxzWDBZZGRraGczSmREOWtWUk1QWkg2QUtRV2dQVG9Scnor?=
 =?utf-8?B?SkJwbVlJNUNXT3NHeTN3c1FlTFBSTGlidk1HaEVHVUlNUjVGRDEvdkpoQkFL?=
 =?utf-8?B?VG5ZUlJIRUhOUHNRUHJwcTAvVWZMN0ZmSHk0K2x4TElMUS8vRk9HLzg0WGdo?=
 =?utf-8?B?KzgyNDNJUDllZWRtaDFnU1JKYjd6YWlLZnpHRDAwa0kwQVprelJsK09WaWNk?=
 =?utf-8?B?a0dIYlBjYVozQmNBYWsrUjZkenk5L25nUXpEcGJ2LytteGlIMVMyRCs1UDlE?=
 =?utf-8?B?aVQ1endSYklpdW9YM1pkbDJmZFlKaDRMNUpUaFk1SHdIT2JaeDYyL044aVBC?=
 =?utf-8?B?RVpuM2RkU0w3M1Z5Z3V4Sk1pcnhtSEVvT1c5cERBaWhzYU50MzNOQ3ZhbU8x?=
 =?utf-8?B?R2UwYU1lalZheXRaTDJ2Wjh2Mm11Y0JkY0tIQkVrazFHSFJibUgzaWgrZFI3?=
 =?utf-8?B?K09zcFJ0QUxzZ3FtT2V0TndUc0MxanJBNitJeDQ5bjVTblN5SnNVZmgrSGQy?=
 =?utf-8?B?NCtITlF6Sm4wSWVDZll1cVE3N2JPNWhxU2tyV2F2NjdxYTQ4dm8zdUVSZ2xN?=
 =?utf-8?B?ZkVSSWNCNFdXUEVJdkxjTVJ1SVNGRWpCT0dOUzR4RE9zOGNvRGZ3ak1zaGVk?=
 =?utf-8?B?MGx3ckl1NE14T2d2Q2pkNFZQM1dzcnYxT091RGNHVUt4ZXVlbjFHOWNMQk54?=
 =?utf-8?B?RDlFclREcGxFTnYyK29YYUVZZ1VtWjMwdE1kOTZKTFo4eFBDQWZHaGVzcEFh?=
 =?utf-8?B?YVZEVmliMFVpRnR1UExHai9ob3BUS3YyQXA0Y0tVK0VWc25mRGFkSUNvSmJr?=
 =?utf-8?B?cVcyMUJwNUk0WWEwOVlHK2RadU4rZHduazFzYnYvV2VSREwvb2s5cjdXZXFI?=
 =?utf-8?B?eS9tTmM1YURnejdOSHUxVEg2UTZOWDE4WHh3emhIemM3d1U3dEIvd2piMEQv?=
 =?utf-8?B?dENyQXowcVFCZEQrdzk4ZXdXeGJiRmduM2N2RkJVSFJPcGx3b1g2d29GcWxG?=
 =?utf-8?B?TUZqWmZBcmxXNGREZnNjbFJ4SjRhREVZOVdhRm11YkkrdG1HOCt0TzdVZERC?=
 =?utf-8?B?VVA4VVV2Q1c0MzBGYXlDWTl2WEJSbFBjZDdXdmFUKzFzUnRXM0hLUWt0VVRR?=
 =?utf-8?B?eEZiWnpJaThLdWNLNndRQmlYbmJDL0hwaWhpU1lTNE9CUmVKbFZNRTR1UElY?=
 =?utf-8?B?UzJZRUFFeTBScnRZMlM4b3ljeU5JbUxoUFYxbGs5WTVRRnhXdzZyYXFmWWtR?=
 =?utf-8?B?VWc9PQ==?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 46550be7-f824-4416-561d-08dad840a455
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:48:57.4627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLA9dqIyo4KwZ3dsozWDKWzj5EODMuU9MUscEmTpzPeBQfEiPLJFxKm3bU96bUDue3urPPcM9SsgS0eCPNrHd31wBHaExLsbZUouU98mTa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB7498
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2022 11.40, Alexander Stein wrote:
> Hello Ansuel,
> 
> Am Donnerstag, 1. Dezember 2022, 19:38:36 CET schrieb Christian Marangi:

>>> Considering Andrew is nak'ing any phy code to configure LED's until a
>>> solution using via /sys/class/leds is provided I would say there is
>>> real interest.
>>>
>>> It seems to me that you got very positive feedback for this last
>>> series. I would think if you submitted without RFC it would catch more
>>> eyes as well.
>>
>> Well yes that's the fun part. netdev really liked the concept and how it
>> was implemented (and actually also liked the use of a dedicated trigger
>> instead of bloating the netdev trigger)
>>
>> But I never got a review from LED team and that result in having the
>> patch stalled and never merged... But ok I will recover the work and
>> recheck/retest everything from the start hoping to get more traction
>> now...
> 
> I was just trying to use your RFC patchset from May 2022 for dp83867 as well, 
> with some success at least.
> I have some comments, fixes and uncertainties. How do you want to progress? 
> Resend so I can rebase on that? Anyway, put me on CC.

Yes, I'm also very interested in getting mainline support for hardware
LED triggers, and incidentally one of my peripherals also happens to be
a dp83867. So please also include me on cc if and when you find time to
post a v+1, and I'll help with testing and reviewing.

Rasmus

