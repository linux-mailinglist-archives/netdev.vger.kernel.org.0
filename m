Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE724550BFB
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiFSPxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 11:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiFSPxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 11:53:52 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE4AD2;
        Sun, 19 Jun 2022 08:53:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpY/t6wdcwj1XQDhCHGCkrhMWJHGa9sxFUfFDTEHjdpa6P1h+wTNrqNP5MjwA4qYqdMghF2t8LKk9W17RG4dfJJeQNAnfnXHu9H4WCfsjd9x5bcvoWUW1BXvhhlfuh3oAPc+ajknPO/xZ9i9U8CJZ1PeJDpkrPgGX4Uv8HT4KcbgsoGYrHP+SCQ7ulEBEFr44t9xJ3xRohIbt0jkjIS4nTD4REIQJnOXNJYEHhvNE/Fz9IkB7BUY7Z6XBLamCd/fSyV1/RwPu/Hb8juiToLPE11EA0v0vEUYpSMFaO0LQK47yLRJEjlaBPeCtKCDu4gaKCghVdMiz5cAHup/RILrpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkFnCpiypT53bMIUZI4FqbR/zUprLyg8ws8Xc4rZ7bw=;
 b=DJ/q0BzvupKPeSOkpAkY7Oyx63HyFV/DjRIw2bDNHmhXFAzT9f6NX0HpqYzCmjop0V+n7LGNgzC3UTzwUKaeMonU0mfpUHCY8fvCjz986hv1GpfeN1Oea77DLi7fAF0zSz+9flKbv8xgx7QFbzsKPiuRJsU830Mw17nXYYHtdEfMZOHfdO5B28uivjUtmDm73Z41jus+v02sKfd/GcoVhEoE8UfuPbhmgx7lZlw894wAHfwiZNxz2STtz+3wMnqrv4KmGH3WOJ2QQFbpUBhT46nb6/pvga6HnjZC56m9R1NJ2vWWy0WOY2R+7EN444EV8a8gxk625aoTLXH0kSGxCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkFnCpiypT53bMIUZI4FqbR/zUprLyg8ws8Xc4rZ7bw=;
 b=Pj09Syf0gWiIOjau/PL9r5zPpYspPHNz0FlHOFo5Y02tGx9MsWrfNtXGojTZ6zZy4iyheXG3PfEozNltaD5yhulebeX07IXHW61uTW2VUpbPet3VhYUBPIAtIotVvzhGOekcfoybswwzQ9SVLnY8GFDs86Lhv/6nFU6qtJKE6oYW3Yli2yfWdy8tLxeIDY4SXFYyCAasDV5Bxb9h5erjLdmX48UYq3WmK1M143IVRWRK+QxNDDHFosnCf7UBcFsJCkr30HjOACyAwJoQBgICl9VJR7z5S5A15HQR/uYrHK7l6oPT0kL4sZrgksE2Xhv2aBCCOhcWW4lPFp9EjvCmHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VE1PR03MB5215.eurprd03.prod.outlook.com (2603:10a6:802:ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Sun, 19 Jun
 2022 15:53:46 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.020; Sun, 19 Jun 2022
 15:53:45 +0000
Subject: Re: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-2-sean.anderson@seco.com>
 <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
 <535a0389-6c97-523d-382f-e54d69d3907e@seco.com>
 <d79239ce-3959-15f8-7121-478fc6d432e4@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <e6ed314d-290f-ace5-b0ff-01a9a2edca88@seco.com>
Date:   Sun, 19 Jun 2022 11:53:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <d79239ce-3959-15f8-7121-478fc6d432e4@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0279.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::14) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b6e7766-7a72-4bfc-60e1-08da520be459
X-MS-TrafficTypeDiagnostic: VE1PR03MB5215:EE_
X-Microsoft-Antispam-PRVS: <VE1PR03MB52158EA41B16421711F3EA0F96B19@VE1PR03MB5215.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zsfPyyOgtIOO094dunJIq1PQKndMlqpUhupgBNFDjqW3gE+cHgypjAi7i2TQR47DzuL8E8zXv4PYBXAJkodqro8eOL7v7T7nzP1q8rMtnR1dhiUYE0HCnzeyrLDotKZJiXAoa+kknexQQrjnjEkoSEwIbhOw+dvJB/EL8/KTIpL5+l3nLBsMCznntPoDBlGhRbN4gH7SP8OK6krBHwykARTuVGpHuA1pdJ9/Kc6ge2YcUEEOrtCH9VkxnrAnMgZGZBVZBAE87bnmAHlb2B+5ivr04K2hjKVoqTW+tzSlcDNi4FY/JT5y9+xC7xibsFxMTICr5rgH8HdFCBG1gKboCjKwBBllve8LeLiRrQOhDoEcIXRbIABKdBdKQqqj7/oOgLqfDbU5wIqJ8enPSSpL9Eu1CIhfiIOA3Ajd8qtYjsvABLQ4orNeeJvERHRcgpKdQwOW2oCphwPX+f4mgV1vM2Y+yZPwRIZYq0eESAw9MeM7eszU7Bg4HF6k2X4bPoSEyA5rN8Da0BKD+h0zZh5BbiFaQwwWmgd1BLR8qDcEnFVeG5gdYl4GiJq2MmCA/175l0T1D7O+vDWhRPDxuvDedhfC5Gxi7ll6OT+Uoqr/MKSBuEk35LU7eMFrDUmTTDnMDM13t9x4LzxscgpoFL2QMzXhRdpwxB27wHzMnsIh0EgfH66uARyVZLmJTmXuc++Ef6+N4yLO+Utstzw5ft9CJAk0/FdB1mcEzTs4IkJeSWOXJ4xKJDxuB8xeqtA21H1h1gIEtyyIIzCPf/NTRr9b4PbMNqrkfRBIrCvyv5BDE152uiWH3fVxCupSAPEInr7Bq0ffQ19mESRsv2FzfIGSmzjH5RPN3yQ2SAO7i5KueDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38100700002)(38350700002)(8676002)(53546011)(4326008)(52116002)(6506007)(6666004)(83380400001)(44832011)(2906002)(31686004)(6512007)(26005)(36756003)(6486002)(966005)(5660300002)(8936002)(31696002)(7416002)(86362001)(186003)(2616005)(498600001)(66476007)(66946007)(66556008)(110136005)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3VxNmF0UWxzQWdWTFhmdWo4dm93SVF5NnIyVFJaSGRwWUhMNnlpRjZTQzY2?=
 =?utf-8?B?UlNRNnBqTklFY2hmSlhGQU52VmI4T1dadktlNzlTV3RqZmVBUHFlbG9JeUY0?=
 =?utf-8?B?cmcvNS9oYXlFM0Y1bXJuWTlSWXZlSUdERFpaS3lubDlia3JaRGMzb21vZldE?=
 =?utf-8?B?dk5LNVQ3ZmpiMm9iRDJJNGFwbnc0S0FZMU9pbGVXR0xLYU1MQU9lWTA5UzlN?=
 =?utf-8?B?Qm1MMFBMYzlnKzBGL2YrZUJ5OE00c0hoRkh1dnlxY2JveWIxL3FlNkU2WVB5?=
 =?utf-8?B?Z3psdDE5QXFEZVNaVVhMcmhuYUlXaVBncm5lOWhhRFRYdnRrM3N1WGNIcTJD?=
 =?utf-8?B?MmlFbzJVYkxseWZmb1BYWVB1aWlCSDJiRi9SdE10bVJoQVlkNDM4ODcxTmt2?=
 =?utf-8?B?WEk5ejYyb0kvZlNNaExnS2VhNzhsNHppeUk0R2k0aE9QQ0hQNTkvTE5xVUhY?=
 =?utf-8?B?d2hhK2g4OEV0OGNSdHZGdDRpL3FiajBNV0s1NVhaSXZHZDhXeEl1SWxtOXZB?=
 =?utf-8?B?aEM3K0NWRndRS1pTVGU5ajdpS3I2NU5VYXRtN2czUDJlL216OHZ5YU9ZWENp?=
 =?utf-8?B?NlNvUFQ4bFpZUmxKbXpISHJpRW5EUVJxeHpjZXh3T1BCVklHVndIWFJVQTNQ?=
 =?utf-8?B?VU9tNUJackZNc1MrTm9Jd05oWm9aRUFJQjZ0dXZ2K0k1Y3ZYTVE0b3RlN2d4?=
 =?utf-8?B?ZTdHYkw1N1oxbkZ0SzZOSHF4cFdaelRpSnFTRkkzemhiTFRiWEY4TGJlYUl0?=
 =?utf-8?B?RjhwYkNaekhTaEM0SHRxdmx4SWgxb3VCdVp4WldoSWpDUjhsNHVzaVlWWWJm?=
 =?utf-8?B?K1VBUVlNaWxpdzR3eHFkTEZBMUtPSUIzN3NSbGEvTFErUTNNVlp3eFlyRDkv?=
 =?utf-8?B?SkVQeDBCZ2VDQnhhOXk4RUlpYnVsWjBIZWdwUVRRSnQzTm1BSUg2QnBiNm1o?=
 =?utf-8?B?MEhNajg3TXNGSEEvczk0OW9VRDNzNjJVR1lqRDdhSTg5YUVESUd2Z1ZNaG5x?=
 =?utf-8?B?SWF5a3VTUHFYcERBMzJqMGQvcWhyVWcybHZtWkJieFgrbXNYRWhBbVg1K2xF?=
 =?utf-8?B?ZEZqR2hKcEJxRXN2dWZHeGtrNWl0cC85MVVoZTRueTVIQ0JVbXRrZmxuaEds?=
 =?utf-8?B?Zjh5WXJaZkJieEdSc3FtN2dPSVQ3TzFJdWU4RWMyTGNwb1VHb0QyVU41ekQx?=
 =?utf-8?B?eEtxNnBWRFc1RnpDdDlCSTdlNDJNS1g5ZnBwMHJWUVRsOTNKaWV6Q01nMWo5?=
 =?utf-8?B?VmV0QnJBdEs3aUhVK3d1ek54RnJCcFVyQis4WSs0UkhseStubTkxaHI1S3dF?=
 =?utf-8?B?bE5hMVQwcDNIQUd0ZVRVNStIdmt1QjkzUkpiVDVVeE93aU5HUzk1OU1zWXRs?=
 =?utf-8?B?ZTZKYWdxcm9uRlQvSjZMQWY0c1VpZWJHWEpTcHVoS3N1d1RlZ0NSdUxOQVk1?=
 =?utf-8?B?c0xNd1o1OGpaYVFKR1NDR1NPeS9jaTZJOW5GSUp4ZmtpZk9ENTV3M01sR3JC?=
 =?utf-8?B?ZWFlL0lkTjhRZEdPZFNIUHkvWjJFakp6RmVtUGxTMldVTW5SQThqMktpdGZP?=
 =?utf-8?B?OTdLUURKc1hCamgrZVIrOU8weHZmVlllMFZTWE9ENWFCSEM5ZFV2WEt1cVNk?=
 =?utf-8?B?ejhsODA3dUY1Rmh2alM1bjIwSXBvS0JWUDl4RHV3R2tYbzkwM0djV3AvUS9E?=
 =?utf-8?B?ajJxcXJtQkRtNkgzS0NlbXBxYVJhZy9JZVVkM0hOcE5zYTdseWJnc3A1bjZo?=
 =?utf-8?B?S2lQQSs5dHkxR1hkUHN2S3ptRkhwMllMblBiakV1Zklvdno4VXk4RGFJQ0pm?=
 =?utf-8?B?WE1EZ2QrUm1pYU1sYTVmdWMxRExoLzV6SU1UWDR3WEdQTzNjZ3lqQlhES21x?=
 =?utf-8?B?R1ZCSHBvM2plOUYyWHFTVGxFekF2Y0U1VEpuR0t4VnROcGZ4alFFR2kzaHJG?=
 =?utf-8?B?cm8zUEVLc1VoNi80RDFRcmZ2UnRNOXVSZTFYTEFiUUNJMUdROE1DNDl6cGx3?=
 =?utf-8?B?UHBwb1d3a2RaZnljNzBZWWRuNlBTNGZaK2RHMzVBbStpcktlLzZTTVJGckQ5?=
 =?utf-8?B?S1puOVNucmJLakgzZ21sc3g0K2dkMURJZXB5OUU3MXgwNEJOWU5HdGNNUi9a?=
 =?utf-8?B?YTlQemU5NVU2UVBGTU1CQUtLMnFhS2hySitmais0Wjhua054S0ZVRkNxaVFO?=
 =?utf-8?B?VTd6UU9ud3VIbHp3aFVDTm56U2g4WER3SEk2OFIrRzFFakkzOE9iaHUvNmh0?=
 =?utf-8?B?Rm1vSC91VnM5UWlWRnZMMVRJcytxWEtucjg4ZGJtZzEwd1M3Nkd6andWemlI?=
 =?utf-8?B?K0REd0V3REY5QkpIMzljd3Npam1Ia0orL0VrbXRBRHY3M3hrZEdpNnZzeUV6?=
 =?utf-8?Q?bJ0pHRlePVwfX8as=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6e7766-7a72-4bfc-60e1-08da520be459
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 15:53:45.7089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZr4D9FbPHdVcol7VoP25jb4zo3ElB42KOd9Zi7Zk96YMucr1PrFBpiVgSCzlj59RAAFNZvivbZgsCN4zaAl9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR03MB5215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/22 7:24 AM, Krzysztof Kozlowski wrote:
> On 18/06/2022 05:38, Sean Anderson wrote:
>> Hi Krzysztof,
>>
>> On 6/17/22 9:15 PM, Krzysztof Kozlowski wrote:
>>> On 17/06/2022 13:32, Sean Anderson wrote:
>>>> This adds a binding for the SerDes module found on QorIQ processors. The
>>>> phy reference has two cells, one for the first lane and one for the
>>>> last. This should allow for good support of multi-lane protocols when
>>>> (if) they are added. There is no protocol option, because the driver is
>>>> designed to be able to completely reconfigure lanes at runtime.
>>>> Generally, the phy consumer can select the appropriate protocol using
>>>> set_mode. For the most part there is only one protocol controller
>>>> (consumer) per lane/protocol combination. The exception to this is the
>>>> B4860 processor, which has some lanes which can be connected to
>>>> multiple MACs. For that processor, I anticipate the easiest way to
>>>> resolve this will be to add an additional cell with a "protocol
>>>> controller instance" property.
>>>>
>>>> Each serdes has a unique set of supported protocols (and lanes). The
>>>> support matrix is stored in the driver and is selected based on the
>>>> compatible string. It is anticipated that a new compatible string will
>>>> need to be added for each serdes on each SoC that drivers support is
>>>> added for.
>>>>
>>>> There are two PLLs, each of which can be used as the master clock for
>>>> each lane. Each PLL has its own reference. For the moment they are
>>>> required, because it simplifies the driver implementation. Absent
>>>> reference clocks can be modeled by a fixed-clock with a rate of 0.
>>>>
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> ---
>>>>
>>>>    .../bindings/phy/fsl,qoriq-serdes.yaml        | 78 +++++++++++++++++++
>>>>    1 file changed, 78 insertions(+)
>>>>    create mode 100644 Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
>>>> new file mode 100644
>>>> index 000000000000..4b9c1fcdab10
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
>>>> @@ -0,0 +1,78 @@
>>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>>> +%YAML 1.2
>>>> +---
>>>> +$id: http://devicetree.org/schemas/phy/fsl,qoriq-serdes.yaml#
>>>
>>> File name: fsl,ls1046a-serdes.yaml
>>
>> This is not appropriate, since this binding will be used for many QorIQ
>> devices, not just LS1046A.
> 
> This is the DT bindings convention and naming style, so why do you say
> it is not appropriate? If the new SoC at some point requires different
> binding what filename do you use? fsl,qoriq-serdes2.yaml? And then again
> fsl,qoriq-serdes3.yaml?

