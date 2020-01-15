Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3374B13BF96
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbgAOMNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:47 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731641AbgAOMNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlbpDQCMMxbU2NGU68+KmDcWsxQ5+08LVJf2EDYbwPS27DHFGJ76BiRGmASHvUxap+l1b0hhPrrwK/yqX8KrH+cFDxbUlBTwKRGManooMPoXLGFY4cux5cy7f03ybPOmvQwMbuRNSO2bBTJIVW004aAliiDQPBzrX2iXpThUBwOcHYVaVEOxdXp2yt33F/5aqbvTZXHQjwsEvWRhvxHm/FQZ0erAOsDvOY3AoEAj0Xsm5uLW7KGH+Sx2TKtrwYr+xPlmMFbu5dWlaqNgaseyHfBhkNujTPSOHYMdKWWG4xzqXZha0B2u61gNFbj+Db3AvRxlfYI7MUMzeLcbtVpcPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+fCfnSJaynmH2NnQWzXjSclI/C2yFd80gnTfbqgY1w=;
 b=YM0JJU3lLa25QE4B4S2r3A8yCNHLnzSmBQY2fD3V53aDlxG/BG3NcvPPHX52H0djnUEbskmG2fasxd0G475d1CD51e2Jv+YJTaOOKSSMmeroT5jVyqC4Qe3iQFF64tE0hw7Z/xYJMe8lWYFq/jQPsCXS5iCegDgZ4U7qRxj0cWzk0uuJbNES/TwTkM71ECwGcd9MCO2WC0ROPpZ0mr3gaUD8zV5uZdHvN8loFmgZ7HFaMgMdqv8T6YiX2mjPOH13Uib4HW5JJ4ZM+bBrgfmXIk8hOns1KUlU52mIDKfnxNfvsoUE2XqlS2SqLQT6vmbW6ImY9CGAEVylBREFhKsWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+fCfnSJaynmH2NnQWzXjSclI/C2yFd80gnTfbqgY1w=;
 b=atNMXd2LpfjvqiwvjrwQqYQ8gtwU8yaHK3HUafpZWPaY5s6qPF4wPL2YosHFtAz+lIiy0xNvT6Rq0kqy9Exp2jHEreLlb5sI5jhhlAMzK6RoytFti6ihA2CKKaTzIB25wLIjxRfWiTR87Dt+wNwprwlEwVUqIV/xn03PTXr50Eo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:33 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:33 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:17 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 52/65] staging: wfx: replace wfx_tx_get_tid() with
 ieee80211_get_tid()
Thread-Topic: [PATCH 52/65] staging: wfx: replace wfx_tx_get_tid() with
 ieee80211_get_tid()
Thread-Index: AQHVy50rurdsYUjCaUy7e1acwjtaVQ==
Date:   Wed, 15 Jan 2020 12:13:18 +0000
Message-ID: <20200115121041.10863-53-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ec78330e-f651-4c1c-e41a-08d799b44e42
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934A43E66291B15D3F6642E93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G5ncbAkW9gjf6HpgxqYX7Kc+R2YZT6kC5EQoVu011BbTHg2aXOmLhhCxadiczYtvokFXP6pn+fBIB/N1K5SOwGxguu4OaZt+1M/rFqWEvGyHaghjd+GoiVIki1X7njiTa9RLeJD0JiXBRc+EpoWNs49JIcxbgrUjvQstX4NLMkcTE5PHcsgAlCiewL1c7tCP9C17jjcisPMZrH/OMb/OUeKmk2pAwXmQwyyB4B7U13kQaKNJ3beIGEct8V5dR+Ctq4A6j3D9nu2/HIRd+ZBEJEObC+XANBteEjDAK0Oz6gI1Mxj373G7NBnPD9NRRYvtsX+wQzdsUnC9JjRsThCNoel05gaUi7Hw5Rs947nh5jVFdoDQAGQ3RcNusYXuCufyj2J0WzVqBQpEk+CvxsNsLGBzKaN5FfDfKPuJvMmvuppEs+LggvEKfgu4bFphEQC6
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE145F2F1FD2004BAB48FEF7ABF59722@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec78330e-f651-4c1c-e41a-08d799b44e42
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:18.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fmPuQ5v1/71URSEnnEyfPWXYan/1wr3JUv0qdDc1OoN2HPtDXMiJoHTkIs7YILP3mCWO6Oc9dOJunQWqk64Rwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
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
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZWViYmQzMjkyYjFiLi42MWQ2NGJlYjYx
NDMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
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
