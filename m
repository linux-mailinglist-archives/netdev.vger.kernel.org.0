Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AD57D761
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 01:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiGUXfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 19:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGUXf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 19:35:28 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20043.outbound.protection.outlook.com [40.107.2.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9E81EC69;
        Thu, 21 Jul 2022 16:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khmiMfohOW1XsvJKUog3mL8ruZ0hG/MYTAoWjm0oHK/Nn+7YYR/hudSwjVv5p3wMaVqFRC6mipMVPeMCDOmKJXAU8ON0QkomibwnqK9vt/dBloG89pdPMDhbciv1q7W9jB9vudk2N8OX4PNmy24+W3XCMpKAMZ0rjCVz2sgxAP4BWv1+7n+gYOp16bh2Pu2Qq9U3lR3OQV8WQ7LiIoNDlrzIGPxPDajPNuGX1TQTpub6ILY/zYWTw6P/ANAadYzzYtpOKuclq07fWcvtT2XfBtwsIHb7p20jQLi+KJQbd2MObEYgSN8Ddg8UWyKolGMZA5A9ory4LQC2bYv3sfEL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lua2xqdFt2y2e08m/F81HflMMyu/aepYChfyEThdqY8=;
 b=FfvllzwdCn+7kLLJi+P56tfrYSATtoxB+h76B/A2luAA/kKBInnx8Yvyzx+6j+l9zBSZGEaWt9p2DLMzkpZ8fJF8hwwLyB9tTa8OQTwbnDoeJ1CL8kOGbEhV44M6gHo6KmLdKbt2G4b1sscehC+bko+qwV7HQSUBe4vi9nXdvu6YDzSE+2TL0/RltITAqHIZKfvy+yLDtpDLC/MBfZPC0NeOMZbtGhfc/dERNGbQVvFAI8P5kanT1x9QwhsagyPcJ+1LU1Wq7G3m1XxakCzW3dFgtBkly53tqprN15MzfT47xZb2NdeI7BO0vezVBzx95enjWQj0zFluM3qlYlZmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lua2xqdFt2y2e08m/F81HflMMyu/aepYChfyEThdqY8=;
 b=g7VoXHQv7k5ZhOgTaLs6E6Z83hDHqnevc7XvlITipL43uAuBHtbep5F8iqR9h/wuubbe6fq6SauOtFdPn/e7TgddMoeyAICmQW5cGJgdUTvcM/O0Lca1tggt6+EzqLZqvgrmDZ/tFCOPpVXsIRsxCkiHmRopNLG8Cz95mHfgkyXJudRzhf20bTZfK+ukVTHMV7TFjSEApPcxk7ksETICEL/CwwnCITgsUiaFQ2NkTzTfr7x25GrkTeLTwijtTykt3N5f+96EB1wLTd7FWFSSqEbLuN0g7OqyqZElJ9DGB5ubmVSnlRYYoSyrJNALI3TcatFbw9lqOR9z3MM/BaOjOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM4PR0302MB2675.eurprd03.prod.outlook.com (2603:10a6:200:91::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 23:35:21 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 23:35:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v3 01/47] dt-bindings: phy: Add Lynx 10G phy
 binding
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-2-sean.anderson@seco.com>
 <20220720221704.GA4049520-robh@kernel.org>
 <d4d6d881-ca3e-b77f-cee0-70e2518bef69@seco.com>
 <CAL_JsqJqU4-F52NLWDWK=Qy0ECRrYL9fmJD4CLd=J1KzCBgU7Q@mail.gmail.com>
Message-ID: <6240dce3-3b68-2df4-768e-ca82bcea518f@seco.com>
Date:   Thu, 21 Jul 2022 19:35:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAL_JsqJqU4-F52NLWDWK=Qy0ECRrYL9fmJD4CLd=J1KzCBgU7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:610:e7::31) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da9a76a-7d47-41e2-0c87-08da6b71ad12
X-MS-TrafficTypeDiagnostic: AM4PR0302MB2675:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwK8sFdu6FkjY8oFKC+TO0uLO9o/HPFnc2TU0s/LyCCGfwfcwlfUlwtkC2Le+uWlitlAjBkRlJ0DiNrOvp5CdGPovAw67Gv5D82TpvJAlfFdfAIFIwl2kGL+EeQPnOOt+JbVt/tJL+zcxlpoiqr85G00n1Rn2ubQVbNtSDZrT8PSt1DDf8imhSgcGLd74RYWKZ5okDO8IGX4q6ooLZsWRqdWh4mPKIxel+4z2nvVKMtVlPoXdxYiqbGna5Fr/ij02qhDmrEdbJgp83lqX6C71umC9G2++bY0W8V+n8Yxt2yTfYbs8op/oFYxvpYR7IBo8SgkNrD7IzmOHIQf1vFekw64iCpf26GEvxp0EpdItlicPRGyTBZWQD4pkzzn1qdkzRBTFAMmubQlZVIN5/w4eApJqpUj9OrLfuDnZuJUNRO5KRfFqSLnMWZitdJGWv5hWnSvDfIQrjAhoxXToDE0kyRNeZ4t2FQ4t95jFXFE6Ip3R1htONNPhoa2JPt2M88rUozvdfJGGFWoCmjrqRob+QNxm6Rg9/wYmHBjiMMkt1Tpddd2DE+WUzCl0OzpsoK0iKM9KZaWzjacbfLY+WGSXCMpnfa17R22Dl6I/dWVBgCEzArcV3Hdk9dG/JjQo4vrpxz1x5FO+WN7pERvTP7UUYcMDt4ESgQpdYlXNswLIHjG1ASMn7ahk2KH+lDyLKPqjKblKAIn19uj1rm5ZnZp1LHvKOpt4pnVJFgusYYDWtmbZCTNOlHxpymIG0VVVn/Bl5MU2N2gwuL045/Xo/EDH6/mP7V8mFvqBhx3WDqbee9tWMwCtPFkwqfXHqogmrs45RufgwOYpV+JsXiG9FsdhHUBQfcfo2rN0mMl86W/NYs6t0KY4BdWEaovy3AJFroCtg1Hdu/XY/fKBodSNrPJfbf8d4pSaR1Bo2PGtAprtlKNfmaJQZg+90HNznWh702x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39850400004)(366004)(346002)(376002)(186003)(6916009)(44832011)(4326008)(8676002)(54906003)(2906002)(66946007)(30864003)(66556008)(66476007)(7416002)(36756003)(83380400001)(31686004)(2616005)(53546011)(26005)(6512007)(316002)(6666004)(38350700002)(6506007)(38100700002)(52116002)(31696002)(6486002)(5660300002)(86362001)(966005)(41300700001)(478600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmdtTWZZenZoVklhdnJiQldSVGRyWlp2ME1aalNIY1lkSUx0Mys2ZXhWaXAy?=
 =?utf-8?B?eEZNd0IxZC95Uy8zZHY0RExFRVI3Q1FaTGRSRFVlejQzN0tTQTQvNUFoMmFn?=
 =?utf-8?B?YjlwTzlpSjR1VzFqOFM5SHRRRlE5ZWhtOXo0NTRmdHFOWEQ5UTB4YTFBcXdi?=
 =?utf-8?B?dnRGVFplREtZbElmWm1OYURDVnE3SEVYb3JtMDhjdlgzT3JJeWtZZTk0VnpE?=
 =?utf-8?B?T1c5aGhOb2g2Q0J4bDhuZU52THRqaVVnR2ttSXAvdmgvNFIvVDQzTEV6cjJI?=
 =?utf-8?B?dkgrRE1Leis5R295czJJT0UzbzZqVW5UbGxRY3BrTlRZM1plNVRCbFFHbkdo?=
 =?utf-8?B?ekJkV2lya1J5eWFzdGNMYUNFSG5XTUxSTFlWVmpzK2ZQZVZzbTlwQ3QwTVVE?=
 =?utf-8?B?RlZzZTZyVUpVRjdsRVZKa1V5ODA5NzM4SytCbDZUQy9ucWkzZTFBdUJDZHZU?=
 =?utf-8?B?Zkg4bHFHMlU4QWhrTUVxWFl5emQyNWFQQWJ6RlI3WFZiQUM1bkpoN09lbCtT?=
 =?utf-8?B?TXBwYXB0MzlmNGZkVVNNMXFXMkdBeWZDY3JaNVJ0aXFwTzhBZ0FyYWlMaU5y?=
 =?utf-8?B?ODA1RnVFekdZUlY0VFBBU2Z0MXVSQy9NbG9aVkRKUS9wZmxJdjBuVGQydjJs?=
 =?utf-8?B?QWQzVjhjVjJpTFVNZmM1R0xmR2RUMHVhN0dkZ2Rud09HTE52alF2MytsQ3RY?=
 =?utf-8?B?Q3ptRG9IUllWTXRNdy9pb1dNWVpzOC90Ujl0NmVDS1NZYk00c2JQWFo3Yy9y?=
 =?utf-8?B?SUNKWW04cWhFaDNSVHFYWTAydXdnUk15TGRpYUVqeHVITmtGb2tsNk8wb01v?=
 =?utf-8?B?bDRVVlM5M3FvUFVtdy9wbVlYQk9mOVJYa2dEVVg5bGZRWmxwOWdUTHBFbmxh?=
 =?utf-8?B?Mm05REdzZG45UmQ0dUVOcmlObHVQbGJnUjZJdEdXL3ZXNDdmaEJxOWxjZDVH?=
 =?utf-8?B?emtCVXZIWkhTT0JBc21Wc1NMSGgvc2dGa3hEeEtFSzRZSFRlRjJFNnJObU96?=
 =?utf-8?B?c0J3Tzd2SHhNNGhlRUkrN2lkVzBBNDBnVStyS3drVnhSUXJUS0pIVnlBazBX?=
 =?utf-8?B?ZnZPNVNnaGRFWnRrVlJrc1A1cWcyT3J2cmR2OW9ueEc3cUFsYm5lMjBhaEpE?=
 =?utf-8?B?UHcyVzIyU3hRaXJlNXdxcGVTMkxKSFdqaTNzSlErS3dFQjBKYkhkdXhOeEUz?=
 =?utf-8?B?Yk83ZnhSMXNLUnAxOFhxL2g2RkNuc1ZiL1RjNTQyU1hSb0cyNndiNFZhaUFo?=
 =?utf-8?B?UVVHQlJyLzk2ZjRKa0ZiTG1VYnVqbTlVemlNeW1iOWdZam82VktScUNwdlFM?=
 =?utf-8?B?ak00TUVnRzlaK3V6a1lZTEJUTXRTNWZBbCt5RWpTeXVNVEJYWVpHSkpabWtz?=
 =?utf-8?B?eEI1YStMQTlPcHhjVHpPWXNvMnUyZ0ZNRFhhT0NWUmJiRlg1Q1NPVkNFYXdo?=
 =?utf-8?B?K0F4QlVNRGNnZjNNT29VL2NpUmNyOWVZUitiVWY1RTNkSmwybzJidmxIa00x?=
 =?utf-8?B?dWdYWGNoTE9HbkYza0tVbTliME1qZU4ySDMzRTgwYitneVJ2c2VMOHhhN0FH?=
 =?utf-8?B?bkZKTER1Z3lMTVRLNitNM2NqUFNreEZNUEg3VFBOenE1VmdpSHZ0OFF6U3Q4?=
 =?utf-8?B?MnptZVJvRGdhckJVSys3aFEzU1BiYUNQVi9GdlNKQ2J6dGNEblY3RVlDQS8x?=
 =?utf-8?B?YUZLU00zR2NWVDVwS21HYzlvcFhmQVkxaTVYOUxaamxrMEkwdXJlVHRzdmJE?=
 =?utf-8?B?L2JnS3dsM0RWNjdIV21VbUoyR0JrZDNjaW51ckpGdEM2U1ByU0UwMDJqZlJM?=
 =?utf-8?B?cFU0ZHdtdktFVWpjdUJaU0NITmxCUXpxR0dvTG1raW1tM0lHRFpmTEdVNWJi?=
 =?utf-8?B?STdTYXcxMGYwYVpMTG00cTdFVUdJRWgvWlRZQ2VhZzF1OEtEL0o3Ni90VmN1?=
 =?utf-8?B?MWdZcHhMV09YWTgrNHp6T0dEdUNudzhqbDNtQlFHMmpmWXpRZ1NWWi9kVVlz?=
 =?utf-8?B?djdReGhJSjJ6elNQcXJ4eU9RWForMWF3QnM2RW5XUVFUMWhvM0JlZDNadlAr?=
 =?utf-8?B?b1dpNDdmcU5FbkFDRUdOL1JzeDRmVFU1U2ZoZGhvblFrbUJwdzdJS3FpMWtF?=
 =?utf-8?B?YXJSdk94Q2ZWdEtGUGlOSHRUcHhHcjB3ZURqSUZuZllGWGJDQTBPME9Mb29N?=
 =?utf-8?B?M2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da9a76a-7d47-41e2-0c87-08da6b71ad12
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 23:35:20.7964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddbsjt6u+A7kMoO0SlBm1PCalyVASl7WELXsDgQE9mZofLR+qCMpdlgDAEg/ihEDG/I1K6+4Z/rD8gOYE9WDlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0302MB2675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/22 2:29 PM, Rob Herring wrote:
> On Thu, Jul 21, 2022 at 10:06 AM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>>
>>
>> On 7/20/22 6:17 PM, Rob Herring wrote:
>> > On Fri, Jul 15, 2022 at 05:59:08PM -0400, Sean Anderson wrote:
>> >> This adds a binding for the SerDes module found on QorIQ processors. The
>> >> phy reference has two cells, one for the first lane and one for the
>> >> last. This should allow for good support of multi-lane protocols when
>> >> (if) they are added. There is no protocol option, because the driver is
>> >> designed to be able to completely reconfigure lanes at runtime.
>> >> Generally, the phy consumer can select the appropriate protocol using
>> >> set_mode. For the most part there is only one protocol controller
>> >> (consumer) per lane/protocol combination. The exception to this is the
>> >> B4860 processor, which has some lanes which can be connected to
>> >> multiple MACs. For that processor, I anticipate the easiest way to
>> >> resolve this will be to add an additional cell with a "protocol
>> >> controller instance" property.
>> >>
>> >> Each serdes has a unique set of supported protocols (and lanes). The
>> >> support matrix is configured in the device tree. The format of each
>> >> PCCR (protocol configuration register) is modeled. Although the general
>> >> format is typically the same across different SoCs, the specific
>> >> supported protocols (and the values necessary to select them) are
>> >> particular to individual SerDes. A nested structure is used to reduce
>> >> duplication of data.
>> >>
>> >> There are two PLLs, each of which can be used as the master clock for
>> >> each lane. Each PLL has its own reference. For the moment they are
>> >> required, because it simplifies the driver implementation. Absent
>> >> reference clocks can be modeled by a fixed-clock with a rate of 0.
>> >>
>> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> >> ---
>> >>
>> >> Changes in v3:
>> >> - Manually expand yaml references
>> >> - Add mode configuration to device tree
>> >>
>> >> Changes in v2:
>> >> - Rename to fsl,lynx-10g.yaml
>> >> - Refer to the device in the documentation, rather than the binding
>> >> - Move compatible first
>> >> - Document phy cells in the description
>> >> - Allow a value of 1 for phy-cells. This allows for compatibility with
>> >>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>> >>   binding.
>> >> - Remove minItems
>> >> - Use list for clock-names
>> >> - Fix example binding having too many cells in regs
>> >> - Add #clock-cells. This will allow using assigned-clocks* to configure
>> >>   the PLLs.
>> >> - Document the structure of the compatible strings
>> >>
>> >>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 311 ++++++++++++++++++
>> >>  1 file changed, 311 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> >> new file mode 100644
>> >> index 000000000000..a2c37225bb67
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> >> @@ -0,0 +1,311 @@
>> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> >> +%YAML 1.2
>> >> +---
>> >> +$id: http://devicetree.org/schemas/phy/fsl,lynx-10g.yaml#
>> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> >> +
>> >> +title: NXP Lynx 10G SerDes
>> >> +
>> >> +maintainers:
>> >> +  - Sean Anderson <sean.anderson@seco.com>
>> >> +
>> >> +description: |
>> >> +  These Lynx "SerDes" devices are found in NXP's QorIQ line of processors. The
>> >> +  SerDes provides up to eight lanes. Each lane may be configured individually,
>> >> +  or may be combined with adjacent lanes for a multi-lane protocol. The SerDes
>> >> +  supports a variety of protocols, including up to 10G Ethernet, PCIe, SATA, and
>> >> +  others. The specific protocols supported for each lane depend on the
>> >> +  particular SoC.
>> >> +
>> >> +definitions:
>> >
>> > $defs:
>>
>> That didn't work until recently :)
>>
>> I will change this for next revision.
>>
>> >> +  fsl,cfg:
>> >> +    $ref: /schemas/types.yaml#/definitions/uint32
>> >> +    minimum: 1
>> >> +    description: |
>> >> +      The configuration value to program into the field.
>> >
>> > What field?
>>
>> Ah, looks like this lost some context when I moved it. I will expand on this.
>>
>> >> +
>> >> +  fsl,first-lane:
>> >> +    $ref: /schemas/types.yaml#/definitions/uint32
>> >> +    minimum: 0
>> >> +    maximum: 7
>> >> +    description: |
>> >> +      The first lane in the group configured by fsl,cfg. This lane will have
>> >> +      the FIRST_LANE bit set in GCR0. The reset direction will also be set
>> >> +      based on whether this property is less than or greater than
>> >> +      fsl,last-lane.
>> >> +
>> >> +  fsl,last-lane:
>> >> +    $ref: /schemas/types.yaml#/definitions/uint32
>> >> +    minimum: 0
>> >> +    maximum: 7
>> >> +    description: |
>> >> +      The last lane configured by fsl,cfg. If this property is absent,
>> >> +      then it will default to the value of fsl,first-lane.
>> >> +
>> >> +properties:
>> >> +  compatible:
>> >> +    items:
>> >> +      - enum:
>> >> +          - fsl,ls1046a-serdes
>> >> +          - fsl,ls1088a-serdes
>> >> +      - const: fsl,lynx-10g
>> >> +
>> >> +  "#clock-cells":
>> >> +    const: 1
>> >> +    description: |
>> >> +      The cell contains the index of the PLL, starting from 0. Note that when
>> >> +      assigning a rate to a PLL, the PLLs' rates are divided by 1000 to avoid
>> >> +      overflow. A rate of 5000000 corresponds to 5GHz.
>> >> +
>> >> +  "#phy-cells":
>> >> +    minimum: 1
>> >> +    maximum: 2
>> >> +    description: |
>> >> +      The cells contain the following arguments:
>> >> +      - The first lane in the group. Lanes are numbered based on the register
>> >> +        offsets, not the I/O ports. This corresponds to the letter-based ("Lane
>> >> +        A") naming scheme, and not the number-based ("Lane 0") naming scheme. On
>> >> +        most SoCs, "Lane A" is "Lane 0", but not always.
>> >> +      - Last lane. For single-lane protocols, this should be the same as the
>> >> +        first lane.
>> >
>> > Perhaps a single cell with a lane mask would be simpler.
>>
>> Yes.
>>
>> >> +      If no lanes in a SerDes can be grouped, then #phy-cells may be 1, and the
>> >> +      first cell will specify the only lane in the group.
>> >
>> > It is generally easier to have a fixed number of cells.
>>
>> This was remarked on last time. I allowed this for better compatibility with the lynx
>> 28g serdes binding. Is that reasonable? I agree it would simplify the driver to just
>> have one cell type.
>>
>> >> +
>> >> +  clocks:
>> >> +    maxItems: 2
>> >> +    description: |
>> >> +      Clock for each PLL reference clock input.
>> >> +
>> >> +  clock-names:
>> >> +    minItems: 2
>> >> +    maxItems: 2
>> >> +    items:
>> >> +      enum:
>> >> +        - ref0
>> >> +        - ref1
>> >> +
>> >> +  reg:
>> >> +    maxItems: 1
>> >> +
>> >> +patternProperties:
>> >> +  '^pccr-':
>> >> +    type: object
>> >> +
>> >> +    description: |
>> >> +      One of the protocol configuration registers (PCCRs). These contains
>> >> +      several fields, each of which mux a particular protocol onto a particular
>> >> +      lane.
>> >> +
>> >> +    properties:
>> >> +      fsl,pccr:
>> >> +        $ref: /schemas/types.yaml#/definitions/uint32
>> >> +        description: |
>> >> +          The index of the PCCR. This is the same as the register name suffix.
>> >> +          For example, a node for PCCRB would use a value of '0xb' for an
>> >> +          offset of 0x22C (0x200 + 4 * 0xb).
>> >> +
>> >> +    patternProperties:
>> >> +      '^(q?sgmii|xfi|pcie|sata)-':
>> >> +        type: object
>> >> +
>> >> +        description: |
>> >> +          A configuration field within a PCCR. Each field configures one
>> >> +          protocol controller. The value of the field determines the lanes the
>> >> +          controller is connected to, if any.
>> >> +
>> >> +        properties:
>> >> +          fsl,index:
>> >
>> > indexes are generally a red flag in binding. What is the index, how does
>> > it correspond to the h/w and why do you need it.
>>
>> As described in the description below, the "index" is the protocol controller suffix,
>> corresponding to a particular field (or set of fields) in the protocol configuration
>> registers.
>>
>> > If we do end up needing
>> > it, 'reg' is generally how we address some component.
>>
>> I originally used reg, but I got warnings about inheriting #size-cells and
>> #address-cells. These bindings are already quite verbose to write out (there
>> are around 10-20 configurations per SerDes to describe) and I would like to
>> minimize the amount of properties to what is necessary. Additionally, this
>> really describes a particular index of a field, and not a register (or an offset
>> within a register).
> 
> Are you trying to describe all possible configurations in DT? Don't.
> The DT should be the config for the specific board, not a menu of
> possible configurations.

Reasons 2 and 3 mentioned below.

>> >> +            $ref: /schemas/types.yaml#/definitions/uint32
>> >> +            description: |
>> >> +              The index of the field. This corresponds to the suffix in the
>> >
>> > What field?
>>
>> The one from the description above.
>>
>> >> +              documentation. For example, PEXa would be 0, PEXb 1, etc.
>> >> +              Generally, higher fields occupy lower bits.
>> >> +
>> >> +              If there are any subnodes present, they will be preferred over
>> >> +              fsl,cfg et. al.
>> >> +
>> >> +          fsl,cfg:
>> >> +            $ref: "#/definitions/fsl,cfg"
>> >> +
>> >> +          fsl,first-lane:
>> >> +            $ref: "#/definitions/fsl,first-lane"
>> >> +
>> >> +          fsl,last-lane:
>> >> +            $ref: "#/definitions/fsl,last-lane"
>> >
>> > Why do you have lane assignments here and in the phy cells?
>>
>> For three reasons. First, because we need to know what protocols are valid on what
>> lanes. The idea is to allow the MAC to configure the protocols at runtime. To do
>> this, someone has to figure out if the protocol is supported on that lane. The
>> best place to put this IMO is the serdes.
> 
> Within ethernet protocols, that makes sense.
> 
>> Second, some serdes have (mostly) unsupported protocols such as PCIe as well as
>> Ethernet protocols. To allow using Ethernet, we need to know which lanes are
>> configured (by the firmware/bootloader) for some other protocol. That way, we
>> can avoid touching them.
> 
> The ones needed for ethernet are the ones with a connection to the
> ethernet MACs with the 'phys' properties. Why don't you just ignore
> the !ethernet ones?

That's what I try to do. However, non-ethernet modes can use the same
lanes as ethernet modes. So we need to know how the protocol selection
registers are laid out, and what bits select which lanes. Although the
general layout is mostly the same [1], the mapping is specific to the
individual serdes on the individual SoC.

[1] Occasionally, the layout of registers changes between different SoC
    revisions. Usually this is because one of the registers ran out of
    bits.

>> Third, as part of the probe sequence, we need to ensure that no protocol controllers
>> are currently selected. Otherwise, we will get strange problems later when we try
>> to connect multiple protocol controllers to the same lane.
> 
> Sounds like a kernel problem...

Of course, but this stuff has to come from somewhere. Due to the second
reason above we can't just clear out all the PCCRs. We need to know
whether a lane is in use or not, 

>>
>> >> +
>> >> +          fsl,proto:
>> >> +            $ref: /schemas/types.yaml#/definitions/string
>> >> +            enum:
>> >> +              - sgmii
>> >> +              - sgmii25
>> >> +              - qsgmii
>> >> +              - xfi
>> >> +              - pcie
>> >> +              - sata
>> >
>> > We have standard phy modes already for at least most of these types.
>> > Generally the mode is set in the phy cells.
>>
>> Yes, but this is the "protocol" which may correspond to multiple phy modes.
>> For example, sgmii25 allows SGMII, 1000BASE-X, 1000BASE-KR, and 2500BASE-X
>> phy modes.
> 
> As phy mode is more specific than protocol (or mode implies protocol),
> why do we need protocol in DT?

The protocol (along with the PCCR and the protocol controller index) is
used to determine the bitmask for a particular selector. For example,
PCCR1 on the T1040 has the following layout:

Bits  Field name
===== ==========
 0- 1 SGMIIA_CFG
 2- 3 SGMIIB_CFG
 4- 5 SGMIIC_CFG
 6- 7 SGMIID_CFG
 8- 9 SGMIIE_CFG
10-11 SGMIIF_CFG
12-15 Reserved
   16 SGMIIA_KX
   17 SGMIIB_KX
   18 SGMIIC_KX
   19 SGMIID_KX
   20 SGMIIE_KX
   21 SGMIIF_KX
22-23 Reserved
24-25 QSGMA_CFG
26-27 Reserved
28-29 QSGMB_CFG
30-31 Reserved

Note that the KX bit (determining whether 1000BASE-X/SGMII or
1000BASE-KX is enabled) is not contiguous with the CFG field. Instead,
the "index" of the protocol controller is used to determine the correct
max to use for the CFG field as well as the KX bit. Also note that this
register is inhomogeneous. Just the "index" is not enough: we need to
know what the protocol is as well.

> [...]
> 
>> >> +        xfi-1 {
>> >> +          fsl,index = <1>;
>> >> +          fsl,cfg = <0x1>;
>> >> +          fsl,first-lane = <0>;
>> >> +          fsl,proto = "xfi";
>> >> +        };
>> >> +      };
>> >> +    };
>> >
>> > Other than lane assignments and modes, I don't really understand what
>> > you are trying to do.
>>
>> This is touched on a bit above, but the idea here is to allow for dynamic
>> reconfiguration of the serdes mode in order to support multiple ethernet
>> phy modes at runtime. To do this, we need to know about all the available
>> protocol controllers, and the lanes they support. In particular, the
>> available controllers and the lanes they map to (and the values to
>> program to select them) differ even between different serdes on the same
>> SoC.
>>
>> > It all looks too complex and I don't see any other
>> > phy bindings needing something this complex.
>>
>> This was explicitly asked for last time. I also would not like to do this,
>> but you and Krzysztof Kozlowski were very opposed to having per-device
>> compatible strings. If you have a suggestion for a different approach, I
>> am all ears. I find it very frustrating that the primary feedback I get from
>> the device tree folks is "you can't do this" without a corresponding "do it
>> this way."
> 
> How much time do you expect that we spend on your binding which is
> only 1 out of the 100-200 patches we get a week?

