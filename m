Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7B581774
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbiGZQak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGZQai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:30:38 -0400
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC835588;
        Tue, 26 Jul 2022 09:30:36 -0700 (PDT)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QFxbZe030264;
        Tue, 26 Jul 2022 18:30:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=AzwTGYD5EzDrLqBysXdTWjCI5adOe6Jkaz/Uro3+RrY=;
 b=6dRCuncLhqgh0NTEl3OOMT6RdOaMDTawIX/JqrpZxbgen4LRQPRWD219+c2qHGa5wYVZ
 wB7E8myvnJrNsXPvYhHpvp/wPKFL1vnVdZXmIn/PoVkYjs5fXBLuEOk7uTMn7QVFbl4v
 v1JPbC8QaqFr8TqC/UYTZS7FMjgybrnWOC/oiskhm7r/EynWCx1N34X4JvuWE7VRjsuV
 IrpJr1XVonNy9lboHSdQ4LCnEM6i/B5QYJXLaV8lRB1+NBDiQhNy2M2w10R5ypetWU/K
 jUJJuQPKx1SZWBuv1YNyNHUr8XB4aCXbDrihPmiGJ3Tg5bVMfD8TLIFPktYac9vt6+Mq 8A== 
Received: from mail.beijerelectronics.com ([195.67.87.132])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3hg504b3vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 18:30:07 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX02GLOBAL.beijerelectronics.com (10.101.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 26 Jul 2022 18:30:06 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (104.47.18.113)
 by EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Tue, 26 Jul 2022 18:30:06 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2KG7mmOUKF2spQnKndiwljA+/s91FVcSWBnt6nMOGoojYdzTvBSe2K0Uqz+yhn9xA4saB08GYTHgOwlBQ8pxN2xuUDqrfjVETzqv1uTFQjaPMnOYVwge4k4rdbJecFclFkaKFbzP5o6CmPH+oaRIUApY2Le5qHS0p55AY7/WNzL8lvTdsckApsqUPdRFcnlB7QrG8I4tzj6oGScVxniCQwJD/K5etXGfYR+XTvVC0HisosdFwkrppejv6ra0T6E0r6eU4uUhRAedFZLE/xLtBDslJ6oF3PzxXp1dqCCPLp6TOioSOCtQayi/+C9zlIN9eq0LNqJ9yEGSm8C9vgLng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzwTGYD5EzDrLqBysXdTWjCI5adOe6Jkaz/Uro3+RrY=;
 b=HLr9ADRBcyHuhyPXToVpFu/F8DRDspzAJn5K8qzAh8+ryWWjBYIN95KZOkgZB6ytJDUPDRH/hZoAXUjCU8XID14GuvQjYLZZJtBJ1BuUwz8aEd5j6uzhw2EJe56a1B3kTU9nBy6PQf796Immg9onCOsYuuCr+zOf8pIJ1PR9N7F2y/o9fCZWzUldmjX091IRKrztAJDjPD/DcoWToPDv03LxmCq98VY4iHLa1cLtHKZxuo7bIqJG9dfPPSgg8aF8p08In/VpXo5LrHE1PsPN4dIPPh37WOIbeeR+FVX+r4Br2yBzqu2MS0SbBhN8MNlXqZ3wUF8Vj46/EXiD5RLUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzwTGYD5EzDrLqBysXdTWjCI5adOe6Jkaz/Uro3+RrY=;
 b=zI4MHH1mzPBicJPX3rhC/COO5MKcl1QP+q24aofdsYTfUpFf6O239NJ93nADQwaC/H5+GT3KUMTiLCD1nU0gfrlEfad0nGIqy5IjlPElPuh45ifiVMbh38uvYvOZdmZSPDobl+Ir3sgAKdmEywKUc4tgmmp5Joijv3GBTBSUNMQ=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DU0P192MB1973.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:40f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23; Tue, 26 Jul
 2022 16:30:00 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::582f:a473:b276:fa7f]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::582f:a473:b276:fa7f%5]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 16:30:00 +0000
Message-ID: <712bcd84-4dbe-67a6-afa9-ddc01ea27cc8@westermo.com>
Date:   Tue, 26 Jul 2022 18:29:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nicolas.dichtel@6wind.com>, <eyal.birger@gmail.com>,
        <linux-kernel@vger.kernel.org>
References: <20220724003741.57816-1-matthias.may@westermo.com>
 <20220724003741.57816-3-matthias.may@westermo.com>
 <20220725170519.GD18808@pc-4.home>
