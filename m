Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0687529067B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408370AbgJPNnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 09:43:18 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:11239 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408361AbgJPNnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 09:43:17 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f89a3730000>; Fri, 16 Oct 2020 21:43:15 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 13:43:11 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.58) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 16 Oct 2020 13:43:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeKZNCberEGSv08ZkhT0sU5MxbhwkxZ99K8Ueirg+/vsFaOewcdhxmNNK5QW+okGK7wcia9IOgjFDo1LS1kiblbCaNaqcrCMJ99UChh0yMKHf85ed6NwZRlReqTsd5UzK0LLx70hHPM3k32/Aw9q7/N7SDhJ7tjF7ioPacWi4i2842v++mgpd8Szp2YmXCqVdbN/OMW6BCeTI5MRKZbFG2L87Byy/mHwcJCDm9dVPGxGyC0anH+ZjMWAt3ghba2RqNLXFCXdcrVsLkbhWqjgZGD5HSFI4kT8+ncvlglXM5mwS3qZhWcrE+Rq9OlwrE4HWcxW2M7u3VyuCQjlnC8GPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcGz7pqCGhYOeo3kKEDhFS79p7nvYXJjFNTFIl1Nva4=;
 b=ZSZKVgUe3mnJQYQyBwZYKQB9rSCwTYxfEX+uqUrpW481CeC4NIl9ZHm8J4JvXlpowUATe7yBka3IWHaQjRWpEn2k4Ta3eXeBRG8wiUdBj6sRJUmcC+BP3EVJivyvYt6f65cEFuhVscrHK2TS60umOauhy1IN30yOooTLv+PncScaCNVN5wjzKj1pWbITtcxLLK1NmfG7gmzQhJbBqDyAbHIGYHgONBYR4po9d/fKj+Ru0q6nQVCUZBrXiukNeNxOymQvJDKnimmsqRDQIh0lDIwPN1cM6giMCuxV+XrGnoMAyf6FPdyCQMRAZN8zVyqbtC9RPHPfInZepYostv3A/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) by
 DM6PR12MB2859.namprd12.prod.outlook.com (2603:10b6:5:15d::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.20; Fri, 16 Oct 2020 13:43:06 +0000
Received: from DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a]) by DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a%3]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 13:43:06 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH] net: bridge: call br_multicast_del_port before the
 port leaves
Thread-Topic: [RFC PATCH] net: bridge: call br_multicast_del_port before the
 port leaves
