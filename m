Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511542637C4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIIUsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:48:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11264 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIIUsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:48:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f593f5e0000>; Wed, 09 Sep 2020 13:47:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 13:48:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 09 Sep 2020 13:48:09 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 20:48:09 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 9 Sep 2020 20:48:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqn1bu9oSk2uHKAfUD/o7eFdvye+OUh52BiPhS6QW5RrnBOx82j9Y0GTIYDG78ocynqiz44uQ2EarcYyhafQ/zuESR4OlQ00+DjaXgy9h/xoUiyzxuzPsSMyXCchomyboVBu9EipucM1a615pKLKT2GtmqamWbnOk6sLq/Vsl/ZHD4UDEJWLafin2PN89Vs+RSQDED8rc1SAGZx1QSJYv2pWSY4iJ3mTpvnjFW2Wu1w7VAM5jZsiak73sZ6UJttt5hrxAVRzV/jb+9cbJvKJz5sohKz8BrK33tjmN4pN0G3azZmCgKSVmvETV4kzEnYnfMoVIQGF0BzG2culR7jccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SXNe8U+Q1MBYjmZL3ahyISLJ5wb2gkTvNLlZh3UNZw=;
 b=fjk0uYRm1oSE4qWSvbjyiFtS0+koskOMgIQL2hsfUaQ3niPip6XLSelzwEQkiUd+FwuBMkevxK8QCZjinoY/uLk8JxJ+f1AVQZgnP5g+wwh548y62s3BJIUv1LiCybm0aWosATAXnDRHpnvWWPaKIetM4sjZ3kK+nYsDnPQFyXVMDnkivr50MIIrJ4gG9KEh7a4kQeIaDZ1VrP1nN57i8nwPf9I8wRMHJ16ieEm03IjiwX7BOEUuFqunttEm/LWAA8DRgVRMI8m2P2wudNDgvS4n87CHCqojomv0g95/KVx4IQuA3+zFSuPhUkhetzSDOqLlpADTov2cMUgvLhVFAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 DM5PR1201MB2505.namprd12.prod.outlook.com (2603:10b6:3:ea::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 9 Sep 2020 20:48:07 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d5da:96cb:7a03:bc5b]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d5da:96cb:7a03:bc5b%9]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 20:48:07 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>
Subject: Re: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Thread-Topic: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Thread-Index: AQHWhkiHT53wZY7V80yfY7kzzX2/h6lfpgkAgAAALICAAQo2gIAAAbKAgAAWWwA=
Date:   Wed, 9 Sep 2020 20:48:07 +0000
Message-ID: <caded8534b9b1b2cb46be06f5d422d8f93fb5758.camel@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
         <20200909012757.32677-4-saeedm@nvidia.com>
         <20200908.202836.574556740303703917.davem@davemloft.net>
         <20200908.202913.497073980249985510.davem@davemloft.net>
         <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
         <20200909122805.1157cbb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909122805.1157cbb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4610c562-8fdd-434a-6c9d-08d85501a81b
