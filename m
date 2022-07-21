Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1521057D0AD
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiGUQF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiGUQFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:05:55 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96262EC;
        Thu, 21 Jul 2022 09:05:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTPaocYciF/X8aFIR7VxiE1rxxOSBT2hxKfWLhbo+9EbpAqNDbDgjZ2pjHm1A4vaXrXsyByb7xyPpuahPygX7ClKu5MTQEI9wmBubFxPydFf08FsCor2sao1dGTdB4vX16vdzraAONS7CkTCI1P5Hjar42ZUn8Qfwt1u0N+xUTiD318ZaOJLRKQE3raOoD8MEyKujlcXaCiLNNLuWCiYoLs/7sqx0+VMWvVhB3rvosZoaoFnoNr7zItA3Y3bKEFvcItQzzvjKpVTuTdDtYggmTIBnwVvqdvsnab0m1c0WneVXXpq0YkBC8RP3ysbitz5gRlwsPCzdHN8367SydH4dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAjlAPcxyfW4U8evg2LPaBEhGFjGH4Spt8ciBEaUe/4=;
 b=jlWSKHLSLur3uFxwRC4a1M8XBVRheEPTlNMG12xGrXZiCDXWo3fVH0/zFvv0fYdgISxiqGqot7J4lU8ih9CTsyq4O/XFrIxjU8hufvcN5uTUsIIB3BTU5q94Fj2AsK6spv133e+I5p2zEBOn8s3b8vM3mNt4Q8RlsB5EArhZLJTZGw4xGOPm4YmBJNr4u+2usmqloFVPCqW/yKs0pwuPj/4H0ZpB8N4ii8UTyyi47AAanyUIDKTPscuTa0AHCZVQiNUn3L3L5aj2aC5l1LPLOF8xShXc7UGgyQj3gkVjiz4ztG2tY+4v37vERJuQh+D0dS2PIRz7JYAwkTgpJx0dnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAjlAPcxyfW4U8evg2LPaBEhGFjGH4Spt8ciBEaUe/4=;
 b=TnDShh6Omx9Kc6TLju99+ZRL+G8BKijoNAI5/Z1AMPMBhZrI/FueNyrwLvQPBdypiwa0askQpQ1a0kNMWRV7pTs05q7zCDMsTLZIUPMIjFrS8BqdoZoaywc/UXK1yr0D68fV/Jb7LSDdlEevnPDmuXxysp3ChLczb2IfzEzrOOsjx6yQrtUhaOLe+YVOjLHpWqzMVneDHBomBFCUbBVScr0l+bbF5REXBWLC0gOXUC8KQqL9BQHNXh9A89HepA1TkSz3+3ceDhNqprWLVFxsrKtjpFXHEQMEIT1dqyx5VY0u0vL0135w3vUsmJIeku2O2u5GtEk8N9DXtXqhYm1P5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB8051.eurprd03.prod.outlook.com (2603:10a6:102:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 16:05:49 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 16:05:49 +0000
Subject: Re: [PATCH net-next v3 01/47] dt-bindings: phy: Add Lynx 10G phy
 binding
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-2-sean.anderson@seco.com>
 <20220720221704.GA4049520-robh@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <d4d6d881-ca3e-b77f-cee0-70e2518bef69@seco.com>
Date:   Thu, 21 Jul 2022 12:05:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220720221704.GA4049520-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0077.namprd02.prod.outlook.com
 (2603:10b6:208:51::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e39093ff-f48c-479f-0bf2-08da6b32e0ca
X-MS-TrafficTypeDiagnostic: PAXPR03MB8051:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oWGsJAGMvcckqanepjyK6oUrsQ3cbiOAobxsro1iQaTD4kkGsbLAh0qqN6JUR+BUq4RZs1sybescM8ajDzVCZFvTSPOMzEUul+kXkuudnHuPLEo9UdaHOtK1qSQv9Oj7/6wY30285DjiycgbqBPM15gNNyLvMLyeTbTzZ+bNvoyE4mCjgaklTq0xnREz3zeQNuMF+L6DPL2R9EBiK8O1LktLI/nJqynoHPJdGq6+3xEbhSjEjaNAcIAzef7P+KasNz49MRE9DKtCfSLbrcGuzkkhgtgZTqOnZEG4wxLqqg+tBhXa2xX0YxR5yvDhZfR9t8Dqh0QKCjwUGyYFoZMVOtID3JM1jkDF6adPotvACLrz0H48k9socMJlRkL6d3NuazcohqSR3cdQDH9kUpAnTj0fmPMMgsK5fVyVlaMwn5BTZ1I5lXj7+gIP205/7RExfTDJ0my2kiU+ilNjb+F1rYEkLnnKO1S4wL4KdM8A34Z4GAl/SPiXhjKr5vzXvsk9BBcgz5uOkjQ9I/61pibc5ozs9wSF/4nn2Kk1u0PxSg6kPv7EfvoKHuRAoAWGPQYTtxOj3YQ5u5a8EokLMOHmKnBuSW9Z8eT+6EBMEvoxIlq1m9LIpZAP13NqgS/JEvgtfAaQryduldPqKFdbWM8B8EVQzQEKGgaLUUlpXkOguFMWlLdi0zFPKgHf8PaGitgctnztyjCvPnWq/el8xuqVG20ZkJWCChc52MRKUtOV2NE9RHf0xgyoibzTb0XkYBydk7GDHTZNc1aMhJ2JyGk4fmnqivWO1KxYTL1Cxf5e9Xo7oEVFlmTdK7x9vXhh5f7Rd4A6DmUm80fVhOdJMjq/9ADfnhQbwzk+bfsY43QuohTDtSNjrYx9sdlxV+e2DF96H2XYzdq0t1C4wT8RgLwdOIxw0Oh/CZJR1+tRm6RxVbxPadmyM+O1TqHWmSkm2n6/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(366004)(396003)(39850400004)(41300700001)(53546011)(26005)(86362001)(6506007)(6512007)(52116002)(38100700002)(31696002)(6666004)(36756003)(2616005)(478600001)(83380400001)(31686004)(6916009)(54906003)(966005)(6486002)(66476007)(38350700002)(186003)(8936002)(7416002)(66946007)(316002)(8676002)(44832011)(30864003)(4326008)(5660300002)(66556008)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWFsTTI1eFZHL0VHNGlGQmd4cmx3dG9ZOWlyK0ZJenY5VElKMkROcWVzd2xj?=
 =?utf-8?B?ZW13TjZOUEhZQnAvYXpxUlpxK2hlTGRhWEcyVWtobkNiQUVvZUFNUGNFYlRi?=
 =?utf-8?B?QVJBeGxTdkowT2JMd1F5elZzcHNmd2NBUDg4RUEwYWhGWDRUdStiazU5U0Fx?=
 =?utf-8?B?NUVoRyt3RjBPNW85b1B3dXdadjhERUY2QmRtRmFoTDFtWWYzek5La2U4Zmxp?=
 =?utf-8?B?V01ITzMydlN1Umhxc0FFYkU5T1NGVlFiMnIwd0V6bTd3SUMzZGxMVCtralZr?=
 =?utf-8?B?eS9JbGNiZWlQMjF3bVprU1BMb3hZUnNWVzZCYW1ZaTllUXM2SVAxZHJpSEx3?=
 =?utf-8?B?ZzFON1lGK2oxM21DUWxMOXhOQTJ1YUZCbFpneGY1bm9jNUw3Wkt4Zk5reEE5?=
 =?utf-8?B?UmZHMkxaZXpwVllzQUVsTUhVdjR6YnBscFd4aERNREtMRzBSWkVlUnhuVFFk?=
 =?utf-8?B?MkVUSDlLS3M3SGhVODFPZjBHMnFNRVdvVk9aOXBvUGZkMjFKcmZ3RnZZQzJX?=
 =?utf-8?B?VUErc1hvU1FrTmhLcURMbFJ6cGFhamQ5THN0QnJzTng5YlVLTXpjaURZWUhY?=
 =?utf-8?B?cFdEZ25qV1JCeGNOY1JXL2FYRWVVc1pNeW40em9nSzArR1V2aXdybGJvb2sv?=
 =?utf-8?B?U3NxZ2NsbUt3REpvRytEL2w5S2xKZ1BacHVHZ1JRaU9hRzFzOUpSRlNGM0Yw?=
 =?utf-8?B?OHczbnI2VHV5NEVKTG1sbGoyU0hGK3pCTnhMWnVvMjNhUFhBbTVMOFRzUXl5?=
 =?utf-8?B?dUFTV0pKYnFCRGJNVzlpL2c1ZjB6NHdLYlpERElsQlJFY1kwYlFIdTlmalJT?=
 =?utf-8?B?QVFkb0hUZ2lHNklDTmN0bm9tdUhSWmt6Q3o0cTVub2NuVFcweC9haGFVSVNH?=
 =?utf-8?B?MnZFL3dEQ2xUUHdsa2FESGNSaUJzWmd5eTRFK1VZMTZDd2dNYXY5bHBad3Rx?=
 =?utf-8?B?dXdjTk9kSEtpbXBPQU1zUXJna0NMMjJrK0lZRjllTm1laE5PMFVvUmhwaWNp?=
 =?utf-8?B?RU1HblVhbDlFQWRWVUFIcWZHSmYzejhhU0MrQU1FQ0ZvV2dPZEVSQzRQdU5q?=
 =?utf-8?B?MVpLYmI2NGFhbVNEdEdHa0pFOU5qcENUNk9QZmFHNUUybU9uRHlGUDhOT0ND?=
 =?utf-8?B?S3ZDeHI0ekJxRTcvR2hXK2FlYU5wOVc5SSs1M0J1VEJzbXdXaXljU2NSUjY5?=
 =?utf-8?B?RjNtN25ZSTV5ZzlncXpSWGdZTlBLcDdUTUpSYkt0aFdrb1dYRmVYRlBOclJs?=
 =?utf-8?B?b1hJU0FpWlhEMUZZc2RMTHpPUHFuWVU4djdzYjh4VEk3WlZ1YW9wbVA1WlZJ?=
 =?utf-8?B?L2gvMExWam51OW80K3RkK0czM3diejM4WUhmV25zeHM2b293T0hQb3FzNVZO?=
 =?utf-8?B?WlBncHZoL0JSZ0FPNlVCV1h0L1l6dFc2NWprZFoydnR0MldWUzNOalFvMVlR?=
 =?utf-8?B?R2FmRFZXZHBuVVBHR001NHdwZ3kvcUFGM1JUVzN3RnllclpMMEt3OGd6dHdy?=
 =?utf-8?B?d3VQclZmQWx5QW5CZ3NjaWN0WldQSlB0VE9ZVTZrTVJjNGZzdkVKZlVyNWty?=
 =?utf-8?B?ZUdUUytVRHRCcVI2YXVESmliUEovVE1mQmo4Q0M4UGhvWFdKcWRyN0NaQUk5?=
 =?utf-8?B?TEl6ZExIdFBMdVlZZzA0ZkFsR1F0NzA2ZDVDQjNFUTZYb01ZM3BxTFM5TFY3?=
 =?utf-8?B?TUpWM0Q3aEtHM3VGWTdtMTNxc05HYW9FMitRL2dEbUY5cFRJMVVlRksvaENt?=
 =?utf-8?B?M25OTTlkekcwUTk5dDdOYTd1dlhER3VvSEJHN0Q4U1Z1OUNMalBiRDdQbHV2?=
 =?utf-8?B?VndXR3dCdTRRT3dldXJnN3ZFVWp0bWoyaG5TUW40VUNHbWFvbmNkNHhvU0Qv?=
 =?utf-8?B?WG42YUs5VU8zeG0xSkh2TFdlbXcvK3JPUXdDTlgzd3UvK3huUlJzdFprRGRw?=
 =?utf-8?B?VHZ0V3Q0QnhGcCttbHV4UlJDN1p6VjFhOFhRbndvN2hvcUVkMDJwOVdNVG5U?=
 =?utf-8?B?MXZjNllUSml4Y2pMaTFyR2haejVZNGJNMThncHZjdEpXaWFERjFCdlNGTE9I?=
 =?utf-8?B?VWJjR0l1Q0VWMHBBcUFSS3BrSmdaMmhMT1EwR2hyME9ITHp1RFlESjNIbEJS?=
 =?utf-8?B?T1MwZjhyZkZIeG5VbGpSUWxERXBhN0E5ZXFYZDVudkVHcHpDMWJpZEdiK2o2?=
 =?utf-8?B?NGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39093ff-f48c-479f-0bf2-08da6b32e0ca
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 16:05:49.2720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbKeSJWiHltM+WR+l5ZScBpZLM5OREpo+ThuZROCOqyyNIKkyhThMXZRJFKU81upHOiNhUQxcxdl+D8VdCOS4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 6:17 PM, Rob Herring wrote:
> On Fri, Jul 15, 2022 at 05:59:08PM -0400, Sean Anderson wrote:
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
>> support matrix is configured in the device tree. The format of each
>> PCCR (protocol configuration register) is modeled. Although the general
>> format is typically the same across different SoCs, the specific
>> supported protocols (and the values necessary to select them) are
>> particular to individual SerDes. A nested structure is used to reduce
>> duplication of data.
>> 
>> There are two PLLs, each of which can be used as the master clock for
>> each lane. Each PLL has its own reference. For the moment they are
>> required, because it simplifies the driver implementation. Absent
>> reference clocks can be modeled by a fixed-clock with a rate of 0.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> Changes in v3:
>> - Manually expand yaml references
>> - Add mode configuration to device tree
>> 
>> Changes in v2:
>> - Rename to fsl,lynx-10g.yaml
>> - Refer to the device in the documentation, rather than the binding
>> - Move compatible first
>> - Document phy cells in the description
>> - Allow a value of 1 for phy-cells. This allows for compatibility with
>>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>>   binding.
>> - Remove minItems
>> - Use list for clock-names
>> - Fix example binding having too many cells in regs
>> - Add #clock-cells. This will allow using assigned-clocks* to configure
>>   the PLLs.
>> - Document the structure of the compatible strings
>> 
>>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 311 ++++++++++++++++++
>>  1 file changed, 311 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> new file mode 100644
>> index 000000000000..a2c37225bb67
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>> @@ -0,0 +1,311 @@
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
>> +definitions:
> 
> $defs:

That didn't work until recently :)

I will change this for next revision.

>> +  fsl,cfg:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    minimum: 1
>> +    description: |
>> +      The configuration value to program into the field.
> 
> What field?

Ah, looks like this lost some context when I moved it. I will expand on this.

>> +
>> +  fsl,first-lane:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    minimum: 0
>> +    maximum: 7
>> +    description: |
>> +      The first lane in the group configured by fsl,cfg. This lane will have
>> +      the FIRST_LANE bit set in GCR0. The reset direction will also be set
>> +      based on whether this property is less than or greater than
>> +      fsl,last-lane.
>> +
>> +  fsl,last-lane:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    minimum: 0
>> +    maximum: 7
>> +    description: |
>> +      The last lane configured by fsl,cfg. If this property is absent,
>> +      then it will default to the value of fsl,first-lane.
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - enum:
>> +          - fsl,ls1046a-serdes
>> +          - fsl,ls1088a-serdes
>> +      - const: fsl,lynx-10g
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
> 
> Perhaps a single cell with a lane mask would be simpler.

Yes.

>> +      If no lanes in a SerDes can be grouped, then #phy-cells may be 1, and the
>> +      first cell will specify the only lane in the group.
> 
> It is generally easier to have a fixed number of cells.

This was remarked on last time. I allowed this for better compatibility with the lynx
28g serdes binding. Is that reasonable? I agree it would simplify the driver to just
have one cell type.

>> +
>> +  clocks:
>> +    maxItems: 2
>> +    description: |
>> +      Clock for each PLL reference clock input.
>> +
>> +  clock-names:
>> +    minItems: 2
>> +    maxItems: 2
>> +    items:
>> +      enum:
>> +        - ref0
>> +        - ref1
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +patternProperties:
>> +  '^pccr-':
>> +    type: object
>> +
>> +    description: |
>> +      One of the protocol configuration registers (PCCRs). These contains
>> +      several fields, each of which mux a particular protocol onto a particular
>> +      lane.
>> +
>> +    properties:
>> +      fsl,pccr:
>> +        $ref: /schemas/types.yaml#/definitions/uint32
>> +        description: |
>> +          The index of the PCCR. This is the same as the register name suffix.
>> +          For example, a node for PCCRB would use a value of '0xb' for an
>> +          offset of 0x22C (0x200 + 4 * 0xb).
>> +
>> +    patternProperties:
>> +      '^(q?sgmii|xfi|pcie|sata)-':
>> +        type: object
>> +
>> +        description: |
>> +          A configuration field within a PCCR. Each field configures one
>> +          protocol controller. The value of the field determines the lanes the
>> +          controller is connected to, if any.
>> +
>> +        properties:
>> +          fsl,index:
> 
> indexes are generally a red flag in binding. What is the index, how does 
> it correspond to the h/w and why do you need it. 

As described in the description below, the "index" is the protocol controller suffix,
corresponding to a particular field (or set of fields) in the protocol configuration
registers.

> If we do end up needing 
> it, 'reg' is generally how we address some component.

I originally used reg, but I got warnings about inheriting #size-cells and
#address-cells. These bindings are already quite verbose to write out (there
are around 10-20 configurations per SerDes to describe) and I would like to
minimize the amount of properties to what is necessary. Additionally, this
really describes a particular index of a field, and not a register (or an offset
within a register).

>> +            $ref: /schemas/types.yaml#/definitions/uint32
>> +            description: |
>> +              The index of the field. This corresponds to the suffix in the
> 
> What field?

The one from the description above.

>> +              documentation. For example, PEXa would be 0, PEXb 1, etc.
>> +              Generally, higher fields occupy lower bits.
>> +
>> +              If there are any subnodes present, they will be preferred over
>> +              fsl,cfg et. al.
>> +
>> +          fsl,cfg:
>> +            $ref: "#/definitions/fsl,cfg"
>> +
>> +          fsl,first-lane:
>> +            $ref: "#/definitions/fsl,first-lane"
>> +
>> +          fsl,last-lane:
>> +            $ref: "#/definitions/fsl,last-lane"
> 
> Why do you have lane assignments here and in the phy cells?

For three reasons. First, because we need to know what protocols are valid on what
lanes. The idea is to allow the MAC to configure the protocols at runtime. To do
this, someone has to figure out if the protocol is supported on that lane. The
best place to put this IMO is the serdes.

Second, some serdes have (mostly) unsupported protocols such as PCIe as well as
Ethernet protocols. To allow using Ethernet, we need to know which lanes are
configured (by the firmware/bootloader) for some other protocol. That way, we
can avoid touching them.

Third, as part of the probe sequence, we need to ensure that no protocol controllers
are currently selected. Otherwise, we will get strange problems later when we try
to connect multiple protocol controllers to the same lane.

>> +
>> +          fsl,proto:
>> +            $ref: /schemas/types.yaml#/definitions/string
>> +            enum:
>> +              - sgmii
>> +              - sgmii25
>> +              - qsgmii
>> +              - xfi
>> +              - pcie
>> +              - sata
> 
> We have standard phy modes already for at least most of these types. 
> Generally the mode is set in the phy cells.

Yes, but this is the "protocol" which may correspond to multiple phy modes.
For example, sgmii25 allows SGMII, 1000BASE-X, 1000BASE-KR, and 2500BASE-X
phy modes.

>> +            description: |
>> +              Indicates the basic group protocols supported by this field.
>> +              Individual protocols are selected by configuring the protocol
>> +              controller.
>> +
>> +              - sgmii: 1000BASE-X, SGMII, and 1000BASE-KX (depending on the
>> +                       SoC)
>> +              - sgmii25: 2500BASE-X, 1000BASE-X, SGMII, and 1000BASE-KX
>> +                         (depending on the SoC)
>> +              - qsgmii: QSGMII
>> +              - xfi: 10GBASE-R and 10GBASE-KR (depending on the SoC)
>> +              - pcie: PCIe
>> +              - sata: SATA
>> +
>> +        patternProperties:
>> +          '^cfg-':
>> +            type: object
>> +
>> +            description: |
>> +              A single field may have multiple values which, when programmed,
>> +              connect the protocol controller to different lanes. If this is the
>> +              case, multiple sub-nodes may be provided, each describing a
>> +              single muxing.
>> +
>> +            properties:
>> +              fsl,cfg:
>> +                $ref: "#/definitions/fsl,cfg"
>> +
>> +              fsl,first-lane:
>> +                $ref: "#/definitions/fsl,first-lane"
>> +
>> +              fsl,last-lane:
>> +                $ref: "#/definitions/fsl,last-lane"
>> +
>> +            required:
>> +              - fsl,cfg
>> +              - fsl,first-lane
>> +
>> +            dependencies:
>> +              fsl,last-lane:
>> +                - fsl,first-lane
>> +
>> +            additionalProperties: false
>> +
>> +        required:
>> +          - fsl,index
>> +          - fsl,proto
>> +
>> +        dependencies:
>> +          fsl,last-lane:
>> +            - fsl,first-lane
>> +          fsl,cfg:
>> +            - fsl,first-lane
>> +          fsl,first-lane:
>> +            - fsl,cfg
>> +
>> +        # I would like to require either a config subnode or the config
>> +        # properties (and not both), but from what I can tell that can't be
>> +        # expressed in json schema. In particular, it is not possible to
>> +        # require a pattern property.
> 
> Indeed, it is not. There's been some proposals.
> 
>> +
>> +        additionalProperties: false
>> +
>> +    required:
>> +      - fsl,pccr
>> +
>> +    additionalProperties: false
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
>> +      compatible = "fsl,ls1088a-serdes", "fsl,lynx-10g";
>> +      reg = <0x1ea0000 0x2000>;
>> +      clocks = <&clk_100mhz>, <&clk_156_mhz>;
>> +      clock-names = "ref0", "ref1";
>> +      assigned-clocks = <&serdes1 0>;
>> +      assigned-clock-rates = <5000000>;
>> +
>> +      pccr-8 {
>> +        fsl,pccr = <0x8>;
>> +
>> +        sgmii-0 {
>> +          fsl,index = <0>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <3>;
>> +          fsl,proto = "sgmii";
>> +        };
>> +
>> +        sgmii-1 {
>> +          fsl,index = <1>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <2>;
>> +          fsl,proto = "sgmii";
>> +        };
>> +
>> +        sgmii-2 {
>> +          fsl,index = <2>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <1>;
>> +          fsl,proto = "sgmii25";
>> +        };
>> +
>> +        sgmii-3 {
>> +          fsl,index = <3>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <0>;
>> +          fsl,proto = "sgmii25";
>> +        };
>> +      };
>> +
>> +      pccr-9 {
>> +        fsl,pccr = <0x9>;
>> +
>> +        qsgmii-0 {
>> +          fsl,index = <0>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <3>;
>> +          fsl,proto = "qsgmii";
>> +        };
>> +
>> +        qsgmii-1 {
>> +          fsl,index = <1>;
>> +          fsl,proto = "qsgmii";
>> +
>> +          cfg-1 {
>> +            fsl,cfg = <0x1>;
>> +            fsl,first-lane = <2>;
>> +          };
>> +
>> +          cfg-2 {
>> +            fsl,cfg = <0x2>;
>> +            fsl,first-lane = <0>;
>> +          };
>> +        };
>> +      };
>> +
>> +      pccr-b {
>> +        fsl,pccr = <0xb>;
>> +
>> +        xfi-0 {
>> +          fsl,index = <0>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <1>;
>> +          fsl,proto = "xfi";
>> +        };
>> +
>> +        xfi-1 {
>> +          fsl,index = <1>;
>> +          fsl,cfg = <0x1>;
>> +          fsl,first-lane = <0>;
>> +          fsl,proto = "xfi";
>> +        };
>> +      };
>> +    };
> 
> Other than lane assignments and modes, I don't really understand what 
> you are trying to do.

This is touched on a bit above, but the idea here is to allow for dynamic
reconfiguration of the serdes mode in order to support multiple ethernet
phy modes at runtime. To do this, we need to know about all the available
protocol controllers, and the lanes they support. In particular, the
available controllers and the lanes they map to (and the values to
program to select them) differ even between different serdes on the same
SoC.

> It all looks too complex and I don't see any other 
> phy bindings needing something this complex.

This was explicitly asked for last time. I also would not like to do this,
but you and Krzysztof Kozlowski were very opposed to having per-device
compatible strings. If you have a suggestion for a different approach, I
am all ears. I find it very frustrating that the primary feedback I get from
the device tree folks is "you can't do this" without a corresponding "do it
this way."

--Sean
