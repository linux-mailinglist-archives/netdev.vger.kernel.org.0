Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7A313BF72
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgAOMNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:38 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:6101
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731379AbgAOMNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa40S3DBCy17O4FBAXtobZlZBfhcedFATYhiHVihvWoiiM+f1IRi1M/j9sYZOvan3JgO2yVwpWwn9mO8vGW1Jeg9kgYQ85ewDXacH79tY1G3l/M1+pKZZDmUNZvnacgyQDfiqmC3rPbERuUY6zy5Nw26tOA7FZbqbVxYIxNVLqD2/VeYpjhDR0m2Y59qF7zxQvN9FkE07cEFV0n23EaiVYY+Ouv6SITz/BXcxuIfayKO+TEcoZH1gGRx6/bUvz4Ukk4673G5BDf35QzS2P7IA32kokYMouBtzTyJO3CrF2rMFP6WpBaDb6hgJX7qd5rMhYPt175SXKi9NNCpWzysxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRUV34dVR5FpqMHul/yJ0EDmgmWG5LdkxOQALJF4n3w=;
 b=WSkZ6pKh4QxAhZPgZ7JpIZ6F6eIqS+KDzyKxzulfC8Z5PoGaLjI06Xp7qd2A08EyN9fXwp4evLNm+Pue20XQM4jYQrCRs2Ca2LGvJl1oqYY/8lVixJnmxEGE+TSpxwRTOWHAfkpewCFHl0jjdHiCvFPdkP3w3WH/wvvodiNuVu+OY/xDuDvg0FKItTyrKyKrq3gDKbsoJMw+898rh4ufNKlnMaRfAxJ4XWspNF6U4xno6mcDKGUn+dgtbAp8TwlOf3MMxkkKBqRzw+LQvWWgaAkaON3MpymNjPPcoy9FAO3iDNU8oxNWXLBUvKv1kIEuhRPfngtcqowBABkXoIktVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRUV34dVR5FpqMHul/yJ0EDmgmWG5LdkxOQALJF4n3w=;
 b=l5VTvPHTNEf3onrVUf+ipwJyx9v/5Tdd2L90j6WwEgJPF576Sy9uehG1P2XaYZjKtN3e26zlus/XNs0m3RTr+GwYE2RO7AiGuLFZ0GUD4ez5S9IkTKP49WMX9aFHs6r3lb8pNJrjMYjhkTC9qcBhxf/UXmr6DI46Bs+mrymMXcY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:27 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:03 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 42/65] staging: wfx: do not update uapsd if not necessary
Thread-Topic: [PATCH 42/65] staging: wfx: do not update uapsd if not necessary
Thread-Index: AQHVy50jb5azjf0rhUKUQExZDeVmYQ==
Date:   Wed, 15 Jan 2020 12:13:04 +0000
Message-ID: <20200115121041.10863-43-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 37cd727a-bc87-4abe-bbb5-08d799b4463a
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934CC5F69A26221BBA0026293370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003)(15650500001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dsuFSXiedqcpa+nGXw9sLexhiATHQAT38avBhipqjW+/bePhBth+RYnq5gBdps2kDYOeIYowLQEy0tkDKnn26CN+P+ui9Sf/AcGQMrypxwb73lrvQHYpdPFfSfKFXjrA1JLiB1EDDUr/Nm9/inBUVDaCyabrKRW28XivXHjWJEuaqufr8fEdidXnKvO5mCP/HnP0Z3SQFopWBfZu1GY8Ie7ROUPpHAmc48iLQQ65GqqeIz5C/Yvb05TpJQA+uE//53y3dMPMNeaJ97q3zG1Gl3fV1O5f8w7gXK4yNC6lEbo+vm4PK3Vv9AZ8noXBCsRMyg335IQ9sucTlbRkvZU7lNlNuvkaRbIRHDzCNwd79edXT6Rbuifi5W5TxUYoQ85cMkCJ0RNWYYiZFy0XV6B0YobZq5hW+RgURNR7heCc08sQhGlAaSW1WTUJ2zcd2xAj
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5D434626CE67E4BB92E4960388978C8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37cd727a-bc87-4abe-bbb5-08d799b4463a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:04.9350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VT88pcmJ4pPQK3YJlTLGApuTgsIPbniXdLkeIJcNj/eDJzaWa8Maa31QzuXc+LkWjYHSeFIOYcGnxxa4mqVbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2NvbmZfdHgoKSBpcyBjYWxsZWQgZm9yIGVhY2ggcXVldWUuIE9uIGV2ZXJ5IGNhbGwsIHRoZSBm
dW5jdGlvbgp1cGRhdGVzIFVBUFNEIG1hc2sgYW5kIFBNIG1vZGUgZm9yIGFsbCBxdWV1ZXMuIEl0
IGlzIGEgcGl0eSBzaW5jZSB0aGUKVUFQU0QgY29uZmlndXJhdGlvbiB2ZXJ5IHJhcmVseSBjaGFu
Z2VzIGFuZCBpdCBtYWtlcyBleGNoYW5nZXMgYmV0d2Vlbgp0aGUgaG9zdCBhbmQgdGhlIGNoaXAg
bW9yZSBkaWZmaWN1bHQgdG8gdHJhY2suCgpUaGlzIHBhdGNoIGF2b2lkIHRvIHVwZGF0ZSBVQVBT
RCBhbmQgUG93ZXIgTW9kZSBpbiBtb3N0IHVzdWFsIGNhc2VzLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgfCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBiZjI4NTM4OWMzMDMuLjZhNDNkZWNk
NWFlNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0yODYsNiArMjg2LDcgQEAgaW50IHdmeF9jb25mX3R4KHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogewogCXN0
cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnByaXY7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPSAo
c3RydWN0IHdmeF92aWYgKikgdmlmLT5kcnZfcHJpdjsKKwlpbnQgb2xkX3VhcHNkID0gd3ZpZi0+
dWFwc2RfbWFzazsKIAlpbnQgcmV0ID0gMDsKIAogCVdBUk5fT04ocXVldWUgPj0gaHctPnF1ZXVl
cyk7CkBAIC0yOTQsNyArMjk1LDggQEAgaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCWFzc2lnbl9iaXQocXVldWUsICZ3
dmlmLT51YXBzZF9tYXNrLCBwYXJhbXMtPnVhcHNkKTsKIAltZW1jcHkoJnd2aWYtPmVkY2FfcGFy
YW1zW3F1ZXVlXSwgcGFyYW1zLCBzaXplb2YoKnBhcmFtcykpOwogCWhpZl9zZXRfZWRjYV9xdWV1
ZV9wYXJhbXMod3ZpZiwgcXVldWUsIHBhcmFtcyk7Ci0JaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7CisJaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OICYmCisJICAgIG9sZF91YXBzZCAhPSB3dmlmLT51YXBzZF9tYXNrKSB7
CiAJCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlmLT51YXBzZF9tYXNrKTsKIAkJd2Z4X3Vw
ZGF0ZV9wbSh3dmlmKTsKIAl9Ci0tIAoyLjI1LjAKCg==
