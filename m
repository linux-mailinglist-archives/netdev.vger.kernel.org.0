Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC65260222
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbgIGRTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:19:37 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17671 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbgIGN42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 09:56:28 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f563bd50000>; Mon, 07 Sep 2020 06:55:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 07 Sep 2020 06:56:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 07 Sep 2020 06:56:22 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 13:56:22 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 7 Sep 2020 13:56:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C99uI33Ejcp5m1W5+ADIBM7M0nN8Mql/kaHfr14HSIJVdM4b0FMUQ93xjCxPaWl+getiCaGLoRCBGFU/jKy5OWdGNYNGv7Bl5AODvtI9JyOboZZ7IhjKqoZf6LCtHyjSAuPmXAmHdVZcbkx1LS0aaC5kBHx/4Y7BNjUbRDQ0VzN1V11goeHiDooslNzRB+pR0heG4H1+xOYNDu065qPIWxRFllGfbSK+TGvlfmNeX7sSy1yefrD8ENq3p2FWoESSg0/GqYFDJQemJyXVQzpGCSvWv8j/K9HQtHpmyQQ+K07MZbANIeUYF4es+bDU4oO+qGUgRH10h44rFuLH7V+ugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcdNVEB31jSW8JH9uBQsMpkXEOBy9vl0s3QLbyVTAAs=;
 b=QAP5+9lkl+DA2ou++fFC+0F+uI0L84BNJdvP2bhgzfOdDT7L5JlkGJ2Bhx56+awrckT9nZnjQtZMDEge9adNwJAKK0pj/mW3RLwbNqQCDfzI9dhinLXiHHICA0I9ndeZyBC5OpXJEbdUyedoaLkJw8gur18/B2LyDRxNjUIqhryFzss+ZqSdBW7oyKlv1jB0S/iNlC8SwWkv0Tu5Hps/AYM+7YSoFx0QxH5pGta4MzDEzN/5XdBbpj8asiQGhl1bwWshehNX4mo3+mjI1awFMAQf0BTQRcKwCoZ/hBXtclICvmrrjt16sbBkZ59dclrKFGp7+06RrlaL3mWYGQGOFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BY5PR12MB4164.namprd12.prod.outlook.com (2603:10b6:a03:207::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 13:56:20 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 13:56:20 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC 0/7] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Thread-Topic: [PATCH RFC 0/7] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Thread-Index: AQHWgpxscb2zVIk4hE+OH7ymotxKpKlZFJEAgALbSoCAAUg+gA==
Date:   Mon, 7 Sep 2020 13:56:20 +0000
Message-ID: <b36a32dbf3b4b315fc4cbfdf06084b75a7c58729.camel@nvidia.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
         <20200904154406.4fe55b9d@hermes.lan>
         <20200906182129.274fimjyo7l52puj@soft-dev3.localdomain>
