Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B62A634E45
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiKWDUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiKWDUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:20:38 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920FD8DA7C;
        Tue, 22 Nov 2022 19:20:31 -0800 (PST)
X-UUID: be6b17754f2544968893f6d0b265031b-20221123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WUqcl6fPOvCCLVyGjjQAm6uBbQXbsTqh4jZCfsOkmo8=;
        b=EXcWa2frh+PwlGsdcC4YjHkvhlydudJBSoImiUUxw+dSIRcDUGWOzbrrOfajUma9zBJJsm7DcL8jhxiyAK0uK0vc5rHDvCGgnsZ3Q6KVfXqNs65fstL4164ymCTBXP7Ou2UAjmDqZkli0mZrlVlKhC+EPaD6SBgZ0TkyqcM8/gM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.13,REQID:170da942-3a26-441d-b616-93b17c5f0954,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:1
X-CID-INFO: VERSION:1.1.13,REQID:170da942-3a26-441d-b616-93b17c5f0954,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:re
        lease,TS:1
X-CID-META: VersionHash:d12e911,CLOUDID:3ed28e2f-2938-482e-aafd-98d66723b8a9,B
        ulkID:221122174707FCY117H2,BulkQuantity:4,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: be6b17754f2544968893f6d0b265031b-20221123
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <sujuan.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1570882916; Wed, 23 Nov 2022 11:20:27 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 23 Nov 2022 11:20:26 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 23 Nov 2022 11:20:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQ5dnij7lnZjx0c3mctMZ8JC1ALz1IkcoWEO+A5ebQMruOgcFKjdvelepZTuPd1M5F9DFIy8kiiC97oD0XKUMwPL6Vj0y8i0qhrFZPY71n7Xjv1QXwVw+H7QbOsXRumxFyxF5hTKlkbw5NXn+wLAyk/67M0gIxyn3Q2TdpOngbKJWH7etz/UqdpgprvxTM9t4kfje6TwNZzl+xxCN8JVwuj01qSOyfkRsyBJMSMIsoaJUvopPkNt3LoDoVhg9aDXAT61azvhysctUcg/swJ9P8RyGFfzCgNd5n37/OiiZYH7WiB4WS5hjyS/ao36mkfYC/WCLK4hYZq5g0ArUZivjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUqcl6fPOvCCLVyGjjQAm6uBbQXbsTqh4jZCfsOkmo8=;
 b=dxBaqeEFJ64xfvs+j1MxjieGAoh530DbeVYfHNzThH84FC8wPCRh2cpKkYvOTM14Iwty1y2sFvQJD4sJIgP/SKXH6ukSl/UkGeO2VMTD/qbPx4C9H/dGGEbEY29OvVChI61qMjPDpTLxThxh0EAWpaDtSUQKgUOpsSFISIgbpP9V8DDPMXkBLRmIbi18TH8dKW7Axxywx4CRwzUQDXjTgPfytGi2NsyJtnJixzmX2U3Kam3Q/artRT4+Ms4NHLRyNt+Jo4M0KJU5DNGZ4YdHU5dMaFReH1KAH6UoZZSd7HTxc90yGVivajY6Daf6tYs1jljQ6+RbhLU2L1YXhaTDAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUqcl6fPOvCCLVyGjjQAm6uBbQXbsTqh4jZCfsOkmo8=;
 b=UEflcGeB9CMpzOx/Zl+XJl/Wpv58LKeQRPBwT70Dct3a8PbegHtE0KWbSHkVMNImpoDzAa8vwKQp47Z4CzH1azfJHyevazWuFB2DWO0RJNoN4e+6TwcmpKSclruqNvCLVIUHj0/sM7w15xi/xWCEh5xHPIcoJ8iQmoaZx3S8RDY=
