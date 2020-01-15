Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD1013BF94
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgAOMNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:44 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731359AbgAOMNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agwcgjHRZaA9WVhzDzSz803EfnI8P5q9Taw5vTRMure25EDci8TXyfwoUYxscMFWLc1NfH7ZLYSyMBeMnmSLnGGG4efoeh9jFrmbYr8INxLIW1sy/ObqCBq8WvdwhS468CQ3n3LKYfgm5gb1NuTnchua5J0GzpBlgEWUXlgfeGVuYkE0DixCuQI24hxlpAUsthY5AsRMZgeNq7USOEJt7rEm0PleY+1bKt4+qN+vpaw4lkMEXH0Q71yCZdt1HloXtc8nupkpatN7IvFOXVHd6O0VW03aB9+jj4WFi7kITkxcOjXNFZGenf9+eey4vp5/QkmhEtwMLgL+iO9Cju9udg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/3KphuIWHT7wDKlqvwRmqG9upHZnSnHv+Ck1RpM3WI=;
 b=O50jqMiMnKXEubqYeF1+SgSxHsiBYm8DynB8ESdmi6TW825HnpBYAltZHkfBIPoTpXZr0JXgiJAqBkYy+X8YL+t+7/Uf+emjXJ8KCzxBIdcg4ZgVy5YC2aTpuC6Edh18Xgwto2L5YsQqYPHaIWAY1w+5wSQwulUxx3KMIZ+mDSdKuJyeOj+c4QlvCNTt++OsPEh+abQREBS5ewfcQ+vgJmsnH86KTFTDMmjpkZSTwgaE3r0z5jIsR9uqsGMpDIeQDEuvDXKefqZh9U2n8I9q+PLUH0Nxpir1nPXjHFOac9OOF4HldJyf3vvJVpWRW0VOzV721AC8K3sxRWrNcMGKnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/3KphuIWHT7wDKlqvwRmqG9upHZnSnHv+Ck1RpM3WI=;
 b=cZZoVOHTskDlSW8m94SkTh5kRIWKj3MIVDY7OVts5F5DHmqDmrW5Xo+cgg38u1x5Hu5Scj5tes/F6AiiH7TlivFN4kY5UFjyyrTMlQVPDxPxTYBgIqzEzBZMzyAA5CELkqJaUG642qUMCh/ZYkx7HDixR7xAIo7Xc8o/4FyUTyA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:32 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:32 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:15 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 51/65] staging: wfx: check that no tx is pending before
 release sta
Thread-Topic: [PATCH 51/65] staging: wfx: check that no tx is pending before
 release sta
Thread-Index: AQHVy50rR3kGt5+U4kCXWFe+sokjlQ==
Date:   Wed, 15 Jan 2020 12:13:17 +0000
Message-ID: <20200115121041.10863-52-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: e4c34091-f227-48dc-6416-08d799b44d6d
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39343A7B73673C2C272C016B93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(1076003)(66556008)(64756008)(66446008)(4744005)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X+HL4LzkScJWQNGEJhU//zPCgh22q0pFhK+nGlc8RmxQAmY2XtrMK83mDB8/PjR/vyDiG2lA21sPU+Yx+/LevWUWQ7vhhHR6eWkg00Gtu6TeDUXI/oxvFWIkVeHtaAg7d5fOiWqSek6I2EYZ2tHEU48Wey5XkmiOc8u/cU5m/tWN+c6bPyNig++cuTvRJ5xNZV5awU2LPaTv7PvPY+9XMLGbJ14sPLaY7Oq1hW4FlZaQD38NCPe5yk80FK5aVrJapGR0WcKjDDOKCwcoVUpJ9dBGM0RDByOvkdakPjy+B/LpXMHoe2fN8gZxlYsRNIuAd1VCZ+Oq0Ny0RPKsYDvY5T/x1G75iclLoyxDs20mFR/Kvitk9llwmspNmEUQEx5RIm6eGJ7Czc7Fm/WaoqKUEKAmB3NpZm31WXtb1AZYpqsd825e//zo8+aMt+kCpUNG
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8FF1F79A9277047A511FEC8B852F89F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c34091-f227-48dc-6416-08d799b44d6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:17.1260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yzrq2KAy7xoZV19qkibJdPLLc6XdRNvn4P6BW9lW4sHdwFG6u7kMfgKgGdWONb5fppG9vEmt7yEg3KwgXhj/PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSnVz
dCBmb3Igc2FuaXR5LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAzICsr
KwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDg0ODUz
YWE5MGY0Yi4uZWViYmQzMjkyYjFiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTYwMiw3ICs2MDIsMTAgQEAg
aW50IHdmeF9zdGFfcmVtb3ZlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgw
MjExX3ZpZiAqdmlmLAogewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3Znhfdmlm
ICopIHZpZi0+ZHJ2X3ByaXY7CiAJc3RydWN0IHdmeF9zdGFfcHJpdiAqc3RhX3ByaXYgPSAoc3Ry
dWN0IHdmeF9zdGFfcHJpdiAqKSAmc3RhLT5kcnZfcHJpdjsKKwlpbnQgaTsKIAorCWZvciAoaSA9
IDA7IGkgPCBXRlhfTUFYX1RJRDsgaSsrKQorCQlXQVJOKHN0YV9wcml2LT5idWZmZXJlZFtpXSwg
InJlbGVhc2Ugc3RhdGlvbiB3aGlsZSBUeCBpcyBpbiBwcm9ncmVzcyIpOwogCS8vIEZJWE1FOiBz
ZWUgbm90ZSBpbiB3Znhfc3RhX2FkZCgpCiAJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQ
RV9TVEFUSU9OKQogCQlyZXR1cm4gMDsKLS0gCjIuMjUuMAoK
