Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF136E7005
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 11:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388388AbfJ1KyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 06:54:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54322 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728554AbfJ1KyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 06:54:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SAoUsF019263;
        Mon, 28 Oct 2019 03:53:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=aYFHtx5i3Op3YaH4QYtN9aEhj5QrwtvhKVpuX17+1Os=;
 b=mlhLzOPZF7O14FynxsQixq1Ac49+p/5QDb/CYwwIovKuD5aoWaa6LPvSFJV2xA4Jj5fM
 ytvl+nejRjc7ZDQN5RIPA2HYoULKzDvDh48swskdZWOc/SPNpreAPIgMyLwmaLbm7gxq
 1nb4+j9oVlRoJ7ncnwnfoN6nCiJeM5jDnMLvEnaCbywQNbxpBVzuTFDsgXxbjICKcps3
 vuZJb2y9cGQE7Rq18WfACORBzD4U8CcVaJZlb+wWJc8DhcOaTRdS11c96tB5nbOod3Z5
 lgInRtVjTqFBg1MWS+MT/b0KLWci7gJjRYHNph21R6biKtATK39jQ3OIOMuGn+z+B94U oA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vvkgq5kcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 03:53:57 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 28 Oct
 2019 03:53:56 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.59) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 28 Oct 2019 03:53:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhyaXjeOuZp+QJdD2QC12uLTZxnEwqdCzZWd5zbiO0CmNHxajXztJ8Gu8+p4EYZ4rcmf2ocuEPDrmv+melpFkiz3SVqDvDh88hVWeoymhuEIZkIGkmI+76ALgmGYEk2OdIDdoTdqXKC4SOpbu63+NdYLc+IiDgwRayFIowb1yrmcK+kYMG4P9Y9O/PVtw+dFFXnZYldZmkCY9fdVFIrPFmknpXnqosUt/G5IjU+QKzkhmXzNsoCLEuBuyxSSuxPGLYj/ci7tyIizOTsFMqy/7P3eBtNdnzMwsMdPUvvw+F4Lca3pC5QNZ0XVjjnHg47N/59FZQ9HGVU3RJY0Ib23sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYFHtx5i3Op3YaH4QYtN9aEhj5QrwtvhKVpuX17+1Os=;
 b=WNefG1D3iKZF6zsNbpij3t+Xb/Y6Ik8fErA5Jfu9AlBQDZfcNqeBhwrnTelTFJYNgoiAl3FvntY5LoHTCWA3PguAL0owzuPOlXP/hu/9JBdOnuWrP38TcdXF3Z36ZC9ZrmvTfHyN4dTDG+v0waQAraERg80C5zJAJpAhwlZNEqvFKZmvYlUWoLCLyru+r3nitbF4mYVgzhvLOzzIDEcAgGEIFfL8GMOUQBB/46butIG7sf6g3Uhij75JUR8IhZ7UREWCt0V/SJK5tp6+l4dGJXBaORbf4nnsVweO+mv7pPUHq+LtFmCg22fISF7lbhjsy6pzN+lMgFnZF80R8ErQKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYFHtx5i3Op3YaH4QYtN9aEhj5QrwtvhKVpuX17+1Os=;
 b=Q7I+TKk+NiSRjJLC9OOSORA6iLeITVQ1Xg1QLWYX4Hddb8W4wbXH00Af3W3MBxvgHI97Tq8zs/5dOwR2T/dGQ6GvnCRHGZW6udKaYQLnICFyYh7NjaMcSIg/Hjl+FgWb6L0zw+GMmj4NRw/Kl/knVx5ZioadfsvCe/9Z1mFDX5I=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2114.namprd18.prod.outlook.com (52.132.9.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Mon, 28 Oct 2019 10:53:54 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 10:53:54 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dmitry Bezrukov" <Dmitry.Bezrukov@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next] net: aquantia: fix error handling in
 aq_nic_init
Thread-Topic: [EXT] [PATCH net-next] net: aquantia: fix error handling in
 aq_nic_init
Thread-Index: AQHVjX39Va16a2hsUESGAfJF8Iu5cg==
Date:   Mon, 28 Oct 2019 10:53:54 +0000
Message-ID: <ad34c73f-19ee-eb83-221b-cd9fac1d44d5@marvell.com>
References: <20191028065633.GA2412@embeddedor>
In-Reply-To: <20191028065633.GA2412@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0138.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::30) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37d26c16-cfce-4f72-3b74-08d75b951fe3
x-ms-traffictypediagnostic: BL0PR18MB2114:
x-microsoft-antispam-prvs: <BL0PR18MB2114CB93EF3422EDBBE67B8AB7660@BL0PR18MB2114.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(396003)(39850400004)(199004)(189003)(2616005)(6506007)(478600001)(8676002)(26005)(476003)(6246003)(71200400001)(316002)(71190400001)(54906003)(110136005)(6512007)(66946007)(102836004)(66476007)(66556008)(64756008)(66446008)(11346002)(3846002)(486006)(31686004)(2906002)(81156014)(86362001)(81166006)(99286004)(4326008)(8936002)(14444005)(256004)(186003)(446003)(6116002)(31696002)(6486002)(52116002)(7736002)(76176011)(5660300002)(14454004)(305945005)(25786009)(229853002)(66066001)(36756003)(6436002)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2114;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wa9f69f+Ex6pS3uaYDOr6edLYytjtDghIPrQEgnXhOGCJ8L0M4H5tLLyvIVpmWWZlYTo9Z5dVt2BPc8VM4s6RgQO5O4shM6yLLT9kajydeDrSLv0WKD+iqIJKINAy2bW92Y8jcMrAUNLmX9mVpp+q3Tu2K7UwCJaPwUBe3DPJyS+Ox/I8C0nnitDkqM0TvRkXSsWFjl75fndsAXKepQ4i8xUBleKRFUvmdxe7E3lqqxL3W0OWMruAxLZzTJKizMDnMZpKPiYxcz4q0kB6v+ZoR/mugDVO3Exq2/omZqwpENmlLN7vsW+2UkbwN6VCVG0HJFynXtcQgtayFVB6UMjbB56SX2t4i/bSHloeXHkISdwdOSdQVJYNKYv53IwnIee9HYztJXLn7ilM3VlgCkmUy396KlyAJ1lelCXoqsRF2ukRB6Zw8l6AHVnsR4jiOcQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <58C8773C3D8CEF44974EC0E093B58982@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d26c16-cfce-4f72-3b74-08d75b951fe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 10:53:54.1833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G9tVhSzBy2gHoCY6+0XxBWG4ochRjnR5dPG1uVP0azKJPRVo/wPUpbgiOAQiJdKQkV+yhRYMLlaK7WzUQkn65Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2114
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_05:2019-10-25,2019-10-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZpeCBjdXJyZW50eSBpZ25vcmVkIHJldHVybmVkIGVycm9yIGJ5IHByb3Blcmx5IGVycm9y
IGNoZWNraW5nDQo+IGFxX3BoeV9pbml0KCkuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHktSUQ6
IDE0ODczNzYgKCJVbnVzZWQgdmFsdWUiKQ0KPiBGaXhlczogZGJjZDY4MDZhZjQyICgibmV0OiBh
cXVhbnRpYTogYWRkIHN1cHBvcnQgZm9yIFBoeSBhY2Nlc3MiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBH
dXN0YXZvIEEuIFIuIFNpbHZhIDxndXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jIHwgMyArKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMu
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jDQo+IGlu
ZGV4IDQzM2FkYzA5OWU0NC4uMTkxNGFhMGExOWQwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYw0KPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYw0KPiBAQCAtMzQxLDcgKzM0MSw4
IEBAIGludCBhcV9uaWNfaW5pdChzdHJ1Y3QgYXFfbmljX3MgKnNlbGYpDQo+ICANCj4gIAlpZiAo
c2VsZi0+YXFfbmljX2NmZy5hcV9od19jYXBzLT5tZWRpYV90eXBlID09IEFRX0hXX01FRElBX1RZ
UEVfVFApIHsNCj4gIAkJc2VsZi0+YXFfaHctPnBoeV9pZCA9IEhXX0FUTF9QSFlfSURfTUFYOw0K
PiAtCQllcnIgPSBhcV9waHlfaW5pdChzZWxmLT5hcV9odyk7DQo+ICsJCWlmICghYXFfcGh5X2lu
aXQoc2VsZi0+YXFfaHcpKQ0KPiArCQkJZ290byBlcnJfZXhpdDsNCj4gIAl9DQo+ICANCj4gIAlm
b3IgKGkgPSAwVSwgYXFfdmVjID0gc2VsZi0+YXFfdmVjWzBdOw0KPiANCg0KSGkgR3VzdGF2bywN
Cg0KSSdkIHNheSB0aGUgaW50ZW50aW9uIGhlcmUgd2FzIHRvIGlnbm9yZSB0aGUgZXJyb3IsIGFz
IGRyaXZlciBtYXkgc3RpbGwgbGl2ZSBpZg0Kc29tZXRoaW5nIHVuZXhwZWN0ZWQgaGFwcGVuZWQg
b24gUGh5IGFjY2VzcyBwYXRoLg0KDQpOb3RpY2UgaW4gdGhlIGFib3ZlIGZpeCB5b3UgbGVhdmUg
YGVycmAgYXMgemVybyBidXQgZG8gZXJyb3IgcGF0aCByZXR1cm4gLQ0KdGhhdCdsbCBicmVhayB0
aGUgZGF0YXBhdGguDQoNCkknZCBwcmVmZXIgdG8gZml4IHRoaXMgd2l0aCBzaW1wbGUNCg0KICAg
ICAodm9pZClhcV9waHlfaW5pdChzZWxmLT5hcV9odyk7DQoNCi0tIA0KUmVnYXJkcywNCiAgSWdv
cg0K
