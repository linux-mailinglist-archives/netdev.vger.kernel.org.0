Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B6A2F0738
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbhAJMgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:36:07 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:52809 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbhAJMgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 07:36:05 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffaf48c0000>; Sun, 10 Jan 2021 20:35:24 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 10 Jan
 2021 12:35:24 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 10 Jan 2021 12:35:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQn/7KGUIDlomi33diaDb2oEZfhpFXo1FJiRFtWWGp++0k2nLvQbzBld9I7eT+DI5LeSJ2f6hqnx5Wz7sfFOMyRKR1IJCPjLwCRZrwIfeoWecd8D3aEunke2kTj1U+zZ+WJSc2bnsULAxp/Sdz1RcjpjqNhn0rwvV1zI8S79JJ+bKEZ+/3JV9aukCQdSfJ1wjyGgTDyrPxA3le04YrsHZ43snYAvvOkAgUqR3Na5dcQMkIkG1HnUYD1XUZ5eEPV/0APWq5m3M/uOjIkygotp2ZYioUHVgwQbzLAeu78nDTnpyR3L55vMgkgQD1eu0cSIpXvCMYwoIYxSvcVGxGSdmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojRDzZuoUrdys415/+gG6WDBgs9uCjYFxnBCLPtSjVg=;
 b=RhxaWixHD5cdKRJmB4ufJc/pqmjzV0+9j9EcScQj3x6D+2Dni9RbBJ9Mf+j1uqIsmCi8CtmGXDr/pb/3+Js1reP5AQ6rkYKoCFK7egU6kYGi8w/x315Q7xys7HZmv5aR7uLIE1D3JPl7mrgPFH/W5+VkSRwrBLYseP8Ksh819CxDH9BwCYIdfhvtFWM3CyIFYV9whlmmFwQ3dR3v6M1cTGbzSnuognKysPa7SItnfs76oF9HE+R41LGUCWAQqPtzcRtZ70Yg+Q0wkg6YTXYo1JYc25aPV1qYyDT5ElNyjhLzhS++4rh313mJE/BW+7Y/Gx/Gswez/Z+oMw7UqmY0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM5PR12MB1450.namprd12.prod.outlook.com (2603:10b6:4:3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Sun, 10 Jan 2021 12:35:21 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 12:35:21 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Danielle Ratson <danieller@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next repost v2 7/7] net: selftests: Add lanes setting
 test
Thread-Topic: [PATCH net-next repost v2 7/7] net: selftests: Add lanes setting
 test
Thread-Index: AQHW5CzhTmf5Zg1lNE+puQzO9c+Iwaoc5qcAgAPDqKA=
Date:   Sun, 10 Jan 2021 12:35:21 +0000
Message-ID: <DM6PR12MB451649B1570518686AB1EF79D8AC0@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
        <20210106130622.2110387-8-danieller@mellanox.com>
 <20210107164504.4a07de2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107164504.4a07de2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b25ba58-90e6-4f53-5b49-08d8b56431ed
