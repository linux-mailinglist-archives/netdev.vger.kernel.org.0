Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808E91A2464
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 16:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgDHO4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 10:56:18 -0400
Received: from mail-bn8nam11on2091.outbound.protection.outlook.com ([40.107.236.91]:60320
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727612AbgDHO4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 10:56:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlJUPa3lqf0EhOzYuTDbqUn3Yfus7gi/EEAWTCYl5lzKO+O5WHU8V45EHRhS9LySKN8/UHF1mXRcoMxRyMLQbRTHEgli/HoOl3hIJ3r1nkjIOybyz8K1GXJ5Keh54tH0NNfJacbJ7MsJw93QdHdNMAsTOBxr2HWhArBn0s476h0x4cprkkbOEbfcr2oq3PBKUdv9p7CP5noJF9IM/UEGZXza6uVSCGNBCXPYeycgwfaqsv1MmiyWbWlGvfbBZLdrDD23x0aSDLFKlZhgxfo2sQdW6dPelwT+Ux5OuRoPYP8FXPSIy/64NpzVeZPmLt1xBZSG6FlE9oJP7IDcML91fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHKjxxGW/r5bv5XHHhK1BcFGVReuVvUgZsexBpV9Dk4=;
 b=e8VcEwJ84ixL8ae271jTzHy78a2HSrcLNi//YTZ8txzneQ6K2Y1/5nD1eQFghcYfDueLpueyMyFL8MXDMhh6VwCb+1XebOaNzg0GZKFpIKDAWs6RzpcQsD5MtPSLhQWDb1YB23ulDgfrrpHftE4pACvzaekZDOQjz0s8HE93Fg7XheTJhDRwnDoIGQ5Y8XMSmRlk57LP8T8OW4T2qXbREFWX92MYAmtGKpY0MBw89IOc6Io6WsZK8U9lv8cWoawHAxWXcf5oWhRQrescoWCdqopbma7sBqTZV6BY8ZP+di5jQyzbNRdeQg4EBF5e8tzBKTBZOjnCYc6DGyDCQBuSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHKjxxGW/r5bv5XHHhK1BcFGVReuVvUgZsexBpV9Dk4=;
 b=AEeFwVdZx/qxS2THYUz5Hp4S+mCrZjoWl5e+XgC4E71ZVrxA8ZjSxSCKZd+7th88NmZyN3Barm0Y5PYxntpIEdph7+ngPecoILPdc0VHz0zJOtmFH1rEjE+d/wnancnMLB1C9FK0f00OdtIYckqqyZmqKaZoZ0Qzzzbp1qvzXQI=
Received: from MN2PR21MB1437.namprd21.prod.outlook.com (2603:10b6:208:208::10)
 by MN2PR21MB1197.namprd21.prod.outlook.com (2603:10b6:208:39::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.5; Wed, 8 Apr
 2020 14:56:15 +0000
Received: from MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa]) by MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa%6]) with mapi id 15.20.2900.002; Wed, 8 Apr 2020
 14:56:15 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>