Correct. This serdes has been present in almost every QorIQ product over
a period of 10-15 years.

> Please follow DT bindings convention and name it after first compatible
> in the bindings.

As noted by Ioana, this is apparently a "lynx-10g" serdes, and will be
named appropriately.

>> The LS1046A is not even an "ur" device (first
>> model, etc.) but simply the one I have access to.
> 
> It does not matter that much if it is first in total. Use the first one
> from the documented compatibles.
> 
>>
>>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>>> +
>>>> +title: NXP QorIQ SerDes Device Tree Bindings
>>>
>>> s/Device Tree Bindings//
>>
>> OK
>>
>>>> +
>>>> +maintainers:
>>>> +  - Sean Anderson <sean.anderson@seco.com>
>>>> +
>>>> +description: |
>>>> +  This binding describes the SerDes devices found in NXP's QorIQ line of
>>>
>>> Describe the device, not the binding, so wording "This binding" is not
>>> appropriate.
>>
>> OK
>>
>>>> +  processors. The SerDes provides up to eight lanes. Each lane may be
>>>> +  configured individually, or may be combined with adjacent lanes for a
>>>> +  multi-lane protocol. The SerDes supports a variety of protocols, including up
>>>> +  to 10G Ethernet, PCIe, SATA, and others. The specific protocols supported for
>>>> +  each lane depend on the particular SoC.
>>>> +
>>>> +properties:
>>>
>>> Compatible goes first.
>>>
>>>> +  "#phy-cells":
>>>> +    const: 2
>>>> +    description: |
>>>> +      The cells contain the following arguments.
>>>> +
>>>> +      - description: |
>>>
>>> Not a correct schema. What is this "- description" attached to? There is
>>> no items here...
>>
>> This is the same format as used by
>> Documentation/devicetree/bindings/phy/xlnx,zynqmp-psgtr.yaml
> 
> I'll fix it.
> 
>>
>> How should the cells be documented?
> 
> Could be something like that:
> Documentation/devicetree/bindings/phy/microchip,lan966x-serdes.yaml
> 
>>
>>>> +          The first lane in the group. Lanes are numbered based on the register
>>>> +          offsets, not the I/O ports. This corresponds to the letter-based
>>>> +          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
>>>> +          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
>>>> +        minimum: 0
>>>> +        maximum: 7
>>>> +      - description: |
>>>> +          Last lane. For single-lane protocols, this should be the same as the
>>>> +          first lane.
>>>> +        minimum: 0
>>>> +        maximum: 7
>>>> +
>>>> +  compatible:
>>>> +    enum:
>>>> +      - fsl,ls1046a-serdes-1
>>>> +      - fsl,ls1046a-serdes-2
>>>
>>> Does not look like proper compatible and your explanation from commit
>>> msg did not help me. What "1" and "2" stand for? Usually compatibles
>>> cannot have some arbitrary properties encoded.
>>
>> Each serdes has a different set of supported protocols for each lane. This is encoded
>> in the driver data associated with the compatible
> 
> Implementation does not matter.

