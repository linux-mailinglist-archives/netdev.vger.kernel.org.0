Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631295C9C0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 09:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfGBHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 03:07:30 -0400
Received: from mail-eopbgr00051.outbound.protection.outlook.com ([40.107.0.51]:59247
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbfGBHHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 03:07:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=km9iLvcOzbYnxCaJKEpu2IXkOHpdSrwiHAt4kXSDcYz4NITuLTSdI/kDew99AqMwKjGbxahiEmoV4FjdB1V7kFCgLB+9XoeqLqaOahMY7MN9yOepM95xUAza5q4nMBm0hSUyaZ9mKS8Gw3MlMh3MOibkl5k45BTyMBbTkBWluR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnEblWDayvWxLCCbBSR6DjHMctk7k74REiir/hy2biI=;
 b=Gj1d2SC8sv5Kj7bhLddPE+sRb0l2hU/FkZC3H81Xmkn2Se47jQFNCAmSZ1EzXnPk1FAViPA1mcdehl6vvvEk72CwSnBylgoHXFhjjUnoRxnCi5iJVeIjSXELS0XuCJe6HSYJO5beeowVJ9I40bq2TDS6xflrkW8az/kYX8ss4mo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnEblWDayvWxLCCbBSR6DjHMctk7k74REiir/hy2biI=;
 b=YiRrpTU5zn253WcGNHiVflPcYWKBOruknebil+K6h8Uo8F8F3r4Poar5REY4eRsl6R47UDVJdVLtcvUFLrANGg9bW77DAIrK4IIkPsFobB56Dy0as82Y9QSODpU1pXhFcbDyN57bvAxMxureB29YQwn22JrG/sM10RKFZqBlV1E=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6264.eurprd05.prod.outlook.com (20.177.33.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Tue, 2 Jul 2019 07:07:27 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 07:07:27 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH 2/3 bpf-next] i40e: Support zero-copy XDP_TX on the RX
 path for AF_XDP sockets.
Thread-Topic: [PATCH 2/3 bpf-next] i40e: Support zero-copy XDP_TX on the RX
 path for AF_XDP sockets.
Thread-Index: AQHVLf8Whv54jI/oEUO7w6WGoDGUZaa27ZmA
Date:   Tue, 2 Jul 2019 07:07:27 +0000
Message-ID: <f9c7b86c-91a6-9585-d1f1-f6f325794038@mellanox.com>
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com>
 <20190628221555.3009654-3-jonathan.lemon@gmail.com>
In-Reply-To: <20190628221555.3009654-3-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0269.eurprd05.prod.outlook.com
 (2603:10a6:3:fc::21) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0deb0a4f-ce06-48e5-71bb-08d6febbf08b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6264;
x-ms-traffictypediagnostic: AM6PR05MB6264:
x-microsoft-antispam-prvs: <AM6PR05MB6264F39C2E547AD6292F4105D1F80@AM6PR05MB6264.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(31696002)(54906003)(4326008)(66946007)(3846002)(229853002)(66476007)(6436002)(66556008)(66066001)(66446008)(5660300002)(53936002)(73956011)(36756003)(71190400001)(6512007)(86362001)(4744005)(446003)(6486002)(2906002)(71200400001)(11346002)(476003)(2616005)(64756008)(68736007)(76176011)(52116002)(6916009)(386003)(6506007)(256004)(99286004)(486006)(53546011)(14454004)(316002)(7736002)(31686004)(478600001)(305945005)(81166006)(81156014)(8676002)(102836004)(8936002)(6116002)(6246003)(26005)(25786009)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6264;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r4CW1KfC+3iGJ7B4lSwJL0NC31cDu8fPHajX8aqCO/Q1JCMZArkoed5sUKZwXn1qQ3KMDy/2mu9zn55yjjBqoWykcA2C2lEwr+52oDdgJDZ6G8utdrw9Yvf//NkOejtqCxIywc04BEFWWOmhRazJbKvcaGj/gmEIvNrfMF6kh8usz3XkjcqLv+75T0IwamcbSADMQYFEppWH9B8FA1oc6pOEXWu0ygW4oae6LNTr8J8SX6kw7z45I56DGruNqQfH3KWmPekR4rsfUQROgY0CDWZcnzbzcZjUgNcJQNCd2ODLeo8ygllcNrn2MC3Sa7cIiTALW3G8GIl//L8Qp7fTPpddMdKeQTwt6KdZEpH8We6xI+e+rZpmYkKRu8xczXGWdOq7JVAGNz0/dJQJYLQnuYyP+qG6fVQknDWRcM3Qk3k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66435EBE9CD5364DA99F531D55B07638@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0deb0a4f-ce06-48e5-71bb-08d6febbf08b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 07:07:27.1641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6264
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0yOSAwMToxNSwgSm9uYXRoYW4gTGVtb24gd3JvdGU6DQo+ICsJeGRwZiA9IGNv
bnZlcnRfdG9feGRwX2ZyYW1lX2tlZXBfemMoeGRwKTsNCj4gKwlpZiAodW5saWtlbHkoIXhkcGYp
KQ0KPiArCQlyZXR1cm4gSTQwRV9YRFBfQ09OU1VNRUQ7DQo+ICsJeGRwZi0+aGFuZGxlID0geGRw
LT5oYW5kbGU7DQoNClNob3VsZG4ndCB0aGlzIGxpbmUgYmVsb25nIHRvIGNvbnZlcnRfdG9feGRw
X2ZyYW1lX2tlZXBfemMgKGFuZCB0aGUgDQpwcmV2aW91cyBwYXRjaCk/IEl0IGxvb2tzIGxpa2Ug
aXQncyBjb2RlIGNvbW1vbiBmb3IgYWxsIGRyaXZlcnMsIGFuZCANCmFsc28gcGF0Y2ggMSBhZGRz
IHRoZSBoYW5kbGUgZmllbGQsIGJ1dCBkb2Vzbid0IHVzZSBpdCwgd2hpY2ggbG9va3Mgd2VpcmQu
DQo=
