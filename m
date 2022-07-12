Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67285571D6F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiGLO5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiGLO5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:57:41 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E66E4F1AE;
        Tue, 12 Jul 2022 07:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtFp56Z/sTr93Gm9BO+kgCgV1f1Cjw4bHXSZZrkZKsBb5Z2Fvz8c02K9IeMpwsTQjdcVbH5dsB9pGud/Jfk+IoDYvqa1Ga9nJ0razsLuxLHgGujuYfeooGHe0SMTBZ8dgvUSuI3jWg06NUIQqRz6hKvk6oU4w1Qyb+y4QJbOC/Zq/a+9JxKJ8KQ+iwP554L5TZDxdg2AtliyCQ6HXnrZn52On0tzdhsU+bBqpNgKO8G4n0LctPK5p9X6lW8CNTvMEdi6Lba+z/nn+TGXd/M/UXU+shIwsKTvhjZ9GKnm3muY9USG+Alw42QLjEpI28RpIQeO6YxPThL+TOFngLPW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRphrDypqy005jsKDc2GJMfiKRNFJmIWNrTwlN3PKCQ=;
 b=S/T0i5idUSuEUOpqd7jvR67lQU7iLVqzTMwywltShiBzHbUEPcnsuCLs1XLSjd5Vtw4pUEn09YDMUn+AQdKuL64NHXVrj3yx5EORTASgbnbqkJZgJygBVf7wfpFsgJXDgC4p4x1WnQtqtkAWUefkI6ipP7u9mDdO6RLRKJBvTXDOQoFqIjUIAv6U4g2WbT4yFml3PM6UHxLRcSQw3VevfngZTtuv2UF0aRbbRrAl70OWb1t6/hJ5ETQyklOrAGlaykqyM2eT+vOEGtdeTbc3qkaTFPMkhBpkMWfzAZrKyEhW2WjMkBYZDd0hcpzs0tX8HAt4VT6YGmnMuOG0ouFk/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRphrDypqy005jsKDc2GJMfiKRNFJmIWNrTwlN3PKCQ=;
 b=EMWhHOIGICGBJr+IICoFp1UCDgfPv7JZwstCYDrrXgRETHPyUYGglqnUTe9S6UuX0fEGNvwQ3rwoLb2/YyHPy7Rra8PqhEak2/Hp3bo6zqBqB2KxAlDhIDQGKK1dtQnS9Jjg4z4L0ZTq2+JiYFqAU1AWa3JzmR8mgW6yxDNT/+P/kLkDAGoLMdsN4M7n7eq3ru/PaUJtCLcPDnzuFMcoAi9Ja5HPPvH4jww80EOaH/VN8ihp2BzJZ+HeEqkUsMwoz9Bs1VbF91fdvpr8V5YWoXOBXm9cYOoD86QYfroVLydk+q7baKZR1SIGru+L3mClk31fF+5Ceh+JZuicQ2Je+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB8PR03MB6268.eurprd03.prod.outlook.com (2603:10a6:10:133::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 14:57:36 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 14:57:36 +0000
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: Add lynx PCS
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
 <20220711160519.741990-2-sean.anderson@seco.com>
 <4584120c-8e6f-6943-1bd3-aa6942525eda@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <a6b2d031-8356-492b-8eef-a7cdfacaba51@seco.com>
Date:   Tue, 12 Jul 2022 10:57:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <4584120c-8e6f-6943-1bd3-aa6942525eda@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0425.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::10) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2eece398-af00-4d55-4baf-08da6416db7e
X-MS-TrafficTypeDiagnostic: DB8PR03MB6268:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0iWdn+BPlT83PZXGHl57jiZUeLUZaMX9+OA443xzkOKMSp0WFG9h92cK/EmwatcjPVagkWD5cP4gI5J/M2JVub2KO7waUc0QTzZbkz8AqAiF9JXMXNg0NnpemwCG/BJlPED0cLXsVXBSrZJIVYZkFkBWnc6QDPMRKxrYYSEA1KYVvz+qFeP8EtGqf/cf4BtMc/4FEoVP5AtKLOqXQSbiipLj0oSUjueMOj3QHlnk9n6MdcaMcFx/9o5Kh8XIpGglx3t+ei3vaVwoZZp6KTdi6Nu0VkxhQSVXpNqJtPk5JZqPH3oAYrlBjJKy+VQtnToJuvAlqFVBYW4HnyagIuAMsdM56rRBsVLLT377BTpBQiECXtkn9DB2lKH/xkx7SHL8/rjpdK32yBXCoUV1TS66FF94eD0L5YVx1VJB2sZobX21E2SGBwcb2K13RwLh2xgjuXhmJZzrdKNoU9a0E5D2AzZbhPw6SQM+93TWVh48ZCnBGjGahahvgdl6+GWeNFMkvub3NWa5l8hoYSp9lFO61NhWKEcPCAe6tiZguaYwQXgh6Cpnue/E/Xa1tByXYl7L2xkGHdIM1wa+3RBPOuHljQfWzadJFtiCPxeYDWxig4KXS0KN0hJoM4IReBvhwGK5IkDwpg7H9dZaTXz7EpWqlYzfekCP1OkqIEdDhw9mmDriulUt1s/wqqgI+G60ojuXH73lVGd15Y8IHDVgcb+JoZ3O173CMPS9ol9xVZVYqOHLdJzgMy4lw86f5w+atRXZS4IoIOZr9xnDSwKy0gY8FAxCd6YroPjP1oIvRa1w4eUTG72PJziQgLy8n+wEjN//oPYJGTNryW9fEdVDQgGQdf/J0uYIfNhDxZUh/YrtsCSZYTLdJuC3b147DMtfr9I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39850400004)(366004)(136003)(38100700002)(478600001)(52116002)(31686004)(86362001)(38350700002)(2906002)(6666004)(6486002)(31696002)(53546011)(6506007)(41300700001)(8676002)(8936002)(4326008)(66556008)(5660300002)(2616005)(44832011)(316002)(66946007)(66476007)(4744005)(7416002)(186003)(36756003)(26005)(54906003)(110136005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEp5R0lEdytCdnZ6Si9UVzQ1VHN0NUpDZWZKeVpXR1BuT3BycnNoMUwvaWZT?=
 =?utf-8?B?TUhMWGxGQjZramdQMzBKZVQ1amY4WU9wZDI1MVphWExmVko5MmpYNWpmYkVW?=
 =?utf-8?B?NmIzWXl0NGIrRVBGU1gyQVg5eWxtVEN3UmgyczZaelBobGxEZER5NjZmRTZQ?=
 =?utf-8?B?ZFA3VHM4WVhCRFV4T1laemVnSXF3QXVjenlrK21yblhDVG1lZmxaS1BmdEhj?=
 =?utf-8?B?SXN3N0o1WFN1SU40RWJ6cnVjWWVwbG1kTTBSQnBVZEo3TjZZUFRaTlAwNCtY?=
 =?utf-8?B?cjZGQlYzNEhmcVh0RlhwR0V2WldzblIxVUxXeGhtRlhoaHJSQ2JSS2RlNnRn?=
 =?utf-8?B?c21ZV0ZmSlIxcVFHazgyWjY0TkgrbEJISm82ZnNUdjdHdkFoUG8wMk1uSDNr?=
 =?utf-8?B?enNKdVRLSDdCNDRMRHhWR3Rlb1ZJUGI0ZWM3VFI4Y05uOTVOeFFIRE8xaDNu?=
 =?utf-8?B?a0FLQUpjMm1XeVI5QmtHNkNBNFlyRDFIZmNTbW11YkVaUFRnK0J2bThQdkx0?=
 =?utf-8?B?STNHRGNXRVpzMmNjQUJGYnlBcXBEWFovSmtVbkcxWXlaY3BYOUx0bVdmUjlz?=
 =?utf-8?B?d0hBZ1FSa1NWRzFnV2JzaU5jNjAzNUN1RlRnSjlsT1V1NzZMK0cyRjBjUmlK?=
 =?utf-8?B?S1IydmtHRFZtRGpEVjVXVU8rUW81NUVrRWxDN2xHc1p4dkNQVnF1MzltMXNL?=
 =?utf-8?B?Q2JwSUlkOGhxcWVnMVN6TzUrYitDWFhqZmZ5QVQ0VFBzOXBDSzU1Tk1lQXlq?=
 =?utf-8?B?ZlIyUFJ2YVh0M2F1WWYweFA0eUJ5eVBISmNDQ05wemNkMUQ2Q0hVQTJqZFBx?=
 =?utf-8?B?MnovRVpRT2tsWGQ0a2U1cVpWMnhmUGNmc2prclA3OGVnYlpHRURsVnIyUUxT?=
 =?utf-8?B?UW5qR3M3QStXUGxBY2MvZldrUzJoWGdmVTVvZ0o4bXpuQktaRTVSVEV5bHlm?=
 =?utf-8?B?aXF3MGVCZU0vc2FNL2V5Y1poTWI0RUxpbGYwZDAyNDNWa1FxbktXa1hjcmNL?=
 =?utf-8?B?R2N2VWh6RGlQdHZ3S1pFSU9udUxzZGhIOXlseWlVdjMzRlJqZzJYL244amhU?=
 =?utf-8?B?R09ud1JXQ1RnMWswS1g4WmRiR1BLTWluTEFFYXBsMVpiVHYwL1VER0dWY0Er?=
 =?utf-8?B?eFBGOTFxQmROZEthbDc4MURrWDVzYm5SQmhhdlJFMU94MElKaVNXTWk4aExW?=
 =?utf-8?B?RG9rbjFVZ1RzZHhxNU5NMmE4WmlUTVRDR0FhcmcybkdTb2hKZi9sN0liMndi?=
 =?utf-8?B?cFZIS3FvSnFuRzRFcFMvMjRRMzNDanA0UjlIZnJIVEQzZFF4dWo5YkVLaldo?=
 =?utf-8?B?WVQvUHpYMTdTcldDSGNObnF2b0xvT0JXc01OMWlQOEtsQk9YdkE5RGVkcGFN?=
 =?utf-8?B?NG84eExPNjVmNGh0cGROUVBHZ011cnNHdnh3ZzNqQjdGTjd6bWVMc3JaUHRx?=
 =?utf-8?B?WVBwR0FjYWV4K3ZQa2xoclM4V1VVNmFKaHZuV2R6RW1HYW5jZVhJWEx4SzRV?=
 =?utf-8?B?OHZUK0p0NWtwV042SDdYdjNHazRoSjhaMHZXUmwwOHR3YlFpNEMraFQyRTdB?=
 =?utf-8?B?SkZwLzNwWmpuM2M2V2lhR3oxL3RLYnBnZWpRTStBdDY1OXZGMHh5d1Njd3Iz?=
 =?utf-8?B?ckp6NndlMVNSV3RsOXRGdHYrOEp3WTI0amxXZXVDK3FJeUlzSEh4dWNzWVZT?=
 =?utf-8?B?ZUFBR1lFK3hEQmJNdEVCQjA0SjZKNGZlUmJleW9MMTBYMDc0NFNhY1FJbTJ2?=
 =?utf-8?B?TCtkTjV6dE9JQW1aODEzUDFVVUtTMHdHNUJqVjVIS2psb1IzQTlmVGtEYm40?=
 =?utf-8?B?bm1MRkVrQ2ltQUx3bGRwSlFOcWt6RlRCVUFRZXVYeXRnM3I1Z3RtcWZIbmRu?=
 =?utf-8?B?bEVzWjZjaUp4M2RtZ0FtQmU5OUFKMXM1UUdTNE5VYktzazZtOXZpR08xM2NH?=
 =?utf-8?B?Z2JwTXpNNmw3NlNjMnUyYnlpQlNDelk5ejJtL25UZUY4UTBVTmtHZUVhdlF3?=
 =?utf-8?B?L0ZPVS9VZGRQbUl1ZllmOFI0anh4S0Jabzc0MFl4RXErOVVUNW8zbDY0V3FE?=
 =?utf-8?B?dHNsK1R3VTE2ODBjc1VlQzAyNlZiTVNudUYwejROVXVSQ3lxS2VCdWdUcldE?=
 =?utf-8?B?TFZnNmo1SDRmdjZUV0dxZDZzclpQQk9KbjRlQyt3WlRiWkhsS05LRG1OdE1y?=
 =?utf-8?B?cVE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eece398-af00-4d55-4baf-08da6416db7e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 14:57:36.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rScO5trfev5zDJR7ffKNf7lm+zE/Cj61yEOccjmkKo6STt75l2zC+8d0g8ZZNElNMwAWzBLIeZNjSvTg+ODzJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6268
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

On 7/12/22 4:47 AM, Krzysztof Kozlowski wrote:
> On 11/07/2022 18:05, Sean Anderson wrote:
>> This adds bindings for the PCS half of the Lynx 10g/28g SerDes drivers.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>>  .../devicetree/bindings/net/fsl,lynx-pcs.yaml | 47 +++++++++++++++++++
>>  1 file changed, 47 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
>> new file mode 100644
>> index 000000000000..49dee66ab679
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
> 
> Shouldn't this be under net/pcs?

There's no net/pcs, since this is the first of its kind. There's no net/phy
either, so I didn't bother creating one.

--Sean
