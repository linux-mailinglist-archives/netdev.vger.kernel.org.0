Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D62A26F533
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIRElq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:41:46 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3797 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIRElq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:41:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f643a5e0000>; Thu, 17 Sep 2020 21:41:02 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 04:41:45 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 04:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeqhWZvC/sVu3/VIMCcn3SwoFIOaTuRkSyEQvno7PPnIbjCFKbU+zPBYSsFuJt50bSNAbq+s6FfantT+ApEqBY/TMUofvC/lH6411pJrUHkP8kBE7tJKKslBMBiAbkdOZ+ow/Hi2h/rjfAdHRZLxu0Q4P9BhE7GkDG+AgM6e9qtZ/PW6tXPXbdx6EE/NrCiIWAwdUckKRAtzbexTeCeSjtshaLbzYjP2/6CyGVWILjoHmdvJCehLVVyKNc5rxUwxeZD+2x1iaMOh6UAzsMtvfFDv4MMljsg+isfSS9VFZM+oVydmcIyOFBUz14ZeLjk7qirxGTbI5McmpBQBEbWT4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yftY7A7/yFzAr65OZQwJlplp5ps7WEWG9hcDHfF7/lY=;
 b=bqDcutvWCQU5gKMbOVvPbQLa04kI3l8ymG6GWEEy+9NiZ72VSl16YPtwNYfizeKQyOl6PTpsbfwwa6hQmQ5M45nGpuLFyTG6MXgumCKm+GNXC89vcp0oU/58j0ko3KZYcWW2ruvQhQMeIWH3x+B2ShzaAVhatzFQK/cpsClnGjRkGSAv5rEmF10waPphS/Zo0RzJhpw0FjosWOq61x9TkVb6z1cZS7P4+dijGz1J0Du9LAdiDqPDrwWSegiFMF4XZcHdva0Wx4EzC8yZni68PdXxM8/iiUw/jUBZLKWf89+0m3x0gliW+ZMEAW4xpWVGwa8mDs+hUl3oiU2XSETs4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2647.namprd12.prod.outlook.com (2603:10b6:a03:6f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.18; Fri, 18 Sep
 2020 04:41:43 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 04:41:43 +0000
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
Thread-Index: AQHWjRbiZXOkBXXnYkS4YkdYcsgPfqltSM4AgABzn/CAAAO2gIAADdQQ
Date:   Fri, 18 Sep 2020 04:41:43 +0000
Message-ID: <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
 <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
In-Reply-To: <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10a143fd-8431-427b-229c-08d85b8d24b2
x-ms-traffictypediagnostic: BYAPR12MB2647:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB26472EF17C630CC167359993DC3F0@BYAPR12MB2647.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FCUG3O8GW/luEGjbVtPRt8LpZ7rXmwtO8GXr/l3BIxlXyM8JE2uZniqID2H3O/3cr0JtkcD+MXWAeNpciHsJyEGwDvwhB0RycfRbe6W0nhcqbN32QFJWQ0Dz76kCIlFoYiAMXTYbw22sStrHh+14Im6HJqOhRCt0MJ8AQrdaHwuJ+8m4Y+2/5VDzdQ9PZ84wH1R6E+h5tKdXWEWpYYKeeCVDOjSb2YH3YObQFveegwE9NhvGS7CRwt4PvNce5wAbFx7SVKpH8pSy3fqQAiS0ktePKYoVrGehiqq1d2Hhn/EsgSWLpoAmmFdgeXegzBRbpqta2e5TQ0zgd1KL2Ld7K4IDrP6n3ebFARN2A/sEEnkjkquvN5+bmdTv1iIfLGifmm4avD4/E+kybaeWePyHDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(186003)(8676002)(4326008)(26005)(86362001)(107886003)(9686003)(966005)(478600001)(110136005)(55016002)(33656002)(71200400001)(55236004)(66556008)(66476007)(66446008)(5660300002)(64756008)(6506007)(76116006)(53546011)(52536014)(8936002)(66946007)(316002)(7696005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1mZ8+eYiiXGpkryyqiMNO7OgVayo53zaHX9y82wvbGjmsBaJWJN2HzLhVc/ZRK/yUdm9n0Qy86hZ+JKCjWi4/7yaSQgJQzJcvHUhFLrkdeMIjGrbL+7IabDD+sz29IIGdlbma6/vb9OthfvKuKOtIR9q5GQTr8pSa6cYybhjF5NwGaRYbHYPQG7kH/Jq3DbdAYG35F09pGWMO83Uq0Z03TQhOy2ovdufxTI2//KnYlv5faYyHJDQBJeOpJctwgHjRJRPUhtm8N2nrj1LrlZjvh3xWyojkrTy2AzfxDVxkqBJsc+gJFm1makJoFQHhyZFp/lqM3a6qEthwmyu7nOUwJ9nTz7jCQxZQRnvRVwdroJIt+FgOD3B7RwGvVuxqYzMkxnxkZS67hJYNbsOzYoLMCVl8S/7w7i3kimBijSjhTfwOX5kxd0BjiWZGcPG1caxDAby6X/xsOxbqYAFUmWjy1OSOwGHWtdjSroBBM/UYKDfsKEbewAGEDJxbOG4q7gFaiJ24qVCe3CHzKFDL5oiYooaQam/hYrmMioEZol4Y11iMlJMMpVFl/BLoLWyxSnk0DU7H03l63I4SlBI+HGRbzluPHrjR38vtrSP8PVX+1q6aPom1KWlAhnqdCF+tqRu4Y4dlkoSyzznw0nfCpKy6g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a143fd-8431-427b-229c-08d85b8d24b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 04:41:43.6478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7oH+Yp2RdS1Wu3PZ5WgZwUskNp+xXzPU0N7fLewCA/XOv0fTvb7rBtsNs1KiWBrryE1Sj0gTAeUt9xm6xO2/Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2647
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600404062; bh=yftY7A7/yFzAr65OZQwJlplp5ps7WEWG9hcDHfF7/lY=;
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
        b=YCDpcT7YgRivz1R9i2c3LsDsmG24DqpdyfVi9uoW+C2qo/jXvQ8No6mxn9ER8Fr3l
         gx69ScyWHBJJ93hwMjrY7GSJDstLHRVOkiu8Jcn1/tuKHHhR6f4sZPFwpAu37ArUeH
         RyYFFofMIA21o5UqNUNnh1jfjlf24r+XjbZ/it4FK15tnuYIruSuF/+Gz71zV5+2gL
         DU18eyB7Jgne+qlqoYm2W5lg0Wnu9Qhe+nFXuDr5S4aWZ4OLVtSMQwdcTYDy0++8Cg
         E1vnCm2WtEFcyK9/WWhhodiWn6N1hrtdnunkOmYbun8/oy4pPZ7zYr1ITyfRKDatWZ
         BiFt5MGBIAkzA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBT
ZW50OiBGcmlkYXksIFNlcHRlbWJlciAxOCwgMjAyMCA5OjA4IEFNDQo+IA0KPiBPbiA5LzE3LzIw
IDk6MjkgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPj4+IEV4YW1wbGVzOg0KPiA+Pj4NCj4g
Pj4+IENyZWF0ZSBhIFBDSSBQRiBhbmQgUENJIFNGIHBvcnQuDQo+ID4+PiAkIGRldmxpbmsgcG9y
dCBhZGQgbmV0ZGV2c2ltL25ldGRldnNpbTEwLzEwIGZsYXZvdXIgcGNpcGYgcGZudW0gMCAkDQo+
ID4+PiBkZXZsaW5rIHBvcnQgYWRkIG5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMSBmbGF2b3VyIHBj
aXNmIHBmbnVtIDANCj4gPj4+IHNmbnVtDQo+ID4+PiA0NCAkIGRldmxpbmsgcG9ydCBzaG93IG5l
dGRldnNpbS9uZXRkZXZzaW0xMC8xMQ0KPiA+Pj4gbmV0ZGV2c2ltL25ldGRldnNpbTEwLzExOiB0
eXBlIGV0aCBuZXRkZXYgZW5pMTBucGYwc2Y0NCBmbGF2b3VyDQo+ID4+PiBwY2lzZg0KPiA+PiBj
b250cm9sbGVyIDAgcGZudW0gMCBzZm51bSA0NCBleHRlcm5hbCB0cnVlIHNwbGl0dGFibGUgZmFs
c2UNCj4gPj4+ICAgZnVuY3Rpb246DQo+ID4+PiAgICAgaHdfYWRkciAwMDowMDowMDowMDowMDow
MCBzdGF0ZSBpbmFjdGl2ZQ0KPiA+Pj4NCj4gPj4+ICQgZGV2bGluayBwb3J0IGZ1bmN0aW9uIHNl
dCBuZXRkZXZzaW0vbmV0ZGV2c2ltMTAvMTEgaHdfYWRkcg0KPiA+Pj4gMDA6MTE6MjI6MzM6NDQ6
NTUgc3RhdGUgYWN0aXZlDQo+ID4+Pg0KPiA+Pj4gJCBkZXZsaW5rIHBvcnQgc2hvdyBuZXRkZXZz
aW0vbmV0ZGV2c2ltMTAvMTEgLWpwIHsNCj4gPj4+ICAgICAicG9ydCI6IHsNCj4gPj4+ICAgICAg
ICAgIm5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMSI6IHsNCj4gPj4+ICAgICAgICAgICAgICJ0eXBl
IjogImV0aCIsDQo+ID4+PiAgICAgICAgICAgICAibmV0ZGV2IjogImVuaTEwbnBmMHNmNDQiLA0K
PiA+Pg0KPiA+PiBJIGNvdWxkIGJlIG1pc3Npbmcgc29tZXRoaW5nLCBidXQgaXQgZG9lcyBub3Qg
c2VlbSBsaWtlIHRoaXMgcGF0Y2gNCj4gPj4gY3JlYXRlcyB0aGUgbmV0ZGV2aWNlIGZvciB0aGUg
c3ViZnVuY3Rpb24uDQo+ID4+DQo+ID4gVGhlIHNmIHBvcnQgY3JlYXRlZCBoZXJlIGlzIHRoZSBl
c3dpdGNoIHBvcnQgd2l0aCBhIHZhbGlkIHN3aXRjaCBpZCBzaW1pbGFyIHRvIFBGDQo+IGFuZCBw
aHlzaWNhbCBwb3J0Lg0KPiA+IFNvIHRoZSBuZXRkZXYgY3JlYXRlZCBpcyB0aGUgcmVwcmVzZW50
b3IgbmV0ZGV2aWNlLg0KPiA+IEl0IGlzIGNyZWF0ZWQgdW5pZm9ybWx5IGZvciBzdWJmdW5jdGlv
biBhbmQgcGYgcG9ydCBmbGF2b3Vycy4NCj4gDQo+IFRvIGJlIGNsZWFyOiBJZiBJIHJ1biB0aGUg
ZGV2bGluayBjb21tYW5kcyB0byBjcmVhdGUgYSBzdWItZnVuY3Rpb24sIGBpcCBsaW5rDQo+IHNo
b3dgIHNob3VsZCBsaXN0IGEgbmV0X2RldmljZSB0aGF0IGNvcnJlc3BvbmRzIHRvIHRoZSBzdWIt
ZnVuY3Rpb24/DQoNCkluIHRoaXMgc2VyaWVzIG9ubHkgcmVwcmVzZW50b3IgbmV0ZGV2aWNlIGNv
cnJlc3BvbmRzIHRvIHN1Yi1mdW5jdGlvbiB3aWxsIGJlIHZpc2libGUgaW4gaXAgbGluayBzaG93
LCBpLmUuIGVuaTEwbnBmMHNmNDQuDQoNCk5ldGRldnNpbSBpcyBvbmx5IHNpbXVsYXRpbmcgdGhl
IGVzd2l0Y2ggc2lkZSBvciBjb250cm9sIHBhdGggYXQgcHJlc2VudCBmb3IgcGYvdmYvc2YgcG9y
dHMuDQpTbyBvdGhlciBlbmQgb2YgdGhpcyBwb3J0IChuZXRkZXZpY2UvcmRtYSBkZXZpY2UvdmRw
YSBkZXZpY2UpIGFyZSBub3QgeWV0IGNyZWF0ZWQuDQoNClN1YmZ1bmN0aW9uIHdpbGwgYmUgYW5j
aG9yZWQgb24gdmlydGJ1cyBkZXNjcmliZWQgaW4gUkZDIFsxXSwgd2hpY2ggaXMgbm90IHlldCBp
bi1rZXJuZWwgeWV0Lg0KR3JlcCBmb3IgImV2ZXJ5IFNGIGEgZGV2aWNlIGlzIGNyZWF0ZWQgb24g
dmlydGJ1cyIgdG8ganVtcCB0byB0aGlzIHBhcnQgb2YgdGhlIGxvbmcgUkZDLg0KDQpbMV0gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjAwNTE5MDkyMjU4LkdGNDY1NUBuYW5vcHN5
Y2hvLw0K
