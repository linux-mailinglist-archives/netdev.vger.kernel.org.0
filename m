Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4FF5EC973
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiI0Q1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiI0Q1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:27:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E8913E13;
        Tue, 27 Sep 2022 09:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5FaILuQ52EpSTQWNBivWWzDW9HvaocY+vmDjVHy5NBndQZap4X6/nAQQRh2yhrtBzW/08NK+IgKIFFC0H6CklgN57MhKSr/vYHwRa2e1SSi5ZAUk+SLDajzIdzM+iL6Qzt/Td2h1KpHex0FjtThf+pdgfX4eWXd5IEXxNWg6yGaLIEDLPjljYIP8gxodVA4sh5ennzuuv/YLjK7QNkap2mikm3I/rUVdH916TwJ4OAoAujM1GIY4nnAWjQhSqH7FHy64fXV7fa3Ry/F4vts1FqbcNQ/MTqh6YILvWLoKOjzgcjMMSpiGc5M2aAKRY+8Xg+SPFiBfKRk1GI9i8LLMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9rVU15Z13R7DX1z9QA8NzWZlivVGi7dRiMmZkFIXSU=;
 b=l1F47QO4thc5ZvRby7Vl5xlBzt8K3qn6aGdKzF8oGPp9HbH65zGjZgXCIpCRY4tzydtnStX3skrYxlax9M9eLAXNmSK3J5Gv9psyZ2zTHaP1BG3YyxNH/deE1iQr+vbchbMBA67L4SND+TwMYQYodQsAOBa+gB96R39yHyhQN1+QJkzKQlnaZMry35TR80xp1TORs5tQga+JtfrL/YXnBaHnWEq9G5x6kg0EF+hbKuTGiGSKJakoutRkKwsYA/lWw1SBFBRrElWEL10m2fU7ESBvM/4axaNMSDdzIsehgc/gLpo5MK8a00Ck9oNtHxal8ibj6pPV+anGPC/4yc7/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9rVU15Z13R7DX1z9QA8NzWZlivVGi7dRiMmZkFIXSU=;
 b=mf7hDJmrvBh6USz+331lrYEsub+vI+I0SlelMZwjKMJlv1KwQN9c90cbpbDp25Xl639FBiNRRtgcmg/h6mqKJEraC3s96AK2DbgPnr3EVP1tfi84QyOKcrpoDGR/6HwTr6/Y1Xu/UmSN+3LUZumz3ErL5gFAWvij25pzRQINH2b5vBlprNLbsKqGVhRc9p/w4nMP8UbR7SPLEKZei/RdXhaCQoUrhOhnN8cZxJUCsxr4luQXtZvqTVpt77fS/Se69BMLrX681C42x6EAgMQuEzh3IMj1+t9jmhIjcsZ3+QyazCFyzUWpet2XCGREJFstqZHY3whKh3TGi4jNEowIMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6890.eurprd03.prod.outlook.com (2603:10a6:10:20c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 16:27:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 16:27:40 +0000
Subject: Re: [PATCH net-next v5 1/9] dt-bindings: net: Expand pcs-handle to an
 array
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
References: <20220926190322.2889342-1-sean.anderson@seco.com>
 <20220926190322.2889342-2-sean.anderson@seco.com>
 <20220927153331.GA4057163-robh@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <44db6758-2f81-0374-809f-9db0cf2f2e33@seco.com>
Date:   Tue, 27 Sep 2022 12:27:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220927153331.GA4057163-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0016.prod.exchangelabs.com
 (2603:10b6:207:18::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DBBPR03MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dfcdfcf-0284-40ca-afaf-08daa0a5323e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a2UcesNH2bYWDpgeZclcCfg/tmys3eO89J6lThfh8hQd+YFSjg99aNZPvL48ZkzxrmNn2XV0mCOTSH2DB+Ezc6FMfEedD0ktKfX/HMA/PhZECM/6ICxIoJq9rH9JWzZIUBMDoFXd1ITviwWke8ZqjveoxiNApDXExEAe3KuNP5gLbe1vg6NXgnnSWWMlRAMAaRzpHpKFJ405XaT7wwVm9ksu5zjjbxA38ladmNczPdx946Rk1+Uk94dGhwpqqfX+Uq8uUDdqQTBjxsi/anM319W4LaCVbXojWjxDBBW1CNqqXn77k9BgrVISijYCjcsFzJpDkW136zloS/eu3lwRUGJOiXjsk/roC29/GvOrFXxlw0J5NYeOUhQ7U6SsGBmp1UrkRKGlJHuI0MO6/3aGenTcKdbFlj1JGWILamshEeaxjM2QkwgE0SD0iXbPaXRgxBzITPP16TUEYZwMX2InF9YKz91VFkdpQYFe0t4dzmVu7q1GS+2ak3Tr/g6f6grKPaSu7REi0Cm9s6YCc+K+Ut74FSsBNDkH1Lc6hIG0mnol1reWku+xtJnxF4nnG7Wvh0xOqulf7DVyxGz1QoeIgMa8ER8vXo2PXhuR7cOhP01UmO5TAJDUFdBK/1fFwtYnmhDabSzXpkxok4SRdiCGTM20xxvPvzsJwbICw4jTqTnslxxrmeOnd1dBayxneReEmcEhxfjKwCJawhAvoTQe8CWI7T9xSNZ/g801mDuBY5t6O80NVCEqKpUnJsuNP3C11yiOLtffeKOCM0R+Mb/BtJdSZiIBa5f7XJAffHXuLfN+3ONG81vltgmNSbGmGLAaxKgXhaAQEYnxua62kuoVfCPwAAq6oMXAM6tCPL7xm78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(39850400004)(346002)(451199015)(31686004)(86362001)(31696002)(66476007)(66556008)(44832011)(5660300002)(36756003)(4326008)(2906002)(41300700001)(8676002)(8936002)(316002)(6916009)(54906003)(66946007)(7416002)(6486002)(966005)(83380400001)(186003)(38100700002)(2616005)(6512007)(52116002)(38350700002)(26005)(6506007)(53546011)(478600001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aStVZkZsRmlyNzAzRG5CZzZ2eWd2ZitabVd4YjcvME9hVWhpVFNYWmxMUDFZ?=
 =?utf-8?B?SU9CU0xlK1Ivb1IrUnd2MGhyWksvVUhIa1JLaUdzYmkydUZIYVZmNjExcVpu?=
 =?utf-8?B?K0l1c1ZvV0ovSjZsQVFFMUUzZU1QOG4rVVlDMWlaTHRtdzNJR0VwdkZiQ2xq?=
 =?utf-8?B?MFgwUG1pZ2pVdTBZTGt4dzd2TGNMZmcxNHkwWnNhTko3V044cGhNRVlldWg2?=
 =?utf-8?B?M1RuMXFuWlBPUHNrandtTGVNVVZxL1JXUm1jMEdvdTAwWE93VVJuSGhEbzU3?=
 =?utf-8?B?NVUzMEJYSU9qSWVLQ0J0RDRlOXZzNEJCWE1ZUlkzaGRNOTBXRFAzaXFCakND?=
 =?utf-8?B?Wmp1R1lmQnRveDlFUEl1QzBmaEpHU3ZLaURDTU1YRFNJaEJMMk15aFRvYTFW?=
 =?utf-8?B?YWxpOUlrN3YrZStxZHRpQkFDKzRIZ3VCdkxzaEFjUURxOE1iekVLeTl5OEtG?=
 =?utf-8?B?b3FWeHBTSG1iaDIwc1F3djNTSDVoQUx4eXd6TGcwWVU1ZC8yQ3o3WnVXc2V0?=
 =?utf-8?B?bHFjaUd4RHd5RGlGMEJhU21ycVp1NVZ3WGdmRXVjS0pWWGtKU09TMjQyS1Yw?=
 =?utf-8?B?VVI5SUM0MDFVVmdTNkdTU256bW1mcDhNUG1tenZrZEdQRy83a2gxTXRKc1hn?=
 =?utf-8?B?Z3J0eFlsblFWamdtTDZEbVlJcXRQUkNFYVNzVXkxazFGaUtCa2ljVXowK1Rw?=
 =?utf-8?B?YmV2ZVZrVTR3dU1FS1F4ZmVjeVJ0c1k5M3FIYU83cG5HTHJFR2QxSEM3VDFO?=
 =?utf-8?B?WVpIK0JYaWo1WFZIWUhhNVVHYmZWQzRKK2lZSW90bnZLd1E2dG5sVThVL1ky?=
 =?utf-8?B?NE1jKzB1WTUvWDNXQjdEYjdBa1M4Q1N1SFFnMzRXK2ZxTDhtM3QxeE44UVB3?=
 =?utf-8?B?KzBnZTBucWVzcmxtekJjYm03U0pnU3IwQlQ3MFFtQjAyRTNITWNrazFiYVBL?=
 =?utf-8?B?Mnp0endaeEJCb2k5Vk5BajlwTkE1UVNqcDI1OWlTU3NuVFhpS1JCNHBmM0hO?=
 =?utf-8?B?S1NKNko1dkVtWFFqYyt0UW5MaGNpdTByWURrRm9WK3lKM2NqSDQySFFRaTVL?=
 =?utf-8?B?dG9ucFV6RmR6V2I3bnlDSHFxZmE2b2ZLcEEvUm01THp6Qlg1ZExvODdnTTBE?=
 =?utf-8?B?ajgxSVFGK3pwajljMDZ1VStjNEt0ZGV2czhzQjZtZ2I1dk5neGhxNlowQmpv?=
 =?utf-8?B?Y0o2SjNMQnhLakZ5a3RLQVl6ZHBoV0ZNRkoybDg4SVMwR21QR0NzVFpPWXM1?=
 =?utf-8?B?aHorRHR6MTRWRXlpQTJEaVVPSVBjNGZJRGhtN1JTQkhiYmZ2cUdEQ1JZWjAr?=
 =?utf-8?B?NnRMcVFpUXJ5THFOKzR4Vy90cUk1eWtXQkpIcGx5MDk4YTBjNzdjVDhKakhR?=
 =?utf-8?B?aGV0MGtvVUlZMm16N2RuSm9lRGIzNGNkVGZZV05IeWxLL3FMaW9jZzRGbWtl?=
 =?utf-8?B?V2pUWlZraGIzRXhIM3grRWdWeW8wYVUrQmE4bnAvVzQ1elpIcWV5MEhOaW1M?=
 =?utf-8?B?UXVQeXBtSzRNMC9ZZjVkVytGYWg1dmRaYmpuWFB0bHRidmw0REswSmJrTFdC?=
 =?utf-8?B?L2V3YlNLNWhjUFh6V0paTllIQlRYbWhIUCtxcGR3M1FDTWhtSkp2RzFwc1E5?=
 =?utf-8?B?bEs0ZW9GUnN3bEwrODNQR3Z6L1Y4Qld2RHd3V2xKblEvTG9KZWZMc1d3dis1?=
 =?utf-8?B?OE4vQlNnN3NtWkRsQ1BNUm5mS3M1STUwQ1B6ZzBWaWlHckZzRVQzZWlWV1gy?=
 =?utf-8?B?dnZjSmV6ajJXNHBNUmljT0FNYlYreDhKV2ZEOUtoUFJwNE5yQ1VxWkxDYVRi?=
 =?utf-8?B?ZmNRYzRzcjBRU05wbVFiMTBoV3N3TUV2QUZYYkovdVVQVUNlT2RpMVMrTUJt?=
 =?utf-8?B?QStUSjZhLzA4OUZ5emtmNVlxOHpLdVBmVlRmTWJ0NldpdWxpNnpOZ2RhUFda?=
 =?utf-8?B?MU10U203UHI0ekF0L2p2cGVkU3pKNEhaWHM0WGUvVHFENVdFQ283UnU0NFZD?=
 =?utf-8?B?T1g1Q1k2MTFjaXh1bFJERkRrLzJJalAwNFp5WVNKREtmTEc5VkJIbkNtdnNn?=
 =?utf-8?B?WEpBS25rQThTZjdsaXNuQnc2L0pDWHhxOVlRK1NTTlUzaDB4cmhyK3pSK3l4?=
 =?utf-8?B?QUVRb3RFdFlsczBHcE5OV09lQ3BwdmxVQUdGMnhqNkl3Y0tqTFNXajNCUnZP?=
 =?utf-8?B?Znc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dfcdfcf-0284-40ca-afaf-08daa0a5323e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 16:27:40.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NST3vpq+ps/r8O2nvfn8yYbX8fMrzORyM2vGjAnRttogrzXn4CD181X9AssqvvjmN/ZGkpIXpKfGANGJ+tKs3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6890
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/22 11:33 AM, Rob Herring wrote:
> On Mon, Sep 26, 2022 at 03:03:13PM -0400, Sean Anderson wrote:
>> This allows multiple phandles to be specified for pcs-handle, such as
>> when multiple PCSs are present for a single MAC. To differentiate
>> between them, also add a pcs-handle-names property.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> This was previously submitted as [1]. I expect to update this series
>> more, so I have moved it here. Changes from that version include:
>> - Add maxItems to existing bindings
>> - Add a dependency from pcs-names to pcs-handle.
>> 
>> [1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/
>> 
>> (no changes since v4)
>> 
>> Changes in v4:
>> - Use pcs-handle-names instead of pcs-names, as discussed
>> 
>> Changes in v3:
>> - New
>> 
>>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml           |  1 +
>>  .../devicetree/bindings/net/ethernet-controller.yaml   | 10 +++++++++-
>>  .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml    |  2 +-
>>  3 files changed, 11 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
>> index 7ca9c19a157c..a53552ee1d0e 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
>> @@ -74,6 +74,7 @@ properties:
>>  
>>          properties:
>>            pcs-handle:
>> +            maxItems: 1
> 
> Forgot to remove the $ref here.
> 
>>              description:
>>                phandle pointing to a PCS sub-node compatible with
>>                renesas,rzn1-miic.yaml#
>> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> index 4b3c590fcebf..5bb2ec2963cf 100644
>> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> @@ -108,11 +108,16 @@ properties:
>>      $ref: "#/properties/phy-connection-type"
>>  
>>    pcs-handle:
>> -    $ref: /schemas/types.yaml#/definitions/phandle
>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> 
> 'phandle-array' is really a matrix, so this needs a bit more:
> 
> items:
>   maxItems: 1
> 
> Which basically says this is phandles with no arg cells.
> 
>>      description:
>>        Specifies a reference to a node representing a PCS PHY device on a MDIO
>>        bus to link with an external PHY (phy-handle) if exists.
>>  
>> +  pcs-handle-names:
>> +    $ref: /schemas/types.yaml#/definitions/string-array
> 
> No need for a type as *-names already has a type.
> 
>> +    description:
>> +      The name of each PCS in pcs-handle.
>> +
>>    phy-handle:
>>      $ref: /schemas/types.yaml#/definitions/phandle
>>      description:
>> @@ -216,6 +221,9 @@ properties:
>>          required:
>>            - speed
>>  
>> +dependencies:
>> +  pcs-handle-names: [pcs-handle]
>> +
>>  allOf:
>>    - if:
>>        properties:
>> diff --git a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
>> index 7f620a71a972..600240281e8c 100644
>> --- a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
>> @@ -31,7 +31,7 @@ properties:
>>    phy-mode: true
>>  
>>    pcs-handle:
>> -    $ref: /schemas/types.yaml#/definitions/phandle
>> +    maxItems: 1
>>      description:
>>        A reference to a node representing a PCS PHY device found on
>>        the internal MDIO bus.
>> -- 
>> 2.35.1.1320.gc452695387.dirty
>> 
>> 
> 

OK, I've added these changes for v6.

--Sean
