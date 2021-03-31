Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8480334FF9E
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhCaLlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:41:18 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:63296
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234995AbhCaLlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 07:41:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtxAm/cBiAN6cHE/k+inlluYMLLJWfE+9XsqIzj3okbnY1i0q/hzkKuDqH8tXcn5B3+ANwkwA4krIVq99XQjx2MwEvc7HEYMsyDMU+dLi7HrwyMuz04uJGrPOlkGedm7m9UeJfpBmseIbAW0HWubYCpyt39NvHsL4SoXFcHjNYwBqFubxML0n8LH65pKvqwd9Y9/dZZk28/lJslFe0Gt/tgYRPTE0dgeDNVeLqwasHcPXMN1yajCmLDjNZ4vlCIPwx9lT0EniVuh6I/L61Ql6pvZrlta1Jl4LPaEkwTQEciy6Xcd+MDJVHUnTUsv5YKE8m1EmYUKA1oRfzMbDxFC2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUBfL5FEwE4VEBeOefnf8oeDetv2tHAjhcUZemJwX20=;
 b=Zqi7b6mOH3TQQH9N/iW3TwJ2Ll21F/DpQl54ZkHKRm8gUyjc/6hqSdhuMZ3VZ2Ie/IbrQ4movGozk2EPUzEuPxDxEIsPUlTAlVQYaZ8jDzQn13I2UCGMThUeUkBqd3M/Ah+1pqKGVQaAfDjEPUEPRmXC9Zm6QOk9kgA4zuL4ymSbYTXvBP/pTninwhN/RdlA5vKbws+6qeSjtXjp/GCBIe2w6U872IxtlVRv6jtNJ4b85w++pjNc5+2ruayrNZ8LMH8WFv8Q5VYleMvX5IHn8zLiNiKualh3xXMk2/+nPrliskiDCHQUpvGfsQty6YXRWuWBi4RzP/PRwLbobFt9Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUBfL5FEwE4VEBeOefnf8oeDetv2tHAjhcUZemJwX20=;
 b=GkmosbJnckpnZdeuNIrxo5hga6ZVLXlaHt5DI8wsHnzQ8o7JuCd38RMT3wBnBD6+e9eDC7K1Q880jgZKrXSZNYcPXEoGmWm32JblZcRKHcWDqma0YLorxWxc/F4Ki0ursb1ZnX6UbI2qbiDD6yTANg08SUU3GhKr5wRyG7XJm4w=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7429.eurprd04.prod.outlook.com (2603:10a6:10:1a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 31 Mar
 2021 11:41:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%5]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 11:41:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9OwgAAITACAAT8a8IAABYcAgAABmVCACCsMAIABO0DQgAA346CAAAhZgIAAAU1g
