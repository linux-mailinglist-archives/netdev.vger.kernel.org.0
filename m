Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674B8123194
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfLQQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:15 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729202AbfLQQQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JL6Z45X94EGcko5cVf3JA5YWXLPmSIEUAjDxn1RQJQvCJaBOCpAvfoHVJwkqtlNUa2QsZD5WoRTrYFax7EHlCkjrag0dZmFvnBjjuqjNC48agJZjhBCAsUaDAqjDolT6jtb2RjDjgbSFJE9zhKPK7SP2P8Ooqp+eE5C/PokQ//Hy+Eh7qpq04ZOePJC0KzVownQSgJog6eFL8X19MDJsMnnDMpDs/NM1Ls69z/D9+laj7HQ20+1MgVZjfRJvSX/D8yKd73tOdEOjZCPQ7A39RWW9nedICJJ2bihIxhqFPo2t0NB7fsJHiqZzhGVrBBcMBIU28Q7jGu1bkwR0AOwYtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yPmS4H5E8JPUG3xYt17LIXx6rW02POsO+7NNwVhTFw=;
 b=R3T6Lr7Y4nAcAMryfwKH6ECcraYLV4eIHHdMsmp8wA89WfqXXY2Tg5rbeZa5ynjRZIxVelWbDbD2MMWsN5EQ3/z3ySm8cffcAYkef2D+Z6ijZUTYVWqR9aWFBpUq1T3f460r7ZR1ROlAjK/wGvesVM7Z4jqX2dxME5s+tk6Un8nyKMtZDBXsLe8iel1ldSih/fSHwCw+3HoxBUr1G6u1ISWvhW40gxTWvWHOIK+3gCBAVVDl651NGmaH3yKPc1z68D6I008wzsfNw2RryWtTsbs7tKq4TrU5oRMYnKu4jYBizbXRn3+9I2dLnHilJM3fMkQP98x9sCna4pB/tG4evg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yPmS4H5E8JPUG3xYt17LIXx6rW02POsO+7NNwVhTFw=;
 b=RUPq28xOEwfZdaYnkfsnrXs4EM8w/5ojfZ/NsuvKaCl5QVqQMCOZ9Te4H+QtoFzo/erZxpJbXAEgxttllHY7dvfZ0CNyt5nDzlNkym+T+h3ZjrQ440xUBW71Yz3P9dePGC2EPQVIqfya5eNt4OxGb7m5PHKOz1Q3luxcJEgxIf0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:16:02 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:16:02 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 51/55] staging: wfx: workaround bug with "iw scan"
