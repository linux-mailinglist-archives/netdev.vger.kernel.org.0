Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8836AA98
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhDZCdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:33:35 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:5000 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhDZCde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:33:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01lp2050.outbound.protection.outlook.com [104.47.1.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 45B439C0061;
        Mon, 26 Apr 2021 02:32:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCYOUJqUuBx60uXvIovac9sAhVuPzCqPIoor1VzWlzzd58aeit7a7PPfMU80dwqAvift8wxg4pZy26qTc8hHO+x1JeTkY9Y0iuWrRztEEBMhBBwKaXxqv4QcpmnODoj89sEute8C+7qItFATHDGVuoB4GgF3AhHmEjIdZgWMd5IsvvjY4NaPZKsqCelmBqaDFTEGiDCYH3eJEc/gOC1qolKHO0PDXqwiBXsPTYcgzVzYN9OSlQNeL9xoOU3cezmTcDe1R8a1RElr8l7t3XC7c18Q1305vqua6/6DJ2wgMFa8SMrI0ZHAwaRP5azChw88lAtSvy69fhbj4htWb2OwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxP3EvnBcz8yC7zwc3IKcdZtX96VQ67KMJZ4f71/uSc=;
 b=Wm3DdrbQgDjNN/biXF6yTpH7CpmmjM/TuCF6evEe6TE6gFNrCca+7AcBIPLfJrFTVsegPr5sro+CL9QsFsI9TL8V6vqyDq4cspqf3kKBYrVkeab23/r3GEGqbW1UXi83VznkpH43VNKezBeW+xwXEakDBR2JyEj51ChqCxe8biEcsS2CxHA1LIAut8LWKaq/HskUOYYMe3i8gJ8I4jRxy3PfWgfwSYQq/+nuUpsW84j/1VEmhz7+BfXhCnkQq7aDod3EVTB0SEIu7vUEzHMXVqg8xFD73zPmPE/QD/zWShY2fQsH7NXSGCwDzc7JOlPrVFDPZPuJ1Gng68SB+FCHkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxP3EvnBcz8yC7zwc3IKcdZtX96VQ67KMJZ4f71/uSc=;
 b=FEo4Ch7xeNe0JaWUx7CNPUrKeKEHrLKlnFd9w2vlRg/gJwnfqhHOH3m7HbHj94+J5QypsXJhe9gow3R8T3xfdIW+s1aK4JwdwQ001BukXYWt49Rz5MuQDy8VPPIaP+CMoDvUfHFNZWKgXJckc5G0f0VQpjy07/8z5gq7fnLMOEI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com (2603:10a6:20b:10d::12)
 by AS8PR08MB5991.eurprd08.prod.outlook.com (2603:10a6:20b:29f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Mon, 26 Apr
 2021 02:32:49 +0000
Received: from AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3]) by AM7PR08MB5511.eurprd08.prod.outlook.com
 ([fe80::1b7:6f71:2dd8:a2b3%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 02:32:49 +0000
From:   Leonard Crestez <lcrestez@drivenets.com>
Subject: Re: Fwd: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Matt Mathis <mattmathis@google.com>
Cc:     "Cc: Willem de Bruijn" <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ilya Lesokhin <ilyal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        John Heffner <johnwheffner@gmail.com>
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com>
 <CAH56bmDBGsHOSjJpo=TseUATOh0cZqTMFyFO1sqtQmMrTPHtrA@mail.gmail.com>
 <CAH56bmCp8eRqsdoMTmAmCaEnubwEy317OJKQ9UjqMvDwrkcMdQ@mail.gmail.com>
Message-ID: <bbefd183-83be-a165-6a82-53100b5ace70@drivenets.com>
Date:   Mon, 26 Apr 2021 05:32:46 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAH56bmCp8eRqsdoMTmAmCaEnubwEy317OJKQ9UjqMvDwrkcMdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.96.81.202]
X-ClientProxiedBy: LO2P265CA0416.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::20) To AM7PR08MB5511.eurprd08.prod.outlook.com
 (2603:10a6:20b:10d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lcrestez-mac.local (78.96.81.202) by LO2P265CA0416.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25 via Frontend Transport; Mon, 26 Apr 2021 02:32:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf63f416-9a2f-48aa-0c18-08d9085b958a
X-MS-TrafficTypeDiagnostic: AS8PR08MB5991:
X-Microsoft-Antispam-PRVS: <AS8PR08MB59910C4F3DC6890FB3DAAE9FD5429@AS8PR08MB5991.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lt4wSpqzmuQ8Bb8H5nvO/dyiM23iI3QvPfDvLeTLHhPMi3mM+4Y5sI+MKvsqt1LT3MaVpSSg4Qs9x0ctHr75OVAh+uMd6mVOiOwMQSEpByiXYYSl1exm/VJHJoXkZywm+eJqtcddaDVu70DkzGNjBJF6AB9lbM9Bt5NsyBsIV1z//XJUgFNS/iwkRNT/S0bVuF5HICoNAh4XRiHDCa26c4DXXEpg/bBGVNAZaxezs2ggWyU9FkyXo7PT1bO3IWX669SrnF+l1pmLQpziEMmpqcXSxn6tp7xZLjm+WUbKhGsgO/S2UHm7hjraTmXymEfGPwPOr4gSMxo/m8HPZzoJZ6w992qO5IbbrKLSIKXTsF7lQYfpp24b0lUvRlUGdpkUGZfUdTzpiC774FLMYm0n+YqPSP9GL/nC8Tfk6vHxdbRp/0ZiHjXYvqThU6/MAAnGH4Bd+ypFEqI83626rDcj21JsdlywoVVr1kkqgqvP7fmWxUu98WusYm3YNa/j/f3TsP2KV/tKSAynqIPmgMA4LY88Ju3Si55zm2F9Dw3ISnW8T4tVJ2MBCFdAK+BXAirO8qPizU5XW3nRGP2ceQjDo1N21pZElfLDukIaUcGxu6i0/+xuYEA76/KLKRlmwN1TtB6SaxtBFwRoPRy88f01ov4rp2Mxj+ZTOROhLMoopP4boouL6YTRHaqROLjn5t/EQD/l5/w1FjLr73ktLEDZpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5511.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39830400003)(366004)(376002)(478600001)(86362001)(16526019)(52116002)(66946007)(31696002)(7416002)(38100700002)(6512007)(66476007)(2616005)(66556008)(38350700002)(36756003)(26005)(5660300002)(83380400001)(4326008)(186003)(31686004)(54906003)(6486002)(8676002)(6916009)(316002)(2906002)(8936002)(6506007)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UkgzOE5ZT3F1dXBoQTV0NWpZd2N1NmFHc24xUjlDNWpPZ1ZUMWRTRlJPQUxB?=
 =?utf-8?B?VkU4SXB6NE5EeTJWZGJLMW1JMVlIQjJnSDZwUUFPenZwcnA0QzNBUUlSeVdh?=
 =?utf-8?B?dVBpekJ0VG9xQWUxcFNmS0hLbDZwblBtdGgzaEljNjJVR25yK2FjVkkzZlRl?=
 =?utf-8?B?MzBURDFROVBZZXVVTVdJZE5XdGlwMXlHN0lvd3drcml2UUxYTHZKTDJ0T2ov?=
 =?utf-8?B?OGZkNGcwNmQ0NS9hRjZYb2toODkxb2h1eFVoWnBqQkdvckV3Y09mRmpFRXZQ?=
 =?utf-8?B?ZGJtLzZBYVJJODExRjV1Q2JaZ05uQXZmbGpNZEM4OEJYSHZjQ0JkSkhUa1Rv?=
 =?utf-8?B?TldBT3Z5RVJTazIrNWRBVi96Z1NoQnFZR2FmRis1M2xxNHByZzIwTzlQZGFC?=
 =?utf-8?B?c2dLU25Vc1h3b0FpVDJ0eGV2TklURForOHRQNEdabHp2SGNKMDB3OFUwL1dQ?=
 =?utf-8?B?MStqMUluc2JYMmhZdG82OFdiSGc0aDBOMVFJOTJXSC9MUzN0bmM3czBNWTlo?=
 =?utf-8?B?MmhqMjI2RERBcU1ONndBbTJNNlZmaitrVmI5bXZPZUZtRVc2MmNwNVByMTV1?=
 =?utf-8?B?M1NWRzlhSk5vSFJRcDVtMHFhVVgrcHgyVS9LY1JPQk5qWkY2NFEwdE1oejlL?=
 =?utf-8?B?bHE5c1c3ODgxeXJacGs0QVhrOGM0S2dpSUxmUXFKcStSMWZiY2NVVkNoMXpK?=
 =?utf-8?B?QmdMczBBTUNrZ1JCZWpLN2hvK05vck0veWtzOVlWSnljU21CbG5BSUsyaUJa?=
 =?utf-8?B?cnBsN3k3VUNmOUR1OWhBQ2duUllWT2FtNys4dzBaQlIzakVEQjJ1ZkFCMHM1?=
 =?utf-8?B?QndveWJDUlFMb0pGVXFDTi82OXZKbDdoSWpuUXNVanpEZWo4ZHZIWE80OWEx?=
 =?utf-8?B?bExmS1pHTGhCTkNtUDFNalJDRWNXT2NsWnlqekR4bTZPdDNEamYyZnh6VkdS?=
 =?utf-8?B?M25MWGVQS2pEWjhVb3o5UDVqeUYwTXBLWWZRS0lpYnFuOUVIU2NwcmwvUUpH?=
 =?utf-8?B?Q25OYy9tbEVzS3EvcmhOYU44alhJNU5GeXpJMUlOQnBFektOV20wK1ZqcVVo?=
 =?utf-8?B?S2ZIR0IzdVlFbm4xRXM5eHM5L0hwTVE0ZEFNazBUQjJ4N21kR2hzQUNPbFlM?=
 =?utf-8?B?R2V1ak5qMU1ZZ1psSVdOem5DYVk0ZW0rVWJIdWV1U09NVU90VlFCVUQvc09D?=
 =?utf-8?B?SFRobkd0eEMvanRTaThUS09oMnFoblpGUUllai8rQStETElzbUtIZ3FxR24w?=
 =?utf-8?B?dGlEZmtzM2lPQmFFNnRETHVDSlg3RFYydUdGcHFSOFpaZ0hWc0lnS2NjYzVM?=
 =?utf-8?B?TFhoeFNUN21zNVFzaCtCdDlkSGhYc3p0Ymw0K1I2aEFRUFhFNU5QcVc3SjhU?=
 =?utf-8?B?cW92dEFWSGNFbkpjUGFRVGtsQ3RtMkNsdDFGNXM3Z29GYmM4QTFXQ1RZWVI3?=
 =?utf-8?B?Tzh6OU1xTFFqdlpwWHV3YlhZVldqRzJQZGJNY1JXTTBHNndRRHZGYUpaRE40?=
 =?utf-8?B?NUZvZWxkRGNqV0wvM04yOHNWMlBvTnFTTTErRHNPRTV1U1c3a0puUHJTWjc1?=
 =?utf-8?B?d0laRmNmcGJlcG1PSEpiUHVqeFI5NURiMDF0eUQ3MFVXck5pVmJkdTlLVEZn?=
 =?utf-8?B?ZVJ2MlVRaDdKQjBuYnpuSzVtdmZKVUhJWmIyL3VtUHRzVE1uMm5xai9kbE1G?=
 =?utf-8?B?RkNSMk43M1MwMUUrTzFWM00rK0FYRkZ0Yi9VczRjeHkzNUdYb1pvbm1OVXBs?=
 =?utf-8?Q?kTUV4FFe6Cz12D4Byox3U9rQ0EqG8WtcP2vuaog?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf63f416-9a2f-48aa-0c18-08d9085b958a
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5511.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 02:32:49.4400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqR3diGWrwxFHR4Oxqht3zxiVdY1+mKef/RXn+I7NFGidYXXyCdlWtxxxBgK33QZ4w2u9bLijKrX8FumV/Cguw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5991
X-MDID: 1619404372-aMv_gfz2-x5w
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 7:45 PM, Matt Mathis wrote:
> (Resending in plain text mode)
> 
> Surely there is a way to adapt tcp_tso_should_defer(), it is trying to
> solve a similar problem.
> 
> If I were to implement PLPMTUD today, I would more deeply entwine it
> into TCP's support for TSO.  e.g. successful deferring segments
> sometimes enables TSO and sometimes enables PLPMTUD.

The mechanisms for delaying sending are difficult to understand, this 
RFC just added a brand-new unrelated timer. Intertwining it with 
existing mechanisms would indeed be better. On a closer look it seems 
that they're not actually based on a timer but other heuristics.

It seems that tcp_sendmsg will "tcp_push_one" once the skb at the head 
of the queue reaches tcp_xmit_size_goal and tcp_xmit_size_goal does not 
take mtu probing into account. In practice this would mean that 
application-limited streams won't perform mtu probing unless a single 
write is 5*mss + probe_size (1*mss over size_needed)

I sent a different RFC which tries to modify tcp_xmit_size_goal.

> But there is a deeper question:  John Heffner and I invested a huge
> amount of energy in trying to make PLPMTUD work for opportunistic
> Jumbo discovery, only to discover that we had moved the problem down
> to the device driver/nic, were it isn't so readily solvable.
> 
> The driver needs to carve nic buffer memory before it can communicate
> with a switch (to either ask or measure the MTU), and once it has done
> that it needs to either re-carve the memory or run with suboptimal
> carving.  Both of these are problematic.
> 
> There is also a problem that many link technologies will
> non-deterministically deliver jumbo frames at greatly increased error
> rates.   This issue requires a long conversation on it's own.

I'm looking to improve this for tunnels that don't correctly send ICMP 
packet-too-big messages, the hardware is assumed to be fine.

--
Regards,
Leonard
