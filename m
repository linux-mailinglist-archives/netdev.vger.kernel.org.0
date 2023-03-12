Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7666B6583
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 12:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCLLdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 07:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjCLLdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 07:33:04 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A6C52930;
        Sun, 12 Mar 2023 04:32:34 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C5va2n003551;
        Sun, 12 Mar 2023 07:31:30 -0400
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3p8qebv393-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 07:31:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgWmcrfhxRgGUmShwsH+Ew8r03kcP8NWO4rtY8Z9XkSmr81IVDU/M7n1z3rArrsvwpFs0pAOBDVOkngfVZsB/3Xu9JLBuO73W/V/sPX2OANSt/JGUlRi58/E9o6k1KHTXdRsKmN+sSvcRPEPNxJ50tQe0/XgBIiGMOLFe3RHoXUXhmI3l1nMmzjzW8iCZcidL1bfyZGryo1CRrhRw3hY0n4qJ2wiB6/sUU+JoBpaCn+01frcgHc1bl81cSUUSM7ff3MVmRRmN0GKeYXqZQBZS1Hw7jRvcFvFxsDJUDfnnd04cEev7T8Cckc93pGizjh/IJp+B7rN3XosGkdotk9MoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPB/hYHXTpUNxrfUXYe9U4ksWUqLlL1fA9rH10cO9ag=;
 b=G1g/nAsxJb3kiqesh3C+8gXG5riV+pmqF2ivMCi8fcs8jniI6RQrQ4D4jqZmtCqD18cwXeAxEkifvXAbZusPnUxT//8o5xohVIENILH4IxKCkwkNswHs9933WifdX9xqRcYc8SOUB9HBsYjMUgdZVeLMJPPcMkyTX+Dnc2LdW7W0pRCJelE/kFSn3Pm+nYm82ZA+5SjHie0WqTU9MzTj6mdkxRBri3U1iGDrZVGfEiL7yJyPnn4Vmz3rFd+vTaVwBZBWrAByiDIPyCyHHPDXB3hegnkxCWXo8iFgVBvu7QKdYR1mAXmpJaPaYEdmEl2MVseZu8FqmgPP6GKpLHZhpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPB/hYHXTpUNxrfUXYe9U4ksWUqLlL1fA9rH10cO9ag=;
 b=hSNA7IuOAc8r4BtHtl91B4FVqCb6Nhs1xlDl4fIVzF9BDP5M/79UuUoVIAVT73YeGiOHL6e7hw4NxlKirlK6bOqbOiNW+1lX7Im9RriISTxXwVirowUioW+1VBzk8jTmk6+c5SIVV+mrMn+62jYC1/Tx0315XR9zFtLu4ZjRWKw=
