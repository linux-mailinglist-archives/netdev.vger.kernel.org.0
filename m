Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022AF571E98
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiGLPNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiGLPNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:13:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2051.outbound.protection.outlook.com [40.107.22.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95BAC3AF2;
        Tue, 12 Jul 2022 08:06:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBfxzO0cmuB6D0BLQRqInEIsnEOMXJxh3Q+iOyos+pRnCaUd8OOo/Xc3Yj5al8+4AMUUY97gcvDC3GIaOq0KlGKHon/8XOvggEW5KFS9H8KNOQmfRe05Z28YC+hsBcjXZtPn/1h0YQ6KJCjwQeEedjYUwOIkXqQAEeAlH5E04QmV5kNd+Dnkpbanbhj/jq0R6R86ihuh9EBc2AfkPmmkhKo0QdBmpmN5eN227nejuJDeWCRNMy6aGSleSjNm1Dm+z4g0EsgB6LWHaHTjQIElo62wKrd9KgI1QHt5CtLCX1s8dlZjE7hTeSD4Vq5mpMGu+IMEMBddCVXXDau2OA0dIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INoTWrCCNABS4UK0/L7IBKxvGi7nyhA7sQ+9kRCty9I=;
 b=fYo/qyjVktkPywhyrznRMnq27tAF0rHB+qSTUm6IQYsXyf/crftjB+npKZoqTN9GFthuhHxBkx3ey3fmGnmTJnIV9p+CexdzIASFjp73fJgCaNbFZGq541P5toJYctnlZdDM9+gsnN2eWsFkHz1xxqYGuVuo7wRljycolhmwQimEjfbacA2FbkzxQ2ayZz54hzuIRbwxUXpLECYpNGQXTqxSoXFqK0Kc/J2i6tiJy9yiZ3cGYHBeTTV1rk7uh7AV8kk0SjG8qS5feRcUE7zVGpB02E1z3ale/zVkM90gO88c8OyBh2NbVGQD7icz++5ow5168RN9ZWRRhf1M3DBnyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INoTWrCCNABS4UK0/L7IBKxvGi7nyhA7sQ+9kRCty9I=;
 b=UiHdkyDaeEnT28TihgLdmERA7RjolSVQIUFzb6rYheasun8ud27WFfaAjuwJfnWAWoi1GKuSZVxPx7z2uDh5ArukUvAkjE0Hz3CpahlCwqVtqrhtriUrHpa+Rr5ee1c+lpWB+J+3oIG6BJylLJXCEXZ88/z2F/kZqWcafoNc7HVukOjafgfL0UbjTf6fPHZX18nddqpIWXi8q8+CgK9AfxBEoDPkxKt9uWwUkTVEz6+im3uM/bOvthvBmmUeEhtkAyxmlD0P661gV1ydE6KFOSSwkQKw58q0daC9uGREoqKrCOeZvzU0rEwazmHR4RTNF32ftQzOtcJwZO1ENjVx8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB6961.eurprd03.prod.outlook.com (2603:10a6:20b:280::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 15:06:24 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:06:24 +0000
Subject: Re: [RFC PATCH net-next 2/9] dt-bindings: net: Expand pcs-handle to
 an array
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-3-sean.anderson@seco.com>
 <ecaf9d0f-6ddb-5842-790e-3d5ee80e2a77@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
Date:   Tue, 12 Jul 2022 11:06:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <ecaf9d0f-6ddb-5842-790e-3d5ee80e2a77@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9a277b7-bf6f-4d47-60f6-08da6418165a
X-MS-TrafficTypeDiagnostic: AM9PR03MB6961:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ny/Dz39P1zQUrQX5xeKFSNzAnXcYyp0EDWNnPbOdqh80wkxyRTQXtbulRrmcGNF7tN2oYlZzlrGx98Ka0U3xUxMJXHBD4TgBSgdZKjFIPmhKcW/FwhhZ5BOGRFpnUYNNqt29H/E5L1kbOod0Eew92K96mKlE131iZKqfOmmHB4QgjBw3ncaFv/X+VjFVMskMRFPGTuBXCsqHI0xeegm2wPkx3UkVOOKxBpyjya3JuQzcJSXkjXGpzPkxZ2mwIsMMfscxFyOkxiKQHjC3Q+h81VNTrbcynmQj+F6BucKwRupwJ8m1Y7zfZvbFaEvBFDn+psiKRxjX9URd03YnVB+y5wxorKOGlPevU788hhdG/W9wV7AoSz7DVFMnk7Zrgk7hZQxJ1FJHh0DIeIYMmyZ4TP0dFmesZg0Tr2zmr7iiy6dBIv/cF/VQziOSvdpFaVXsn35Hj9/SkHYIBFxe2CVD/QIPyvZ+sTMpI7EVSQXYH5reRxyB8GnR/pMQEd1Cs1qHVZRYuDZa/pYud71AiGPDRBL7mFtC2nGIHGUzBTZzOBipqlXngSYV7yrn8FjOOq0YhvgsS9I8y83YabyCHYSGofg/ZhOGc/7ZkL0IkRKuiHigSBEssU/VbxPxWSAYYXSwjvtPD740S+/qgLCnl/ci5VibU51GeL0QLROSu16G1Y8QchUfkYFGEcgz+zqunLqJA97UZdALOcasg7UjieohAedCNJVBVkz5hFPgndiSGq6gwXu9HQ8N6MPzciITUbhT3LaNweOtyWu5tAarni2Aba4K3V9Y/AsA+jHlMIbKvYd30+QyNbr0DlaTLbDFkhxBfbYZGult2290feS1rbaJBEn5pEhW6l0CZKgON4QeI8NK5e+02lRYNtfn2221qy+n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39850400004)(366004)(136003)(376002)(396003)(186003)(2616005)(53546011)(26005)(52116002)(6512007)(6506007)(2906002)(38350700002)(86362001)(31696002)(110136005)(8676002)(4326008)(66476007)(54906003)(6666004)(41300700001)(5660300002)(38100700002)(6486002)(316002)(66556008)(44832011)(31686004)(7416002)(478600001)(36756003)(83380400001)(66946007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3RTSEFyT0tVUnJyMEZ6NVlmeVZGV3o1V0lvNEFPVlV2R1V1Z08yL1ZqeEJQ?=
 =?utf-8?B?anAxZWhxZ0JvNVJzbUxiaU1Ddk1kUTBmSGVQQUVSTndjZG5ZdnBPQ2x1d29l?=
 =?utf-8?B?NGFMYlRuUHg3VlRzY2lTRkczWUtGOXk5YW9qYjRTNEtrQjRlU3FWWEkwRUV4?=
 =?utf-8?B?WXN0WTcrVDZ1SUxIamhUNjVTbGkvS01WK2xSUXArUXRaeDlGMGxVWnJPV3VP?=
 =?utf-8?B?ckpyRm8wenNUWnZETHFLajNCZ1NmY0VNVlpIY1VSd3lCYUk3K3FXQjg0cXpv?=
 =?utf-8?B?ckM1VUdxdHFKTXErOWhzZ2prNzJlbXpNYVFVcHo1R1JrNDVQZ0tVOXhVWG9t?=
 =?utf-8?B?Mk81ZWpLZTE5dCtXUjlCMUpKdmVWZkVvdmZzTWdwQzBqaWRRZ2NpYUxtRnlm?=
 =?utf-8?B?MkQrT0RVbDFOQkx5WlhlU05BdDJSdmhjWUFqZkxVa3pwczJESVM4UTQ0MUpy?=
 =?utf-8?B?Ynd0YnFWM2RoSVhmMitKSmxCZ0Y3R1B5M3dQRGRMNzUzVk14d0pZd2Q5OFpr?=
 =?utf-8?B?bXZCZ2taY3ZQKzJOeDYwME9adjdhYVdpODdtL1BGd1MyS0FkWnhUZWUrMVdI?=
 =?utf-8?B?R1o0ZjI0djR1Uk82QjhGTTlQYkpSYmFIbXZZL2ppY0xQM3JzS3lwL3NzeGE3?=
 =?utf-8?B?Q3EzSW5xcFpOUGhTZ1ZEcG9XS05aNkhocDlBT29IenhYQTNCcXBWbzBVM0E3?=
 =?utf-8?B?T3BOcGkrNkI1WlFrcFBBN1lwMGt2bFdKZGxoTnQ0NGcxMmRWbGJpZnJYZEl5?=
 =?utf-8?B?TEQ2L1U0dFFtV2VXWmRndzAyeE9sMVlhWlRDVkQwMGRVenZDa2RnOUltVllm?=
 =?utf-8?B?aXVidWhuWjFYWVJNK2dlMHNCVXhzai91dnpWcmpUVHdPR0I1ckZ5aWVwVndP?=
 =?utf-8?B?ZVNSdHdtd2NINHZhNG5vbHA0ckFUWXFMeXl3ZzhWdUZLcnNZNHcrQ2d3TWJ1?=
 =?utf-8?B?V01IeGVqR1FvMXQ0UytnWndoNGZvbDR0RHlvRGFpcTk0b2YzUEtKajJHTHl2?=
 =?utf-8?B?VEhTNnFUTFBHV1ZvWFQyQ2Zsdk11RFNOSERBSGRGR3RNdXpnNmVmSzEzOENu?=
 =?utf-8?B?UkVJTngvckRyanJKTXY1Nm1mQkZlWkw3R1BSdHIwWVlmVStpWHBtYjZ2Zk9u?=
 =?utf-8?B?TlluNHNTc1YvY1YrOGZNUGsyNHlkUTJuK1BWWmFVVU1ZRjgvUE1VUGFnVnBi?=
 =?utf-8?B?NmpWb3VQYnlYSk9RYWY2VWQ3TXd3RmF4THNISVRoVU9vdk8zaTV2Q0t4ZzVD?=
 =?utf-8?B?KzJPWmJIZ0d5c0N2eTNmemVDZThLaGtkY09Fd090eFE5M1pJUFNJeU5uNjBx?=
 =?utf-8?B?UUdKUnZqS2h3NzQ3M29sQzhkQVM1bHA4Z1J6Q2V6K09ucmtheXJXZlpXakZM?=
 =?utf-8?B?NWZQSVZOWk40OGh3bjFvd2c3ekd3RVRmUXpHeXpsZGQvRSszc2Q5c1dvMEI2?=
 =?utf-8?B?ZEd3WHBSTXJMcFpnM0VJZzBnZi9uVnBFbUNPeVJJbm5Pb2JuM3NPdVhhdjF3?=
 =?utf-8?B?bTFSQzgwRlJnVVo2V0RYbUZuMlFyOUFQaFlvZjJNOWpVdjAzYkpsSGFQWDU2?=
 =?utf-8?B?WEY5dHQxeUtuZ1pHRW5GVnFUdmhtbW1XOFMzT3d6am1VbmY1QWJUZ0t4SzJI?=
 =?utf-8?B?Wm5QNzgxQmpQakVWRlZ2WXFPbEZWaVg1WEJXdmVrc2lQaDYxendhanJiQUNj?=
 =?utf-8?B?d3FBdDFOa3dPclFjSGJjODErVnRPQW1hYy9YQms4Z29vTzhuWmZMWXpFOE9Q?=
 =?utf-8?B?ZFlHMnJ0YmpLaFJyU2w4UU9pZFoyT05UQmlYWWw4UTRLRkJScGhyeVdvNDZa?=
 =?utf-8?B?WENyUjVDdzJZcDE3TDlzYlB1bFBKNnowKzVBcExhNURFZXBYTmVrYjRQSUlz?=
 =?utf-8?B?dGtUQkVaQ3ByQUhIMnE0bDFHZVdvd2x2NXdKUkFjcktCYWY4YmZybHM5UE5x?=
 =?utf-8?B?WnJGcjdQSVMxZ2FFRTNPbEk3eHJPd2orWnBNb21CcTZHWjBmUVozOGNRUkRs?=
 =?utf-8?B?MHpmV0l0Ri9ZSzhFNDBaWmw3TUFuUGIvbGR1MnhESzJmME9ESVRxd0ViWml6?=
 =?utf-8?B?Z2FXQndVT2ZTMzE3NGRqREdudzZYM29sU3ZxWWpoSC9qZk0wOUdQWkpST2Vr?=
 =?utf-8?B?MjFRRGNJdVJvcS95S3h1SGVyc2JEMTRBelNaUDFJbXZJV2RmRWRkL21pOFZr?=
 =?utf-8?B?R2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a277b7-bf6f-4d47-60f6-08da6418165a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 15:06:24.5079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPiqIBJpXRP3RnIWv60w2gaJWU9XhrOj8eoPZ95Y9WpLjTS95Y/3vqZTIt82e5tPHnRXsQ2/g0ZNGvWg0/M6wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB6961
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 7/12/22 4:51 AM, Krzysztof Kozlowski wrote:
> On 11/07/2022 18:05, Sean Anderson wrote:
>> This allows multiple phandles to be specified for pcs-handle, such as
>> when multiple PCSs are present for a single MAC. To differentiate
>> between them, also add a pcs-names property.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>>  .../devicetree/bindings/net/ethernet-controller.yaml       | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> index 4f15463611f8..c033e536f869 100644
>> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> @@ -107,11 +107,16 @@ properties:
>>      $ref: "#/properties/phy-connection-type"
>>  
>>    pcs-handle:
>> -    $ref: /schemas/types.yaml#/definitions/phandle
>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>>      description:
>>        Specifies a reference to a node representing a PCS PHY device on a MDIO
>>        bus to link with an external PHY (phy-handle) if exists.
> 
> You need to update all existing bindings and add maxItems:1.
> 
>>  
>> +  pcs-names:
> 
> To be consistent with other properties this should be "pcs-handle-names"
> and the other "pcs-handles"... and then actually drop the "handle".

Sorry, I'm not sure what you're recommending in the second half here.

>> +    $ref: /schemas/types.yaml#/definitions/string-array
>> +    description:
>> +      The name of each PCS in pcs-handle.
> 
> You also need:
> dependencies:
>   pcs-names: [ pcs-handle ]
> 

OK

--Sean