x-ms-traffictypediagnostic: DM5PR12MB1450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB145034A0FDD258AE002F10A3D8AC0@DM5PR12MB1450.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kIHZ09jXMQnHz3blDwN8moMOMP2rQLEXU7mvToWUUpFUpqLs3zgMnvwIyBvFwTp9sVc0PUUHgBE5X930rWvf3SiEsVp2k8Bk9Iu2CZDVu9ZGRNIPiirZ2akqhpmhnmw96HVcYExqGl0vznfH9roHo/yIvlgR8unbzi3Q/HBxKPyD8i32fLp88drbv0obBRFs17/1Ly7yx5+n8y9DfPqPuQhhOkFet6EUBz7FeEqukzRDvri3t0XpdavgISXWPZrsxCw0MWuGSXAmzPRSTNkVphwXaom1iUuBQbh62rMwY0zvQv48El2EeBE6+ENhd7+NMB2BkVGR1WEV53V0qsur094Sb4B7WJ2JmAh9YavNWI0qM5h4I3tmGIPLphGG5qkzxJVqX7+P5ijglFLgPDugbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(55016002)(4744005)(71200400001)(9686003)(107886003)(7696005)(26005)(66476007)(53546011)(186003)(6506007)(83380400001)(86362001)(478600001)(4326008)(52536014)(8676002)(33656002)(66556008)(66446008)(5660300002)(66946007)(2906002)(8936002)(64756008)(76116006)(316002)(110136005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QVRUczM3RjJ4c1JLZVBab3liY042dkFLU3QyRWIxNEd1SkRPa2xaZVFxakxn?=
 =?utf-8?B?MUlhemI5VE9zNEdBNG5sUE1SVDh6R3RwVXF0czZMbUNLTW5SbEFaTTM2Zisw?=
 =?utf-8?B?R281Yitwdk1obUVGemFocmlDUWE0SW9yRU53dXFQVDA3Z1lmdWwwZWpFZUJi?=
 =?utf-8?B?ZU1nU3pMeTFwcFU5MHhLK21wUlQvTzJyYm9WQmdGRkttellmbHAxdE5pV1l4?=
 =?utf-8?B?OG5iVHZsYndYUTRJaDFSQ2JjdFlEMlJKWGR6b0pBeG5DZnNmSkl2YmxyNmpn?=
 =?utf-8?B?ZE53QU5lZFpIc1AxVnV1QzYyYlJEL0MvUjlMRUJaSkFsdDMvNFA2Q1hnK05j?=
 =?utf-8?B?bHduTEdBRmpiRkxXQUkydTlhQmFGbUF3RTkxZ3d0bXZibVdIUUM2RW9ZbC85?=
 =?utf-8?B?Z28zRHZUTUJLVm05NEkvV3JsWHA5KzVNVTJIa3h3TytnRlptcDBYNW9kWjRx?=
 =?utf-8?B?amJiWGhUWGdVZDVYVU43dTBjS1BtYmg0RG5mRUxKZHhzMngrMzMrRVFtQVVM?=
 =?utf-8?B?WXYvQXpCUVpCQm5OaVFtUUFOMG92ZGNOZ2xuVit4Wjd6L3BGTm9uUWpyOTZv?=
 =?utf-8?B?TWYyS0U4RVpBeFdTRjFhUXBHbGN1bzRzZHJORDM4YWhxQ01HU0Z5d3RodHA4?=
 =?utf-8?B?ZVAwWktybHExZGpURm5zRFh0Mnc0LzQyUzQzZHZhT3NaY0lqRFpKUTI1aktW?=
 =?utf-8?B?dHhZUFNBZzlSSmZHWlozM1l2QUNTelJINWE5N3lRSDdvTituTlZBZlhsL2ov?=
 =?utf-8?B?MU1DaU44MWpoM2tlaVNJNkl4OEhDWGNUcHdXbENUOXZpSzhKaE5RVytuUERj?=
 =?utf-8?B?YkdjUkxBcDAzV1h0WGN0UU9DRndCK3BBRDNMVlpTbVp5WHd6UUZDVDFZaWZT?=
 =?utf-8?B?bU0yUitOTmJESjE2WDFyNkhJUWpMU05FODdIMWxQZndldzM4WmdxZ1RLTjNj?=
 =?utf-8?B?YSsranRoazVQem1TZTZRV1dPMHgxbjlJYVFialRmWElNZVVHaVZIaWpZeC9T?=
 =?utf-8?B?ajhpQVVDc1NYVmJZczhqbHJnVzE5NklOaDlscDZ3VGJKTzF1UjNraEFBcDNI?=
 =?utf-8?B?cUFPcDRzS0dkVytCYXhsMWtMMXlMakZQMjRmcXNBVmFpSkE0b1dEY0dWdTZD?=
 =?utf-8?B?emZPQUdCWGx3Z0REQ2tkWk9Ec1VWVHdTWjk1czlZYkVmaG5Ga1U0QmlFMWY1?=
 =?utf-8?B?aXZlUkhWcXhidExtRGxSV1BISmZwUDJKdWoyYk9kV2tZa2U5SEVSMElsWG1k?=
 =?utf-8?B?R3R5NUN4QjBjcVNMVVBFNmFJYjZYSm1ENGc0MDFJOTEvVWJXakRXN0daM0Fr?=
 =?utf-8?Q?Kp2wVQipg1q7U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b25ba58-90e6-4f53-5b49-08d8b56431ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 12:35:21.1264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dc+1RdFR0yBzo3nF1apR9vM7sqayr0e2sR1wMOSXuQlFKsyHeLxC9YP62peDxfzklmbZA+X6QmddExPi6zEiFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1450
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610282124; bh=ojRDzZuoUrdys415/+gG6WDBgs9uCjYFxnBCLPtSjVg=;
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
        b=bZz3XG9Q8zBm1AGFwgvmKBNwgx5qoTUqGlduSdAUXVRyZEjFC9mKAL09jfz9sBd4S
         ct9lk60Lq8q2h+W118xUVBWNTDQxGD6wTvDNVaJhQluOFvCGZwJBBc4X4wMIzBAl3V
         EpYzmIrdUGLPQLGyt26Hcz2V9DW6XBJQDsH967w+yuk+ZjHcJM94G++AddxYSsZA6Z
         Ra7nlkfiOTUzFD08xvFwVlSrCLkdfXmCREuq/jAxz+W/e7Pq9ko+ggJn9P13l8VGPJ
         Zk68iLzN1cHZZCNMMy43p9GGIa+0JRWLogt/fpMugnDu0rNBQdsQ2KEHIjZwGLQLYJ
         jELZYXXUA6XgQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIEphbnVhcnkgOCwgMjAyMSAyOjQ1IEFNDQo+
IFRvOiBEYW5pZWxsZSBSYXRzb24gPGRhbmllbGxlckBtZWxsYW5veC5jb20+DQo+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBKaXJpIFBpcmtvIDxqaXJp
QG52aWRpYS5jb20+OyBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IG1r
dWJlY2VrQHN1c2UuY3o7IG1seHN3IDxtbHhzd0BudmlkaWEuY29tPjsgSWRvIFNjaGltbWVsIDxp
ZG9zY2hAbnZpZGlhLmNvbT47IERhbmllbGxlIFJhdHNvbiA8ZGFuaWVsbGVyQG52aWRpYS5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgcmVwb3N0IHYyIDcvN10gbmV0OiBzZWxm
dGVzdHM6IEFkZCBsYW5lcyBzZXR0aW5nIHRlc3QNCj4gDQo+IE9uIFdlZCwgIDYgSmFuIDIwMjEg
MTU6MDY6MjIgKzAyMDAgRGFuaWVsbGUgUmF0c29uIHdyb3RlOg0KPiA+ICAuLi4vc2VsZnRlc3Rz
L25ldC9mb3J3YXJkaW5nL2V0aHRvb2xfbGFuZXMuc2ggfCAxODYgKysrKysrKysrKysrKysrKysr
DQo+ID4gIC4uLi9zZWxmdGVzdHMvbmV0L2ZvcndhcmRpbmcvZXRodG9vbF9saWIuc2ggICB8ICAz
NCArKysrDQo+ID4gIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL25ldC9mb3J3YXJkaW5nL2xpYi5z
aCB8ICAyOCArKysNCj4gDQo+IFdoeSBpcyBldGh0b29sX2xhbmVzIHRlc3QgZ2V0dGluZyBhZGRl
ZCB0byBuZXQvZm9yd2FyZGluZz8g8J+klA0KDQpJIGFkZGVkIHRvIHRoZSBzYW1lIHBsYWNlIHRo
YXQgYWxsIHRoZSBldGh0b29sIHRlc3RzIGFyZSBpbiwgaWxsIG1vdmUgaXQgdG8gZHJpdmVycy9u
ZXQvbWx4c3csIHRoYW5rcy4NCg==
