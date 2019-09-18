Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E4CB65A7
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfIROQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 10:16:32 -0400
Received: from mail-eopbgr720065.outbound.protection.outlook.com ([40.107.72.65]:25276
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfIROQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 10:16:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j767ujQbE/MsC9Dqwi1KDjgfpM154MYP+2sdv2w4KD3qbiA6XVf+UlCgn4bvCvgzP2HxrB4dl6Bo8/cLTY1/QNf3S+ziJN9rHYd8qT770lHux3TnuN6LYZ2Ul3rJurGZM58V3atUmXDKeOUSMKVWAxEKoh6C2V0ueBKzSUmf5/RCaSmb4XiKOAKWaptFHiDcuATQkeZs3JQefVoL6AShHBIrcpwBOuy84b83jtalbesvaSptefVmXGiM9vFuIaUtPD9kZXL/wABKolqkPm+ti3sJvts3OrWkjqRv8Ds1krFOHslAYr2KNuij/JkJtOGFw0ppKchMFJ0dXK0HmZEEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oo/KUudxLbs4wIVfmcw1JSYG60uq/M5b0PW/CeAb0I=;
 b=JkXCpLn0c98rG3MvpD7vKD4ia+1kxCJCtqMXe4NWDmiNciGi/RwHP/0ciWGv67e7rumBeKr6wIc44OjYLGrAQFiKjw9PwSr6fNJr9OK8f6iwgE6l31r+tkjrNp44X87DAbHaSF1nlPTEFLAt+qe4jejT0cuWG3XZJ4f/kcaGo/+GGxf4JOtvCOA5kISCT2jC8sh/gT2Xczj/Z1KSfdgnPdzkmZDRutO4fVnAHoJn0slvkHokhQlz5993BgXjZwZQIce1ECxY9JoZk7RJ2cZVRlVovrTtAbx4KUGDyxz2AToZ07vTRfJPuR06bcKEAqFa4WrgdM40GTKFsSurKq+7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oo/KUudxLbs4wIVfmcw1JSYG60uq/M5b0PW/CeAb0I=;
 b=HvCk0AMy3NVt4i6LYsW9fbYoyDCBN5CLuXALH0pvZ/JzZFfZaoXsIU7EG3DYdlV/d+Z2LeA1EcqoBo/7rsoPzhmEMiQ1vRxGlAalsX0OmscIiNGJBDv5dec6ssiFU1ahk4IDdChUPsbKwNGtcpKLPeibYIRvf38dFL7QghNYduk=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6790.namprd02.prod.outlook.com (20.180.17.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Wed, 18 Sep 2019 14:16:23 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::3515:e3a7:8799:73bd]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::3515:e3a7:8799:73bd%2]) with mapi id 15.20.2284.009; Wed, 18 Sep 2019
 14:16:23 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Markus Elfring <Markus.Elfring@web.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michals@xilinx.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: RE: [PATCH] ethernet: Use devm_platform_ioremap_resource() in three
 functions
Thread-Topic: [PATCH] ethernet: Use devm_platform_ioremap_resource() in three
 functions
