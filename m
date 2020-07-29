Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A182319A8
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG2GiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:38:12 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:34846
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726286AbgG2GiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:38:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmaLpTsUTWVTmyDI0jkyl3gnqQLleZkB1vdnsBd+U/Qj7AQX2vLPZhiVzqRT1m9QU77aUItehFw2lNQIJLKB/jNLHRHOSa4TuASZE6alo2NnFNY6DvS63pjv+u7zgPTBoJhZKkQuyE80wepM9A7ptY5CilQpdHFyKqTdo4uUmzLPZHRVdHj+ppLsh2matxScm5RexGHLtxxssUBdnf4+vRfQV97NQCuXtsEx/ZkWcDgjqFZXbnQ8tr65Gwdo0mZxLbZCuLwa16yT/p5ombfsiayOE16a4R8LYF6T7y6a1XAEJZy8HmCSV4Kv6GiAMIHFK3UpYFVIpdUMupe1uXjnzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64dK6xotEbEcUw8cheduzwrP5qCQPmd0uCvKf3AcUJ8=;
 b=d1XjlpesLw+40Lga8rIj52fI/PEs8LgVte6oNG9X9fD99RpcNdzH6Rq4QCr5BlCa+YgijCy72RC7erwnkbkK/hqq557nqv+sG1Wp2YZ5kyH5AMR0h8CtoxbSnFkH9pjvXxdwQtSHNQrdLKLkpXMK+p1397LPeA/QetR4dTtRCu18uQts4JCGvohw1du+u5nPdmu3vJHX3r8F8jazVOI9xzs1RYU+pF3rEvt4OFSxWK6SbP674RP1IsbzC5r/WF5dbcjgZlsZz743RVjgrzLkl2iX2D4ZkRaRVKlRh3KXiSkLSOD11SuoyQoXgfam5hBIWQN1qF/zBIP+mnFhS+KJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64dK6xotEbEcUw8cheduzwrP5qCQPmd0uCvKf3AcUJ8=;
 b=dFvMDwaWXOwsRQfGQdhXaG+deO5VJea0GpecWv7vgNFzb6IfpG+PeTi1320R387wAbRWJjhcfZjk8vTbFWKA0fNFKGhXJgzzl7isieJQkkaG3x0YzOo8MG2xB3EFNS6viyOWWaPjNnF9wM1M461T7KuJ9DkWmHuDS8V5eFee7ko=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3247.eurprd05.prod.outlook.com (2603:10a6:802:1b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Wed, 29 Jul
 2020 06:38:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 06:38:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     Moshe Shemesh <moshe@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net V2 10/11] net/mlx5e: Modify uplink state on interface
 up/down
Thread-Topic: [net V2 10/11] net/mlx5e: Modify uplink state on interface
 up/down
Thread-Index: AQHWZRnI5HUsQie3Q0KGLyCoRiJXbakeFcOAgAAFqwA=
Date:   Wed, 29 Jul 2020 06:38:08 +0000
Message-ID: <7f29e8a3271dac59f6b5f3f2cd41eda3cf7a1c0f.camel@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
         <20200728195935.155604-11-saeedm@mellanox.com>
         <CAJ3xEMgJg5RQROKUjR3tGu+khu80ogtZY=8Q2sJkrej4MCZPAg@mail.gmail.com>
