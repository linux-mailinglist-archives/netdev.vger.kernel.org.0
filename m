Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1713C40E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgAON4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:05 -0500
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:6173
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbgAONzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPVA14Y/bgHxG5b0WkqHrvBmxpOfwG6Jz46fyadn2AF3UE3irT7tOtkorpBxZNJglak+JR/nk+0xyrInd4BguMX5Ms52HfMOwPlQHJ6oWKq/f2hoReBVr6jFiSft93CN4hDELCW4FkJNjdIJ7dEobgE2laQzQazY8ZTvZ0dMS+v/bCaS9Nkqkc3hSki25Lo13FRUnIxDcuiIRlyFRBIlvepwd2kStCWs6eQqEBYQYExgtr5V1iGG+YfmB7lvKdmWjfWK2QteBDPceFMWBujqPadykVMZ+3QPht7lHw6ev5DSOoMvUuFqNnmgxFG898MM7PQkDcIuPdsaWCkhNVJrtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PygPHqprha7K8FjZZ0l+m6hCgp5shKtLrsMhbt1BQuc=;
 b=Z0wFNkSR+ho5FYVDBq9j4nirhWOnfjqYO50xwt0hfO6KFHCjulV43o+uN56Jwi5fgynfx5wNsh76YSauXrWZO/Ax7Gox5dUg5+7WMa1POdBEXoaZdhfCWGdCFCpoYzEMNS83ZGbg4Ne5TLl2J2sFEEwqIJU9PJ9V6p5baQmuDW4d1XTc0nOyHiycjcmnWxvEhABBY2nwPSxVg1GuqA3sd2fWIHvG9ud2k6ZKr5Z1onsEjn7ZWN7korQeTCfC/uOhxXYlSly5Zol8+vEroVqigNfXgKVEFTdiN2mKbES5Qs+Pe2xcBh43aXCp5TugxmuoSo5cq+OK87ovfWzazmNLEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PygPHqprha7K8FjZZ0l+m6hCgp5shKtLrsMhbt1BQuc=;
 b=nVyfdPHzFxXkyhXmXuCWBsGGZ+B/3X4pZCTEC6O8u+CKsYPKQJcQSYlKMG9/FbbycRGt7nrwTD+pJLW44oOEgesPagStbAn3X/93wgr/6EHyDIfCM3tl/1FNQLPgjugAXIA1h2/twZ6jhkxVqnS4WAqi39l4DqA4nGkHqc/mjPA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:02 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:02 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:00 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 00/65] Simplify and improve the wfx driver
