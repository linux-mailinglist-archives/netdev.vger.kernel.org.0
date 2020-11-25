Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9F42C38E8
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgKYGAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 01:00:20 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:63041 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgKYGAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 01:00:19 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbdf2f20000>; Wed, 25 Nov 2020 14:00:18 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 06:00:18 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 25 Nov 2020 06:00:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pfa6gCfGoLn3yEA6yl+I3YFqh1TSIbFpoVV6URbf++sBuToWPoEQTbeK6W4nyQum84fRgd2nzx4ViCFoIqzI0qqeGkZ6rFqIGccN6y2caCLEGvYm9WItjAiPKVEWabOZk4ZFBAXmAhMvAgPTG+h083Zahx2qHMCHNCQhc35ZcaJY0olv9HpvZ4t9T6cmwmdArw3Iq7EA2UwUSGQbs4eDRo/WbGBv3cQdiW/J1H8NzKjhNkyZSk34eCObWTvAEUSXZ+OWd1yOqLkOj8DcRRLkTJRTrov1WdUdMOxDz9oCrm4a1MgO4CpxdJNGwTnvY8InWW6CBEWqEQtGvuIKhAD2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO85iCTLrKVhayL9FdhAA9AXKJ+ocvv2YZikXzZpx/Y=;
 b=MknV0zKeDKUiui1611WzW2JoiCXNL+63BTUgD/owH7bG7Ht+NNghe8cc7FuyJG4xlIHNoJ0iQbxfR7k8gOSDs9AYmqyMP7SdTilWJGSACSNNh04XG01Vm9naG0WxyOSmmkNvxC8zn1wfQcPFzd1fZH7aMBp4jGmRL79U7/DoKV3cOpthGZSXVfVtwehK3UKNHBGDP/g6/9vDigeCqz41T+zXdVVBt+o97iDvpDJq20PQLH330o56umthxQdxrWmOJXbfu7Wal6zEg4BR5Jp4oee44K1eOtIAWRzrk9H3AVHXCjJkrRIKjcorH15/AxSmR4Bxx9GCBTeojpdtWI2gLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Wed, 25 Nov
 2020 06:00:15 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%5]) with mapi id 15.20.3589.030; Wed, 25 Nov 2020
 06:00:15 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>, Saeed Mahameed <saeed@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Index: AQHWuSmL5Mv5iXh50kOvsKYXf73R1KnLY/sAgAAUkACAAB9NAIAAFpTQgADolgCAABuKAIACDoWAgAAnbICAABcLgIAJZzYAgAACmNA=
Date:   Wed, 25 Nov 2020 06:00:15 +0000
Message-ID: <BY5PR12MB43221CF1FAD99DF931ADE99CDCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201117184954.GV917484@nvidia.com>
 <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
 <29c4d7854faaea6db33136a448a8d2f53d0cfd72.camel@kernel.org>
 <8e6de69c-c979-1f22-067d-24342cfbff52@gmail.com>
