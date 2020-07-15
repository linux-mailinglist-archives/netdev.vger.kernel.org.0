Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BC722031E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGODxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 23:53:51 -0400
Received: from mail-eopbgr60092.outbound.protection.outlook.com ([40.107.6.92]:18341
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726885AbgGODxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 23:53:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U16AdpjhtQo55NmZpLUDgMrCmk1yFTqeAIb2JR24+bQEgoYPfzJUKKil+9pevY6ID1NgrKCg+VpLtLocwKpLu/t/wMqaUs/jZr/cAPySpBYjZmuSLE+F1cppfX9oduPQJGws9Rch18sVG/CSvdLPaP5oqzAf1tJojr830KOuzk5sPZ+ihITg9j67SDbujVWrmZv89pwZouQG1ZcqSwlS0sHyZP9kizrMm1rqz2fkPdl1dzcapt/8bR9O3BJ9dbE2fzmompCOvde3R/mEAv3G8prbnjzLF3aHuhxxCpGA0aRgrTmtpLApjZe2QBpHoNe2ycFkLclDvG+QgH8vldYf2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSXBB0uDW0j5u6EjKkAKD03eqOJsmJ1sHlG19P0yaSM=;
 b=hqIMs5wQKn/XuQd08w7qmwdvxohZanvr/9k6iXrXf/7vg6R++6rTbqY0B4hesngzNRxMjMfPpxJA2eppx4K7QZ4/ygQngI+//RUh/tUZxCAcu6hO2qbNKPpprdRqpPo1vXIsHPfia2oVawPh5CGt+vaj3khxk4hpvD9rSrLrfeSjq6y6lfd7NpDn6a2bJFA52YOsUthNURnWgdxyDMg2A7I8lYYQMTMAidOVvjbk+N5snAiLktUXxCK6QvV6aguK8CgJ30sVcppllLKkESraR4JKMmCYj+CO8Z/tjIyW+WYzgGADAw02g9Yw7/ldBoAGMktt29PQ/noGb8CxBtXBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSXBB0uDW0j5u6EjKkAKD03eqOJsmJ1sHlG19P0yaSM=;
 b=clKOs+S4/+5bBch21+eYVbZIELdejeL7/iQTZCpjLpzz0BJGvQqBZSQ7oznilrijz5gyB6O/9dN+Y2aiQPYgXT9gvPFTdo80tWi8iT7RDtJHJTX5f1kSaFaoVgt8wELDTuMVpuyYa5WxJOCYthz5AmtdENP8Ar0OSR6xraFNNgg=
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR05MB5973.eurprd05.prod.outlook.com (2603:10a6:20b:af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 03:53:44 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::9d1c:861f:f91e:7e5d]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::9d1c:861f:f91e:7e5d%7]) with mapi id 15.20.3195.017; Wed, 15 Jul 2020
 03:53:44 +0000
From:   Tuong Tong Lien <tuong.t.lien@dektech.com.au>
To:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Xue, Ying" <Ying.Xue@windriver.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] tipc: Don't using smp_processor_id() in preemptible
 code
Thread-Topic: [PATCH v2] tipc: Don't using smp_processor_id() in preemptible
 code
Thread-Index: AQHWWbQzmHeVUzT0dUO3ZUB6LP3WYKkHHx8AgADIYYCAABs7AA==
Date:   Wed, 15 Jul 2020 03:53:43 +0000
Message-ID: <AM6PR0502MB3925A724B302DE48876AED87E27E0@AM6PR0502MB3925.eurprd05.prod.outlook.com>
References: <20200714080559.9617-1-qiang.zhang@windriver.com>,<bf395370-219a-7c87-deee-7f3edce8c9dc@gmail.com>
 <DM6PR11MB2635949FCEAF1EF90B93B5D1FF7E0@DM6PR11MB2635.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB2635949FCEAF1EF90B93B5D1FF7E0@DM6PR11MB2635.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=dektech.com.au;
