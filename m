Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A751210A8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfLPRFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:05:12 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727015AbfLPRD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aH0x/iAVVKsNQG+gEQAedTQi55DGrttJeqt7wv7xTTxtTiUb//3rACEpDfot0s36ZN7agGDkZCcNaKk0STeZiQSAMP4pVmmNu7bRdNw8NEOYU8Z55rNpnIew1ZSItsuC2REIGh+l2ntz6ECWqFHfqdu9uabnKG89V5GN3N/lQH+a77U+2JS+EqgmKKqrerHzxIgL2fc34qzmOCjlhB/fcBuJ+UJDv+fcR5r+B/MHk+arDyKkzjwpOlm7czDH3/AxG72ztbUOkYu4JSa+veWOSAFkJdf7+wC6wQMvKj3J7CF2BjZI2iNvIu+eMTrqVAeEFxwvokvPiaDqcBpuEOcs3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7tXuYx2dOSQbmWepOf+xma40ECr9xpJr1eswoJ0yio=;
 b=bV3bHq7cHVWwRiEeTDcmHd4duNPoio7vB2tdRrCTKRU+NEdNpVAzT3oKXzkxNYBGd2+6Rj7hukleKZImY5rUDgJlpidZtFmFFHcnojtRv1zmSCiut2jgMRaRfJbkEqjdtMLaS0c46N6EJzMYcLAkmu/Gsm3HsUZpruAFNf1zBvCHzI5YfKnXvp8BB9JXVelMZPYzy2qOiaK2e4lEjs4373r13svUmlwu4TPg8vfHhZ5knbMYOAdIzKRjuYBUANXLdloNYDZlFA/y9EPzR6rOgV11tUZ3VWciaq7LAOp+F9rTXpXUMvnmK0grdRzx0EcSv/QxoHITFvPYhw41orYUOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7tXuYx2dOSQbmWepOf+xma40ECr9xpJr1eswoJ0yio=;
 b=nu5dC399iCG0AeQDXe1cUx3KIUrgEMmvTxE0bOCM6qp8lozM3k7YNjVhenSdhI27yBbbjb7ZZbUVzLA8v4QhvDkbau/ZiadQSagohSP3yGwLF1hBA5DLurkSOKnoAFr2iHzkDOTDXHhEW44oor1Bx1XoA0QtDEJObTEGm8bNscU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:50 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:50 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 18/55] staging: wfx: remove useless include
Thread-Topic: [PATCH 18/55] staging: wfx: remove useless include
Thread-Index: AQHVtDLFwIWSXuE2ykSWZ5NGgqd7UQ==
Date:   Mon, 16 Dec 2019 17:03:42 +0000
Message-ID: <20191216170302.29543-19-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c9ff51d-3ca3-4a59-74a6-08d78249ec6b
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB43516D3EC64CC9DBC93E124693510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(4744005)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ih0/wSHYYQgv37KktA+WEnfB1vrYQqCjh1/ZN0YSM4GcNlQOREgC1JvWV602j44F7tqHk8k2F4sfICBurMiEMwr66gKBXuf0pBDCukiQuH8cxCqwhci0ZvkdHDkrJJbQiVTdgJVAJj8Gs7X+82Sqtae4fULTWOCgs8EdnSMRWeQA7O+IOBBYZZCoxLVGVKV16kTxTlN3hw/SA68Sn+vRPXHk662/SQDf+f8u4aqc5dVQVL7ziz+O9gUmNKojROfBmDTBne06jh3PdB54DF/PsACVMpf4EV344WyVpgrCY4TVkUukFwlobWDPSfFXhpwHhljO21V78CypkEoZDa++MYEPXogiH1GMApOaTtxauldbuAinlHnEM14QYwAZ/wh/TzC5ILIeIpQlYYfgVMyk5F5KWZgal/005bpgvdvJNKs4q6n059itnG9CoBujilNJ
Content-Type: text/plain; charset="utf-8"
Content-ID: <3061A0C7E72CF447901B76B4B17567A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9ff51d-3ca3-4a59-74a6-08d78249ec6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:42.7388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQxSzqV1XEcskf++LAVZ+LxxGd336sEZTSciOQRt6ZGRZe7fu1+75SZVtYCgTLjh+etza0cmxXQQ8SEy+UWZaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpo
aWZfdHguYyBkb2VzIG5vdCB1c2UgYW55IHN0cnVjdCBza2IuDQoNClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgfCAxIC0NCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlv
bigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4LmMNCmluZGV4IGNiN2NkZGNiOTgxNS4uZThjMmJkMWVmYmFj
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYw0KKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYw0KQEAgLTYsNyArNiw2IEBADQogICogQ29weXJpZ2h0IChj
KSAyMDE3LTIwMTksIFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuDQogICogQ29weXJpZ2h0IChj
KSAyMDEwLCBTVC1Fcmljc3Nvbg0KICAqLw0KLSNpbmNsdWRlIDxsaW51eC9za2J1ZmYuaD4NCiAj
aW5jbHVkZSA8bGludXgvZXRoZXJkZXZpY2UuaD4NCiANCiAjaW5jbHVkZSAiaGlmX3R4LmgiDQot
LSANCjIuMjAuMQ0K