Received: from DM8PR03MB6246.namprd03.prod.outlook.com (2603:10b6:8:33::16) by
 MN2PR03MB5215.namprd03.prod.outlook.com (2603:10b6:208:1e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Sun, 12 Mar
 2023 11:31:28 +0000
Received: from DM8PR03MB6246.namprd03.prod.outlook.com
 ([fe80::8c01:b841:bfe1:9b61]) by DM8PR03MB6246.namprd03.prod.outlook.com
 ([fe80::8c01:b841:bfe1:9b61%5]) with mapi id 15.20.6178.020; Sun, 12 Mar 2023
 11:31:28 +0000
From:   "Hennerich, Michael" <Michael.Hennerich@analog.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>
Subject: RE: [PATCH 07/12] net: ieee802154: adf7242: drop of_match_ptr for ID
 table
Thread-Topic: [PATCH 07/12] net: ieee802154: adf7242: drop of_match_ptr for ID
 table
Thread-Index: AQHZVD+WJRmxaKVSH02/ljxp5UVbs673A87A
Date:   Sun, 12 Mar 2023 11:31:28 +0000
Message-ID: <DM8PR03MB62467F65542CD233D5D348178EB89@DM8PR03MB6246.namprd03.prod.outlook.com>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311173303.262618-7-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230311173303.262618-7-krzysztof.kozlowski@linaro.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?utf-8?B?UEcxbGRHRStQR0YwSUc1dFBTSmliMlI1TG5SNGRDSWdjRDBpWXpwY2RYTmxj?=
 =?utf-8?B?bk5jYldobGJtNWxjbWxjWVhCd1pHRjBZVnh5YjJGdGFXNW5YREE1WkRnME9X?=
 =?utf-8?B?STJMVE15WkRNdE5HRTBNQzA0TldWbExUWmlPRFJpWVRJNVpUTTFZbHh0YzJk?=
 =?utf-8?B?elhHMXpaeTAyWkRFMk5HTXhNUzFqTUdNNUxURXhaV1F0WWpjM01TMWlZMll4?=
 =?utf-8?B?TnpGak5EYzJNVGxjWVcxbExYUmxjM1JjTm1ReE5qUmpNVE10WXpCak9TMHhN?=
 =?utf-8?B?V1ZrTFdJM056RXRZbU5tTVRjeFl6UTNOakU1WW05a2VTNTBlSFFpSUhONlBT?=
 =?utf-8?B?SXlORFExSWlCMFBTSXhNek15TXpBNU5ESTROemszTVRrM016Z2lJR2c5SWxG?=
 =?utf-8?B?NVdYRkdabWRuYXpsTkwyWTBSRVoxZHl0TmRqWldLMVYzYXowaUlHbGtQU0lp?=
 =?utf-8?B?SUdKc1BTSXdJaUJpYnowaU1TSWdZMms5SW1OQlFVRkJSVkpJVlRGU1UxSlZS?=
 =?utf-8?B?azVEWjFWQlFVVnZRMEZCUVRadlZ6aDJNV3hVV2tGVlRIVXpjM0JuZGt4U2Rs?=
 =?utf-8?B?RjFOMlY1YlVNNGRFYzRSRUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRklRVUZCUVVSaFFWRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGRlFVRlJRVUpCUVVGQlVXUnBhelZSUVVGQlFVRkJRVUZCUVVGQlFVRkJT?=
 =?utf-8?B?alJCUVVGQ2FFRkhVVUZoVVVKbVFVaE5RVnBSUW1wQlNGVkJZMmRDYkVGR09F?=
 =?utf-8?B?RmpRVUo1UVVjNFFXRm5RbXhCUjAxQlpFRkNla0ZHT0VGYVowSm9RVWQzUVdO?=
 =?utf-8?B?M1FteEJSamhCV21kQ2RrRklUVUZoVVVJd1FVZHJRV1JuUW14QlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVWQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlowRkJRVUZCUVc1blFVRkJSMFZCV2tGQ2NFRkdPRUZqZDBKc1FVZE5RV1JS?=
 =?utf-8?B?UW5sQlIxVkJXSGRDZDBGSVNVRmlkMEp4UVVkVlFWbDNRakJCU0UxQldIZENN?=
 =?utf-8?B?RUZIYTBGYVVVSjVRVVJGUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRlJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRMEZCUVVGQlFVTmxRVUZCUVZsUlFtdEJSMnRCV0hkQ2Vr?=
 =?utf-8?B?RkhWVUZaZDBJeFFVaEpRVnBSUW1aQlNFRkJZMmRDZGtGSGIwRmFVVUpxUVVo?=
 =?utf-8?B?UlFXTjNRbVpCU0ZGQllWRkNiRUZJU1VGTlowRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZDUVVGQlFVRkJRVUZCUVVsQlFVRkJRVUZCUFQwaUx6NDhMMjFs?=
 =?utf-8?Q?dGE+?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR03MB6246:EE_|MN2PR03MB5215:EE_
x-ms-office365-filtering-correlation-id: 04aeee71-de8d-4e67-f835-08db22ed524e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1H2KOkQbDohvGcaXMjkdcXO/5BnUl7UFugjUD1WIUS72odKssiFUgR+QHT8scdELrdO2IPoRaSPNa6n/6capdsaN9gFWoxbUtN9STxu/QMLo4tR13xnIwRA04OfyLhioawKQkxye9gEiByBlM1Az3gEFNGlybHrpAP5tLqp66+lnmpjPbg2gYC/1HDGtFl59koryHfjYRGrF8fgNOS8T9gO/CAJi4ZFwPas84jOOwI/xXmpg24Arl3wlef+qPoJupZsJzJ8NIA3gzdUqg4ulzfT9QEV9p6d1/W6+5ea4xEN8A9D4KroqrCEX5mXSSZhNFidj1v1c0gJzjRRu+R0R5BMYznQzc+6iU5NpncmMKLPKfhHCE4RyGVjPXDg2ADkw8k+7f8A7BO/LA0gWlWqVfVmnAdZNX0QXHpipeK16Q8tZRzpR7HkL5gn8J0L2DNLc/0yq8YYrq4g+tbWhxPgqTEK3qa9c1uty6b5kHGxy68RgbxyXjksbSGzsXJxD/t+p1erXuFUc/MM6jU7pugINgl8xlVWwKwbZ7B9S63Ueos11OgApgL8gVNTMmcteIO4QO/S908WANHG9TiDbATzLlOYGBSna+HrPX986/v/vgqDoU6Xf0k/4hQ38fPjo43j5d5PJnkKJlXt876vuEO5mByqiucHAH6U9rUi1I1SG0zkRKCvXzv/AG9QrTMeQHJFVkvjQWxLxcPcrEqDrAWkS3ITNZdRV/iaOgpaJ3RL+EnE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR03MB6246.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199018)(921005)(86362001)(33656002)(38070700005)(122000001)(38100700002)(2906002)(41300700001)(7416002)(5660300002)(8936002)(52536014)(55016003)(66574015)(6506007)(26005)(83380400001)(9686003)(186003)(53546011)(316002)(110136005)(8676002)(66476007)(64756008)(66446008)(478600001)(66946007)(66556008)(76116006)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0d6MG5GdlJ4TzNTY3BzWENyV3Y3SU1kRUdEV0ludGd0VUMyNUo5L1Ixd0Vy?=
 =?utf-8?B?R2J4UENQdDlCMlZaZDcraG04bGVPMHM5TStQajdRUlg5cGxTNXNjU2FrcWMy?=
 =?utf-8?B?d2FMT2M4MHNZK1NiVnZBV0FyRi81OHVNOVM1bWtwQzhjNDFZSnBndE1tWm9s?=
 =?utf-8?B?Ry96cENlOFhKM0Nsb2JzbDBXOGgvenpJM1QwRmZYdy9IdE9CMlZtejM4L0Fw?=
 =?utf-8?B?OGE1eUJRTHhRUG1RS2pwMHA4bXpjbCtWbjlqWHJXalZ0ZFQ5RHZKSUZ1QktX?=
 =?utf-8?B?c05RbmxPZUxxMTc4R2o2NVdqb25CdC9jTEVRUEtlZEw4L0hHVXBaUUpFR2cy?=
 =?utf-8?B?UVA4UGNVTHV4c296ZzFQbGpuaG5xWHFCeW1tTXFnKzJTYWYzTzdvbjQ3V2dv?=
 =?utf-8?B?MXVPQ1lQdFJacm5qSlc3bldZSTZoQ3UzaHk1Tk5CZWtwUFgvQTdJWXNoT1Ey?=
 =?utf-8?B?R3hSUlN3c2Z5WCs1ZkRFMHh5V0ZjZ1FKV0hsTTdacGlGVEZZMFN2NW0rSVZU?=
 =?utf-8?B?NVJ6Y2FlUXlrRlNCaG9CdURYeDl1ZnZCMG5zWU1RK1JVZUI4b3RraUwwNVA1?=
 =?utf-8?B?QXU4ZnpBOHlQSS9qeW9yaUpGV2ZOWE1lK09nN0hXT1Z4a1pjQmpSWm9TVXFO?=
 =?utf-8?B?c0ZNdXdnaVFHa29CSXZLSnJ3WjVyZDVmVDRUajBVeDBlZFBUbnRjakNBWHR1?=
 =?utf-8?B?b1FaQUhWbk85aGRKWWxUY2ptd1BGTzlQV1IxeDVXZzFoWE1PR2lzSTk2Y0ty?=
 =?utf-8?B?SDdMU2VDRnZ2dURGd1RscDRjenYzMnM3WmI0RURma290Q2p4SmFvTktFVndG?=
 =?utf-8?B?K09iMUlLdHNQcHRQNkc2RmdFYmZKWGVON1NUL0JPMmJaNkxzTnh1Y05kakJJ?=
 =?utf-8?B?WTRqQkFqaFJwL09EWWpHR1BQNDB4QUl2b1N0MlhidTZ1c215R29LMzlBSDBz?=
 =?utf-8?B?NFZ3RnNKZ1B5WG51bGszVWNxQ3pMekZxNTFMSkkyYzBWaTBZU2FrWW5ONGty?=
 =?utf-8?B?eGJJV2FCTmRZaDdla3N0STMyQjFMeXBVMFJtN0xKaU9BblZOSkRWMFZBL21q?=
 =?utf-8?B?SWNTRVpybExLR1NQdmY4aUNLSFVSK1N3K1FjVmMvVnlBSFlQR2F6eU5ESVhH?=
 =?utf-8?B?aUR2aEp5cUNtdE1EWFR3dmFNYUQ1ZDNwSkdkMWhyS2dTdzV5WVF0S2VCK250?=
 =?utf-8?B?UVppTnlFSWgwbFo4ek5NZUJUV2wvT0tHS3dsWmhKdjNXNzZ1Z2NoV1YyYTRD?=
 =?utf-8?B?VERtOUE5aCsvN24vcCtnbVpLb21wYmJaeXlseVY0eDFsRXZNYzNBd1BDUHlU?=
 =?utf-8?B?eFFGbCtjRXE2MFBsZ1h2d0Mwb2ZWWnZ4OVBIdUhTeFJoY2krYko5SzB4M0pJ?=
 =?utf-8?B?aGUxOTdjTWxjUUFJOHplcS9DSllwWE1VV0I1N1NtZWd3RWNTcDViaDhNdG1I?=
 =?utf-8?B?bjdteEYzcnVJeHU4QzB3dHVBcHNkdnF6dnhvbzZyZDlCTEFGSTZHd1pVbW5D?=
 =?utf-8?B?bDcyWTE3RTRhTmNzcU9ZSWgycG91MzQ4NGQxdCtQWWpxOGRxMmJ5NG1Pc0Zt?=
 =?utf-8?B?Mlc1dDcxOW5tWFpmRDc2UkFXR0FhRkNyMGNvMTljTHRib0E2THA1ei9PdmhE?=
 =?utf-8?B?bTRIenZpNjZacG9VZmZuRFhxaENNcWxnZkpMc1lJeGdjU1U1V29GeHZCYVdL?=
 =?utf-8?B?MDdVZmNUOVpXZmN1dlFxVnBiZFdFekRkRnJEdERqMit1S3BiZWp6emxIdVRQ?=
 =?utf-8?B?N253VkY1VjdlNU5zN05CN3ZZRk1oNlBuTlFRZXVjWS9zb2VKRW1nc2pGRGp5?=
 =?utf-8?B?QXhiWm5zaHNZL0hxY3h4M0Z4UDVwTHEvcmMxUzllT2U3ai96ejQxeGV6ZDlP?=
 =?utf-8?B?WlVhWjY0aEFqQUtJbnhsbCtraG5ibk5zbVlXV3dPRHVKOTZ2VHBsckU2Y3Ux?=
 =?utf-8?B?UEM4WERTSTVjbGczSS9reHFFcncvdkhnbGRVcGdmZ01OQU5pekdMeE5PazhE?=
 =?utf-8?B?UVRxSWpraVdPR1I2ZGhLd3VCcTdYbXk0NENIZXJMNklGd3V2eVJteVF3akZ6?=
 =?utf-8?B?aVhoQUZicjJFMllBRzhmWHBteWJMaitXT0pEL0FQMXV0UnVMR2Y0amppZmVv?=
 =?utf-8?B?RzVaUHNZMENKRGRYUXVITlZEUjlhcmNPTWkvMXVFdklqOVllSlBncER0cDVL?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR03MB6246.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04aeee71-de8d-4e67-f835-08db22ed524e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 11:31:28.6089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InCwDPISKfYf0RshKBitYwXwT/ovy4IZVlr7gO36Itk+ct9DxCS4DQUjjhGmn3whbyobQufEbjH9aXjyxgW37ujg4LZQX08ssLjHG/ZhHBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5215
