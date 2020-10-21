Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0342947E4
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408087AbgJUFde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:33:34 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:42820
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731295AbgJUFde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/dRGVv/QaF6mLXAoxGTDq/WwJj0DEMFi6JK6N9eR5ahE809LZH8/rKfooFGbyBi1ZmHcqkqCgX/ETiS+JyDCotHbBw1nVZdJkgc0Ex+jxGvPrWDqWIINd8rohxOGtntKNqZYWI2PkgGS+PwaUO7t2QtRVVw1JAElV39Y8h8uWzxWHfC4wtKidrka49I77XI0+fs2y8on+lrJ/CvFmVbJ7xgmQ4Kbpksd8oGCEqd0YaHgLlPf1qTxZchOcAS0zTLKrw8vem21DMHZZN5JbB4/pn72rbgvmdlh4bigvIbApdQQh/swG07fxoaRuzCGq9PmogIF5WNix+as4QkPqsglQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3Sr8JjE9FbXixLIg6T7siY8V8DhuGbwScB9quX2DOE=;
 b=Dc08S4LVXC9qDvpsgMJG6WJv7b16b+YsnwPp5lPy0fig57t/9fMWi2U6JCscxnubMdPuzkeWQfsZJAYTacJ7fkBXl13bXDdBshrlyUS31uO+c/Ijlmy0QtQvz2dCHe9pwfDe2Q3/CMwkRxbGTFGFirfYvYqkzh9tSrarRSCQ2kWoUBr1eEv6KyVixp91lUNw0slchAs17AZ5cNZ71e/SctfEijL+NJtuOWyZOXRAfrqFZUV9eNBB6r48PaV00Tag5F6F2zIvlGEl7BRTOk5aEoHmJN5PItS43o5s0OLg38OpZN3kmsK7s9Xq/KqwxDNP9D6z2IUYqgDJXsOrVUE3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3Sr8JjE9FbXixLIg6T7siY8V8DhuGbwScB9quX2DOE=;
 b=FoI9iowjReDRO53gZVzdyPzEdKu70obJhBDge7YPQMnV6rBXJ8het4V7zgUbM63suemXdYXGHgjq2LO6DYHkF12gmt0UEZ5hSnV4AaAteAMzZYk7AYsqLW/jSURaO4jn/qL8D6VweTNRWRPu+IiivAdXpIspeQONyCq51I8MfS0=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3964.eurprd04.prod.outlook.com (2603:10a6:5:17::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 21 Oct
 2020 05:33:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:33:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 0/6] can: flexcan: add stop mode support for i.MX8QM