Date:   Wed, 31 Mar 2021 11:41:00 +0000
Message-ID: <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
In-Reply-To: <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9e815c66-86b1-4164-9ca0-08d8f439db65
x-ms-traffictypediagnostic: DBAPR04MB7429:
x-microsoft-antispam-prvs: <DBAPR04MB742955C5A98E242FADAF6270E67C9@DBAPR04MB7429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VLpUlgj+AVzpTRLEHTkfxSYWE8K8HfLOGuQQu1oVJaPFA6NYiA3ul9cRx9O9HjUQd/w+P2InWQKInTVj0NYtLy3p6uyRxIYMlAIbbJ32hivY66Aj7sA4o8jTjxCsQNhlpHCDuZZXqGMLMTwq7C5FXpU89j2gae7PF38QvTCGLA5yQoHVdIygdUEu6G1EfELO2pzcB0u0AFGmQfSpiWc77X3wMrJS75SNsDyQsFPMLHth0/3UzeIKfqDWGLBzwrHVXQxD/WzRLVRMbyC2iCBlqVts1XRdWdFxBj1njnpfvLirXP7U5CP6G/q13PX23L698VNLX4a6GmWvFhgArSCsR+YoQnrI5fOM1uAN4TEbnqscCUizieW3vhGB6/t/xrt9oILUiKHg336sYQH6u5KJ/2PIQn/WPMRlPIbGoyLJLvoFYbj+Ad6BQiBcFv0Fhb/hW02opKnTfycnwhigd2uYJfidqBdCOpOD+5jltYBMZm8FU3Tzw7kNCw+TQcScScVTtQrl176Rl437xJ6uB/sYUL3nxav90KZxDaZehVw6ezv784LG9IbPOMXwJpXhMdS661NDdKBtyd7dToolZ/XglhxAoX81YQ/DF+bIUuMeCoi83UGZFfdHLdW6GWePGRJCxHVGw5+tk/XaLQDjWpfX9yP92FeunNrON2ioOOKM2cs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(86362001)(76116006)(83380400001)(498600001)(8676002)(4326008)(8936002)(9686003)(55016002)(33656002)(2906002)(6506007)(5660300002)(71200400001)(7696005)(38100700001)(66446008)(64756008)(186003)(53546011)(110136005)(54906003)(66946007)(66556008)(26005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RjNoRnR2dFJzMzJKRFArempzbENLUUdLb0V4L05BajJRV3lIMUVYbjdJZG43?=
 =?utf-8?B?VW9nMDBOb2MyVGlGcWg4T3E1Y25OOWFVVEdJT2MzbGJwd005TzlhaDQ4YXE5?=
 =?utf-8?B?UnBneExuMnNWL2JQcGk2aklDcG9UdkpkQndDVDNlU2NKQ2IzSzhQTnNvMks4?=
 =?utf-8?B?VGdYOUpPUkIxYlA2NXpsbkhlMHMvNkhaYVQyTkVzZ015ZHRwbWpEZmQ4bVFJ?=
 =?utf-8?B?WWNGdkJyWHpTYkhOSFRteXNrQk1qblZHbVRxb05CQVFBYXQwMTlyTldSZFZJ?=
 =?utf-8?B?cEFlL0ZmblNRYkJhQjk0K2NqREdzeDc2eDJjWjhMVGpYa2xmVldDQXdYUjRK?=
 =?utf-8?B?RmtCbHFLUkRuK3BSVlgxMkJHVkoyVWpkTFVJUlBqRmE4aU1XbFpFelNWWlFB?=
 =?utf-8?B?VWRFL3hXU3NRbkF4aHR5OVVMUCtYUnp0bHcwalpHVW9kOUlIOXU1WWtXWTFv?=
 =?utf-8?B?bVpZQjRVeU5yMnB3dlNqa1NJUDZneGJnR0hCcVFvRDRhQnhEWUROMHJDNzFP?=
 =?utf-8?B?cUcreGlVcGlnbEZWNVdhYzF1WUdUcS90c3FxWUVNNWtYMTVnVXhmTERvTThW?=
 =?utf-8?B?UEZ1N0xWOFZuY1lxdkpLNFZmK0dYcVVFR0pZNHFDUGtIbitUUkZTdzF5bllu?=
 =?utf-8?B?VitseHFnbTBIdUNBUjJwMWl1eXdzaEF4VGQvbllkYWxFOTVYWUlXbzhZV1RI?=
 =?utf-8?B?aVNjU0Jhdkl0aHZxZ2h6TEpkWVJseFV0RlBzemlsN0JQVk9GYlN0WXFXQ3Bx?=
 =?utf-8?B?UUVLM3Y4eUFzNGFSSFNqczhuZDU1bG5oOEhDRDZETHRpeFJXcGhhdTdVRXli?=
 =?utf-8?B?T3FsMS9DRWlGU3hQSWZpZzhkSW0xbTZjT1RUL280d0FUbVU2d3p5MzdmbmVX?=
 =?utf-8?B?RVRYMndGblppZFF1TmwrcGhTZ3RKcnhpV1hNbnc2Z3FGanh4Mi93VGlBM2FN?=
 =?utf-8?B?Y0RqcDRJaW04WW5RQk9ud0ZwSWw0bm50SDFnYmZERlNWSE1uRU1kcXNrbkQ2?=
 =?utf-8?B?T1BMaFkzNTZhaFdKWklvSXd5bUJZZnRPTUs2WXgwWXQ2WDB1dVZydkd1c21p?=
 =?utf-8?B?VVRkSVFvNGt5RXJXQmdIZWNEcmRPSVVCaTRsNEQ2Q0w3Mk0vWnB2TEE1eGN0?=
 =?utf-8?B?azdWUFE1MnJuS0dWTm5WRWc5OTROanFJMTFyTkRERm16TytRT0dWK3dHdHZR?=
 =?utf-8?B?YzNyVndYLy9BM0g0aDJlRElMQTZ5QkRZcHBMVUtsdmgvZGxJUDlMbGw3b0tH?=
 =?utf-8?B?eVFVR0ZUbm8yVTdQZTFEdThvQ05BQ1JvY1VzZzNMQmcrMGFwYXZzYVJJblpC?=
 =?utf-8?B?aTNuMUpmVnFLcitwbGllZzIyS0lZWXEvWXg0WG53QjQySjB0cWs3eHlsTHdj?=
 =?utf-8?B?VkpOenRsS3kwVGREUmtHL25kblE2MCt1bkJRbUxiRi9UaFZmdHQ0UTJ5SVhI?=
 =?utf-8?B?WEl2b08yU0Z5L2hsbHVKNi80M01RMHpEb3VHdGdoYU1qVW5uVDEvYzFzUU5s?=
 =?utf-8?B?QWx6WFQydlB1MWthUFdJSi9tc2hrK2R0dlphL2l2MXhncE9XTWR5c0FPVkNC?=
 =?utf-8?B?UTBKQlVTQ2o4RVVGbmxsUUFsL2lKWjVkbUMyUXZmZ0w2UkJaYWZKczFBTUY5?=
 =?utf-8?B?eW9VWW50Rjg2QkY4SWo5diszcDJpVU9nNWJOOXVvMlRVdkREVGRwbjhLbFRS?=
 =?utf-8?B?ZjBSMUJSOXkvUklqckxlbTREWDVSUXQ5VzczRkpaSUxlVnlUbTQ3MDNxcGF4?=
 =?utf-8?Q?FvUf3qtkE4cfFTkUAfasNphZL73chr/RwaoY7Cl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e815c66-86b1-4164-9ca0-08d8f439db65
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 11:41:00.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pW9bTT1TTRdMVoko33PX0HL3g2ZZ/0KHUqVxuqjMicAM+Nv4U7PeHqIamNYWmtqnu5Gd2S1+7iXUdq0eWOaNcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0M+aciDMx5pelIDE5OjI5DQo+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgR2l1c2VwcGUgQ2F2YWxsYXJv
DQo+IDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQWxleGFuZHJlIFRvcmd1ZSA8YWxleGFuZHJl
LnRvcmd1ZUBzdC5jb20+Ow0KPiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT4NCj4g
Q2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IExpbnV4IEtlcm5lbCBNYWlsaW5nIExpc3QNCj4g
PGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC10ZWdyYSA8bGludXgtdGVncmFA
dmdlci5rZXJuZWwub3JnPjsNCj4gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4g
U3ViamVjdDogUmU6IFJlZ3Jlc3Npb24gdjUuMTItcmMzOiBuZXQ6IHN0bW1hYzogcmUtaW5pdCBy
eCBidWZmZXJzIHdoZW4gbWFjDQo+IHJlc3VtZSBiYWNrDQo+IA0KPiANCj4gT24gMzEvMDMvMjAy
MSAxMjoxMCwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiANCj4gLi4uDQo+IA0KPiA+Pj4+Pj4+PiBZ
b3UgbWVhbiBvbmUgb2YgeW91ciBib2FyZHM/IERvZXMgb3RoZXIgYm9hcmRzIHdpdGggU1RNTUFD
IGNhbg0KPiA+Pj4+Pj4+PiB3b3JrDQo+ID4+Pj4+Pj4gZmluZT8NCj4gPj4+Pj4+Pg0KPiA+Pj4+
Pj4+IFdlIGhhdmUgdHdvIGRldmljZXMgd2l0aCB0aGUgU1RNTUFDIGFuZCBvbmUgd29ya3MgT0sg
YW5kIHRoZQ0KPiA+Pj4+Pj4+IG90aGVyDQo+ID4+Pj4+IGZhaWxzLg0KPiA+Pj4+Pj4+IFRoZXkg
YXJlIGRpZmZlcmVudCBnZW5lcmF0aW9uIG9mIGRldmljZSBhbmQgc28gdGhlcmUgY291bGQgYmUN
Cj4gPj4+Pj4+PiBzb21lIGFyY2hpdGVjdHVyYWwgZGlmZmVyZW5jZXMgd2hpY2ggaXMgY2F1c2lu
ZyB0aGlzIHRvIG9ubHkgYmUNCj4gPj4+Pj4+PiBzZWVuIG9uIG9uZQ0KPiA+Pj4gZGV2aWNlLg0K
PiA+Pj4+Pj4gSXQncyByZWFsbHkgc3RyYW5nZSwgYnV0IEkgYWxzbyBkb24ndCBrbm93IHdoYXQg
YXJjaGl0ZWN0dXJhbA0KPiA+Pj4+Pj4gZGlmZmVyZW5jZXMgY291bGQNCj4gPj4+Pj4gYWZmZWN0
IHRoaXMuIFNvcnJ5Lg0KPiA+Pj4NCj4gPj4+DQo+ID4+PiBJIHJlYWxpc2VkIHRoYXQgZm9yIHRo
ZSBib2FyZCB3aGljaCBmYWlscyBhZnRlciB0aGlzIGNoYW5nZSBpcyBtYWRlLA0KPiA+Pj4gaXQg
aGFzIHRoZSBJT01NVSBlbmFibGVkLiBUaGUgb3RoZXIgYm9hcmQgZG9lcyBub3QgYXQgdGhlIG1v
bWVudA0KPiA+Pj4gKGFsdGhvdWdoIHdvcmsgaXMgaW4gcHJvZ3Jlc3MgdG8gZW5hYmxlKS4gSWYg
SSBhZGQNCj4gPj4+ICdpb21tdS5wYXNzdGhyb3VnaD0xJyB0byBjbWRsaW5lIGZvciB0aGUgZmFp
bGluZyBib2FyZCwgdGhlbiBpdA0KPiA+Pj4gd29ya3MgYWdhaW4uIFNvIGluIG15IGNhc2UsIHRo
ZSBwcm9ibGVtIGlzIGxpbmtlZCB0byB0aGUgSU9NTVUgYmVpbmcNCj4gZW5hYmxlZC4NCj4gPj4+
DQo+ID4+PiBEb2VzIHlvdSBwbGF0Zm9ybSBlbmFibGUgdGhlIElPTU1VPw0KPiA+Pg0KPiA+PiBI
aSBKb24sDQo+ID4+DQo+ID4+IFRoZXJlIGlzIG5vIElPTU1VIGhhcmR3YXJlIGF2YWlsYWJsZSBv
biBvdXIgYm9hcmRzLiBCdXQgd2h5IElPTU1VDQo+ID4+IHdvdWxkIGFmZmVjdCBpdCBkdXJpbmcg
c3VzcGVuZC9yZXN1bWUsIGFuZCBubyBwcm9ibGVtIGluIG5vcm1hbCBtb2RlPw0KPiA+DQo+ID4g
T25lIG1vcmUgYWRkLCBJIHNhdyBkcml2ZXJzL2lvbW11L3RlZ3JhLWdhcnQuYyhub3Qgc3VyZSBp
ZiBpcyB0aGlzKSBzdXBwb3J0DQo+IHN1c3BlbmQvcmVzdW1lLCBpcyBpdCBwb3NzaWJsZSBpb21t
dSByZXN1bWUgYmFjayBhZnRlciBzdG1tYWM/DQo+IA0KPiANCj4gVGhpcyBib2FyZCBpcyB0aGUg
dGVncmExODYtcDI3NzEtMDAwMCAoSmV0c29uIFRYMikgYW5kIHVzZXMgdGhlDQo+IGFybSxtbXUt
NTAwIGFuZCBub3QgdGhlIGFib3ZlIGRyaXZlci4NCg0KT0suDQoNCj4gSW4gYW5zd2VyIHRvIHlv
dXIgcXVlc3Rpb24sIHJlc3VtaW5nIGZyb20gc3VzcGVuZCBkb2VzIHdvcmsgb24gdGhpcyBib2Fy
ZA0KPiB3aXRob3V0IHlvdXIgY2hhbmdlLiBXZSBoYXZlIGJlZW4gdGVzdGluZyBzdXNwZW5kL3Jl
c3VtZSBub3cgb24gdGhpcyBib2FyZA0KPiBzaW5jZSBMaW51eCB2NS44IGFuZCBzbyB3ZSBoYXZl
IHRoZSBhYmlsaXR5IHRvIGJpc2VjdCBzdWNoIHJlZ3Jlc3Npb25zLiBTbyBpdCBpcw0KPiBjbGVh
ciB0byBtZSB0aGF0IHRoaXMgaXMgdGhlIGNoYW5nZSB0aGF0IGNhdXNlZCB0aGlzLCBidXQgSSBh
bSBub3Qgc3VyZSB3aHkuDQoNClllcywgSSBrbm93IHRoaXMgaXNzdWUgaXMgcmVncmVzc2lvbiBj
YXVzZWQgYnkgbXkgcGF0Y2guIEkganVzdCB3YW50IHRvIGFuYWx5emUgdGhlIHBvdGVudGlhbCBy
ZWFzb25zLiBEdWUgdG8gdGhlIGNvZGUgY2hhbmdlIG9ubHkgcmVsYXRlZCB0byB0aGUgcGFnZSBy
ZWN5Y2xlIGFuZCByZWFsbG9jYXRlLg0KU28gSSBndWVzcyBpZiB0aGlzIHBhZ2Ugb3BlcmF0ZSBu
ZWVkIElPTU1VIHdvcmtzIHdoZW4gSU9NTVUgaXMgZW5hYmxlZC4gQ291bGQgeW91IGhlbHAgY2hl
Y2sgaWYgSU9NTVUgZHJpdmVyIHJlc3VtZSBiZWZvcmUgU1RNTUFDPyBPdXIgY29tbW9uIGRlc2ly
ZSBpcyB0byBmaW5kIHRoZSByb290IGNhdXNlLCByaWdodD8NCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+IFRoYW5rcw0KPiBKb24NCj4gDQo+IC0tDQo+IG52cHVibGljDQo=