From:   Matthias May <matthias.may@westermo.com>
Subject: Re: [PATCH 2/2 net-next] geneve: fix TOS inheriting for ipv6
In-Reply-To: <20220725170519.GD18808@pc-4.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BwkOzX69jPoeCCQltutzELfm"
X-ClientProxiedBy: GV3P280CA0104.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::24) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a07ef534-2e0c-4d05-f31e-08da6f2415b0
X-MS-TrafficTypeDiagnostic: DU0P192MB1973:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAKOvxQo10EjjensX+9woVIBYj1MNB93UU2gFlDqxLg+koJTofNsBhwdacAsG9RvnEBAY12k7laJYyCkfF+RdnjFrsyTXSv1TdhQfjL5IyVBSMsVado3YpcLONYvNoE7i3ZVfkHWCFN+a7zqrWK1OcGK1HiMqokCUsK8WFB8gO1oKKOtif7w0ay07YVFADA1A651ZWSoPfzaA06sNV59SyNeljyCRyOIIOdJC9Dn7kDMxtB/0yHMIZSYfvZKBGIdhaKKNaNlAbXbFcb57SHjuvTjm8eUj//OmGxpk9xLb9T3H0FdX7avTcs49Qs7l3INN/94r1gJOPwoN5jFEgxU+WKl6XURIQZ579Q08C/5kR2TMF6WfGermjwXF4mnjvy3eSUh60w1X9H1MgxuIsm1nmTT0AjxTVKtxaYIIXEAsIp48gLZOl0eF/Ex2ocTFAshmaXQgoy1KhDQoOxyj4eUX2/O5Vh2FocqtssTiokclxWu3+3Djk/j8G+eIXbEtwyKevAv4JFVBpWeyMS42taJtpJgpSIDwd9UN+p3AeNtpQG5ZYPRVaMnxC54ZkA5HxJtMh78Afz9rwOnb6s9wZxMYZXZeytiSbvQ/DPBrEmftK/uL/hwiIjH2GliEkAfQ9CSVldoPGpO5R3gpUjoJTgfNHR4+RrmQub7TRQ9hJ2zQN6XGXtrJuSWDGEtLUA4Ot8PWrAPkbz7wwnqvn6WmYL0Z5klhdkrElV1cjv+cuqPUdCn1pykrdXVqozpZvagcAk1Nm6xunsKtos6/DXb7AIGwRyTVZpo6V8ecMBx8nt8s8fxskpN0F3EmcZdR/WKATOM6tB1nSpoha6uTtCPjAcprjJjBw4kYGxbChiiGFm8hKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(366004)(39850400004)(346002)(44832011)(7416002)(8936002)(38100700002)(6486002)(235185007)(86362001)(31696002)(5660300002)(6506007)(2616005)(478600001)(33964004)(186003)(36756003)(31686004)(38350700002)(52116002)(316002)(53546011)(2906002)(83380400001)(41300700001)(4326008)(8676002)(6916009)(66476007)(66946007)(66556008)(21480400003)(6666004)(26005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFlSYTVDOXlSSGdqWGI0aDE1OHN3RDZRclZ0UWtXMWxIQ2prM3RST1lIa25l?=
 =?utf-8?B?cDBiVkN4b3A5eExlWUk1alJobUw2akRLWS9FWkJZaWdyLy94VWFMdWRlWUNs?=
 =?utf-8?B?NWNXa3kwTGdERUsybUZpcG1mc2plMVJFc3VsdkNtcndacm5YZjhoT1FMbnJz?=
 =?utf-8?B?TGZRN2c4SmlOYjhuUjF4Y3BNSURURXlXV3JySWV5V0R6OE9zSXhTckxlcmYx?=
 =?utf-8?B?cDJyNmxsUmFINjFVaVIrelJXVTUvNzRsVjMwOHladWVaZzQrR3E5bEV4WVh1?=
 =?utf-8?B?YXdSb3lNbllFR2RHd0NWVXdXWVdNcVZwRUZPWjEyRlBuSUhHbkxvYUVtNnc2?=
 =?utf-8?B?SVZkQllyUDIrMnZ0UzNUL3k4S0JTa1pObDN4T0NtaXNXZUVUWndoZ0plSUhS?=
 =?utf-8?B?SXhGUGJiWDg4QnQ2OTg1alVGcElULzRBeWFZMk80YkhLai91RkNpM1FNK0FJ?=
 =?utf-8?B?c2doaStYZEx2Uk1GMVljMXg2b1dSTEpEMk03Z2Q5aDFVMHhSemhTMUJySkNZ?=
 =?utf-8?B?aDZzeDZEY0I1RDJnUVBzU3dzL2VPVmViZS9xa2MxMzRvSFF3aTNDN3FIQ2ox?=
 =?utf-8?B?WXFTd0llRmR5RnRtZkNzdHhlYU1kOG54b2QrRHZYTFFHWWVYUi9qTWN5U2No?=
 =?utf-8?B?eVk3QTdEYXpGNkwzMFBPWGQ4ZnBJRGREcmhneDh5Y2xoZ0VwK1c4RkIzeGVB?=
 =?utf-8?B?RGpEVGt3SmM0M2N5ZTUzcVVkL2RxUkkzaWExTjB6SzFhOFlyKzZYM2VvRkNr?=
 =?utf-8?B?dWFVckM4Wi9CdXBTRXUxTlkxYVBVcnhoNVZ5Y3B3eFY0UkVYRE5uTnNrOC85?=
 =?utf-8?B?OW02TytyekdkT2hRbEdOV0R5RHgwU1c4SmlzT09xblFySkdQMzZHQmRieFdn?=
 =?utf-8?B?QnRFV29SOFQxdHpKdXB3amZ1RS9raUVsUzNzSTIwcG45Zm9RM1ZzL2dTZDFi?=
 =?utf-8?B?TVZaeFZiVms2NUllSnFxN2g0WGg2b3c3NHpIY0ROc21GZTNtSTV6bTRyQVNL?=
 =?utf-8?B?cUpxS2JPQ0gwTm5RSGhzbG4wSWdIRy9Qb0pyWit6YmFaOHUzZVRURXNIeERZ?=
 =?utf-8?B?YVBQQUZpRFRXT1pBbmZ0ODM4WVdKem9OaStxdmNOUis2RXgvTVc4UTF6cko4?=
 =?utf-8?B?Ty9UMWdKd040OE1BT1FIL3BMdWw2UTlwZTRRZEZvUFhnczI2Zk1xZ3dUVDZU?=
 =?utf-8?B?RXRySWR2Z3MwSGxUU0pTcTBBVkxTa3ZnWEVBWVRxWHlIbHVneWNxQ0tTbXRX?=
 =?utf-8?B?VUg3Q0ViRWZrR0srVUt6OGY5ZUl1Yjg0WFZ2T0xyeGVucFZnWmZBcXZVRkZq?=
 =?utf-8?B?LzY4S0xCaDFNbEdlSTdhZm1HS0IyWWZQdEh1WG40d1BwUWdtM0w0cUVEM3dy?=
 =?utf-8?B?RE9zVlZWU20vNnF0Y2dCMHVYNGpSRytTVXBueElaM2lLekJIaS9Wdm15WlFi?=
 =?utf-8?B?cEhJZ2IrR0UzaUpHa1FOd0h3N1JvOVNTUHY4QUE2bVRTaXhwMkVlb1BmUzJI?=
 =?utf-8?B?UWJJMFBaRVRzY2tvTm8zWTBSSVpBa1UvNU4wKy9PZGpsZWd2dGpaY2NtU05E?=
 =?utf-8?B?a1lXSEloNWtOcUVIeWlSU0czcm81dVpLVGJMS09ZZXAvWXZ1bVJpOUFQckRT?=
 =?utf-8?B?VmV4cS9PZURxVldOeVk0SGt4anFxM2xTZHBSSFMwWE1ZeWZ5bG8yS1VaaFc4?=
 =?utf-8?B?dG04RFBVeERnQUNqdDArMGs2NlpITEtnTjh5L2kyV1EwbUUwdkVuYWFjMjQw?=
 =?utf-8?B?NXRjcllNRDdibXFtT2tjY1NXdGJBREpqZm0xUnBQYkw0c25Ja2FTUDVEenR2?=
 =?utf-8?B?MENXTDJuekRxY1NsUjVYUFBUalJkb0d0UXUzcWw1Wk9HLzU1NElHQVNMbEJM?=
 =?utf-8?B?ekYvanozMDlrYjd0Y0ViRGcyMzRTQ21MTmJyT1RWMktFMVd1UXVmTlBvMS9D?=
 =?utf-8?B?N2hyakoyZ2NHTVJtQkxRQlNPUytOWEkrS21EZExxSkI4cWdVRC9hTGV5MzVZ?=
 =?utf-8?B?d1NJOVZEZkdrWXI2eWw2dEtNTE1wNHVoTDlBR29zblVma2JnT04yci9zdUFK?=
 =?utf-8?B?T2ZaelRXai8xRWhybVNGWTV0MGUxR3ZoOXBpZ3RVeHgyNTBYN1ppcldldDJI?=
 =?utf-8?Q?ZkyjB4vfC0EtmxvoYkflcxDS0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a07ef534-2e0c-4d05-f31e-08da6f2415b0
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 16:30:00.1176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjV05d6aFPDUJ8ds4VZ1+22pn5+nUd5c05fD6Cq496dHw/4Pogj3j1DsP5al+6w/P/ZlM0gYirCWpjLD96UlzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P192MB1973
X-OrganizationHeadersPreserved: DU0P192MB1973.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-ORIG-GUID: EfoSeM9FDFlonhkMjKn34vOqUkM10VUH
X-Proofpoint-GUID: EfoSeM9FDFlonhkMjKn34vOqUkM10VUH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------BwkOzX69jPoeCCQltutzELfm
Content-Type: multipart/mixed; boundary="------------lorKvdLzVXT00j3ZWkodQVkI";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 nicolas.dichtel@6wind.com, eyal.birger@gmail.com,
 linux-kernel@vger.kernel.org
