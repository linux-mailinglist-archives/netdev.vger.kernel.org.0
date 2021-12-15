Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C80147657B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhLOWPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:15:16 -0500
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:42048
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229472AbhLOWPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 17:15:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTdzYbIXsDKlM7UkEUNiPzvH4b6fwE5ywBxHxMswNmdXdsXQVDfe8+Oa+W6iZ8iwjXpVqajsEQc6QzmMXQ4YqiQWsab7RuuQNQoa14ky4nrO1O5ezdgAEq4wQ78qpXZ0Fn3duAThXBjCUAPeXhbu5yJAH9ubOsi/q4L298U/Y9ZiBfM5VdoXk478RzKr+edbv2fAs7PfAbOVBulsspF/yPcrEyi6VBd0/RlcXhgBYEdJCuZ/pQ1JQevjrs6EV8pTZWK1gtsIfJBbfaDt/dvY0GdeDbKdVd2IBSKx/ctHGrYnIB1TY5jEiBPgBCFU+ZxxyC+Ov+BBn32QVzI/L/FvOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQpxKDl9rdUSffqtUQ7FxYSzDwHyXu/6o5/kvQhkkCc=;
 b=SRrvvI14YQ3B5edHddAd6ov+x5TS0/S9r5wjsnn2FMJ98ZAY2RDql6rt9u5usPghVA9E5CLzfOwtnsVl6fBGUHy78BGAZYX5/H00TcAnwESmEEU5A06+E7I3WRO20rGwYNLUQFO7qqMgA38oU1h1SaDGVpy+YuFewYMGUwU1T97tCUPt2cNWHg/uOu7i+ykZDAjAlVHj5JyCE0sEtc+/p7QwSYaoekldBNkVEVZvkvRYhruZOoxxpMqBHETFjDqAaBr8iqHiv1d0+gDtY9VvIN9vlC8BGh2xuPzjf+aSlEC2P+Kb84N6yFGqTemeG3TdqkMCxaWSYqbhZ9Qm92pIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQpxKDl9rdUSffqtUQ7FxYSzDwHyXu/6o5/kvQhkkCc=;
 b=eikaR6GncQgQN0NBEvyqCy00AmCLh1fc6o0x+1uIb1ASJbgEMRM7t45/Gt+WP7Z8vhAue2MySgffC8gdZPzuD2gOTT3BXXTy05qjm3/qIBnxOJRmQ5hl5DQIIr1hZnGFey1HOZ7RSl97lJp6PXHtPjM6TaBxC6+XYqAFBM2jzpjymyl87rx8zHM7RT6oshRS/CsgKL5I+kVl88jodfpWkJhRokEPBkbe4560+gfqnQLQCJdqPHcBBfikOs7QSG+KxTakBzZVBpLVaGlketdYehom+IaSPaag3tMMEScYXxReeeTtaukObbHAV7BfYYBcMDuto+/UvPNqmqKXr6g04Q==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3400.namprd12.prod.outlook.com (2603:10b6:a03:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 22:15:10 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 22:15:10 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369esocIlp2uqECAMRBwa0Q32qwQUeyAgAxe1YCAAFJzgIAAQYMAgAJAtACAFHu+gIAAEY0AgAAwXIA=
Date:   Wed, 15 Dec 2021 22:15:10 +0000
Message-ID: <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
         <20211122144307.218021-2-sunrani@nvidia.com>
         <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
         <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
         <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
         <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc594fc1-7b0f-484f-72a1-08d9c0185be7
x-ms-traffictypediagnostic: BYAPR12MB3400:EE_
x-microsoft-antispam-prvs: <BYAPR12MB34009753DC6619E0B613A275B3769@BYAPR12MB3400.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NvaHDp7Rt8+86RIrzO6OzIo6V4ZzWQ4WPrq+zjh3Sjih4fQ4RtYt4GLzkEo71JLidzLhBeL9JECa/ML5z6V/dREJqgSGG0hmrIHZuF3IXTh4bX677U5eu5o5h5pqEsDoQeGumsEP8F4sYQF/VRJc+AplOQFykl2dj32iYxDK5iQhaVMsfCpogAtjywQ8YLBxHkbPhsi4b/GkA5ePKetYCqBW92rjBnX2Ig2ewx+1xyimkgJXmwvSiEX5NYd2b8x0sA8y2AxKICAYubdl3QVC3v9yMr3Bs3dmYEcEUXBIbI4gsOBYc1Wwa1u5rL6lXgjjcA0mjgGUaXa/mVakGWTphU0Dk4SITHwy/bFbSm/q7MtX2Anf9q4rV7O/68nJi1m960KB/8JePg6rK7sWkFQr26i2v07L2QX0oxARiVIXtZiXfC1gbhtL017R/mJNFebZx1DAu0TubONYame6mQymWO8xR4pjOvfLqw3GMsHDbVw29sZV8tRwRhPzqklTdwhhHJWodg7aIhu+y8J0S6nFheByhjLPiqu3xcROtFECUUbPbG7Pk2A0J4OnKg51hPOVDBtGeumiey3twNi3qOlpr0sn9XMX2yHtgZDq6x+b5qZ4fyxsiBMYzWzLhHDQoWlVGVLajSXJnIKbvADsx5k6v4lJwKX/u3SfecSU9zGXypk4y2Hh1Dpc4LrA3dKc2wt7udRVPVA7O6FlcWqzEAlk8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8676002)(4326008)(26005)(5660300002)(4001150100001)(4744005)(186003)(38100700002)(8936002)(71200400001)(54906003)(6916009)(6506007)(38070700005)(36756003)(86362001)(6486002)(107886003)(122000001)(316002)(6512007)(83380400001)(66946007)(64756008)(66556008)(508600001)(76116006)(66446008)(66476007)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTVyQWcxZWxLMys1TXVPRTdVWVRBYXh1UkYxeHhBN0VCS0N0MGpJZHBWWnRw?=
 =?utf-8?B?ZFhHU01xUEQ4bXd1RHZSeEZTZnRCdGRSZVJTZE9KY1BhaElqK1QyMi9sNTVU?=
 =?utf-8?B?SkxFYVJIbi9EcmhtcmxXb1F6N2NLaWd4S1NGYnRrdzdBTXhKMk5OK1lzODVh?=
 =?utf-8?B?cDhCUERqMHlLUHZiTmlscWlRY0tsS3o2V0NjMVpjOUpBUXNGQkIwSHlIeWFM?=
 =?utf-8?B?WGpRd1ZXUUl2TXl2NzVWQXVPbnFVKzFFaDEyVVZUS3JGb0Q4Y3NPeVBpWFlN?=
 =?utf-8?B?S0lVSmplUTVBOU5FYkxPMm10NEUwVWFCMFZFajNQR25xVjYyeTJQQW96TVhl?=
 =?utf-8?B?Q0xlMnNpUjlCYy8vS0Z1L3lTc1BsR25XYm1TT0ZOMHNRUkJVR0Fhdk1aK3Jr?=
 =?utf-8?B?aERUSk13WVovNGFSOG9xUXFjTjlYWFZuUDkxWDJMZEdiQmx4L0U2aDYyeTda?=
 =?utf-8?B?eFUrZlc2MG1YdytQajU5SXp3T3pmbWU4cWtoZVZmT0dXdHVzclB1cnZCbWhv?=
 =?utf-8?B?QmdqRDJLRFdHM095NmRmZXZWUXBQcG5CNU0veXBDYjUxVVFyUXU2ZWJxWjBl?=
 =?utf-8?B?NWV3Qlc0ZVFNZE5QdWU4WG5PVVVqVk9oSTh1NW04UTdJSDhsdFNRTFRtVlJk?=
 =?utf-8?B?TTFSY1pldDhoWENkZFVKOWZmeGFlNUFuajFwOFdSZXlWMStTUHMveWw5b0VG?=
 =?utf-8?B?MisxV01kT25hUjJWcDg4Q0d6SnNvTU5vSGJsOXRxL1lFWTRCUXc3enMrdjFM?=
 =?utf-8?B?TXJvb1c0NitXWXZMbmRmOTQ3dXg5Ym84dDhqZXhIYlkvVWNTb0t5aWJ5VFVZ?=
 =?utf-8?B?a0tLTmU2TDRSVWRLNVVwTXNXYlZpOFV2allqTmJWSHJNNk5qdklNb1R2UUFj?=
 =?utf-8?B?dmZSTkxPT0RmcGdXd29JQjlwQS9Qb3Z1cXB1enFwYUYzUGZFNk94dC9CN2Ev?=
 =?utf-8?B?Y2czME43emVvU3NwY2h5R3E1anM4aGRFSmdRWGtUdHpuUE5BM0p6Ry9xRTdQ?=
 =?utf-8?B?OXVXaW8rVTBPeXpkNTlOOXR0dDcwclI0UnY5eE50U3lTcGtJTU5rMXBTNXhz?=
 =?utf-8?B?VkVLSHRZaDFPWVF0R0dyRi9ZaFQvSEhKelY5WWF0SXYyQUl4bUxqaFB1R1VX?=
 =?utf-8?B?QVpsdHJ0WldNa05KdEhES0hOSEhEdko0ajU2MnRHa1lVdWRPKzlnUExGbWRM?=
 =?utf-8?B?MXB2V1BjRm9PdHVZWU1DNnhnN3ZXRGlkZzErN2c3VFZqVmFqN0crcUxkNmVU?=
 =?utf-8?B?QTVGbEkxRXhHSUJJSEw1RHo5bFF3elQwVVNUdW8xeTJFNmh4US9JcHdwZDVh?=
 =?utf-8?B?SEJiY2pUaHhPTTByN0Fla1ZMZUpLcFJOWjFVVnpUSWsvRTM5QmdOUWxISm5k?=
 =?utf-8?B?dWhibXdPODBxdEpFV1BWTk9jTy9VdVp0RTFDZzlITlIveW9jN2xhcy9CblYx?=
 =?utf-8?B?ZEV1cEk5citFUkFRT0RySE1Xc09LVUxZai92aWl4L3EvNFVmM0UwY3gveWQw?=
 =?utf-8?B?bXJjOWtLUi9tTnB4bU9jN1hVaktkZ3JGOXlVMFlsLzF0MVg0T1Zha2hBSlNV?=
 =?utf-8?B?NEZGS0VjWVhjbmlXeW8wVzJFempiS3AvbTUyQ0VlVnZSVmhNL0FYV2ZZakVt?=
 =?utf-8?B?LzlJSlhhc1h1UXlpZU1WdkthNmJ2RVBCS1M0VkpxSXQ3NlQ4NnJYNlZYd0Vq?=
 =?utf-8?B?VG5LNlRjY2VPbXpub0JtVU8wejBWYytqbi9XYnZqUjdsTmJpNTNya28vVkZX?=
 =?utf-8?B?Sm5wWkF2QXVlS0Vid2tLWWx5alRNYmtUelpXRG9iSkVlQStlQS9Bdlg1TDB0?=
 =?utf-8?B?S2ZsOHlObTV5aHEwTVlCMHNWM1dQS0ZONmIxODZFWnBxWVpnUmlpQmgvV3Nh?=
 =?utf-8?B?ZkJiQXlpN0VncUxPMkI2Q01oQUJDbTlpWmpoZ3pJYk81Vi9NTFo4Z24yQmxz?=
 =?utf-8?B?NDA5bENnZXdjS0JiR3hWeFY0WWtwSWxxeUpUbndQUVRtZVpTWmZyQTBwOVVN?=
 =?utf-8?B?bEhUNGZCaGp0SjJaSWhEOStWanpIa05YaEhpV2s3ZjJzZm9aQWx3UlN6Y1hl?=
 =?utf-8?B?aS9HZ3IrQStnM2FIVk1mVzIrM2VoRUt2ZTJISzI5MUh5Qm5JMCtsQTdrQ08z?=
 =?utf-8?B?WjdCSkRTOVZZKzdSWlA5VmRvTXRudy9QZm9aUmNQSldiajcwc0hWaWFIbFJB?=
 =?utf-8?Q?RdXB9fpKXh6Vwe3zMtAlB30dv+vGOjFmdUzV/qOCkY6f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A70141E2FC466047B60BE905660D9826@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc594fc1-7b0f-484f-72a1-08d9c0185be7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 22:15:10.1815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJTNcRsVJOQT4AuJYePbWMFwCnClKHSKkWKCLk1+/LL9N5OwdT8EGX3BFtNmrYgw3GZegO21/ZIZnyDlOYBQzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTE1IGF0IDExOjIyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxNSBEZWMgMjAyMSAxODoxOToxNiArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBBZnRlciBzb21lIGludGVybmFsIGRpc2N1c3Npb25zLCB0aGUgcGxhbiBpcyB0byBu
