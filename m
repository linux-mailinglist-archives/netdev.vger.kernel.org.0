Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09975123173
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfLQQP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:26 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:11510
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728718AbfLQQPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GX/Xat2GVV+uKhN+JY0sJ06q+T7q5GuqFoBUGMl/w05st1o0NHw/Gh/4oXxk1lc5ROezJXSH7Ss6Jx5eXxg0mZ4puwgodM9xfXGKIlRwVozykmQsYqFVCMiJlbhNyFhya8eCdfA3ns6iiliy2I/Q+QGbTpK2XvxEDzEeQrcvvBuFm3TFNxieltw7VVWcBt/f5+Ey1duClk+pJov288IGi23BFdYVgMPOazoxFk+asINAMZz08TTDOT/QBAo5qaKPGb4V5ZV7xr4KYdWBcYQvSnNC66jgpSil8jt0VjFhO+dpUEJ3I08vRU7cuHZtUQbmJ0Aty6Tjuqhbsh04PMC8iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00C7yvUiSw61drLH3nKSkuEhkRj+FBYQcpu+d0wiUzU=;
 b=JKbCLZ2v6B259A9cM/PiP6Qv3tZ8J5FyW6Ne/rydNSmoa+lAXCG1+MVWD5eVH8dKkcsTP15p5cNY4F60nurVRaKc7r7RISLHpJ6ag2WAVmmrvmcDpLFP5btnkV7IlhV32aMpACXqz5E07YgNoa4oh/BKkQoo3PotfoBcXL28xWo8nJ22a8NH7JSoYku7kjrhMn5t9NBJCBPEgkk67KyFqVL/Rw4PKP5hylIIquCn/cuJJD7fUCKhH14t8RT3U96WcMLTcZy+0Ol5PxhuNJdWiUEccQ6r7reS6XCWGgMcB/Mg/jLu4cYA7iREvJq1kDq6ePKyI9ZvnpPabfeC1JuYEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00C7yvUiSw61drLH3nKSkuEhkRj+FBYQcpu+d0wiUzU=;
 b=dC8vAyOoM8MkUZlxwjtnz71lWA53lPOv39I7GeEnN3ZXP1HqKQZRoKnmzEfC5Eqn50Zww6MxreeYZeiHXICyBgK2RU9E41gK5OXdH0ThQCGH8i6vFVSaBBSb0HL0uNsspV95enpJegaDLVtb5DSajXSoVCC3jLI3X2Eciv0h6wA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:06 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:06 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 27/55] staging: wfx: better naming for
 hif_req_join->short_preamble
Thread-Topic: [PATCH v2 27/55] staging: wfx: better naming for
 hif_req_join->short_preamble