I appreciate the work you do on this. But every revision I make without
knowing whether I'm on the right track wastes both of our time. I have
to spend my time coming up with and implementing a new binding and you
have to spend time reviewing it. A nudge in the right direction can
easily save us both time.

> We're not experts in all kinds of h/w and the experts for specific h/w
> don't always care about DT bindings.

Vinod, this is why I (and presumably Rob) would appreciate your feedback.

> We often get presented with solutions without sufficient explanations
> of the problem. If I don't understand the problem, how can I propose a
> solution? We can only point out what doesn't fit within normal DT
> patterns. PHYs with multiple modes supported is not a unique problem,
> so why are existing ways to deal with that not sufficient and why do
> you need a *very* specific binding?

Well, take for example xlnx,zynqmp-psgtr. Although it is not obvious
from the binding, there are several things which simplify the driver.
First, all the modes are completely incompatible. Any consumer will not
need to switch modes at runtime. Second, there is only one GTR device
per SoC. That means that the compatible string which completely
determines the available modes. The mode/lane mapping can be stored in
the driver instead of in the device tree. Last, there is only one
variant of this device. There are no other SoCs with slightly different
register layout, mode support, or lanes.

To contrast with this device, there are several almost-compatible modes.
We cannot just set the mode at boot and be done with it (in fact this is
exactly what I am trying to change by adding a driver). Some modes are
so similar that they reuse protocol controllers, but they still need to
have different lane configuration. There are multiple different SerDes
devices on each SoC. While they have the same register layout, the
connected protocol controllers (and lane mapping) is different. There
are also different SoCs with (ever-so-slightly) different register
layouts, protocol controllers, and lane mappings.

