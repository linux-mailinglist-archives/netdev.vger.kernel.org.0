Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96C1550288
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiFRDis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbiFRDio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:38:44 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20078.outbound.protection.outlook.com [40.107.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3441A21272;
        Fri, 17 Jun 2022 20:38:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1vvbHDlY1wSeN4E5g7gXXcgAQ86xl84bq0Fp5pC+Ut+g9eOk6JZzh/OVUL9IK1rmQDACf8/A69XtRnHD0wmLVV0hQ7oqt5n3mfOTHdADNlt5+ZLsCFc35RF5NgfSkpo/ZcAjOI+32W3rPBnPWC+SgsImu4+fcDLYHOut6u4wToFjENYSCjTKV9aFPH1sUftMI/bEacfjKfdPHo36BczJFLsfDrwMjZShMCrW9pRd0/ZYGtDjvxJ2KwaWUL+Bw2LPDxOTz8VgStom+zVIA6NH6MY0X3bq6uY7Jhoftzi+sZXtHZGI4N2coCIJPLrlLtFL88mNLdd26pB9C5dWuesjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjQRa1OKV3aB22sJf0hMZlGYb1KsEq2JJXe0IJfyFN8=;
 b=BRFZC/3lliyl7isZhwx3fK96Cv4ag+SzyDf1WZcT4/ll8FbI33/oXXFfC/4Wyb1Iie+cYHpeSFDWScCkr7Ko7toWIsWMMTeZnIq6Fq07enYhoOEL3bo2GVJ3wq1CCvyrhpu8E4QYKceQJxuY5XPgacHYqPPB5YqULTbROS1+lOzJVrMPkgrOT6NGxvKqbvCrhPIbiZu5mAPF1/r6HivcTRFHwG4wEjX26j65KGvUzXP4r/4hQ2iWuZ9gdDRA2zHq2taWZlO04mEgCJ+7lc9bkCLSoB3EUogV6BuY1BPtmv41HSaXBQ8igmiUGUr8St1TEv2q30OgExopPMeXJxdEAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjQRa1OKV3aB22sJf0hMZlGYb1KsEq2JJXe0IJfyFN8=;
 b=vQGjLhzJf1dIDmW2AcMHbKzt3uOYCu0ppWXpYLNpskPfoNwIpYbvy4GW01raI6jtukPybqCY9rkIr+2OQdTnBsU/xpIrq8YGniVrM/fu2WPZngqEJ7+7c6COd0FFe2Bu3IMzSLcox1WQYKYeHRPjr1TdKBrWTUJQkQdngdZHJaylX6noLJ1QdiSMsG9oHFsS7d35uJ71wMomG++p6bWGFX4NBG0gVJd9E5/ztdT+OfCt7QP5zZF0W8MDFkO7TJkxJFO3GkTChVwKfnR5F90DsnY/zYvBEqY3NFjAHZNrEH5H4C8a6aTSBuDyJ4k/oPWSg+Uu6rFcnS51etX/+I1bxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB8PR03MB5659.eurprd03.prod.outlook.com (2603:10a6:10:108::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Sat, 18 Jun
 2022 03:38:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 03:38:38 +0000
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
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <535a0389-6c97-523d-382f-e54d69d3907e@seco.com>
Date:   Fri, 17 Jun 2022 23:38:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::19) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9ed235-7b1a-4be5-6dc5-08da50dc07cf
X-MS-TrafficTypeDiagnostic: DB8PR03MB5659:EE_
X-Microsoft-Antispam-PRVS: <DB8PR03MB5659A4C9689EF2EB509B397696AE9@DB8PR03MB5659.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7cdrSflQWfiw7RrlgMi2VEK/vbIqStf5ZX/4NC939X9tbA1ypDPxa81vWhn6zByRdJ8moujYjpLpC9Grmyz8riHNfALi4ZUEG7CXcxdynq+/5shLG2WtIRMRaWPORHejiHlZVBqyKDqokVf1obUB1R+bySnanl0vFyEbJpsUojb0k4rottoq6tpanYgBjzZbM/DqsT4FYkio/l50mBGIdNaDSYR4g62xjxuL+vby7zT02eEW5XLxdgDUIovQmlWEGEItZ/gi9z/9PxGuTVNj6/lWNkSsXej9XRME/N9xgxfbQs3qf4m1yLcbWy6pLz3e8R6bYMddeSOpmek+lfI9oYSRVFi78RD6W2rCRHlsZjg6IQDwnbSr+Zf3eEP3W4xkmprcmND7PjvedgjfuqJ/ubDzTskTjb8UaVnIcPmVkb3jRzTrC6abc83hD4kyYMvAbg2iAaVhlWzdwP3+KcPedGIBOjdkIM3bOFR3wHB0Kyrjb1XipZuKeiz3lp1cAZrG8b17KoG9NMRMIZAlQOmZIBD+VLkWQ7ABVuz8FrFCbBGCoRsHBiVt60sBXBS6EUNu7Lu04TAcuhlrNK9LCP5R6PsINmFRXTAU46oBZsBBbkoOuFi3vxQBeNEtnZKNftC92V3+Klb9GePw+T2AYK9NnvlSc2l6deOzPI6d3wd5J5y0tkQxpYiUFj379Yxqo2O7/m/C1k80GyE9ge0/RWZBNV+x5vl4rOMmDS5sJrepHRJxC0rk20zmuWecfYx/AM8CkJcd51+Q23H6HGsImWtaNAQVJZmfSsauEDyERw26ASLj4Mduuc8M+UTKAgQ5TsjKokaOjRTYq+8hi3ztQADhQB8Sv5UNBD6VHXL1crUMXI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(2906002)(26005)(86362001)(7416002)(5660300002)(2616005)(6512007)(6506007)(6666004)(186003)(44832011)(52116002)(83380400001)(53546011)(316002)(498600001)(66556008)(8676002)(6486002)(8936002)(31686004)(4326008)(66476007)(38350700002)(110136005)(31696002)(966005)(54906003)(66946007)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2VOZThoc05ldllFRmFmaVo3WUlXcnk2SzZweWozVDVUL0Ivb0ZVYkhRcTk5?=
 =?utf-8?B?NEY0c29LbHFLV3FYWjNLZ3lwT2lEM0dVNDYvRmE0RGhyK2NQVFZQaGRDeHNJ?=
 =?utf-8?B?VTErVTE0VmpYM0FwKzd4MTFiamRCRWhvS1pnTVhUY000Z05oZ085Vlc4VzVa?=
 =?utf-8?B?ZHM0clRCTjgwa3hXNlAzblNKcllhRjJQOTQ3Z0xUSllkMjRuSEcwaEpWcUs3?=
 =?utf-8?B?Q0EyTkhwWW9RTVlDemJwZTNiRDZMTWpwcllyTVFGTXZCN2NzSEhYQXRuSDVD?=
 =?utf-8?B?bFZQOW5IVk8vLzFnK1BQNFRmUFpKdk5OSnVrV1ZUUFd0TWRzeEtnZW1vSGtG?=
 =?utf-8?B?YkFja2gwZDdGSlF3ajQ2aUcvelhFMHlQN2JYcVh6OEdJMHA1TWNYSnVIZlZN?=
 =?utf-8?B?bmRkZVVlaVp3WWU2RE5nQngvMHJXWHZDTXY2WmRHQUVxY0lEOXl1aWFmSzIv?=
 =?utf-8?B?aW5mK3ZTaUJUUkJHL1Byc29jaC9DaUhndEVkR1o0UEhaWXFHNDlHY2JRN3lL?=
 =?utf-8?B?UzhmMW4vaC9iR1hPQUpIaG5MUzNmYjIrZVRkU1ZlL3BNT3EvWVpjdm5uQ0VB?=
 =?utf-8?B?VnhzenJGOGFtSTlNbmFXRks3aTBqYXgwMzMwWU1qb3BUME1jaHp0SzlURElC?=
 =?utf-8?B?MUdUQkltNzkrVm5oQVBhb0o5Q0pRNVo3RkJPTWhNTTJxU1JjSmp2cUFyeEtH?=
 =?utf-8?B?bzJ0aE1YSmhvNERNeWZQaDRLNDlJZTVpNHN1VkxoTEVYbkhNN1p1R2R2ZDI4?=
 =?utf-8?B?SDJnalVqR0xQOU40anBXQ2kza2ZMaDFML2JQaENwdEpkak40RG5sclZnUkg0?=
 =?utf-8?B?Z1hmR0F1OWtuY3J2SE1XS2NUbnkwWFh1T3BnN2o3TG05S0tNdnZaeXEwNHhK?=
 =?utf-8?B?UnhXUUo1dWRlZHFZaDQvSzZicW5Weld1Vm51VTR3R3hiUGJjNTEwY1NzRmxx?=
 =?utf-8?B?b3NhcDdjQzhxQUs4K3IrSmQ4Wnh1R0hhWXhNZEVZeDdUQ0JmdktwZlFMckky?=
 =?utf-8?B?bXJ1VEg2ZWoyQi9keHV4eVFCMlJlZWpnZ0hGMVVsSjZBTjRnMmlMSkpJR2d2?=
 =?utf-8?B?aTFOSUNUUWMwRHNIRWhoWTJaVnlYOE1OQUxmSW83QnQwb05KSlRxZ0NleXYz?=
 =?utf-8?B?SGNmVlBoWStlalMrU0NsMEd0bXQxVmxuWjYrYUJsdVB6Y1IwWW92UnlmKzUw?=
 =?utf-8?B?VjQ2WFBuVTRZMlBScmh0a0N1SHZwZUsyWDJnMGpBbllMdGI2N2hUL0RBcVBX?=
 =?utf-8?B?MW9qYlVkS3pRYXh2MTYwTmNKN0s2cWtIbDMxdTJPWWNtU0l3UDEzZnVYOVZL?=
 =?utf-8?B?NklselU4WE9LdVVIUmV5RXU4T0ppSlFGT0YzbG1zR1owVnlXS3hwWWxnWmE0?=
 =?utf-8?B?SCtaTWVyT1RiWTVzMkxCV1hISFd5SkVwaXFGdGFmTHF5QTBzSEFDNWdOTWZ6?=
 =?utf-8?B?dkNQMEdBN0FUb1hNeFhhRzRhTXFYTFJYSnZ2c2c5eGFrVnhYTlkzdmYrTEI2?=
 =?utf-8?B?YVlRRVVDWGlkRXg5d1RNYklNYWNJYStTcGFiSWkwQ2Z1TEdINDk3YkFxU0RD?=
 =?utf-8?B?czdGdDNkSDM0bWZRdEF5bmJhT1VjbWZIZm5nUnpwVVF5WVhMK2JndGRLTVpF?=
 =?utf-8?B?UnNDV25ucGVWa1R3UUVVb2NCY015QWtHV0FaeGNlMHUxMWdvWjZBZmZ4RW5S?=
 =?utf-8?B?WkhIMkJ3N1FBdks2VllWNE9rTXJWTlZPUldieERtQkViekJHbUVKZ3M0dThn?=
 =?utf-8?B?YWd2NVBRRUczTzBiUkRGS1ZZNTZnVlkzcHdnT1R1UFJoU1hadjJielRIOThp?=
 =?utf-8?B?eGJnNlU5VWlkNldkd1VNdFdBdEJjN0ZoUjlZMDV5T0FrNGl1ZTM1aGVNbXdW?=
 =?utf-8?B?UHJkQ3A4Mmh1ZGsrUGdrSlhNVDU2RnJpam9oN1B1ZkUwdlBPNlh2SWJxQ1VD?=
 =?utf-8?B?SHV4bTFrSHhybVFkODZVRUNsem5VVXdKcE5JQk8wZUcraTlLc2dEeG1WRmwz?=
 =?utf-8?B?L1lGU0RUT1hpNUx5YXFZV01RSEZia3VvSzkzQUxXR21RV0dEdnNKRGZzZnJW?=
 =?utf-8?B?NmcyeXFRWDU5K01OaFM3UjZPbjAvWUptSko5OXJvaEdYbzhza1ROZm12TEtR?=
 =?utf-8?B?cU1XS0JxdDVrTTA3VVIramZWRjYycFJwWkNETVR6aHltd1BxMzhGQy9sbHlH?=
 =?utf-8?B?b1lySHpDTDdnT2RwWXRhUXQyRXlySVhBRTRieEhyUUY4cVFySll5bHgxak5C?=
 =?utf-8?B?VE5CTTU5RGxCdCtFWE00OG1zYUxPeWJsNGEyQnpZTTdoM1N0OG80ckNCbGQx?=
 =?utf-8?B?eCsrcW1kMnRlblFPZnRWeUw2VllUcTdybklRL0dVOXJyVXdRLzlRemFmbWdS?=
 =?utf-8?Q?dabLbRILieWzpj18=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9ed235-7b1a-4be5-6dc5-08da50dc07cf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 03:38:38.2126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QEAgWt5CX7xJo4lbc7RlNKdcPdXpnx31Fj/LGt5/9pRizRAbonYoTD0bkTcBgrB5H7ET9cxZ3OX5MGnI7t5Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5659
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 6/17/22 9:15 PM, Krzysztof Kozlowski wrote:
> On 17/06/2022 13:32, Sean Anderson wrote:
>> This adds a binding for the SerDes module found on QorIQ processors. The
>> phy reference has two cells, one for the first lane and one for the
>> last. This should allow for good support of multi-lane protocols when
>> (if) they are added. There is no protocol option, because the driver is
>> designed to be able to completely reconfigure lanes at runtime.
>> Generally, the phy consumer can select the appropriate protocol using
>> set_mode. For the most part there is only one protocol controller
>> (consumer) per lane/protocol combination. The exception to this is the
>> B4860 processor, which has some lanes which can be connected to
>> multiple MACs. For that processor, I anticipate the easiest way to
>> resolve this will be to add an additional cell with a "protocol
>> controller instance" property.
>>
>> Each serdes has a unique set of supported protocols (and lanes). The
>> support matrix is stored in the driver and is selected based on the
>> compatible string. It is anticipated that a new compatible string will
>> need to be added for each serdes on each SoC that drivers support is
>> added for.
>>
>> There are two PLLs, each of which can be used as the master clock for
>> each lane. Each PLL has its own reference. For the moment they are
>> required, because it simplifies the driver implementation. Absent
>> reference clocks can be modeled by a fixed-clock with a rate of 0.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>>
>>   .../bindings/phy/fsl,qoriq-serdes.yaml        | 78 +++++++++++++++++++
>>   1 file changed, 78 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
>> new file mode 100644
>> index 000000000000..4b9c1fcdab10
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
>> @@ -0,0 +1,78 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/phy/fsl,qoriq-serdes.yaml#
> 
> File name: fsl,ls1046a-serdes.yaml

This is not appropriate, since this binding will be used for many QorIQ
devices, not just LS1046A. The LS1046A is not even an "ur" device (first
model, etc.) but simply the one I have access to.

>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NXP QorIQ SerDes Device Tree Bindings
> 
> s/Device Tree Bindings//

OK

>> +
>> +maintainers:
>> +  - Sean Anderson <sean.anderson@seco.com>
>> +
>> +description: |
>> +  This binding describes the SerDes devices found in NXP's QorIQ line of
> 
> Describe the device, not the binding, so wording "This binding" is not
> appropriate.

OK

>> +  processors. The SerDes provides up to eight lanes. Each lane may be
>> +  configured individually, or may be combined with adjacent lanes for a
>> +  multi-lane protocol. The SerDes supports a variety of protocols, including up
>> +  to 10G Ethernet, PCIe, SATA, and others. The specific protocols supported for
>> +  each lane depend on the particular SoC.
>> +
>> +properties:
> 
> Compatible goes first.
> 
>> +  "#phy-cells":
>> +    const: 2
>> +    description: |
>> +      The cells contain the following arguments.
>> +
>> +      - description: |
> 
> Not a correct schema. What is this "- description" attached to? There is
> no items here...

This is the same format as used by
Documentation/devicetree/bindings/phy/xlnx,zynqmp-psgtr.yaml

How should the cells be documented?

>> +          The first lane in the group. Lanes are numbered based on the register
>> +          offsets, not the I/O ports. This corresponds to the letter-based
>> +          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
>> +          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
>> +        minimum: 0
>> +        maximum: 7
>> +      - description: |
>> +          Last lane. For single-lane protocols, this should be the same as the
>> +          first lane.
>> +        minimum: 0
>> +        maximum: 7
>> +
>> +  compatible:
>> +    enum:
>> +      - fsl,ls1046a-serdes-1
>> +      - fsl,ls1046a-serdes-2
> 
> Does not look like proper compatible and your explanation from commit
> msg did not help me. What "1" and "2" stand for? Usually compatibles
> cannot have some arbitrary properties encoded.

Each serdes has a different set of supported protocols for each lane. This is encoded
in the driver data associated with the compatible, along with the appropriate values
to plug into the protocol control registers. Because each serdes has a different set
of supported protocols and register configuration, adding support for a new SoC will
require adding the appropriate configuration to the driver, and adding a new compatible
string. Although most of the driver is generic, this critical portion is shared only
between closely-related SoCs (such as variants with differing numbers of cores).

The 1 and 2 stand for the number of the SerDes on that SoC. e.g. the documentation will
refer to SerDes1 and SerDes2.
  
So e.g. other compatibles might be

- fsl,ls1043a-serdes-1 # There's only one serdes on this SoC
- fsl,t4042-serdes-1 # This SoC has four serdes
- fsl,t4042-serdes-2
- fsl,t4042-serdes-3
- fsl,t4042-serdes-4

>> +
>> +  clocks:
>> +    minItems: 2
> 
> No need for minItems.

OK

>> +    maxItems: 2
>> +    description: |
>> +      Clock for each PLL reference clock input.
>> +
>> +  clock-names:
>> +    minItems: 2
>> +    maxItems: 2
>> +    items:
>> +      pattern: "^ref[0-1]$"
> 
> No, instead describe actual items with "const". See other examples.

Again, same format as xlnx,zynqmp-psgtr.yaml

I will update this to use items.

>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +required:
>> +  - "#phy-cells"
>> +  - compatible
>> +  - clocks
>> +  - clock-names
>> +  - reg
>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  - |
>> +    serdes1: phy@1ea0000 {
>> +      #phy-cells = <2>;
>> +      compatible = "fsl,ls1046a-serdes-1";
>> +      reg = <0x0 0x1ea0000 0x0 0x2000>;
>> +      clocks = <&clk_100mhz>, <&clk_156mhz>;
>> +      clock-names = "ref0", "ref1";
>> +    };
>> +
>> +...

--Sean

