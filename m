Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2FA65FE52
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjAFJsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjAFJrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:47:48 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3F943E4A;
        Fri,  6 Jan 2023 01:47:42 -0800 (PST)
X-UUID: 5ef82198f34b4f36b7f1aec6be54f3c0-20230106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=X4OpMzMCZC5NsU7iKgxkeW2lRtfqrMDvsCdsi1Xg9II=;
        b=YOWHIs+TQGmsYodGTjiny8eLDQhtew9o9Nf1ONsZmpPRH1qxZNHmBRAH7tPbYVUQyVJDbh6AhQDF7KRGut1VZe/T2EogNm31+I8gIi5iEYkMdMBIjEwZ1uEUNJcFeU//ge0hl4lZ3RSz1r29qIowT1Esy9q2Fz2iJcUghEN/i68=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.17,REQID:105d59f0-41ed-4289-9395-9cea694adaec,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-10
X-CID-INFO: VERSION:1.1.17,REQID:105d59f0-41ed-4289-9395-9cea694adaec,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:-10
X-CID-META: VersionHash:543e81c,CLOUDID:942105f5-ff42-4fb0-b929-626456a83c14,B
        ulkID:230106174737XCU5EF6B,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0
X-CID-BVR: 0
X-UUID: 5ef82198f34b4f36b7f1aec6be54f3c0-20230106
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 5605930; Fri, 06 Jan 2023 17:47:36 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Fri, 6 Jan 2023 17:47:35 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Fri, 6 Jan 2023 17:47:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahrfL8TbG6ge1cTiWwP18Jhlwsw1eB343H5nrBv1vWU3YJLxzbmahZVnADeFolr6AqbN+6LsGMzw8oqlNfFqKmd16nYrtexuSGsnad+PyfeIMRdXqeRA0EkgmbB4hlIx2eX5h2UP7eajFW17GVy9GbGKiWZsubtFNgyOgqpgmzCL/jkfA4iiQACTpl/27uPsosVY0740U9YgIfCRA7kvWwxy16EyOzXlCNG1+WbOKxnyyzxDE/TGmEs/uq4ESvU743S+2/BHdANWw/fbPjPG55LwcG5BkAiDUlzoZ8vsKZQVfIUjovURKcYQRJhpSMHtYMHkBMN72sZAkZbFdSkI/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4OpMzMCZC5NsU7iKgxkeW2lRtfqrMDvsCdsi1Xg9II=;
 b=QIjmLMYI22kXTJc5YEPeKd+ZPknQ/wbOQdaHkng5P9CjUXKqKjEmTnIGPNRNFF/qqqVnQjRI362Y8RMdnb4PJAb7HmfibtG0hWlb3K9rYN5CKzBoGOTEo9K0AKa+GVhk3IDOd+qNhGJ3jXSRxdY4STq9oztfHWyRNKJtD/uDavrYXBCqcsOJMz/uweDMwAXVxhYlIfIkXUGAmbxNHXblwiFSfZBL2SyCgwm+rRtbIWnpvP1DSCxRcQtuBZUWCLpHYgATi8s03mMYMWmaOFF8QZ4pcmvo4TFTUaKbXgJ9R1qIDI3Q5/xICQhHwVAR3FiUZgZQF2B9zn2ez6QXhJWtTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4OpMzMCZC5NsU7iKgxkeW2lRtfqrMDvsCdsi1Xg9II=;
 b=l1RC4WRrV8NNjZRX6khln9CziuUt53I0h0u0pf3xj17sG6IWBE90apr+0s2DsgFcD+hnNq6h59wrDhyO/qdsyJM0NzasSc1bhxxuCh4s8RunDJOe6L9HFiMiGdR2u3y98v6Z0I8fFL00qCyp87GtI0z6CI/tYwyXYbPGOOCDtfE=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by SI2PR03MB5913.apcprd03.prod.outlook.com (2603:1096:4:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 09:47:33 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::6bf6:aaf0:3698:5453]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::6bf6:aaf0:3698:5453%4]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 09:47:33 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
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
Subject: Re: [PATCH v3 0/2] Add power domain support for MT8188
Thread-Topic: [PATCH v3 0/2] Add power domain support for MT8188
Thread-Index: AQHZFqWJsQzQJaQLuUudGVvEgxokhq6ROoAA
Date:   Fri, 6 Jan 2023 09:47:33 +0000
Message-ID: <aa438a50a089d69625c87e6215526a7733488342.camel@mediatek.com>
References: <20221223080553.9397-1-Garmin.Chang@mediatek.com>
In-Reply-To: <20221223080553.9397-1-Garmin.Chang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|SI2PR03MB5913:EE_
x-ms-office365-filtering-correlation-id: 99d4630a-2a41-4ec2-5465-08daefcb08ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8P9qC1ulxYds0uE2w56d8PLkT597hsaSFK7nHZV2s8NUbDm9aEPuHgOvPWlGCrQQTRmv5QN5WyCn3QY+IqB9+vwb+LBP/tQQSN+H35nEnmTceqAgTVc4KCz8B/Bakj7GDNjOVxVEsbh1vacRJEfrvyubfY8hTRXqzgMLLGc3xnwLsX/wYmapxry7Dcjxt688Gi4zcWXDaMog0TVpc3sLgBvPBQ1JgA4ouxM0mTWWIx1c9bQZsyU/MAO4hiGmnlpLUSNk0YIdcPIMf5FVXId1/ovJtac4zXtjUwTzPAdjSuBDxEXJpXG5tAkddS/aZxG01uwFCmQsCjVOgboRVdknpS3yloibFWCjcvGByGakBLupDhfbIpVQaJR0VdGy/0rndXhF+B4yNIeM+uQ5HfrY7q5qUSwB8K7rHYh7XF6308mUIqCqZ+xTKmR9RS14jRwWe4U4n3/IpgDxwb312VUTrKY6nys0bKGx2H0ReYj03ooEkdy1lx5DVkAuumOne5mLxB1dQD2aLxeth67tf/kIAIJww4/7puYGinxjKYO1LrPONxSaJUyncauELPzstdcIzb8mb861/V4tVoYLHSkYZ0ATBevWtSXjD5Ip8LUSB9orUSAUiGv0wMtTZtYDYgf5CFGu1Azk2DOfk2ihb4azksR6CWG77zcS3IOyn4pC+HNDZEpNLzFUbuSzInCP/Ifz8ttODBimzQ5h91bl1QUbIY2BR7ahFIlqENiTd9+oCKMSqXSyCZ+tDp/SuXFWIWd0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199015)(86362001)(122000001)(38070700005)(6486002)(26005)(38100700002)(71200400001)(41300700001)(6506007)(6512007)(186003)(478600001)(4744005)(5660300002)(8936002)(110136005)(66446008)(4001150100001)(76116006)(91956017)(66476007)(2906002)(66556008)(4326008)(8676002)(66946007)(64756008)(2616005)(85182001)(36756003)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjdiSHlZaE1iZHlac1k5czllNUJQaWRtZW1maWh0WTdEOGZUNGVKYW0vbE1k?=
 =?utf-8?B?c0NvMXI2TFBOMkJELy9CMi9jZW82blhMNEdXM2QvSDRhaGtrTGJIRE1Hd28y?=
 =?utf-8?B?a1oxMjh2THJrNkw5ZGZBbW5URlBrZW01Ti8rY3ByOHNQMkV0TmFEVUkwb2Zu?=
 =?utf-8?B?OGZLMi9CcGFoRWlZMCtHT2VpVVRCZ2RVemgvMUVpZ1E3R21lclFVSk5BQkhI?=
 =?utf-8?B?OUdJTzZsRXhEenVUTjZncW5mWjRzSkJjVXFhZTRDVVRvSGgxNFF4MmN6NFhT?=
 =?utf-8?B?TWNSUkFqYXIyU1pPZjdFZlJBRkplaTdXVThMcFJSaU1JWE03cldSUU8wZDNN?=
 =?utf-8?B?Ky9YMUpsSFBLd2dBeWpkNS9rT2tMb1JLVVNRN29CNUg3ajN0TllFb084bXZH?=
 =?utf-8?B?Wmp3VCtqMW94MnRFbzUvVXp4SXpnNCszZ0x4V0JhUU1wRGMxc3BuZkRiRjBF?=
 =?utf-8?B?Y3dRSkpRTEUxL0cwTUp4eTZuWkVWYkFqcUFySmgvTHJFM0E2MjZvUjJsOEtM?=
 =?utf-8?B?N3VaU3o4aEpjajlyOGUvRmdON3ZJSXZScFc3Z2pLRFJwczlVWTIvSVg5bi9I?=
 =?utf-8?B?c1IxamtPcGdwb3FrZXphQ0Y0TzR6ZXlWQ1VSTlBRNzM1YmRuUnY0cTZsWkFy?=
 =?utf-8?B?Y2o1R3NHclJkWlVBaUVuNkovUlJHRU1pWExVOTMyMm1jdUJmNlUzbWRGc3l0?=
 =?utf-8?B?SzNnMXJvSmIyeTZhNTAwZm5aY2YrdzRmZFlGV1V6bEh6YUg5K0ZTUVptaDQ0?=
 =?utf-8?B?QVlzOFNxKzlLbnI5aVlDOENDRk1wNzE2cTBGTHlLTmJST2d6SXFYam1pOE1I?=
 =?utf-8?B?R0ZmTE5xdlM3U212dm85S050bmpyVGxuekhWNUoyMlpNUEpnZk5OMmZONGpq?=
 =?utf-8?B?ZGFXUDlFcFJSeERqd2pKMFpVdXNRMHJlK1pPbDFWQlhUQUFSMlFWbkJ0ZUNv?=
 =?utf-8?B?SDJjQWpiOTBSVVNkbXV1MVFTc042TE1IbkRkRFdXUU1zSjBqbFZvMHFwMXls?=
 =?utf-8?B?c1M2L2lGU1BTTEthUGd4YWprUWlxU3kzcVY4dFFmMWxxKzhLOVdOTUg3aWh1?=
 =?utf-8?B?SXVlZVFDMDM4TkNpa2kyTlBxbTVnWHdkSkNkaGg3TTdSYWNzTTJIV3ZaMHZu?=
 =?utf-8?B?eW1YQzZrT3RvQy9DcnptYjdEdTd6SGc4Y0llb1JkMVVDUlF0OGtVcFpubnQv?=
 =?utf-8?B?cmV5TnU5QUpmaEs3M00wOVBOMUVid2pyQmNRQWxzZ25Ud2xRZ1R6R3IzM0dM?=
 =?utf-8?B?SXJMQkxKNU9aSTFuZ1c2TnpieS8xeXFFM2pzNnFoWjJTdGU3V1ZtMm81eEo0?=
 =?utf-8?B?Smo4VnRVM2NvTXJwakpPV2djZk1haW5ja0M4M1FsR3BZSEFiR0Jhd0c2NVF5?=
 =?utf-8?B?Z2tObS94Y1NDRzExNzNwVUFTamdxOE5uOFQ3WkFHaTlVV3lIMkN0Q2p3dytT?=
 =?utf-8?B?L0R5ZVNkYVd3eWVWTG9JencvU2hOd01qYXk1dkhEOE5XODFRMHlsM0MvVVNL?=
 =?utf-8?B?aWtoQWVrekdNbG1zMmxFdXkxN0ZsVWhBZjAwTDIraXJHeG5SVHQ0anJGM0FE?=
 =?utf-8?B?UVZ5NUZvN0xPQ3JpdVp0dU16Z2FieFFOaVBsUkhoMk9KRVRrL2xwbU1UaUMr?=
 =?utf-8?B?S2twS3RUZU9RVmw5blVmUnhVUDc2S3R6aGJzNm44RHFlQmoxMmt3ZDV1c3ZQ?=
 =?utf-8?B?VnJXRm0yT0R5eE5YZFlWNHNjdFVTRHB5NE5EV3pUZ0FmTEFXbEFMd1JhN3NH?=
 =?utf-8?B?L3R1cEx2bk9vMTZmRTllZ3FUdXA2bWI0bHpobGoxU0Y2Sy9oZURrWnZmczQy?=
 =?utf-8?B?bjVDT2dsZkh1Ukh2ZkFzVHJRUThZa0dXSkNJMTY2aTFUUlMrcG1tYllKY3ZW?=
 =?utf-8?B?WThucFVRcThoaCtLTFVWZE9zeEYxUWxyRVozWTRtbmlEdy9pdUE3TjR1aHJG?=
 =?utf-8?B?Vk00R2pQa3l0OXpxb1dISW42Mk5yQTczQkhNK0lIdk9iNVM5UXZJSkRXamhI?=
 =?utf-8?B?Nm9MSUxtWmJESktJY0VsOThKaStSeHJrVnA0NVBHT256Q2YwUXNaOThWMW52?=
 =?utf-8?B?Z2RISXEzZThZWE03N3lSTk1tNUQ1NGJvVEJaOEZCVjh2dXhTU1RkQTdqYW5J?=
 =?utf-8?B?WXZxcW5IbWVwVjljaXB4SzEvdWgvWTltS2V6Yks4ZzVqS1RHTlI2anVkMkdL?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFB7FB09E99E764CA90839FBFC6D56C5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d4630a-2a41-4ec2-5465-08daefcb08ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2023 09:47:33.2711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TvT0w7zai+ALM41vynwognx18aD3SRU550Kw6EH/8WYabiFBzTGrPRNtnBSG1VQhpU2UbvGhtdO1YUPBe6iECMoo17Gtxlg+bE8XPr3Tztc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5913
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWF0dGhpYXMNCg0KDQpKdXN0IGEgZ2VudGxlIHBpbmcgb24gdGhpcy4NCkNvdWxkIHlvdSBw
bGVhc2UgcmV2aWV3IHRoaXMgcGF0Y2ggYW5kIGdpdmUgdXMgc29tZSBzdWdnZXN0aW9uPw0KDQoN
ClRoYW5rcywNCkJlc3QgcmVnYXJkcywNCkdhcm1pbg0KDQoNCg0KT24gRnJpLCAyMDIyLTEyLTIz
IGF0IDE2OjA1ICswODAwLCBHYXJtaW4uQ2hhbmcgd3JvdGU6DQo+IEJhc2Ugb24gdGFnOiBuZXh0
LTIwMjIxMjIwLCBsaW51eC1uZXh0L21hc3Rlcg0KPiANCj4gY2hhbmdlcyBzaW5jZSB2MjoNCj4g
LSAJYWRkIE1US19TQ1BEX0RPTUFJTl9TVVBQTFkgY2FwIHRvIE1GRzENCj4gLSAJYWRkIE1US19T
Q1BEX0FMV0FZU19PTiBjYXAgdG8gQURTUF9JTkZSQQ0KPiANCj4gR2FybWluLkNoYW5nICgyKToN
Cj4gICBkdC1iaW5kaW5nczogcG93ZXI6IEFkZCBNVDgxODggcG93ZXIgZG9tYWlucw0KPiAgIHNv
YzogbWVkaWF0ZWs6IHBtLWRvbWFpbnM6IEFkZCBzdXBwb3J0IGZvciBtdDgxODgNCj4gDQo+ICAu
Li4vcG93ZXIvbWVkaWF0ZWsscG93ZXItY29udHJvbGxlci55YW1sICAgICAgfCAgIDIgKw0KPiAg
ZHJpdmVycy9zb2MvbWVkaWF0ZWsvbXQ4MTg4LXBtLWRvbWFpbnMuaCAgICAgIHwgNjIzDQo+ICsr
KysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9zb2MvbWVkaWF0ZWsvbXRrLXBtLWRvbWFpbnMu
YyAgICAgICAgIHwgICA1ICsNCj4gIC4uLi9kdC1iaW5kaW5ncy9wb3dlci9tZWRpYXRlayxtdDgx
ODgtcG93ZXIuaCB8ICA0NCArKw0KPiAgaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvaW5mcmFj
ZmcuaCAgICAgICAgIHwgMTIxICsrKysNCj4gIDUgZmlsZXMgY2hhbmdlZCwgNzk1IGluc2VydGlv
bnMoKykNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3NvYy9tZWRpYXRlay9tdDgxODgt
cG0tZG9tYWlucy5oDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9kdC1iaW5kaW5ncy9w
b3dlci9tZWRpYXRlayxtdDgxODgtcG93ZXIuaA0KPiANCg==
