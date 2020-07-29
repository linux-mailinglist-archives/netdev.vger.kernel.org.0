Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556AC232501
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2TCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 15:02:22 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:7494
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726502AbgG2TCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 15:02:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDokbeVw6lxIdCz4a0Ts8lx8NphYUe2b0AJCJAmx3fkGE+6xpbUN3atfVl2G4nqre6NfOJ6ykSfW7xJ9HUUAwqthWnbYnFTfp0TSWDfM0TovzqU260xgW+d3MSWFQ2d28UdMcw0d6DpulkUuTv7MRc9aGjc5LeUagmMvohuvFwfIXH1/gCyZcA/QkNl0ahCUUKRs9eQw2lwElFXSP/IxpxvtJ4YdkuKnGrB6VMSOaBOB7i1ObS9x2RijdcZT7WfakMuNRBe3jmAopj/pd1ZJ19E3roXCY8zX0YDLN64+47F9qWSr7105qIkY37iqsY2PUbRKv/78DXmC1QQZbbqSyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOhEenbLskpcoVZxbtSjZ1RjDJBXDQfGDFe+mHLxTtU=;
 b=LB+2AEfzpnHaULiG+nPcCs0cc9SK8XCCiPyrQixJj0CjzkT3efE/WM4gmK3FBl6EIKSmUvdyNfFiM1uPAFvBRuicSff5TTqRXUXgPU3jUj6KZQgcppg/XBEK4h5hlsYyWIxQQ30MhJUinbk6i4F/U+w3L2aD7dGtrABYA2z0ROCMY4dwmN79ynbxUTvtkmW3t9UOjg15si8Lq5iugEfmL6XHqC6aeH3vBKgJz/yOMlTlG9y2YOx8i2DMyYPMEOckLuuVei8cOzHp+9vEHXTMnFUw7SaBB6BJIuwGTEncjbrYXKWmOqIfggdKalNI0YQQL0MIuE8Ytz0ZMrum25jGLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOhEenbLskpcoVZxbtSjZ1RjDJBXDQfGDFe+mHLxTtU=;
 b=LO5oXVTeZWknl5ZlY+WX3iFvf80nFK+4PFOd7LApZIw6Mb++yynWIuh9PS7BU7/dl4XvmPDTc4ahWeOtaQMDyPHNv3ldg8hYIMkhJx3sMSe/HsLNhk089rExwy//emydaCxDn4OZwbWQ6jIX2H8t1EWhXyqy4EWw7W5at5n9zww=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2784.eurprd05.prod.outlook.com (2603:10a6:800:9b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 29 Jul
 2020 19:02:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 19:02:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "hawk@kernel.org" <hawk@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "xiongx18@fudan.edu.cn" <xiongx18@fudan.edu.cn>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>,
        "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] net/mlx5e: fix bpf_prog refcnt leaks in mlx5e_alloc_rq