In-Reply-To: <8e6de69c-c979-1f22-067d-24342cfbff52@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e118875-2c37-435f-e8e8-08d891076120
x-ms-traffictypediagnostic: BYAPR12MB3031:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3031800E493C4D047B429693DCFA0@BYAPR12MB3031.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lT6EFDx5QdHb5eyjIIZEGSvP9ohNQFLHKvFmOpu9y5j9LvvXZ9TrNDv43j6tsFOIzFA1ZFAasIGG0qjGKSJoze+nVgakmDg5FegPjJ7s/XFLq7bgs85oilvRfmntYsh3uWuyfPeDmG+xSFIlqO2Z064UPyJbvvOM8ktEsxaDDAKP9oWEQv1+BCq54vXEAXyCGy5O8USRvkm8OPTfQJO60QZlNNQcX3EcVm6q/azxXCYP0OXBaqhECDWViY1oPNxUky8N14ykJXloQq58tmS6bDR3vHYEL/TE6YYh8oKUIIfGg+J3+OdfFtMN/zgCAOwP5M0aPTGqqi7mBOTCcUGggQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(110136005)(64756008)(316002)(186003)(66946007)(86362001)(66556008)(8676002)(2906002)(66446008)(8936002)(76116006)(52536014)(9686003)(66476007)(54906003)(7696005)(55016002)(4326008)(478600001)(33656002)(53546011)(5660300002)(26005)(55236004)(6636002)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3//rXwcU10Pg3iGDHwrPZpeuZkYg+JJPV2DgD/3xEb1uTAZJO8KQmAWy2EpH8TZr4NdSNPLjCazsCPOswt+g6CYDX9ACza7Uh+EJ1E5YAA6YRPVkgSaBSVHdaN06TXgoaGs+xI5ws8MgOJh0mZxmxgTCKgkGwVp/hNHu3J1hGi+8rmfsz0F3t8bItHN1YOjiuLKncd/+vuGyy9d4PzskaI3O55AST0MgJLItMeNBxfbjgtBgE9iHNIn2vqPOoOBj/j4hkfpM/GjvetFeR2yWvU9BX8co8uWiOOzHr9botrf3z/sUMuZ9vSFAWMQnKFqVEjJaY/b5BH7rTtKifloES9cLChqgKMWsKu7axt66l74hwhanCg5Rv4dITyglGd2GR+q6qzM4pygZqdRjmYznffAzEIFVaG3glMfzi2zDCG6aq692KPtvXLIAfJ9n6ZrAsjek9OhwHtKhVCKiw8a+sjVVu+JvTsIZ6Z3wbeiNiWgPxQCUOaCxIsIhlIGImQZa+XzuOPRkdVQFSU/OPzO6FNImFwYBG24GE8M2VeWNLhZcA3R0iNlaym1sWsERL+f8O3Yt182jNk772N5jAj2TlES98CoQLSdaBl4zxB96FwgT5vzZpFlBeNIuCIBvD2P8VRcXvt9lFigBUc0G5xdfoySUiSGjHRVAudu1PgB+WbQ5gTILrPB56ACzyHM863/+44sym5bXMLf1D/IIBqvwNjWdftvVVVTPTpPUFTKgxJjRsCvk5HmeSTk/dDfvSTeJnZv28Wx33v1RQQG47insjIvT+hGswCf1oU/qIkYMil+kBfa33PKpfADPnRQRHE3QRZLOUl0azIDAwhHdGpJNko/mD0ytdD1oYh07x6yRP8XhvDZOrLGTVeCU+3WlEi7duGkCEExmPKLBZ5pRzFPSWg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e118875-2c37-435f-e8e8-08d891076120
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 06:00:15.1866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 855a1PXLw0iv3svQhHgzM95vqnWWBg7hlZ7nwgSIYuTCn6TyjByM0+xGKScmM3MFLpJ7bVOek74vZ7JGFBa5LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606284018; bh=YO85iCTLrKVhayL9FdhAA9AXKJ+ocvv2YZikXzZpx/Y=;
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
        b=U+9NedYrzglRM/KMkflJMYwxoYVVkCqOYUlBZ5pedqw6Id4ReZ5k+k1q+/Xk7pm+T
         umWC0c37JZz9YiW0D/jL4/Wxxt+SkR7LON5HLllAh5uU0LQyFv1p5XZYoCehA0HLtG
         bb/8/HQs9i2NfcTkVFCNnmuJJ/48qjZVV3XAtuiyhPQAr9mGNfV70Fg7nkkO53YyKz
         uhWqVVtd6kWN8CxHB6gNMIfLmWyn3LUTeuSl9qUi4Ge1aZ1EOC3uXn7Sbjmh1537Tg
         Y7D519LSL+bfDTXfIX2aTGOBN/tCamJ1OiwuU8Zgoa9O+XHy8T26vUAhd1sOAFdoFg
         Emt2i8RIieUOw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDI1LCAyMDIwIDExOjA0IEFNDQo+IA0KPiBPbiAxMS8x
