Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D748113C011
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgAOMRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:17:39 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:6048
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731124AbgAOMN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pn/FMUccoWhlTyXuaS4IOqRdA8EkoUmzG/Y2d+ULevHUorhDGu/gQTg/mr4IeBUVdi+pnV3JF7VueKinVHKMMcqaLk1IvHaOEBTySeapbvXNSdtPrsIquG8LrURAj5kulVe+NxoZTaA5v5SsowGmYpx112rNM3EgDtylYAkD4xgOvMDIYwSvWVGlLV7MHHK0lAWs2mybrVecrkCSEKr2RvpIIOKtFBt1nsMGsw5Ewc+msWEpNLR950hU0ZBm+VQ33K/jrb1nvgbfDS0xLEjBuivR2Gaw20yNu4rxCcAroaEyMCc5WIb5CPTtnOXXcImPNnH3SIjs/m7Bn1E2SVEbng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2/Jm6w1JZAbFd2GIhM4GZMXqZt/BV+Jj6ZkQwLi2xk=;
 b=Mt7ZBONgR7sz6eX1RBSPcxXdRI2Kkj4mZXPLBR1HmV1c1b3C/ir+MdM9hprwjVAgQgXn7at0+LVEHvhChgbWJ5l9Cn3fFfQ+zuHUCzKYcj9Und7INBybVWJa3hf1kcI/u49OW/9F9oqN9koLOpHfbk7IFLXwm1CIAynvlSq7O1U+EbLPHaEnL8gRiACvMsfaveetKCZfULKqTAnoUgPoY9DK2w/dPGQODSSRogua91dpSVAB1B2RC7Vs1URZl3GNol7JSDhJlG/QlqQxuRuySktWJCi4kl9K7nYWjwvQdwmZmyRSlR1dMz5o7O6DzVhWELjiFi3xVOQGNU/Q7h78Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2/Jm6w1JZAbFd2GIhM4GZMXqZt/BV+Jj6ZkQwLi2xk=;
 b=bAu4YljaYh8T2MHPAMWFXxB3ixM2Doc4/cXWIJXpj+k8GjRAi8fqwMZX5kalhbgXxlHqo80kh5+xlLiRGSmflmHgrmS0eFtaOF+CMoXvuclI23Z44/EXlisKSgrkckJq7qhyrgiZBoz79EkCsr8gNHKr5qa5xb1stqUYVYHFpbk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:21 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:21 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:52 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 33/65] staging: wfx: simplify hif_mib_set_data_filtering
Thread-Topic: [PATCH 33/65] staging: wfx: simplify hif_mib_set_data_filtering
Thread-Index: AQHVy50c0vdkJWjWbU+56y4sJ/OM1g==
Date:   Wed, 15 Jan 2020 12:12:53 +0000
Message-ID: <20200115121041.10863-34-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 312ec85e-983a-46c0-3f92-08d799b43f3a
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096095CC2320C8F1D9B5E5F93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o54hdyBVLjzMCmRmesKdVVZ4yRXsqA+GQKtwPIaK021FswYsw7Fy0RfGcSjVzbrlZrbptqTX1WBXODAfv26Kc4HDEIaugzQCpKsU6YlnJHXRwB401A+y//CSb+OQuf5Nv+wDB1acD986yWjKz+cJjc5UcoaMP3mnKYcYM5lyCuhLJWMX+YBO4VV/A9hc+dHqe+A9iLIHBqSA8nNMjCedjfcHcwtBuZSNl81h2sD+zipsDycwdmuDBGBjC/BPATnHmaZurTVYbgyS8ABJmO8WGz4liyOstyktF75ZRs/y1oZN9CV6Z6iwUys1ZoQWWaYWzquwb3OIjngkZSLCwbYwVRA7mNWDoe7OgOq4XP+U0/HnqU1I/ACSdNZ4oFDffDq0JNHD8HVc8D3j+1th/A98ZOEog8EH4vEO2AZVXk6vKOthVS7SbNC9rmIOUwdx3wBi
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F6F0D71D8A3A64DA79AA88675271063@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312ec85e-983a-46c0-3f92-08d799b43f3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:53.1848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZPvBcMgLcdDtDXmzCqaHjT4RsrTI2aWqFW/kAQ9ohwhezmqJEOO9GV2Ib4DJXZ97DbOnUYN7aQl+Tq5y2AFClQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJkZWZhdWx0X2ZpbHRlciIgd2FzIG5vdCBvYnZpb3VzLgoKSW4gYWRkLCBleHBsaWNp
dGx5IGRlY2xhcmUgdGhhdCBmaWVsZHMgZGVmYXVsdF9maWx0ZXIgYW5kIGVuYWJsZSBhcmUKYm9v
bGVhbnMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oIHwgOCAr
KysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAgIHwgMyArLS0KIDIgZmls
ZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9taWIuaAppbmRleCBlMGVmMDMzN2UwMWMuLjBjNjdjZDRjMTU5MyAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9taWIuaApAQCAtMjA2LDkgKzIwNiwxMSBAQCBzdHJ1Y3QgaGlmX21pYl9j
b25maWdfZGF0YV9maWx0ZXIgewogfSBfX3BhY2tlZDsKIAogc3RydWN0IGhpZl9taWJfc2V0X2Rh
dGFfZmlsdGVyaW5nIHsKLQl1OCAgICBkZWZhdWx0X2ZpbHRlcjsKLQl1OCAgICBlbmFibGU7Ci0J
dTggICAgcmVzZXJ2ZWRbMl07CisJdTggICAgaW52ZXJ0X21hdGNoaW5nOjE7CisJdTggICAgcmVz
ZXJ2ZWQxOjc7CisJdTggICAgZW5hYmxlOjE7CisJdTggICAgcmVzZXJ2ZWQyOjc7CisJdTggICAg
cmVzZXJ2ZWQzWzJdOwogfSBfX3BhY2tlZDsKIAogZW51bSBoaWZfYXJwX25zX2ZyYW1lX3RyZWF0
bWVudCB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCAxYzFiNWE2YzI0NzQuLjI3MjQ4ZWE2MmFlYSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCkBAIC0xNTQsOSArMTU0LDggQEAgc3RhdGljIGludCB3Znhfc2V0X21jYXN0X2ZpbHRl
cihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAlpZiAocmV0KQogCQlyZXR1cm4gcmV0OwogCi0JLy8g
ZGlzY2FyZCBhbGwgZGF0YSBmcmFtZXMgZXhjZXB0IG1hdGNoIGZpbHRlcgogCWZpbHRlcl9kYXRh
LmVuYWJsZSA9IDE7Ci0JZmlsdGVyX2RhdGEuZGVmYXVsdF9maWx0ZXIgPSAxOyAvLyBkaXNjYXJk
IGFsbAorCWZpbHRlcl9kYXRhLmludmVydF9tYXRjaGluZyA9IDE7IC8vIGRpc2NhcmQgYWxsIGJ1
dCBtYXRjaGluZyBmcmFtZXMKIAlyZXQgPSBoaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsICZm
aWx0ZXJfZGF0YSk7CiAKIAlyZXR1cm4gcmV0OwotLSAKMi4yNS4wCgo=
