Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DCE26F4BF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIRDe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:34:27 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:61212 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIRDe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 23:34:26 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 23:34:24 EDT
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6429900000>; Fri, 18 Sep 2020 11:29:20 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 03:29:20 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 03:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhYcfmOGB8cBdDCxUPKtWrJcnWI+e6/HS7ZrRvWMYJHidH0fxqAuL+0zrwNw0gacWCnqcflk01ikbpeuCfH+tAmDu6WsmMogYjNibkSRpwBW7GkgxSCNZloXyN5Exl7Ch8vIx/emd1BS8y5XQEmAMvruZUe1hxrgC9o26VDeVq/VVK897ed+6r362x8Dszu893hju6RWaHmlPHyygWxuqa2C3DAABgiXDx7AhQxv8YGK6eyOkVWqI41fN7ELaRNbVvVX/iBhUivUGDwR6m5musKR7RNTdy6pQnqD9T1DL/LAPN0RuAr9ktpz11msryOcQKYr5s7ssE+3PKTJKpecmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90gz5AK1nIDQ9vIerrLn2q+fgCoWyYhMWugQkO2MO80=;
 b=YYSTu0lJYb+G5jbFKtasiT2aYFRhJllH3q2e+O1tcw+ET5ByYvpH7301bst0iCxCrH8WaURTkYcfNPfT1ORJPK9ftzrND/Kqocmhz+MrYsqjVocIP16+dWqjTuOw9Ki4QcsZRGllV2nENEc50KegQwYFppNppPGVlxguWkMmMQQJDU5Cji+NfazhLL8shD5o4C/VnWJSi6DHPJQdAVTbF0eAfqziUmOEJwQgYMFEIyzUhhw6AAOz4G1GqaN5t3N/8ZLuCFed6Ajn2m5c1lb+UaKU4tif3/YltBu+GX1NYMDZhddqk5VBWQcKjFQVpJTiDVApneVtfPfnHOcQCFoAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2696.namprd12.prod.outlook.com (2603:10b6:a03:68::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 03:29:18 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 03:29:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
Thread-Topic: [PATCH net-next v2 8/8] netdevsim: Add support for add and
 delete PCI SF port
Thread-Index: AQHWjRbiZXOkBXXnYkS4YkdYcsgPfqltSM4AgABzn/A=
Date:   Fri, 18 Sep 2020 03:29:17 +0000
Message-ID: <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
In-Reply-To: <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dffdf2de-0855-4ba8-8e9a-08d85b830680
x-ms-traffictypediagnostic: BYAPR12MB2696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2696D4D50202764159A1BA5CDC3F0@BYAPR12MB2696.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JarlvUYR0mOo9k1Mbo/cFt64Y9H3zlLnwHjfRrMeHnPNE6jYlFdfjzLvL+fQGvNTXtnnyczkD5auv6u8XoAtonADiQ76AJG/s0dMvtLlvjE3SscRvdNZk0DxShj36tNTmVBzI1MND5M8iAbdp/7Ab9yFyBsbtwRlfCKXV58ASuMbl9MxN5cgdxZiqkU61pdkCPm8bm2IMZAxz6nh8JVVsNKjTMueYFlZDgCUG1uymswHueMr8fuCCaK1hpyAfQEtVq9otDCdnANYyCtL6rFRaanfnbTTWh6LlKiPXP6xKRPyOgpLJ+0OEbe/DU6F2lTRQgeZizCT7lOmPneXBdYTh/e2EdDLWGWbADsib4u33NIahGmF2fewQ87jWhqN9C8MlnXXd+iOI0RkytE2LEpG+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(66946007)(55236004)(26005)(2906002)(6506007)(186003)(110136005)(33656002)(8936002)(71200400001)(53546011)(86362001)(107886003)(76116006)(83380400001)(4326008)(64756008)(66556008)(52536014)(7696005)(66476007)(66446008)(966005)(5660300002)(316002)(478600001)(55016002)(9686003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Iz1XfclsEzJbYH9ukDwfd59rmfY0J31CYn+SqSs61Y9yoDOhkPrNtyOpRZWOYURH5We2l1atGq6XDcjODPPo9o1DnJP4mq87CEndNgcC2s9Nq3JOzAhOPYLRzE/TFwfTsS2krFK7fELe6VNrBFLEMo0g0YPfnWIWgWIY9SfIOyTMoWVDHWJIHGtppX77/WrC+70K7VFNcVCO/hHPmG4UDzRBIlTn2N5iK0BqH97hNLNX995YFd0/N4LqFadPlNFz8xksthKk7hAFixlmWDWPm2iFX/0pee1e8L8+mgpE64CBgNo9Ltk0XxhTquAeP8WQF99ZND0zlo3SrFSK8i//t4dbjLuUWFOlPQo9CKW8WmhFaAPHU70o5whXrzANXJq3zUtpSlz8swv1KRz9yPj5SQB/UPzqLRgIgBiHHBpnOvOQpJlv6SSlJdJ8qN3py/7MR2OMt6VyququfoL0Is8jowSLZsCBkv5KbNcQJx/pm4mq/OEcVORAHpVO+MwUaZlL8Wr9L+7c30HbE4+oaDQcpx3atwnD/RbmAOP1+MmmPGTiINw+Nul9iRS7KMARzMBIHKonQ6hB00QvYVAfi6yyA0TTKysTmH35zTvgIlCU49iPRyVv864BBGsJvo07fvkeJiHlR1erJs7rlyZcjrqAdg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffdf2de-0855-4ba8-8e9a-08d85b830680
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 03:29:17.8905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1gaDNC7nAZnl1dpAD6I7CXGRHUwTSoViqTrYOdkkf80EI3A8pg/2U4qtGCrUlgTxrBKcD33GSGeI20zO78GAJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2696
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600399760; bh=90gz5AK1nIDQ9vIerrLn2q+fgCoWyYhMWugQkO2MO80=;
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
        b=MojALVyGFTftNp1OOETxGkdRuAEH7ypINx0AG2gCPOrrpFFGtZXObYxo4nh5XcfmP
         hYNYityPz9l5j1pkgN3PfRhdEpzgj/mQgTlqnSFlghOZUwp6LFzfuqz/d7H5AlV+Uu
         JO6jDhjIGB0eg6q/Z8VUT+Pc5c8OuH7rRDIJPgh74JSnfTOodWv745NKcJtllk1WwR
         lsjgBADkwBc/WrxE4NBfQsaQUG+O69/dD6kZaJ0Ra7Tcao/5tK3dkEEQ7lorZfhVb6
         aSTbSeAeTi6hzUnpEZj5m2hxvBnEhh0pC5U4qHFroGF4In4PxcQlDM1JzQRxMzm9Xa
         yS3iD1Cne4Opg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5
LCBTZXB0ZW1iZXIgMTgsIDIwMjAgMjowMSBBTQ0KPiANCj4gT24gOS8xNy8yMCAxMToyMCBBTSwg
UGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IFNpbXVsYXRlIFBDSSBTRiBwb3J0cy4gQWxsb3cgdXNl
ciB0byBjcmVhdGUgb25lIG9yIG1vcmUgUENJIFNGIHBvcnRzLg0KPiA+DQo+ID4gRXhhbXBsZXM6
DQo+ID4NCj4gPiBDcmVhdGUgYSBQQ0kgUEYgYW5kIFBDSSBTRiBwb3J0Lg0KPiA+ICQgZGV2bGlu
ayBwb3J0IGFkZCBuZXRkZXZzaW0vbmV0ZGV2c2ltMTAvMTAgZmxhdm91ciBwY2lwZiBwZm51bSAw
ICQNCj4gPiBkZXZsaW5rIHBvcnQgYWRkIG5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMSBmbGF2b3Vy
IHBjaXNmIHBmbnVtIDAgc2ZudW0NCj4gPiA0NCAkIGRldmxpbmsgcG9ydCBzaG93IG5ldGRldnNp
bS9uZXRkZXZzaW0xMC8xMQ0KPiA+IG5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMTogdHlwZSBldGgg
bmV0ZGV2IGVuaTEwbnBmMHNmNDQgZmxhdm91ciBwY2lzZg0KPiBjb250cm9sbGVyIDAgcGZudW0g
MCBzZm51bSA0NCBleHRlcm5hbCB0cnVlIHNwbGl0dGFibGUgZmFsc2UNCj4gPiAgIGZ1bmN0aW9u
Og0KPiA+ICAgICBod19hZGRyIDAwOjAwOjAwOjAwOjAwOjAwIHN0YXRlIGluYWN0aXZlDQo+ID4N
Cj4gPiAkIGRldmxpbmsgcG9ydCBmdW5jdGlvbiBzZXQgbmV0ZGV2c2ltL25ldGRldnNpbTEwLzEx
IGh3X2FkZHINCj4gPiAwMDoxMToyMjozMzo0NDo1NSBzdGF0ZSBhY3RpdmUNCj4gPg0KPiA+ICQg
ZGV2bGluayBwb3J0IHNob3cgbmV0ZGV2c2ltL25ldGRldnNpbTEwLzExIC1qcCB7DQo+ID4gICAg
ICJwb3J0Ijogew0KPiA+ICAgICAgICAgIm5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMSI6IHsNCj4g
PiAgICAgICAgICAgICAidHlwZSI6ICJldGgiLA0KPiA+ICAgICAgICAgICAgICJuZXRkZXYiOiAi
ZW5pMTBucGYwc2Y0NCIsDQo+IA0KPiBJIGNvdWxkIGJlIG1pc3Npbmcgc29tZXRoaW5nLCBidXQg
aXQgZG9lcyBub3Qgc2VlbSBsaWtlIHRoaXMgcGF0Y2ggY3JlYXRlcyB0aGUNCj4gbmV0ZGV2aWNl
IGZvciB0aGUgc3ViZnVuY3Rpb24uDQo+DQpUaGUgc2YgcG9ydCBjcmVhdGVkIGhlcmUgaXMgdGhl
IGVzd2l0Y2ggcG9ydCB3aXRoIGEgdmFsaWQgc3dpdGNoIGlkIHNpbWlsYXIgdG8gUEYgYW5kIHBo
eXNpY2FsIHBvcnQuDQpTbyB0aGUgbmV0ZGV2IGNyZWF0ZWQgaXMgdGhlIHJlcHJlc2VudG9yIG5l
dGRldmljZS4NCkl0IGlzIGNyZWF0ZWQgdW5pZm9ybWx5IGZvciBzdWJmdW5jdGlvbiBhbmQgcGYg
cG9ydCBmbGF2b3Vycy4NCg0KVGhpcyBzZXJpZXMgZW5hYmxlcyB1c2VyIHRvIGFkZCBQQ0kgUEYg
YW5kIHN1YmZ1bmN0aW9uIHBvcnRzLg0KUEYgcG9ydCBhZGRpdGlvbiAoYW5kIGl0cyByZXByZXNl
bnRvciBuZXRkZXYpIGlzIGRvbmUgaW4gcGF0Y2ggNSBbMV0uDQpUaGlzIHBhdGNoIGZvciBTRiB1
dGlsaXplcyB0aGUgc2FtZSAnIHN0cnVjdCBuc2ltX3BvcnRfZnVuY3Rpb24nIGZvciBQRiBhbmQg
U0YuDQpPbmx5IGRpZmZlcmVuY2UgYmV0d2VlbiB0aGVtIGlzIGZsYXZvdXIuDQpbMV0gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjAwOTE3MTcyMDIwLjI2NDg0LTYtcGFyYXZAbnZp
ZGlhLmNvbS8NCg0KID4gDQo+ID4gICAgICAgICAgICAgImZsYXZvdXIiOiAicGNpc2YiLA0KPiA+
ICAgICAgICAgICAgICJjb250cm9sbGVyIjogMCwNCj4gPiAgICAgICAgICAgICAicGZudW0iOiAw
LA0KPiA+ICAgICAgICAgICAgICJzZm51bSI6IDQ0LA0KPiA+ICAgICAgICAgICAgICJleHRlcm5h
bCI6IHRydWUsDQo+ID4gICAgICAgICAgICAgInNwbGl0dGFibGUiOiBmYWxzZSwNCj4gPiAgICAg
ICAgICAgICAiZnVuY3Rpb24iOiB7DQo+ID4gICAgICAgICAgICAgICAgICJod19hZGRyIjogIjAw
OjExOjIyOjMzOjQ0OjU1IiwNCj4gPiAgICAgICAgICAgICAgICAgInN0YXRlIjogImFjdGl2ZSIN
Cj4gPiAgICAgICAgICAgICB9DQo+ID4gICAgICAgICB9DQo+ID4gICAgIH0NCj4gPiB9DQo+ID4N
Cj4gPiBEZWxldGUgbmV3bHkgYWRkZWQgZGV2bGluayBwb3J0DQo+ID4gJCBkZXZsaW5rIHBvcnQg
YWRkIG5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMQ0KPiA+DQo+ID4gQWRkIGRldmxpbmsgcG9ydCBv
ZiBmbGF2b3VyICdwY2lzZicgd2hlcmUgcG9ydCBpbmRleCBhbmQgc2ZudW0gYXJlDQo+ID4gYXV0
byBhc3NpZ25lZCBieSBkcml2ZXIuDQo+ID4gJCBkZXZsaW5rIHBvcnQgYWRkIG5ldGRldnNpbS9u
ZXRkZXZzaW0xMCBmbGF2b3VyIHBjaXNmIGNvbnRyb2xsZXIgMA0KPiA+IHBmbnVtIDANCg==
