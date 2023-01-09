Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9866622D0
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbjAIKPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbjAIKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:15:07 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12918E1A;
        Mon,  9 Jan 2023 02:14:39 -0800 (PST)
X-UUID: 45d82fc343ab4e52912f0e38819bc455-20230109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+opO11Np9hvTvRcZ5tx7m9xLVp7G0FD9kI998UEJH4o=;
        b=KG8fPaw2fqe3DNd+nm5BS2bHB6u4j0asuWLcXWyTxKvwRMGgs17FER/1BFn8sXbYZHr7jFsss2MIO3Rju9sm+hwYkalJZBlOKCkhOBK/nxuwgwZF7Oglv7qsb1oeZTmlPomvUczW1DgzjvdmiwmC+PVboDG7AYSIzt1Vh+PQta0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.17,REQID:c90fe436-9df0-4e78-b05d-bb73bbc74911,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.17,REQID:c90fe436-9df0-4e78-b05d-bb73bbc74911,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:543e81c,CLOUDID:0c891a54-dd49-462e-a4be-2143a3ddc739,B
        ulkID:230109181435FE3IZXBM,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: 45d82fc343ab4e52912f0e38819bc455-20230109
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1643792116; Mon, 09 Jan 2023 18:14:33 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 9 Jan 2023 18:14:32 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 9 Jan 2023 18:14:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDh4IeuQazkYk3DexSTZm8uZ7YJjVmyqfuRdB/CCtBUVeQ1PF++q75J+h0NLfgWZtGg4srlB2ZPdSllTYD+W33oV5V91HIcyebTtGUGgEw4egc7Nr0rf2U7VVpWisxkALdjO4WK2zhHpo2onv+IDYmK4K3tKfNFRxDOus2/3LyPzn76blCT1KtqIExEcQjHP237zoTYnBwLYTWh/fq6lpy4Jcws+T9xrqAgvGAWKSN3CtncGnFI9wJD2imSTmZMvyhFt8kkmboKJXYEc3TNse+8kOHi2erpBHfODp55wypWOdBHj/QZbM7XjAsE9k1rUpJ0yqbIUumiSUrweeFvFAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+opO11Np9hvTvRcZ5tx7m9xLVp7G0FD9kI998UEJH4o=;
 b=iR6vD+gqkBBzXX2vSIx/jAKatgCZ50o5kox0q8g/73VUCud7CqPGrlAuX+K0wk0YbZtTtEpVmb4h9gWHqmC+ccZmHfmh1WV3QuDwLwxTBIB4VtZe0xjYNY10ankEQg57g21FjgGwEx1+ylxUgGOCSSEeDH+/9wUSmNlQ5hUlUrjVFmQKem+ez1CYZUy2n4smgra7NUAbPQnEPGl2r1YKxjlfo0OofZe44wJTR5JgdpcEiU4k6gHg+jiusy/WHrN9IXtuJYWe0QpF1An3MDKgDGmDL4ei6AIyOSNhSIr6SQXu8LomP+n5c7bmqHlrU9YAPF5zuTpENqLF7SD4mCT6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+opO11Np9hvTvRcZ5tx7m9xLVp7G0FD9kI998UEJH4o=;
 b=HC499OvA5cpDdrApLIAWDWAPxx1hOi+jXNLaUcidKtZqqtCkxY35fnynrXM46WtTw2LleUFw4rDcOblwiKoLo35lyNcIUlf/oqigKmeB+UYWT34nzmS3kN9l06xizUjKUrrSmgNMjnkTgPWoz0UC7ydg6sPNSfBMqgtdYoz0Crg=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by KL1PR03MB7222.apcprd03.prod.outlook.com (2603:1096:820:d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 10:14:27 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::6bf6:aaf0:3698:5453]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::6bf6:aaf0:3698:5453%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:14:27 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 01/19] dt-bindings: ARM: MediaTek: Add new document
 bindings of MT8188 clock
Thread-Topic: [PATCH v3 01/19] dt-bindings: ARM: MediaTek: Add new document
 bindings of MT8188 clock
Thread-Index: AQHZHCEowPSIi+cvV0uMdV6lhHqFDq6GPjMAgA+v14A=
Date:   Mon, 9 Jan 2023 10:14:26 +0000
Message-ID: <df20ff7bf661b021d5917956af08883f3b9657e0.camel@mediatek.com>
References: <20221230073357.18503-1-Garmin.Chang@mediatek.com>
         <20221230073357.18503-2-Garmin.Chang@mediatek.com>
         <33196eef-b1d5-8dd2-7c59-16a73327e8c0@linaro.org>
