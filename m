Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CDC34FF4A
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhCaLKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:10:48 -0400
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:54791
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235024AbhCaLKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 07:10:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frgrt5VvCPnCePTWpA4gDmPDJHmUigKUyVZfg41hSftyi/AeIz2j4/gcJZnZ1llfWZL3ogahHyP2Cs2wGlJwKtjuJs0Hh+y6a/I0Y47JUHHZ1JJyhDP+ywjzFBdobBZwI3OCkU49sGOjUt5i3O2vVZtOCUtUjzre1YuI3qHmkVrO+K2TAkE5uXjmnljJMh3T28zrB0hgARkT3mW4d3iMye/KRgYlpVbxxcGjnrObxvsVVlU0uJ9Gmm8HkgLKHaLES6kdhRijuGBi+zP2jPrjPBSanAjrlbQI0Kdt3UYZgWso3xB6CDFYp2o6QvD+/kTUBpa3WFIg3xYvpODLQ2ABcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi6ZGw5C6BvuIxNNQa9/GuyWieExFqoTw0Oi+WJjCQA=;
 b=MS6zyY8jgWucJa+itgk3L1ApWhiv0KsT9WWTPJKmQXXQ8GjxWUvsHsjUvudLnCClD/0nYjEZYqh9wH2MaADg0eLNvrN+g3h4nJrTDbtmn6g1QW/ASKc0oYex89jk1caECZ83F3RX4XDFJOdI4iUgnTBHDJWHf4N34hmGEQ1d8NSNjhTLC2IHMlPPTghofcFFPCusZ6JCjaoMqznB0Q8PgxZSp/0fm2S5nWijY2W79n3XkpzZ9TSdi/KeJTXr0s+9rglMrUINES1lDPEK9Wp/DmSJB8gRG+4GnAYfTvHoZmVmWR3rGDI5rWyZvfwV5WBvHtgx10QXDoBFe/xpu3AkVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi6ZGw5C6BvuIxNNQa9/GuyWieExFqoTw0Oi+WJjCQA=;
 b=CE/bt5fV/zer3yAwBEtqyqUsIMxrpumt5nS0K5kGrWMqEZt40xR44Yw9sRmTEkm9o5gX07f1aF00IpCLxaJ5Yhg8N/EJx5oOcQndFBKZpDBdDPI4ZB+3vvabPzbV5qYklXkxmXc6qizlnOgoxm0iVLDSNYiRn+TVJ7fmtiYoAUg=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6970.eurprd04.prod.outlook.com (2603:10a6:10:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 31 Mar
 2021 11:10:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%5]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 11:10:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jon Hunter <jonathanh@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9OwgAAITACAAT8a8IAABYcAgAABmVCACCsMAIABO0DQgAA346A=
