Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B5613C3F9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgAONzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:46 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730114AbgAONzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jg/G1kJ/FvBKAZ56mUw2RK5msUTVZ9WfgvWuLoWK06J8DwwZSMlALG0u1wmGyf8uDQh/DoJTtFAKTku7R5NQPXz2QIS7jGhyl+8WL8meKR+X/wzH3DeH0kWaZbDCISyXGR269lvC5/NSZkY9pj+WEUNINZ+nCEV3pdGc8pOmhEFkRlVW3HWvCzYR03OXX2YJzDdoUoHpqEGlKOy6WOl5qvBCzJ+5i4k96GollciLP1riP59pjXYkAlkwrw2N3e3PyV5CZgi6s0elNzZ7f08nGh2AMbP3ja9jegl6ZrKu5ai/4SNx+GTISXvOs0Gq0iCz2s13xrXHVlgctaD4koKWJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lC91FItTpe1pbxs0PlU7shB+j+DUCASaB32KIkS3tIM=;
 b=fGtEpuxeIkOb5yP5rz8ZCchBguQoYx5zvBnfUhmSI5WhCCxAJU4/PDdlhyifVkNlp8W+SMemiiDBud1pUqRQKxRcXbwPosDCEeppbxDSayxBatil41/r2lI5QPPvsHGpt8kEtSpxOH0Ui0G+GV1cW8hQsQYO2UXQh7GpYl18JjEP6csLF50jZohUhU0mxpA/vTNHrinEJvewHqsUC4X/fYGkRQ83Lcx1mG5NUwAPE/U9z6gTLWKw+HFx0+CcANTfZryJFEnpaIEZJ4SgJh2k1uFhRY8TCYdK4qFc40OjHpvGepqpZnMGQWoqM8JH5dYq6dUNnUfNTW8dqWxMxb4dGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lC91FItTpe1pbxs0PlU7shB+j+DUCASaB32KIkS3tIM=;
 b=dPs7ThajAuFj1vNrQZTI9pwmunYaejln+3afJYWwpYKaEo+nZ9r+tENzYMGuYreykCaJr5mgp6k7UH6RzhIHzzkO1HjRXJZ1emro3dzXP2N0Z+JDCqx33XWAj6QB6tOc/TnljIWP0lNyyW5g+cwd7+uJk9kgsp7my5CeTK5O6Ps=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:28 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:17 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 52/65] staging: wfx: replace wfx_tx_get_tid() with
 ieee80211_get_tid()
Thread-Topic: [PATCH v2 52/65] staging: wfx: replace wfx_tx_get_tid() with
 ieee80211_get_tid()
