Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43CC269603
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgINUF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:05:58 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:55100 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgINUF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 16:05:57 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5fcd210000>; Tue, 15 Sep 2020 04:05:53 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 13:05:53 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Mon, 14 Sep 2020 13:05:53 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 20:05:52 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 20:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSctS8TAdDhXdrRSSxJMe7NVhSfpPAQIy8eU1BUXDtsFtI4Hnj5zmFaK4GjfSAWxpuhVcllSxmD1X0xZVAx5cRVyEUCqh96ImaLxuSFBPcJneM2doEzQSmBYPMJ1o7scoOpNglH05ZzQva017AlNJJjn79A2ImkttUz8vlgJWH3r6uHptJXa+nbShiaQ6ySlpEbdPx1pby+CXf4HJOAByGBK34lcuL2HPtQqFCL0Ioa86jurjQIFKzq3PurmI176nfYLXteuR08LM7H8IYxEGZr2JdSnlgtnixV0o8NdwTb7LzMqahY4CZ0HLe0cXTucY48BG1I5ifjUYS2/KzUNpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcQKkOIo1SZ7+d3pEAZIozSYFw9E7cJPqDbHs/uPH7E=;
 b=PDOy/WXuXk27bgGe4YYKaBt7ShRCJe1z1SzxznMZwZxi2EqKlcdh8pnk+3dND2VgJkrwUFHt5fKY0J6FBuRjchCl49UiK6eDG5ZGqSmbL8O4FkflUFalNUCQfFABT0cwfK/s2LCeWZ02YzcujPxD/+p0wvTUa1bZ4wnDkDZO/12MMwj7fpXatkXLN9Ht/6MjEgtKdK0ye/CT2fIIkbAZOXtwUyseWdy5AvU1QQ6VY4NSIxbltwDUBZB2NVU66NYcLCq2X3LNMStVxBo+SLiO2kDTW4kJwdm66bsBg8DnN9EpT2Ri28pqgGdtgf54kDNhx5yq7i03kdepE51e6XVNuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4643.namprd12.prod.outlook.com (2603:10b6:a03:1ff::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 20:05:49 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:05:49 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Tariq Toukan <tariqt@nvidia.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Thread-Topic: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Thread-Index: AQHWiJNZoUr+QGKMUEyUXarY3mHlDqlok7IA
Date:   Mon, 14 Sep 2020 20:05:49 +0000
Message-ID: <fe9a119bb49991d0ac6d71886e9e7918cc7ff56b.camel@nvidia.com>
References: <20200911232853.1072362-1-kuba@kernel.org>
In-Reply-To: <20200911232853.1072362-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf6ba3f2-0092-43cd-31dd-08d858e99366
x-ms-traffictypediagnostic: BY5PR12MB4643:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB46435C0B7F215154020E63EAB3230@BY5PR12MB4643.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DFTYOjoKC0FkKGJIRlvsVGK71rX623w1BTC59/pzetbXFwcjraSwM1oiFqF+6dZDWYLgCcr3tbfHsL6R+pUI7U0GEzDHRokA841ACmEHzOpSAQyYfohUyWl8zfDY49Qp8Fs85pl0/GU2qg7rPngED59gmHyPSRYv51SzH57SalSZShkqPURD/Y4EB1WVF6UtNUaScbNFv11lhra+/cQWCRu3dV+oQf7lphmnoRSn0j8fC2q93y+abwzXTto5AfU64z2igdzHiLGMxFnVDu+RySuNXA7jeTgEhPrCHxIajeLaJa9k2sYyIDHdL0XhR8pzKBLXMsqKj9g3aekvNsaqUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(6506007)(2616005)(6512007)(316002)(110136005)(2906002)(186003)(26005)(36756003)(83380400001)(478600001)(4744005)(8676002)(4326008)(54906003)(71200400001)(6486002)(66446008)(64756008)(66556008)(8936002)(66946007)(76116006)(66476007)(86362001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZiPq+wJa6X13M7aaByw9DE5tpsG6nfmyQWnGJzVLQAURPx1WOuvCtOtAqXKdDsjQaiHpLvdAh1mbR+Q18lr2gZHVSrK6AAiSF9umugnjSW+J+U4xHW5SDavE0giPM7BVG9mZdlTGoSwU8L4Y4s6Cg+UVmBugIGEP7GzkwYRQfCwdh13VkNrja5lSBMY1WTCfyK8aAyMwru8/rpYSTMMB/ej25titFgq8s8zHgDe5D6tDN1RBfFG5lXf9VQs5tTv2IV2/yMzDwQfMUaMU+jCDXx3h52MaxH88HkvHlvmAlvq9Z23AE9dsj7EtU2fquXEG0KvwXYMtUHlf4qwnQN8jLRLXk+TjsG8gbTSlWJbc23qik5Jt+r+7pb0Z/9TjYUANE5RBFpoOfid1m5hS76dZeaqMHwj0DGrITPCD28uZas/JKZeFYoH7plRxUpJIzuZXgFSXny1QWogyBuFAE56mx+poLxLY+34JDDdrsuID+7w6Gwx8tWq2tMILbXr9hX6V7SJTXktKYkz2jESUtKtiieiDKTKi+o3fzgftA9CXCQmRh+2tb5R1qfm2qv6Cc6QiQoaZNZco/jTb6aqWgIN8dDp1rB55HWS2ff05VzGjNBt/mxSIDy4CQOdbzAjbIMWhszIuiNehbm+Vu08TeqYKzQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3B7C8AE197831408D6CB6A9EA2D7A6D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6ba3f2-0092-43cd-31dd-08d858e99366
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 20:05:49.5273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U+gKqzuk4G13ISIQKwNXqgeP6dePv1aSVfa4J2XD95HzbeYJ/yuURCV3LWLAdEgkw7yWODNt0Ke7Ow7pIAmV2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4643
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600113953; bh=tcQKkOIo1SZ7+d3pEAZIozSYFw9E7cJPqDbHs/uPH7E=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=mPfdrpBQMcME7l6n9mRVdNQG5GRR0F2I31VZx1fIIjoPufc8rTtjQirTW1Ud80hMR
         v6+pFXFzwqF6J0FzN5GR/8obBHR+k/JuQPn68Cx1zZ0ak2LNuZ7DzDFKdc+09M/OQ0
         djSICOzB+TZB6LH4hB4pfGcjOzdHR5NIy57/tdWy2LUNqehBFHBaPrwhLiIdkDUbsl
         F7+p0eYx0C4fcyuF6jcgjZiU/NdXUMtAI5GwjeCktAYhsGHQqqdNH4j54EiC4W608v
         uZxTQCcieyihIHVSijopss0sZqRUgFVlbSquBQX4Sw7GdqtJc0b3yIl8Xh1IQPjyzi
         l7eQBL9s2GPAQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTExIGF0IDE2OjI4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gSGkhDQo+IA0KPiBUaGlzIGlzIHRoZSBmaXJzdCAoc21hbGwpIHNlcmllcyB3aGljaCBleHBv
c2VzIHNvbWUgc3RhdHMgdmlhDQo+IHRoZSBjb3JyZXNwb25kaW5nIGV0aHRvb2wgaW50ZXJmYWNl
LiBIZXJlICh0aGFua3MgdG8gdGhlDQo+IGV4Y2l0YWJpbGl0eSBvZiBuZXRsaW5rKSB3ZSBleHBv
c2UgcGF1c2UgZnJhbWUgc3RhdHMgdmlhDQo+IHRoZSBzYW1lIGludGVyZmFjZXMgYXMgZXRodG9v
bCAtYSAvIC1BLg0KPiANCj4gSW4gcGFydGljdWxhciB0aGUgZm9sbG93aW5nIHN0YXRzIGZyb20g
dGhlIHN0YW5kYXJkOg0KPiAgLSAzMC4zLjQuMiBhUEFVU0VNQUNDdHJsRnJhbWVzVHJhbnNtaXR0
ZWQNCj4gIC0gMzAuMy40LjMgYVBBVVNFTUFDQ3RybEZyYW1lc1JlY2VpdmVkDQo+IA0KPiA0IHJl
YWwgZHJpdmVycyBhcmUgY29udmVydGVkLCBob3BlZnVsbHkgdGhlIHNlbWFudGljcyBtYXRjaA0K
PiB0aGUgc3RhbmRhcmQuDQo+IA0KPiB2MjoNCj4gIC0gbmV0ZGV2c2ltOiBhZGQgbWlzc2luZyBz
dGF0aWMNCj4gIC0gYm54dDogZml4IHNwYXJzZSB3YXJuaW5nDQo+ICAtIG1seDU6IGFkZHJlc3Mg
U2FlZWQncyBjb21tZW50cw0KPiANCj4gDQoNCg0KTEdUTSwNCg0KUmV2aWV3ZWQtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4NCg0KQVBJIGZvciBzdGF0cyBvbmx5IHJlcG9y
dGluZyBjb21tZW50IGlzIG5vdCBjcml0aWNhbC4NCg==
