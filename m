Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795A11004C5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKRLyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:54:36 -0500
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:29966
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726461AbfKRLyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 06:54:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGQVPW4p1u06/8d+wWCcZ5guNGQwIxNs6K7ApXyZKrmuHodxCi7gYdOyP3PN5MXnuTXjeB9FrpoYzV4d/1WKQL2rj5o8E961+HpvmT4GPnTQnNJ/+XkByu1b5M8PmOv5BwciIDzRbbV2lG6o5f/H9YfdW+bhjl8ZrLKaRQW4jZfAFzixTYDl9N1bBAwROL+laK9wfxTt+G+guObgfCkX4ctmms/pBgPlySlESMnu59pAEKedLIOb3VtIgLJXpv2aznGBINRpa1RI7XwZa2eyKDMGYO2szZAh5Adl3iboq0SW7mUQOWl7Bzzt4744JcKNLgZTXIqKpId5BsLhuLXvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm9Ds9S3VkfnS+UQkQgyuuV0Yea40IRJJroj5AwCR0M=;
 b=QOjr1kY1c3QJR7FQb0SplliSrt4wAwPEePeOF4F5zll0Dl/Iqx6uFIV9u9SKP5Erq1a4w1UeRnsyBFbwCY/SXMfa1ttq0tNG0XXkJByDIFDbUSpC9kUlg5pckuWu3sDfV0oQ06ES7lGG6tNTLmoGGAL8MW2K0ED2k33SskrlUvy+t5eX/wjaDAV/65oSVWdo+osAkStJLAKqDbpZx7/9KeLh8mliB3rwhuJIf2exrMVUGu8/umBWCW1vpXQ3gxpc7ijnW+eBRxhpiwAf/09qBewIjM8/RvSWkqajSJ4yPVWp+efG5RcI+cHTpTEaPgaeOATDlrSSR3N9gkJTKFzbvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm9Ds9S3VkfnS+UQkQgyuuV0Yea40IRJJroj5AwCR0M=;
 b=qaLfp32UXzkKlRiTGLapkX9XS8IvZzah/PVzJ4U4RHnWK5kx6GHpUeQacotRdsk3yeK9qSTHW1vluP+ZU21UBhbScPAINEvwDU9FVgJOc5Wy2FzEzR/+dYgOK+Ij2ypU2nLqhE6SjMLwqgrfTZ29mYuScMeo6P4rne3DJSfgN0A=
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com (20.178.124.149) by
 VI1PR05MB6320.eurprd05.prod.outlook.com (20.179.25.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Mon, 18 Nov 2019 11:54:32 +0000
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461]) by VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461%4]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 11:54:31 +0000
From:   Shay Drory <shayd@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lennart@poettering.net" <lennart@poettering.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        lorian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: Send SFP event from kernel driver to user space (UDEV)
Thread-Topic: Send SFP event from kernel driver to user space (UDEV)
Thread-Index: AQHVnTyemIrPi2KC+0KxDlDyt5FLmqeQJL4AgACuqIA=
Date:   Mon, 18 Nov 2019 11:54:31 +0000
Message-ID: <7dc1a44f-d15c-4181-df45-ae93cfd95438@mellanox.com>
References: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
 <20191118012924.GC4084@lunn.ch>