Received: from PS1PR03MB3461.apcprd03.prod.outlook.com (2603:1096:803:42::12)
 by PSAPR03MB5285.apcprd03.prod.outlook.com (2603:1096:301:48::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 03:20:25 +0000
Received: from PS1PR03MB3461.apcprd03.prod.outlook.com
 ([fe80::1a4e:1765:7e7f:4000]) by PS1PR03MB3461.apcprd03.prod.outlook.com
 ([fe80::1a4e:1765:7e7f:4000%5]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 03:20:25 +0000
From:   =?utf-8?B?U3VqdWFuIENoZW4gKOmZiOe0oOWonyk=?= 
        <Sujuan.Chen@mediatek.com>
To:     "lorenzo@kernel.org" <lorenzo@kernel.org>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>,
        =?utf-8?B?RXZlbHluIFRzYWkgKOiUoeePiumIuik=?= 
        <Evelyn.Tsai@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?Qm8gSmlhbyAo54Sm5rOiKQ==?= <Bo.Jiao@mediatek.com>,
        =?utf-8?B?TWFyay1NQyBMZWUgKOadjuaYjuaYjCk=?= 
        <Mark-MC.Lee@mediatek.com>
Subject: Re: [PATCH,RESEND] net: ethernet: mtk_wed: add wcid overwritten
 support for wed v1
Thread-Topic: [PATCH,RESEND] net: ethernet: mtk_wed: add wcid overwritten
 support for wed v1
Thread-Index: AQHY/leC+cBclBSkxkKDvGRR4JVa7q5L2FiA
Date:   Wed, 23 Nov 2022 03:20:25 +0000
Message-ID: <414c9fdb577a2e301f53da8d9f1bcb948296608a.camel@mediatek.com>
References: <217932f091aa9d9cb5e876a2e958ca25f80f80b2.1668997816.git.sujuan.chen@mediatek.com>
         <Y3yajX0EF/aU5HJr@localhost.localdomain>
In-Reply-To: <Y3yajX0EF/aU5HJr@localhost.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PS1PR03MB3461:EE_|PSAPR03MB5285:EE_
x-ms-office365-filtering-correlation-id: d5390451-9cd0-4358-d49b-08dacd01a9a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aXBJVazF4JsosAE6iP33y8MRZSDQ/ATXUi/HjcyteadtVTBij30BXzlboGH6FYeCoY3I1lp1UdSXZo5vWOR3ogEX1dN0Uh9KxpzvFYtCWgXqWY+hfJAfCyuMcmnTgDTGBj5GBnL/5QtMCjyxdBe0DRCrwZQwjyoFQDGsTwktC5G+b8m0bw3+vxvVeKyeqIRCYwtYpZC526BGURBcdzB12GmOCyUek0hOH9JThJdp+EMyadUz2YLaUO2/QSEsex7aG9zy9z7Jq8gj/FTjLZYLXhS9Mq04AVBgadqTnZlxiaQd4eJ4J+aq7O0dldUxEkWvvHaYNFIr2VCUzJE3qqZC6xjsgjl+i/Xpwp68IJbYWdwh6X9NMXEJyXef2u1bylTBYLol9OZUtyvH23Lb1kEbuneVEOwf/7sjzGxlkxqAW0FSHIb9UwOfWMUEN23MFytXLyJ7xOTfhQdobHCoM1nfivDNJGVFgF6wU01vMEBS6NNH+WG0lA83ns9a3WsRhvLSkr6uHGE3mRQDvkFAxDAZL3OppIOoF6VPDSiD7NbMbCQjWKDi96lqFmQWxtyJeAVXnx44XLlUL2aJ50do97t91fUZ+mK4/dGLCNzFhWwHGWabNAEx9zDziT6u9/EUWxaGdYnrexqMQGmUQJUeOj6P+hQbfSXd1WXMS+6wgJek4aMjRAZDSTqK9+66K0BhGgKRhXnT6ALS04Zx4tVkYmF7IA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR03MB3461.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199015)(5660300002)(38100700002)(4001150100001)(85182001)(122000001)(8936002)(36756003)(4326008)(8676002)(83380400001)(186003)(66446008)(64756008)(2616005)(6512007)(2906002)(71200400001)(91956017)(316002)(6916009)(26005)(66556008)(66946007)(76116006)(66476007)(6506007)(107886003)(41300700001)(38070700005)(6486002)(478600001)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXZXRm51Vk1ObXdwcEpFWmx3eG5CemdXbjNaVUtueXBhSXZFb3JYcFFHK3lv?=
 =?utf-8?B?RHdrVHdUNkh6V1MvSStmemptYlQySFkraVlZV2d0VVhna1lDZEFzSTQ3WGo0?=
 =?utf-8?B?azdMQmlEckY0bkNYYkRDVE9pU0c3WTBGa2NXZi9TRTMxWDZub2lsY0V2QWpo?=
 =?utf-8?B?Z3MzVzdKSWRyTm81amZYWjNQa01XM1ExQnl2cWlDV3MwZTIwVlJkd2RmTWhu?=
 =?utf-8?B?TGdERzBVWWliT0xLdEt4Z3k4NWUwMXlWa1dCcDV0d3lCVkxrYWh2M0JTN0ww?=
 =?utf-8?B?R0dMcDhyWlgzK1BleTdoQ0VJOHMrSDgwaUFRUTNYb3V2YS9zWWljTWJBZjlT?=
 =?utf-8?B?WjhXUkpxU1FKbTZueGFzK25iQ21VaFlremVwM1orbmt2NE1TZlNoRWRleEdU?=
 =?utf-8?B?TkZCUkpxSVdUNEQ1b0dKOVRpTVdWM2pCeHc0K2NYRFJralFWWUhtU0o4Tmw5?=
 =?utf-8?B?SFZqdDRiN2tQY3A2c3pETzJUMTVUc3kraksvdWQrdU1xViswenppMHJodjlh?=
 =?utf-8?B?NkhDdkRYRmlGT0JQQnZaOTFyckw5RnpYcDYvQzZGb0szUTZsSFdTU2VkLzBH?=
 =?utf-8?B?bG0xU3FuSEcwemV2QldyTUdHZXlMSm5GdGs1cExLL1NMQXY2K0FhRktvTjk2?=
 =?utf-8?B?SXprNkJIRkJZQm5jT2hsRCtCZFRZK016aUl3RS9yZlNBb2htc3cvdVI5d2Rh?=
 =?utf-8?B?ZDhYcDR0T0pEd3pMdFRYbWU2ZUZ0dGErLzd2M05GUk1wZm1QR1o2NjhmYktZ?=
 =?utf-8?B?WkpWTDV4TU9RdnIzQXk0MkJBOFkzL21reG43YUpuY3crRkppNEFid2dDYlpa?=
 =?utf-8?B?a0NMVHFhcHVTTDFwNjRJU1dWL1prWEVJNFNycHpMcFp2dG1xNmFmczhUdTVN?=
 =?utf-8?B?Y254cnFLTElKekdlWUJGNmRlUTg5bUVtaFQvQ0lpRG9GZm81bjh5SS80dk9q?=
 =?utf-8?B?L1VSRG5uR2JsTTdieFJOQkpQN2NYTWtCb0N0bElsakhxeGlqV1lOalZxU1Rs?=
 =?utf-8?B?dWVVUmt1UXFPc3JmWWN2MXdzdjZZdVhkc0lScVdsN3hZSTJKNE9ZYUY4MzNz?=
 =?utf-8?B?SWFDSGlkT1N2SVBqYjZZRXROMktlOHBLUExSN2JxUEIxOW8xS0IwT2p5aW84?=
 =?utf-8?B?Q2grMU5LZmY3alBENjJkbmUyNG9lNWI4VUhmTWQxSUlrZEU2bEd0S1VraFQw?=
 =?utf-8?B?WVg2NTBEZmRxN24xNGp0REtNNWMxNUVwWmRsUWhINXk3RFNFdTU5NmZKUjNI?=
 =?utf-8?B?ZVVWalNOeEFESTVHYU5nanBzRVB4d1M3K3JGY0xSNUNtdFkyVG9LQytHNkJZ?=
 =?utf-8?B?eVo2T28rRDFlcnZmQXc5U0xlQ0xnK3RRVlJLTmhIYlV2OVBYaVh3YUM4Q1RO?=
 =?utf-8?B?R2VLK2dtN2JwK0lVUmlKVloyQnBuSHh4dVhIWlJQY2xSTFRyQjQ2bGEzT01v?=
 =?utf-8?B?S0QwcFBHdWplZzB0eXFYQzB0T25OZ0VKN3lVTDV6SVVlUVV0Uy9yTFJFZzFs?=
 =?utf-8?B?QllWV055ajYvZEcraXVuYU02VEEveFJySXNOYjdBRDlVTTRFWWlYT3hNTjNz?=
 =?utf-8?B?TVVtUWxsQkZYVGI2WGpNWjBHU09ic08zRGtiRW5KZ1MzTTdPVFVMTVBTZ2Y5?=
 =?utf-8?B?ZDZOMVpsWE83V0NCTVh2d2M1L2V1Y082ckpRc1pTSGtodTB6d1JJTFVVSGdu?=
 =?utf-8?B?Z0hJNGdJU0lzbFdlcUFtRmN5TmorTVA0a0NOYjM5SHN5c1pJRlgvRWNYeWRE?=
 =?utf-8?B?bWh4SzArbzhUaGx5QU1wMXowVmQrWE9rQ1BxTzVpQ2wxU0NhRWFwOW10MmZq?=
 =?utf-8?B?eld3enlxVlBjWjdaOG5ieGhnTUptTjRxdU1WaS9DaVFReStpZFpTMWFPRFF3?=
 =?utf-8?B?US9kR3czZlpFZ1ROOXJjWW0xNEdvYWJJbXpoOTlqSUtNR0VhekpQanpwdzFY?=
 =?utf-8?B?NDhyZTI1R2duOW9oWDFpYlRTOTVsV2UvZktzcEpRUGJFeXpMSHFpWi9xMGNQ?=
 =?utf-8?B?ZUpub0ZpWGt5cXBydXBPQVhkc3AzbEdUVkV1eUU2UmNuRVZucnFIYzVCSVU5?=
 =?utf-8?B?UkRqZkxJZ3RGeHlISk9lYWpPMzZNek5DRjJWVG8rWnRhZGJuR1ovZVgrZ3hY?=
 =?utf-8?B?bjlxSk03YzZJaWtJU1VBN3RLemoyRXlsbnl3OWZxK3owLzVFTERzSEE1NW05?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDB3F8007D072A4FA0325FBE15EE5378@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR03MB3461.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5390451-9cd0-4358-d49b-08dacd01a9a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 03:20:25.0847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CURXn9gLTdRdruPYQSY2zCLfVzPuDn++Pvu1bxYRUDzl/lJ1jYwWiTTCSSkuLY/wyjer9WRPjTyepXOX4o3FU0HX47uQbX0HUQXTINooFl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB5285
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDEwOjQ2ICswMTAwLCBMb3JlbnpvIEJpYW5jb25pIHdyb3Rl
Og0KPiA+IEFsbCB3ZWQgdmVyc2lvbnMgc2hvdWxkIGVuYWJsZSB3Y2lkIG92ZXJ3cml0dGVuIGZl
YXR1cmUsDQo+ID4gc2luY2UgdGhlIHdjaWQgc2l6ZSBpcyBjb250cm9sbGVkIGJ5IHRoZSB3bGFu
IGRyaXZlci4NCj4gPiANCj4gPiBUZXN0ZWQtYnk6IFN1anVhbiBDaGVuIDxzdWp1YW4uY2hlbkBt
ZWRpYXRlay5jb20+DQo+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBCbyBKaWFvIDxiby5qaWFvQG1lZGlh
dGVrLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCbyBKaWFvIDxiby5qaWFvQG1lZGlhdGVrLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdWp1YW4gQ2hlbiA8c3VqdWFuLmNoZW5AbWVkaWF0ZWsu
Y29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfd2Vk
LmMgICAgICB8IDkgKysrKysrLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVr
L210a193ZWRfcmVncy5oIHwgMiArKw0KPiA+ICBpbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9t
dGtfd2VkLmggICAgICAgICB8IDMgKysrDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3dlZC5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWRpYXRlay9tdGtfd2VkLmMNCj4gPiBpbmRleCA3ZDg4NDIzNzhjMmIuLmEyMDA5MzgwM2Uw
NCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfd2Vk
LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfd2VkLmMNCj4g
PiBAQCAtNTI2LDkgKzUyNiw5IEBAIG10a193ZWRfZG1hX2Rpc2FibGUoc3RydWN0IG10a193ZWRf
ZGV2aWNlICpkZXYpDQo+ID4gIAkJCU1US19XRURfV1BETUFfUlhfRF9SWF9EUlZfRU4pOw0KPiA+
ICAJCXdlZF9jbHIoZGV2LCBNVEtfV0VEX1dETUFfR0xPX0NGRywNCj4gPiAgCQkJTVRLX1dFRF9X
RE1BX0dMT19DRkdfVFhfRERPTkVfQ0hLKTsNCj4gPiAtDQo+ID4gLQkJbXRrX3dlZF9zZXRfNTEy
X3N1cHBvcnQoZGV2LCBmYWxzZSk7DQo+ID4gIAl9DQo+ID4gKw0KPiA+ICsJbXRrX3dlZF9zZXRf
NTEyX3N1cHBvcnQoZGV2LCBmYWxzZSk7DQo+ID4gIH0NCj4gPiAgDQo+ID4gIHN0YXRpYyB2b2lk
DQo+ID4gQEAgLTEyOTAsOSArMTI5MCwxMCBAQCBtdGtfd2VkX3N0YXJ0KHN0cnVjdCBtdGtfd2Vk
X2RldmljZSAqZGV2LA0KPiA+IHUzMiBpcnFfbWFzaykNCj4gPiAgCQlpZiAobXRrX3dlZF9ycm9f
Y2ZnKGRldikpDQo+ID4gIAkJCXJldHVybjsNCj4gPiAgDQo+ID4gLQkJbXRrX3dlZF9zZXRfNTEy
X3N1cHBvcnQoZGV2LCBkZXYtPndsYW4ud2NpZF81MTIpOw0KPiA+ICAJfQ0KPiA+ICANCj4gPiAr
CW10a193ZWRfc2V0XzUxMl9zdXBwb3J0KGRldiwgZGV2LT53bGFuLndjaWRfNTEyKTsNCj4gPiAr
DQo+ID4gIAltdGtfd2VkX2RtYV9lbmFibGUoZGV2KTsNCj4gPiAgCWRldi0+cnVubmluZyA9IHRy
dWU7DQo+ID4gIH0NCj4gPiBAQCAtMTMzOCw2ICsxMzM5LDggQEAgbXRrX3dlZF9hdHRhY2goc3Ry
dWN0IG10a193ZWRfZGV2aWNlICpkZXYpDQo+ID4gIAlkZXYtPmlycSA9IGh3LT5pcnE7DQo+ID4g
IAlkZXYtPndkbWFfaWR4ID0gaHctPmluZGV4Ow0KPiA+ICAJZGV2LT52ZXJzaW9uID0gaHctPnZl
cnNpb247DQo+ID4gKwlpZiAoaHctPnZlcnNpb24gIT0gMSkNCj4gPiArCQlkZXYtPnJldl9pZCA9
IHdlZF9yMzIoZGV2LCBNVEtfV0VEX1JFVl9JRCk7DQo+IA0KPiBuaXRwaWNrOiBzaW5jZSByZXZf
aWQgaXMgdmFsaWQganVzdCBmb3IgaHctPnZlcnNpb24gPiAxIGFuZCBpdCB3aWxsDQo+IGJlIHVz
ZWQgYnkNCj4gbXQ3NiBpbiB0aGUgZnV0dXJlLCB5b3UgY2FuIG1vdmUgaXQgZmV3IGxpbmVzIGJl
bG93IHdoZXJlIHdlIGFscmVhZHkNCj4gY2hlY2sNCj4gaHctPnZlcnNpb24gYW5kIGdldCByaWQg
b2YgdGhlIHVubmVjZXNzYXJ5IGlmIGNvbmRpdGlvbi4gU29tZXRoaW5nDQo+IGxpa2U6DQo+IA0K
PiAJaWYgKGh3LT52ZXJzaW9uID09IDEpIHsNCj4gCQkuLi4NCj4gCX0gZWxzZSB7DQo+IAkJZGV2
LT5yZXZfaWQgPSB3ZWRfcjMyKGRldiwgTVRLX1dFRF9SRVZfSUQpOw0KPiAJCXJldCA9IG10a193
ZWRfd29faW5pdChodyk7DQo+IAl9DQo+IA0KQWNrLCBJIHdpbGwgbW92ZSBpdCBpbiB2Mg0KDQo+
IFJlZ2FyZHMsDQo+IExvcmVuem8NCj4gPiAgDQo+ID4gIAlpZiAoaHctPmV0aC0+ZG1hX2RldiA9
PSBody0+ZXRoLT5kZXYgJiYNCj4gPiAgCSAgICBvZl9kbWFfaXNfY29oZXJlbnQoaHctPmV0aC0+
ZGV2LT5vZl9ub2RlKSkNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVk
aWF0ZWsvbXRrX3dlZF9yZWdzLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVr
L210a193ZWRfcmVncy5oDQo+ID4gaW5kZXggOWUzOWRhY2U5NWViLi44NzNkNTBiOWE2ZTYgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX3dlZF9yZWdz
LmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfd2VkX3JlZ3Mu
aA0KPiA+IEBAIC0yMCw2ICsyMCw4IEBAIHN0cnVjdCBtdGtfd2RtYV9kZXNjIHsNCj4gPiAgCV9f
bGUzMiBpbmZvOw0KPiA+ICB9IF9fcGFja2VkIF9fYWxpZ25lZCg0KTsNCj4gPiAgDQo+ID4gKyNk
ZWZpbmUgTVRLX1dFRF9SRVZfSUQJCQkJCTB4MDA0DQo+ID4gKw0KPiA+ICAjZGVmaW5lIE1US19X
RURfUkVTRVQJCQkJCTB4MDA4DQo+ID4gICNkZWZpbmUgTVRLX1dFRF9SRVNFVF9UWF9CTQkJCQlC
SVQoMCkNCj4gPiAgI2RlZmluZSBNVEtfV0VEX1JFU0VUX1RYX0ZSRUVfQUdFTlQJCQlCSVQoNCkN
Cj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zb2MvbWVkaWF0ZWsvbXRrX3dlZC5oDQo+
ID4gYi9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRlay9tdGtfd2VkLmgNCj4gPiBpbmRleCA4Mjk0
OTc4ZjRiY2EuLjFiMWVmNTc2MDlmNyAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3Nv
Yy9tZWRpYXRlay9tdGtfd2VkLmgNCj4gPiArKysgYi9pbmNsdWRlL2xpbnV4L3NvYy9tZWRpYXRl
ay9tdGtfd2VkLmgNCj4gPiBAQCAtODUsNiArODUsOSBAQCBzdHJ1Y3QgbXRrX3dlZF9kZXZpY2Ug
ew0KPiA+ICAJaW50IGlycTsNCj4gPiAgCXU4IHZlcnNpb247DQo+ID4gIA0KPiA+ICsJLyogdXNl
ZCBieSB3bGFuIGRyaXZlciAqLw0KPiA+ICsJdTMyIHJldl9pZDsNCj4gPiArDQo+ID4gIAlzdHJ1
Y3QgbXRrX3dlZF9yaW5nIHR4X3JpbmdbTVRLX1dFRF9UWF9RVUVVRVNdOw0KPiA+ICAJc3RydWN0
IG10a193ZWRfcmluZyByeF9yaW5nW01US19XRURfUlhfUVVFVUVTXTsNCj4gPiAgCXN0cnVjdCBt
dGtfd2VkX3JpbmcgdHhmcmVlX3Jpbmc7DQo+ID4gLS0gDQo+ID4gMi4xOC4wDQo+ID4gDQo=