Thread-Topic: [PATCH V4 0/6] can: flexcan: add stop mode support for i.MX8QM
Thread-Index: AQHWp2pf20/YUdBzdkWpWOmwjarHMamhhkvQ
Date:   Wed, 21 Oct 2020 05:33:29 +0000
Message-ID: <DB8PR04MB6795A27E2E3D66186A8720DCE61C0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cde945fc-14da-4b99-cd26-08d87582d772
x-ms-traffictypediagnostic: DB7PR04MB3964:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB39649344E5F95C59994B2EDBE61C0@DB7PR04MB3964.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2sLP9ln/p7BNxhA4vwNI8oVp1fN1lIgMJ1PyKO8NW9iFbWLF4vhFQEhCg/n0SgLyLAj2QuN4ZO0MX+wxBueAC69s6qyU5sEi01nzxkj0VH49F3aGbzpI+6al/GlpNVIJQGKHW6uHDgzuVFGObz++zpLW+rAud2R/XP81ryilhlazZV9qzSEnRbtb+WcdCuQ+VgK5qBuMFdEd7r9HMKM6W0pYXzeMWlFyPb1KxPicNOazuYwp29ax2xrAykXDewtmu+gTzv7ZaVyNbzAEunZ3uLajrYu50HYzLXMJVVON1ro+ycE1V7+qIRz8UMICcp4e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(5660300002)(9686003)(6506007)(8936002)(478600001)(64756008)(66476007)(66446008)(66556008)(66946007)(76116006)(4326008)(26005)(54906003)(110136005)(71200400001)(33656002)(316002)(52536014)(83380400001)(2906002)(186003)(86362001)(53546011)(8676002)(7696005)(4744005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9wvF9VAxk9b3Ifj1tI8thQQgzlef0N+54s7KtiMgzr2d7AoQ+jgiiIOO7W3V66jJHqiR6hPIEJLsFs1uhwiBzDF0QBVS60kgfcf+dx0LXrkN+phfzmhTLFlk0xuVxQaDMJKTSGPPJbIcjOGL72K9c0HaCAv1rgYGeYkabQkGXeFMJuVjQo6lP6l0kWWqXnYX9n7EJOzLXnS5x4XIKbHOATrJp+BGUPhlkPOH2c8/5sLTdo/XRhh5amS0yt1W5H+dqKLLb+rzWwLdCix332wlleKXwDrS6IA8hwo0ABh70WMUpTUIRozI2ttwGqWIYxnGNNUvoia8EDf6GdASvnoF8BhRYlRgp0ueNEBtKC9yTlmTchb/5X7D3h4Ff4gk8kLzium51nxvx/iuJgtf9S9ldHzQnT19a4PQBrtCFYKHRjY+PL8yEFqXElwXUoE8pVRtaxAWkg+CL7SLy6zmfuc78QaS29A0CmTX1fvhpYzigowS5izwKkEl7NR8XbBMbAJtq7Er3W5+YoALRM5tOOAbkQvJcqUl2mj9CP3qE/G6tgny6JEC/iUg6m/QNbdbNzXDDFq8V0LAPpe6S7BZSu7+5T9FCnFyqAeNUy/WNgL/v0sBGTsIUPgvli/l7l21vjpo1+1LRxZwhxFQFDqiL/uw+A==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde945fc-14da-4b99-cd26-08d87582d772
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 05:33:29.1737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y10GA+7IU6VFqhvm6hOzwf+dVDxc6HPIPl2M/4Pjt8FIrv5TTYFSy6ITACR+YPhw1FZSYl/tFyEbC3/hpzqrEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjDE6jEw1MIyMcjVIDEzOjI1DQo+IFRv
OiBta2xAcGVuZ3V0cm9uaXguZGU7IHJvYmgrZHRAa2VybmVsLm9yZzsgc2hhd25ndW9Aa2VybmVs
Lm9yZzsNCj4gcy5oYXVlckBwZW5ndXRyb25peC5kZQ0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4
LmRlOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgWWluZyBMaXUNCj4gPHZpY3Rv
ci5saXVAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BB
VENIIFY0IDAvNl0gY2FuOiBmbGV4Y2FuOiBhZGQgc3RvcCBtb2RlIHN1cHBvcnQgZm9yIGkuTVg4
UU0NCj4gDQo+IFRoZSBmaXJzdCBwYXRjaCBmcm9tIExpdSBZaW5nIGFpbXMgdG8gZXhwb3J0IFND
VSBzeW1ib2xzIGZvciBTb0NzIHcvd28gU0NVLCBzbw0KPiB0aGF0IG5vIG5lZWQgdG8gY2hlY2sg
Q09ORklHX0lNWF9TQ1UgaW4gdGhlIHNwZWNpZmljIGRyaXZlci4NCj4gDQo+IFRoZSBmb2xsb3dp
bmcgcGF0Y2hlcyBhcmUgZmxleGNhbiBmaXhlcyBhbmQgYWRkIHN0b3AgbW9kZSBzdXBwb3J0IGZv
cg0KPiBpLk1YOFFNLg0KDQpIaSBTaGF3bmd1bywNCg0KQ291bGQgeW91IHBsZWFzZSBoZWxwIHJl
dmlldyBwYXRjaCAxLzYgYW5kIDUvNj8gU2luY2UgZmxleGNhbiBkcml2ZXIgZGVwZW5kcyBvbiB0
aGVzZS4gVGhhbmtzLg0KDQpGb3IgcGF0Y2ggMS82LCBpdCB3aWxsIGJlbmVmaXQgb3RoZXIgZHJp
dmVycyB3aGljaCBjb3ZlciBTb0NzIHcvd28gU0NVLCBzdWNoIGFzIGkuTVggRXRoZXJuZXQgQ29u
dHJvbGxlciBkcml2ZXIgKGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5j
KS4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCg==
