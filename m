Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328CF562197
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbiF3SBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiF3SBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:01:44 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150078.outbound.protection.outlook.com [40.107.15.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0083A39B9D;
        Thu, 30 Jun 2022 11:01:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLSKD/Tl3ASoNZSYiKXl/RvLtQm5JEqhWaMe2YslhzSoF5KOAjdz8XI8d8K91ZiHgIGJZ+NpKiAW2sVTP6SOrMCh5HnBaJOHGWQvwO4CgHolFN5RLnmvgDtkbP1fWTd+vQGmDzWbf0LG8gMQ6c8pJnNSKV4kZfKBpAdkv+n/49GeBuXvoZjd0LF/29jVg7e3P5kxAZvMmhCSADHK86FwyNmdNmqqIGrRN0lDmPkRERgloeA9HgS0XC61Yxnx/9wHBs0HI1Jt9IMcUUW2OoW9Rgkze2kP5TuErETPjyQ8WYnHrzSpZ3h3rVdXoo4G/nHD0eKB6bJu6bI/jp/cyE7gOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Cp1PGB+bejSR6Fb0kr5hRWDAezUbZCfJnJ4yrbif4s=;
 b=Qc8mSEW6jaAf5QkpeHZI89xg7SMdkDUUetn89KTQoZsvyib7Y503PdfNgDG8Dd80m1ltSJeZgZYKZuPrtswLMpeaXQXIxCY4VbA6kw5ZDo4fbmtDYcsiAc3tolr45wT4q4jzzrVvZ+TART6QpSXIT5XuV6anA8HpSc2mcUx9/fBK9P75aaN4dgHKRF2IOae70SLEjF+DXQ2fEIAVGactsJ2PNvkf4ztK4wWq3hTT+z1qfwAHfk6p11pZd6YGVMx4uC2GCqLOtL1d98Od8dDG8UN4VCJcvHU+AlF0d5TiGa2y30WH1kJb+bojuBMzwc7lto8moBAmsfVFRcy7JuwOwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Cp1PGB+bejSR6Fb0kr5hRWDAezUbZCfJnJ4yrbif4s=;
 b=gMlsuiv8jwe4Si0+5PRcoRJxLCSQvXFZSakQge6182iq6IvCZpXJ+DDFRfr26F9plySaVXnI1WgBOEQcb5eUQpfAhPZ9om/4jrt6TSMcEF7HfhUXPAAoNyQ+tMrLJYMP4xLtlxGRApuhLv+kmBnKkMkq487QKBAhGA8NeNR1Cu+3Ki1pnQq8pUREtASu0mp/ZwgG7hlTWh63NmjR86jwpZuZ+MY1A6Q1wBYI63uXpSklJRAUCwaRn6sKV6o4osJpp4MT+EpP2NJM/WPgbRVJjJyFMXmq7tj+8i49RZE027pfpQQ1oywgkHBdyGzwhwMR7a0+vD4bycYQq27yycCVgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB6693.eurprd03.prod.outlook.com (2603:10a6:20b:23d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 18:01:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 18:01:38 +0000
Subject: Re: [PATCH net-next v2 01/35] dt-bindings: phy: Add QorIQ SerDes
 binding
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-2-sean.anderson@seco.com>
 <20220630172713.GA2921749-robh@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <7fe84856-7115-b0f4-b0e1-0b47acbddb7a@seco.com>
Date:   Thu, 30 Jun 2022 14:01:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220630172713.GA2921749-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0295.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05156145-d596-4590-b8d7-08da5ac2946c
X-MS-TrafficTypeDiagnostic: AS8PR03MB6693:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWv8PYy4ROpIvarFGmrsMY03V7ZRvEs37cWhWcC45p7fbeaQxbvfQjrRI+tmRg9rkqVeCKDmUFiY4VpRjaFc2hV6beaqX4Hn8cfYjla/dXfCExxpTALxVw6NOH4ZVivXjyHab40AuJ2tFnmLZPNfRtoLdJsZI+e42vXSaOGG+syW3NoT8MmMP/V9fUfSIb/exrhSFNcaJWOClSxLdcKmpcL3yMjopfxB4KGspYWKtdrwC4RB6QS465/tYEemXSNk7GdUAep/xgWJv+A2i/OrFOwMxL4jBdXWEdplUzQqI1TloQ5ZmOY0eV2TplOk5xqkrkoBazK4YBTHGhD0BMh1wSyigqAE3O2wVuRPF46ostGskCW1o4FjRJCVozdN06mFau7LlHRsaAqXfHse/MaX68H0bNjfdgz1X5fOK0WhUyAwS/xoO3VjyU57n4TJXJ+4wd/wd8m88N+TbMXAc0JNTHx3wBVabcEib9KVXwFEkj+wlT/fTCpMTviQkzgPC6VMZj9P3Y6jIgHuVMCRJ23wZt4sfdVkFB69pl1840yTnGPqRLMTytBohiith/plRup37Bcrt03iN4ZnBAonjVbUlATis/TPGJH1qs+w933vSADtS0UnDmHmbcMdk5Fz1E5ciAJRPp39IkbwsbsI/Lx4G2JzIQiFD1ZHWyYoGmFB4Az70ZQ0oV2mg2EZaUrJImu/mnhFmduw3JMV+pDS2+gNvK0nzUCN/kjy5t5iRNcVp2JjH9EvraM0UnrugUSEg2HFTyjXpPVBn+R5lqI//p1LgSZC+gnRo/Ob800oTHCzKyXDb6PCkFzGb2d3aPrz4GRpiobFyxn+3w96M07RROe+nTzkN6EPxvCMqZuZ70++qKTkSg8bKHP1TISfPjwInZZhR947NilyQJnHc746U6mWF+GSMAIoYQ2Mv3vf/agMzBSrPQlCt56kFYT3R8jyqVo5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(396003)(39850400004)(346002)(366004)(83380400001)(36756003)(86362001)(31686004)(186003)(38350700002)(38100700002)(2616005)(41300700001)(2906002)(66476007)(66556008)(66946007)(8676002)(26005)(6506007)(5660300002)(52116002)(44832011)(53546011)(8936002)(6512007)(478600001)(6486002)(966005)(316002)(54906003)(31696002)(7416002)(6916009)(4326008)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmE3c2U4ZkI4SVVDNytGN1NkVkg0M3FQWUwrMGZMQnoyN2l4Z0Mra05sOTM3?=
 =?utf-8?B?amZMSUpFa0F0MVFlYkdpOHlIbldwaDJFZGwzMXFhbGxMMEU2a2RQYjVvaGlw?=
 =?utf-8?B?Z2E2L1k4RzJxUUJ3VGV3czFxeFNuMjlLK0FHRmNONmx5MDZWdlgvdDJrRGZT?=
 =?utf-8?B?T3VmR3JOTEI1YWFidHQyVUx6SWtrVzhxR3Z5dTNBc0lObUJXM1ZETWFPb3pN?=
 =?utf-8?B?cFF5ZjkxSFhYSDlRdlBEUDR1Q0lnSHY4TDNmN1V3OEN5dlpWZGRUUFR2ME0v?=
 =?utf-8?B?blhZSDlUMnY4SGRGa0RVdTloZ2hPbTRBOGpRMko5U240dnBBOWhqSFNVcExy?=
 =?utf-8?B?Qlk0RFdiaFkzNzFOdS9uYzlJcS80YlRCWGh5Vy84OWtJUlZIdFN4RzZhc3RH?=
 =?utf-8?B?RWZFVUpXNFVNOHdCVFhWT0FidGFwSU1zUVY0bXNwYjFyU2Qwa241Q0huL0h3?=
 =?utf-8?B?WkNDcUYwWUlzSW1XczlVTFNHNHQwa0FuMUZqdk5Ec1VrVVc0Q0pvZGFoZFAx?=
 =?utf-8?B?YUVHYkh0bVk3RDRZeWd4ajJoOTJJUEtYdDhOa09pdDVVTGhLcWdiWGNuRWhC?=
 =?utf-8?B?b2gza2ZmUk1waW9ZNTNJL2Z6K0tveTg1dUhCb2lvZUNsYVpwZUlrVXBxeXJr?=
 =?utf-8?B?TWFDb09CdlJVMmt1cEYxaFk0bXY0YU9FSk9zNjZrWXdJWVdCSnJmb1hzd2Jq?=
 =?utf-8?B?T21xNmVNemdvK0h4K2hBNkFUOEVsUkcwWGx0WDVkZXE5bStLaXUrcFJuMTY1?=
 =?utf-8?B?QmlLRi80Z2d0dUZDS3B3Ri9zeGFrN1JTT0MzL3I3cndwWW94QktkMm91OElL?=
 =?utf-8?B?RTUza1UyY0RSSHlSWVgxckhEZ29oYkZyQW5HbVdWUVZsU2ZVU3A3aFZVVW5n?=
 =?utf-8?B?dS9DMEsveUZkSEU1Wkt6cWFyTXZhSm1jQTBnV1l6RXFTenB2Um14b1puM0Iz?=
 =?utf-8?B?MitNWnpqSkdQNm1HYWgvQjBkTUtnQnRCQnovUlU0cksrUDZaMmU1dXk3ZFlK?=
 =?utf-8?B?djhvNzd1YWt5VWZBUlRIdGRZU25mNHZ4NCsvOU5YRDkyN2I5MktSRWd0czRn?=
 =?utf-8?B?bnlXeVFOWW03QVRnNXRSQXAwN09DdXdNN2kvaHA4bkhuUjVpSDNzbmdOYUg4?=
 =?utf-8?B?cTN2dWNJU1p3aHAzaGQyQmFPZTdyV0g3WlpEYXVOUjRJRzJkNmRKU2xSLzcv?=
 =?utf-8?B?YnNNSGhseXJFKys5SmpxWk9zNFlxdm4yeEVYaU04STlLSVZKRUNBazljRHhX?=
 =?utf-8?B?cDNuYTJGbDBuSHExUGN1RkNkckxDSytRejRPT0Vrelh0NHZtakJJQ29odVg0?=
 =?utf-8?B?N0swb0x3cm4yL29GTzFMZFpSZjBJdFYwK2dFTVk0MHd2NjdtR2FwKzEweC9z?=
 =?utf-8?B?b2RnRFZJd2UzWXVNMVM3eGdxQWJ3dGNTQXBMWldETEI3MEMrd2FnNXRWMzBa?=
 =?utf-8?B?WUx6Ynd0QVUxVEo3b21aNWZQcFhmUXVKZlgxclNuSmVTWWhqRjBFT290aGYw?=
 =?utf-8?B?cHZSd1M5QWk5L1hWazFCdW9ZSHEzODM3dlprallwWnVuYXlZeWxEU3p2aTZv?=
 =?utf-8?B?VE9DaVFYQ0czSFYyb2Z5aEFoaVRDdEZPazZ6MGxLOVhEOVdjY2dwbmhDOTh6?=
 =?utf-8?B?RGMrNzlyR2pKMGJ2QVpsb2svU3FQR3pXZDdDRDJ4WXRrdlYvRk9qcXQxYlZr?=
 =?utf-8?B?SXVubzlBMXdrWk9iWUw3VFpRTTJlb0tYT3pXNjNNVG42MStXK3N3KytiTFBV?=
 =?utf-8?B?RWdhdzhoQ3pPTkltUEJuOExvaUZJT0tSYjhqTFVIZEJBdkMxdU5pM3FLVmNu?=
 =?utf-8?B?UFd5VE1yMU1MeWY4Z1BCb0pYYzlYM0g3NDgvTHBzVWNvL1Bhell6Sk16SHdM?=
 =?utf-8?B?a1FaVnE5TUhqNUZOeERhQUx3MTRublZXbFBFam5BRXo1V3JmcVgwVVhBSzd4?=
 =?utf-8?B?REcyNUhxcExtU3RER3BaSXVTMlBoRTh5UXQrQTY2U1haL1k4Q254UjBlVkQ4?=
 =?utf-8?B?a2lxWlF5TGx2ZXZ0dXRpbWcyWS9iL3FGOVZJbTFSUlFteGdtaWYxNGV2YXZE?=
 =?utf-8?B?UkVvSXpZbWNxdkEzQ3dSUkVPRHpQWHNCU21aU0xHNUVtdEd5ZTVIQWN5RXlp?=
 =?utf-8?B?dXE4Y29BNG1sY2k1bHVMT1g3WWNnL0duMlRtWUVVZ1FxdDdnL0ZoMzVyM2R4?=
 =?utf-8?B?ZHc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05156145-d596-4590-b8d7-08da5ac2946c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 18:01:38.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx9cr0SkKHabGc3TgqNp733rE0CE8Iyu1g11YszyGfJrB50TxYZlkPiGINgWmo1kwTo0X3JuOBmXv6QGUsvpHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 6/30/22 1:27 PM, Rob Herring wrote:
> On Tue, Jun 28, 2022 at 06:13:30PM -0400, Sean Anderson wrote:
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
>> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> new file mode 100644
>> index 000000000000..b5a6f631df9f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> @@ -0,0 +1,93 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/phy/fsl,lynx-10g.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NXP Lynx 10G SerDes
>> +
>> +maintainers:
>> +  - Sean Anderson <sean.anderson@seco.com>
>> +
>> +description: |
>> +  These Lynx "SerDes" devices are found in NXP's QorIQ line of processors. The
>> +  SerDes provides up to eight lanes. Each lane may be configured individually,
>> +  or may be combined with adjacent lanes for a multi-lane protocol. The SerDes
>> +  supports a variety of protocols, including up to 10G Ethernet, PCIe, SATA, and
>> +  others. The specific protocols supported for each lane depend on the
>> +  particular SoC.
>> +
>> +properties:
>> +  compatible:
>> +    description: |
>> +      Each compatible is of the form "fsl,<soc-name>-serdes-<instance>".
>> +      Although many registers are compatible between different SoCs, the
>> +      supported protocols and lane assignments tend to be unique to each SerDes.
>> +      Additionally, the method of activating protocols may also be unique.
> 
> We typically have properties for handling these variables. Numbering 
> instances is something we avoid.

On v1, Krzysztof said that this was a better route...

>> +      Because of this, each SerDes instance will need its own compatible string.
> 
>> +      In cases where two SoCs share the same SerDes implementation (such as the
>> +      LS1046A and LS1026A), both SoCs should share the same compatible strings.
> 
> No, not unless the 2 parts are just fuse or package pinout differences. 
> Otherwise, there's always the chance they are not 'the same' and have 
> different bugs.
>
> You could have "fsl,ls1046a-serdes", "fsl,ls1026a-serdes" (whichever SoC 
> is older last) if you think they are 'the same'.

Fine by me.

>> +    enum:
>> +      - fsl,ls1046a-serdes-1
>> +      - fsl,ls1046a-serdes-2
>> +
>> +  "#clock-cells":
>> +    const: 1
>> +    description: |
>> +      The cell contains the index of the PLL, starting from 0. Note that when
>> +      assigning a rate to a PLL, the PLLs' rates are divided by 1000 to avoid
>> +      overflow. A rate of 5000000 corresponds to 5GHz.
>> +
>> +  "#phy-cells":
>> +    minimum: 1
>> +    maximum: 2
>> +    description: |
>> +      The cells contain the following arguments:
>> +      - The first lane in the group. Lanes are numbered based on the register
>> +        offsets, not the I/O ports. This corresponds to the letter-based ("Lane
>> +        A") naming scheme, and not the number-based ("Lane 0") naming scheme. On
>> +        most SoCs, "Lane A" is "Lane 0", but not always.
>> +      - Last lane. For single-lane protocols, this should be the same as the
>> +        first lane.
>> +      If no lanes in a SerDes can be grouped, then #phy-cells may be 1, and the
>> +      first cell will specify the only lane in the group.
> 
> Usually when we have per lane phys, the consumer side will have a 'phys' 
> entry per lane.

The problem is that it is hard to coordinate multiple lanes coming up at once. There
are particular ordering requirements when multiple lanes are grouped together:

> Note that if the lanes being reconfigured are grouped for multi-lane or synchronous
> mode, then the master source clock lane for the group must have TRST_B set to 1 
> after all the other lanes in the group. The master source clock lane of the group
> is indicated by LNmGCR0[1STLANE]=1. All lanes p<m (if LNmGCR1[TRSTDIR]=0) or p> (if LNmGCR1[TRSTDIR]=1) of the master source clock lane until the next lane with
> LNmGCR0[1STLANE]=1, or the end of the SerDes, are grouped with the master source
> clock lane. All grouped lanes must have the same setting of TRSTDIR.

This is trivial to do if we enable things as a "group" but not so easy if each lane
is a separate phy. In particular, we have to know up front whether lanes are being
grouped together in order to program 1STLANE correctly. I think the enable order
corresponds to the order in the dtb, but AFAIK that is not guaranteed by the phy
subsystem.

> Having a variable number of cells isn't great either. We usually only do 
> that when we have to extend an existing binding.

This is mainly to align closer to the lynx-28g binding. It can always be restricted.

>> +
>> +  clocks:
>> +    maxItems: 2
>> +    description: |
>> +      Clock for each PLL reference clock input.
>> +
>> +  clock-names:
>> +    items:
>> +      - enum: &clocks
>> +          - ref0
>> +          - ref1
>> +      - enum: *clocks
> 
> Whoa, there's a first. Don't use YAML anchors and references. We only 
> support JSON subset of YAML.

How else should this be expressed? I would like to allow both

clock-names = "ref0", "ref1";

and

clock-names = "ref1", "ref0";

ideally without repeating myself.

--Sean

>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +required:
>> +  - "#clock-cells"
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
>> +      #clock-cells = <1>;
>> +      #phy-cells = <2>;
>> +      compatible = "fsl,ls1046a-serdes-1";
>> +      reg = <0x1ea0000 0x2000>;
>> +      clocks = <&clk_100mhz>, <&clk_156mhz>;
>> +      clock-names = "ref0", "ref1";
>> +      assigned-clocks = <&serdes1 0>;
>> +      assigned-clock-rates = <5000000>;
>> +    };
>> +
>> +...
>> -- 
>> 2.35.1.1320.gc452695387.dirty
>> 
>> 
> 
