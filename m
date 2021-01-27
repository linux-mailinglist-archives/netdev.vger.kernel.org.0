Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5413058DF
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhA0KyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 05:54:10 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18532 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235716AbhA0KwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 05:52:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601145a70003>; Wed, 27 Jan 2021 02:51:19 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 10:51:19 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 10:51:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZcsuzeaPW0ocXPRqA1lU1ax8lTGuquj6gJGj2NMQhIx5E2tjvplliA+hWeU78O0JT+DBWd+uCs/daBJX0R4m7CAa6rUyCHSJhkLVkNDJtIESwzSDAFB8coPbu2Bof7rcvdWcAuuVEuaakU3Bz1yOSwF3gZyG10QkTdx9zT5DjfQ1P4l2lxjAsZmeIhlj1HSwi9BfNtFiR+XZzpGQgitL/PWa1GyS2DNxV8issM6nH/I1LEx5UaOWGRP2bJBU+Po4skdOZ7ZaLoAsUuNXPy06XQQhDfqgU+HIu/nAvvST2ncAmrNpoOWG+UYDsg9jcL6ei90nWev3pqakMZTrnP6Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VodAagaVDR941NdZWhczlGirebVzyXU+9RLbd+jVkM=;
 b=Acn8Pe0azzLM1T2n0o+iEoOixhr9m8QBNc6bNfU3KsVSA2xlkhe7/dZ8d+G20LbIGU2RaF8mhD3PJmtuX0yoJnCZdJGEdcWdIG3l3y+zw8LznA+DDJFLgxZE5cYh9j6iPUM7Jak60nQdzAEpQaptP8KIlpeF5gEgHd8Mumyy7XlHZrHtdFIYe5yknmptehD/xBWoEuG7RyxK6qvYxI0Ou6/N4l1uoBH8/7Z0TnSUYaXw777G3e2FCNeFilzhsuui8JYdDNa0CyjlKf98eKR2NGrCJU3qdIPAlxeQpZO8PM9Ue29xxCYFESgHw2FqZOUBex/mhZdw/eHKKp0AdmbYhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3066.namprd12.prod.outlook.com (2603:10b6:5:11a::20)
 by DM6PR12MB4928.namprd12.prod.outlook.com (2603:10b6:5:1b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 10:51:18 +0000
Received: from DM6PR12MB3066.namprd12.prod.outlook.com
 ([fe80::38ce:fe85:48ce:51a2]) by DM6PR12MB3066.namprd12.prod.outlook.com
 ([fe80::38ce:fe85:48ce:51a2%6]) with mapi id 15.20.3784.017; Wed, 27 Jan 2021
 10:51:18 +0000
From:   Amit Cohen <amcohen@nvidia.com>
To:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Donald Sharp <sharpd@nvidia.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next 01/10] netdevsim: fib: Convert the current
 occupancy to an atomic variable
Thread-Topic: [PATCH net-next 01/10] netdevsim: fib: Convert the current
 occupancy to an atomic variable
Thread-Index: AQHW8+aNGAT+dMEaqEel5LPIF58mwKo640+AgABmyrA=
Date:   Wed, 27 Jan 2021 10:51:17 +0000
Message-ID: <DM6PR12MB30665BEF4DBA4B1BA697E23ACBBB9@DM6PR12MB3066.namprd12.prod.outlook.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-2-idosch@idosch.org>
 <b307a304-09ef-d8e8-7296-92ddddfc348c@gmail.com>