x-originating-ip: [14.161.14.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 898a0766-47bd-443b-82ff-08d82872abd7
x-ms-traffictypediagnostic: AM6PR05MB5973:
x-microsoft-antispam-prvs: <AM6PR05MB5973A22FEF58E42F512D1577E27E0@AM6PR05MB5973.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tvUe10eL8+W5OAWcl1NqnXebpU+Jsg3XTZSfzI7GOBUIOh1T0sD8bBImrmFXvoktRwhKmhFj4Tktkt66lJRP67LdtbPZ01Xw+LdDz3l39EBGSZOSSLArfIXRx0bW+s+9I0RKOZk88MPerSxmOwJv1PgxCsWI5KwBO27YXLeBX1PCx+8AFP3XfKqkP9Xe5xt8tzXe8dAuxuIYJba8FBYUAYLq1lHXOG/YO4SwrJN8k/aZeMKJhyrLLKJdq3GFHIsbJgAA4mX3+ERAJm8miAMgO+F8RzqyKBjvF5N70qL8IkcIsS+tSTvLrS64MAI9Oud99cjaB12ZiIH9q/OPYRPpBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39840400004)(396003)(376002)(366004)(346002)(136003)(83380400001)(55016002)(2906002)(53546011)(6506007)(7696005)(86362001)(8676002)(186003)(8936002)(9686003)(508600001)(26005)(71200400001)(33656002)(5660300002)(52536014)(66476007)(76116006)(4326008)(66946007)(66556008)(316002)(66446008)(64756008)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: P3BKnueWKRsRZBA+tKoyJEUJbPIq/LtFbAXAmRQiSfWserVJvlrXhUoNewbkw/7KEldO3WGTF9ki+QLrA3epTu+gMj/n5seR/6LDUkBsAnPm3BHIGc3hvOGIL1PkoQWewyyEB2Ss6UbG9eTS+1VdRZZoQDXop5HylgefnLbs4hUaO5nD3HlzYvaclXVWOYenSxQoDgeLKHLZpN66P8A9uNqxPdJTCUsUpmogsIULo8RjJUqI+SOZqlI8R8RrrqpfaXWc0Av6qBE55BMh7IajWiVVBW8Lzl/QANBk6II0pLKT5tDWT79ZjO6AuRGzalcUGtdYkhcWue0yM8TIdWqOtlRHZQO0TDWL3/P+zNteBADiQY2q7hdnzrw1rXgVqpoqk6Md+FXIGEOWwDfshhTjavG7HCcScp6I8HN0llyJpzSPxv5un9DASIWbcl9uxsdF5ulVu1qOsUUwLP43f5/VvOkf9Y+oCsOtYOLSyGVXBHg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0502MB3925.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898a0766-47bd-443b-82ff-08d82872abd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 03:53:44.1718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dk1VmCvAgNGknMCEDXB81mADKp9fJkkokbxfdZDPBUPY6PyAwUo9iEsO0l+0lpBiTBM31CGpOQ6jOZQb0g0FnABl2lR/PagohufzzRROIig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWmhhbmcsIFFpYW5nIDxR
aWFuZy5aaGFuZ0B3aW5kcml2ZXIuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgMTUsIDIw
MjAgOToxMyBBTQ0KPiBUbzogRXJpYyBEdW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPjsg
am1hbG95QHJlZGhhdC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsg
VHVvbmcgVG9uZyBMaWVuDQo+IDx0dW9uZy50LmxpZW5AZGVrdGVjaC5jb20uYXU+OyBYdWUsIFlp
bmcgPFlpbmcuWHVlQHdpbmRyaXZlci5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyB0aXBjLWRpc2N1c3Npb25AbGlzdHMuc291cmNlZm9yZ2UubmV0OyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IOWbnuWkjTogW1BBVENIIHYyXSB0aXBjOiBEb24ndCB1
c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUgY29kZQ0KPiANCj4gDQo+IA0K
PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IOWPkeS7tuS6ujog
RXJpYyBEdW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiDlj5HpgIHml7bpl7Q6IDIw
MjDlubQ35pyIMTTml6UgMjI6MTUNCj4g5pS25Lu25Lq6OiBaaGFuZywgUWlhbmc7IGptYWxveUBy
ZWRoYXQuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHR1b25nLnQu
bGllbkBkZWt0ZWNoLmNvbS5hdTsNCj4gZXJpYy5kdW1hemV0QGdtYWlsLmNvbTsgWHVlLCBZaW5n
DQo+IOaKhOmAgTogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3Rz
LnNvdXJjZWZvcmdlLm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiDkuLvpopg6
IFJlOiBbUEFUQ0ggdjJdIHRpcGM6IERvbid0IHVzaW5nIHNtcF9wcm9jZXNzb3JfaWQoKSBpbiBw
cmVlbXB0aWJsZSBjb2RlDQo+IA0KPiANCj4gDQo+IE9uIDcvMTQvMjAgMTowNSBBTSwgcWlhbmcu
emhhbmdAd2luZHJpdmVyLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBaaGFuZyBRaWFuZyA8cWlhbmcu
emhhbmdAd2luZHJpdmVyLmNvbT4NCj4gPg0KPiA+IENQVTogMCBQSUQ6IDY4MDEgQ29tbTogc3l6
LWV4ZWN1dG9yMjAxIE5vdCB0YWludGVkIDUuOC4wLXJjNC1zeXprYWxsZXIgIzANCj4gPiBIYXJk
d2FyZSBuYW1lOiBHb29nbGUgR29vZ2xlIENvbXB1dGUgRW5naW5lL0dvb2dsZSBDb21wdXRlIEVu
Z2luZSwNCj4gPiBCSU9TIEdvb2dsZSAwMS8wMS8yMDExDQo+ID4NCj4gPiBGaXhlczogZmMxYjZk
NmRlMjIwOCAoInRpcGM6IGludHJvZHVjZSBUSVBDIGVuY3J5cHRpb24gJiBhdXRoZW50aWNhdGlv
biIpDQo+ID4gUmVwb3J0ZWQtYnk6IHN5emJvdCsyNjNmOGMwZDAwN2RjMDliMmRkYUBzeXprYWxs
ZXIuYXBwc3BvdG1haWwuY29tDQo+ID4gU2lnbmVkLW9mZi1ieTogWmhhbmcgUWlhbmcgPHFpYW5n
LnpoYW5nQHdpbmRyaXZlci5jb20+DQo+ID4gLS0tDQo+ID4gIHYxLT52MjoNCj4gPiAgYWRkIGZp
eGVzIHRhZ3MuDQo+ID4NCj4gPiAgbmV0L3RpcGMvY3J5cHRvLmMgfCAzICsrLQ0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvbmV0L3RpcGMvY3J5cHRvLmMgYi9uZXQvdGlwYy9jcnlwdG8uYw0KPiA+IGluZGV4
IDhjNDdkZWQyZWRiNi4uNTIwYWYwYWZlMWIzIDEwMDY0NA0KPiA+IC0tLSBhL25ldC90aXBjL2Ny
eXB0by5jDQo+ID4gKysrIGIvbmV0L3RpcGMvY3J5cHRvLmMNCj4gPiBAQCAtMzk5LDkgKzM5OSwx
MCBAQCBzdGF0aWMgdm9pZCB0aXBjX2FlYWRfdXNlcnNfc2V0KHN0cnVjdCB0aXBjX2FlYWQgX19y
Y3UgKmFlYWQsIGludCB2YWwpDQo+ID4gICAqLw0KPiA+ICBzdGF0aWMgc3RydWN0IGNyeXB0b19h
ZWFkICp0aXBjX2FlYWRfdGZtX25leHQoc3RydWN0IHRpcGNfYWVhZCAqYWVhZCkNCj4gPiAgew0K
PiA+IC0gICAgIHN0cnVjdCB0aXBjX3RmbSAqKnRmbV9lbnRyeSA9IHRoaXNfY3B1X3B0cihhZWFk
LT50Zm1fZW50cnkpOw0KPiA+ICsgICAgIHN0cnVjdCB0aXBjX3RmbSAqKnRmbV9lbnRyeSA9IGdl
dF9jcHVfcHRyKGFlYWQtPnRmbV9lbnRyeSk7DQo+ID4NCj4gPiAgICAgICAqdGZtX2VudHJ5ID0g
bGlzdF9uZXh0X2VudHJ5KCp0Zm1fZW50cnksIGxpc3QpOw0KPiA+ICsgICAgIHB1dF9jcHVfcHRy
KHRmbV9lbnRyeSk7DQo+ID4gICAgICAgcmV0dXJuICgqdGZtX2VudHJ5KS0+dGZtOw0KPiA+ICB9
DQo+ID4NCj4gPg0KPiANCj4gPiBZb3UgaGF2ZSBub3QgZXhwbGFpbmVkIHdoeSB0aGlzIHdhcyBz
YWZlLg0KPiA+DQo+ID4gIFRoaXMgc2VlbXMgdG8gaGlkZSBhIHJlYWwgYnVnLg0KPiA+DQo+ID4g
UHJlc3VtYWJseSBjYWxsZXJzIG9mIHRoaXMgZnVuY3Rpb24gc2hvdWxkIGhhdmUgZGlzYWJsZSBw
cmVlbXB0aW9uLCBhbmQgbWF5YmUgPiBpbnRlcnJ1cHRzIGFzIHdlbGwuDQo+ID4NCj4gPlJpZ2h0
IGFmdGVyIHB1dF9jcHVfcHRyKHRmbV9lbnRyeSksIHRoaXMgdGhyZWFkIGNvdWxkIG1pZ3JhdGUg
dG8gYW5vdGhlciBjcHUsID5hbmQgc3RpbGwgYWNjZXNzDQo+ID5kYXRhIG93bmVkIGJ5IHRoZSBv
bGQgY3B1Lg0KPiANCj4gVGhhbmtzIGZvciB5b3Ugc3VnZ2VzdCwgSSB3aWxsIGNoZWNrIGNvZGUg
YWdhaW4uDQo+IA0KDQpBY3R1YWxseSwgbGFzdCB3ZWVrIEkgc2VudCBhIHNpbWlsYXIgcGF0Y2gg
dG8gdGlwYy1kaXNjdXNzaW9uIHdoaWNoIGNvdmVycyB0aGUNCmNhc2UgYXMgd2VsbCAodGhlcmUg
aXMgYWxzbyBhbm90aGVyIHBsYWNlIGNhdXNpbmcgdGhlIHNhbWUgaXNzdWUuLi4pLiBJZiB5b3UN
CmRvbid0IG1pbmQsIHlvdSBjYW4gdGFrZSBhIGxvb2sgYXQgYmVsb3cgKGp1c3QgY29waWVkL3Bh
c3RlZCkuDQoNCkJSL1R1b25nDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBU
dW9uZyBUb25nIExpZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNvbS5hdT4gDQpTZW50OiBGcmlk
YXksIEp1bHkgMTAsIDIwMjAgNToxMSBQTQ0KVG86IGptYWxveUByZWRoYXQuY29tOyBtYWxveUBk
b25qb25uLmNvbTsgeWluZy54dWVAd2luZHJpdmVyLmNvbTsgdGlwYy1kaXNjdXNzaW9uQGxpc3Rz
LnNvdXJjZWZvcmdlLm5ldA0KQ2M6IHRpcGMtZGVrIDx0aXBjLWRla0BkZWt0ZWNoLmNvbS5hdT4N
ClN1YmplY3Q6IFtQQVRDSCBSRkMgMS81XSB0aXBjOiBmaXggdXNpbmcgc21wX3Byb2Nlc3Nvcl9p
ZCgpIGluIHByZWVtcHRpYmxlDQoNClRoZSAndGhpc19jcHVfcHRyKCknIGlzIHVzZWQgdG8gb2J0
YWluIHRoZSBBRUFEIGtleScgVEZNIG9uIHRoZSBjdXJyZW50DQpDUFUgZm9yIGVuY3J5cHRpb24s
IGhvd2V2ZXIgdGhlIGV4ZWN1dGlvbiBjYW4gYmUgcHJlZW1wdGlibGUgc2luY2UgaXQncw0KYWN0
dWFsbHkgdXNlci1zcGFjZSBjb250ZXh0LCBzbyB0aGUgJ3VzaW5nIHNtcF9wcm9jZXNzb3JfaWQo
KSBpbg0KcHJlZW1wdGlibGUnIGhhcyBiZWVuIG9ic2VydmVkLg0KDQpXZSBmaXggdGhlIGlzc3Vl
IGJ5IHVzaW5nIHRoZSAnZ2V0L3B1dF9jcHVfcHRyKCknIEFQSSB3aGljaCBjb25zaXN0cyBvZg0K
YSAncHJlZW1wdF9kaXNhYmxlKCknIGluc3RlYWQuDQoNClNpZ25lZC1vZmYtYnk6IFR1b25nIExp
ZW4gPHR1b25nLnQubGllbkBkZWt0ZWNoLmNvbS5hdT4NCi0tLQ0KIG5ldC90aXBjL2NyeXB0by5j
IHwgMTIgKysrKysrKysrLS0tDQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL25ldC90aXBjL2NyeXB0by5jIGIvbmV0L3RpcGMv
Y3J5cHRvLmMNCmluZGV4IGM4YzQ3ZmM3MjY1My4uMTgyN2NlNGZhYzVkIDEwMDY0NA0KLS0tIGEv
bmV0L3RpcGMvY3J5cHRvLmMNCisrKyBiL25ldC90aXBjL2NyeXB0by5jDQpAQCAtMzI2LDcgKzMy
Niw4IEBAIHN0YXRpYyB2b2lkIHRpcGNfYWVhZF9mcmVlKHN0cnVjdCByY3VfaGVhZCAqcnApDQog
CWlmIChhZWFkLT5jbG9uZWQpIHsNCiAJCXRpcGNfYWVhZF9wdXQoYWVhZC0+Y2xvbmVkKTsNCiAJ
fSBlbHNlIHsNCi0JCWhlYWQgPSAqdGhpc19jcHVfcHRyKGFlYWQtPnRmbV9lbnRyeSk7DQorCQlo
ZWFkID0gKmdldF9jcHVfcHRyKGFlYWQtPnRmbV9lbnRyeSk7DQorCQlwdXRfY3B1X3B0cihhZWFk
LT50Zm1fZW50cnkpOw0KIAkJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHRmbV9lbnRyeSwgdG1w
LCAmaGVhZC0+bGlzdCwgbGlzdCkgew0KIAkJCWNyeXB0b19mcmVlX2FlYWQodGZtX2VudHJ5LT50
Zm0pOw0KIAkJCWxpc3RfZGVsKCZ0Zm1fZW50cnktPmxpc3QpOw0KQEAgLTM5OSwxMCArNDAwLDE1
IEBAIHN0YXRpYyB2b2lkIHRpcGNfYWVhZF91c2Vyc19zZXQoc3RydWN0IHRpcGNfYWVhZCBfX3Jj
dSAqYWVhZCwgaW50IHZhbCkNCiAgKi8NCiBzdGF0aWMgc3RydWN0IGNyeXB0b19hZWFkICp0aXBj
X2FlYWRfdGZtX25leHQoc3RydWN0IHRpcGNfYWVhZCAqYWVhZCkNCiB7DQotCXN0cnVjdCB0aXBj
X3RmbSAqKnRmbV9lbnRyeSA9IHRoaXNfY3B1X3B0cihhZWFkLT50Zm1fZW50cnkpOw0KKwlzdHJ1
Y3QgdGlwY190Zm0gKip0Zm1fZW50cnk7DQorCXN0cnVjdCBjcnlwdG9fYWVhZCAqdGZtOw0KIA0K
Kwl0Zm1fZW50cnkgPSBnZXRfY3B1X3B0cihhZWFkLT50Zm1fZW50cnkpOw0KIAkqdGZtX2VudHJ5
ID0gbGlzdF9uZXh0X2VudHJ5KCp0Zm1fZW50cnksIGxpc3QpOw0KLQlyZXR1cm4gKCp0Zm1fZW50
cnkpLT50Zm07DQorCXRmbSA9ICgqdGZtX2VudHJ5KS0+dGZtOw0KKwlwdXRfY3B1X3B0cih0Zm1f
ZW50cnkpOw0KKw0KKwlyZXR1cm4gdGZtOw0KIH0NCiANCiAvKioNCi0tIA0KMi4xMy43DQo=
