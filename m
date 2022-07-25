Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913775804F3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbiGYUC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGYUC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:02:26 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6C913E8E;
        Mon, 25 Jul 2022 13:02:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF3xRa6lvBfAL/OgAPMv0FhbpyQ4nt3MF0rMYWPJSz9RIH5YOJOi336hLB4sE66JmHyjzue+unAlpRUUCLNiif10mhMyFMWqCyiBMhaNqJ/wEmegsudoC+qRWpA2aldOUkAqCoJS+F2bkjx1J0UxfwbCL6YuXCQrjyrJ9GFs7vqCC256wPWrILom4FmCSrB2XHjNVdYaqyqQ31M4bFdWzS3r7LEomiNwpHl8zCb1VPLpFry4D7Z6F4Gyi0x3sjGMO1N8UTijn1smKXYKh/ArojnzD5YZKid7SG/C3LbZlb4ti2JNUvqX0pgCskxVVmlR1PH6blYi7XAUHc90jhqQQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Kzk9rC+jGuLCXV8geD8PzTImMd1Sz+VQiP9jYvbQXA=;
 b=PjhvHT8d55EWOD982erepstk8HsIyg0wP7NP0GO5JwbzIL58ud4xF3LBD+f4Sg1IebPmXtjnMw9/eu25PiduNqhD2P196mcTiwmyirqD+PMr8+DJDy1SD0g76s3LYv2Mm2W5qikSjA2uaeos5QknJMA9cQ9+W6e2zZqm5/ncMBSDizJlj8kYT0vzzihqUkxLomnS7YuhGbbCxYrQ6X1Nd7tJvzT1MAJlnjbMB9MJP/AlmVe1uWA4uvOv5fEoXJWqnAwzPZ6ff/Pnr1T1KPq57UffxeebQ8tgdB6hxlFUvMpukbmrOCl/E5YCdqCFkZTJceFfIg017DWjXBm6HVkPpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Kzk9rC+jGuLCXV8geD8PzTImMd1Sz+VQiP9jYvbQXA=;
 b=LbMrvf6xrGvGpSVfGAsJr9GiLS7wdDVw7J/5ps92cv1Kt/djQ/8q4L8mk12lNKxjZukAWwPSLajfq4yuOJoTGOEoCr7VTr8joYvHMismut/hvDLbE6JcDf/YSC1iWnZBIuHmv2oIarZb9SH/27a/w8VRFWKTfykpAAbi0vtKv+G1HCoIJ0uyO8N2CZ1REL7ORpXCC6yyZvDOnUTzOdEBgQ8H0xt1lVZzyJaaah7wPD0PeZRrv7liltwPnuMI/KzzTGXyfdGvqnc9eqznL5+WEHCikOGEl+Ly3aIk0mgOvJ1ZA1S4QMJL/Tn/FPfW8goEt/hljhITETvzZoZo1X/t1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GVXPR03MB8401.eurprd03.prod.outlook.com (2603:10a6:150:69::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 20:02:21 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 20:02:20 +0000
Subject: Re: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-47-sean.anderson@seco.com>
 <VI1PR04MB58077A401571734F967FAF12F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <5f32679a-3af3-f3ba-d780-5472c4d08a81@seco.com>
 <VI1PR04MB58076F8E57D04F5F438385DCF2909@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <787a4a58-2900-9f06-bb41-2ae96f70b025@seco.com>
Date:   Mon, 25 Jul 2022 16:02:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB58076F8E57D04F5F438385DCF2909@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:610:75::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7485d3c6-475a-4f1a-2e86-08da6e789553
X-MS-TrafficTypeDiagnostic: GVXPR03MB8401:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2Hprqg24gtgXf+JB2g6GDYMT7AxXcCAPBjZbgzMtWfPne01uxTvEJMdM/x4npXhr2vPhpRq4GGWl0cyxFslDiX0PMX+2c5uZ9GRQhSjK8hWrUs2gDP8tbn5ZYHz819coVQHqJwZXUKs9hTwPTl9ZHHbVV7sicDDOLbol4ck3RCzbtz6qcP203J6xEIYMI+PYC5oDxx7QpR/bxjyr3L6gz5ahm0ZD2jdvq4nZFUNh3CaSwi4GQ3HdHiMKpDOPazJTpEu4SNSpdfntxZXsB3K+MV6PrXcqjl/orYG/4st9+nGrXnzvxe0ToDRXhBx6kYk3lWjFYESKubLcnqEFc2NkdcFGy4xAxtw7gtZ9VwT5yYgMHOp2RMCvw7QYUp0jVDl09T6ZwO1V5DYa5OLIebkYknLJdtBJEqmVPhHcAgAtPzgIlTNWJmLKmvdN8mL3R5q/Qszyt6Mavj44VgAMBls/Sf1wSH/i8VTN3IpxchsbBKQexs9zgwphchXsOV/jlBEATT5Vm4uOHaqxW0pGUlINz1y4goJRVY7esPYrF5+u0VAqSiFFNHvb5N2tOZMbSHn9tnHrxphERyU6394SKmrShJO/7XZA00a83/1QdD0MobkT0xZpX9Is6sWpRvDTXqAbQW9Bylp67JSP3obYg7/JgxRvUetLc9AWRPthkVwkRr+tnoz+KWiMteo+0n7fh1q2kAMRr06b1UngiulRI4mG3ukpdWNJtTagecc62DERu4Vz6Xs9U2p2/HMT7OFT2etvjcSbBxQ9zqgGf0ntuZRhkRugiwn7q0bQvCFMCTyVdniRcC3dWJFKXLqCMAdSfWBm/qyUNDtLJwGJZd6Jqg7Zqy855oiZWxgtM9pEQNUi0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(39850400004)(396003)(346002)(2906002)(6666004)(53546011)(41300700001)(52116002)(38100700002)(38350700002)(186003)(6506007)(2616005)(83380400001)(6512007)(26005)(66946007)(66476007)(31686004)(8676002)(36756003)(66556008)(4326008)(86362001)(31696002)(6486002)(54906003)(110136005)(316002)(478600001)(5660300002)(7416002)(8936002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bndxejBsakV3bldGNVBVa2RxakNsU2xBclZyTU1qL3dVK0RWZUY3TnZLZzV6?=
 =?utf-8?B?OVZaLzJCUTJOc2o0RnBXREcwcVlhZXczNDc2WFpmTmdTb1JVcDdRTk4yVXlG?=
 =?utf-8?B?ZDU4eDR0NjJMQXNXVXFVQ0JoSytUaTBkZEY0RFpHK0NNTGVtSzBrYzMwclFI?=
 =?utf-8?B?ckRVQzJNbE14eGFDbHpVa3ROMWxSNXIxSVJPSzg0cHhSNGZpanpnbjhxSjB2?=
 =?utf-8?B?dFE5eEdMb1A0bGJsMWVNR2thd3pFVUkwZUVDZU1RMDhkVitDUXlmQXRjWFFJ?=
 =?utf-8?B?bmE5MWJhVWJ6dC96enZlR3cyM1NJd3Y0VUVaVnlicUNsU1VsRkhwYXRaUFZx?=
 =?utf-8?B?RGJHaFVqcG9LU2syeGovNG16b1RSTEZoQjdyTThwOUdwOG5ZZDRDZHJIaVQx?=
 =?utf-8?B?cThzV05ZR2VPQ0RPMGZFdkpDRklaUHhmL0JNNitXMGgvRWQvRzl4aHg5bVFN?=
 =?utf-8?B?NjR3UWVxWUwwVlVmQkQwY1dXZklHYXNESmdsdmhoMEZxQ2IxbWR2ZmFORzAw?=
 =?utf-8?B?c1c5T1Z6RzZCR0kxYm00YU1IZVE4bWk1USt1QWVRaXZLSGlBelA5ZlR3emxz?=
 =?utf-8?B?YWlqQTc0Mlp0ZlE3MlJxMmNZSERvV0k4djJNb0UyQ0w3eFJqSzJDK0x2UnpU?=
 =?utf-8?B?VlNNaXlTQytGa09MVWtndWRkeGZqSndMaWQrcCsyVnJGQU9WSnpsN3Bpb1d0?=
 =?utf-8?B?Ymc3RjI4Y3g0SWxhOHA1R25UVkwzQzhUSzZvRkpUdVcvVjFTZU9JcFF5Zmdl?=
 =?utf-8?B?UXlwcTlMTFVqbHFwaTRZMGMxYnFUZmZBNkFUTGc2VzVzYk1LRWpvWDZwbXBY?=
 =?utf-8?B?U092U3NYdWZuVmVSR3F1eGcwUjlydS92Y01oRHU5di9zMlBiUUNsUWpsdmdn?=
 =?utf-8?B?YTVHdjVLTXhCRjVycGo3UHZSU2cwa3NLSkoxT2oxVFFQWU1rWUk2YWttK0Jy?=
 =?utf-8?B?bHJxWVZOMWFmTm14aitja1hmL2ptbW5zZDJsQTY4QS9Cc2lLYUtKSGZROW9y?=
 =?utf-8?B?RnkzWmd5bVJsV0xtMGc3eXdvSmpYZ3VPWXh4dDRNQjhBcitaakdxK1VJdnlR?=
 =?utf-8?B?c01ZRGQ4UEJNSjFta1ZnSmhQZml6bVplSkg3VGpaM28yS3dmOFByZ242TFdI?=
 =?utf-8?B?WGNwLzNqOWF5YVFSeDEwZkE2UmpRRURwbElEUTl3cTRDT2JmKzIxOEdkQXE0?=
 =?utf-8?B?VCtiV3M5ZjNORnZjYTVWTjh1OC9QdlBxMlQyWitFMitWTk1LSWxDVmU1N3lB?=
 =?utf-8?B?YUZPdjhzbllnWCs3YlpWczFLVUFQaUYvSEl2aUNnM29SbndmNlpCWFhqOHpE?=
 =?utf-8?B?dGxnVVZPaFpyMkhyNHBuMWo0RFpCbnREVjl3bnpYVGRBcXgxdEsxZjBMQ25l?=
 =?utf-8?B?ZGJhb2lkekVnekxCV0pRUkhyWTIyOFRBdFMrc3FUaUdBanFDYURtaXZnbW4z?=
 =?utf-8?B?d2tRanJkN0YyNStjTCsxeHVMS3ZtV0VvNHU5ZDJwamJFcVJpU3N0Um9lMW84?=
 =?utf-8?B?Z0pzaE90ZHQ2WXBvZ09HNlJyeDAybi90eUR0MWFlVkJBSHdyZGZubG10TFE1?=
 =?utf-8?B?ZDlvODdSRzZ4WnZ0SDlHd3dQdGVqRXpPNkhOT2s2c0NpUnMyYllEbjhyaW5S?=
 =?utf-8?B?SU5FSkVoWmtLMWd3Yit2WnNqL3JLdldFaEhSRGEzSGhaQzVFTVAxbXptdHFE?=
 =?utf-8?B?WitWYTNVUnBaSUk1UllWaHNIQUVSelZUSTV2RXNiMTNMK3FiYnZ2a2o0TEsx?=
 =?utf-8?B?TTBPVGlTLytHNzhkZFNhY1Z0Y2EySkxMZHVGOVFnYW1hN0hzdVBvZm1ySHlZ?=
 =?utf-8?B?VW4xVlJaQkFZdkZxUmEzVldIU053UnJTcjJaWFVwMHFmMGZQTE5wRXB0Qndi?=
 =?utf-8?B?Ylo0MGhtNzRSa3dxYXJYUWd5RFhXNi9DcTluUjQwbDBDWGd6ZzFUTk16aFlF?=
 =?utf-8?B?dHNIWU9tT3VQczlpR0I0bHVTeXRCYTdVOGJ2WUwvZmdlM2tKTytjSmk3UDhh?=
 =?utf-8?B?b0ZJS01RV3NwT1o5ZkUxd3ppQm5SelVIOWFlNFl1Y2dRKzQwdEJBdnNqN2NB?=
 =?utf-8?B?a1EvNDhNUE95aGlHYmlscy93TmgvY0J0cXZnQ2paODRtRjdPbUg5bitmdzZa?=
 =?utf-8?B?enJlQW8vRUZyTWFMcWZZZ05STS93UVFDU1JhVzllSGZUTkNDMnpVYlpGdzRh?=
 =?utf-8?B?VWc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7485d3c6-475a-4f1a-2e86-08da6e789553
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 20:02:20.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFts9rTy41E7CJTwDnHSqpNeNZLsnQ/+R/rgmxCKEeoaCtpDL3UaLLJ2j14QhOZUj51LJIsnDd/omdytkWvYzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR03MB8401
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/22 8:41 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Thursday, July 21, 2022 18:41
>> To: Camelia Alexandra Groza <camelia.groza@nxp.com>; David S . Miller
>> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Madalin Bucur
>> <madalin.bucur@nxp.com>; netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Kishon Vijay
>> Abraham I <kishon@ti.com>; Krzysztof Kozlowski
>> <krzysztof.kozlowski+dt@linaro.org>; Leo Li <leoyang.li@nxp.com>; Rob
>> Herring <robh+dt@kernel.org>; Shawn Guo <shawnguo@kernel.org>; Vinod
>> Koul <vkoul@kernel.org>; devicetree@vger.kernel.org; linux-
>> phy@lists.infradead.org
>> Subject: Re: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
>> bindings
>> 
>> 
>> 
>> On 7/21/22 10:20 AM, Camelia Alexandra Groza wrote:
>> >> -----Original Message-----
>> >> From: Sean Anderson <sean.anderson@seco.com>
>> >> Sent: Saturday, July 16, 2022 1:00
>> >> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> >> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> >> netdev@vger.kernel.org
>> >> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> >> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> >> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean
>> Anderson
>> >> <sean.anderson@seco.com>; Kishon Vijay Abraham I <kishon@ti.com>;
>> >> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Leo Li
>> >> <leoyang.li@nxp.com>; Rob Herring <robh+dt@kernel.org>; Shawn Guo
>> >> <shawnguo@kernel.org>; Vinod Koul <vkoul@kernel.org>;
>> >> devicetree@vger.kernel.org; linux-phy@lists.infradead.org
>> >> Subject: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
>> >> bindings
>> >>
>> >> This adds appropriate bindings for the macs which use the SerDes. The
>> >> 156.25MHz fixed clock is a crystal. The 100MHz clocks (there are
>> >> actually 3) come from a Renesas 6V49205B at address 69 on i2c0. There is
>> >> no driver for this device (and as far as I know all you can do with the
>> >> 100MHz clocks is gate them), so I have chosen to model it as a single
>> >> fixed clock.
>> >>
>> >> Note: the SerDes1 lane numbering for the LS1046A is *reversed*.
>> >> This means that Lane A (what the driver thinks is lane 0) uses pins
>> >> SD1_TX3_P/N.
>> >>
>> >> Because this will break ethernet if the serdes is not enabled, enable
>> >> the serdes driver by default on Layerscape.
>> >>
>> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> >> ---
>> >> Please let me know if there is a better/more specific config I can use
>> >> here.
>> >>
>> >> (no changes since v1)
>> >
>> > My LS1046ARDB hangs at boot with this patch right after the second SerDes
>> is probed,
>> > right before the point where the PCI host bridge is registered. I can get
>> around this
>> > either by disabling the second SerDes node from the device tree, or
>> disabling
>> > CONFIG_PCI_LAYERSCAPE at build.
>> >
>> > I haven't debugged it more but there seems to be an issue here.
>> 
>> Hm. Do you have anything plugged into the PCIe/SATA slots? I haven't been
>> testing with
>> anything there. For now, it may be better to just leave it disabled.
>> 
>> --Sean
> 
> Yes, I have an Intel e1000 card plugged in.
> 
> Camelia
> 

Can you try the following patch? I was able to boot with PCI with it applied.

From 71f4136f1bdda89009936a9c24561b60e0554859 Mon Sep 17 00:00:00 2001
From: Sean Anderson <sean.anderson@seco.com>
Date: Mon, 25 Jul 2022 16:01:16 -0400
Subject: [PATCH] arm64: dts: ls1046a: Fix missing PCIe lane

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 0b3765cad383..3841ba274782 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -532,7 +532,7 @@ pcie-0 {
 					/* PCIe.1 x1 */
 					cfg-1 {
 						fsl,cfg = <0x1>;
-						fsl,first-lane = <1>;
+						fsl,first-lane = <0>;
 					};
 
 					/* PCIe.1 x4 */
@@ -543,6 +543,14 @@ cfg-3 {
 					};
 				};
 
+				/* PCIe.2 x1 */
+				pcie-1 {
+					fsl,index = <1>;
+					fsl,proto = "pcie";
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <1>;
+				};
+
 				pcie-2 {
 					fsl,index = <2>;
 					fsl,proto = "pcie";
-- 
2.35.1.1320.gc452695387.dirty
