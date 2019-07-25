Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED5742B1
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 02:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfGYAsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 20:48:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29064 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbfGYAsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 20:48:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6P0jOkx023492;
        Wed, 24 Jul 2019 17:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=uqg2KxnlRx9ysHJbiX/kIx7Zkths63k8JJAvyjQd5/A=;
 b=M0DEHYmXYIG2yjbpuDfwMBSk+urbmml6CILCO62AnaIRkpxcm2Zycc7yUO5UkT7E08TE
 E/5W0J6M4oiQKyiwNcIZP9Mp4T7Fm/cLtrgJ2ozDFdZ7RQ3tHtGlNsmCcNfKSzHJoVt/
 P6N3OzsM7XIg7b0HdpAPQqvQPs+bqAusaya+4q0DzvrNCwLgg/qEJk/+3mhV7uBL4ICk
 3HEsut/ASX3RclHA1RV8FaS9qL9kYeWPjHTLvkQ5+wCTAvnhRYFmubXWxMvo/DhIvz5o
 KUHjlpClvHMiK2nsbQlRrPkAUvNwWWnuPtM+AtB7UpEJ30AU++3mFD7jNvWS0NX8nz6b Dg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rf1h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 17:48:32 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 24 Jul
 2019 17:48:31 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.54) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 24 Jul 2019 17:48:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc5G7HXbpDg2czC/w20lwtO7RHbVcgTBCNgL7pqX7F4VJf8iUHLpZ77yj/7gqFX6xaeJrs90tfr6cmQwQ7c0BCNxitWedphGo+YvIahVGllZIZ2oOtjmj82iXccyab6myEDyRXNZXM/iZcB40lk+2tLbo17z6filCfdH5Yz7A2LQ/bqUtPtA4Czcwq/dCOG/4wy6rCM7VZ9j2ezCt2gydhe4NCGqAiwty0zZnN6k/8y0+yxGA1DiyPuungC7+Eo5LKFadDrcS1EICj6TZVNq61pxdI8igAHwl5CaHxQyJ0RyYhin0o3Hpk7E9i8FRpic6VVd+tUpRkT66Ha7/y5OYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqg2KxnlRx9ysHJbiX/kIx7Zkths63k8JJAvyjQd5/A=;
 b=ZC6bllPFFQNtR+HjugroZLYRcCjCBMQPh2T+L47e/2u0JU/c6YL+V8080PrXNKJfe8ql85ZMuvbk9CDdi+xkAkX74TfWB66SMl2UG6YUTSJn2TIaPb6Sc+wSd4OLLhAax5EVbd+T+AZFAJxIPiJeLbTHKHH5k3sASQSTOChE1k56v+g2r1hLvwQ3r2E0G7XDBf/MsbP2Y/4FW/KMqjMSQ/6dKkpIva4DrVK5Ha4uoEPutrMmF7JQiWc7cUtr8HrD8aVNTmB7HKjSVG3LO5f+CTGCj7J3npVD2y9yhUfwoEF0kb/Hkfprx2ZkghPi0sDbGCn4T6xgDvlhZOJAPQDNRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqg2KxnlRx9ysHJbiX/kIx7Zkths63k8JJAvyjQd5/A=;
 b=PeVJL2HzzMUoPtlEltiQDLpR5ERZO8ntZHFxePHlkl+b+78vhxhLf4hd8AeHk7mA6Mh72vQPTV6y7ABvllimAGQRhL+gq+y39wqzhBdXBmth6VQ0D0visWeEnvubgRX5sZJkFp27taVdo5VouEjSQJK3/0E33iS6ohad4JTOl2U=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2878.namprd18.prod.outlook.com (20.179.22.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 00:48:27 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2094.017; Thu, 25 Jul 2019
 00:48:27 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] qed: Add API for flashing the nvm
 attributes.
Thread-Topic: [PATCH net-next 2/2] qed: Add API for flashing the nvm
 attributes.
Thread-Index: AQHVQduLokqu4pcbaEuAaiqqjflGdKbaLDaAgABQ2oA=
Date:   Thu, 25 Jul 2019 00:48:27 +0000
Message-ID: <MN2PR18MB25283C800F4F96BB511118A0D3C10@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190724045141.27703-1-skalluru@marvell.com>
         <20190724045141.27703-3-skalluru@marvell.com>
 <24c09b029d00ba73aab58ef09a2e65ac545b3423.camel@mellanox.com>
