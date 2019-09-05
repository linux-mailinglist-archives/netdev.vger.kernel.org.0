Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE414AAC15
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 21:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390792AbfIEThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 15:37:35 -0400
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:32644
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726626AbfIEThf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 15:37:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deU1KP++b/md12/1Y6i6rrgw/FZi5rLzSZkDIcIUV3+ClzSIQPAMv5XsLs7cAnkeC/0/toPirda1wIEO52Lm6xwpj+Qt8jp5lEzSd5b2LLM6bP061cEbbWVkplRU6itFDzTIdPCbBKLMKUwml6l/svXibOHRTDgnBfiibjK/V7kgJKSW+z6Ib5yy5AVEay7SBsFaVm6Ce/tpQ1xdJr4HFm4oWeh0CPF7mAXIUvds0f0eNy1gdVI1qMTC4b8pwPTK+vbH3t97mpEIUBaK1uxH2t9H5hWOn3e4rKSjL9S/qjo1yUuydtgHTRyg46J/BD1UNzNgZYbb+lE5fhijoGOj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxsg5SHK8dDyYa7SuZEIjYSVuZuB6GyR9F9f7GXsC7s=;
 b=KQwZh+iY4QPYfUedoCoulYAQGKWZUFueMjT5Nfiysf9Vq8iC2N17S7CV7sVZwU++7lHCHD73cNdYIxEIbG6T8Ig2aDYkk0zzc67lUCnV0hw6q6+NBtNgUPydR6Itg9XFptd17ElCo7oTFDiqOCDmmvXVFC/YXrROtlahltBQvaV3x7WCGq3+yb5scPJsbf2davm7jtC6eAJsXeAhNSmXFdyp8r/yWtsc8+Uipw2NRI4n0VrHzd6gxlc2j6hJRlv+Tx62d7NCpMearci/yOqj8rS9mu+ecIphkH3O8ALg9heD4XSyB9tsVXMzxXVSFFw/zswm9CmDbWummTXPsCmWSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxsg5SHK8dDyYa7SuZEIjYSVuZuB6GyR9F9f7GXsC7s=;
 b=X8BE+hQkDXVg0Lnk1A+uh1Gbo4FsjMx1WIF3pPiKzk3RRPzSFRUce53mXl/9LhQwnGHkezn4Kxwv0AjEo+L1os4EH8Rsbt05Y23H1WRCQVnY9+HluMzsC+cSjVleCSOgcp4brJ5uE/LPos/2IOSv9aDPHqj2N1uOxiV8COtyfU0=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2528.eurprd05.prod.outlook.com (10.168.138.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Thu, 5 Sep 2019 19:37:31 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 19:37:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Erez Shitrit <erezsh@mellanox.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        Mark Bloch <markb@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Alex Vesker <valex@mellanox.com>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: DR, Remove useless set memory to zero
 use memset()
Thread-Topic: [PATCH net-next] net/mlx5: DR, Remove useless set memory to zero
 use memset()
Thread-Index: AQHVY81KEA2Ew763xU69+l7MFCxCDKcdexgA
Date:   Thu, 5 Sep 2019 19:37:31 +0000
Message-ID: <ae713a1826a9aa76714deb821286c0c14ab342ee.camel@mellanox.com>
References: <20190905095326.127277-1-weiyongjun1@huawei.com>
In-Reply-To: <20190905095326.127277-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a8a39d2-07cc-43dc-5cd3-08d732387e4b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2528;
x-ms-traffictypediagnostic: VI1PR0501MB2528:|VI1PR0501MB2528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB252842657287167D2E9DC269BEBB0@VI1PR0501MB2528.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(346002)(376002)(136003)(396003)(39850400004)(199004)(189003)(102836004)(8936002)(2906002)(6246003)(5660300002)(53936002)(6506007)(86362001)(558084003)(99286004)(76176011)(6486002)(316002)(229853002)(3846002)(14454004)(58126008)(2501003)(25786009)(54906003)(110136005)(6636002)(6116002)(4326008)(36756003)(478600001)(64756008)(66446008)(7736002)(305945005)(71190400001)(486006)(476003)(71200400001)(2616005)(6436002)(91956017)(446003)(76116006)(66066001)(81166006)(11346002)(118296001)(66476007)(66556008)(186003)(66946007)(8676002)(6512007)(26005)(81156014)(256004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2528;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qtXh/7IZbkpd0aW3CyfYl77dOk9wrAV66fFaJVJ49KZHM1UkTic6NEdV0/xl+cvKBjiQULoeovF90HcANVL7ZIec5CzOlXzsKGDSfdbENWMnRYxwhkqFwqIXI96OVtGqT5P+aaAQoGUy6sp9u5fan0R9PenVXcpSIhBF/qVzhSK3C+mcOQQM7kR+6Bw99p/nSqzfvZIN7RyZtciIwfY6U2wZFBa9nQjBmioU6sDIt1FhCWZ5gdnF/YJCa681kM2Wti3o0xSOolzulBd+YLeBn+LN3ugoZqYznp8xdVCUVcdc1ImGUM2S8ZenhK8wBdWFDgp+nr5O9eAVTB2FE4ri6B76zxLXMERGxEuE8705ZybJGU5YrCwtn4xYIN4kiu8NmaGrMsJulqnNoc/aWsmzmkeTPSaRLRmKN2kOuE1XniI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21160ABF23229941BD0911EE2F7FC846@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8a39d2-07cc-43dc-5cd3-08d732387e4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 19:37:31.3305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oQu9RCYjrHlhdER1FcrdZtXLBGy5e/W1QV+4ZvcKcC+V2B3ELlpF/raIm+PvUvanEdnju3FuRWGPOqukPv+e/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2528
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA5LTA1IGF0IDA5OjUzICswMDAwLCBXZWkgWW9uZ2p1biB3cm90ZToNCj4g
VGhlIG1lbW9yeSByZXR1cm4gYnkga3phbGxvYygpIGhhcyBhbHJlYWR5IGJlIHNldCB0byB6ZXJv
LCBzbw0KPiByZW1vdmUgdXNlbGVzcyBtZW1zZXQoMCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBX
ZWkgWW9uZ2p1biA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT4NCg0KQXBwbGllZCB0byBuZXQtbmV4
dC1tbHg1Lg0KVGhhbmtzICENCg==
