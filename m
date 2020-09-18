Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33F626F4B9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgIRDau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:30:50 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17695 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIRDat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:30:49 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64298f0000>; Thu, 17 Sep 2020 20:29:19 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 03:30:47 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 03:30:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQt+z2os6xn6xzF4q9IxaTvk1d8cthCbi3Ibg7dOmj78SrHAPzzn6l27/XRBk+muiu/GAi9loqYD18SGA5+12S1vuwg1KpNpSjsnbbeBrnksbtmtLoMqCNMGiNjprfgLuQ6T8wVd5e+GNMDgnlHtCX/8vBjsDPhUNlH5d68Fak19nuwo70SODM3KVKPcuV6vno0YkPGybu5qwz9Z1KyebavMq86anmgTY1xCGs0cpLCz4TXchKTDs3QMAPqEXB37acDfXoVmlSvUibrjT423Zrce2HSIB+Haq3T0fGLiuOrwo3mSOlXSlkwmfko9gMfdjM64hxx8LBYsrfIz0wLzvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfbqoGNbJcxx38eZUQdOq/N542m9G1h9tKaBZSYBJA8=;
 b=DC6AR1syOfIf02I2RQVHaxBc+6ytq3dS6jm60oNaB95OKWqZpdag2FVqVNrcDHFWq4uZj8UNvj+hUjcQKhDJpxTwAT1rrOUk7ZxT4tAHHwOk1CGvQLfsv4lb6d5XrArH4pCDFkDLGxpPEvJWrpcqPtaiRChmONxd+V2chbDtqzzkiSCR+L7wEbu4maZDSckfzZteR5HmnwPsjBmFBW/erFsv2XIY/jf1m2pAAkh8swgVZQlbtDSzOQaMCp+Isg8hXMGhqMis6JFCefbZvYOTo3n5HmmSekj5zz8iHqeL9yyOI4WYVOrVWSfEcfLUwjHxkUuKUSpWINSM8g4IeLDTMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4983.namprd12.prod.outlook.com (2603:10b6:a03:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 03:30:46 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 03:30:46 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 4/8] devlink: Support get and set state of
 port function
Thread-Topic: [PATCH net-next v2 4/8] devlink: Support get and set state of
 port function
Thread-Index: AQHWjRbgnAwI4x+qJkaJMGS9lwX3jaltRr8AgAB3BRA=
Date:   Fri, 18 Sep 2020 03:30:45 +0000
Message-ID: <BY5PR12MB4322ACBFC1F5C2C0CF694BFCDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-5-parav@nvidia.com>
 <88de7791-2a50-64b1-6e3d-5c1a8235eb96@gmail.com>
In-Reply-To: <88de7791-2a50-64b1-6e3d-5c1a8235eb96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e1a8c36-d849-4b74-9bce-08d85b833af4
x-ms-traffictypediagnostic: BYAPR12MB4983:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB498313502BF9BC6A416DBE37DC3F0@BYAPR12MB4983.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JkanR39Xgwf+Qhcivf6C6jLXZvIjauNVKi5+uJ5TWiC9Fo7mZ/at6juzlPtPenB71acUl6DgROO3M4aYjAl0OkDlLvpbDvRMkTIDzv8ZNNutlPKMpu9ppuLSXfZRRtl0HDXvqBc8kXCUJXfgB9TdDsIb+hLI0hUNOh+PJR6rcet28PwhEZsuJmNTFxyi+nK5QLc0Pcu/lRIQVJ3mjCSSZUvE+fpDU6nXp1nrxcvcCp0HQZDe8OEf82AWTOHhcdtmA6R+SYY8BvcvkOwtGbkaiz2AuzlGAnhP+z46hyuxRuTzczArP6BPUO+OlvryGMZPE8n/pEzg6RYgS9qCQo6krw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(76116006)(478600001)(55236004)(55016002)(186003)(83380400001)(107886003)(4326008)(52536014)(86362001)(110136005)(316002)(26005)(9686003)(8936002)(66446008)(66556008)(66476007)(64756008)(66946007)(53546011)(2906002)(6506007)(33656002)(5660300002)(8676002)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: U7mYPmoXYjkOPdOGmE5kUUYgsQedT+cAj404EBjqq5BmsJsg5P74yWCHIvN12nsRY/Sbo66nUWBLXooNk1pT9h3HUbdczZwGc68kZErr/hYke/PtxSqJdtCCqB3stnUq8htCOsM1km+Vfudd2KMBgi1g3m3j6usnKmbCZLGPEcgiDL+ZU4ULrJUzZxvZPVP1jHNnUjck/1yVzRSmDOwrgiBMyEzAkDM0KLHyXPU4mmw7zoxjJWTKxzzPjWxg2p77ZNcaBXwexT23h9HcvZtGlzRO+3rtRRJWwqRG8gcY1LuygRjEJvChpBDVKsE4/oht54lN861ZcCE9nVwuGNyxhPgN8GHeCETetNmIhAU16WCEi+jfsjVxZZqnc9KebUNX0VHjHa6qqYG0pSa2ij8jO9GOdQawJ7N3dnku/gbrlknRwUKAD552FYtJW9IUw6DtMAGuENO7HTH56uislHlWhax3QGAVz9yjX/9KUdyhBEW7O/AeW1yRlXrrHaPWxGyzge+cKJ6BxeYDqNvfm0jGtqZwlRIWzsevvvOFi8q9CAi3e2bhlesAYUn09V+uz6GIctfronswJ+5ThUyROqrfHn3NQ2reEq4ePHLgvZZiqnZlMIzxtTQ3Gvl8otbJHwOf9AnUn+FkkccFvLKGKcQ8qg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1a8c36-d849-4b74-9bce-08d85b833af4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 03:30:45.9105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LI/ybjiUAKMHaOK+C1P9r+J5lCV+ZT9OS4s+iK/6FyMGV/9fFAyyuLt2XBE1HeW7K15o3kqGlYHwp4djnjgq2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4983
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600399759; bh=jfbqoGNbJcxx38eZUQdOq/N542m9G1h9tKaBZSYBJA8=;
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
        b=PnxQsU09KnDk4mPmMjU9ofNYN0GBi6JhOcSkRhxLb60y+Z4KlPwZaqTsmoB0ok4Bu
         w9dJS3hYD60Y2JeNr5kUcIR0Rf8+pNbdwO+BRyCnDn+Wo4OVXdRjo4XLpdKiVvNnKj
         7nXpC0geyWoXmVjLDBi18sqv4lYG4iQLJCIklW1DDv8DAV20suLpPu11Rpd8txwEJd
         2UmEU7EQeTzp0tZsYQORPDTF+7bIkId6x6/eF4NAjsiLN1JPO2Bh5zCH0cHrRa9x5v
         dQP0hQw9aUfhBrinlWVhQURaUgEicSBnqJufFpJ6PPyB8wDjpa7WbcXV3mpmBvg7dH
         5PT4KFTsh42RA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIFNlcHRlbWJlciAxOCwgMjAyMCAxOjU0IEFNDQo+IA0KPiBPbiA5LzE3LzIwIDExOjIwIEFN
LCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldmxpbmsu
YyBiL25ldC9jb3JlL2RldmxpbmsuYyBpbmRleA0KPiA+IGQxNTI0ODllNDhkYS4uYzgyMDk4Y2I3
NWRhIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9jb3JlL2RldmxpbmsuYw0KPiA+ICsrKyBiL25ldC9j
b3JlL2RldmxpbmsuYw0KPiA+IEBAIC01OTUsNiArNTk4LDQwIEBAIGRldmxpbmtfcG9ydF9mdW5j
dGlvbl9od19hZGRyX2ZpbGwoc3RydWN0IGRldmxpbmsNCj4gKmRldmxpbmssIGNvbnN0IHN0cnVj
dCBkZXZsaW5rDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBib29s
IGRldmxpbmtfcG9ydF9mdW5jdGlvbl9zdGF0ZV92YWxpZCh1OCBzdGF0ZSkNCj4gDQo+IHlvdSBo
YXZlIGEgbmFtZWQgZW51bSBzbyB3aHkgbm90ICdlbnVtIGRldmxpbmtfcG9ydF9mdW5jdGlvbl9z
dGF0ZSBzdGF0ZSc/DQo+DQpSaWdodC4gSSBzaG91bGQuIEkgbWlzc2VkIGl0Lg0KV2lsbCBkby4N
CiANCj4gDQo+ID4gK3sNCj4gPiArCXJldHVybiBzdGF0ZSA9PSBERVZMSU5LX1BPUlRfRlVOQ1RJ
T05fU1RBVEVfSU5BQ1RJVkUgfHwNCj4gPiArCSAgICAgICBzdGF0ZSA9PSBERVZMSU5LX1BPUlRf
RlVOQ1RJT05fU1RBVEVfQUNUSVZFOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGRl
dmxpbmtfcG9ydF9mdW5jdGlvbl9zdGF0ZV9maWxsKHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rLCBj
b25zdCBzdHJ1Y3QNCj4gZGV2bGlua19vcHMgKm9wcywNCj4gPiArCQkJCQkgICAgc3RydWN0IGRl
dmxpbmtfcG9ydCAqcG9ydCwgc3RydWN0DQo+IHNrX2J1ZmYgKm1zZywNCj4gPiArCQkJCQkgICAg
c3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrLCBib29sDQo+ICptc2dfdXBkYXRlZCkgew0K
PiA+ICsJZW51bSBkZXZsaW5rX3BvcnRfZnVuY3Rpb25fc3RhdGUgc3RhdGU7DQo+ID4gKwlpbnQg
ZXJyOw0KPiA+ICsNCj4gPiArCWlmICghb3BzLT5wb3J0X2Z1bmN0aW9uX3N0YXRlX2dldCkNCj4g
PiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4gKwllcnIgPSBvcHMtPnBvcnRfZnVuY3Rpb25fc3Rh
dGVfZ2V0KGRldmxpbmssIHBvcnQsICZzdGF0ZSwgZXh0YWNrKTsNCj4gPiArCWlmIChlcnIpIHsN
Cj4gPiArCQlpZiAoZXJyID09IC1FT1BOT1RTVVBQKQ0KPiA+ICsJCQlyZXR1cm4gMDsNCj4gPiAr
CQlyZXR1cm4gZXJyOw0KPiA+ICsJfQ0KPiA+ICsJaWYgKCFkZXZsaW5rX3BvcnRfZnVuY3Rpb25f
c3RhdGVfdmFsaWQoc3RhdGUpKSB7DQo+ID4gKwkJV0FSTl9PTigxKTsNCj4gDQo+IFdBUk5fT05f
T05DRSBhdCBtb3N0Lg0KPiANClllcC4gSSB3aWxsIGNoYW5nZSB0byBXQVJOX09OX09OQ0UuDQo=
