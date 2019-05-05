Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9113C6B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEEAei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 20:34:38 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:1287
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbfEEAef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 20:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/B/09CNMTKAJYF8rs7p6+Ynm4v6ODbE3XAgx+ewOAc=;
 b=gRhsuZJvlnBYgs5e2+PyKUlNAL9h19H1DQZSxfklnlrx0f5Nl56iT8Iaz7wB7AfGC8JPAThp+a3JM3GcFwo0MjEvlg31HREQ/sIuJcOljWHxoZc5Ycr2Rp1qzeGv7SiQNUzQQTVQyybqHHu7f2NvQQStP4celRpJhC+2DIsRv8M=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5881.eurprd05.prod.outlook.com (20.179.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Sun, 5 May 2019 00:33:33 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 00:33:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5: Add support for FW fatal reporter dump
Thread-Topic: [net-next 14/15] net/mlx5: Add support for FW fatal reporter
 dump
Thread-Index: AQHVAtorycA5HCVlPkqR2luU2dyXFA==
Date:   Sun, 5 May 2019 00:33:33 +0000
Message-ID: <20190505003207.1353-15-saeedm@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
In-Reply-To: <20190505003207.1353-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 195f859a-dbb3-4191-76a5-08d6d0f14dbb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5881;
x-ms-traffictypediagnostic: DB8PR05MB5881:
x-microsoft-antispam-prvs: <DB8PR05MB58813A9CAA214FF8D18F9789BE370@DB8PR05MB5881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39850400004)(136003)(396003)(199004)(189003)(305945005)(52116002)(76176011)(36756003)(316002)(25786009)(6486002)(478600001)(14454004)(446003)(50226002)(476003)(11346002)(2616005)(26005)(7736002)(4326008)(99286004)(86362001)(6916009)(53936002)(66476007)(186003)(68736007)(66446008)(64756008)(66556008)(6436002)(66946007)(73956011)(6512007)(1076003)(66066001)(71190400001)(71200400001)(54906003)(256004)(102836004)(81156014)(81166006)(8936002)(3846002)(6506007)(386003)(107886003)(2906002)(8676002)(5660300002)(6116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5881;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wjxc/gEiIBR+w0D0kkiiaBo7jmCQD83TqMkxyzvSjXmQxN+8B5509PsKfMAOCzl5NZ+Jy+GotxAYr6rp1bzy/w87Q+gQp8VCHpfd0FZGN1hcAEc2zCWs4xv2b+ED16pLhVcKI/jBnS/8L11F3VNRkMxHW4gfmqt9l3XnSTcwYZ/rQ2HQtJOtpigBG+2vBzmOI/fOQOLWKq4Ls7KWapAAp0czJlXTzDRWGPmyL1cf3tVILgAQEZWK7Ylo5SSoG/26FU/d/qjyzZfANUunCc5GUrDll4Z1ASXGpAkasNnBdpdeRINaGrnMQLqocFso5ZOGDf9TTD4VaNuWq3JMjrc9gvs05+ztl+vD2ndlJNzhtf83OISndl1KCyNGDXPCMXO7LgRAlKE7Q+iCOi3RNp4A/u+SRPSOgy4iiROBOAKkYS8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195f859a-dbb3-4191-76a5-08d6d0f14dbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 00:33:33.2713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpBZGQgc3VwcG9ydCBv
ZiBkdW1wIGNhbGxiYWNrIGZvciBtbHg1IEZXIGZhdGFsIHJlcG9ydGVyLg0KVGhlIEZXIGZhdGFs
IGR1bXAgdXNlIGNyLWR1bXAgZnVuY3Rpb25hbGl0eSB0byBnYXRoZXIgY3Itc3BhY2UgZGF0YSBm
b3INCmRlYnVnLiBUaGUgY3ItZHVtcCB1c2VzIHZzYyBpbnRlcmZhY2Ugd2hpY2ggaXMgdmFsaWQg
ZXZlbiBpZiB0aGUgRlcNCmNvbW1hbmQgaW50ZXJmYWNlIGlzIG5vdCBmdW5jdGlvbmFsLCB3aGlj
aCBpcyB0aGUgY2FzZSBpbiBtb3N0IEZXIGZhdGFsDQplcnJvcnMuDQpUaGUgY3ItZHVtcCBpcyBz
dG9yZWQgYXMgYSBtZW1vcnkgcmVnaW9uIHNuYXBzaG90IHRvIGVhc2UgcmVhZCBieQ0KYWRkcmVz
cy4NCg0KQ29tbWFuZCBleGFtcGxlIGFuZCBvdXRwdXQ6DQokIGRldmxpbmsgaGVhbHRoIGR1bXAg
c2hvdyBwY2kvMDAwMDo4MjowMC4wIHJlcG9ydGVyIGZ3X2ZhdGFsDQpkZXZsaW5rX3JlZ2lvbl9u
YW1lOiBjci1zcGFjZSBzbmFwc2hvdF9pZDogMQ0KDQokIGRldmxpbmsgcmVnaW9uIHJlYWQgcGNp
LzAwMDA6ODI6MDAuMC9jci1zcGFjZSBzbmFwc2hvdCAxIGFkZHJlc3MgOTgzMDY0IGxlbmd0aCA4
DQowMDAwMDAwMDAwMGYwMDE4IGUxIDAzIDAwIDAwIGZiIGFlIGE5IDNmDQoNClNpZ25lZC1vZmYt
Ynk6IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgIHwgMzkgKysrKysrKysrKysrKysrKysrKw0K
IDEgZmlsZSBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCmluZGV4IGU2NGYwZTMyY2Q2Ny4u
NTI3MWM4OGVmNjRjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2hlYWx0aC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvaGVhbHRoLmMNCkBAIC01NDcsOSArNTQ3LDQ4IEBAIG1seDVfZndfZmF0YWxfcmVw
b3J0ZXJfcmVjb3ZlcihzdHJ1Y3QgZGV2bGlua19oZWFsdGhfcmVwb3J0ZXIgKnJlcG9ydGVyLA0K
IAlyZXR1cm4gbWx4NV9oZWFsdGhfY2FyZShkZXYpOw0KIH0NCiANCitzdGF0aWMgaW50DQorbWx4
NV9md19mYXRhbF9yZXBvcnRlcl9kdW1wKHN0cnVjdCBkZXZsaW5rX2hlYWx0aF9yZXBvcnRlciAq
cmVwb3J0ZXIsDQorCQkJICAgIHN0cnVjdCBkZXZsaW5rX2Ztc2cgKmZtc2csIHZvaWQgKnByaXZf
Y3R4KQ0KK3sNCisJc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiA9IGRldmxpbmtfaGVhbHRoX3Jl
cG9ydGVyX3ByaXYocmVwb3J0ZXIpOw0KKwljaGFyIGNyZHVtcF9yZWdpb25bMjBdOw0KKwl1MzIg
c25hcHNob3RfaWQ7DQorCWludCBlcnI7DQorDQorCWlmICghbWx4NV9jb3JlX2lzX3BmKGRldikp
IHsNCisJCW1seDVfY29yZV9lcnIoZGV2LCAiT25seSBQRiBpcyBwZXJtaXR0ZWQgcnVuIEZXIGZh
dGFsIGR1bXBcbiIpOw0KKwkJcmV0dXJuIC1FUEVSTTsNCisJfQ0KKw0KKwllcnIgPSBtbHg1X2Ny
ZHVtcF9jb2xsZWN0KGRldiwgY3JkdW1wX3JlZ2lvbiwgJnNuYXBzaG90X2lkKTsNCisJaWYgKGVy
cikNCisJCXJldHVybiBlcnI7DQorDQorCWlmIChwcml2X2N0eCkgew0KKwkJc3RydWN0IG1seDVf
ZndfcmVwb3J0ZXJfY3R4ICpmd19yZXBvcnRlcl9jdHggPSBwcml2X2N0eDsNCisNCisJCWVyciA9
IG1seDVfZndfcmVwb3J0ZXJfY3R4X3BhaXJzX3B1dChmbXNnLCBmd19yZXBvcnRlcl9jdHgpOw0K
KwkJaWYgKGVycikNCisJCQlyZXR1cm4gZXJyOw0KKwl9DQorDQorCWVyciA9IGRldmxpbmtfZm1z
Z19zdHJpbmdfcGFpcl9wdXQoZm1zZywgImRldmxpbmtfcmVnaW9uX25hbWUiLA0KKwkJCQkJICAg
Y3JkdW1wX3JlZ2lvbik7DQorCWlmIChlcnIpDQorCQlyZXR1cm4gZXJyOw0KKw0KKwllcnIgPSBk
ZXZsaW5rX2Ztc2dfdTMyX3BhaXJfcHV0KGZtc2csICJzbmFwc2hvdF9pZCIsIHNuYXBzaG90X2lk
KTsNCisJaWYgKGVycikNCisJCXJldHVybiBlcnI7DQorDQorCXJldHVybiAwOw0KK30NCisNCiBz
dGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyX29wcyBtbHg1X2Z3X2Zh
dGFsX3JlcG9ydGVyX29wcyA9IHsNCiAJCS5uYW1lID0gImZ3X2ZhdGFsIiwNCiAJCS5yZWNvdmVy
ID0gbWx4NV9md19mYXRhbF9yZXBvcnRlcl9yZWNvdmVyLA0KKwkJLmR1bXAgPSBtbHg1X2Z3X2Zh
dGFsX3JlcG9ydGVyX2R1bXAsDQogfTsNCiANCiAjZGVmaW5lIE1MWDVfUkVQT1JURVJfRldfR1JB
Q0VGVUxfUEVSSU9EIDEyMDAwMDANCi0tIA0KMi4yMC4xDQoNCg==