In-Reply-To: <CAJ3xEMgJg5RQROKUjR3tGu+khu80ogtZY=8Q2sJkrej4MCZPAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ed855d96-3909-4243-0687-08d83389f51b
x-ms-traffictypediagnostic: VI1PR05MB3247:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3247C7B2E5087C64289CDBF4BE700@VI1PR05MB3247.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LDEhVrV/CDjXkbp60c4jG0OeirilIYct0QZPf6Gi5dCWYTebS+zLia0yYqB7Fm0hYA8Ou3gIPSjOqwrO5JuIX5gZYGWh0QH2ywuD6KCiiNYHV+HSk+cO82RnE7W3Lzwim6tk3+Dxn0gkAYXC9nk28SjwKUoYZjCwwMw05qWBR9pvLDiDgVnYk7DzZGYXjDsEjcenTcn34arqCTxhElyXH2PyKr2GBB0e1ttyI0beNIRmhZkYvK4hBCKaoHWJ9o5FnAfljWQutpwNGh0vS4IoeCmuRPlvmfTQmsAm9kpaC74Cye9P/Pq2/f8s97pRS3df
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(396003)(376002)(366004)(346002)(478600001)(54906003)(8936002)(316002)(71200400001)(6916009)(6486002)(2616005)(4326008)(6512007)(6506007)(53546011)(83380400001)(8676002)(186003)(26005)(5660300002)(64756008)(86362001)(91956017)(66946007)(76116006)(66476007)(36756003)(66556008)(2906002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: URipVAMxTqjon5ypBvS0DFvIdvryny4LYqs2sfXBprdZFXrZeow625U/l1Dzx0hTTa6sPClqbizN1qSDmD7H6mIwp53dLxCMjnTHH8ty+qDa4Tib6QuBrpA/AEyXQ+unvyVDZ98h5lSUmu5C4WJMKvwf0Me7oR7zjLZDa2H4QYCEOjeuN6JzAXn9Jf+0HvkAlZxVJhqJGTbDKxFJD3nMujf74T1J2w0PtoanX/LlcXlAQsq1PsRxO61TnqH+SmaozihrRxqkN/+DhEOflKATWQuxiez34+hqGHOIlUinnEJA+3rqJiJfHZuFLbn8oununp5Oj3cfoSSbXOq0fpat1s9Zsc6v+qubW4DjX2hNvG9MCHEr1eCz4pcuVZFZo+lCAuK4es+bC2+s9achDR/N3Z0jiY4ixD9qL3VreE0jjLvS5cQ37tA0DjqhQPdtAU0iwG5j/6dppGgV7hbEHomLTmyYhG4arjWAdiub2Jee60g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA9D1A7AB9AFE440A5FB572F840BCB47@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed855d96-3909-4243-0687-08d83389f51b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 06:38:08.7043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V9LJTUFnkddnlxcA3mPacIVsUBf7vsENtCDOBIVCJTAhHGO4xmKEQj2YD6XYzs33d3AFe2ql5aY6w6++Zh0orA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA3LTI5IGF0IDA5OjE3ICswMzAwLCBPciBHZXJsaXR6IHdyb3RlOg0KPiBP
biBUdWUsIEp1bCAyOCwgMjAyMCBhdCAxMTowNyBQTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCj4gd3JvdGU6DQo+ID4gV2hlbiBzZXR0aW5nIHRoZSBQRiBpbnRlcmZhY2Ug
dXAvZG93biwgbm90aWZ5IHRoZSBmaXJtd2FyZSB0bw0KPiA+IHVwZGF0ZQ0KPiA+IHVwbGluayBz
dGF0ZSB2aWEgTU9ESUZZX1ZQT1JUX1NUQVRFLCB3aGVuIEUtU3dpdGNoIGlzIGVuYWJsZWQuDQo+
ID4gVGhpcyBiZWhhdmlvciB3aWxsIHByZXZlbnQgc2VuZGluZyB0cmFmZmljIG91dCBvbiB1cGxp
bmsgcG9ydCB3aGVuDQo+ID4gUEYgaXMNCj4gPiBkb3duLCBzdWNoIGFzIHNlbmRpbmcgdHJhZmZp
YyBmcm9tIGEgVkYgaW50ZXJmYWNlIHdoaWNoIGlzIHN0aWxsDQo+ID4gdXAuDQo+ID4gQ3VycmVu
dGx5IHdoZW4gY2FsbGluZyBtbHg1ZV9vcGVuL2Nsb3NlKCksIHRoZSBkcml2ZXIgb25seSBzZW5k
cw0KPiA+IFBBT1MNCj4gPiBjb21tYW5kIHRvIG5vdGlmeSB0aGUgZmlybXdhcmUgdG8gc2V0IHRo
ZSBwaHlzaWNhbCBwb3J0IHN0YXRlIHRvDQo+ID4gdXAvZG93biwgaG93ZXZlciwgaXQgaXMgbm90
IHN1ZmZpY2llbnQuIFdoZW4gVkYgaXMgaW4gImF1dG8iIHN0YXRlLA0KPiA+IGl0DQo+ID4gZm9s
bG93cyB0aGUgdXBsaW5rIHN0YXRlLCB3aGljaCB3YXMgbm90IHVwZGF0ZWQgb24NCj4gPiBtbHg1
ZV9vcGVuL2Nsb3NlKCkNCj4gPiBiZWZvcmUgdGhpcyBwYXRjaC4NCj4gPiBXaGVuIHN3aXRjaGRl
diBtb2RlIGlzIGVuYWJsZWQgYW5kIHVwbGluayByZXByZXNlbnRvciBpcyBmaXJzdA0KPiA+IGVu
YWJsZWQsDQo+ID4gc2V0IHRoZSB1cGxpbmsgcG9ydCBzdGF0ZSB2YWx1ZSBiYWNrIHRvIGl0cyBG
VyBkZWZhdWx0ICJBVVRPIi4NCj4gDQo+IFNvIHRoaXMgaXMgbm90IHRoZSBsZWdhY3kgbW9kZSAi
YXV0byIgdmYgdnBvcnQgc3RhdGUgYnV0IHJhdGhlcg0KPiBzb21ldGhpbmcgZWxzZT8NCj4gDQoN
Ck9yLCB0aGlzIGlzIHRoZSB1cGxpbmsgZXN3IHBvcnQgYW5kIG5vdCB0aGUgUEYncywgYXV0byBt
ZWFucyANCkZXL0hXIG1hbmFnZXMgdGhlIHN0YXRlIGFjY29yZGluZyB0byB0aGUgYWN0dWFsIHBo
eXNpY2FsIGxpbmsgc3RhdGUuDQoNCj4gSWYgdGhpcyBpcyB0aGUgY2FzZSB3aGF0IGlzIHRoZSBz
ZW1hbnRpY3Mgb2YgdGhlIGZpcm13YXJlICJhdXRvIg0KPiBzdGF0ZSBhbmQNCj4gaG93IGl0IHJl
bGF0ZWQgdG8gdGhlIHN3aXRjaGRldiB2cG9ydCByZXByZXNlbnRvcnMNCj4gYXJjaGl0ZWN0dXJl
L2JlaGF2aW91cj8NCj4gDQoNCk5vIGNoYW5nZSBpbiB0aGUgY3VycmVudCBzd2l0Y2hkZXYgYmVo
YXZpb3IsIG9ubHkgZm9yIGxlZ2FjeSBhbmQgTk9ORQ0KbW9kZS4gDQoNCj4gDQo+ID4gRml4ZXM6
IDYzYmZkMzk5ZGU1NSAoIm5ldC9tbHg1ZTogU2VuZCBQQU9TIGNvbW1hbmQgb24gaW50ZXJmYWNl
DQo+ID4gdXAvZG93biIpDQo=