OC8yMCAxMDo1NyBQTSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+ID4NCj4gPiBXZSBhcmUgbm90
IHNsaWNpbmcgdXAgYW55IHF1ZXVlcywgZnJvbSBvdXIgSFcgYW5kIEZXIHBlcnNwZWN0aXZlIFNG
ID09DQo+ID4gVkYgbGl0ZXJhbGx5LCBhIGZ1bGwgYmxvd24gSFcgc2xpY2UgKEZ1bmN0aW9uKSwg
d2l0aCBpc29sYXRlZCBjb250cm9sDQo+ID4gYW5kIGRhdGEgcGxhbmUgb2YgaXRzIG93biwgdGhp
cyBpcyB2ZXJ5IGRpZmZlcmVudCBmcm9tIFZNRHEgYW5kIG1vcmUNCj4gPiBnZW5lcmljIGFuZCBz
ZWN1cmUuIGFuIFNGIGRldmljZSBpcyBleGFjdGx5IGxpa2UgYSBWRiwgZG9lc24ndCBzdGVhbA0K
PiA+IG9yIHNoYXJlIGFueSBIVyByZXNvdXJjZXMgb3IgY29udHJvbC9kYXRhIHBhdGggd2l0aCBv
dGhlcnMuIFNGIGlzDQo+ID4gYmFzaWNhbGx5IFNSSU9WIGRvbmUgcmlnaHQuDQo+IA0KPiBXaGF0
IGRvZXMgdGhhdCBtZWFuIHdpdGggcmVzcGVjdCB0byBtYWMgZmlsdGVyaW5nIGFuZCBudHVwbGUg
cnVsZXM/DQo+IA0KPiBBbHNvLCBUeCBpcyBmYWlybHkgZWFzeSB0byBpbWFnaW5lLCBidXQgaG93
IGRvZXMgaGFyZHdhcmUga25vdyBob3cgdG8gZGlyZWN0DQo+IHBhY2tldHMgZm9yIHRoZSBSeCBw
YXRoPyBBcyBhbiBleGFtcGxlLCBjb25zaWRlciAyIFZNcyBvciBjb250YWluZXJzIHdpdGggdGhl
DQo+IHNhbWUgZGVzdGluYXRpb24gaXAgYm90aCB1c2luZyBzdWJmdW5jdGlvbiBkZXZpY2VzLg0K
U2luY2UgYm90aCBWTS9jb250YWluZXJzIGFyZSBoYXZpbmcgc2FtZSBJUCwgaXQgaXMgYmV0dGVy
IHRvIHBsYWNlIHRoZW0gaW4gZGlmZmVyZW50IEwyIGRvbWFpbnMgdmlhIHZsYW4sIHZ4bGFuIGV0
Yy4NCg0KPiBIb3cgZG9lcyB0aGUgbmljIGtub3cgaG93IHRvIGRpcmVjdCB0aGUgaW5ncmVzcyBm
bG93cyB0byB0aGUgcmlnaHQgcXVldWVzIGZvcg0KPiB0aGUgc3ViZnVuY3Rpb24/DQo+IA0KUngg
c3RlZXJpbmcgb2NjdXJzIHRocm91Z2ggdGMgZmlsdGVycyB2aWEgcmVwcmVzZW50b3IgbmV0ZGV2
IG9mIFNGLg0KRXhhY3RseSBzYW1lIHdheSBhcyBWRiByZXByZXNlbnRvciBuZXRkZXYgb3BlcmF0
aW9uLg0KDQpXaGVuIGRldmxpbmsgZXN3aXRjaCBwb3J0IGlzIGNyZWF0ZWQgYXMgc2hvd24gaW4g
ZXhhbXBsZSBpbiBjb3ZlciBsZXR0ZXIsIGFuZCBhbHNvIGluIHBhdGNoLTEyLCBpdCBjcmVhdGVz
IHRoZSByZXByZXNlbnRvciBuZXRkZXZpY2UuDQpCZWxvdyBpcyB0aGUgc25pcHBldCBvZiBpdC4N
Cg0KQWRkIGEgZGV2bGluayBwb3J0IG9mIHN1YmZ1bmN0aW9uIGZsYXZvdXI6DQokIGRldmxpbmsg
cG9ydCBhZGQgcGNpLzAwMDA6MDY6MDAuMCBmbGF2b3VyIHBjaXNmIHBmbnVtIDAgc2ZudW0gODgN
Cg0KQ29uZmlndXJlIG1hYyBhZGRyZXNzIG9mIHRoZSBwb3J0IGZ1bmN0aW9uOg0KJCBkZXZsaW5r
IHBvcnQgZnVuY3Rpb24gc2V0IGVuczJmMG5wZjBzZjg4IGh3X2FkZHIgMDA6MDA6MDA6MDA6ODg6
ODgNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5e
Xl5eXl5eXl5eDQpUaGlzIGlzIHRoZSByZXByZXNlbnRvciBuZXRkZXZpY2UuIEl0IGlzIGNyZWF0
ZWQgYnkgcG9ydCBhZGQgY29tbWFuZC4NClRoaXMgbmFtZSBpcyBzZXR1cCBieSBzeXN0ZW1kL3Vk
ZXYgdjI0NSBhbmQgaGlnaGVyIGJ5IHV0aWxpemluZyB0aGUgZXhpc3RpbmcgcGh5c19wb3J0X25h
bWUgaW5mcmFzdHJ1Y3R1cmUgYWxyZWFkeSBleGlzdHMgZm9yIFBGIGFuZCBWRiByZXByZXNlbnRv
cnMuDQoNCk5vdyB1c2VyIGNhbiBhZGQgdW5pY2FzdCByeCB0YyBydWxlIGZvciBleGFtcGxlLA0K
DQokIHRjIGZpbHRlciBhZGQgZGV2IGVuczJmMG5wMCBwYXJlbnQgZmZmZjogcHJpbyAxIGZsb3dl
ciBkc3RfbWFjIDAwOjAwOjAwOjAwOjg4Ojg4IGFjdGlvbiBtaXJyZWQgZWdyZXNzIHJlZGlyZWN0
IGRldiBlbnMyZjBucGYwc2Y4OA0KDQpJIGRpZG4ndCBjb3ZlciB0aGlzIHRjIGV4YW1wbGUgaW4g
Y292ZXIgbGV0dGVyLCB0byBrZWVwIGl0IHNob3J0Lg0KQnV0IEkgaGFkIGEgb25lIGxpbmUgZGVz
Y3JpcHRpb24gYXMgYmVsb3cgaW4gdGhlICdkZXRhaWwnIHNlY3Rpb24gb2YgY292ZXItbGV0dGVy
Lg0KSG9wZSBpdCBoZWxwcy4NCg0KLSBBIFNGIHN1cHBvcnRzIGVzd2l0Y2ggcmVwcmVzZW50YXRp
b24gYW5kIHRjIG9mZmxvYWQgc3VwcG9ydCBzaW1pbGFyDQogIHRvIGV4aXN0aW5nIFBGIGFuZCBW
RiByZXByZXNlbnRvcnMuDQoNCk5vdyBhYm92ZSBwb3J0aW9uIGFuc3dlcnMsIGhvdyB0byBmb3J3
YXJkIHRoZSBwYWNrZXQgdG8gc3ViZnVuY3Rpb24uDQpCdXQgaG93IHRvIGZvcndhcmQgdG8gdGhl
IHJpZ2h0IHJ4IHF1ZXVlIG91dCBvZiBtdWx0aXBsZSByeHF1ZXVlcz8NClRoaXMgaXMgZG9uZSBi
eSB0aGUgcnNzIGNvbmZpZ3VyYXRpb24gZG9uZSBieSB0aGUgdXNlciwgbnVtYmVyIG9mIGNoYW5u
ZWxzIGZyb20gZXRodG9vbC4NCkp1c3QgbGlrZSBWRiBhbmQgUEYuDQpUaGUgZHJpdmVyIGRlZmF1
bHRzIGFyZSBzaW1pbGFyIHRvIFZGLCB3aGljaCB1c2VyIGNhbiBjaGFuZ2UgdmlhIGV0aHRvb2wu
DQo=