Date:   Wed, 31 Mar 2021 11:10:14 +0000
Message-ID: <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ce254fb-cef5-4c37-2cde-08d8f4358f40
x-ms-traffictypediagnostic: DB8PR04MB6970:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6970922E63829B9CB3412E79E67C9@DB8PR04MB6970.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ekQFJPhOqnpqcYyA/h22J6OQIYq265TsYQwFkUr0unu/ov+h7LjyHX6/g3Cc56OBXhFfC52nsoQ8HXtrOgmcLS/+/l6vxgRT25WiCmGY3lf7FplaXrQjOPlBIAq96APqBpuhT+Cy9KFGZeMlMd003+FvRZs0xLFlvo4R7FerKY14wet/dvnm23n6SlHanBIJRgqPTdzG3kLJ2dsg1Di+DmaSK3O2p+U7uX3+uTWoB9ymSkume4c9ziqwUdKDHkqvHXhVrBC7kHLfYY+ZAsLmgdTGDxiEr40EAxdeA1fFqH16IKlX8MWB23Ufh3W6ix14YWRrlmxGs/nkdUGjxUrju2p0pKxDr+uAeHT3NbFvp0wxQooDqqR8sosbRW63NGq8D/13vdUf0XqDhZbUk4Sa7NJBlNh2Yuf6xurT8qTwr/tsaMOoO8FFHP8LuwrTnqjW01Fdo0B51zX37ynGazexryT/2inu5RuVltSz3eI/LyuufZquSrhgxRkhFVnfT6xBWlRsmqwqdpn70U8uWjU9gl/khN5zr6Lz4FtFrfqD0/WLIm5EbDPJ55L9IXrk9a1+D8KNYaVkVth/sxSGBtJN7QjHJm5/6u36ZoaUXOFPA1v5wZmaxa0v3IiGRIWYeQGM7Op5MORm7XhFGC4nBlqvZPgUJty9017HuhRI+gB9d4c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(2940100002)(86362001)(83380400001)(498600001)(8676002)(66476007)(9686003)(55016002)(33656002)(2906002)(8936002)(6506007)(5660300002)(66446008)(71200400001)(64756008)(38100700001)(7696005)(26005)(186003)(53546011)(110136005)(66946007)(76116006)(54906003)(4326008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WWtHb0dLblQ0NWRqSjJiNG50V2x2MTRzUk1pVERIb3htUDR5NEcyaTNsZ2xO?=
 =?utf-8?B?UHlJeGFSN1dZZzBCVk9XVWdMbkdxWm1VZFFMc3I1Y2wvVThZRVR5UGpGYWFh?=
 =?utf-8?B?djViQ0xOaVVaakh0bkJ6OHNNcjcwcXJnR1RRdGR6M212emgxcWM3ZUc0ZHZn?=
 =?utf-8?B?Vzl0K1pYZkEzNmtjMHRNUnNpOEo4VVdBZnBuNG00VnZWZ25RYkF3OWpxYmht?=
 =?utf-8?B?TG9zZE9adVJPN2JZbVRLZzdQZU9hcjl2d2hGS2Vob3N2cXU1NE9HcTZiKzgv?=
 =?utf-8?B?cklHdlB4Y1N1aFpvVEN2OXJWTFJNcG1yNS9kNGJ3V3JITlRicGl0MFZnTEJw?=
 =?utf-8?B?bkM2bWgycnFoS0JDTTJFU2tpd2FoNUtrak91UFIyUmtxTjA3NDEzbEhYaGly?=
 =?utf-8?B?MGJYak5HUURRcEl2b3d5aFNwRkJEcmtHMnErREFZaTdBVEZ6VjlWdENjNWpm?=
 =?utf-8?B?MllSVmZYaUkvVHlHeUJLZXRTeGNNVCtsc1N6cEtuSFJZbnd1WmJvZzB3cTdn?=
 =?utf-8?B?ck42RHk0QTl2NHlweVNBM1MraUswNjZnTGQ2RVJkSmkwaUp3Ni9zMTJqczVN?=
 =?utf-8?B?Yi9iWjZaeHQwYllYUU9MZGk1RkYyU1dmRHF5UEIxTVFJVEpWT3I5Ym9Ubisy?=
 =?utf-8?B?Z2IrMEZuME5vQkg0NDlNYlRmOXVZbzZCR1g1V1NRVVJlKzdxMUREOE9RSDVY?=
 =?utf-8?B?VWh4b2NtdUh0T3d1UFQ4YnZIR293WHFBbDJVNk1vQ1dVa25zRmV0TlVZQTBL?=
 =?utf-8?B?aiswWHBXenp5TGh1WFlsWGZuRmZsOFZ4a0UrbUN2VEpPZ1hic2dxWEovQ2Fi?=
 =?utf-8?B?R0hqa3FXK2JUcHdUVE5TWnhHZmlLYUdpZTZSVHdXNlhzU1B4d2NNTU5MNHRP?=
 =?utf-8?B?VzJXaVQzeHNhSTZwbDEvenMra3dYWnpPcS9NeTZ2MTZoRGFwdkNNRjE5aTVp?=
 =?utf-8?B?T1kxTjBvN09CSE4xTytXWXJtbC9MZTQzY1d0YTBHYi9mOGpNS2VJVERBeVV2?=
 =?utf-8?B?c041QkxoTnZMaDNKNnZVQlI1aldRYSsrZDg1bGRtZ25tNmZoc2JUTXluY1FT?=
 =?utf-8?B?RVR4M0ZFVGcrT1FTNG9PU1V2cyt6RVpuRHlKMGdxcVpYMWtiMGhuNmRNMC9j?=
 =?utf-8?B?UlM0TnNSRitTcU82N1VqdnV4NTNkanFtcFhNUVI0WGt4Mk5PNHVsa25kUU44?=
 =?utf-8?B?K3VHd0lncEQrNCtkbG90VDNGeFdmdnB1UnAxOFQyamtoaHI0NkRCeUdTMHQ4?=
 =?utf-8?B?cnVXRFRZU1Q1ajVXcjJqR24xR0xDZDM3MUNlUkpBM1J1NWVJRS9KUTh6Yzdx?=
 =?utf-8?B?Z2lScGx4MFlkTlM3UTErUVdteUxRaVV3N2w2Tk9Bc2ZjbkV2ek0xNFArR2RY?=
 =?utf-8?B?ejZkWjJoSkF5TG5CalhGZUk5MzJUUy9yZHFmL09xdmV1ZWFwYnBzTXl3eDZC?=
 =?utf-8?B?L0R2ZUhaSldMblFaV2VTWDJ6ZlFZRGdjWVJsRWU3WjZVdVJxWHhRN09WR1Nm?=
 =?utf-8?B?djlYOGlSRnlpWkpsMUZUSlNGNHJPd1Vtc1JkaFMwaHRueE1VMW5HQVcyajMx?=
 =?utf-8?B?d0V2c2d3Ynlob3ZIZk0wVEVOWTFFWGhQWUI2WFFteUdsMWE4VmNnYTh4L0cy?=
 =?utf-8?B?T2RqQWg1OUp4RVZyZVlLc2hGVFkyMFRDSmphQjlqMmFLVGtHeWNTV2JRb2Rl?=
 =?utf-8?B?aXI2RjI2bE0wTGpWUE1qbmJ2clZIdnJaMVV3ZlI5M2grZkF5am16UmpXdThI?=
 =?utf-8?Q?SW0XNUSry9yzjIbmTPzRqZooVF4Tk+xGqCEZ3Pk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce254fb-cef5-4c37-2cde-08d8f4358f40
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 11:10:14.4934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i9i9abA7TpxSLYvoJ2UILq6jDcK8vps2mlBUPW1VxipD/uQv4Bzq4aifjcTzBFGsdtWHfdYmLip3P1C575CJzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjHlubQz5pyIMzHml6UgMTU6NDQNCj4g
VG86IEpvbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IGxpbnV4LXRlZ3JhIDxsaW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+
Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSRTogUmVn
cmVzc2lvbiB2NS4xMi1yYzM6IG5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBt
YWMNCj4gcmVzdW1lIGJhY2sNCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4gRnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQo+ID4gU2VudDog
MjAyMeW5tDPmnIgzMOaXpSAyMDo1MQ0KPiA+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBMaW51eCBLZXJu
ZWwgTWFpbGluZyBMaXN0DQo+ID4gPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51
eC10ZWdyYQ0KPiA+IDxsaW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPg0KPiA+IFN1YmplY3Q6IFJlOiBSZWdyZXNzaW9uIHY1LjEyLXJj
MzogbmV0OiBzdG1tYWM6IHJlLWluaXQgcnggYnVmZmVycw0KPiA+IHdoZW4gbWFjIHJlc3VtZSBi
YWNrDQo+ID4NCj4gPg0KPiA+DQo+ID4gT24gMjUvMDMvMjAyMSAwODoxMiwgSm9ha2ltIFpoYW5n
IHdyb3RlOg0KPiA+DQo+ID4gLi4uDQo+ID4NCj4gPiA+Pj4+PiBZb3UgbWVhbiBvbmUgb2YgeW91
ciBib2FyZHM/IERvZXMgb3RoZXIgYm9hcmRzIHdpdGggU1RNTUFDIGNhbg0KPiA+ID4+Pj4+IHdv
cmsNCj4gPiA+Pj4+IGZpbmU/DQo+ID4gPj4+Pg0KPiA+ID4+Pj4gV2UgaGF2ZSB0d28gZGV2aWNl
cyB3aXRoIHRoZSBTVE1NQUMgYW5kIG9uZSB3b3JrcyBPSyBhbmQgdGhlDQo+ID4gPj4+PiBvdGhl
cg0KPiA+ID4+IGZhaWxzLg0KPiA+ID4+Pj4gVGhleSBhcmUgZGlmZmVyZW50IGdlbmVyYXRpb24g
b2YgZGV2aWNlIGFuZCBzbyB0aGVyZSBjb3VsZCBiZQ0KPiA+ID4+Pj4gc29tZSBhcmNoaXRlY3R1
cmFsIGRpZmZlcmVuY2VzIHdoaWNoIGlzIGNhdXNpbmcgdGhpcyB0byBvbmx5IGJlDQo+ID4gPj4+
PiBzZWVuIG9uIG9uZQ0KPiA+IGRldmljZS4NCj4gPiA+Pj4gSXQncyByZWFsbHkgc3RyYW5nZSwg
YnV0IEkgYWxzbyBkb24ndCBrbm93IHdoYXQgYXJjaGl0ZWN0dXJhbA0KPiA+ID4+PiBkaWZmZXJl
bmNlcyBjb3VsZA0KPiA+ID4+IGFmZmVjdCB0aGlzLiBTb3JyeS4NCj4gPg0KPiA+DQo+ID4gSSBy
ZWFsaXNlZCB0aGF0IGZvciB0aGUgYm9hcmQgd2hpY2ggZmFpbHMgYWZ0ZXIgdGhpcyBjaGFuZ2Ug
aXMgbWFkZSwNCj4gPiBpdCBoYXMgdGhlIElPTU1VIGVuYWJsZWQuIFRoZSBvdGhlciBib2FyZCBk
b2VzIG5vdCBhdCB0aGUgbW9tZW50DQo+ID4gKGFsdGhvdWdoIHdvcmsgaXMgaW4gcHJvZ3Jlc3Mg
dG8gZW5hYmxlKS4gSWYgSSBhZGQNCj4gPiAnaW9tbXUucGFzc3Rocm91Z2g9MScgdG8gY21kbGlu
ZSBmb3IgdGhlIGZhaWxpbmcgYm9hcmQsIHRoZW4gaXQgd29ya3MNCj4gPiBhZ2Fpbi4gU28gaW4g
bXkgY2FzZSwgdGhlIHByb2JsZW0gaXMgbGlua2VkIHRvIHRoZSBJT01NVSBiZWluZyBlbmFibGVk
Lg0KPiA+DQo+ID4gRG9lcyB5b3UgcGxhdGZvcm0gZW5hYmxlIHRoZSBJT01NVT8NCj4gDQo+IEhp
IEpvbiwNCj4gDQo+IFRoZXJlIGlzIG5vIElPTU1VIGhhcmR3YXJlIGF2YWlsYWJsZSBvbiBvdXIg
Ym9hcmRzLiBCdXQgd2h5IElPTU1VIHdvdWxkDQo+IGFmZmVjdCBpdCBkdXJpbmcgc3VzcGVuZC9y
ZXN1bWUsIGFuZCBubyBwcm9ibGVtIGluIG5vcm1hbCBtb2RlPw0KDQpPbmUgbW9yZSBhZGQsIEkg
c2F3IGRyaXZlcnMvaW9tbXUvdGVncmEtZ2FydC5jKG5vdCBzdXJlIGlmIGlzIHRoaXMpIHN1cHBv
cnQgc3VzcGVuZC9yZXN1bWUsIGlzIGl0IHBvc3NpYmxlIGlvbW11IHJlc3VtZSBiYWNrIGFmdGVy
IHN0bW1hYz8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IEJlc3QgUmVnYXJkcywN
Cj4gSm9ha2ltIFpoYW5nDQo+ID4gVGhhbmtzDQo+ID4gSm9uDQo+ID4NCj4gPiAtLQ0KPiA+IG52
cHVibGljDQo=
