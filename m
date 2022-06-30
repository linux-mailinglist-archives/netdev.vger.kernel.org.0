Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917F6561FBB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiF3PxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiF3PxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:53:14 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9146F33;
        Thu, 30 Jun 2022 08:53:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuLVkvKAsV5q2FX6ewOj4F5Z4Yhmj49maRha+9IG8kN4ecddamtMQae0sQfGSF0Y3ZbnbYql4Q147IK4rbHYDUBradsHqwzdSIYzkfHcoV4asnvqlA91yhWi1KtCr5w46Lltd14V6exNNe10lx8RW2Yt0i/sXebLzn1Ewzo+mGSSZR9gZ8U3TjaH2WkBdKQFPlQUkArzUnVS6nSogAHAyQ9m4t5XnfCiDdjZ2x1FwBp58dyz6VJBWgQpZbKhYWICEpKLSF9AK2jywt0NxpGbiUuX+S7KroRmqs3XlbyhysBtcDk88Xe+eJsId8ZtVyB40TEOnthLvh8Y1AsAffNkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2CG8vX3xGCDJfJCFkFYDDznsu4M+kihT935Ob9uY+A=;
 b=bYkGkLi3al+R6r+8EcpxfMzBSwAmZyRajs3gtzkmoqrQ7OaSdDL1iGd7n1JTmjAHs5XPnr9uq4Peo3gZoV1o4+WZKYmeO9tcSw7bNCkGuF3ClnkTEO+xQioP6UZZok7NPd9BVUt2xUeJ/uoWBu+sBFZAOjAaj9/f8v/nEBvIfAnw5Ps8bMlYm7oLRyYuTvAEZpyaoAfbfULPQl8rdZL9wt3DfnwDmxkG/JVBvowDwSshrbFLJJ+TVW8lwX5M8MO3jUSbWQlI6vRO0WeOHM2wrD7riyVu67wNslAX10cWNMEY+lPlyeJSs8yEFypYrqrojWTa5wcXcCF+zJANqex03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2CG8vX3xGCDJfJCFkFYDDznsu4M+kihT935Ob9uY+A=;
 b=txxttmFBIkgTmAJAlaSvcY2gWjWk1X7vt1Q8YLRJTWI2thT82JJouxCgIozy/qXWo4OFKO4lozidA4pFBEuySqahKPBgw+8jO+5AvMJn42HZdH0Ed5NLKxuarS1vJ+4xV/7flkvd+v8u0Jf/uq3kbh6CfKZktk5d+aU79l5DJ4wvtL4WsfG2vp2Ikde4gRBPmvsWRIr5aduKDWZMgnhwTZJSmB+TP33f2ksma1B6d+JqeAfZ2rz08NeulyUXNC4sb57AUomORCwOvfgvOvsThkLdXjmKKogkrB9/TD+m4o0oLtrSk+7yEijsBiS6g0OZ70swddl2R9feNCi4oqxprw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AM6PR03MB5861.eurprd03.prod.outlook.com (2603:10a6:20b:e2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 15:53:08 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb%7]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 15:53:07 +0000
Subject: Re: [PATCH net-next v2 01/35] dt-bindings: phy: Add QorIQ SerDes
 binding
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vinod Koul <vkoul@kernel.org>, linux-phy@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-2-sean.anderson@seco.com>
 <1656468579.935954.1403683.nullmailer@robh.at.kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <3760c113-9bc1-6169-a35f-bf382eb4ce7c@seco.com>
Date:   Thu, 30 Jun 2022 11:53:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1656468579.935954.1403683.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0139.namprd02.prod.outlook.com
 (2603:10b6:208:35::44) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2dd42bb-1a12-47a8-0a8c-08da5ab0a054
