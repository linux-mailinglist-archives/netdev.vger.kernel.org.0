Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4EF140C22
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 15:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgAQOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 09:10:29 -0500
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:9494
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726885AbgAQOK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 09:10:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfHoO2ZrP1KwaN2iy1wzkBk8fngoYyW9XoJfDCzw+8FQcErGVbw7L0F6GepuDrJVtFY8YOv/R2BxvS6WRFT0TMCFLhclNFGNzk9NwhNZ0XQDnlTnM5aa1Pw1O3c7QehyQepEnfQ6dp6//B2XbrHwnUbCqiWb8uio9VOPZ3RDLSmUKuYRsihsNrJrZsT7Jzv/ll54C8MzqRwRUHApxIyC/KKtcoqaxq7qYsxLPJh/uJkpDXcfrSdH97ldGS7UQthSrIb30d0mCMiYAHDRmyr0mPIJrltBaqD3B1qNsicnFsEf0qmqAdJIl2da0f4VO/nLNReyuM1k9TcXtdQrl/CGfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUGwp82irPj+LO9u2HeDlIDJDBN0rylxPR3eJwb+b/I=;
 b=jl5a5ffTSLtvkU23z5sAoE54LEqp4BLGNW4kxLWIlkCVCfrPwWXzfI8dJaci0LIIzBQvFOlitaycV7w3OSezvmudaYo9tZBE6Oo1V0JXZ/aB1KTgve3IxYWrrismzKcS4g0Q1QAriX5+aZCDmXOU+EbzkSqMMUxqrJ1xBL/tn1hbQ36CtaJKsa79WE6kUAs+0i52MotDt/uNjHVCGLHbCWRFel7A5xj9O3M/Z+wA2X0HKMd7D8gUVKjxzr6dcil04Dv4hCaAv2GkLYkjqb+LJst4JTixiMSxIgtn6llk/GvkV5s4ryXiV/frSpTmEFMq0mIFqQ8vK0WAnt4OdAieHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUGwp82irPj+LO9u2HeDlIDJDBN0rylxPR3eJwb+b/I=;
 b=obzk/hH4ITcYTk50VILto6P7LBhPrLUciiPatLlhQWYp7km2KMPjGem1bP6eDG8pzGp3osCNZfusWghZ3VyUE87YxTMoaY7EMLuHqITaFgY4XUnXHboirQVQbtbJdwizL5OgIN7M9JW5mSAIYGMygwEiyJ9AhhpgGKv4rIc0wlQ=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1SPR01MB022.eurprd05.prod.outlook.com (52.134.19.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Fri, 17 Jan 2020 14:10:25 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 14:10:25 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR14CA0004.namprd14.prod.outlook.com (2603:10b6:208:23e::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Fri, 17 Jan 2020 14:10:24 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1isSKL-0008Kk-1B; Fri, 17 Jan 2020 10:10:21 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
Thread-Topic: [PATCH 5/5] vdpasim: vDPA device simulator
Thread-Index: AQHVzGqlRPHVvNcseEuo1k66+tVAdqftb4kAgAEpwICAAE2WgA==
Date:   Fri, 17 Jan 2020 14:10:24 +0000
Message-ID: <20200117141021.GW20978@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-6-jasowang@redhat.com>
 <20200116154658.GJ20978@mellanox.com>
 <aea2bff8-82c8-2c0f-19ee-e86db73e199f@redhat.com>
In-Reply-To: <aea2bff8-82c8-2c0f-19ee-e86db73e199f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR14CA0004.namprd14.prod.outlook.com
 (2603:10b6:208:23e::9) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94de57c2-1d6a-481b-2d66-08d79b56ff19
x-ms-traffictypediagnostic: VI1SPR01MB022:|VI1SPR01MB022:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0229D7CDA01B08805F1ED10CF310@VI1SPR01MB022.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(86362001)(4326008)(33656002)(7416002)(36756003)(478600001)(9786002)(6916009)(9746002)(81156014)(81166006)(1076003)(8936002)(2616005)(316002)(5660300002)(54906003)(2906002)(66946007)(52116002)(66476007)(186003)(66556008)(71200400001)(26005)(8676002)(66446008)(64756008)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB022;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jtiko7mQ9BGHQNlTI7J5z+Xa55QKeK+p5Dn8Jb4CQ/+s2kpAX45onHrbd0ZT4kz6Mzq4UlBwLd+W0FOie6sr2xqFAXPR3lbUQWjykXUBfhjbBycpYudLdJrIpy8Qpc8c+4ywV1bH0nQCwWgG12/GUe/sr441KTYEFG5N5KeSG0dEsZnzQh7hGNYRIaTgvLS9lHOGYZusMFheBxu4PBwVaqLLRaKVjB4iPRykT+qf7N+i+B0aL0GV/qKSc9dzyg/YezlOKtI89XIejMeLoaCVAmRwGnqoqlR74lOBA3EgOLuStolPVz0TZZDuW32nnyfsDRa+JRoLEYHfSJ3kF84znsQLwOJJ0igsb+lbmVnPooYLlVcEqB368zwaPNUn73Zm8lWedCystdpE9E8d7x8fmk0ts8A9yDH81Et3kBO6V7lMJCYEs92byn2dSbn/LJ2kWq0/W6wthpUkt0JjerDlL/e5xCc+sW2eDynurazSDU5j3CznfRfkJSV5ylCiVyqc
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7E8AD5E3071474B8AAD18D37DC908BD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94de57c2-1d6a-481b-2d66-08d79b56ff19
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 14:10:24.8465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wF/Vgr35Ko7qrprCAO3MWvx6JZmxoOf+9zJNUzAefC4BkUhaY9557vDIirV1JXkRDuhQVgZH5L+BPRV84UQBBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBKYW4gMTcsIDIwMjAgYXQgMDU6MzI6MzlQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90
ZToNCj4gDQo+IE9uIDIwMjAvMS8xNiDkuIvljYgxMTo0NywgSmFzb24gR3VudGhvcnBlIHdyb3Rl
Og0KPiA+IE9uIFRodSwgSmFuIDE2LCAyMDIwIGF0IDA4OjQyOjMxUE0gKzA4MDAsIEphc29uIFdh
bmcgd3JvdGU6DQo+ID4gPiBUaGlzIHBhdGNoIGltcGxlbWVudHMgYSBzb2Z0d2FyZSB2RFBBIG5l
dHdvcmtpbmcgZGV2aWNlLiBUaGUgZGF0YXBhdGgNCj4gPiA+IGlzIGltcGxlbWVudGVkIHRocm91
Z2ggdnJpbmdoIGFuZCB3b3JrcXVldWUuIFRoZSBkZXZpY2UgaGFzIGFuIG9uLWNoaXANCj4gPiA+
IElPTU1VIHdoaWNoIHRyYW5zbGF0ZXMgSU9WQSB0byBQQS4gRm9yIGtlcm5lbCB2aXJ0aW8gZHJp
dmVycywgdkRQQQ0KPiA+ID4gc2ltdWxhdG9yIGRyaXZlciBwcm92aWRlcyBkbWFfb3BzLiBGb3Ig
dmhvc3QgZHJpZXJzLCBzZXRfbWFwKCkgbWV0aG9kcw0KPiA+ID4gb2YgdmRwYV9jb25maWdfb3Bz
IGlzIGltcGxlbWVudGVkIHRvIGFjY2VwdCBtYXBwaW5ncyBmcm9tIHZob3N0Lg0KPiA+ID4gDQo+
ID4gPiBBIHN5c2ZzIGJhc2VkIG1hbmFnZW1lbnQgaW50ZXJmYWNlIGlzIGltcGxlbWVudGVkLCBk
ZXZpY2VzIGFyZQ0KPiA+ID4gY3JlYXRlZCBhbmQgcmVtb3ZlZCB0aHJvdWdoOg0KPiA+ID4gDQo+
ID4gPiAvc3lzL2RldmljZXMvdmlydHVhbC92ZHBhX3NpbXVsYXRvci9uZXRkZXYve2NyZWF0ZXxy
ZW1vdmV9DQo+ID4gVGhpcyBpcyB2ZXJ5IGdyb3NzLCBjcmVhdGluZyBhIGNsYXNzIGp1c3QgdG8g
Z2V0IGEgY3JlYXRlL3JlbW92ZSBhbmQNCj4gPiB0aGVuIG5vdCB1c2luZyB0aGUgY2xhc3MgZm9y
IGFueXRoaW5nIGVsc2U/IFl1ay4NCj4gDQo+IA0KPiBJdCBpbmNsdWRlcyBtb3JlIGluZm9ybWF0
aW9uLCBlLmcgdGhlIGRldmljZXMgYW5kIHRoZSBsaW5rIGZyb20gdmRwYV9zaW0NCj4gZGV2aWNl
IGFuZCB2ZHBhIGRldmljZS4NCg0KSSBmZWVsIGxpa2UgcmVnYXJkbGVzcyBvZiBob3cgdGhlIGRl
dmljZSBpcyBjcmVhdGVkIHRoZXJlIHNob3VsZCBiZSBhDQpjb25zaXN0ZW50IHZpcnRpbyBjZW50
cmljIG1hbmFnZW1lbnQgZm9yIHBvc3QtY3JlYXRpb24gdGFza3MsIHN1Y2ggYXMNCmludHJvc3Bl
Y3Rpb24gYW5kIGRlc3RydWN0aW9uDQoNCkEgdmlydG8gc3RydWN0IGRldmljZSBzaG91bGQgYWxy
ZWFkeSBoYXZlIGJhY2sgcG9pbnRlcnMgdG8gaXQncyBwYXJlbnQNCmRldmljZSwgd2hpY2ggc2hv
dWxkIGJlIGVub3VnaCB0byBkaXNjb3ZlciB0aGUgdmRwYV9zaW0sIG5vbmUgb2YgdGhlDQpleHRy
YSBzeXNmcyBtdW5naW5nIHNob3VsZCBiZSBuZWVkZWQuDQoNCj4gPiA+IE5ldGxpbmsgYmFzZWQg
bGlmZWN5Y2xlIG1hbmFnZW1lbnQgY291bGQgYmUgaW1wbGVtZW50ZWQgZm9yIHZEUEENCj4gPiA+
IHNpbXVsYXRvciBhcyB3ZWxsLg0KPiA+IFRoaXMgaXMganVzdCBiZWdnaW5nIGZvciBhIG5ldGxp
bmsgYmFzZWQgYXBwcm9hY2guDQo+ID4gDQo+ID4gQ2VydGFpbmx5IG5ldGxpbmsgZHJpdmVuIHJl
bW92YWwgc2hvdWxkIGJlIGFuIGFncmVlYWJsZSBzdGFuZGFyZCBmb3INCj4gPiBhbGwgZGV2aWNl
cywgSSB0aGluay4NCj4gDQo+IA0KPiBXZWxsLCBJIHRoaW5rIFBhcmF2IGhhZCBzb21lIHByb3Bv
c2FscyBkdXJpbmcgdGhlIGRpc2N1c3Npb24gb2YgbWRldg0KPiBhcHByb2FjaC4gQnV0IEknbSBu
b3Qgc3VyZSBpZiBoZSBoYWQgYW55IFJGQyBjb2RlcyBmb3IgbWUgdG8gaW50ZWdyYXRlIGl0DQo+
IGludG8gdmRwYXNpbS4NCj4NCj4gT3IgZG8geW91IHdhbnQgbWUgdG8gcHJvcG9zZSB0aGUgbmV0
bGluayBBUEk/IElmIHllcywgd291bGQgeW91IHByZWZlciB0byBhDQo+IG5ldyB2aXJ0aW8gZGVk
aWNhdGVkIG9uZSBvciBiZSBhIHN1YnNldCBvZiBkZXZsaW5rPw0KDQpXZWxsLCBsZXRzIHNlZSB3
aGF0IGZlZWQgYmFjayBQYXJhdiBoYXMNCg0KSmFzb24NCg==