In-Reply-To: <20200906182129.274fimjyo7l52puj@soft-dev3.localdomain>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ede4199d-2f42-4555-8f59-08d85335cca9
x-ms-traffictypediagnostic: BY5PR12MB4164:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4164E57FC2F4EFE67929B5CADF280@BY5PR12MB4164.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JKOztMeuwfB/U577iL6q+pPzGfOsfwEB0P3oSpK1iZUnEWmnopyIq2ZLnfVA8+Hm2xM48W7MD47wWb/xw5OJz551W5nP2MIjczCy/irtp4U6e3UywzgZYtv0le23DKQCaqUka65jT4IWoRK7ybnJrKzV8zg+gq+BffsrIh1v0RJPv2l/TIgrgycBYShwtML9KdlRW5UKqyIblNnlxZB/UYCMrNuSHqYdd4/mbce2oSnw68Wra6dRTf4MykmRFYqDEtfNalSCIo/baHsXuaG6KsH64v30b/febPZ2REI54kmFnWhviTJ2rABPbr3leqAWkrvuL26PPEGZGZyIuN1KxcdI8rLMDLRFo+WRPf+s3alpTQriTuGdcDGk7yQJXxzJPsxvFdkilA0MztnEzIhcng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(2616005)(26005)(478600001)(3450700001)(83380400001)(71200400001)(6486002)(36756003)(86362001)(54906003)(4326008)(76116006)(8936002)(64756008)(186003)(2906002)(66476007)(66556008)(66446008)(91956017)(966005)(8676002)(6512007)(66946007)(316002)(110136005)(5660300002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wJW6J+sLhME3s057mcq94pkWyZbIPrUZLr7fZxjvn+/pynr6h9Wc1D2fOyLjtz+LVR0SW3dFfbX16inUyRaNoz8ygzEEjlf2BXhf9DRrUx8EjifpQiXau/U3hCvsv3ptQlRd2+0P8Qx78DV8KGDzdenTcq0Jy4sbDn8FBL1uwY94pHbC9l9BoAvIQIMOGg9FtNMJ65oWQCHoDBpPJq7AIe/TLriDTcAA/HTIQ3Kfao4wQ2U6Dca97kw/qzCLfzwAMD0v3hhwqeUrbPv6bAIgrxRL6aHKaPa9/J2NIzG3YUB/lgKC0uZZqVBJHfqmDutIsUnSJtEzlC/0Hsb1Gpj9+D53cfKlxnE7qF7DOVVdGpVVeCOJOOGtzLUm0YtvhUUqiPXxj4Nx9RCa2DjxB/GyYswijbulsa+xwnUQ+2Hs7+Yb04ZVlqvU2FxyZmK1Rbttv1ZHEv4ACKm9cjExEV7ypfEyPTeD4ST6VsM7my86WMveiFxCi/iMOf1E5VI1wH7G71aASkIPanfu0QwPkKQ9OjvH21B031N7KyGIUH7VmVKn0238QLxHDtb5O/6QTKoU2pssmk6TD8cO8VhytJgh8k81hnRr3ELRIUzvle6ypmlc5tM28Tt28ccH76Mbgb2C1aAfyxTTEBtULeSaD+fnQg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <94F99F6A221CFA4CB7EA968A51B4F31B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede4199d-2f42-4555-8f59-08d85335cca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 13:56:20.3412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fa3Pa3sWSjArxVMQli7eqfZZMKGZzNColt6KRhMH1S9xdLn+JdqXcGZ30JUBy18jkksJeScvnKbKeUPTzvKzDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4164
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599486933; bh=fcdNVEB31jSW8JH9uBQsMpkXEOBy9vl0s3QLbyVTAAs=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=heIZT8iBcMGIj/ifRH1l57uqW943Xhgw1awfp5i1zeTOtsfQ4UOSnldmSVdEhRtKW
         bXsOOw1VmjEiHOpA5C5zojRt8cgDlPJCP0Mkq8a4B4/b8PMAhkj/JLhKkII/ZSbXsc
         fEqo+yCOMk9PjOXrp0q+XG9r55SFiflMnCf90SNoznrDemjE1rxZ/GMUAxzAWU5ItF
         0eM9qb9TaK3v0dDm+4EJPl1bCdtlC9TnhFKRE+u10qFX3AE4Of6qF8WqFF8/ofVnWT
         M2YO+lwU+i4hFy3LwEpj9c6oIoBqvD6LsdcHgEYozRCySt4l2CYoJyzwJqA7sxnqJo
         rBAk8KVDY7GdA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA5LTA2IGF0IDIwOjIxICswMjAwLCBIb3JhdGl1IFZ1bHR1ciB3cm90ZToN
Cj4gVGhlIDA5LzA0LzIwMjAgMTU6NDQsIFN0ZXBoZW4gSGVtbWluZ2VyIHdyb3RlOg0KPiA+IE9u
IEZyaSwgNCBTZXAgMjAyMCAwOToxNToyMCArMDAwMA0KPiA+IEhlbnJpayBCam9lcm5sdW5kIDxo
ZW5yaWsuYmpvZXJubHVuZEBtaWNyb2NoaXAuY29tPiB3cm90ZToNCj4gPiANCj4gPiA+IENvbm5l
Y3Rpdml0eSBGYXVsdCBNYW5hZ2VtZW50IChDRk0pIGlzIGRlZmluZWQgaW4gODAyLjFRIHNlY3Rp
b24gMTIuMTQuDQo+ID4gPiANCj4gPiA+IA0KW3NuaXBdDQo+ID4gPiBDdXJyZW50bHkgdGhpcyAn
Y2ZtJyBhbmQgJ2NmbV9zZXJ2ZXInIHByb2dyYW1zIGFyZSBzdGFuZGFsb25lIHBsYWNlZCBpbiBh
DQo+ID4gPiBjZm0gcmVwb3NpdG9yeSBodHRwczovL2dpdGh1Yi5jb20vbWljcm9jaGlwLXVuZy9j
Zm0gYnV0IGl0IGlzIGNvbnNpZGVyZWQNCj4gPiA+IHRvIGludGVncmF0ZSB0aGlzIGludG8gJ2lw
cm91dGUyJy4NCj4gPiA+IA0KPiA+ID4gUmV2aWV3ZWQtYnk6IEhvcmF0aXUgVnVsdHVyICA8aG9y
YXRpdS52dWx0dXJAbWljcm9jaGlwLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBC
am9lcm5sdW5kICA8aGVucmlrLmJqb2Vybmx1bmRAbWljcm9jaGlwLmNvbT4NCj4gDQo+IEhpIFN0
ZXBoZW4sDQo+IA0KPiA+IENvdWxkIHRoaXMgYmUgZG9uZSBpbiB1c2Vyc3BhY2U/IEl0IGlzIGEg
Y29udHJvbCBwbGFuZSBwcm90b2NvbC4NCj4gPiBDb3VsZCBpdCBiZSBkb25lIGJ5IHVzaW5nIGVC
UEY/DQo+IA0KPiBJIG1pZ2h0IGJlIGFibGUgdG8gYW5zd2VyIHRoaXMuIFdlIGhhdmUgbm90IGNv
bnNpZGVyZWQgdGhpcyBhcHByb2FjaCBvZg0KPiB1c2luZyBlQlBGLiBCZWNhdXNlIHdlIHdhbnQg
YWN0dWFsbHkgdG8gcHVzaCB0aGlzIGluIEhXIGV4dGVuZGluZw0KPiBzd2l0Y2hkZXYgQVBJLiBJ
IGtub3cgdGhhdCB0aGlzIHNlcmllcyBkb2Vzbid0IGNvdmVyIHRoZSBzd2l0Y2hkZXYgcGFydA0K
PiBidXQgd2UgcG9zdGVkIGxpa2UgdGhpcyBiZWNhdXNlIHdlIHdhbnRlZCB0byBnZXQgc29tZSBm
ZWVkYmFjayBmcm9tDQo+IGNvbW11bml0eS4gV2UgaGFkIGEgc2ltaWxhciBhcHByb2FjaCBmb3Ig
TVJQLCB3aGVyZSB3ZSBleHRlbmRlZCB0aGUNCj4gYnJpZGdlIGFuZCBzd2l0Y2hkZXYgQVBJLCBz
byB3ZSB0b3VnaHQgdGhhdCBpcyB0aGUgd2F5IHRvIGdvIGZvcndhcmQuDQo+IA0KPiBSZWdhcmRp
bmcgZUJQRiwgSSBjYW4ndCBzYXkgdGhhdCBpdCB3b3VsZCB3b3JrIG9yIG5vdCBiZWNhdXNlIEkg
bGFjaw0KPiBrbm93bGVkZ2UgaW4gdGhpcy4NCj4gDQo+ID4gQWRkaW5nIG1vcmUgY29kZSBpbiBi
cmlkZ2UgaW1wYWN0cyBhIGxhcmdlIG51bWJlciBvZiB1c2VycyBvZiBMaW51eCBkaXN0cm9zLg0K
PiA+IEl0IGNyZWF0ZXMgYmxvYXQgYW5kIHBvdGVudGlhbCBzZWN1cml0eSB2dWxuZXJhYmlsaXRp
ZXMuDQoNCkhpLA0KSSBhbHNvIGhhZCB0aGUgc2FtZSBpbml0aWFsIHRob3VnaHQgLSB0aGlzIHJl
YWxseSBkb2Vzbid0IHNlZW0gdG8gYWZmZWN0IHRoZQ0KYnJpZGdlIGluIGFueSB3YXksIGl0J3Mg
b25seSBjb2xsZWN0aW5nIGFuZCB0cmFuc21pdHRpbmcgaW5mb3JtYXRpb24uIEkgZ2V0DQp0aGF0
IHlvdSdkIGxpa2UgdG8gdXNlIHRoZSBicmlkZ2UgYXMgYSBwYXNzdGhyb3VnaCBkZXZpY2UgdG8g
c3dpdGNoZGV2IHRvDQpwcm9ncmFtIHlvdXIgaHcsIGNvdWxkIHlvdSBzaGFyZSB3aGF0IHdvdWxk
IGJlIG9mZmxvYWRlZCBtb3JlIHNwZWNpZmljYWxseSA/DQoNCkFsbCB5b3UgZG8gLSBzbm9vcGlu
ZyBhbmQgYmxvY2tpbmcgdGhlc2UgcGFja2V0cyBjYW4gZWFzaWx5IGJlIGRvbmUgZnJvbSB1c2Vy
LQ0Kc3BhY2Ugd2l0aCB0aGUgaGVscCBvZiBlYnRhYmxlcywgYnV0IHNpbmNlIHdlIG5lZWQgdG8g
aGF2ZSBhIHNvZnR3YXJlDQppbXBsZW1lbnRhdGlvbi9mYWxsYmFjayBvZiBhbnl0aGluZyBiZWlu
ZyBvZmZsb2FkZWQgdmlhIHN3aXRjaGRldiB3ZSBtaWdodCBuZWVkDQp0aGlzIGFmdGVyIGFsbCwg
SSdkIGp1c3QgcHJlZmVyIHRvIHB1c2ggYXMgbXVjaCBhcyBwb3NzaWJsZSB0byB1c2VyLXNwYWNl
Lg0KDQpJIHBsYW4gdG8gcmV2aWV3IHRoZSBpbmRpdmlkdWFsIHBhdGNoZXMgdG9tb3Jyb3cuDQoN
ClRoYW5rcywNCiBOaWsNCg0K
