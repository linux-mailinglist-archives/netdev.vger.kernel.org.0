Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285392A882E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgKEUhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:37:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9000 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732120AbgKEUhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:37:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa4627e0000>; Thu, 05 Nov 2020 12:37:18 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:37:17 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 5 Nov 2020 20:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbeCQbLvSZbdmn1vo5oYNlYpto8Pl7ldHjvvuGBUw2i/yTZvFvJSdTq9q8tddgwK8rjYrnnP0WPIsGOTng20AeK/CB6znirqzzYtwWoRZkM5Kp0xKHcdMvHCfdz181lRNMC33lleiHIpUEIwx2pIMpS9Nl++vXvDhzB/TEOpaGrz5C45jKveFWZBS7NHWDdse7bs85huY2WIdozhrMY5XJIgYk9fZyQizpcMr6KHR/VJxhG18KwGjkDbzcIHXNsG/re6Dg/Hsd+eZzWc1ZeWQuv0xV4h4VWSbHcdNiazmG0eZOpgbm7yT8W2AHFAQtiweSR27GY9n83VGOm+F0xjWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD/GFIG2r5QISvQem2rHibPZXj/UX6eMMFewuOQ77ik=;
 b=h+vOFQfFl79rywnYn5NIm9V/gaIYAUTAo91TLTTPBnIaQuGfpsc7ArNmriab40qq+kulKEWs3Wf2r1l8CtetxDdaOYcyM5lbmEFsHZBarrTaB2lqRCLP/6GZHro2IkVLViaqDobOO9GHiDbQWF7HEeQdSWYoJqiqZwFbB8JjZvbJjIDHQTW+2kr04NiJm0R7ATuDn6hSaw2Jlk2Aby+JSEAuD94oD3PSY7yK6kwYPAO1OoYOJ7CDRWtdkgOTpA7f1GHC6/Osd06rrxNx06ykASIKRZyufbbvb85OCUpfQ33H9AgaYVowzM8Tv9SdTbU2Xz81tA34M66W1T5hTmrzAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3810.namprd12.prod.outlook.com (2603:10b6:a03:1a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Thu, 5 Nov
 2020 20:37:14 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 20:37:14 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: RE: [PATCH v3 01/10] Add auxiliary bus support
Thread-Topic: [PATCH v3 01/10] Add auxiliary bus support
Thread-Index: AQHWqNRzAuOUFv+0MUGnf97WP/Ijmam5V8WAgACqGACAAAJYUIAADeQAgAABDDA=
Date:   Thu, 5 Nov 2020 20:37:14 +0000
Message-ID: <BY5PR12MB43222D59CCCFCF368C357098DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <BY5PR12MB43228923300FDE8B087DC4E9DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAPcyv4h1LH+ojRGqvh_R6mfuBbsibGa8DNMG5M1sN5G1BgwiHw@mail.gmail.com>
In-Reply-To: <CAPcyv4h1LH+ojRGqvh_R6mfuBbsibGa8DNMG5M1sN5G1BgwiHw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.17]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04a481c0-2f4b-4ea7-6cce-08d881ca9495
x-ms-traffictypediagnostic: BY5PR12MB3810:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB381065F5F3CB262AC5C7B41FDCEE0@BY5PR12MB3810.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NMWrovufe2X0lcZSb3LJr4xn16IVI2gtOV6MKNNTgAJ9WqJfFHZ6McaJ889vnbrRaoSFbELGDgf1X7K2Va+ihVnGBVuC9H/ZoKuFNHQ7YdC+9WFmCpuaLwXzzIi9YdGny7efMopdhlTPCJyYIr1PIWvriUaDKwEXHIl63aQnhCLYDVc3vBEPraHTND1Z43wf20z4D8ob+k9IWn5UZU10rw2Nze+PLoRDukbOJqOBgu23VHvFyHCi0/KgVgb4Jz4e0QvrmPYSVRU5n1ZFwz3Y8ZdZ8JwMDWvrbp1znDT0rlzXU0MNsqfL1l8TL9bcHWtCGRdkAXDZq+wC1WTYBr9LBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(76116006)(26005)(186003)(6916009)(86362001)(2906002)(5660300002)(66476007)(64756008)(55016002)(66556008)(66446008)(66946007)(478600001)(7416002)(6506007)(7696005)(8676002)(8936002)(55236004)(4326008)(83380400001)(33656002)(71200400001)(9686003)(54906003)(53546011)(52536014)(316002)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CCHqfMpM3NFt1ZnEy1vZDrSjEI3RN8GhkhkZZuRLp03F7mMkds29L0+uvfbhtSIVe85Ve1aoJNZVIS/SDLHP5p/oc0bC1UkyptFgbbkn3+TME7V672h78GvqwNQ6vdHYwQuBIJTxf3tTHh5uCnrmUttH0awvR3yPJbbjltqDW2zlO/8yfdc1cmhmK0g3rnpdQ7EHyV0lay80WWzOGI2hMI05714qtWw8dzbZqq2uyc4iPAMZOLLvpOb+ghRT9oEbcyi4vVYvkDFXlCcGFJ1XQ90LOJ1D3elOk5M2LWh7qga1qkxcBScNYi+g4DMp6pTrJp4KeoTZvYZ2nzTpmKzowi5ODx7ywweyNQcE7xHc8Lm6T/nKgJG6xohT8O4Yz6nSn9ZEfA5feVb0ntIMkQe4wEMBWXNp8xSnUM8wFcSMAETBGnwVoKr08vpxD7Xouj2q//9n2MhrbMbgqq2zS4ONPnLHsKe2Bt82rMHB5n8s7ZYRBOuOsC8NCc4StdEsUuzBDr3qAeDCIfnIfFR9r4W+JwmsslzgQCEb6W0WofNIEgXU8z9WqAv8DVejJ13lD+5CxzIhxqE4eiOZnkFcSPad6P78KYEoM3ckCSf6rDOYWpSLIinGeW1kXVb+U6gI4T2rak7Qfc+eBPzCSvLyqgbd7g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a481c0-2f4b-4ea7-6cce-08d881ca9495
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 20:37:14.8166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UFKfaRZH+JwbBO3oHn8SD72ENXu04F4O0/bo/EV0SWMDEVszRt4CD8VSX+JBsTN7TsAvpPeYYhJagXdEwsIUIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3810
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604608638; bh=xD/GFIG2r5QISvQem2rHibPZXj/UX6eMMFewuOQ77ik=;
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
        b=Q0p8P89lcN7gTOrwNKNpTe9Nd2Xj99LQWSHaHQwxNRhlDqrmZ9iwzCjt/CC5NogQo
         HnEKBCt4Zo2BBAhxubmQS5Wda1hxYzlsbuDKSqELpb3TatqbPOK1Du4aIZIAE9MRBb
         yt6C2fToCnb1UgLxaVBQhMDcyRhvZOqq53xbCzzqPWfn9V1qTGcuD0oaDJkHhUNyKp
         b8Ib1H3YmJGFJC2dEDFBPuusLWDJoYb1ZMYJwHlS8KhA1d63HpjQcEd3zGqwpYVHcw
         7c0Hut1X7pEga11GAG8lYZWVsCks8NjWJV8Kb65C4FvYWPF0x3roX+ImC7/Upa3Wlz
         OB1986+AkQ/fQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IFNl
