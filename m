Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6C92B2FF1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgKNTAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:00:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15982 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbgKNTAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:00:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEIuOgu009143;
        Sat, 14 Nov 2020 11:00:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=5nnFu+QAn4VPSnn9AG5//JC8aLC6SUUYZH/TzQPXd58=;
 b=I9w73xKBV2rqoHLPNC6xoz0i+zGp1Xd8VwKmljPeccSDbu4SGcyoxtHNBm9i/q9/6Hty
 Kt+sOPdxCP8CBmIK6DEcvhm2LrOdydfah8WNtxTPzdpjvKfYqtd3RfwBTta3wYwYgzaF
 QMr7AjqygVNwGFWxdKFDPI7FQbr1MHHh57EB5hJCHyIsz7mEbAogRzxjukJvRXv2WxLU
 xD/KvuhYkr/lg7BdwRo8VuvbBdOQEurtq6bE2QR3wENjd8v68pwLrSZnU3rgmhMJ/5d0
 FRmyHxfrQ3LywbEiBQ4sGQtvNtiGMPoHDcOA27z0hc0s10axyw6pjik+HwH6CXIcG5vh MQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfms8mcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:00:06 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:00:04 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:00:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 14 Nov 2020 11:00:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljJH2IzuBo4F4qFNW76k9nHti3ZlzJd2XHiGNsyi6a2hTzQmhKQFRjxuxZ79R7hWu2XEH4+bX2g00sd8ef+hEfr8Qqr2vhOTa/l54rDT9D6sFfo/V7zGXbko0wIOAD1wlYHfBZQPb7FcWszm6i5b9kweTPGENSmYeWOPYsW5X5gg0YtF0qfWLPLi/Am2B33C7OdYMY3macQkCkffOQt3N5HGoAKpzGtqUSMhquObGeAnzrNSlAoyYEZI2Ftobsr2suDrU7TnhYa7oHxaB3ZT5MTtHvqP+IXWe/0pY4MxJazsGQa/ZzW0tG4/9oz8lMyujlrIg3Kh40hE4HChlmFo6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nnFu+QAn4VPSnn9AG5//JC8aLC6SUUYZH/TzQPXd58=;
 b=JtRQzH/f1fGziaCr0jCbr0lu61JLsIEPk2hUNwcAA9JzqvAap99Uu/MTAhaym1rTj1eG41mvQswldy4wS9zt30G7mY2jcRxO0KZ31bCIoTUaKtjZSf7bQ663h2IhYlKGI/kmp1GIRusY+6MpHt81Ba+gxoSP5ah3Gn6qzKy+QXhPUxOLR6euoF6cqqI4mdIDGfXZ2oi4YidpMMQSDi9hfmQqNfaT/hi5sULRsi7lSXnYv58IdsXQxUEGE9T3OQXQhpTIZiCMdcELeH9U1GVjm2H1LHDIrxbFr7eAGHMIFZrdzA3PFBU0DLQIEQrxi8ww9xeuP8nSD3NWXCAJvCXgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nnFu+QAn4VPSnn9AG5//JC8aLC6SUUYZH/TzQPXd58=;
 b=iZNAsJaVEfWBxc1e0T03yYQAX+pdqmWlzixb1zIgxwWuD/OhbYanswHvX6hcIfFx+dPQNofcQjE/zF8G3jK1Hch5Dqo7kY9x2QA3bfQOPYMdmhUG3cNAO88m5UKk0Wvv7IpUF3Hg3AOOB3oxEzTqjFci8l7YTJiBvhYA6YSCNPY=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM6PR18MB2442.namprd18.prod.outlook.com (2603:10b6:5:181::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Sat, 14 Nov
 2020 19:00:01 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Sat, 14 Nov 2020
 19:00:01 +0000
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
Subject: RE: [EXT] Re: [PATCH v3 net-next 00/13] Add ethtool ntuple filters
 support
Thread-Topic: [EXT] Re: [PATCH v3 net-next 00/13] Add ethtool ntuple filters
 support
Thread-Index: AQHWuTDBvkTTwaz4QUqCXDqjAfB6VanH/j+A
Date:   Sat, 14 Nov 2020 19:00:01 +0000
Message-ID: <DM6PR18MB321233569BEE8D88940C425DA2E50@DM6PR18MB3212.namprd18.prod.outlook.com>
References: <20201111071404.29620-1-naveenm@marvell.com>
 <0b91885ea6395a139f5d8a317f6a897af9d76cc6.camel@kernel.org>
In-Reply-To: <0b91885ea6395a139f5d8a317f6a897af9d76cc6.camel@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.206.46.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c75179ce-69e8-41d9-dda0-08d888cf7d1c
x-ms-traffictypediagnostic: DM6PR18MB2442:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2442C400B5C6D33040FF1593A2E50@DM6PR18MB2442.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MXdrKGzWB+OVdYwcNJI+ZNuzGJCdj82coSfZQm41NtG2idP7ebbePcRdBX/clnqeXx0OVSOIccSKC4J2VGWQhPSeVGQ5D65bLADV986i0AvqxyiVO3V7xPKBeNYNN44ZfLBNEJvzBGAMlpWrVGMXQMruft0JDUhnQwXGWttboaK5lliuG8oF68IIm8bWlZfMxO9gGegjBnEtWSEOXzfoXu30u/qyRMablSNMxpQldQ9iB8/YtjKHu8LMw5QN4gjl0pH06DHQzhuJ78vPRNaHV5qGm+zJMBzNh518SB7iGFmjC+eG/fSsv8UBPlFvhMJt6OinzH210IDlM+7TiL01pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(55236004)(53546011)(186003)(55016002)(9686003)(6506007)(26005)(4001150100001)(33656002)(107886003)(316002)(5660300002)(8676002)(71200400001)(54906003)(110136005)(66446008)(83380400001)(8936002)(86362001)(478600001)(66556008)(2906002)(64756008)(66946007)(52536014)(66476007)(7696005)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hENW+icgLmBljfb8zJQ6eqKHLglA+gHDmcRbwtC5oLKK2NqEU0R+3vxXtLB9S+6UIw+u/U5PZiHlfPrkwo3/nRbMej320hYVzywJY/NaQojPBe3jgucoG5rOkHqfynENRgp3ZnNkh31TWPIW6UUvZP1yiAmdcuVVoB7YSZLta1UCyC91QgFsDFtJuCLYx+iuYio1bO08dmTEF39HZV67exz1Jyvpe/DUzS9Knm3dXSt8vCXM6yfI59lOmOPGOmHNYGjaYO6BTNmuoo2rxE7LRKS6vCQmmhrE6DLEZIG/i1TJ5tT31yJne2qqyHpShuYqIIpXf9wVPj27cZeyTVbvR/u6TA3vXSLp0rvbDNtWCr8gIWZxdIYiN+0z903Q8KVEjutWlkHiopybgPMlY+w34IamA9CFg5A4mTqNLiOnnljx88nNaNpI2CGprX8bixGoGE2IEEMEXLoxCYZtMO5vMN0yx5pg6jsY7mU0c49C5FVXwtN6MQjsUOqcB0kx4EumbInSNpvQ/DzVssJZDsopXL4OjodJ6sc6hcfREMIstJEhzGUXJVyCWJfFBhN8YdQuAck05aEKqzpOBK9THFsjtsBx29aUzGfonOOsuBnoZW7bDX1qkqMvTQDdRkiw92fSPuhbuVVWeyBeFjO78bQAmA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75179ce-69e8-41d9-dda0-08d888cf7d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 19:00:01.0507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWx1VyKd1NqTjijkx9TYp8lrcBOVKSnMqLzaB5agx+7oWJWLMiipc6py7szhECQQV33ccqdCrHiKYY3hTXtc1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2442
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+IFNl
bnQ6IEZyaWRheSwgTm92ZW1iZXIgMTMsIDIwMjAgMTo0NyBBTQ0KPiBUbzogTmF2ZWVuIE1hbWlu
ZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVsbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrdWJhQGtlcm5lbC5vcmc7IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmlsIEtvdnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1AbWFy
dmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2VldGhh
c293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47IEplcmluIEphY29iIEtvbGxhbnVr
a2FyYW4NCj4gPGplcmluakBtYXJ2ZWxsLmNvbT47IFN1YmJhcmF5YSBTdW5kZWVwIEJoYXR0YSA8
c2JoYXR0YUBtYXJ2ZWxsLmNvbT47DQo+IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxs
LmNvbT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCB2MyBuZXQtbmV4dCAwMC8xM10gQWRk
IGV0aHRvb2wgbnR1cGxlIGZpbHRlcnMgc3VwcG9ydA0KPiANCj4gRXh0ZXJuYWwgRW1haWwNCj4g
DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gT24gV2VkLCAyMDIwLTExLTExIGF0IDEyOjQzICswNTMwLCBO
YXZlZW4gTWFtaW5kbGFwYWxsaSB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIHNlcmllcyBhZGRzIHN1
cHBvcnQgZm9yIGV0aHRvb2wgbnR1cGxlIGZpbHRlcnMsIHVuaWNhc3QNCj4gPiBhZGRyZXNzIGZp
bHRlcmluZywgVkxBTiBvZmZsb2FkIGFuZCBTUi1JT1YgbmRvIGhhbmRsZXJzLiBBbGwgb2YgdGhl
DQo+ID4gYWJvdmUgZmVhdHVyZXMgYXJlIGJhc2VkIG9uIHRoZSBBZG1pbiBGdW5jdGlvbihBRikg
ZHJpdmVyIHN1cHBvcnQgdG8NCj4gPiBpbnN0YWxsIGFuZCBkZWxldGUgdGhlIGxvdyBsZXZlbCBN
Q0FNIGVudHJpZXMuIEVhY2ggTUNBTSBlbnRyeSBpcw0KPiA+IHByb2dyYW1tZWQgd2l0aCB0aGUg
cGFja2V0IGZpZWxkcyB0byBtYXRjaCBhbmQgd2hhdCBhY3Rpb25zIHRvIHRha2UgaWYNCj4gPiB0
aGUgbWF0Y2ggc3VjY2VlZHMuIFRoZSBQRiBkcml2ZXIgcmVxdWVzdHMgQUYgZHJpdmVyIHRvIGFs
bG9jYXRlIHNldA0KPiA+IG9mIE1DQU0gZW50cmllcyB0byBiZSB1c2VkIHRvIGluc3RhbGwgdGhl
IGZsb3dzIGJ5IHRoYXQgUEYuIFRoZQ0KPiA+IGVudHJpZXMgd2lsbCBiZSBmcmVlZCB3aGVuIHRo
ZSBQRiBkcml2ZXIgaXMgdW5sb2FkZWQuDQo+ID4NCj4gPiAqIFRoZSBwYXRjaGVzIDEgdG8gNCBh
ZGRzIEFGIGRyaXZlciBpbmZyYXN0cnVjdHVyZSB0byBpbnN0YWxsIGFuZA0KPiA+ICAgZGVsZXRl
IHRoZSBsb3cgbGV2ZWwgTUNBTSBmbG93IGVudHJpZXMuDQo+ID4gKiBQYXRjaCA1IGFkZHMgZXRo
dG9vbCBudHVwbGUgZmlsdGVyIHN1cHBvcnQuDQo+ID4gKiBQYXRjaCA2IGFkZHMgdW5pY2FzdCBN
QUMgYWRkcmVzcyBmaWx0ZXJpbmcuDQo+ID4gKiBQYXRjaCA3IGFkZHMgc3VwcG9ydCBmb3IgZHVt
cGluZyB0aGUgTUNBTSBlbnRyaWVzIHZpYSBkZWJ1Z2ZzLg0KPiA+ICogUGF0Y2hlcyA4IHRvIDEw
IGFkZHMgc3VwcG9ydCBmb3IgVkxBTiBvZmZsb2FkLg0KPiA+ICogUGF0Y2ggMTAgdG8gMTEgYWRk
cyBzdXBwb3J0IGZvciBTUi1JT1YgbmRvIGhhbmRsZXJzLg0KPiA+ICogUGF0Y2ggMTIgYWRkcyBz
dXBwb3J0IHRvIHJlYWQgdGhlIE1DQU0gZW50cmllcy4NCj4gPg0KPiA+IE1pc2M6DQo+ID4gKiBS
ZW1vdmVkIHJlZHVuZGFudCBtYWlsYm94IE5JWF9SWFZMQU5fQUxMT0MuDQo+ID4NCj4gPiBDaGFu
Z2UtbG9nOg0KPiA+IHYzOg0KPiA+IC0gRml4ZWQgU2FlZWQncyByZXZpZXcgY29tbWVudHMgb24g
djIuDQo+ID4gCS0gRml4ZWQgbW9kaWZ5aW5nIHRoZSBuZXRkZXYtPmZsYWdzIGZyb20gZHJpdmVy
Lg0KPiA+IAktIEZpeGVkIG1vZGlmeWluZyB0aGUgbmV0ZGV2IGZlYXR1cmVzIGFuZCBod19mZWF0
dXJlcyBhZnRlcg0KPiA+IHJlZ2lzdGVyX25ldGRldi4NCj4gPiAJLSBSZW1vdmVkIHVud2FudGVk
IG5kb19mZWF0dXJlc19jaGVjayBjYWxsYmFjay4NCj4gPiB2MjoNCj4gPiAtIEZpeGVkIHRoZSBz
cGFyc2UgaXNzdWVzIHJlcG9ydGVkIGJ5IEpha3ViLg0KPiA+DQo+IA0KPiBSZXZpZXdlZC1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPg0KDQo=
