Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CAD1210FD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLPRHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:07:53 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:42057
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727933AbfLPRHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:07:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AL++eVmTpe+UAkSRSu3sPkrpuJDU/Mfp9OXXJB86kCmGLVSAFuCiJko+Ix9Q3jj1++aptPd4HYcBPV2Qa+ZC860mo8nJMtldDd92yfzzpCRaqTHrkF4ikCl9dcPjhoxTsGIeFtaHqdU7ProUdHi+NEb+2on5KKoyolYSbJTejDWpw5Kl6xG7Y6FY5aQtmnFpO+USGOxWltrkhDAhB9cdoIhiUtv6zqQP8OiQyEEzaDATpFJAa8jx7icBMocu+m4ev4vCc0udgUcmlQF85hF1Av0TNZhsrng/WCHEycEDKrjz/kdY6Sounzrzd5nZaBbygCj4Gz0RsRjS5sj+ZoEuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ju2pb/bN7NmIsuJrqbmIxqlLWZGyRmVnm5Zhe7MC/Ic=;
 b=oFBtoTix+Gu7UEygTGbHsA2KmfeMfsTxRv+27B9e8XwTBWx+87Wh4f9gluAPWpkH7YyUQ8x9Ee2ljxzBBpZyK8w6BJ3paOfuOEAlr1NcmcHi1gYqpcoMrwWKzS4+OV6bg7pO28BoiadvQSqMTQM4EfgcJw5PsvMtoYUseU6jJ+Ghf5DXWsHjZhPa1w9AyMZYc9ODKbZC9a7fe097oyG7PyITa/2tyKWKXVYg2X4/NW5ieQIb8equ46sj9Z86xIk0dZAk9kcgIhiVYA6xUlcsh6rgrhYk6maOQqPdH9BUSoiSivluRwbP6yYFeF0qiUEwsatbSxDhLX5sr4ySJtZMWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ju2pb/bN7NmIsuJrqbmIxqlLWZGyRmVnm5Zhe7MC/Ic=;
 b=ioIFZnsgE31gFUyih0gaTSeTBgvs8xuIcSIPU1S3xLkdamxbdX3uX1s5/v1XaxtR0Q629zeoGpB7YR0JhwiQDriqhxfUJpc4Euh8PvxHx6FxUMU5K5gLedSTnnZFkeEGL9YjIwEhBzLn/yGK9kyglgOW6drvHjuypAnUhZblgBs=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:47 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:47 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 48/55] staging: wfx: introduce update_probe_tmpl()
