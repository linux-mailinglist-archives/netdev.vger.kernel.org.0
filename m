Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCEED71C2
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfJOJCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 05:02:44 -0400
Received: from mail-eopbgr720075.outbound.protection.outlook.com ([40.107.72.75]:4000
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727964AbfJOJCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 05:02:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNHKy1eYpO/0GRtkOTb4m96EFrBN16QdRNMPE4XmKa/LEEr24KQtirwjJyp4pHnlkYcCvDrp/2TLViPpE2MpE3oyfOmxfHgqhwLRGLMX7Vfx1sPbzAAIkpD+08CEmvDtktDcN5BIH3wpq6vUUzXJF7Uh4vw/BMKUTKLdoxeksGRzSJxmQP41ElcovohMhSNw6Clo1QcX2eLWWLoJaYETOm7Uj0xP3GFTrPGMf7omvwG9c0A6C0PFR4H9zI+fXmmxPpUnLEA64xET42DFJI1YqdI6gUtkNRYFQ97Zf4WsVa6kO06k/Khx/zoVhrtkSYSFi+HCGOoY5WoMbnhDvU5Ntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HE5YmrU2LByAXntzgiaWC+kDWM8QZvYaRMFpXR0JS7k=;
 b=K5ZxdTsTYX0cNQ2S06Jlt7KukENVpVSURZIfkos5W08owt3H3CC261c3z4WDbwJYYxbXkyaPT+w1d6SpdrDXplODuU2oimD+7clL9qVJIS99+tnTJmw7C8ZDc/4Bv/C+LnWEtzyVg50g7DwjhWiPi+JG/xsJM3+eyuIAEIUqVMTAW9bDAfqs0VsgnbnsHTSoGAuwdQivZ9nBFKsvV5ejhf7Cruf1BW0+t5QvqDIY3b7ia8aBEEVxPywkHWTaG41r81EW3gUJlNAjn/bM7PkEeXpJ4BIDvrobv1gGn3dA0+IQ24sGDnqTNCE6rzRf0kbPOBY5L7Kgm6PhRMbrXrvWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HE5YmrU2LByAXntzgiaWC+kDWM8QZvYaRMFpXR0JS7k=;
 b=xccuzrHpT0nW3Dc9YykGylR2YrDsJn6ufe52aGjAdv2CvP79pO9un3A43utccWxu9ZQUEMzlPj2nevWSJi0HsqLaopwqW9YHh+L/M978EoYO7WOtq1ptYJlyH6tngiLgRO2NIE/BPKgr/cKTIpHMG8V//ZkGIIKk4xVY8+93xts=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3665.namprd11.prod.outlook.com (20.178.222.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Tue, 15 Oct 2019 09:02:38 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 09:02:38 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 04/12] net: aquantia: add PTP rings
 infrastructure
Thread-Topic: [PATCH v2 net-next 04/12] net: aquantia: add PTP rings
 infrastructure
Thread-Index: AQHVfccRlNH8qRKne0q5x9XkZMSroKdaWXWAgAEZiwA=
Date:   Tue, 15 Oct 2019 09:02:38 +0000
Message-ID: <14148d19-5869-f510-2a08-e3d69ad25575@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <eea16e6e4fe987819dca72304b92b8b921c65286.1570531332.git.igor.russkikh@aquantia.com>
 <20191014161451.GM21165@lunn.ch>
In-Reply-To: <20191014161451.GM21165@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0224.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::20) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f94f5c8-9c55-4183-9b4d-08d7514e6d4f
x-ms-traffictypediagnostic: BN8PR11MB3665:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB36659F4130D60E678969910F98930@BN8PR11MB3665.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(346002)(39850400004)(199004)(189003)(229853002)(66066001)(476003)(44832011)(5660300002)(186003)(11346002)(6916009)(26005)(36756003)(31696002)(446003)(486006)(508600001)(54906003)(316002)(2906002)(386003)(2616005)(6506007)(102836004)(71190400001)(86362001)(6512007)(107886003)(66556008)(6116002)(256004)(3846002)(66476007)(71200400001)(6246003)(31686004)(6486002)(66946007)(76176011)(99286004)(64756008)(66446008)(6436002)(14444005)(81156014)(81166006)(8936002)(8676002)(25786009)(14454004)(4326008)(305945005)(7736002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3665;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7z0zs1JVB4qbzsVdLo81rNRSIjMzhyOYV3NzMoQBT5ow8xOfDHMmGjeHpP57HvnfwMlakfzR1rRQBsagDdMCjBaVjm3muUWpUiBvj+zQNeuR2W/WZHV5QoGvR0GNXO+nqbwDdFgayIcc9CzdDrG5KCzWuSj8yB3OeIbBajY5PZ5xAeGGoBXSS/Ewx24dEEEW8FYp0TpZNO8PRNXaUMFqDOKOSA6Zu/svwZ2GoafIuDgEblD6aktJx4leGQhraNt6c11eOxCzLqEUqeUXC49rWcSK7JdTRpqJUwdxTWdhLrHm+8p3kF2/ZfBOYV2+6G0i8ENAeehyYuWsmANOw8RJEplmb3VPZkR7sMUdq0CE46lSyXuP90DSudEf9KAc05/Suo9SIu64VyOJ67UTexqN/ZNcjmlgMsip6HUSjdHOkQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6D5F0DE77756C47BC0527BA4F95AD7C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f94f5c8-9c55-4183-9b4d-08d7514e6d4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 09:02:38.0586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bm6NOA92oWuJn57QychPNjCUHwYVrSyMZXVS3FYBBbf4kM/qCDMIGfo0yhQsC9NHm5r7oJ+lJKaKdZEzB/5MGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3665
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQo+PiAgDQo+PiArCWFxX3B0cF9yaW5nX2RlaW5pdChzZWxmKTsNCj4+ICAJ
YXFfcHRwX3VucmVnaXN0ZXIoc2VsZik7DQo+PiArCWFxX3B0cF9yaW5nX2ZyZWUoc2VsZik7DQo+
PiAgCWFxX3B0cF9mcmVlKHNlbGYpOw0KPiANCj4gSXMgdGhpcyBvcmRlciBzYWZlPyBTZWVtcyBs
aWtlIHlvdSBzaG91bGQgZmlyc3QgdW5yZWdpc3RlciwgYW5kIHRoZW4NCj4gZGVpbml0Pw0KDQpX
aWxsIGRvdWJsZSBjaGVjaywgcHJvYmFibHkgeW91IGFyZSByaWdodC4NCg0KDQo+PiArCWVyciA9
IGFxX3JpbmdfaW5pdCgmYXFfcHRwLT5od3RzX3J4KTsNCj4+ICsJaWYgKGVyciA8IDApDQo+PiAr
CQlnb3RvIGVycl9leGl0Ow0KPj4gKwllcnIgPSBhcV9uaWMtPmFxX2h3X29wcy0+aHdfcmluZ19y
eF9pbml0KGFxX25pYy0+YXFfaHcsDQo+PiArCQkJCQkJICZhcV9wdHAtPmh3dHNfcngsDQo+PiAr
CQkJCQkJICZhcV9wdHAtPnB0cF9yaW5nX3BhcmFtKTsNCj4+ICsNCj4+ICtlcnJfZXhpdDoNCj4+
ICsJcmV0dXJuIGVycjsNCj4gDQo+IE1heWJlIHRoZXJlIHNob3VsZCBiZSBzb21lIHVuZG9pbmcg
Z29pbmcgb24gaGVyZS4gSWYgeW91IGZpbGxlZCB0aGUgcngNCj4gcmluZywgZG8geW91IG5lZWQg
dG8gZW1wdHkgaXQgb24gZXJyb3I/DQoNClJpZ2h0LCBwdHBfcnggc2hvdWxkIGJlIGNsZWFuZWQg
aGVyZS4NCg0KDQo+PiArCWVyciA9IGFxX25pYy0+YXFfaHdfb3BzLT5od19yaW5nX3J4X3N0YXJ0
KGFxX25pYy0+YXFfaHcsDQo+PiArCQkJCQkJICAmYXFfcHRwLT5od3RzX3J4KTsNCj4+ICsJaWYg
KGVyciA8IDApDQo+PiArCQlnb3RvIGVycl9leGl0Ow0KPj4gKw0KPj4gK2Vycl9leGl0Og0KPiAN
Cj4gRG8geW91IG5lZWQgdG8gc3RvcCB0aGUgcmluZ3Mgd2hpY2ggc3RhcnRlZCwgYmVmb3JlIHRo
ZSBlcnJvcg0KPiBoYXBwZW5lZD8NCg0KVGhlIGZhaWx1cmVzIHRoZXJlIGFyZSBvbmx5IHRoZW9y
ZXRpY2FsICh0aGV5IG9ubHkgZG8gY2hlY2sgaWYgdGhlIGRldmljZQ0KaXMgc3RpbGwgb24gUENJ
IGJ1cykuDQoNCmVyciByZXN1bHQgd2lsbCBwcm9wYWdhdGUgYW5kIGNhdXNlIG92ZXJhbGwgTklD
IG9iamVjdCB0byBiZSBmYWlsZWQgb24gb3BlbiwNCmV2ZW50dWFsbHkgYXFfbmljX2RlaW5pdCB3
aWxsIGJlIGNhbGxlZCBhbmQgSFcgd2lsbCBlbmR1cCBpbiBkaXNhYmxlZCBzdGF0ZS4NCg0KVGh1
cywgYmVsaWV2ZSB3ZSBvbmx5IGhhdmUgdG8gY2FyZSBub3QgdG8gbGVhayBtZW1vcnksIGxpa2Ug
aW4gYWJvdmUgcHRwX3J4IGNhc2UuDQoNCg0KPj4gKwltZW1zZXQoc2VsZiwgMCwgc2l6ZW9mKCpz
ZWxmKSk7DQo+PiArDQo+PiArCXNlbGYtPmFxX25pYyA9IGFxX25pYzsNCj4+ICsJc2VsZi0+aWR4
ID0gaWR4Ow0KPj4gKwlzZWxmLT5zaXplID0gc2l6ZTsNCj4+ICsJc2VsZi0+ZHhfc2l6ZSA9IGR4
X3NpemU7DQo+IA0KPiBNb3JlIHNlbGYuIFdoeSBub3QgcmluZz8gSSBzdXBwb3NlIGJlY2F1c2Ug
dGhlIHJlc3Qgb2YgdGhpcyBmaWxlIGlzDQo+IHVzaW5nIHRoZSB1bmhlbHBmdWwgc2VsZj8NCg0K
UmlnaHQuIEkgdGhpbmsgSSdsbCBtYWtlIGEgc2VwYXJhdGUgcGF0Y2hzZXQgdG8gZml4IHRoaXMg
bmFtaW5nLA0KdG8gbm90IHRvIG1peHVwIHRoaW5ncy4NCg0KPj4gK2Vycl9leGl0Og0KPj4gKwlp
ZiAoZXJyIDwgMCkgew0KPj4gKwkJYXFfcmluZ19mcmVlKHNlbGYpOw0KPj4gKwkJcmV0dXJuIE5V
TEw7DQo+IA0KPiByZXR1cm4gRVJSX1BUUihlcnIpPw0KPiANCj4+ICsJfQ0KPj4gKw0KPj4gKwly
ZXR1cm4gc2VsZjsNCj4gDQo+IEFuZCB0aGlzIGNvZGUgc3RydWN0dXJlIHNlZW0gb2RkLiBXaHkg
bm90Lg0KDQpUaGUgb25seSBjYXVzZSBvZiBlcnJvciBvbiB0aGVzZSAqX2FsbG9jKCkgZnVuY3Rp
b25zIGlzIEVOT01FTS4NClNvIHRoaW5rIEknbGwganVzdCBzaW1wbGlmeSB0aGlzLCByZW1vdmUg
YWxsIGBlcnJgIGZpZWxkcyBhbmQgbGVhdmUNCk5VTEwgYXMgYSBmYWlsIGluZGljYXRvci4NCg0K
UmVnYXJkcywNCiAgSWdvcg0K