Thread-Topic: [PATCH] net/mlx5e: fix bpf_prog refcnt leaks in mlx5e_alloc_rq
Thread-Index: AQHWZaSD4+bJSZVEQUqH8FFGnSv/eKke6kCA
Date:   Wed, 29 Jul 2020 19:02:15 +0000
Message-ID: <613fe5f56cb60982937c826ed915ada2de5e93a2.camel@mellanox.com>
References: <20200729123334.GA6766@xin-virtual-machine>
In-Reply-To: <20200729123334.GA6766@xin-virtual-machine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d21119a7-6309-4cd8-a1cf-08d833f1e8f6
x-ms-traffictypediagnostic: VI1PR0501MB2784:
x-microsoft-antispam-prvs: <VI1PR0501MB27845DB2AAA3C72EF17C6B31BE700@VI1PR0501MB2784.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I3oLNH4EpNhwLHBGZ1SBOM/Zu0B686xW+XjlC0wnPpoYQXAAFkvYSnQKJg9QIbDtvh/KMaFLXexhh9Sl8X/WFQsueBDXSg9srszFWxV009RarUfIMHKDxck9dkRzt/05edx/eiHdgIcA7ovvTg3A1VVnyvPgnTqWp/FEbT3jxg8TT4YkpbkXFeOEqYUuZbq2H38scAZNbm3x39+cEFP5//bDnnG55Rg7KxIJ58dKnYeVh/7S4/uT+74x3qmmfF4S/H6lnpGcXuzuwOo9vEvdIBNH+cEg37jZ+X1AJO43C6EeaT7M8qsgd3H0Mz45ThHwShUAIApxBTmHeHJiKDaCBgHvpovKEtmEq1asD2GWE7PgcnfBgjbl16F8DLszuCC6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(6506007)(71200400001)(5660300002)(186003)(26005)(86362001)(36756003)(6486002)(316002)(54906003)(66946007)(110136005)(66446008)(64756008)(66556008)(66476007)(76116006)(83380400001)(91956017)(2616005)(478600001)(6512007)(7416002)(8936002)(8676002)(4326008)(2906002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: z/ZFnQUZlEwZUckpd33B9TLzfCtbAg4FEYLQrCJfE5z47j40Iokx/aoGvFxQBaEC3Gq9DwtylS7XEFHI2CCQOdmecpk/LhFpRGGD872efJGokJb8JzKgZlKKvu+v0MJNkj+VmTELCxyvkeN8VQpbi+dkChcIvkuOR2GpeHdMbZj0bbHCAZWIzXX7GDvP31mX1YRFkav9uLJ8psVsXSSIAa1tTPyDjBvx0DcJeXpKYuWPET/+uY2dMg75R8toU3BjndIr3oV85/59taqpvbJIkTZzrcZFJ14yNJsthRSPm5ti1huARnhkCd7zS01hJ0aCs4grm9FUTcYkzqZOsR5uJBM6oUii/NN0mREfq445dn5Ecrl1G+ptnqWDQGXeGd3Q9CmBgMnkr3zT33PtB/IJAYcKubdssNxGiXr6tbAR+ySIjo/73VYi8CN5y9tfBYzwG8A1z5V/t67lM40B7ISydv2Qxk0DYSjTAO1Bw6wNZeVnESsGPLzw7rRC2B8e9D4QukFMC8hIk5DdxC3iH6CMEeq0xiNZ90qY8ssQB3J6me8Mn6Nx+29zJLMSqf0lPQ1TKCaxZUlswkucp/Ep+DIpFLXki/4HbobIjbeqmn8MbEOoqydVyXP/M2HxKrMyux0u4qDCQFw8DO6uCQRmrmQPCw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <85B799C4F07D4F498545FE711C372F98@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21119a7-6309-4cd8-a1cf-08d833f1e8f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 19:02:16.0329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5WeL9EEQBVqYtlHb7tD6l13FSYHAtYRWmDloMDrGfhik6qIACkRjf5YYHP9fj5meaSwI1r7aEnNN/3XuxCURKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2784
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA3LTI5IGF0IDIwOjMzICswODAwLCBYaW4gWGlvbmcgd3JvdGU6DQo+IFRo
ZSBmdW5jdGlvbiBpbnZva2VzIGJwZl9wcm9nX2luYygpLCB3aGljaCBpbmNyZWFzZXMgdGhlIHJl
ZmNvdW50IG9mDQo+IGENCj4gYnBmX3Byb2cgb2JqZWN0ICJycS0+eGRwX3Byb2ciIGlmIHRoZSBv
YmplY3QgaXNuJ3QgTlVMTC4NCj4gDQo+IFRoZSByZWZjb3VudCBsZWFrIGlzc3VlcyB0YWtlIHBs
YWNlIGluIHR3byBlcnJvciBoYW5kbGluZyBwYXRocy4gV2hlbg0KPiBtbHg1X3dxX2xsX2NyZWF0
ZSgpIG9yIG1seDVfd3FfY3ljX2NyZWF0ZSgpIGZhaWxzLCB0aGUgZnVuY3Rpb24NCj4gc2ltcGx5
DQo+IHJldHVybnMgdGhlIGVycm9yIGNvZGUgYW5kIGZvcmdldHMgdG8gZHJvcCB0aGUgcmVmY291
bnQgaW5jcmVhc2VkDQo+IGVhcmxpZXIsIGNhdXNpbmcgYSByZWZjb3VudCBsZWFrIG9mICJycS0+
eGRwX3Byb2ciLg0KPiANCj4gRml4IHRoaXMgaXNzdWUgYnkganVtcGluZyB0byB0aGUgZXJyb3Ig
aGFuZGxpbmcgcGF0aA0KPiBlcnJfcnFfd3FfZGVzdHJveQ0KPiB3aGVuIGVpdGhlciBmdW5jdGlv
biBmYWlscy4NCj4gDQoNCkZpeGVzOiA0MjJkNGM0MDFlZGQgKCJuZXQvbWx4NWU6IFJYLCBTcGxp
dCBXUSBvYmplY3RzIGZvciBkaWZmZXJlbnQgUlENCnR5cGVzIikNCg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogWGluIFhpb25nIDx4aW9uZ3gxOEBmdWRhbi5lZHUuY24+DQo+IFNpZ25lZC1vZmYtYnk6
IFhpeXUgWWFuZyA8eGl5dXlhbmcxOUBmdWRhbi5lZHUuY24+DQo+IFNpZ25lZC1vZmYtYnk6IFhp
biBUYW4gPHRhbnhpbi5jdGZAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gaW5kZXgg
YTgzNmEwMmEyMTE2Li44ZTFiMWFiNDE2ZDggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiBAQCAtNDE5LDcgKzQxOSw3
IEBAIHN0YXRpYyBpbnQgbWx4NWVfYWxsb2NfcnEoc3RydWN0IG1seDVlX2NoYW5uZWwNCj4gKmMs
DQo+ICAJCWVyciA9IG1seDVfd3FfbGxfY3JlYXRlKG1kZXYsICZycXAtPndxLCBycWNfd3EsICZy
cS0NCj4gPm1wd3FlLndxLA0KPiAgCQkJCQkmcnEtPndxX2N0cmwpOw0KPiAgCQlpZiAoZXJyKQ0K
PiAtCQkJcmV0dXJuIGVycjsNCj4gKwkJCWdvdG8gZXJyX3JxX3dxX2Rlc3Ryb3k7DQo+ICANCj4g
IAkJcnEtPm1wd3FlLndxLmRiID0gJnJxLT5tcHdxZS53cS5kYltNTFg1X1JDVl9EQlJdOw0KPiAg
DQo+IEBAIC00NzAsNyArNDcwLDcgQEAgc3RhdGljIGludCBtbHg1ZV9hbGxvY19ycShzdHJ1Y3Qg
bWx4NWVfY2hhbm5lbA0KPiAqYywNCj4gIAkJZXJyID0gbWx4NV93cV9jeWNfY3JlYXRlKG1kZXYs
ICZycXAtPndxLCBycWNfd3EsICZycS0NCj4gPndxZS53cSwNCj4gIAkJCQkJICZycS0+d3FfY3Ry
bCk7DQo+ICAJCWlmIChlcnIpDQo+IC0JCQlyZXR1cm4gZXJyOw0KPiArCQkJZ290byBlcnJfcnFf
d3FfZGVzdHJveTsNCj4gIA0KPiAgCQlycS0+d3FlLndxLmRiID0gJnJxLT53cWUud3EuZGJbTUxY
NV9SQ1ZfREJSXTsNCj4gIA0K