In-Reply-To: <24c09b029d00ba73aab58ef09a2e65ac545b3423.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:52f:5282:d96a:f14b:eee7:a834]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2380017a-23a0-41ae-5308-08d71099ce49
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2878;
x-ms-traffictypediagnostic: MN2PR18MB2878:
x-microsoft-antispam-prvs: <MN2PR18MB2878200BDB4B084AF07B0C26D3C10@MN2PR18MB2878.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(13464003)(55016002)(54906003)(46003)(446003)(305945005)(476003)(256004)(11346002)(2906002)(14444005)(486006)(74316002)(2501003)(68736007)(7736002)(110136005)(14454004)(4326008)(6436002)(33656002)(71200400001)(316002)(66556008)(6116002)(7696005)(99286004)(71190400001)(186003)(76176011)(81166006)(81156014)(52536014)(76116006)(102836004)(66476007)(6246003)(86362001)(53936002)(25786009)(8936002)(8676002)(229853002)(6506007)(478600001)(53546011)(5660300002)(9686003)(66946007)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2878;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qIf2ANrLYwiRoZ0TH9z6CeaBpy0ygrjcXexSJDYC8Ox/uZX6tAuONTzEoxGusvRnMu6/UWA6BuQX7m5mgp4mxwmwipYc7bGllOWG0Bwl66tkVYXmjry5uJeOPvoiTXKYVMkZEpBTQmPPidTyQVA6rjjBbR9cbSSW12vq0NJIdsK9LMQOg8g96V0YxRqc8R/Kc2aHNYJUWWA8d6CovYtAJOZ4gDLzQRhgveeNZht6bM81+pr1mXCNTq4AhB84iBpsmg/6f9cifv6a6j8MgPSSxF6G0sbZQtMKW0ROSuna/5vozzUflomPCUZp352uGvBI0ohI+QbB/iqOtknCsMUl4vwjwqCqeWchVgMHfAI/rtGr5sejRihVJCpRhTZnWEJoubmB7W8WH6fEkm1NMa8hN6dEcYFStWsKBOIY1tysjNg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2380017a-23a0-41ae-5308-08d71099ce49
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 00:48:27.1707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2878
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-24_10:2019-07-24,2019-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bHkgMjUsIDIwMTkgMToxMyBB
TQ0KPiBUbzogU3VkYXJzYW5hIFJlZGR5IEthbGx1cnUgPHNrYWxsdXJ1QG1hcnZlbGwuY29tPjsN
Cj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiBDYzogQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxs
LmNvbT47IE1pY2hhbCBLYWxkZXJvbg0KPiA8bWthbGRlcm9uQG1hcnZlbGwuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENIIG5ldC1uZXh0IDIv
Ml0gcWVkOiBBZGQgQVBJIGZvciBmbGFzaGluZyB0aGUgbnZtDQo+IGF0dHJpYnV0ZXMuDQo+IA0K
PiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBPbiBUdWUsIDIwMTktMDct
MjMgYXQgMjE6NTEgLTA3MDAsIFN1ZGFyc2FuYSBSZWRkeSBLYWxsdXJ1IHdyb3RlOg0KPiA+IFRo
ZSBwYXRjaCBhZGRzIGRyaXZlciBpbnRlcmZhY2UgZm9yIHJlYWRpbmcgdGhlIE5WTSBjb25maWcg
cmVxdWVzdCBhbmQNCj4gPiB1cGRhdGUgdGhlIGF0dHJpYnV0ZXMgb24gbnZtIGNvbmZpZyBmbGFz
aCBwYXJ0aXRpb24uDQo+ID4NCj4gDQo+IFlvdSBkaWRuJ3Qgbm90IHVzZSB0aGUgZ2V0X2NmZyBB
UEkgeW91IGFkZGVkIGluIHByZXZpb3VzIHBhdGNoLg0KVGhhbmtzIGZvciB5b3VyIHJldmlldy4g
V2lsbCBtb3ZlIHRoaXMgQVBJIHRvIHRoZSBuZXh0IHBhdGNoIHNlcmllcyB3aGljaCB3aWxsIHBs
YW4gdG8gc2VuZCBzaG9ydGx5Lg0KDQo+IA0KPiBBbHNvIGNhbiB5b3UgcGxlYXNlIGNsYXJpZnkg
aG93IHRoZSB1c2VyIHJlYWRzL3dyaXRlIGZyb20vdG8gTlZNIGNvbmZpZw0KPiA/IGkgbWVhbiB3
aGF0IFVBUElzIGFuZCB0b29scyBhcmUgYmVpbmcgdXNlZCA/DQpOVk0gY29uZmlnL3BhcnRpdGlv
biB3aWxsIGJlIHVwZGF0ZWQgdXNpbmcgZXRodG9vbCBmbGFzaCB1cGRhdGUgY29tbWFuZCAoaS5l
LiwgZXRodG9vbCAtZikganVzdCBsaWtlIHRoZSB1cGRhdGUgb2YgDQpvdGhlciBmbGFzaCBwYXJ0
aXRpb25zIG9mIHFlZCBkZXZpY2UuIEV4YW1wbGUgY29kZSBwYXRoLA0KICBldGhvb2wtZmxhc2hf
ZGV2aWNlIC0tPiBxZWRlX2ZsYXNoX2RldmljZSgpIC0tPiBxZWRfbnZtX2ZsYXNoKCkgLS0+IHFl
ZF9udm1fZmxhc2hfY2ZnX3dyaXRlKCkNCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdWRhcnNh
bmEgUmVkZHkgS2FsbHVydSA8c2thbGx1cnVAbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfbWFpbi5jIHwgNjUNCj4gPiArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gPiAgaW5jbHVkZS9saW51eC9xZWQvcWVkX2lmLmggICAg
ICAgICAgICAgICAgIHwgIDEgKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDY2IGluc2VydGlvbnMo
KykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWVk
L3FlZF9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Fsb2dpYy9xZWQvcWVkX21h
aW4uYw0KPiA+IGluZGV4IDgyOWRkNjAuLjU0ZjAwZDIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfbWFpbi5jDQo+ID4gQEAgLTY3LDYgKzY3LDggQEAN
Cj4gPiAgI2RlZmluZSBRRURfUk9DRV9RUFMJCQkoODE5MikNCj4gPiAgI2RlZmluZSBRRURfUk9D
RV9EUElTCQkJKDgpDQo+ID4gICNkZWZpbmUgUUVEX1JETUFfU1JRUyAgICAgICAgICAgICAgICAg
ICBRRURfUk9DRV9RUFMNCj4gPiArI2RlZmluZSBRRURfTlZNX0NGR19TRVRfRkxBR1MJCTB4RQ0K
PiA+ICsjZGVmaW5lIFFFRF9OVk1fQ0ZHX1NFVF9QRl9GTEFHUwkweDFFDQo+ID4NCj4gPiAgc3Rh
dGljIGNoYXIgdmVyc2lvbltdID0NCj4gPiAgCSJRTG9naWMgRmFzdExpblEgNHh4eHggQ29yZSBN
b2R1bGUgcWVkICIgRFJWX01PRFVMRV9WRVJTSU9ODQo+ID4gIlxuIjsNCj4gPiBAQCAtMjIyNyw2
ICsyMjI5LDY2IEBAIHN0YXRpYyBpbnQgcWVkX252bV9mbGFzaF9pbWFnZV92YWxpZGF0ZShzdHJ1
Y3QNCj4gPiBxZWRfZGV2ICpjZGV2LA0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPg0KPiA+
ICsvKiBCaW5hcnkgZmlsZSBmb3JtYXQgLQ0KPiA+ICsgKiAgICAgLy0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAtLS0tLS0tLS0t
LS1cDQo+ID4gKyAqIDBCICB8ICAgICAgICAgICAgICAgICAgICAgICAweDUgW2NvbW1hbmQNCj4g
PiBpbmRleF0gICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ICsgKiA0QiAgfCBFbnRp
dHkgSUQgICAgIHwgUmVzZXJ2ZWQgICAgICAgIHwgIE51bWJlciBvZiBjb25maWcNCj4gPiBhdHRy
aWJ1dGVzICAgICAgIHwNCj4gPiArICogOEIgIHwgQ29uZmlnIElEICAgICAgICAgICAgICAgICAg
ICAgICB8IExlbmd0aCAgICAgICAgfA0KPiA+IFZhbHVlICAgICAgICAgICAgICB8DQo+ID4gKw0K
PiA+ICogICAgIHwNCj4gPiAgICAgICAgIHwNCj4gPiArICogICAgIFwtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gLS0tLS0tLS0t
LS0tLw0KPiA+ICsgKiBUaGVyZSBjYW4gYmUgc2V2ZXJhbCBDZmdfaWQtTGVuZ3RoLVZhbHVlIHNl
dHMgYXMgc3BlY2lmaWVkIGJ5DQo+ID4gJ051bWJlciBvZi4uLicuDQo+ID4gKyAqIEVudGl0eSBJ
RCAtIEEgbm9uIHplcm8gZW50aXR5IHZhbHVlIGZvciB3aGljaCB0aGUgY29uZmlnIG5lZWQgdG8N
Cj4gPiBiZSB1cGRhdGVkLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGludCBxZWRfbnZtX2ZsYXNo
X2NmZ193cml0ZShzdHJ1Y3QgcWVkX2RldiAqY2RldiwgY29uc3QgdTgNCj4gPiAqKmRhdGEpDQo+
ID4gK3sNCj4gPiArCXN0cnVjdCBxZWRfaHdmbiAqaHdmbiA9IFFFRF9MRUFESU5HX0hXRk4oY2Rl
dik7DQo+ID4gKwl1OCBlbnRpdHlfaWQsIGxlbiwgYnVmWzMyXTsNCj4gPiArCXN0cnVjdCBxZWRf
cHR0ICpwdHQ7DQo+ID4gKwl1MTYgY2ZnX2lkLCBjb3VudDsNCj4gPiArCWludCByYyA9IDAsIGk7
DQo+ID4gKwl1MzIgZmxhZ3M7DQo+ID4gKw0KPiA+ICsJcHR0ID0gcWVkX3B0dF9hY3F1aXJlKGh3
Zm4pOw0KPiA+ICsJaWYgKCFwdHQpDQo+ID4gKwkJcmV0dXJuIC1FQUdBSU47DQo+ID4gKw0KPiA+
ICsJLyogTlZNIENGRyBJRCBhdHRyaWJ1dGUgaGVhZGVyICovDQo+ID4gKwkqZGF0YSArPSA0Ow0K
PiA+ICsJZW50aXR5X2lkID0gKipkYXRhOw0KPiA+ICsJKmRhdGEgKz0gMjsNCj4gPiArCWNvdW50
ID0gKigodTE2ICopKmRhdGEpOw0KPiA+ICsJKmRhdGEgKz0gMjsNCj4gPiArDQo+ID4gKwlEUF9W
RVJCT1NFKGNkZXYsIE5FVElGX01TR19EUlYsDQo+ID4gKwkJICAgIlJlYWQgY29uZmlnIGlkczog
ZW50aXR5IGlkICUwMnggbnVtIF9hdHRycyA9DQo+ID4gJTBkXG4iLA0KPiA+ICsJCSAgIGVudGl0
eV9pZCwgY291bnQpOw0KPiA+ICsJLyogTlZNIENGRyBJRCBhdHRyaWJ1dGVzICovDQo+ID4gKwlm
b3IgKGkgPSAwOyBpIDwgY291bnQ7IGkrKykgew0KPiA+ICsJCWNmZ19pZCA9ICooKHUxNiAqKSpk
YXRhKTsNCj4gPiArCQkqZGF0YSArPSAyOw0KPiA+ICsJCWxlbiA9ICoqZGF0YTsNCj4gPiArCQko
KmRhdGEpKys7DQo+ID4gKwkJbWVtY3B5KGJ1ZiwgKmRhdGEsIGxlbik7DQo+ID4gKwkJKmRhdGEg
Kz0gbGVuOw0KPiA+ICsNCj4gPiArCQlmbGFncyA9IGVudGl0eV9pZCA/IFFFRF9OVk1fQ0ZHX1NF
VF9QRl9GTEFHUyA6DQo+ID4gKwkJCVFFRF9OVk1fQ0ZHX1NFVF9GTEFHUzsNCj4gPiArDQo+ID4g
KwkJRFBfVkVSQk9TRShjZGV2LCBORVRJRl9NU0dfRFJWLA0KPiA+ICsJCQkgICAiY2ZnX2lkID0g
JWQgbGVuID0gJWRcbiIsIGNmZ19pZCwgbGVuKTsNCj4gPiArCQlyYyA9IHFlZF9tY3BfbnZtX3Nl
dF9jZmcoaHdmbiwgcHR0LCBjZmdfaWQsIGVudGl0eV9pZCwNCj4gPiBmbGFncywNCj4gPiArCQkJ
CQkgYnVmLCBsZW4pOw0KPiA+ICsJCWlmIChyYykgew0KPiA+ICsJCQlEUF9FUlIoY2RldiwgIkVy
cm9yICVkIGNvbmZpZ3VyaW5nICVkXG4iLCByYywNCj4gPiBjZmdfaWQpOw0KPiA+ICsJCQlicmVh
azsNCj4gPiArCQl9DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJcWVkX3B0dF9yZWxlYXNlKGh3Zm4s
IHB0dCk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHJjOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0
aWMgaW50IHFlZF9udm1fZmxhc2goc3RydWN0IHFlZF9kZXYgKmNkZXYsIGNvbnN0IGNoYXIgKm5h
bWUpDQo+ID4gIHsNCj4gPiAgCWNvbnN0IHN0cnVjdCBmaXJtd2FyZSAqaW1hZ2U7DQo+ID4gQEAg
LTIyNjgsNiArMjMzMCw5IEBAIHN0YXRpYyBpbnQgcWVkX252bV9mbGFzaChzdHJ1Y3QgcWVkX2Rl
diAqY2RldiwNCj4gPiBjb25zdCBjaGFyICpuYW1lKQ0KPiA+ICAJCQlyYyA9IHFlZF9udm1fZmxh
c2hfaW1hZ2VfYWNjZXNzKGNkZXYsICZkYXRhLA0KPiA+ICAJCQkJCQkJJmNoZWNrX3Jlc3ApOw0K
PiA+ICAJCQlicmVhazsNCj4gPiArCQljYXNlIFFFRF9OVk1fRkxBU0hfQ01EX05WTV9DRkdfSUQ6
DQo+ID4gKwkJCXJjID0gcWVkX252bV9mbGFzaF9jZmdfd3JpdGUoY2RldiwgJmRhdGEpOw0KPiA+
ICsJCQlicmVhazsNCj4gPiAgCQlkZWZhdWx0Og0KPiA+ICAJCQlEUF9FUlIoY2RldiwgIlVua25v
d24gY29tbWFuZCAlMDh4XG4iLA0KPiA+IGNtZF90eXBlKTsNCj4gPiAgCQkJcmMgPSAtRUlOVkFM
Ow0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3FlZC9xZWRfaWYuaCBiL2luY2x1ZGUv
bGludXgvcWVkL3FlZF9pZi5oDQo+ID4gaW5kZXggZWVmMDJlNi4uMjM4MDVlYSAxMDA2NDQNCj4g
PiAtLS0gYS9pbmNsdWRlL2xpbnV4L3FlZC9xZWRfaWYuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGlu
dXgvcWVkL3FlZF9pZi5oDQo+ID4gQEAgLTgwNCw2ICs4MDQsNyBAQCBlbnVtIHFlZF9udm1fZmxh
c2hfY21kIHsNCj4gPiAgCVFFRF9OVk1fRkxBU0hfQ01EX0ZJTEVfREFUQSA9IDB4MiwNCj4gPiAg
CVFFRF9OVk1fRkxBU0hfQ01EX0ZJTEVfU1RBUlQgPSAweDMsDQo+ID4gIAlRRURfTlZNX0ZMQVNI
X0NNRF9OVk1fQ0hBTkdFID0gMHg0LA0KPiA+ICsJUUVEX05WTV9GTEFTSF9DTURfTlZNX0NGR19J
RCA9IDB4NSwNCj4gPiAgCVFFRF9OVk1fRkxBU0hfQ01EX05WTV9NQVgsDQo+ID4gIH07DQo+ID4N
Cg==