Message-ID: <712bcd84-4dbe-67a6-afa9-ddc01ea27cc8@westermo.com>
Subject: Re: [PATCH 2/2 net-next] geneve: fix TOS inheriting for ipv6
References: <20220724003741.57816-1-matthias.may@westermo.com>
 <20220724003741.57816-3-matthias.may@westermo.com>
 <20220725170519.GD18808@pc-4.home>
In-Reply-To: <20220725170519.GD18808@pc-4.home>

--------------lorKvdLzVXT00j3ZWkodQVkI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUvMDcvMjAyMiAxOTowNSwgR3VpbGxhdW1lIE5hdWx0IHdyb3RlOg0KPiBPbiBTdW4s
IEp1bCAyNCwgMjAyMiBhdCAwMjozNzo0MUFNICswMjAwLCBNYXR0aGlhcyBNYXkgd3JvdGU6
DQo+PiBUaGUgY3VycmVudCBjb2RlIHVzZXMgdGhlIFJUX1RPUyBtYWNybyB0byBjdXQgb2Zm
IHRoZSA2IERTQ1ANCj4+IGJpdHMsIGRvd24gdG8gdGhlIG9yaWdpbmFsIDMgVE9TIGJpdHMu
DQo+Pg0KPj4gRG8gbm90IHVzZSB0aGlzIG1hY3JvIHRvIGdldCB0aGUgcHJpbyBmb3IgaW5o
ZXJpdGluZyBwdXJwb3Nlcy4NCj4gDQo+IEhvbmVzdGx5LCB0aGlzIHBhdGNoIGlzIGEgYnVn
IGZpeCBhbmQgaXMgc3VpdGFibGUgZm9yIHRoZSBuZXQgdHJlZQ0KPiAod2l0aCBhcHByb3By
aWF0ZSAnRml4ZXMnIHRhZykuDQo+IA0KPiBJZGVhbGx5LCB3ZSdkIGFsc28gZml4IGlwNl9k
c3RfbG9va3VwX3R1bm5lbCgpICh1c2VkIGJ5IGJhcmV1ZHANCj4gdHVubmVscykgYW5kIHZ4
bGFuNl9nZXRfcm91dGUoKS4NCj4gDQo+IEFsc28sIG1seDVlX3RjX3R1bl91cGRhdGVfaGVh
ZGVyX2lwdjYoKSBhbmQNCj4gbWx4NWVfdGNfdHVuX2NyZWF0ZV9oZWFkZXJfaXB2NigpIGJv
dGggY2FsbCBSVF9UT1MoKSBpbnNpZGUNCj4gaXA2X21ha2VfZmxvd2luZm8oKSBhbmQgY2Vy
dGFpbmx5IG5lZWQgdG8gYmUgZml4ZWQgdG9vLg0KPiANCg0KSGkgR3VpbGxhdW1lDQpIb3cg
d291bGQgaSBkbyB0aGF0Pw0KU2VuZCBhIHYyIHRvIG5ldCB3aXRoIHRoZSBmaXhlcyB0YWcg
b24gOTVjYWY2ZjcxYTk5OT8NCk9yIGp1c3QgcmVzZW5kIHRvIG5ldCB3aXRoIHRoZSBmaXhl
cyB0YWcgb24gOTVjYWY2ZjcxYTk5OT8NClNpbmNlIHRoZXJlIGFyZSBubyBhY3R1YWwgY2hh
bmdlcyB0byB0aGUgcGF0Y2guDQpUaGlzIGtpbmQgb2YgY29udHJhZGljdHMgdGhlIHN0YXRl
bWVudCB0aGF0IElQdjQgYW5kIElQdjYgc2hvdWxkIGJlaGF2ZSB0aGUgc2FtZS4NCi0tPiB2
NiB3b3VsZCBiZSBmaXhlZCwgYnV0IHY0IG5vdC4NCg0KQlINCk1hdHRoaWFzDQo=

--------------lorKvdLzVXT00j3ZWkodQVkI--

--------------BwkOzX69jPoeCCQltutzELfm
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYuAWhAUDAAAAAAAKCRDfdrYEUzwNviM9
AP0SYzX7AZIUsmRzq5uEEQthkqiUF5Nv92tRg6KCqn2K9AEA7pM8wjL7a3lFpRnkijbjObz3M6cl
ZD4rgEACogd5/gc=
=//wv
-----END PGP SIGNATURE-----

--------------BwkOzX69jPoeCCQltutzELfm--