Thread-Topic: [PATCH v2 51/55] staging: wfx: workaround bug with "iw scan"
Thread-Index: AQHVtPU3xiUk2oUs3kW8So34MmM/rw==
Date:   Tue, 17 Dec 2019 16:15:37 +0000
Message-ID: <20191217161318.31402-52-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4a51ef6-660b-465b-2e3b-08d7830c5a19
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB447783BEF841B5910856D3D793500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SF/NnugUPFTBKeG4nBwzp1WqK+3K4OO+tCggqf4zo/I/RZaF2xI2OppESwktTV/rnL1SK5yxc6hdfEsKKQFObZyR0/HynQJk3ZGLf93esCFUxq+FE5U6qPzaFAUxt87m1tSVrZ6RTQkc7orYO1FktiTFWrI1d9+jUo+U+/ukzRfTwGwGxek/7FgZYM/zLLc4NjbtCo8u9V9U2THTykoy8EfmqtzJTjKK7HEQEpowsH0u0I4q7VoIq4RNBprrRsZXqkPGaLDlzAto255CVJ9LFYCqj84bJfOP3zsHO40T02UWS1Xe3sQYXr5E5mA6oluOa4JrC0eTsBqb3XBIZxjyUGff1nuEZ8yedCScCpbCac7xFj+4NroShvVejOWSrFZ7SwCXi4RRtDbtFLIhzquoO0ChER/QUWlCcMH3EwkQpWS//aInRCE1Phe+XDSAcWoB
Content-Type: text/plain; charset="utf-8"
Content-ID: <90446FA95A74B94B8D05B0C4D380CEB4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a51ef6-660b-465b-2e3b-08d7830c5a19
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:37.2259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w0YYV1ogO8TNKKrNdVrKuH+trGrUQKAXU635rZdr9S/LkV/TSMHMz6HJSlMUzQrKYYY9DUKnh+qDTuve7eMDPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbWFj
ODAyMTEgc3BlY2lmaWNhdGlvbiBkb2VzIG5vdCBmb3JiaWQgaHdfc2NhbigpIHRvIGNhbGwKaWVl
ZTgwMjExX3NjYW5fY29tcGxldGVkKCkuIEhvd2V2ZXIsIGZyb20gdXNlcnNwYWNlIHBvaW50IG9m
IHZpZXcsIG5vdAphbGwgYXBwbGljYXRpb25zIHN1cHBvcnQgdGhpcyBiZWhhdmlvci4gSW4gcGFy
dGljdWxhciwgdGhlIGNvZGUgb2YgaXcKY29udGFpbnMgYSBiaWcgZmF0IHdhcm5pbmc6CgogICAv
KgogICAgKiBUaGlzIGNvZGUgaGFzIGEgYnVnLCB3aGljaCByZXF1aXJlcyBjcmVhdGluZyBhIHNl
cGFyYXRlCiAgICAqIG5sODAyMTEgc29ja2V0IHRvIGZpeDoKICAgICogSXQgaXMgcG9zc2libGUg
Zm9yIGEgTkw4MDIxMV9DTURfTkVXX1NDQU5fUkVTVUxUUyBvcgogICAgKiBOTDgwMjExX0NNRF9T
Q0FOX0FCT1JURUQgbWVzc2FnZSB0byBiZSBzZW50IGJ5IHRoZSBrZXJuZWwKICAgICogYmVmb3Jl
ICghKSB3ZSBsaXN0ZW4gdG8gaXQsIGJlY2F1c2Ugd2Ugb25seSBzdGFydCBsaXN0ZW5pbmcKICAg
ICogYWZ0ZXIgd2Ugc2VuZCBvdXIgc2NhbiByZXF1ZXN0LgogICAgWy4uLl0KICAgICogQWxhcywg
dGhlIGtlcm5lbCBkb2Vzbid0IGRvIHRoYXQgKHlldCkuCiAgICAqLwoKU28sIHdlIGhhdmUgdG8g
YXZvaWQgdG8gY2FsbCBpZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWQoKSBmcm9tIGh3X3NjYW4oKQoo
aXQncyBhIGtpbmQgb2YgdW53cml0dGVuIHJ1bGUpLgoKVGhpcyBwYXRjaCByZWxvY2F0ZXMgdGhl
IGh3X3NjYW4oKSBwcm9jZXNzIHRvIGEgd29ya19zdHJ1Y3QgdG8gZml4IHRoZQpwcm9ibGVtLgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgNDcgKysrKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oIHwgIDEg
KwogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgfCAgMSArCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oICB8ICAyICsrCiA0IGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDE3IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKaW5kZXggYjczZTYxZThkYTQ2Li41NDAwMDliNzIyNDAg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc2Nhbi5jCkBAIC03MSwyMyArNzEsMTkgQEAgc3RhdGljIGludCBzZW5kX3NjYW5f
cmVxKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCXJldHVybiBpIC0gc3RhcnRfaWR4OwogfQogCi1p
bnQgd2Z4X2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFf
dmlmICp2aWYsCi0JCXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpod19yZXEpCisvKgor
ICogSXQgaXMgbm90IHJlYWxseSBuZWNlc3NhcnkgdG8gcnVuIHNjYW4gcmVxdWVzdCBhc3luY2hy
b25vdXNseS4gSG93ZXZlciwKKyAqIHRoZXJlIGlzIGEgYnVnIGluICJpdyBzY2FuIiB3aGVuIGll
ZWU4MDIxMV9zY2FuX2NvbXBsZXRlZCgpIGlzIGNhbGxlZCBiZWZvcmUKKyAqIHdmeF9od19zY2Fu
KCkgcmV0dXJuCisgKi8KK3ZvaWQgd2Z4X2h3X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspCiB7Ci0Jc3RydWN0IHdmeF9kZXYgKndkZXYgPSBody0+cHJpdjsKLQlzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKSB2aWYtPmRydl9wcml2OworCXN0cnVjdCB3
ZnhfdmlmICp3dmlmID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB3ZnhfdmlmLCBzY2FuX3dv
cmspOworCXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpod19yZXEgPSB3dmlmLT5zY2Fu
X3JlcTsKIAlpbnQgY2hhbl9jdXIsIHJldDsKIAotCVdBUk5fT04oaHdfcmVxLT5yZXEubl9jaGFu
bmVscyA+IEhJRl9BUElfTUFYX05CX0NIQU5ORUxTKTsKLQotCWlmICh2aWYtPnR5cGUgPT0gTkw4
MDIxMV9JRlRZUEVfQVApCi0JCXJldHVybiAtRU9QTk9UU1VQUDsKLQotCWlmICh3dmlmLT5zdGF0
ZSA9PSBXRlhfU1RBVEVfUFJFX1NUQSkKLQkJcmV0dXJuIC1FQlVTWTsKLQogCW11dGV4X2xvY2so
Jnd2aWYtPnNjYW5fbG9jayk7Ci0JbXV0ZXhfbG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CisJbXV0
ZXhfbG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CiAJdXBkYXRlX3Byb2JlX3RtcGwod3Zp
ZiwgJmh3X3JlcS0+cmVxKTsKIAl3ZnhfZndkX3Byb2JlX3JlcSh3dmlmLCB0cnVlKTsKIAljaGFu
X2N1ciA9IDA7CkBAIC05NiwxOCArOTIsMzUgQEAgaW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCQlpZiAocmV0ID4gMCkK
IAkJCWNoYW5fY3VyICs9IHJldDsKIAl9IHdoaWxlIChyZXQgPiAwICYmIGNoYW5fY3VyIDwgaHdf
cmVxLT5yZXEubl9jaGFubmVscyk7Ci0JX19pZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWRfY29tcGF0
KGh3LCByZXQgPCAwKTsKLQltdXRleF91bmxvY2soJndkZXYtPmNvbmZfbXV0ZXgpOworCW11dGV4
X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CiAJbXV0ZXhfdW5sb2NrKCZ3dmlmLT5z
Y2FuX2xvY2spOworCV9faWVlZTgwMjExX3NjYW5fY29tcGxldGVkX2NvbXBhdCh3dmlmLT53ZGV2
LT5odywgcmV0IDwgMCk7CiAJaWYgKHd2aWYtPmRlbGF5ZWRfdW5qb2luKSB7CiAJCXd2aWYtPmRl
bGF5ZWRfdW5qb2luID0gZmFsc2U7Ci0JCXdmeF90eF9sb2NrKHdkZXYpOworCQl3ZnhfdHhfbG9j
ayh3dmlmLT53ZGV2KTsKIAkJaWYgKCFzY2hlZHVsZV93b3JrKCZ3dmlmLT51bmpvaW5fd29yaykp
Ci0JCQl3ZnhfdHhfdW5sb2NrKHdkZXYpOworCQkJd2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsK
IAl9IGVsc2UgaWYgKHd2aWYtPmRlbGF5ZWRfbGlua19sb3NzKSB7CiAJCXd2aWYtPmRlbGF5ZWRf
bGlua19sb3NzID0gZmFsc2U7CiAJCXdmeF9jcW1fYnNzbG9zc19zbSh3dmlmLCAxLCAwLCAwKTsK
IAl9Cit9CisKK2ludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0
IGllZWU4MDIxMV92aWYgKnZpZiwKKwkJc3RydWN0IGllZWU4MDIxMV9zY2FuX3JlcXVlc3QgKmh3
X3JlcSkKK3sKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+
ZHJ2X3ByaXY7CisKKwlXQVJOX09OKGh3X3JlcS0+cmVxLm5fY2hhbm5lbHMgPiBISUZfQVBJX01B
WF9OQl9DSEFOTkVMUyk7CisKKwlpZiAodmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX0FQKQor
CQlyZXR1cm4gLUVPUE5PVFNVUFA7CisKKwlpZiAod3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX1BS
RV9TVEEpCisJCXJldHVybiAtRUJVU1k7CisKKwl3dmlmLT5zY2FuX3JlcSA9IGh3X3JlcTsKKwlz
Y2hlZHVsZV93b3JrKCZ3dmlmLT5zY2FuX3dvcmspOwogCXJldHVybiAwOwogfQogCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5oCmluZGV4IDAzYmM2YzdlNTYyZC4uYjU0N2YxOTI3ZDcyIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaApAQCAt
MTUsNiArMTUsNyBAQAogc3RydWN0IHdmeF9kZXY7CiBzdHJ1Y3Qgd2Z4X3ZpZjsKIAordm9pZCB3
ZnhfaHdfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CiBpbnQgd2Z4X2h3X3Nj
YW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJ
CXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEpOwogdm9pZCB3Znhfc2Nhbl9jb21w
bGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDE2ZjVkYjg3MzI3NS4u
NDM1NGJiODA4MWM1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTE0MjcsNiArMTQyNyw3IEBAIGludCB3Znhf
YWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92
aWYgKnZpZikKIAogCW11dGV4X2luaXQoJnd2aWYtPnNjYW5fbG9jayk7CiAJaW5pdF9jb21wbGV0
aW9uKCZ3dmlmLT5zY2FuX2NvbXBsZXRlKTsKKwlJTklUX1dPUksoJnd2aWYtPnNjYW5fd29yaywg
d2Z4X2h3X3NjYW5fd29yayk7CiAKIAltdXRleF91bmxvY2soJndkZXYtPmNvbmZfbXV0ZXgpOwog
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaAppbmRleCAzMzU2ZDBjYmY3YWYuLmI1Zjc2M2MzZmFjNyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
CkBAIC0xMjcsNyArMTI3LDkgQEAgc3RydWN0IHdmeF92aWYgewogCiAJLyogYXZvaWQgc29tZSBv
cGVyYXRpb25zIGluIHBhcmFsbGVsIHdpdGggc2NhbiAqLwogCXN0cnVjdCBtdXRleAkJc2Nhbl9s
b2NrOworCXN0cnVjdCB3b3JrX3N0cnVjdAlzY2FuX3dvcms7CiAJc3RydWN0IGNvbXBsZXRpb24J
c2Nhbl9jb21wbGV0ZTsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nhbl9yZXE7
CiAKIAlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKIAotLSAKMi4yNC4w
Cgo=