Thread-Index: AQHVbiVJrMo9zt2XL0ayrq5tymaMB6cxduyg
Date:   Wed, 18 Sep 2019 14:16:23 +0000
Message-ID: <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de>
In-Reply-To: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 077f8b97-4191-4492-4b33-08d73c42c94b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR02MB6790;
x-ms-traffictypediagnostic: CH2PR02MB6790:|CH2PR02MB6790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB67905B69A0880457C2CB5A9DC78E0@CH2PR02MB6790.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:473;
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(199004)(189003)(13464003)(2201001)(76176011)(2501003)(14454004)(14444005)(316002)(7696005)(33656002)(256004)(5660300002)(52536014)(76116006)(55016002)(99286004)(6246003)(54906003)(110136005)(9686003)(7416002)(6436002)(66556008)(64756008)(86362001)(71190400001)(6636002)(66066001)(66476007)(66446008)(74316002)(4326008)(229853002)(305945005)(7736002)(8676002)(66946007)(26005)(2906002)(71200400001)(476003)(478600001)(11346002)(186003)(486006)(8936002)(25786009)(102836004)(446003)(6116002)(3846002)(53546011)(81156014)(6506007)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6790;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2rRvfyx/M+DWNtDBjMX7uzzSYdn6zxDwopAx+TxazxKfEaCkeg699M6Bkx5J55ooe1illxRyiScTk2F2gVKxgz7tXENtOJId4HaZyyd5ItBdBVnSbo4pLfxqqLH9TunHMK1IwhTcC2xpWIOq6I2XllQopVBxVgdFiFgMrH8JRhnEH1KuXD2qQS4TQ+VNXIFxDyM3qHG33rQz6x8KLNQ8zbh/hDh0FikkcZTRWLOHz7JYCMny4q8AvsUp8BswVavA2xLtnd/kSVnR3VetnRLo9eLDF5wU5fZvam+vP8ijJuG2Fa7IW7Rb/zrPUWfVQRioWP8sIxvrLty/fzfXfGuxxeMYpCuw1ZtCu7hGoWm/iXHAgqYBCFVEM5jWVsvGhFsAywkNAvwf3LgjqT35FksYXJQOWw/Jw2890sgatDLyeQI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077f8b97-4191-4492-4b33-08d73c42c94b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2019 14:16:23.8006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WeIqQ6VdYY/UFfgql0o2nNsC4IJHiEfqhAtjAKcLWIUxEMeZdivl6LEW/E09ifYQ5T1b98YP/epGELLeWO7rlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6790
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJrdXMgRWxmcmluZyA8TWFy
a3VzLkVsZnJpbmdAd2ViLmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAxOCwgMjAx
OSA3OjAxIFBNDQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0ta2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmc7IERhdmlkIFMuDQo+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD47IEhhbnMgVWxsaSBLcm9sbCA8dWxsaS5rcm9sbEBnb29nbGVtYWlsLmNvbT47DQo+IEhh
dWtlIE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPjsgTGludXMgV2FsbGVpag0KPiA8bGludXMu
d2FsbGVpakBsaW5hcm8ub3JnPjsgTWljaGFsIFNpbWVrIDxtaWNoYWxzQHhpbGlueC5jb20+OyBS
YWRoZXkNCj4gU2h5YW0gUGFuZGV5IDxyYWRoZXlzQHhpbGlueC5jb20+DQo+IENjOiBMS01MIDxs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVs
Lm9yZzsNCj4gQmFydG9zeiBHb2xhc3pld3NraSA8YmdvbGFzemV3c2tpQGJheWxpYnJlLmNvbT47
IEhpbWFuc2h1IEpoYQ0KPiA8aGltYW5zaHVqaGExOTk2NDBAZ21haWwuY29tPg0KPiBTdWJqZWN0
OiBbUEFUQ0hdIGV0aGVybmV0OiBVc2UgZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291cmNlKCkg
aW4gdGhyZWUNCj4gZnVuY3Rpb25zDQoNClByZWZlciB1c2luZyBhIHNlcGFyYXRlIHBhdGNoIGZv
ciBlYWNoIGRyaXZlci4gQWxzbyBza2lwIG1lbnRpb25pbmcNCiJ0aHJlZSBmdW5jdGlvbnMiIGlu
IGNvbW1pdCBkZXNjcmlwdGlvbi4gIA0KDQo+IA0KPiBGcm9tOiBNYXJrdXMgRWxmcmluZyA8ZWxm
cmluZ0B1c2Vycy5zb3VyY2Vmb3JnZS5uZXQ+DQo+IERhdGU6IFdlZCwgMTggU2VwIDIwMTkgMTU6
MTU6MDYgKzAyMDANCj4gDQo+IFNpbXBsaWZ5IHRoZXNlIGZ1bmN0aW9uIGltcGxlbWVudGF0aW9u
cyBieSB1c2luZyBhIGtub3duIHdyYXBwZXIgZnVuY3Rpb24uDQoNCk1pbm9yIG5pdC0gQmV0dGVy
IHRvIG1lbnRpb24gYWJvdXQgdGhlc2UgZnVuY3MgaW4gY29tbWl0IGRlc2NyaXB0aW9uLg0KU29t
ZXRoaW5nIGxpa2UtIHVzZXMgZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291cmNlKCkgaW5zdGVh
ZCBvZiB1c2luZw0KcGxhdGZvcm1fZ2V0X3Jlc291cmNlKCkgYW5kIGRldm1faW9yZW1hcF9yZXNv
dXJjZSgpIHRvZ2V0aGVyIHRvIHNpbXBsaWZ5Lg0KDQo+IA0KPiBUaGlzIGlzc3VlIHdhcyBkZXRl
Y3RlZCBieSB1c2luZyB0aGUgQ29jY2luZWxsZSBzb2Z0d2FyZS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IE1hcmt1cyBFbGZyaW5nIDxlbGZyaW5nQHVzZXJzLnNvdXJjZWZvcmdlLm5ldD4NCj4gLS0t
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jb3J0aW5hL2dlbWluaS5jICAgICAgICAgICAgIHwg
IDYgKy0tLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9sYW50aXFfeHJ4MjAwLmMgICAgICAg
ICAgICAgIHwgMTEgKy0tLS0tLS0tLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94
aWxpbnhfYXhpZW5ldF9tYWluLmMgfCAgOSArLS0tLS0tLS0NCj4gIDMgZmlsZXMgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jb3J0aW5hL2dlbWluaS5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY29ydGluYS9nZW1pbmkuYw0KPiBpbmRleCBlNzM2Y2UyYzU4Y2EuLmYwMDk0MTVlZTRkOCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY29ydGluYS9nZW1pbmkuYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jb3J0aW5hL2dlbWluaS5jDQo+IEBAIC0yNTQ5LDE3
ICsyNTQ5LDEzIEBAIHN0YXRpYyBpbnQgZ2VtaW5pX2V0aGVybmV0X3Byb2JlKHN0cnVjdA0KPiBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRl
djsNCj4gIAlzdHJ1Y3QgZ2VtaW5pX2V0aGVybmV0ICpnZXRoOw0KPiAgCXVuc2lnbmVkIGludCBy
ZXRyeSA9IDU7DQo+IC0Jc3RydWN0IHJlc291cmNlICpyZXM7DQo+ICAJdTMyIHZhbDsNCj4gDQo+
ICAJLyogR2xvYmFsIHJlZ2lzdGVycyAqLw0KPiAgCWdldGggPSBkZXZtX2t6YWxsb2MoZGV2LCBz
aXplb2YoKmdldGgpLCBHRlBfS0VSTkVMKTsNCj4gIAlpZiAoIWdldGgpDQo+ICAJCXJldHVybiAt
RU5PTUVNOw0KPiAtCXJlcyA9IHBsYXRmb3JtX2dldF9yZXNvdXJjZShwZGV2LCBJT1JFU09VUkNF
X01FTSwgMCk7DQo+IC0JaWYgKCFyZXMpDQo+IC0JCXJldHVybiAtRU5PREVWOw0KPiAtCWdldGgt
PmJhc2UgPSBkZXZtX2lvcmVtYXBfcmVzb3VyY2UoZGV2LCByZXMpOw0KPiArCWdldGgtPmJhc2Ug
PSBkZXZtX3BsYXRmb3JtX2lvcmVtYXBfcmVzb3VyY2UocGRldiwgMCk7DQo+ICAJaWYgKElTX0VS
UihnZXRoLT5iYXNlKSkNCj4gIAkJcmV0dXJuIFBUUl9FUlIoZ2V0aC0+YmFzZSk7DQo+ICAJZ2V0
aC0+ZGV2ID0gZGV2Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbGFudGlx
X3hyeDIwMC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbGFudGlxX3hyeDIwMC5jDQo+IGlu
ZGV4IDkwMGFmZmJkY2MwZS4uMGE3ZWE0NWI5ZTU5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9sYW50aXFfeHJ4MjAwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bGFudGlxX3hyeDIwMC5jDQo+IEBAIC00MjQsNyArNDI0LDYgQEAgc3RhdGljIGludCB4cngyMDBf
cHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIHsNCj4gIAlzdHJ1Y3QgZGV2
aWNlICpkZXYgPSAmcGRldi0+ZGV2Ow0KPiAgCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAgPSBkZXYt
Pm9mX25vZGU7DQo+IC0Jc3RydWN0IHJlc291cmNlICpyZXM7DQo+ICAJc3RydWN0IHhyeDIwMF9w
cml2ICpwcml2Ow0KPiAgCXN0cnVjdCBuZXRfZGV2aWNlICpuZXRfZGV2Ow0KPiAgCWNvbnN0IHU4
ICptYWM7DQo+IEBAIC00NDMsMTUgKzQ0Miw3IEBAIHN0YXRpYyBpbnQgeHJ4MjAwX3Byb2JlKHN0
cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJU0VUX05FVERFVl9ERVYobmV0X2Rldiwg
ZGV2KTsNCj4gIAluZXRfZGV2LT5taW5fbXR1ID0gRVRIX1pMRU47DQo+ICAJbmV0X2Rldi0+bWF4
X210dSA9IFhSWDIwMF9ETUFfREFUQV9MRU47DQo+IC0NCj4gLQkvKiBsb2FkIHRoZSBtZW1vcnkg
cmFuZ2VzICovDQo+IC0JcmVzID0gcGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VS
Q0VfTUVNLCAwKTsNCj4gLQlpZiAoIXJlcykgew0KPiAtCQlkZXZfZXJyKGRldiwgImZhaWxlZCB0
byBnZXQgcmVzb3VyY2VzXG4iKTsNCj4gLQkJcmV0dXJuIC1FTk9FTlQ7DQo+IC0JfQ0KPiAtDQo+
IC0JcHJpdi0+cG1hY19yZWcgPSBkZXZtX2lvcmVtYXBfcmVzb3VyY2UoZGV2LCByZXMpOw0KPiAr
CXByaXYtPnBtYWNfcmVnID0gZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291cmNlKHBkZXYsIDAp
Ow0KPiAgCWlmIChJU19FUlIocHJpdi0+cG1hY19yZWcpKSB7DQo+ICAJCWRldl9lcnIoZGV2LCAi
ZmFpbGVkIHRvIHJlcXVlc3QgYW5kIHJlbWFwIGlvIHJhbmdlc1xuIik7DQo+ICAJCXJldHVybiBQ
VFJfRVJSKHByaXYtPnBtYWNfcmVnKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IGluZGV4IDRmYzYyN2ZiNGQxMS4uOTI3
ODNhYWFhMGEyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGls
aW54X2F4aWVuZXRfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94
aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gQEAgLTE3ODcsMTQgKzE3ODcsNyBAQCBzdGF0aWMgaW50
IGF4aWVuZXRfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gIAkJb2Zf
bm9kZV9wdXQobnApOw0KPiAgCQlscC0+ZXRoX2lycSA9IHBsYXRmb3JtX2dldF9pcnEocGRldiwg
MCk7DQo+ICAJfSBlbHNlIHsNCj4gLQkJLyogQ2hlY2sgZm9yIHRoZXNlIHJlc291cmNlcyBkaXJl
Y3RseSBvbiB0aGUgRXRoZXJuZXQgbm9kZS4gKi8NCj4gLQkJc3RydWN0IHJlc291cmNlICpyZXMg
PSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwNCj4gLQ0KPiBJT1JFU09VUkNFX01FTSwgMSk7
DQo+IC0JCWlmICghcmVzKSB7DQo+IC0JCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJ1bmFibGUgdG8g
Z2V0IERNQSBtZW1vcnkNCj4gcmVzb3VyY2VcbiIpOw0KPiAtCQkJZ290byBmcmVlX25ldGRldjsN
Cj4gLQkJfQ0KPiAtCQlscC0+ZG1hX3JlZ3MgPSBkZXZtX2lvcmVtYXBfcmVzb3VyY2UoJnBkZXYt
PmRldiwgcmVzKTsNCj4gKwkJbHAtPmRtYV9yZWdzID0gZGV2bV9wbGF0Zm9ybV9pb3JlbWFwX3Jl
c291cmNlKHBkZXYsIDEpOw0KPiAgCQlscC0+cnhfaXJxID0gcGxhdGZvcm1fZ2V0X2lycShwZGV2
LCAxKTsNCj4gIAkJbHAtPnR4X2lycSA9IHBsYXRmb3JtX2dldF9pcnEocGRldiwgMCk7DQo+ICAJ
CWxwLT5ldGhfaXJxID0gcGxhdGZvcm1fZ2V0X2lycShwZGV2LCAyKTsNCj4gLS0NCj4gMi4yMy4w
DQoNCg==