In-Reply-To: <20191118012924.GC4084@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shayd@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a2bcfb2-c53f-4219-7677-08d76c1e12f9
x-ms-traffictypediagnostic: VI1PR05MB6320:|VI1PR05MB6320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB632006DC0B6060808610F62EC24D0@VI1PR05MB6320.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(199004)(189003)(316002)(31696002)(7736002)(6246003)(6486002)(76176011)(6116002)(486006)(102836004)(2906002)(6512007)(14454004)(6506007)(3846002)(6436002)(4326008)(446003)(11346002)(25786009)(66556008)(476003)(8676002)(6916009)(8936002)(66446008)(2616005)(5660300002)(81166006)(81156014)(186003)(26005)(229853002)(76116006)(66946007)(305945005)(64756008)(66476007)(66066001)(53546011)(478600001)(256004)(99286004)(71190400001)(54906003)(71200400001)(36756003)(31686004)(554214002)(86362001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6320;H:VI1PR05MB5680.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KP6enxeNv9NfV+5qpArXOeTenLqbXqsB9f/xfaVjenrY666ZJlU6GvOMoSuCnMVWDiq4zXqPoCNdVHu6RxhfnwqMbsf5RrFpfx0HyGLVWLwIwqoWsrsmIhWgBqz6hRFRsqkQ8VAhcIeiXYMYBmSlGU9YMbQVBg4BU4lYynIm+/rbCMEeXqkyDcpTdx+2gKKz80BIDbTq5T2OGKb7idbZniOK/wa1qfFRtKO9Qaw+7/7Wa/U6YZFi5jyNQU1QuOnAV4i7G+I9lkq4hd2dWREc1JhduOijQQ+bhANBCMkJhh+/tA5aApGFbk4wGOfljlAqIwYJefJk7yOkY6rrS8FPajSiih2gVE8eplITxTZKKCkoZgubAE01QLGZTniDkWzMiNeXISM0eBKyvUyfT2BnJ179if6F7CcFHukb6nP7FeDNKjsc3Tf4HotvpZMrkyv0
Content-Type: text/plain; charset="utf-8"
Content-ID: <E71223BA688AA34DA4CF1FD82C4732E4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2bcfb2-c53f-4219-7677-08d76c1e12f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 11:54:31.7632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bM/u3WQ5E1OcRxMkRQtFe8uy7dEIc97FNlhDhMML9NWF/nnMhAFpl4fksQtKFfIACNSyJAM10oHtEt6FQt7M0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6320
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTgvMjAxOSAwMzoyOSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFN1biwgTm92IDE3
LCAyMDE5IGF0IDExOjQ2OjE1QU0gKzAwMDAsIFNoYXkgRHJvcnkgd3JvdGU6DQo+DQo+IEhpIFNo
YXkNCj4NCj4gSXQgd291bGQgYmUgZ29vZCB0byBDYzogdGhlIGdlbmVyaWMgU0ZQIGNvZGUgbWFp
bnRhaW5lcnMuDQoNClRoZSBzdWdnZXN0ZWQgc29sdXRpb24gaXMgbm90IHRhcmdldGVkIGZvciBT
RlAgZHJpdmVycyAoc2VlIGJlbG93KSwNCmJ1dCBJIGFkZGVkIHRoZW0gdG8gdGhlIENjIGxpc3Qu
DQoNCj4NCj4+IFRvZGF5LCBTRlAgaW5zZXJ0ZWQgLyByZW1vdmFsIGV2ZW50IGltcGFjdHMgb25s
eSB0aGUga2VybmVsIHNwYWNlIGRyaXZlcnMuDQo+PiBUaGVyZSBhcmUgdXNlcnMgd2hvIHdpc2hl
cyB0byBnZXQgU0ZQIGluc2VydCAvIHJlbW92YWwgaW4gYSB1ZGV2LWV2ZW50DQo+PiBmb3JtYXQg
Zm9yIHRoZWlyIGFwcGxpY2F0aW9uIC8gZGFlbW9ucyAvIG1vbml0b3JzLg0KPj4gVGhlIG5haXZl
IHdheSB0byBpbXBsZW1lbnQgdGhpcyBmZWF0dXJlIHdvdWxkIGJlIHRvIGNyZWF0ZSBhIHN5c2Zz
IGZpbGUNCj4+IHRoYXQgcmVwcmVzZW50cyBkZXZpY2UgU0ZQLCB0byBleHBvc2UgaXQgdW5kZXIg
dGhlIG5ldGRldiBzeXNmcywgYW5kDQo+PiB0byByYWlzZSBhIHVkZXYgZXZlbnQgb3ZlciBpdC4N
Cj4+IEhvd2V2ZXIsIGl0IGlzIG5vdCByZWFzb25hYmxlIHRvIGNyZWF0ZSBhIHN5c2ZzIGZvciBl
YWNoIG5ldC1kZXZpY2UuDQo+PiBJbiB0aGlzIGxldHRlciwgSSB3b3VsZCBsaWtlIHRvIG9mZmVy
IGEgbmV3IG1lY2hhbmlzbSB0aGF0IHdpbGwgYWRkIGENCj4+IHN1cHBvcnQgdG8gc2VuZCBTRlAg
ZXZlbnRzIGZyb20gdGhlIGtlcm5lbCBkcml2ZXIgdG8gdXNlciBzcGFjZS4NCj4+IFRoaXMgc3Vn
Z2VzdGlvbiBpcyBidWlsdCB1cG9uIGEgbmV3IG5ldGxpbmsgaW5mcmFzdHJ1Y3R1cmUgZm9yIGV0
aHRvb2wNCj4+IGN1cnJlbnRseSBiZWluZyB3cml0dGVuIGJ5IE1pY2hhbCBLdWJlY2t3aGljaCBj
YWxsZWQg4oCcZXRodG9vbC1uZXRsaW5r4oCdWzFdLg0KPiBTbyB5b3UgYXJlIGluIG5vIHJ1c2gg
dG8gbWFrZSB1c2Ugb2YgdGhpcz8gZXRodG9vbC1ubCBzZWVtcyB0byBiZQ0KPiBtYWtpbmcgdmVy
eSBzbG93IHByb2dyZXNzLg0KDQpJIGFtIGxvb2tpbmcgZm9yIHRoZSBjb3JyZWN0IHNvbHV0aW9u
IHRoYXQgd2UgY2FuIHB1c2ggdG8ga2VybmVsIG9wZW4gc291cmNlLg0KVGhlIGV0aHRvb2wtbmwg
c2VlbXMgbGlrZSBhIGdvb2QgcGF0aC4gSWYgeW91IGhhdmUgYW5vdGhlciBzdWdnZXN0aW9uLA0K
YmFzZSBvbiBleGlzdGluZyBjb2RlLCBJIHdpbGwgYmUgZ2xhZCB0byBoZWFyLg0KDQo+DQo+PiBN
eSBzdWdnZXN0aW9uIGlzIHRvIGRvIGl0IGJ5IGFkZGluZyBhIGZ1bmN0aW9uDQo+PiAoZXRodG9v
bF9zZnBfaW5zdGVydGVkL3JlbW92ZWQoLi4uKSkgdG8gZXRodG9vbCBBUEksIFRoaXMgZnVuY3Rp
b24gd2lsbA0KPj4gcmFpc2UgYSBuZXRsaW5rIGV2ZW50IHRvIGJlIGNhdWdodCBpbiB1c2VyIHNw
YWNlLg0KPiBXaGF0IGFib3V0IHRoZSBjYXNlIG9mIHRoZSBTRlAgaXMgaW5zZXJ0ZWQgYmVmb3Jl
IHRoZSBTRlAgaXMNCj4gYXNzb2NpYXRlZCB0byBhIG5ldGRldj8gU2ltaWxhcmx5LCB0aGUgU0ZQ
IGlzIGVqZWN0ZWQgd2hlbiB0aGUgU0ZQIGlzDQo+IG5vdCBjb25uZWN0ZWQgdG8gYSBNQUMuIFlv
dSBkb24ndCBoYXZlIGEgbmV0ZGV2LCBzbyB5b3UgY2Fubm90IHNlbmQgYW4NCj4gZXZlbnQuIEFu
ZCBTRkYsIHdoaWNoIGFyZSBuZXZlciBpbnNlcnRlZCBvciByZW1vdmVkPyBTRlBzIGhhdmUgYQ0K
PiBkaWZmZXJlbnQgbGlmZSBjeWNsZSB0byBhIG5ldGRldi4gRG8geW91IGNhcmUgYWJvdXQgdGhp
cz8NCg0KVGhlIGZlYXR1cmUgaXMgdGFyZ2V0ZWQgdG8gbmV0ZGV2IHVzZXJzLiBJdCBpcyBleHBl
Y3RlZCBmcm9tIHRoZSB1c2VyIHRvIHF1ZXJ5IGN1cnJlbnQgc3RhdGUgdmlhDQpldGh0b29sIC1t
IGFuZCBhZnRlcndhcmRzIG1vbml0b3IgZm9yIGNoYW5nZXMgb3ZlciBVREVWLg0KDQo+DQo+PiBU
aGUgZGVzaWduOg0KPj4NCj4+IC0gU0ZQIGV2ZW50IGZyb20gTklDIGNhdWdodCBieSB0aGUgZHJp
dmVyDQo+PiAtIERyaXZlciBjYWxsIGV0aHRvb2xfc2ZwX2luc2VydGVkL3JlbW92ZWQoKQ0KPj4g
LSBFdGh0b29sIGdlbmVyYXRlZCBuZXRsaW5rIGV2ZW50IHdpdGggcmVsZXZhbnQgZGF0YQ0KPj4g
LSBUaGlzIGV2ZW50LW1lc3NhZ2Ugd2lsbCBiZSBoYW5kbGVkIGluIHRoZSB1c2VyLXNwYWNlIGxp
YnJhcnkgb2YgVURFVg0KPj4gKGZvciB0aGlzIHB1cnBvc2Ugd2Ugd291bGQgbGlrZSB0byBhZGQg
YSBuZXRsaW5rIGluZnJhc3RydWN0dXJlIHRvIFVERVYNCj4+IHVzZXItc3BhY2UgbGlicmFyeSku
DQo+IFdvdWxkIHlvdSBhZGQganVzdCBTRlAgaW5zZXJ0L2VqZWN0IHRvIFVERVYuIE9yIGFsbCB0
aGUgZXZlbnRzIHdoaWNoDQo+IGdldCBzZW50IHZpYSBuZXRsaW5rPyBMaW5rIHVwL2Rvd24sIHJv
dXRlIGFkZC9yZW1vdmUsIGV0Yz8NCg0KSXQgbWFrZXMgc2Vuc2UgdG8gbm90aWZ5IGFsbCBldmVu
dHMuIFdoYXQgZG8geW91IHRoaW5rPw0KDQo+DQo+IFdoYXQgc29ydCBvZiBkYWVtb24gaXMgdGhp
cyBhbnl3YXk/IE1vc3QgbmV0d29ya2luZyBkYWVtb25zIGFscmVhZHkNCj4gaGF2ZSB0aGUgY29k
ZSB0byBsaXN0ZW4gdG8gbmV0bGluayBldmVudHMuIFNvIHdoeSBjb21wbGljYXRlIHRoaW5ncyBi
eQ0KPiB1c2luZyBVREVWPw0KDQpUaGF0IGlzIGEgZ29vZCBwb2ludCwgd2Ugd2lsbCBkaXNjdXNz
IGl0IGludGVybmFsbHkuDQoNCj4NCj4gSXMgVURFViBuYW1lIHNwYWNlIGF3YXJlPyBEbyB5b3Ug
cnVuIGEgdWRldiBkYWVtb24gaW4gZWFjaCBuZXR3b3JrDQo+IG5hbWUgc3BhY2U/IEkgYXNzdW1l
IHdoZW4geW91IG9wZW4gYSBuZXRsaW5rIHNvY2tldCwgaXQgaXMgZm9yIGp1c3QNCj4gdGhlIGN1
cnJlbnQgbmV0d29yayBuYW1lc3BhY2U/DQoNClVERVYgd2lsbCBmb2xsb3cgbmV0bGluayBuYW1l
LXNwYWNlLg0KDQo+DQo+ICAgICAgQW5kcmV3DQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50cywg
U2hheS4NCg0KDQo=
