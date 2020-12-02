Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD77C2CB849
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387901AbgLBJNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:13:19 -0500
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:9441
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387632AbgLBJNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:13:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDYBU0VAgU5dWtebN980L+AnKocPJ0uk+AAMSuSEWDi6wvMz6BWxjPmRKloWv3b5rDhE9h6O92CaZ15iqB5s/G7ZdwFdBpBj1J0re/u7E+zVFVdi+TRL19tKg9zi8TaYAkPXmWdKEuyN5IllWSsoehP+unNuUjRA2U+cQfZp8rOas+EmTo14bUp75jhzL3Ldn6J2jKsUyTK2COz29kAnhyobSX9SKma+olSOHtwpCkBcghxHvKw79mBf9chBoj1Bt3j97o2y6h+9rYPf9FOPJot5QoQShHij4JQj067W5NQpj7HHqYNYpLcboCcw69l3OtqbjTjEiQnXFEeSWk8M1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJOjMu0GqnnkVPllOvLTWrozSk44SgX2IulbW+PgAqE=;
 b=XOv9UVYWbz1csHGQUEZnPC5lailO9KTDgw6FqJowBCaOzLAJeg6bTBos/PC7IaKnTI7sN0IKY0lMNA64eT27J7R+I9NdNiiq6fUHKSbi8bd5bl+8lPMq5jVIbIT0mnTatOh4hsXBojieH9SO8OiCoRP4nRTx/w5TXVEgtymXWZXmGpBNYtqv6pDmXXYXdbYCPZ8NxXIfwkgLH5Mi0hNcjUzrEcKTQPfCutUw2ROLFqu2FdDejj0TZK5LMOU7MPjOMNYyxf1V6umkROK7immgkXkrcP1fVzlM8BQtiFd5W3cWY4dMjgLe3OWGvAsDjTM7PilLc12tFFIG4HBDEjy94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJOjMu0GqnnkVPllOvLTWrozSk44SgX2IulbW+PgAqE=;
 b=eQ7i9O1CAG2NOdc+4XdC4MOed2fTZpLJWvCkdrIwBOzkAUdIv4jGSyMDREKIs5wi3Bo2azFcwLJz407cfL0+qzUYG4AqAWnE3cCuovpRNoFCzHUsS+jONsWeNyE9WR922NJ6+f+hZZiAWF50Nva4HGf9iEqE1R2Lu+lg48GhvOc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5132.eurprd04.prod.outlook.com (2603:10a6:10:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Wed, 2 Dec
 2020 09:12:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 09:12:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] LF-2678 net: ethernet: stmmac: delete the eee_ctrl_timer
 after napi disabled
Thread-Topic: [PATCH] LF-2678 net: ethernet: stmmac: delete the eee_ctrl_timer
 after napi disabled
Thread-Index: AQHWyIl9Kwp5e4Cf7kiosEMhiGQOaqnjhMig
Date:   Wed, 2 Dec 2020 09:12:28 +0000
Message-ID: <DB8PR04MB6795667EDA944455335135CCE6F30@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
 <20201202085949.3279-2-qiangqing.zhang@nxp.com>
