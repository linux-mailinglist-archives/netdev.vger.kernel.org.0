Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC81613C492
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgAONyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:46 -0500
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:11386
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729429AbgAONyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fm7iusfI6Mzi60Jl8ybrwIb3uDLg25pQiUJ92dA/jGm4/gdHWikwAjnvEsBx4ZQ9/jxL9fYnU1T+13LzXT1E6DXunOSWt25alqWzQvm4Gg9Lrmfex3KrCEnn3vKkwTesyuVttCGi68qko1qqtKRH//quH1uaHXZVE7+rSoDwwIUVVlcr/F6HhcrQUbgHNziXncfS7ECbgfRbHDjChXiDuY/tVefTXzIk2DIpkv2nhF1lbD6YX0NQzhgC2OZQuZ6qCw65hlpP6qHEfUO2A38kuoOrupcVlRHws4a9iHnmaRwonrIh+NiAcWTkAXLOV45E5tESEQZhcmy9jvw/9vKgHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvHPtKXlsvQwnf5lOZyIuOjtMJUoc4RQcmbJFZUNCiI=;
 b=TmSo6KUDXR9RDOmhtaExHsd/SJyofv2y7DEBx77Ug7jnCmtURLvG3mczQ3c1X3LGNM/cC9r+AjUE97HXmdEffupNqoM/mTyJqoMc0Ia7g3/BZI8gptIwB0tZlIFwMjCEy6mn22k2+FFSPCB40tj1v1s9sVwgS28WlIwE4IKXqh5VwKs3lYCKpSSf0S490zq51+LhnQfWHy5K8eTfb/3wE+iWIiIDpU+ELcXWOgVkQddNPtZnu9PvZ2sUUf9vNyK0qLNQrIseq/U45kWisTS0FQ/EOYKYqQR/TxuXlCtBGVSrExlPalHdJ8nHP1jPEK7wz28zlQHxD38R3C/d3nJo+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvHPtKXlsvQwnf5lOZyIuOjtMJUoc4RQcmbJFZUNCiI=;
 b=irGfdVdYb4jII7Su0ytA0nePKPeIVBfdU2gXi/u4uuca8hG+aKA9cRmNLnZgd17w3JjSwxWck/nTcfQjrFe3cKCwMc8w1WJNahZGjHw21Fx32LSY2FxREnKJ9hfut6fFuL5nK0U39/XOK0xi998/iqXfwClG/o16g2+6GSJdD/g=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:41 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:40 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 27/65] staging: wfx: SSID should be provided to hif_start()
 even if hidden
Thread-Topic: [PATCH v2 27/65] staging: wfx: SSID should be provided to
 hif_start() even if hidden
Thread-Index: AQHVy6tVShBVmGdqoESyrnrSwKo/9A==
Date:   Wed, 15 Jan 2020 13:54:41 +0000
Message-ID: <20200115135338.14374-28-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 31461766-a2a7-473a-e0f8-08d799c2783b
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661E000478AD5ADF637C8EB93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(4744005)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aA0ccgOx3OJ+ynD/AeqX1uCbS5dPxbqmzQ5oMeBr8pgo5AhEpTzlgJsCuHkT6oWjrkZqOVws0SZJyBZB2AX2IKWLGeoesS7YvNKVE0GKrIRBYQCQ1pIy/ra9Zl8A+9vn12jDr6An0SBmJ59gfDraqeJOn9gg8DAI3mhIHMKG9IE/FYGJMdka4/aPT97sLHJrORKAlWrKcOPufDJDDkb+VoM4MHKMMTNCVLy753GRxqBzqEPijxbW4cAoEgH3toOB2RQYsGM6K7l37HZNeePFUOT80LTFmMclfDXgsfN/wLZMszi1bn9trW3b2r1WYAS5iYtCMZS1svK/xvmUZqD1/e2p0LRyL4wHYZmeusV/Nf/rSCOcvTA97/yZh1ckLCLnoGpRyQpaDJJ18XLbIM0sYWZxNWQcLjiClPMjL2nppwwGPoIKO6iXhbVEO+Bdk3oI
Content-Type: text/plain; charset="utf-8"
Content-ID: <D999B44CAA344440B9355B3C1C8A12CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31461766-a2a7-473a-e0f8-08d799c2783b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:41.8048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBl9fXIdojjcEeR0pHbcuoxBA9w7QdqdCEtM+bWVA2hT8LOKkUpm9LMPXM7nGnpOL1YenWdCU2zoX1RyEEdeSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU1NJ
RCBpcyBoaWRkZW4gaW4gYmVhY29uIGJ1dCBmaXJtd2FyZSBoYXMgdG8ga25vdyB0byB3aGljaCBw
cm9iZQpyZXF1ZXN0cyBpdCBoYXMgdG8gYW5zd2VyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgfCA2ICsrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCAyZDU0MTYwMWUyMjQuLjhk
ZjZlNDNmZTc0MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC00MjIsMTAgKzQyMiw4IEBAIGludCBo
aWZfc3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNz
X2NvbmYgKmNvbmYsCiAJYm9keS0+YmVhY29uX2ludGVydmFsID0gY3B1X3RvX2xlMzIoY29uZi0+
YmVhY29uX2ludCk7CiAJYm9keS0+YmFzaWNfcmF0ZV9zZXQgPQogCQljcHVfdG9fbGUzMih3Znhf
cmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIGNvbmYtPmJhc2ljX3JhdGVzKSk7Ci0JaWYgKCFj
b25mLT5oaWRkZW5fc3NpZCkgewotCQlib2R5LT5zc2lkX2xlbmd0aCA9IGNvbmYtPnNzaWRfbGVu
OwotCQltZW1jcHkoYm9keS0+c3NpZCwgY29uZi0+c3NpZCwgY29uZi0+c3NpZF9sZW4pOwotCX0K
Kwlib2R5LT5zc2lkX2xlbmd0aCA9IGNvbmYtPnNzaWRfbGVuOworCW1lbWNweShib2R5LT5zc2lk
LCBjb25mLT5zc2lkLCBjb25mLT5zc2lkX2xlbik7CiAJd2Z4X2ZpbGxfaGVhZGVyKGhpZiwgd3Zp
Zi0+aWQsIEhJRl9SRVFfSURfU1RBUlQsIHNpemVvZigqYm9keSkpOwogCXJldCA9IHdmeF9jbWRf
c2VuZCh3dmlmLT53ZGV2LCBoaWYsIE5VTEwsIDAsIGZhbHNlKTsKIAlrZnJlZShoaWYpOwotLSAK
Mi4yNS4wCgo=
