Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E4DA9AB3
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 08:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbfIEGdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 02:33:07 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:60822 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731393AbfIEGdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 02:33:07 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x856WIMS012294;
        Thu, 5 Sep 2019 02:32:58 -0400
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2054.outbound.protection.outlook.com [104.47.50.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uqnh5hr4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 02:32:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoFCxhachD0QoTTd9q6CkSK7iRQWAxvQpHKKO6CrXl1VeLUozN70cxZQHUZplqAX2Do+/xHXzo2ZdzEuqdAvMpSJMkJ29lmX3pjgKfgd06Yzjlq2M1U/9l+Sfns6l862bgebFp6vR2G/WoYashX2Pt8dQoeWrgDug0ZAMgpw9BDQNUJKLE4IB5ijgmR9+3FLzuLFEQmYeFBsf87Uq0MdxPnJgDyk99qB/4Ncv/VYTqzJ1N9/jkjSdYf0SABeU/y950p0tSHUKeqdAdxjvPp7bRhBs91pA1CTH0Bw804DBhjfBfjocVo0oubwpj7mSiRBEar/YULx0P6RSvXJAxdfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jI+2GsDfuE3xCGsw67lj2swvKYiZXLSaoOGFy5l/kY=;
 b=UUrLQuPbxPcCN1zABZcR6GQLp5fCVQ2n/GzugYgGM0i+YwcG1oqH4fvxv31tDuEshiYutgbcHE32x+4A6UA6iD/N6QdMZ0K9pwU7TIFyqPMewo4DZfoXQT/icwrDc4PT3J/RoBzHvmPRHl+8Ua+fVsUNO6zQRHCCbsf5N6+ZHe3USCyurHjxwkL4YFCF0jlXhWU6nAML8o2n+86aludVRnZp14K5S7J/3i/JMDiegp+MxgKXR+AWJbJYsG+WbYUZsAH8H5PvbpVtexR4sj7mfwAzQwPtx4CbPglWTDNV4Om8WOAQvepE4tOPKKAyv/CQ86yA74CwwKLn8ifdOcd8uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jI+2GsDfuE3xCGsw67lj2swvKYiZXLSaoOGFy5l/kY=;
 b=wrsfK0uBJ70CDbn5hciC2G702nQ6p4E47IoVUR7pE3xWwqCp4Z5z5k+TcUvZfKQFhHVAiZP3Pp6l5eIQUC79JSi9Kg/XSxnTsWNgv+O3t1pB+3fjOO4c0SaTdTEyY8ZdiagwBuTq6NmSvXD3fw51x46GNBaPW55ESZ4v4SL62mk=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5176.namprd03.prod.outlook.com (20.180.14.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Thu, 5 Sep 2019 06:32:57 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::ad16:8446:873b:4042]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::ad16:8446:873b:4042%3]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 06:32:57 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Thread-Topic: [PATCH v2 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Thread-Index: AQHVYyQE++iIz555akeWnGeI6+1Uuqcb8XQAgADiDIA=
Date:   Thu, 5 Sep 2019 06:32:57 +0000
Message-ID: <e1739eb3d43ebf854e9eb5c829ffbf59f9dca85c.camel@analog.com>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
         <20190904162322.17542-3-alexandru.ardelean@analog.com>
         <20190904200350.GB21264@lunn.ch>
In-Reply-To: <20190904200350.GB21264@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3df6d8c9-25cb-4366-7341-08d731cae3da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5176;
x-ms-traffictypediagnostic: CH2PR03MB5176:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <CH2PR03MB51760004E451EC5A9D4F7F0AF9BB0@CH2PR03MB5176.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(91956017)(6436002)(66446008)(66556008)(66476007)(53936002)(99286004)(25786009)(6512007)(66946007)(76116006)(64756008)(5640700003)(6306002)(6246003)(2351001)(86362001)(4326008)(3846002)(6486002)(2906002)(36756003)(6116002)(186003)(71190400001)(71200400001)(8676002)(26005)(2501003)(966005)(81166006)(81156014)(76176011)(8936002)(229853002)(305945005)(6506007)(102836004)(6916009)(1730700003)(11346002)(446003)(486006)(476003)(2616005)(66066001)(14454004)(14444005)(5660300002)(54906003)(118296001)(256004)(478600001)(7736002)(316002)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5176;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZKAeHyti6q7+r7xg1zmVEGAL3+kvm3+yslcWrhX75uzEcvWmh2TclGRzIT7bHqRlJjBuY3rjifkei5xTqT43BbOrE21j9/YDI58UsEAupnP5BlLVWlB43KL4CIoOMdImEjcTIK/q/mRQzyddkPIqgCHgbk58JxaY0RbltZxN+hcDW1BR3iZLEePbHj6JhDRF+ZAf5yIiS8sSMbnHHD+I8F9xEj543gg3aRHmRqUFaNg6vyye39f/8lNUazjVeqCiJRDSyldbVElce6hy4iDXwkxxnNMsIfT0COCV2FLM22BvVasVaeSE04znCF9EAAUCD5EXKSnZ6aIrq/3+TLgTZlE4/Km3fSOKww7iEIsYIrKE2uqG4fgJuOabOFIuTBDQ0kz2umu0+lmfdOo3mcYq3udytoAl5WFBb0AXOceN3mQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1245B549EC8A45469671C2EA05B6702A@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df6d8c9-25cb-4366-7341-08d731cae3da
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 06:32:57.0972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8SerwV1Sg8GkBtAlJBnZ5IRulOEANmiEZdXzyAJLSWUn/jSJThOOhdIDFqtNAsxZtxD8MliVrdHjGUxxVOaVkwZgjkDebYkwGEv6FA5Bs0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5176
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_02:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909050067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA5LTA0IGF0IDIyOjAzICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gV2VkLCBTZXAgMDQsIDIwMTkgYXQgMDc6MjM6MjJQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoaXMgZHJpdmVyIGJlY29tZXMgdGhl
IGZpcnN0IHVzZXIgb2YgdGhlIGtlcm5lbCdzIGBFVEhUT09MX1BIWV9FRFBEYA0KPiA+IHBoeS10
dW5hYmxlIGZlYXR1cmUuDQo+ID4gRURQRCBpcyBhbHNvIGVuYWJsZWQgYnkgZGVmYXVsdCBvbiBQ
SFkgY29uZmlnX2luaXQsIGJ1dCBjYW4gYmUgZGlzYWJsZWQgdmlhDQo+ID4gdGhlIHBoeS10dW5h
YmxlIGNvbnRyb2wuDQo+ID4gDQo+ID4gV2hlbiBlbmFibGluZyBFRFBELCBpdCdzIGFsc28gYSBn
b29kIGlkZWEgKGZvciB0aGUgQURJTiBQSFlzKSB0byBlbmFibGUgVFgNCj4gPiBwZXJpb2RpYyBw
dWxzZXMsIHNvIHRoYXQgaW4gY2FzZSB0aGUgb3RoZXIgUEhZIGlzIGFsc28gb24gRURQRCBtb2Rl
LCB0aGVyZQ0KPiA+IGlzIG5vIGxvY2stdXAgc2l0dWF0aW9uIHdoZXJlIGJvdGggc2lkZXMgYXJl
IHdhaXRpbmcgZm9yIHRoZSBvdGhlciB0bw0KPiA+IHRyYW5zbWl0Lg0KPiA+IA0KPiA+IFZpYSB0
aGUgcGh5LXR1bmFibGUgY29udHJvbCwgVFggcHVsc2VzIGNhbiBiZSBkaXNhYmxlZCBpZiBzcGVj
aWZ5aW5nIDANCj4gPiBgdHgtaW50ZXJ2YWxgIHZpYSBldGh0b29sLg0KPiA+IA0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9hZGluLmMgfCA1MCArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDUw
IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2Fk
aW4uYyBiL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMNCj4gPiBpbmRleCA0ZGVjODNkZjA0OGQuLjc0
MjcyOGFiMmE1ZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9waHkvYWRpbi5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+IEBAIC0yNiw2ICsyNiwxMSBAQA0KPiA+
ICANCj4gPiAgI2RlZmluZSBBRElOMTMwMF9SWF9FUlJfQ05UCQkJMHgwMDE0DQo+ID4gIA0KPiA+
ICsjZGVmaW5lIEFESU4xMzAwX1BIWV9DVFJMX1NUQVRVUzIJCTB4MDAxNQ0KPiA+ICsjZGVmaW5l
ICAgQURJTjEzMDBfTlJHX1BEX0VOCQkJQklUKDMpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMwMF9O
UkdfUERfVFhfRU4JCQlCSVQoMikNCj4gPiArI2RlZmluZSAgIEFESU4xMzAwX05SR19QRF9TVEFU
VVMJCUJJVCgxKQ0KPiA+ICsNCj4gPiAgI2RlZmluZSBBRElOMTMwMF9QSFlfQ1RSTDIJCQkweDAw
MTYNCj4gPiAgI2RlZmluZSAgIEFESU4xMzAwX0RPV05TUEVFRF9BTl8xMDBfRU4JCUJJVCgxMSkN
Cj4gPiAgI2RlZmluZSAgIEFESU4xMzAwX0RPV05TUEVFRF9BTl8xMF9FTgkJQklUKDEwKQ0KPiA+
IEBAIC0zMjgsMTIgKzMzMyw1MSBAQCBzdGF0aWMgaW50IGFkaW5fc2V0X2Rvd25zaGlmdChzdHJ1
Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCB1OCBjbnQpDQo+ID4gIAkJCSAgICBBRElOMTMwMF9ET1dO
U1BFRURTX0VOKTsNCj4gPiAgfQ0KPiA+ICANCj4gPiArc3RhdGljIGludCBhZGluX2dldF9lZHBk
KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIHUxNiAqdHhfaW50ZXJ2YWwpDQo+ID4gK3sNCj4g
PiArCWludCB2YWw7DQo+ID4gKw0KPiA+ICsJdmFsID0gcGh5X3JlYWQocGh5ZGV2LCBBRElOMTMw
MF9QSFlfQ1RSTF9TVEFUVVMyKTsNCj4gPiArCWlmICh2YWwgPCAwKQ0KPiA+ICsJCXJldHVybiB2
YWw7DQo+ID4gKw0KPiA+ICsJaWYgKEFESU4xMzAwX05SR19QRF9FTiAmIHZhbCkgew0KPiA+ICsJ
CWlmICh2YWwgJiBBRElOMTMwMF9OUkdfUERfVFhfRU4pDQo+ID4gKwkJCSp0eF9pbnRlcnZhbCA9
IDE7DQo+IA0KPiBXaGF0IGRvZXMgMSBtZWFuPyAxIHBpY28gc2Vjb25kLCBvbmUgaG91cj8gQW55
dGhpbmcgYnV0IHplcm8gc2Vjb25kcz8NCj4gRG9lcyB0aGUgZGF0YXNoZWV0IHNwZWNpZnkgd2hh
dCBpdCBhY3R1YWxseSBkb2VzPyBNYXliZSB5b3Ugc2hvdWxkIGJlDQo+IHVzaW5nIEVUSFRPT0xf
UEhZX0VEUERfREZMVF9UWF9JTlRFUlZBTCBoZXJlLCB0byBpbmRpY2F0ZSB5b3UgYWN0dWFsbHkN
Cj4gaGF2ZSBubyBpZGVhLCBidXQgaXQgaXMgdGhlIGRlZmF1bHQgZm9yIHRoaXMgUEhZPw0KDQpU
aGlzIFBIWSBjdXJyZW50bHkgaGFzIGEgMSBzZWNvbmQgVFggaW50ZXJ2YWwuDQpBcyBzcGVjaWZp
ZWQgYnkgdGhlIGRhdGFzaGVldCAocGFnZSAyMiBFbmVyZ3ktRGV0ZWN0IFBvd2VyZG93biBNb2Rl
IHNlY3Rpb24pOg0KaHR0cHM6Ly93d3cuYW5hbG9nLmNvbS9tZWRpYS9lbi90ZWNobmljYWwtZG9j
dW1lbnRhdGlvbi9kYXRhLXNoZWV0cy9BRElOMTMwMC5wZGYNCg0KIlRoZSBQSFkgbW9uaXRvcnMg
dGhlIGxpbmUgZm9yIHNpZ25hbCBlbmVyZ3kgYW5kIHNlbmRzIGEgbGluayBwdWxzZSBvbmNlIGV2
ZXJ5IHNlY29uZCINCg0KQ3VycmVudGx5IHRoZXJlIGlzIG5vIGNvbnRyb2wgZXhwb3NlZCB0byBj
b25maWd1cmUgdGhpcyBpbnRlcnZhbDsgYnV0IHRoZXJlIGNvdWxkIGJlIHNvbWUgcmVnaXN0ZXJz
ICh0aGF0IGFyZSBub3QNCmV4cG9zZWQgeWV0KSB0aGF0IGNvdWxkIGNvbnRyb2wgdGhpcy4NCg0K
TWljcmVsJ3MgZGF0YXNoZWV0IG1lbnRpb25zIChwYWdlIDI3IDMuMTYuMUVORVJHWS1ERVRFQ1Qg
UE9XRVItRE9XTiBNT0RFIHNlY3Rpb24pOg0KaHR0cDovL3d3MS5taWNyb2NoaXAuY29tL2Rvd25s
b2Fkcy9lbi9kZXZpY2Vkb2MvMDAwMDIxMTdmLnBkZg0KDQoiSW4gRURQRCBNb2RlLCB0aGUgS1Na
OTAzMVJOWCBzaHV0cyBkb3duIGFsbCB0cmFuc2NlaXZlciBibG9ja3MsIGV4Y2VwdCBmb3IgdGhl
IHRyYW5zbWl0dGVyIGFuZCBlbmVyZ3kgZGV0ZWN0IGNpci1jdWl0cy4gDQpQb3dlciBjYW4gYmUg
cmVkdWNlZCBmdXJ0aGVyIGJ5IGV4dGVuZGluZyB0aGUgdGltZSBpbnRlcnZhbCBiZXR3ZWVuIHRo
ZSB0cmFuc21pc3Npb25zIG9mIGxpbmsgcHVsc2VzIHRvIGNoZWNrIGZvcnRoZQ0KcHJlc2VuY2Ug
b2YgYSBsaW5rIHBhcnRuZXIuIg0KDQpJIGRpZCBub3QgY2hlY2sgZm9yIE1pY3JlbCB0byBzZWUg
aG93IHRoYXQgaW50ZXJ2YWwgaXMgY29udHJvbGxlZC4NCg0KVGhlIHJlYXNvbiBmb3IgZG9pbmcg
dGhpcyBUWCBpbnRlcnZhbCBjb250cm9sIHdhcyBtb3N0bHkgYmFzZWQgb24gdGhpcyBtZW50aW9u
IGZyb20gTWljcmVsJ3MgZGF0YXNoZWV0LCB3aXRoDQpjb25zaWRlcmF0aW9uIHRoYXQgaXQgY291
bGQgd29yayBBRElOICYgb3RoZXIgZnV0dXJlIFBIWXMuDQoNCj4gDQo+ID4gKwkJZWxzZQ0KPiA+
ICsJCQkqdHhfaW50ZXJ2YWwgPSBFVEhUT09MX1BIWV9FRFBEX05PX1RYOw0KPiA+ICsJfSBlbHNl
IHsNCj4gPiArCQkqdHhfaW50ZXJ2YWwgPSBFVEhUT09MX1BIWV9FRFBEX0RJU0FCTEU7DQo+ID4g
Kwl9DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBp
bnQgYWRpbl9zZXRfZWRwZChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCB1MTYgdHhfaW50ZXJ2
YWwpDQo+ID4gK3sNCj4gPiArCXUxNiB2YWw7DQo+ID4gKw0KPiA+ICsJaWYgKHR4X2ludGVydmFs
ID09IEVUSFRPT0xfUEhZX0VEUERfRElTQUJMRSkNCj4gPiArCQlyZXR1cm4gcGh5X2NsZWFyX2Jp
dHMocGh5ZGV2LCBBRElOMTMwMF9QSFlfQ1RSTF9TVEFUVVMyLA0KPiA+ICsJCQkJKEFESU4xMzAw
X05SR19QRF9FTiB8IEFESU4xMzAwX05SR19QRF9UWF9FTikpOw0KPiA+ICsNCj4gPiArCXZhbCA9
IEFESU4xMzAwX05SR19QRF9FTjsNCj4gPiArCWlmICh0eF9pbnRlcnZhbCAhPSBFVEhUT09MX1BI
WV9FRFBEX05PX1RYKQ0KPiA+ICsJCXZhbCB8PSBBRElOMTMwMF9OUkdfUERfVFhfRU47DQo+IA0K
PiBTbyB5b3Ugc2lsZW50bHkgYWNjZXB0IGFueSBpbnRlcnZhbD8gVGhhdCBzb3VuZHMgd3Jvbmcu
IFlvdSByZWFsbHkNCj4gc2hvdWxkIGJlIHJldHVybmluZyAtRUlOVkFMIGZvciBhbnkgdmFsdWUg
b3RoZXIgdGhhbiwgZWl0aGVyIDEsIG9yDQo+IG1heWJlIEVUSFRPT0xfUEhZX0VEUERfREZMVF9U
WF9JTlRFUlZBTCwgaWYgeW91IGNoYW5nZSB0aGUgZ2V0DQo+IGZ1bmN0aW9uLg0KDQphY2s7DQp3
aWxsIHVzZSBFVEhUT09MX1BIWV9FRFBEX0RGTFRfVFhfSU5URVJWQUwsIEVUSFRPT0xfUEhZX0VE
UERfTk9fVFggJiYgMSBhcyBhY2NlcHRhYmxlIHZhbHVlcyBoZXJlDQoNCj4gDQo+ICAgICAgIEFu
ZHJldw0K