bnQ6IEZyaWRheSwgTm92ZW1iZXIgNiwgMjAyMCAxOjU2IEFNDQo+IA0KPiBPbiBUaHUsIE5vdiA1
LCAyMDIwIGF0IDExOjQwIEFNIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiBGcm9tOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0
bWFuQGludGVsLmNvbT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgNiwgMjAyMCAxMjo1
OCBBTQ0KPiA+ID4gU3ViamVjdDogUkU6IFtQQVRDSCB2MyAwMS8xMF0gQWRkIGF1eGlsaWFyeSBi
dXMgc3VwcG9ydA0KPiA+ID4NCj4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiA+ID4gRnJvbTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4g
PiA+IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciA1LCAyMDIwIDE6MTkgQU0NCj4gPiA+ID4NCj4g
Pg0KPiA+IFsuLl0NCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gK0Fub3RoZXIgdXNlIGNhc2UgaXMg
Zm9yIHRoZSBQQ0kgZGV2aWNlIHRvIGJlIHNwbGl0IG91dCBpbnRvDQo+ID4gPiA+ID4gK211bHRp
cGxlIHN1YiBmdW5jdGlvbnMuICBGb3IgZWFjaCBzdWIgZnVuY3Rpb24gYW4NCj4gPiA+ID4gPiAr
YXV4aWxpYXJ5X2RldmljZSB3aWxsIGJlIGNyZWF0ZWQuICBBIFBDSSBzdWIgZnVuY3Rpb24gZHJp
dmVyDQo+ID4gPiA+ID4gK3dpbGwgYmluZCB0byBzdWNoIGRldmljZXMgdGhhdCB3aWxsIGNyZWF0
ZSBpdHMgb3duIG9uZSBvciBtb3JlDQo+ID4gPiA+ID4gK2NsYXNzIGRldmljZXMuICBBIFBDSSBz
dWIgZnVuY3Rpb24gYXV4aWxpYXJ5IGRldmljZSB3aWxsIGxpa2VseQ0KPiA+ID4gPiA+ICtiZSBj
b250YWluZWQgaW4gYSBzdHJ1Y3Qgd2l0aCBhZGRpdGlvbmFsIGF0dHJpYnV0ZXMgc3VjaCBhcw0K
PiA+ID4gPiA+ICt1c2VyIGRlZmluZWQgc3ViIGZ1bmN0aW9uIG51bWJlciBhbmQgb3B0aW9uYWwg
YXR0cmlidXRlcyBzdWNoDQo+ID4gPiA+ID4gK2FzIHJlc291cmNlcyBhbmQgYSBsaW5rIHRvDQo+
ID4gPiA+IHRoZQ0KPiA+ID4gPiA+ICtwYXJlbnQgZGV2aWNlLiAgVGhlc2UgYXR0cmlidXRlcyBj
b3VsZCBiZSB1c2VkIGJ5IHN5c3RlbWQvdWRldjsNCj4gPiA+ID4gPiArYW5kDQo+ID4gPiA+IGhl
bmNlIHNob3VsZA0KPiA+ID4gPiA+ICtiZSBpbml0aWFsaXplZCBiZWZvcmUgYSBkcml2ZXIgYmlu
ZHMgdG8gYW4gYXV4aWxpYXJ5X2RldmljZS4NCj4gPiA+ID4NCj4gPiA+ID4gVGhpcyBkb2VzIG5v
dCByZWFkIGxpa2UgYW4gZXhwbGljaXQgZXhhbXBsZSBsaWtlIHRoZSBwcmV2aW91cyAyLg0KPiA+
ID4gPiBEaWQgeW91IGhhdmUgc29tZXRoaW5nIHNwZWNpZmljIGluIG1pbmQ/DQo+ID4gPiA+DQo+
ID4gPg0KPiA+ID4gVGhpcyB3YXMgYWRkZWQgYnkgcmVxdWVzdCBvZiBQYXJhdi4NCj4gPiA+DQo+
ID4gVGhpcyBleGFtcGxlIGRlc2NyaWJlcyB0aGUgbWx4NSBQQ0kgc3ViZnVuY3Rpb24gdXNlIGNh
c2UuDQo+ID4gSSBkaWRuJ3QgZm9sbG93IHlvdXIgcXVlc3Rpb24gYWJvdXQgJ2V4cGxpY2l0IGV4
YW1wbGUnLg0KPiA+IFdoYXQgcGFydCBpcyBtaXNzaW5nIHRvIGlkZW50aWZ5IGl0IGFzIGV4cGxp
Y2l0IGV4YW1wbGU/DQo+IA0KPiBTcGVjaWZpY2FsbHkgbGlzdGluZyAibWx4NSIgc28gaWYgc29t
ZW9uZSByZWFkaW5nIHRoaXMgZG9jdW1lbnQgdGhpbmtzIHRvDQo+IHRoZW1zZWx2ZXMgImhleSBt
bHg1IHNvdW5kcyBsaWtlIG15IHVzZSBjYXNlIiB0aGV5IGNhbiBnbyBncmVwIGZvciB0aGF0Lg0K
QWgsIEkgc2VlLg0KIm1seDUiIGlzIG5vdCBsaXN0ZWQgZXhwbGljaXRseSwgYmVjYXVzZSBpdCBp
cyBub3QgaW5jbHVkZWQgaW4gdGhpcyBwYXRjaHNldC4NCkluIHZhcmlvdXMgcHJldmlvdXMgZGlz
Y3Vzc2lvbnMgaW4gdGhpcyB0aHJlYWQsIG1seDUgc3ViZnVuY3Rpb24gdXNlIGNhc2UgaXMgZGVz
Y3JpYmVkIHRoYXQganVzdGlmaWVzIHRoZSBleGlzdGVuY2Ugb2YgdGhlIGJ1cy4NCkkgd2lsbCBi
ZSBoYXBweSB0byB1cGRhdGUgdGhpcyBkb2N1bWVudGF0aW9uIG9uY2UgbWx4NSBzdWJmdW5jdGlv
biB3aWxsIGJlIHBhcnQgb2Yga2VybmVsIHNvIHRoYXQgZ3JlcCBhY3R1YWxseSBzaG93cyB2YWxp
ZCBvdXRwdXQuDQood2FpdGluZyB0byBwb3N0IHRoZW0gYXMgaXQgdXNlcyBhdXhpbGlhcnkgYnVz
IDotKSkuDQo=