Thread-Topic: [PATCH v2 00/65] Simplify and improve the wfx driver
Thread-Index: AQHVy6s+cndN0n1vZ0q4WKXK99cqqw==
Date:   Wed, 15 Jan 2020 13:54:01 +0000
Message-ID: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 1974a7b7-89b5-4a8e-dfb0-08d799c2605e
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40943FF0A53C66FC3916E4A293370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OYm9JRUUB3iws0XCtRR/82EVy9pMvq5wusyV2pWmIGWosXjQhfwuHGrAiZ/k7iRs6RW3JatM+fNEVpEjuezAiAXvYrnZ61ZuBIrcTUNsVYEvWuo3C2rpHI36IFvwXsWnEN26Vnt0a32gvezXlHA2ctQBDXqJsr15/tYodg1TIj1wV31Nmrvld39q7Jiic819mkyUgz57o4ftpLhQ6VFGrAMEnsG/I6834W8lQAuwt0QP3E+mNaeDJ8o9zvZOkpv5iFxOTvATJRF34L6eKbSY7/40biJx1K9ar40i9fjTTJHCEbE7pRrmgK/N1MejF3ibuz8mbqIMH25my5CEb2mNopCUb6J9dBss0mrZtgCaeb82JqdLqKeZGuAzM6v9Uh8t0xv1OzUYw2r7G3UafNFXGGW1G7fo8qRNxaZFdmmIupFxiMgxAeyiyU81mmSrZyA0
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEFD7BE8F416CA47A85700541733D19A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1974a7b7-89b5-4a8e-dfb0-08d799c2605e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:01.8588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9EdSQei5x1qUlZyvoPQjPT7R74uFPN2LjpNaxD0rvIWJpM6LnPgIaAllIbEfTNJV9xD3rAfbOPmZz3dGdaG+2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8gYWxsLAoKVGhpcyBwdWxsIHJlcXVlc3QgaXMgZmluYWxseSBiaWdnZXIgdGhhbiBJIGV4cGVj
dGVkLCBzb3JyeS4KCkl0IGNvbnRhaW5zIDIgbWFpbiB0b3BpY3M6CiAgLSBTaW1wbGlmeSBoYW5k
bGluZyBvZiBzdGF0aW9ucyBpbiBwb3dlciBzYXZlIG1vZGUuIE1vc3Qgb2YgdGhlIHdvcmsKICAg
IHdhcyByZWR1bmRhbnQgd2l0aCBtYWM4MDIxMS4gSSBoYXZlIHNhdmVkIHBsZW50eSBvZiBsaW5l
cyBvZiBjb2RlCiAgICBieSB1c2luZyB0aGUgbWFjODAyMTEgQVBJIGJldHRlci4KICAtIENvbnRp
bnVlIHRvIGNsZWFybHkgc2VwYXJhdGUgaGFyZHdhcmUgaW50ZXJmYWNlIGZyb20gdGhlIHJlc3Qg
b2YKICAgIHRoZSBkcml2ZXIuIFRoZSBiaWdnZXN0IHBhcnQgb2YgdGhpcyBjbGVhbi11cCBpcyBk
b25lLiBJdCBpcyBub3cKICAgIHBvc3NpYmxlIHRvIGxvb2sgYXQgdGhlIHdhcm5pbmcgcmFpc2Vk
IGJ5IHNwYXJzZSBhbmQgZml4CiAgICBzdXBwb3J0IGZvciBiaWcgZW5kaWFuIGhvc3RzLgogICAg
CnYyOgogIC0gTm93IGl0IGNvbXBpbGVzIChhIGxhc3QgbWludXRlIHJlYmFzZSBkaWQgYnJlYWsg
dGhlIGJ1aWxkKS4KCkrDqXLDtG1lIFBvdWlsbGVyICg2NSk6CiAgc3RhZ2luZzogd2Z4OiByZXZl
cnQgdW5leHBlY3RlZCBjaGFuZ2UgaW4gZGVidWdmcyBvdXRwdXQKICBzdGFnaW5nOiB3Zng6IG1h
a2UgaGlmX3NjYW4oKSB1c2FnZSBjbGVhcmVyCiAgc3RhZ2luZzogd2Z4OiBhZGQgbWlzc2luZyBQ
Uk9CRV9SRVNQX09GRkxPQUQgZmVhdHVyZQogIHN0YWdpbmc6IHdmeDogc2VuZCByYXRlIHBvbGlj
aWVzIG9uZSBieSBvbmUKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9zZXRfdHhfcmF0ZV9y
ZXRyeV9wb2xpY3koKSB1c2FnZQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9vdXRw
dXRfcG93ZXIoKSB1c2FnZQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9yY3BpX3Jz
c2lfdGhyZXNob2xkKCkgdXNhZ2UKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9zZXRfYXJw
X2lwdjRfZmlsdGVyKCkgdXNhZ2UKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9zdGFydCgp
IHVzYWdlCiAgc3RhZ2luZzogd2Z4OiB1c2Ugc3BlY2lhbGl6ZWQgc3RydWN0cyBmb3IgSElGIGFy
Z3VtZW50cwogIHN0YWdpbmc6IHdmeDogcmV0cmlldmUgYW1wZHVfZGVuc2l0eSBmcm9tIHN0YS0+
aHRfY2FwCiAgc3RhZ2luZzogd2Z4OiByZXRyaWV2ZSBncmVlbmZpZWxkIG1vZGUgZnJvbSBzdGEt
Pmh0X2NhcCBhbmQgYnNzX2NvbmYKICBzdGFnaW5nOiB3Zng6IGRyb3Agc3RydWN0IHdmeF9odF9p
bmZvCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHdkZXYtPm91dHB1dF9wb3dlcgogIHN0YWdpbmc6IHdm
eDogc2ltcGxpZnkgd2Z4X2NvbmZpZygpCiAgc3RhZ2luZzogd2Z4OiByZW5hbWUgd2Z4X3VwbG9h
ZF9iZWFjb24oKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgd2Z4X3VwbG9hZF9hcF90ZW1wbGF0
ZXMoKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgd2Z4X3VwZGF0ZV9iZWFjb25pbmcoKQogIHN0
YWdpbmc6IHdmeDogZml4IF9fd2Z4X2ZsdXNoKCkgd2hlbiBkcm9wID09IGZhbHNlCiAgc3RhZ2lu
Zzogd2Z4OiBzaW1wbGlmeSB3ZnhfZmx1c2goKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgdXBk
YXRlIG9mIERUSU0gcGVyaW9kCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHd2aWYtPmR0aW1fcGVyaW9k
CiAgc3RhZ2luZzogd2Z4OiBkcm9wIHd2aWYtPmVuYWJsZV9iZWFjb24KICBzdGFnaW5nOiB3Zng6
IGRyb3Agd3ZpZi0+Y3FtX3Jzc2lfdGhvbGQKICBzdGFnaW5nOiB3Zng6IGRyb3Agd3ZpZi0+c2V0
YnNzcGFyYW1zX2RvbmUKICBzdGFnaW5nOiB3Zng6IGRyb3Agd2Z4X3NldF9jdHNfd29yaygpCiAg
c3RhZ2luZzogd2Z4OiBTU0lEIHNob3VsZCBiZSBwcm92aWRlZCB0byBoaWZfc3RhcnQoKSBldmVu
IGlmIGhpZGRlbgogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3VwZGF0ZV9pZSgpCiAgc3Rh
Z2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfam9pbigpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBo
aWZfc2V0X2Fzc29jaWF0aW9uX21vZGUoKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3Nl
dF91Y19tY19iY19jb25kaXRpb24oKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX21pYl91
Y19tY19iY19kYXRhX2ZyYW1lX2NvbmRpdGlvbgogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlm
X21pYl9zZXRfZGF0YV9maWx0ZXJpbmcKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9zZXRf
ZGF0YV9maWx0ZXJpbmcoKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9tYWNfYWRk
cl9jb25kaXRpb24oKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgaGlmX3NldF9jb25maWdfZGF0
YV9maWx0ZXIoKQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgd2Z4X3NldF9tY2FzdF9maWx0ZXIo
KQogIHN0YWdpbmc6IHdmeDogc2ltcGxpZnkgd2Z4X3VwZGF0ZV9maWx0ZXJpbmcoKQogIHN0YWdp
bmc6IHdmeDogc2ltcGxpZnkgd2Z4X3NjYW5fY29tcGxldGUoKQogIHN0YWdpbmc6IHdmeDogdXBk
YXRlIHBvd2VyLXNhdmUgcGVyIGludGVyZmFjZQogIHN0YWdpbmc6IHdmeDogd2l0aCBtdWx0aXBs
ZSB2aWZzLCBmb3JjZSBQUyBvbmx5IGlmIGNoYW5uZWxzIGRpZmZlcnMKICBzdGFnaW5nOiB3Zng6
IGRvIG5vdCB1cGRhdGUgdWFwc2QgaWYgbm90IG5lY2Vzc2FyeQogIHN0YWdpbmc6IHdmeDogZml4
IGNhc2Ugd2hlcmUgUlRTIHRocmVzaG9sZCBpcyAwCiAgc3RhZ2luZzogd2Z4OiBmaXggcG9zc2li
bGUgb3ZlcmZsb3cgb24gamlmZmllcyBjb21wYXJhaXNvbgogIHN0YWdpbmc6IHdmeDogcmVtb3Zl
IGhhbmRsaW5nIG9mICJlYXJseV9kYXRhIgogIHN0YWdpbmc6IHdmeDogcmVsb2NhdGUgImJ1ZmZl
cmVkIiBpbmZvcm1hdGlvbiB0byBzdGFfcHJpdgogIHN0YWdpbmc6IHdmeDogZml4IGJzc19sb3Nz
CiAgc3RhZ2luZzogd2Z4OiBmaXggUkNVIHVzYWdlCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSB3
Znhfc2V0X3RpbV9pbXBsKCkKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IHRoZSBsaW5rLWlkIGFs
bG9jYXRpb24KICBzdGFnaW5nOiB3Zng6IGNoZWNrIHRoYXQgbm8gdHggaXMgcGVuZGluZyBiZWZv
cmUgcmVsZWFzZSBzdGEKICBzdGFnaW5nOiB3Zng6IHJlcGxhY2Ugd2Z4X3R4X2dldF90aWQoKSB3
aXRoIGllZWU4MDIxMV9nZXRfdGlkKCkKICBzdGFnaW5nOiB3Zng6IHBzcG9sbF9tYXNrIG1ha2Ug
bm8gc2Vuc2UKICBzdGFnaW5nOiB3Zng6IHN0YSBhbmQgZHRpbQogIHN0YWdpbmc6IHdmeDogZmly
bXdhcmUgbmV2ZXIgcmV0dXJuIFBTIHN0YXR1cyBmb3Igc3RhdGlvbnMKICBzdGFnaW5nOiB3Zng6
IHNpbXBsaWZ5IHdmeF9zdXNwZW5kX3Jlc3VtZV9tYygpCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlm
eSBoYW5kbGluZyBvZiBJRUVFODAyMTFfVFhfQ1RMX1NFTkRfQUZURVJfRFRJTQogIHN0YWdpbmc6
IHdmeDogc2ltcGxpZnkgd2Z4X3BzX25vdGlmeV9zdGEoKQogIHN0YWdpbmc6IHdmeDogZW5zdXJl
IHRoYXQgcGFja2V0X2lkIGlzIHVuaXF1ZQogIHN0YWdpbmc6IHdmeDogcmVtb3ZlIHVudXNlZCBk
b19wcm9iZQogIHN0YWdpbmc6IHdmeDogcmVtb3ZlIGNoZWNrIGZvciBpbnRlcmZhY2Ugc3RhdGUK
ICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9oYW5kbGVfdHhfZGF0YSgpCiAgc3RhZ2luZzog
d2Z4OiBzaW1wbGlmeSB3ZnhfdHhfcXVldWVfZ2V0X251bV9xdWV1ZWQoKQogIHN0YWdpbmc6IHdm
eDogc2ltcGxpZnkgaGlmX211bHRpX3R4X2NvbmZpcm0oKQogIHN0YWdpbmc6IHdmeDogdXBkYXRl
IFRPRE8KCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8gICAgICAgICAgfCAgMTIgKy0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jICAgICB8ICA3NyArLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguYyAgICAgfCAzMTUgKysrLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3R4LmggICAgIHwgIDI1IC0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyAgICAg
ICB8ICAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIHwgICAzICstCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmggfCAgMjIgKy0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3J4LmMgICAgICB8ICAyMCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHgu
YyAgICAgIHwgIDQ5ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oICAgICAgfCAgMTEg
Ky0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oICB8IDE1NyArKysrKy0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgICAgICAgfCAgIDcgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvcXVldWUuYyAgICAgICB8IDIwNiArKystLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVl
dWUuaCAgICAgICB8ICAxMCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgICAgICAgIHwg
IDE0ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCAgICAgICAgfCAgIDUgKy0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgICB8IDczNSArKysrKysrKy0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmggICAgICAgICB8ICAxMyArLQogZHJp
dmVycy9zdGFnaW5nL3dmeC93ZnguaCAgICAgICAgIHwgIDI1ICstCiAxOSBmaWxlcyBjaGFuZ2Vk
LCA1MjYgaW5zZXJ0aW9ucygrKSwgMTE4MiBkZWxldGlvbnMoLSkKCi0tIAoyLjI1LjAKCg==