CC:     Wei Liu <wei.liu@kernel.org>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH RFC v2 12/33] hv_netvsc: add XDP frame size to driver
Thread-Topic: [PATCH RFC v2 12/33] hv_netvsc: add XDP frame size to driver
Thread-Index: AQHWDZwWYtPz3NShLUejuRSAK49QAqhvS9mg
Date:   Wed, 8 Apr 2020 14:56:14 +0000
Message-ID: <MN2PR21MB143703CC4F63B5EB20CA217CCAC00@MN2PR21MB1437.namprd21.prod.outlook.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634669527.707275.1340397871511076658.stgit@firesoul>
In-Reply-To: <158634669527.707275.1340397871511076658.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-08T14:56:13.3658040Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9bf9c14c-b0db-42ea-87d7-feca533218c8;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.83.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a9d51dab-0cf2-4214-4af4-08d7dbccfc6c
x-ms-traffictypediagnostic: MN2PR21MB1197:|MN2PR21MB1197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB119736BE40467F8F1092BB31CAC00@MN2PR21MB1197.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1437.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(6506007)(478600001)(186003)(26005)(9686003)(71200400001)(55016002)(82960400001)(86362001)(82950400001)(7696005)(10290500003)(4326008)(316002)(2906002)(54906003)(66556008)(66446008)(81156014)(53546011)(64756008)(76116006)(66946007)(110136005)(81166007)(8676002)(52536014)(7416002)(33656002)(5660300002)(8990500004)(8936002)(66476007);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yAS6FmSKm4TFm9qK732O/VU95LqK88/JOHbQaPyXpwFWIW/nhAJujg7qJpq5u4VbsDzGflGochMB/Zldy1M62p7Hf7d3gr2kshl3lptWTDWRl6JBGs2n+w8e4LxxhF8x+O6jHusb+Al1v9XAA9iHCrCu4f6mLDpBccs6K32yYlfoGZmaaFrEXy7DbpckTMu43io74LN6h6DJr4dDETXnTELLPNhLi8gRwsVa0ylyrYLAZ7zaXS9Aaa59DWbStbTP6o15pElnS8zI4wxC/+doMVkRtUqPJQNbNA4dvyD1iE/+kGLF7FIPN1skUiog7JnF0Kz1kb4q/iLO+KMCusJRxYPlxa41HaspTUaT9VhP8XhExSpd1efsyotuYlYniWEVpyfHY+h7DyZaPUT6mkC05JcPoqIeAIOuMW9zYwlAREi+qRDvKcl/svwIm1I6M3Zg
x-ms-exchange-antispam-messagedata: v6wPmm5ssgs9cwUBMAkeQs5othqhtY07LSSQBD7LeJ80Oqi+q0IMb0nDNGeRxBD6UtS2e0wC87IFeut55sjexIn0K94aV2vtUVrWzpeOi67UJliWmwdOCG1cPz/iW9Gx+Z/fU9heIcepORn0e3vuTg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d51dab-0cf2-4214-4af4-08d7dbccfc6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 14:56:14.9458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jEtT7EwtJt5aHdqCaCTQontIynENKVmSe9vQo1Tmiueoq4w7tz5u6XX3M+vGbaMREoz+JPu1PYD1XsxpBy7nSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmVzcGVyIERhbmdhYXJk
IEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgOCwg
MjAyMCA3OjUyIEFNDQo+IFRvOiBzYW1lZWhqQGFtYXpvbi5jb20NCj4gQ2M6IFdlaSBMaXUgPHdl
aS5saXVAa2VybmVsLm9yZz47IEtZIFNyaW5pdmFzYW4gPGt5c0BtaWNyb3NvZnQuY29tPjsNCj4g
SGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT47IFN0ZXBoZW4gSGVtbWluZ2Vy
DQo+IDxzdGhlbW1pbkBtaWNyb3NvZnQuY29tPjsgSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0KPiA8
YnJvdWVyQHJlZGhhdC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5rZXJu
ZWwub3JnOw0KPiB6b3Jpa0BhbWF6b24uY29tOyBha2l5YW5vQGFtYXpvbi5jb207IGd0emFsaWtA
YW1hem9uLmNvbTsgVG9rZQ0KPiBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+
OyBEYW5pZWwgQm9ya21hbm4NCj4gPGJvcmttYW5uQGlvZ2VhcmJveC5uZXQ+OyBBbGV4ZWkgU3Rh
cm92b2l0b3YNCj4gPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+OyBKb2huIEZhc3RhYmVu
ZA0KPiA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPjsgQWxleGFuZGVyIER1eWNrDQo+IDxhbGV4
YW5kZXIuZHV5Y2tAZ21haWwuY29tPjsgSmVmZiBLaXJzaGVyIDxqZWZmcmV5LnQua2lyc2hlckBp
bnRlbC5jb20+Ow0KPiBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5jb20+OyBXaWxsZW0gZGUg
QnJ1aWpuDQo+IDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPjsgSWxpYXMgQXBhbG9k
aW1hcw0KPiA8aWxpYXMuYXBhbG9kaW1hc0BsaW5hcm8ub3JnPjsgTG9yZW56byBCaWFuY29uaSA8
bG9yZW56b0BrZXJuZWwub3JnPjsNCj4gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5j
b20+DQo+IFN1YmplY3Q6IFtQQVRDSCBSRkMgdjIgMTIvMzNdIGh2X25ldHZzYzogYWRkIFhEUCBm
cmFtZSBzaXplIHRvIGRyaXZlcg0KPiANCj4gVGhlIGh5cGVydiBOSUMgZHJpdmVycyBYRFAgaW1w
bGVtZW50YXRpb24gaXMgcmF0aGVyIGRpc2FwcG9pbnRpbmcgYXMgaXQNCj4gd2lsbCBiZSBhIHNs
b3dkb3duIHRvIGVuYWJsZSBYRFAgb24gdGhpcyBkcml2ZXIsIGdpdmVuIGl0IHdpbGwgYWxsb2Nh
dGUgYQ0KPiBuZXcgcGFnZSBmb3IgZWFjaCBwYWNrZXQgYW5kIGNvcHkgb3ZlciB0aGUgcGF5bG9h
ZCwgYmVmb3JlIGludm9raW5nIHRoZQ0KPiBYRFAgQlBGLXByb2cuDQoNCkFzIGV4cGxhaW5lZCB3
aGVuIEkgc3VibWl0IHRoZSBYRFAgc3VwcG9ydCBmb3IgaHZfbmV0dnNjIC0tIHdpdGhvdXQgWERQ
LCANCnRoaXMgZHJpdmVyIGFscmVhZHkgYWxsb2NhdGVzIG1lbW9yeSBhbmQgZG9lcyBhIGNvcHkg
Zm9yIGV2ZXJ5IHBhY2tldC4gU28gDQp0aGUgcGFnZSBhbGxvY2F0aW9uIGZvciBYRFAgZGF0YSBi
dWYgaXMgbm90IHNsb3dlciB0aGFuIHRoZSBleGlzdGluZyBjb2RlIA0KcGF0aC4gQWxzbywgYW4g
b3B0aW1pemF0aW9uIHRoYXQgb25seSBhbGxvY2F0ZXMgYSBQQUdFIG9uY2UsIGFuZCByZS11c2Vz
IGl0IA0KaW4gYSBOQVBJIGN5Y2xlIHdpbGwgYmUgZG9uZS4NCg0KQW5kLCBteSBYRFAgaW1wbGVt
ZW50YXRpb24gZm9yIGh2X25ldHZzYyB0cmFuc3BhcmVudGx5IHBhc3NlcyB4ZHBfcHJvZyANCnRv
IHRoZSBhc3NvY2lhdGVkIFZGIE5JQy4gTWFueSBvZiB0aGUgQXp1cmUgVk1zIGFyZSB1c2luZyBT
UklPViwgc28gDQptYWpvcml0eSBvZiB0aGUgZGF0YSBhcmUgYWN0dWFsbHkgcHJvY2Vzc2VkIGRp
cmVjdGx5IG9uIHRoZSBWRiBkcml2ZXIncyBYRFAgDQpwYXRoLiBTbyB0aGUgb3ZlcmhlYWQgb2Yg
dGhlIHN5bnRoZXRpYyBkYXRhIHBhdGggKGh2X25ldHZzYykgaXMgbWluaW1hbC4NCg0KVGhhbmtz
LA0KLSBIYWl5YW5nDQoNCg==