Thread-Index: AQHWoxl2OxFzX3PLdEe3rZhC1xEv9amaPlgA
Date:   Fri, 16 Oct 2020 13:43:06 +0000
Message-ID: <ed19387091755aee165c074983776f37f2b87892.camel@nvidia.com>
References: <20201015173355.564934-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201015173355.564934-1-vladimir.oltean@nxp.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65ed0a59-9b58-4617-3eca-08d871d9696a
x-ms-traffictypediagnostic: DM6PR12MB2859:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB28597EF4D1FAD4E15ED29311DF030@DM6PR12MB2859.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D86yvNVIflDWQIzRM4p+UeNvovf3Wy6f2C6j7bUDJLORzR/0FY2Wtk/YWHB/OoDHbqXokOPZytr7vj4cj4aKnvwtLLYbqbsSAeC+z29XBUylHTRac0Ya8qaYJ9Le6nWnEyjw3FX+Q4HGBV8AzTKX33+vL6xMu6aSvu2FXMasQ08uz4GDQr4KwVtYynNekpdhW9HLz+8QstoXSJ8ipuM1Uu2zNRexgRW3ylmPxYAcxvGuweQahGX3zFjb8W5NzUImBY3WTzLh6kv6AzxneAuS+CpApDvFNiMkH8uWVeYd+yCaiAL6QiyfaShXJKzCqmEGnotuNPVT/MG/tT1OAwV1Cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(6506007)(86362001)(66946007)(66446008)(64756008)(5660300002)(66556008)(66476007)(83380400001)(8676002)(8936002)(186003)(6486002)(26005)(36756003)(4001150100001)(478600001)(110136005)(6512007)(316002)(3450700001)(91956017)(76116006)(2906002)(71200400001)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: h5KSyS079N6iJuMZ6XM1lzHpMxEoATAHKmYwVArRG5m8ZiNucWUDH5ORnqoYJ6uK4GaR5KagA+kNh1PJv7vKFKV1oFX8zRY26QZ11rsaX2376coxX5++mVuQRQiinctGrH4nShVYksJXgsYur7dtST+jQwnwvgkNF+9ZpI1C/jnmyckPLYr/rRGi4YNdYM4emPhMc0zSDveYdDMNDsJzGtSTNg5jHfwJL6AagEn0voRM39pYaAwIwoLKvZX89IEJ0eI3LTRneRfYrdVh5FmvlIsSYAmwOIMsDMCYiXtAeKQYgA9NrdVEYQquBd99h6bwggi8dxtoQvxGBX1ZMRziJAcxDguZ02sdqgJHqxVV9AvE8hUE56ak09CYlHozooY67BpEWUmTQgNhE24KvtEVQlQ1oF3hsnmZUJ4ovL3JHVOBDIBVaQK4pTZug9RZWL3LbgMBc/Ekg2rCzPopiJ7gtdJwmMbUS3ohDpHHVsfayHsxjUSjctKMcRvROhYjYYtugECPVXq922coet23t0FxOT8+y3cjjVuqzu0wnxIdk5Fdafjj8hxqVa63gnA8Pxx+644keaZ7wxqMyb5pW5sBt3AoK4hZUn6iYa8uXxNWItv4/qPcN6m9KyLAtN2s35qOszXYV0iTWx29RogguabaKw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B04B081B9C6CB4BBF9AED9869594F99@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ed0a59-9b58-4617-3eca-08d871d9696a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 13:43:06.2158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dD1+0oR/Ifj9mttvGjW2ptR0NumGIlW/eVMkyaDofOGoDMUtqTQwII4vRBpplQJ0csZMjOu4PyOQ+oKA2mhIIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2859
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602855795; bh=QcGz7pqCGhYOeo3kKEDhFS79p7nvYXJjFNTFIl1Nva4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
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
        b=gN2joZc1617mdmduSk9r4vc9BLf1GQvoVa1jc8amoidxyX8Lpubz82fNdPd0sGvVB
         6PMQDUVyFDp4VbraDAX4aAJHvE/8i3W/V9rWHzdBSAgkWrbhvTCy3OMWqNFzmM6RTL
         jHGn/9VDQHxKkuQDPpH9uV0ymQ/qPhHrn/UT5ousUmHDx67wE6jAbvnZswR+7R+zl9
         I7MHa35ddVwseuTv2SNzwZV9k1pxO6AFpllb0TArofkhjxxxzHFjhRyZSsDychMeDY
         clxGKPetWbN42CuuhhIFBGi2sD5irYgYqYf7exDB4NTvp8jAK0UQ4D1qr45kfbV8r4
         bTvVoZr1JjRaw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTE1IGF0IDIwOjMzICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IFN3aXRjaGRldiBkcml2ZXJzIG9mdGVuIGhhdmUgZGlmZmVyZW50IFZMQU4gc2VtYW50aWNz