x-ms-traffictypediagnostic: DM5PR1201MB2505:
x-microsoft-antispam-prvs: <DM5PR1201MB25054418F721C965D9FB0C69B3260@DM5PR1201MB2505.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vR3HEg+IzeIxlmfU9BPZkQKaVIppR0LnyS14lh1nBDTFWQ/o8S6o4gfcsSjLVEfvy+a0FOEO9knX48Q4g23bbxLJB+No/eQuyvdMA6QpjuBA96Cyj6vmn569GJmtwRrxHweb2QBzaDkHUwoH4jKFP6SG7sjykBvnRM4G2AgQi9jHgvJu9sbdqLA9q/LFMXlAgEI+1jwrwLRzc0P+zoPzmNwo9zaoa3FFl1858WtWBwHKyMDDwyZC1Jlv4mVoJPYwvynqTYkXvUHmygFhKz0TQT9HFtuX6Mgj0DccY+oONgvfHPMqjcL1+p709V3EOfaRYEXqg2KSqSHaVnKKDTIDOhIXpx0eQXRwPzQlsqCTxBvRebPHOo3iJhu18TAd4OYu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(2906002)(107886003)(8676002)(6506007)(83380400001)(54906003)(91956017)(36756003)(64756008)(316002)(4326008)(76116006)(66446008)(86362001)(66476007)(66556008)(6512007)(6486002)(66946007)(478600001)(6916009)(71200400001)(2616005)(186003)(8936002)(5660300002)(26005)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ImiecjWb1oC8GJumm9OZA1rZj3RGqkVPvJ+Li/kJ91JiaqNTfR12FHfdQXN3TtvPI7DkXR8k8kIyAso4bpV+hq8yneV7Kl3ae6MbRUaxHDtmqfZB6UuOrYvJLwdxlwJ7TtOaM+EceDNYoCpqpg2A1mxWli9sGTPFXMqV9CQyFEUoRzKu2UPqUTLzUXqEt8vqwJf7zRGbPdO2d4oCcYJivEL1Vwt/OUgMbZ1aygc8BG8nPrm+B6VQjbb/dFndMTq5GpK9LWXAKDd6icxSFsgbIKLXM5dPLvxR/xEuydtL8yw6BCNMTWS0JhvCSoqPLBHkBCVpRaXJ5nlfdMemLycX+vWwPoPHrcRArn6QwuNx4lrSVlh4F0yV2FQwS0tK8iuSpEwIa0Wn/d9pvbP4IqKSWDwRbOZmcVYuVaPeRL0LuenQA9RqFdG7Qpv15SUlNiFPO29d5b+zLFLeLxJE34HKoT/NSI0PGQT1sKu4OIblqCGKSEfQZoxJHhmaYypKTy8qTcpWmYelrcjEsW+TIQxhwkDzVfqH+a+ptUmv4/DetcNL1qnsi7QdE2mz7AknfitOLpQuiWBpZ3KoYM20QVpjuhYYErxBIgsInI0OvZYcefcjng1tMCJs2GANf6qXU7gqYU100NlM5I7n7Gjc0bueUA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2938065CDB3C9F4A90591EE8B97900DE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4610c562-8fdd-434a-6c9d-08d85501a81b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 20:48:07.5567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqbCHtQlZ651NfPjKdUIGtsNIjD7WZnHLu+SKHpe9RekOgqkAUftpY5r8/qAYfRko44Uv0QgRcQHqO8vzt/rOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2505
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599684446; bh=7SXNe8U+Q1MBYjmZL3ahyISLJ5wb2gkTvNLlZh3UNZw=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
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
        b=GC79W8Zerh9BsLCJ7TXc/ohSPYhWJNFc+wtk1eJsrTwk+yZggHBhk1+ceSuWI23PU
         sgveLQa/5KQ1b4SZkl05DJOULqfh3TxZgAoFaTaBF5KP/t9d3QlMxnMNIxEtW7ns1F
         KYUZzzvj4+0LYVsUxXRCRENtnrVarjF0Nq8aGS6HLYnoyVzFhTpAaAn4wbnwt6O9O+
         SlRg3iCsv6LYZuSJOU6FWtz24JUMjC4kOm06bMZo0SXJup/oTGWg3khvqAgPfG905d
         swgIoysExMDh6fuLrHypGmziWdjGPiBPLQFceN+TPQOnKp//TPgoRxw436AFtoj5f5
         P/R3wTXJUNgZQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA5LTA5IGF0IDEyOjI4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCA5IFNlcCAyMDIwIDE5OjIyOjAyICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+IE9uIFR1ZSwgMjAyMC0wOS0wOCBhdCAyMDoyOSAtMDcwMCwgRGF2aWQgTWlsbGVyIHdy
