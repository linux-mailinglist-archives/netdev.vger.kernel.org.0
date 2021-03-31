Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DED34FAA0
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhCaHng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:43:36 -0400
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:20130
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234148AbhCaHnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 03:43:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVgI7pBp+PthrE1hF6+xudQFLICGIZWz1BlLuaXBDPnKWyKxgPzKSK25vccX2ApUw9LAB760qf9ztjELn99PvY/lqxAOUmOgCxHl1HO+gBUEjbFTgDOBVB8icbNZM5xRLF4h51V8xwqeO0L5+6JAf8jtTDrM8N4rweiQ6lpL6qcHTahu1myT3/78FQ6RG6HTTuFjNJPA2H8AAdxXywEbbg8X3q6bZ3s8z8bJhKNG38o7thBqzFHrdceJS5q3arcKGUagn+4ilHwOlmyzFAFXARqXN0qFox7WKFAYQTBUIqw9j2/8vs9C74MSny4qPYF9D+GzuuvB826GNa/uqw+jlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqzVt+GIk+3cjvZmHyIY2+ATVlI26G7NN7ZJ0dXcKes=;
 b=PJfNEgY67yxWbVL+/qbqtLxlzl812u0oO3yo8WIpfpOd6geG+fwDM8cYk1bcezKd0lYPsGoJNtnzb60XejHNdKrs4c+9Slwwl3R5I1/k24uJp1V3viGSPLAGwrRS6slF0CtsxLy0rr5qQi5BoaaQvtSi07dV5WVm+BniL+I39IhZdNuD5ljjaGX5YZ9QVuk5+E2vtXkJgJo8t4t0Mbf/8sciV2MKK43E+ZVcZ9zseFi7RzxiCo7fD7Pgm8viT+gr2WfVh019s1jZSbTENcB55ZVyh61aVycOCVlnRsEEP3pEWyKKPSrwpbAj3To6xdUfSOib/pCvmuXVaUyZQ2B1ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqzVt+GIk+3cjvZmHyIY2+ATVlI26G7NN7ZJ0dXcKes=;
 b=C2373UzllLn2Gc3yVmoOOsPAe52lDShtBBGjHPhiGOdpFHq5u+/WhkI5vJTH23BvuWqurA+2X1dAB5ZbjdONq2Tg9rfAj0QL5ucRfATTh0eMMmSjpxPswraaww9IM1OOghiIe49fNlXNVr3rOTOG9WDfGvHACTWYtO56zUGXr/4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8137.eurprd04.prod.outlook.com (2603:10a6:10:244::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 31 Mar
 2021 07:43:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%5]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 07:43:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9OwgAAITACAAT8a8IAABYcAgAABmVCACCsMAIABO0DQ