In-Reply-To: <20201202085949.3279-2-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a83a554-ad6d-4073-2bb6-08d896a26490
x-ms-traffictypediagnostic: DB7PR04MB5132:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB513265096BFA7A584FF4D614E6F30@DB7PR04MB5132.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ynZPqBBf3wXEiZ9are6vG5tt6ATz1n5NA7pl1Te5Qa5P1aAIwWndPYiLBVRx5AC5VaiMAX6olGGdrzJCMyE/+LrcpjRa4H1pohRaI/qs7Uo4W27SPobLNbsfB/XmwWRgp49Ai/LIkbsyzOVOpRQA+TUiinjSEvPLijsQlv9i0dF3apy21EBPiOqx2QHG4n+cDc5uJJtEcnctm2XuzGK70xKe9A2EJQvPlE0GJpdz0h68Rg+C1wWJSGc9E/IkfVo1G+TwTX8iNveqYbpH+VzR6JDCZh1hjwMarR+VvLMQrn6Qs/KA8BuwXiMPGSx1PGmDS6SktUX6LnSIcrorsTWqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(26005)(71200400001)(2906002)(7696005)(53546011)(6506007)(86362001)(186003)(76116006)(55016002)(33656002)(83380400001)(316002)(52536014)(4326008)(110136005)(8936002)(54906003)(8676002)(5660300002)(66476007)(66446008)(66946007)(478600001)(9686003)(64756008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?eXhZRFBQWEF6MTZUVk40T2toc3M5Yyt0QTMxUHdwQnYyOEZHak9vakFTWHND?=
 =?gb2312?B?cjlqYkJUZC96aUJHVmhpMnQwNEx2UXlWekN6bWJHMGFMZ0tsNWhKYnlvaWt3?=
 =?gb2312?B?c0E4bUhYbTFzNXBrMXVNQUpKR2J3b1ViV2ZHcmdxaUI4WCtheHEwenRxemU5?=
 =?gb2312?B?dGkyK3loWWNDMnJsSkVKL0cwdHFLYzRza1BHQzVEcEIxYko2WFdLaWFRSWxE?=
 =?gb2312?B?RC9SSmI4OTRIdG1UcGlWbFJnM2VON0dzSWxOWGpzWSsvc2NpbGxPb3ZtZjM5?=
 =?gb2312?B?a0lxT3AxM0tVVFlyeDQzaXV1aWdoYXFWZFVrS00zdHJCVW5RQnFwZ1JVMXdl?=
 =?gb2312?B?aDQyUGsvTHZ4QmhNVjAyeGVMRS9WTzJtakI0eXV1Z1R1OVIxVmswaTFDVUk5?=
 =?gb2312?B?b3FNQm1zME9uT2ZUMCswUCtTeW5TMDZnYTlLV1oxVU1CQ1lHZUl6NzUwbERn?=
 =?gb2312?B?MEZxVlNIRFBiNzlKYTFJVm00NGNnQVY3ZzhZK0U4RHZtaTNWeHljTFpaMmRw?=
 =?gb2312?B?Vmh2VWlKcm1TdFpFUCthQnI1R3VWR2xuek9xWWgxdjF5NVVYQWszVGg1WVN3?=
 =?gb2312?B?bzFDUTRuaW5FNElTbGsrdkhzUTR1SThkSnZnSCsycjhTeUVmbHhLN2h2aEJo?=
 =?gb2312?B?OU5RbHFUSE9qM1kzVHh6eWREU1dmZkM1dklSdWJSSy9YSWE0WGx5b0wrSWZn?=
 =?gb2312?B?NVhDd2pZNGdib3habGZwT3NZUk1QTVlXUmJuWTlscDFPc1Jxd0VvSjJkRUNk?=
 =?gb2312?B?N0lXNmNzQko0bXloUFdvQ0dXODJFcWYxckt1Ukx0U256dHJTYXNOTHRxRnV0?=
 =?gb2312?B?MUs5UThjdHhIRFBtWTdsN3c1OGNQWkJ2RjEzZUpmdEt5NlJja0FJVUkzc2ls?=
 =?gb2312?B?NkpyWE5jK1R4NXZoczFJM0U2NVpqTVNHSFR5MkdrUmRBQ3BKd3R1czFvbFd3?=
 =?gb2312?B?Yzd4bkErV2tidmpqY2VGQkJ6cktES2dlS1pQMjFhYWpza2haMFhpV0k2VXlU?=
 =?gb2312?B?aU9YQkJNM3FiWmdnT1c3UzRTMGQxeUY2Z2V4Q2I3Mmc2bDBUOC9PY285a3VY?=
 =?gb2312?B?U21rQjRXV0dWWlM2S1RXNEJmTm9IUlQrNUNHSkUybkRhZFNaQ0ttOVZxWjhk?=
 =?gb2312?B?aVJWQWY0SmxTN1dqSm9WSVg0R0gvd3g3TEJvdFRvd0F4SFBjdjR2NUZyVWY2?=
 =?gb2312?B?NU9HOUNhaC9Jai8yTVpQcURrazJCU0J6WDlxTVBxSG9ZWk9OR3c2KzZ4VmMr?=
 =?gb2312?B?ZnVuaEVHczdleGZZRE83Z3Q2QnRYZU5ialFYQnExcThwQk92UXgxYXo4UDFF?=
 =?gb2312?Q?yYuri2P57x/Mg=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a83a554-ad6d-4073-2bb6-08d896a26490
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 09:12:28.7609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xnOuGE0C3gjr2F2kWphnrdAkkuqR5liNHgt/evmSyp1WvJ4xJpjmScUTD4bkPQhT8uREQsnGM+3Z3bELetlVRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSwNCg0KUGxlYXNlIGlnbm9yZSB0aGlzIHBhdGNoIGR1ZSB0byB3cm9uZ2x5IHNlbmQgb3V0
LiBTb3JyeS4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT4NCj4gU2VudDogMjAyMMTqMTLUwjLI1SAxNzowMA0KPiBUbzogcGVwcGUuY2F2YWxsYXJv
QHN0LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBzdC5jb207DQo+IGpvYWJyZXVAc3lub3BzeXMuY29t
DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+IFN1Ympl
Y3Q6IFtQQVRDSF0gTEYtMjY3OCBuZXQ6IGV0aGVybmV0OiBzdG1tYWM6IGRlbGV0ZSB0aGUgZWVl
X2N0cmxfdGltZXINCj4gYWZ0ZXIgbmFwaSBkaXNhYmxlZA0KPiANCj4gRnJvbTogRnVnYW5nIER1
YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+IA0KPiBUaGVyZSBoYXZlIGNoYW5jZSB0byByZS1l
bmFibGUgdGhlIGVlZV9jdHJsX3RpbWVyIGFuZCBmaXJlIHRoZSB0aW1lciBpbiBuYXBpDQo+IGNh
bGxiYWNrIGFmdGVyIGRlbGV0ZSB0aGUgdGltZXIgaW4gLnN0bW1hY19yZWxlYXNlKCksIHdoaWNo
IGludHJvZHVjZXMgdG8NCj4gYWNjZXNzIGVlZSByZWdpc3RlcnMgaW4gdGhlIHRpbWVyIGZ1bmN0
aW9uIGFmdGVyIGNsb2NrcyBhcmUgZGlzYWJsZWQgdGhlbiBjYXVzZXMNCj4gc3lzdGVtIGhhbmcu
DQo+IA0KPiBJdCBpcyBzYWZlIHRvIGRlbGV0ZSB0aGUgdGltZXIgYWZ0ZXIgbmFwaSBkaXNhYmxl
ZCBhbmQgZGlzYWJsZSBscGkgbW9kZS4NCj4gDQo+IFRlc3RlZC1ieTogSm9ha2ltIFpoYW5nIDxx
aWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFuIDxmdWdh
bmcuZHVhbkBueHAuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL3N0bW1hY19tYWluLmMgfCAxMyArKysrKysrKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiBpbmRleCBj
YzFmMTdiMTcwZjAuLjdlNjU1ZmEzNDU4OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+IEBAIC0yOTMzLDkgKzI5MzMs
NiBAQCBzdGF0aWMgaW50IHN0bW1hY19yZWxlYXNlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+
ICAJc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiA9IHRvX3BsYXRmb3JtX2RldmljZShwcml2
LT5kZXZpY2UpOw0KPiAgCXUzMiBjaGFuOw0KPiANCj4gLQlpZiAocHJpdi0+ZWVlX2VuYWJsZWQp
DQo+IC0JCWRlbF90aW1lcl9zeW5jKCZwcml2LT5lZWVfY3RybF90aW1lcik7DQo+IC0NCj4gIAlp
ZiAoZGV2aWNlX21heV93YWtldXAocHJpdi0+ZGV2aWNlKSkNCj4gIAkJcGh5bGlua19zcGVlZF9k
b3duKHByaXYtPnBoeWxpbmssIGZhbHNlKTsNCj4gIAkvKiBTdG9wIGFuZCBkaXNjb25uZWN0IHRo
ZSBQSFkgKi8NCj4gQEAgLTI5NTQsNiArMjk1MSwxMSBAQCBzdGF0aWMgaW50IHN0bW1hY19yZWxl
YXNlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICAJaWYgKHByaXYtPmxwaV9pcnEgPiAwKQ0K
PiAgCQlmcmVlX2lycShwcml2LT5scGlfaXJxLCBkZXYpOw0KPiANCj4gKwlpZiAocHJpdi0+ZWVl
X2VuYWJsZWQpIHsNCj4gKwkJcHJpdi0+dHhfcGF0aF9pbl9scGlfbW9kZSA9IGZhbHNlOw0KPiAr
CQlkZWxfdGltZXJfc3luYygmcHJpdi0+ZWVlX2N0cmxfdGltZXIpOw0KPiArCX0NCj4gKw0KPiAg
CS8qIFN0b3AgVFgvUlggRE1BIGFuZCBjbGVhciB0aGUgZGVzY3JpcHRvcnMgKi8NCj4gIAlzdG1t
YWNfc3RvcF9hbGxfZG1hKHByaXYpOw0KPiANCj4gQEAgLTUyMjQsNiArNTIyNiwxMSBAQCBpbnQg
c3RtbWFjX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQ0KPiAgCWZvciAoY2hhbiA9IDA7IGNo
YW4gPCBwcml2LT5wbGF0LT50eF9xdWV1ZXNfdG9fdXNlOyBjaGFuKyspDQo+ICAJCWRlbF90aW1l
cl9zeW5jKCZwcml2LT50eF9xdWV1ZVtjaGFuXS50eHRpbWVyKTsNCj4gDQo+ICsJaWYgKHByaXYt
PmVlZV9lbmFibGVkKSB7DQo+ICsJCXByaXYtPnR4X3BhdGhfaW5fbHBpX21vZGUgPSBmYWxzZTsN
Cj4gKwkJZGVsX3RpbWVyX3N5bmMoJnByaXYtPmVlZV9jdHJsX3RpbWVyKTsNCj4gKwl9DQo+ICsN
Cj4gIAkvKiBTdG9wIFRYL1JYIERNQSAqLw0KPiAgCXN0bW1hY19zdG9wX2FsbF9kbWEocHJpdik7
DQo+IA0KPiAtLQ0KPiAyLjE3LjENCg0K
