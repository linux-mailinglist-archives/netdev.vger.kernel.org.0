Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D306D06BD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjC3NaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjC3NaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:30:01 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA2259FC;
        Thu, 30 Mar 2023 06:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1680182997;
  x=1711718997;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ilxe0aEGynjt8BmKO1+4g3Rkk2/XIYvM/9OJyXaYo20=;
  b=Fh0AmkoiPtdk5Y6i0JWHRoqKX9ZYpvoKV/WiMZMstpzVi3FmYDsOqzVy
   QtaXk1beu3URWfY3wqyv/91s/hodMbVkFpGTjvMaCDK4XfakSrbNzDEQq
   q8MVQX262PvYlGgwtsQI9UAZC4YZbyhYDH0i08WFZD1fBO5boSUNKoIj8
   hhW17yUPNwuXnEZMxxSQyagbsG0yoGhTPi/Oy0Bbv+9/rJzpcxqsUQAx2
   40vAmyvP0ztLzMm+WwCL8JAioVSVIB6owrei1gbS13iBrbUZU3HwyBIJH
   GMt7h8VavUnotOMa5/UjipQPrelErT4YLQH/qDwKS/iB68pliLMC7xG2L
   g==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9l1aoeJv4KfgBqy+uu5x4e/B9dGld2LZPEUVfHyIECL9zwHObFZgYljCX7Vle1jqSMENTIj+D3Yi06MVQPuI1ux1JdrX2Oxh5ZySfnlb4l0UJDaMFNQpN82L3XzYTQ8PoBx/97+NTxPX+UDir1bcQyrp3RWSGhXrFFaxVVnttjOcoTv10TqjNTjQUWKCp+n3BBlI+qfmTAnbnJMBMR/Hmj5E24dApGnvoML5mqufbLhi2R1UUfKIoo107Z70YHRweWZ9cASOT8alyGBfkA3cCuiqtnT+X/yiYDMoW943FVcwZaw2v8jY5IPl5Csd9OiYS7AqKKvppD7X3AYBOmv0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ilxe0aEGynjt8BmKO1+4g3Rkk2/XIYvM/9OJyXaYo20=;
 b=h91vlAQGIqVN7cogonEhN++baou9+K5HNLsCMeU+7jMnIhBkBmxSlISZQn4Xpg7P2Ke1lgRjLwm9Crv+2d0AQQUHvenSr6V1kr2LDshK8OktaQWO3plYSpNt8Ns1CgYG+EyqUXF/O0BMudbuDexl8OblfHcnQ4allOKsM9Ykb2UM9CbY0xug7NVUXeQ17RZZtUeHVYcaWcc+vjAJqqYNMoEzeFG11asyxjDTGxIkkhc+YV3uErbIyfFWa0E3Ingc3h1t+5yNHPjqJG1ur5RUJIrjSxd353KjMsmHQAGQrPlSRxopH25mDb1tjzabgNsgaRX5/zNNWwbpKYUO+uq/vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=axis365.onmicrosoft.com; s=selector2-axis365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ilxe0aEGynjt8BmKO1+4g3Rkk2/XIYvM/9OJyXaYo20=;
 b=oKxVY51UWnrsn4WW/tQ8uD1IJDLqqH4O4C2B2xbpx6btPHHBpId/ncPj6phMPMlH8Dzc3403YfEV+rHVwb5GqE8HGqk6ZlFHd9nkjzIlX6E/Uj3PFHfKFNeEdi2M8jeQYtvh887LXozLyY7tg3IyaRq8BAYMvBVJm7WdDX8Bmtk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
Message-ID: <8d843a75-543d-1da2-89b1-ec256eecb009@axis.com>
Date:   Thu, 30 Mar 2023 15:29:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Gustav Ekelund <gustav.ekelund@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
 <20230328120604.zawfeskqs4yhlze6@kandell>
 <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
 <20230328124754.oscahd3wtod6vkfy@kandell>
 <c92234f1-099b-29a0-f093-c54c046d304a@axis.com>
 <be2b5084-9cab-4cc7-ba50-a53dd71dfea5@lunn.ch>
 <20230328144742.vty3cpmgmsdyjiia@kandell>
