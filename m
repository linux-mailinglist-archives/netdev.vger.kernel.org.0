Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62D6552443
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343632AbiFTSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343623AbiFTSxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:53:18 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D92418E27;
        Mon, 20 Jun 2022 11:53:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjlXjTq5KU8gWOdp8cHny4z1JcJHfD7atjQwqcTPtr6iitY8dvDjV8KaFlzxtxtknkIR5Yd3S4Fim0eg8p3cMi1oeD/jnD7fK1Jccp2g54eXAyBrigGSsL3aruJALBUBtHr+/SBC5AGSB2ylgDJro5HCJqsGiJgIzYI8/eo8HEeZ5amNEJGm7Wy8ZeI+/VMuMnwo1RSvGtftDPGfDXv8SPfWb4vtFCfuEnJatacqXze9tVrIVmtml0/uJ35t0CKTpnjCoAnlDstv8hBKIJCZxibBfADzCt0Pul3gEt7noE/x/gD3ZLDtdEgWKR0EPTy6RfF3TerDBKEAm6FjE//D4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GFSa9zQRzQAuOHvdZF1CA9Egvv4ZbfvbkG5jLqdX+c=;
 b=UnkSV3SUf48KRq1bRjBEXRTuFD55nRW3TGXw/H+RvpPncabZYrO7SPpUiQqXuUG2HAH9Xc4qmMRnC7fxnTw0Yj2zMj3tNSUY5cNFDmcmj0iYED04shXxQ+EpA0URtkkjmOi0VhizvsFKGpiUBariS2bbX9vQPs4g+SSuSaSDJ13qbhpeSRAUKWqy1/M1iSG+r7p9FvxfsVB8SbjeP+YPnAXr5YYJ6apdNz4rBEvowxYgoMfqGY8zJHcMhXC2vjRy90LBdJu8j89SMUfxojX28is6r5iAA2D5zyKv/2EJlyQCZroxxi4PSmXWo8/gli1/v3mxZAo8us3B4YGx9LRHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GFSa9zQRzQAuOHvdZF1CA9Egvv4ZbfvbkG5jLqdX+c=;
 b=TJgRrO9xsyrJF2Nb6UBujFxAo+4qiuBDU142NpGuIHJFezM280Wu9IV4yp7+ID3xOE7nJ033hRAUcgEx4n7SAQUihm9obB74S/7UoIB6n+rqev/8l6i+FGQuwGYvTEQxqjCeC1TO6oR9Fo23WMxSB3V6WBC2oiBn7Hwv32o+/3bgcdxku2UFisz/1kCrnc/5yAMht4zTJQlk3U0yShVB5300S1h3KgWRpbxbFjFriQY4jHQlgZ1Dxnkjbsqi0Kg2mTPIAcrQICOx6T45D4i+PORihjNQ13p/kYviAU+QSTZYm6Y4iRd1CtU0RI6RCeWLeXnvajaUkI7SnTmk6z6k9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7646.eurprd03.prod.outlook.com (2603:10a6:20b:413::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 18:53:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.022; Mon, 20 Jun 2022
 18:53:13 +0000
Subject: Re: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
From:   Sean Anderson <sean.anderson@seco.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-4-sean.anderson@seco.com>
 <GV1PR04MB905598703F5E9A0989662EFDE0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
 <GV1PR04MB9055F41AD598F85648B54EE2E0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
 <df411ea9-b12e-09f2-6f96-0fb4a023cb7d@seco.com>
Message-ID: <0c5f8436-66bf-0ed0-f556-8ff5f59d3139@seco.com>
Date:   Mon, 20 Jun 2022 14:53:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <df411ea9-b12e-09f2-6f96-0fb4a023cb7d@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:208:120::36) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4043e3a-899c-4cad-f75b-08da52ee20bf
X-MS-TrafficTypeDiagnostic: AM9PR03MB7646:EE_
X-Microsoft-Antispam-PRVS: <AM9PR03MB76463A955C729E782248F01196B09@AM9PR03MB7646.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GsJ36C1gO2gk+k3QJBvj+QWKwMI516mUg9C00W1DTqYV1Ms+t7vEfRKpDo3B9vIWu7uw5IGocr/BI/HO0sDFFyP+ckynyc57/7pz7K8OKCDyBEY1+OXg170PnMj+iSgtqeufN4g1aVSUT3uylDh4MfDq2+lHWVLqRl7jRuaiS/bWrjiF9J7+zIwLXyJw3VxcXxaScCc8PJ9OZa7bYOOkZQn2hsVQjU0nTVh0rU6RmAkRnExZNApVPaQC9FD/SBCtBYuK9jQxtFX8FJjo7rNiMps5YAh4t9FfXlVbW3gk5H+sOp3OQQy/MaebP7sov9xavCPSXE1LMPNyByEBXN7MquGA+Nez3kop5zwkoqRC85Hs0k4d9YMyEj8Jqb7eiErrpXu9tRc+YFkTQQzShyVqO0diDyTi4gk6lQLHkbWjtR0dmEXerajw6BWow/jei3X8NrIj8gayaQfvwPnSv6P3wyJTnrmRCHd3Gm2AFztwqVj0kjeoKlkrCxp+gJ4HdbeJBWvsGLG/Wdtze4BQEmTYNM7V3s4rXMWBy/a9OOyqY6LCk2Ga4sts0CIgT/65sYK10tO0QcUIPXwD+6kj8jPlLbzD+V3PW87gbTgekxB5khag8afl73hBXCr1lQJhAoqkh030P2oAhDhmXKUdN/C7a6pC5l6V5FRKd6VAKAd6Ra72W0JcW+cnE2q3bcEwyoDcKOxBkG/fMgutXSCnKKaPCVzKstI5LpkX5rz/AjyzQaw6EsmO9jctcKLkbqbaXNN4SKhHiMVXdF0rid+rGAHz8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(136003)(39850400004)(346002)(53546011)(52116002)(6506007)(6666004)(2616005)(41300700001)(186003)(26005)(38100700002)(38350700002)(86362001)(31696002)(6512007)(110136005)(83380400001)(8676002)(44832011)(4326008)(66476007)(36756003)(66556008)(66946007)(6486002)(478600001)(8936002)(31686004)(5660300002)(2906002)(316002)(7416002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTNERk40MUVIcGVOc2hEV1VnL2haWmdIVHVXa0lSY2Jkc0hzcU41TlJQODlH?=
 =?utf-8?B?akN0RXhmK1MvQVVCczNsNWFGRGxWQW0rSjVsQUJKYjhXYm5kRnIxcW51MWZt?=
 =?utf-8?B?YkJ6R1piRnBJbTFuUjBkRWhNWThpL3FKdWlmbGtqeXFCR0ZwdGh6YWZlVjFz?=
 =?utf-8?B?UmI5RHFQRUkxSmxVYXBPZWtJVEMrYmRpUEMxdnk4TTY2dVBSSTcyQ085Q29I?=
 =?utf-8?B?RzlId0xTSEFGUGYyUVp3cEFNS2Z2Q3J6dlNFbGY0dm9hc21Ca3llZUN5QXhl?=
 =?utf-8?B?Vkt2dlZTSXVFOU1XQ2JZSTVYbWh4ZGtNTFppN0pwNjBxK09scDVHM0lSUFJu?=
 =?utf-8?B?SHl2MmNrRTlZZmhBb1l2eUR6WWFTVlJ3SDJzajZBUURFNTIrUnZQYVFqSHht?=
 =?utf-8?B?SndiRGVicDA5cFBmdlpLY0tPS1RuZUdXa3J6MC9KZXRvaUJJb0J3WDBKbE5G?=
 =?utf-8?B?SDI4MStzaXljUjFxZitLSnhPUlRjSGZWM2tXUk1WaXlKci9STnlaZGE2ZjRF?=
 =?utf-8?B?cU0zM3hlM25XU3hRdG4wY2NYNHJrOWprMVRlQXFPTUVvc3M0RkpmQlZjVlYw?=
 =?utf-8?B?YlE5S2RSSkxOUjRkcnl1czYyS083VlpJTGYraW1vWC9FS1NDZFlLdWxBdldK?=
 =?utf-8?B?bWx1eG4wNlJ0a29YcmxDL0dhZ0NkekZ6UkRPZDVZdUs5WTkwL0JobWRVY25x?=
 =?utf-8?B?TEowc1UvOXRmV0EybGNwZ1FUNGRpTlpiUStCZG9pbXJ0Wlk3b0xtRnY4S09C?=
 =?utf-8?B?SlQvQWZpUUtVM01ZR2x5V2RRWHNLWjNYZzRLa2w3VUR4RU5QK0hGSEVKVStv?=
 =?utf-8?B?UTJzZjlmcysyNE9XbkpHbXVESE1xTFk4dXRTRyszc2M3TG81dWxpRTVxcXB3?=
 =?utf-8?B?U1I0SFhvU0ZxazIyRmR1Z2p4TE9mcWNLeVBjMFphN0RlS0tqWDkyTjFPdlVy?=
 =?utf-8?B?UDcvbGNHYVh6cGlXOTR3RkVNM2xhZ0V6a1dhSW4yR1lRRFdUYzh4cDY3OGpW?=
 =?utf-8?B?ckxDbHNjR0xMMndYVDVKYzBMRkdEWHBsWXErMWZDQ3hnSlJtQ1psN2ZFanRi?=
 =?utf-8?B?aWx1c2RPWkY2YS9JVVhlZFhsVGNIQzZiQjRkdVEzbUJtNGRpWnVhT3loQmMw?=
 =?utf-8?B?RUVjdnFsUzA3alJSdmhCcjhBVXhjZU9PR3JGYW9xN0t5TG0yQllZcWtaQXNK?=
 =?utf-8?B?ZmRsOHc0VmcwMkVrc21DM0hCNHNWS1NMQ1p4NXZSKytGejhyUEgyOXYxSnE4?=
 =?utf-8?B?K3RrdXlkNTBoRjdXVUxMYUpSVmNFVzFjY0FjbThFTnhiNVJrWkVSSTZsaE90?=
 =?utf-8?B?cXVPelFaRHFXZnlSYWt4RDhkY2g3RkdHVlhaVG9BZVdWcWhjaXFrZjNISnFW?=
 =?utf-8?B?UTV3ZHhCTld2WHduZjhrKy9WMWdmQ040eXVYYUdweTlmZ09jUThZeHRFdTU5?=
 =?utf-8?B?Q0dHTGhab1duYWdlLy9uNmZVZEliNnc0WEY5YnI0cUIzWnhtOHlOMi81Uk9z?=
 =?utf-8?B?N3l4SlhpcnFHTDlrZ2FkU2ZDQW10cENESERKYWhNWFdtcGEwNXZjY3ZkQUQr?=
 =?utf-8?B?NUxFZEdnYjBVTUNGa1hITmwrdVBQQ25ROStYdi94QWhGVjM5S2NnaWJqWmxQ?=
 =?utf-8?B?dUFUekVvaVlMOWRFS3l4eG1pYXJoS2NadndhTysxdzVLWmVCZGUxMlVvN0Ny?=
 =?utf-8?B?ZjNWSkJUcHNjZDR2MHkzRUJraFdZb2x4aXA3T1YyaS9FUENpa2g5S0EwbnJ6?=
 =?utf-8?B?UUswZ0paeG1XcGo4Q3psTUhEaHZ1Q1U5YmdST0hOdmlOWis4OGp1dHlMU1RU?=
 =?utf-8?B?ejJ4c0xyY1RYZFJsckt1TFFLT1hLYW1CZlA3RG5wRld1a3ljSEh2WkQ2NGMx?=
 =?utf-8?B?QmtrK0kwMDgvK0l6WGZkRkJFN3FzQkpuRjdyV3RDdkJiNlRaaXJtOWRxTjNY?=
 =?utf-8?B?N2VEWmk2RUwzcVVPbjY2YmJ2TUdSYXB0cmRzOTBSbXZCVXVhRmM3ajFJUkJW?=
 =?utf-8?B?L0FGQ1ZTejM5amtjVTN4UE42d1Rxek82bTZDWldZUmNTQXF3TGJIUHg5cVBK?=
 =?utf-8?B?M3czc1lOWUZpTFI3VG4zTjdWNTNZVlJVK252VnA2a0oyaVA4VG9ISWk3RThS?=
 =?utf-8?B?OHB6S3NTV2dvR2hjTzk3c2ZDelBKNXJwWVhkMzdRWlZFbkdpUFlEVS9BaHNT?=
 =?utf-8?B?VlhCdmtIcmdmUmQ3KzY1K3lpdUV5cjJyVkVpQlhqcyswc015WHFoREZublRM?=
 =?utf-8?B?bVhkc1lHRzJRS0Zpb0RkeFlsa1U3akMwL3ZVRHAzYkRNcEc0OTMvT0pNZFZp?=
 =?utf-8?B?VmpVQ2xQWkIyYlZ2bDROamtrbGRkaGdPODcwelY0cWZTaXVtR2o0aTJYRmds?=
 =?utf-8?Q?VaeeVAlQYKKtm6TQ=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4043e3a-899c-4cad-f75b-08da52ee20bf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 18:53:13.3210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHUZZzb9qytGa7/HrElsUjGU5lFtA42JEnwhCtXDLA3wg2eg3f+57OVEZ4VzqdA7g2UNkmWrmxEpnncRLgGW6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7646
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/22 11:52 AM, Sean Anderson wrote:
> Hi Ioana,
> 
> On 6/18/22 8:39 AM, Ioana Ciornei wrote:
>>>> Subject: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
>>>>
>>
>> Sorry for the previous HTML formatted email...
>>
>>>
>>> Hi Sean,
>>>
>>> I am very much interested in giving this driver a go on other SoCs as well
>>> but at the moment I am in vacation until mid next week.
> 
> Please let me know your results. I have documented how to add support for
> additional SoCs, so hopefully it should be fairly straightforward.
> 
>>>> This adds support for the "SerDes" devices found on various NXP QorIQ SoCs.
>>>> There may be up to four SerDes devices on each SoC, each supporting up to
>>>> eight lanes. Protocol support for each SerDes is highly heterogeneous, with
>>>> each SoC typically having a totally different selection of supported
>>>> protocols for each lane. Additionally, the SerDes devices on each SoC also
>>>> have differing support. One SerDes will typically support Ethernet on most
>>>> lanes, while the other will typically support PCIe on most lanes.
>>>>
>>>> There is wide hardware support for this SerDes. I have not done extensive
>>>> digging, but it seems to be used on almost every QorIQ device, including
>>>> the AMP and Layerscape series. Because each SoC typically has specific
>>>> instructions and exceptions for its SerDes, I have limited the initial
>>>> scope of this module to just the LS1046A. Additionally, I have only added
>>>> support for Ethernet protocols. There is not a great need for dynamic
>>>> reconfiguration for other protocols (SATA and PCIe handle rate changes in
>>>> hardware), so support for them may never be added.>
>>>> Nevertheless, I have tried to provide an obvious path for adding support
>>>> for other SoCs as well as other protocols. SATA just needs support for
>>>> configuring LNmSSCR0. PCIe may need to configure the equalization
>>>> registers. It also uses multiple lanes. I have tried to write the driver
>>>> with multi-lane support in mind, so there should not need to be any large
>>>> changes. Although there are 6 protocols supported, I have only tested SGMII
>>>> and XFI. The rest have been implemented as described in the datasheet.
>>>>
>>>> The PLLs are modeled as clocks proper. This lets us take advantage of the
>>>> existing clock infrastructure. I have not given the same treatment to the
>>>> lane "clocks" (dividers) because they need to be programmed in-concert with
>>>> the rest of the lane settings. One tricky thing is that the VCO (pll) rate
>>>> exceeds 2^32 (maxing out at around 5GHz). This will be a problem on 32-bit
>>>> platforms, since clock rates are stored as unsigned longs. To work around
>>>> this, the pll clock rate is generally treated in units of kHz.>
>>>> The PLLs are configured rather interestingly. Instead of the usual direct
>>>> programming of the appropriate divisors, the input and output clock rates
>>>> are selected directly. Generally, the only restriction is that the input
>>>> and output must be integer multiples of each other. This suggests some kind
>>>> of internal look-up table. The datasheets generally list out the supported
>>>> combinations explicitly, and not all input/output combinations are
>>>> documented. I'm not sure if this is due to lack of support, or due to an
>>>> oversight. If this becomes an issue, then some combinations can be
>>>> blacklisted (or whitelisted). This may also be necessary for other SoCs
>>>> which have more stringent clock requirements.
>>>
>>>
>>> I didn't get a change to go through the driver like I would like, but are you
>>> changing the PLL's rate at runtime?
> 
> Yes.
> 
>>> Do you take into consideration that a PLL might still be used by a PCIe or SATA
>>> lane (which is not described in the DTS) and deny its rate reconfiguration
>>> if this happens?
> 
> Yes.
> 
> When the device is probed, we go through the PCCRs and reserve any lane which is in
> use for a protocol we don't support (PCIe, SATA). We also get both PLL's rates
> exclusively and mark them as enabled.
> 
>>> I am asking this because when I added support for the Lynx 28G SerDes block what
>>> I did in order to support rate change depending of the plugged SFP module was
>>> just to change the PLL used by the lane, not the PLL rate itself.
>>> This is because I was afraid of causing more harm then needed for all the
>>> non-Ethernet lanes.
> 
> Yes. Since There is not much need for dynamic reconfiguration for other protocols,
> I suspect that non-ethernet support will not be added soon (or perhaps ever).
> 
>>>>
>>>> The general API call list for this PHY is documented under the driver-api
>>>> docs. I think this is rather standard, except that most driverts configure
>>>> the mode (protocol) at xlate-time. Unlike some other phys where e.g. PCIe
>>>> x4 will use 4 separate phys all configured for PCIe, this driver uses one
>>>> phy configured to use 4 lanes. This is because while the individual lanes
>>>> may be configured individually, the protocol selection acts on all lanes at
>>>> once. Additionally, the order which lanes should be configured in is
>>>> specified by the datasheet.  To coordinate this, lanes are reserved in
>>>> phy_init, and released in phy_exit.
>>>>
>>>> When getting a phy, if a phy already exists for those lanes, it is reused.
>>>> This is to make things like QSGMII work. Four MACs will all want to ensure
>>>> that the lane is configured properly, and we need to ensure they can all
>>>> call phy_init, etc. There is refcounting for phy_init and phy_power_on, so
>>>> the phy will only be powered on once. However, there is no refcounting for
>>>> phy_set_mode. A "rogue" MAC could set the mode to something non-QSGMII and
>>>> break the other MACs. Perhaps there is an opportunity for future
>>>> enhancement here.
>>>>
>>>> This driver was written with reference to the LS1046A reference manual.
>>>> However, it was informed by reference manuals for all processors with
>>>> MEMACs, especially the T4240 (which appears to have a "maxed-out"
>>>> configuration).
>>>>
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> ---
>>>> This appears to be the same underlying hardware as the Lynx 28G phy
>>>> added in 8f73b37cf3fb ("phy: add support for the Layerscape SerDes
>>>> 28G").
>>>
>>> The SerDes block used on L1046A (and a lot of other SoCs) is not the same
>>> one as the Lynx 28G that I submitted. The Lynx 28G block is only included
>>> on the LX2160A SoC and its variants.
> 
> OK. I looked over it quickly and it seemed to share many of the same registers.

I looked at the LX2160ARM today and it seems like the 28g phy is mostly a superset
of the 10g phy. With some careful attention to detail, I think these drivers could
be merged. At the very least, I think it should be possible to create some helper
functions for programming the common registers.

--Sean

>>> The SerDes block that you are adding a driver for is the Lynx 10G SerDes,
>>> which is why I would suggest renaming it to phy-fsl-lynx-10g.c.
> 
> Ah, thanks. Is this documented anywhere?
> 
> --Sean
> 
