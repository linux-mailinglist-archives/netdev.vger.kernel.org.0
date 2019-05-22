Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA526A1C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfEVSuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:50:05 -0400
Received: from us-smtp-delivery-213.mimecast.com ([216.205.24.213]:60928 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729538AbfEVSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558551004;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:autocrypt;
        bh=yBD7+yUC+19Yo3dtt1mYEk+eRvdqgBPPfO9NyaBoHeU=;
        b=WZvpqAaL2EXC9e1pfG0rVsmu/63GoTS0o0JgzzzK4CCv5aGADUVSDupVyt7338Uh9U3Vyk
        j+INmk7PNLFmfn6fc1YdeZ8LOploOVLkBPkaUkADoRQwt7OPY/0OSdzjfvTVzVmMPu1kME
        QPEpoAEznTUqb+ADdn9i/th8+AaFdAY=
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-lbkrVFnbMRCb9sYxtY3F7w-5; Wed, 22 May 2019 14:43:35 -0400
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
Subject: [PATCH net-next v2 7/8] net: phy: dp83867: Validate FIFO depth
 property
Thread-Topic: [PATCH net-next v2 7/8] net: phy: dp83867: Validate FIFO depth
 property
Thread-Index: AQHVEM49gbW0KPtQLEifVXwmMcWIzg==
Date:   Wed, 22 May 2019 18:43:26 +0000
Message-ID: <20190522184255.16323-7-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: fd2557a6-9c75-4276-5d82-08d6dee5601a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3787;
x-ms-traffictypediagnostic: MWHPR0601MB3787:
x-microsoft-antispam-prvs: <MWHPR0601MB37873C4904605173E9ECD158D3000@MWHPR0601MB3787.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:576;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39850400004)(136003)(199004)(189003)(26005)(25786009)(66066001)(52116002)(446003)(11346002)(476003)(2616005)(486006)(110136005)(54906003)(99286004)(76176011)(186003)(86362001)(14444005)(256004)(6666004)(6436002)(71190400001)(71200400001)(316002)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(3846002)(6116002)(2906002)(68736007)(15650500001)(81166006)(81156014)(7736002)(386003)(6506007)(305945005)(8676002)(8936002)(50226002)(102836004)(2501003)(36756003)(478600001)(53936002)(4326008)(5660300002)(14454004)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3787;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vLKk0nQc5P1V/Isq0rb6SZs8yfQi7s4gkz6ZIUx3YXp1o9OUy4ebNRCmnBoGDtl3oERuvJwYfsWn4j3z30YTT/hAp9GSD61l2Ynnec2jmzfvr/C3r+UnlSWgRtxv0y5Qio8PJ2FCO//E9SDhb33UlbOx8DIwt4bgOe1OUT6q8k2HeSbx9mKBuCJ+itsQCw0FPWemjCcoTSD/4S2Vh9h+S05AJYD03fR8Ko3I2SkU6CbDy8fKlcdxS2wE5g4yNdNFG3sNeL1rIxhszm207kk1VzvPUj5goF/q1ujAW08uUVUEJTDw6DWyBvFV1/bVG1G4WNqS/6t26V/wp5qMk91Va4hAPsGcLqq33O+ZrmBqpamd/YhWbfnq2E4Qd4TYlOZAM4qIgtfyvgQGfcRF9Bj49z4JpSLhmzCDn7HzAcDJcHY=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2557a6-9c75-4276-5d82-08d6dee5601a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:26.3100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3787
X-MC-Unique: lbkrVFnbMRCb9sYxtY3F7w-5
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW5zdXJlIHByb3BlcnR5IGlzIGluIHZhbGlkIHJhbmdlIGFuZCBmYWlsIHdoZW4gcmVhZGluZyBE
VCBpZiBpdCBpcyBub3QuCkFsc28gYWRkIGVycm9yIG1lc3NhZ2UgZm9yIGV4aXN0aW5nIGZhaWx1
cmUgaWYgcmVxdWlyZWQgcHJvcGVydHkgaXMgbm90CnByZXNlbnQuCgpDYzogQW5kcmV3IEx1bm4g
PGFuZHJld0BsdW5uLmNoPgpDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5j
b20+CkNjOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPgpTaWduZWQtb2Zm
LWJ5OiBUcmVudCBQaWVwaG8gPHRwaWVwaG9AaW1waW5qLmNvbT4KLS0tCgpOb3RlczoKICAgIENo
YW5nZXMgZnJvbSB2MToKICAgICAgTmV3IHBhdGNoIGluIHNlcmllcyB2MgoKIGRyaXZlcnMvbmV0
L3BoeS9kcDgzODY3LmMgfCAxNyArKysrKysrKysrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDE1
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
cGh5L2RwODM4NjcuYyBiL2RyaXZlcnMvbmV0L3BoeS9kcDgzODY3LmMKaW5kZXggNWVjZTE1M2Fh
OWMzLi5jZTQ2ZmY0Y2Y4ODAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3BoeS9kcDgzODY3LmMK
KysrIGIvZHJpdmVycy9uZXQvcGh5L2RwODM4NjcuYwpAQCAtNjUsNyArNjUsOCBAQAogCiAvKiBQ
SFkgQ1RSTCBiaXRzICovCiAjZGVmaW5lIERQODM4NjdfUEhZQ1JfRklGT19ERVBUSF9TSElGVAkJ
MTQKLSNkZWZpbmUgRFA4Mzg2N19QSFlDUl9GSUZPX0RFUFRIX01BU0sJCSgzIDw8IDE0KQorI2Rl
ZmluZSBEUDgzODY3X1BIWUNSX0ZJRk9fREVQVEhfTUFYCQkweDAzCisjZGVmaW5lIERQODM4Njdf
UEhZQ1JfRklGT19ERVBUSF9NQVNLCQlHRU5NQVNLKDE1LCAxNCkKICNkZWZpbmUgRFA4Mzg2N19Q
SFlDUl9SRVNFUlZFRF9NQVNLCQlCSVQoMTEpCiAKIC8qIFJHTUlJRENUTCBiaXRzICovCkBAIC0y
NDUsOCArMjQ2LDIwIEBAIHN0YXRpYyBpbnQgZHA4Mzg2N19vZl9pbml0KHN0cnVjdCBwaHlfZGV2
aWNlICpwaHlkZXYpCiAJaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChvZl9ub2RlLCAiZW5ldC1w
aHktbGFuZS1uby1zd2FwIikpCiAJCWRwODM4NjctPnBvcnRfbWlycm9yaW5nID0gRFA4Mzg2N19Q
T1JUX01JUlJPSU5HX0RJUzsKIAotCXJldHVybiBvZl9wcm9wZXJ0eV9yZWFkX3UzMihvZl9ub2Rl
LCAidGksZmlmby1kZXB0aCIsCisJcmV0ID0gb2ZfcHJvcGVydHlfcmVhZF91MzIob2Zfbm9kZSwg
InRpLGZpZm8tZGVwdGgiLAogCQkJCSAgICZkcDgzODY3LT5maWZvX2RlcHRoKTsKKwlpZiAocmV0
KSB7CisJCXBoeWRldl9lcnIocGh5ZGV2LAorCQkJICAgInRpLGZpZm8tZGVwdGggcHJvcGVydHkg
aXMgcmVxdWlyZWRcbiIpOworCQlyZXR1cm4gcmV0OworCX0KKwlpZiAoZHA4Mzg2Ny0+Zmlmb19k
ZXB0aCA+IERQODM4NjdfUEhZQ1JfRklGT19ERVBUSF9NQVgpIHsKKwkJcGh5ZGV2X2VycihwaHlk
ZXYsCisJCQkgICAidGksZmlmby1kZXB0aCB2YWx1ZSAldSBvdXQgb2YgcmFuZ2VcbiIsCisJCQkg
ICBkcDgzODY3LT5maWZvX2RlcHRoKTsKKwkJcmV0dXJuIC1FSU5WQUw7CisJfQorCXJldHVybiAw
OwogfQogI2Vsc2UKIHN0YXRpYyBpbnQgZHA4Mzg2N19vZl9pbml0KHN0cnVjdCBwaHlfZGV2aWNl
ICpwaHlkZXYpCi0tIAoyLjE0LjUKCg==