X-MS-TrafficTypeDiagnostic: AM6PR03MB5861:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZyIFHasBZwThW8Df0dojgWyKJVb6cWTA7qb0J4y9Fi/0WoaMAg32RSO2zfS9yL4LkImBbrqRr4IvCmuK5HsG2axSjz87Khof+4Bw5y7tTzvX0WwSxU4DHWJck+Rb1V6/L9KnQuRo1OuGNWteQXAVCAKDy/e5rI1UXK4F/K+oi9PYSLI3F+4GdC0sYutu7rq8xBi3VSV0lw+NTrkkCU0GOoHumxePv6fn+fTiaZUvJJLbg2DaXuaA9zzU+FuuYVEEjrW6FlgMGpxja/hFvilRpX1HN15Yg3pLHniJzQ1XpI53ZAA6u7H6qHSDELXBIhvcD5Xmevcxo5mT8fEZLirTYQ8Wxpq78yxJiK1K/Yb2vqejCZ8CWU7U3OdT6pfQ3Q08EqyrbEeut+lfrVE9QVpW8IhMuTrKMOcusFmmbYeVfbb5/Q+kmtOQapXs7VIdDdP2O+lOJdj9ofugY8Qmy4L58jogRwE87FmAevzB1xndMKJDucgPNnClchnjbzUc9wN9mzr3i99YgFdeTM882LtNc6uXyRsgO+EYnvKVGwwNL4FY+HoUY07wrTYX0kl2ao7OvdOKs5IBuctgxVP47sPBU+8nqyFSl/pTokhGzoaJ4oYXziuGCYCSRMikXliNISptQAj93OnchpUe/vB+Dzu+rEa18yDxczrcv70L6kXPDdk4HhDha542NmiAGF4qxwT75jk172SuYj/p8Tsyo7BvAuh6VzexPhMBXH8tLqMkwP9ktepkHiAUWd29BU6fI4hFNL6gVxChhGiajcPYkSydT635uuLtK3y/aCwBoiiELz/DzxmJiGd8hEE7TzTMMF+o8lw/ikuptQIRJmCprcVN8eDGD09ER38G1B67+ol8UHZoKVcSNDz5EsfRGPUQGMQnDFB/8YNMK/tJmpgCxqagw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(346002)(39850400004)(396003)(53546011)(2616005)(52116002)(6512007)(38100700002)(5660300002)(186003)(38350700002)(6506007)(26005)(83380400001)(2906002)(7416002)(8936002)(44832011)(66946007)(4326008)(966005)(6486002)(41300700001)(6666004)(66476007)(6916009)(54906003)(316002)(66556008)(31696002)(8676002)(31686004)(86362001)(478600001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEh6Q3ludHFCRnpTM0FmOG53cC9FQTdTNGFvbGxkTzdCa3FwZWFra0ViYlk3?=
 =?utf-8?B?enZzSW5CRUswWE4wUytPRzZWWmFZMkMra1RCanBLTU0rQkJ1cTFhWDE0U2dC?=
 =?utf-8?B?cy8zQ0hBUVVhZ1Z6RnJHWFlEUCtEVldaWXU2cUxXbHVlNWNza0JFQ1JwdUdV?=
 =?utf-8?B?c2VUcVdTbWtaOTRtazZ6TzlRdE16MFBtYnNNbE9CcW5jZHVQQllJbDRjVGpS?=
 =?utf-8?B?WnlkRERWRjJubDgrZUptcDZNRXBLZVdIRExiMXlTaEE0V1RSekNneXZ4UENM?=
 =?utf-8?B?SUxoL0tYaVduNEdnRDM5WklGVGJoSDIwSG9QY05GdkphR0U4bEp2ZnZFWVNF?=
 =?utf-8?B?RVJNbE5iRWxsRnZBTzQ3QXZ0VzZRc0NiZ09LVVBWQ2ZIMTF0QStjYUthS002?=
 =?utf-8?B?WCt4NVZPakFJMHRDdFBmTWJrK1l2NUs2dVIrbEZxUWdhTFNlUEhVU3dkSFZk?=
 =?utf-8?B?VXNQTEVtWFpmK05DT0ZQNCtoVkdZNTAvK2UrcG45VGt0V0NiYmtGK2IwUXps?=
 =?utf-8?B?WDJsb3dKVGxUN3NVMzdVSzhVYWpIMGYxM3JMU29sQlhXQURaQ3dVWUNmSy9r?=
 =?utf-8?B?Y25kTW9Ec0xRMm1LZkljcHNUREtma3AwSVFXNzh2ZWVLMGVhRitwMmo0MWZD?=
 =?utf-8?B?YUptUkdEek9Fdkk0dUFIM2VnNFluUGVhd0hPQ3ZtamVFN1JVQlBmSjY4Tllo?=
 =?utf-8?B?UW95Znh6eGdhQ3lsUVlXdlhhQmcwRXV4MGk3OFVVRUhYc0dyMEwrNmJXUHBn?=
 =?utf-8?B?Q2NlTUFwcEZteGIzcWhXU2lObGRabnJwUEgrVkFCeDc3MmJQZXBPb0RIRU91?=
 =?utf-8?B?QlBhdXR6TTBrcm1iaTlYS3BzeUNFQVdsbTFqWTkrYXZ6N2FPbmJiaWpDcHhy?=
 =?utf-8?B?emVnN29YMm5tUXI1N0FGemhxQngzTVF6M20ycEIrQWltdmVaUlJxM2haZTdL?=
 =?utf-8?B?cVVwdGJvM3EvVEF2UUZwcHAwaWF1Z2E2V2Ztd1FzRHNVcHVsTlpDK2dQbXZq?=
 =?utf-8?B?eEUrem5TSjd2emNsYlB3T29vSXVjUW5TOFdTZ2toRFVyRjdaSGtSWkxLMmR4?=
 =?utf-8?B?MmEwc3E1MUFQRktXODB4cVZwMGswaEMzV3lhUWY0T3piTTRvdFIyalR3eFgy?=
 =?utf-8?B?eGdXZnM5dDN5U0F3cFA4cDg3NkNZYlZlaUQ0YWlmdjEwMWdzWWpxSzJNbjFt?=
 =?utf-8?B?dUg0MHV6M2MrY0xDU0xOS3BRdjBIa2ZWcFAwZWJLRzJsSWpjS0xPYjdCemlX?=
 =?utf-8?B?T2NhSnVSRFZ4cWhHRTNpV216cFJvS3VkLzdmdEY1S05IWGgvc0crUzdJMlh2?=
 =?utf-8?B?YTN1N29LWEpuQ1A2aHE1QUNWNVZwT2w1Wm4zby94K1lySFlnZEVCVTZ2cnNS?=
 =?utf-8?B?Q0Z0NDNzTFBHa01hcDF3bXgrOUhvVEJWcURXZmQrcjU3TytEbjNUSlpTRlF3?=
 =?utf-8?B?bzE1VnNNUWtaRXlCR0cvd3NlTjM3SUYzVVp3RlAxNnBXUElmK2lId2dlaGdy?=
 =?utf-8?B?MUJMQTkxQWd2UmpVNXBFTGtyMktRZFYraDFqYTcwZ0Z2cmx5WHRudGJwaEFM?=
 =?utf-8?B?c1JFcE5pekNrckZ2cXp1K0VoMUltc1Z2UEFoTjhueTVIdGtCc0Y1QjMwWllD?=
 =?utf-8?B?bjBQZ3Zidjl0d3JsQnBudzdsTXh0T2g4U3JoNmYzdCtpaXNVNzlpSy8vYlRB?=
 =?utf-8?B?RUUxMGJUeTRjUXIvK0RqZUtkcmd4K3FUeXVsdHFvcEVCM01OOE5oSVhXNUZU?=
 =?utf-8?B?WmxRbDFlMHNiaTcyL04vRCtuVDZpSE5uZllHbzNqQkRVYVZ5WTN3RmpadjRx?=
 =?utf-8?B?ZHFueXViWmVyVCtGZWtBK2h3a3NVYW5EMlkyYS95czdFTmR1YVNObklBMlM4?=
 =?utf-8?B?Y2MvT3NkeDZWL2laRVBQTE53cVR2UXRLaGYwMmx3K3MxdUVBZ0w3b2grNXB6?=
 =?utf-8?B?UEQ1UFovWjhsdWthZkRwdDNhLzh5aHA5MFdpcGZCZkNlUlhxak9raVRZcXlC?=
 =?utf-8?B?Zm1BbUQ5bW81R0N1SXlvdkdGNlpwRndleExjeHpYbkV5UlVOZ3MrZXJ3QUsw?=
 =?utf-8?B?YXFKdWh6Mk9vTHp4M2Znb0pwWkMybG9ubUpRdVZ3Y3REWk81RWpUZGljV1Ru?=
 =?utf-8?B?RHk3MFdlRnlmMWdPRXdSTU1xQnRLTWxLejZQSzJCc0VLQWhMTkwvODVBWlZv?=
 =?utf-8?B?Snc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2dd42bb-1a12-47a8-0a8c-08da5ab0a054
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 15:53:07.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxLlrFY7YwPndRVQ8WV/cyloE13uO94Mv8razmuZ8Np+UO4Qq39zQeb+6n7NKzP8l4yn09H98xUCay9NwL90Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/22 10:09 PM, Rob Herring wrote:
> On Tue, 28 Jun 2022 18:13:30 -0400, Sean Anderson wrote:
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
>> added for. There is no "generic" compatible string for this reason.
>> 
>> There are two PLLs, each of which can be used as the master clock for
>> each lane. Each PLL has its own reference. For the moment they are
>> required, because it simplifies the driver implementation. Absent
>> reference clocks can be modeled by a fixed-clock with a rate of 0.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> Changes in v2:
>> - Add #clock-cells. This will allow using assigned-clocks* to configure
>>   the PLLs.
>> - Allow a value of 1 for phy-cells. This allows for compatibility with
>>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>>   binding.
>> - Document phy cells in the description
>> - Document the structure of the compatible strings
>> - Fix example binding having too many cells in regs
>> - Move compatible first
>> - Refer to the device in the documentation, rather than the binding
>> - Remove minItems
>> - Rename to fsl,lynx-10g.yaml
>> - Use list for clock-names
>> 
>>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 93 +++++++++++++++++++
>>  1 file changed, 93 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml: patternProperties:^thermistor@:properties:adi,excitation-current-nanoamp: '$ref' should not be valid under {'const': '$ref'}
> 	hint: Standard unit suffix properties don't need a type $ref
> 	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml: ignoring, error in schema: patternProperties: ^thermistor@: properties: adi,excitation-current-nanoamp
> Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.example.dtb:0:0: /example-0/spi/ltc2983@0: failed to match any schema with compatible: ['adi,ltc2983']

This looks unrelated to this patch AFAICT.

--Sean
