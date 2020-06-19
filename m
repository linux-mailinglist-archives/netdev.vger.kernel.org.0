Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643382001BE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 07:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgFSFqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 01:46:33 -0400
Received: from mail-eopbgr1310128.outbound.protection.outlook.com ([40.107.131.128]:29376
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728809AbgFSFqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 01:46:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHJ+XzTBg720W/BNAz6HQYk0BzTfuGS5//gc16Qm5uLYfecGmj5LPON6m4sg6Lc9nkjsFWq7M2qNipfIo3abSy25iasuEYYpVRAdNapFC/eupzp1hE+v7/ynTCT5g8w7X7X7pucbpqhVXWSpxjyYaNyXhWs7Ef3TulD9q3K4uPQdw7XVGRVDyMWjZZvCzEHVE2v1lheVOYpTjrHyTH43n+Z532QajsNp29xxp6iFUC58DWqCxcKR4JwZ+fai1JbaAYs54EswtvUKjpaWxJ8iG7SeltC/u+c3ZYeDO7I+iSiPnp964JtKu28rIbDrSN9ZxAjIj32lvBPiPKex9XgSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESRD9MIwwy4T70AyFDu5tkk/2VA1u0mT9YPw/xhx1do=;
 b=krH6S/qzeNLaQU6W/zRvTz1QHf0CHEA8CF1iQ7SWraKfzU2T1D9Z48N2vWr14Z9GQ0mVrlNzwgOLjIyvK7dZtmaNrUdhXGVuf6N1BZonYX92GP8JSgarNN0e08Ac2vp8VJq4CTUxkULTe9lpudbkkuKBKcnVNzzeYq5Dmr9bE7GX9uEwUB1sKi/reTdAlLSl6ozU/m8oLcj+z2fogQfIRs7IRZ7oNpG3/NiuZCvnApVMZzQ1qiKZG5whxM1tJDTBlT6qYYpOro+mWdKJvGscCMI6TnpPPKecdbqvjY5EJ2XwRVxXupJh0qJy7O3iOp5qpwxdkjyZUd3dpURNMfrT7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESRD9MIwwy4T70AyFDu5tkk/2VA1u0mT9YPw/xhx1do=;
 b=J0G0ygxpznN81Brz3EiC358QSyjuR3vZI2vOtM2J23RGv31ArIOXmryR5/OIptqZJfixd3C7vr7n7dsgOXywfO/SX6BWvWivyatp9wlAYJ/QiH1dItk0QB+VJ824zbyWTveOyeARK6CEsPjXNVMTjBiKIjBmmpoIm+6S0fJwoVc=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB2251.jpnprd01.prod.outlook.com (2603:1096:404:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Fri, 19 Jun
 2020 05:46:15 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::2da1:bdb7:9089:7f43]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::2da1:bdb7:9089:7f43%3]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 05:46:15 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Topic: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
