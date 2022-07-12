Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3972571EF8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiGLPX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiGLPXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:23:23 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150051.outbound.protection.outlook.com [40.107.15.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4BC25582;
        Tue, 12 Jul 2022 08:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHQHhD7FP+CkM2XkNVC+vWL5+/+lhIUjyADzhh02VaDQ4jM0wYYFCrmnPSI6sGToaH0Kt3foHPS2Sj6FyExnHctztordLt6DHjGqIJ8v2B5cCzJqQO93wjdjFzvalpb/oEN8HjZmevNPqbieI+KQ+f2HeZdM1FBS7nXC3A1hUfjf+b4ZxG4wdsEeMJhOaGsNd0gvk+PHPWeXB3bqDglm17kyG/CGRcUixlX6pPvyxwGYttZQwRI4K8S6lQg2XZHfFujyKkfwkz+EDujyMca9pYZko90Xkf2jLulKtQHVreN3kkMW3S5sTCYkemBQADTceazimRuInCZ0ai6pTm2eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLwpN3Lc4Tv7bMTYblU2RB+TviDyjrJD3wwGLvu/l0M=;
 b=MDOmWT5Am2H6JiWs69ctYBZljA0JLlTcFCZW0kHJROLXt5jdVMhE6zviJM0T83lz7OkRBlr8v1fUxUVFQ7ObFfp9xSyX0ezh6fAtzdNJy9jk+ssCRxGYQqBGeffXqqJ8kjHiC+PW8TdT1s/acEv+z5OBxxqttfS33Eu+lS6wlz6sHL9cffq4QvjR+8ul0cBrxAn35T1nsb5gWLhmiQaLO6nOq79U5vUiIS6GsZ8hiaPR57XPxmnHrvIQj1nVjd2czZExmIy2KTpGaOzr7P71UM9Ki5Cx4OOnV02o6lPb271aOywdQ8myjG57uPB0CDVRyFUSDtOxZosGAL57oMlReA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLwpN3Lc4Tv7bMTYblU2RB+TviDyjrJD3wwGLvu/l0M=;
 b=T7CdgzqSEVrWNq+ZfmCC59S5h3Mkk4AORdiZvgJc8ceKWyzJFZKvv4ZQri1VJiEjbyMOcln8h96fVHKR5zoLLPv/DO3OIiAZLQb+lbC3czlkPF0K2oIbE4BWpVIL91IMzfuQdxBAvPomMo+ErT2ocPuLJ02T3YzM8i5FpcYzMHVBaiofP80xRFlB/NEi7C8GcaPQS4AYa2ezyFcs6JMf7B+g3tOWh1COJ8CVSxZIpS+63myLFD7N14lLdG9h/tukpQEVyOVc/vLWOUKbTusxLvG1tg2Hy9X9xhKV4ChHKImLPTO9qOkbXBdSkLqezFmG0YlV497yNAt2E8UVtjnx+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR0302MB3416.eurprd03.prod.outlook.com (2603:10a6:209:20::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 15:23:07 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:23:07 +0000
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
 <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
 <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <fbcf26df-a29f-0517-02cc-3c8d009282ed@seco.com>
Date:   Tue, 12 Jul 2022 11:23:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0295.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::30) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22016c2f-01f9-4d66-6916-08da641a6c28
X-MS-TrafficTypeDiagnostic: AM6PR0302MB3416:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TN3eQhnGEgCcupVjaxUI3PJkAnPWjfc8wlVRgHiTZm68ZLOY3qqDCqIiHR6DtN0T+WYrYsRaRU7czoEwfKeJNAn4EOikIE1E2g5EoChn3dMltyNQ5d60hRM3iYDGIdOqsUlfGrFh/WK1TMKZHR+kWGaphcPfw8OFdoJL/haYbFCXje1Ma4wjzpfox9tjw6uTCJRB9mUWkx3NXlGIEiQlv375TubEPVeT+3pr6eT3KzWTva/MkmK9oBadPWHdZsHA8iyPZTSRJoTek3CwnmYfGoXTHSqFnNqdGJJs82Q3TXh0HOIPL7pbV0ZZjk2AZQv9UR9VFL0QfKdLyrMn91Hm6U3XkS72h+cTcFOHwE1Zzj5TsTuPxQwfryIk3f08LQHDT3YCgu1ccTDgx0aWuQybJVufaaS5aYIXS2acaVc5LDmuxzt9uwnLWKijtR6ihUq9B1pPKjkTpkDbnJHgldXMjdOxfDG4IBTFY9lDN7JGKPToF3BB2Fmke1uC2e1U9aZn8VcLLdXGkDh9HL/xLMWv1sYj5pkA9fyvnBs5QpmIGPluEp7lYezUQBfuY53ydFQI2TtwqDeVnm86iG2GRJn3QasYqxkQ7qMd2gNMgiUDO3HwklRNfh31wLOb5EtjFHWSMZwHuM5bju6S4p42KjDC0qni7JTLfzTcirJ5Bc9RAsj8yJ4RmCC6jBVrNwfrp2p8YD5i34I/esSWKTrcVI/2Ja8iAR80gndZPyiAsNW3bTXcpWtEo1tDMsO1qfpBK5XA2ABzcU5gfz6LBgKZTbE8kT3uzx02NTuXz8iwQ67inDjbH0MSSnuRfQdV63EgjPOcuLLnMUYkwthJ4vkP9meoCz9vxGmLciHyAx3tnHU8L671csurwTttQTV8gP4W3FRkVh9dJ6iVlv3DXCsEtP4kYCKL9i2ZCmlQnZgQAG7ReXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(376002)(396003)(346002)(136003)(366004)(966005)(83380400001)(6486002)(31696002)(66476007)(66946007)(8676002)(2616005)(66556008)(110136005)(54906003)(4326008)(316002)(86362001)(186003)(478600001)(52116002)(53546011)(38100700002)(38350700002)(6666004)(6512007)(26005)(7416002)(2906002)(41300700001)(8936002)(44832011)(5660300002)(31686004)(6506007)(36756003)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnJKdE1LRkZpaFV6WG1zMWI1ZmNmWWxjMnkrOWREV3ZvSWkrUkR4UWZESXRJ?=
 =?utf-8?B?N1ZMT2VnMVJIbldaQXR3QjlWaDBNQ29zbmtORUhiZVdkRkN2ZWhrM3NwWHlt?=
 =?utf-8?B?ZTZaMkw1QVIweUgvSmszcnZJeFh2OGRwczR1dmkrQU5HQ2g2aFptdnRBL05X?=
 =?utf-8?B?eUFaclByK0VDWng5SVlsNUNBOXZQcG5mYTN0UklFSG90Rm9TV3VGcjI4OUtu?=
 =?utf-8?B?aVlLQmRpc2x1Q1NWOWJ1eVF1MlZ6c0thS3lERWlBclUvdUlLUk5nRVFRUlg2?=
 =?utf-8?B?dTRrSW9EWFRDSFg2UFpoYi9pU0lKWTdKdUlxNDM1SEo3OVVqNkxmWG1RL2Zm?=
 =?utf-8?B?TDBTVVZjVllLS1dtamZPbCtIVmpoTTFpV20xaVJuQkp1Nnk0U3Q2bGp6L1Yz?=
 =?utf-8?B?Yk5DSXpoOVZ5QnQ3RENKWWEwOUNiaXNucS9nbjAzbmVLclVjdkFPYkRycGZJ?=
 =?utf-8?B?aHhQR1c3bkVCUmpDWlpWTG1JWFRKdHZaNGxzNXBRWVZSU0dBbHQ4MGNDQlVv?=
 =?utf-8?B?a3RqcllNbG5xbDlXWU9xMERYTlV0cGVqRTY1VnJoLzFwQjhSSmdsV1RCQWI5?=
 =?utf-8?B?amp1Mk4wdGlCRFkyejFPaEk2REUxR3JsQU42Y1E1dlJsZDY3UnI1aDFGZVVC?=
 =?utf-8?B?V1pKMi8wNUtqVzlNeVUwNW9pUUk4ZDJ3UXVoZXZRejNlTGl3cDV0WmVhSGc0?=
 =?utf-8?B?eEhZNWZCQmFZS0hralQyQjU4enJwNU5OTnU2b1JFZVMvSGh0UDFBSmVvcGNX?=
 =?utf-8?B?b2RhL0pUdUhrcC9VV21mejhBTjZkR0ZvT0dsdGlzNyttUm1IVmNnUDdmemJi?=
 =?utf-8?B?WkZGR09TQXAxWXd1WWtkVDQyQmN6dVhhN0t5RDdHcGJxQXZHQ0pWVGJxYXps?=
 =?utf-8?B?YTNJdWgwd1FYVDMwSWprbFB0ek1QK0tYaER6Z3BHNktqcEk0QlNUYk9VdktJ?=
 =?utf-8?B?cktrK21BRlRheEF0bnE1N0h0VjJCYTBoekJZYS9NamZtY2pLdFJNeUhlbE5k?=
 =?utf-8?B?eTRXR3QrRWNlM0M5T0JpZ0ZSeDU3anozVlM3aTA1RGV2b0NPS2lCNU9NTXd3?=
 =?utf-8?B?ODJkT3ArSnMrY1IxdDNaUDcyZXE1K0ZvcUk3eU5icjViKzBhVElzV2srOVli?=
 =?utf-8?B?c0ZJNENxTkNXdlFnNWZ0ZTVONDZlTUFaR3JTOS9EK0VBUjBBSUlUZEZEVzNJ?=
 =?utf-8?B?VkE2dnF1dlNnSmdaTDJ1U3ZjbzZwazFVdjJEenBuUUJ0YlM2aUFkYzVTbWlO?=
 =?utf-8?B?VUpBTktqczZpZ2djY2NxU1VNNytVS1cyaDJSc1daRmZKU1puc3RtcXVsZEx2?=
 =?utf-8?B?bEFvNVZPZ3lOVFZCMFlObkFtVmwrNzk5ckZVZmFad04zQnZpNTRQejE0WUNz?=
 =?utf-8?B?aElmb1FWYzZSRkoyYWNiUGtCbnA3Rm5aMVM1MERnNUU5TnBVR3REVU14alhn?=
 =?utf-8?B?Q1poaXppM0toNHpJa1JmS05hQkpuSW9jN3JDaFF0WDhGaTU4UVN0b2M2TCt0?=
 =?utf-8?B?MUdyczJtdmN6bEFvNmpNSCtCeWJISXorNmhxUkdBVmYreHFPdTNJRFBZa0d3?=
 =?utf-8?B?SVZ3ckNLeU5nUHhyeFJrdkRsdFNXeWFnTGxITVIvMnBSdHF0d0hsWUVZSXpr?=
 =?utf-8?B?c1AzV2ZCdWtQY3F6cTNvWUdjR0J0YkZLSFpmSkhLMnhjck5CWFJKL3N3NHlW?=
 =?utf-8?B?WlVVS1AxN0lENXRuZkltVi9sOWNjeHJoRVhHcnl5VTJaSWFLK0VTSW5neUJr?=
 =?utf-8?B?Y3BtVE1wVGZqV0d3UDM2ZnlEaVNoVGRERDlXSXRBa0dVSEJxSGNONlNUVlFx?=
 =?utf-8?B?S0daS010WGk1RmtuazhxKzloaGJFYlR6YnU3TE5CZjNkR2lrRncyOFQyeDNy?=
 =?utf-8?B?dkhReGFuRmxINWF4eW9vYmxOV0ZodVBsK2dDU29mamxSVVhGNEZqVTlUdS9D?=
 =?utf-8?B?K3gvclRYcGFhVUN6bThjZCtuMFdZb3grZnVaVU1vSmtYK0ZlOWYwakFSZGNj?=
 =?utf-8?B?M2FyRzk3L1E0YUIwZDhENkxjMFE5bjhVZnkya1dlR3pOZTdvTWRjSDgyRlM3?=
 =?utf-8?B?ZU9tdXo0MlJ0NjJqbnZEcGR2ZlhDUEFDTXdHZDZTM2pTTmt5Zlg0UXJtTFpO?=
 =?utf-8?B?SjluQ3ZXdmR0b1dMcm8vMzljbFhtUWxYUGtkN1duUlJHTnkvM0lLdExQV3Iw?=
 =?utf-8?B?cmc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22016c2f-01f9-4d66-6916-08da641a6c28
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 15:23:07.4111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CA3XMaX+9uQjrJGzKyvP6zvQuuPLDuXNLXshvjdJF7Q+izH2dFSRVje7+Zh09VSMyYakNt0VlZD/wTr6mwh2fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3416
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 11:18 AM, Krzysztof Kozlowski wrote:
> On 12/07/2022 17:06, Sean Anderson wrote:
>> Hi Krzysztof,
>> 
>> On 7/12/22 4:51 AM, Krzysztof Kozlowski wrote:
>>> On 11/07/2022 18:05, Sean Anderson wrote:
>>>> This allows multiple phandles to be specified for pcs-handle, such as
>>>> when multiple PCSs are present for a single MAC. To differentiate
>>>> between them, also add a pcs-names property.
>>>>
>>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>>> ---
>>>>
>>>>  .../devicetree/bindings/net/ethernet-controller.yaml       | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>>> index 4f15463611f8..c033e536f869 100644
>>>> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>>> @@ -107,11 +107,16 @@ properties:
>>>>      $ref: "#/properties/phy-connection-type"
>>>>  
>>>>    pcs-handle:
>>>> -    $ref: /schemas/types.yaml#/definitions/phandle
>>>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>>>>      description:
>>>>        Specifies a reference to a node representing a PCS PHY device on a MDIO
>>>>        bus to link with an external PHY (phy-handle) if exists.
>>>
>>> You need to update all existing bindings and add maxItems:1.
>>>
>>>>  
>>>> +  pcs-names:
>>>
>>> To be consistent with other properties this should be "pcs-handle-names"
>>> and the other "pcs-handles"... and then actually drop the "handle".
>> 
>> Sorry, I'm not sure what you're recommending in the second half here.
> 
> I would be happy to see consistent naming with other xxxs/xxx-names
> properties, therefore I recommend to:
> 1. deprecate pcs-handle because anyway the naming is encoding DT spec
> into the name ("handle"),

I agree with you here.

> 2. add new property 'pcs' or 'pcss' (the 's' at the end like clocks but
> maybe that's too much) with pcs-names.
> 
> However before implementing this, please wait for more feedback. Maybe
> Rob or net folks will have different opinions.

For some context:

https://lore.kernel.org/netdev/20211004191527.1610759-2-sean.anderson@seco.com/
https://lore.kernel.org/netdev/20220321152515.287119-3-andy.chiu@sifive.com/

--Sean
