Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274AA44B00F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhKIPL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:11:58 -0500
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:47502
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231272AbhKIPL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 10:11:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfXSdjS6BDy+61nucA71XwiktWLCCfMVWgmL3M4Y9LK46fk0EzW0hG7AyMRmC5MCfnuSuCop+QyjL1ktvqCfS7ysd+3Wg4cRqxTcSQ/RyAgL4spf1AXxas22n58cpb0sMTzBkws2gCFnp1594Jsun/SFkwX5tEM0IyyBh60vjLdvyYQ/p2heW7xQ9Qd2rZeeqUE8aEHHH4pE3cTwBJSCEY79VbOx+gTFVZaZsGyfa/ayZVscBN977QzvgadEgyZEuGZWZCgmUzPVNg9buCD1vW9xMD8D0rHpoOWUGu3VMl70s7ZWp7WZF9d7GXSuyU0vgpL3jsJjzcoiTIBps1VKzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAvUg1rn5o/Nh7AT6/RxbBGtKdhw0+WhIFqyYn5zaLI=;
 b=jHfncflH8/Qb4Q/PACXBbbToNiklNh4det720kASd7pWbsP7msuXDQMHY5d0d3ghxLY3WWxpdOr1AzEQ00p7cQWsVSnNXBG1huFk1Fh0kktjZZ8+Iq3pq4JE8OEv+n0puxGNNeFPQGjA1cp80sKQIwLiEqirGA/VKTJ9f2buPQ5r2PxCsYNf0kl9shDOFQAUjDEnbga4PPIrm+ljkV5VRGAU4Db/BTb746Fm9K/GfuZtNPeXyUbXhtF3mtZ7FOtPqK2Je1ytj9l6hB/oDeiX/h/BmczcU2rIex5zlL5GbNVlHq0WzRWiObfaUgchZYLt9tDTcnWx7TeKqoGLdIwIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAvUg1rn5o/Nh7AT6/RxbBGtKdhw0+WhIFqyYn5zaLI=;
 b=hpVc4QeqwIW/Oc/EAlhD1A6bYv9u9xL5DIzG7EV2B0diAZG3GtbzWq9kn8mecka3IMHf/jwpLjt6uvjedmiQVvtOsHGhoNh3azMJDdofcaYvKnv9BXTH3RA2y7J/5WVsvTCNS+4HGUlT94MXntTJeaCidWDcRzaGe1U64aeJjJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8952.eurprd04.prod.outlook.com (2603:10a6:10:2e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 15:09:06 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::dca1:2938:918d:caf3]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::dca1:2938:918d:caf3%4]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 15:09:06 +0000
Message-ID: <144f229b-fc8b-92fd-1031-f24fcc740064@oss.nxp.com>
Date:   Tue, 9 Nov 2021 16:08:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
Content-Language: en-GB
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
 <87h7cl1j41.fsf@kurt>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
