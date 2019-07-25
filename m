Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF97598C
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 23:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfGYV1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 17:27:07 -0400
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:14093
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfGYV1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 17:27:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YS/tAxrdYlIVXIMfnmKbgb6eMnOVEpWescRLxupM5U7tjxew4ky//nFqSYCh3l9jwqKTpDbBfo/f+qhOjoJSIrppTZO5Qr91kC6rL4wTu/cYw3awhTLfi43jrmEpwbWV07U4ZGHDJGHhbVjz020PKE56/ydJ4cWOsN0Mtbc80ywnKnva11NbFpv2BHDaVZtfNUNIOA21tyOU016pHU/y/WZ8ttkUvhak6f3oQXP0vcxFji7sBwZX+BhchQfeqsJ3cQ2TkhpuyN753jruGjPcR1VQMxnmrAZ5lhzPFDhjIYHgd4Z2g1BG1/twCz8P1/OlpQugHWMZhauGHaMkghpStA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RbAfa9dGA/7U6wKw6MiL4KbFKFo/dDzBDaBiXzYU0M=;
 b=jbqfkP2bDO3p4CGTHTkxCq48StYWh1hCrhhdWLpKqb5jVM8T2yriUdWPAa90iqWJihdFptibdGerhwmGenKgOqxdZYGEn722oDiWVFSqwbBortXEusMUvhqqcaK33pyxCLItXkXd0bBUZHe8J5KPpRyhSJP+jdWSYXy/jvio+6COHw0hOhRgLcVNB8CxfKCBR/jg1MZ/btPx9pPCqP/jRCKb4P/d9tjCG4GAv/RtI1u99Lz+XnVgylv7U8VJjxGrL5hat2DYsYk6EE4l7jHxutlFi/mhJuwRmJqt5nvZ+zl6qaxLg/6ydK1c62hB02kuttgmgfdcTePGDgLu/xrpQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RbAfa9dGA/7U6wKw6MiL4KbFKFo/dDzBDaBiXzYU0M=;
 b=ewyDA7tO2S5q115VZufJBmqQEDQ3gMB2SYVIDn14kHJKaXHwkm5hxZnQeyohv84/45BKofVqy7fkOhhQPwOUjsAt4sh64MyKeD1MxumKi0be0uslQwnzLusobZ4dksEyXHFrOgR2HnyXjiphZXmoU27RdbeVgr2wEWR8XaeFaiQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2280.eurprd05.prod.outlook.com (10.168.55.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 21:27:02 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 21:27:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
Thread-Topic: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
Thread-Index: AQHVQiiqTJlSndEpEUiixXCmHX0hZabaPY6AgAEGJICAAJdegA==
Date:   Thu, 25 Jul 2019 21:27:02 +0000
Message-ID: <f9ca12ff3880f94d4576ab4e4239f072ed611293.camel@mellanox.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
         <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
         <e007bac4c951486294d4e69d20f7c9ed7040172d.camel@mellanox.com>
         <73cd7a2a29db5a32d669273d367566cdf6652f4e.camel@redhat.com>
In-Reply-To: <73cd7a2a29db5a32d669273d367566cdf6652f4e.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab97b6f8-cf50-4b28-093d-08d71146d593
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2280;
x-ms-traffictypediagnostic: DB6PR0501MB2280:
x-microsoft-antispam-prvs: <DB6PR0501MB2280AE058A10A9CDFAC1DE4BBEC10@DB6PR0501MB2280.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(189003)(199004)(43544003)(3846002)(91956017)(8676002)(6512007)(107886003)(86362001)(316002)(110136005)(5660300002)(53936002)(6246003)(4326008)(66946007)(66556008)(76116006)(68736007)(66446008)(6506007)(6436002)(25786009)(58126008)(7736002)(14444005)(478600001)(256004)(305945005)(2501003)(81166006)(64756008)(102836004)(99286004)(81156014)(486006)(6116002)(8936002)(2906002)(76176011)(11346002)(2616005)(476003)(71200400001)(71190400001)(26005)(6486002)(66066001)(118296001)(229853002)(186003)(446003)(36756003)(66476007)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2280;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JUrSnbOxN8d3WHtvq9U3NnVt118BE8bqkFwS2ZgI+MgNV0Qsr1H6ClF7KMB9RyT8W+xhowvOTKx9S/aDrdlW5gLO5rKktWUeTzQ+KXAWLkpnsuy1E4lWyw2Tmx92gkhD1PSPjXTCjf0LmHymfZff8WRdecSBzrraQDZYx/0RyxhmYwXIxI55qosAsZvaMtFfWhuO9J8RfiSqqpZ0Hp2yEgDy/p3m7DoE9RytEkMaROBRGs4fsf/W/qWMZTExGIrZoNvQ24lF2cl5Vb/wu7r+0fLNelPk89aki4GXrrxgF4fx+wi02+ENrrHM7jH9XbWUI7EXsb4LUDsb8sGLmkuYXlME01F80lj89FFkoktUo30RZIPVwbIjPlF7X8YR4wZMAfyQAfSwu0mWXjQgoWHRrusu8GroCH2t45uKcf7Rb0Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D07962EBCCF7744C974F69160ACDDB33@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab97b6f8-cf50-4b28-093d-08d71146d593
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 21:27:02.3891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDE0OjI1ICswMjAwLCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToN
Cj4gT24gV2VkLCAyMDE5LTA3LTI0IGF0IDIwOjQ3ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBPbiBXZWQsIDIwMTktMDctMjQgYXQgMTY6MDIgKzAyMDAsIERhdmlkZSBDYXJhdHRp
IHdyb3RlOg0KPiA+ID4gZW5zdXJlIHRvIGNhbGwgbmV0ZGV2X2ZlYXR1cmVzX2NoYW5nZSgpIHdo
ZW4gdGhlIGRyaXZlciBmbGlwcyBpdHMNCj4gPiA+IGh3X2VuY19mZWF0dXJlcyBiaXRzLg0KPiA+
ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZGUgQ2FyYXR0aSA8ZGNhcmF0dGlAcmVkaGF0
LmNvbT4NCj4gPiANCj4gPiBUaGUgcGF0Y2ggaXMgY29ycmVjdCwgDQo+IA0KPiBoZWxsbyBTYWVl
ZCwgYW5kIHRoYW5rcyBmb3IgbG9va2luZyBhdCB0aGlzIQ0KPiANCj4gPiBidXQgY2FuIHlvdSBl
eHBsYWluIGhvdyBkaWQgeW91IGNvbWUgdG8gdGhpcyA/IA0KPiA+IGRpZCB5b3UgZW5jb3VudGVy
IGFueSBpc3N1ZSB3aXRoIHRoZSBjdXJyZW50IGNvZGUgPw0KPiA+IA0KPiA+IEkgYW0gYXNraW5n
IGp1c3QgYmVjYXVzZSBpIHRoaW5rIHRoZSB3aG9sZSBkeW5hbWljIGNoYW5naW5nIG9mIGRldi0N
Cj4gPiA+IGh3X2VuY19mZWF0dXJlcyBpcyByZWR1bmRhbnQgc2luY2UgbWx4NCBoYXMgdGhlIGZl
YXR1dHJlc19jaGVjaw0KPiA+IGNhbGxiYWNrLg0KPiANCj4gd2UgbmVlZCBpdCB0byBlbnN1cmUg
dGhhdCB2bGFuX3RyYW5zZmVyX2ZlYXR1cmVzKCkgdXBkYXRlcw0KPiB0aGUgKG5ldykgdmFsdWUg
b2YgaHdfZW5jX2ZlYXR1cmVzIGluIHRoZSBvdmVybHlpbmcgdmxhbjogb3RoZXJ3aXNlLA0KPiBz
ZWdtZW50YXRpb24gd2lsbCBoYXBwZW4gYW55d2F5IHdoZW4gc2tiIHBhc3NlcyBmcm9tIHZ4bGFu
IHRvIHZsYW4sDQo+IGlmIHRoZQ0KPiB2eGxhbiBpcyBhZGRlZCBhZnRlciB0aGUgdmxhbiBkZXZp
Y2UgaGFzIGJlZW4gY3JlYXRlZCAoc2VlOg0KPiA3ZGFkOTkzN2UwNjQNCj4gKCJuZXQ6IHZsYW46
IGFkZCBzdXBwb3J0IGZvciB0dW5uZWwgb2ZmbG9hZCIpICkuDQo+IA0KDQpidXQgaW4gcHJldmlv
dXMgcGF0Y2ggeW91IG1hZGUgc3VyZSB0aGF0IHRoZSB2bGFuIGFsd2F5cyBzZWVzIHRoZQ0KY29y
cmVjdCBod19lbmNfZmVhdHVyZXMgb24gZHJpdmVyIGxvYWQsIHdlIGRvbid0IG5lZWQgdG8gaGF2
ZSB0aGlzDQpkeW5hbWljIHVwZGF0ZSBtZWNoYW5pc20sIGZlYXR1cmVzX2NoZWNrIG5kbyBzaG91
bGQgdGFrZSBjYXJlIG9mDQpwcm90b2NvbHMgd2UgZG9uJ3Qgc3VwcG9ydC4NCg0KPiB0aGFua3Mh
DQo=
