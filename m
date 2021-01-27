Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4EE305AC3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbhA0MFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:05:55 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8794 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbhA0MCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 07:02:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601156150002>; Wed, 27 Jan 2021 04:01:25 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 12:01:24 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 11:46:19 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 11:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibWliwB/Zkar0TmP4qUh3wrB6Xgmyd2kBo5j3a/f013kyPKc+R+3kO5CyZ3jMEGJ8lPVzb9vt5PkieZBspwLuH5e5rQwEgKKSzNFijqDsgrBZ1g4kFGlHtMHbWRJunUzlpWApGhU8pB+NhtRi94xtQzYtv1UNpj5VANpwPZMLjs1PKqpepm/IuLsRrGiL7LduFjp5zK/NsAexQKnUgvJQ8NAb20jetl781JB+pXmfoe3awZF95OBbpRc9nCQIfayv4S1IAOlHZZ4zmQzf5UTsV4/MS2sIVKV1gu85Vc6oeSBLjQytvO3727HVFbnWbi7AMeAAEicap0WJ5e9NI1emA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3VbMXGTN+WzdL1opF3NEADXQJ+6xKA0ORpYUoLepkg=;
 b=JiycDUUMHc+TK9XtyucLSPrNfrVz5pirF8DtbZMjbOEBuFPHUJvg/PBeNtV8bXcEQKUYCCodt4GvqxiIzsqDZiZSgiLnJWaSvMO8cCXJIgHLgKxUv0JsVjQXvtg5O9Ojv+JVUSdjpNSi+PS+t4HVLXaguPjIqr6WH8fT9iZHFHYXDZ0Dxeg784EM6dDMQvhAUNFoOrQUACBqVW9kuaD2zrI4PoWnV/1WvzaOdz7dr+AEHpDP+S9hut4oKs54kN/ElRvu37nPtLtNjHArIU8Vwp7GHTUF5v2HGEruUfMwpPQ5qC0EqwGhzbfuWBwqMJxSZyrb8UDkNWRlv0PzZK/4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3066.namprd12.prod.outlook.com (2603:10b6:5:11a::20)
 by DM5PR12MB1195.namprd12.prod.outlook.com (2603:10b6:3:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 27 Jan
 2021 11:46:17 +0000
Received: from DM6PR12MB3066.namprd12.prod.outlook.com
 ([fe80::38ce:fe85:48ce:51a2]) by DM6PR12MB3066.namprd12.prod.outlook.com
 ([fe80::38ce:fe85:48ce:51a2%6]) with mapi id 15.20.3784.017; Wed, 27 Jan 2021
 11:46:17 +0000
From:   Amit Cohen <amcohen@nvidia.com>
To:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Donald Sharp <sharpd@nvidia.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
Thread-Topic: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
Thread-Index: AQHW8+aawNgF4jESA0au0imTpS07+6o664UAgABrSjA=
Date:   Wed, 27 Jan 2021 11:46:16 +0000
Message-ID: <DM6PR12MB3066D520C69BEF9BB15DE35CCBBB9@DM6PR12MB3066.namprd12.prod.outlook.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-6-idosch@idosch.org>
 <79194116-6d96-eb13-c845-b5d268df7a82@gmail.com>
In-Reply-To: <79194116-6d96-eb13-c845-b5d268df7a82@gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7d7bf96-41b3-488b-2d94-08d8c2b92819
x-ms-traffictypediagnostic: DM5PR12MB1195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1195E45438218C68450936DFCBBB9@DM5PR12MB1195.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bJLPQrhIt1NhQHuTxrOWiYi7u2VvHNi05DgR3cy4Y7l6J1BNYxwBVz/V1xmzOJCq1TUzHR8G/2A4O5/k0C/kr57CIQTA9nYA7NYoWFU+E5PWNNm3BoZ8XfWGYY0pSv2r3KujslK3hOg+Gx4/szAs4q9u7uEBw15K5ThvBL/1JVR0ynsTIN0csErMHjs2D00fGJ7dyN+qDMF+Yn5Bw7JnC5sycsK/LHtmtDXNI4Zx7chi3w2Y6vSi1exZwZi+FES6jOfKNa8MF6HTH/SUkxoulEwzHxIdEoXy2gSwpT7Ww7J1InKho2RbG7L3Xwr1dR4Y8GJcddl+J60oCE4m0/nUXW2fN1medN+sFL1kRK1S2AH6rYNjnSY7gDlm+Ypes0bp5ruwio00dvTqu8PITPKrfbYLXvm4C0Seh186FTN+xwIVfp4/dU4+1cj9/4/bN63/Ns0hqYfCk+f3wMR1qBS0hPjcl87Ay4W07Ki9N+2gEyTbKCRFyvyiCYaelxidA+tTc4m5uQafNE6orNAiEhKUew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(76116006)(66946007)(8936002)(66556008)(66476007)(110136005)(7696005)(6506007)(86362001)(66446008)(4326008)(54906003)(64756008)(186003)(71200400001)(8676002)(2906002)(26005)(83380400001)(33656002)(15650500001)(478600001)(316002)(5660300002)(107886003)(55016002)(52536014)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dTMyamdKT0tkeUtoeHNKdkRVSndoL2tqM2ZCMXo2TTA1OFlSYmdmU3YvZlQ5?=
 =?utf-8?B?blVKbDMyZlVWSXdJTEZ6amFwZE0rNVFFR3RSZzVNc2xSS1ltMjArRlJRNnBY?=
 =?utf-8?B?VXI1S2c1WGlKQW1GYy9ZaTZOUmRxNUx6QXlWZFQ1WGJFSms4bmk5eE16enVw?=
 =?utf-8?B?VUZaVVNPTDl5QThKKzNWbGxxcXBrYUk3eGYyaWUrbGxNYmlZZkUvZ0lWVXRz?=
 =?utf-8?B?MUEwdHJyZWo4dmxwSlNnZWNXeFVPayszUGlUTmtneFNERTM2b1RncVJSS3VW?=
 =?utf-8?B?ZkJQTGZsTDlDeDdGNzltaVMzdVFNdmdjRjZ3cWkzT1M1Yk4ydEg2ZHhVQUtN?=
 =?utf-8?B?ajI0L0NKZzUvRHBZMnBxcWduSGNpTVJMUmRGWC8xRFNucWlweXV3UHlPOHdh?=
 =?utf-8?B?RzNJditKcGtDSEJFWTIxY2dnQ0NWamYxU1BFZEpaTFZGN0hRZ1IyZkl4ZjBa?=
 =?utf-8?B?NzN3WEpVRzJpNW1wL1lNcnBoTGVzNTB5WXJMK2pRYzQxZWk5SER1ZmZ5WGJv?=
 =?utf-8?B?L3FPN2VxS0ZiclNZV05SVlJoQ21YVnpwZWpBZW0rMy90bll4T2dQT01aZzB0?=
 =?utf-8?B?QkJNV2RQcjhSNHNmNEpabllJYm1KaTRjdXIzUUhZYWQyZUFpTFZUc0hsQkhY?=
 =?utf-8?B?Q3NvUFIxQXNPaDNwZUZSb09GbGJKTy9UanFEVnp1WERsMWdxd01DYWJpb1pi?=
 =?utf-8?B?YmdYUEdEbzlUL2lpS3RYaVZXeFFqRDkrL0pvTEZDL2NNMDVCL0ZOY2JDZkZy?=
 =?utf-8?B?TjVXbmx1MXRtRzBBZy9ZbFFLd05YZmR2bENpMjB2dmNmWVQ3ckdjbERZWVFJ?=
 =?utf-8?B?Yk13WS94bHZwYnFvVzByamJTRkdqRFQzdEc2aTQxbGM4My92cVhoSk1pKzIw?=
 =?utf-8?B?c1RQL0s5N3lhc1VpdXgweU54REMwZ1I1UFBEcUVuNENSaWN6RTNVWTErQWRj?=
 =?utf-8?B?YkJReHRQVmEwZDMvcWFEZGdsSzB5TW5hV0x4bUhFN1QxUnJXYStQa0pPM3dR?=
 =?utf-8?B?R2hZMkRPaDZ5YWRSYTV6MHhqeUtid2l6ZHdmSzRzTzB1OURRQ2VTazl1ZmVi?=
 =?utf-8?B?TzVFbVAwd3JIb2RZZjZIMFludm5xaWEzYUxLSVN4NW16NzI5ZVJ5b3ZGaXB0?=
 =?utf-8?B?azNIdzVxakg3VlZvaEpQK294d0UrbGFBdDNxYi9QVTEwQTFRTFBJY253cm9C?=
 =?utf-8?B?OC9WWHRIVk91TlNodTRPTGZrTklrMHdwbkhTTWJHRExXbjVWQ0RBenRjdXUr?=
 =?utf-8?B?bDB2aEtwY1FWTE9xNTJKVzNzTTIwTUp6ekNSVGM3UmFXQ3lXcDJYYVQ3aHFw?=
 =?utf-8?B?UGo0NkgvOFp3Mi9EL2FJUWh3WkJVaGxMUU56QmI2cXR5bjlGOHVHM2g5V0JK?=
 =?utf-8?B?YjQzZUgydWpqbjg4SkZ4a1Q5TnN2T1o2V1RGUHBMOWNBUDV0Z1NvV1E5Y2xI?=
 =?utf-8?Q?9IQydGF8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7d7bf96-41b3-488b-2d94-08d8c2b92819
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 11:46:16.8923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PIn5vB2zPQWwiUU+/3KhAbt8orJ3V2IGEkdEK0DCtw6uWZIfdLnU+Cy22ol05ZBd4p/HIMM1gvJPdVeMNtoBLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1195
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611748885; bh=F3VbMXGTN+WzdL1opF3NEADXQJ+6xKA0ORpYUoLepkg=;
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
        b=S+cgYVTCP+aPUuU64PYzB06i0jEYzbCkn0Y5WIuCT/W3A+CoJeVOm57XvEIBndVpG
         mEt5pePH65HP6jGDDd4ufw/etN9F6+BcSUBMP//FmpdlIqYZV6mQZhzw1HYoS/cbI3
         lbudvv6QfBLy9qb1SIDdVONIF/t7CblHhz3irZkgWxB/IHtBBwSPY7fmKGtotecZO3
         5SMihC8Y3LhKCR2hBGh+SEm7AHEB+r+VjCmoE0Ztuuf8+0vk8MxZGZDUstGetVhr4C
         oVmaJ2tgS/Mm9EKGgrdIvR7COy8qlrpY4fsdvZPP/m287JgSzpspSR7pm10nWGBEoF
         37bj9ozTde2qg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IERhdmlkIEFoZXJuIDxkc2Fo
ZXJuQGdtYWlsLmNvbT4NCj5TZW50OiBXZWRuZXNkYXksIEphbnVhcnkgMjcsIDIwMjEgNzowMw0K
PlRvOiBJZG8gU2NoaW1tZWwgPGlkb3NjaEBpZG9zY2gub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPkNjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IEFtaXQgQ29o
ZW4gPGFtY29oZW5AbnZpZGlhLmNvbT47IFJvb3BhIFByYWJodSA8cm9vcGFAbnZpZGlhLmNvbT47
IERvbmFsZA0KPlNoYXJwIDxzaGFycGRAbnZpZGlhLmNvbT47IEJlbmphbWluIFBvaXJpZXIgPGJw
b2lyaWVyQG52aWRpYS5jb20+OyBtbHhzdyA8bWx4c3dAbnZpZGlhLmNvbT47IElkbyBTY2hpbW1l
bA0KPjxpZG9zY2hAbnZpZGlhLmNvbT4NCj5TdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDA1
LzEwXSBuZXQ6IGlwdjQ6IEVtaXQgbm90aWZpY2F0aW9uIHdoZW4gZmliIGhhcmR3YXJlIGZsYWdz
IGFyZSBjaGFuZ2VkDQo+DQo+T24gMS8yNi8yMSA2OjIzIEFNLCBJZG8gU2NoaW1tZWwgd3JvdGU6
DQo+PiBGcm9tOiBBbWl0IENvaGVuIDxhbWNvaGVuQG52aWRpYS5jb20+DQo+Pg0KPj4gQWZ0ZXIg
aW5zdGFsbGluZyBhIHJvdXRlIHRvIHRoZSBrZXJuZWwsIHVzZXIgc3BhY2UgcmVjZWl2ZXMgYW4N
Cj4+IGFja25vd2xlZGdtZW50LCB3aGljaCBtZWFucyB0aGUgcm91dGUgd2FzIGluc3RhbGxlZCBp
biB0aGUga2VybmVsLCBidXQNCj4+IG5vdCBuZWNlc3NhcmlseSBpbiBoYXJkd2FyZS4NCj4+DQo+
PiBUaGUgYXN5bmNocm9ub3VzIG5hdHVyZSBvZiByb3V0ZSBpbnN0YWxsYXRpb24gaW4gaGFyZHdh
cmUgY2FuIGxlYWQgdG8NCj4+IGEgcm91dGluZyBkYWVtb24gYWR2ZXJ0aXNpbmcgYSByb3V0ZSBi
ZWZvcmUgaXQgd2FzIGFjdHVhbGx5IGluc3RhbGxlZA0KPj4gaW4gaGFyZHdhcmUuIFRoaXMgY2Fu
IHJlc3VsdCBpbiBwYWNrZXQgbG9zcyBvciBtaXMtcm91dGVkIHBhY2tldHMNCj4+IHVudGlsIHRo
ZSByb3V0ZSBpcyBpbnN0YWxsZWQgaW4gaGFyZHdhcmUuDQo+Pg0KPj4gSXQgaXMgYWxzbyBwb3Nz
aWJsZSBmb3IgYSByb3V0ZSBhbHJlYWR5IGluc3RhbGxlZCBpbiBoYXJkd2FyZSB0bw0KPj4gY2hh
bmdlIGl0cyBhY3Rpb24gYW5kIHRoZXJlZm9yZSBpdHMgZmxhZ3MuIEZvciBleGFtcGxlLCBhIGhv
c3Qgcm91dGUNCj4+IHRoYXQgaXMgdHJhcHBpbmcgcGFja2V0cyBjYW4gYmUgInByb21vdGVkIiB0
byBwZXJmb3JtIGRlY2Fwc3VsYXRpb24NCj4+IGZvbGxvd2luZyB0aGUgaW5zdGFsbGF0aW9uIG9m
IGFuIElQaW5JUC9WWExBTiB0dW5uZWwuDQo+Pg0KPj4gRW1pdCBSVE1fTkVXUk9VVEUgbm90aWZp
Y2F0aW9ucyB3aGVuZXZlciBSVE1fRl9PRkZMT0FEL1JUTV9GX1RSQVANCj4+IGZsYWdzIGFyZSBj
aGFuZ2VkLiBUaGUgYWltIGlzIHRvIHByb3ZpZGUgYW4gaW5kaWNhdGlvbiB0byB1c2VyLXNwYWNl
DQo+PiAoZS5nLiwgcm91dGluZyBkYWVtb25zKSBhYm91dCB0aGUgc3RhdGUgb2YgdGhlIHJvdXRl
IGluIGhhcmR3YXJlLg0KPj4NCj4+IEludHJvZHVjZSBhIHN5c2N0bCB0aGF0IGNvbnRyb2xzIHRo
aXMgYmVoYXZpb3IuDQo+Pg0KPj4gS2VlcCB0aGUgZGVmYXVsdCB2YWx1ZSBhdCAwIChpLmUuLCBk
byBub3QgZW1pdCBub3RpZmljYXRpb25zKSBmb3INCj4+IHNldmVyYWwNCj4+IHJlYXNvbnM6DQo+
PiAtIE11bHRpcGxlIFJUTV9ORVdST1VURSBub3RpZmljYXRpb24gcGVyLXJvdXRlIG1pZ2h0IGNv
bmZ1c2UgZXhpc3RpbmcNCj4+ICAgcm91dGluZyBkYWVtb25zLg0KPg0KPmFyZSB5b3UgYXdhcmUg
b2YgYW55IHJvdXRpbmcgZGFlbW9ucyB0aGF0IGFyZSBhZmZlY3RlZD8gU2VlbXMgbGlrZSB0aGV5
IHNob3VsZCBiZSBhYmxlIHRvIGhhbmRsZSByZWR1bmRhbnQgbm90aWZpY2F0aW9ucw0KDQpBY3R1
YWxseSBubywgd2UgZGlkbid0IGNoZWNrIGFsbCB0aGUgZXhpc3RpbmcgZGFlbW9ucywganVzdCBh
c3N1bWUgdGhhdCBub3QgZXZlcnlvbmUgd2lsbCB3YW50IHRvIGFjdGl2YXRlIHRoZSBub3RpZmlj
YXRpb25zIGF0IGFsbC4NClNvIHRoZXJlIGlzIG5vIHBvaW50IGluIHNlbmRpbmcgbm90aWZpY2F0
aW9ucyBmb3IgdXNlcnMgd2hpY2ggYXJlbid0IGludGVyZXN0ZWQgaW4gdGhlbS4NCg0KPg0KPj4g
LSBDb252ZXJnZW5jZSByZWFzb25zIGluIHJvdXRpbmcgZGFlbW9ucy4NCj4+IC0gVGhlIGV4dHJh
IG5vdGlmaWNhdGlvbnMgd2lsbCBuZWdhdGl2ZWx5IGltcGFjdCB0aGUgaW5zZXJ0aW9uIHJhdGUu
DQo+DQo+YW55IG51bWJlcnMgb24gdGhlIG92ZXJoZWFkPw0KDQpGb3IgYWRkaXRpb24gb2YgMjU2
ayByb3V0ZXMgaW4gbWx4c3csIHRoZSBvdmVyaGVhZCBpcyAzLjYlIG9mIHRoZSB0b3RhbCB0aW1l
Lg0KDQo+DQo+PiAtIE5vdCBhbGwgdXNlcnMgYXJlIGludGVyZXN0ZWQgaW4gdGhlc2Ugbm90aWZp
Y2F0aW9ucy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBbWl0IENvaGVuIDxhbWNvaGVuQG52aWRp
YS5jb20+DQo+PiBBY2tlZC1ieTogUm9vcGEgUHJhYmh1IDxyb29wYUBudmlkaWEuY29tPg0KPj4g
U2lnbmVkLW9mZi1ieTogSWRvIFNjaGltbWVsIDxpZG9zY2hAbnZpZGlhLmNvbT4NCj4+IC0tLQ0K
Pj4gIERvY3VtZW50YXRpb24vbmV0d29ya2luZy9pcC1zeXNjdGwucnN0IHwgMjAgKysrKysrKysr
KysrKysrKysrKw0KPj4gIGluY2x1ZGUvbmV0L25ldG5zL2lwdjQuaCAgICAgICAgICAgICAgIHwg
IDIgKysNCj4+ICBuZXQvaXB2NC9hZl9pbmV0LmMgICAgICAgICAgICAgICAgICAgICB8ICAyICsr
DQo+PiAgbmV0L2lwdjQvZmliX3RyaWUuYyAgICAgICAgICAgICAgICAgICAgfCAyNyArKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPj4gIG5ldC9pcHY0L3N5c2N0bF9uZXRfaXB2NC5jICAgICAg
ICAgICAgIHwgIDkgKysrKysrKysrDQo+PiAgNSBmaWxlcyBjaGFuZ2VkLCA2MCBpbnNlcnRpb25z
KCspDQo+Pg0KDQo=
