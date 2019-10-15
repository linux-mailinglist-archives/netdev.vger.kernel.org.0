Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A983D71D6
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfJOJJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 05:09:24 -0400
Received: from mail-eopbgr820050.outbound.protection.outlook.com ([40.107.82.50]:34112
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbfJOJJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 05:09:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYGiorZFhlZTpaBGnw+e1lPE3Sc6XRfI7N6WleNqYpOgtq3F0ZwWcgtpvaRrAaLzYAgC7SBAqcBa4gbBuADKoBoVZIKugSpGIWaoEHmmZ7Ovz6RFEDswCTbBjUWlEmvULjA0sJVITHzzRGGvB4nUh8GRL+qsvThAJJYHb1NieyLn1chS3xgDFqtFMqxHiKyOLLPbdYiqS7SpCOTOYdZjhN5dsN7DC4qFtLrTpTclj4sUzqBb3Yw+nNs7TOfQk2WSzlo4XjZbLnXjBklJZkOleLIR3EKQWwkE0cm6dMFNzKIaPtkbB4PmnKeLdX5eH+/Sz+8gWz6ItxG3NmbB2qx73g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3Q0nB4GsQWcAzsqaVz1tGPWzv53/RrjNALA+/7I3EI=;
 b=YF3CFNZut20nwe2RESMG9RaSn9PCJTQNxkQydVtEVmfKagmFfkYz6WNRAMPCwZuo6RaJ7oy6sadIPVem90HEyjsNMtEKr0m8rg8yU6Sw4mF4R/ecm3i3FvHm3FPI8tyVH1U+8+zABI6bGdyc9ANEC+Zw9852wcWOpYfAC6Ivp8MtPny2DiDiMuti7E1eI9jllMDnhEF+89lkHUCrBKz/ODJ3oCNNeIHTWk997RGm+IVqUEJPLEPZ0cbL5XZ9juG2mtXWRVXEaMjysAJV+YCnR0yxpBUFCGH01lk5bXA6v09MkfddXVtfjBNuTvIKvN94GlT5dfMyqx9mPqln8CUnaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3Q0nB4GsQWcAzsqaVz1tGPWzv53/RrjNALA+/7I3EI=;
 b=F/CDLOkksDu4MV7O/2W1ZghgeBy2xdGSKk5ZfanwoqyEoT4RQLEtsPw0ctMQGwhhypIihHQ7r9BVuL3BeCxUgIF5/gxEKElyUfhWNgKf/iKXRYp+QRwLydjM/6C+O0NTp6xvFGu4gJbabh1J90L7BKPMj3+Xwbe98C2Ypv20pV4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3620.namprd11.prod.outlook.com (20.178.222.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Tue, 15 Oct 2019 09:09:19 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 09:09:19 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 06/12] net: aquantia: implement data PTP
 datapath
Thread-Topic: [PATCH v2 net-next 06/12] net: aquantia: implement data PTP
 datapath
Thread-Index: AQHVfccUKqidU8yu2kiaCh23VeKGlKdaX2wAgAEVcoA=
Date:   Tue, 15 Oct 2019 09:09:19 +0000
Message-ID: <af9b3109-c53e-1288-fd7d-8a67446c6923@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <093d91dcc66abeb4d3ef83eef829badd7389d792.1570531332.git.igor.russkikh@aquantia.com>
 <20191014163612.GP21165@lunn.ch>
In-Reply-To: <20191014163612.GP21165@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0044.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83322ab3-f2e4-4d99-96bd-08d7514f5c94
x-ms-traffictypediagnostic: BN8PR11MB3620:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB362027F45B3F458612AE65B398930@BN8PR11MB3620.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(346002)(396003)(136003)(366004)(376002)(199004)(189003)(66446008)(66556008)(2906002)(6246003)(11346002)(6916009)(107886003)(305945005)(7736002)(486006)(6116002)(3846002)(476003)(6486002)(6436002)(2616005)(256004)(229853002)(446003)(4326008)(44832011)(6512007)(64756008)(66476007)(66946007)(8936002)(8676002)(81166006)(81156014)(36756003)(316002)(26005)(99286004)(186003)(508600001)(31686004)(14454004)(86362001)(6506007)(66066001)(25786009)(31696002)(386003)(52116002)(102836004)(76176011)(4744005)(71190400001)(71200400001)(54906003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3620;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHVRf051Z614aY69buBg2NWkS34VDDTqRHgWTK7F3A/2SvY+tAELOvNLL/cROLYIjWowFer3ztEnl6wORmoJRTJydPBY47zQFr7kNrXkZM0Cyli+EYQJ2NWpY4RD743fGCqXmp/6IjbsQnu5Od7O5K5fjv8zNsnnWFl9mOV4xCCtnFCCauQcP+8bd6qvcvjNX8Kwf6nPA9nZT/qHL0cjSaiBT51vNnISIupzCQ5XNfQsoFZEQzjRi8HjjApHixVH+TfIGHVZ1Fxnay2rh0kIsKW8j3VCL5awRRi23Kh7CwGzMSIljZayWQhYIUVkLiWw1dkks0Ft6O0Ovv8ZXQB/+hBmZH4irGMxmykzr4UZbpbVBFrnf/KQQ2nfk7xKQatKSwu8Cyoa48OJEiQlGAL3GXgn7WVGCwL6PHjdqMZ+duA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C7921E8AF4CAD43898074FED5D1E43B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83322ab3-f2e4-4d99-96bd-08d7514f5c94
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 09:09:19.4771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ZNp6Iq9lA54fgDf2aLk/wWk58lS+9M2ZjuZ1sN1VRPLJufKLGCg6XUQ90kbO+lW5fCf+dK8z9RS2FA9avpgvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3620
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiArc3RhdGljIGlubGluZSBpbnQgYXFfcHRwX3RtX29mZnNldF9pbmdyZXNzX2dldChzdHJ1
Y3QgYXFfcHRwX3MgKmFxX3B0cCkNCj4+ICt7DQo+PiArCXJldHVybiBhdG9taWNfcmVhZCgmYXFf
cHRwLT5vZmZzZXRfaW5ncmVzcyk7DQo+PiArfQ0KPiANCj4gaW5saW5lIHNob3VsZCBub3QgYmUg
dXNlZCBpbiBDIGZpbGVzLiBMZXQgdGhlIGNvbXBpbGVyIGRlY2lkZS4NCg0KT2sNCg0KPj4gKwlh
dG9taWNfc2V0KCZhcV9wdHAtPm9mZnNldF9lZ3Jlc3MsIGVncmVzcyk7DQo+PiArCWF0b21pY19z
ZXQoJmFxX3B0cC0+b2Zmc2V0X2luZ3Jlc3MsIGluZ3Jlc3MpOw0KPiANCj4gSXQgc2VlbXMgb2Rk
IHlvdSBoYXZlIHdyYXBwZXJzIGZvciBhdG9taWNfcmVhZCwgYnV0IG5vdCBhdG9taWNfc2V0LiBE
bw0KPiB0aGUgd3JhcHBlcnMgYWN0dWFsbHkgYWRkIGFueXRoaW5nPw0KDQpJIHRoaW5rIG5vLCB0
aGV5IGFyZSBqdXN0IG5hbWluZyBzdWdhci4NCldpbGwgZGlzY3VzcyBpbnRlcm5hbGx5IGFuZCBw
cm9iYWJseSBsZWF2ZSBkaXJlY3QgYXRvbWljX2dldHxzZXQNCg0KPj4gKwlpZiAobmV4dF9oZWFk
ID09IHJpbmctPnRhaWwpDQo+PiArCQlyZXR1cm4gLTE7DQo+IA0KPiBFTk9NRU0/DQoNClJpZ2h0
Lg0KDQo+PiArDQo+PiArCXJpbmctPmJ1ZmZbcmluZy0+aGVhZF0gPSBza2JfZ2V0KHNrYik7DQo+
PiArCXJpbmctPmhlYWQgPSBuZXh0X2hlYWQ7DQo+PiArDQo+PiArCXJldHVybiAwOw0KPj4gK30N
Cj4+ICsNCj4gDQo+ICAgQW5kcmV3DQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcsIEFuZHJldyEN
Cg0KUmVnYXJkcywNCiAgSWdvcg0K
