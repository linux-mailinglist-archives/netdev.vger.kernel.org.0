Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00994117E3D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfLJDic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:38:32 -0500
Received: from mail-eopbgr680121.outbound.protection.outlook.com ([40.107.68.121]:24310
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfLJDib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:38:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMRbRcl6fC/YxPhqeA0jyBTiByuBjIl4/CluYva3aUZem9AbL7TMzKc4VCj+wv/NnE/PcUkxOQl4kebLBogr1V1LLyYVhSLhZouG23IX9DWxj8WkOCC5X2FFMWAwriGoDjMEQuZAkmit/qVrzLE9wuzOtygRw3Dkhr54VYIH1bKul+mnYVvTEg4T706I1VwpfNAgaqKeZS721D1JChGz+spyo4ba/Fr8GUW65M98VylX29PGkRjlzTy6vNSyShFOxw6Wu5n9yvLFHbr7yqYziZg4WGf606K2yrc122fHIrO5z/tQCs+c+p/Z8wYldWSvBqPTr2pRfs9LVSSsiu/JrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1BkiyXLZFQpTqsQIdx8qHcrZq/2t/1HDdC67eIk88w=;
 b=dpIxm8KpEFpmsAEikWal6TqZlqYJB/0oKMHOTgMywXM0DvFlXN1yQenvMZ11AgJtjJSeXoO9tEWi/2BiCCB3vkAKadJen8L3mqgqhGbxDBkZCiSp7YR1mjJYwTQJFVabORQwrBm4OZft7Ux3g1g7qufa7UIvTzzoAd9robGndOQ+pgXqTed1rrEFw9Et9B6gwmSe5y8YDOqDcTobyUwDFY/VY00EzWK3XzC3da0OURS7Y1ZLcys/YQkhYvzhvDfojm465ifuQuJMIneiOlwguKgnIdcfDMkdQTZD1yctk3thWMHr7uyn4BLFvbpLC5h/qdlxduUDM18+bNnpWdFBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1BkiyXLZFQpTqsQIdx8qHcrZq/2t/1HDdC67eIk88w=;
 b=pkk+OLMH1ZXUd8PA/OVzM66MgZj0VTMk9cptxJ7nHMV0SMbVyCMNYIqQaznHYIwoXXNcdoBZsAC8C9YuLXUZkSli1stOdVOlbQnw2FJsLXfPdkH4t0YpNmsG2OMbKeu2uAG0HxS4CdejTFv5n+c/oDSSwOGzh6DwHUo9qvggz8E=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2646.namprd06.prod.outlook.com (10.173.39.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 03:37:46 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 03:37:46 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>
CC:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] brcmfmac: make errors when setting roaming parameters
 non-fatal
Thread-Topic: [PATCH 4/8] brcmfmac: make errors when setting roaming
 parameters non-fatal
Thread-Index: AQHVruFlOnuRdty+l0+GLrh99rhVXKeyuJUA
Date:   Tue, 10 Dec 2019 03:37:46 +0000
Message-ID: <47ad27cf-4ffb-d7b4-37cc-a1edb334e163@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-4-smoch@web.de>
In-Reply-To: <20191209223822.27236-4-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::25) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ed6034f-7cc6-4f9c-c689-08d77d22523f
x-ms-traffictypediagnostic: CY4PR06MB2646:|CY4PR06MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB264646B3E98B4B004130AF57BB5B0@CY4PR06MB2646.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(36756003)(6512007)(316002)(2906002)(2616005)(3450700001)(305945005)(31696002)(81166006)(4326008)(81156014)(66446008)(186003)(31686004)(8676002)(64756008)(53546011)(66556008)(66476007)(66946007)(6506007)(478600001)(54906003)(52116002)(26005)(110136005)(229853002)(86362001)(6486002)(5660300002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2646;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dA3tDUg3uGH+erfVz0gSrIDw7mv3Gg9d0sL9KhwHqGOzufGZrEvvyCwDqReZWTBqVv5lZ81KFGUw/EYIAdoffsnWUUYRVzI/EFOZg34wzVy60CiXanEzWkP/5alkW1RPs9P1ipbVPAzejQgeOhe/lUbKkj+zCg2zEyUmKBrn0nHrlqFD+YOC9ApDKDGBeSZLQ6FjWIuxRYQ2/eVGWEibVZ48j//oqATNFL2U62qFry3DvnRdEiohJb7JfDgynSRXdXWFR01lylwsWD4eMblvD+uy3LlBSwN3LBoEBLTDKHAPXB7gBXCoPejlP5mdhZ/traN07cTa3heXEs91RGBkjq8AmnUdMmox5R9o0SdrYSjQI3r4KdNKPq7PzNRxwipwHUYoDsZRLloYscd/exul0l3lCVUHhpKDuhEPDKHu6A3MAOwanPuol87O2M0JEtJ1
Content-Type: text/plain; charset="utf-8"
Content-ID: <80E94353ED6CDF4490ABE6F81FD619DC@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed6034f-7cc6-4f9c-c689-08d77d22523f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:37:46.2993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/zL+Uzediwt+oLBXLkK3zKT8lfukbpbwVn9EbQGVlNx+TqH50dyUzB9V2PfltW+mx3dOgAuOiVrUqIAceLlpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgNjozOCwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IDQzNTkgZG9uZ2xl
cyBkbyBub3Qgc3VwcG9ydCBzZXR0aW5nIHJvYW1pbmcgcGFyYW1ldGVycyAoZXJyb3IgLTUyKS4N
Cj4gRG8gbm90IGZhaWwgdGhlIDgwMjExIGNvbmZpZ3VyYXRpb24gaW4gdGhpcyBjYXNlLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogU29lcmVuIE1vY2ggPHNtb2NoQHdlYi5kZT4NCkFja2VkLWJ5OiBD
aGktSHNpZW4gTGluIDxjaGktaHNpZW4ubGluQGN5cHJlc3MuY29tPg0KDQo+IC0tLQ0KPiBDYzog
S2FsbGUgVmFsbyA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+DQo+IENjOiBBcmVuZCB2YW4gU3ByaWVs
IDxhcmVuZC52YW5zcHJpZWxAYnJvYWRjb20uY29tPg0KPiBDYzogRnJhbmt5IExpbiA8ZnJhbmt5
LmxpbkBicm9hZGNvbS5jb20+DQo+IENjOiBIYW50ZSBNZXVsZW1hbiA8aGFudGUubWV1bGVtYW5A
YnJvYWRjb20uY29tPg0KPiBDYzogQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXByZXNz
LmNvbT4NCj4gQ2M6IFdyaWdodCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNzLmNvbT4NCj4gQ2M6
IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBDYzogYnJjbTgwMjExLWRldi1saXN0
LnBkbEBicm9hZGNvbS5jb20NCj4gQ2M6IGJyY204MDIxMS1kZXYtbGlzdEBjeXByZXNzLmNvbQ0K
PiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiAtLS0NCj4gICAuLi4vd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL2NmZzgwMjExLmMgICAgfCAxMCArKysrLS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jZmc4MDIxMS5j
DQo+IGluZGV4IDU1OThiYmQwOWI2Mi4uMGNmMTNjZWExZGJlIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYw0K
PiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y2ZnODAyMTEuYw0KPiBAQCAtNjAxMiwxOSArNjAxMiwxNyBAQCBzdGF0aWMgczMyIGJyY21mX2Rv
bmdsZV9yb2FtKHN0cnVjdCBicmNtZl9pZiAqaWZwKQ0KPiAgIAlyb2FtdHJpZ2dlclsxXSA9IGNw
dV90b19sZTMyKEJSQ01fQkFORF9BTEwpOw0KPiAgIAllcnIgPSBicmNtZl9maWxfY21kX2RhdGFf
c2V0KGlmcCwgQlJDTUZfQ19TRVRfUk9BTV9UUklHR0VSLA0KPiAgIAkJCQkgICAgICh2b2lkICop
cm9hbXRyaWdnZXIsIHNpemVvZihyb2FtdHJpZ2dlcikpOw0KPiAtCWlmIChlcnIpIHsNCj4gKwlp
ZiAoZXJyKQ0KPiAgIAkJYnBoeV9lcnIoZHJ2ciwgIldMQ19TRVRfUk9BTV9UUklHR0VSIGVycm9y
ICglZClcbiIsIGVycik7DQo+IC0JCWdvdG8gcm9hbV9zZXR1cF9kb25lOw0KPiAtCX0NCj4gDQo+
ICAgCXJvYW1fZGVsdGFbMF0gPSBjcHVfdG9fbGUzMihXTF9ST0FNX0RFTFRBKTsNCj4gICAJcm9h
bV9kZWx0YVsxXSA9IGNwdV90b19sZTMyKEJSQ01fQkFORF9BTEwpOw0KPiAgIAllcnIgPSBicmNt
Zl9maWxfY21kX2RhdGFfc2V0KGlmcCwgQlJDTUZfQ19TRVRfUk9BTV9ERUxUQSwNCj4gICAJCQkJ
ICAgICAodm9pZCAqKXJvYW1fZGVsdGEsIHNpemVvZihyb2FtX2RlbHRhKSk7DQo+IC0JaWYgKGVy
cikgew0KPiArCWlmIChlcnIpDQo+ICAgCQlicGh5X2VycihkcnZyLCAiV0xDX1NFVF9ST0FNX0RF
TFRBIGVycm9yICglZClcbiIsIGVycik7DQo+IC0JCWdvdG8gcm9hbV9zZXR1cF9kb25lOw0KPiAt
CX0NCj4gKw0KPiArCXJldHVybiAwOw0KPiANCj4gICByb2FtX3NldHVwX2RvbmU6DQo+ICAgCXJl
dHVybiBlcnI7DQo+IC0tDQo+IDIuMTcuMQ0KPiANCj4gLg0KPiANCg==
