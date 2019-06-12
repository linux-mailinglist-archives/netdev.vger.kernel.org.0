Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C028F425F1
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfFLMev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:34:51 -0400
Received: from mail-eopbgr10052.outbound.protection.outlook.com ([40.107.1.52]:53458
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405140AbfFLMev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tg90vM86CrUJSeuKUehf6n1egrf+vlj+H5iO5QAN2Yw=;
 b=rW9FXdm0aaKCDKWePm/HYCEoNj20Q6QhbxFMCeLGj5S4890c6uheClnjX77sZdT7nHMOIbkpuEvLX5OcOZNkXeqPldiG9HP2YWsuLQqUpYimlAw17PvyAUhvmThwdi/OM4igbwqpLy0vuUBHOHjhsGfHev7rXhf8RD5EuV0GDdM=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4605.eurprd05.prod.outlook.com (20.176.3.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Wed, 12 Jun 2019 12:34:02 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3021:5bae:ebbe:701f]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3021:5bae:ebbe:701f%6]) with mapi id 15.20.1965.017; Wed, 12 Jun 2019
 12:34:02 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>, mlxsw <mlxsw@mellanox.com>,
        Alex Kushnarov <alexanderk@mellanox.com>
Subject: Re: tc tp creation performance degratation since kernel 5.1
Thread-Topic: tc tp creation performance degratation since kernel 5.1
Thread-Index: AQHVIRbjnv8d5ZZGnkSVzGrTJvp9YqaX9AeA
Date:   Wed, 12 Jun 2019 12:34:02 +0000
Message-ID: <vbfy327yocq.fsf@mellanox.com>
References: <20190612120341.GA2207@nanopsycho>
In-Reply-To: <20190612120341.GA2207@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a33d33fa-a821-4993-65d2-08d6ef324043
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4605;
x-ms-traffictypediagnostic: VI1PR05MB4605:
x-microsoft-antispam-prvs: <VI1PR05MB4605D7D6D3DE2654AED765ADADEC0@VI1PR05MB4605.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(39860400002)(136003)(346002)(189003)(199004)(71190400001)(73956011)(81166006)(316002)(14454004)(99286004)(53936002)(107886003)(6486002)(478600001)(6246003)(2616005)(81156014)(86362001)(6512007)(8676002)(486006)(229853002)(2906002)(54906003)(6436002)(66476007)(71200400001)(7736002)(36756003)(64756008)(68736007)(5660300002)(305945005)(66066001)(66556008)(25786009)(26005)(66446008)(66946007)(4326008)(6506007)(386003)(6116002)(76176011)(14444005)(476003)(446003)(6916009)(3846002)(102836004)(186003)(256004)(52116002)(8936002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4605;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bYV6WdJ3rzLOsiYGTJQ++dWbZq2Xn1W+WSum2csEy3rchuJihbRYqrsvL0ftTLiot9rfcyxJ9Nm18QTqBD6Bibpj/XKTnuz/mFuFRyeTzD9CreGii0+72EDZs6OFvfQlSNQPvL+FJCi0lmhjTGj0xTRDsh4rLbcOUaq9RPCoQGRUzk4bJIwhZWWgmAY2EP7XPZ4YDkh6UYDJbq+Wx0v3iGs52I+S7vvotHuBLYnqkHyJ+oryRIwYOOwGQlHSbVKYYmIOG/iOqTMTe/cT/WPsSIHTPpYzpYoJFw+Q3AWiUlShTV5E19YMZOwPa3MFQk/0h5hWMG0JN37nSKm7bwv0G0elnLiQNeNZpz6hs6PSThKcHWrrFBwSy29K+YV6Nd6RrGTsoK2+LV1mGXgVnS21J2h99nkebCnvKol7JefUnG8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33d33fa-a821-4993-65d2-08d6ef324043
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 12:34:02.8094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vladbu@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQgMTIgSnVuIDIwMTkgYXQgMTU6MDMsIEppcmkgUGlya28gPGppcmlAcmVzbnVsbGku
dXM+IHdyb3RlOg0KPiBIaS4NCj4NCj4gSSBjYW1lIGFjcm9zcyBzZXJpb3VzIHBlcmZvcm1hbmNl
IGRlZ3JhZGF0aW9uIHdoZW4gYWRkaW5nIG1hbnkgdHBzLiBJJ20NCj4gdXNpbmcgZm9sbG93aW5n
IHNjcmlwdDoNCj4NCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICMhL2Jpbi9iYXNoDQo+DQo+IGRldj10
ZXN0ZHVtbXkNCj4gaXAgbGluayBhZGQgbmFtZSAkZGV2IHR5cGUgZHVtbXkNCj4gaXAgbGluayBz
ZXQgZGV2ICRkZXYgdXANCj4gdGMgcWRpc2MgYWRkIGRldiAkZGV2IGluZ3Jlc3MNCj4NCj4gdG1w
X2ZpbGVfbmFtZT0kKGRhdGUgKyIvdG1wL3RjX2JhdGNoLiVzLiVOLnRtcCIpDQo+IHByZWZfaWQ9
MQ0KPg0KPiB3aGlsZSBbICRwcmVmX2lkIC1sdCAyMDAwMCBdDQo+IGRvDQo+ICAgICAgICAgZWNo
byAiZmlsdGVyIGFkZCBkZXYgJGRldiBpbmdyZXNzIHByb3RvIGlwIHByZWYgJHByZWZfaWQgbWF0
Y2hhbGwgYWN0aW9uIGRyb3AiID4+ICR0bXBfZmlsZV9uYW1lDQo+ICAgICAgICAgKChwcmVmX2lk
KyspKQ0KPiBkb25lDQo+DQo+IHN0YXJ0PSQoZGF0ZSArIiVzIikNCj4gdGMgLWIgJHRtcF9maWxl
X25hbWUNCj4gc3RvcD0kKGRhdGUgKyIlcyIpDQo+IGVjaG8gIkluc2VydGlvbiBkdXJhdGlvbjog
JCgoJHN0b3AgLSAkc3RhcnQpKSBzZWMiDQo+IHJtIC1mICR0bXBfZmlsZV9uYW1lDQo+DQo+IGlw
IGxpbmsgZGVsIGRldiAkZGV2DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPg0KPiBPbiBteSB0ZXN0aW5n
IHZtLCByZXN1bHQgb24gNS4xIGtlcm5lbCBpczoNCj4gSW5zZXJ0aW9uIGR1cmF0aW9uOiAzIHNl
Yw0KPiBPbiBuZXQtbmV4dCB0aGlzIGlzOg0KPiBJbnNlcnRpb24gZHVyYXRpb246IDU0IHNlYw0K
Pg0KPiBJIGRpZCBzaW1wbGUgcHJpZmlsaW5nIHVzaW5nIHBlcmYuIE91dHB1dCBvbiA1LjEga2Vy
bmVsOg0KPiAgICAgNzcuODUlICB0YyAgICAgICAgICAgICAgIFtrZXJuZWwua2FsbHN5bXNdICBb
a10gdGNmX2NoYWluX3RwX2ZpbmQNCj4gICAgICAzLjMwJSAgdGMgICAgICAgICAgICAgICBba2Vy
bmVsLmthbGxzeW1zXSAgW2tdIF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZQ0KPiAgICAgIDEu
MzMlICB0Y19wcmVmX3NjYWxlLnMgIFtrZXJuZWwua2FsbHN5bXNdICBba10gZG9fc3lzY2FsbF82
NA0KPiAgICAgIDAuNjAlICB0Y19wcmVmX3NjYWxlLnMgIGxpYmMtMi4yOC5zbyAgICAgICBbLl0g
bWFsbG9jDQo+ICAgICAgMC41NSUgIHRjICAgICAgICAgICAgICAgW2tlcm5lbC5rYWxsc3ltc10g
IFtrXSBtdXRleF9zcGluX29uX293bmVyDQo+ICAgICAgMC41MSUgIHRjICAgICAgICAgICAgICAg
bGliYy0yLjI4LnNvICAgICAgIFsuXSBfX21lbXNldF9zc2UyX3VuYWxpZ25lZF9lcm1zDQo+ICAg
ICAgMC40MCUgIHRjX3ByZWZfc2NhbGUucyAgbGliYy0yLjI4LnNvICAgICAgIFsuXSBfX2djb252
X3RyYW5zZm9ybV91dGY4X2ludGVybmFsDQo+ICAgICAgMC4zOCUgIHRjX3ByZWZfc2NhbGUucyAg
bGliYy0yLjI4LnNvICAgICAgIFsuXSBfaW50X2ZyZWUNCj4gICAgICAwLjM3JSAgdGNfcHJlZl9z
Y2FsZS5zICBsaWJjLTIuMjguc28gICAgICAgWy5dIF9fR0lfX19zdHJsZW5fc3NlMg0KPiAgICAg
IDAuMzclICB0YyAgICAgICAgICAgICAgIFtrZXJuZWwua2FsbHN5bXNdICBba10gaWRyX2dldF9m
cmVlDQoNCkFyZSB0aGVzZSByZXN1bHRzIGZvciBzYW1lIGNvbmZpZz8gSGVyZSBJIGRvbid0IHNl
ZSBhbnkgbG9ja2RlcCBvcg0KS0FTQU4uIEhvd2V2ZXIgaW4gbmV4dCB0cmFjZS4uLg0KDQo+DQo+
IE91dHB1dCBvbiBuZXQtbmV4dDoNCj4gICAgIDM5LjI2JSAgdGMgICAgICAgICAgICAgICBba2Vy
bmVsLnZtbGludXhdICBba10gbG9ja19pc19oZWxkX3R5cGUNCj4gICAgIDMzLjk5JSAgdGMgICAg
ICAgICAgICAgICBba2VybmVsLnZtbGludXhdICBba10gdGNmX2NoYWluX3RwX2ZpbmQNCj4gICAg
IDEyLjc3JSAgdGMgICAgICAgICAgICAgICBba2VybmVsLnZtbGludXhdICBba10gX19hc2FuX2xv
YWQ0X25vYWJvcnQNCj4gICAgICAxLjkwJSAgdGMgICAgICAgICAgICAgICBba2VybmVsLnZtbGlu
dXhdICBba10gX19hc2FuX2xvYWQ4X25vYWJvcnQNCj4gICAgICAxLjA4JSAgdGMgICAgICAgICAg
ICAgICBba2VybmVsLnZtbGludXhdICBba10gbG9ja19hY3F1aXJlDQo+ICAgICAgMC45NCUgIHRj
ICAgICAgICAgICAgICAgW2tlcm5lbC52bWxpbnV4XSAgW2tdIGRlYnVnX2xvY2tkZXBfcmN1X2Vu
YWJsZWQNCj4gICAgICAwLjYxJSAgdGMgICAgICAgICAgICAgICBba2VybmVsLnZtbGludXhdICBb
a10gZGVidWdfbG9ja2RlcF9yY3VfZW5hYmxlZC5wYXJ0LjUNCj4gICAgICAwLjUxJSAgdGMgICAg
ICAgICAgICAgICBba2VybmVsLnZtbGludXhdICBba10gdW53aW5kX25leHRfZnJhbWUNCj4gICAg
ICAwLjUwJSAgdGMgICAgICAgICAgICAgICBba2VybmVsLnZtbGludXhdICBba10gX3Jhd19zcGlu
X3VubG9ja19pcnFyZXN0b3JlDQo+ICAgICAgMC40NyUgIHRjX3ByZWZfc2NhbGUucyAgW2tlcm5l
bC52bWxpbnV4XSAgW2tdIGxvY2tfYWNxdWlyZQ0KPiAgICAgIDAuNDclICB0YyAgICAgICAgICAg
ICAgIFtrZXJuZWwudm1saW51eF0gIFtrXSBsb2NrX3JlbGVhc2UNCg0KLi4uIGJvdGggbG9ja2Rl
cCBhbmQga2FzYW4gY29uc3VtZSBtb3N0IG9mIENQVSB0aW1lLg0KDQpCVFcgaXQgdGFrZXMgNSBz
ZWMgdG8gZXhlY3V0ZSB5b3VyIHNjcmlwdCBvbiBteSBzeXN0ZW0gd2l0aCBuZXQtbmV4dA0KKGRl
YnVnIG9wdGlvbnMgZGlzYWJsZWQpLg0KDQo+DQo+IEkgZGlkbid0IGludmVzdGlnYXRlIHRoaXMg
YW55IGZ1cnRoZXIgbm93LiBJIGZlYXIgdGhhdCB0aGlzIG1pZ2h0IGJlDQo+IHJlbGF0ZWQgdG8g
VmxhZCdzIGNoYW5nZXMgaW4gdGhlIGFyZWEuIEFueSBpZGVhcz8NCj4NCj4gVGhhbmtzIQ0KPg0K
PiBKaXJpDQo=
