Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1665816B2
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiGZPpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiGZPpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:45:09 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30087.outbound.protection.outlook.com [40.107.3.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFD230B;
        Tue, 26 Jul 2022 08:45:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVmYnEGOzKF5VfBIe3LHS+/Gf7ROmvtaJeKzy6K94fg8gAWMcGKUF04pv8qrW2uhIaUB/e0wtEZnoT4zuBmGz+IXDXTcl0+LGwjyK07s1NczCCdYfCWgoZ2sJ5uKjhWNmgi6fYxzpstCkncFyWI8F2irLY/3jB92v/cwWcDmZ5IrQvJYcj6uCeVqjol4beD1je54+5D8HfLfcf4nkA+BUKMLs9dgXQmTP6tSO+qG7jroh/JPglK5FNoaY8ER6LbbD/FMN+O+zUezyfyJkir9wUPH99CQPuR7n8EmIFp8Pg8cyCBkpPqD6W/roqwEo7tBDdZeXL6cbifD2QmLDathlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHYz329QnB9AxKxogXZpp0eZbvTsCKlgfWndwRcV/Gw=;
 b=KQY6M1Rfg2bbykTCaUM5ZPPZrL2a1Lp44Gk2kchcQAxXpEMM6s4J1g3IlF1TRu3SDFfINcXzwmliv9k4jTL4Sn72XiC4hLtr9IP3hsbL/+MHo7ptxFVbHMR2b1DfZn4Zwc4byf3yWDV7RzQufK8YixAebeMlIpPcUuwj1SAlMN4P8fKunF+gDKSbMsy2WmqIPgjBy4o8yJgbD6WdnpI4RtZWJtg+1Tbfqeax4movhCOjZyfHXbtPJvD2+yxMFigu/i6tnYhqwxmiA5RdAGM9wBCF2Q0WqGWwpoD+obXzOpOPRcgt/ROM+Hjiq1kBs0BxHzaCbBDmfRx1sjRSp2Fa9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHYz329QnB9AxKxogXZpp0eZbvTsCKlgfWndwRcV/Gw=;
 b=eOyg+nmroiwf0JL1sMADS56/5+kJP5CeFHeYCfxeflBo99JJGREDtmZF0zhN1xWGEraPNrowcPQEB5cqaHlYDK6WvD7M/sy+JBZ2hGX59kKsiDTuRwrfUDrU0jSYLtGPe3sDPK+OJQo07R+GN12bb21GOFM8+3JKJYejXn3elQ2tqSOqQL4NCl9duKh0+R76l0QLNvilvrSztL2pbiY77FauwhvzG8CWIu8DZxv6euHPzRXWmBPrKyPcZ4XCFdgYwO9O+wr0VnAqBTEShpKGP/yq61/AA8Y76NjbkWQWAyaXNQXJbxj7EfJukpUNmPA5I1apIuREu8Fho6xhypSqLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6987.eurprd03.prod.outlook.com (2603:10a6:10:202::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Tue, 26 Jul
 2022 15:45:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Tue, 26 Jul 2022
 15:45:04 +0000
Subject: Re: [PATCH net-next v3 01/47] dt-bindings: phy: Add Lynx 10G phy
 binding
From:   Sean Anderson <sean.anderson@seco.com>
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
 <6240dce3-3b68-2df4-768e-ca82bcea518f@seco.com>
Message-ID: <3a255b33-ae5b-0e2e-d1d0-0ac9548c5837@seco.com>
Date:   Tue, 26 Jul 2022 11:44:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <6240dce3-3b68-2df4-768e-ca82bcea518f@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:208:234::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee50f105-c484-4c91-b997-08da6f1dced1
X-MS-TrafficTypeDiagnostic: DBBPR03MB6987:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8GgW1fYI0qjOkgIF/cE5NYCWx9ocb2XXy/EzPHFnQX11kNj0lWSuDQ1S5fiWcMCyKKuY7m8g2xSS/PHqBO9mfW3mARd15aq0FX2irnn3aag7QscFIoDmFBJj/OEDI0QpiDwx0Ig++7jEXZuLGmj7eGTRaU/ytsO0ifLl1LHhC0PfXzefo7reLfiHDKCCEq1TEoxYb9GcSnZou7tk2e9JStukvU8KTryORMB1FXzS8cFal19hLnYvK2Y9/VkJqvVO9fu/UVvgX2/xG8t6rnzELPuOeQ1r2oBh6vtxaxIWfRRb+3vHjiaE8Cdl1evbQHAtri45BgI9jXph1p6V9UBtH3XrD3dwxUz/K3YWqdDaII8LJAbj8bTHTv1Sr8uMOFpkH73qvKioLv8ksWhlabi7N1ZlD/m1m9PyD91dH6p2IJrUiewV11lYUBYtkTUltGvU9r/er2x72JQZuo/vTa8CfQ1wQ3NEYOZha77x3sdF5Xnve9P4waFM0lBc1Q2ro7gfPcnqbyMt0SGXHJ7B/nhsvx36iKd9qv/Kl1REN/cj3EriuRTCxrmG6Ya3S1Fuah0v53ESUidh6MRZC0pWtBuvp+TxFO6leKJeYDwx9Bl9cmK0ckza0WAFGdoCUe6kPdDd0TNyIcbtLMksaOOAglgYc1V2PK+fUT1FGXjQuFJRd5a5VwZDWmNK13z4eT9THR0eNGBJN5b2FaIAUPzFg+cW6NFBS69VMN52Gjg9yLcivW+9JVVxTd8Is2yhEMGHX79SXdqcy/2i9ka3+37pdpRUbsT80Xa/KqYykZaflcUamUAFhBeCmsYhLNsoCOTrqE/Nq01Q0FMOTUByZ2zFM0pwWQtsMuSA4TUidG5BTSbgmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(376002)(396003)(346002)(366004)(136003)(36756003)(54906003)(38100700002)(38350700002)(4326008)(316002)(31686004)(8676002)(6916009)(2906002)(66556008)(66476007)(66946007)(478600001)(6486002)(5660300002)(86362001)(6512007)(2616005)(7416002)(4744005)(6666004)(52116002)(53546011)(44832011)(31696002)(8936002)(26005)(6506007)(41300700001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHpkblM3QnpiWVV1QXQzU3ozUXNxMU1ER2U4ZDdsR09xazlGRjI3S1krTXFw?=
 =?utf-8?B?TENFM0JINDBJY1ZUeHhINDkwZjJGVEFjMVpJSCtsUTRXdm84dkxFZE1xd1hD?=
 =?utf-8?B?SS8zQ3lyUnFKVHVaTzBOOW1JOXhUb2hLY2ZJNFNNZlhPamxZb1B5UXA3dTJJ?=
 =?utf-8?B?M3htOUMzSXdENjNERnFXalo5c1lSM3BqaEtXZXRnVWF0U3A5b3VyTWNJdVNG?=
 =?utf-8?B?MW1DSEd1U3M0Z29PNnRDZG12UUs1RUFOSTQwckZuMVhoUE5IY1dYZm00OW5h?=
 =?utf-8?B?d1pzZ3BLTHJNRHlKSEJod3RQOERRU3kxUFNnZ3J3REM5TmFJQldoK3dxUkJt?=
 =?utf-8?B?OWRQY0FQL0lFa3VlLzcxckRMT2psZUhISWZOMS9McTMxQmRkaFJiSmhYQk1E?=
 =?utf-8?B?OWQvamVEbm8zSURnWGpOazhwTDU0OGw5NXZ5SU1TRkpORmlDY2tUL3hFemRh?=
 =?utf-8?B?MHBVaSt4RHpaQ0VHOWdNcHJ6RnVOOGp1djE5ckltNzFpRGpoVnNiQXNZNGdv?=
 =?utf-8?B?SlNKNlB5dkNhczllamRUWHBFTnhkY2pwWXlpeVEvVU9JR1MrTXhvcE9ETXpj?=
 =?utf-8?B?SWtFT1R6NHhPc3FtdGx6aE5pMjJOVno4bnIxNlNMUVpjRndHMzk2YzFqTDY5?=
 =?utf-8?B?SmhObE9KbVJ1SHhUdktIS2xEckpBUFI1bkNkcU9WT3NEQzJCSkRWQTZVZmJu?=
 =?utf-8?B?MWkvZUN3ejJJalg2VEI2SnJQNTBVTG84K3NxSFRCZkw0K2xSb3JrbDN0aVZh?=
 =?utf-8?B?SFJQSEZnN09KUDV3MjJmWWRlTHdORFZQaHVKK2c2c2pTZ0NJSjBBNFM2L2xz?=
 =?utf-8?B?MFk3K3h0S2IzYzBPMm5tbmhrUGFqeDIyZFQzVTdCb3BkOEgycmd5VzBtYnZH?=
 =?utf-8?B?UGZ0elVsSE4zdG4zZGZZOTU4bnIzNmMzT0M4TVVsdjgyU2dlbjR3YWhUbTZh?=
 =?utf-8?B?NVlnZ2dGZlc2c05Vd1cwdE80ZWdVaWZkWGVLTmt2YzZ0Kzd5dW4rMW14S1FW?=
 =?utf-8?B?d2UzZUJmNkpTMnZaSzZPSXh2V1IrR0xySU5rS2RxTmRMbDZrWnNtZ3BDRGhz?=
 =?utf-8?B?aTA5bXZleEd2WVdBellqajFoWEVjM0Z0eGhUZEpiTjNDQjU5eXh1VzV5eWly?=
 =?utf-8?B?NURKdDE1WVJZamVCTEtYSmpyS0xWZG1oRjFPajV3dlMvOFJHZWJHNE96OFdw?=
 =?utf-8?B?bGM1Skt0ZEhzc1c0T3YzanBFYWJleFlFWkc4VjQ5V2NNaDd1RnhIUEtjYlcv?=
 =?utf-8?B?TFlMRWVmc3FuNFVGRi8xenJCYTJoODBNWDRtZklubWlXbm83eFozak80ZkxL?=
 =?utf-8?B?cmE4N1lWTFF2Q0pVVUU3a3RocVFkb0tHeWp0Q21oai9tSmNQS2tEZ01Tbloy?=
 =?utf-8?B?Tjg1TzNCLzZIaVhnUzJ1M2RsYlRtclRYckdoaFJ4NG91SGVSU3l1emdmMzFG?=
 =?utf-8?B?QkJJTG5CQkpOTkcvQks3QlNhUXBqS2xLbEcwbVFTdmVkSnoydWxhMTQ5NkhO?=
 =?utf-8?B?bUNUNjdDQ0ZObU5qYStEVU5aNEd5K05JbGU2ZEkyREFwcmZEZnNqZHQwenRh?=
 =?utf-8?B?cHp5dFFjOWJZL1Y1TW14U1B1akY2V0JkMElEbzNtUERDSVZzbE85NVRqNkZY?=
 =?utf-8?B?YUVUb2c4Z2pWT3I3L0N0blN0bjE4S1IyY2I5cElURlVPRjJmUjJuRkJWR1NI?=
 =?utf-8?B?U0UxbjVUZDhYZE1SaE01R3I3V2JQREdhWU5reGpwUVlPcmtBSVdxOXkwazZ6?=
 =?utf-8?B?aWI2KzZzWi9sR2xZS3NWQW9EelNvdU5GR3lRcmtGeWZaWER5dnVmeXFYdUxl?=
 =?utf-8?B?TXI3cHgrdk51RVFvNndvQzRhMzJSUnVpdVBoYTJJaE5sWlFrdXpxbFJYejA4?=
 =?utf-8?B?cHFQNlBxdXkvdTFINithWG5FaFFkNFpESHlkcCtDT0N0UjZIbEttSjZ3K1FJ?=
 =?utf-8?B?STVBdXY0M1AxbTY1V1pmYU5Gd05PVnIwYTdtUDJPTWMvMXVHbExjYklLaFBi?=
 =?utf-8?B?bm1ZN1Rid0kvUTM4ZGhyakV1Rm81YnFWd0grMGRUbHQ0dlNhQ1IzWGdDUzFN?=
 =?utf-8?B?MXhUYjZBazNhZnNsSG0xbEpRUGhCUk51d3Z5UGcvNkdTRjVzb1RLa1A1d3ZV?=
 =?utf-8?B?OXQ5eGpCQmpmcWwzTXdqbmcyMXA5eGNobFZNc1oxWmhqN2RsY0FBRGtiK0pI?=
 =?utf-8?B?ZGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee50f105-c484-4c91-b997-08da6f1dced1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 15:45:04.2025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HcihQmZE2kJUUvroKF+9jxjHhzIIUF66gwi2Xxsdtf10JNArMBYPinl4tNa2eYsVoo53Y0u9tLFkHasww+62nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6987
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 7/21/22 7:35 PM, Sean Anderson wrote:
> What about
> 
> 	phys = <&serdes1_lane1>;
> 
> and then under the serdes node do something like
> 
> 	serdes1: phy@foo {
> 		...
> 
> 		serdes1_lane1 {
> 			first-lane = <1>;
> 
> 			sgmii {
> 				fsl,pccr = <0x8>;
> 				fsl,idx = <2>;
> 				fsl,cfg = <1>;
> 				fsl,proto = "sgmii";
> 				// or PHY_TYPE_SGMII
> 			};
> 
> 			qsgmii {
> 				...
> 			};
> 
> 			xfi {
> 				...
> 			};
> 		};
> 	};
> 
> and this way you could have something like a fsl,reserved property to
> deal with not-yet-supported lanes. And this could be added piecemeal by
> board configs.

Does this sound good? I would like to start working on v4 of this series,
and reworking the binding will be a big part of that. Am I heading in the
right direction? This seems to be a more common approach (e.g. mediatek,tphy).

--Sean