Of *course* implementation matters. Devicetree bindings do not happen in a vacuum. They
describe the hardware, but only in service to the implementation.

>> , along with the appropriate values
>> to plug into the protocol control registers. Because each serdes has a different set
>> of supported protocols
> 
> Another way is to express it with a property.
> 
>> and register configuration,
> 
> What does it mean exactly? The same protocols have different programming
> model on the instances?

(In the below paragraph, when I say "register" I mean "register or field within a
register")

Yes. Every serdes instance has a different way to program protocols into lanes. While
there is a little bit of orthogonality (the same registers are typically used for the
same protocols), each serdes is different. The values programmed into the registers are
unique to the serdes, and the lane which they apply to is also unique (e.g. the same
register may be used to program a different lane with a different protocol).

>> adding support for a new SoC will
>> require adding the appropriate configuration to the driver, and adding a new compatible
>> string. Although most of the driver is generic, this critical portion is shared only
>> between closely-related SoCs (such as variants with differing numbers of cores).
>>
> 
> Again implementation - we do not talk here about driver, but the bindings.
> 
>> The 1 and 2 stand for the number of the SerDes on that SoC. e.g. the documentation will
>> refer to SerDes1 and SerDes2.
>>    
>> So e.g. other compatibles might be
>>
>> - fsl,ls1043a-serdes-1 # There's only one serdes on this SoC
>> - fsl,t4042-serdes-1 # This SoC has four serdes
>> - fsl,t4042-serdes-2
>> - fsl,t4042-serdes-3
>> - fsl,t4042-serdes-4
> 
> If the devices are really different - there is no common parts in the
> programming model (registers) - then please find some descriptive
> compatible. However if the programming model of common part is
> consistent and the differences are only for different protocols (kind of
> expected), this should be rather a property describing which protocols
> are supported.
> 

I do not want to complicate the driver by attempting to encode such information in the
bindings. Storing the information in the driver is extremely common. Please refer to e.g.

- mvebu_comphy_cp110_modes in drivers/phy/marvell/phy-mvebu-cp110-comphy.c
- mvebu_a3700_comphy_modes in drivers/phy/marvell/phy-mvebu-a3700-comphy.c
- icm_matrix in drivers/phy/xilinx/phy-zynqmp.c
- samsung_usb2_phy_config in drivers/phy/samsung/
- qmp_phy_init_tbl in drivers/phy/qualcomm/phy-qcom-qmp.c

All of these drivers (and there are more)

- Use a driver-internal struct to encode information specific to different device models.
- Select that struct based on the compatible

The other thing is that while the LS1046A SerDes are fairly generic, other SerDes of this
type have particular restructions on the clocks. E.g. on some SoCs, certain protocols
cannot be used together (even if they would otherwise be legal), and some protocols must
use particular PLLs (whereas in general there is no such restriction). There are also
some register fields which are required to program on some SoCs, and which are reserved
on others.

There is, frankly, a large amount of variation between devices as implemented on different
SoCs. Especially because (AIUI) drivers must remain compatible with old devicetrees, I
think using a specific compatible string is especially appropriate here. It will give us
the ability to correct any implementation quirks as they are discovered (and I anticipate
that there will be) rather than having to determine everything up front.

--Sean
