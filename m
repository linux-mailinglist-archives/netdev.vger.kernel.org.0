Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB443207CC1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 22:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406362AbgFXUPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 16:15:19 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:48766
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406318AbgFXUPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 16:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHnRdY3XO4XXtvCZ0dlUeQOUeRxcpQ99sExRaH13UlW0tRA5bQOA1COtw1rn2iamBsGGbELKiwD+x6ks+Svaq4rvnzq02bcRHX3hGrWgSVfpmXNWkhPLPUbooVO0uGE0C5RIOSP5RVa1DHWRrRLZZNP1CikeFr+sQsxOIGzkdCqRZCHd82BcOD5m9EJzDdbHqDlVLJkN2p+5CcG1ujh7sET/JNP60sXRlmeyME6pJbQAm+KApdKc8jmnkNJGYLm0gB22r3Y+LjC3f/cCy0kXlQmKOUk6D/jLMSO8x9GhQSU0c68eEOVGyddBVyv7bD+nD9qlvHdJqPsqRAK12Qs/3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZPO/hOqK55KzBgyth5Ug3xzGpg4lF2hHl9jhRsiIwA=;
 b=gEAKRTCNGYquRxqMxwkb2VSQ3e1M3yYi8M6CFI39VvVy0B+kNJnLS0qenBsp6+VhtwUrOvVHDfAYp4eEfsSCGy2OIFP7f/Lz1/rbmN2d2ExOOy+69fxnsSKD3dO7e6JOqX1FpVlEA7h4QyuQbLEMJ4cvNvC2BJIlzKMF6xYvF0mrxqlM3t+0mApVzkW33CdKiNBTDEQYxdqtb89Vnjoul7xjGQV+PvpGOhjwb6CpNIzx//lDnim1ivdek6N5P1JACrNPtbIgko1BV+38lLV5WbJCG4TiXJ+XTxs4T4ecmn/wN2kt9mKvEaqApMmQ71+BR4/tQpbUVyid+cQ6IMZf6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZPO/hOqK55KzBgyth5Ug3xzGpg4lF2hHl9jhRsiIwA=;
 b=roeATFXPsIWPxX9GNktJelhu2iZRsfI92myWhx+5Wx1tTCza84Kz7IIn9wHQuC/Agaai1oekT19v+QtDhPBOmzEIB8rJZpQHFoIbBUc2TjuqpLC9C94HS10dqY5yOREuZzUNxjSu5+DhSV7rbg9HviIBgm8tOHYgB4kA6EBPdfA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3248.eurprd05.prod.outlook.com (2603:10a6:802:1c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.24; Wed, 24 Jun
 2020 20:15:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 20:15:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Aya Levin <ayal@mellanox.com>, "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Thread-Topic: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Thread-Index: AQHWSZftaIEAvWsK9UqUrJlFGGGeOajmuBIAgACd/gCAAAqXAIAApF4AgAAwHoA=
Date:   Wed, 24 Jun 2020 20:15:14 +0000
Message-ID: <19a722952a2b91cc3b26076b8fd74afdfbfaa7a4.camel@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
         <20200623195229.26411-11-saeedm@mellanox.com>
         <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
         <082c6bfe-5146-c213-9220-65177717c342@mellanox.com>
         <20200624102258.4410008d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200624102258.4410008d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bdf5c12b-ec1e-4f68-0c03-08d8187b4e1c
x-ms-traffictypediagnostic: VI1PR05MB3248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3248167CE8FA0A28B92111EEBE950@VI1PR05MB3248.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hdvrSIGy4V3kOR3LLe1MHnicmyjyEL/Wj8/yIHrpELg/pCyN+ZiZ/nPSX6hpVym56BhpH2pycXZLr980rHo5Z4zSzs14dXDFZP7ZyF/PrUabQpOSN8jV86pa/6QzgVsFmrFv7DcxaWMLBs2CgylrOzXtaNYXDZ+WVI2b0njrZ/dUUoASJFYAF1K7PxeoD8rTZrvz3gR4mTgh/mPPatOcFKqs4GsDnW23HNMK2NJcFe3fiJb1SKyxeIq60109Vao8JNKTsfeuz4jcFooIQYETggN+hSy96EOcERkZOleHd1fsu89v8YafXUPJbOzZLbPmI0kRw9DK44k55+R+oJC8mA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(110136005)(2616005)(54906003)(316002)(66556008)(2906002)(36756003)(186003)(71200400001)(478600001)(4326008)(66946007)(66446008)(66476007)(64756008)(6512007)(91956017)(6486002)(76116006)(5660300002)(6506007)(26005)(8936002)(83380400001)(86362001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nSg6ftIZ57ILLuc62/38q1QdEeRx4ui0HAhydN+mLFKaTVUdfltqD3Kk1Hu+7hr3OvZVpnlWGHJSaSR2H5qm2F8QKq/PzJYjMwtFk4lBtdL4sjJ36zaFp/6rSREbtpoRjmQqdCBOJSb2DSgKG0B1Uolg60ojN/65JiH8mCG0b67K3aZwr356qA5RTgQMPbddTr+Nl325x0iQxdoBZrdAmc0jT43n7vrl87daef9Lq08QJKkVwhR1fb0fenLJxNUk+R9/NsXqueCUc+q5z/cYVJ7IOHxPDuwd9AVSvqjXRR0ytSVT6v0Cl95a+vtIYC38aVWtNUgma3x42yKvD9eKqKsEsgsbZyMTed0XXxNrgp1F1hfWDKVb+9pkgbpeUKcnMLmC6Kw570FR1qKrqbAQ9ele31JIYUR8uJ4WlWC6OFouNcnDJaDndSEjhOC3gxZeREmjDAXXlH3t03xb6VbgrcT/amDYiWWtxPW72ett3U4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5569BB2C536A3B418806AF13DA89EA11@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf5c12b-ec1e-4f68-0c03-08d8187b4e1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 20:15:14.1421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pq4voN43I9G+g7FRSVEXHetI3WhzpLUKxjwvWAY9EeL6tMhNExKRmqTIqPqQvGmHuBKvPyp3fXW4L63wPPk8ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3248
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTI0IGF0IDEwOjIyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNCBKdW4gMjAyMCAxMDozNDo0MCArMDMwMCBBeWEgTGV2aW4gd3JvdGU6DQo+
ID4gPiA+IEkgdGhpbmsgTWljaGFsIHdpbGwgcmlnaHRseSBjb21wbGFpbiB0aGF0IHRoaXMgZG9l
cyBub3QgYmVsb25nDQo+ID4gPiA+IGluDQo+ID4gPiA+IHByaXZhdGUgZmxhZ3MgYW55IG1vcmUu
IEFzICgvaWY/KSBBUk0gZGVwbG95bWVudHMgdGFrZSBhDQo+ID4gPiA+IGZvb3Rob2xkDQo+ID4g
PiA+IGluIERDIHRoaXMgd2lsbCBiZWNvbWUgYSBjb21tb24gc2V0dGluZyBmb3IgbW9zdCBOSUNz
LiAgDQo+ID4gPiANCj4gPiA+IEluaXRpYWxseSB3ZSB1c2VkIHBjaWVfcmVsYXhlZF9vcmRlcmlu
Z19lbmFibGVkKCkgdG8NCj4gPiA+ICAgcHJvZ3JhbW1hdGljYWxseSBlbmFibGUgdGhpcyBvbi9v
ZmYgb24gYm9vdCBidXQgdGhpcyBzZWVtcyB0bw0KPiA+ID4gaW50cm9kdWNlIHNvbWUgZGVncmFk
YXRpb24gb24gc29tZSBJbnRlbCBDUFVzIHNpbmNlIHRoZSBJbnRlbA0KPiA+ID4gRmF1bHR5DQo+
ID4gPiBDUFVzIGxpc3QgaXMgbm90IHVwIHRvIGRhdGUuIEF5YSBpcyBkaXNjdXNzaW5nIHRoaXMg
d2l0aCBCam9ybi4gIA0KPiA+IEFkZGluZyBCam9ybiBIZWxnYWFzDQo+IA0KPiBJIHNlZS4gU2lt
cGx5IHVzaW5nIHBjaWVfcmVsYXhlZF9vcmRlcmluZ19lbmFibGVkKCkgYW5kIGJsYWNrbGlzdGlu
Zw0KPiBiYWQgQ1BVcyBzZWVtcyBmYXIgbmljZXIgZnJvbSBvcGVyYXRpb25hbCBwZXJzcGVjdGl2
ZS4gUGVyaGFwcyBCam9ybg0KPiB3aWxsIGNoaW1lIGluLiBQdXNoaW5nIHRoZSB2YWxpZGF0aW9u
IG91dCB0byB0aGUgdXNlciBpcyBub3QgYSBncmVhdA0KPiBzb2x1dGlvbiBJTUhPLg0KPiANCg0K
Q2FuIHdlIG1vdmUgb24gd2l0aCB0aGlzIHBhdGNoIGZvciBub3cgPyBzaW5jZSB3ZSBhcmUgZ29p
bmcgdG8ga2VlcCB0aGUNCnVzZXIga25vYiBhbnl3YXksIHdoYXQgaXMgbWlzc2luZyBpcyBzZXR0
aW5nIHRoZSBkZWZhdWx0IHZhbHVlDQphdXRvbWF0aWNhbGx5IGJ1dCB0aGlzIGNhbid0IGJlIGRv
bmUgdW50aWwgd2UNCmZpeCBwY2llX3JlbGF4ZWRfb3JkZXJpbmdfZW5hYmxlZCgpDQo=