Thread-Index: AQHVy6trofdSPgT4oky+6Y0lpY6dQw==
Date:   Wed, 15 Jan 2020 13:55:18 +0000
Message-ID: <20200115135338.14374-53-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d8b88b17-c288-48f3-3542-08d799c28de9
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40945459A8E966524D5F887193370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: miR1ssjXm3ii7ddUCMFY6o0GOzr3Nlg1oFqVZceOr9YRrrYG2zzSeYzpVoCT4HNJEbO+PhNvk3LepJrcWVD0CGjet9/VuHx+k35226WNwe9fhxoB8Z2zO9NKWTetW1E+mLokjhxb+FhXaeyNZxqR3nMbSyBgr8Rvb+eEVrFS8PY1rxJnbLv2fSbq7DlOvqBuJAgUKm4j0QkudhunFBs28ED9dLOR+IgWRqbO0DsBeG+85J5FuQLOHq58JK0RKV9kEKYMLA9ArE5vFNs78Y/Pnk7qoPbrZqr+N82/UpWxqCjO7fbIdoTzxb5Q7qjkkk1QEbM0a9dD7Psd+3zvPZ6UJr3M3Ztb9XLMrrxOPeqI8fQXnlZl7/VF3eu6lWClz7XM3X7L4wlJ6osQtyXNpwIpti67rTw9p/Iw3ftIdSJwqRhFjmZYKzLhT3/QBRSStATH
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1659D4B6F35D044B1A048DD57B2D27E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b88b17-c288-48f3-3542-08d799c28de9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:18.1669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWfbmJHzqd+dwlHxLuMdXd/9Uuw+7CTzgInmW6b+uHS1wnP+6fzUPBbiIvM2p+Hkcm9GsNIu+3SOSaxJ//E3Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X2dldF90aWQoKSB3YXMgdXNlZCBhcyBhIHdyYXBwZXIgYXJvdW5kIGllZWU4MDIxMV9nZXRf
dGlkKCkuIEl0CmRpZCBzb21ldGltZSByZXR1cm4gV0ZYX01BWF9USUQgdG8gYXNrIHRvIHVwcGVy
IGxheWVycyB0byBub3QgaW5jbHVkZQp0aGUgZnJhbWUgaW4gImJ1ZmZlcmVkIiBjb3VudGVyLiBU
aGUgb2JqZWN0aXZlIG9mIHRoaXMgYmVoYXZpb3IgaXMgbm90CmNsZWFyLCBidXQgdGVzdHMgaGFz
IHNob3duIHRoYXQgd2Z4X3R4X2dldF90aWQoKSBjYW4gYmUgcmVwbGFjZWQgYnkKaWVlZTgwMjEx
X2dldF90aWQoKSB3aXRob3V0IGFueSByZWdyZXNzaW9ucy4KCkJUVywgaXQgaXMgbm90IG5lY2Vz
c2FyeSB0byBzYXZlIHRoZSB0aWQgaW4gdHhfcnBpdiBzaW5jZSBpdCBjYW4gYmUKcmV0cmlldmVk
IGZyb20gdGhlIDgwMi4xMSBoZWFkZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmMgfCAyMyArKysrKystLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3R4LmggfCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICB8ICAyICst
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgICB8ICA1ICstLS0tCiA0IGZpbGVzIGNoYW5n
ZWQsIDggaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpp
bmRleCA4YzlmOTg2ZWM2NzIuLjdkYTFhZmQ2ZTliNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAg
LTI4Myw2ICsyODMsNyBAQCBzdGF0aWMgdm9pZCB3ZnhfdHhfbWFuYWdlX3BtKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyLAogewogCXUzMiBtYXNrID0gfkJJ
VCh0eF9wcml2LT5yYXdfbGlua19pZCk7CiAJc3RydWN0IHdmeF9zdGFfcHJpdiAqc3RhX3ByaXY7
CisJaW50IHRpZCA9IGllZWU4MDIxMV9nZXRfdGlkKGhkcik7CiAKIAlzcGluX2xvY2tfYmgoJnd2
aWYtPnBzX3N0YXRlX2xvY2spOwogCWlmIChpZWVlODAyMTFfaXNfYXV0aChoZHItPmZyYW1lX2Nv
bnRyb2wpKSB7CkBAIC0yOTgsMTEgKzI5OSwxMSBAQCBzdGF0aWMgdm9pZCB3ZnhfdHhfbWFuYWdl
X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyLAogCX0K
IAlzcGluX3VubG9ja19iaCgmd3ZpZi0+cHNfc3RhdGVfbG9jayk7CiAKLQlpZiAoc3RhICYmIHR4
X3ByaXYtPnRpZCA8IFdGWF9NQVhfVElEKSB7CisJaWYgKHN0YSkgewogCQlzdGFfcHJpdiA9IChz
dHJ1Y3Qgd2Z4X3N0YV9wcml2ICopJnN0YS0+ZHJ2X3ByaXY7CiAJCXNwaW5fbG9ja19iaCgmc3Rh
X3ByaXYtPmxvY2spOwotCQlzdGFfcHJpdi0+YnVmZmVyZWRbdHhfcHJpdi0+dGlkXSsrOwotCQlp
ZWVlODAyMTFfc3RhX3NldF9idWZmZXJlZChzdGEsIHR4X3ByaXYtPnRpZCwgdHJ1ZSk7CisJCXN0
YV9wcml2LT5idWZmZXJlZFt0aWRdKys7CisJCWllZWU4MDIxMV9zdGFfc2V0X2J1ZmZlcmVkKHN0
YSwgdGlkLCB0cnVlKTsKIAkJc3Bpbl91bmxvY2tfYmgoJnN0YV9wcml2LT5sb2NrKTsKIAl9CiB9
CkBAIC00MTgsMTcgKzQxOSw2IEBAIHN0YXRpYyBzdHJ1Y3QgaGlmX2h0X3R4X3BhcmFtZXRlcnMg
d2Z4X3R4X2dldF90eF9wYXJtcyhzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RyCiAJcmV0dXJuIHJl
dDsKIH0KIAotc3RhdGljIHU4IHdmeF90eF9nZXRfdGlkKHN0cnVjdCBpZWVlODAyMTFfaGRyICpo
ZHIpCi17Ci0JLy8gRklYTUU6IGllZWU4MDIxMV9nZXRfdGlkKGhkcikgc2hvdWxkIGJlIHN1ZmZp
Y2llbnQgZm9yIGFsbCBjYXNlcy4KLQlpZiAoIWllZWU4MDIxMV9pc19kYXRhKGhkci0+ZnJhbWVf
Y29udHJvbCkpCi0JCXJldHVybiBXRlhfTUFYX1RJRDsKLQlpZiAoaWVlZTgwMjExX2lzX2RhdGFf
cW9zKGhkci0+ZnJhbWVfY29udHJvbCkpCi0JCXJldHVybiBpZWVlODAyMTFfZ2V0X3RpZChoZHIp
OwotCWVsc2UKLQkJcmV0dXJuIDA7Ci19Ci0KIHN0YXRpYyBpbnQgd2Z4X3R4X2dldF9pY3ZfbGVu
KHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmh3X2tleSkKIHsKIAlpbnQgbWljX3NwYWNlOwpA
QCAtNDYwLDcgKzQ1MCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3R4X2lubmVyKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCW1lbXNldCh0eF9pbmZvLT5yYXRl
X2RyaXZlcl9kYXRhLCAwLCBzaXplb2Yoc3RydWN0IHdmeF90eF9wcml2KSk7CiAJLy8gRmlsbCB0
eF9wcml2CiAJdHhfcHJpdiA9IChzdHJ1Y3Qgd2Z4X3R4X3ByaXYgKil0eF9pbmZvLT5yYXRlX2Ry
aXZlcl9kYXRhOwotCXR4X3ByaXYtPnRpZCA9IHdmeF90eF9nZXRfdGlkKGhkcik7CiAJdHhfcHJp
di0+cmF3X2xpbmtfaWQgPSB3ZnhfdHhfZ2V0X3Jhd19saW5rX2lkKHd2aWYsIHN0YSwgaGRyKTsK
IAl0eF9wcml2LT5saW5rX2lkID0gdHhfcHJpdi0+cmF3X2xpbmtfaWQ7CiAJaWYgKGllZWU4MDIx
MV9oYXNfcHJvdGVjdGVkKGhkci0+ZnJhbWVfY29udHJvbCkpCkBAIC02MzQsMTEgKzYyMywxMSBA
QCBzdGF0aWMgdm9pZCB3Znhfbm90aWZ5X2J1ZmZlcmVkX3R4KHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAoc3Ry
dWN0IGllZWU4MDIxMV9oZHIgKilza2ItPmRhdGE7CiAJc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0
YTsKIAlzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICpzdGFfcHJpdjsKLQlpbnQgdGlkID0gd2Z4X3R4X2dl
dF90aWQoaGRyKTsKKwlpbnQgdGlkID0gaWVlZTgwMjExX2dldF90aWQoaGRyKTsKIAogCXJjdV9y
ZWFkX2xvY2soKTsgLy8gcHJvdGVjdCBzdGEKIAlzdGEgPSBpZWVlODAyMTFfZmluZF9zdGEod3Zp
Zi0+dmlmLCBoZHItPmFkZHIxKTsKLQlpZiAoc3RhICYmIHRpZCA8IFdGWF9NQVhfVElEKSB7CisJ
aWYgKHN0YSkgewogCQlzdGFfcHJpdiA9IChzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICopJnN0YS0+ZHJ2
X3ByaXY7CiAJCXNwaW5fbG9ja19iaCgmc3RhX3ByaXYtPmxvY2spOwogCQlXQVJOKCFzdGFfcHJp
di0+YnVmZmVyZWRbdGlkXSwgImluY29uc2lzdGVudCBub3RpZmljYXRpb24iKTsKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmgKaW5kZXggODM3MjBiMzQzNDg0Li4wNGIyMTQ3MTAxYjYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5oCkBAIC0zOCw3ICszOCw2IEBAIHN0cnVjdCB3ZnhfdHhfcHJpdiB7CiAJc3RydWN0IGll
ZWU4MDIxMV9rZXlfY29uZiAqaHdfa2V5OwogCXU4IGxpbmtfaWQ7CiAJdTggcmF3X2xpbmtfaWQ7
Ci0JdTggdGlkOwogfSBfX3BhY2tlZDsKIAogdm9pZCB3ZnhfdHhfcG9saWN5X2luaXQoc3RydWN0
IHdmeF92aWYgKnd2aWYpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggMzM5NTUyNzhkOWQzLi5hYTFhNjhiNjFh
YzUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtNjA0LDcgKzYwNCw3IEBAIGludCB3Znhfc3RhX3JlbW92ZShz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlzdHJ1
Y3Qgd2Z4X3N0YV9wcml2ICpzdGFfcHJpdiA9IChzdHJ1Y3Qgd2Z4X3N0YV9wcml2ICopICZzdGEt
PmRydl9wcml2OwogCWludCBpOwogCi0JZm9yIChpID0gMDsgaSA8IFdGWF9NQVhfVElEOyBpKysp
CisJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoc3RhX3ByaXYtPmJ1ZmZlcmVkKTsgaSsrKQog
CQlXQVJOKHN0YV9wcml2LT5idWZmZXJlZFtpXSwgInJlbGVhc2Ugc3RhdGlvbiB3aGlsZSBUeCBp
cyBpbiBwcm9ncmVzcyIpOwogCS8vIEZJWE1FOiBzZWUgbm90ZSBpbiB3Znhfc3RhX2FkZCgpCiAJ
aWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKaW5kZXgg
NDdkOTRkNmI4NTkwLi5lODMyNDA1ZDYwNGUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaApAQCAtMTIsOSArMTIsNiBA
QAogCiAjaW5jbHVkZSAiaGlmX2FwaV9jbWQuaCIKIAotLy8gRklYTUU6IHVzZSBJRUVFODAyMTFf
TlVNX1RJRFMKLSNkZWZpbmUgV0ZYX01BWF9USUQgICAgICAgICAgICAgICA4Ci0KIHN0cnVjdCB3
ZnhfZGV2Owogc3RydWN0IHdmeF92aWY7CiAKQEAgLTQwLDcgKzM3LDcgQEAgc3RydWN0IHdmeF9n
cnBfYWRkcl90YWJsZSB7CiBzdHJ1Y3Qgd2Z4X3N0YV9wcml2IHsKIAlpbnQgbGlua19pZDsKIAlp
bnQgdmlmX2lkOwotCXU4IGJ1ZmZlcmVkW1dGWF9NQVhfVElEXTsKKwl1OCBidWZmZXJlZFtJRUVF
ODAyMTFfTlVNX1RJRFNdOwogCS8vIEVuc3VyZSBhdG9taWNpdHkgb2YgImJ1ZmZlcmVkIiBhbmQg
Y2FsbHMgdG8gaWVlZTgwMjExX3N0YV9zZXRfYnVmZmVyZWQoKQogCXNwaW5sb2NrX3QgbG9jazsK
IH07Ci0tIAoyLjI1LjAKCg==