b3RlOg0KPiA+ID4gRnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiA+
ID4gRGF0ZTogVHVlLCAwOCBTZXAgMjAyMCAyMDoyODozNiAtMDcwMCAoUERUKQ0KPiA+ID4gICAN
Cj4gPiA+ID4gRnJvbTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPg0KPiA+ID4g
PiBEYXRlOiBUdWUsIDggU2VwIDIwMjAgMTg6Mjc6NDggLTA3MDANCj4gPiA+ID4gICANCj4gPiA+
ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdHgu
Yw0KPiA+ID4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl90eC5jDQo+ID4gPiA+ID4gQEAgLTIzMiw2ICsyMzIsMjkgQEAgbWx4NWVfdHh3cWVfYnVp
bGRfZHNlZ3Moc3RydWN0DQo+ID4gPiA+ID4gbWx4NWVfdHhxc3ENCj4gPiA+ID4gPiAqc3EsIHN0
cnVjdCBza19idWZmICpza2IsDQo+ID4gPiA+ID4gIAlyZXR1cm4gLUVOT01FTTsNCj4gPiA+ID4g
PiAgfQ0KPiA+ID4gPiA+ICANCj4gPiA+ID4gPiArc3RhdGljIGlubGluZSBib29sIG1seDVlX3Ry
YW5zcG9ydF9pbmxpbmVfdHhfd3FlKHN0cnVjdA0KPiA+ID4gPiA+IG1seDVfd3FlX2N0cmxfc2Vn
ICpjc2VnKQ0KPiA+ID4gPiA+ICt7DQo+ID4gPiA+ID4gKwlyZXR1cm4gY3NlZyAmJiAhIWNzZWct
PnRpc190aXJfbnVtOw0KPiA+ID4gPiA+ICt9DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICtzdGF0
aWMgaW5saW5lIHU4DQo+ID4gPiA+ID4gK21seDVlX3R4X3dxZV9pbmxpbmVfbW9kZShzdHJ1Y3Qg
bWx4NWVfdHhxc3EgKnNxLCBzdHJ1Y3QNCj4gPiA+ID4gPiBtbHg1X3dxZV9jdHJsX3NlZyAqY3Nl
ZywNCj4gPiA+ID4gPiArCQkJIHN0cnVjdCBza19idWZmICpza2IpDQo+ID4gPiA+ID4gK3sgIA0K
PiA+ID4gPiANCj4gPiA+ID4gTm8gaW5saW5lcyBpbiBmb28uYyBmaWxlcywgcGxlYXNlLiAgDQo+
ID4gPiANCj4gPiA+IEkgc2VlIHlvdSdyZSBkb2luZyB0aGlzIGV2ZW4gbW9yZSBsYXRlciBpbiB0
aGlzIHNlcmllcy4NCj4gPiA+IA0KPiA+ID4gUGxlYXNlIGZpeCBhbGwgb2YgdGhpcyB1cCwgdGhh
bmsgeW91LiAgDQo+ID4gDQo+ID4gTWF4aW0gcmVhbGx5IHRyaWVkIGhlcmUgdG8gYXZvaWQgdGhp
cyB3aXRob3V0IGh1Z2UgcGVyZm9ybWFuY2UNCj4gPiBkZWdyYWRhdGlvbiAofjYuNCUgcmVkdWNl
IGluIHBhY2tldCByYXRlKSwgZHVlIHRvIHRoZSByZWZhY3RvcmluZw0KPiA+IHBhdGNoZXMgZ2Nj
IHlpZWxkcyBub24gb3B0aW1hbCBjb2RlLCBhcyB3ZSBleHBsYWluZWQgaW4gdGhlIGNvbW1pdA0K
PiA+IG1lc3NhZ2VzIGFuZCBjb3Zlci1sZXR0ZXINCj4gPiANCj4gPiBPdXIgb3RoZXIgb3B0aW9u
IGlzIG1ha2luZyB0aGUgY29kZSB2ZXJ5IHVnbHkgd2l0aCBubyBjb2RlIHJldXNlIGluDQo+ID4g
dGhlDQo+ID4gdHggcGF0aCwgc28gd2Ugd291bGQgcmVhbGx5IGFwcHJlY2lhdGUgaWYgeW91IGNv
dWxkIHJlbGF4IHRoZSBuby0NCj4gPiBpbmxpbmUgDQo+ID4gZ3VpZGVsaW5lIGZvciB0aGlzIHNl
cmllcy4NCj4gDQo+IFdoeSBhcmUgeW91IHJlcXVlc3RpbmcgYSB3aG9sZSBwYXNzIG9uIHRoZSBz
ZXJpZXMgd2hlbiBvbmx5IF9zb21lXw0KPiBpbmxpbmVzIG1ha2UgYSBkaWZmZXJlbmNlIGhlcmU/
DQoNCkkgbWVhbnQgZm9yIHRoZSBpbmlsaW5lcyB0aGF0IGFyZSBuZWNlc3NhcnkgdG8gYXZvaWQg
dGhlIHBlcmZvcm1hbmNlDQpkcm9wLCBNYXhpbSBjYW4gbWFrZSB0aGUgY2hhbmdlIGFuZCByZW1v
dmUgdGhlIHVubmVjZXNzYXJ5IGlubGluZQ0KZnVuY3Rpb25zIGlmIGl0IGlzIG9rIHdpdGggWW91
IGFuZCBEYXZlLg0KDQoNCg==
