Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47507257576
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 10:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgHaIdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 04:33:09 -0400
Received: from mail-eopbgr70131.outbound.protection.outlook.com ([40.107.7.131]:49550
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726573AbgHaIdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 04:33:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7CjineOQs3ikm+QJR0aRzL/sWGu0N4ao8cX4IhtSjzw7QuDG1i+HJ/4nttN9/qfoBLu00C0rQhQND5mM2fXSmlEzgxg6mjdPohmpP3KbHxBmSsAdu2TqbUl39fYyeA922S10QVr2pBDuWbtWCDCO102TkFeLCok5wfmKBFQ+gmQa2LgbfX2J80FKcD8g++AQHgBZwJqaNMHexewducjPbIgsQT9X20s4PupfW2i25h32pl1GhyS+jq3PZwXbaRe/eOCHF4FqQNt3flQMP7HffQScJMiWYg1ob4+uC1l2C8CHfhAVaJf79Lg3+YQqWWoT/S+74lGv0yM1uTyieqLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmnifRTmUqhpqgxFN5WLlyBwVxBpS+8dSOZIxoOgERM=;
 b=XmgPyuySaPDc4JrNrFEg9izH+Lvx8x/sBru20fB3oA+5cKzjNCLHeC4ptE8MO7CW9sqqsmI9ilUTuBoDsV+RHSKCzSCHfNahzYYFMl1+UFXDcpI1O0Axb6xEwxOtt8J/7u5e8Np1ig4tlO6GC4Kw9/n2qbK7JfPHsP4hzKzKKSabYuvEx7UEv6XUm6uetQCnfOU5+5fOY/6kzbn2XCDd77lT+T/Rw3gLKm3vCheoJ8Hz44+ET8v9KUZVixodkYHqi/SJmc1qJoSOOquHLMXYGH350It06cAgVLuaPpi7wzVriU15UYHIoyZIqfjLyZkoqchCSR3XbIfUNDReYlOYGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmnifRTmUqhpqgxFN5WLlyBwVxBpS+8dSOZIxoOgERM=;
 b=RQHLklclAscqGBDQIalf703CfjAy+2HNOd3KwDpfBQcjRL6Vms6Od84D1PwX91Sqg4oHNhNOVupUacuv61OpLGcqkDBPAwqyKyxO1dB3QTr4nILnZFSB3utAOYUU9N7KcetUAaEgXO0YIhlL5hZK+Ztj9US0fFMOJ77Q+zdu8uM=
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM4PR05MB3377.eurprd05.prod.outlook.com (2603:10a6:205:b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Mon, 31 Aug
 2020 08:33:02 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 08:33:02 +0000
From:   Tuong Tong Lien <tuong.t.lien@dektech.com.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
Subject: RE: [net] tipc: fix using smp_processor_id() in preemptible
Thread-Topic: [net] tipc: fix using smp_processor_id() in preemptible
Thread-Index: AQHWfoc+himFBG6tQEGws4qIktdqQalR4IkAgAACUeA=
Date:   Mon, 31 Aug 2020 08:33:02 +0000
Message-ID: <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
 <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
In-Reply-To: <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [14.161.14.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24b75977-0fbb-41d5-afe6-08d84d8879ae
x-ms-traffictypediagnostic: AM4PR05MB3377:
x-microsoft-antispam-prvs: <AM4PR05MB33776A34997B84FC4F380BC3E2510@AM4PR05MB3377.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6lRkGKOaJI0c30g2VzkyFxskN0gBUKDDE2FyeOmK9q9j3zUWImT4/D02+6b/Fs26NbMUf6nBe/lyaWlXH2Mp271o760c6dJbLyxHYrzjFkG1Wr8g5fnrdIxNVwr8xVHT4lH2CN/1DZ0mgEmoIAsz8V4sNpXqZN2GPwG5fbBwoKba4G9jdbCXrAZ4X9SNJskAYgeJ6dvT1Vue/1Za9cwD9XDjWdyBJtwTOQek8syOrfcCwnMRcgbbmt7yZOL60lp8GTkt/2v77iUV8oS2pok76TLiEDSczPm1HHxA7/Xol3aAr93JbQ6kjklr+wyBrq7c8TPv51C8Oun7QuCeO+xJFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(396003)(39850400004)(2906002)(66476007)(64756008)(4326008)(53546011)(478600001)(6506007)(71200400001)(66446008)(5660300002)(8936002)(76116006)(26005)(186003)(8676002)(52536014)(83380400001)(66946007)(55016002)(86362001)(66556008)(7696005)(33656002)(9686003)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Y5HDWKZu3Pl4T3Q16MjWim6udlo2IzYGg1BAEDTbi2jC4YQFDAVT6ttYQ0lcdMS1PjLbj9qN1JoCY5ZiUWEUVKLOdzLE2IQ+mb+J2xGlYR1ayUYXUT8xW3jumEh3CJ6G9ezudsxSchJ61R6hGLcHrG34aaAU9XPN5Y9bZ0UnyxJ3P4YOEqiyV6L++xZX8ojyGmB290PCqIFdsft/KNNguLvy5ECNsZtQCu9t8ndTwZWMSzmifft4o8V5rsnxA+aKXPIoSlvjOIFqtb4+AQoa4W9it1R5IaZUS/vqV6+5fTbNR5lQ7fx5RGNpLygKdlvRRiMDGQBjPeJp82E2Rj2pi9MgACrEgvmuhfkRQeZM0uFPZlr+4/uC69tBgSSzInvl4UrnHFkyvjc9Cm5yDogfGhRZFCGnX1N197MdKPMhLnnncvxXLt3q9YBpr7lI+G1i703oY+B4EQ2/STEN0iswp8KhBpK1yHOpyfxH6fPGY1RtOt9sBT5p2iIvTeDNXQOfBshTnskdas0tx1Bm0M1Isbng9dmu5YzRPX7ta7YfItBtyR1ArfgsBsIE5WhSM1uhBRBheycToLInTreMSbxO4F0AH7LKeWwpy/DTEBZwp0GV+GOm8g+ko3YfaLO0qcnN4/wZ0opot4nzPTZGP818Yg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b75977-0fbb-41d5-afe6-08d84d8879ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2020 08:33:02.4018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IRe3VolR43OvYen0RcRN7iFBGg0qj0yuCnWhQ7QeHuO6SEj5T9r2uP0LMRJ3MmlUmQxsniONhu+eo3CHiMcyAwB7L1BaZhXixUmHmnK6TWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3377
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRXJpYywNCg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLCBwbGVhc2Ugc2VlIG15IGFuc3dl
cnMgaW5saW5lLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEVyaWMg
RHVtYXpldCA8ZXJpYy5kdW1hemV0QGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3Qg
MzEsIDIwMjAgMzoxNSBQTQ0KPiBUbzogVHVvbmcgVG9uZyBMaWVuIDx0dW9uZy50LmxpZW5AZGVr
dGVjaC5jb20uYXU+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBqbWFsb3lAcmVkaGF0LmNvbTsgbWFs
b3lAZG9uam9ubi5jb207DQo+IHlpbmcueHVlQHdpbmRyaXZlci5jb207IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gQ2M6IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQNCj4g
U3ViamVjdDogUmU6IFtuZXRdIHRpcGM6IGZpeCB1c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkgaW4g
cHJlZW1wdGlibGUNCj4gDQo+IA0KPiANCj4gT24gOC8yOS8yMCAxMjozNyBQTSwgVHVvbmcgTGll
biB3cm90ZToNCj4gPiBUaGUgJ3RoaXNfY3B1X3B0cigpJyBpcyB1c2VkIHRvIG9idGFpbiB0aGUg
QUVBRCBrZXknIFRGTSBvbiB0aGUgY3VycmVudA0KPiA+IENQVSBmb3IgZW5jcnlwdGlvbiwgaG93
ZXZlciB0aGUgZXhlY3V0aW9uIGNhbiBiZSBwcmVlbXB0aWJsZSBzaW5jZSBpdCdzDQo+ID4gYWN0
dWFsbHkgdXNlci1zcGFjZSBjb250ZXh0LCBzbyB0aGUgJ3VzaW5nIHNtcF9wcm9jZXNzb3JfaWQo
KSBpbg0KPiA+IHByZWVtcHRpYmxlJyBoYXMgYmVlbiBvYnNlcnZlZC4NCj4gPg0KPiA+IFdlIGZp
eCB0aGUgaXNzdWUgYnkgdXNpbmcgdGhlICdnZXQvcHV0X2NwdV9wdHIoKScgQVBJIHdoaWNoIGNv
bnNpc3RzIG9mDQo+ID4gYSAncHJlZW1wdF9kaXNhYmxlKCknIGluc3RlYWQuDQo+ID4NCj4gPiBG
aXhlczogZmMxYjZkNmRlMjIwICgidGlwYzogaW50cm9kdWNlIFRJUEMgZW5jcnlwdGlvbiAmIGF1
dGhlbnRpY2F0aW9uIikNCj4gDQo+IEhhdmUgeW91IGZvcmdvdHRlbiAnIFJlcG9ydGVkLWJ5OiBz
eXpib3QrMjYzZjhjMGQwMDdkYzA5YjJkZGFAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbScgPw0K
V2VsbCwgcmVhbGx5IEkgZGV0ZWN0ZWQgdGhlIGlzc3VlIGR1cmluZyBteSB0ZXN0aW5nIGluc3Rl
YWQsIGRpZG4ndCBrbm93IGlmIGl0IHdhcyByZXBvcnRlZCBieSBzeXpib3QgdG9vLg0KDQo+IA0K
PiA+IEFja2VkLWJ5OiBKb24gTWFsb3kgPGptYWxveUByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFR1b25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNvbS5hdT4NCj4gPiAtLS0N
Cj4gPiAgbmV0L3RpcGMvY3J5cHRvLmMgfCAxMiArKysrKysrKystLS0NCj4gPiAgMSBmaWxlIGNo
YW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9uZXQvdGlwYy9jcnlwdG8uYyBiL25ldC90aXBjL2NyeXB0by5jDQo+ID4gaW5kZXggYzM4
YmFiYWE0ZTU3Li43YzUyM2RjODE1NzUgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L3RpcGMvY3J5cHRv
LmMNCj4gPiArKysgYi9uZXQvdGlwYy9jcnlwdG8uYw0KPiA+IEBAIC0zMjYsNyArMzI2LDggQEAg
c3RhdGljIHZvaWQgdGlwY19hZWFkX2ZyZWUoc3RydWN0IHJjdV9oZWFkICpycCkNCj4gPiAgCWlm
IChhZWFkLT5jbG9uZWQpIHsNCj4gPiAgCQl0aXBjX2FlYWRfcHV0KGFlYWQtPmNsb25lZCk7DQo+
ID4gIAl9IGVsc2Ugew0KPiA+IC0JCWhlYWQgPSAqdGhpc19jcHVfcHRyKGFlYWQtPnRmbV9lbnRy
eSk7DQo+ID4gKwkJaGVhZCA9ICpnZXRfY3B1X3B0cihhZWFkLT50Zm1fZW50cnkpOw0KPiA+ICsJ
CXB1dF9jcHVfcHRyKGFlYWQtPnRmbV9lbnRyeSk7DQo+IA0KPiBXaHkgaXMgdGhpcyBzYWZlID8N
Cj4gDQo+IEkgdGhpbmsgdGhhdCB0aGlzIHZlcnkgdW51c3VhbCBjb25zdHJ1Y3QgbmVlZHMgYSBj
b21tZW50LCBiZWNhdXNlIHRoaXMgaXMgbm90IG9idmlvdXMuDQo+IA0KPiBUaGlzIHJlYWxseSBs
b29rcyBsaWtlIGFuIGF0dGVtcHQgdG8gc2lsZW5jZSBzeXpib3QgdG8gbWUuDQpObywgdGhpcyBp
cyBub3QgdG8gc2lsZW5jZSBzeXpib3QgYnV0IHJlYWxseSBzYWZlLg0KVGhpcyBpcyBiZWNhdXNl
IHRoZSAiYWVhZC0+dGZtX2VudHJ5IiBvYmplY3QgaXMgImNvbW1vbiIgYmV0d2VlbiBDUFVzLCB0
aGVyZSBpcyBvbmx5IGl0cyBwb2ludGVyIHRvIGJlIHRoZSAicGVyX2NwdSIgb25lLiBTbyBqdXN0
IHRyeWluZyB0byBsb2NrIHRoZSBwcm9jZXNzIG9uIHRoZSBjdXJyZW50IENQVSBvciAncHJlZW1w
dF9kaXNhYmxlKCknLCB0YWtpbmcgdGhlIHBlci1jcHUgcG9pbnRlciBhbmQgZGVyZWZlcmVuY2lu
ZyB0byB0aGUgYWN0dWFsICJ0Zm1fZW50cnkiIG9iamVjdC4uLiBpcyBlbm91Z2guIExhdGVyIG9u
LCB0aGF04oCZcyBmaW5lIHRvIHBsYXkgd2l0aCB0aGUgYWN0dWFsIG9iamVjdCB3aXRob3V0IGFu
eSBsb2NraW5nLg0KDQpCUi9UdW9uZw0KPiANCj4gPiAgCQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3Nh
ZmUodGZtX2VudHJ5LCB0bXAsICZoZWFkLT5saXN0LCBsaXN0KSB7DQo+ID4gIAkJCWNyeXB0b19m
cmVlX2FlYWQodGZtX2VudHJ5LT50Zm0pOw0KPiA+ICAJCQlsaXN0X2RlbCgmdGZtX2VudHJ5LT5s
aXN0KTsNCj4gPiBAQCAtMzk5LDEwICs0MDAsMTUgQEAgc3RhdGljIHZvaWQgdGlwY19hZWFkX3Vz
ZXJzX3NldChzdHJ1Y3QgdGlwY19hZWFkIF9fcmN1ICphZWFkLCBpbnQgdmFsKQ0KPiA+ICAgKi8N
Cj4gPiAgc3RhdGljIHN0cnVjdCBjcnlwdG9fYWVhZCAqdGlwY19hZWFkX3RmbV9uZXh0KHN0cnVj
dCB0aXBjX2FlYWQgKmFlYWQpDQo+ID4gIHsNCj4gPiAtCXN0cnVjdCB0aXBjX3RmbSAqKnRmbV9l
bnRyeSA9IHRoaXNfY3B1X3B0cihhZWFkLT50Zm1fZW50cnkpOw0KPiA+ICsJc3RydWN0IHRpcGNf
dGZtICoqdGZtX2VudHJ5Ow0KPiA+ICsJc3RydWN0IGNyeXB0b19hZWFkICp0Zm07DQo+ID4NCj4g
PiArCXRmbV9lbnRyeSA9IGdldF9jcHVfcHRyKGFlYWQtPnRmbV9lbnRyeSk7DQo+ID4gIAkqdGZt
X2VudHJ5ID0gbGlzdF9uZXh0X2VudHJ5KCp0Zm1fZW50cnksIGxpc3QpOw0KPiA+IC0JcmV0dXJu
ICgqdGZtX2VudHJ5KS0+dGZtOw0KPiA+ICsJdGZtID0gKCp0Zm1fZW50cnkpLT50Zm07DQo+ID4g
KwlwdXRfY3B1X3B0cih0Zm1fZW50cnkpOw0KPiANCj4gQWdhaW4sIHRoaXMgbG9va3Mgc3VzcGlj
aW91cyB0byBtZS4gSSBjYW4gbm90IGV4cGxhaW4gd2h5IHRoaXMgd291bGQgYmUgc2FmZS4NCj4g
DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHRmbTsNCj4gPiAgfQ0KPiA+DQo+ID4gIC8qKg0KPiA+DQo=
