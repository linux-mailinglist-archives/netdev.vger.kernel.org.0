Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2096863151
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfGIHBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:01:23 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:39749
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbfGIHBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 03:01:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEObhMmpYLJKpYdSruQOnp+WXbbewcM1xAPgafAnOKI=;
 b=HbYdlhk/bhkzjDdGRpWVZJogRzMW8UXReMOqvaqr7NbkeHpOUfWCvm2ptcvTHzP0inT49TAVWup96QvI1v7BV52Qm7akiWinjBIL6Ik4Uge8WCDsp7LkmMu3138qi6VrS/jApOYxGoaatMY+E07KbYr+Mk6R5y/W10dP0icDwLg=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3297.eurprd05.prod.outlook.com (10.170.125.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 06:58:37 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 06:58:37 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>, Justin Pettit <jpettit@ovn.org>,
        John Hurley <john.hurley@netronome.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Thread-Topic: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Thread-Index: AQHVNKHtV/7FmlwqTUa4YKqKnTYQf6bBAzEAgADa/IA=
Date:   Tue, 9 Jul 2019 06:58:36 +0000
Message-ID: <d4f2f3ce-f14d-6026-a271-d627de6d8cea@mellanox.com>
References: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
 <1562489628-5925-3-git-send-email-paulb@mellanox.com>
 <20190708175446.GL3449@localhost.localdomain>
In-Reply-To: <20190708175446.GL3449@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0102CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:14::46) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20cc38e9-cb20-4791-c079-08d7043add98
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3297;
x-ms-traffictypediagnostic: AM4PR05MB3297:
x-microsoft-antispam-prvs: <AM4PR05MB32970C0AA8AD0B7E40E3AAD7CFF10@AM4PR05MB3297.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:595;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(189003)(199004)(229853002)(256004)(6512007)(6436002)(2906002)(186003)(305945005)(11346002)(25786009)(36756003)(14444005)(6246003)(54906003)(3846002)(7736002)(6486002)(31696002)(486006)(71200400001)(71190400001)(316002)(6116002)(53936002)(26005)(4326008)(31686004)(446003)(102836004)(86362001)(66446008)(81166006)(5660300002)(76176011)(66476007)(386003)(64756008)(53546011)(66946007)(478600001)(52116002)(73956011)(6506007)(66556008)(6916009)(68736007)(99286004)(14454004)(2616005)(476003)(66066001)(8676002)(8936002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3297;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zEoElcOH3VE20Yypb4j7SLMtmpmvoQqncI056E1ciXn4EJbSECtqS7JHSPgOCMwSaYd2h60JgIa+rQePNySypKDH8p7gXJA0cFVO9N3OjCqKeOldd7L8bNMkpf8r4ILzCqhve96VgzUfKAYnIQax0buWQRoyg+5R0lL/39xbycexJ188C+ZH+ZJ96Q5GxEthoLO2wcINdOGo8gQV4e8BYXb4dU/IIMXyCzcMrWUHs1NuzAVtgv+kjMlNxqDOrHEAEbNU19jFoy5dSKOgq9cNdtaCu9J2ei26wPCT1g2881uRmZmwIbL/2PK5bjtb7tJqMx6NfJXa35ugswOSBiYyFyyfs7NPUEAu1xkpB2Nm3gudEthe8/rWqA68uRAl+8zNh387euoLFNPhf+MVMTPiQx/eBz5/Z5rLsVksf7jvu6A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BEBCE7A2EFB4949873BC1B81B790023@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20cc38e9-cb20-4791-c079-08d7043add98
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 06:58:37.0213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3297
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzgvMjAxOSA4OjU0IFBNLCBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lciB3cm90ZToNCj4g
T24gU3VuLCBKdWwgMDcsIDIwMTkgYXQgMTE6NTM6NDdBTSArMDMwMCwgUGF1bCBCbGFrZXkgd3Jv
dGU6DQo+PiBOZXcgdGMgYWN0aW9uIHRvIHNlbmQgcGFja2V0cyB0byBjb25udHJhY2sgbW9kdWxl
LCBjb21taXQNCj4+IHRoZW0sIGFuZCBzZXQgYSB6b25lLCBsYWJlbHMsIG1hcmssIGFuZCBuYXQg
b24gdGhlIGNvbm5lY3Rpb24uDQo+Pg0KPj4gSXQgY2FuIGFsc28gY2xlYXIgdGhlIHBhY2tldCdz
IGNvbm50cmFjayBzdGF0ZSBieSB1c2luZyBjbGVhci4NCj4+DQo+PiBVc2FnZToNCj4+ICAgICBj
dCBjbGVhcg0KPj4gICAgIGN0IGNvbW1pdCBbZm9yY2VdIFt6b25lXSBbbWFya10gW2xhYmVsXSBb
bmF0XQ0KPiBJc24ndCB0aGUgJ2NvbW1pdCcgYWxzbyBvcHRpb25hbD8gTW9yZSBsaWtlDQo+ICAg
ICAgY3QgW2NvbW1pdCBbZm9yY2VdXSBbem9uZV0gW21hcmtdIFtsYWJlbF0gW25hdF0NCj4NCj4+
ICAgICBjdCBbbmF0XSBbem9uZV0NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBQYXVsIEJsYWtleSA8
cGF1bGJAbWVsbGFub3guY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogTWFyY2VsbyBSaWNhcmRvIExl
aXRuZXIgPG1hcmNlbG8ubGVpdG5lckBnbWFpbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBZb3Nz
aSBLdXBlcm1hbiA8eW9zc2lrdUBtZWxsYW5veC5jb20+DQo+PiBBY2tlZC1ieTogSmlyaSBQaXJr
byA8amlyaUBtZWxsYW5veC5jb20+DQo+PiBBY2tlZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxh
bm94LmNvbT4NCj4+IC0tLQ0KPiAuLi4NCj4+ICtzdGF0aWMgdm9pZA0KPj4gK3VzYWdlKHZvaWQp
DQo+PiArew0KPj4gKwlmcHJpbnRmKHN0ZGVyciwNCj4+ICsJCSJVc2FnZTogY3QgY2xlYXJcbiIN
Cj4+ICsJCSIJY3QgY29tbWl0IFtmb3JjZV0gW3pvbmUgWk9ORV0gW21hcmsgTUFTS0VEX01BUktd
IFtsYWJlbCBNQVNLRURfTEFCRUxdIFtuYXQgTkFUX1NQRUNdXG4iDQo+IERpdHRvIGhlcmUgdGhl
bi4NCg0KDQpJbiBjb21taXQgbXNnIGFuZCBoZXJlLCBpdCBtZWFucyB0aGVyZSBpcyBtdWx0aXBs
ZSBtb2RlcyBvZiBvcGVyYXRpb24uIEkgDQp0aGluayBpdCdzIGVhc2llciB0byBzcGxpdCB0aG9z
ZS4NCg0KImN0IGNsZWFyIiB0byBjbGVhciBpdCAsIG5vdCBvdGhlciBvcHRpb25zIGNhbiBiZSBh
ZGRlZCBoZXJlLg0KDQoiY3QgY29tbWl0wqAgW2ZvcmNlXS4uLi4gIiBzZW5kcyB0byBjb25udHJh
Y2sgYW5kIGNvbW1pdCBhIGNvbm5lY3Rpb24sIA0KYW5kIG9ubHkgZm9yIGNvbW1pdCBjYW4geW91
IHNwZWNpZnkgZm9yY2UgbWFya8KgIGxhYmVsLCBhbmQgbmF0IHdpdGggDQpuYXRfc3BlYy4uLi4N
Cg0KYW5kIHRoZSBsYXN0IG9uZSwgImN0IFtuYXRdIFt6b25lIFpPTkVdIiBpcyB0byBqdXN0IHNl
bmQgdGhlIHBhY2tldCB0byANCmNvbm50cmFjayBvbiBzb21lIHpvbmUgW29wdGlvbmFsXSwgcmVz
dG9yZSBuYXQgW29wdGlvbmFsXS4NCg0KDQo+DQo+PiArCQkiCWN0IFtuYXRdIFt6b25lIFpPTkVd
XG4iDQo+PiArCQkiV2hlcmU6IFpPTkUgaXMgdGhlIGNvbm50cmFjayB6b25lIHRhYmxlIG51bWJl
clxuIg0KPj4gKwkJIglOQVRfU1BFQyBpcyB7c3JjfGRzdH0gYWRkciBhZGRyMVstYWRkcjJdIFtw
b3J0IHBvcnQxWy1wb3J0Ml1dXG4iDQo+PiArCQkiXG4iKTsNCj4+ICsJZXhpdCgtMSk7DQo+PiAr
fQ0KPiAuLi4NCj4NCj4gVGhlIHZhbGlkYXRpb24gYmVsb3cgZG9lc24ndCBlbmZvcmNlIHRoYXQg
Y29tbWl0IG11c3QgYmUgdGhlcmUgZm9yDQo+IHN1Y2ggY2FzZS4NCndoaWNoIGNhc2U/IGNvbW1p
dCBpcyBvcHRpb25hbC4gdGhlIGFib3ZlIGFyZSB0aGUgdGhyZWUgdmFsaWQgcGF0dGVybnMuDQo+
PiArc3RhdGljIGludA0KPj4gK3BhcnNlX2N0KHN0cnVjdCBhY3Rpb25fdXRpbCAqYSwgaW50ICph
cmdjX3AsIGNoYXIgKioqYXJndl9wLCBpbnQgdGNhX2lkLA0KPj4gKwkJc3RydWN0IG5sbXNnaGRy
ICpuKQ0KPj4gK3sNCj4+ICsJc3RydWN0IHRjX2N0IHNlbCA9IHt9Ow0KPj4gKwljaGFyICoqYXJn
diA9ICphcmd2X3A7DQo+PiArCXN0cnVjdCBydGF0dHIgKnRhaWw7DQo+PiArCWludCBhcmdjID0g
KmFyZ2NfcDsNCj4+ICsJaW50IGN0X2FjdGlvbiA9IDA7DQo+PiArCWludCByZXQ7DQo+PiArDQo+
PiArCXRhaWwgPSBhZGRhdHRyX25lc3QobiwgTUFYX01TRywgdGNhX2lkKTsNCj4+ICsNCj4+ICsJ
aWYgKGFyZ2MgJiYgbWF0Y2hlcygqYXJndiwgImN0IikgPT0gMCkNCj4+ICsJCU5FWFRfQVJHX0ZX
RCgpOw0KPj4gKw0KPj4gKwl3aGlsZSAoYXJnYyA+IDApIHsNCj4+ICsJCWlmIChtYXRjaGVzKCph
cmd2LCAiem9uZSIpID09IDApIHsNCj4+ICsJCQlORVhUX0FSRygpOw0KPj4gKw0KPj4gKwkJCWlm
IChjdF9wYXJzZV91MTYoKmFyZ3YsDQo+PiArCQkJCQkgVENBX0NUX1pPTkUsIFRDQV9DVF9VTlNQ
RUMsIG4pKSB7DQo+PiArCQkJCWZwcmludGYoc3RkZXJyLCAiY3Q6IElsbGVnYWwgXCJ6b25lXCJc
biIpOw0KPj4gKwkJCQlyZXR1cm4gLTE7DQo+PiArCQkJfQ0KPj4gKwkJfSBlbHNlIGlmIChtYXRj
aGVzKCphcmd2LCAibmF0IikgPT0gMCkgew0KPj4gKwkJCWN0X2FjdGlvbiB8PSBUQ0FfQ1RfQUNU
X05BVDsNCj4+ICsNCj4+ICsJCQlORVhUX0FSRygpOw0KPj4gKwkJCWlmIChtYXRjaGVzKCphcmd2
LCAic3JjIikgPT0gMCkNCj4+ICsJCQkJY3RfYWN0aW9uIHw9IFRDQV9DVF9BQ1RfTkFUX1NSQzsN
Cj4+ICsJCQllbHNlIGlmIChtYXRjaGVzKCphcmd2LCAiZHN0IikgPT0gMCkNCj4+ICsJCQkJY3Rf
YWN0aW9uIHw9IFRDQV9DVF9BQ1RfTkFUX0RTVDsNCj4+ICsJCQllbHNlDQo+PiArCQkJCWNvbnRp
bnVlOw0KPj4gKw0KPj4gKwkJCU5FWFRfQVJHKCk7DQo+PiArCQkJaWYgKG1hdGNoZXMoKmFyZ3Ys
ICJhZGRyIikgIT0gMCkNCj4+ICsJCQkJdXNhZ2UoKTsNCj4+ICsNCj4+ICsJCQlORVhUX0FSRygp
Ow0KPj4gKwkJCXJldCA9IGN0X3BhcnNlX25hdF9hZGRyX3JhbmdlKCphcmd2LCBuKTsNCj4+ICsJ
CQlpZiAocmV0KSB7DQo+PiArCQkJCWZwcmludGYoc3RkZXJyLCAiY3Q6IElsbGVnYWwgbmF0IGFk
ZHJlc3MgcmFuZ2VcbiIpOw0KPj4gKwkJCQlyZXR1cm4gLTE7DQo+PiArCQkJfQ0KPj4gKw0KPj4g
KwkJCU5FWFRfQVJHX0ZXRCgpOw0KPj4gKwkJCWlmIChtYXRjaGVzKCphcmd2LCAicG9ydCIpICE9
IDApDQo+PiArCQkJCWNvbnRpbnVlOw0KPj4gKw0KPj4gKwkJCU5FWFRfQVJHKCk7DQo+PiArCQkJ
cmV0ID0gY3RfcGFyc2VfbmF0X3BvcnRfcmFuZ2UoKmFyZ3YsIG4pOw0KPj4gKwkJCWlmIChyZXQp
IHsNCj4+ICsJCQkJZnByaW50ZihzdGRlcnIsICJjdDogSWxsZWdhbCBuYXQgcG9ydCByYW5nZVxu
Iik7DQo+PiArCQkJCXJldHVybiAtMTsNCj4+ICsJCQl9DQo+PiArCQl9IGVsc2UgaWYgKG1hdGNo
ZXMoKmFyZ3YsICJjbGVhciIpID09IDApIHsNCj4+ICsJCQljdF9hY3Rpb24gfD0gVENBX0NUX0FD
VF9DTEVBUjsNCj4+ICsJCX0gZWxzZSBpZiAobWF0Y2hlcygqYXJndiwgImNvbW1pdCIpID09IDAp
IHsNCj4+ICsJCQljdF9hY3Rpb24gfD0gVENBX0NUX0FDVF9DT01NSVQ7DQo+PiArCQl9IGVsc2Ug
aWYgKG1hdGNoZXMoKmFyZ3YsICJmb3JjZSIpID09IDApIHsNCj4+ICsJCQljdF9hY3Rpb24gfD0g
VENBX0NUX0FDVF9GT1JDRTsNCj4+ICsJCX0gZWxzZSBpZiAobWF0Y2hlcygqYXJndiwgImluZGV4
IikgPT0gMCkgew0KPj4gKwkJCU5FWFRfQVJHKCk7DQo+PiArCQkJaWYgKGdldF91MzIoJnNlbC5p
bmRleCwgKmFyZ3YsIDEwKSkgew0KPj4gKwkJCQlmcHJpbnRmKHN0ZGVyciwgImN0OiBJbGxlZ2Fs
IFwiaW5kZXhcIlxuIik7DQo+PiArCQkJCXJldHVybiAtMTsNCj4+ICsJCQl9DQo+PiArCQl9IGVs
c2UgaWYgKG1hdGNoZXMoKmFyZ3YsICJtYXJrIikgPT0gMCkgew0KPj4gKwkJCU5FWFRfQVJHKCk7
DQo+PiArDQo+PiArCQkJcmV0ID0gY3RfcGFyc2VfbWFyaygqYXJndiwgbik7DQo+PiArCQkJaWYg
KHJldCkgew0KPj4gKwkJCQlmcHJpbnRmKHN0ZGVyciwgImN0OiBJbGxlZ2FsIFwibWFya1wiXG4i
KTsNCj4+ICsJCQkJcmV0dXJuIC0xOw0KPj4gKwkJCX0NCj4+ICsJCX0gZWxzZSBpZiAobWF0Y2hl
cygqYXJndiwgImxhYmVsIikgPT0gMCkgew0KPj4gKwkJCU5FWFRfQVJHKCk7DQo+PiArDQo+PiAr
CQkJcmV0ID0gY3RfcGFyc2VfbGFiZWxzKCphcmd2LCBuKTsNCj4+ICsJCQlpZiAocmV0KSB7DQo+
PiArCQkJCWZwcmludGYoc3RkZXJyLCAiY3Q6IElsbGVnYWwgXCJsYWJlbFwiXG4iKTsNCj4+ICsJ
CQkJcmV0dXJuIC0xOw0KPj4gKwkJCX0NCj4+ICsJCX0gZWxzZSBpZiAobWF0Y2hlcygqYXJndiwg
ImhlbHAiKSA9PSAwKSB7DQo+PiArCQkJdXNhZ2UoKTsNCj4+ICsJCX0gZWxzZSB7DQo+PiArCQkJ
YnJlYWs7DQo+PiArCQl9DQo+PiArCQlORVhUX0FSR19GV0QoKTsNCj4+ICsJfQ0KPj4gKw0KPj4g
KwlpZiAoY3RfYWN0aW9uICYgVENBX0NUX0FDVF9DTEVBUiAmJg0KPj4gKwkgICAgY3RfYWN0aW9u
ICYgflRDQV9DVF9BQ1RfQ0xFQVIpIHsNCj4+ICsJCWZwcmludGYoc3RkZXJyLCAiY3Q6IGNsZWFy
IGNhbiBvbmx5IGJlIHVzZWQgYWxvbmVcbiIpOw0KPj4gKwkJcmV0dXJuIC0xOw0KPj4gKwl9DQo+
PiArDQo+PiArCWlmIChjdF9hY3Rpb24gJiBUQ0FfQ1RfQUNUX05BVF9TUkMgJiYNCj4+ICsJICAg
IGN0X2FjdGlvbiAmIFRDQV9DVF9BQ1RfTkFUX0RTVCkgew0KPj4gKwkJZnByaW50ZihzdGRlcnIs
ICJjdDogc3JjIGFuZCBkc3QgbmF0IGNhbid0IGJlIHVzZWQgdG9nZXRoZXJcbiIpOw0KPj4gKwkJ
cmV0dXJuIC0xOw0KPj4gKwl9DQo+PiArDQo+PiArCWlmICgoY3RfYWN0aW9uICYgVENBX0NUX0FD
VF9DT01NSVQpICYmDQo+PiArCSAgICAoY3RfYWN0aW9uICYgVENBX0NUX0FDVF9OQVQpICYmDQo+
PiArCSAgICAhKGN0X2FjdGlvbiAmIChUQ0FfQ1RfQUNUX05BVF9TUkMgfCBUQ0FfQ1RfQUNUX05B
VF9EU1QpKSkgew0KPj4gKwkJZnByaW50ZihzdGRlcnIsICJjdDogY29tbWl0IGFuZCBuYXQgbXVz
dCBzZXQgc3JjIG9yIGRzdFxuIik7DQo+PiArCQlyZXR1cm4gLTE7DQo+PiArCX0NCj4+ICsNCj4+
ICsJaWYgKCEoY3RfYWN0aW9uICYgVENBX0NUX0FDVF9DT01NSVQpICYmDQo+PiArCSAgICAoY3Rf
YWN0aW9uICYgKFRDQV9DVF9BQ1RfTkFUX1NSQyB8IFRDQV9DVF9BQ1RfTkFUX0RTVCkpKSB7DQo+
PiArCQlmcHJpbnRmKHN0ZGVyciwgImN0OiBzcmMgb3IgZHN0IGlzIG9ubHkgdmFsaWQgaWYgY29t
bWl0IGlzIHNldFxuIik7DQo+PiArCQlyZXR1cm4gLTE7DQo+PiArCX0NCj4+ICsNCj4+ICsJcGFy
c2VfYWN0aW9uX2NvbnRyb2xfZGZsdCgmYXJnYywgJmFyZ3YsICZzZWwuYWN0aW9uLCBmYWxzZSwN
Cj4+ICsJCQkJICBUQ19BQ1RfUElQRSk7DQo+PiArCU5FWFRfQVJHX0ZXRCgpOw0KPj4gKw0KPj4g
KwlhZGRhdHRyMTYobiwgTUFYX01TRywgVENBX0NUX0FDVElPTiwgY3RfYWN0aW9uKTsNCj4+ICsJ
YWRkYXR0cl9sKG4sIE1BWF9NU0csIFRDQV9DVF9QQVJNUywgJnNlbCwgc2l6ZW9mKHNlbCkpOw0K
Pj4gKwlhZGRhdHRyX25lc3RfZW5kKG4sIHRhaWwpOw0KPj4gKw0KPj4gKwkqYXJnY19wID0gYXJn
YzsNCj4+ICsJKmFyZ3ZfcCA9IGFyZ3Y7DQo+PiArCXJldHVybiAwOw0KPj4gK30NCj4gLi4uDQo=
