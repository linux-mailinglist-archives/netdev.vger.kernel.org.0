Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FF174035
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfGXUj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:39:59 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:34724
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726939AbfGXUj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 16:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8e4CWbpEKXwwELGdVivfvzFoq81HcfnQf1MTfJFiwUQFP39EUoadvZfoG94Dw8aTx/cNRQnzJC4BmJV4wBqvcy2uAqKGB7kY7RVizepP8+WFhboS3eiqJr1CTtpl4SZpgs6ZmhcD2ATa7wDqMUsxTdzZueniYAUHFf2O4DzcmYnSZ/HfMiFk9P+Wf7XwNFV7cWgu+WgExUTqkvxwzqHS4ywP82Yxl8sEURcKhIXVNvuySc8/AO0rL1bnm87p2JA1wNat5s1xnwel0CPob4ihlUsrJ+lGsEbvz5flrnL006q3JByqthvxr8CvV0zKm/CKpQ8Sn49FQr961qw3U9hTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CziKWvPbce7RiAqIOQp6VMZQT8qNlIt8NufLZCNCrF4=;
 b=UFOFUd33B5/W/8S1IQ+gVE6cmRrJXFmkJKX50isogxYu0gkzbRe9kL+qF+R2laMgAE0QYBw0nPJYqou99WE8rHca158qiCBoWjr7sQuQa1IOs28lxSWnaoOlwKJoCsoQNLDdRcVtqEo7Ir2qUwgEFME7VvVR+vLMQPyQ/1TVvHuuRqjY1u0zWuFUD5FS1erH3fTSaOlEIYokO6ibWQAVRFYeNMPiRgWrddBVNHvpLN147suIqeLMVPFCi226v9wPhkZj+ZKrdxbzUHNpT/DA9qHNsQhHnlX2L7ORb9b9rWt2pHBXb5dwCVsFtak2cyFXtwfNoveuooHZEApjB+20Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CziKWvPbce7RiAqIOQp6VMZQT8qNlIt8NufLZCNCrF4=;
 b=qra+DccyN7i7PRAsE/QuBHmKpGpgR0fE8dc7Mzvu0VDO3FWN/1OCGV4Z6x3KUU2PyFcV3USLMfwK7WW5lMtVETsWJDVWNQhtcPKBEOYYeE3UjtCIkECqFkuizXCE+46nqaiTRu/7Ro5bu/E8fUX8UaPC6/1tUoZk+yW8uMDX/Q4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2838.eurprd05.prod.outlook.com (10.172.226.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 20:39:53 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 20:39:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] mlx4/en_netdev: update vlan features with
 tunnel offloads
Thread-Topic: [PATCH net-next 1/2] mlx4/en_netdev: update vlan features with
 tunnel offloads
Thread-Index: AQHVQiip5Uqq5nD8f0m9Isk3aDyinabaO48A
Date:   Wed, 24 Jul 2019 20:39:53 +0000
Message-ID: <4cb45c2e4515a122b38d54a0b9d8f03c854401ea.camel@mellanox.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
         <c3ccd45ee8742fb1a35fcfd41955907329e8112b.1563976690.git.dcaratti@redhat.com>
In-Reply-To: <c3ccd45ee8742fb1a35fcfd41955907329e8112b.1563976690.git.dcaratti@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 237ad9e0-339e-4eb9-0458-08d710771503
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2838;
x-ms-traffictypediagnostic: DB6PR0501MB2838:
x-microsoft-antispam-prvs: <DB6PR0501MB2838496028EEAFF962B2E87CBEC60@DB6PR0501MB2838.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(189003)(199004)(6246003)(2616005)(6512007)(53936002)(305945005)(476003)(8676002)(64756008)(2906002)(25786009)(71190400001)(186003)(99286004)(71200400001)(81166006)(3846002)(8936002)(446003)(6506007)(58126008)(6436002)(36756003)(256004)(229853002)(6116002)(2501003)(91956017)(102836004)(7736002)(478600001)(316002)(11346002)(66066001)(68736007)(118296001)(66946007)(81156014)(6486002)(66476007)(66446008)(14454004)(4744005)(110136005)(66556008)(486006)(26005)(5660300002)(76116006)(76176011)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2838;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZZdGDsGUrLDuGhCDRCX4ZHcJRF/hSmpFazafL90YDui0/p7QyxfCHIQj4V4RVmXW6XnIIFqGK6voP+1+towS5VMkA7wf5tJUipCFe3ZW+DnHahTffuRw0GCOD9cgkniA4Ggxym/nLkyMX6+ly9J47iUMPAQXtWzuoi506EujNwdnDE2p72R/76Z+5+0FlB4eW3jHzSidh+FfE85pDHU2s0w/xy+zdad7nHnC7df0m/n538bAiLsbLqQgQTELLBTib2NrOWUJJnRWFoEBlD1JRI1yLUsceagCthX7q6IIzcUIHV+yq28F+zikFnrWwDX5bfWa5CFkKfFcd95SzaFYtVfrKo5drUtJv3q1fzN9wDDYUs1/hmEF4ZTQsa5UFQ59gCRsM3/GgwuYNtyPPpMpMZznBlBnZ3xAYqd5Gc3bQu0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7C2F6F9487B2D45832FEBD3665C3717@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237ad9e0-339e-4eb9-0458-08d710771503
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 20:39:53.4267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDE2OjAyICswMjAwLCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToN
Cj4gQ29ubmVjdFgtMyBQcm8gY2FuIG9mZmxvYWQgdHJhbnNtaXNzaW9uIG9mIFZMQU4gcGFja2V0
cyB3aXRoIFZYTEFODQo+IGluc2lkZToNCj4gZW5hYmxlIHR1bm5lbCBvZmZsb2FkcyBpbiBkZXYt
PnZsYW5fZmVhdHVyZXMsIGxpa2UgaXQncyBkb25lIHdpdGgNCj4gb3RoZXINCj4gTklDIGRyaXZl
cnMgKGUuZy4gYmUybmV0IGFuZCBpeGdiZSkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZGUg
Q2FyYXR0aSA8ZGNhcmF0dGlAcmVkaGF0LmNvbT4NCg0KDQpMR1RNDQpSZXZpZXdlZC1ieTogU2Fl
ZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo=
