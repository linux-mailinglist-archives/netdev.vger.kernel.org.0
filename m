Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB813C09A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgAOMMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:20 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730191AbgAOMMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETqoM2s6c0MVVUUsz+HPVX9fcViEXpXSnItJof9FD0PTuBMEoI+fl9Asd/UFDRpQ1Z7T/uh+qboRdi1mq+DvnV+8QRcexrCYtoplgjsbYx1PdbbcFqu5z0iod9v88uptQb5WhmyB/H+kvlSISGhS4r7DmL+jo38oaXU/WvRj0kf6RsN4wh93jS04zjwqY9uZJAHiS9wOMg60W/02Z2Wb5hmlK9YW+TF/VBFivThTmnROLK8+6y8Hi2ihwIjwYq/Z0UVCdFGMX+9P7XjxlMEnY92hKoaYRTWFGKbCGcSwFSeZzkfI0OrMuhWZ0dsNgqU4RCIpqJCNcERDhZz4CKp29g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJKgaa7pmmCRqtSbENrnVw4XdApYgK6og7UgQlebpmM=;
 b=bHvR5VKlHyhKXbNDkzzLgymElcdY4OJjvrLsKDuQm+bIi02S6FdxeJh77Zr1snNEvort3++pxVPentDqWQpLf5dRS6/bVczjsG+qVCjl6I/gD6BD3erj03+27g5Ofe/UI1Qf71RKFQpEHz1DeKEvHUpEf+4RUJroY111pnYcc+VzsV3Y0s6bjtX4Pdhm23PJ9lkmA59R+hgx09KS+wwV8lilj6Ot35kEu2bz+izC5ASTb58MDrIW8NVkVm+b++KsfK8cO3K/aDA29iSFV9SiWadRgX8OfuDJiGpMfRs3yKgc4ysW3ZSV2LU6YfnwLbG+sE2BfpFjXsoWzvPiOCPzEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJKgaa7pmmCRqtSbENrnVw4XdApYgK6og7UgQlebpmM=;
 b=SH07mGd1q2IVwui1+8PucbC9mju2s5OkzOB+daVoaSMvbwnyCMv8y4hbOf7vdFs7Zy+oL+fzIB82tkpmFuqCM8jCsmXJjC5aOUU0W8RrCyPG3G8DKAc7G/h46Okv5mPhfgb0lQUqEphdkjiTagg6aqW47FF397NeoSr+n6Q/x/g=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:10 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:09 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:08 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>,
        Pascal Prime <Pascal.Prime@silabs.com>,
        Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH 01/65] staging: wfx: revert unexpected change in debugfs
 output
Thread-Topic: [PATCH 01/65] staging: wfx: revert unexpected change in debugfs
 output
