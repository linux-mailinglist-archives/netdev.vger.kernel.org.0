Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6C72263
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392538AbfGWW3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:29:10 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:24451
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729617AbfGWW3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:29:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYTQP+zMOFsUbn2sG+ObO762b+m/4asuPyZivZ1sEy81cv0JHMrPb+JsH8ZVi0GjtWRw0eK5X5M4UIX8IE2k4rZ1BXH6Fnw7N/94+4Pgeq/UG/9+FSFRbBlMB8mPSZ9g5SauSbggQY9XSa79FApFTYGx+fkjdFTrrowSvVmcynQXS+m94FP4lm+hE+0J6iHjxKr8R664lBTeyv/h50c71sYTP4F7EmuzlEmCAMUKgP0OiPVqmGCn4yve5QR+3lHVYab50LMcO0KRCnfgOpZ7WE25lwFW6jlLn4rwBxw+LCTJ18aVV8IFLOERTKyQo6lLT9VK3g6KtAp+AQE+zGeisA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CELCRh48N3xqTSwdWC2ejrBlNzAmapk2aOD7YazrgSM=;
 b=HmzacgPYJfTGH4iXhRUmJRaFGym392Ut/Ee7IzMNGf6eW/27ez9qJIkhx99c8TE6LWPypjJrFmwUWoNW+GF1OH1s0QKQ26CL00UWDzx9Kya/RISZ8SnY/rtB9qEy+OvpZdKmFd+E8LsJvtPTldz0y7mhnb5r8BmpjnG+nDr93fB3tek3YoE8NQg1h63b1ajRjzzzLWQEfK4Q255LGk/B2vLcM7RvPW3GFXsPCUjhgEDU/Cw8aZzzPpkGd7uxMLVuwhc0nDWs4f5s0LkTG3t5i28co3N8NZUMtfHIbO41enuHs9IbXL8ZaNasthGVZ7WTCWmHERqbj2afLtwo/ySQiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CELCRh48N3xqTSwdWC2ejrBlNzAmapk2aOD7YazrgSM=;
 b=JK2VVJYRoNxbsp0K8+7RGa1XXcVitXjZH+wyHHiLVfhASA52MpESCaB6FzPLlBSB5spez/r+tBYUDFenxl01+zQoi/IoxRtZn8t9/4TWvPvK8mzUADnVuonVSgHIbbj0EiGcyGbwGnXFOU1zdOB+38p7jF3yVLynqZjLr60QQrQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2824.eurprd05.prod.outlook.com (10.172.226.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 22:29:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 22:29:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willy@infradead.org" <willy@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "hch@lst.de" <hch@lst.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Thread-Topic: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Thread-Index: AQHVOLf8iJMmCRNg5EmRYlClumhf36bY2qAA
Date:   Tue, 23 Jul 2019 22:29:06 +0000
Message-ID: <2b45504e005f88a033405225b04fba0b5dcf2e92.camel@mellanox.com>
References: <20190712134345.19767-1-willy@infradead.org>
         <20190712134345.19767-5-willy@infradead.org>
In-Reply-To: <20190712134345.19767-5-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90510248-e54e-47b0-cecc-08d70fbd2ca2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2824;
x-ms-traffictypediagnostic: DB6PR0501MB2824:
x-microsoft-antispam-prvs: <DB6PR0501MB28245689A7A860C80E4716B5BEC70@DB6PR0501MB2824.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(189003)(199004)(36756003)(25786009)(2616005)(446003)(118296001)(53936002)(6116002)(3846002)(6436002)(81156014)(71200400001)(7736002)(71190400001)(478600001)(11346002)(486006)(26005)(476003)(8936002)(6512007)(6486002)(81166006)(2906002)(8676002)(186003)(305945005)(66066001)(58126008)(2501003)(6506007)(256004)(110136005)(14454004)(99286004)(316002)(14444005)(229853002)(68736007)(64756008)(66476007)(66556008)(6246003)(4744005)(66446008)(54906003)(5660300002)(86362001)(76116006)(66946007)(76176011)(102836004)(91956017)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2824;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 30qvx1v0kOba22ZB56HWx688IKVELPw33LSZeLIR+9SD6pHi0ockKjHDJvFV6XrQndCY2z6qSg4mjTvecPvBztMo8SYV5kDsmX6G2xs3Exi4/iGobV7tuuAC2gYB6GToJNf7+tAUhACMXr94NZLSeknPdGFP3p7RBtAP4lySLfuVaDx/Gia2BUnwJaiDkY1p5WhSd2YJAAgwwqNLOunMCBPwBvEOYvTPeHQMKE8bLDoKQ9/uI7QpdtKUlMEa3HOjurdAusw74vzeKgPX8pMpkHrx1sow+iRKJRnXOGS7OVzvEU1oC0yj2CMCBnZktamHZ6LFfwr7/9DN2PvLTCkQWJI7kBFB2QAtdVaDyOOXQ5pOSdYsAr6Vun6KVLmPGpAXgI7d3OI1EShFvwwF0xN/9+dofEciBfu85RSDjHLHCno=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34F652FD5E97CD40B8223BB123B33657@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90510248-e54e-47b0-cecc-08d70fbd2ca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:29:06.6598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTEyIGF0IDA2OjQzIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gRnJvbTogIk1hdHRoZXcgV2lsY294IChPcmFjbGUpIiA8d2lsbHlAaW5mcmFkZWFkLm9yZz4N
Cj4gDQo+IE1hdGNoIHRoZSBsYXlvdXQgb2YgYmlvX3ZlYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IE1hdHRoZXcgV2lsY294IChPcmFjbGUpIDx3aWxseUBpbmZyYWRlYWQub3JnPg0KPiAtLS0NCj4g
IGluY2x1ZGUvbGludXgvc2tidWZmLmggfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3NrYnVmZi5oIGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KPiBpbmRleCA3OTEwOTM1NDEwZTYu
LmI5ZGM4YjRmMjRiMSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KPiAr
KysgYi9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQo+IEBAIC0zMTQsOCArMzE0LDggQEAgc3RydWN0
IHNrYl9mcmFnX3N0cnVjdCB7DQo+ICAJc3RydWN0IHsNCj4gIAkJc3RydWN0IHBhZ2UgKnA7DQo+
ICAJfSBwYWdlOw0KPiAtCV9fdTMyIHBhZ2Vfb2Zmc2V0Ow0KPiAgCV9fdTMyIHNpemU7DQo+ICsJ
X191MzIgcGFnZV9vZmZzZXQ7DQo+ICB9Ow0KPiAgDQoNCldoeSBkbyB5b3UgbmVlZCB0aGlzIHBh
dGNoPyB0aGlzIHN0cnVjdCBpcyBnb2luZyB0byBiZSByZW1vdmVkDQpkb3duc3RyZWFtIGV2ZW50
dWFsbHkgLi4NCg0KPiAgLyoqDQo=
