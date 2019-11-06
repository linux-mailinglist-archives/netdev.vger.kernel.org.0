Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40CF1E74
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbfKFTQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:16:49 -0500
Received: from mail-eopbgr750079.outbound.protection.outlook.com ([40.107.75.79]:44612
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727615AbfKFTQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:16:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmZFpMg7TmwUtBiQ53cMxmrGI6uHoFm3ajfhm95f8rCh6ZRLjQMA2aecxO8VgpHECKfsFqmUoixxIkRA5Mnz8MJtFMZdXQHzCSNLHRHlvk2Bo28JuDNBs01Q9XcsCpqgVOI737WEofConA6+7HHAWYkF/vBHaKqwdQBM3AdGQnfd1dpxI/dNgRFz/XWMV/C7a8qlR8b/nKzjhMHL7cGvgTGr8aOKGBz5hW+8kIAIFyKKwIaMdowEisEAB/FuHRAyOrIqWLxFZwV3Y+9lC9pQ0sQIXpJqIcx9syyIfmOFaVlfwWW6sNgVwWhnNdc6XQUGK/QRKOKjW9lVOrViVo8r5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMJTltj0Go6mxEri+1JwZDHVW126XxCYtrEwkkRs/d4=;
 b=OyoSlfRP7VsnWEYiQivc+Zc6lgx/cm6f82Qquq8YqohXBi0nvunXg4gDbSDalHhOGIwBW6Avsu5CeBT9qnMfQ8fphtJ8jBQSWiJFgIFiQpUwMHSevu3HexA9ZcHJthqWhHe09n8kygXj3FmFWgm747c3SalGIgPhfXNjinvlv/92KYQk+Bb9WA84tRnE+LAZ9vUhmhGg68F/1RVDSHjvvo/UOZT4W2cdq8YbosAV2HlNivbQC+/notyw0XwCh3gZIrwMYSSCQldJLqIPm3SxhALqnHRL6ZccYovx+Jf3I0Ai8ziMd6to3SrdISu4oFjL2m9GJdDadTc9L7IcjZqUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMJTltj0Go6mxEri+1JwZDHVW126XxCYtrEwkkRs/d4=;
 b=awOEOma/MQhLj0m6KOByqdtZvbQRm2NuvW9ynF7X9/DAqZASCmxWDWWA5cKcgOrJiie7awG7rGGlHayGkpIBpusS7Y3sbec1cgz7leeR09t7KQNpDZBr+457J1gMBo4W7JIu7qwGw65jyYupdADAWwbfB2W5qzj1dynuGomAkBk=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3576.namprd15.prod.outlook.com (52.132.229.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 19:16:43 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::a0a2:ffd4:4a7f:7a63]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::a0a2:ffd4:4a7f:7a63%7]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 19:16:43 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