X-Proofpoint-ORIG-GUID: 1S1fIU1elhc10B9mySJzFuRz9a1QJ0sK
X-Proofpoint-GUID: 1S1fIU1elhc10B9mySJzFuRz9a1QJ0sK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 adultscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303120099
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBTYW1zdGFnLCAx
MS4gTcOkcnogMjAyMyAxODozMw0KPiBUbzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsg
RmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+Ow0KPiBWbGFkaW1pciBPbHRl
YW4gPG9sdGVhbnZAZ21haWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWINCj4gS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47
IEhhdWtlDQo+IE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPjsgV29vanVuZyBIdWgNCj4gPHdv
b2p1bmcuaHVoQG1pY3JvY2hpcC5jb20+OyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBD
bGF1ZGl1DQo+IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IEFsZXhhbmRyZSBCZWxs
b25pDQo+IDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbT47IENvbGluIEZvc3RlciA8Y29s
aW4uZm9zdGVyQGluLQ0KPiBhZHZhbnRhZ2UuY29tPjsgSGVubmVyaWNoLCBNaWNoYWVsIDxNaWNo
YWVsLkhlbm5lcmljaEBhbmFsb2cuY29tPjsNCj4gQWxleGFuZGVyIEFyaW5nIDxhbGV4LmFyaW5n
QGdtYWlsLmNvbT47IFN0ZWZhbiBTY2htaWR0DQo+IDxzdGVmYW5AZGF0ZW5mcmVpaGFmZW4ub3Jn
PjsgTWlxdWVsIFJheW5hbCA8bWlxdWVsLnJheW5hbEBib290bGluLmNvbT47DQo+IEhlaW5lciBL
YWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBSdXNzZWxsIEtpbmcNCj4gPGxpbnV4QGFy
bWxpbnV4Lm9yZy51az47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxA
dmdlci5rZXJuZWwub3JnOyBsaW51eC13cGFuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogS3J6eXN6
dG9mIEtvemxvd3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTdWJqZWN0
OiBbUEFUQ0ggMDcvMTJdIG5ldDogaWVlZTgwMjE1NDogYWRmNzI0MjogZHJvcCBvZl9tYXRjaF9w
dHIgZm9yIElEDQo+IHRhYmxlDQo+IA0KPiBUaGUgZHJpdmVyIHdpbGwgbWF0Y2ggbW9zdGx5IGJ5
IERUIHRhYmxlIChldmVuIHRob3VnaHQgdGhlcmUgaXMgcmVndWxhciBJRA0KPiB0YWJsZSkgc28g
dGhlcmUgaXMgbGl0dGxlIGJlbmVmaXQgaW4gb2ZfbWF0Y2hfcHRyICh0aGlzIGFsc28gYWxsb3dz
IEFDUEkNCj4gbWF0Y2hpbmcgdmlhIFBSUDAwMDEsIGV2ZW4gdGhvdWdoIGl0IG1pZ2h0IG5vdCBi
ZSByZWxldmFudCBoZXJlKS4NCj4gDQo+ICAgZHJpdmVycy9uZXQvaWVlZTgwMjE1NC9hZGY3MjQy
LmM6MTMyMjozNDogZXJyb3I6IOKAmGFkZjcyNDJfb2ZfbWF0Y2jigJkNCj4gZGVmaW5lZCBidXQg
bm90IHVzZWQgWy1XZXJyb3I9dW51c2VkLWNvbnN0LXZhcmlhYmxlPV0NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9y
Zz4NCg0KQWNrZWQtYnk6IE1pY2hhZWwgSGVubmVyaWNoIDxtaWNoYWVsLmhlbm5lcmljaEBhbmFs
b2cuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvaWVlZTgwMjE1NC9hZGY3MjQyLmMgfCAy
ICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9pZWVlODAyMTU0L2FkZjcyNDIuYw0KPiBiL2Ry
aXZlcnMvbmV0L2llZWU4MDIxNTQvYWRmNzI0Mi5jDQo+IGluZGV4IDVjZjIxOGM2NzRhNS4uNTA5
YWNjODYwMDFjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9pZWVlODAyMTU0L2FkZjcyNDIu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9pZWVlODAyMTU0L2FkZjcyNDIuYw0KPiBAQCAtMTMzNiw3
ICsxMzM2LDcgQEAgTU9EVUxFX0RFVklDRV9UQUJMRShzcGksIGFkZjcyNDJfZGV2aWNlX2lkKTsN
Cj4gc3RhdGljIHN0cnVjdCBzcGlfZHJpdmVyIGFkZjcyNDJfZHJpdmVyID0gew0KPiAgCS5pZF90
YWJsZSA9IGFkZjcyNDJfZGV2aWNlX2lkLA0KPiAgCS5kcml2ZXIgPSB7DQo+IC0JCSAgIC5vZl9t
YXRjaF90YWJsZSA9IG9mX21hdGNoX3B0cihhZGY3MjQyX29mX21hdGNoKSwNCj4gKwkJICAgLm9m
X21hdGNoX3RhYmxlID0gYWRmNzI0Ml9vZl9tYXRjaCwNCj4gIAkJICAgLm5hbWUgPSAiYWRmNzI0
MiIsDQo+ICAJCSAgIC5vd25lciA9IFRISVNfTU9EVUxFLA0KPiAgCQkgICB9LA0KPiAtLQ0KPiAy
LjM0LjENCg0K