IHRoYW4gdGhlIGJyaWRnZS4NCj4gRm9yIGV4YW1wbGUsIGNvbnNpZGVyIHRoaXM6DQo+IA0KPiBp
cCBsaW5rIGFkZCBicjAgdHlwZSBicmlkZ2UNCj4gaXAgbGluayBzZXQgc3dwMCBtYXN0ZXIgYnIw
DQo+IGJyaWRnZSBtZGIgYWRkIGRldiBicjAgcG9ydCBzd3AwIGdycCAwMTowMjowMzowNDowNTow
NiBwZXJtYW5lbnQNCj4gaXAgbGluayBkZWwgYnIwDQo+IFsgICAyNi4wODU4MTZdIG1zY2NfZmVs
aXggMDAwMDowMDowMC41IHN3cDA6IGZhaWxlZCAoZXJyPS0yKSB0byBkZWwgb2JqZWN0IChpZD0y
KQ0KPiANCj4gVGhpcyBpcyBiZWNhdXNlIHRoZSBtc2NjX29jZWxvdCBkcml2ZXIsIHdoZW4gVkxB
TiBhd2FyZW5lc3MgaXMgZGlzYWJsZWQsDQo+IGNsYXNzaWZpZXMgYWxsIHRyYWZmaWMgdG8gdGhl
IHBvcnQtYmFzZWQgVkxBTiAocHZpZCkuIFRoZSBwdmlkIGlzIDAgd2hlbg0KPiB0aGUgcG9ydCBp
cyBzdGFuZGFsb25lLCBhbmQgaXQgaXMgaW5oZXJpdGVkIGZyb20gdGhlIGJyaWRnZSBkZWZhdWx0
IHB2aWQNCj4gKHdoaWNoIGlzIDEgYnkgZGVmYXVsdCwgYnV0IGl0IG1heSB0YWtlIG90aGVyIHZh
bHVlcykgd2hlbiBpdCBqb2lucyB0aGUNCj4gVkxBTi11bmF3YXJlIGJyaWRnZSwgYW5kIHRoZW4g
dGhlIHB2aWQgcmVzZXRzIHRvIDAgd2hlbiB0aGUgcG9ydCBsZWF2ZXMNCj4gdGhlIGJyaWRnZSBh
Z2Fpbi4NCj4gDQo+IE5vdyBiZWNhdXNlIHRoZSBtc2NjX29jZWxvdCBzd2l0Y2ggY2xhc3NpZmll
cyBhbGwgdHJhZmZpYyB0byBpdHMgcHJpdmF0ZQ0KPiBwdmlkLCBpdCBuZWVkcyB0byB0cmFuc2xh
dGUgYmV0d2VlbiB0aGUgdmlkIHRoYXQgdGhlIG1kYiBjb21lcyB3aXRoLCBhbmQNCj4gdGhlIHZp
ZCB0aGF0IHdpbGwgYWN0dWFsbHkgYmUgcHJvZ3JhbW1lZCBpbnRvIGhhcmR3YXJlLiBUaGUgYnJp
ZGdlIHVzZXMNCj4gdGhlIHZpZCBvZiAwIGluIFZMQU4tdW5hd2FyZSBtb2RlLCB3aGlsZSB0aGUg
aGFyZHdhcmUgdXNlcyB0aGUgcHZpZA0KPiBpbmhlcml0ZWQgZnJvbSB0aGUgYnJpZGdlLCB0aGF0
J3MgdGhlIGRpZmZlcmVuY2UuDQo+IA0KPiBTbyB3aGF0IHdpbGwgaGFwcGVuIGlzOg0KPiANCj4g
U3RlcCAxIChhZGRpdGlvbik6DQo+IGJyX21kYl9ub3RpZnkoUlRNX05FV01EQikNCj4gLT4gb2Nl
bG90X3BvcnRfbWRiX2FkZChtZGItPmFkZHI9MDE6MDI6MDM6MDQ6MDU6MDYsIG1kYi0+dmlkPTAp
DQo+ICAgIC0+IG1kYi0+dmlkIGlzIHJlbWFwcGVkIGZyb20gMCB0byAxIGFuZCBpbnN0YWxsZWQg
aW50byBvY2Vsb3QtPm11bHRpY2FzdA0KPiANCj4gU3RlcCAyIChyZW1vdmFsKToNCj4gZGVsX25i
cA0KPiAtPiBuZXRkZXZfdXBwZXJfZGV2X3VubGluayhkZXYsIGJyLT5kZXYpDQo+ICAgIC0+IG9j
ZWxvdF9wb3J0X2JyaWRnZV9sZWF2ZQ0KPiAgICAgICAtPiBvY2Vsb3RfcG9ydF9zZXRfcHZpZChv
Y2Vsb3QsIHBvcnQsIDApDQo+IC0+IGJyX211bHRpY2FzdF9kZWxfcG9ydCBpcyBjYWxsZWQgYW5k
IHRoZSBzd2l0Y2hkZXYgbm90aWZpZXIgaXMNCj4gICAgZGVmZXJyZWQgZm9yIHNvbWUgdGltZSBs
YXRlcg0KPiAgICAtPiBvY2Vsb3RfcG9ydF9tZGJfZGVsKG1kYi0+YWRkcj0wMTowMjowMzowNDow
NTowNiwgbWRiLT52aWQ9MCkNCj4gICAgICAgLT4gbWRiLT52aWQgaXMgcmVtYXBwZWQgZnJvbSAw
IHRvIDAsIHRoZSBwb3J0IHB2aWQgKCEhISkNCj4gICAgICAgLT4gdGhlIHJlbWFwcGVkIG1kYiAo
YWRkcj0wMTowMjowMzowNDowNTowNiwgdmlkPTApIGlzIG5vdCBmb3VuZA0KPiAgICAgICAgICBp
bnNpZGUgdGhlIG9jZWxvdC0+bXVsdGljYXN0IGxpc3QsIGFuZCAtRU5PRU5UIGlzIHJldHVybmVk
DQo+IA0KPiBTbyB0aGUgcHJvYmxlbSBpcyB0aGF0IG1zY2Nfb2NlbG90IGFzc3VtZXMgdGhhdCB0
aGUgcG9ydCBpcyByZW1vdmVkDQo+IF9hZnRlcl8gdGhlIG11bHRpY2FzdCBlbnRyaWVzIGhhdmUg
YmVlbiBkZWxldGVkLiBBbmQgdGhpcyBpcyBub3QgYW4NCj4gdW5yZWFzb25hYmxlIGFzc3VtcHRp
b24sIHByZXN1bWFibHkgaXQgaXNuJ3QgdGhlIG9ubHkgc3dpdGNoZGV2IHRoYXQNCj4gbmVlZHMg
dG8gcmVtYXAgdGhlIHZpZC4gU28gd2UgY2FuIHJlb3JkZXIgdGhlIHRlYXJkb3duIHBhdGggaW4g
b3JkZXINCj4gZm9yIHRoYXQgYXNzdW1wdGlvbiB0byBob2xkIHRydWUuDQo+IA0KPiBTaW5jZSBi
cl9tZGJfbm90aWZ5KCkgaXNzdWVzIGEgU1dJVENIREVWX0ZfREVGRVIgb3BlcmF0aW9uLCB3ZSBt
dXN0IG1vdmUNCj4gdGhlIGNhbGwgbm90IG9ubHkgYmVmb3JlIG5ldGRldl91cHBlcl9kZXZfdW5s
aW5rKCksIGJ1dCBpbiBmYWN0IGJlZm9yZQ0KPiBzd2l0Y2hkZXZfZGVmZXJyZWRfcHJvY2Vzcygp
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5A
bnhwLmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX2lmLmMgfCAzICstLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCg0KSXQgY2FuIHBv
dGVudGlhbGx5IHVzZSBhZnRlciBmcmVlLCBtdWx0aWNhc3QgcmVzb3VyY2VzIChwZXItY3B1IHN0
YXRzKSBhcmUgZnJlZWQNCmluIGJyX211bHRpY2FzdF9kZWxfcG9ydCgpIGFuZCBjYW4gYmUgdXNl
ZCBkdWUgdG8gYSByYWNlIHdpdGggcG9ydCBzdGF0ZQ0Kc3luYyBvbiBvdGhlciBDUFVzIHNpbmNl
IHRoZSBoYW5kbGVyIGNhbiBzdGlsbCBwcm9jZXNzIHBhY2tldHMuIFRoYXQgaGFzIGENCmNoYW5j
ZSBvZiBoYXBwZW5pbmcgaWYgdmxhbnMgYXJlIG5vdCB1c2VkLg0KDQpJbnRlcmVzdGluZyB0aGF0
IGJyX3N0cF9kaXNhYmxlX3BvcnQoKSBjYWxscyBicl9tdWx0aWNhc3RfZGlzYWJsZV9wb3J0KCkg
d2hpY2gNCmZsdXNoZXMgYWxsIG5vbi1wZXJtYW5lbnQgbWRiIGVudHJpZXMsIHNvIEknbSBndWVz
c2luZyB5b3UgaGF2ZSBwcm9ibGVtIG9ubHkNCndpdGggcGVybWFuZW50IG9uZXM/IFBlcmhhcHMg
d2UgY2FuIGZsdXNoIHRoZW0gYWxsIGJlZm9yZS4gRWl0aGVyIGJ5IHBhc3NpbmcgYW4NCmFyZ3Vt
ZW50IHRvIGJyX3N0cF9kaXNhYmxlX3BvcnQoKSB0aGF0IHdlJ3JlIGRlbGV0aW5nIHRoZSBwb3J0
IHdoaWNoIHdpbGwgYmUNCnBhc3NlZCBkb3duIHRvIGJyX211bHRpY2FzdF9kaXNhYmxlX3BvcnQo
KSBvciBieSBjYWxsaW5nIGFuIGFkZGl0aW9uYWwgaGVscGVyIHRvDQpmbHVzaCBhbGwgd2hpY2gg
Y2FuIGJlIHJlLXVzZWQgYnkgYm90aCBkaXNhYmxlX3BvcnQoKSBhbmQgc3RvcF9tdWx0aWNhc3Qo
KQ0KY2FsbHMuIEFkZGluZyBhbiBhcmd1bWVudCB0byBicl9zdHBfZGlzYWJsZV9wb3J0KCkgdG8g
YmUgcGFzc2VkIGRvd24gc291bmRzDQpjbGVhbmVyIHRvIG1lLiBXaGF0IGRvIHlvdSB0aGluaz8N
Cg0KQ2hlZXJzLA0KIE5paw0KDQo=