Thread-Index: AQHVy50CgXXZf+D1OU60c4tUE9Izlw==
Date:   Wed, 15 Jan 2020 12:12:09 +0000
Message-ID: <20200115121041.10863-2-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: e3cdbf29-fc88-4812-4960-08d799b42534
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934172B84FC814C30BB14D293370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:220;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kFCS2mMuil2Ju5OoK+WzY+/gRjQjSKqy1xc0p12AFqYM4uv0g+TKh2x+XvfNLSJb0Qiq+MeGzcQDZJit1A9bTZbfIz2egMTQNW5iMY6j83VuADfnCEy8yWqliY8toH1dqO3N+a+r7tHRkKwjVCRYjt4VPAFhBEoYYljQkTHiZhJdYr3GVAVXYZ2zOLehSrhXbQc/v0UGWHe1/yGd8LwcrK8Dvz2f89XKc1pRxuDJiL0tDJhWdM2WyhCO/BfOYadY2l0vrtoT1sYjqLEF/RE/3f8sThs3l+0r/Lu1HQXBE1PqxjOUDFTYWrcnCCWn263JT1UeP/t5uPVn6ckhBhrv1wJzdyZl6IrAOeTsEwynCLJnghhrENFkH7YTR4vU1jSIsVVxHAor2CazYt1dAmLjwjRq8wdlSVIddmQl+7r+XiQpF+CB4bzLLizmEVCv7aqc
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BA67E860FF98E48B3A2DC1D62D69292@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cdbf29-fc88-4812-4960-08d799b42534
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:09.6429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NMVx9Nh0uy6i403LGCNareI46n4IHfntyzv22zNJvmZ2Z8Ct9pNYtnnCYczRyR9c4IVX46SOxH+ZLAwOWBdWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
YXBwZWFycyB0aGF0IGNvbW1pdCA4YzcxMjhjNGNmNGUgKCJzdGFnaW5nOiBhbGlnbiB0byBmaXgg
d2FybmluZ3Mgb2YKbGluZSBvdmVyIDgwIGNoYXJhY3RlcnMiKSBkbyBzbGlnaHRseSBtb3JlIHRo
YW4gd2hhdCBpcyBleHBsYWluZWQgaW4KY29tbWl0IGxvZy4KCkVzcGVjaWFsbHksIGl0IGNoYW5n
ZXMgdGhlIG91dHB1dCBvZiB0aGUgZmlsZSByeF9zdGF0cyBmcm9tIGRlYnVnZnMuCkZyb20gc29t
ZSBwb2ludCBvZiB2aWV3LCB0aGlzIGZpbGUgY2FuIGJlIGNvbnNpZGVyZWQgYXMgYSBwYXJ0IG9m
IHRoZQpBUEkuIEFueSBjaGFuZ2Ugb24gaXQgc2hvdWxkIGJlIGNsZWFybHkgYW5ub3VuY2VkLgoK
U2luY2UgdGhlIGNoYW5nZSBpbnRyb2R1Y2VkIGRvZXMgbm90IHNlZW1zIHRvIGhhdmUgYW55IGp1
c3RpZmljYXRpb24sCnJldmVydCBpdC4KClJlcG9ydGVkLWJ5OiBQYXNjYWwgUHJpbWUgPHBhc2Nh
bC5wcmltZUBzaWxhYnMuY29tPgpDYzogSnVsZXMgSXJlbmdlIDxqYmkub2N0YXZlQGdtYWlsLmNv
bT4KRml4ZXM6IDhjNzEyOGM0Y2Y0ZSAoInN0YWdpbmc6IGFsaWduIHRvIGZpeCB3YXJuaW5ncyBv
ZiBsaW5lIG92ZXIgODAgY2hhcmFjdGVycyIpClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWls
bGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2RlYnVnLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2RlYnVnLmMKaW5kZXggZDE3YTc1MjQyMzY1Li4xMTY0YWJhMTE4YTEgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RlYnVnLmMKQEAgLTE0NSw3ICsxNDUsNyBAQCBzdGF0aWMgaW50IHdmeF9yeF9zdGF0
c19zaG93KHN0cnVjdCBzZXFfZmlsZSAqc2VxLCB2b2lkICp2KQogCQkgICBzdC0+cHdyX2Nsa19m
cmVxLAogCQkgICBzdC0+aXNfZXh0X3B3cl9jbGsgPyAieWVzIiA6ICJubyIpOwogCXNlcV9wcmlu
dGYoc2VxLAotCQkgICAiTi4gb2YgZnJhbWVzOiAlZCwgUEVSICh4MTBlNCk6ICVkLCBUaHJvdWdo
cHV0OiAlZEticHMvc1xuIiwKKwkJICAgIk51bS4gb2YgZnJhbWVzOiAlZCwgUEVSICh4MTBlNCk6
ICVkLCBUaHJvdWdocHV0OiAlZEticHMvc1xuIiwKIAkJICAgc3QtPm5iX3J4X2ZyYW1lLCBzdC0+
cGVyX3RvdGFsLCBzdC0+dGhyb3VnaHB1dCk7CiAJc2VxX3B1dHMoc2VxLCAiICAgICAgIE51bS4g
b2YgICAgICBQRVIgICAgIFJTU0kgICAgICBTTlIgICAgICBDRk9cbiIpOwogCXNlcV9wdXRzKHNl
cSwgIiAgICAgICAgZnJhbWVzICAoeDEwZTQpICAgIChkQm0pICAgICAoZEIpICAgIChrSHopXG4i
KTsKLS0gCjIuMjUuMAoK