Thread-Index: AQHVtPUlIxdb1YHkuU+OJUWlibw5eg==
Date:   Tue, 17 Dec 2019 16:15:05 +0000
Message-ID: <20191217161318.31402-28-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 9581d860-6c3e-4472-9e3c-08d7830c4779
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB420889310FF68DD8E8B64E8B93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(4326008)(8676002)(86362001)(6486002)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kdjzFlrNMrOz1k9EAfgFUjwagve7r+OQLiyC72ZQqTyc0UlF2iLV/3sOZ2hpveiu7VmwjFUCLyr3779LDkJuXoIyT7cG6+hu32VnlV/f87YjEQ93xZXXlhtUZw9JLVLpEy6BUmfrmVgt7tQ3ZQuTu1MFJSDqpVrAMN/mOEx6aEP8+TAym0XmlZaGvwts5QHSOUwKkuiw0HPE0nAlbz6jQOsfQHpvr3HBCGUoOheDfFJtgwa08A3ZfyF7p+Y6uRToviujzavs3slfdGSdZWlXK+YhYinSsDKwza7+EaB4l/XmkntECV8vxUU1i+kouBo67zSeKt4DGk+xvffOQ1Ffchk1u+DxXm975PPKfoZ5ABtG6HsQpc3Mjncrt8PRmwXmNUhlaDCW0CLgFE5dn9COz5o23xAGhmeGaNCa6Jx3TA0Y6KbXZp5D+j3UQjCjS5GY
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C5B07B352ECAC46A3F6198AEC361D19@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9581d860-6c3e-4472-9e3c-08d7830c4779
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:05.9802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ZJEcQzMAMa8MGz3cS7zG2lq9HkGpU8e7pZwWJakTnNouztf92aZrNfFV6U9giJTW6EInbfPQP8W5seWzW3+Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSElG
X1BSRUFNQkxFX1NIT1JUX0xPTkcxMiBpcyBuZXZlciB1c2VkLiBTbyBpdCBpcyBwb3NzaWJsZSB0
byBjaGFuZ2UKInByZWFtYmxlX3R5cGUiIGludG8gYSBib29sZWFuIGFuZCBkcm9wICJlbnVtIGhp
Zl9wcmVhbWJsZSIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5o
IHwgMTYgKysrKysrLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5o
IHwgIDUgKysrLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgICB8ICA2ICsrKy0t
LQogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggZTg0OGJkMzA3M2EyLi5mYzA3OGQ1NGJmYmYg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTM3NywxMiArMzc3LDYgQEAgc3RydWN0
IGhpZl9jbmZfZWRjYV9xdWV1ZV9wYXJhbXMgewogCXUzMiAgIHN0YXR1czsKIH0gX19wYWNrZWQ7
CiAKLWVudW0gaGlmX3ByZWFtYmxlIHsKLQlISUZfUFJFQU1CTEVfTE9ORyAgICAgICAgICAgICAg
ICAgICAgICAgICAgPSAweDAsCi0JSElGX1BSRUFNQkxFX1NIT1JUICAgICAgICAgICAgICAgICAg
ICAgICAgID0gMHgxLAotCUhJRl9QUkVBTUJMRV9TSE9SVF9MT05HMTIgICAgICAgICAgICAgICAg
ICA9IDB4MgotfTsKLQogc3RydWN0IGhpZl9qb2luX2ZsYWdzIHsKIAl1OCAgICByZXNlcnZlZDE6
MjsKIAl1OCAgICBmb3JjZV9ub19iZWFjb246MTsKQEAgLTM5Nyw5ICszOTEsMTAgQEAgc3RydWN0
IGhpZl9yZXFfam9pbiB7CiAJdTE2ICAgY2hhbm5lbF9udW1iZXI7CiAJdTggICAgYnNzaWRbRVRI
X0FMRU5dOwogCXUxNiAgIGF0aW1fd2luZG93OwotCXU4ICAgIHByZWFtYmxlX3R5cGU7CisJdTgg
ICAgc2hvcnRfcHJlYW1ibGU6MTsKKwl1OCAgICByZXNlcnZlZDI6NzsKIAl1OCAgICBwcm9iZV9m
b3Jfam9pbjsKLQl1OCAgICByZXNlcnZlZDsKKwl1OCAgICByZXNlcnZlZDM7CiAJc3RydWN0IGhp
Zl9qb2luX2ZsYWdzIGpvaW5fZmxhZ3M7CiAJdTMyICAgc3NpZF9sZW5ndGg7CiAJdTggICAgc3Np
ZFtISUZfQVBJX1NTSURfU0laRV07CkBAIC00NjIsOCArNDU3LDkgQEAgc3RydWN0IGhpZl9yZXFf
c3RhcnQgewogCXUzMiAgIHJlc2VydmVkMTsKIAl1MzIgICBiZWFjb25faW50ZXJ2YWw7CiAJdTgg
ICAgZHRpbV9wZXJpb2Q7Ci0JdTggICAgcHJlYW1ibGVfdHlwZTsKLQl1OCAgICByZXNlcnZlZDI7
CisJdTggICAgc2hvcnRfcHJlYW1ibGU6MTsKKwl1OCAgICByZXNlcnZlZDI6NzsKKwl1OCAgICBy
ZXNlcnZlZDM7CiAJdTggICAgc3NpZF9sZW5ndGg7CiAJdTggICAgc3NpZFtISUZfQVBJX1NTSURf
U0laRV07CiAJdTMyICAgYmFzaWNfcmF0ZV9zZXQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl9hcGlfbWliLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgK
aW5kZXggOTRiNzg5Y2ViNGZmLi4zNGU0MzEwYWQ3MWYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX2FwaV9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlf
bWliLmgKQEAgLTQ3MSw4ICs0NzEsOSBAQCBzdHJ1Y3QgaGlmX21pYl9zZXRfYXNzb2NpYXRpb25f
bW9kZSB7CiAJdTggICAgbW9kZToxOwogCXU4ICAgIHJhdGVzZXQ6MTsKIAl1OCAgICBzcGFjaW5n
OjE7Ci0JdTggICAgcmVzZXJ2ZWQ6NDsKLQl1OCAgICBwcmVhbWJsZV90eXBlOworCXU4ICAgIHJl
c2VydmVkMTo0OworCXU4ICAgIHNob3J0X3ByZWFtYmxlOjE7CisJdTggICAgcmVzZXJ2ZWQyOjc7
CiAJdTggICAgbWl4ZWRfb3JfZ3JlZW5maWVsZF90eXBlOwogCXU4ICAgIG1wZHVfc3RhcnRfc3Bh
Y2luZzsKIAl1MzIgICBiYXNpY19yYXRlX3NldDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDIzZWM3YTRhOTI2
Yi4uZTVjOTMzNjc4YzQ3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTY1Miw3ICs2NTIsNyBAQCBzdGF0aWMg
dm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAlzdHJ1Y3QgY2ZnODAyMTFf
YnNzICpic3MgPSBOVUxMOwogCXN0cnVjdCBoaWZfcmVxX2pvaW4gam9pbiA9IHsKIAkJLmluZnJh
c3RydWN0dXJlX2Jzc19tb2RlID0gIWNvbmYtPmlic3Nfam9pbmVkLAotCQkucHJlYW1ibGVfdHlw
ZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZSA/IEhJRl9QUkVBTUJMRV9TSE9SVCA6IEhJRl9Q
UkVBTUJMRV9MT05HLAorCQkuc2hvcnRfcHJlYW1ibGUgPSBjb25mLT51c2Vfc2hvcnRfcHJlYW1i
bGUsCiAJCS5wcm9iZV9mb3Jfam9pbiA9IDEsCiAJCS5hdGltX3dpbmRvdyA9IDAsCiAJCS5iYXNp
Y19yYXRlX3NldCA9IHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwKQEAgLTg0Myw3ICs4
NDMsNyBAQCBzdGF0aWMgaW50IHdmeF9zdGFydF9hcChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAkJ
LmNoYW5uZWxfbnVtYmVyID0gd3ZpZi0+Y2hhbm5lbC0+aHdfdmFsdWUsCiAJCS5iZWFjb25faW50
ZXJ2YWwgPSBjb25mLT5iZWFjb25faW50LAogCQkuZHRpbV9wZXJpb2QgPSBjb25mLT5kdGltX3Bl
cmlvZCwKLQkJLnByZWFtYmxlX3R5cGUgPSBjb25mLT51c2Vfc2hvcnRfcHJlYW1ibGUgPyBISUZf
UFJFQU1CTEVfU0hPUlQgOiBISUZfUFJFQU1CTEVfTE9ORywKKwkJLnNob3J0X3ByZWFtYmxlID0g
Y29uZi0+dXNlX3Nob3J0X3ByZWFtYmxlLAogCQkuYmFzaWNfcmF0ZV9zZXQgPSB3ZnhfcmF0ZV9t
YXNrX3RvX2h3KHd2aWYtPndkZXYsCiAJCQkJCQkgICAgICBjb25mLT5iYXNpY19yYXRlcyksCiAJ
fTsKQEAgLTk5NCw3ICs5OTQsNyBAQCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAlhc3NvY2lhdGlvbl9tb2RlLm1vZGUgPSAxOwogCWFzc29jaWF0
aW9uX21vZGUucmF0ZXNldCA9IDE7CiAJYXNzb2NpYXRpb25fbW9kZS5zcGFjaW5nID0gMTsKLQlh
c3NvY2lhdGlvbl9tb2RlLnByZWFtYmxlX3R5cGUgPSBpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGUg
PyBISUZfUFJFQU1CTEVfU0hPUlQgOiBISUZfUFJFQU1CTEVfTE9ORzsKKwlhc3NvY2lhdGlvbl9t
b2RlLnNob3J0X3ByZWFtYmxlID0gaW5mby0+dXNlX3Nob3J0X3ByZWFtYmxlOwogCWFzc29jaWF0
aW9uX21vZGUuYmFzaWNfcmF0ZV9zZXQgPSBjcHVfdG9fbGUzMih3ZnhfcmF0ZV9tYXNrX3RvX2h3
KHd2aWYtPndkZXYsIGluZm8tPmJhc2ljX3JhdGVzKSk7CiAJYXNzb2NpYXRpb25fbW9kZS5taXhl
ZF9vcl9ncmVlbmZpZWxkX3R5cGUgPSB3ZnhfaHRfZ3JlZW5maWVsZCgmd3ZpZi0+aHRfaW5mbyk7
CiAJYXNzb2NpYXRpb25fbW9kZS5tcGR1X3N0YXJ0X3NwYWNpbmcgPSB3ZnhfaHRfYW1wZHVfZGVu
c2l0eSgmd3ZpZi0+aHRfaW5mbyk7Ci0tIAoyLjI0LjAKCg==
