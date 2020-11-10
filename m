Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2972ADC7A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgKJQyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:54:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbgKJQyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:54:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAGkHm5012571;
        Tue, 10 Nov 2020 08:54:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=To4mc14h5olrPcYRIWZ9bskd39MNmYGszMcBAlCHSgo=;
 b=HoqMBqYZFPX/nWdIdVUbu21ANMRYoT6aG56p/J3MtyOCc9HSvffu+Ajo5J0rb50R5SOj
 LoU3e66lQzX/aRygK9MEKfy1cbCGbEA89QLnFOPCeaaixrTyduOtlYgLyVibXOfJ5/WB
 sumQF+1c1jxOc9qoalfrzIuAoQeNWPv8WniTr4lpDSxxiJMANB3TWN67utFYXbqEJYYG
 Fio53YabGbU9AybiDjxCX9pB8VVB1jACWZ4/bTUTOwqWCh3UE5fR8luabm7op3D0oZYh
 yE3TJzShqssxYxuMAat4AP0v2Y7uYR+1CicwJnLMElI7ZdcHLYCJbktvTsGKMMLAkfNn VQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuysjsg6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 08:54:03 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 08:54:01 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 08:54:01 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 10 Nov 2020 08:54:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVEr5WSdSdqNNwgXZF5V3Cby0Dj6vQbwCUVignbVsRScg7k4p/WbpDkWFDvvcMhIx2DCuLRtTz/NV+PfXxuT0L+olWDt3Dq6hsa5/myYuoAvo3AZyUUm2v8VFjpTWxInFNTWXOuRHKx6My0+20dWdgvmOhKNbajV5Ql1lF7mYqzGGA7UPlkrWd/VCvBkl1unTMVS1wtUvElAtgwOhk3IwLsXzZ5Gvz2Wlv4laMm87w8ZttlBgrbe7s0fe9JkK4V3Lj2/mVzB/G7kHsVE2gAdyKkRONb0p+gzmGU+Y+DQT81w7n7UEsbM05kiFx4A8LUT4yZoFQx3gtPrKLkOP0asKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To4mc14h5olrPcYRIWZ9bskd39MNmYGszMcBAlCHSgo=;
 b=Z6DQ48E09vk5MyTAWKjlX/+D//at3G7enzPPdPGP0DZHe/uZY5dAt2Wxma+4d+Jdjw0fmuD8KE3qTlHsxIlfaqLuHgUEKmhlNQ/K0WGsoSrOagAbCTkl+p145NjlpYyR86PrGUtYNlVzXtpe+1p6ZpMCkr1XlVeuO+xkjc6op5AbukPQ934tE8GIAaHvET0CZ9zowXT8PqeMPUUwMGWjndCmyKEjpXhF9ZkhXzZlFfPr4OcbWPcVIVCQaXpgQFzNG72VLMotlvSpVtuxugbpgadkYsQf3LR7j61Pb7j6EsCVyp7wousVQ1XzPpY5TJayOHU+W7lXPHV4Xnp5DJ2B3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To4mc14h5olrPcYRIWZ9bskd39MNmYGszMcBAlCHSgo=;
 b=tIGYicYM/heKT8VRwAxrBPELJNgCDzLdrFVCSjNu+mLLr4x+0j/ZBE8nG226vi60jWEqbWvjpTyAYIYh5vzK/IxafhQRkuxlEiwXs7Xz/5rqrjaAK52kVBPwsIhmCmsJA7hjonqK11HupkDMh+dB+T1ovPzB3vS6S90hxOaQ9fs=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM6PR18MB3601.namprd18.prod.outlook.com (2603:10b6:5:2aa::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 16:53:58 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 16:53:58 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [PATCH v2 net-next 06/13] octeontx2-pf: Add support for unicast
 MAC address filtering
Thread-Topic: [PATCH v2 net-next 06/13] octeontx2-pf: Add support for unicast
 MAC address filtering
Thread-Index: Ada3gDVjvfeWdOssRMKXfIo4ErYXkw==
Date:   Tue, 10 Nov 2020 16:53:58 +0000
Message-ID: <DM6PR18MB3212D8BA359A08B18004EB3BA2E90@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.208.47.103]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c1e8e1c-5eb9-4558-a487-08d8859937eb
x-ms-traffictypediagnostic: DM6PR18MB3601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB360169CA456E98E857BCF61FA2E90@DM6PR18MB3601.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XrK03AbEKp1wTaLfyWhW1h2AYWM5XSE/74Wxh43xgfWIsDdjodabkIkC0/rA1/RinOD/EZxEti+PAHWAvUK7aSUyfJeCJ4kXCJRWGUQ0zuEEiJBi1Ky42jBHVu2krEIuAmKgPFqHtca/jhLwnvVVNfnIrqAcNw4A5JymQHEDkdEa3st7n6lqJ6MvoBA/BPlEMu1MhjpRfJ2NoBBgrINu8zK9J6Ae7RwQrbHSZR4AlwA06T/75jBKnJnF+QXCctwJaGALo4hOSAaJPaSLQxpi+xu/uYJltqbWHs9TH98TOCaIUOrLCl3EAE7M/VQJgZUfTL5OByUEhs0hY7ZEKgvFWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(136003)(346002)(5660300002)(9686003)(55016002)(107886003)(86362001)(83380400001)(52536014)(66446008)(6506007)(53546011)(316002)(66946007)(76116006)(54906003)(66556008)(110136005)(2906002)(33656002)(71200400001)(7696005)(8936002)(8676002)(478600001)(4326008)(186003)(26005)(66476007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: u8xa/LzuDPlns+Hb/3aXxZgjijCzGRjnCAbCfkAxSnOJ5sYPZCuuCvbQvDtyOF3n5wWDdJpvgLeH2JwJcuBO60Q8PRErkTpxT3H3aINEz6C4IQrXmeOFQRjss7s+vgwuyVGhzsTOFCPMcSTsRjFtJz64JTx4zrf6ZoOP50hws9zeJumnEf5UGJcQawMBZbxQShAkjAk5jGxlD6GqEsZuUxdY6xsQQ98Yl/p2xojh7673+sYv/j+qFJGLVVElDmfuVUrnvtWYNlLQ2fJf16RSpm6wJCgfBOMPX+zGSEN/LvWNUzIZDcqCCNGFTO7bz/smLFKjyq2iDGTq6ltgaUqcZObP4B5IsLstcAhJbSHihouhdGkPCr5WYw8V6/cm3eRNi4xPvXLxWLiujRHkH6YlwBNkMLoq3PsfbQdD5zfWF4P0ZfSKdhn9FmVyxJcfDg6PJDaYNcC0qh6lyQPVw3Emfd1ikrdwGNJXxReVJiR11lSCNNvwAgaH8QCudzMv6d8n2mqZyp8IPmVOayvAl0QFhuQ+iXi7NpKH8l+gtjh9F2ymh0F8q+HjFvGWHJJTVc9QJblkeut1iZBqhczP8GEc68X4KTvAphy2JTUO+Coik4Si+xF79zAKT99srlMrrOugznlabile6eelTEV+BHi3gQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1e8e1c-5eb9-4558-a487-08d8859937eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 16:53:58.6456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NlpA2Yq0++FIMXtcDpVe8/bVREEQpasys7Uh5SlqqDg28KjgqcOV1aqWqQT57fBwF8Fve+/9WmsItBT4fS18gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3601
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_06:2020-11-10,2020-11-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyENCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz4NCj4g
U2VudDogU2F0dXJkYXksIE5vdmVtYmVyIDcsIDIwMjAgMzo0NiBBTQ0KPiBUbzogTmF2ZWVuIE1h
bWluZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVsbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrdWJhQGtlcm5lbC5vcmc7
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmlsIEtvdnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1A
bWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2Vl
dGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IEplcmluIEphY29iIEtvbGxh
bnVra2FyYW4NCj4gPGplcmluakBtYXJ2ZWxsLmNvbT47IFN1YmJhcmF5YSBTdW5kZWVwIEJoYXR0
YSA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT47DQo+IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2
ZWxsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiBuZXQtbmV4dCAwNi8xM10gb2N0ZW9u
dHgyLXBmOiBBZGQgc3VwcG9ydCBmb3INCj4gdW5pY2FzdCBNQUMgYWRkcmVzcyBmaWx0ZXJpbmcN
Cj4gDQo+IE9uIFRodSwgMjAyMC0xMS0wNSBhdCAxNDo1OCArMDUzMCwgTmF2ZWVuIE1hbWluZGxh
cGFsbGkgd3JvdGU6DQo+ID4gRnJvbTogSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1hcnZlbGwu
Y29tPg0KPiA+DQo+ID4gQWRkIHVuaWNhc3QgTUFDIGFkZHJlc3MgZmlsdGVyaW5nIHN1cHBvcnQg
dXNpbmcgaW5zdGFsbCBmbG93IG1lc3NhZ2UuDQo+ID4gVG90YWwgb2YgOCBNQ0FNIGVudHJpZXMg
YXJlIGFsbG9jYXRlZCBmb3IgYWRkaW5nIHVuaWNhc3QgbWFjIGZpbHRlcmluZw0KPiA+IHJ1bGVz
LiBJZiB0aGUgTUNBTSBhbGxvY2F0aW9uIGZhaWxzLCB0aGUgdW5pY2FzdCBmaWx0ZXJpbmcgc3Vw
cG9ydA0KPiA+IHdpbGwgbm90IGJlIGFkdmVydGlzZWQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBIYXJpcHJhc2FkIEtlbGFtIDxoa2VsYW1AbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogU3VuaWwgR291dGhhbSA8c2dvdXRoYW1AbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogTmF2ZWVuIE1hbWluZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVsbC5jb20+DQo+ID4gLS0tDQo+
ID4gIC4uLi9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9uaWMvb3R4Ml9jb21tb24uaCAgIHwg
IDEwICsrDQo+ID4gIC4uLi9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9uaWMvb3R4Ml9mbG93
cy5jICAgIHwgMTM4DQo+ID4gKysrKysrKysrKysrKysrKysrKy0tDQo+ID4gIC4uLi9uZXQvZXRo
ZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfcGYuYyAgIHwgICA1ICsNCj4gPiAgMyBm
aWxlcyBjaGFuZ2VkLCAxNDYgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gPg0KPiAN
Cj4gPiAraW50IG90eDJfYWRkX21hY2ZpbHRlcihzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBj
b25zdCB1OCAqbWFjKSB7DQo+ID4gKwlzdHJ1Y3Qgb3R4Ml9uaWMgKnBmID0gbmV0ZGV2X3ByaXYo
bmV0ZGV2KTsNCj4gPiArCWludCBlcnI7DQo+ID4gKw0KPiA+ICsJZXJyID0gb3R4Ml9kb19hZGRf
bWFjZmlsdGVyKHBmLCBtYWMpOw0KPiA+ICsJaWYgKGVycikgew0KPiA+ICsJCW5ldGRldi0+Zmxh
Z3MgfD0gSUZGX1BST01JU0M7DQo+IA0KPiBJIGRvbid0IHRoaW5rIHlvdSBhcmUgYWxsb3dlZCB0
byBjaGFuZ2UgbmV0ZGV2LT5mbGFncyBpbnNpZGUgdGhlIGRyaXZlciBsaWtlIHRoaXMsDQo+IHRo
aXMgY2FuIGVhc2lseSBjb25mbGljdCB3aXRoIG90aGVyIHVzZXJzIG9mIHRoaXMgbmV0ZGV2OyBu
ZXRkZXYgcHJvbWlzY3VpdHkgaXMNCj4gbWFuYWdlZCBieSB0aGUgc3RhY2sgdmlhIHJlZmNvdW50
IFBsZWFzZSBzZWU6DQo+IF9fZGV2X3NldF9wcm9taXNjdWl0eSgpIGFuZCBkZXZfc2V0X3Byb21p
c2N1aXR5KCkNCj4gDQo+IEFuZCB5b3Ugd2lsbCBuZWVkIHRvIG5vdGlmeSBzdGFjayBhbmQgdXNl
cnNwYWNlIG9mIGZsYWdzIGNoYW5nZXMuDQoNClVuZGVyc3Rvb2QsIHdpbGwgZml4IGluIHYzLg0K
DQo=
