Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9092426368C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 21:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgIITWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 15:22:10 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:16536 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgIITWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 15:22:08 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f592b5c0000>; Thu, 10 Sep 2020 03:22:04 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 12:22:04 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Wed, 09 Sep 2020 12:22:04 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 19:22:04 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 9 Sep 2020 19:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5ReK24yDnnGf5X5UkNH535tKcjceBeKWbuXnUT0Z/qIu8xqy4GONY90RkhA43kOIQngm9US7ngGaglXh8/1YSKH+4HzEzTIB8LYppRCNFjiEsmB49OBCGcDtH7r4ryXxZv0Wqy0yRrqGzjK6UVRZM4uYOmKBICdRDqGGsPiNyRt02NEk+41bH5jesaQuaiq3U1c0uXRDEVFaXtxtp64w0YLJz2nxGYwH7NrwmVt8n8UAFxAdqxE86CXchBkMddqEJlSrLJ7OnDv5+E+GXJldjb7cIkIEx1+RfaosLsA6H6MNS6OGwt2DO6ZzF2eTn7+h7fnFSyIwQBGdcQChxtRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hSNhg/o/3EJ2e1uRcX6VmxDsP7ziDirSDJkVXcOzpU=;
 b=TSrr0ooEOk9wjHRheMge04Mkor1IoFdUu8IggUL/fbwu5R98bpSCnRCuFIwK4R0TRko821TX2hVwhAdvFeR6g2AoncPwghjSxGfn0xFp3WmrEDfUEaPZBS77KYSs+nU45x+2zV2igVZ3G4qiM1hTIWznx3ONgeS450EO8l82ca7TyEig3EwcfZratOoogq9Qe913gnkzrIyU6+rF3Lny3bg9+/JSCa9CCpTteGGvEeo+W+hu43vDywDPVdQNwTeOw+mZjapL0SD+MD8siTbweTfv/+MniSrIlkQSVuqr7X1NlV1tGBm9YuhHLjcQGJz86T1bN27bxffPJSt59cbyFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 9 Sep 2020 19:22:02 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d5da:96cb:7a03:bc5b]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d5da:96cb:7a03:bc5b%9]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 19:22:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>
Subject: Re: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Thread-Topic: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to
 en_tx.c
Thread-Index: AQHWhkiHT53wZY7V80yfY7kzzX2/h6lfpgkAgAAALICAAQo2gA==
Date:   Wed, 9 Sep 2020 19:22:02 +0000
Message-ID: <f99402b166904107f1ea8051fd0a9ab4b6143e79.camel@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
         <20200909012757.32677-4-saeedm@nvidia.com>
         <20200908.202836.574556740303703917.davem@davemloft.net>
         <20200908.202913.497073980249985510.davem@davemloft.net>