Subject: RE: [net-next 1/2] tipc: update cluster capabilities if node deleted
Thread-Topic: [net-next 1/2] tipc: update cluster capabilities if node deleted
Thread-Index: AQHVlGslx91tbrousEamVXVMV+qFsad+hI8g
Date:   Wed, 6 Nov 2019 19:16:43 +0000
Message-ID: <CH2PR15MB3575236202A3DB62E731A1109A790@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [192.75.88.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98732f2c-8707-47ff-8bad-08d762eddc56
x-ms-traffictypediagnostic: CH2PR15MB3576:
x-ld-processed: 92e84ceb-fbfd-47ab-be52-080c6b87953f,ExtAddr
x-microsoft-antispam-prvs: <CH2PR15MB35767BB675DF58DBCE2E408C9A790@CH2PR15MB3576.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(13464003)(189003)(199004)(66946007)(2906002)(71190400001)(66476007)(5660300002)(76116006)(66556008)(64756008)(71200400001)(66446008)(14454004)(99286004)(14444005)(110136005)(256004)(52536014)(7736002)(498600001)(74316002)(446003)(26005)(305945005)(229853002)(55016002)(25786009)(2501003)(2201001)(102836004)(11346002)(6116002)(3846002)(6436002)(81166006)(7696005)(53546011)(6506007)(66066001)(81156014)(76176011)(8936002)(33656002)(15650500001)(476003)(8676002)(44832011)(486006)(186003)(9686003)(86362001)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3576;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zVkaQMWu/U7SoJ9uByV6jjdzK6N40IICRNKIDy05u5dp4W0p33otssohZbenHiQ9OVyqYLFrJOUA4Ia0PDJzk3YK7+0yNJVQ4T0VUp+z3jbihSM41All0SbiISK3QTkZR0n2anloGA0JcGpBwvKsENtfTsGYyxEStoZ7hazG3qL5pMMExFoGP4Pkb3REy8Yk7SWFRiBOuz4U/cDVY2OfK7HAos8g3pDngGOWTMcjfui4110S7tQrto1ftcwK8IAz+AJtwY+8DhqVoDOrnziYlvlmge6/AQu1666UREcQQGkIaeyKFKGYkXo+tTRGY7tPCg0Fjf4H0nyAG5TGzOrKKF/Q6Mobxqy92ZRegUPPj6tv7idg6W3C44CeCEcVvWXiBgfh6+P6eLkDOA2aR8lEVj/DpDUXbKEGtLAcadKXD2pbPsN++p0A5TgoJ3O3LKfr
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98732f2c-8707-47ff-8bad-08d762eddc56
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 19:16:43.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oKC/H+MEfv8eJYL+u/MV7NvTRs6wsJ/U6kAh3tYYGmuBLZCUYuwNXBdW5dlytNw5W15RS3HAyBges884NEnqtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWNrZWQtYnk6IEpvbg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhv
YW5nIExlIDxob2FuZy5oLmxlQGRla3RlY2guY29tLmF1Pg0KPiBTZW50OiA2LU5vdi0xOSAwMToy
Ng0KPiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJpY3Nzb24uY29tPjsgbWFsb3lAZG9uam9u
bi5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRpcGMtDQo+IGRpc2N1c3Npb25AbGlzdHMu
c291cmNlZm9yZ2UubmV0DQo+IFN1YmplY3Q6IFtuZXQtbmV4dCAxLzJdIHRpcGM6IHVwZGF0ZSBj
bHVzdGVyIGNhcGFiaWxpdGllcyBpZiBub2RlIGRlbGV0ZWQNCj4gDQo+IFRoZXJlIGFyZSB0d28g
aW1wcm92ZW1lbnRzIHdoZW4gcmUtY2FsY3VsYXRlIGNsdXN0ZXIgY2FwYWJpbGl0aWVzOg0KPiAN
Cj4gLSBXaGVuIGRlbGV0aW5nIGEgc3BlY2lmaWMgZG93biBub2RlLCBuZWVkIHRvIHJlLWNhbGN1
bGF0ZS4NCj4gLSBJbiB0aXBjX25vZGVfY2xlYW51cCgpLCBkbyBub3QgbmVlZCB0byByZS1jYWxj
dWxhdGUgaWYgbm9kZQ0KPiBpcyBzdGlsbCBleGlzdGluZyBpbiBjbHVzdGVyLg0KPiANCj4gQWNr
ZWQtYnk6IEpvbiBNYWxveSA8am9uLm1hbG95QGVyaWNzc29uLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogSG9hbmcgTGUgPGhvYW5nLmgubGVAZGVrdGVjaC5jb20uYXU+DQo+IC0tLQ0KPiAgbmV0L3Rp
cGMvbm9kZS5jIHwgMTIgKysrKysrKysrKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC90aXBjL25vZGUu
YyBiL25ldC90aXBjL25vZGUuYw0KPiBpbmRleCA3NDJjMDQ3NTZkNzIuLmEyMGZhYmQwOWU3ZSAx
MDA2NDQNCj4gLS0tIGEvbmV0L3RpcGMvbm9kZS5jDQo+ICsrKyBiL25ldC90aXBjL25vZGUuYw0K
PiBAQCAtNjY1LDYgKzY2NSwxMSBAQCBzdGF0aWMgYm9vbCB0aXBjX25vZGVfY2xlYW51cChzdHJ1
Y3QgdGlwY19ub2RlICpwZWVyKQ0KPiAgCX0NCj4gIAl0aXBjX25vZGVfd3JpdGVfdW5sb2NrKHBl
ZXIpOw0KPiANCj4gKwlpZiAoIWRlbGV0ZWQpIHsNCj4gKwkJc3Bpbl91bmxvY2tfYmgoJnRuLT5u
b2RlX2xpc3RfbG9jayk7DQo+ICsJCXJldHVybiBkZWxldGVkOw0KPiArCX0NCj4gKw0KPiAgCS8q
IENhbGN1bGF0ZSBjbHVzdGVyIGNhcGFiaWxpdGllcyAqLw0KPiAgCXRuLT5jYXBhYmlsaXRpZXMg
PSBUSVBDX05PREVfQ0FQQUJJTElUSUVTOw0KPiAgCWxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KHRl
bXBfbm9kZSwgJnRuLT5ub2RlX2xpc3QsIGxpc3QpIHsNCj4gQEAgLTIwNDEsNyArMjA0Niw3IEBA
IGludCB0aXBjX25sX3BlZXJfcm0oc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGdlbmxfaW5m
byAqaW5mbykNCj4gIAlzdHJ1Y3QgbmV0ICpuZXQgPSBzb2NrX25ldChza2ItPnNrKTsNCj4gIAlz
dHJ1Y3QgdGlwY19uZXQgKnRuID0gbmV0X2dlbmVyaWMobmV0LCB0aXBjX25ldF9pZCk7DQo+ICAJ
c3RydWN0IG5sYXR0ciAqYXR0cnNbVElQQ19OTEFfTkVUX01BWCArIDFdOw0KPiAtCXN0cnVjdCB0
aXBjX25vZGUgKnBlZXI7DQo+ICsJc3RydWN0IHRpcGNfbm9kZSAqcGVlciwgKnRlbXBfbm9kZTsN
Cj4gIAl1MzIgYWRkcjsNCj4gIAlpbnQgZXJyOw0KPiANCj4gQEAgLTIwODIsNiArMjA4NywxMSBA
QCBpbnQgdGlwY19ubF9wZWVyX3JtKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBnZW5sX2lu
Zm8gKmluZm8pDQo+ICAJdGlwY19ub2RlX3dyaXRlX3VubG9jayhwZWVyKTsNCj4gIAl0aXBjX25v
ZGVfZGVsZXRlKHBlZXIpOw0KPiANCj4gKwkvKiBDYWxjdWxhdGUgY2x1c3RlciBjYXBhYmlsaXRp
ZXMgKi8NCj4gKwl0bi0+Y2FwYWJpbGl0aWVzID0gVElQQ19OT0RFX0NBUEFCSUxJVElFUzsNCj4g
KwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3JjdSh0ZW1wX25vZGUsICZ0bi0+bm9kZV9saXN0LCBsaXN0
KSB7DQo+ICsJCXRuLT5jYXBhYmlsaXRpZXMgJj0gdGVtcF9ub2RlLT5jYXBhYmlsaXRpZXM7DQo+
ICsJfQ0KPiAgCWVyciA9IDA7DQo+ICBlcnJfb3V0Og0KPiAgCXRpcGNfbm9kZV9wdXQocGVlcik7
DQo+IC0tDQo+IDIuMjAuMQ0KDQo=
