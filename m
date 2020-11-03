Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4702A3BB2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgKCFLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:11:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12040 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgKCFLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:11:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A355ElR027843;
        Mon, 2 Nov 2020 21:11:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=udXXoetfzrpV0PtFcefRq5XwU4oudNWzMyBl9DJ8izw=;
 b=Zw+xo0fg3aIUtvh1GU4y+KwxF3XejPyz8uQnlFf5MXUR1CjEbOnxcgrCd+ruUvoHw7dA
 r714qM0GCzy2bXzKaTS25vKUgmbEoCKHUxF0WxxWNszxazHOp3bp2D5n7pBTwAIQq102
 uUhqN+Q1g7f6s3vzAmKLMJO3TJDCuOGEvih88u5mL78XyqGE8Mgzmcf5Q7e9OB2EvpY3
 TT/xb62jRQbeEs7DlhpFDsjx/7qWc6cqYt2fxKnoD/7tUjqA7K80W5feh/1VaUKI218w
 q5T5R0lUhgrR9QnvJxuznxDf5SBL19OJy6ZQ4XerxZzNfcZ79doMVkFaOAYd8Bzv8Vbl /A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mv3aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 21:11:12 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 21:11:12 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 21:11:11 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 21:11:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzKkNIbXihGPpuVrE7xf+W8N35/zfxQJ07xQ5RHwXiiEMJ6T0uEk8zfzLx22eUtW0EE8mAm+p9GxOuaDOIQfNJTt9HNLDjGqdSPKASNokH3w8wM93HTkP3e0UmtDirp+M0MprHuj2U6Ezj0W/yJS0wl2HjJPaJT+2VOQ7PVRYb03qNkubr4VizdpEO2rik1q/lpOs2Nlm8wHGPEdDXP+R2Q5bztkzgz8m4H2jyGsE/C0maJXRRT+NwTSvLi0oeOzvis6AJF5wscb+jY/3ENn9/077Kd6lpU8yGSerjsy+SEYaZSBKMztra51eL0DvL+TRWWUdzVsd04THWLdWANypA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udXXoetfzrpV0PtFcefRq5XwU4oudNWzMyBl9DJ8izw=;
 b=LVGeNpjoMSHsGsv+z7SklWHsTKmRiGj4QaoOPWuWwt6+ZrTpGLBmKuhYchXaUkEMmCp++6VaX00Kf5FMbzQs8kG1abwBgWfSQ1V1l/ELzhN/FTT314Q972f5eYYs9/XwZZCvDEiSmUw7BtFk1UEq9lj3bynb9MhhMQ6Ha+kNix7TjltXowTgmW2lNhv2CmEvOCwXxmkcHcveWgbAJZnVqgHzzTre6nCID/C8YmoWjnkfQtpxTjJMzYdzgfeX5SkriLbI/d3KdDhXVSk+6jKqFaYdChWj9+rjlNypb0asLY9z1L1IKn+GkQnFK+bXr1bukIna+es29bBzGeGlvMFd2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udXXoetfzrpV0PtFcefRq5XwU4oudNWzMyBl9DJ8izw=;
 b=rx3aYYRZlqdlrTSue1n6JRVBR4xV6WAFfGvUjRIGt4xJRQtGdTYTB7pxElNvNqfGf1Mat9t1fnQU3mM8wEEuBuiOb2mjWpbKyE/0hF0wnAaeqRMRoCnU3O3TDONnrHjWC4I8bZyu4wPeCFaBg7ozjRgZWAT8t3NR4OJfPBVIXIc=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM5PR18MB1082.namprd18.prod.outlook.com (2603:10b6:3:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 05:11:10 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:11:10 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>
Subject: Re: [PATCH net-next 10/13] octeontx2-pf: Add support for SR-IOV
 management functions
Thread-Topic: [PATCH net-next 10/13] octeontx2-pf: Add support for SR-IOV
 management functions
Thread-Index: Adaxn58fsYFAvW1+SnujJIbOflXmtA==
Date:   Tue, 3 Nov 2020 05:11:10 +0000
Message-ID: <DM6PR18MB32124FD00B4CD6C9921EE641A2110@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [124.123.178.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1227dcb2-7c50-4be1-58d7-08d87fb6e0dd
x-ms-traffictypediagnostic: DM5PR18MB1082:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1082FB4F33EE9373BF7AAEDFA2110@DM5PR18MB1082.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6cSYe3k/Kuu0Swno+Sg2JbQlOjZZ6lhENYlcH9Su8I12bYTDHBF+IK50+3X8+UVxX7ASQ8rR56ElWVLDACCUj6uJLX0vCI6d6DymjNnpN/CzoPskk9art+ET9iIMX6P8ZWq/ORjAG/KZgimODMOVkjPwUkDfkrHwA4vx//L3fneMtDeBLQXXAjdHNxJ2UMzh3BByV/BaqQhJs77XeV5ZPOj28tWzRk6jfHz5akbC/D7qZZS1Nhxu+XJRxbd3LnGSyZQG3Qv2NoVqQRpo/fJpPK5E0Cf4XbWwm/UUYDNkNsiOjmG2jiJFmmINu41PupYCfnnxcHCa6UmWXQozkTBKDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(7696005)(66446008)(64756008)(52536014)(83380400001)(54906003)(9686003)(76116006)(66556008)(66476007)(55016002)(8676002)(66946007)(478600001)(5660300002)(316002)(71200400001)(86362001)(107886003)(2906002)(6916009)(186003)(33656002)(53546011)(8936002)(4326008)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0a0dp/NKtr5x/qoAs70rE/UoWVMfu/d4mgpp11nxoNab+ODB6jV3t4JfzQPjnuXJdXVMMNiN0EqQlVqNGYVzF2wlmlMB5+gIqz4qfXlI44K/dKjNN2upO2+BXX9O8pIXtosQCd52GADVmw2y81s12J+T7clbZQ246pXsTz+hlPAS29pybXGsUyCMv2VGqEULnKHlV9ah2+S0A7dUt6vy6OIWNeW97VOzlkn9/UDgMNzSP0RQo0RdR6fMGxQbDgXGk8jCfk40H3SSLH7u72PuQJk+wYSODbWo6Yn6DQbv4jPLbrFPJATf83CIePTNnLBT7Dr3p2QUde8W9mo1/Z85YyAPkQ0e0fazAkvaO6tjm3KgtCHpYIuwdxerAwJKdyI2Sz4RBI+Z6gD/mTJ3E881fYhT6MOAPm1BPNn0xjlKCXPeXyRIRZlFqKqZEZcc+qtjf1pP018abpKXYKcBSkDFYYSUxoTpWRGR571HyL3pgEI5FFDYg8w49vNUCNnjPxMdu+kYTxsSljcEgsWvQuz/qGJonEXD6hDr+HRUrVOuuYGVEb9y/oNT+jUgDgpMtZgCG1GrLZW757o+fBv3LblP8TiW3rDuQjgzWizD+bt0cpLZlOSlhw2LnCBLc44uqatRlUeSW6Je5ePMza6+lhit0Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1227dcb2-7c50-4be1-58d7-08d87fb6e0dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:11:10.5013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tjpvtZDi1H1piYgEhsCZVrBuOk9XpBa2PwtE2O+bhFi6evirw5Wv5+Kkd0yf7+KE0QUHegZILPIfzfHqVwoUVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1082
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAyLCAy
MDIwIDExOjI1IFBNDQo+IFRvOiBOYXZlZW4gTWFtaW5kbGFwYWxsaSA8bmF2ZWVubUBtYXJ2ZWxs
LmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmlsIEtvdnZ1cmkgR291dGhhbSA8
c2dvdXRoYW1AbWFydmVsbC5jb20+OyBMaW51DQo+IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwu
Y29tPjsgR2VldGhhc293amFueWEgQWt1bGENCj4gPGdha3VsYUBtYXJ2ZWxsLmNvbT47IEplcmlu
IEphY29iIEtvbGxhbnVra2FyYW4gPGplcmluakBtYXJ2ZWxsLmNvbT47DQo+IFN1YmJhcmF5YSBT
dW5kZWVwIEJoYXR0YSA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT47IEhhcmlwcmFzYWQgS2VsYW0NCj4g
PGhrZWxhbUBtYXJ2ZWxsLmNvbT47IFRvbWFzeiBEdXN6eW5za2kgPHRkdXN6eW5za2lAbWFydmVs
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMTAvMTNdIG9jdGVvbnR4Mi1w
ZjogQWRkIHN1cHBvcnQgZm9yIFNSLUlPVg0KPiBtYW5hZ2VtZW50IGZ1bmN0aW9ucw0KPiANCj4g
T24gTW9uLCAyIE5vdiAyMDIwIDExOjQxOjE5ICswNTMwIE5hdmVlbiBNYW1pbmRsYXBhbGxpIHdy
b3RlOg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBuZG9fc2V0X3ZmX21hYywgbmRv
X3NldF92Zl92bGFuIGFuZA0KPiA+IG5kb19nZXRfdmZfY29uZmlnIGhhbmRsZXJzLiBUaGUgdHJh
ZmZpYyByZWRpcmVjdGlvbiBiYXNlZCBvbiB0aGUgVkYNCj4gPiBtYWMgYWRkcmVzcyBvciB2bGFu
IGlkIGlzIGRvbmUgYnkgaW5zdGFsbGluZyBNQ0FNIHJ1bGVzLiBSZXNlcnZlZA0KPiA+IFJYX1ZU
QUdfVFlQRTcgaW4gZWFjaCBOSVhMRiBmb3IgVkYgVkxBTiB3aGljaCBzdHJpcHMgdGhlIFZMQU4g
dGFnIGZyb20NCj4gPiBpbmdyZXNzIFZMQU4gdHJhZmZpYy4gVGhlIE5JWCBQRiBhbGxvY2F0ZXMg
dHdvIE1DQU0gZW50cmllcyBmb3IgVkYNCj4gPiBWTEFOIGZlYXR1cmUsIG9uZSB1c2VkIGZvciBp
bmdyZXNzIFZUQUcgc3RyaXAgYW5kIGFub3RoZXIgZW50cnkgZm9yDQo+ID4gZWdyZXNzIFZUQUcg
aW5zZXJ0aW9uLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhbHNvIHVwZGF0ZXMgdGhlIE1BQyBhZGRy
ZXNzIGluIFBGIGluc3RhbGxlZCBWRiBWTEFOIHJ1bGUNCj4gPiB1cG9uIHJlY2VpdmluZyBuaXhf
bGZfc3RhcnRfcnggbWJveCByZXF1ZXN0IGZvciBWRiBzaW5jZQ0KPiA+IEFkbWluaXN0cmF0aXZl
IEZ1bmN0aW9uIGRyaXZlciB3aWxsIGFzc2lnbiBhIHZhbGlkIE1BQyBhZGRyIGluDQo+ID4gbml4
X2xmX3N0YXJ0X3J4IGZ1bmN0aW9uLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTmF2ZWVuIE1h
bWluZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVsbC5jb20+DQo+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBU
b21hc3ogRHVzenluc2tpIDx0ZHVzenluc2tpQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFRvbWFzeiBEdXN6eW5za2kgPHRkdXN6eW5za2lAbWFydmVsbC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogU3VuaWwgR291dGhhbSA8c2dvdXRoYW1AbWFydmVsbC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1hcnZlbGwuY29tPg0KPiANCj4gZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfcGYuYzoyMDk3OjMx
OiB3YXJuaW5nOiBjYXN0DQo+IHRvIHJlc3RyaWN0ZWQgX19iZTE2DQo+IGRyaXZlcnMvbmV0L2V0
aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL25pYy9vdHgyX3BmLmM6MjA5NzozMTogd2FybmluZzog
Y2FzdA0KPiB0byByZXN0cmljdGVkIF9fYmUxNg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2
ZWxsL29jdGVvbnR4Mi9uaWMvb3R4Ml9wZi5jOjIwOTc6MzE6IHdhcm5pbmc6IGNhc3QNCj4gdG8g
cmVzdHJpY3RlZCBfX2JlMTYNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250
eDIvbmljL290eDJfcGYuYzoyMDk3OjMxOiB3YXJuaW5nOiBjYXN0DQo+IHRvIHJlc3RyaWN0ZWQg
X19iZTE2DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL25pYy9vdHgy
X3BmLmM6MjE1ODo1NTogd2FybmluZzoNCj4gaW5jb3JyZWN0IHR5cGUgaW4gYXJndW1lbnQgNSAo
ZGlmZmVyZW50IGJhc2UgdHlwZXMpDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0
ZW9udHgyL25pYy9vdHgyX3BmLmM6MjE1ODo1NTogICAgZXhwZWN0ZWQNCj4gdW5zaWduZWQgc2hv
cnQgW3VzZXJ0eXBlXSBwcm90bw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVv
bnR4Mi9uaWMvb3R4Ml9wZi5jOjIxNTg6NTU6ICAgIGdvdCByZXN0cmljdGVkDQo+IF9fYmUxNiBb
dXNlcnR5cGVdIHByb3RvDQo+IDIwM2EyMTEsMjE0DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21h
cnZlbGwvb2N0ZW9udHgyL2FmL3J2dV9ucGNfZnMuYzogSW4gZnVuY3Rpb24NCj4g4oCYbnBjX3Vw
ZGF0ZV9kbWFjX3ZhbHVl4oCZOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVv
bnR4Mi9hZi9ydnVfbnBjX2ZzLmM6MTIzNjoyNDogd2FybmluZzoNCj4gaW1wbGljaXQgY29udmVy
c2lvbiBmcm9tIOKAmGVudW0gaGVhZGVyX2ZpZWxkc+KAmSB0byDigJhlbnVtIGtleV9maWVsZHPi
gJkgWy1XZW51bS0NCj4gY29udmVyc2lvbl0NCj4gIDEyMzYgfCAgbnBjX3VwZGF0ZV9lbnRyeShy
dnUsIE5QQ19ETUFDLCBlbnRyeSwNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgIF5+
fn5+fn5+DQoNCkkgd2lsbCBmaXggdGhlc2Ugd2FybmluZ3MgaW4gdjIuDQoNClRoYW5rcywNCk5h
dmVlbg0K
