Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290F650962
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbfFXLC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:02:58 -0400
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:55493
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727732AbfFXLC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 07:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8yQnCoEphAhsY7tnHn14ZcOVYYFG9VbAbhX0zsn8B8=;
 b=lB/WxBQ+ncbF5h3yfWvY1MN6InmdobcGuxjyDW+oFLCZzRIDVKP7L+BSPVNtQ/JG9juNkM5ONapZgZfyszNu6jNk8Djs6Ki+Y70FyQ+w6Po9XjGQW67vtsGWQhPLRdt9BWztKN2GQhXURimbNU+slzccAOZj20t0B9lFz8R8iV8=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1872.namprd11.prod.outlook.com (10.175.54.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 11:02:55 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 11:02:54 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 1/7] net: aquantia: replace internal driver
 version code with uts
Thread-Topic: [PATCH net-next 1/7] net: aquantia: replace internal driver
 version code with uts
Thread-Index: AQHVKQC320Yt1wWfIE+V6I6UeKytHw==
Date:   Mon, 24 Jun 2019 11:02:54 +0000
Message-ID: <120088f1-c860-a643-c675-fdeed4faf1ef@aquantia.com>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
 <f5f346ff5f727f1ccf0f889e358261a792397210.1561210852.git.igor.russkikh@aquantia.com>
 <20190622150514.GB8497@lunn.ch> <20190623204954.3aa09ded@cakuba>
In-Reply-To: <20190623204954.3aa09ded@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0008.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::18)
 To MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23e16df6-d2d4-4c00-d890-08d6f89381f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1872;
x-ms-traffictypediagnostic: MWHPR11MB1872:
x-microsoft-antispam-prvs: <MWHPR11MB1872A6B5CD2435015424274498E00@MWHPR11MB1872.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39840400004)(366004)(396003)(199004)(189003)(110136005)(66476007)(53936002)(66446008)(64756008)(66556008)(2906002)(6116002)(3846002)(305945005)(6486002)(7736002)(186003)(6436002)(54906003)(316002)(6512007)(102836004)(71190400001)(86362001)(31696002)(229853002)(66066001)(8676002)(446003)(71200400001)(68736007)(4744005)(76176011)(73956011)(476003)(8936002)(6246003)(26005)(81166006)(36756003)(2616005)(66946007)(11346002)(5660300002)(52116002)(72206003)(31686004)(478600001)(44832011)(4326008)(256004)(14454004)(99286004)(486006)(25786009)(81156014)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1872;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PIycvIhIHmsE/fQl1+df1hXNSGuex4lDiLItKvPd9iA4AXZPtQyEEslQIYUosLNhMtIipzXBbDKYpD7Lb28TppfNkWXktHGaVRn9VU/fmvKsE+zZm0EEvlXNnVsC0YbEsG3T12qGRq3gMUt1ssFHqpH59zcADuc3NHDuwqcCQ04OkH1kH/zZ6DwmonaxanecnbHYWIL3zu7KFFKXXRFtwhty2jOr03PRrOOO2YAVk6NYulG/w73vKvuSUQxATguEAnw472Qw22sY1AwaU6nlBaD9O/v/O10tYqIB3TdzDIqUNd6xqvYZZWyM5F+lqjY2S/3cpzztCRoIe3fy/pS8fzn0mXto/9RVUzRIMW7S2YQXWeL1s7uYeiG16SGk8l2Qxdtg1YojEEh0vF8u1c4TrIG2kbZ7zx2ecw/lRyYY0CI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85D59E22E18CC94F8313713C3F414664@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e16df6-d2d4-4c00-d890-08d6f89381f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 11:02:54.6588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IA0KPj4gRGV2bGluayBoYXMganVzdCBnYWluZWQgc29tZXRoaW5nIHNpbWlsYXIgdG8gZXRo
dG9vbCAtaS4gTWF5YmUgd2UNCj4+IHNob3VsZCBnZXQgdGhlIGRldmxpbmsgY29yZSB0byBhbHNv
IHJlcG9ydCB0aGUga2VybmVsIHZlcnNpb24/DQo+IA0KPiBJIGRvbid0IHRoaW5rIHdlIGhhdmUg
dGhlIGRyaXZlciB2ZXJzaW9uIGF0IGFsbCB0aGVyZSwgbXkgdXN1YWwNCj4gaW5jbGluYXRpb24g
YmVpbmcgdG8gbm90IGR1cGxpY2F0ZSBpbmZvcm1hdGlvbiBhY3Jvc3MgQVBJcy4gIERvIHdlIA0K
PiBoYXZlIG5vbi1oeXBvdGhldGljYWwgaW5zdGFuY2VzIG9mIHVzZXJzIHJlcG9ydGluZyBldGh0
b29sIC1pIHdpdGhvdXQNCj4gdW5hbWUgb3V0cHV0PyAgQWRtaXR0ZWRseSBJIG1heSB3b3JrIHdp
dGggYWJvdmUtYXZlcmFnZSBMaW51eC10cmFpbmVkDQo+IGVuZ2luZWVycyA6UyAgV291bGQgaXQg
YmUgb2theSB0byBqdXN0IGdldCBkZXZsaW5rIHVzZXIgc3BhY2UgdG8gdXNlDQo+IHVuYW1lKCkg
dG8gZ2V0IHRoZSBpbmZvPw0KDQpJIHdvcmsgYWxvdCB3aXRoIGZpZWxkIHN1cHBvcnQgZW5naW5l
ZXJpbmcgcGVvcGxlLCB0aGV5IGhhdmUgYSAnTklDLWNlbnRyaWMnDQp2aWV3IG9uIGEgc3lzdGVt
IGFuZCBvZnRlbiBhc3N1bWUgTklDIGRyaXZlciB2ZXJzaW9uIGlzIGFsbCB0aGF0IG1hdHRlcnMu
DQoNClRoZXJlZm9yZSBgZXRodG9vbCAtaWAgaXMgb2Z0ZW4gdGhlIG9ubHkgdGhpbmcgd2UgZ2V0
IHdoZW4gZGVidWdnaW5nIHVzZXIgaXNzdWVzLg0KDQpSZWdhcmRzLA0KICBJZ29yDQo=
