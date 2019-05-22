Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C9726A20
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfEVSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:50:08 -0400
Received: from us-smtp-delivery-213.mimecast.com ([216.205.24.213]:53514 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729057AbfEVSuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558551004;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:autocrypt;
        bh=YgMdNyuM4gH7PILBizVtUU41ZR5v1hR/uz1/F6AsnOY=;
        b=ePiXLc/F6hvmk1v7ZJlcAIJe0qEZR6MrN8OoPhaGq6CfVga4pEGoQEBpf+p7rIJ4QhvTBt
        Dw3roa9AHGIoTg8ocV6nQFIORHD+dgJoFKmJM/s66bye05hT0UKPyg98vCSsdFc6qWrmPm
        sSmV1OoiYmg5KKBMeMXzE1qOy7XpzW8=
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-0hylx3ZkMMOI9Laqb9vXVA-4; Wed, 22 May 2019 14:43:34 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3787.namprd06.prod.outlook.com (10.167.236.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 18:43:29 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 18:43:29 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     Trent Piepho <tpiepho@impinj.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 6/8] net: phy: dp83867: IO impedance is not
 dependent on RGMII delay
Thread-Topic: [PATCH net-next v2 6/8] net: phy: dp83867: IO impedance is not
 dependent on RGMII delay
Thread-Index: AQHVEM49JArBAXOFuke+cvvyCAFHXA==
Date:   Wed, 22 May 2019 18:43:25 +0000
Message-ID: <20190522184255.16323-6-tpiepho@impinj.com>
References: <20190522184255.16323-1-tpiepho@impinj.com>
In-Reply-To: <20190522184255.16323-1-tpiepho@impinj.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To MWHPR0601MB3708.namprd06.prod.outlook.com
 (2603:10b6:301:7c::38)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9480a34-5383-4dc4-5890-08d6dee55fa2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3787;
x-ms-traffictypediagnostic: MWHPR0601MB3787:
x-microsoft-antispam-prvs: <MWHPR0601MB37871B1EE732F1FC43BD503FD3000@MWHPR0601MB3787.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39850400004)(136003)(199004)(189003)(26005)(25786009)(66066001)(52116002)(446003)(11346002)(476003)(2616005)(486006)(110136005)(54906003)(99286004)(76176011)(186003)(86362001)(256004)(6666004)(6436002)(71190400001)(71200400001)(316002)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(3846002)(6116002)(2906002)(68736007)(81166006)(81156014)(7736002)(386003)(6506007)(305945005)(8676002)(8936002)(50226002)(102836004)(2501003)(36756003)(478600001)(53936002)(4326008)(5660300002)(14454004)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3787;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9NsBInt6jEegMsErYqM7H5pJGsJGHklLlKpA7Jtz227RFwBKOEkz+xCigzZ/Mx3SHrslObL/uH6pYYVfj23SFG+6sYSwttYlBGh+VyCGwm/PR5BxPfaNBeqkK3nkHheicYRGs0nzsM1TytxJdwgPx0Zq9xvI1kjuok2+BXtdomnXDjnCmAdjEsTZk6slcr4tGYJdljkRELkGctjTFhvyV4N+g0saCb876qR7RUuIW2CfPsdmfv2KyVfR+RyH4nb+0Ubaj4Bqm9JSiyK9ljcUHW3e9+GOw8dqU2o9AyWZSq8bzM0YUbY2GaCMqb9HvFudQPL4cXQZUqFYFcqvVqiQelvXBemv5dd733ybwtv+nMBDEMlnPGKcH818IjsRyvlN52k8i5N85LDuxwuylplsX6ZZPK+GA7gln1oCknzJSWw=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9480a34-5383-4dc4-5890-08d6dee55fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:25.5554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3787
X-MC-Unique: 0hylx3ZkMMOI9Laqb9vXVA-4
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGRyaXZlciB3b3VsZCBvbmx5IHNldCB0aGUgSU8gaW1wZWRhbmNlIHZhbHVlIHdoZW4gUkdN
SUkgaW50ZXJuYWwKZGVsYXlzIHdlcmUgZW5hYmxlZC4gIFRoZXJlIGlzIG5vIHJlYXNvbiBmb3Ig
dGhpcy4gIE1vdmUgdGhlIElPCmltcGVkYW5jZSBibG9jayBvdXQgb2YgdGhlIFJHTUlJIGRlbGF5
IGJsb2NrLgoKQ2M6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4KQ2M6IEZsb3JpYW4gRmFp
bmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPgpDYzogSGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdl
aXQxQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogVHJlbnQgUGllcGhvIDx0cGllcGhvQGltcGlu
ai5jb20+Ci0tLQoKTm90ZXM6CiAgICBDaGFuZ2VzIGZyb20gdjE6CiAgICAgIFBhdGNoIGFkZGVk
IGluIHYyLgoKIGRyaXZlcnMvbmV0L3BoeS9kcDgzODY3LmMgfCAxOSArKysrKysrKystLS0tLS0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jIGIvZHJpdmVycy9uZXQvcGh5L2Rw
ODM4NjcuYwppbmRleCA1OTA1MWIwZjViZTkuLjVlY2UxNTNhYTljMyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZXQvcGh5L2RwODM4NjcuYworKysgYi9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jCkBA
IC03NSw4ICs3NSw3IEBACiAjZGVmaW5lIERQODM4NjdfUkdNSUlfUlhfQ0xLX0RFTEFZX1NISUZU
CTAKIAogLyogSU9fTVVYX0NGRyBiaXRzICovCi0jZGVmaW5lIERQODM4NjdfSU9fTVVYX0NGR19J
T19JTVBFREFOQ0VfQ1RSTAkweDFmCi0KKyNkZWZpbmUgRFA4Mzg2N19JT19NVVhfQ0ZHX0lPX0lN
UEVEQU5DRV9NQVNLCTB4MWYKICNkZWZpbmUgRFA4Mzg2N19JT19NVVhfQ0ZHX0lPX0lNUEVEQU5D
RV9NQVgJMHgwCiAjZGVmaW5lIERQODM4NjdfSU9fTVVYX0NGR19JT19JTVBFREFOQ0VfTUlOCTB4
MWYKICNkZWZpbmUgRFA4Mzg2N19JT19NVVhfQ0ZHX0NMS19PX0RJU0FCTEUJQklUKDYpCkBAIC0x
NjIsOCArMTYxLDYgQEAgc3RhdGljIGludCBkcDgzODY3X29mX2luaXQoc3RydWN0IHBoeV9kZXZp
Y2UgKnBoeWRldikKIAlpZiAoIW9mX25vZGUpCiAJCXJldHVybiAtRU5PREVWOwogCi0JZHA4Mzg2
Ny0+aW9faW1wZWRhbmNlID0gLUVJTlZBTDsKLQogCS8qIE9wdGlvbmFsIGNvbmZpZ3VyYXRpb24g
Ki8KIAlyZXQgPSBvZl9wcm9wZXJ0eV9yZWFkX3UzMihvZl9ub2RlLCAidGksY2xrLW91dHB1dC1z
ZWwiLAogCQkJCSAgICZkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCk7CkBAIC0xODUsNiArMTgyLDgg
QEAgc3RhdGljIGludCBkcDgzODY3X29mX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikK
IAkJZHA4Mzg2Ny0+aW9faW1wZWRhbmNlID0gRFA4Mzg2N19JT19NVVhfQ0ZHX0lPX0lNUEVEQU5D
RV9NQVg7CiAJZWxzZSBpZiAob2ZfcHJvcGVydHlfcmVhZF9ib29sKG9mX25vZGUsICJ0aSxtaW4t
b3V0cHV0LWltcGVkYW5jZSIpKQogCQlkcDgzODY3LT5pb19pbXBlZGFuY2UgPSBEUDgzODY3X0lP
X01VWF9DRkdfSU9fSU1QRURBTkNFX01JTjsKKwllbHNlCisJCWRwODM4NjctPmlvX2ltcGVkYW5j
ZSA9IC0xOyAvKiBsZWF2ZSBhdCBkZWZhdWx0ICovCiAKIAlkcDgzODY3LT5yeGN0cmxfc3RyYXBf
cXVpcmsgPSBvZl9wcm9wZXJ0eV9yZWFkX2Jvb2wob2Zfbm9kZSwKIAkJCQkJInRpLGRwODM4Njct
cnhjdHJsLXN0cmFwLXF1aXJrIik7CkBAIC0zMzMsMTQgKzMzMiwxNCBAQCBzdGF0aWMgaW50IGRw
ODM4NjdfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikKIAogCQlwaHlfd3Jp
dGVfbW1kKHBoeWRldiwgRFA4Mzg2N19ERVZBRERSLCBEUDgzODY3X1JHTUlJRENUTCwKIAkJCSAg
ICAgIGRlbGF5KTsKLQotCQlpZiAoZHA4Mzg2Ny0+aW9faW1wZWRhbmNlID49IDApCi0JCQlwaHlf
bW9kaWZ5X21tZChwaHlkZXYsIERQODM4NjdfREVWQUREUiwgRFA4Mzg2N19JT19NVVhfQ0ZHLAot
CQkJCSAgICAgICBEUDgzODY3X0lPX01VWF9DRkdfSU9fSU1QRURBTkNFX0NUUkwsCi0JCQkJICAg
ICAgIGRwODM4NjctPmlvX2ltcGVkYW5jZSAmCi0JCQkJICAgICAgIERQODM4NjdfSU9fTVVYX0NG
R19JT19JTVBFREFOQ0VfQ1RSTCk7CiAJfQogCisJLyogSWYgc3BlY2lmaWVkLCBzZXQgaW8gaW1w
ZWRhbmNlICovCisJaWYgKGRwODM4NjctPmlvX2ltcGVkYW5jZSA+PSAwKQorCQlwaHlfbW9kaWZ5
X21tZChwaHlkZXYsIERQODM4NjdfREVWQUREUiwgRFA4Mzg2N19JT19NVVhfQ0ZHLAorCQkJICAg
ICAgIERQODM4NjdfSU9fTVVYX0NGR19JT19JTVBFREFOQ0VfTUFTSywKKwkJCSAgICAgICBkcDgz
ODY3LT5pb19pbXBlZGFuY2UpOworCiAJLyogRW5hYmxlIEludGVycnVwdCBvdXRwdXQgSU5UX09F
IGluIENGRzMgcmVnaXN0ZXIgKi8KIAlpZiAocGh5X2ludGVycnVwdF9pc192YWxpZChwaHlkZXYp
KSB7CiAJCXZhbCA9IHBoeV9yZWFkKHBoeWRldiwgRFA4Mzg2N19DRkczKTsKLS0gCjIuMTQuNQoK

