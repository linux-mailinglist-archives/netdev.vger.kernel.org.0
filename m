Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7F42096C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 12:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhJDKn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 06:43:29 -0400
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:48577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229545AbhJDKn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 06:43:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NU53dETflYps4MJTfktcIW9ouymY4YalnKhfHILX9wKlFOjFf/DaY6DJb65HEi3FWwgxbMAsb4jS8UPZ+a8XI1v/5ZW523Ed3pvBGUjYa2aRlNZyJ3yVZZgRwQWVzkiJnoUTqQvuvhLpaBT1Nrl91/+dDmFKwureGjQUjqgVu2VnrrY6ArH6LHNnUXsN8wgU5WgWM8i7gHyFAoiNNsAgnOaspjOg8o9baLS0Z4LN6M/SPUOPeOtvUm8kZHzO9fkUwa1ZyLsA8Ag8ez7a3mVn/ip7nB4u0EVI4suwFfFvK1deJtrL6GaI4N7M8SbMmJZhAldZb76NMzYU/sl4PGNYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MB3H8TwsdmIaBbWyQO52p53XClBVpDMRmqj8sL2pUg=;
 b=OOIlO0HriSih1Tdcmvbni1F/xrgs9u2sxiMLPbpr5uRmFTA2ozE71zLM3bJvnxrl07uOOeyrY6zzBHaEIqr/cYTMhAFkwx0d3lJKwWk7QjQ9GYU7uxWs7C0giWhrtwOQsHNDZfeUg+zXkOGNdL7zhMUOfBhGMRwvegOCSq5WVyH8SxZJ+DOqT7Kun3XeNKo6lTUVPHXW1C/YjEgg5GxGfbfhA8+b+gxBZTLnSlJepPAxVdFlJYsm0EhyGtjWjpfPLnrjZyvTf12aiZcHouRXHGDEU8JeaCNyCrf1mkbb5ygCFap+4yWRpB6talj0kuVNbI+9032CIsEA83v6yRWkDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nordicsemi.no; dmarc=pass action=none
 header.from=nordicsemi.no; dkim=pass header.d=nordicsemi.no; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nordicsemi.onmicrosoft.com; s=selector2-nordicsemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MB3H8TwsdmIaBbWyQO52p53XClBVpDMRmqj8sL2pUg=;
 b=f5CKK9eaL1FEKCoBeBaV1R5a64rFvv0vzVQ5dq9GBRkZka3uGKgl1sNMgmokthG753+RqlCN3bLT3VztI/W66SBPv0KyOZRR3zbMS3hLbsKB+GWR3AwzfbKCZG3UKL3EYcOSXaVuUGOXqwkIxSqseZ20Sg8klnaUHr3cIECg2Dg=
