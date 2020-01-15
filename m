Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7165B13C06E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbgAOMSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:18:31 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730705AbgAOMMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iutFJARPyJojSa+fh0ilIdC2cSdUrq8WtT6gPnb3W+PSkXPB/BMdUs2jm9h8ckELt/3w9LvFyNOg2t7QqubSUnYWWtMNtS84UO4eX/6lL5Kpr0JNRszYZdh2qw3NpAyESyzJAnu/j+xgg54het7IdmDFvMU279vydedYRWr2NJleDSHfrusH4kcN2e3djL9N/EipTKd7mV7XuJkVuqAiAzS/UKIFDuOv4Iw/RiTc+polDx7iPFB9Id4YJ1hXEpNmnwxjfSJuMBIAhylThjf0cQzUK6YQebmRuWLDpd7ctm7zQ5UWaVrASffMgQ0tkFy0AXIrN84h/QoXyGG2INGxxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzVf8PCsjhv48CVwVz+IbX+oGTKM2/8Ap4mn8+5bTGE=;
 b=YaRYrWusylgzNQ4+nWE71tpwWWTmSvEaFh6/rR3KS4Oir0upLI+ef8tOrhDstnyMC9nuIYf/Oyr3WeU6tINhCHcdAEU8VQ9rfThmFESW8beLm4Gmmihw//OUt9yfsThNYiMIStcx8aBWy0OFhlpJyQIUA/VMHvAsvVh6uuhsE6OKnuRl6nQtsFuYJ/Olqk9NGY8R3ymDAcnXy4DaRDiHR+FqCApGWIpVy3UcvYhuwi8pSo6jRWsiHE8iok0nA/ivFzHHyYPZkTLlOAxCqHeR/fV6BlOWF0SIJZW0MoqP3gPiVWVryX1w5brcnQG+TReyoQL0cE0PIVsMVQGrsP/kSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzVf8PCsjhv48CVwVz+IbX+oGTKM2/8Ap4mn8+5bTGE=;
 b=SxOyG89cI80V0UOFIQ60Oz5rfMzI1RulYyaPKitia34DJnrANa1upLwdUmmm+nXHR4tRhjs8tGGtp/vlvoa/VkWyf7rZghMvysyeQ++QsFKIk3ZXfTYENzJllEevh8UXoftJnoSC6UTnG1BbboJc+cmQxWr/T6Ii+nc0JxmslcM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:32 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:32 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:30 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 17/65] staging: wfx: simplify wfx_upload_ap_templates()
Thread-Topic: [PATCH 17/65] staging: wfx: simplify wfx_upload_ap_templates()
Thread-Index: AQHVy50QtpQv9u8EV0+rKqOV6r6udQ==
Date:   Wed, 15 Jan 2020 12:12:32 +0000
Message-ID: <20200115121041.10863-18-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 44b5923c-d3cf-4cd0-c603-08d799b4329a
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39341736C6340B90B3CCEE3093370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J24eyhQJNAb6+g3tOSgGN+L9s9BQs08aaR3aynAQDVKwfN+Pb9/rb9F7NvKF1LHrwVa7oWF/3fW5LnEsIbv/7tLWk8OqQVlMiLUw3+S55YT3g6Vkg+N8nxxvwJLb3ZrwQiw7PmzIT6ecc2lbQtU94s4atZqDH9z2FJ/PlDeSLi3xbgaNHpZ/dQsZlmlIbKG+YqG3YwBWNBl0gcjLNoqKfkPVewaminCUNsxZ6vyEuLV6aI1dc3Qqnt+4q/BmTwH/DhR5LDgLraqUei2FBu1K5cFP9oueqaL2G4d8Ir/bNtUV5AoLCCMOS2dSmGYZAusj5T1J6O4955M2WBlptErzEH592ztoK8YhK2vIll68IERaPd999qIniWCF5WCEsX7/K+eOmJEAKqQ8YIFcgG+mYqutLZJikrHF3twqB5vnHprXFLDEERgz//nkbDPJStzm
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B9ABF37F3FCBC49850B621DB93AB3F3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b5923c-d3cf-4cd0-c603-08d799b4329a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:32.0120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8RxNVWBaiOFLYjGToGwFXqgMTO9+OuFZ+wRskBkUnjd7fcOs4e8g1FyKPy0WwQWfYoDS3QH2SPusn225auOpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBmdW5jdGlvbiBidWlsdCBwcm9iZSByZXNwb25zZSBmcm9tIGRhdGEgcmV0cmlldmVkIGluIGJl
YWNvbi4gWWV0LAp0aGlzIGpvYiBjYW4gYmUgZG9uZSB3aXRoIGllZWU4MDIxMV9wcm9iZXJlc3Bf
Z2V0KCkuIFNvLCB3ZSBjYW4gc2ltcGxpZnkKdGhhdCBjb2RlIChhbmQgZml4IGJ1Z3MgbGlrZSBp
bmNsdXNpb24gb2YgVElNIGluIHByb2JlIHJlc3BvbnNlcykuCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyB8IDEyICsrKystLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5z
ZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBmZGRlN2FiOTIzMDIu
LjExODEyMDM0ODlmMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC03ODMsNyArNzgzLDYgQEAgc3RhdGljIGlu
dCB3ZnhfdXBkYXRlX2JlYWNvbmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHN0YXRpYyBpbnQg
d2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJc3RydWN0
IHNrX2J1ZmYgKnNrYjsKLQlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQ7CiAKIAlpZiAod3Zp
Zi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gfHwKIAkgICAgd3ZpZi0+dmlm
LT50eXBlID09IE5MODAyMTFfSUZUWVBFX01PTklUT1IgfHwKQEAgLTc5NSwxNCArNzk0LDExIEBA
IHN0YXRpYyBpbnQgd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2aWYp
CiAJCXJldHVybiAtRU5PTUVNOwogCWhpZl9zZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBI
SUZfVE1QTFRfQkNOLAogCQkJICAgICAgIEFQSV9SQVRFX0lOREVYX0JfMU1CUFMpOworCWRldl9r
ZnJlZV9za2Ioc2tiKTsKIAotCS8qIFRPRE86IERpc3RpbGwgcHJvYmUgcmVzcDsgcmVtb3ZlIFRJ
TSBhbmQgYW55IG90aGVyIGJlYWNvbi1zcGVjaWZpYwotCSAqIElFcwotCSAqLwotCW1nbXQgPSAo
dm9pZCAqKXNrYi0+ZGF0YTsKLQltZ210LT5mcmFtZV9jb250cm9sID0KLQkJY3B1X3RvX2xlMTYo
SUVFRTgwMjExX0ZUWVBFX01HTVQgfCBJRUVFODAyMTFfU1RZUEVfUFJPQkVfUkVTUCk7Ci0KKwlz
a2IgPSBpZWVlODAyMTFfcHJvYmVyZXNwX2dldCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+dmlmKTsK
KwlpZiAoIXNrYikKKwkJcmV0dXJuIC1FTk9NRU07CiAJaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3
dmlmLCBza2IsIEhJRl9UTVBMVF9QUkJSRVMsCiAJCQkgICAgICAgQVBJX1JBVEVfSU5ERVhfQl8x
TUJQUyk7CiAJZGV2X2tmcmVlX3NrYihza2IpOwotLSAKMi4yNS4wCgo=