All of this sort of information would normally just be stored in the
driver as a set of struct arrays. In fact, this is what I did the first
time!

> With the phy binding, you know what each lane is connected to. You can
> put whatever information you want in the phy cells to configure the
> phy for that client. The phy cells are defined by the provider and
> opaque to the consumer. Yes, we like to standardize cells when
> possible, but that's only a convenience. I'm not saying phy cells is
> the answer for everything and define 10 cells worth of data either.

Maybe it's better to do something like

	// first-lane last-lane protocol pccr idx val
	phys = <&serdes1 1 1 PHY_TYPE_SGMII 0x8 2 1>,
	       <&serdes1 1 1 PHY_TYPE_QSGMII 0x9 0 2>,
	       <&serdes1 1 1 PHY_TYPE_10GBASER 0xb 1 1>;
	phy-names = "sgmii", "qsgmii", "xfi";

(made up values)

But this doesn't play well with the existing idiom of being able to call
phy_set_mode(). Plus, existing drivers expect to have one (devicetree)
phy for one physical serdes.

What about

	phys = <&serdes1_lane1>;

and then under the serdes node do something like

	serdes1: phy@foo {
		...

		serdes1_lane1 {
			first-lane = <1>;

			sgmii {
				fsl,pccr = <0x8>;
				fsl,idx = <2>;
				fsl,cfg = <1>;
				fsl,proto = "sgmii";
				// or PHY_TYPE_SGMII
			};

			qsgmii {
				...
			};

			xfi {
				...
			};
		};
	};

and this way you could have something like a fsl,reserved property to
deal with not-yet-supported lanes. And this could be added piecemeal by
board configs.

--Sean