In-Reply-To: <20200908.202913.497073980249985510.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 873ec877-4836-44e2-dd5e-08d854f5a146
x-ms-traffictypediagnostic: DM6PR12MB4297:
x-microsoft-antispam-prvs: <DM6PR12MB42973675CB72875A5499CA06B3260@DM6PR12MB4297.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YqqVubXYj4aKXHPdtNvmkvIkxiw0YnpfYkf5/Lkhe5Phhc9HrEOC7fgO2hSZp0kNumi5mpfaTC8BBPERgpp0ofLl/WjIxwz0vNWEXGHJFaY6a7gh9etTjCWWtLpMRffvEGWbOL0dhrJCGKSv1pwQvRg4+Jb7ud9GOhaYXkm9R9h4uoTG0dt5OOzLEGJ4tFkRcZdS6u1PsIZsw7Mev9hDkJp2AzFr+WctQ8dJ9odSF0Qn+F1VdPmt1D4Cp8huNLnVTGAbcEpLLkcodaMy1J2Aa3QA0WlXI1KrJcYx+6jGhdPNRbUWVdrSmgykVv5lll5Hnh4GF50U8iQl0g1bcCJ0qvN0GwTIW2ECfJNgke3UNhSN9Ffh6AiA4WF0r4a0khc4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(66946007)(478600001)(6512007)(316002)(4326008)(6916009)(107886003)(71200400001)(186003)(2906002)(86362001)(83380400001)(5660300002)(36756003)(54906003)(8936002)(66446008)(66476007)(64756008)(2616005)(66556008)(76116006)(91956017)(8676002)(6506007)(26005)(6486002)(309714004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IhCl6BEyNanHr4sP+lAprH5oF65K5luyT3vdK9RuX3/GSFf9aGUU9W64Q7BZISxktRJWncwB7nkxpn/9yVLqTnwqj/WA2V2EHvCjR0l5F87zRzXgdoCQwVJP2fLCRgPWitf9ZDFSZDDeCrt/FOmnD/d6qAvsUDktgpMIVKbUvnPUih627nifOuiogdEM5NoQvGdN7COpzRSPR/TWPg2kUbGhnuurChLzMuApCL2qzeYHePUb0UJ37A8vEmBUz/xIQ+4i1vRvAnKOJCnEOrZ5IkIEMhSxGePI3p6mmF/N7S0XpSV7l9vbwSRVMwGewEZ/Et3Sfq4tGBtwXU70k3E6m1ZSvt7i4OLuwbDM3kNjfN3fmIbYpF1QZyUaUf6MM5ECAxRqmJTBB75I8ZSs9u27YT7b3Te54DLq5qoJoGJ+yhgosBEwiqvjXgEm2nN1VwnwV7ZnlKy54M+Rnfrg+fRBo3hFPO8iZk8ZIWU2zUd3KI1ffsa/WrTJG25YaVc5Gaq4vaA8pp92Y3Nt+1m070tAr3EvH4oe2GHt7svzNlzmy371U7hETIhftyFbbXMtUnJXWqHTSQ8EVbcfN397g3ajnBx1WSVEfr6Zb9AACPr9seIccadBLkGC2hbddublNyO2+iFqFXq8AiLfqE8rFFXxDA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <04758488EC4E434EA2E68BF68D4EE251@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873ec877-4836-44e2-dd5e-08d854f5a146
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 19:22:02.0440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X0509wh5M46spK07ONVAbfMvLpQvApg2od4GgOog0ZfOkL2NHA6WhlQvjjMh6r4PjAB5MZyNovxKVWd8It+SlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599679324; bh=+hSNhg/o/3EJ2e1uRcX6VmxDsP7ziDirSDJkVXcOzpU=;
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
        b=EM9hl1bO2UtBU1MLtvJJNizBQ7PymnIx/PhE1wHQ+OafdU3q3lqIlLm7+ZUa7kWiL
         J3983VpbTfx2YNXbffk0smIpFVkEi5gArII3JaLgyAIouQV+exgauBVE6DeMlGuc9s
         y5Nym2uE2J+kukyZ7P5sIf5FoxHQT3O9uS38c2IGTESsUidHhuhckUtv0lwJBSITMN
         6WYTgpS3Tny7S11gEW0tIvctfji0n+dWBFsoau94f2w3oAzz4Pb1dgPz7EX1KTaXR2
         hjrTcdbcs0j/Mi1xSl/bilBJWvNH9P6CTvCESzdKsfcwQOSrUqXYhvAP9oDfSxcKOu
         DSS6HjMXRhgCg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA5LTA4IGF0IDIwOjI5IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gRGF0ZTogVHVlLCAw
OCBTZXAgMjAyMCAyMDoyODozNiAtMDcwMCAoUERUKQ0KPiANCj4gPiBGcm9tOiBTYWVlZCBNYWhh
bWVlZCA8c2FlZWRtQG52aWRpYS5jb20+DQo+ID4gRGF0ZTogVHVlLCA4IFNlcCAyMDIwIDE4OjI3
OjQ4IC0wNzAwDQo+ID4gDQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fdHguYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3R4LmMNCj4gPiA+IEBAIC0yMzIsNiArMjMyLDI5IEBAIG1seDVl
X3R4d3FlX2J1aWxkX2RzZWdzKHN0cnVjdCBtbHg1ZV90eHFzcQ0KPiA+ID4gKnNxLCBzdHJ1Y3Qg
c2tfYnVmZiAqc2tiLA0KPiA+ID4gIAlyZXR1cm4gLUVOT01FTTsNCj4gPiA+ICB9DQo+ID4gPiAg
DQo+ID4gPiArc3RhdGljIGlubGluZSBib29sIG1seDVlX3RyYW5zcG9ydF9pbmxpbmVfdHhfd3Fl
KHN0cnVjdA0KPiA+ID4gbWx4NV93cWVfY3RybF9zZWcgKmNzZWcpDQo+ID4gPiArew0KPiA+ID4g
KwlyZXR1cm4gY3NlZyAmJiAhIWNzZWctPnRpc190aXJfbnVtOw0KPiA+ID4gK30NCj4gPiA+ICsN
Cj4gPiA+ICtzdGF0aWMgaW5saW5lIHU4DQo+ID4gPiArbWx4NWVfdHhfd3FlX2lubGluZV9tb2Rl
KHN0cnVjdCBtbHg1ZV90eHFzcSAqc3EsIHN0cnVjdA0KPiA+ID4gbWx4NV93cWVfY3RybF9zZWcg
KmNzZWcsDQo+ID4gPiArCQkJIHN0cnVjdCBza19idWZmICpza2IpDQo+ID4gPiArew0KPiA+IA0K
PiA+IE5vIGlubGluZXMgaW4gZm9vLmMgZmlsZXMsIHBsZWFzZS4NCj4gDQo+IEkgc2VlIHlvdSdy
ZSBkb2luZyB0aGlzIGV2ZW4gbW9yZSBsYXRlciBpbiB0aGlzIHNlcmllcy4NCj4gDQo+IFBsZWFz
ZSBmaXggYWxsIG9mIHRoaXMgdXAsIHRoYW5rIHlvdS4NCg0KSGkgRGF2ZSwgDQoNCk1heGltIHJl
YWxseSB0cmllZCBoZXJlIHRvIGF2b2lkIHRoaXMgd2l0aG91dCBodWdlIHBlcmZvcm1hbmNlDQpk
ZWdyYWRhdGlvbiAofjYuNCUgcmVkdWNlIGluIHBhY2tldCByYXRlKSwgZHVlIHRvIHRoZSByZWZh
Y3RvcmluZw0KcGF0Y2hlcyBnY2MgeWllbGRzIG5vbiBvcHRpbWFsIGNvZGUsIGFzIHdlIGV4cGxh
aW5lZCBpbiB0aGUgY29tbWl0DQptZXNzYWdlcyBhbmQgY292ZXItbGV0dGVyDQoNCk91ciBvdGhl
ciBvcHRpb24gaXMgbWFraW5nIHRoZSBjb2RlIHZlcnkgdWdseSB3aXRoIG5vIGNvZGUgcmV1c2Ug
aW4gdGhlDQp0eCBwYXRoLCBzbyB3ZSB3b3VsZCByZWFsbHkgYXBwcmVjaWF0ZSBpZiB5b3UgY291
bGQgcmVsYXggdGhlIG5vLWlubGluZSANCmd1aWRlbGluZSBmb3IgdGhpcyBzZXJpZXMuDQoNClRo
YW5rcywNClNhZWVkLg0K