Date:   Wed, 31 Mar 2021 07:43:30 +0000
Message-ID: <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
In-Reply-To: <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6faee7b2-77f6-4f77-5f0d-08d8f418ae13
x-ms-traffictypediagnostic: DB9PR04MB8137:
x-microsoft-antispam-prvs: <DB9PR04MB8137B93D292FF8218859ED8AE67C9@DB9PR04MB8137.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4iV86BkBMz3/abCOdYl6ZHIO9Xf5X0GjCXxLaZERZK1lEWrp2hm28XUlpMKoGdfTjGTvofXVbwEhnFq8huyQUUfHTVE5s5O2fij5Uyk/z/LLoe/pxtO18H/pFMzN3Hs8uE6b8FY3CmagSuwcS7o4QnRpymYT5U6aO8U2s44NMG0b3ZdGAI4N/UTWjTxyG4zPUoW6j/gHcDdOTcIKeQnM8QN+NkSmoENETVSo3WvKaVNLXD8Tapp8qMVA+7ccQC+X6KD4iBN08Z0t+9URKqHEV1Iq4CEJTNPeGUDkAsgOZl4JcJa1XfUy5MgLrntkUkg04od8Bo909ym9XssZsVoCFfPMTO8CvJcQ5SGzkC+XK0XD/4oM+C8CAb53v3F/17uADaNBPsCkCg12yu00skTVwCatFXIbwxZhrk1VjUHZ7Om2id9kISy3SHwkxlscWL9lpz2KtqG5p91LOzC0iP4PE5sZuq5kwHs5YKXRhQCG+q0vtcN6wamY6raI9xVzdOZeudlCGuPc97HUWJnuuR8n8PfgQm7bF++ve0UftaWObLMrNx+QDfn0U9Uuw/bvbtkz5alZPBtoIf0XsFzzOTPrmcKP/E7FVHQwnL33EzQtf49fYZNgCFSUAEVUhjifCC4mjTriJs41dh/j2EiU0RZIZYqYeBnZ9GoB2m049KnCg/o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(4326008)(76116006)(6506007)(186003)(66946007)(53546011)(38100700001)(71200400001)(52536014)(26005)(7696005)(64756008)(66446008)(498600001)(86362001)(66476007)(66556008)(83380400001)(2906002)(55016002)(9686003)(6916009)(8676002)(8936002)(5660300002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R1htL1dveGdFWk1FMWlnZmx1dzJHYktMUElkQ29zcklIdzVnZkxTYnd2RHFF?=
 =?utf-8?B?aHNaYm5rQ0xsL2R1N2VkMzNWWXlpYXBwU2N5anJibGlra1BkRklsaXd4RmFw?=
 =?utf-8?B?NlROdFBwWFVQUm1FSTZhVklwMDdCRjhURktVcGlPM2VFbTlKejlWeEhiMHpV?=
 =?utf-8?B?NGlaZVlmUWcyazRjbXdCWncxeEsxQWtrV1BHd2gvYXQzNEdGLzlwRkFFSFBj?=
 =?utf-8?B?ckh5NFczdU5paTRXWDcva0ZvMjJUbUNBZnFJZ3l3bFA1SllhTWYrNEdhRlBN?=
 =?utf-8?B?ejkzb0hZT0tIdGFqUU1Ud1FLMnA2VmZUcTBlU2dmanFnOUxxWVRvVUQ3N0tL?=
 =?utf-8?B?WDdZWWxJZ0hCSDdJVzVMbmtvVUczTWh1TW8yUitlNVUxMGNWOHFCWVFFNXVY?=
 =?utf-8?B?bG53cnEvQXVBRjFIME4rV0tmNnRkL3lSRkZvNVVtV3FZVzFBWXRjOFdTRXVy?=
 =?utf-8?B?dDdKYlcrTG5OQlo4b0xwSitBVGl1RmJRY2tEUHJTVjFtRXFXOXFHSkYydkU5?=
 =?utf-8?B?Nm9QSFNld25QMm5MaWYrYjdscG5MTW5BZmgzNExUMW5tR3JyRFNTSE9TUDhu?=
 =?utf-8?B?ZzQ0WXJhTWx2Y05TaHdYbERHcHVlZXQxYlhlSnM2OHpxOVhJN212cmRiWlBU?=
 =?utf-8?B?SXZJSjRkc2VoNmhXNm5TSmFvZ0JybWFzQUozWC9IZWY2Z0xkZGZ6bG9LWjdN?=
 =?utf-8?B?SmhnSXl5RExqUXVRUVpvK0d1cXdES0szMUFmYXVkcEtKek0reUlJZFBDb1kx?=
 =?utf-8?B?b0JmZGhwTGRzVHluZXNPZVBEMTBIS0tXcXBIRE1SQXFjeW11eEFnMHMyUVhk?=
 =?utf-8?B?cyswYTJQRWhtNHNUQndKa1RKd1JNUzJ4QU5ZaE1ZSzJlNzRMQmYyR1ZXZTRU?=
 =?utf-8?B?ZUNIZEk0L2JYVkF4c2hyNmRUcEVCR0ZtZWlWb2FzNnJKS3BBcGliUGE5N2lx?=
 =?utf-8?B?RFh4MFFpc1k4RXR0WmlhYi9oYVlYMGdnVzl6dExYRmNUYmtTT0dlUFp3dk51?=
 =?utf-8?B?N1lUYktKQUJyeWk0WFlqYWoyMWZVdDBZTTBUWWdBVnBoYUJCVlFadXFBRThY?=
 =?utf-8?B?b2NSOEUvNFdOQVEzNWJ3aklKK3MrNVJKVitZNE5FVTdrRW1RSEVHOCtFWktR?=
 =?utf-8?B?bEVyaUlRZ0FTVlpzd3pCa09SaHN0bVl1TDFJQXU3Q1NGZjRZK0NRbFBRZ1dq?=
 =?utf-8?B?MDNWWkR2V0NnVEF0ZldPV2FnZUJKVmxKOXh4YzlCOTVRaE1ZbUVuQW9JSW03?=
 =?utf-8?B?endWZnE1M29sM21LTTJ0eGx5NlJtb1RISWpnWHNlOXJjeW05aUY1b1lvb3ls?=
 =?utf-8?B?S09KekRBOVc5dkJPV0RKb2tEY25DVkZUM3RMUjhQaEl3Y0dTYjNIWjBOMHpI?=
 =?utf-8?B?dmRSSGtrbnVUMURwWXFiTmJNZUxCTXlEUFM0dlpJL3FoV2RKaHlCemNlUVE1?=
 =?utf-8?B?WjlXRDFuRVo0bTdRd1VTSFIvU3QyVWdlSU5BaGJ3cGxHbFJhZDdUVmR5SmNK?=
 =?utf-8?B?RHUxSHFNc1czaXVpRkF3S2lSQnBVT1VqNnovSitzem1yZlFxVDdCVEhTenVY?=
 =?utf-8?B?Uno4dkFyd1lsZXgweDlPWjJCaC9DbEdRKzJCM3V5VzdVTmxkeVpPanBEc2Vr?=
 =?utf-8?B?NW1EQmdMd0pEOUViUW9UUVVSOHJxVnhNWDd6aG1uRmVlSEJFMFFyMlJLbWs3?=
 =?utf-8?B?Ti9xRkJvRE9kL2w4aytkTTN5cTV3WTEyNksyejJleHlrUFp3VjhDQUFEcktN?=
 =?utf-8?Q?Y+ElFA6YOLu2vJtQOG/IyIudjkSzsAPqsyx8coY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6faee7b2-77f6-4f77-5f0d-08d8f418ae13
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 07:43:30.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2FkBBJseMBd9MsTcKFI/0j+TkG8h9IUAH1UvHx5FXk5oTt4ox5Uot6Y9zDdYfOrOyRJj/KaBhxo2h4sO+Oeew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0M+aciDMw5pelIDIwOjUxDQo+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IGxpbnV4LXRlZ3JhIDxsaW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+
Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogUmVn
cmVzc2lvbiB2NS4xMi1yYzM6IG5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBt
YWMNCj4gcmVzdW1lIGJhY2sNCj4gDQo+IA0KPiANCj4gT24gMjUvMDMvMjAyMSAwODoxMiwgSm9h
a2ltIFpoYW5nIHdyb3RlOg0KPiANCj4gLi4uDQo+IA0KPiA+Pj4+PiBZb3UgbWVhbiBvbmUgb2Yg
eW91ciBib2FyZHM/IERvZXMgb3RoZXIgYm9hcmRzIHdpdGggU1RNTUFDIGNhbg0KPiA+Pj4+PiB3
b3JrDQo+ID4+Pj4gZmluZT8NCj4gPj4+Pg0KPiA+Pj4+IFdlIGhhdmUgdHdvIGRldmljZXMgd2l0
aCB0aGUgU1RNTUFDIGFuZCBvbmUgd29ya3MgT0sgYW5kIHRoZSBvdGhlcg0KPiA+PiBmYWlscy4N
Cj4gPj4+PiBUaGV5IGFyZSBkaWZmZXJlbnQgZ2VuZXJhdGlvbiBvZiBkZXZpY2UgYW5kIHNvIHRo
ZXJlIGNvdWxkIGJlIHNvbWUNCj4gPj4+PiBhcmNoaXRlY3R1cmFsIGRpZmZlcmVuY2VzIHdoaWNo
IGlzIGNhdXNpbmcgdGhpcyB0byBvbmx5IGJlIHNlZW4gb24gb25lDQo+IGRldmljZS4NCj4gPj4+
IEl0J3MgcmVhbGx5IHN0cmFuZ2UsIGJ1dCBJIGFsc28gZG9uJ3Qga25vdyB3aGF0IGFyY2hpdGVj
dHVyYWwNCj4gPj4+IGRpZmZlcmVuY2VzIGNvdWxkDQo+ID4+IGFmZmVjdCB0aGlzLiBTb3JyeS4N
Cj4gDQo+IA0KPiBJIHJlYWxpc2VkIHRoYXQgZm9yIHRoZSBib2FyZCB3aGljaCBmYWlscyBhZnRl
ciB0aGlzIGNoYW5nZSBpcyBtYWRlLCBpdCBoYXMgdGhlDQo+IElPTU1VIGVuYWJsZWQuIFRoZSBv
dGhlciBib2FyZCBkb2VzIG5vdCBhdCB0aGUgbW9tZW50IChhbHRob3VnaCB3b3JrIGlzIGluDQo+
IHByb2dyZXNzIHRvIGVuYWJsZSkuIElmIEkgYWRkICdpb21tdS5wYXNzdGhyb3VnaD0xJyB0byBj
bWRsaW5lIGZvciB0aGUgZmFpbGluZw0KPiBib2FyZCwgdGhlbiBpdCB3b3JrcyBhZ2Fpbi4gU28g
aW4gbXkgY2FzZSwgdGhlIHByb2JsZW0gaXMgbGlua2VkIHRvIHRoZSBJT01NVQ0KPiBiZWluZyBl
bmFibGVkLg0KPiANCj4gRG9lcyB5b3UgcGxhdGZvcm0gZW5hYmxlIHRoZSBJT01NVT8NCg0KSGkg
Sm9uLA0KDQpUaGVyZSBpcyBubyBJT01NVSBoYXJkd2FyZSBhdmFpbGFibGUgb24gb3VyIGJvYXJk
cy4gQnV0IHdoeSBJT01NVSB3b3VsZCBhZmZlY3QgaXQgZHVyaW5nIHN1c3BlbmQvcmVzdW1lLCBh
bmQgbm8gcHJvYmxlbSBpbiBub3JtYWwgbW9kZT8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo+IFRoYW5rcw0KPiBKb24NCj4gDQo+IC0tDQo+IG52cHVibGljDQo=
