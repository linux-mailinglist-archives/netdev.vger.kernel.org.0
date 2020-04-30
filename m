Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA86E1C0079
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgD3PhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:37:14 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:26702
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726619AbgD3PhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:37:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OY7NaSsqgaN/UzKuKyPVvjCbcnzI5YdCTl6n6odtieK1t/cwWwcDCFhdUHf9aPg0kARAVMPSgjvngj1fXavdGOsIr+cou9xOrF9gaH3mSIkGJ5Ohh5v9g6YssNt6YOnjEMrAO3DAwgT5AYMP4oemRgVd1a/n++2wYM34ecUKVG4hp8e4Mp3Ni139cDXmtUuV3slWgrRFu7lxlNnucTgWOm6cKqvxupqQehMGMsvFJT4tFE3l4pIw7BUM+5hbA+qewI6vDkKaGgtakhTgvx7FY40yK3M7S7NtR0WS412eUYKyyNWPWrJSnR1LJ+VYT/+SNPTRc9f2jd4Q7VWNRJG6Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvBMSsCqa+JoC6TRsdXYBHW3h0kMFBZ17Fx1d57++AQ=;
 b=GKdvFGgKwe3GzW3klBZVCqcbEk2Xbg1BaAR3y9fN2Nbmk5jSfVLFfD7/XLkmY5GgxsyvF/ATMVwEwg6PAOmFpPfOtupjOduaCjHvISwgyB39dBxMutCvb0iG+hAFJIZcbdEan+Ck+viWWcbMi2Jlton+D0pu1PJ1RPOmr2QbmUkhVVpFmyFQpZq6BplE3Ln6XDjQrNnkfEvqgcnP5qF2SrmwRhcVXnHeNu7ePewDnuJ98xaLVhgCE2oQuhRQE8vSUwMP96cxFp/vRzdY+EqG4K2ppuhYLbn/Uy9xoeMxABQQ9u4flLTu9M/0Z3B1wOSeQ2XlFBC4RLsEB622PbLLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvBMSsCqa+JoC6TRsdXYBHW3h0kMFBZ17Fx1d57++AQ=;
 b=YYUAXjWOCbHcK2ppjoKSNN2QaiI6g53oLnCft0Fk1XvHnyG4cbmcbosExArfE2/BviJLBBHYToZprjeQ5qLWm4cQNBsXR6L4rBtxUmC0O/OXG7Hy1HVpvfUQa4nOPHEW7hZNFC1YgHZYflXkyJtXeUyrsL5G5MHrZgRlhRY5DCc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6303.eurprd05.prod.outlook.com (2603:10a6:803:102::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 15:37:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 15:37:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 8/8] net/mlx5e: kTLS, Add resiliency to zero-size record
 frags in TX resync flow
Thread-Topic: [net 8/8] net/mlx5e: kTLS, Add resiliency to zero-size record
 frags in TX resync flow
Thread-Index: AQHWHnlGkBWvZX3mfkSmotxvr+MvzqiQyyoAgACI3YCAAHlwAA==
Date:   Thu, 30 Apr 2020 15:37:09 +0000
Message-ID: <8b1ceea21d536bd570fb2173086b680146d837c9.camel@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
         <20200429225449.60664-9-saeedm@mellanox.com>
         <20200429171238.3f3a552a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <00f2e766-a6eb-ce51-a787-ae9ab504dda6@mellanox.com>
