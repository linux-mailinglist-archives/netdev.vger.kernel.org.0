Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA97B55243A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343603AbiFTSvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiFTSvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:51:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2088.outbound.protection.outlook.com [40.107.22.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D1665DA;
        Mon, 20 Jun 2022 11:51:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N27HEmXeQUNaqz3r7gzddLTvimREU3JsS+8zC6kGT/3M15XIKH7TX9M/OsiQx2OdzOcmfwonFxsXRk2g+w49HSB2HVo4R+BQ4vewDVGynPme6IrGlrcCk39mQ1lGB857SPbj/4Yv1nKzxOZKN6gHSgx1qUcyiEBYKGGpSGl//xUeNlupCnwSYdfAmgwX7Tr1px3rkTcj3euOaT4zCGt+MCbyzcJMD/S3K36x/NHdkXoeLZ7QcnEiP+CInWMNHulHxfOWOXff7fFxWp/KDgnjCQ5YBijGiazFEue2Tt+v9sZzUDwWzoEJjP+UU3zQiETzG9x0XmfhPkZvENQtVP03mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CV24NqUyreWf8ym3I0L/O6OEcR2vK5LYnUE175kbHb4=;
 b=n5yZoNXunnwz3OgooWaJmR9USw0ApT0aKGF86BIC9oYc2l/BBbXWj177A0kqsoQXtkUVEltLkCR00W9XPYrFIXYfK/ks0jQQK6fq6gjBx1RllkqkpX291SfNCBeFNMopFxADZpwysFQzlsGGyi12mQxanyLAU03dE5seeVZ71Z4Vbu36xvwEEGasLW5U3ZRplJ0P/CMJrx6R6hkhXkLav3I7x8wIK1E/9wRFs+EzeY1/Ivqf/8eAb17oaq3A0mZt+iFeWvyUADVsUuSP1di53g9XqOzQAZLX0cTbPgaICEdQo4LzgGqXAexwj+DzaNMJ7pD2no4UOSGeVmG+9vOguw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CV24NqUyreWf8ym3I0L/O6OEcR2vK5LYnUE175kbHb4=;
 b=XjfQkkZXuBqe9gJdayV9U9T3muKgQZ1Y3yxQJU+gpVf27qCifhzOH3j/uAj8MFPqjlzqux6ieb4/5YTN5M9QyoQ03lYWgQ4kVuRLeb+kTOcloE//pAo5hWJnYuEfeuF+jlhhj3iNlf+LppZ+PWdbYPwXBT3esyGYLOjE7aBXQdGr8GItaQJUE+WL1XT8P5ieFi4XC+IelvT5eRXWLuKomjR0BEEdOxVrKPKhNNOoGGPRbr5p3q/kl5H5ehIyj1Y3wu+wHm9O6J27JTasxd6XLVIdiVuZ4HD5Ygheylu7loQkZfPCL85V9FL5L/1/9gfkTrU09ZntY9F5FZLprCOEiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB4692.eurprd03.prod.outlook.com (2603:10a6:208:c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 18:51:06 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5353.022; Mon, 20 Jun 2022
 18:51:06 +0000
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
        linux-phy@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-2-sean.anderson@seco.com>
 <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
 <535a0389-6c97-523d-382f-e54d69d3907e@seco.com>
 <d79239ce-3959-15f8-7121-478fc6d432e4@linaro.org>
 <e6ed314d-290f-ace5-b0ff-01a9a2edca88@seco.com>
 <16684442-35d4-df51-d9f7-4de36d7cf6fd@linaro.org>
 <50fa16ce-ac24-8e4c-5d81-0218535cd05c@seco.com>
 <e922714b-29c7-0f41-9e5c-9a0aef9fb5de@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <5d724f49-71c4-96ad-b756-06b5683fa112@seco.com>
Date:   Mon, 20 Jun 2022 14:51:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e922714b-29c7-0f41-9e5c-9a0aef9fb5de@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0057.prod.exchangelabs.com
 (2603:10b6:208:25::34) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2acf1ca-62de-4ce1-848b-08da52edd51a
X-MS-TrafficTypeDiagnostic: AM0PR03MB4692:EE_
X-Microsoft-Antispam-PRVS: <AM0PR03MB4692656C1A44C9C629C4B58496B09@AM0PR03MB4692.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVHYSkfAxYkhV1SeIi1pEb9MWIaT+A5waEyMS+FbLhGHnfkyXsZvh9/FjL4DPU0CJT7wbTla1jRNtRUPigWbfF9cZtGSgqQmMNevJ01oicWsVP304vCOANk41xwIf5qjw/m+i+QLRKafAjgS+6/9pPuODfGLHfmoAX7Dr70TkU2wRb2C3NlsyKHZQcg9G5HlsXzO+tIIOle6vMSFo4iXr9JeZ2Bp9ezeuiockSR3CCl3CJ1jQcYZBmWbFC+RPE7XdmSq+W5cLR4XjNqqO7RoRNYqb7jS3J16ligGUye36cz6bAGGJwOjHRc+ko/ziatWjiDtswJQk+xq8xhTH57qLafUiHI5Zz5FvuQI6ORlVlDO2mIfr6CDf8Q+cGTTSsflk6zdHDo2yIKzomaD3yPwEbP9NP+Z6DFnU0rVA06bZn4FK3BBYCFr9YWnFGFsRR1ejEf1GwjaHNGBhfrDiLf0J5wU0DzCdd8f/JaelS/4gb88Jz9Q8CuL/vnXhsxtsgynszBgymSZXs+NE2i13OBSKi1tGvtePfCf2ZbWbOu0wXARJ1JCF6YYaIvRzhozxPFSOewuBXXQwYBQn4HzhAtJ/mmL2aFFNIeofYV2mE/KfZooVmJjpCKtpWnJIFRtvC4a7/K1PKro/5XWkJr9J5vBb3jFodikOpvMiqLngTluFHYhBcXhjjkDT6eLTJ6QywjqCZ91aavgtAWSJ83fcK5BBCpJz7mXVK3m9uJM838HSmjEq9WtPEX3F23+d7RsDpDmxwy4Rnb6C40FK5a7KctpXnqJuGRvrtthg5BIK5ZJDeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(366004)(39850400004)(376002)(36756003)(44832011)(31686004)(53546011)(38100700002)(316002)(110136005)(54906003)(38350700002)(31696002)(186003)(26005)(52116002)(2906002)(8676002)(4326008)(6486002)(66556008)(66946007)(66476007)(8936002)(5660300002)(7416002)(86362001)(478600001)(2616005)(41300700001)(6512007)(83380400001)(6666004)(6506007)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW1Sd09zQ1ora0o4bitzZTdRcEtRVDRSckVIRDEvYms1eDlLVHE2dXpUeUR2?=
 =?utf-8?B?K3BqV3dEQ1BxaXduZGVvU3o1c3Z0akJXWlhEdklmdlhmdHo2SGNldFFiS2VU?=
 =?utf-8?B?T0tDdnlIcVhITDBHME52NkQ4bEl4emdLN05KSEtJR1dSSlBrRFpZL2VFOSto?=
 =?utf-8?B?R1BCb01PQ1VmbVFKQUlLbTJVYmZIcklmQW5lVnpVZ0tLNU9jY1ZJbFFaSUJ1?=
 =?utf-8?B?OG1BMmkxLyttOTNid2xKeXNIem1lV1VGYUdUUUkrbDVrTjFBaUlBV0xWcEJw?=
 =?utf-8?B?K2ZSWndjUFM4cTlwcHhnUDltSU9pdGZ2OUFOejJOV0RLdnVsZ1BCTmZEZkxE?=
 =?utf-8?B?ajlGMmVuVkRPSUNjQXNGS1czYWtTaXBSZlF0Tk1ZL3NmM1ZLbUdHQTF3N3pC?=
 =?utf-8?B?WmVvY0ZsK21pZzZKR0NsM0NnTGhtR1VpQTZSRU9hODNYbXhsNUdhUHQ3TmpX?=
 =?utf-8?B?TDV1K1RiQmd3RC9DMW5zV3U4OFhwdGV2Z2tmK0hTb2lLQVFybENuRkNxS1Ja?=
 =?utf-8?B?QmdDd05nOGFFVkptWlR0NFVTbzNQQk5rNVplOVdDbGtDaTZCR3VINk5NMThV?=
 =?utf-8?B?ZVN5bU16ZTN5RG1zYWcxMXJCbm00V1VjaTdJdHVvSWluajJFMHBVdmlmd1lE?=
 =?utf-8?B?VnY1bDNiek51OTdSeTdySzVhYkRPRUFVRTM0MlNvTmFYckVMblJwYTlhZkh5?=
 =?utf-8?B?NGdZZGJNZzYveldBcGdyd2E0ZHJ2WkdWVGl0aWMwMGxZV0xMR3B1YzZVRUxV?=
 =?utf-8?B?OHZhRXMyYnc2Um5GL1JSSDhVb3ZUcEFlWkFTVWRZUnZ4V3ZIa3ZaUGFKTGs5?=
 =?utf-8?B?SWZFemVrQ3lRVk13dHpkNEVpUjVhREs4NnJRcUdoTlFXYmxHMm55OTVmYm1w?=
 =?utf-8?B?UzFFTnVLQkVsakhpUHNCOFB3TnMrYXhBSG1hYXhUdmNLd2YwWFdJL3N2dmhD?=
 =?utf-8?B?ejFkb2dSR3BVTitHdWJheE1hMkpCV2ZZTGhmYzYybGVUNnN2Q1NNYUhjRWVt?=
 =?utf-8?B?eG4vSFAvZGFOT2l6aEdCWTIzcWdHL1NYQWh5Sk82OVp4YmpROVlDWklNR2hv?=
 =?utf-8?B?c3RwMUdKTktnaFZaamU4djBZY2ZzK2JWZDNFY3c4N0RUOW9SZE9nR2FUU3hD?=
 =?utf-8?B?QnlPcXRmK1Z2MENhV2ErTTZKNjhHRFdjRHRNcVVtcGZzREV0VjZraVhIcW9k?=
 =?utf-8?B?V0pQcU1zZ0lHSmQ2SkNNajR4eE1IRVp6M2ZGSGJmaGZ6K1BWMm0vVlVPakxn?=
 =?utf-8?B?cXRvQVN3Sk5ycXdqUnViQ2dQM3BUYVVGMWJwQXFTZ3lqenhSc0RxeWg1L1Z0?=
 =?utf-8?B?L3NIRkdwdHk2NXIwK1VqRzVadXlScnF1T0ovZkNUa3NXdWVjek5CQmd2a1dm?=
 =?utf-8?B?YmJmSDhpN1NtbkFGdkd0U0l4TEtkaXJTTUc1WVlnVFlObnFDSEUvU3VMQXZD?=
 =?utf-8?B?S0lSN2txd3BaVXRzL1lVc2lWM1VBN05lTlI0T2MzbmF5MTIrcThrc3crZFU1?=
 =?utf-8?B?RUJ4eXdBbUJhT2k3SUlxbkdxZHEzMHF3WXhjWmd0cDZ0SHNnNFhkRGpocjBW?=
 =?utf-8?B?WHlMK2dqUzRHZENZVzU1L2xmbUd0MnJ3YnVMU2MwYUNXR0tvQ0o2NjdRVVdy?=
 =?utf-8?B?WlIvSnUxWXh6YlUraGFUVUk0dDRYUEVRMFJSUVk1ZVR0VGNNZnZHMDdXSU4v?=
 =?utf-8?B?MTVNTG5kYzdoeFpianQxN1AycElqYzl2OWpzY05wMDRyYlI3cXdQbkQyLzUw?=
 =?utf-8?B?Y1h2YWRBckI1VFpvWHBRV3V6WTdTYVd6V2RBbXV2MmhWc2dySFRuYzJhcmlQ?=
 =?utf-8?B?aVBUcER3YmJmYTcrUkJ0cFd0V2pNUW9Ea3lnT2ZGRVl3Ukh5RVdET3hmV0Zr?=
 =?utf-8?B?b01Cbzhab0hqSmZvUUt4UldXNEJPWDBxd1BFc3hIbWFMeVFOZXJRVXpmeGZq?=
 =?utf-8?B?cTM4YlpycTNhMHA1RTN5OTAyOXM4Q1NCZTdVVzlWOURMSTRVTllTbmV3R2U4?=
 =?utf-8?B?TktlVTV4VC9MeTEzR1MxajZOWk1PNGtGekI3MjlNVTJnY042T09ocHZhaE1l?=
 =?utf-8?B?c09YcWxFYXhEWkozbUFQZDB4a3U0NnlNVHUvaWVONXB1NjhGb3pXVmo0TzQ4?=
 =?utf-8?B?b3Q1NDVzWmFKSzhBWGFiYThKS2hiTXZVM2xpRlQ4aXV6RGR5aVhWa3BVK1RS?=
 =?utf-8?B?dmFzb0Z6VXNJbU5TRnl3M0RUOUJWSkE2aDk0Smp3ZHVxYWthczdKaGxNcmhz?=
 =?utf-8?B?NzRYTjJzYUlvR2xHWlVpWm9qOTkvQ2lLaUR5U0llVHhZSlM0NzVFWkFscWtU?=
 =?utf-8?B?MTQ3KzRvTVdzWHBmbmlLQVBDeVo1SkZZTCtPWUlqaElZcVduTGl0SjhUMTZP?=
 =?utf-8?Q?h30nHjOyPzCm1erU=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2acf1ca-62de-4ce1-848b-08da52edd51a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 18:51:06.3920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYHYJzhHkgPSGWfwdr87h6ECkVFYewOwuKrmob4hseSdysfQoFLzkmBZ1EaZFFv3QCJ/fRyoTaUzZ0ir5e9XlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4692
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/22 2:21 PM, Krzysztof Kozlowski wrote:
>>>> - samsung_usb2_phy_config in drivers/phy/samsung/
>>>
>>> This one is a good example - where do you see there compatibles with
>>> arbitrary numbers attached?
>> 
>> samsung_usb2_phy_of_match in drivers/phy/samsung/phy-samsung-usb2.c
>> 
>> There is a different compatible for each SoC variant. Each compatible selects a struct
>> containing
>> 
>> - A list of phys, each with custom power on and off functions
>> - A function which converts a rate to an arbitrary value to program into a register
>> 
>> This is further documented in Documentation/driver-api/phy/samsung-usb2.rst
> 
> Exactly, please follow this approach. Compatible is per different
> device, e.g. different SoC variant. Of course you could have different
> devices on same SoC, but "1" and "2" are not different devices.

(in this case they are)

>> 
>>>> - qmp_phy_init_tbl in drivers/phy/qualcomm/phy-qcom-qmp.c
>>>>
>>>> All of these drivers (and there are more)
>>>>
>>>> - Use a driver-internal struct to encode information specific to different device models.
>>>> - Select that struct based on the compatible
>>>
>>> Driver implementation. You can do it in many different ways. Does not
>>> matter for the bindings.
>> 
>> And because this both describes the hardware and is convenient to the implementation,
>> I have chosen this way.
>> 
>>>>
>>>> The other thing is that while the LS1046A SerDes are fairly generic, other SerDes of this
>>>> type have particular restructions on the clocks. E.g. on some SoCs, certain protocols
>>>> cannot be used together (even if they would otherwise be legal), and some protocols must
>>>> use particular PLLs (whereas in general there is no such restriction). There are also
>>>> some register fields which are required to program on some SoCs, and which are reserved
>>>> on others.
>>>
>>> Just to be clear, because you are quite unspecific here ("some
>>> protocols") - we talk about the same protocol programmed on two of these
>>> serdes (serdes-1 and serdes-2 how you call it). Does it use different
>>> registers?
>> 
>> Yes.
>> 
>>> Are some registers - for the same protocol - reserved in one version?
>> 
>> Yes.
>> 
>> For example, I excerpt part of the documentation for PCCR2 on the T4240:
>> 
>>> XFIa Configuration:
>>> XFIA_CFG Default value set by RCW configuration.
>>> This field must be 0 for SerDes 3 & 4
>>> All settings not shown are reserved
>>>
>>> 00 Disabled
>>> 01 x1 on Lane 3 to FM2 MAC 9
>> 
>> And here is part of the documentation for PCCR2 on the LS1046A:
>> 
>>> SATAa Configuration
>>> All others reserved
>>> NOTE: This field is not supported in every instance. The following table includes only
>>>       supported registers.
>>> Field supported in	Field not supported in
>>> SerDes1_PCCR2		—
>>> —			SerDes2_PCCR2
>>>
>>> 000b - Disabled
>>> 001b - x1 on Lane 3 (SerDes #2 only)
>> 
>> And here is part of the documentation for PCCRB on the LS1046A:
>> 
>>> XFIa Configuration
>>> All others reserved Default value set by RCW configuration.
>>>
>>> 000b - Disabled
>>> 010b - x1 on Lane 1 to XGMIIa (Serdes #1 only)
>> You may notice that
>> 
>> - For some SerDes on the same SoC, these fields are reserved
> 
> That all sounds like quite different devices, which indeed usually is
> described with different compatibles. Still "xxx-1" and "xxx-2" are not
> valid compatibles. You need to come with some more reasonable name
> describing them. Maybe the block has revision or different model/vendor.

There is none AFAIK. Maybe someone from NXP can comment (since there are many
undocumented registers).

>> - Between different SoCs, different protocols may be configured in different registers
>> - The same registers may be used for different protocols in different SoCs (though
>>   generally there are several general layouts)
> 
> Different SoCs give you different compatibles, so problem is solved and
> that's not exactly argument for this case.
> 
>> - Fields have particular values which must be programmed
>> 
>> In addition, the documentation also says
>> 
>>> Reserved registers and fields must be preserved on writes.
>> 
>> All of these combined issues make it so that we need detailed, serdes-specific
>> configuration. The easiest way to store this configuration is in the driver. This
>> is consistent with *many* existing phy implementations. I would like to write a
>> standard phy driver, not one twisted by unusual device tree requirements.
> 
> Sure.
> 
>> 
>>>>
>>>> There is, frankly, a large amount of variation between devices as implemented on different
>>>> SoCs. 
>>>
>>> This I don't get. You mean different SoCs have entirely different
>>> Serdes? Sure, no problem. We talk here only about this SoC, this
>>> serdes-1 and serdes-2.
>>>
>>>> Especially because (AIUI) drivers must remain compatible with old devicetrees, I
>>>> think using a specific compatible string is especially appropriate here. 
>>>
>>> This argument does not make any sense in case of new bindings and new
>>> drivers, unless you build on top of existing implementation. Anyway no
>>> one asks you to break existing bindings...
>> 
>> When there is a bug in the bindings how do you fix it? If I were to follow your suggested method, it would be difficult to determine the particular devices
>> 
>>>> It will give us
>>>> the ability to correct any implementation quirks as they are discovered (and I anticipate
>>>> that there will be) rather than having to determine everything up front.
>>>
>>> All the quirks can be also chosen by respective properties.
>> 
>> Quirks are *exactly* the sort of implementation-specific details that you were opposed to above.
>> 
>>> Anyway, "serdes-1" and "serdes-2" are not correct compatibles,
>> 
>> The compatibles suggested were "fsl,ls1046-serdes-1" and -2. As noted above, these are separate
>> devices which, while having many similarities, have different register layouts and protocol
>> support. They are *not* 100% compatible with each other. Would you require that clock drivers
>> for different SoCs use the same compatibles just because they had the same registers, even though
>> the clocks themselves had different functions and hierarchy?
> 
> You miss the point. Clock controllers on same SoC have different names
> used in compatibles. We do not describe them as "vendor,aa-clk-1" and
> "vendor,aa-clk-2".
> 
> Come with proper naming and entire discussion might be not valid
> (although with not perfect naming Rob might come with questions). I
> cannot propose the name because I don't know these hardware blocks and I
> do not have access to datasheet.
> 
> Other way, if any reasonable naming is not possible, could be also to
> describe the meaning of "-1" suffix, e.g. that it does not mean some
> index but a variant from specification.

The documentation refers to these devices as "SerDes1", "SerDes2", etc.

Wold you prefer something like

serdes0: phy@1ea0000 {
	compatible = "fsl,ls1046a-serdes";
	variant = <0>;
};

?

--Sean
