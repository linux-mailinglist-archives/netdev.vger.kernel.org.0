Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9EF1C66A0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 06:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgEFEO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 00:14:56 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:5444
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbgEFEO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 00:14:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bs2tODpNZ5/yGy2VChJ9u70xTATPZVa0M1XpQ8IK61v26oCTpu9bi/thUuykRx0SYYPx+PtqDyFFgC3XXzDggrswp6Jb4YBiqJ674gtEdiwHY7ngZ6W2HJLbtzChPTlddkKuEGWy5jX/LyLekx5BmTNpeZBsGOnyCrIygWRGxpSFmuu5ZEBpJdufr5r7ynKPFYMpYAmDS39yBYyU/ySdpyF4YJW/Pbt7mvw7ZQl1/bJzqEtlHe7+8yKkvEaqCDt/+B5lHlt2tVn8LPEmWDSDkCPILt1UaQnfo3RcBDR5vdanx4bQX4X/mvFrRnOc2uEq0P5B7wmLnhFrqAjRyqNDoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1nC//0ruIVF8uSTmZzNPy5WxR9oB39H0X5Lq3MxMwM=;
 b=YvOngeA9/05o+Gk+TJd8+jZ18JLyfcOGfQC/0hbdy13Z6R46oJJMRb7+VmrmucsleBsQ5OKoXuqDAMk2PrY/HFQYLfv5uEMQwuHON0BI2IgGRlK0tlVU1HPfHZtrfqX/0qBQd1hfyMaGVZn1n3ODIyfxvdhBL4G2US6axNV9ctvLrjJIJuXBnXAMWYbBM1JT8bjMYcLP5Mv2elKtjH2cbraRGFwiVdc/lpM3ugN8/JRgzGLM/yUZNBMknsq1vaPGARjYbEBzY7fxHNj+T+hvGOBCgbQHSXUnVxANbwEk67zmmD80/jnKr2lB5s01udNthZ+/oHJazbH32NObueIIYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1nC//0ruIVF8uSTmZzNPy5WxR9oB39H0X5Lq3MxMwM=;
 b=T4cSJXJNcPm7EQuHCPU/nDLUMfAb5caOBZAfNnhOKVZizGW/H7s18M1ssAaJkFADZ9iNsznhHFQt+u8wwgB/sRRsohrtCdKLKVPJh7/zdoPhGxoNk+Cwqo54+vifdfFHLdh2c4pYKE9iW7SWTQZLPN8vs7nXz0DphC5uKF8LfG4=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6526.eurprd04.prod.outlook.com (2603:10a6:803:11d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 6 May
 2020 04:14:50 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 04:14:50 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE:  [PATCH net-next] enetc: Fix use after free in
 stream_filter_unref()
Thread-Topic: [PATCH net-next] enetc: Fix use after free in
 stream_filter_unref()
Thread-Index: AdYjXNNfSiDFKk+lRwOD0iff3ewHXQ==
Date:   Wed, 6 May 2020 04:14:49 +0000
Message-ID: <VE1PR04MB6496EA13ABB5C079D314EE8792A40@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [123.123.61.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5ff4e9cc-b7c3-4b91-ad0e-08d7f1740523
x-ms-traffictypediagnostic: VE1PR04MB6526:|VE1PR04MB6526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6526B0145D631509584A3F3092A40@VE1PR04MB6526.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03950F25EC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eVq7oECH0BH/lyAOl7pzJc9a63xnGMrDWeMVbMKDGHCVsdI4UPgAshh/N9nYwq0NyU7oLGi370lVphNTvqHiNyIAHzaPUPvgKDWQ4b21roFArDs5eVtu8j4r/1EMOWkUg0Lwme+5GI7GpM4sq6WP4mn8NWSM6V0PuF75ew6h0VilyAg3p25yQWdWlA9ejP1Psujm8jHLnZz8Vh1Cn5JgL+l4lWdyHISYQ1AHJmLShs5LKAezWVFDhNA5eF/LqZPfUcmCrL4ES2bsKFDfkbB8cGO6Nne5H2Vv9lBe2OZXIDkNTHQBshxJpELLnj2opOrZIKuzTezGfp4YtOkNb5irrZdZbWd7QjuAZn0wEZZEBlIpFY9IjkH6WdvtlqbgEVQ/hHUlbEYYqy33vAKDMeWf48h0NAExnTN4MIcOQI42X3eKbJKJltJ2p4bFQfV1TqGfihXV9avgvBWAN9o4x9DHPiJVFas3r8z0Fgturfv/E/aHpqqvJnrecrCxzHvi4nKd37RaimWpaCb0WtkkyIFOtyA9tKLJlGmfWMHcncuSsH8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(33430700001)(8676002)(6636002)(7696005)(26005)(8936002)(5660300002)(9686003)(55016002)(53546011)(6506007)(186003)(110136005)(54906003)(52536014)(478600001)(33440700001)(316002)(71200400001)(33656002)(66476007)(66946007)(66556008)(66446008)(4326008)(2906002)(64756008)(76116006)(44832011)(86362001)(9126004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: e9e3RFKxKSwRsx+ztSFfBrW4LlVV0BIdyyvFN15C40tkITEW3Zocx6T26uhwUlnSVPgiB0m4a1QGiHE+0rwNmouVlUvmO/soBo4lVXK4fHEFeAeMK38ayxC4VhJZTAY3tNi0w+PhVoEAeqa7UCFHhHQAy5EqEVk7Ta9tnGs3tozRK+wMVNVomqGBCb8Ij4i5D7yK9ybXfz9Qk1mnZdwHvzr/2NJvToWa1VOXOBg+CtzfmD7XFJgGvd8/QIfydBspNrudIr/2Ta/aYk5bVqyDqDYakH3hJ/2QJhGfRnOdp6JS9QGOAT6Rw2+O31+usM3cOlA1Sv4FBaomuhX0vvm2hMfVdoRW6kzoEQKBM08f7vaj7b24XkWUSU6A7/ZF4Y8u5EaXyS8MrAuBlK7X94+IqzrtdZzB0LbY3MTjlH5HojCfwm08p3VzhK4aMj9FKxMsIT3ZjZMjkWT24ekmIcjnrr1VPbx/iBO/bEp50KK/fTotmM/xk5dEqLkTaPnKVzb0xkdKy4iFBmvG3plJeq2oa24Fz1lOQit6hQV7BnSN0qow8KDmpAqSJR3OIKY+tfGOLbWP2PztAZWp5qhNZ9HylGSLhKIK+z8HweUiO1DiGIk/32T+RdktGCwMjyy2CzmyGT6lIObHfgo7i1t+5Ve+xBx8Kb0/PnwviTPGyFvxOopISvRpG3nMaPqxX1ZT8Jga8mqXY+jswXXmvgkfMkYnJD3KCneZ3fIAkCbjKk62orgpMfelLdqaI/aajlb2sQXCzandscIZzAmkMpOSUHwa7Vm239kwfLEa5L3SH87U70o=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff4e9cc-b7c3-4b91-ad0e-08d7f1740523
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2020 04:14:49.9889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3SAlJATjcSYDvPMFkPtHV+3vFDbKTy4WXa14xUdtZl0ysRqZrHK7DIMctgjBrpps
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6526
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGFuLA0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuIENh
cnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPiBTZW50OiAyMDIwxOo11MI2yNUg
NDo0Nw0KPiBUbzogQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBQbyBM
aXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4ga2VybmVsLWphbml0b3JzQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHRdIGVuZXRjOiBGaXggdXNlIGFm
dGVyIGZyZWUgaW4NCj4gc3RyZWFtX2ZpbHRlcl91bnJlZigpDQo+IA0KPiANCj4gVGhpcyBjb2Rl
IGZyZWVzICJzZmkiIGFuZCB0aGVuIGRlcmVmZXJlbmNlcyBpdCBvbiB0aGUgbmV4dCBsaW5lLg0K
PiANCj4gRml4ZXM6IDg4OGFlNWEzOTUyYiAoIm5ldDogZW5ldGM6IGFkZCB0YyBmbG93ZXIgcHNm
cCBvZmZsb2FkIGRyaXZlciIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5j
YXJwZW50ZXJAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZW5ldGMvZW5ldGNfcW9zLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcW9zLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcW9zLmMNCj4gaW5kZXggNDhlNTg5ZTlkMGY3Yy4u
MTBkNzllYjQ2YzJlOCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2VuZXRjL2VuZXRjX3Fvcy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9lbmV0Yy9lbmV0Y19xb3MuYw0KPiBAQCAtOTAyLDggKzkwMiw4IEBAIHN0YXRpYyB2b2lk
IHN0cmVhbV9maWx0ZXJfdW5yZWYoc3RydWN0DQo+IGVuZXRjX25kZXZfcHJpdiAqcHJpdiwgdTMy
IGluZGV4KQ0KPiAgICAgICAgIGlmICh6KSB7DQo+ICAgICAgICAgICAgICAgICBlbmV0Y19zdHJl
YW1maWx0ZXJfaHdfc2V0KHByaXYsIHNmaSwgZmFsc2UpOw0KPiAgICAgICAgICAgICAgICAgaGxp
c3RfZGVsKCZzZmktPm5vZGUpOw0KPiAtICAgICAgICAgICAgICAga2ZyZWUoc2ZpKTsNCj4gICAg
ICAgICAgICAgICAgIGNsZWFyX2JpdChzZmktPmluZGV4LCBlcHNmcC5wc2ZwX3NmaV9iaXRtYXAp
Ow0KDQpUaGlzICJzZmktPmluZGV4IiBzaG91bGQgYmUgImluZGV4IiwgYnV0IHRoZSBwYXRjaCBp
cyBhbHNvIGZpeCBpdC4NCg0KPiArICAgICAgICAgICAgICAga2ZyZWUoc2ZpKTsNCj4gICAgICAg
ICB9DQo+ICB9DQo+IA0KPiAtLQ0KPiAyLjI2LjINCg0KVGhhbmtzIGEgbG90Lg0KDQpCciwNClBv
IExpdQ0KDQo=