In-Reply-To: <00f2e766-a6eb-ce51-a787-ae9ab504dda6@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 08b4aceb-3d0e-4d83-145e-08d7ed1c58da
x-ms-traffictypediagnostic: VI1PR05MB6303:|VI1PR05MB6303:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB63039711A1B0C94C1D8BC969BEAA0@VI1PR05MB6303.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(66476007)(64756008)(66446008)(86362001)(6512007)(6486002)(4744005)(6506007)(8676002)(8936002)(2906002)(71200400001)(26005)(4326008)(5660300002)(186003)(66556008)(316002)(6636002)(91956017)(76116006)(53546011)(66946007)(54906003)(478600001)(110136005)(36756003)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bT1+p0FqIcn8CBofXIt+tdKMNJDnF8NvpRqumJZ56jXfqKDGR0hUECnd0AiT+7uq8AmFLXbSEXQrOZG/3GxZUQz1lYkywj4OZFBDJPn4aL3ZlwKrxl1z4Z03gTLBIsn/9HFBGsm70co/GgFzKIOQ6uUBvG2R99x34/ORLWtrPpyCnL26snfA8IPmlkCPdneqZKCdbJqwgP7sObs22yr3eMTJTkEsd01awjG9YsRTvgSuDpPw2iRvjtdJl5IWx//7IAQdCzy5I8NV4H/INVmmVk921wB44vtCh3AeX8zyEuWLC5XC+ae/VogEK6wH33GQlZzJEbPQU8ZboaORqVEPhh/la4dILuYNfd4juhxNze6AWnk4l+wlDesVFe2LBh2lPqF57whFtbTgEJUhOEYbYbcPmnKWXmtIO1CPpRfxwhL0riH7DDulSVHVz636iOlG
x-ms-exchange-antispam-messagedata: 6LGwDmJIIr0+TA7JSsj5yHcp4I/a8uko+2qnw3ohRbwlD1/WDMfmMpQKMBxFDSmHsZGWngMYmp3DAMJ03C2z+rw4Hx1fZy2N+CzaBooTVLgfYstJatef5l3uYogMKbGVuaPReyJY4QYMegxkmA2yKaGEH+hithg6LC2wrZZROvZhwABTI4JRECkZeO/pvQo7KZ2RZZutDj5pmN3Ld+tfll2m08cdvkuN8+XwMPd1UQ1WWzV+NlYN6cRd4WYdbFyIxzRejsg2XonVGucn003fyhAvCeW28pmoSGhhv8+X8XEMY9xE29cMJ3fJplcdweatmlpgXoRlTU+wP4h2goOUtFJAiVykMZn163yRa1FuCb71ixY2mYFc6kEJEpjo+n/vBocNn+BwuFf0cD8ibORTKR0JEHwyp4D21LIuE/vBJdiEfbIDi4MigpTPzEN17DduwxW+3q2LzUu/yjKHYk0mxxFCTKGDwnjveTVUGqI5cPQjSgEiLZyj0MNCwgVUrpXxkds31BDc7rkIOz5UpfHlZfmPnrMNWYwFY4xL2YjteSXk6D/B5DnICrp66mvjK05GCSSAQ+YwDo5WvXdeHjNVaKSEa2eSt6r9sFtb1PA4mLCIqVHzThRS35FspPciCDRdrjQcEMNfSkuz7xExf9v2uQFYHqEwPB1t0WCbgCf5/Jr8kOu529dh/KvxpvhbuEvXNRrtR4ylk8KgzynNbzrPgaRfwhztgEatPiZPXikIkfOhQkU81rZ12GjnJi9yIYPy8juTvCkssqc5Enkjgq9qNwDBOtYM9KUOFXvndYNcBiM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B687DBF7B236904C9E2419185CAD2FE4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b4aceb-3d0e-4d83-145e-08d7ed1c58da
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 15:37:09.9989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQQcztgyjGMkNz+ahD26X0bwgW4VGoNt66Wev5ygUqDHJGy0qgMe6f8Q5ntfpNGOvqDNqRv09uniRo3luhhHtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6303
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTMwIGF0IDExOjIyICswMzAwLCBUYXJpcSBUb3VrYW4gd3JvdGU6DQo+
IA0KPiBPbiA0LzMwLzIwMjAgMzoxMiBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24g
V2VkLCAyOSBBcHIgMjAyMCAxNTo1NDo0OSAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4g
PiA+IEZyb206IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiA+IA0KPiA+
ID4gU0tCcyBvZiBUTFMgcmVjb3JkcyBtaWdodCBoYXZlIGVtcHR5IHplcm8tc2l6ZWQgZnJhZ3Mu
DQo+ID4gDQo+ID4gV2h5PyBMZXQncyBmaXggdGhhdCBpbnN0ZWFkIG9mIGFkZGluZyBjaGVja3Mg
dG8gZHJpdmVycy4NCj4gPiANCj4gDQo+IEhpIEpha3ViLA0KPiANCj4gVGhlIEhXIHNwZWMgcmVx
dWlyZXMgdGhlIERVTVAgc2l6ZSB0byBiZSBub24temVybywgdGhpcyBwYXRjaCBjb21lcw0KPiB0
byANCj4gZ3VhcmFudGVlIHRoaXMgaW4gZHJpdmVyLg0KPiBJbiBrZXJuZWwgc3RhY2ssIGhhdmlu
ZyB6ZXJvLXNpZGUgZnJhZ21lbnRzIGlzIGZvciBzdXJlIG5vbi1vcHRpbWFsIA0KPiBwcmFjdGlj
ZSwgYnV0IHN0aWxsIGNvdWxkIGJlIGNvbnNpZGVyZWQgdmFsaWQgYW5kIHRvbGVyYXRlZC4NCj4g
SSBhZ3JlZSB0aGF0IHdlIHNob3VsZCBmaW5kIHRoZSBzb3VyY2Ugb2YgdGhpcyBwcmFjdGljZSBp
biBzdGFjayBhbmQgDQo+IGVuaGFuY2UgaXQuDQo+IA0KDQpPayB0aGVuLCBsZXQncyBmaW5kIHRo
ZSBzb3VyY2UsIGkgd2lsbCBkcm9wIHRoaXMgcGF0Y2ggZm9yIG5vdy4uDQpXZSBzaG91bGQgYWlt
IGZvciBsZXNzIGRyaXZlciBjb2RlIGR1cGxpY2F0aW9uLCBpZiB0aGlzIGlzIHNvbWV0aGluZw0K
dGhhdCBjYW4gYmUgZ3VhcmFudGVlZCBieSB0aGUga3RscyBzdGFjay4NCg0K
