Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E257626A1F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfEVSuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:50:06 -0400
Received: from us-smtp-delivery-213.mimecast.com ([63.128.21.213]:47137 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729672AbfEVSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558551004;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:autocrypt;
        bh=iw+ApwcaXfobS5dN8I0BPVbmlKIKoHvK4WTIBwYUBYk=;
        b=HGa1vsfq6pA0IQRvhLC7oDP2SsSzCbU40rarNbdBWLPUdXtdIoXOXtRLCkNcDH9rzk6kCN
        uC8m2tR5XvpIcxrZD2lSdvjkGV/IX5OHNReSkPES4wmr1dl28NZ6n8aAQQV/9m/V6gMIXH
        MG30pBfHwTmLpfTBe/s7ltUPi/nbg4A=
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-S_iB3su0MwKqTtkPDljgRw-6; Wed, 22 May 2019 14:43:36 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3787.namprd06.prod.outlook.com (10.167.236.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 18:43:30 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 18:43:30 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     Trent Piepho <tpiepho@impinj.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 8/8] net: phy: dp83867: Allocate state struct in
 probe
Thread-Topic: [PATCH net-next v2 8/8] net: phy: dp83867: Allocate state struct
 in probe
Thread-Index: AQHVEM4+nQR7WXAhP0KbHYCkImhLuw==
Date:   Wed, 22 May 2019 18:43:27 +0000
Message-ID: <20190522184255.16323-8-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: 7a2b0b9e-a378-49b3-a829-08d6dee5608d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3787;
x-ms-traffictypediagnostic: MWHPR0601MB3787:
x-microsoft-antispam-prvs: <MWHPR0601MB37871B589CB70CB3134BCC5CD3000@MWHPR0601MB3787.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39850400004)(136003)(199004)(189003)(26005)(25786009)(66066001)(52116002)(446003)(11346002)(476003)(2616005)(486006)(110136005)(54906003)(99286004)(76176011)(186003)(86362001)(256004)(6666004)(6436002)(71190400001)(71200400001)(316002)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(3846002)(6116002)(2906002)(68736007)(81166006)(81156014)(7736002)(386003)(6506007)(305945005)(8676002)(8936002)(50226002)(102836004)(2501003)(36756003)(478600001)(53936002)(4326008)(5660300002)(14454004)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3787;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 737uilZcrd/n6W/9JpwCYJ6A2PZyfPm3c10ONdR3iNdPj1WY6+Lr9/kzUJOdxj1OOR3Q0r5WSOjtKmeY8+ZuyZuvJhGYeD5zPD+9T3OCka3u5EsWYY4t0wrQd87u5B3ZWdfmequuoRzZPc8nAaogdI+560j4QyORawar6+nboLmPhfkEVENXvB0OMOVfWHzcPXrioPDfVX0D3XwxbeZ+cSZ09Jd9PtycjdWyXm4Wx7uq/w09GupTfimb+XYtvyDdBqXkt/WptPdmX7oG6d/9R8hSpmkENR5kpxLuAJ3WzKQSveFYlzLxafkQGTv+d0MjMFKMIHYtVp0O56QXxR8AsEJJK3zT660PuWCL53kxp92c7IT/2A+g+nh7y7SxEBME/RqpE2UvZDXxD6nw5w3T/mHPqdEm6IDpO6deHI/Bmk0=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2b0b9e-a378-49b3-a829-08d6dee5608d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:27.1375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3787
X-MC-Unique: S_iB3su0MwKqTtkPDljgRw-6
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyB3YXMgYmVpbmcgZG9uZSBpbiBjb25maWcgdGhlIGZpcnN0IHRpbWUgdGhlIHBoeSB3YXMg
Y29uZmlndXJlZC4KU2hvdWxkIGJlIGluIHRoZSBwcm9iZSBtZXRob2QuCgpDYzogQW5kcmV3IEx1
bm4gPGFuZHJld0BsdW5uLmNoPgpDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFp
bC5jb20+CkNjOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBUcmVudCBQaWVwaG8gPHRwaWVwaG9AaW1waW5qLmNvbT4KLS0tCgpOb3RlczoKICAg
IENoYW5nZXMgZnJvbSB2MToKICAgICAgTmV3IHBhdGNoIGluIHNlcmllcyB2MgoKIGRyaXZlcnMv
bmV0L3BoeS9kcDgzODY3LmMgfCAzMyArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jIGIvZHJpdmVycy9uZXQvcGh5L2RwODM4
NjcuYwppbmRleCBjZTQ2ZmY0Y2Y4ODAuLjNiZGY5NDA0MzY5MyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvcGh5L2RwODM4NjcuYworKysgYi9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jCkBAIC0y
NjgsMjUgKzI2OCwyOSBAQCBzdGF0aWMgaW50IGRwODM4Njdfb2ZfaW5pdChzdHJ1Y3QgcGh5X2Rl
dmljZSAqcGh5ZGV2KQogfQogI2VuZGlmIC8qIENPTkZJR19PRl9NRElPICovCiAKLXN0YXRpYyBp
bnQgZHA4Mzg2N19jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQorc3RhdGlj
IGludCBkcDgzODY3X3Byb2JlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpCiB7CiAJc3RydWN0
IGRwODM4NjdfcHJpdmF0ZSAqZHA4Mzg2NzsKKworCWRwODM4NjcgPSBkZXZtX2t6YWxsb2MoJnBo
eWRldi0+bWRpby5kZXYsIHNpemVvZigqZHA4Mzg2NyksCisJCQkgICAgICAgR0ZQX0tFUk5FTCk7
CisJaWYgKCFkcDgzODY3KQorCQlyZXR1cm4gLUVOT01FTTsKKworCXBoeWRldi0+cHJpdiA9IGRw
ODM4Njc7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBkcDgzODY3X2NvbmZpZ19pbml0
KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpCit7CisJc3RydWN0IGRwODM4NjdfcHJpdmF0ZSAq
ZHA4Mzg2NyA9IHBoeWRldi0+cHJpdjsKIAlpbnQgcmV0LCB2YWwsIGJzOwogCXUxNiBkZWxheTsK
IAotCWlmICghcGh5ZGV2LT5wcml2KSB7Ci0JCWRwODM4NjcgPSBkZXZtX2t6YWxsb2MoJnBoeWRl
di0+bWRpby5kZXYsIHNpemVvZigqZHA4Mzg2NyksCi0JCQkJICAgICAgIEdGUF9LRVJORUwpOwot
CQlpZiAoIWRwODM4NjcpCi0JCQlyZXR1cm4gLUVOT01FTTsKLQotCQlwaHlkZXYtPnByaXYgPSBk
cDgzODY3OwotCQlyZXQgPSBkcDgzODY3X29mX2luaXQocGh5ZGV2KTsKLQkJaWYgKHJldCkKLQkJ
CXJldHVybiByZXQ7Ci0JfSBlbHNlIHsKLQkJZHA4Mzg2NyA9IChzdHJ1Y3QgZHA4Mzg2N19wcml2
YXRlICopcGh5ZGV2LT5wcml2OwotCX0KKwlyZXQgPSBkcDgzODY3X29mX2luaXQocGh5ZGV2KTsK
KwlpZiAocmV0KQorCQlyZXR1cm4gcmV0OwogCiAJLyogUlhfRFYvUlhfQ1RSTCBzdHJhcHBlZCBp
biBtb2RlIDEgb3IgbW9kZSAyIHdvcmthcm91bmQgKi8KIAlpZiAoZHA4Mzg2Ny0+cnhjdHJsX3N0
cmFwX3F1aXJrKQpAQCAtNDAyLDYgKzQwNiw3IEBAIHN0YXRpYyBzdHJ1Y3QgcGh5X2RyaXZlciBk
cDgzODY3X2RyaXZlcltdID0gewogCQkubmFtZQkJPSAiVEkgRFA4Mzg2NyIsCiAJCS8qIFBIWV9H
QklUX0ZFQVRVUkVTICovCiAKKwkJLnByb2JlICAgICAgICAgID0gZHA4Mzg2N19wcm9iZSwKIAkJ
LmNvbmZpZ19pbml0CT0gZHA4Mzg2N19jb25maWdfaW5pdCwKIAkJLnNvZnRfcmVzZXQJPSBkcDgz
ODY3X3BoeV9yZXNldCwKIAotLSAKMi4xNC41Cgo=

