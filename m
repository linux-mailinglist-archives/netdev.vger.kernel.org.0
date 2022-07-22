Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9767657E4CB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiGVQuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiGVQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:50:15 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80051.outbound.protection.outlook.com [40.107.8.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E1B4AC;
        Fri, 22 Jul 2022 09:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwtGzgioaB2qvOwedmj8LItDznlxyqAL+0EY8Wz4yPirTwjrSwFBJIdJmO+oi48QwoxgFmifgqUegMz1NBXEj8YTBr8U2w50dYubza/A/BfxJPPeeMKF1Nv/yxy1VJxugoRG6MahVKC9+bcYREkJNziKZ1cBy4qCK+8nUNcXhdIcVRCLV1UEoI1uCqr7hsp+8uy10XBoB/AilNlviBdx+8u+Uj+Hu/PJF8wWHwD7HEM+sX6YkGY8uDfts0DQ67wtViDLCZXfUWBWYAk/L7ft8GxVX/MTt9rey/6+n2B02PfIOky5MkVPtvZNQCPz6BojFnwTYgR30PMDz9kzUqKHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Acx+onrncLv0gZ7VAZAaYY46jFr7ratE9EvFPG8hoK0=;
 b=DZxGjhEJKpvInWZIJ8iuIah3cW8P5SXaFLTibzX4q8q/KYkmGXAgdajW+E9tfTzcXxY+7Xty86wbWgzCvEPmx/DiRAstEi3qWT9Q45KKBk32y5NiFsxWPP8lDMvllA8kZ01pJjxoS3fZVYAVq2zTTw273aB5j+YsP6wKJA2d9UX7/u8T/m2diIz8+aVon6R7DLiSoLEe91BxAYJSK4h3AM58arb5M0RgwCCR/GyI7pLxw9yyEO1pecCMcgm0YUu4bX2OTbrGgWwF01Mv26dhXXVYD+fXL0lJIH7BB4q6j0vXw8moSAe3dslS7/mzvmcgZRT4KUk50ynzNoIWN1BqLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Acx+onrncLv0gZ7VAZAaYY46jFr7ratE9EvFPG8hoK0=;
 b=tA/9yDrwE2wvF4sl7SDJEWZt3+nVmYGMhVnyf1wQdl5W1oFPiiKJJj4Fxe3KXNpD/xWoiWYoSgMtTVdeyljc1xKfu4e4CkD3UEVgR9gJsqoc86WZBvg9lps3yfPGIVV3Nn222ExUYSCQ9+HsIqF7hGCgzuNKRPIb/0XXlnZdGuGTPCIZBo3iEh+iaQpzuB6EaG9bTopSRgp+Ih7efHs8HyuPPTGH+FeMFQZxbmNimcTgAfj83mkgv9uF/HWH3cVrHgtaVGe6j0hW3F18sZljYASRM13VLqBOf4JXEpY4qJMEEfjgzJwY7jgZjkviQJYbc9GroT795LR3t8CVteXJyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM4PR0302MB2786.eurprd03.prod.outlook.com (2603:10a6:200:92::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:50:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Fri, 22 Jul 2022
 16:50:09 +0000
Subject: Re: [PATCH net-next v3 03/47] dt-bindings: net: Convert FMan MAC
 bindings to yaml
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-4-sean.anderson@seco.com>
 <1657926388.246596.1631478.nullmailer@robh.at.kernel.org>
 <1b694d96-5ea8-e4eb-65bf-0ad7ffefa8eb@seco.com>
 <e1a8e417-3c4d-a11b-efce-e66bc170d92c@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <6eb62dfa-2f00-58f7-3a35-0346249e6042@seco.com>
Date:   Fri, 22 Jul 2022 12:50:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e1a8e417-3c4d-a11b-efce-e66bc170d92c@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:208:134::47) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 981b44f3-89a8-4aaf-fa84-08da6c023cbc
X-MS-TrafficTypeDiagnostic: AM4PR0302MB2786:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Ew/IuGXDGpN+G1a84ltFnAi3+e9HEIORQ9rwQnmQyUG2GIwNO+hjO4MwhLAfSXZNy/aCyQZh8LczzNqG1ywYTi3QT5JsA6lJF4xs1O+6g6o2NzvzLT9ML8yu6r8mfXouxvB7RY9IkLNiDS7jARxaiPELpw1vHvpVTtxwVNfToXj1ibVTMxhJnh1JbeemutrEZWpqKN7n+1/FBpTSoi7NMN3i+VSVGd7fscRvh4d19ztf18icaRY0d809JLBYqycirvk/tdFobqCUoYrmMNYXKVy1dpFYADegyWjNz+JAFP2v0yo25zeqwg0gBCS0YkhnFaSHwW9OO0FvcMfXDjeVPIlpiI7jLqE16SaRDPrv4vg0EKVpqu0Vwd7ops0HDCSMD19GX80ou39hfZJW60PZ1ni56Uo64PzRhHdPCrz5ZSslUrWqS7jl6RC2Vuz9JCX5K6W+GA4o4tdIfCMGuAA6baFS5I0kTyv9q3R6KKDzEg7e2qIZRhsiv43RikEN2XzmJd+z1eKBx2hThsP6vgr7Gh4OqeAwnONH9zS6+FFQuYKklUFvGUYONod4HCzPtweZSLE68HsappqPiEmAdGqwmTTq1xuQEOX7CrfAajZTbA+0Lwz2Q5dZWZfFebqxakxTfapWr2q9971l37t4myEmVEN5HHUGZlNHDcuzviZhxd8XLdHvV98pYtrRT6izi9ZGlXyLX8KoHnbhvGxHcsKfiH4dNaD6TnvVnRtbfFyujdNLtjNUomondIv8vs6DLAyJiNoxgcsaUHStYKDuQh+lOUH6cvfCPLvJKm6y3YyxMSbIsqq0dkLF1I6MpJkBzZSyLgVyeizF/XIL8DjO83Tfu8gZD6E8WZ2SQyzuLIIjLwgYdu9aG0eZLggf8ZijJNAiLdDbhgCZJwjG8ars2ewbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(39850400004)(396003)(136003)(7416002)(5660300002)(8936002)(44832011)(41300700001)(38350700002)(26005)(53546011)(2906002)(52116002)(6506007)(31686004)(6666004)(186003)(6512007)(36756003)(4326008)(66556008)(66476007)(31696002)(66946007)(8676002)(86362001)(316002)(478600001)(110136005)(54906003)(38100700002)(83380400001)(2616005)(966005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cG0zK21GeHphUk5HSkNLT1ZoYW5sbWJyY2NxdHJJZFN1V3ZtNjJGSHM3aEMr?=
 =?utf-8?B?Mjh4dW1vMlE2THNteDRGRDdXdFM4bWdnd1ZxZEVOb0tTcXozamFIbThNK01i?=
 =?utf-8?B?cXdvOXpkU3RqdVZ1L3lUK2lRSmdiN3RQSTFZU2p2VjgrVXZ2b3JmeWNWb2M5?=
 =?utf-8?B?OVFYNzhkdXczMHY5UHd0cTVLbTRoeFpTdnM1VnI5NW45Q0YraTRjNHJId3Rs?=
 =?utf-8?B?c1hUdW5JYjlwQjdzVjRJYlFMbG40SlRvRFp3NE9xbFpvUFNKMUlZei9vMFVC?=
 =?utf-8?B?TmhLUE1BZ1FVTzI3alYrclhmZi9QSUR0ekxQTVJQZURMdGRrcjdmQkFVZ0xo?=
 =?utf-8?B?a1JmOXNwSC9teXdlQys0RlJjWEloTGYwVDllSW1zRTNtdHhJYURFb1NNSDNJ?=
 =?utf-8?B?ZTk4OHhvcmdYcE0xbFgrbnl1WVFIWTJXcEFnQmloTHhWR2ZTWW5jZmxOSDRE?=
 =?utf-8?B?aTk3KzNUQlVNY1BWRmFPN2l5bnZTMmZUOUF0b0FlcVNUN2pCckVSNXE2UmNx?=
 =?utf-8?B?bFF5YVArMTE1Q3pGK24vL3R4TGlxVWp5Q3d3YjZBMDlOZG5GS0c5cUdIRFlV?=
 =?utf-8?B?a2VxNWZuZjdNRGhQRVJ5Tm1aUEdVVk5MSW95RXUvaXM5RXVQbStZdHJ4ZDFF?=
 =?utf-8?B?cGg3Nk5SaHpEMy9FY2k3VGJUTnZtbUtubVpnZVlDcjN3U0NzcHJZd3FjUnRZ?=
 =?utf-8?B?cXhiUE5Ed2FKVHJ4ZWtYOVVGMUUrNVRwYWVWakdpN0JSUGwrM1paVXVjaGov?=
 =?utf-8?B?SnhmQmVTM2dvZG56VHVxclYwZ0dBV0IxZFV3STR0Y0xuS2FGd0hKOUZ6U0g3?=
 =?utf-8?B?OU9zMFBIV0F3UllJOGdDa1dRd1ZMUWN2QUoyd0FoenZRYUV5ZGpjNkhVU3No?=
 =?utf-8?B?cFhoNlhFMU5PMU5iWDZMb3p1ZmhXTVFIemZ5ZUFZc3ZpVGMyQk1ZRDhTTCsz?=
 =?utf-8?B?SGF4WXkrWWIwQ0NVcjRBK1lzSGxDRVlFVUpvWmlLcDlVRjRlNmhhVW9wYnF2?=
 =?utf-8?B?NytvQ3BwbmZyZnZTTE9OazdBVGNMaVUxREQ1KzREY2hPSlJRT1R5aUV3RGVu?=
 =?utf-8?B?b3RVWjlBTWh1SEdjK0VRajR4ZnBud1UrRHhZcjFZaDkwNjJTenZUZHJTN1dO?=
 =?utf-8?B?VVQvMkE5dUpxVFd3Rjg2dzczV0VIRkdKOE0vWk90L3psZEQ4SmhOTUZYRmFH?=
 =?utf-8?B?Q05QMHdkWStFWHFaQXFHUmZjZDNtUUhTS2xRbTB2R0RMSkNneVJmbUJQdmpZ?=
 =?utf-8?B?bnhMM0RSTEsvYUsvbm1oNE5NTzE4eHpHaFFGTGNnVUs1TTJCZlhkaEJJdFBV?=
 =?utf-8?B?VkVpbFNOeGFtb0Q2UmdrSXRYb0NLUGUyMzhsUXllM01oZEROelMycmRXRTFO?=
 =?utf-8?B?R0UyelJUbXo3U2lEcmFQZk1pdHdBczNXVTA0SjIyRWtJaWRqOUNTbmZ5VFAx?=
 =?utf-8?B?T00vNGhDNERmRUVUK2ppOGdRT05UR29HRHQzNVRJeGVUaFEvbUNUcnU4MFdQ?=
 =?utf-8?B?YzZVclZHWmlVaFh3eTgyczVacWpiSFhSaHlmTUxuUXoraTh5aUNJOTVYWUZU?=
 =?utf-8?B?dTVrTDVDdmJiWUkybjFVbHVEZlNwK1ZBV2hrdDcrc0lJMmRJNy9lbmtXOFZu?=
 =?utf-8?B?UGtDRUdKejRtM3JVdm1mNHdXRSs5dk5xeGJSWkZTbnQzL2VWWDBQYWdOT2Ri?=
 =?utf-8?B?YkE0WDFiekFRTXF4L1NtaFkvb1hSVm5abUtka3RwNDh5S3hYOUZiRFBvUE1p?=
 =?utf-8?B?anVyQ3AvZ3JMUnY1WmZuZGJWQis3L2E0VzNzeG9WeTBPS3VUMXFzTU9Db1B3?=
 =?utf-8?B?a3pwRzgvRlJKSEphd0ZWdFJHU1R3ejE3QWc1TlA1K2NwWWR5VmVKUTZ1YU9B?=
 =?utf-8?B?d2x0TVg5NmdDU21DR0V3LzFvWWpNME0zVWZDQmlrVUVYTUdrRUduYzR1OWxT?=
 =?utf-8?B?TC9PSnZ5UTZTRVo2ZHJCVlFzZUM3Nnk2RlJydGVwSWo2MXlhM1lZNXFXUVRj?=
 =?utf-8?B?NzNrNFJWSkcwVjVjRVFKUGtsRisxVjZwSEdRVHFLOVIvNUczNDdDNlR3TFpT?=
 =?utf-8?B?NkhTcktocVhFZUQ1VUVFR3pIVmZhNDBWTGVtVE1KTU8yWk5wL2tQMmt6YXUz?=
 =?utf-8?B?aUZaNGpSUS9IdDQ2eHIydUVsOXlJYU9scXhpN0ZEN3pCVW5iUm4rUjlaUWhY?=
 =?utf-8?B?NkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 981b44f3-89a8-4aaf-fa84-08da6c023cbc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:50:09.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PyTTUu332loqlnDOX/ZhYza1zE7PWnmwf0DpiJ5Zs2m0GcCkOr1ZkMwta/XD00r5zjryeDozzUd/rREgfPqrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0302MB2786
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 10:42 AM, Krzysztof Kozlowski wrote:
> On 17/07/2022 00:47, Sean Anderson wrote:
>> On 7/15/22 7:06 PM, Rob Herring wrote:
>>> On Fri, 15 Jul 2022 17:59:10 -0400, Sean Anderson wrote:
>>>> This converts the MAC portion of the FMan MAC bindings to yaml.
>>>>
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> Reviewed-by: Rob Herring <robh@kernel.org>
>>>> ---
>>>>
>>>> Changes in v3:
>>>> - Incorporate some minor changes into the first FMan binding commit
>>>>
>>>> Changes in v2:
>>>> - New
>>>>
>>>>   .../bindings/net/fsl,fman-dtsec.yaml          | 145 ++++++++++++++++++
>>>>   .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>>>>   2 files changed, 146 insertions(+), 127 deletions(-)
>>>>   create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>>>>
>>>
>>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>>
>>> yamllint warnings/errors:
>>>
>>> dtschema/dtc warnings/errors:
>>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.example.dtb: ethernet@e8000: 'phy-connection-type', 'phy-handle' do not match any of the regexes: 'pinctrl-[0-9]+'
>>> 	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>>>
>>> doc reference errors (make refcheckdocs):
>> 
>> What's the correct way to do this? I have '$ref: ethernet-controller.yaml#'
>> under allOf, but it doesn't seem to apply. IIRC this doesn't occur for actual dts files.
> 
> You do not allow any other properties than explicitly listed
> (additionalProp:false). If you want to apply all properties from other
> schema you need to use unevaluated.
> 
> https://elixir.bootlin.com/linux/v5.19-rc7/source/Documentation/devicetree/bindings/writing-bindings.rst#L75

Thanks, I'll fix that.

Although I wasn't able to reproduce this error locally. I'm using the
following command:

CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 make O=build -j12 dt_binding_check DT_SCHEMA_FILES=fsl,fman-dtsec.yaml DT_CHECKER_FLAGS=-m

--Sean
