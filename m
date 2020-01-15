Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6F13C48A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgAOOAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:00:10 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729505AbgAONyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b89zrAxxqyI7YeNKQhi+CF1EfL9rgIMi23rb570wXvqclOFHVg8BUE/ygkGPKdVVYDjAQ0ODHgyVTjrZ1tS0SeJ1JtiaOAbZPg4OdqBo6zF8SbXIUuQQFgpqWnJwqVohTzQE5+0bk9eG+i6s0D82yuol4x3d/F4vi8toqzaNp6byMSZcUy/oe0IPIEVkY8EudMz7CAvvbbb3StZQ/AjTEgi665a+wWn0ZVhsxRganzDaVrBsxOww+A/1aZlqw2wsEu4nXWKjfv0AEaetDZbimbZvMGN+uEfluptAElHR8cLdOpfY2+7AxqyA8mFAFn7eI8ThyiSRy8FEtRWBEFxNDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2ETDyqVciDrVTsElmWoRWuQT1mIpukmooLN9gH5YIg=;
 b=ghn/ePOBuV9ZYhWeFB38ZD4D5DGChAqYb41mW3HbG7L83KjGekJ90E26gNpyV1pmFUJoVCq0/zzgOihHeiPajyJ6JWm74caOH5tf/E/PRuDSfYSQM2FktIbhkGBI9wyPpDDuCmm8+AXtf7q2Co13u6wK1QNlAytYWtIq8p5/gB116HixiY3QrhGiPAfwvaKX6KOkxKcLtlCRbk9N7evjmbmw6abGPA+qv3ksHJO5/vqpfo3GVCSygrtRitkudD3OFRZcDamkk48mGwUkL9H09n6vgfXajkTOneSiSJNebjJSIYVggQl1G5GLkWsza6mvKxtHtb34RAKBGTL3ESFgGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2ETDyqVciDrVTsElmWoRWuQT1mIpukmooLN9gH5YIg=;
 b=A0BHqJxAKTXmLiJKpfO4APM7cgMqEJnQMTPvvjiNtI0MzmqH/LMKBYDS/6flG90XmOxst7YW+RDyOfvlk3/b8/oxYn1HvU92SCh9D+HOPkXXxv304/QJs+Jtkj5cfaJ5NwYdHGGi/75EItB/KwoP0KnlBd/2q6wG6NBBh6Njtjk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:30 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:29 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 20/65] staging: wfx: simplify wfx_flush()
Thread-Topic: [PATCH v2 20/65] staging: wfx: simplify wfx_flush()
Thread-Index: AQHVy6tPXDDCxzgink2P+uB/DsLkqQ==
Date:   Wed, 15 Jan 2020 13:54:30 +0000
Message-ID: <20200115135338.14374-21-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8c1ef2cc-c5d2-46b9-faaa-08d799c2718c
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40946AF2D9CFDDBF09F8110B93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(6666004)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQ6WGLr+WSDLKZeXVROcmb3LD6lbE8c0JqASfNMlYO/70WwfTLNlpdyJ17SfFxwPV6oLTedP8I6WtUGXMw49pO4ZEsDWFlFDF56czpKSL6AaEOIeJiZSVNAThWVxa/Z09VTmG/LdyConVdHQbZ/3SpxKdH76lOleFIKvOyhD0RaDjcZhVaR9h6jKplfdVPc+pCUF87JlC35Vf4JVDKFOERLijcCKdL8P9S2cdt/Y6X3CTBMlBfSo2hrqeo/tj/nL7NKobEA8ZETqvJr3e24yUzPNWB12x4kmApZqb+aAU8+a7WoedpPod+RyQ5e6aZ6R2N+RBBEPmOGyqr64IMSHtvJPBap9AfZ8yfZoqBJ5qaxNrUTfE332yuPkVrT2ZgnQrygvhmNJAmN1tGdEVLBwgzKszSPXTEvQbnYc9OEtE25mWVe5F4coNQC4pIJq6L1B
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A2F20680412E2468A6FE0BBE067C37F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1ef2cc-c5d2-46b9-faaa-08d799c2718c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:30.5733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p68uYygqgZlJMBcI/NxPR5DRIYgur5QkQ+FZOFeuQsh37+59rdgL+CMVKfljfDTvnpTbQF47em7dSNUKEZixOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIG9mIHdmeF9mbHVzaCgpIGZvcmNlIHRvIGRyb3AgcGFja2V0cyBpbiBzb21lIGNv
bnRleHRzLgpIb3dldmVyLCB0aGVyZSBpcyBubyBvYnZpb3VzIHJlYXNvbnMgdG8gZG8gdGhhdC4g
SXQgbG9va3MgbGlrZSBhCndvcmthcm91bmQgZm9yIGEgYnVnIHdpdGggdGhlIG9sZCBpbXBsZW1l
bnRhdGlvbiBvZiBfX3dmeF9mbHVzaCgpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgfCAxMiArLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggM2Q2NjVlZWY4YmE3Li5hZTAxZjdiZTBk
ZGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtMzYyLDE3ICszNjIsNyBAQCBzdGF0aWMgaW50IF9fd2Z4X2Zs
dXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBib29sIGRyb3ApCiB2b2lkIHdmeF9mbHVzaChzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICB1MzIg
cXVldWVzLCBib29sIGRyb3ApCiB7Ci0Jc3RydWN0IHdmeF92aWYgKnd2aWY7Ci0KLQlpZiAodmlm
KSB7Ci0JCXd2aWYgPSAoc3RydWN0IHdmeF92aWYgKikgdmlmLT5kcnZfcHJpdjsKLQkJaWYgKHd2
aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9NT05JVE9SKQotCQkJZHJvcCA9IHRydWU7
Ci0JCWlmICh3dmlmLT52aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfQVAgJiYKLQkJICAgICF3
dmlmLT5lbmFibGVfYmVhY29uKQotCQkJZHJvcCA9IHRydWU7Ci0JfQotCS8vIEZJWE1FOiBvbmx5
IGZsdXNoIHJlcXVlc3RlZCB2aWYKKwkvLyBGSVhNRTogb25seSBmbHVzaCByZXF1ZXN0ZWQgdmlm
IGFuZCBxdWV1ZXMKIAlfX3dmeF9mbHVzaChody0+cHJpdiwgZHJvcCk7CiB9CiAKLS0gCjIuMjUu
MAoK