Thread-Topic: [PATCH 48/55] staging: wfx: introduce update_probe_tmpl()
Thread-Index: AQHVtDLO7/q/Mx2zi0ywoiBpqR255Q==
Date:   Mon, 16 Dec 2019 17:03:58 +0000
Message-ID: <20191216170302.29543-49-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2f8b4bf-e0d0-4605-7653-08d7824a55e2
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4142CF83D1F4909B5587BFBE93510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(15650500001)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCac2Z+6Q4XyUkNoCEZDtGM4IdBH+DiywstTn70IUop/RuuSfyvGILswgjsSNDixLrFDbvZcL8ycs5B+8iWVfjpKJLxc+TMWfRxb9U/qB6RKE9tuYdIl6zHdhz/DQoVf9uG+cNl88q3M47yQL59AkHoyRfhYrYxiHGvrBykcJ69RRS92XkIaSG4XQnPFVuXt2s2TKgN5iBmzdDcNavkCNmT5OAyIvL5ckcZClTc+DRc/gDTaxs+QY7J/e04yPYRpxHIAelsaS0tvSM3ZFJ2unuGnbkLNa7bGhrK5FpO/rEhl+uDTwMziKRMIHCvYxbtdxxRB1cavoDIt9Fb6mD6eQw+6e9/Rqf5YtHaIabqT6IwGM7G1SIPhk+gA/G9/w//zfXBBr2E25hUMf81kQIUARHm9nrOYT6O/eMB7a/QGU8KZbzvpuLjQapil8fevHtqU
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D77E2D38BDB234BAB1354C9E40F3F12@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f8b4bf-e0d0-4605-7653-08d7824a55e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:58.0690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4fTGq7Kg7QlycicrFC7CFFfuaAmC844fixBk2tZS6mrmRh7l66s7OgtqiRyDSra1LXPCOf2Sws3VikgtoTwAaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpT
aW1wbGlmeSB3ZnhfaHdfc2NhbigpIGJ5IHNwbGl0dGluZyBvdXQgdGhlIHVwZGF0ZSBvZiB0aGUg
cHJvYmUgcmVxdWVzdC4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMg
fCA1NyArKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAzMCBpbnNlcnRpb25zKCspLCAyNyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCmlu
ZGV4IDEyMmRhODdiYmY5Mi4uOGIxODRlZmFkMGNmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zY2FuLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQpAQCAtNDks
NiArNDksMjcgQEAgc3RhdGljIGludCB3Znhfc2Nhbl9zdGFydChzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyBpbnQgdXBkYXRlX3Byb2JlX3RtcGwoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsDQorCQkJICAgICBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0
ICpyZXEpDQorew0KKwlzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFtZSAqdG1wbDsNCisJc3Ry
dWN0IHNrX2J1ZmYgKnNrYjsNCisNCisJc2tiID0gaWVlZTgwMjExX3Byb2JlcmVxX2dldCh3dmlm
LT53ZGV2LT5odywgd3ZpZi0+dmlmLT5hZGRyLA0KKwkJCQkgICAgIE5VTEwsIDAsIHJlcS0+aWVf
bGVuKTsNCisJaWYgKCFza2IpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCisJc2tiX3B1dF9kYXRh
KHNrYiwgcmVxLT5pZSwgcmVxLT5pZV9sZW4pOw0KKwlza2JfcHVzaChza2IsIDQpOw0KKwl0bXBs
ID0gKHN0cnVjdCBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lICopc2tiLT5kYXRhOw0KKwl0bXBsLT5m
cmFtZV90eXBlID0gSElGX1RNUExUX1BSQlJFUTsNCisJdG1wbC0+ZnJhbWVfbGVuZ3RoID0gY3B1
X3RvX2xlMTYoc2tiLT5sZW4gLSA0KTsNCisJaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCB0
bXBsKTsNCisJZGV2X2tmcmVlX3NrYihza2IpOw0KKwlyZXR1cm4gMDsNCit9DQorDQogaW50IHdm
eF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJICAgc3RydWN0IGllZWU4MDIx
MV92aWYgKnZpZiwNCiAJCSAgIHN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpod19yZXEp
DQpAQCAtNTYsOSArNzcsNyBAQCBpbnQgd2Z4X2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAq
aHcsDQogCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnByaXY7DQogCXN0cnVjdCB3Znhfdmlm
ICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopIHZpZi0+ZHJ2X3ByaXY7DQogCXN0cnVjdCBjZmc4
MDIxMV9zY2FuX3JlcXVlc3QgKnJlcSA9ICZod19yZXEtPnJlcTsNCi0Jc3RydWN0IHNrX2J1ZmYg
KnNrYjsNCiAJaW50IGksIHJldDsNCi0Jc3RydWN0IGhpZl9taWJfdGVtcGxhdGVfZnJhbWUgKnA7
DQogDQogCWlmICghd3ZpZikNCiAJCXJldHVybiAtRUlOVkFMOw0KQEAgLTcyLDI5ICs5MSwxNSBA
QCBpbnQgd2Z4X2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQogCWlmIChyZXEtPm5f
c3NpZHMgPiBISUZfQVBJX01BWF9OQl9TU0lEUykNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KLQlz
a2IgPSBpZWVlODAyMTFfcHJvYmVyZXFfZ2V0KGh3LCB3dmlmLT52aWYtPmFkZHIsIE5VTEwsIDAs
IHJlcS0+aWVfbGVuKTsNCi0JaWYgKCFza2IpDQotCQlyZXR1cm4gLUVOT01FTTsNCi0NCi0JaWYg
KHJlcS0+aWVfbGVuKQ0KLQkJbWVtY3B5KHNrYl9wdXQoc2tiLCByZXEtPmllX2xlbiksIHJlcS0+
aWUsIHJlcS0+aWVfbGVuKTsNCi0NCiAJbXV0ZXhfbG9jaygmd2Rldi0+Y29uZl9tdXRleCk7DQog
DQotCXAgPSAoc3RydWN0IGhpZl9taWJfdGVtcGxhdGVfZnJhbWUgKilza2JfcHVzaChza2IsIDQp
Ow0KLQlwLT5mcmFtZV90eXBlID0gSElGX1RNUExUX1BSQlJFUTsNCi0JcC0+ZnJhbWVfbGVuZ3Ro
ID0gY3B1X3RvX2xlMTYoc2tiLT5sZW4gLSA0KTsNCi0JcmV0ID0gaGlmX3NldF90ZW1wbGF0ZV9m
cmFtZSh3dmlmLCBwKTsNCi0Jc2tiX3B1bGwoc2tiLCA0KTsNCisJcmV0ID0gdXBkYXRlX3Byb2Jl
X3RtcGwod3ZpZiwgcmVxKTsNCisJaWYgKHJldCkNCisJCWdvdG8gZmFpbGVkOw0KIA0KLQlpZiAo
IXJldCkNCi0JCS8qIEhvc3Qgd2FudCB0byBiZSB0aGUgcHJvYmUgcmVzcG9uZGVyLiAqLw0KLQkJ
cmV0ID0gd2Z4X2Z3ZF9wcm9iZV9yZXEod3ZpZiwgdHJ1ZSk7DQotCWlmIChyZXQpIHsNCi0JCW11
dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7DQotCQlkZXZfa2ZyZWVfc2tiKHNrYik7DQot
CQlyZXR1cm4gcmV0Ow0KLQl9DQorCXJldCA9IHdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIHRydWUp
Ow0KKwlpZiAocmV0KQ0KKwkJZ290byBmYWlsZWQ7DQogDQogCXdmeF90eF9sb2NrX2ZsdXNoKHdk
ZXYpOw0KIA0KQEAgLTExNCwxMyArMTE5LDExIEBAIGludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywNCiAJCWRzdC0+c3NpZF9sZW5ndGggPSByZXEtPnNzaWRzW2ldLnNzaWRf
bGVuOw0KIAkJKyt3dmlmLT5zY2FuLm5fc3NpZHM7DQogCX0NCisJc2NoZWR1bGVfd29yaygmd3Zp
Zi0+c2Nhbi53b3JrKTsNCiANCitmYWlsZWQ6DQogCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9t
dXRleCk7DQotDQotCWlmIChza2IpDQotCQlkZXZfa2ZyZWVfc2tiKHNrYik7DQotCXNjaGVkdWxl
X3dvcmsoJnd2aWYtPnNjYW4ud29yayk7DQotCXJldHVybiAwOw0KKwlyZXR1cm4gcmV0Ow0KIH0N
CiANCiB2b2lkIHdmeF9zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KLS0gDQoy
LjIwLjENCg==
