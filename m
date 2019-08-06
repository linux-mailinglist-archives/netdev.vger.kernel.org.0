Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1F83ABE
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfHFVBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:01:53 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:12163
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfHFVBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 17:01:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNl2YVgRNxkAkoQWlnfEwYC1gi5f8Gji2p9HI2lgKQUopwTQ4d+GX7X9pAbtwHotjemZSzIgsQzPkaTQqStB4STdK6vwuv6NUBqf0WwJxJxbUbieLwv3EaFI5748EuIDgJB7Lp6wQ4FKF0L7g157PEyivdyzQ6+gWmosGdvlh9BeeIeU4/xGBXHYsg6fwLE5h0gyQNlYli1w/9jDvnRQjTeR7YBDYfWpCCjyws6f//CjYQqg7hor+ARI4NOVHsVLBgwMYtX1W690+UgvnQ7+BaBUJs5NH+/1OHMcUHxpfwB7FqVyz2oSw5804on1wFDDxaN+C18y9U3AG2HkuLtmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEUrpJcCapRBg1PsKhdP/7TPvtf8OpDkqL50o6lBK7Q=;
 b=eSm1bRwfC6pLoK9tvbZS67eIc5ciDDJqr+B6Eu1QzbR7amJMqMxwm1zU9xNazeoJ+/krAlo3cKWk767P66RH+Kb2lnFxKb4000v3eytl+7eWORycL5AtiOeMKqiNEcKtXO0sm9mHuZ9gulwQtff/aAZtrE9m2y5SZcG/xqQEyrdwtW3peMZRZZ+rLibbZhpUziPVIRjiHOay3ltQty0gHmoI5gdRRDW2wlM5kEsqRedz1sal0Hmc+uxGy4JV+ed+r6l1o1fN0O5U6sTLoo//nwV0T3PhiJCMxIV22q8rNeJiSx/AHssmuNf24t6Sb/RLkIg/s9YcUdl6Ml7xm2AR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEUrpJcCapRBg1PsKhdP/7TPvtf8OpDkqL50o6lBK7Q=;
 b=sRCI9qcoARlVfLkLk8GzpDw5vTsiiC7WhYgMVLH2/xl9dYaP8eTT1c9GHjTi6ujNr9belIMY9vyz8gT5x2tbNIcfG6u1M2d7uoqym2qMryJdoewa0p8Tdpc7BJCpjyBjdAy0F3/S28k0yS1lPhOQpy/fI3ViDAW4aHi4AkPd8A8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2279.eurprd05.prod.outlook.com (10.168.56.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Tue, 6 Aug 2019 21:01:49 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 21:01:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][net-next][V2] net/mlx5: remove self-assignment on
 esw->dev
Thread-Topic: [PATCH][net-next][V2] net/mlx5: remove self-assignment on
 esw->dev
Thread-Index: AQHVSUTRDpTLHfU6A0aKQ9PCBRoqCqbuocYA
Date:   Tue, 6 Aug 2019 21:01:48 +0000
Message-ID: <c6ae2c6a0d0b15e49737169db50a0a78f2e37caf.camel@mellanox.com>
References: <20190802151316.16011-1-colin.king@canonical.com>
In-Reply-To: <20190802151316.16011-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae59aabc-067b-4cd8-90c7-08d71ab14c73
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2279;
x-ms-traffictypediagnostic: DB6PR0501MB2279:
x-microsoft-antispam-prvs: <DB6PR0501MB22799683AFC66A3B32B385CABED50@DB6PR0501MB2279.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(199004)(189003)(6506007)(102836004)(66946007)(6436002)(5660300002)(86362001)(2616005)(81156014)(110136005)(58126008)(54906003)(2201001)(8676002)(76176011)(26005)(186003)(4744005)(99286004)(81166006)(316002)(6512007)(229853002)(118296001)(6486002)(53936002)(76116006)(4326008)(2501003)(36756003)(66066001)(25786009)(6116002)(3846002)(8936002)(14444005)(7736002)(446003)(14454004)(68736007)(71200400001)(91956017)(66556008)(66476007)(305945005)(66446008)(6246003)(2906002)(256004)(476003)(478600001)(486006)(11346002)(64756008)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2279;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8kSMwRKLQTKaf3YJfbPmlilwVQHtcwqPS0Fho+htc79SbBjJ8y/O+fb3sokOpPwVYVYFfsOnX7Tx6NVg+o3kUHCZ9pNbizJEKYTl5y2fNuS1vdoEQZqeUVlOSLpvd1yb+Wzu25Vo4jPAok8ECldq8Sq5pn+nCfFS6rYWgAigcX6zmJvBVfv1z/DhUM+Mh6pnYUQj9N4hN7e2Re48I0N5KsCq7IIUQTHZ4nJ/o0Ac4IvhtuftIjLVdnYG7z2LRfG7CtOJ9d0S0e7EajFjXr86fWLUzUYrQDpebmV1bxP4Ebd2yDOnUDzAu9MhxlAHQKuAqsbZoZbzk+6DER0JH9n13YWIeCFkEFM9sGRqy3Kgcjqo5F7JO+E+VZSMNM1/VTLm65NSyxcwuVl2vRBBcOgSi2muNcIZnINJXvSEPUgiK2U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <794A4F31C86EA642807B59BB314CD7F8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae59aabc-067b-4cd8-90c7-08d71ab14c73
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 21:01:48.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2279
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTAyIGF0IDE2OjEzICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhl
cmUgaXMgYSBzZWxmIGFzc2lnbm1lbnQgb2YgZXN3LT5kZXYgdG8gaXRzZWxmLCBjbGVhbiB0aGlz
IHVwIGJ5DQo+IHJlbW92aW5nIGl0LiBBbHNvIG1ha2UgZGV2IGEgY29uc3QgcG9pbnRlci4NCj4g
DQo+IEFkZHJlc3Nlcy1Db3Zlcml0eTogKCJTZWxmIGFzc2lnbm1lbnQiKQ0KPiBGaXhlczogNmNl
ZGRlNDUxMzk5ICgibmV0L21seDU6IEUtU3dpdGNoLCBWZXJpZnkgc3VwcG9ydCBRb1MgZWxlbWVu
dA0KPiB0eXBlIikNCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdA
Y2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+IA0KPiBWMjogbWFrZSBkZXYgY29uc3QNCj4gDQoNCkFw
cGxpZWQgdG8gbWx4NS1uZXh0Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
