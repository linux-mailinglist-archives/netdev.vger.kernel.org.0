Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7F557D019
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiGUPpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbiGUPpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:45:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1C08C8EE;
        Thu, 21 Jul 2022 08:40:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZilEPMlyfvss7Ae5cRngW6M1ih3Ty1GpCJYVOYq+gOnVXMCwF6yspNrOKqnPfo4vwHX4U4mVDHm/KuBwTSAfAovAtcF0OAXQlPhv7AtMy5oE6DfqO+HEEFvzge83C8iR5vQmzKsOcgDT+uMnMP120HekqVMR2dL1kPnrn+CUPlSvvfTzrbhGZsaANMFGdSvAnGkzGfz18+xzRI6qku1ET9dR2aa4iXlpo2BFaY2JSJpZx7h/DNxdFcZqZcWscGPS2gfaF0Xq/zkrewesAP0FglSMY4DR6BNLfWa+27sVfPcepGAteThi4YlOQbm1nAQ3BMPBLqlJDyDwe2C0rQXoVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUdcodAtvA4MgZyOlst8WfGadB2wctAQN2Y9R3e3SBQ=;
 b=GtyfOKWY5OfW6uOXKfBAmh/JxRbylUlzPBXHTjhYReiyOwuC+tsnjYrCHq4tOpOe9mzWKZq9t9hieE5WUhycz9visENtCAuhMjEcD7zUdB4wy+ZOaQUCc5/lEhN/+W1AvzswrmAfbJeU12I0j5Y9Z36LX1K7sdSnGAuzinRXmoOogMG9w7thxym0Wgvu/Z5YB4vDW7ovF+SE7fqlxpTBGPtdiaKNk5ECmt9brAyyxZpms2s1J60ThkqrOwA0+PpNuW7wcFGmgwvrWYTVgKp84trXehPskmw0P94RPKxDNwmid3f65aCD2VP/xBx110vKLrYVgMWIWiivYnAkeW6kfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUdcodAtvA4MgZyOlst8WfGadB2wctAQN2Y9R3e3SBQ=;
 b=JWJlBEl1J0oU9Abe0IkdZAGf8G+pAZOkor1EN/HO/BRwipmfbo9WNqqKIs1LgEcdkqMK83SZ+8XlyODUUdiGt0wQigKMybvunpKJsQRj6jONsn1vWrpq4JDZOCO3/NeLwP6q893Upe9NGVhXObmsFxTiRRthqpJ9ghp+x4XuPz4PcwKJpCbxIr/Ou4Yfrh1D9p1p/K7/27TLj4YNOHbCw5gkXV74XHvphsj+b4fZoRxvEfyfTOhgXVcx/oe/zlEoSsWZpIIdt2oE3w7KUAnBTB/WQC54LkIlONUuhjJNOhiEtkcjPb9ZJHLQdPxq+nTSbMIxH4DdRx0YzJ0Kqd9Rpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR03MB3840.eurprd03.prod.outlook.com (2603:10a6:803:67::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 21 Jul
 2022 15:40:45 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:40:45 +0000
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
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <5f32679a-3af3-f3ba-d780-5472c4d08a81@seco.com>
Date:   Thu, 21 Jul 2022 11:40:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB58077A401571734F967FAF12F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0342.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed303953-cfb8-4b45-5a54-08da6b2f60b1
X-MS-TrafficTypeDiagnostic: VI1PR03MB3840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VISDUWnyOM3T3rqFQ53CRJKP0TM/B8G6AHryT0XVlze3IY+HaBvVeJK85qNinvOQRfWqbC/mAvqNFV//97UowpxY2lqIGY6UWWR/LY//tHKaMy0rCruyk1q7FxrMLwG+7aFKOWXzWs2lPtf8XrBKuCukFPAcOUnQmPv9C3gGCD71KM5l7Qf//MinNKNz06VZ0roGxf/nndfigcQCuzYc6K7x1/KQYcRmgGXq7aK26GmKCVeOgzOKwgZAvNkfLpvbBkUlOv9Wogz0tIFXFZ8OAA+Pvm2fOxtGJ4dIg7fsU6sg044k5s2sK4vcH+FuhDqSfwaYjhAlenVkgqZOKeb0oRtZC3xiEbKXTQSHRoIlk6rqS7wxUGYhODd2WUYwKPRgn2hwJmdm2aezL5tyfG5/t/YYBfiLnvmaZidDZ2ZKRBJkXlOKQB/7ehWqFKD5cNqEjgqEHA26KG9hbSdBss7F7LDVAnsXFsw5/B5uYpEYH4aqnebN+pE94elpjI5SvpR07qnM9sB4OKiYZk8Zr27fZ865vrzD4wVXgshdM18C8Y6xpHu+bWWEOYCyK+AwBa8OHQjds4jEOihKnYcKUmsxbE4XvKMr6DMjkh1JVdOPmZl8810CzMVa50UYQcP7j7oIX8BO7HCoo0nR6yK+WXQJsyheCNpHqnzrT8zinn9Epr2Zas0W/skHNRzptvonMPQ2y9LZRK7x9u2js0MRNCwz+e+g4+trQElcC0IRwJpQlZAISzBUbVGD1D0rs7z+sZpZI7PW5Sn8tzAwTP0S6ZOBcC3zFJXpIpwN6lrAXy248D4uqMkWDxKKs1aK0HfaOMe6udWfDXHEwcebYMIcnBSMCJ66ZYPwTRMVs2gvA2JJAiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(376002)(39850400004)(366004)(346002)(2616005)(38100700002)(6512007)(6666004)(86362001)(66476007)(2906002)(478600001)(6486002)(53546011)(52116002)(5660300002)(8936002)(26005)(6506007)(44832011)(31696002)(4326008)(41300700001)(7416002)(83380400001)(54906003)(110136005)(186003)(36756003)(66946007)(8676002)(66556008)(316002)(38350700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1haemZIZmhJc0d1UWRhZlZpNWxTTDUvWitJeFZNU3M2WFFkOHU2b29UMmpM?=
 =?utf-8?B?K1lld0haRkdBWDE0L05scmNBZi8zdlJ3c2dVUGtKT0xtZVRzbnNvZmVjWGJv?=
 =?utf-8?B?ME5uSGpGNC9uRzU1Y1BKNE1zd0Z4WTlBdVlvaVZQY1J4M1ZqK2FGQmI2cEJV?=
 =?utf-8?B?N0FsaGRSb0NJZWtkVUJiazkrQ0xHSGo1aGFvbFFCdEovQ3RyUldmejJiV01G?=
 =?utf-8?B?bmZCRGllMmpNcW9sdk0xRldNV2VlZzZqRGw1T0pIeGRqNzFmSTYyNnlMNWxo?=
 =?utf-8?B?QUxEVmdIQWdyYUNETkVyQ3FRMm1jU3RIYXJRT3BvN2RHT09zVFVwb2pHRndI?=
 =?utf-8?B?K2pUMDZzYkhOOVdBYVpRNzBWaThVUGM0LzBTdDZObjNrMDU3NXA4TG9yc1V5?=
 =?utf-8?B?SE9DOW54bVBuazA2OS8yUHV2VFU1MnpJWGdYVVNmdU5pVTFzSzk4Q1JpVGFy?=
 =?utf-8?B?TTArZHhvYTAzeXhoWS9XMk5QRFhxd0FHNEVKSW9xb3cxaWUyNU5EKzJRNVpC?=
 =?utf-8?B?WGpQWFo0UzcvT3lLK29YZTI3aXFUYTBZbWpUb0kyZHE4cVNDTlQraHJhNGp0?=
 =?utf-8?B?N2FjS1FMR0JiMlFIdHZyNUpJbEZLMzFXV1lLQW5TSW5WTGZNNkdiV1Y3SWQz?=
 =?utf-8?B?ZERkeWN6cFhlYTJPNDVBbDQySStRTEtYV1RZb3hMRGZTK3BRRm9icUxzOExF?=
 =?utf-8?B?d01TalpZMXF5VU9PK2U5ay9ZS2NhUXp5djJHc3B3OTdKaEZSWEFGUDdRVGZW?=
 =?utf-8?B?UTd1SkpMUUMxWUN5aTYxcGVHbUJNWjEzSU5SaU83MnZpVEwydFk5YzRuOEFz?=
 =?utf-8?B?MENuNmdGQTZFWTRPYmpLU2E5Ryt0TXUvRkZGV3NueGFMYlQzQ3ZuS3FXRHM2?=
 =?utf-8?B?M1JmSUhGWG9veDhkSVlpbkVFTE5wQjVTWlBjWVkxNW41UTN0VHkveDExZytS?=
 =?utf-8?B?NUJUN1llR3crZUowUTRjd1E0QXQ1L3dIbzJyY2QvRWJvZ3E5dFZPemlqd0RO?=
 =?utf-8?B?WmpOUVRCOVcyVmdsUWV0VkVKSXdlT05RQzExV0E2akRKOVpqa2tBY0dwYjlC?=
 =?utf-8?B?WmM0WGtaL2tRV3hLMVhGUGNNNldncXF5TFZJQ0VxL01mUi9lNlFtWUgrUkgx?=
 =?utf-8?B?ZjVFT0piM2pyS2J3MEdDajFQVlRJTjUwU3dveGxtZHRwdkRkUlNWT3ZadHpQ?=
 =?utf-8?B?aFFCOHg2SytNTU1ZSlpGMXQ2U1kyd3pzamM1WElrMERoaWRLRE5ySTEvUlVx?=
 =?utf-8?B?bHJKQUlVMnZxYjNTejJTTlRpTWVoYktKaWdzdmVvWkZlNUdKbVpybTVCeEJw?=
 =?utf-8?B?dWw3UHIwOXBpZTc0SnA5RjNEeDhkN09RODQ5ZlV4NjhRb3JPWEtXcEkzVDJl?=
 =?utf-8?B?QklRdm1rNDhyOUF3Y3Rld0JUMjJuYk02cm1DaXZ4NUZiRHFuVkZFeVc5ZFpr?=
 =?utf-8?B?aGpJVk1iY3lUc1I5NW03R3ZncVFXQXpKRDJIc0FrcnprZGZQU08zWEpVdnRh?=
 =?utf-8?B?RDNVc00zdW15dVhYY3hSYjErc0N1NnZUMnhYME1NSGNpV0VNUVdyUitTdHVO?=
 =?utf-8?B?dFpMcFlVYWxFcm5QN0I5MXdIMUJzbk05NnNkUUoxOEVrbERWV2hjY0psZSsz?=
 =?utf-8?B?cWltMzk2QmpwOWVMZ1BmeTkrblpIdllkWG1HUEpLWE91cHBOQ3V3a3F0YXI4?=
 =?utf-8?B?YzJUdDRTL2JjbGhMYVIwR2krRjBQMXR0N1pCb3lIcUxUSHJ3NUtMbDlzL25v?=
 =?utf-8?B?S1JIZFF5ckZKMk9EcXI2Tjk2Q1IrR0szazhQa1ZReThiUGM3QytMWnBlbzM3?=
 =?utf-8?B?WnZGeWpUMmkyRUd4TS9raTViUTMyZ0xXMm9aZW1DK2VxUXc4MkQzU0ozOWlM?=
 =?utf-8?B?QU94TVFHbjVVRUNDcy9JenJRdGdIRnBoUS9jeE5FaHhsM1ZxZktObXNpbGlS?=
 =?utf-8?B?RmJMY1dWVnJxYXlXVHEwUjBuQTFCcHdnTzVLTXVWbHp1ZktwR2doQ1pkaW50?=
 =?utf-8?B?NUZyNmg3TnFYU1MwbDd1TndHVmxVSlhyaDRsbkFTRFRqd24wUTFadDc4djAw?=
 =?utf-8?B?cng1ZFJjTkxsYlFLL2I3SzBkR3N2MGdRZXA1MlBXK0h5MlFtZFRaQmdadlZl?=
 =?utf-8?B?QnE1VS9lczRzczUrbHNaU0huVGw3QVYreDFsWmpzSm54d2FUTFg4OUVTR1dU?=
 =?utf-8?B?OGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed303953-cfb8-4b45-5a54-08da6b2f60b1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:40:45.7935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQGx2vi5laloRfF7trp9DHbwK4lr4CoTowV/IRTj2N+qQj0ajxrUYZhU1abZOg6c5m7njfLKRCnQ9akfapiI1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 10:20 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>; Kishon Vijay Abraham I <kishon@ti.com>;
>> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Leo Li
>> <leoyang.li@nxp.com>; Rob Herring <robh+dt@kernel.org>; Shawn Guo
>> <shawnguo@kernel.org>; Vinod Koul <vkoul@kernel.org>;
>> devicetree@vger.kernel.org; linux-phy@lists.infradead.org
>> Subject: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
>> bindings
>> 
>> This adds appropriate bindings for the macs which use the SerDes. The
>> 156.25MHz fixed clock is a crystal. The 100MHz clocks (there are
>> actually 3) come from a Renesas 6V49205B at address 69 on i2c0. There is
>> no driver for this device (and as far as I know all you can do with the
>> 100MHz clocks is gate them), so I have chosen to model it as a single
>> fixed clock.
>> 
>> Note: the SerDes1 lane numbering for the LS1046A is *reversed*.
>> This means that Lane A (what the driver thinks is lane 0) uses pins
>> SD1_TX3_P/N.
>> 
>> Because this will break ethernet if the serdes is not enabled, enable
>> the serdes driver by default on Layerscape.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> Please let me know if there is a better/more specific config I can use
>> here.
>> 
>> (no changes since v1)
> 
> My LS1046ARDB hangs at boot with this patch right after the second SerDes is probed,
> right before the point where the PCI host bridge is registered. I can get around this
> either by disabling the second SerDes node from the device tree, or disabling
> CONFIG_PCI_LAYERSCAPE at build.
> 
> I haven't debugged it more but there seems to be an issue here.

Hm. Do you have anything plugged into the PCIe/SATA slots? I haven't been testing with
anything there. For now, it may be better to just leave it disabled.

--Sean
