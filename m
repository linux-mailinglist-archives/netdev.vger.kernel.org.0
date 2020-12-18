Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B0B2DDE1C
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 06:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgLRFhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 00:37:38 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:12969 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgLRFhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 00:37:37 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdc3ff80000>; Fri, 18 Dec 2020 13:36:56 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 05:36:51 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 05:36:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcyLXQqx33Vxi4tlYgXOsxyhNzNA34gNxMsqeKVI1/UuG37ceNlKG/fXlUyN1PAeZdteoXaOheS1lGZFe4r8Bqvzr+7J+mjdn4KaP+XjpGcVq1XlMDllU/iMBXri4hMbwcGDGxsgZJgM6/K/e0IXKyz9+ebnxIc2XMRTweN3fTddDvn4oJSB/0wqhVhkjMclbXdvS/hrUe/WwJnKvv30bIG4bkklSplLyg992BpF4QKidFAjEZYj0HhZti87NxQJRefIJ12etoec/XavoDrJhccGQ+TaKhBN8Z+HhovH3yeTbw9eoc5ajOEfYhV2A19HhBkobTNWtrZQjJJ/opFJxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWHQ9/A25JflZWDbLIVX1NgT1kdn8NcENGcUb0AMxik=;
 b=DtEQgitGqTroX4EjqnCAUpvR0ZyDiR1C3Nq0wH6ju5xZ+l7I1isyqIWInsjna0Gc93jR/iX5mDD9/aFV5DrhoZkHPkWV7RJVTyDj92BzaUSdlgb81A+CTRPX4Ju7HZAbX1O2BtNfRCYVo1/faN+k18KdEaz/BWHOgDK7SUyY7/kFFbkW1XCnwEbUorAfWCouF1Wm+CqSY/htBfAWB0Kx1nwWfwc4k6sdirfoZ2PsHTSlvwJhol2QRRJeWKSVgqZeetHRcicPUEt2Pee2ZrQ2EFaSKI96qtdl5vcfzqXJZHahvwFJAEsGw0pBTwZJ5YVUm5q81JhLvbO5/dUoBBgwoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4742.namprd12.prod.outlook.com (2603:10b6:a03:9f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 05:36:49 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Fri, 18 Dec 2020
 05:36:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kiran Patil" <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Topic: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Index: AQHW0mKFU48o8ZNlzEyGRue6Xkj1U6n3ZWwAgABJMwCAANkqgIAAFw4AgAASXQCAACxXAIAAIWYAgAAMc4CAABNrgIAAnGiAgAAx5QCAABY0AIAAGuoAgAATBoCAACZrgIABvk+AgAAcKYCAACOYEIAABOtA
Date:   Fri, 18 Dec 2020 05:36:48 +0000
Message-ID: <BY5PR12MB4322E1121673E1DDB0C5B2C4DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
 <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
 <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a544b86c-96d2-4ef6-fe33-08d8a316ea6a
x-ms-traffictypediagnostic: BYAPR12MB4742:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB47426A73B8D1ED6574F4E324DCC30@BYAPR12MB4742.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bVZ5dc9zY7VrhoZHtYTNgbJTghFGUW7Mc73Xl7fNtup5vPSD/Q03LRC1O+RkI+KTWY8s0Z06JpXWelx/aMMLdkDTS0jP0lMTIHu40y6elFwr/BLIaOH7efd17QW7nu+28VpzZSgG3C7J+C43QR8vfZlXm0dr3/aXGbxC79pN3A0VXF9UiIiOeugayMHCUvOiKJcN3btLLFqtn+u75ybAJOwWTj+gAsWnwBsw5/gzkQh9PshLZiRwOtA4S9MVeB/T2VBkco4JAD7T14Sq9aLZOWFIdKMqRL/PF10RK1DrDOWRWN5l54Xm+4RcvdsXkUafkMgKkxV4c2B+IBbIew+Blg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(9686003)(86362001)(55236004)(76116006)(5660300002)(33656002)(26005)(66946007)(7416002)(2940100002)(66476007)(66446008)(186003)(54906003)(4326008)(66556008)(2906002)(7696005)(55016002)(110136005)(8936002)(53546011)(71200400001)(8676002)(64756008)(316002)(6506007)(52536014)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dlJ5cFVUcVJ2ZTgzZXpJRTJkcldyRGo2aWsxQ0pxN09Dc2hWb0ZDaGZBME11?=
 =?utf-8?B?VkdpWHpmMU51UTBSa0haaUJxYndQSUxnTlEwalhIekdlV0tneklRSTdjY3lZ?=
 =?utf-8?B?VmpvdDRwb2JkazdXMHA0aytVbDA5UHltcnBwdGFpSDdLenoxd2JZNWpjMUV3?=
 =?utf-8?B?RmxQWjFGaWwwamRHUHZLUXRUUEgzSURFVkJoa29PNEROZEpFNzFlT20yODNm?=
 =?utf-8?B?d3E1YkMxcnVjTnpMQ2pRSHhCS0N4SVNFRFlxdzVaU3MvelJPc1NLUWQ3NGQ4?=
 =?utf-8?B?T1NPWi83b0llSGlEWHIxVlJncmdFS00vUzhPcHNLWXNIUzZXNlVqZStHL2VR?=
 =?utf-8?B?OWs5MXc3QkhwSkRGSm1oeE12ZXhWcHpCdXBWM2E4SS9MK0poMU80ZnEyaFlE?=
 =?utf-8?B?S0lEN3VMU2xvZStmRGFTV3VzQVZTYnVFdHZXOUFObTl5V2dSUVBtWkxYV29p?=
 =?utf-8?B?Qnp5T0x2enROTUlxZ1preVhabmd5OFlsUzNmUDhZSmF1MmNvTHhlYjl2bmJu?=
 =?utf-8?B?d0NDcUdxMlVXQWNpRElOVGRRTW1rNXZYbDd2REFYbGNsd1NYZnJqU2FRVzlh?=
 =?utf-8?B?c2VSNTNQNzVka2VrWnVCbDBBMTNLYVRZLzAvczJHZ1lNNXhvUnBvdzN6WUMw?=
 =?utf-8?B?a0hoQ2lGZ3BiSUd1K3dnWkNHd1pYSmVhWU9JM0FSUEFSWmFTOStOVk1BYU1K?=
 =?utf-8?B?ZW5vakFEbUtyd1JGMDBFMWhsZWVQRXlHczlFbGxSL3lHLzBRbnhLVzk4aHVG?=
 =?utf-8?B?M3FtbGhmM0JOdHdtZkc4OUwxMjhIUHRtRVpFR2liWFJFUTZVaGhXejRRekNK?=
 =?utf-8?B?dTBGWlU3U2FGMnZWZWVwTWtnWjVkRmpGQ0hTVmk5WUxjcEhqRFo5VDFlSlpI?=
 =?utf-8?B?WFhlbm1YdDljV0o5d3BvTGxOWHgvWGFaZ0JBSW9sRXZjMmRYNHVKZ3BGN2dv?=
 =?utf-8?B?bnNwTEo5UXhQMGo2WFJoQ0R6YURsNzBiNXI4b3piNHJYWXU0UWNOWnZ0WW01?=
 =?utf-8?B?NUhpeDhibjFiUXcyMzFmd2RUWTFyREJsSklUZ2VTU3lRQ0dSODBtMHI1bXc5?=
 =?utf-8?B?enp6MGpHZnZ5MGkyOEpGeXZqNks4T3J0d3ltbXQxZ0Rzc3ZUWXN5cTFhR3Zj?=
 =?utf-8?B?RHhsaUYwQ0c4S3g0dm9FZlFnblpYMlAzYWhLYnFMTW12ZHFxVW9mQ0FTZWdE?=
 =?utf-8?B?K1IwZDJscjlMQkJpK2NDMnBQR1ZRRjFpa2ExYnU1d0w5aHF2eDEweEM0Q2th?=
 =?utf-8?B?SUkrREdReng0TkR4UEQzNUJPdmdRRmtQNnBuY0QrdDliek5yTmdmTHRTd1VM?=
 =?utf-8?Q?l+kkJufDRoHIE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a544b86c-96d2-4ef6-fe33-08d8a316ea6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 05:36:48.8860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 84hZ7yz0Goh7eAVjmltABf/BhTRL3dmKlCBXUNNC/LudvjIA3S/lIwLGFAj07TUlr6h2X7lUUJppg7mQQjiDBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4742
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608269816; bh=LWHQ9/A25JflZWDbLIVX1NgT1kdn8NcENGcUb0AMxik=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Jh6f0WfOggjF/Pb9zw+0d70UR84VJS6LXWH4zh132wvP4H9R4xhk2/iMbtuABgomo
         Muiwv/St91Cqn8nLPEGkwpOKvGScmp6bQXl94N/mT2AGGzopeQrFa0+PZrHdrDVutF
         HxNtACONnuJGevZkAIH2KFK408g6lIA4J+Ocb/B8RkEOKNTP5lqhA3M6WNZbLaU8XG
         +plrH/8g/m1qAa0fJhH3cYWpSk11ZT/iXYt3zb5RstNm/FNEPlpFnaX07qG5qHRvcN
         NifVSy3qMU4qvjxGzMW0qF6x9eQYOTvMvYg1NGnAciT2REcfFSV2n1jH+Msgq47bfZ
         62aq1TYqCa3sw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29tPg0KPiBTZW50OiBGcmlk
YXksIERlY2VtYmVyIDE4LCAyMDIwIDEwOjUxIEFNDQo+IA0KPiA+IEZyb206IEFsZXhhbmRlciBE
dXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4gPiBTZW50OiBGcmlkYXksIERlY2Vt
YmVyIDE4LCAyMDIwIDg6NDEgQU0NCj4gPg0KPiA+IE9uIFRodSwgRGVjIDE3LCAyMDIwIGF0IDU6
MzAgUE0gRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4g
PiBPbiAxMi8xNi8yMCAzOjUzIFBNLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6DQo+ID4gVGhlIHBy
b2JsZW0gaXMgUENJZSBETUEgd2Fzbid0IGRlc2lnbmVkIHRvIGZ1bmN0aW9uIGFzIGEgbmV0d29y
aw0KPiA+IHN3aXRjaCBmYWJyaWMgYW5kIHdoZW4gd2Ugc3RhcnQgdGFsa2luZyBhYm91dCBhIDQw
MEdiIE5JQyB0cnlpbmcgdG8NCj4gPiBoYW5kbGUgb3ZlciAyNTYgc3ViZnVuY3Rpb25zIGl0IHdp
bGwgcXVpY2tseSByZWR1Y2UgdGhlDQo+ID4gcmVjZWl2ZS90cmFuc21pdCB0aHJvdWdocHV0IHRv
IGdpZ2FiaXQgb3IgbGVzcyBzcGVlZHMgd2hlbiBlbmNvdW50ZXJpbmcNCj4gaGFyZHdhcmUgbXVs
dGljYXN0L2Jyb2FkY2FzdCByZXBsaWNhdGlvbi4NCj4gPiBXaXRoIDI1NiBzdWJmdW5jdGlvbnMg
YSBzaW1wbGUgNjBCIEFSUCBjb3VsZCBjb25zdW1lIG1vcmUgdGhhbiAxOUtCIG9mDQo+ID4gUENJ
ZSBiYW5kd2lkdGggZHVlIHRvIHRoZSBwYWNrZXQgaGF2aW5nIHRvIGJlIGR1cGxpY2F0ZWQgc28g
bWFueQ0KPiA+IHRpbWVzLiBJbiBteSBtaW5kIGl0IHNob3VsZCBiZSBzaW1wbGVyIHRvIHNpbXBs
eSBjbG9uZSBhIHNpbmdsZSBza2INCj4gPiAyNTYgdGltZXMsIGZvcndhcmQgdGhhdCB0byB0aGUg
c3dpdGNoZGV2IHBvcnRzLCBhbmQgaGF2ZSB0aGVtIHBlcmZvcm0NCj4gPiBhIGJ5cGFzcyAoaWYg
YXZhaWxhYmxlKSB0byBkZWxpdmVyIGl0IHRvIHRoZSBzdWJmdW5jdGlvbnMuIFRoYXQncyB3aHkN
Cj4gPiBJIHdhcyB0aGlua2luZyBpdCBtaWdodCBiZSBhIGdvb2QgdGltZSB0byBsb29rIGF0IGFk
ZHJlc3NpbmcgaXQuDQo+IExpbnV4IHRjIGZyYW1ld29yayBpcyByaWNoIHRvIGFkZHJlc3MgdGhp
cyBhbmQgYWxyZWFkeSB1c2VkIGJ5IG9wZW52c3dpY2ggZm9yDQo+IHllYXJzIG5vdy4NCj4gVG9k
YXkgYXJwIGJyb2FkY2FzdHMgYXJlIG5vdCBvZmZsb2FkZWQuIFRoZXkgZ28gdGhyb3VnaCBzb2Z0
d2FyZSBwYXRjaCBhbmQNCnMvcGF0Y2gvcGF0aA0KDQo+IHJlcGxpY2F0ZWQgaW4gdGhlIEwyIGRv
bWFpbi4NCj4gSXQgaXMgYSBzb2x2ZWQgcHJvYmxlbSBmb3IgbWFueSB5ZWFycyBub3cuDQo=
