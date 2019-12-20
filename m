Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F961283DD
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 22:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfLTV1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 16:27:08 -0500
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:62004
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727422AbfLTV1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 16:27:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+DagKYzu1nrlMb/2U68sisYaf0C4AgV/oJDOOaP8a9UtkPHF244pYi7Mzp6wamBcuZsDpQH5L7Kfm3wvQLTAf1w1YcQA0eXUAHE1GNfCQUGfwCOXGd9Qe/tAEVBPmcb1kWWWlimE5Fux0ztab3jr6TETbx/Dt/4pxqt4rsdfR9+ZqXuRUvXfmSRBdV9Sukmq694SRBy0U5DZgK7numbmXAy0nOiyWerYjKMH8wyxGn7mTqW79SJN2kse2bNUpP/5s35nGzrV40+2E+SLxIz8B7MjHSYu/az8iAzocUJ1CFvE7AnljBfx0iScqWMkW60IbDoCK1CuuHxZ2OT3rMIcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC2kC9OsSTA2LG6fabLRuYQGRN0WjeyeEwYsV+WPn+0=;
 b=eBmq/G82mn/4OtUyNv0o6txKZDegQPg+aKiiNajxQJrOxUsNFMwbT+N3QSiqanAJqkaKoCZvPsWDbD8wpz3w6vjLYOQE27XZQV2ZEZpFBCv1JPb/fdxf6LEJTcZpheGPGobV/VCX81ylHXsKWE0GSmefmRT7QdMJTYKy3XMQi1VXi8YjKVzf6b/Iy0jCgrG21gmhAex0aUdbvmwai4jDP7d5RZx95Do9vRUkZuvIHgTPscWuzd13njavCGwVflqzG/oqRdvP1OEjnYtTP9Qew70XqFqMDDEgMZ2zRxh1csbb9AO+UR1QNxyNktzzaW5tA+fcKLsKFSkd0zOeHxn7rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC2kC9OsSTA2LG6fabLRuYQGRN0WjeyeEwYsV+WPn+0=;
 b=O92KO7fQfXscld8nsVCQNkZ5fjvCxk4eTD9JIRH5X6XWjptdu0LdUK2hBHlUvvDsLj7efSPO5PFLdGFQKnMizhvV75AOFmiBZsyg3aOs3sA4wp3zwVIQQzUmIVT/9VdBaTjatpq4vCf2Y34f+hlrI7WN3EtpDvDb2eOzGM+X8EY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4719.eurprd05.prod.outlook.com (20.176.7.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.16; Fri, 20 Dec 2019 21:27:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 21:27:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Li Rongqing <lirongqing@baidu.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Thread-Topic: [net-next v5 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Thread-Index: AQHVtneBdU0TpEmmd0SpPbrpIjWYGafC0goAgAC5dYA=
Date:   Fri, 20 Dec 2019 21:27:03 +0000
Message-ID: <ac43d22859fa5a5145cc52e4673de01209818b9d.camel@mellanox.com>
References: <20191218084437.6db92d32@carbon>
         <157676523108.200893.4571988797174399927.stgit@firesoul>
         <20191220102314.GB14269@apalos.home>
In-Reply-To: <20191220102314.GB14269@apalos.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8537ecd0-7edf-4845-8272-08d785935b38
x-ms-traffictypediagnostic: VI1PR05MB4719:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB4719F78F27800CA2A00DA07EBE2D0@VI1PR05MB4719.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(189003)(199004)(54906003)(6512007)(110136005)(8676002)(6506007)(6486002)(81156014)(26005)(81166006)(2906002)(86362001)(36756003)(8936002)(71200400001)(478600001)(5660300002)(76116006)(4326008)(66946007)(66476007)(91956017)(316002)(66556008)(66446008)(4001150100001)(186003)(2616005)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4719;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfUhAX/gra1Y/8gqYDEBrh92D/gTDvPfgNuRA7mHfMMgnAFAvro82/7o4UrApz5+WoHYS8bDoPGr2nvIorgJwEGSKHeWcq4rPQhzRi2ephH5D9JhYBgH03T3lqEYjt28dW/A1h6EmkBn+0dlofiKxZJxkdwcKz+Z/PI+UxyfWCFm+dE0mQkXLSaMJhoGAsjOYDbG014nLHvPhCNSseJ8nsuvlzWjCrbE+6ihzS+vBz+AO8JCKFsGaKPCORl/nEXCAre1CCKUreYLIMym6x+VCt0PH/nSpYSt0an9+I+/dRHDhCLM0JrboixVOax4e9XhBOpxFobnRZ+dZlif3XznhKf4DLvlpfJbWJzB4tR4hFbqC7iLCf0m4sIeN//s7MRRDzVV5QRpXVneUYvWJJvJN0lkFz/hRw8mECY+hqJflSCLAdAA/RowK+rUZdsI3p+R
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9371C7A0FCF1C249B46D3F889B332152@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8537ecd0-7edf-4845-8272-08d785935b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 21:27:03.1972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ypJdnX5igLEq9qTPLoIA+6jdcQ70VRcZ7RL13F6Ut1WnC0FEFcWSTIoVBghWTkqCTmYEr1IJaI0z1wja2UoEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4719
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEyLTIwIGF0IDEyOjIzICswMjAwLCBJbGlhcyBBcGFsb2RpbWFzIHdyb3Rl
Og0KPiBIaSBKZXNwZXIsIA0KPiANCj4gSSBsaWtlIHRoZSBvdmVyYWxsIGFwcHJvYWNoIHNpbmNl
IHRoaXMgbW92ZXMgdGhlIGNoZWNrIG91dCBvZiAgdGhlDQo+IGhvdHBhdGguIA0KPiBAU2FlZWQs
IHNpbmNlIGkgZ290IG5vIGhhcmR3YXJlIHRvIHRlc3QgdGhpcyBvbiwgd291bGQgaXQgYmUgcG9z
c2libGUNCj4gdG8gY2hlY2sNCj4gdGhhdCBpdCBzdGlsbCB3b3JrcyBmaW5lIGZvciBtbHg1Pw0K
DQpUaGUgaWRlYSBzZWVtcyByZWFzb25hYmxlLA0KSSB3aWxsIG5lZWQgYSBkYXkgb3IgdHdvIHRv
IHRlc3QgYW5kIHJldmlldyB0aGlzLg0KDQpUaGUgb25seSB0aGluZyB3ZSBuZWVkIHRvIGJlIGNh
cmVmdWwgYWJvdXQgaXMgaG93IGhlYXZ5IHRoZSBmbHVzaA0Kb3BlcmF0aW9uIG9uIG51bWEgY2hh
bmdlcywgaG9sZGluZyBhIHNwaW4gbG9jayBhbmQgcmVsZWFzaW5nIGFsbCBwYWdlcw0KYXQgb25j
ZSAuLg0KcHJpb3IgdG8gdGhpcyBwYXRjaCwgcGFnZSByZWxlYXNpbmcgd2FzIGRvbmUgcGVyIHBh
Y2tldCwgc28gdGhlcmUNCnNob3VsZCBiZSBhbiBpbXByb3ZlbWVudCBoZXJlIG9mIGJ1bGsgcGFn
ZSBmbHVzaCwgYnV0IG9uIHRoZSBvdGhlciBoYW5kDQp3ZSB3aWxsIGJlIGhvbGRpbmcgYSBzcGlu
IGxvY2suLiBpIGFtIG5vdCB3b3JyaWVkIGFib3V0IHNwaW4gbG9jaw0KY29udGVudGlvbiB0aG91
Z2gsIGp1c3QgYWJvdXQgdGhlIHBvdGVudGlhbCBjcHUgc3Bpa2VzLg0KDQpUaGFua3MsDQpTYWVl
ZC4NCg0KPiANCj4gWy4uLl0NCj4gPiArCXN0cnVjdCBwdHJfcmluZyAqciA9ICZwb29sLT5yaW5n
Ow0KPiA+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ID4gKwlpbnQgcHJlZl9uaWQ7IC8qIHByZWZl
cnJlZCBOVU1BIG5vZGUgKi8NCj4gPiArDQo+ID4gKwkvKiBRdWlja2VyIGZhbGxiYWNrLCBhdm9p
ZCBsb2NrcyB3aGVuIHJpbmcgaXMgZW1wdHkgKi8NCj4gPiArCWlmIChfX3B0cl9yaW5nX2VtcHR5
KHIpKQ0KPiA+ICsJCXJldHVybiBOVUxMOw0KPiA+ICsNCj4gPiArCS8qIFNvZnRpcnEgZ3VhcmFu
dGVlIENQVSBhbmQgdGh1cyBOVU1BIG5vZGUgaXMgc3RhYmxlLiBUaGlzLA0KPiA+ICsJICogYXNz
dW1lcyBDUFUgcmVmaWxsaW5nIGRyaXZlciBSWC1yaW5nIHdpbGwgYWxzbyBydW4gUlgtTkFQSS4N
Cj4gPiArCSAqLw0KPiA+ICsJcHJlZl9uaWQgPSAocG9vbC0+cC5uaWQgPT0gTlVNQV9OT19OT0RF
KSA/IG51bWFfbWVtX2lkKCkgOg0KPiA+IHBvb2wtPnAubmlkOw0KPiANCj4gT25lIG9mIHRoZSB1
c2UgY2FzZXMgZm9yIHRoaXMgaXMgdGhhdCBkdXJpbmcgdGhlIGFsbG9jYXRpb24gd2UgYXJlDQo+
IG5vdA0KPiBndWFyYW50ZWVkIHRvIHBpY2sgdXAgdGhlIGNvcnJlY3QgTlVNQSBub2RlLiANCj4g
VGhpcyB3aWxsIGdldCBhdXRvbWF0aWNhbGx5IGZpeGVkIG9uY2UgdGhlIGRyaXZlciBzdGFydHMg
cmVjeWNsaW5nDQo+IHBhY2tldHMuIA0KPiANCj4gSSBkb24ndCBmZWVsIHN0cm9uZ2x5IGFib3V0
IHRoaXMsIHNpbmNlIGkgZG9uJ3QgdXN1YWxseSBsaWtlIGhpZGluZw0KPiB2YWx1ZQ0KPiBjaGFu
Z2VzIGZyb20gdGhlIHVzZXIgYnV0LCB3b3VsZCBpdCBtYWtlIHNlbnNlIHRvIG1vdmUgdGhpcyBp
bnRvIA0KPiBfX3BhZ2VfcG9vbF9hbGxvY19wYWdlc19zbG93KCkgYW5kIGNoYW5nZSB0aGUgcG9v
bC0+cC5uaWQ/DQo+IA0KPiBTaW5jZSBhbGxvY19wYWdlc19ub2RlKCkgd2lsbCByZXBsYWNlIE5V
TUFfTk9fTk9ERSB3aXRoIG51bWFfbWVtX2lkKCkNCj4gcmVnYXJkbGVzcywgd2h5IG5vdCBzdG9y
ZSB0aGUgYWN0dWFsIG5vZGUgaW4gb3VyIHBhZ2UgcG9vbA0KPiBpbmZvcm1hdGlvbj8NCj4gWW91
IGNhbiB0aGVuIHNraXAgdGhpcyBhbmQgY2hlY2sgcG9vbC0+cC5uaWQgPT0gbnVtYV9tZW1faWQo
KSwNCj4gcmVnYXJkbGVzcyBvZg0KPiB3aGF0J3MgY29uZmlndXJlZC4gDQo+IA0KPiBUaGFua3MN
Cj4gL0lsaWFzDQo=
