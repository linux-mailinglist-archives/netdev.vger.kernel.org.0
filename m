Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E301A14464F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAUVS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:18:27 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:13101
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728741AbgAUVS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 16:18:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVNQr7C7Nu8zuFy2+H67MvmMXU3nuEfymIMktkHePtuT0H2pl5tOyCxjqhSGCduQLVnefn7UQkOAK7pxAO80mWpRkmr2nznSae40gmknEhbnbZtl3SmWcYOOpkGHXB0EJCeDI+foIEn1aIAxPwxoP1idjgyl4i6NNyX6NiD+W0CcFNSZ0dkGfrtp6AqqrvfsT74IyGrQk0HplEfWtjXgpQjNImfLgAc7+gPlgvQFsQ2PjCpEhO1ggi/m3I2EHWwI+Mig8NZt/YN+znpf20rKnpgKP42gzsrM9mHY5qPDWpd+VQu60yc0Xd6gQyhwtPlHIRN9xGZ36HgydqDs+sfE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg7pyNmO3XTmQ6+wvB3E6/13/Fnp5/8MPFU6rJWtQjc=;
 b=jN3o83DtfxEhD1/0dhCQWyXN+Ps1ltMUuRZVTzjvmPpz8CpEoUOwDjyh9mvEO7Wg9DppY7y0KxdzWykiJPczzcNoe57kc4FWYZnKQsNmku2G43/yHSlBqsrcInFWFRM2iqMDHAcHj+QIIIEFLN42sctVPhjGKglhapDELT9fOqSTdUnVsOCuMCC7Sxymkm/GNHhFzPkU8w8NeJe6zs9Hn19MxmaL1dapOr5cumIw7wQOnjT3XPa2aXXRlJgtpoqW9FDp9lvtSv9M6sj81R4NL+gWYNVbxO7Gg37IcguRATPz0zanFQEE1aYHA8yPyYsopRtySasNtHsUI3Te0i3/6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg7pyNmO3XTmQ6+wvB3E6/13/Fnp5/8MPFU6rJWtQjc=;
 b=R8CMjAUyjjovBcUjq84L7wHc9RuFftEZVFsOmh6J1+9UsQ23rK3VVesYFs8PI+L5Wi+m2KSF6txKXhT2S0Ebtn6N1YCZggYSTamxwX/+Y1zC3hZqUyuzFJ4P+AGA/saqUakYdNZu/V4aoBHRolXeeaAbfA2ZsfF+EFFrN2qE5VU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4415.eurprd05.prod.outlook.com (52.133.15.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 21:18:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 21:18:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Handle multi chain hardware misses
Thread-Topic: [PATCH net-next 00/13] Handle multi chain hardware misses
Thread-Index: AQHV0HY4DifryuDZx0aVaDBxGBwzoqf1n68A
Date:   Tue, 21 Jan 2020 21:18:21 +0000
Message-ID: <4b0bcbf60537bcdfe8d184531788a9b6084be8f6.camel@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb4984f2-b99d-4c7b-6ea5-08d79eb771c2
x-ms-traffictypediagnostic: VI1PR05MB4415:|VI1PR05MB4415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB441535AAB9D92B44FF226A9BBE0D0@VI1PR05MB4415.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(189003)(86362001)(2616005)(5660300002)(36756003)(66556008)(66446008)(6506007)(478600001)(64756008)(71200400001)(6486002)(26005)(81166006)(8676002)(6512007)(8936002)(81156014)(76116006)(2906002)(316002)(110136005)(4744005)(186003)(66946007)(91956017)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4415;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3WcY2ZIpyoNSGw5z4XBgi3S58L/R1TSa72myYRyt/mUNNvr25E+yfdlM0OPTziVIiVB9INGBSyRY/aYiVC0RvyBSCReLkmRCU2EQoSiK4c3nwzJF/27+NdhNO0WxpgDd3/Gqat8iHWLw/r4f1FN3U5bGw/ZB5BqGkFQjUVpWs0wDkN4nT+DA4dwjrrEQ+Jd9+/oAnYKPCOR+VwWBQknj271YDplEJ1HwTkXApzTVOz2GyN/Gv5ou/oqD0LF6HGFZGkOSvdvkQka1CUJXECQYMA5MNGLT3nnaVksyvPtzh1WGs9OkCPBISkiASgwvDicOcguCiw7n88+LtAAx0eU71ieUMRbXhLZPOdpNXj/SAN/wXs/jhIST41kfupaDhdeAWCJFPI2KZVN92LcyIo4vC5ItwrFD40pf0hFNuka8j7EbgNbv2DGSx6B0ZDlr+XYb
Content-Type: text/plain; charset="utf-8"
Content-ID: <D838AEDD156B3640A5383E3B518AE9FE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4984f2-b99d-4c7b-6ea5-08d79eb771c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 21:18:21.9706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7eEeV5gT5f90B8OxE20FeacaSYKu18jQwY033yRZ+Dp7EA1bbE665EnY+cov16tBRpkXYL4MynO+1UIgdiDDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4415
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAxLTIxIGF0IDE4OjE2ICswMjAwLCBQYXVsIEJsYWtleSB3cm90ZToNCj4g
Tm90ZSB0aGF0IG1pc3MgcGF0aCBoYW5kbGluZyBvZiBtdWx0aS1jaGFpbiBydWxlcyBpcyBhIHJl
cXVpcmVkDQo+IGluZnJhc3RydWN0dXJlDQo+IGZvciBjb25uZWN0aW9uIHRyYWNraW5nIGhhcmR3
YXJlIG9mZmxvYWQuIFRoZSBjb25uZWN0aW9uIHRyYWNraW5nDQo+IG9mZmxvYWQNCj4gc2VyaWVz
IHdpbGwgZm9sbG93IHRoaXMgb25lLg0KDQpIaSBEYXZlIGFuZCBKYWt1YiwNCg0KQXMgUGF1bCBl
eHBsYWluZWQgdGhpcyBpcyBwYXJ0IG9uZSBvZiB0d28gcGFydHMgc2VyaWVzLA0KDQpBc3N1bWlu
ZyB0aGUgcmV2aWV3IHdpbGwgZ28gd2l0aCBubyBpc3N1ZXMgaSB3b3VsZCBsaWtlIHRvIHN1Z2dl
c3QgdGhlDQpmb2xsb3dpbmcgYWNjZXB0YW5jZSBvcHRpb25zOg0KDQpvcHRpb24gMSkgSSBjYW4g
Y3JlYXRlIGEgc2VwYXJhdGUgc2lkZSBicmFuY2ggZm9yIGNvbm5lY3Rpb24gdHJhY2tpbmcNCm9m
ZmxvYWQgYW5kIG9uY2UgUGF1bCBzdWJtaXRzIHRoZSBmaW5hbCBwYXRjaCBvZiB0aGlzIGZlYXR1
cmUgYW5kIHRoZQ0KbWFpbGluZyBsaXN0IHJldmlldyBpcyBjb21wbGV0ZSwgaSBjYW4gc2VuZCB0
byB5b3UgZnVsbCBwdWxsIHJlcXVlc3QNCndpdGggZXZlcnl0aGluZyBpbmNsdWRlZCAuLiANCg0K
b3B0aW9uIDIpIHlvdSB0byBhcHBseSBkaXJlY3RseSB0byBuZXQtbmV4dCBib3RoIHBhdGNoc2V0
cw0KaW5kaXZpZHVhbGx5LiAodGhlIG5vcm1hbCBwcm9jZXNzKQ0KDQpQbGVhc2UgbGV0IG1lIGtu
b3cgd2hhdCB3b3JrcyBiZXR0ZXIgZm9yIHlvdS4NCg0KUGVyc29uYWxseSBJIHByZWZlciBvcHRp
b24gMSkgc28gd2Ugd29uJ3QgZW5kdXAgc3R1Y2sgd2l0aCBvbmx5IG9uZQ0KaGFsZiBvZiB0aGUg
Y29ubmVjdGlvbiB0cmFja2luZyBzZXJpZXMgaWYgdGhlIHJldmlldyBvZiB0aGUgMm5kIHBhcnQN
CmRvZXNuJ3QgZ28gYXMgcGxhbm5lZC4NCg0KVGhhbmtzLA0KU2FlZWQNCg==