Received: from DB9PR05MB7898.eurprd05.prod.outlook.com (2603:10a6:10:263::11)
 by DB8PR05MB6732.eurprd05.prod.outlook.com (2603:10a6:10:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 10:41:38 +0000
Received: from DB9PR05MB7898.eurprd05.prod.outlook.com
 ([fe80::18d5:e101:fcc4:8726]) by DB9PR05MB7898.eurprd05.prod.outlook.com
 ([fe80::18d5:e101:fcc4:8726%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 10:41:38 +0000
From:   "Cufi, Carles" <Carles.Cufi@nordicsemi.no>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Florian Weimer' <fweimer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jukka.rissanen@linux.intel.com" <jukka.rissanen@linux.intel.com>,
        "johan.hedberg@intel.com" <johan.hedberg@intel.com>,
        "Lubos, Robert" <Robert.Lubos@nordicsemi.no>,
        "Bursztyka, Tomasz" <tomasz.bursztyka@intel.com>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>
Subject: RE: Non-packed structures in IP headers
Thread-Topic: Non-packed structures in IP headers
Thread-Index: Ade11fYpGxA4RFKaTJCxYimSNlf1AQBKmbUlAClekgAAWUMW4A==
Date:   Mon, 4 Oct 2021 10:41:38 +0000
Message-ID: <DB9PR05MB789852210DBB2F6264536A8EE7AE9@DB9PR05MB7898.eurprd05.prod.outlook.com>
References: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
 <87bl48v74v.fsf@oldenburg.str.redhat.com>
 <a8082bcaeb534ee5b24ea6dae4428547@AcuMS.aculab.com>
In-Reply-To: <a8082bcaeb534ee5b24ea6dae4428547@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=nordicsemi.no;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f98c7e2-dc17-4620-ab14-08d987238b85
x-ms-traffictypediagnostic: DB8PR05MB6732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR05MB6732450FDAFED97B496F2420E7AE9@DB8PR05MB6732.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DESsnX2jBXrjlYim9icCkmgNfWpGUadd2YWmHKnpHz9Mj2GDq1V1XJHw3aK9S0Vb/0JqFamcutdwZ6ZCKTJHuNj2zRo5FRnF++eYijmgwn5RloPcrHaYtA6RJ6rlG8ksxTIUiQcd9TDNtbLvag5I2s9LO+mM1uEYY0IXVWpXBWNwYddcKGvzO8xxZu+pETzv1VQlmLRqntbL/E0tuA6AQjaGxov4CsdppcTKVV/iny+5Gkemjt6jBBE9fGFLTJbMVKz4on2/Hi1TI97sbcUjeTa/iAdWLkR3QYYmOmQSj9wezhhSJBDEqil4WU1YyBEu4XGcid8AAFwuUVxs0qlvcF8B1h4TAQZjE9lmZKYH96BCIpMAwe/FkpX7vwO4Asr8T5liCGO5xdvnuUGRKifMSsxLnmrcvY9liYkNTj7G8FWZh+tsrpC5d4W5QvgKqHwPZxHD/sIxA+luDRhAqxARsEIUubTjPm+g2KUeiQLHte3IsBbe7JD+5ywoAO3bKUwVuzkZK1qmC22aPsGKkfuDPjE0cGjQg3TiVWVcbzb3AICPozq4TUicCm/tAsrI95bGzu11EY1vvoZBWvsV9Y9HWPRBR5aoGOMappuPMskxbUEmcY88yaIV5TyO5r8T+Sy4xwcWiW3awiR3PryLPbCsscpTHxSp/uBVSvOHWD8xH+VryUOvXZ2undOSVxhyzRuqgtKV/jtsnUIgNkdaYI1+bMIeFs+5fWxdKMEUX0YoOwr7NBaPtHhA2BzcIGBnZN13dT5cLFZ5hsKBFrb2VAnc0za40A5n6Cxm5w8DXr7BWdw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7898.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(2906002)(6506007)(52536014)(38070700005)(8936002)(66476007)(122000001)(4326008)(966005)(316002)(76116006)(54906003)(8676002)(38100700002)(33656002)(110136005)(26005)(66946007)(64756008)(508600001)(83380400001)(55016002)(71200400001)(9686003)(186003)(66446008)(7696005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 03ekqEb5iSfLqY4IH1FS5JZ8XUYD6AnRZM7/q1yAS8mepXWUU3l7U4cHhe4fUBDtol8fqErsPwDd6cwcPLgFTrYAxuz7qGiOiH8hBO98u6wvRuyTt1R66n86wJurF6FhEU91i4orIh4kpAGKadUmjUSP7lGHLfUJyvcYQI80HC4D9LsildD3d19i2oxoFgvE3lu8NSoZ8S0QQQ0PCR43B8Zh7tkDR9Vsz0CE0ZpXHozouegtazoG4i6cDnI7C3v2st8ko2frS+kEKcqhl6utjLjytpzISHFj6xcVScKrwWOmnJim86uuUVhCq/HI3m9FMTunD08tdHLbgGzhssbw5rzM/yaQb8X0uh21BPGCa/fG+L7pJMMhlGlEqjDoS5uBicEnehh5CQdH+RxGI2OGrflAPb4dIBJsbvR8hYjn4PKxRrUhKMdig42Wo2wH5/Gl2aAXxWoGcjC/bZF5t51O0GKD0lgILfep1CfISNEtnd+ql9U0czIfvmcWXn8Jh8jZmxFiuQxBWXLlIqoDEFg6gDzE5GCDF7ChsjI+zw8J457I2hx22qP3biAzf5xHfLhX2SOlm1H2yeYQZvN4/MVyvkTAWrzUrSOnZDLERm/s/rcDRsbwGDcFIZdqy9jW+NiQoneGHp8D80ugsQmrSVCVqPCgxjMuDMxtRhe6rQXLqbk1WWBAqjkhVlhbDfEXysA++0JIJT1ghdS+kxKMAbowcJZXm/UcIDRjZYtWvEdIyTk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nordicsemi.no
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7898.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f98c7e2-dc17-4620-ab14-08d987238b85
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 10:41:38.3038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 28e5afa2-bf6f-419a-8cf6-b31c6e9e5e8d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jxqvdXxe4xQvl+28MoQgPYwa+GmSFr4YUKKLodhssVae4Xu12rvC2LzRE7VpSo2apPNgIsLa9Qy5vV0KvkHe270ZZr0p4ANvEmaF42dLhZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBBQ1VMQUIuQ09NPg0KPiBTZW50OiAw
MiBPY3RvYmVyIDIwMjEgMTc6NTUNCj4gRnJvbTogRmxvcmlhbiBXZWltZXINCj4gPiBTZW50OiAw
MSBPY3RvYmVyIDIwMjEgMjE6MTANCj4gPg0KPiA+ICogQ2FybGVzIEN1Zmk6DQo+ID4NCj4gPiA+
IEkgd2FzIGxvb2tpbmcgdGhyb3VnaCB0aGUgc3RydWN0dXJlcyBmb3IgSVB2ezQsNn0gcGFja2V0
IGhlYWRlcnMgYW5kDQo+ID4gPiBub3RpY2VkIHRoYXQgc2V2ZXJhbCBvZiB0aG9zZSB0aGF0IHNl
ZW0gdG8gYmUgdXNlZCB0byBwYXJzZSBhIHBhY2tldA0KPiA+ID4gZGlyZWN0bHkgZnJvbSB0aGUg
d2lyZSBhcmUgbm90IGRlY2xhcmVkIGFzIHBhY2tlZC4gVGhpcyBzdXJwcmlzZWQgbWUNCj4gPiA+
IGJlY2F1c2UsIGFsdGhvdWdoIEkgZGlkIGZpbmQgdGhhdCBwcm92aXNpb25zIGFyZSBtYWRlIHNv
IHRoYXQgdGhlDQo+ID4gPiBhbGlnbm1lbnQgb2YgdGhlIHN0cnVjdHVyZSwgaXQgaXMgc3RpbGwg
dGVjaG5pY2FsbHkgcG9zc2libGUgZm9yIHRoZQ0KPiA+ID4gY29tcGlsZXIgdG8gaW5qZWN0IHBh
ZGRpbmcgYnl0ZXMgaW5zaWRlIHRob3NlIHN0cnVjdHVyZXMsIHNpbmNlDQo+ID4gPiBBRkFJSyB0
aGUgQyBzdGFuZGFyZCBtYWtlcyBubyBndWFyYW50ZWVzIGFib3V0IHBhZGRpbmcgdW5sZXNzIGl0
J3MNCj4gPiA+IGluc3RydWN0ZWQgdG8gcGFjayB0aGUgc3RydWN0dXJlLg0KPiA+DQo+ID4gVGhl
IEMgc3RhbmRhcmRzIGRvIG5vdCBtYWtlIHN1Y2ggZ3VhcmFudGVlcywgYnV0IHRoZSBwbGF0Zm9y
bSBBQkkNCj4gPiBzdGFuZGFyZHMgZGVzY3JpYmUgc3RydWN0IGxheW91dCBhbmQgZW5zdXJlIHRo
YXQgdGhlcmUgaXMgbm8gcGFkZGluZy4NCj4gPiBMaW51eCByZWxpZXMgb24gdGhhdCBub3QganVz
dCBmb3IgbmV0d29ya2luZywgYnV0IGFsc28gZm9yIHRoZQ0KPiA+IHVzZXJzcGFjZSBBQkksIHN1
cHBvcnQgZm9yIHNlcGFyYXRlbHkgY29tcGlsZWQga2VybmVsIG1vZHVsZXMsIGFuZCBpbg0KPiA+
IG90aGVyIHBsYWNlcy4NCj4gDQo+IEluIHBhcnRpY3VsYXIgc3RydWN0dXJlcyBhcmUgdXNlZCB0
byBtYXAgaGFyZHdhcmUgcmVnaXN0ZXIgYmxvY2tzLg0KDQpOb24tcGFkZGVkIG9uZXM/IEJlY2F1
c2UgdGhpcyBhZ2FpbiBtaWdodCBiZSBhbiBpc3N1ZSBkZXBlbmRpbmcgb24gdGhlIGNvbXBpbGVy
L0FCSSBhcyBwZXIgbXkgdW5kZXJzdGFuZGluZy4NCg0KPiANCj4gPiBTb21ldGltZXMgdGhlcmUg
YXJlIGFsaWdubWVudCBjb25jZXJucyBpbiB0aGUgd2F5IHRoZXNlIHN0cnVjdHMgYXJlDQo+ID4g
dXNlZCwgYnV0IEkgYmVsaWV2ZSB0aGUga2VybmVsIGdlbmVyYWxseSBjb250cm9scyBwbGFjZW1l
bnQgb2YgdGhlDQo+ID4gZGF0YSB0aGF0IGlzIGJlaW5nIHdvcmtlZCBvbiwgc28gdGhhdCBkb2Vz
IG5vdCBtYXR0ZXIsIGVpdGhlci4NCj4gPg0KPiA+IFRoZXJlZm9yZSwgSSBkbyBub3QgYmVsaWV2
ZSB0aGlzIGlzIGFuIGFjdHVhbCBwcm9ibGVtLg0KPiANCj4gQW5kIGFkZGluZyBfX3BhY2tlZCBm
b3JjZXMgdGhlIGNvbXBpbGVyIHRvIGRvIGJ5dGUgYWNjZXNzZXMgKHdpdGggc2hpZnRzKQ0KPiBv
biBjcHUgdGhhdCBkb24ndCBzdXBwb3J0IG1pc2FsaWduZWQgbWVtb3J5IGFjY2Vzc2VzLg0KDQpS
aWdodCwgSSB1bmRlcnN0YW5kIHRoYXQgdXNpbmcgX19wYWNrZWQgaW52b2x2ZXMgYSBydW50aW1l
IHBlbmFsdHkgaGl0IG9uIG1lbW9yeSBhY2Nlc3NlcywgYnV0IEkgd2Fzbid0IHByb3Bvc2luZyB0
byBwYWNrIHRob3NlIHN0cnVjdHMsIGp1c3QgdG8gY2hlY2sgdGhlaXIgc2l6ZSBmb3IgcGFkZGlu
ZyBhdCBjb21waWxlLXRpbWUuDQoNCj4gU28gaXQgcmVhbGx5IGlzIHdyb25nIHRvIHNwZWNpZnkg
X19wYWNrZWQgdW5sZXNzIHRoZSBzdHJ1Y3R1cmUgY2FuIGJlDQo+IHVuYWxpZ25lZCBpbiBtZW1v
cnksIG9yIGhhcyBhICdicm9rZW4nIGRlZmluaXRpb24gdGhhdCBoYXMgZmllbGRzIHRoYXQNCj4g
YXJlbid0ICduYXR1cmFsbHkgYWxpZ25lZCcuDQoNCkJ1dCB3aG8gZGVmaW5lcyB3aGF0ICJicm9r
ZW4iIG9yICJuYXR1cmFsIGFsaWdubWVudCIgaXMgZm9yIGVhY2ggYXJjaGl0ZWN0dXJlPyBGdXJ0
aGVybW9yZSwgdGhlIEMgc3RhbmRhcmQgZG9lc24ndCByZWFsbHkgbWVudGlvbiBhbnkgb2YgdGhl
c2UgdGVybXMgYXMgZmFyIGFzIEkga25vdywgaXQganVzdCBsZWF2ZXMgY29tcGxldGUgZnJlZWRv
bSB0byB0aGUgY29tcGlsZXIgdG8gYWRkIHRoZSBwYWRkaW5nIGl0IG1pZ2h0IGNvbnNpZGVyIGFw
cHJvcHJpYXRlLg0KDQo+IEluIHRoZSBsYXR0ZXIgY2FzZSBpdCBpcyBlbm91Z2ggdG8gbWFyayB0
aGUgZmllbGQgdGhhdCByZXF1aXJlcyB0aGUNCj4gcGFkZGluZyBiZWZvcmUgaXQgcmVtb3ZlZCBh
cyAoSUlSQykgX19hbGlnbmVkKDEpLg0KPiBUaGUgY29tcGlsZXIgd2lsbCB0aGVuIHJlbW92ZSB0
aGUgcGFkZGluZyBidXQgc3RpbGwgYXNzdW1lIHRoZSBmaWVsZCBpcw0KPiBwYXJ0aWFsbHkgYWxp
Z25lZCAtIHNvIG15IGRvIHR3byAzMmJpdCBhY2Nlc3MgaW5zdGVhZCBvZiA4IDhiaXQgb25lcyku
DQoNCkludGVyZXN0aW5nLCBJIGhhdmUgbmV2ZXIgc2VlbiB0aGlzIHVzZWQgYmVmb3JlLCBidXQg
dGhlbiBhZ2FpbiBJIGNvbWUgZnJvbSBhbiAoZGVlcGx5KSBlbWJlZGRlZCBiYWNrZ3JvdW5kIHRo
YXQgdGVuZHMgdG8gcGFjayBhbGwgb2YgaXRzIHN0cnVjdHMgdGhhdCByZXByZXNlbnQgYnl0ZXMg
dGhhdCBnbyBvdmVyIHRoZSB3aXJlIChvciBoYXJkd2FyZSByZWdpc3RlcnMgZm9yIHRoYXQgbWF0
dGVyKS4NCg0KV2hhdCBpcyBhbHNvIGludGVyZXN0aW5nIGluIHRoaXMgY2FzZSwgaXMgd2h5IHRo
ZSBldGhlcm5ldCBoZWFkZXIgaXMgcGFja2VkIGluIExpbnV4WzJdLiBUaGVyZSBkb24ndCBzZWVt
IHRvIGJlIGFueSBzcGVjaWFsIGFsaWdubWVudCBvciBzaXplIGNvbnN0cmFpbnRzIHdoZW4gY29t
cGFyZWQgdG8gdGhlIElQIGhlYWRlcnMsIHNpbmNlIHRoZSBzaW5nbGUgMTYtYml0IGludGVnZXIg
aXMgcGxhY2VkIDEyIGJ5dGVzIGFmdGVyIHRoZSBiZWdpbm5pbmcgb2YgdGhlIHN0cnVjdC4gSSBh
c3N1bWUgdGhlIHJlYXNvbiBmb3IgcGFja2luZyB0aGlzIGhlYWRlciBpcyBpbmRlZWQgYWxpZ25t
ZW50LCBhbmQgbm90IHBhZGRpbmcuIFVubGlrZSB0aGUgSVAgaGVhZGVycywgdGhlIGtlcm5lbCBw
cm9iYWJseSBkb2Vzbid0IGVuc3VyZSB0aGF0IGFuIGV0aGVybmV0IGhlYWRlciBiZWdpbnMgYXQg
YW4gYWRkcmVzcyBjb21wYXRpYmxlIHdpdGggdGhlIGFsaWdubWVudCByZXF1aXJlbWVudHMgb2Yg
dGhhdCAxNi1iaXQgaW50ZWdlciwgc28gdGhlIGhlYWRlciBuZWVkcyBwYWNraW5nIG5vdCBiZWNh
dXNlIHRoZXJlJ3MgYSByaXNrIG9mIHBhZGRpbmcgYmVpbmcgaW50cm9kdWNlZCBieSB0aGUgY29t
cGlsZXIsIGJ1dCBiZWNhdXNlIHRoZSBoZWFkZXIgbWlnaHQgc3RhcnQgYXQgYW4gb2RkIG1lbW9y
eSBhZGRyZXNzPw0KDQpUaGFua3MsDQoNCkNhcmxlcw0KDQpbMl0gaHR0cHM6Ly9lbGl4aXIuYm9v
dGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9pbmNsdWRlL3VhcGkvbGludXgvaWZfZXRoZXIu
aCNMMTY5DQo=