Thread-Index: AQHWM0Kg7roEc2K3tEugD8qfTO7LKKjZTL9ggAAmMYCABhvkIA==
Date:   Fri, 19 Jun 2020 05:46:15 +0000
Message-ID: <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
In-Reply-To: <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 19f62e9b-71ef-4f49-6d68-08d8141414fb
x-ms-traffictypediagnostic: TY2PR01MB2251:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TY2PR01MB2251502A8CAB2690F63CC77DD8980@TY2PR01MB2251.jpnprd01.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0439571D1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AJ+/f/EV+L28jmootD7bqeHXn/Cr1LO5N1WxiKFUAr5ZxspatuGiu8UG6XN5SKEMKHSXNcQYyc1vTd3LS1urNmcpdZ7bNdgYswqrp7rnmUBgFsDx59DE0V6keM4I7p5Okr6b3lXM14FEv/WtabIZ/xEa7L+gZkDPSmI1vIvBfrnqx4h+O1q8q90lAhFHp6ffhZbiXQNIVVL4ad9WPMm/myLSnjZtb6ne0gX+jv/8wkSFjAbdK4RBG1n9/OT8Ah7SYshUn63ZB1eGDcLsBAA6VYStCyg3fHuHY/Ha20pRyVoqhAm1lNmcIl1MPQNPYa8NJQdp9AXvCVfRbaEDmgJLHQ6Ss4lF+E1tHJTDq5yjHYLxhHl0R+TJOzUcGW3gkcKBe/UBaYqjzwPYuW1vInM8/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(6506007)(55236004)(53546011)(2906002)(33656002)(71200400001)(55016002)(26005)(66946007)(76116006)(186003)(66556008)(8676002)(64756008)(9686003)(66446008)(86362001)(8936002)(66476007)(966005)(4326008)(7696005)(478600001)(54906003)(52536014)(5660300002)(316002)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9PjVY9sLVs3y72t2gunSa73WnmQEl2JJeLHYwf7mv4wuuKGyf+5mXLsl56U4dygOX3Tl5l71G7l3FZalow8AZV40AuN97VZXqwPhSs7YuwWA6IRt7QqUFdTwKaeYUIjmRfydfs19OTtWi/fuKvpDshroXPNqtbDEcEj0doSVXZ7oh1lIZBxNHwgHfk2uX8ZulOnRQpnvbpJFIoQ57jkskenMDsVJ0fzdX79aoV/qr+X1nm9mXNWnFOUdMcNNZrOAayLd7XjMRMQZea0rndfyzRZS9QiOfyQUZ1hRXM++0uHRnIeGvUHfIe7jnOrQzVk3gAQCg0JS+LL+obyQY0BgM/GIytJ++cfekZsZ78L3v5rknGJJXTmFb8TDkLFwBSNMqCWEnD4Iro8U9RvpLFhghet8gkx3zipg5CL5DyDe7sBTZX2Hll6EnIkEymkTRfuob58/5xfcpFAlCrKLwZMWgdlQtife9NN+NyHMiMwNw7HaUC7nB5Xj7zqGXOHVq+f8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f62e9b-71ef-4f49-6d68-08d8141414fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2020 05:46:15.5819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbNwpJXrMktEuFzkZE61E2vl/TICFgGyzL6D69FcAChS02/0GNzGmqxikajaV+sfDjcw5j1oUhirm4P2PGKcncFOceUCVz6qj9jKABHM8zrdOGsvCqghvZQBMfM7B9cq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2251
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogU2VyZ2VpIFNodHlseW92LCBTZW50OiBNb25kYXksIEp1bmUgMTUs
IDIwMjAgNToxMyBQTQ0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiAxNS4wNi4yMDIwIDg6NTgsIFlv
c2hpaGlybyBTaGltb2RhIHdyb3RlOg0KPiANCj4gPj4gRnJvbTogWW9zaGloaXJvIFNoaW1vZGEs
IFNlbnQ6IFR1ZXNkYXksIE1heSAyNiwgMjAyMCA2OjQ3IFBNDQo+ID4+DQo+ID4+IEFjY29yZGlu
ZyB0byB0aGUgcmVwb3J0IG9mIFsxXSwgdGhpcyBkcml2ZXIgaXMgcG9zc2libGUgdG8gY2F1c2UN
Cj4gPj4gdGhlIGZvbGxvd2luZyBlcnJvciBpbiByYXZiX3R4X3RpbWVvdXRfd29yaygpLg0KPiA+
Pg0KPiA+PiByYXZiIGU2ODAwMDAwLmV0aGVybmV0IGV0aGVybmV0OiBmYWlsZWQgdG8gc3dpdGNo
IGRldmljZSB0byBjb25maWcgbW9kZQ0KPiA+Pg0KPiA+PiBUaGlzIGVycm9yIG1lYW5zIHRoYXQg
dGhlIGhhcmR3YXJlIGNvdWxkIG5vdCBjaGFuZ2UgdGhlIHN0YXRlDQo+ID4+IGZyb20gIk9wZXJh
dGlvbiIgdG8gIkNvbmZpZ3VyYXRpb24iIHdoaWxlIHNvbWUgdHggcXVldWUgaXMgb3BlcmF0aW5n
Lg0KPiA+PiBBZnRlciB0aGF0LCByYXZiX2NvbmZpZygpIGluIHJhdmJfZG1hY19pbml0KCkgd2ls
bCBmYWlsLCBhbmQgdGhlbg0KPiA+PiBhbnkgZGVzY3JpcHRvcnMgd2lsbCBiZSBub3QgYWxsb2Nh
bGVkIGFueW1vcmUgc28gdGhhdCBOVUxMIHBvcmludGVyDQo+ID4+IGRlcmVmZXJlbmNlIGhhcHBl
bnMgYWZ0ZXIgdGhhdCBvbiByYXZiX3N0YXJ0X3htaXQoKS4NCj4gPj4NCj4gPj4gU3VjaCBhIGNh
c2UgaXMgcG9zc2libGUgdG8gYmUgY2F1c2VkIGJlY2F1c2UgdGhpcyBkcml2ZXIgc3VwcG9ydHMN
Cj4gPj4gdHdvIHF1ZXVlcyAoTkMgYW5kIEJFKSBhbmQgdGhlIHJhdmJfc3RvcF9kbWEoKSBpcyBw
b3NzaWJsZSB0byByZXR1cm4NCj4gPj4gd2l0aG91dCBhbnkgc3RvcHBpbmcgcHJvY2VzcyBpZiBU
Q0NSIG9yIENTUiByZWdpc3RlciBpbmRpY2F0ZXMNCj4gPj4gdGhlIGhhcmR3YXJlIGlzIG9wZXJh
dGluZyBmb3IgVFguDQo+ID4+DQo+ID4+IFRvIGZpeCB0aGUgaXNzdWUsIGp1c3QgdHJ5IHRvIHdh
a2UgdGhlIHN1YnF1ZXVlIG9uDQo+ID4+IHJhdmJfdHhfdGltZW91dF93b3JrKCkgaWYgdGhlIGRl
c2NyaXB0b3JzIGFyZSBub3QgZnVsbCBpbnN0ZWFkDQo+ID4+IG9mIHN0b3AgYWxsIHRyYW5zZmVy
cyAoYWxsIHF1ZXVlcyBvZiBUWCBhbmQgUlgpLg0KPiA+Pg0KPiA+PiBbMV0NCj4gPj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmVuZXNhcy1zb2MvMjAyMDA1MTgwNDU0NTIuMjM5MC0x
LWRpcmsuYmVobWVAZGUuYm9zY2guY29tLw0KPiA+Pg0KPiA+PiBSZXBvcnRlZC1ieTogRGlyayBC
ZWhtZSA8ZGlyay5iZWhtZUBkZS5ib3NjaC5jb20+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IFlvc2hp
aGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4NCj4gPj4gLS0t
DQo+ID4+ICAgSSdtIGd1ZXNzaW5nIHRoYXQgdGhpcyBpc3N1ZSBpcyBwb3NzaWJsZSB0byBoYXBw
ZW4gaWY6DQo+ID4+ICAgLSByYXZiX3N0YXJ0X3htaXQoKSBjYWxscyBuZXRpZl9zdG9wX3N1YnF1
ZXVlKCksIGFuZA0KPiA+PiAgIC0gcmF2Yl9wb2xsKCkgd2lsbCBub3QgYmUgY2FsbGVkIHdpdGgg
c29tZSByZWFzb24sIGFuZA0KPiA+PiAgIC0gbmV0aWZfd2FrZV9zdWJxdWV1ZSgpIHdpbGwgYmUg
bm90IGNhbGxlZCwgYW5kIHRoZW4NCj4gPj4gICAtIGRldl93YXRjaGRvZygpIGluIG5ldC9zY2hl
ZC9zY2hfZ2VuZXJpYy5jIGNhbGxzIG5kb190eF90aW1lb3V0KCkuDQo+ID4+DQo+ID4+ICAgSG93
ZXZlciwgdW5mb3J0dW5hdGVseSwgSSBkaWRuJ3QgcmVwcm9kdWNlIHRoZSBpc3N1ZSB5ZXQuDQo+
ID4+ICAgVG8gYmUgaG9uZXN0LCBJJ20gYWxzbyBndWVzc2luZyBvdGhlciBxdWV1ZXMgKFNSKSBv
ZiB0aGlzIGhhcmR3YXJlDQo+ID4+ICAgd2hpY2ggb3V0LW9mIHRyZWUgZHJpdmVyIG1hbmFnZXMg
YXJlIHBvc3NpYmxlIHRvIHJlcHJvZHVjZSB0aGlzIGlzc3VlLA0KPiA+PiAgIGJ1dCBJIGRpZG4n
dCB0cnkgc3VjaCBlbnZpcm9ubWVudCBmb3Igbm93Li4uDQo+ID4+DQo+ID4+ICAgU28sIEkgbWFy
a2VkIFJGQyBvbiB0aGlzIHBhdGNoIG5vdy4NCj4gPg0KPiA+IEknbSBhZnJhaWQsIGJ1dCBkbyB5
b3UgaGF2ZSBhbnkgY29tbWVudHMgYWJvdXQgdGhpcyBwYXRjaD8NCj4gDQo+ICAgICBJIGFncmVl
IHRoYXQgd2Ugc2hvdWxkIG5vdyByZXNldCBvbmx5IHRoZSBzdHVjayBxdWV1ZSwgbm90IGJvdGgg
YnV0IEkNCj4gZG91YnQgeW91ciBzb2x1dGlvbiBpcyBnb29kIGVub3VnaC4gTGV0IG1lIGhhdmUg
YW5vdGhlciBsb29rLi4uDQoNClRoYW5rIHlvdSBmb3IgeW91ciBjb21tZW50ISBJIGhvcGUgdGhp
cyBzb2x1dGlvbiBpcyBnb29kIGVub3VnaC4uLg0KDQoNCkJ5IHRoZSB3YXksIHRoZXJlIGlzIG90
aGVyIHRvcGljIHRob3VnaCwgSSdtIHRoaW5raW5nIHdlIHNob3VsZCBub3QgY2FsbA0KcmF2Yl97
Y2xvc2Usb3Blbn0oKSBpbiByYXZiX3tzdXNwZW5kLHJlc3VtZX0oKSBiZWNhdXNlIHRoaXMgaXMg
cG9zc2libGUgdG8NCmEgcmFjZSBjb25kaXRpb24gYmV0d2VlbiBpZmNvbmZpZyB1cC9kb3duIGFu
ZCBzeXN0ZW0gc3VzcGVuZC9yZXN1bWUuDQpJbiBvdGhlciB3b3JkcywgSSdtIHRoaW5raW5nIHRo
aXMgc2hvdWxkIG5vdCBmcmVlL3JlYWxsb2NhdGUNCmRtYSBtZW1vcnkgd2hpbGUgbmV0aWZfcnVu
bmluZyBpcyB0cnVlLiBCdXQsIHdoYXQgZG8geW91IHRoaW5rPw0KDQpCZXN0IHJlZ2FyZHMsDQpZ
b3NoaWhpcm8gU2hpbW9kYQ0KDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdlaQ0K