From:   Gustav Ekelund <gustaek@axis.com>
In-Reply-To: <20230328144742.vty3cpmgmsdyjiia@kandell>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0029.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::17) To DB7PR02MB4074.eurprd02.prod.outlook.com
 (2603:10a6:10:27::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR02MB4074:EE_|AS8PR02MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e054d0-91ea-4c1a-075c-08db3122d7ff
X-LD-Processed: 78703d3c-b907-432f-b066-88f7af9ca3af,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZCm5D8jtn4rGWcv2TYZHa8OthFw6KR9/Ob+iUWnvABGAK4PHmKfHnoVkFwhaSZDeU+LTWkvriM4Yc4nZUQQDjgKEV5Lg2JG6FliZMu/YxYP75yCNB6f+Ag2TMsH7jGI3pEtkbeH4yN2u9RpIo5zmL1n1b6+ZDLPnrN/0/eXsFpp6gpCkZHFyON5SD9frfGPDZFOsIbKKFjGbvZ4ZN0gH/LpBfFr1UF2FqfxvViJrAITt1kka07R50sIjKX24Zexh71+k0GljgzyjF2VlBYCl0l4PFZ0hUQJLsQ0SPiReLG6YUJzddWJddu2JRQIaCUsav9whxS/TouOgnW831043bgcnkupHIRq7G1MaYJemdVemkBabn4eOfCcjY4t0KXVekT+7YWzNvO6AALalMz8knFosHuVz0ymb0sEVErHzZIfCFVcxJhKhWpd3EEgphzs5rc3ImEsz8ctEKMzhHTM+q5qMTZj55OwmqhVW2ctftJawUlgKhGaiMMRE0ztiqMBLPzNcvK+mdfLLBY77OnxzoPVX/lpq518LYnfRYueKizXAilHf1XvfFslpDzJ66RWECaQzmiewZ5d5wCTDpNCkghAC7WbL/qarcXCHE+bx78L3+QBCyKC9mnelSzCWXKRLE3I8FFjm1W7ogYKamXpRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR02MB4074.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199021)(6486002)(2616005)(478600001)(66574015)(36756003)(83380400001)(31696002)(38100700002)(186003)(53546011)(26005)(6506007)(41300700001)(8936002)(2906002)(31686004)(7416002)(5660300002)(316002)(110136005)(54906003)(4326008)(8676002)(66476007)(66556008)(66946007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk5EU2pkOTkyRXF2aWpZRjEzYlU0RTBMZ3I3VVpsbUJXN0dsQ0FKS01LSWl1?=
 =?utf-8?B?ODFOSDBIKzIvbVFEOFI3WWJPME96UU9KLytDbHNVNWxiR1cwRmZieGYrVGJZ?=
 =?utf-8?B?N1pXbE5SbHo5cVZ0c0lLZ3dGbERRWmFzWEVvUXV6K0JYMStIdVFwNCtzY0hB?=
 =?utf-8?B?ejZ0T25rTExwMkdYK3paMkgxNXlXdXlCbHFtczc1bWFWTTZGaEplRU9aOUhy?=
 =?utf-8?B?L2JLaFdwM214cVc2ZUt0Y0hHL1I4Tjk4WEtBZ3l3K0FjTFFZc3hWcXpXcnVi?=
 =?utf-8?B?N0hKMnJUY1VHd2dHYUJ5bWZCeGg2eVZ6dDdXc0tndVBLdGFELzJPZnA3MEsw?=
 =?utf-8?B?SGk0b2twb0kyM3diSUdBVHU0K2ZSYVRPbWNZL0xZMkt4dkwwRllqL3JZN1Qv?=
 =?utf-8?B?L0hYV1lSYjJBZGIyVCtXb0M4NzZPUFNvTGlWVTMzRVpLY0I3N2ZKNGJjV3Ra?=
 =?utf-8?B?Rk5sY1JrbzNKc000ZFB6TUJISjJ1UTZtTk9OZ3NSckdacWthVVQxQUhLN3lz?=
 =?utf-8?B?UzVCRTRTSUIzdk1VbFBKNE9DR2wrRXkzWVdkQTkxYW9RaytOaVpIazN0NDNQ?=
 =?utf-8?B?SjNjaEt2b25sWGU2SWxLYmp5dTF3SkYzeGlZUzg3eENDeVZuUElFWUt3WkV3?=
 =?utf-8?B?VWxrL1FOeEwxZjkyVGxiK3JCZ1gzUHpLdXUzMGZuOHp6VjFFaU1CZ08vWloy?=
 =?utf-8?B?ZDQ3dTcrWHNVcWJsYTJwVi9yOTNaTXltKzVUWVZwVERiRUl4aFdsc3Y5ZVJO?=
 =?utf-8?B?QkxOaTA5OUhzOXJZVjVCTXMxNTZNUDFNMHo5M0l3dUhkV080akE1QlRxaUgx?=
 =?utf-8?B?V1JPZXEzYjdmQWc2WVlDTXExN2dWN1VFemYycWRUc2c5MDZhWmRVMm9sUlBB?=
 =?utf-8?B?aDYwSXlkbjgzejVjditCMGZDbllMQU9sMy8rWm91KzBPNEJpRkplY2M3YU42?=
 =?utf-8?B?TTc0UEJvdk9CM2VBUmZHSVZBRE84ekg5WldZNGFDODN4ZldhaUNnZlE5V2xV?=
 =?utf-8?B?MU5OSTEvdkVxOWNFUVoxVlpiV0JtQldIbzA0NzVNT0dOQjROYkZsNm5USWQ5?=
 =?utf-8?B?YUZxdnpTSUloYXV3ZGMrbUpmZUtLVm9RY1YrN1pJc0JWd3ZFVGVvQVFBMXlE?=
 =?utf-8?B?VGM4azVucytuRUNCWVkya25wRGt1a1IzL2FxZXFTc0ZDaWVVNUR1eHZST1Nl?=
 =?utf-8?B?aUxaRkc3OE1lUElPT0pEWFJwRUlpYXA1L3pWZnJibFlNZnFYdFMzd0J1UWNm?=
 =?utf-8?B?TWxmc1VYc0FHVmRPTi9wc0ZIWE43Rnphbjk2aDJMUHQ1NzEzdGFSeGNrV0gw?=
 =?utf-8?B?SWtuZVJEazFTSU45TlRVOURnazZqZC9xUHc4elBydUhOUHo0cUlUTUJpMGlS?=
 =?utf-8?B?N2hPZkpnMU50OUI1bEFnZnpVRFdZbDRwdWpySmpRQkdnYnRGV1JIUjEvcnNF?=
 =?utf-8?B?RlFFYzJnejV5Y1BYMGJRMnVXL1F3TFByS0JrNEwyck15QW0rYk9XR240TEc0?=
 =?utf-8?B?Q2Z0VjBWVzRUZCtRcmN3dnFsZzR6L1g3aVJNc1BueEprNXZBK2d2bjQ3b1pj?=
 =?utf-8?B?YWQvMThESzJOcGt2UXB2MG8zYjVNclEzbjVHdUJkN2I0ZzgzaFZTanp3QzQz?=
 =?utf-8?B?aEZvOFJCNFFEY1VkL3NBVG5aNEhYRjJUYnF1MHcrRzFlcVMrZUdMc0RUSVVJ?=
 =?utf-8?B?NnpneXk5VXJKV0l2N3JJMHZEeERLOTRqUElFcTJjKzNWeHhNWUdUY1ZkOHpr?=
 =?utf-8?B?TVRWM1l1S0lwTm9tdVdwQVhGRldlRFRzUHp0Q0t0MVFDZ2E2ekdHOW9EczZ6?=
 =?utf-8?B?dDZsRFQzYWlneThIakVLdWxtam9xVkxvRE5ZMXFWSzkzbDJsT0h4Q04yN3R1?=
 =?utf-8?B?T3UvQkhqNkE2aGxrTFNJWnJpS0cvSFhTOExzWVJxd3ZsZjdXUEZFTlQzeTB6?=
 =?utf-8?B?OURTNnh3TzkxY2YwS1QwdUJwWXdLcU5qVWR5R3pkYkNCQXRNMG5NVXRrcVVU?=
 =?utf-8?B?alZNdzMrWTd2SHJnTW5BU1ZVMnN5ZDRtYi9UU0tHSy91UDk5QXBnbFl0L3R6?=
 =?utf-8?B?ZU85UDJ6UmRiYTA1RjJVRG9jNWo5YVFJdDVLTXVwZ0g5elVGSCtmY21nSjdV?=
 =?utf-8?Q?9d5s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e054d0-91ea-4c1a-075c-08db3122d7ff
X-MS-Exchange-CrossTenant-AuthSource: DB7PR02MB4074.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:29:52.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxOOGOVBvPLzpNoGJB/2NaOynMZlZOk+2+CeX7BqDraXMgQkSuSEd2+7iylmQNgr0HSb3jt17nAZMarvB+n39A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB7382
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/23 16:47, Marek Behún wrote:
> On Tue, Mar 28, 2023 at 03:45:51PM +0200, Andrew Lunn wrote:
>> On Tue, Mar 28, 2023 at 03:34:03PM +0200, Gustav Ekelund wrote:
>>
>>> 1) Marvell has confirmed that 6393x (Amethyst) differs from 6390 (Peridot)
>>> with quote: “I tried this on my board and see G2 offset 0x1B index 12 bit 0
>>> does not clear, I also tried doing a SWReset and the bit is still 1. I did
>>> try the same on a Peridot board and it clears as advertised.”
>>>
>>> 2) Marvell are not aware of any other stuck bits, but has confirmed that the
>>> WD event bits are not cleared on SW reset which is indeed contradictory to
>>> what the data sheet suggests.
>>
>> Hi Gustav
>>
>> Please expand the commit message with a summary of this
>> information. It answers the questions both Marek and i have been
>> asking, so deserves to be in the commit message.
>>
>> 	Andrew
> 
> Maybe also add a comment next to the code writing to the register, that
> this is due to an yet unreleased erratum on 6393x.
> 
> Marek
Hi Marek and Andrew

As you pointed out, it is only the force WD bit that is writeable and
the others are read-only. Just needed to clarify that the patch is only
meant to solve clearing the force WD event bit (bit 0).
I will clarify this in the commit as well.

The errata is allegedly planned to be documented in their next version
of release notes.

Thank you for reviewing!

Best regards
Gustav
