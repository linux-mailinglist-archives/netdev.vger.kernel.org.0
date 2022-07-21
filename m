Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5157D418
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiGUTZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiGUTY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:24:59 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60088.outbound.protection.outlook.com [40.107.6.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B48A89667;
        Thu, 21 Jul 2022 12:24:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hbknv/XnPDoErHtnbQtXdIs1Yd8uMUff1nLw9CKxRn/uDZLA3H5LH4w4S2sWYgbDmgnmIBqzj862QTVnXzw3i8n+TEvVStKlerYvCi1emfW9oTG9jB5g9l6nuEtl8oLmHxWFq1if7aOn6YE6M3wY73p/d3gEjLmhxF6yN4D5eokymxm/lRsRTW0ztupLBEAfhma2Ze9/WdbkFIYP4TnfCQp/zKYRYHvWm5CMEiRar5N3lGv2koCgRfuQp9Nk2JbQGh2CYnavKHyhkEDJaFSnsPZWGhj98U1DpZTlgFvA6x4s78yGIxjXmKJhXxYizDAv5xzVGGklKZpWaK7jmk8MZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4UfZiPxehhZSI8PEYXo02VYU4eWygyTHrPMJz7AtXY=;
 b=j/5e26ZudfXV0qzRq9mGETpLVHNSgLvHTijKYT1tXIxdXHONuWasyO88BUULHWsSO34EKJKEPjAgkOO4a0PreA8YpWrwwLrI92j09DofLsBb6GPHDDvjPIoI5cQX+QgsZlsUKVQkrzElqDgB12x33GrxwV9EPCjzCcZeO8DdVV3LVJ42ntg9JrfYcDtrD+taKww2Ki2Ch1IvOwmyVob5zMwwzCGyrt3KnMY12OsZ+DmLwmBre77GL3bWM4SAO5c4csmQH8TBALBcyDjoXANW8JmlJJ5S5d7wfaMKlq2QsdkztLcceOYAFGiw6FkKSE7K9sr3OLuxmQDSORuS1MZAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4UfZiPxehhZSI8PEYXo02VYU4eWygyTHrPMJz7AtXY=;
 b=hOzv0v3EPtq3cn2gN2jgpaeudGkWYPJdwpz4Sckzx31huwZLe4Fs4Mmx6iDpWtgU5REu0i88dLOqenleLPwtDTKY0E18EtZ3+/9gVQscpSkKIROeo465U+88GrYDKWa7GvVo2xbxNIugS9AglmLBKG8jnsXWQGbPWiP2bCIce8ZBG7/RBzKB2DWEFWAmD6wNzav5hzNe3KNimb5wnRUHnm1mu79/0/27XOmDQGTus5nAcg70xlKVJe0CpHDcEc9DLUyO0IQXq0SVneGIfCur+NdkqLS1RXmHwkMyQFuBkpa6LpRlqrsHaVsyWPmGAYcOY6iOZK74TfHLz8ruRGVGLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7929.eurprd03.prod.outlook.com (2603:10a6:20b:438::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 19:24:54 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 19:24:54 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on rate
 adaptation
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-9-sean.anderson@seco.com>
 <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
 <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com>
 <YtmVIXYKpCJ2GEwK@shell.armlinux.org.uk> <YtmckydVRP9Z/Mem@lunn.ch>
Message-ID: <6eaca88c-45f3-9bda-78d3-fb3589768817@seco.com>
Date:   Thu, 21 Jul 2022 15:24:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtmckydVRP9Z/Mem@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0004.namprd12.prod.outlook.com
 (2603:10b6:208:a8::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a645a27-7910-42c9-82cd-08da6b4eb0e7
X-MS-TrafficTypeDiagnostic: AM9PR03MB7929:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvMIiUievkgR2aAekUZejtu3ItuAU5NvbtT3hqLzWlx9SxKO4ctEHyTDnGDrkuatWrMm9ilsI0iY1hM3Drm3OWGHz2pnnR6zydn2r929vBbO8uVv/FEVZmJIOCmQJg97cr5Rrfllxj3iCBmhytKvCQrNT7vHLyEJaxDhrx00u4XSY0pOY1PNVK+HbmV7uyrfRzj8LCPxEFx+tHujcv8RWxDhcNGB3qMGRRVpvOy+UWCmaVb+VKNtrJq81tm1NaP3m2N2raq9442c188qBBZIxNpqhkivjvOZ2nA/Lw3dW0WPaPMbKuGwxV3qstavqmnSHpcllQjD9QaYDr962vgD30XOxmYno3wdlHq0HYvHL5vhsYkbVXlGbT9DX1EJGm2SyU0dMQy53T2TXFAqTKk5ZDfYgXFZGeZaAxx700joiFpnQ5x74kDo5gZJ+m7S4Lm5e0S5elVHZXo+OvOaV6a7ZdYQFS6AWzM/GRjyQdZLT6Xqhr02fHX1h4J3qqUXPqxFPjoZsgnWu/gNOQIip5N66vj2APr6qyHtTX2qRl5aZLRw2ZyV7jqs7yWxc6PyM68Hf+BkP3LY9+0yRJC+vYnCksKgO8ovmz0iB3ElXO7Yz926KxTVX7Pyft2WljPHx6aIfQ8ph8znzosbhaZTI+T4kEyNicRKqGsFmtlD9MwBxiNji91936ESx5juN3LmxeQ8k8HLmrlWliKo44uAt9FdXK0B2B25xtdsDekeTH5Mtf3GNBHO6kecdRK01Zu0/bNk6tHz80F5U1lHkhtmDXhZY5J/DHg2ON0MDQZB78K08s6gQGmlN4HM4N8bVIklkjp3dxtrMTbmtIe/jUEyMFu7liagPuYl/PjC/lHFCaTMkMu7YIZTed6T19TPbzvxrnKEUpWp9HK9JhD2X3Nc6pkt9NYxrAZJFde8ePXbQYWszJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39850400004)(8676002)(66946007)(4326008)(7416002)(8936002)(5660300002)(44832011)(66476007)(66556008)(54906003)(2906002)(36756003)(38350700002)(38100700002)(6506007)(31686004)(2616005)(41300700001)(6512007)(6486002)(110136005)(52116002)(31696002)(186003)(86362001)(6666004)(478600001)(53546011)(26005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHF0OVhERGxhVlVTdi9IZ29jeVBQcmJWSTVhc0FMSXJXaEdVSDcwNVJvZmFz?=
 =?utf-8?B?U3ZaamlablUreE9pZVNURnNkTS9EYldlOFM0WURScEYwQVlqVUtDWEFNQVkz?=
 =?utf-8?B?d01LMDN1MVBBQ1NkOWF3QUNRdityRHkvTUJXVThqVkd0UU5RUnV2OE53Qmt1?=
 =?utf-8?B?a29wQkdZc25DRnlWekp5OXhpTGNvK3ZXdnB2RWg0emp0VlJEVHMrZ2YySzd0?=
 =?utf-8?B?ZE5melI5Y2tXVHdrZC9LUFJMVW9xWEF4d3pVRXZnOFdQMXNJR0E4REp6MVRW?=
 =?utf-8?B?dUxwd0xoRGEwTnF5QnBWY1llV0hEaUpHWUZ1dTlBOTJTeGxBK0Q2bE9qRmkv?=
 =?utf-8?B?aDFDTlRrSHZJVFZTTmx0QlA1NWpwT24wQkZiak5VeDZHWm1pT3N2azhVZ0hl?=
 =?utf-8?B?cGhWMnZ1aWNCaFU0a2R1b2hMRlk3QU1KeWZXR3ZTbmovUWdpNEI0NHJhRXg2?=
 =?utf-8?B?OGU4RnVmcFBWSHgvK0RjSUhoNyt2UE4wZElaRW9qSEhBUDNSMWxzMS9mWmYr?=
 =?utf-8?B?cEh4THZHVDllK085dWZ4TUczSWtCRjBReXNSb2VUYzIvTlNvQ0lnazZzTlFn?=
 =?utf-8?B?YTQvQ3E3UDE2bnVXcVdXUTNVSDNnZ2plRkE3OHE2cFlKN241MVZ2OUV0RG1Q?=
 =?utf-8?B?U1JrdHA3ckwwS20rOUdhbDNhWmhxa1p4Sld6TFdYUFlGdm5CbHJVcEI3N3Mv?=
 =?utf-8?B?cVRZenJZaDQrTURSV0hqTU9DZkNqaHBrOXNzUHFLZ0VseVF0ajBRdURNbkFx?=
 =?utf-8?B?a1pzL1lkTUIyKzdDNUV6clRjQTN6b2k5NDRvcm9GM3V5cysvVnFvNDN6bk03?=
 =?utf-8?B?SkZPRW9VcXdmVzRVVFpuUC9sU2N0M09uS0RDbkNzWENnMlVCczYwT3pNd0Rx?=
 =?utf-8?B?Zll6NDBPQ3VJWUpYMllxbytXaVBoeC9lT1VZeW1MeWZ3aWpOajlMY0RFVmxQ?=
 =?utf-8?B?c1ZnTGtRZVNzWEVkcGJ3L3h4b29Xd05GMEpoK2RUSUFoSUZXc1hOWndCVTRU?=
 =?utf-8?B?SWM3MXJUbGE0ckFtTjIzT2xaVjREUzAzNmNxMUF0WlRjNkJSRzJUaXdkSkhG?=
 =?utf-8?B?NE56SFVzb2tiSzdwTitJQWthUWVLL2xDMmJqeDZoLzJDcXBIcTBSMW5iSnRH?=
 =?utf-8?B?TWY2SUt2YW0ycHFEM28vK1RRcndxOHJwMHZwZllZK1YrT05XYjBpMVdiMVdL?=
 =?utf-8?B?TW94Y1Q3ZnRFVTVxSzRId1kvSVNFcndpNzJvRUJ5eFFLUzN1a2sya0lNbi9s?=
 =?utf-8?B?UlNsSXNKNHcyVGkrWEdJMkVJcWpONTJaZEdFVkZ6dnR1eTdyNitWcktILzVW?=
 =?utf-8?B?a0pQYUZSUlRxN3JYV1RjbHd2OTdlQzZDU1VjWmVpT0VtY2FVcFB4RnVDTkNT?=
 =?utf-8?B?L2JsbjBYK01ZMDd5Mm13MzR6cjZ0dGJ5Z1U2N1JMQnhqbGd0OC9uUy9YWnlj?=
 =?utf-8?B?VGxhVnVFek5McmJWRjBRWFBEbVBlcEErMVJ1Y3pqQk9BVTk2clo0N3ExZU1u?=
 =?utf-8?B?ckdKRXhqZ0xSV0R5clhqajl6S1U5S2trQ3NSZFZTOVo5dE5uckNjVytISU5M?=
 =?utf-8?B?S2VSWjEwWDBtUEpUbTQzczNBaXRJUkFRWDJMUEtTZVdLTnZSSjhrQm4yQWVS?=
 =?utf-8?B?STdIMk9RUk5FT1pFRmx1OTgvV0E0WmI1ZzJ2Q053VW5keVZNaExKOTRzT2xx?=
 =?utf-8?B?UzRiQjI2ZVFKZjhBUVFjMm04UVh2cUtnWDZrK0FtRkxhdVV0K0s5NytXVzYy?=
 =?utf-8?B?aWNRMWwxNElKcUhpTWNTSlE4MFhBTnFZcnB0OHhWcitYczVML3pBY01NMEF2?=
 =?utf-8?B?TzIyQmZWa2hadGtkcjFHc2JiSmFOMUF5K3QrcXBybytCV01lOURiR0tiTXVX?=
 =?utf-8?B?QjhnaHNrcGxHYmFOUW0zdWViNE5vQksyYXJsUW4raWRvUlI4UzdCTHpSRVlo?=
 =?utf-8?B?RDRTbk4rTEZhU1JMeW1lYW5Pa0QvOWdhRUF2WG40dTd3YlROWDRlTjVkOFJx?=
 =?utf-8?B?R3VhcU9GWXJZMi9IaEk0eEJrWENMU1ZXMEFjNWZVUEpGb3UxajQwWitHUHIx?=
 =?utf-8?B?U0tZYkhBcEt4VTlaMWR2Wi8vMTZyb3ZHNEZ2NyttdzdEUzMzSG5xK1R1dllI?=
 =?utf-8?B?bDEybFFUcDFldzJBTk93cHRNSGNBSG9ZOGlTQnVjd2F1TmxkbFlpMEhmUFgy?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a645a27-7910-42c9-82cd-08da6b4eb0e7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 19:24:54.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUshgYopivvvZs3nm4+eBeH+pxPGM8ED2pPBvLG/S1S4Mtya9tOQkDuqSCQdZJJf0fAb+w0mSj3likUWygDJYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7929
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/22 2:36 PM, Andrew Lunn wrote:
>> I guess it would depend on the structure of the PHY - whether the PHY
>> is structured similar to a two port switch internally, having a MAC
>> facing the host and another MAC facing the media side. (I believe this
>> is exactly how the MACSEC versions of the 88x3310 are structured.)
>> 
>> If you don't have that kind of structure, then I would guess that doing
>> duplex adaption could be problematical.
> 
> If you don't have that sort of structure, i think rate adaptation
> would have problems in general. Pause is not very fine grained. You
> need to somehow buffer packets because what comes from the MAC is
> likely to be bursty. And when that buffer overflows, you want to be
> selective about what you throw away. You want ARP, OSPF and other
> signalling packets to have priority, and user data gets
> tossed. Otherwise your network collapses.

I performed some experiments using iperf to attempt to determine how
things worked. On one end, I had a LS1046ARDB with an AQR113C connected
via 10GBASE-R at address 10.0.0.1. On the other end, I had a custom
board supporting 100BASE-TX at address 10.0.0.2. I ran tests in both
directions at once. In a regular link (both sides using MII), I would
expect around 90Mbit/sec in both directions for full duplex, and around
40Mbit/s in both directions for half duplex (or less?). I would also
expect no retries (since collisions should be handled by the MAC and not
TCP).

Direction Duplex   Interval            Transfer      Bandwidth       Write/Err  Retries  
========= ======== =================== ============= =============== ========== =======
1->2      Full     0.0000-10.0185 sec   111 MBytes    92.8 Mbits/sec      888/0       0
2->1      Full     0.0000-10.0865 sec    99.1 MBytes  82.4 Mbits/sec      794/0       0
1->2      Half     0.0000-10.0098 sec    36.6 MBytes  30.7 Mbits/sec      294/0    1241
2->1      Half     0.0000-10.1764 sec    1.13 MBytes 927 Kbits/sec         10/0     155

From the second line, it appears like the 100BASE-TX device wasn't able
to saturate the link. I'm not sure why that is (it doesn't match
earlier test results I had), but it is reproducable with other iperf
servers (so I don't think it's due to the rate adaptation).

For the second two lines, we can see that the rate adapting sender is
much faster, and has many more retries. This suggests to me that the
rate adapting phy is not performing collision avoidance, causing high
packet loss and starving the 100BASE-TX device.

Clearly half duplex data transfer works, but I don't know if it is
functioning properly.

--Sean
