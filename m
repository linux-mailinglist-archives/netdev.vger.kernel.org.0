Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264EF3A13A5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbhFIMCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:02:52 -0400
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:1122
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239688AbhFIMCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 08:02:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f82ZnkdeOTUrR8ugdUxSQVmjWOAX544ko0WqKIl77Fm+C6Hs9jNGBeNdp0C5hs3aQWRVAets8bZfPEmB0ad47sPj4kEPBhvyCi4Yb4Z9RTCVWp4mc54Gw97YmAE6sLax3CNP9+4TJR1Egw6JNphgD+/u+yPD5ySI8hyIAvQtzTvoYNRaKGPl6Bzdp4/EX6SspwaGOzeTTn1hyBBQV/o7koe9j+sBbc6WVtRtwBOqax3Kb0LPKNlU4CfDfXbDqN5evEdtHD7VBAFjcnzpetrcO8T+LxsEbUrod9YDWkvCFRaFXa2k7wbj+FwKdGy8yOnf7DnEHHlazVRgJglEya/bMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J+deXHYLy5tBmk/8UmkV4CevwcKJsuGQfuS/EyiXYc=;
 b=INsEVlp8cthURfI95Rb6Hm+JMkqz0iSxXUxGd3dAq5djKGQ4EGViER4UAw1USVOfD8amrhkYcxzPgxaNSQRxa6/rfd2LHpNvQzFigy+jIAXCP3Ib30YsGa4iqbi8mw3fGQTDp31Wg0OPVkLiD7RfvJlftXKKXjz3kwgkpq8CMtjx2AAVRgxGRRe3u5KIpwgcXYtecy3wWJOZ1cbLHegnUf/46niEck757lgJV1HDqkYZ8ZKjwdmGrsY77DuOKPq3ml494lTjFlgU63wanbGyRId9cww00muatGwPzl7xuB9bBjPWreV1EmaDQrSGcJ2y/njeLgmYqVp7EdzxfxH3pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5J+deXHYLy5tBmk/8UmkV4CevwcKJsuGQfuS/EyiXYc=;
 b=tB4xFBYxJ8zwGuzhstGYVWV47CA+GnNxSIiypPEQoTgbo2LvGihWA3Vl5jy5h1kXbCJQegp+lCjEVp92EN6Umz7M04fmlHXHGawyrsFPRMpojvSa5p+eAVCIeNyoTvFoESidkAEjr5q5mr6lUmp/16u84RwL9ysXZbMlq1Sncp4KXa4/D/DcaYoLZuRyXDkG3z+DJ0LX9z+XkupZ0OV5dGq27VWKx76owPX60s+tUqNsUE8DlU28MrOzw/mxxBqemM+88oEZ52/0A8X9P1P+BTofMrPjJ0BaId+QxEgVnbfdPZ0eh0hRGVt8MYv9rWHf2JgJ/5slBOpc9grbsn5LTQ==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM4PR12MB5309.namprd12.prod.outlook.com (2603:10b6:5:39d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.22; Wed, 9 Jun 2021 12:00:54 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 12:00:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>, Jiri Pirko <jiri@resnulli.us>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Topic: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Index: AQHXVqgtOTo5DdccDUWHkWiFIp83jqr+w2yAgADrK4CAAFDXgIAA7Z8AgAC7xYCAAOyAgIAAfE0AgAEjb4CAA5i/AIABMJGAgAES5oCAAWhkoIAAGvCAgAAL8BA=
Date:   Wed, 9 Jun 2021 12:00:54 +0000
Message-ID: <DM8PR12MB54805046960CB7DA76E095EFDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
 <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
 <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
 <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
 <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
 <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
 <DM8PR12MB54801D7B4FA3A44ECAD4DE2BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <14aed028-b555-bcd3-47fe-bda2da94510b@huawei.com>
In-Reply-To: <14aed028-b555-bcd3-47fe-bda2da94510b@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8e70e41-74d9-47f3-db27-08d92b3e3c44
x-ms-traffictypediagnostic: DM4PR12MB5309:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR12MB530930E3BBFAB127AF51CCC1DC369@DM4PR12MB5309.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: snLcke3ARexh5cFRp8gKSt6jK4Q2DtuM1s1Yc12n7WRbD9+rrO1U9yDw5bIqHOWiDRsLKwpehxG/qsuDL/LpUS8dkwH3zF60E3HZA9x6bxAbOq4S6jBhhOVBu0TgNzJWIDrtlQq2quYoxjB4Y5EqV7oZoddUhSttnCYkUuI2d1LGJcKkuQI+jHsS1RWBFEIo/X0wPrafAFq+geH/ZZWgUZJqPF5hu/LpZTWKpzAbawqJvSgVtQOrkGSfKwtZW4iPTrL4XD/a7+M1UP2s7p+m758kb9mJIGUKcwivEn76Gx652m0uK71+aZddnw5jw+lrNswt5tiryWekLD9v09ScMG19FfiWtM4j8KRitkyA+GtUHTPyx+acYQ0jW3/aaUSczPywS0z2KWpF2klHUyiYxM8bYAa/YkZX/kSDBUNcYgfmjs4WVKad+vmcbXx8qZLa1S2ZNToEtbPpfbrsotyOSMjOH8EN4MpYid7ejSlh1kXw6g4wY6dsQzHhE9uCkxBDUk5KXYMSQgM2yx8LogdcS2g19FVzkcxj37UPiZkk3Ts4vnMAnUb/pX1hlpviJgy/Hl6xh9N9YFaTkWMkv9a4mHCUfp5/5mC1Xr515e8L3nU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(55236004)(76116006)(122000001)(8676002)(66556008)(316002)(66476007)(54906003)(110136005)(478600001)(26005)(4744005)(66946007)(38100700002)(6506007)(7696005)(83380400001)(2906002)(53546011)(33656002)(52536014)(4326008)(5660300002)(86362001)(7416002)(8936002)(55016002)(186003)(64756008)(9686003)(71200400001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk1RVTUzaVJPd25TS2l2V3JSSkE1d1R4SUxVeU5FNXBFYkxNZ1Q3eG9EaTB3?=
 =?utf-8?B?S3NtSDZDN0RVd1ZzZEJwZWl6SzRWcVNidU8waFJwelgrK01GUkVKRkVRRnFt?=
 =?utf-8?B?NlZROHR4WXBWVFRkN2tBS25YZ09NSHRKN0VuOHZaVGpSc3JGbmR1eFExVXFi?=
 =?utf-8?B?WHA3UlBsU2Q0SDBPbTloQitqVmFCcVQ5UXZNWDNjWm5GeWRHN2tDeVhDY3Bx?=
 =?utf-8?B?L0ZwQW95UnBRSTVVaDMvNlBUeUJLcFdXMUNlcUpHZ3RzS3M5SU5jWXFEaytI?=
 =?utf-8?B?dHZTNE0yV0tPR05PR0NIczRKT0F0YnF2NlJRNmJjK1djRC9DMDh3dExCWHJV?=
 =?utf-8?B?OGdDckhBWVlqbTZsSTNUT0ova1hFTlp2NFZCdTJiMGVMRHdNcHFnY0JYN0I0?=
 =?utf-8?B?VkI2L1FacGNQOGwwb1MwRVhEVG5hZ0pTZUlkU3FWTERILzY1V01xaDR0dFdD?=
 =?utf-8?B?L1orZDJacG1ML0gyQ0NuaXVmeW1iOG5tL2NPMVRHWDJUV3hnZTNCREozNFBL?=
 =?utf-8?B?S09OMWtObUgvNUtzYmlGR1ZiQXdMRXZ5S1cvWG1mVHpmay9ROG1UbE1ubVY0?=
 =?utf-8?B?T2NJMXhjM293OGVUVDZoOWppZTIxZDJuSFlaRHI5Y1VwSnFud3dvUDdPK2xm?=
 =?utf-8?B?L2JmZ0RINTdhM2RCQkhKUHIyNWM3a20vRzFzNzJuQjVVQ29KL2VwUUdQb2RK?=
 =?utf-8?B?aG5DZGNpWlFlQVkwTytRS3poMzJsUkFpZE1lNU81RC9WbU1FVEMxbHluTXNR?=
 =?utf-8?B?ZXpVK2Y5ZXRZOXY3QzZhcXpXLzlMK3I0N3huVGVEV2lrTko2YkFjMGozRGRx?=
 =?utf-8?B?eU5wc3R3ZE5LZTB5OWhWVnFXMVZ2cUJIWG0yYk9oK2p2MDBxdnlEdDMycVJG?=
 =?utf-8?B?TUpZL2tOdW5SSFlvNS90NitnTUVYdjh1Yk83dnM2NHdIYWg2L3g3NEt4UDFv?=
 =?utf-8?B?YWsrcDQyOGVEaFZpeHBxdGFvbGNyeDRaUTJoNmZqR1kwUlZPQnpydU5sVzRu?=
 =?utf-8?B?S2NWbVhCa3dacURYVjc2WmhpTFlyb3RBMEhUb0h2bUhsUEdENXVpaFV1bVdW?=
 =?utf-8?B?RW4zVjhEYlRrVDlSc1BnMmZqVmN2R1ZwU2RKclZFUkptblpaZ2I4blJjVTQ5?=
 =?utf-8?B?QkpCYzVtd2VCbXJPVUZsQXphOTBJcEFURGc5VXo5YlVDbDJrREw0ejFQQzBE?=
 =?utf-8?B?TmxldllIcDUrRGZ2V24vVGFXQlpTNS9sNlp5Y3A5Q256UHlOakZKNlpKcWhJ?=
 =?utf-8?B?U2ovQnNQeGVrVUFUcE1keEZIK0dtYVBDeGZtaGZnUGNCVG1BcElZdzlkQ0pG?=
 =?utf-8?B?d0pDZnhzek9zY2lCQ3J6eHQ4di9XS2xhQ1pDQWs0bENDOXJ5djBKWUNZVkFv?=
 =?utf-8?B?dGtnak9qOVdqRmhZMUYzZ2k5SzZqZkpqT2FOUVNDSVpnRHpyMllHWmh4VGNw?=
 =?utf-8?B?dUZqd1pmY21teklZNXhvQVd0a2YvWGYrdzM4L2Q2cTFDcWlYb2VIQWwzNXVF?=
 =?utf-8?B?c00zbVl2K0FHMHd6aHhlUGh1ejVUeDRIRXp1Z1ZRd2VDUWxWQ3pRVDNpY01L?=
 =?utf-8?B?WXVqWEZJdzRzVG5JQlFUL05ZeURVVm9nL1ZMU1psV3lPLzg1Yk9ncGhVWXJm?=
 =?utf-8?B?M1N6WEtKRlg1b1VDd0N3dmFKSkt5eEd4eTVCcEtqZ2VpNjZKL3Q5cFg0YkNU?=
 =?utf-8?B?MVF3SThpZUZhelBvbS9KQUR5R1l2b1ZVeVUwMjZIeG4zNXlYa09KUm1xYXJv?=
 =?utf-8?Q?3fIK8lsvRpmU3ShZprxQtkOez4i3mcJZYit25Bk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e70e41-74d9-47f3-db27-08d92b3e3c44
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 12:00:54.7095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGWOW97/NiegPbyjkWdZ/yjFZbzmhsWd0vVHDb6TuyRZwh65HNsYimb8tXVZCMDsK7U6dy6aqv2z0PGuRE4NhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5309
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIEp1bmUgOSwgMjAyMSA0OjQ3IFBNDQo+IA0KPiBPbiAyMDIxLzYvOSAxNzo1
MiwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+DQo+ID4+IEZyb206IFl1bnNoZW5nIExpbiA8bGlu
eXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gPj4gU2VudDogVHVlc2RheSwgSnVuZSA4LCAyMDIxIDU6
NDEgUE0NCj4gPg0KPiA+Pg0KPiA+PiBJcyB0aGVyZSBhbnkgcmVhc29uIHdoeSBWRiB1c2UgaXRz
IG93biBkZXZsaW5rIGluc3RhbmNlPw0KPiA+IEJlY2F1c2UgZGV2bGluayBpbnN0YW5jZSBnaXZl
cyB0aGUgYWJpbGl0eSBmb3IgdGhlIFZGIGFuZCBTRiB0byBjb250cm9sIGl0c2VsZi4NCj4gPiAo
YSkgZGV2aWNlIHBhcmFtZXRlcnMgKGRldmxpbmsgZGV2IHBhcmFtIHNob3cpDQo+ID4gKGIpIHJl
c291cmNlcyBvZiB0aGUgZGV2aWNlDQo+ID4gKGMpIGhlYWx0aCByZXBvcnRlcnMNCj4gPiAoZCkg
cmVsb2FkIGluIG5ldCBucw0KPiA+DQo+ID4gVGhlcmUga25vYnMgKGEpIHRvIChjKSBldGMgYXJl
IG5vdCBmb3IgdGhlIGh5cGVydmlzb3IgdG8gY29udHJvbC4gVGhlc2UgYXJlDQo+IG1haW5seSBm
b3IgdGhlIFZGL1NGIHVzZXJzIHRvIG1hbmFnZSBpdHMgb3duIGRldmljZS4NCj4gDQo+IERvIHdl
IG5lZWQgdG8gZGlzYWJsZSB1c2VyIGZyb20gY2hhbmdpbmcgdGhlIG5ldCBucyBpbiBhIGNvbnRh
aW5lcj8NCkl0IGlzIG5vdCB0aGUgcm9sZSBvZiB0aGUgaHcvdmVuZG9yIGRyaXZlciB0byBkaXNh
YmxlIGl0Lg0KUHJvY2VzcyBjYXBhYmlsaXRpZXMgc3VjaCBhcyBORVRfQURNSU4gZXRjIHRha2Ug
Y2FyZSBvZiBpdC4NCg==