b3QgcHVzaCBuZXcNCj4gPiBpbnRlcmZhY2VzLCBidXQgdG8gdXRpbGl6ZSB0aGUgZXhpc3Rpbmcg
ZGV2bGluayBwYXJhbXMgaW50ZXJmYWNlDQo+ID4gZm9yDQo+ID4gZGV2bGluayBwb3J0IGZ1bmN0
aW9ucy4NCj4gPiANCj4gPiBXZSB3aWxsIHN1Z2dlc3QgYSBtb3JlIGZpbmUgZ3JhaW5lZCBwYXJh
bWV0ZXJzIHRvIGNvbnRyb2wgYSBwb3J0DQo+ID4gZnVuY3Rpb24gKFNGL1ZGKSB3ZWxsLWRlZmlu
ZWQgY2FwYWJpbGl0aWVzLg0KPiA+IA0KPiA+IGRldmxpbmsgcG9ydCBmdW5jdGlvbiBwYXJhbSBz
ZXQvZ2V0IERFVi9QT1JUX0lOREVYIG5hbWUgUEFSQU1FVEVSDQo+ID4gdmFsdWUNCj4gPiBWQUxV
RSBjbW9kZSB7IHJ1bnRpbWUgfCBkcml2ZXJpbml0IHwgcGVybWFuZW50IH0NCj4gPiANCj4gPiBK
aXJpIGlzIGFscmVhZHkgb24tYm9hcmQuIEpha3ViIEkgaG9wZSB5b3UgYXJlIG9rIHdpdGggdGhp
cywgbGV0IHVzDQo+ID4ga25vdyBpZiB5b3UgaGF2ZSBhbnkgY29uY2VybnMgYmVmb3JlIHdlIHN0
YXJ0IGltcGxlbWVudGF0aW9uLg0KPiANCj4gWW91IGNhbiB1c2UgbWFpbCBwaWdlb24gdG8gY29u
ZmlndXJlIHRoaXMsIG15IHF1ZXN0aW9ucyB3ZXJlIGFib3V0IA0KPiB0aGUgZmVhdHVyZSBpdHNl
bGYgbm90IHRoZSBpbnRlcmZhY2UuDQoNCldlIHdpbGwgaGF2ZSBhIHBhcmFtZXRlciBwZXIgZmVh
dHVyZSB3ZSB3YW50IHRvIGVuYWJsZS9kaXNhYmxlIGluc3RlYWQNCm9mIGEgZ2xvYmFsICJ0cnVz
dCIga25vYi4NCg0K
