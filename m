Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4E626A14
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfEVStj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:49:39 -0400
Received: from us-smtp-delivery-213.mimecast.com ([63.128.21.213]:40492 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729538AbfEVSti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558550977;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:autocrypt;
        bh=f/jSqzUhvxPtsWGb5uMlM2rHoSaAwtWGeaukdUAESyU=;
        b=ALZvKZDM7leOnaeskATEM3ouYwZdL4J0laYCev5DrmY03nSJxBujUebuPO1xaOFhwOu63k
        Reg+k8PEcJy2IrQV3B/Wqz50PgCSc55G0PW8bbOR28OCkJFfHsbyLNrfPEQ/QaCLTVlbcI
        5Ky2sYLhphTe4pNCqaATnvsYtNxHJ9w=
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-WHabDtBCMp2cT9kce1zJYA-1; Wed, 22 May 2019 14:43:30 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3787.namprd06.prod.outlook.com (10.167.236.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 18:43:22 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 18:43:22 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     Trent Piepho <tpiepho@impinj.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 3/8] net: phy: dp83867: Add ability to disable
 output clock
Thread-Topic: [PATCH net-next v2 3/8] net: phy: dp83867: Add ability to
 disable output clock
Thread-Index: AQHVEM470HTrKWiiUkOMve5v31Lbag==
Date:   Wed, 22 May 2019 18:43:22 +0000
Message-ID: <20190522184255.16323-3-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: f9000fcf-5785-400a-604d-08d6dee55dad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3787;
x-ms-traffictypediagnostic: MWHPR0601MB3787:
x-microsoft-antispam-prvs: <MWHPR0601MB378714BC268CCA4AEB5EA17AD3000@MWHPR0601MB3787.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39850400004)(136003)(199004)(189003)(26005)(25786009)(66066001)(52116002)(446003)(11346002)(476003)(2616005)(486006)(110136005)(54906003)(99286004)(76176011)(186003)(86362001)(256004)(6436002)(71190400001)(71200400001)(316002)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(3846002)(6116002)(2906002)(68736007)(81166006)(81156014)(7736002)(386003)(6506007)(305945005)(8676002)(8936002)(50226002)(102836004)(2501003)(36756003)(478600001)(53936002)(4326008)(5660300002)(14454004)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3787;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eNd6kL9m0ULzZnydJqzw4ruaFcl51b/HJ4Y7p6CIx5CR73qXKln68SLcHXZ5AWlvF5AtWNLLHbvOnQBPJGtEOg8m6ra0QZG19IPmHDcMl/Ryd7As3fqeXEuB4aYvtCqYpvDqLEisZgvMiQxAYiHHupuKghX4o4pTRFa18shmIAkyHECt1z0rDNF0nZ0gYJDx1Ds3npI1rm0JJqRSXEGU2krjzDbkoo3yj78WX1uozTMa6BJMZocMc8xM8jt9ShbhkzuBx6UGALXLsqO6k9j1dzBdiajmcRAIE370S+oq7OMiQzu4sSh6dX0M9Za0JNp8FuKuCsn5ZSiHLUVCEZOP6w6QDjKOTlHBMhY1ai3iOCkBHjq9Rfu3gjYriwSwnqzqqX6E2k/WFQCcP6xGcc6HXTlFl9uWcGqEj4yaxvKY9vQ=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9000fcf-5785-400a-604d-08d6dee55dad
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:22.3322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3787
X-MC-Unique: WHabDtBCMp2cT9kce1zJYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R2VuZXJhbGx5LCB0aGUgb3V0cHV0IGNsb2NrIHBpbiBpcyBvbmx5IHVzZWQgZm9yIHRlc3Rpbmcg
YW5kIG9ubHkgc2VydmVzCmFzIGEgc291cmNlIG9mIFJGIG5vaXNlIGFmdGVyIHRoaXMuICBJdCBj
b3VsZCBiZSB1c2VkIHRvIGRhaXN5LWNoYWluClBIWXMsIGJ1dCB0aGlzIGlzIHVuY29tbW9uLiAg
U2luY2UgdGhlIFBIWSBjYW4gZGlzYWJsZSB0aGUgb3V0cHV0LCBtYWtlCmRvaW5nIHNvIGFuIG9w
dGlvbi4gIEkgZG8gdGhpcyBieSBhZGRpbmcgYW5vdGhlciBlbnVtZXJhdGlvbiB0byB0aGUKYWxs
b3dlZCB2YWx1ZXMgb2YgdGksY2xrLW91dHB1dC1zZWwuCgpUaGUgY29kZSB3YXMgbm90IHVzaW5n
IHRoZSB2YWx1ZSBEUDgzODY3X0NMS19PX1NFTF9SRUZfQ0xLIGFzIG9uZSBtaWdodApleHBlY3Q6
IHRvIHNlbGVjdCB0aGUgUkVGX0NMSyBhcyB0aGUgb3V0cHV0LiAgUmF0aGVyIGl0IG1lYW50ICJr
ZWVwCmNsb2NrIG91dHB1dCBzZXR0aW5nIGFzIGlzIiwgd2hpY2gsIGRlcGVuZGluZyBvbiBQSFkg
c3RyYXBwaW5nLCBtaWdodApub3QgYmUgb3V0cHV0dGluZyBSRUZfQ0xLLgoKQ2hhbmdlIHRoaXMg
c28gRFA4Mzg2N19DTEtfT19TRUxfUkVGX0NMSyBtZWFucyBlbmFibGUgUkVGX0NMSyBvdXRwdXQu
Ck9taXR0aW5nIHRoZSBwcm9wZXJ0eSB3aWxsIGxlYXZlIHRoZSBzZXR0aW5nIGFzIGlzICh3aGlj
aCB3YXMgdGhlCnByZXZpb3VzIGJlaGF2aW9yIGluIHRoaXMgY2FzZSkuCgpPdXQgb2YgcmFuZ2Ug
dmFsdWVzIHdlcmUgc2lsZW50bHkgY29udmVydGVkIGludG8KRFA4Mzg2N19DTEtfT19TRUxfUkVG
X0NMSy4gIENoYW5nZSB0aGlzIHNvIHRoZXkgZ2VuZXJhdGUgYW4gZXJyb3IuCgpDYzogQW5kcmV3
IEx1bm4gPGFuZHJld0BsdW5uLmNoPgpDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+CkNjOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPgpTaWdu
ZWQtb2ZmLWJ5OiBUcmVudCBQaWVwaG8gPHRwaWVwaG9AaW1waW5qLmNvbT4KLS0tCiBkcml2ZXJz
L25ldC9waHkvZHA4Mzg2Ny5jIHwgMzcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2RwODM4NjcuYyBiL2RyaXZlcnMvbmV0L3BoeS9k
cDgzODY3LmMKaW5kZXggZmQzNTEzMWEwYzM5Li41NGZiYzgzM2JmNWQgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbmV0L3BoeS9kcDgzODY3LmMKKysrIGIvZHJpdmVycy9uZXQvcGh5L2RwODM4NjcuYwpA
QCAtNjgsNiArNjgsNyBAQAogCiAjZGVmaW5lIERQODM4NjdfSU9fTVVYX0NGR19JT19JTVBFREFO
Q0VfTUFYCTB4MAogI2RlZmluZSBEUDgzODY3X0lPX01VWF9DRkdfSU9fSU1QRURBTkNFX01JTgkw
eDFmCisjZGVmaW5lIERQODM4NjdfSU9fTVVYX0NGR19DTEtfT19ESVNBQkxFCUJJVCg2KQogI2Rl
ZmluZSBEUDgzODY3X0lPX01VWF9DRkdfQ0xLX09fU0VMX01BU0sJKDB4MWYgPDwgOCkKICNkZWZp
bmUgRFA4Mzg2N19JT19NVVhfQ0ZHX0NMS19PX1NFTF9TSElGVAk4CiAKQEAgLTg3LDcgKzg4LDgg
QEAgc3RydWN0IGRwODM4NjdfcHJpdmF0ZSB7CiAJaW50IGlvX2ltcGVkYW5jZTsKIAlpbnQgcG9y
dF9taXJyb3Jpbmc7CiAJYm9vbCByeGN0cmxfc3RyYXBfcXVpcms7Ci0JaW50IGNsa19vdXRwdXRf
c2VsOworCWJvb2wgc2V0X2Nsa19vdXRwdXQ7CisJdTMyIGNsa19vdXRwdXRfc2VsOwogfTsKIAog
c3RhdGljIGludCBkcDgzODY3X2Fja19pbnRlcnJ1cHQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
dikKQEAgLTE1NCwxMSArMTU2LDE5IEBAIHN0YXRpYyBpbnQgZHA4Mzg2N19vZl9pbml0KHN0cnVj
dCBwaHlfZGV2aWNlICpwaHlkZXYpCiAJLyogT3B0aW9uYWwgY29uZmlndXJhdGlvbiAqLwogCXJl
dCA9IG9mX3Byb3BlcnR5X3JlYWRfdTMyKG9mX25vZGUsICJ0aSxjbGstb3V0cHV0LXNlbCIsCiAJ
CQkJICAgJmRwODM4NjctPmNsa19vdXRwdXRfc2VsKTsKLQlpZiAocmV0IHx8IGRwODM4NjctPmNs
a19vdXRwdXRfc2VsID4gRFA4Mzg2N19DTEtfT19TRUxfUkVGX0NMSykKLQkJLyogS2VlcCB0aGUg
ZGVmYXVsdCB2YWx1ZSBpZiB0aSxjbGstb3V0cHV0LXNlbCBpcyBub3Qgc2V0Ci0JCSAqIG9yIHRv
byBoaWdoCisJLyogSWYgbm90IHNldCwga2VlcCBkZWZhdWx0ICovCisJaWYgKCFyZXQpIHsKKwkJ
ZHA4Mzg2Ny0+c2V0X2Nsa19vdXRwdXQgPSB0cnVlOworCQkvKiBWYWxpZCB2YWx1ZXMgYXJlIDAg
dG8gRFA4Mzg2N19DTEtfT19TRUxfUkVGX0NMSyBvcgorCQkgKiBEUDgzODY3X0NMS19PX1NFTF9P
RkYuCiAJCSAqLwotCQlkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCA9IERQODM4NjdfQ0xLX09fU0VM
X1JFRl9DTEs7CisJCWlmIChkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCA+IERQODM4NjdfQ0xLX09f
U0VMX1JFRl9DTEsgJiYKKwkJICAgIGRwODM4NjctPmNsa19vdXRwdXRfc2VsICE9IERQODM4Njdf
Q0xLX09fU0VMX09GRikgeworCQkJcGh5ZGV2X2VycihwaHlkZXYsICJ0aSxjbGstb3V0cHV0LXNl
bCB2YWx1ZSAldSBvdXQgb2YgcmFuZ2VcbiIsCisJCQkJICAgZHA4Mzg2Ny0+Y2xrX291dHB1dF9z
ZWwpOworCQkJcmV0dXJuIC1FSU5WQUw7CisJCX0KKwl9CiAKIAlpZiAob2ZfcHJvcGVydHlfcmVh
ZF9ib29sKG9mX25vZGUsICJ0aSxtYXgtb3V0cHV0LWltcGVkYW5jZSIpKQogCQlkcDgzODY3LT5p
b19pbXBlZGFuY2UgPSBEUDgzODY3X0lPX01VWF9DRkdfSU9fSU1QRURBTkNFX01BWDsKQEAgLTI4
OCwxMSArMjk4LDIwIEBAIHN0YXRpYyBpbnQgZHA4Mzg2N19jb25maWdfaW5pdChzdHJ1Y3QgcGh5
X2RldmljZSAqcGh5ZGV2KQogCQlkcDgzODY3X2NvbmZpZ19wb3J0X21pcnJvcmluZyhwaHlkZXYp
OwogCiAJLyogQ2xvY2sgb3V0cHV0IHNlbGVjdGlvbiBpZiBtdXhpbmcgcHJvcGVydHkgaXMgc2V0
ICovCi0JaWYgKGRwODM4NjctPmNsa19vdXRwdXRfc2VsICE9IERQODM4NjdfQ0xLX09fU0VMX1JF
Rl9DTEspCisJaWYgKGRwODM4NjctPnNldF9jbGtfb3V0cHV0KSB7CisJCXUxNiBtYXNrID0gRFA4
Mzg2N19JT19NVVhfQ0ZHX0NMS19PX0RJU0FCTEU7CisKKwkJaWYgKGRwODM4NjctPmNsa19vdXRw
dXRfc2VsID09IERQODM4NjdfQ0xLX09fU0VMX09GRikgeworCQkJdmFsID0gRFA4Mzg2N19JT19N
VVhfQ0ZHX0NMS19PX0RJU0FCTEU7CisJCX0gZWxzZSB7CisJCQltYXNrIHw9IERQODM4NjdfSU9f
TVVYX0NGR19DTEtfT19TRUxfTUFTSzsKKwkJCXZhbCA9IGRwODM4NjctPmNsa19vdXRwdXRfc2Vs
IDw8CisJCQkgICAgICBEUDgzODY3X0lPX01VWF9DRkdfQ0xLX09fU0VMX1NISUZUOworCQl9CisK
IAkJcGh5X21vZGlmeV9tbWQocGh5ZGV2LCBEUDgzODY3X0RFVkFERFIsIERQODM4NjdfSU9fTVVY
X0NGRywKLQkJCSAgICAgICBEUDgzODY3X0lPX01VWF9DRkdfQ0xLX09fU0VMX01BU0ssCi0JCQkg
ICAgICAgZHA4Mzg2Ny0+Y2xrX291dHB1dF9zZWwgPDwKLQkJCSAgICAgICBEUDgzODY3X0lPX01V
WF9DRkdfQ0xLX09fU0VMX1NISUZUKTsKKwkJCSAgICAgICBtYXNrLCB2YWwpOworCX0KIAogCXJl
dHVybiAwOwogfQotLSAKMi4xNC41Cgo=

