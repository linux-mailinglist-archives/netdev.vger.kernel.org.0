Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6386713C476
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgAONz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:26 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729813AbgAONzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVo1oVyWM9IF4fqn5vtIvcqIaICzUSPhCgLlkSauIAFJKPuTbUnh1bK4RuIcmsQNjtyHWe/7V8SMreQEbxlyz8kt9gR/ePopdtfj/Mw4As+cZEc6M9kUOMeCyOlJ8WFlP9mcdYjgvXXLkU7ka0TQqefZib+B0n9yyfKBRq/stib9AL5dyTZ3OxABOXi1oyFDwBbECRYt53/zfQo6t9QMUT27kCUVel+xBD/l7dOlq9693gMBLDUW9fsdqO6L3C5Xxr0KQtI0bq3QPh/aNnvlnjF5I9FHxDdmQ3Z7zHTj7XKXHXztSfzK+NTZtpqytC5PmtIW0rQ5TNySDnCUMROQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2/Jm6w1JZAbFd2GIhM4GZMXqZt/BV+Jj6ZkQwLi2xk=;
 b=LbnlVUMoqLqLbDHhCC0CkBGrb/nhSgDPGYe6WS/LGeKEu8DYBhY9+EZuHDICwsC4CDexkvP5mfEIBfwpeALX5EVAP/I3A+dKIK4xUxp1/RywrOXr3f3tUk5TwwjWBDt301b3cOungfglwzaGBOt4ITSpyukDfRN0tApTXGoG22L0dyJzaNggDuB75UFDgFjW6hPXsBOJoY71D4a/pDPrzUmC4JgssbmisfBbGJKRtAtwYlrlNbzrJJK8Z1jmR2Fj7aYim9B5tC8Oy1DhRm6Tk2WeX9uf74AMMOKwr4RAN80mB7N1W+MV+X5ubtLQ0+EirmeFLQ/ovs/COjIztltfTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2/Jm6w1JZAbFd2GIhM4GZMXqZt/BV+Jj6ZkQwLi2xk=;
 b=DExnBvljHNaKwAAJL+qPVRD1fiQOZWj4GOFWCSj9TIDTbg9yzjzOd/9Yk8pfxgFg3RDUoLfh7vdP3Fkjv0V6KE9JEclh6zCwwjpdeK9u/m0eTrdOK1bn13xmHmx7/kDUcJcUPrxef66i/Ive40wZoYQilXUZcukYjyVErRc0Clc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:18 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:18 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:50 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 33/65] staging: wfx: simplify hif_mib_set_data_filtering
Thread-Topic: [PATCH v2 33/65] staging: wfx: simplify
 hif_mib_set_data_filtering
Thread-Index: AQHVy6tbuB7e0lz3BkWa3Nsca80jng==
Date:   Wed, 15 Jan 2020 13:54:51 +0000
Message-ID: <20200115135338.14374-34-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 360623ee-eb74-4eb3-74a9-08d799c27df8
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661070317572856F731D67B93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8T5jRbU115IgsB8U5jreb5sAEuritn5gAhMbWZK4LQ/3ekr9Pc84Tga7fpR4NmMA1vxLUWURUix33fuyXDiqWaZYybLPZvqf0fIytpHRYFoobQWJVYLseKjWbu6e+8xisNh4lzYLByfYl1xZBhxSkwvtxTSSAxJu/xbhGMcLlbdUkxJ0c3bvrxDe09gJ/RsMTm8esjvFP+3cJDiPu5uEcRQBcTCPVwk3DRG6w8r6ST7e7T1DerNbNXl1hOH3K4QobSY2GuPWTS2Ep2a87S8qx78SludgCE1lwh1mmB2Ks4T8rJAmP0oAZx3kl6ZPis4hKNuv3kz1+Li3i14fWjOBLdsfjLZeMkjlzHLBVQ7a4T/RWMPv++T9QqSwL1G5SPx82cMSJfTadFno/W+It19JcRTP3gDRtfrkPYZAL6TRrw5FrM0nL9pIH5/2DQmquKBt
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BC2593D25EE0640A3B26980B322F012@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360623ee-eb74-4eb3-74a9-08d799c27df8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:51.4153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+3Eb27hUyNJXaw4Qfq1FveKhse1JlUSIp4ELQd8CPdkSo2wl8Ew3H4yMYEqEHSNl5LpG3s2KS9wfRxwtjxzww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
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