In-Reply-To: <33196eef-b1d5-8dd2-7c59-16a73327e8c0@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|KL1PR03MB7222:EE_
x-ms-office365-filtering-correlation-id: ea4820cf-907e-488b-003b-08daf22a4a07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QU8PbtxcfMEIwON1LMAd3XhKlmX6iPTfQlV6XQu7xXjmSrJmHnJ3itsP3S/rFUNrHjbxxW5oHykN9uN8d5rmSPLAxWD2wMrIixFZ6azacj40MqjXtpX/JUEUInHEtvnHBf+vnWuqNboy8HKrnYMxX8tCZZNb7PW3Ckwd0/ZBIYqPdua6RenPOd1ND+CQDe2ZXEIFy58/f7peEKGy0eBSZ/QAWxR26mu5USmuffm1PrllKTmH4KusAgeQ9B+y+rYFzFEQjRTo9FAftCSxcOsaoUIt85wmCcNol/+h6kE/WzckXxbnY04k5MhAEMZXat1SPjvfSLc+lrRkkbV7aKQ7nTRkn00wd5B2VqiKnscBZdBGmkmxX6H+eqhIJXZwLhFpt4YZv1ATxjacUloSRx6BSvYcgpFsp23sn8Qw4iE3mGDF7eeM/Oi7G7ARAYhmMUnohHBBCmG+L0DDUnvELBPYZVDcDZu9GnaYyEnY9AHbQ7JEnhYXGx1bMgUFmQrIKrL6KOEvkcHrmIQRPhuJbn9zw2KoIMHdnpeukGy7Xj8k8JKq/gb6KHwHvxQfoevux0wGBHJFiGbvykltbYtOUPcnUBb8OFXO3Ira3vmQ0F9qMnvtRMIqHZRViPeJwj/FJo7Yi4PG9zR4OPY2DnNz87pJZm1DDM0iFERpfaic4NecaBeHylqULbbNPan69gudGPokm07f+yl8W+ycLpPnwOplTOWC92AiVARG2pLuAGFCqbcTA+DY77l/jpnxdBwsZR9JAEVt4DK373BKB2sMuBRJ1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(8936002)(2906002)(4001150100001)(5660300002)(41300700001)(7416002)(71200400001)(66446008)(38070700005)(66556008)(91956017)(66476007)(4326008)(8676002)(76116006)(64756008)(316002)(66946007)(85182001)(110136005)(54906003)(186003)(26005)(6512007)(122000001)(2616005)(38100700002)(83380400001)(86362001)(36756003)(966005)(6506007)(478600001)(6486002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0MwTEtCaVVmdGRNZkNJK2s0eFQ3QXVnS2toNUR6M2ViV2oxSUJnYkFhQnFj?=
 =?utf-8?B?YkEwVUFGMXFiWDJxSEEvbUwzUGp2THdQUDBsVUc1R0pFZGNkK3JId3FtMUFG?=
 =?utf-8?B?MnM0RlMyZzRVb0g2SFhETUt0VVBOK09wMHB4dk56dzZCVS9PK3IrZ2tzR2Vt?=
 =?utf-8?B?ZzBiK0VMRmlWYUV3TS9YTDJOZGViOEVTMWxPQXJSNFdnN3BzQ01aNHhuU2l1?=
 =?utf-8?B?YUJRWHZ6dGMvdGVwSmxsK0Z3bys0bGlPa0xHNDYwaHB1MmFhT3ZKbkswdStM?=
 =?utf-8?B?OWtvOGJlZ21pSXl4ekw1ZWMvRHR2TEg1cmhZbGFXN3FIUGlUbjBTb1g1Wmky?=
 =?utf-8?B?aTBHUUcxeHJuWmUzWkV4Zkh0Yk9EMGt6NjR5THh5dWRKY3dHeFJqNWMxbk1W?=
 =?utf-8?B?Q1l5emkxMGdFeSs1bVlOTUhjVlVYZnZOQ3dsS1p2YnpranR5SVdwTitiNU1u?=
 =?utf-8?B?dDNhY2pyc3BxNkhIVHB1dnhKemlMWUorQ2J3S1hqZFl3YnRTRlhNOTVheW90?=
 =?utf-8?B?V3c2c3IrNUdkMDRTUUc5Q2VaTVZZc2FJSFdML2Z3bHU5b3VnUHl2aWcwTzU5?=
 =?utf-8?B?QVp6a1RITi9rSjRnUEN1Skd1L29ZK0d5RTFEODNFN2J4VVVWRDhpMzM0Mm9p?=
 =?utf-8?B?MXlwZm14ckpxUmROZ29yMU54SlltbFBIMDgvTzR5cHJPS2RiTFBmYzhiMm92?=
 =?utf-8?B?WWFzbE9pRGhSbDNEZ2txVmxlTjQ0QkcyaDJRcmUydERYcEFoTS9aTXhjR3lJ?=
 =?utf-8?B?bENUaWpzeG5BZ3c1N2l1Y1lrVFNMbE1KSXRmS1M2S0N6WEVIMVpGKzYwbk5N?=
 =?utf-8?B?MUNKTi9qd0RUQ0VQTjFrK1dRVGdrQmxPL1F5c0M2UnoyQ05IeFZodDF4YjFx?=
 =?utf-8?B?WHI1azNmSjJLOCtLU1VoQ1VyVGszeENMbUVOMHl3cnZsek5LeEtwV0NxbG41?=
 =?utf-8?B?b2xMNlRQSmw0dnJZOUJTcHNZSXJxczZUTHRub2tuMXNVRTUwMG00STg1N1o3?=
 =?utf-8?B?K0o5SmhXaTBVREc4SnVlbXczenBodlhLWitTMzBhbXBSZXpsSVhMb0M5SU1D?=
 =?utf-8?B?NHF0cUZBVzJXb2NCaFJyc1BzMkxHaWwyT2dIcWxxKzNiR2RhZUw4VzZBSjhB?=
 =?utf-8?B?SkI5eXNGdk5oVDZiYVZTQk5xamEwTnNtM29TdW5BYVdMNTJzMDFBNEdSc3I2?=
 =?utf-8?B?TWZRT2tyM2NYZCsxSXB3RmNCV1Yvd29XczcwcmZ4YTVPU0FMb01aUUNzc3hw?=
 =?utf-8?B?ZTZUMy92VEo3SWtscEhSWU5xd0dhWkx5ZDAybFZrMXhZd2dtZjFOVkhsbXpR?=
 =?utf-8?B?RmdSL3RqRlRwcGhXVHhjMGFWR2U4anEvNVl6cVFHSEp0M3pJc0x0dDBoLzFN?=
 =?utf-8?B?N2g0Y2JGbUk5NlRPZ3hwbElrYmtIWVhBRTVxelF2MXB3bmU0TlQwRGVsNm5l?=
 =?utf-8?B?QU1FNnliaENCempqUkFCS0o4cU1QNE5LR1V5bVpwUnl4TnJKRmJQTHA1TG9B?=
 =?utf-8?B?NXJWdmhYWGMwUld4WE5qWVRlOHZkVFNCYnZyOHd2QkYzZzA2Y25DekFYNWhE?=
 =?utf-8?B?bXdxVVVmdWNqdG5CWThQZkZKNkVuVUtrYkU4cGNkeXlmSWx4MkE3QzJpM3pj?=
 =?utf-8?B?akZEZTBmazRDam1NS0ZWK3pGZTFHWEdpWGkxT3NKSThBVXVkcW9hOG1XQVFR?=
 =?utf-8?B?NVZRRTZ2RTY0U0tYRUJxb21idHh0RkxqamNKZVlCY2RKMDRWYUhSUWdXdFVv?=
 =?utf-8?B?QWd5OVRFek9ZMGtLSU9EcmVWcnI4aEk5SUNPV2VNWmJTUTFNL2hIc1N1WGhj?=
 =?utf-8?B?Z05yUVdwTUEzOGZTTGNRL2Z5UkxxZmNJcDUvZGVCMW9OWlVZenU5WE5NNmYw?=
 =?utf-8?B?a3hRWHlqZHJ0T3lnWTBlQ3l0c1lFWmN1NkY0bHFSZndML0pmZGlXSVJtVVls?=
 =?utf-8?B?d3hqeFh4M3haMHc4a3hSSHRUeWUvVFlmR0I0ZUJyUzRIQ3RVR2RDT04xSERB?=
 =?utf-8?B?eGxIQXV6WFFqRFFYaUVYU0tVdDZ3VGY0dk5GcFRZQmtLOWNrR2FuNlR6eGwy?=
 =?utf-8?B?SVI0ZXRpU20wc2xPaE9RcG1keGkvamYyRWVkTGx6aFl2ZnlkaG1jeGQzeU53?=
 =?utf-8?B?ZDAvT01LVTFpTGoxV0Y5YmUvbERTWE5CUHpaTkVSWEF0WW1vTE5Gam5ieFhH?=
 =?utf-8?B?aWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <336F2557B2F041459A4DDAE3FE73B9FC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4820cf-907e-488b-003b-08daf22a4a07
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 10:14:27.0242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hwo1iGQgTVyj+bZvRxXVkruW2bSD+YYaTBvJa/33QuE22wVaZTdlMvNhrGajZEjhKm57ZyFGp/audS0G5bqY7MBZ5hVAqeQkkWge1zgsGKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7222
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTMwIGF0IDExOjQxICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBPbiAzMC8xMi8yMDIyIDA4OjMzLCBHYXJtaW4uQ2hhbmcgd3JvdGU6DQo+ID4gQWRk
IHRoZSBuZXcgYmluZGluZyBkb2N1bWVudGF0aW9uIGZvciBzeXN0ZW0gY2xvY2sNCj4gPiBhbmQg
ZnVuY3Rpb25hbCBjbG9jayBvbiBNZWRpYVRlayBNVDgxODguDQo+ID4gDQo+IA0KPiBTdWJqZWN0
OiBkcm9wIHNlY29uZCwgcmVkdW5kYW50ICJkb2N1bWVudCBiaW5kaW5ncyBvZiIuDQo+IA0KSGkg
S3J6eXN6dG9mLA0KDQpUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2VzdGlvbnMuDQpPSy4gSSdsbCBy
ZW1vdmUgaXQgaW4gdjQuDQoNCj4gPiBTaWduZWQtb2ZmLWJ5OiBHYXJtaW4uQ2hhbmcgPEdhcm1p
bi5DaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9hcm0vbWVkaWF0ZWsvbWVk
aWF0ZWssbXQ4MTg4LWNsb2NrLnlhbWwgICB8ICA3MSArKw0KPiA+ICAuLi4vbWVkaWF0ZWsvbWVk
aWF0ZWssbXQ4MTg4LXN5cy1jbG9jay55YW1sICAgfCAgNTUgKysNCj4gPiAgLi4uL2R0LWJpbmRp
bmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsuaCAgIHwgNzMzDQo+ID4gKysrKysrKysrKysr
KysrKysrDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgODU5IGluc2VydGlvbnMoKykNCj4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0DQo+ID4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Fy
bS9tZWRpYXRlay9tZWRpYXRlayxtdDgxODgtDQo+ID4gY2xvY2sueWFtbA0KPiA+ICBjcmVhdGUg
bW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvYXJtL21l
ZGlhdGVrL21lZGlhdGVrLG10ODE4OC1zeXMtDQo+ID4gY2xvY2sueWFtbA0KPiA+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgaW5jbHVkZS9kdC1iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxtdDgxODgtY2xr
LmgNCj4gPiANCj4gPiBkaWZmIC0tZ2l0DQo+ID4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvYXJtL21lZGlhdGVrL21lZGlhdGVrLG10ODE4OC0NCj4gPiBjbG9jay55YW1sDQo+
ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvYXJtL21lZGlhdGVrL21lZGlh
dGVrLG10ODE4OC0NCj4gPiBjbG9jay55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4g
PiBpbmRleCAwMDAwMDAwMDAwMDAuLjY2NTRjZWFkNzFmNg0KPiA+IC0tLSAvZGV2L251bGwNCj4g
PiArKysNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9hcm0vbWVkaWF0
ZWsvbWVkaWF0ZWssbXQ4MTg4LQ0KPiA+IGNsb2NrLnlhbWwNCj4gDQo+IENsb2NrIGNvbnRyb2xs
ZXJzIGRvIG5vdCBnbyB0byBhcm0gYnV0IHRvIGNsb2NrLiBJdCdzIHNvIHN1cHJpc2luZw0KPiBk
aXJlY3RvcnkgdGhhdCBJIG1pc3NlZCB0byBub3RpY2UgaXQgaW4gdjEuLi4gV2h5IHB1dHRpbmcg
aXQgaW4gc29tZQ0KPiB0b3RhbGx5IGlycmVsZXZhbnQgZGlyZWN0b3J5Pw0KPiANCkRvIHlvdSBt
ZWFuIG1vdmUgdG8gdGhlIHBhdGggYmVsb3cgPw0KRG9jdW1lbnRhdGlvblxkZXZpY2V0cmVlXGJp
bmRpbmdzXGNsb2NrDQoNCklmIHllcywgSSB3aWxsIGNoYW5nZSBpdCBpbiB2NC4NCg0KPiANCj4g
PiBAQCAtMCwwICsxLDcxIEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwt
Mi4wIE9SIEJTRC0yLUNsYXVzZSkNCj4gPiArJVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6
IA0KPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5vcmcv
c2NoZW1hcy9hcm0vbWVkaWF0ZWsvbWVkaWF0ZWssbXQ4MTg4LWNsb2NrLnlhbWwqX187SXchIUNU
Uk5LQTl3TWcwQVJidyFrNlRQZ2lTcnAwMFNod0UyWTl2TVVrcVdteUROWGQxYk4wWDRJdk02TXl5
SGotWURnN3EtMl9Mbkc4Q1RkWWR0bVFyVkxJaThZMXpfa0h6S3p3NnhJcjAybGVsM3o4WSTCoA0K
PiA+ICANCj4gPiArJHNjaGVtYTogDQo+ID4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0
dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sKl9fO0l3ISFDVFJOS0E5
d01nMEFSYnchazZUUGdpU3JwMDBTaHdFMlk5dk1Va3FXbXlETlhkMWJOMFg0SXZNNk15eUhqLVlE
ZzdxLTJfTG5HOENUZFlkdG1RclZMSWk4WTF6X2tIekt6dzZ4SXIwMl9OLS1kb2MkwqANCj4gPiAg
DQo+ID4gKw0KPiA+ICt0aXRsZTogTWVkaWFUZWsgRnVuY3Rpb25hbCBDbG9jayBDb250cm9sbGVy
IGZvciBNVDgxODgNCj4gPiArDQo+ID4gK21haW50YWluZXJzOg0KPiA+ICsgIC0gR2FybWluIENo
YW5nIDxnYXJtaW4uY2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ICsNCj4gPiArZGVzY3JpcHRpb246
IHwNCj4gPiArICBUaGUgY2xvY2sgYXJjaGl0ZWN0dXJlIGluIE1lZGlhVGVrIGxpa2UgYmVsb3cN
Cj4gPiArICBQTExzIC0tPg0KPiA+ICsgICAgICAgICAgZGl2aWRlcnMgLS0+DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICBtdXhlcw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAt
LT4NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xvY2sgZ2F0ZQ0KPiA+ICsN
Cj4gPiArICBUaGUgZGV2aWNlcyBwcm92aWRlIGNsb2NrIGdhdGUgY29udHJvbCBpbiBkaWZmZXJl
bnQgSVAgYmxvY2tzLg0KPiA+ICsNCj4gPiArcHJvcGVydGllczoNCj4gPiArICBjb21wYXRpYmxl
Og0KPiA+ICsgICAgZW51bToNCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxODgtYWRzcC1hdWRp
bzI2bQ0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4OC1pbXAtaWljLXdyYXAtYw0KPiA+ICsg
ICAgICAtIG1lZGlhdGVrLG10ODE4OC1pbXAtaWljLXdyYXAtZW4NCj4gPiArICAgICAgLSBtZWRp
YXRlayxtdDgxODgtaW1wLWlpYy13cmFwLXcNCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxODgt
bWZnY2ZnDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LXZwcHN5czANCj4gPiArICAgICAg
LSBtZWRpYXRlayxtdDgxODgtd3Blc3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LXdw
ZXN5cy12cHAwDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LXZwcHN5czENCj4gPiArICAg
ICAgLSBtZWRpYXRlayxtdDgxODgtaW1nc3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4
LWltZ3N5cy13cGUxDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWltZ3N5cy13cGUyDQo+
ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWltZ3N5cy13cGUzDQo+ID4gKyAgICAgIC0gbWVk
aWF0ZWssbXQ4MTg4LWltZ3N5czEtZGlwLXRvcA0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4
OC1pbWdzeXMxLWRpcC1ucg0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4OC1pcGVzeXMNCj4g
PiArICAgICAgLSBtZWRpYXRlayxtdDgxODgtY2Ftc3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWss
bXQ4MTg4LWNhbXN5cy1yYXdhDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWNhbXN5cy15
dXZhDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWNhbXN5cy1yYXdiDQo+ID4gKyAgICAg
IC0gbWVkaWF0ZWssbXQ4MTg4LWNhbXN5cy15dXZiDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4
MTg4LWNjdXN5cw0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4OC12ZGVjc3lzLXNvYw0KPiA+
ICsgICAgICAtIG1lZGlhdGVrLG10ODE4OC12ZGVjc3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWss
bXQ4MTg4LXZlbmNzeXMNCj4gPiArDQo+ID4gKyAgcmVnOg0KPiA+ICsgICAgbWF4SXRlbXM6IDEN
Cj4gPiArDQo+ID4gKyAgJyNjbG9jay1jZWxscyc6DQo+ID4gKyAgICBjb25zdDogMQ0KPiA+ICsN
Cj4gPiArcmVxdWlyZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxlDQo+ID4gKyAgLSByZWcNCj4gPiAr
ICAtICcjY2xvY2stY2VsbHMnDQo+ID4gKw0KPiA+ICthZGRpdGlvbmFsUHJvcGVydGllczogZmFs
c2UNCj4gPiArDQo+ID4gK2V4YW1wbGVzOg0KPiA+ICsgIC0gfA0KPiA+ICsgICAgY2xvY2stY29u
dHJvbGxlckAxMTI4MzAwMCB7DQo+ID4gKyAgICAgICAgY29tcGF0aWJsZSA9ICJtZWRpYXRlayxt
dDgxODgtaW1wLWlpYy13cmFwLWMiOw0KPiA+ICsgICAgICAgIHJlZyA9IDwweDExMjgzMDAwIDB4
MTAwMD47DQo+ID4gKyAgICAgICAgI2Nsb2NrLWNlbGxzID0gPDE+Ow0KPiA+ICsgICAgfTsNCj4g
PiArDQo+ID4gZGlmZiAtLWdpdA0KPiA+IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL2FybS9tZWRpYXRlay9tZWRpYXRlayxtdDgxODgtDQo+ID4gc3lzLWNsb2NrLnlhbWwNCj4g
PiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9hcm0vbWVkaWF0ZWsvbWVkaWF0
ZWssbXQ4MTg4LQ0KPiA+IHN5cy1jbG9jay55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQN
Cj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjJiMjhkZjFmZjg5NQ0KPiA+IC0tLSAvZGV2L251bGwN
Cj4gPiArKysNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9hcm0vbWVk
aWF0ZWsvbWVkaWF0ZWssbXQ4MTg4LQ0KPiA+IHN5cy1jbG9jay55YW1sDQo+IA0KPiBXcm9uZyBk
aXJlY3RvcnkuDQoNCj4gIGZvbGxvdyB0aGUgYW5zd2VyIGFib3ZlLg0KPiANCj4gPiBAQCAtMCww
ICsxLDU1IEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wIE9SIEJT
RC0yLUNsYXVzZSkNCj4gPiArJVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6IA0KPiA+IGh0
dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy9h
cm0vbWVkaWF0ZWsvbWVkaWF0ZWssbXQ4MTg4LXN5cy1jbG9jay55YW1sKl9fO0l3ISFDVFJOS0E5
d01nMEFSYnchazZUUGdpU3JwMDBTaHdFMlk5dk1Va3FXbXlETlhkMWJOMFg0SXZNNk15eUhqLVlE
ZzdxLTJfTG5HOENUZFlkdG1RclZMSWk4WTF6X2tIekt6dzZ4SXIwMlAwS2NlckkkwqANCj4gPiAg
DQo+ID4gKyRzY2hlbWE6IA0KPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8v
ZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCpfXztJdyEhQ1RSTktBOXdNZzBB
UmJ3IWs2VFBnaVNycDAwU2h3RTJZOXZNVWtxV215RE5YZDFiTjBYNEl2TTZNeXlIai1ZRGc3cS0y
X0xuRzhDVGRZZHRtUXJWTElpOFkxel9rSHpLenc2eElyMDJfTi0tZG9jJMKgDQo+ID4gIA0KPiA+
ICsNCj4gPiArdGl0bGU6IE1lZGlhVGVrIFN5c3RlbSBDbG9jayBDb250cm9sbGVyIGZvciBNVDgx
ODgNCj4gPiArDQo+ID4gK21haW50YWluZXJzOg0KPiA+ICsgIC0gR2FybWluIENoYW5nIDxnYXJt
aW4uY2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ICsNCj4gPiArZGVzY3JpcHRpb246IHwNCj4gPiAr
ICBUaGUgY2xvY2sgYXJjaGl0ZWN0dXJlIGluIE1lZGlhVGVrIGxpa2UgYmVsb3cNCj4gPiArICBQ
TExzIC0tPg0KPiA+ICsgICAgICAgICAgZGl2aWRlcnMgLS0+DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICBtdXhlcw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAtLT4NCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xvY2sgZ2F0ZQ0KPiA+ICsNCj4gPiArICBU
aGUgYXBtaXhlZHN5cyBwcm92aWRlcyBtb3N0IG9mIFBMTHMgd2hpY2ggZ2VuZXJhdGVkIGZyb20g
U29DDQo+ID4gMjZtLg0KPiA+ICsgIFRoZSB0b3Bja2dlbiBwcm92aWRlcyBkaXZpZGVycyBhbmQg
bXV4ZXMgd2hpY2ggcHJvdmlkZSB0aGUgY2xvY2sNCj4gPiBzb3VyY2UgdG8gb3RoZXIgSVAgYmxv
Y2tzLg0KPiA+ICsgIFRoZSBpbmZyYWNmZ19hbyBwcm92aWRlcyBjbG9jayBnYXRlIGluIHBlcmlw
aGVyYWwgYW5kDQo+ID4gaW5mcmFzdHJ1Y3R1cmUgSVAgYmxvY2tzLg0KPiA+ICsgIFRoZSBtY3Vz
eXMgcHJvdmlkZXMgbXV4IGNvbnRyb2wgdG8gc2VsZWN0IHRoZSBjbG9jayBzb3VyY2UgaW4gQVAN
Cj4gPiBNQ1UuDQo+ID4gKyAgVGhlIGRldmljZSBub2RlcyBhbHNvIHByb3ZpZGUgdGhlIHN5c3Rl
bSBjb250cm9sIGNhcGFjaXR5IGZvcg0KPiA+IGNvbmZpZ3VyYXRpb24uDQo+ID4gKw0KPiA+ICtw
cm9wZXJ0aWVzOg0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAg
ICAgLSBlbnVtOg0KPiA+ICsgICAgICAgICAgLSBtZWRpYXRlayxtdDgxODgtdG9wY2tnZW4NCj4g
PiArICAgICAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWluZnJhY2ZnLWFvDQo+ID4gKyAgICAgICAg
ICAtIG1lZGlhdGVrLG10ODE4OC1hcG1peGVkc3lzDQo+ID4gKyAgICAgICAgICAtIG1lZGlhdGVr
LG10ODE4OC1wZXJpY2ZnLWFvDQo+ID4gKyAgICAgIC0gY29uc3Q6IHN5c2Nvbg0KPiA+ICsNCj4g
PiArICByZWc6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICAnI2Nsb2NrLWNl
bGxzJzoNCj4gPiArICAgIGNvbnN0OiAxDQo+ID4gKw0KPiA+ICtyZXF1aXJlZDoNCj4gPiArICAt
IGNvbXBhdGlibGUNCj4gPiArICAtIHJlZw0KPiA+ICsgIC0gJyNjbG9jay1jZWxscycNCj4gPiAr
DQo+ID4gK2FkZGl0aW9uYWxQcm9wZXJ0aWVzOiBmYWxzZQ0KPiA+ICsNCj4gPiArZXhhbXBsZXM6
DQo+ID4gKyAgLSB8DQo+ID4gKyAgICBzeXNjb25AMTAwMDAwMDAgew0KPiANCj4gY2xvY2stY29u
dHJvbGxlcg0KDQpPSy4gSSdsbCB1c2UgY2xvY2stY29udHJvbGxlciBpbiB2NC4NCj4gDQo+ID4g
KyAgICAgICAgY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDgxODgtdG9wY2tnZW4iLCAic3lzY29u
IjsNCj4gPiArICAgICAgICByZWcgPSA8MHgxMDAwMDAwMCAweDEwMDA+Ow0KPiA+ICsgICAgICAg
ICNjbG9jay1jZWxscyA9IDwxPjsNCj4gDQo+IA0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5
c3p0b2YNCj4gDQo=
