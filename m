Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65F93050EB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhA0Ea2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:28 -0500
Received: from mail-db8eur05on2081.outbound.protection.outlook.com ([40.107.20.81]:54897
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726665AbhA0Bt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:49:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFD9eTcFOHTOF3PnzVozP/D2WHKtW5Nc5PUW9v9LH7Q3tNKDADDHMpVUCHgCndi/E6SZ+IZo1xrYw4fKNC0HovtXxU8LbVzPX8qnmzw5swapcB1N+C5NTTa0RZ/Cesyn3e5aaRhFm7olfnKCahDdCF0sFzsmALugU3MPBWPq6dThTlJIa/YQk/SDxyZgsmY4CERtyfQPVVtgPgj3IMcV/HfKFL0sa+E6mqrGkQwrVtB1Y0BmjUQQtaifXKlJX5gki+J49viytFTgaWt8S4nrGFjFVY9PdoU8kwYY7ZwI6hZGuOPNmzLfw5WjI3o13TnkXcGbO0hoRWxEDuXpDJWDHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWHGtA93csDtvMLm8hVT24H0QTZhEqhDgKeF1Yit6uI=;
 b=PpznQUUFlHzyBrpCye/B0ZQKLGxp9UT6F3t4Ve9RkYfV7Zpo9CG4ntJAtGF5P/h+WeEgc68uztb17pR3oRHb35uBNdBbK7qP5HRF+sRxLcxd+y2UkvD5s3FzJPCYKCsCqhXEWamDQNPHxPsyEwaHfnuzKWdDKZJldzEV76lQfTd0mBQcplJIeK5WHsdPlUceyXjdS+R+4UVIhBB9QXrQrM5QjgcaUShb64MYD/i69RenVaVxWsPZqRbGKRNn/QgAvTB4QoEtpHmo8NlaCSDcLCaAKkbyR3AkRv5WdnmQKlvt2mZnPl/9FU+PGgaXAw8r4eWHciOBdKxZgKPBnjq5ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWHGtA93csDtvMLm8hVT24H0QTZhEqhDgKeF1Yit6uI=;
 b=eaWDsOlr1dtgPufcV7fngXfweUvqGEwQmAOsYeVSymT6aohhvgjeYM093EkIEeh77Z78V/QJfaA51Ea1ouRwkpdyuq9+tSaI8OCgSZqXweX6WuLsP33Xm3ENwafaZD1iI6RVviJtHbtTdp0wRf9V7DBVN+CH2p2sHx3vZULpghQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3705.eurprd04.prod.outlook.com (2603:10a6:8:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 01:49:04 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 01:49:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp
 clock
Thread-Topic: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp
 clock
Thread-Index: AQHW89q4ejRyIZ/fz0O9/wDN0TPK2Ko6gnIAgAArb9CAAAM8AIAABAMw
Date:   Wed, 27 Jan 2021 01:49:04 +0000
Message-ID: <DB8PR04MB6795548D04FC176ED9DBD29DE6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
 <20210126115854.2530-2-qiangqing.zhang@nxp.com>
 <CAF=yD-J-WDY6GPP-4B-9v78wJf3yj6vrqhHnbyhg1kx6Wc1yHg@mail.gmail.com>
 <DB8PR04MB67953865C100029E0088CE69E6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <e2f16f61-4f45-de76-65fc-272900cd14f7@gmail.com>
In-Reply-To: <e2f16f61-4f45-de76-65fc-272900cd14f7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ec701c3-aa76-4a00-1f35-08d8c265ba60
x-ms-traffictypediagnostic: DB3PR0402MB3705:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB370578C19832AA66996B5B75E6BB0@DB3PR0402MB3705.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Scp9N18/nsNOyLBEp1VXToCuO/JTdHN9cUqxTS9rHIEO9uEX+Dk7e0Mhi1nRW7rdG+oN9JPuH348dNe1BOrheQVsXuVBJ9qGFB0Q8QHaR/v9xFQ9g6aVYcrU6bOgTMICtT3MUe33NW9X7nvD3ooJeIdssaU3h6whK01GQtEAJf2TlfEusLfakchmvYTHFw1v+D2HEls0BLkbIH8v+HLNCoQgXcJB2GFmlDz82y8eKuWI3fVWec9dT6bFX78N6V8SaSTSRlvnjF98XZ2mwmHzWnYUp/p4cKRDimujHhVFzutKVx2G7H29rVJ6X9nn9glg5VRtDadwkW0dl3giKxw/QiMSbcPzx6kbWv3zGfw4EGJ3IlIsmKfJe9+kJ8rXFtuYzGVNwfL7GuIBpYI3tdt0nUB+7uSYssH4vKRlM/tjIWh+eTO5QeLBTzBkC/qmuIZeXrnyb/T0sO9OCa/HWuMXtlzRKGWTDnj3TFUXrgdSQLKofhvi3KGhfMrB26dCD8VnzgJ33ZZTjD0+pTlbKVIHqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(66476007)(83380400001)(54906003)(66556008)(8936002)(66946007)(9686003)(186003)(52536014)(76116006)(86362001)(6506007)(66446008)(478600001)(53546011)(7696005)(8676002)(64756008)(33656002)(110136005)(316002)(55016002)(4326008)(71200400001)(26005)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UlMyOEdWbCtlWmo0UGo1ZzgxR1cwTTc2NFk1QklsVlBzR01GeG12SGdadGF2?=
 =?utf-8?B?MFVvRElvL1hheGs0MjhaY1lncU4rQ1lpMXVtMS9IU205bytTTC80bGN0VUNx?=
 =?utf-8?B?WWloaWFNV1dxYlBJZ29FY0FuWi90VGx1Qm01UStEeUt4VlhsTThReTMrUlgr?=
 =?utf-8?B?V0xwTzdsUGhmckdvMDczaXRTWU43MFdrcWZvdTZJNTlhdVV1SEF5M0FNbENp?=
 =?utf-8?B?bXFtRmloUld0V20vU1hCd01JTkVGbnIwS1VOVmNPWjgybFhnQ1BkY1VQb3lw?=
 =?utf-8?B?STdsY2xsMDdCclIwT0dvb3pyaDRQa2pVM0J3eTdRUFllVjJDcG9STGZydzJ2?=
 =?utf-8?B?Vktyci9HUWNsb0pFS015RWErakdLSlVzbDgwQmNnWU8rZ0ZJb2puZWZDUkQ4?=
 =?utf-8?B?NlBxaWdPUU8rOTdLalUrd2RubXdKR1phMi96Vm0vTWhnM0l5SkpMU1d5WUh3?=
 =?utf-8?B?VVRzQzVqNHY4UHRMQlczM1dzT2ExMzFLVkZVbDRsNkZvSXoxQkEydDU3LzYv?=
 =?utf-8?B?Sm5VWDJkNlpyY1VPY2hmbUd1UWMwc2ExMVo0RHV4TXdYajg1ajFES1drRHN4?=
 =?utf-8?B?UkdaenVWY0EyNzZCa012VW1DaFF1T1dNUTRSZUYyd2FYeXd2eXdDMHROeURp?=
 =?utf-8?B?eXRHejE5SzhmQUZrY2Q2M0pha3Erci9nVVI0VkdhVytZaDdod0xrdGtVVDBy?=
 =?utf-8?B?OUFQRnJoYU9CR1REWVpmQVpGdFRjVThNd21JU2dvQkNYMlVzRFBhaFpmRVp2?=
 =?utf-8?B?MzN1ZE1GbytJMGJVVFhVM04rK3k5cjI1cy9TR3J5T3I4ZzIzaTFvNG1ESkxH?=
 =?utf-8?B?Vzh1MC84SEVPMVpjSGJCWHRtUytRNjROVDVhU3RBMkYzbkE3YlFEa0t6WENa?=
 =?utf-8?B?UVdUU3BVR1VCaXFEZ3hhMnhOWGJudXY3aUNGM0ZvN0xRblhwSDFDTTNuMVQz?=
 =?utf-8?B?eXMwdHBRZHJUMWcxQ05pa0VydENNTHA3cVVIcE5NNnQ0by9DVkFOTFRrb1Bp?=
 =?utf-8?B?TlQvZ3Y1ZVJJTTFkbFQ4TFRBbFRBMVhXa3NpNm1rNFprU05QSzhCQ3NHbEFE?=
 =?utf-8?B?ODlyOEhtR1FMbEgxME5MLzlTRnltQzJHZ29kZGFEdnlacGU1aG1WYzV3VEp0?=
 =?utf-8?B?YnZ0MVJMQ2V5QXJCaVc3cnk0TnRUblkzTWJZNmRLL00zamtGaG1ZaFAwVnJB?=
 =?utf-8?B?aHhmUFRFSC9WRzBpdHdwRENOREJRMzJCUWs0SStFNzVuRWc0R3RUZG9UdmJY?=
 =?utf-8?B?WUprS2pKMlo3WkROdnNwVlNSYXVFZkRuOGI2bzc5V3NwSnFZVExCN21ESC9Y?=
 =?utf-8?B?UVZQcWljU3l2ZTF5QnNRMEJtdHZ3Ty81Q2NKbi81dHNYSncvTkdaLytSdVps?=
 =?utf-8?B?dGc0T1BRVFcxUVZsQmJpTlZsSGRNR0h5Sm8wNU4xZUFvdjJkNm55UnAzMnBt?=
 =?utf-8?Q?vj9nq4um?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec701c3-aa76-4a00-1f35-08d8c265ba60
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 01:49:04.6167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ppbMcGOSPnJetdeHM3H7OBESFoPAwFV48d9aqyhYLiFvI3p5SSO1fkxeVabUHGKyuq/eqUmXGmCA3OwFDsyNUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0MeaciDI35pelIDk6MzMNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBXaWxsZW0gZGUgQnJ1
aWpuDQo+IDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPg0KPiBDYzogR2l1c2VwcGUg
Q2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQWxleGFuZHJlIFRvcmd1ZQ0KPiA8
YWxleGFuZHJlLnRvcmd1ZUBzdC5jb20+OyBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNv
bT47IERhdmlkDQo+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+OyBOZXR3b3JrDQo+IERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5r
ZXJuZWwub3JnPjsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IEFuZHJldyBM
dW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMyAxLzZdIG5ldDog
c3RtbWFjOiByZW1vdmUgcmVkdW5kYW50IG51bGwgY2hlY2sgZm9yIHB0cA0KPiBjbG9jaw0KPiAN
Cj4gDQo+IA0KPiBPbiAxLzI2LzIwMjEgNTozMCBQTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFdpbGxlbSBkZSBC
cnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+ID4+IFNlbnQ6IDIwMjHl
ubQx5pyIMjfml6UgNjo0Ng0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT4NCj4gPj4gQ2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0
LmNvbT47IEFsZXhhbmRyZSBUb3JndWUNCj4gPj4gPGFsZXhhbmRyZS50b3JndWVAc3QuY29tPjsg
Sm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+OyBEYXZpZA0KPiA+PiBNaWxsZXIgPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsNCj4g
Pj4gTmV0d29yayBEZXZlbG9wbWVudCA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IGRsLWxpbnV4
LWlteA0KPiA+PiA8bGludXgtaW14QG54cC5jb20+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4u
Y2g+OyBGbG9yaWFuIEZhaW5lbGxpDQo+ID4+IDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gPj4g
U3ViamVjdDogUmU6IFtQQVRDSCBWMyAxLzZdIG5ldDogc3RtbWFjOiByZW1vdmUgcmVkdW5kYW50
IG51bGwgY2hlY2sNCj4gPj4gZm9yIHB0cCBjbG9jaw0KPiA+Pg0KPiA+PiBPbiBUdWUsIEphbiAy
NiwgMjAyMSBhdCA3OjA1IEFNIEpvYWtpbSBaaGFuZw0KPiA+PiA8cWlhbmdxaW5nLnpoYW5nQG54
cC5jb20+DQo+ID4+IHdyb3RlOg0KPiA+Pj4NCj4gPj4+IFJlbW92ZSByZWR1bmRhbnQgbnVsbCBj
aGVjayBmb3IgcHRwIGNsb2NrLg0KPiA+Pj4NCj4gPj4+IEZpeGVzOiAxYzM1Y2M5Y2Y2YTAgKCJu
ZXQ6IHN0bW1hYzogcmVtb3ZlIHJlZHVuZGFudCBudWxsIGNoZWNrDQo+ID4+PiBiZWZvcmUNCj4g
Pj4+IGNsa19kaXNhYmxlX3VucHJlcGFyZSgpIikNCj4gPj4NCj4gPj4gVGhpcyBkb2VzIG5vdCBs
b29rIGxpa2UgYSBmaXggdG8gdGhhdCBwYXRjaCwgYnV0IGFub3RoZXIgaW5zdGFuY2Ugb2YgYSBj
bGVhbnVwLg0KPiA+Pg0KPiA+PiBUaGUgcGF0Y2hzZXQgYWxzbyBkb2VzIG5vdCBleHBsaWNpdGx5
IHRhcmdldCBuZXQgKGZvciBmaXhlcykgb3INCj4gPj4gbmV0LW5leHQgKGZvciBuZXcgaW1wcm92
ZW1lbnRzKS4gSSBzdXBwb3NlIHRoaXMgcGF0Y2ggdGFyZ2V0cyBuZXQtbmV4dC4NCj4gPg0KPiA+
IEkgZm9yZ290IHRvIGV4cGxpY2l0bHkgdGFyZ2V0IGFzIG5ldCB3aGVuIGZvcm1hdCB0aGUgcGF0
Y2ggc2V0IGFnYWluLiBUaGlzIGNvdWxkDQo+IGJlIGEgZml4IGV2ZW4gb3JpZ2luYWwgcGF0Y2go
MWMzNWNjOWNmNmEwKSBkb2Vzbid0IGJyZWFrIGFueXRoaW5nLCBidXQgaXQgZGlkbid0DQo+IGRv
IGFsbCB0aGUgd29yayBhcyBjb21taXQgbWVzc2FnZSBjb21taXQuDQo+ID4gVGhpcyBwYXRjaCB0
YXJnZXRzIG5ldCBvciBuZXQtbmV4dCwgdGhpcyBtYXR0ZXIgZG9lc24ndCBzZWVtIHRvIGJlIHRo
YXQNCj4gaW1wb3J0YW50LiBJZiBpdCBpcyBuZWNlc3NhcnksIEkgY2FuIHJlcG9zdCBpdCBuZXh0
IHRpbWUgYXMgYSBzZXBhcmF0ZSBwYXRjaCBmb3INCj4gbmV0LW5leHQuIFRoYW5rcy4NCj4gDQo+
IFlvdXIgcGF0Y2ggc2VyaWVzIGlzIHRpdGxlZCAiZXRoZXJuZXQ6IGZpeGVzIGZvciBzdG1tYWMg
ZHJpdmVyIiBzbyB3ZSBzb3J0IG9mDQo+IGV4cGVjdCB0byBmaW5kIG9ubHkgYnVnIGZpeGVzIGlu
IHRoZXJlLg0KPiANCj4gR2l2ZW4gdGhpcyBwYXRjaCBoYXMgbm8gZGVwZW5kZW5jeSBhbmQgZG9l
cyBub3QgY3JlYXRlIG9uZSBvbiB0aGUgb3RoZXJzLCB5b3UNCj4gc2hvdWxkIHBvc3QgdGhhdCBh
cyBhIHNlcGFyYXRlIHBhdGNoIHRhcmdldGluZyB0aGUgJ25ldC1uZXh0JyB0cmVlLg0KDQpPaywg
SSB3aWxsIHJlbW92ZSB0aGlzIHBhdGNoIGZyb20gcGF0Y2ggc2V0IG5leHQgdmVyc2lvbi4gVGhh
bmtzLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gLS0NCj4gRmxvcmlhbg0K
