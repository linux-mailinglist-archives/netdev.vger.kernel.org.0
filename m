Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CFB287B14
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgJHRfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:35:15 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:38114 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgJHRfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 13:35:15 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7f4dcf0002>; Fri, 09 Oct 2020 01:35:11 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 17:35:07 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 17:35:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgqNJ68M35LXgxpVdoiWuoWA8hraHFojouyWtJcdJAP2VMv6gKRBom2Sn1ulLzz3ftIX3Ztjb6NUyxoYDg4tDg8qiuO63yI3Bued7/+mPHeRtRiXOXLbqCYud81/Ksb50Tgnei8LyezJhkgIO1NTaGzax5+LgJwYXjkcu0ZOIy5dhOW2blFvT1Vtg30GIFvXFHUY/Ev4A0hnD/41CJsIrLCm7YTijqbS66wi3NKbQNVQlmQqUu0B/aPtDyxGRBXYC0fXU4Gg3jnzpxSj4fTz+gzR0uB3CONor5PND/WI4fzcbcIdZn5iZBfsUob5bY3EHsXY4wXiGtIcpR6ixYSJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/XYNbGXdUedIdhFtfG4Yy4sPas7KYERmhPGXWwA68g=;
 b=lF5tlVpz62xI8xh+U4drXPje/5/pQ+4DTcmaqf8I2OTxUbshMsyQPqhznT48Fvb0NCZdnL+PH0NzfpxkQ2luPTYAwnsltn89eGbHHUgSWzzLVpV3TON3rAAJufLm6z3lKX5l5AGV8XEQhtjnBJrbmcLiWjd4pgMvSqTcXAiG4UsKfLZQvA+3EU3rXxIg9qIK8z9nuGyhNC+uGkKcru727O5NGJyR3YBhoK2nCQAqLLzCgibvrSb215/03oqkI9qJYg8MiIwEfhglyF4t2rJY8CJHDJKP+vzGirBpBfhoosFc6+7c9JzSZrAwNlfuZYM9KirvaLaJZFkVHC8aRThU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4324.namprd12.prod.outlook.com (2603:10b6:a03:209::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 17:35:05 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 17:35:05 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Ertman, David M" <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm05cPW7H51WMukmCocLPE63Nf6mKKyGAgACGC4CAAB03gIABpCoAgAAWQgCAAAuCMIAACwKAgAADjQCAAAZvgIAAB6yAgABvlmCAANAogIAACvlQ
Date:   Thu, 8 Oct 2020 17:35:04 +0000
Message-ID: <BY5PR12MB43223FE33A906FF4AA0C46A4DC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB284193A69F553272DA501C52DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB284193A69F553272DA501C52DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dda4c55-a0b2-4063-4175-08d86bb07e58
x-ms-traffictypediagnostic: BY5PR12MB4324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB43241FE037524E9F393976CDDC0B0@BY5PR12MB4324.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ElJTLTHc2AuEGhfPs98TUNY0P5Rtx+ejQb+QLzTV8Pt9mM6ZsF40mrZjRrGYjH7rDSjeniepozgJspkYsoNAJBPXmcd54MYmNAr6codhRjfWqs+SeGH/0+Q7RDIgbNrLkXfdlOmwshln+SanFi4Euxa7p4S4BJNp+XmAjGepUu7chCkZ4i3TE0z9ePx6j0r7a91aekXhxVQMt8qYOsyS8LUweIiYzZz2eHI7mZWk5883n2rZLaWW5PjyMgmAFk3FmTNgvHuzjxQ/Qpfv5FUxuv+rzd31An7Ak3WJcuw6x1SDVCrsld7RnnGayQTkbpUgScaREaxHjhWzBYNx1eh/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(5660300002)(71200400001)(4326008)(52536014)(66446008)(66946007)(66476007)(76116006)(64756008)(55016002)(7416002)(66556008)(9686003)(8676002)(110136005)(33656002)(26005)(2906002)(316002)(6506007)(55236004)(86362001)(478600001)(186003)(8936002)(83380400001)(7696005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jPE9hJI25NMyOdG7ZNOm1KKee5mFnXO7szBis5H+Kl23fY7WZRejtbEunJyEyOP4HVnHHRJt/xBySKaWd7AaI72xl/pFp+6pkOm8giejDFgoXwGZ2PC9YFanDxKb2HZd3fLZFxG50462t2xJKNAoQXZhgvqg2EngsSmOmDK9Z4yq75ne7g9yrmUUMFb4t/glU9DeePe4l5k/HQ93uQDsPFgNorB0UaDF3zUN4lBDTdZVan/lYunDukzQ0pQzAhA6K1aJqxefbE9/1cTcl8acuYSKJLsDaDqcfd5s9wcV0mb3PCQ5L9vYHwVLO9LXc69GSIKqcPop58nPQvIRdBuRJFaV0ABFHGiw/Wz95LYTh0TJM+zoHn1qAVlnIZdEO238XDz9sePxIXpd5TNPPR/ceK6D1h6QFVx4NTGCJtMO0XFCvaQGpzgff0TTMxXqXy/O2lh4hU0Dkl/+GR0paM7KOm+yNKhvUfs28n1YPP552oO3jSN1HcnSv+hHb6ycRiZEmtLlKJ0jVT+jnJ6jnSyzGigrtZoukL+YfHEj9o66ZEuUrWc04z6dkxYsP+YFLKJDg0HLtwy1JCjLIHR60Z68aZmjfI7odO6H5GwsIbQqfqXkEU1aQEFqpswnZZpcH/tgyLlxWnIjRpYwgLBNfGWz6g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dda4c55-a0b2-4063-4175-08d86bb07e58
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 17:35:04.9799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aAQbfw+psQEcUYQEYYCpy2y5c7ApTT+cBEdhCjr6Il66AjNHJUMGJsysskNODdSygiwFiJAuefnsGKGVG/0vog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4324
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602178511; bh=p/XYNbGXdUedIdhFtfG4Yy4sPas7KYERmhPGXWwA68g=;
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
        b=rnnGNNzr35uJKRhPyGmOlDZuqJFKuffGSfsJaxQeXYIEL+bF79WoY/eBqbwePXPF4
         Qyio2/hyYq03s5+r+Auiu2dBdzL4E98mtNQR4QYH1OqNyUx3NcAFqRObyFeY/rJ7Mu
         rdY0SVgle/eZFHpBzQ8fsL5NAX00J9mgPoHNoF0ml5U+t52CgimARLooATtgfuhxFk
         GvHrbzRGGU3HvyfxYikA1rYZDyVgkgwdI5KCBXGT8hnncxWZkV/k7c5H7Hu8Ob/MyQ
         TPxR8xhxbNnl/2blOBVQTgVyKu/5mVIe7Rj6AIhCIAOzR7ZJdviuqpCOSUcs3dR2T5
         UPMwtAfAr+ClA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDgsIDIwMjAgMTA6MjQgUE0NCg0KPiA+IEZyb206IFBh
cmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4NCj4gPiBTZW50OiBXZWRuZXNkYXksIE9jdG9i
ZXIgNywgMjAyMCA5OjU2IFBNDQoNCg0KPiA+IC8qKg0KPiA+ICAqIGFuY2lsbGFyX2RldmljZV9y
ZWdpc3RlcigpIC0gcmVnaXN0ZXIgYW4gYW5jaWxsYXJ5IGRldmljZQ0KPiA+ICAqIE5PVEU6IF9f
bmV2ZXIgZGlyZWN0bHkgZnJlZSBAYWRldiBhZnRlciBjYWxsaW5nIHRoaXMgZnVuY3Rpb24sIGV2
ZW4NCj4gPiBpZiBpdCByZXR1cm5lZA0KPiA+ICAqIGFuIGVycm9yLiBBbHdheXMgdXNlIGFuY2ls
bGFyeV9kZXZpY2VfcHV0KCkgdG8gZ2l2ZSB1cCB0aGUNCj4gPiByZWZlcmVuY2UgaW5pdGlhbGl6
ZWQgYnkgdGhpcyBmdW5jdGlvbi4NCj4gPiAgKiBUaGlzIG5vdGUgbWF0Y2hlcyB3aXRoIHRoZSBj
b3JlIGFuZCBjYWxsZXIga25vd3MgZXhhY3RseSB3aGF0IHRvIGJlDQo+IGRvbmUuDQo+ID4gICov
DQo+ID4gYW5jaWxsYXJ5X2RldmljZV9yZWdpc3RlcigpDQo+ID4gew0KPiA+IAlkZXZpY2VfaW5p
dGlhbGl6ZSgmYWRldi0+ZGV2KTsNCj4gPiAJaWYgKCFkZXYtPnBhcmVudCB8fCAhYWRldi0+bmFt
ZSkNCj4gPiAJCXJldHVybiAtRUlOVkFMOw0KPiA+IAlpZiAoIWRldi0+cmVsZWFzZSAmJiAhKGRl
di0+dHlwZSAmJiBkZXYtPnR5cGUtPnJlbGVhc2UpKSB7DQo+ID4gCQkvKiBjb3JlIGlzIGFscmVh
ZHkgY2FwYWJsZSBhbmQgdGhyb3dzIHRoZSB3YXJuaW5nIHdoZW4NCj4gcmVsZWFzZQ0KPiA+IGNh
bGxiYWNrIGlzIG5vdCBzZXQuDQo+ID4gCQkgKiBJdCBpcyBkb25lIGF0IGRyaXZlcnMvYmFzZS9j
b3JlLmM6MTc5OC4NCj4gPiAJCSAqIEZvciBOVUxMIHJlbGVhc2UgaXQgc2F5cywgImRvZXMgbm90
IGhhdmUgYSByZWxlYXNlKCkNCj4gZnVuY3Rpb24sIGl0DQo+ID4gaXMgYnJva2VuIGFuZCBtdXN0
IGJlIGZpeGVkIg0KPiA+IAkJICovDQo+ID4gCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAJfQ0KPiBU
aGF0IGNvZGUgaXMgaW4gZGV2aWNlX3JlbGVhc2UoKS4gIEJlY2F1c2Ugb2YgdGhpcyBjaGVjayB3
ZSB3aWxsIG5ldmVyIGhpdCB0aGF0DQo+IGNvZGUuDQo+IA0KPiBXZSBlaXRoZXIgbmVlZCB0byBs
ZWF2ZSB0aGUgZXJyb3IgbWVzc2FnZSBoZXJlLCBvciBpZiB3ZSBhcmUgZ29pbmcgdG8gcmVseSBv
bg0KPiB0aGUgY29yZSB0byBmaW5kIHRoaXMgY29uZGl0aW9uIGF0IHRoZSBlbmQgb2YgdGhlIHBy
b2Nlc3MsIHRoZW4gd2UgbmVlZCB0bw0KPiBjb21wbGV0ZWx5IHJlbW92ZSB0aGlzIGNoZWNrIGZy
b20gdGhlIHJlZ2lzdHJhdGlvbiBmbG93Lg0KPiANClllcy4gU2luY2UgdGhlIGNvcmUgaXMgY2hl
Y2tpbmcgaXQsIGFuY2lsbGFyeSBidXMgZG9lc24ndCBuZWVkIHRvIGNoZWNrIGhlcmUgYW5kIHJl
bGVhc2UgY2FsbGJhY2sgY2hlY2sgY2FuIGJlIHJlbW92ZWQuDQoNCj4gLURhdmVFDQo=
