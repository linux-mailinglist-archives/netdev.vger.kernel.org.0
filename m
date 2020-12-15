Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923722DA7DB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 06:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLOFtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 00:49:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3751 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLOFtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 00:49:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd84e300000>; Mon, 14 Dec 2020 21:48:32 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Dec
 2020 05:48:27 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Dec 2020 05:48:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGnwKKkOEfMzHSy39mXVcT+cXSXw/5FgJeSHb6/UJ0qMkDRHaUwjvP5dTveL49PDvH5qYWhbjmTN8cL20PaNK1LimfCId7LeKRjK/nXowlKEYS1U1d46ZbBhpPL8Zzt/42QcMDHFBI4pd2xmBYZl7pksoEGW+FcazGao1dxKoF3S91P5G8jHCYE6vA+LsD5ZAzcq3nPGt5VPB9hsLaq+7/fDJ7Gnw2PVrZklukmWe6lBLUz1XQJcmjU5YGcj57VOxox6iuLUB4tn33fD2g3s2p5brez1E6jYTouU4dXganUMo0b776F4I4r5mlQoSDSyi6y/W/sHW2B3ENhz6lwQvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DJHDD6VtSW8ieelv1on1eouTb9tL5M+410AHK5cz9s=;
 b=VfMh1zmpZkc8PITSBhv+ZU6o0LXPTaOj65mqPYaVCC9LoCOZNr4er2fghrcuCNwGPKaNH7wNmbw3BtQBUi84r5msJYbiS91sHpqaMhY7ydygzRSKSleBlKJ+vpSia17B5cPj9iZz+hvoqCjGS+a2qW9q0XCgN9dnJnf1ub2UZJzVXzueMsrOVBghcMknWzt3xyBenF8mqwBTK9O+M/lGLzjY81R2crisixW2lwiGiLkcVrSq16zNLdC/5k6VDXyfykddSVaIzEmCi+sp9YvMdIqMKbRVNJmvjv3SUaNplWQfC7mX073miEN45MNZeBpM99AU42wV5m5o6IohK+CyXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3030.namprd12.prod.outlook.com (2603:10b6:a03:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Tue, 15 Dec
 2020 05:48:25 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.032; Tue, 15 Dec 2020
 05:48:25 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Topic: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Index: AQHW0mKFU48o8ZNlzEyGRue6Xkj1U6n3ZWwAgAAua7A=
Date:   Tue, 15 Dec 2020 05:48:25 +0000
Message-ID: <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
In-Reply-To: <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 052564ef-b8bf-44be-cc4d-08d8a0bd0a4f
x-ms-traffictypediagnostic: BYAPR12MB3030:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3030830C9EB278CAC69A2A7BDCC60@BYAPR12MB3030.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gMKAEXhvzhNNftH9/bNpBWVmNWBpiHDPWhEhp3efx+FyJb2u/EDeheqmqfc4xv28MbCvNvyJWwrkRELa3kS+ky0NLFMlWm9oA4pxa3Xl6cQXSDKX3sr2NyKrgPLmbVtbwrw6Fpbto8Mj5dNIPBmaIE74w5ehqbMHm61V8BHsufIGNIhkNXUuZSHH61wMpxNXBLQEu2UyKsA/C6yyv8jDIWfOIXyhYdU4981Di/cZebXn8DYeKS55azKL9++KZ0VbXVI+6bIUt7eUB9FcGC2NwmEgkClzHS6xVb4gAwSs5xxGTf4UBvj6nH2rGgcnIoYz9qjPpiyjOAafgD2Kdmro6k2rGb4K+wDY7oUW9KpnPEc3tdv1pakmaEZtgSjUw3Tx5U54fq6UnFYz2wjKsvusrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(966005)(508600001)(26005)(76116006)(2906002)(8936002)(83380400001)(45080400002)(53546011)(71200400001)(55236004)(7696005)(6506007)(110136005)(54906003)(8676002)(52536014)(66476007)(5660300002)(64756008)(66556008)(66446008)(86362001)(4326008)(186003)(7416002)(33656002)(9686003)(66946007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eEZKWG12eGJBL3Jiak9GdXFsaVlZTFlNVzhVT1ZMV0V1WlVMU1hDWG1tVlVm?=
 =?utf-8?B?bHlyc3hGaXo5c2Y3V09mLzlydGVVL1ZDWnlKY0xZSW9TN1ZOb2FMZGhDU3dy?=
 =?utf-8?B?cHVwRy9MOS82Tlh5YUlnRHgyU0d3cVRQcTcrK3ZkOStpM29PNkhOcDN2U20y?=
 =?utf-8?B?NEhyd0Vtd2NWRWwzSmpyK3pGUDRzYmZaenpkTXczd1hDbkJjTHZ1UmREdGhq?=
 =?utf-8?B?Q3hwSWpJSW9HeXRpbm1uZU02Yy9Dc2MvZElFU0ora1JVV2x5V09EQm5oRkpU?=
 =?utf-8?B?Mmo0Z3p4VGF5WEoySm9SaW4yUDFIRUJtb1l6RnY4SlRtVFBCZ0I2ZDc5U01M?=
 =?utf-8?B?aXdHLzJoZXNadzZqQ3QraHdvbXI2bjhzSDk0S1h0eW1hemRqOWRIQ2tSSnlC?=
 =?utf-8?B?bmNQeFJGMlFqSHRPUUJuN2tNOXI2NDdqdUdwYmZUL3BHT3NSN2VOSngzdkN2?=
 =?utf-8?B?dkc3bTk5ZGhGK3QwWjFvalFHTU51SWVBdzdUeW84MVVWVFBpZ1RuUUtpbUpS?=
 =?utf-8?B?Vm5DQ0lhTnIzeWUxSTNMUmh3ek05N1RSYzA2Uml1b0ZRQUcvSFZad25UOG5w?=
 =?utf-8?B?OXNkUkt2MVcxdEx6ZWFrNDNqUm9mZ2JXNmtSTzJuZG12MElzMEFWQnJkMnJ4?=
 =?utf-8?B?LzRISC9xVHh2cUJRRXhOT3hXSm50NFlPSUxEb1QvVXBRYzlvK0t2dG00YzRM?=
 =?utf-8?B?U2NLOVJEbDdtZDRoVGFBbnZCc25vSVlRWXJVbVlpSERHZUdaUE1iWitDcnRn?=
 =?utf-8?B?TmtsLzZNT3pDRC9JN0tIdHFaWlBrTVAya1VnV240TDUzZ0NQZnpFTzNWWkM0?=
 =?utf-8?B?a2JoSWI1dG1la1hIUHpEVC9UcjBFMG4rTmVqc2tmeWJ2Um9JWURsb3p6VVNy?=
 =?utf-8?B?WFUxZG9IMlNONlJTWFdqZ2FrbkZheXVreXlDZUtVbG16Zkh2V1VnVVpmc0Mv?=
 =?utf-8?B?a3o2STFWbEdKTmVEMXk0ZWwyRDkxSldlbmptclZpQ1FweFdITlloRlNFMFgz?=
 =?utf-8?B?V2tIa1pibHl5elZ5dS9qUEtGR3J3cDBFM2VHaEJRTFppSmVkbzZZdVhZeXV3?=
 =?utf-8?B?bThFcFFSbUFBVjZLVmIwcE9UY1I3djJFQnhreEI2QlJSU2hHTXFvVGp2cW16?=
 =?utf-8?B?T1FuVTJ2UVpNb1IyWUFDbCtYZUlWN3NZQTNiL01YK2gvaldYckRIdUpjN1Mx?=
 =?utf-8?B?a216dDA5Z2piVWVCS0pvYnBwMHlFRit1bkJFVVRWdDl4TWVqUnM2SG5LNmdL?=
 =?utf-8?B?T0VBUE9GNnphdk9mcTFRbEtMUTBQWVhCL0x2MVduME1oaHhMUG1YenVSZVZK?=
 =?utf-8?Q?c9u7Yt/Hkffh0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 052564ef-b8bf-44be-cc4d-08d8a0bd0a4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 05:48:25.3716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h1Wvp3ru0bCKzbcmJ3F4tkdisN7MQZU6gX4roOfE350vbkoILjimFvtSzYrSzgyKpA35eZNYl1TquZQlsKnOsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3030
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608011312; bh=3DJHDD6VtSW8ieelv1on1eouTb9tL5M+410AHK5cz9s=;
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
        b=av93BfLYDPQ+DztB4MgC0mYr9apdTaL/Oew+Vwi2vzQiRrXMSTqFjp0gVBJL8sZ0A
         UOmPJoAcakxySlFkD1BMj+NOC7LGaMsuaN9AnFLd9OFDryxZUiZPq4i/ePfGZZ5Bto
         4UIf2tOotnR1m3MzhprU3wSa/YulMe4UL97VCFApsHTXwp62E+3BxBGqKNjd6N88c9
         8l/QFwpTELboTv9F+eOMIV3Ybr6QyqfvSMlTybKm3jrUbhcZvSp/wbMXQdSWjSIqkG
         5r1k5sHF3Q/2q1sNDHc9PX50pKIWr3sx0jEcRBHgoUNEJvQeiboHVvKz082LkWX4Ez
         gZur3SgPWOl9A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4g
U2VudDogVHVlc2RheSwgRGVjZW1iZXIgMTUsIDIwMjAgNzoyNCBBTQ0KPiANCj4gT24gTW9uLCBE
ZWMgMTQsIDIwMjAgYXQgMTo0OSBQTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz4N
Cj4gd3JvdGU6DQo+ID4NCj4gPiBIaSBEYXZlLCBKYWt1YiwgSmFzb24sDQo+ID4NCj4gDQo+IEp1
c3QgdG8gY2xhcmlmeSBhIGZldyB0aGluZ3MgZm9yIG15c2VsZi4gWW91IG1lbnRpb24gdmlydHVh
bGl6YXRpb24gYW5kIFNSLUlPVg0KPiBpbiB5b3VyIHBhdGNoIGRlc2NyaXB0aW9uIGJ1dCB5b3Ug
Y2Fubm90IHN1cHBvcnQgZGlyZWN0IGFzc2lnbm1lbnQgd2l0aCB0aGlzDQo+IGNvcnJlY3Q/IA0K
Q29ycmVjdC4gaXQgY2Fubm90IGJlIGRpcmVjdGx5IGFzc2lnbmVkLg0KDQo+IFRoZSBpZGVhIGhl
cmUgaXMgc2ltcGx5IGxvZ2ljYWwgcGFydGl0aW9uaW5nIG9mIGFuIGV4aXN0aW5nIG5ldHdvcmsN
Cj4gaW50ZXJmYWNlLCBjb3JyZWN0PyANCk5vLiBJZGVhIGlzIHRvIHNwYXduIG11bHRpcGxlIGZ1
bmN0aW9ucyBmcm9tIGEgc2luZ2xlIFBDSSBkZXZpY2UuDQpUaGVzZSBmdW5jdGlvbnMgYXJlIG5v
dCBib3JuIGluIFBDSSBkZXZpY2UgYW5kIGluIE9TIHVudGlsIHRoZXkgYXJlIGNyZWF0ZWQgYnkg
dXNlci4NCkphc29uIGFuZCBTYWVlZCBleHBsYWluZWQgdGhpcyBpbiBncmVhdCBkZXRhaWwgZmV3
IHdlZWtzIGJhY2sgaW4gdjAgdmVyc2lvbiBvZiB0aGUgcGF0Y2hzZXQgYXQgWzFdLCBbMl0gYW5k
IFszXS4NCkkgYmV0dGVyIG5vdCByZXBlYXQgYWxsIG9mIGl0IGhlcmUgYWdhaW4uIFBsZWFzZSBn
byB0aHJvdWdoIGl0Lg0KSWYgeW91IG1heSB3YW50IHRvIHJlYWQgcHJlY3Vyc29yIHRvIGl0LCBS
RkMgZnJvbSBKaXJpIGF0IFs0XSBpcyBhbHNvIGV4cGxhaW5zIHRoaXMgaW4gZ3JlYXQgZGV0YWls
Lg0KDQo+IFNvIHRoaXMgaXNuJ3Qgc28gbXVjaCBhIHNvbHV0aW9uIGZvciB2aXJ0dWFsaXphdGlv
biwgYnV0IG1heQ0KPiB3b3JrIGJldHRlciBmb3IgY29udGFpbmVycy4gSSB2aWV3IHRoaXMgYXMg
YW4gaW1wb3J0YW50IGRpc3RpbmN0aW9uIHRvIG1ha2UgYXMNCj4gdGhlIGZpcnN0IHRoaW5nIHRo
YXQgY2FtZSB0byBtaW5kIHdoZW4gSSByZWFkIHRoaXMgd2FzIG1lZGlhdGVkIGRldmljZXMNCj4g
d2hpY2ggaXMgc2ltaWxhciwgYnV0IGZvY3VzZWQgb25seSBvbiB0aGUgdmlydHVhbGl6YXRpb24g
Y2FzZToNCj4gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC92NS45L2RyaXZlci1hcGkv
dmZpby1tZWRpYXRlZC0NCj4gZGV2aWNlLmh0bWwNCj4NCk1hbmFnaW5nIHN1YmZ1bmN0aW9uIHVz
aW5nIG1lZGljYXRlZCBkZXZpY2UgaXMgYWxyZWFkeSBydWxlZCBvdXQgbGFzdCB5ZWFyIGF0IFs1
XSBhcyBpdCBpcyB0aGUgYWJ1c2Ugb2YgdGhlIG1kZXYgYnVzIGZvciB0aGlzIHB1cnBvc2UgKyBo
YXMgc2V2ZXJlIGxpbWl0YXRpb25zIG9mIG1hbmFnaW5nIHRoZSBzdWJmdW5jdGlvbiBkZXZpY2Uu
DQpXZSBhcmUgbm90IGdvaW5nIGJhY2sgdG8gaXQgYW55bW9yZS4NCkl0IHdpbGwgYmUgZHVwbGlj
YXRpbmcgbG90IG9mIHRoZSBwbHVtYmluZyB3aGljaCBleGlzdHMgaW4gZGV2bGluaywgbmV0bGlu
aywgYXV4aWxpYXJ5IGJ1cyBhbmQgbW9yZS4NCiANCj4gUmF0aGVyIHRoYW4gY2FsbGluZyB0aGlz
IGEgc3ViZnVuY3Rpb24sIHdvdWxkIGl0IG1ha2UgbW9yZSBzZW5zZSB0byBjYWxsIGl0DQo+IHNv
bWV0aGluZyBzdWNoIGFzIGEgcXVldWUgc2V0PyANCk5vLCBxdWV1ZSBpcyBqdXN0IG9uZSB3YXkg
dG8gc2VuZCBhbmQgcmVjZWl2ZSBkYXRhL3BhY2tldHMuDQpKYXNvbiBhbmQgU2FlZWQgZXhwbGFp
bmVkIGFuZCBkaXNjdXNzZWQgIHRoaXMgcGllY2UgdG8geW91IGFuZCBvdGhlcnMgZHVyaW5nIHYw
IGZldyB3ZWVrcyBiYWNrIGF0IFsxXSwgWzJdLCBbM10uDQpQbGVhc2UgdGFrZSBhIGxvb2suDQoN
Cj4gU28gaW4gdGVybXMgb2Ygd2F5cyB0byBnbyBJIHdvdWxkIGFyZ3VlIHRoaXMgaXMgbGlrZWx5
IGJldHRlci4gSG93ZXZlciBvbmUNCj4gZG93bnNpZGUgaXMgdGhhdCB3ZSBhcmUgZ29pbmcgdG8g
ZW5kIHVwIHNlZWluZyBlYWNoIHN1YmZ1bmN0aW9uIGJlaW5nDQo+IGRpZmZlcmVudCBmcm9tIGRy
aXZlciB0byBkcml2ZXIgYW5kIHZlbmRvciB0byB2ZW5kb3Igd2hpY2ggSSB3b3VsZCBhcmd1ZQ0K
PiB3YXMgYWxzbyBvbmUgb2YgdGhlIHByb2JsZW1zIHdpdGggU1ItSU9WIGFzIHlvdSBlbmQgdXAg
d2l0aCBhIGJpdCBvZiB2ZW5kb3INCj4gbG9jay1pbiBhcyBhIHJlc3VsdCBvZiB0aGlzIGZlYXR1
cmUgc2luY2UgZWFjaCB2ZW5kb3Igd2lsbCBiZSBwcm92aWRpbmcgYQ0KPiBkaWZmZXJlbnQgaW50
ZXJmYWNlLg0KPg0KRWFjaCBhbmQgc2V2ZXJhbCB2ZW5kb3JzIHByb3ZpZGVkIHVuaWZpZWQgaW50
ZXJmYWNlIGZvciBtYW5hZ2luZyBWRnMuIGkuZS4NCihhKSBlbmFibGUvZGlzYWJsZSB3YXMgdmlh
IHZlbmRvciBuZXV0cmFsIHN5c2ZzDQooYikgc3Jpb3YgY2FwYWJpbGl0eSBleHBvc2VkIHZpYSBz
dGFuZGFyZCBwY2kgY2FwYWJpbGl0eSBhbmQgc3lzZnMNCihjKSBzcmlvdiB2ZiBjb25maWcgKG1h
YywgdmxhbiwgcnNzLCB0eCByYXRlLCBzcG9vZiBjaGVjayB0cnVzdCkgYXJlIHVzaW5nIHZlbmRv
ciBhZ25vc3RpYyBuZXRsaW5rDQpFdmVuIHRob3VnaCB0aGUgZHJpdmVyJ3MgaW50ZXJuYWwgaW1w
bGVtZW50YXRpb24gbGFyZ2VseSBkaWZmZXJzIG9uIGhvdyB0cnVzdCwgc3Bvb2YsIG1hYywgdmxh
biByYXRlIGV0YyBhcmUgZW5mb3JjZWQuDQoNClNvIHN1YmZ1bmN0aW9uIGZlYXR1cmUvYXR0cmli
dXRlL2Z1bmN0aW9uYWxpdHkgd2lsbCBiZSBpbXBsZW1lbnRlZCBkaWZmZXJlbnRseSBpbnRlcm5h
bGx5IGluIHRoZSBkcml2ZXIgbWF0Y2hpbmcgdmVuZG9yJ3MgZGV2aWNlLCBmb3IgcmVhc29uYWJs
eSBhYnN0cmFjdCBjb25jZXB0IG9mICdzdWJmdW5jdGlvbicuDQoNCj4gPiBBIFN1YmZ1bmN0aW9u
IHN1cHBvcnRzIGVzd2l0Y2ggcmVwcmVzZW50YXRpb24gdGhyb3VnaCB3aGljaCBpdA0KPiA+IHN1
cHBvcnRzIHRjIG9mZmxvYWRzLiBVc2VyIG11c3QgY29uZmlndXJlIGVzd2l0Y2ggdG8gc2VuZC9y
ZWNlaXZlDQo+ID4gcGFja2V0cyBmcm9tL3RvIHN1YmZ1bmN0aW9uIHBvcnQuDQo+ID4NCj4gPiBT
dWJmdW5jdGlvbnMgc2hhcmUgUENJIGxldmVsIHJlc291cmNlcyBzdWNoIGFzIFBDSSBNU0ktWCBJ
UlFzIHdpdGgNCj4gPiB0aGVpciBvdGhlciBzdWJmdW5jdGlvbnMgYW5kL29yIHdpdGggaXRzIHBh
cmVudCBQQ0kgZnVuY3Rpb24uDQo+IA0KPiBUaGlzIHBpZWNlIHRvIHRoZSBhcmNoaXRlY3R1cmUg
Zm9yIHRoaXMgaGFzIG1lIHNvbWV3aGF0IGNvbmNlcm5lZC4gSWYgYWxsIHlvdXINCj4gcmVzb3Vy
Y2VzIGFyZSBzaGFyZWQgYW5kIA0KQWxsIHJlc291cmNlcyBhcmUgbm90IHNoYXJlZC4NCg0KPiB5
b3UgYXJlIGFsbG93aW5nIGRldmljZXMgdG8gYmUgY3JlYXRlZA0KPiBpbmNyZW1lbnRhbGx5IHlv
dSBlaXRoZXIgaGF2ZSB0byBwcmUtcGFydGl0aW9uIHRoZSBlbnRpcmUgZnVuY3Rpb24gd2hpY2gN
Cj4gdXN1YWxseSByZXN1bHRzIGluIGxpbWl0ZWQgcmVzb3VyY2VzIGZvciB5b3VyIGJhc2Ugc2V0
dXAsIG9yIGZyZWUgcmVzb3VyY2VzDQo+IGZyb20gZXhpc3RpbmcgaW50ZXJmYWNlcyBhbmQgcmVk
aXN0cmlidXRlIHRoZW0gYXMgdGhpbmdzIGNoYW5nZS4gSSB3b3VsZCBiZQ0KPiBjdXJpb3VzIHdo
aWNoIGFwcHJvYWNoIHlvdSBhcmUgdGFraW5nIGhlcmU/IFNvIGZvciBleGFtcGxlIGlmIHlvdSBo
aXQgYQ0KPiBjZXJ0YWluIHRocmVzaG9sZCB3aWxsIHlvdSBuZWVkIHRvIHJlc2V0IHRoZSBwb3J0
IGFuZCByZWJhbGFuY2UgdGhlIElSUXMNCj4gYmV0d2VlbiB0aGUgdmFyaW91cyBmdW5jdGlvbnM/
DQpOby4gSXRzIHdvcmtzIGJpdCBkaWZmZXJlbnRseSBmb3IgbWx4NSBkZXZpY2UuDQpXaGVuIGJh
c2UgZnVuY3Rpb24gaXMgc3RhcnRlZCwgaXQgc3RhcnRlZCBhcyBpZiBpdCBkb2Vzbid0IGhhdmUg
YW55IHN1YmZ1bmN0aW9ucy4NCldoZW4gc3ViZnVuY3Rpb24gaXMgaW5zdGFudGlhdGVkLCBpdCBz
cGF3bnMgbmV3IHJlc291cmNlcyBpbiBkZXZpY2UgKGh3LCBmdywgbWVtb3J5KSBkZXBlbmRpbmcg
b24gaG93IG11Y2ggYSBmdW5jdGlvbiB3YW50cy4NCg0KRm9yIGV4YW1wbGUsIFBDSSBQRiB1c2Vz
IEJBUiAwLCB3aGlsZSBzdWJmdW5jdGlvbnMgdXNlcyBCQVIgMi4NCkZvciBJUlFzLCBzdWJmdW5j
dGlvbiBpbnN0YW5jZSBzaGFyZXMgdGhlIElSUSB3aXRoIGl0cyBwYXJlbnQvaG9zdGluZyBQQ0kg
UEYuDQpJbiBmdXR1cmUsIHllcywgYSBkZWRpY2F0ZWQgSVJRcyBwZXIgU0YgaXMgbGlrZWx5IGRl
c2lyZWQuDQpTcmlkaGFyIGFsc28gdGFsa2VkIGFib3V0IGxpbWl0aW5nIG51bWJlciBvZiBxdWV1
ZXMgdG8gYSBzdWJmdW5jdGlvbi4NCkkgYmVsaWV2ZSB0aGVyZSB3aWxsIGJlIHJlc291cmNlcy9h
dHRyaWJ1dGVzIG9mIHRoZSBmdW5jdGlvbiB0byBiZSBjb250cm9sbGVkLg0KZGV2bGluayBhbHJl
YWR5IHByb3ZpZGVzIHJpY2ggaW50ZXJmYWNlIHRvIGFjaGlldmUgdGhhdCB1c2luZyBkZXZsaW5r
IHJlc291cmNlcyBbOF0uDQoNClsuLl0NCg0KPiA+ICQgaXAgbGluayBzaG93DQo+ID4gMTI3OiBl
bnMyZjBucDA6IDxCUk9BRENBU1QsTVVMVElDQVNUPiBtdHUgMTUwMCBxZGlzYyBub29wIHN0YXRl
DQo+IERPV04gbW9kZSBERUZBVUxUIGdyb3VwIGRlZmF1bHQgcWxlbiAxMDAwDQo+ID4gICAgIGxp
bmsvZXRoZXIgMjQ6OGE6MDc6YjM6ZDE6MTIgYnJkIGZmOmZmOmZmOmZmOmZmOmZmDQo+ID4gICAg
IGFsdG5hbWUgZW5wNnMwZjBucDANCj4gPiAxMjk6IHAwc2Y4ODogPEJST0FEQ0FTVCxNVUxUSUNB
U1Q+IG10dSAxNTAwIHFkaXNjIG5vb3Agc3RhdGUgRE9XTg0KPiBtb2RlIERFRkFVTFQgZ3JvdXAg
ZGVmYXVsdCBxbGVuIDEwMDANCj4gPiAgICAgbGluay9ldGhlciAwMDowMDowMDowMDo4ODo4OCBi
cmQgZmY6ZmY6ZmY6ZmY6ZmY6ZmY+DQo+IA0KPiBJIGFzc3VtZSB0aGF0IHAwc2Y4OCBpcyBzdXBw
b3NlZCB0byBiZSB0aGUgbmV3bHkgY3JlYXRlZCBzdWJmdW5jdGlvbi4NCj4gSG93ZXZlciBJIHRo
b3VnaHQgdGhlIG5hbWluZyB3YXMgc3VwcG9zZWQgdG8gYmUgdGhlIHNhbWUgYXMgd2hhdCB5b3Ug
YXJlDQo+IHJlZmVycmluZyB0byBpbiB0aGUgZGV2bGluaywgb3IgZGlkIEkgbWlzcyBzb21ldGhp
bmc/DQo+DQpJIGJlbGlldmUgeW91IGFyZSBjb25mdXNlZCB3aXRoIHRoZSByZXByZXNlbnRvciBu
ZXRkZXZpY2Ugb2Ygc3ViZnVjdGlvbiB3aXRoIGRldmljZXMgb2Ygc3ViZnVuY3Rpb24uIChuZXRk
ZXYsIHJkbWEsIHZkcGEgZXRjKS4NCkkgc3VnZ2VzdCB0aGF0IHBsZWFzZSByZWZlciB0byB0aGUg
ZGlhZ3JhbSBpbiBwYXRjaF8xNSBpbiBbN10gdG8gc2VlIHRoZSBzdGFjaywgbW9kdWxlcywgb2Jq
ZWN0cy4NCkhvcGUgYmVsb3cgZGVzY3JpcHRpb24gY2xhcmlmaWVzIGEgYml0Lg0KVGhlcmUgYXJl
IHR3byBuZXRkZXZpY2VzLg0KKGEpIHJlcHJlc2VudG9yIG5ldGRldmljZSwgYXR0YWNoZWQgdG8g
dGhlIGRldmxpbmsgcG9ydCBvZiB0aGUgZXN3aXRjaA0KKGIpIG5ldGRldmljZSBvZiB0aGUgU0Yg
dXNlZCBieSB0aGUgZW5kIGFwcGxpY2F0aW9uIChpbiB5b3VyIGV4YW1wbGUsIHRoaXMgaXMgYXNz
aWduZWQgdG8gY29udGFpbmVyKS4NCiANCkJvdGggbmV0ZGV2aWNlIGZvbGxvdyBvYnZpb3VzbHkg
YSBkaWZmZXJlbnQgbmFtaW5nIHNjaGVtZS4NClJlcHJlc2VudG9yIG5ldGRldmljZSBmb2xsb3dz
IG5hbWluZyBzY2hlbWUgd2VsbCBkZWZpbmVkIGluIGtlcm5lbCArIHN5c3RlbWQvdWRldiB2MjQ1
IGFuZCBoaWdoZXIuDQpJdCBpcyBiYXNlZCBvbiBwaHlzX3BvcnRfbmFtZSBzeXNmcyBhdHRyaWJ1
dGUuDQpUaGlzIGlzIHNhbWUgZm9yIGV4aXN0aW5nIFBGIGFuZCBTRiByZXByZXNlbnRvcnMgZXhp
c3QgZm9yIHllYXIrIG5vdy4gRnVydGhlciB1c2VkIGJ5IHN1YmZ1bmN0aW9uLg0KDQpGb3Igc3Vi
ZnVuY3Rpb24gbmV0ZGV2aWNlIChwMHM4OCksIHN5c3RlbS91ZGV2IHdpbGwgYmUgZXh0ZW5kZWQu
IEkgcHV0IGV4YW1wbGUgYmFzZWQgb24gbXkgZmV3IGxpbmVzIG9mIHVkZXYgcnVsZSB0aGF0IHJl
YWRzDQpwaHlzX3BvcnRfbmFtZSBhbmQgdXNlciBzdXBwbGllZCBzZm51bSwgc28gdGhhdCB1c2Vy
IGV4YWN0bHkga25vd3Mgd2hpY2ggaW50ZXJmYWNlIHRvIGFzc2lnbiB0byBjb250YWluZXIuDQoN
Cj4gPiBBZnRlciB1c2UgaW5hY3RpdmF0ZSB0aGUgZnVuY3Rpb246DQo+ID4gJCBkZXZsaW5rIHBv
cnQgZnVuY3Rpb24gc2V0IGVuczJmMG5wZjBzZjg4IHN0YXRlIGluYWN0aXZlDQo+ID4NCj4gPiBO
b3cgZGVsZXRlIHRoZSBzdWJmdW5jdGlvbiBwb3J0Og0KPiA+ICQgZGV2bGluayBwb3J0IGRlbCBl
bnMyZjBucGYwc2Y4OA0KPiANCj4gVGhpcyBzZWVtcyB3cm9uZyB0byBtZSBhcyBpdCBicmVha3Mg
dGhlIHN5bW1ldHJ5IHdpdGggdGhlIHBvcnQgYWRkDQo+IGNvbW1hbmQgYW5kDQpFeGFtcGxlIG9m
IHRoZSByZXByZXNlbnRvciBkZXZpY2UgaXMgb25seSB0byBtYWtlIGxpZmUgZWFzaWVyIGZvciB0
aGUgdXNlci4NCkRldmxpbmsgcG9ydCBkZWwgY29tbWFuZCB3b3JrcyBiYXNlZCBvbiB0aGUgZGV2
bGluayBwb3J0IGluZGV4LCBqdXN0IGxpa2UgZXhpc3RpbmcgZGV2bGluayBwb3J0IGNvbW1hbmRz
IChnZXQsc2V0LHNwbGl0LHVuc3BsaXQpLg0KSSBleHBsYWluZWQgdGhpcyBpbiBhIHRocmVhZCB3
aXRoIFNyaWRoYXIgYXQgWzZdLg0KSW4gc2hvcnQgZGV2bGluayBwb3J0IGRlbCA8YnVzL2Rldmlj
ZV9uYW1lL3BvcnRfaW5kZXggY29tbWFuZCBpcyBqdXN0IGZpbmUuDQpQb3J0IGluZGV4IGlzIHVu
aXF1ZSBoYW5kbGUgZm9yIHRoZSBkZXZsaW5rIGluc3RhbmNlIHRoYXQgdXNlciByZWZlcnMgdG8g
ZGVsZXRlLCBnZXQsIHNldCBwb3J0IGFuZCBwb3J0IGZ1bmN0aW9uIGF0dHJpYnV0ZXMgcG9zdCBp
dHMgY3JlYXRpb24uDQpJIGNob29zZSB0aGUgcmVwcmVzZW50b3IgbmV0ZGV2IGV4YW1wbGUgYmVj
YXVzZSBpdCBpcyBtb3JlIGludHVpdGl2ZSB0byByZWxhdGVkIHRvLCBidXQgcG9ydCBpbmRleCBp
cyBlcXVhbGx5IGZpbmUgYW5kIHN1cHBvcnRlZC4NCg0KPiBhc3N1bWVzIHlvdSBoYXZlIG93bmVy
c2hpcCBvZiB0aGUgaW50ZXJmYWNlIGluIHRoZSBob3N0LiBJDQo+IHdvdWxkIG11Y2ggcHJlZmVy
IHRvIHRvIHNlZSB0aGUgc2FtZSBhcmd1bWVudHMgdGhhdCB3ZXJlIHBhc3NlZCB0byB0aGUNCj4g
YWRkIGNvbW1hbmQgYmVpbmcgdXNlZCB0byBkbyB0aGUgdGVhcmRvd24gYXMgdGhhdCB3b3VsZCBh
bGxvdyBmb3IgdGhlDQo+IHBhcmVudCBmdW5jdGlvbiB0byBjcmVhdGUgdGhlIG9iamVjdCwgYXNz
aWduIGl0IHRvIGEgY29udGFpbmVyIG5hbWVzcGFjZSwgYW5kDQo+IG5vdCBuZWVkIHRvIHB1bGwg
aXQgYmFjayBpbiBvcmRlciB0byBkZXN0cm95IGl0Lg0KUGFyZW50IGZ1bmN0aW9uIHdpbGwgbm90
IGhhdmUgc2FtZSBuZXRkZXZpY2UgbmFtZSBhcyB0aGF0IG9mIHJlcHJlc2VudG9yIG5ldGRldmlj
ZSwgYmVjYXVzZSBib3RoIGRldmljZXMgZXhpc3QgaW4gc2luZ2xlIHN5c3RlbSBmb3IgbGFyZ2Ug
cGFydCBvZiB0aGUgdXNlIGNhc2VzLg0KU28gcG9ydCBkZWxldGUgY29tbWFuZCB3b3JrcyBvbiB0
aGUgcG9ydCBpbmRleC4NCkhvc3QgZG9lc24ndCBuZWVkIHRvIHB1bGwgaXQgYmFjayB0byBkZXN0
cm95IGl0LiBJdCBpcyBkZXN0cm95ZWQgdmlhIHBvcnQgZGVsIGNvbW1hbmQuDQoNClsxXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMDExMTIxOTI0MjQuMjc0Mi0xLXBhcmF2QG52
aWRpYS5jb20vDQpbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzQyMTk1MWQ5OWEz
M2QyOGI5MWYyYjI5OTc0MDlkMGM5N2ZhNWE5OGEuY2FtZWxAa2VybmVsLm9yZy8NClszXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMDExMjAxNjE2NTkuR0U5MTc0ODRAbnZpZGlh
LmNvbS8NCls0XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMDA1MDEwOTE0NDku
R0EyNTIxMUBuYW5vcHN5Y2hvLm9yaW9uLw0KWzVdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25l
dGRldi8yMDE5MTEwNzE2MDQ0OC4yMDk2Mi0xLXBhcmF2QG1lbGxhbm94LmNvbS8NCls2XSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvQlk1UFIxMk1CNDMyMjc3ODRCQjM0RDkyOUNBNjRF
MzE1RENDQTBAQlk1UFIxMk1CNDMyMi5uYW1wcmQxMi5wcm9kLm91dGxvb2suY29tLw0KWzddIGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIwMTIxNDIxNDM1Mi4xOTgxNzItMTYtc2Fl
ZWRAa2VybmVsLm9yZy9ULyN1DQpbOF0gaHR0cHM6Ly9tYW43Lm9yZy9saW51eC9tYW4tcGFnZXMv
bWFuOC9kZXZsaW5rLXJlc291cmNlLjguaHRtbA0KDQo=