In-Reply-To: <b307a304-09ef-d8e8-7296-92ddddfc348c@gmail.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e38eafff-8905-4ca4-0fef-08d8c2b179c5
x-ms-traffictypediagnostic: DM6PR12MB4928:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB4928EDD8F513332585D3C170CBBB9@DM6PR12MB4928.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LWqLa3wBQSz/MdBbYF0jVR/d49IvzCrjmb55/bmvsZ43Il7UW/5BXzwYp4GG3XCLUYK5KGPcLVgKbhiR+qSGwyAlVP79/IKs6vmphixrLoUK+h5NjM+aHw1QR6+K4kMh0BtcuxLL/YciXWy5cDbUzNY4adhWJyOMrx+1NtatO8gWONdSVgXMuzXs+peeX/8+F/EdqZ3G/AAXklc5sRAr7gXcSi/yaaMt30UENHryWLY5Q2HaVoq7SJVF7zO0Q5WdZ4UXa+GSupZZV9OxIwgzuUDRkHosm4TFv2Ez8si+Veaw34W6wGNb8pdHGkpOPR/7ji9A67rE9UoRqv5/An2FMciXtfieQG7pvoKWAEW3fJsvDIN0AyudGOqqDjPRko3hi+coy7x2yBesQoUvFGe1gLEyRTks6aivsYGQloBhm40TAZ9RzNdeAP3EZXVFxE4anNvYqohM6Z5nHNaReuglcSHZ/24Un4OVtKLLAGLSxbZGV30BdDpjosRF1JzgE3Wuci/e91q4H0wK5fzV9C7bcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(26005)(4326008)(186003)(55016002)(66946007)(6506007)(33656002)(76116006)(71200400001)(316002)(107886003)(86362001)(66446008)(8676002)(478600001)(5660300002)(110136005)(54906003)(8936002)(83380400001)(66556008)(2906002)(52536014)(7696005)(64756008)(66476007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cDloeDJETmh0QjY2cWhNa3ljaGszOUVwTVhtS2V3bGJ5SmRpZzl2YkhTYUw0?=
 =?utf-8?B?cGR6TUM1QUwzYzllVXdtVUMzbFIreCs0TVZrUjI3NlVueEhtc2NXN09nR3l6?=
 =?utf-8?B?aUdDWFVoNFBCSzh5cm02VlFydDdMMnVNMmVMQVNIc3BQam9LWG51V2RaT1ho?=
 =?utf-8?B?aVkzNDJqY1oxUmVya3ZWaTIwL2M5SDFTVUNaU0VIczJMVDRiRXN3T1pUKzRR?=
 =?utf-8?B?enA2eSs4Rnp3MjZIY1FzbXJaZTlVZVNyMzZaWnZvVkxFOHB6SzZtTjZoblFW?=
 =?utf-8?B?UGpnOVdZbFd3RDVwc2hKd3grSjJ2OWJxemRaMVBFVXFTaElacUlCa0k2Ukox?=
 =?utf-8?B?N2wrN2RpUGNwNW85TTRuVHRtalJYWkpQc3ZPSlFuMVJ5dGh4RGdycTlHZG94?=
 =?utf-8?B?Q1ZOT1Z5dUpyUnhHeDg4dGlDUzB3TmxoOC8zZmFxcERYUFNoNVZVN0k1Wm9K?=
 =?utf-8?B?UmI3UjRXN3JUMkNwWVBHejZrTUk1clRvQnV1Q05nY3RFaE44cktvOWhxMXIz?=
 =?utf-8?B?R0NFMW0weEREWjd3cUpLZ1VjbHRLZWs5czN4cW5Ya002YklodUU3ZjNCT2Vx?=
 =?utf-8?B?NWZlbTliSzlKR3ppdklmalR5a1g0N01yQlhyTXpXOHRsa01pakk2b1lOVUpL?=
 =?utf-8?B?YUJBK3R0WW5hQ3R3SkxVcE84U1h5M2VsY2Nzend2WW1pN3QvOFBTTk4xVGNJ?=
 =?utf-8?B?MUxCcHI5dWlBRDZtT2ZGdG52WHpTbitIaGdsZXlsanBKdThaZExQM1JrR0pk?=
 =?utf-8?B?dlY4cjkvL3p6cmI3N3JLbGpJaS9rdlduMUgvbzJWaVQ5QjdRd3ZzdzdhR0lB?=
 =?utf-8?B?dTFTc3pacWVFVk5nOEpQTFp3emc4bEc5TUw5amgvWCtxbnlYM3lQKzNMTm92?=
 =?utf-8?B?cDgzaWY4ME1xTXIxTjFWN3FFV0p0Z3ErWFkxNmwwVDdJRU1nUXdiRG9NZDlO?=
 =?utf-8?B?dlRCSlVsdzZnSldyZ1Yyak1BMHFPVVI3ZGdDY0dsdEplMjhONmZ6RFluNVhG?=
 =?utf-8?B?YW9vK3ozUDl6MWQySVd1ck1OSE02Nk9yR1JySjdwWkxYTi8zS0VEbGlCdUh3?=
 =?utf-8?B?R3c4V0hiZXNiRG9pN3hBUTZvdGt2TUh1eDRxcTltNklmK0hldVRPMEVtVEJQ?=
 =?utf-8?B?QlIxNTI4U2tkWmJrK2Z4a0dSSFlkK20rVWk5cmF1ZnhjYVQ0NkIrc1FwUHc5?=
 =?utf-8?B?cEdQQ3JoSDlBTis0WXpKOHJ4RU9CL3ZESjcybTJVb0ltaHZtRytpMDQ0ZGdz?=
 =?utf-8?B?T2pERkF2NEZ0eTVzSWtPbzBwUSs5cnJXaEJNRjUyYzZIUmh0ZFhzbCtXOE8v?=
 =?utf-8?B?MS94aCt4T2RRS1dDcVV3RHRIVjZEc09JYXZIZUxZRVA4TnBoRWp4Mm5JaThD?=
 =?utf-8?B?TjlKUmw1blY5aDRHcnBKK2FrZGl2USswRDNYMFhkRkM2czdUcXExZGhLcjcz?=
 =?utf-8?Q?Kb/2TvtU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e38eafff-8905-4ca4-0fef-08d8c2b179c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 10:51:17.9783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4f/mS0m8b+nP7mY/zzcKsh+JHvULq3L16fcOATpWM6dyMd3ZrrqL7pTxCvSIs93hN/4bvu02fth60GPtZo5EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4928
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611744679; bh=9VodAagaVDR941NdZWhczlGirebVzyXU+9RLbd+jVkM=;
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
        b=UcGx8yXfdyEsLo6Lohsf1N2t6r0JldSSZRyJR9VJ8ON5z/h0Z69j//wcUBe7CP4nB
         upyvT3yOeluEQdISuQwjmEb1MV0Hl1q4yrXrTf4OmJeX8Q1s9tkjoxnaa0VYB713Zd
         1myZyKn7dpmDcymAPeRZ7hU5N52eQOovypkZZbwUfxhmIWV572wgtThscVRdEduCsA
         8FZGtRoGWB0RDqxb9OZEUlmMhgfZS0Ymk3zBXUpap8OYS167syrDI5SIFJKN5I9QW7
         mBXgPdBcbCfUHOJwRcAtamuP6lgyooizkFghhQIlhsDXnuR52V6/bKv1onGXTwx58r
         kHXrLebA7II6w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IERhdmlkIEFoZXJuIDxkc2Fo
ZXJuQGdtYWlsLmNvbT4NCj5TZW50OiBXZWRuZXNkYXksIEphbnVhcnkgMjcsIDIwMjEgNjozMw0K
PlRvOiBJZG8gU2NoaW1tZWwgPGlkb3NjaEBpZG9zY2gub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPkNjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IEFtaXQgQ29o
ZW4gPGFtY29oZW5AbnZpZGlhLmNvbT47IFJvb3BhIFByYWJodSA8cm9vcGFAbnZpZGlhLmNvbT47
IERvbmFsZA0KPlNoYXJwIDxzaGFycGRAbnZpZGlhLmNvbT47IEJlbmphbWluIFBvaXJpZXIgPGJw
b2lyaWVyQG52aWRpYS5jb20+OyBtbHhzdyA8bWx4c3dAbnZpZGlhLmNvbT47IElkbyBTY2hpbW1l
bA0KPjxpZG9zY2hAbnZpZGlhLmNvbT4NCj5TdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDAx
LzEwXSBuZXRkZXZzaW06IGZpYjogQ29udmVydCB0aGUgY3VycmVudCBvY2N1cGFuY3kgdG8gYW4g
YXRvbWljIHZhcmlhYmxlDQo+DQo+T24gMS8yNi8yMSA2OjIzIEFNLCBJZG8gU2NoaW1tZWwgd3Jv
dGU6DQo+PiBAQCAtODg5LDIyICs4ODIsMjkgQEAgc3RhdGljIHZvaWQgbnNpbV9uZXh0aG9wX2Rl
c3Ryb3koc3RydWN0DQo+PiBuc2ltX25leHRob3AgKm5leHRob3ApICBzdGF0aWMgaW50IG5zaW1f
bmV4dGhvcF9hY2NvdW50KHN0cnVjdCBuc2ltX2ZpYl9kYXRhICpkYXRhLCB1NjQgb2NjLA0KPj4g
IAkJCQlib29sIGFkZCwgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKSAgew0KPj4gLQlp
bnQgZXJyID0gMDsNCj4+ICsJaW50IGksIGVyciA9IDA7DQo+Pg0KPj4gIAlpZiAoYWRkKSB7DQo+
PiAtCQlpZiAoZGF0YS0+bmV4dGhvcHMubnVtICsgb2NjIDw9IGRhdGEtPm5leHRob3BzLm1heCkg
ew0KPj4gLQkJCWRhdGEtPm5leHRob3BzLm51bSArPSBvY2M7DQo+PiAtCQl9IGVsc2Ugew0KPj4g
LQkJCWVyciA9IC1FTk9TUEM7DQo+PiAtCQkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywgIkV4
Y2VlZGVkIG51bWJlciBvZiBzdXBwb3J0ZWQgbmV4dGhvcHMiKTsNCj4+IC0JCX0NCj4+ICsJCWZv
ciAoaSA9IDA7IGkgPCBvY2M7IGkrKykNCj4+ICsJCQlpZiAoIWF0b21pYzY0X2FkZF91bmxlc3Mo
JmRhdGEtPm5leHRob3BzLm51bSwgMSwNCj4+ICsJCQkJCQkgZGF0YS0+bmV4dGhvcHMubWF4KSkg
ew0KPg0KPnNlZW1zIGxpa2UgdGhpcyBjYW4gYmUNCj4JCWlmICghYXRvbWljNjRfYWRkX3VubGVz
cygmZGF0YS0+bmV4dGhvcHMubnVtLCBvY2MsDQo+CQkJCQkgZGF0YS0+bmV4dGhvcHMubWF4KSkg
ew0KDQphdG9taWM2NF9hZGRfdW5sZXNzKHgsIHksIHopIGFkZHMgeSB0byB4IGlmIHggd2FzIG5v
dCBhbHJlYWR5IHouDQpXaGljaCBtZWFucyB0aGF0IHdoZW4gZm9yIGV4YW1wbGUgbnVtPTIsIG9j
Yz0yLCBtYXg9MzoNCmF0b21pYzY0X2FkZF91bmxlc3MoJmRhdGEtPm5leHRob3BzLm51bSwgb2Nj
LCBkYXRhLT5uZXh0aG9wcy5tYXgpIHdvbid0IGZhaWwgd2hlbiBpdCBzaG91bGQuDQoNClRoaXMg
c2l0dWF0aW9uIGlzIHJlYWxpc3RpYyBhbmQgYWN0dWFsbHkgd2l0aCBhdG9taWM2NF9hZGRfdW5s
ZXNzKCkgc2VsZnRlc3RzL2RyaXZlcnMvbmV0L25ldGRldnNpbS9uZXh0aG9wLnNoIGZhaWxzLg0K
DQo+DQo+YW5kIHRoZW4gdGhlIGVycl9udW1fZGVjcmVhc2UgaXMgbm90IG5lZWRlZA0KPg0KPj4g
KwkJCQllcnIgPSAtRU5PU1BDOw0KPj4gKwkJCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLCAi
RXhjZWVkZWQgbnVtYmVyIG9mIHN1cHBvcnRlZCBuZXh0aG9wcyIpOw0KPj4gKwkJCQlnb3RvIGVy
cl9udW1fZGVjcmVhc2U7DQo+PiArCQkJfQ0KPj4gIAl9IGVsc2Ugew0KPj4gLQkJaWYgKFdBUk5f
T04ob2NjID4gZGF0YS0+bmV4dGhvcHMubnVtKSkNCj4+ICsJCWlmIChXQVJOX09OKG9jYyA+IGF0
b21pYzY0X3JlYWQoJmRhdGEtPm5leHRob3BzLm51bSkpKQ0KPj4gIAkJCXJldHVybiAtRUlOVkFM
Ow0KPj4gLQkJZGF0YS0+bmV4dGhvcHMubnVtIC09IG9jYzsNCj4+ICsJCWF0b21pYzY0X3N1Yihv
Y2MsICZkYXRhLT5uZXh0aG9wcy5udW0pOw0KPj4gIAl9DQo+Pg0KPj4gIAlyZXR1cm4gZXJyOw0K
Pj4gKw0KPj4gK2Vycl9udW1fZGVjcmVhc2U6DQo+PiArCWZvciAoaS0tOyBpID49IDA7IGktLSkN
Cj4+ICsJCWF0b21pYzY0X2RlYygmZGF0YS0+bmV4dGhvcHMubnVtKTsNCj4NCj5hbmQgaWYgdGhp
cyBwYXRoIGlzIHJlYWxseSBuZWVkZWQsIHdoeSBub3QgYXRvbWljNjRfc3ViIGhlcmU/DQo+DQo+
PiArCXJldHVybiBlcnI7DQo+PiArDQo+PiAgfQ0KPj4NCj4+ICBzdGF0aWMgaW50IG5zaW1fbmV4
dGhvcF9hZGQoc3RydWN0IG5zaW1fZmliX2RhdGEgKmRhdGEsDQo+Pg0KDQo=