In-Reply-To: <87h7cl1j41.fsf@kurt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::8) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.161.68.184] (81.1.10.98) by AM8P251CA0003.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 15:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9735ff67-3d8e-4dcb-6d42-08d9a392df74
X-MS-TrafficTypeDiagnostic: DU2PR04MB8952:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <DU2PR04MB895210B36C1BD3BAC29CEC55D2929@DU2PR04MB8952.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OtcjyIrhe5+TesxO1XObsEYwvygZaI/gOwHzOlH4ojq9M+adoxdRSNa1f4NaZReXDSaW2XUXNo1+KQul0q0wjNKhtPlufBVg3LxDFkMJtMtz56unP0eSZtKv6QrePtjMist9WoOwf03LC2xtKubb/LvGT4nHEaXw/+rORa7SM4SJ6gJWSvj2SN5XwcQDXTVoqe/hehFBEPugzNxhcFynOe33/+r8PU+D/Sz4zH/JFc0P2qUpWNhgiUwdxx7QS6aEtfn7QBQi5kWukgBag0yBqRFXMkqSGj6jF849VZqCtwX8jyOrMk0bgVtK0+mDEPRqz5bJAU/dPQMWZvgRUV4WOZ9OdHRfgoEHvO3tZM8759gTRAu6VikNFq1Hlcl5GrrGL3sH6xl/9b3XEojfCkC3Xd3Yv3FqaviSk8R0eMcPt5pM6nA1RZrGJjK+xDyQ5H78WhbiNtTJJNFG3Q5XwwZUghvfx5EaQbhd8CfppC35K8F3bvrxTvK0mDoHN+fTaQlkCaAxbbssRRyBsCFPqtml3epENPBmTcNiBcQHXRmtGusJo7gx5pR3enwL7baYLBltLjpiOyZ4VdCrlkrXy5jBeIRP/h6rDLxIUVH/rZtkZP9PEc6dRxviHJ8sr3JhdTpYCaXZA8BtmrUyZedIK8gD3QYDb84Z5bx7NPITT+temlpeK1XLfSoxeVr/yxsbbkN7O/lne/Ulp/CE2NlaQnQCtSOezVyJbB+mC1wka8I8s0ow7ZREk2qBKUPL24qVco1W0gyn97hJdxbDg7dECRdfcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(8676002)(7416002)(6486002)(66556008)(110136005)(5660300002)(66946007)(83380400001)(186003)(54906003)(4326008)(316002)(16576012)(2906002)(52116002)(53546011)(38350700002)(508600001)(38100700002)(26005)(31686004)(31696002)(44832011)(956004)(6666004)(2616005)(8936002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STl5RXVTV3BrMWVnNTVUV24xL0JSa09tRmhnUTZxbXRhdXdEaW91djhlTDJT?=
 =?utf-8?B?Z0RhQkZZVXRXbGZndTMwSzNhZHdtNUd4UmNXMm9hNmtKZ20ybzVjYm9KWkEx?=
 =?utf-8?B?VTNrUmRRZW9Kc0UybHZudWxIa0VKOTAxSDc0a25EMUsxMVBOcUxrRVdKM2FY?=
 =?utf-8?B?NHpXamc3WUllMzNhTWF5K2FOZjFZblEzVDcrWjdRaWoxV0p3RzQ2c1QxZmhJ?=
 =?utf-8?B?ZkEzUVNTMUI5NEJFM2pIQ0VxVkFzUHpnT09iS1lBRHZrSDE1UHlXNTM2ZDBj?=
 =?utf-8?B?aENMdGMzV25xRkZ1ZHBweUFsL1JSeGFhZVVQRXBBVWlwdEpNSGxpNElKL2hk?=
 =?utf-8?B?bFNTOXh2VDgvQXZZak9QVUEvK1l2dUl1R2s5d3M4M3F0YmhFRW1aZ3BTTm5Z?=
 =?utf-8?B?OVNkbE9ESTYzNVlaZGgzcVdZWDgwZDdUUHJjS2hZUlJocURueTZGbThsVy9p?=
 =?utf-8?B?TkxDd3RBMkE3UDRHS3pFbEVPa21McXhpbFNZcnMrWkRFSEljcnBCemFYVmx6?=
 =?utf-8?B?ZVNnZTcwTE0xdlI0QjZjbDJsNTFoS3QzOUtqMGRERWhrbENCaHY4TEpHc3Rl?=
 =?utf-8?B?Wnd2NStHY3pGZjJ3L2dtZm45b0hiTVpYNUNCOW9LUTNoa0RZaElSWG1YNnhG?=
 =?utf-8?B?VnBUV1pyUjZKS2VHVGtUZkgxVmF6OFVwQnN2LzVvMHowQVdoWDhZeUNtV0Ir?=
 =?utf-8?B?SzE5ZWowYnhGTEc4dmZIQ3pmZXY2THNocW85MFNIa1VXWWhjU0J3TWxJMWFz?=
 =?utf-8?B?eVJCa3ZRL1c4THJsQ3BaVSswRlRlT1FnYmNmNnhzd214ZTdhRmpxOXhwY3E0?=
 =?utf-8?B?WFZyRWpLWUVWL0xzSFRCbmlXUFRvRGpLMk9xLzkxUUZCdkF3RkFzVWk4UEVT?=
 =?utf-8?B?N3ZEcmxMUmlkOGx6aVo0U3NtTWJ6OCttU2ozU2M4V2NOYTBEcmZmOHJyTVJO?=
 =?utf-8?B?bDJDTnQzSjZOellHVkhJbCtBYXh5Nm5xUm0wRytoT2JYNTdBNVUwTkY1bUMz?=
 =?utf-8?B?VmorV200RHZGeGVqQWxEVkFQOW0vbERGTC9lc25vRzY1Ui9tS1dkUHh4aGZk?=
 =?utf-8?B?L0JIVTlBVk52Um84T3JQZDlkZHVaS2hWbUJTdXlZNUgweVZwL3k2eTdVa1pW?=
 =?utf-8?B?Y2ZIdGJ4TVg2bVp6d0k0enBXRnpIdEdCd25scy9LamRaUjRkSlVoN0xVQ2lr?=
 =?utf-8?B?djYwbitHYjRKK3BOMVhPTk0xOE9TNkx5R0RqR1ZYT0lRVlFWa2dleGFiV3Y5?=
 =?utf-8?B?TE1kVUdUam9nU2FBdW5xcEp0ay9BZlRwaHgzUXBKOW5mdDNoRE1TanRnWGF1?=
 =?utf-8?B?SmtJdS9OSCtSTy92MEx1MVlDYWczS3JqYkgzVmQ0d1FxQWxVUWRGcXNMeFM2?=
 =?utf-8?B?YlJYbEp3SDF4eDF4WGtpV1ZhK2UvblpVTndoWWFJbTNIbUV5VHNaY3dMSU9t?=
 =?utf-8?B?T1lFYy84Z1VUVVV6dktRQVBibjdubCtwUlZFZlJHQTdPakF4d0Z4MlpDVnFl?=
 =?utf-8?B?SWpSWDRJOXVOMzcxUFdPNmF3OGxiZGJsblNKNXdkYkcwN29KMGU0akt4RkFR?=
 =?utf-8?B?TlBQamN1aDVCYnRlS29BWC9NRmtGQWRsU2Z1d2VVcStWS0RKTC9Ya2NhTFVK?=
 =?utf-8?B?U21EMXlLN1VVelBjSW1MOGhLRUpZY1kyM1lxQ2tmUmlhNFI4dWM0bWRUMmk3?=
 =?utf-8?B?dG9qTndLVTBVQVlIUUp3dVZJS3kzNHB6cHN0UU56alFxWlp4Z0dJMHQyd2l3?=
 =?utf-8?B?MEVKV0Y1ZlI3VEIvUEhyZEVoZWNMa3EvZy95WGk0d1pwb2NDWTRtNVpUc1Mv?=
 =?utf-8?B?VUs0MnBPcElTeXBCTHh5dnUzLzVjM0ppTEh1aDV1dzNSOVBmTzFtYjUwVUVN?=
 =?utf-8?B?Z0pkSFJmUWJkeUN5bTB2b3p4WXlWbSt0RlozcWpGU0pTR3VxRElPMmsyaWRO?=
 =?utf-8?B?MDdpYlpYaDVXSTNEZmovQWljb3V5L0R2b0x1MC82NHd3MlNEbklKYnBBSGIv?=
 =?utf-8?B?MzVrSGlhU0hRTlZqT3NuK1lQdnRPTUR6ZTg0STRHMXF6TGhVZmJuMHVMZXpT?=
 =?utf-8?B?SjNId1B5amowTGE2c0g1NCtUYnVONFdJZUhuVDJnSStuVzE5VHJrdHUyd3Vh?=
 =?utf-8?B?bW0rNEdXL2JjOTluOGRzZE4yV1ZSNHA2Wkp4MUZUQnJzRW4zZlh6VjcyZ3Yx?=
 =?utf-8?Q?GVXY/yPWdMMhxikd3e6Asm8=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9735ff67-3d8e-4dcb-6d42-08d9a392df74
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 15:09:06.2264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmosvK3Mc+fqALfdBz78L4uo8yWwWQCfo9TKu4VqtnsXkcnLqOa6BrnbwspkyYZUx37SX/1+JD1fuBGUHes9XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On 11/9/2021 3:47 PM, Kurt Kanzenbach wrote:
> On Tue Nov 09 2021, Vladimir Oltean wrote:
>> On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
>>> Hi Vladimir,
>>>
>>> On Mon Nov 08 2021, Vladimir Oltean wrote:
>>>> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
>>>> base_time is in the past") allowed some base time values in the past,
>>>> but apparently not all, the base-time value of 0 (Jan 1st 1970) is still
>>>> explicitly denied by the driver.
>>>>
>>>> Remove the bogus check.
>>>>
>>>> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
>>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> I've experienced the same problem and wanted to send a patch for
>>> it. Thanks!
>>>
>>> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
>>
>> Cool. So you had that patch queued up? What other stmmac patches do you
>> have queued up? :).
> 
> I'm experiencing some problems with XDP using this driver. We're
> currently investigating.

Could you elaborate a bit?
I've been using XDP a lot with the stmmac driver recently, and while I 
did see issues initially, most of them got fixed by using a recent 
enough kernel, thanks to the following commits:
. a6451192da2691dcf39507bd ("net: stmmac: fix kernel panic due to NULL 
pointer dereference of xsk_pool")
. 2b9fff64f03219d78044d1ab ("net: stmmac: fix kernel panic due to NULL 
pointer dereference of buf->xdp")
. 81d0885d68ec427e62044cf4 ("net: stmmac: Fix overall budget calculation 
for rxtx_napi")

There was one remaining issue for which I need to push a fix: if you 
remove an XDP program from an interface while transmitting traffic, you 
are likely to trigger a kernel panic. I'll try to push a patch for that 
soon.

> Thanks,
> Kurt
> 

Regards,
Yannick
