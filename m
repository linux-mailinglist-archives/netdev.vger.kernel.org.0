Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B2739A9BB
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhFCSHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:07:24 -0400
Received: from mail-bn8nam11on2113.outbound.protection.outlook.com ([40.107.236.113]:4260
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230493AbhFCSG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 14:06:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtzpOMTkfR5fans9d35uW0nbnAKKFPN+GhVR7rLz3WUtLNlx11tTT98O/B7z6IhUnz2Q1LN7e7sOOdNuMUW4Tg4S/Nj5DUNIEwqPHy5qQyxuV46ru/MY3/HDKHshgr4FPZga7qxQPxpjesLNV0DeLsMfhgwzUbpU242MlhVm+Bhho12cx6VhHfZmcdO+uoLH/acsBjHdQVGjwuLs5OSkPuRa17eQehki2cLLB79/hE4yed8SQTkDXawFewDVO7KQykRl6bmaAZYe4JY2FznK2XxVXtarg6RO4JbhDhwZnZQWLzEExM2nPqmEFja4x9kPQi80B1+4aS4J2Nw3Kgdf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkSavEKG98yFVKgotVRbGxo+Bu230vtMWbe7dOTO9Rw=;
 b=gFNey6Ppvvm9HEpNpFcNIFPo2oMbv3tCrB5NQNAf+YsnOX2oRhcWrxyZSXAXOOTC9O7+m782zg5QxMw7bCwKVNsb/fWvl1PxHvaR8u8Oh5pOTnfMtw5QVjf9TOXKEaOZNP6IrdD1csOWfd+JU23lhvobVQ1Cny4stSSlT+QvZW0AVZDxbbvtO+ACp/6XeX+XMBBrBSbswFlnrlF223sw/+wF5KItkNHPOlnuF1pcUTKP6pM4SeKCxZf40RT82YeC0Eq85sQz2MToU9baShUTi4skAhmhr2CLihK2YfIgK6eKlDm8rB+BIzOdTSdSQMkdnk7V4JfRXvntVzXdJlrT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkSavEKG98yFVKgotVRbGxo+Bu230vtMWbe7dOTO9Rw=;
 b=c1JI+Nqwy5/Yvj0ZMIu8jnh/eBTxZII0iwgDUrvukxqFEAqMHaA89140i57zTPqvPpStUbcKS6b6Pyt/p+JN9VSLh96w613WrEuRvJ6a3YE9zgEwgHu0HdDQz4EiVNKHj15dtzSc6Zg2p8wX5AoVPCmeogJpL4MI6j8voN1oFRI=
Received: from SN6PR2101MB0894.namprd21.prod.outlook.com (2603:10b6:805:9::31)
 by SN6PR2101MB1101.namprd21.prod.outlook.com (2603:10b6:805:6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.5; Thu, 3 Jun
 2021 18:04:31 +0000
Received: from SN6PR2101MB0894.namprd21.prod.outlook.com
 ([fe80::28f2:daf:5b6d:d99d]) by SN6PR2101MB0894.namprd21.prod.outlook.com
 ([fe80::28f2:daf:5b6d:d99d%4]) with mapi id 15.20.4219.008; Thu, 3 Jun 2021
 18:04:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Leonid Bloch <leonidb@asocscloud.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Long Li <longli@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
 unregistered
Thread-Topic: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
 unregistered
Thread-Index: AQHXWHTXyjSAvRmnA0a6WpgCISs5dqsCkHcg
Date:   Thu, 3 Jun 2021 18:04:31 +0000
Message-ID: <SN6PR2101MB089485D8C070855CD43C1961BF3C9@SN6PR2101MB0894.namprd21.prod.outlook.com>
References: <54fb17e8-6a0c-ab56-8570-93cc8d11b160@asocscloud.com>
In-Reply-To: <54fb17e8-6a0c-ab56-8570-93cc8d11b160@asocscloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b263ae7f-564f-4f55-88c1-4403922a6ed8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-03T17:48:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: asocscloud.com; dkim=none (message not signed)
 header.d=none;asocscloud.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:7151:7539:d190:d1d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5434c504-c7fe-4c96-e290-08d926ba0993
x-ms-traffictypediagnostic: SN6PR2101MB1101:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SN6PR2101MB1101D411DF5E17114012F1CCBF3C9@SN6PR2101MB1101.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hbahYVbh/hYIeR3qX7YJ5UpXBL5NACHP/kUQmryicBd7PhzFt+yQYsbIT6vQY1B8+yUf2vG4ZptRSQk1GDvSMq4vMcVnB/3XQw/p7iMWL3PYLM8ZAJY137377xVvxxoYB/qrnE+rxT2T+pBaNLM1ZlWRJ92B/RxhokLfmCWUDOEgP0J6xxVDTaCxD5djEkmGmp6x4bmWvm6VFy8mHQqL35yi0adUldmsEJdhUpXZTwTGA5cr+s2r3sVIgV14yGW71PdxKO4wLmaJpLfyDxyN1ZHPimhk7XE7hcS5mv6alUiHKhkgeNhL39MwVQd2btD5awuJKH885mLx0tTXWa/aMO3P4uKmD2lyf9rKcDaJpxWKcCfpoBogjqK206ecQYy0iVVVlP3QVx+11XZPDJ/ke4GfLKRGoDfNDPmX2oul7z67KenZR6sckZJmPzzy7Djb0EWGvkS3Id8D3V7St/0kvjJccEGJ9UMFzwAVUkow8X91z5K+hWYaERXjH71g18mwqyfg2v578me7GlY/1pCdLMedVgVyVuz8DCQw5DTcRbEqM4iiNzkgnbrlnv5viEuLdp+8KnEuU17XIAjVSVY6OlVskRrlUTr06nB6R2NnCw2szuHRUOgrPimSqdBk0AHyXD5yN8BcQcjtwJ1zejd1gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB0894.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(316002)(2906002)(4326008)(9686003)(8936002)(6636002)(71200400001)(8676002)(54906003)(66946007)(6506007)(186003)(33656002)(10290500003)(86362001)(76116006)(66446008)(8990500004)(122000001)(38100700002)(64756008)(66556008)(66476007)(7696005)(5660300002)(478600001)(110136005)(82950400001)(52536014)(82960400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3AwVytnd0ZacHNvdmRJVTZzbGRvQ0VzYk1PbFljYjFZeEFNeFZod2prVG9K?=
 =?utf-8?B?bVdkU2d0R1NIUm5kUmVtK2luVGc2M2VPczV3NmV2QW1yYUtWTzBKWDdsME8x?=
 =?utf-8?B?NVd1N2lZYW9FRkNnL0ZVRm96cGVjNHRHUnJ0WGF4SjduMzZBa2pLRUFDQ0JT?=
 =?utf-8?B?VVpFb2loTFZWWE01QmUvOHYrZ1BJMFpGazlMcDlMZkZ0Mmh0UCsxbUxjMnhs?=
 =?utf-8?B?Um9qc09YTkxzWGxNWk9tSUJFK3o3cTh5M0pRcjlwOFhHT3h2MzRXcjh6ajVZ?=
 =?utf-8?B?RXlrYllSQTI4YnkxLy9ZbXp1aHdheUdKMDhTSGRNd2syOSttM013YWNxckhq?=
 =?utf-8?B?MklYcGdZNDlUYjFQN2h1aEpHYjNVYTlKZ3haeE9ZVFVqQzhsRmE0cU5KRGZO?=
 =?utf-8?B?Z1l4RXJhRHRCcWQyaUZZd1VnQ0tUZjdTZEdvUzhoeXdBMmxiM3hJaTYrRC83?=
 =?utf-8?B?WS80R205TEQ3dnE3RTMxZGVlbnR5cEx2RUViWXNmc2dKaHk3MjkrSDlqNFpM?=
 =?utf-8?B?WVFtODhVZG5Ldy9acDdpanJCWHhQVDc3MXBpODA3dldyMjRWL2ZOWU9mWDg2?=
 =?utf-8?B?OEJySFZkQTQydVY0SE52ZnFGb1gzRlljMjY4QVd2R2ZLNTB6UUxOWDJRK3NH?=
 =?utf-8?B?ellyM3djVzBENloxU25yU2pZenpqcWE4cnVrcDRtQ3RpTFVKY0QzWTEzbkd4?=
 =?utf-8?B?MTNnWkFUN2lCTDM3VUw3RkpUSVdUNXZ4OUsvbDE0bG5oaktwL2JQN0JvSHpo?=
 =?utf-8?B?SHF0VjRFeVlsbUpvVlVKdVFkVzFEb1ZMVTdTenlFQ2YydEN5K2NOQ0xiZmU2?=
 =?utf-8?B?VEFoUGlyMy9tZ2ZLcGFrcG1xY3ZnaW9XUWhFV2VnM3pjMXRvOW1Vb2VFbXo4?=
 =?utf-8?B?ZTJuWTlBV2RPVFZLWDNqRmlLTWtibFE2Qis0NkZiNmRCbytGUFo1aS9XQkpp?=
 =?utf-8?B?MmtMdmQwMlBWSEJvVXErZS82aEJ0eVBWV1hTb0RCNGZjUElMWHVUaHhUcFNX?=
 =?utf-8?B?c1JwaWN5WGtnUlY1VjhXeGVVSjhsK0xsMmFNL2p4QnZ3Qys3ekJhaktCK3Vy?=
 =?utf-8?B?Zkw2K1NNM0EzQk15Z0tPZDZMb2ZoRGFYYk1CMC9hdjlWS0dyNmpNZEJMRm93?=
 =?utf-8?B?bUY4cUJydElZbmZlRUhuZ1BqczlyTGJvdnd2QmxpcGpXOWNEOEdUWlc1b1hQ?=
 =?utf-8?B?NFFPUXhOcEZXT2Nxc1M3djR2bzFVSFBBblNod0piQkxoTklYNnRwU2RySmlv?=
 =?utf-8?B?R01EVmIyNm5BdTRXbHRlU3Z4NDhDMk1FY2ZMQjBBNU5HbEg4MzJseFdDY0FM?=
 =?utf-8?Q?aSR2iLQsQF?=
x-ms-exchange-antispam-messagedata-1: YfZfyW7nnJRwRERVpyKX1bN5YCrQSms9hPl5r+8AFUfQ+ZzmGzkrhuEivPb8erNvkssVmL5pIBH1mD1AcWV+eI1GL6MtHhju09M3Ma2CGctaQx4XCR4bwTtfL93gsQhPn5ryun+zVvFiN4a/Awu1Ie/p7n7xD3CLfQrHxk5zBvAQBD4n9SS4pdrArNDT46pLpiIlo1o/7Shkas2zdLfgA2IbkTVRtTTO+7yuQqDEZ2jPP7dDijax0PXpMW9c8hCBmIZ92qPQ/Vx92phA1VNYvvaxfq43pjDq/06wsaCNKUN9dRTl4HT2/VR1izF2eeMKqq5QYQXlZy8M5s4krnPSzjFe1J3Kq/k3bUDVzG7s/kw5P9hPYsP5vZLK5murCMcIngFi9bVd+7qnA18xohYO9tms
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB0894.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5434c504-c7fe-4c96-e290-08d926ba0993
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 18:04:31.4166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXfu9uIH5QMNMeO47HK+PPF12Z4pkcPnEF8LmAaE1KunYIHZyZb6GLIPjT9fai3jLeF680P/Id1V3lIfyMfKqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB1101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBMZW9uaWQgQmxvY2ggPGxlb25pZGJAYXNvY3NjbG91ZC5jb20+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBKdW5lIDMsIDIwMjEgNTozNSBBTQ0KPiBUbzogS1kgU3Jpbml2YXNhbiA8a3lzQG1p
Y3Jvc29mdC5jb20+OyBIYWl5YW5nIFpoYW5nDQo+IDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsg
U3RlcGhlbiBIZW1taW5nZXINCj4gPHN0aGVtbWluQG1pY3Jvc29mdC5jb20+OyBXZWkgTGl1IDx3
ZWkubGl1QGtlcm5lbC5vcmc+OyBEZXh1YW4gQ3VpDQo+IDxkZWN1aUBtaWNyb3NvZnQuY29tPg0K
PiBDYzogbGludXgtaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBbQlVHXSBodl9uZXR2c2M6IFVuYmluZCBleGl0cyBiZWZvcmUgdGhlIFZG
cyBib3VuZCB0byBpdCBhcmUNCj4gdW5yZWdpc3RlcmVkDQo+IA0KPiBIaSwNCj4gDQo+IFdoZW4g
SSB0cnkgdG8gdW5iaW5kIGEgbmV0d29yayBpbnRlcmZhY2UgZnJvbSBodl9uZXR2c2MgYW5kIGJp
bmQgaXQgdG8NCj4gdWlvX2h2X2dlbmVyaWMsIG9uY2UgaW4gYSB3aGlsZSBJIGdldCB0aGUgZm9s
bG93aW5nIGtlcm5lbCBwYW5pYyAocGxlYXNlDQo+IG5vdGUgdGhlIGZpcnN0IHR3byBsaW5lczog
aXQgc2VlbXMgYXMgdWlvX2h2X2dlbmVyaWMgaXMgcmVnaXN0ZXJlZA0KPiBiZWZvcmUgdGhlIFZG
IGJvdW5kIHRvIGh2X25ldHZzYyBpcyB1bnJlZ2lzdGVyZWQpOg0KPiANCj4gW0p1biAzIDA5OjA0
XSBodl92bWJ1czogcmVnaXN0ZXJpbmcgZHJpdmVyIHVpb19odl9nZW5lcmljDQo+IFsgICswLjAw
MjIxNV0gaHZfbmV0dnNjIDVlMDg5MzQyLThhNzgtNGI3Ni05NzI5LTI1YzgxYmQzMzhmYyBldGgy
OiBWRg0KPiB1bnJlZ2lzdGVyaW5nOiBldGg1DQo+IFsgICsxLjA4ODA3OF0gQlVHOiBzY2hlZHVs
aW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci84LzAvMHgwMDAxMDAwMw0KPiBbICArMC4wMDAwMDFd
IEJVRzogc2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3YXBwZXIvMy8wLzB4MDAwMTAwMDMNCj4g
WyAgKzAuMDAwMDAxXSBCVUc6IHNjaGVkdWxpbmcgd2hpbGUgYXRvbWljOiBzd2FwcGVyLzYvMC8w
eDAwMDEwMDAzDQo+IFsgICswLjAwMDAwMF0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzog
c3dhcHBlci83LzAvMHgwMDAxMDAwMw0KPiBbICArMC4wMDAwMDVdIE1vZHVsZXMgbGlua2VkIGlu
Og0KPiBbICArMC4wMDAwMDFdIE1vZHVsZXMgbGlua2VkIGluOg0KPiBbICArMC4wMDAwMDFdICB1
aW9faHZfZ2VuZXJpYw0KPiBbICArMC4wMDAwMDBdIE1vZHVsZXMgbGlua2VkIGluOg0KPiBbICAr
MC4wMDAwMDBdIE1vZHVsZXMgbGlua2VkIGluOg0KPiBbICArMC4wMDAwMDFdICB1aW9faHZfZ2Vu
ZXJpYyB1aW8NCj4gWyAgKzAuMDAwMDAxXSAgdWlvDQo+IFsgICswLjAwMDAwMF0gIHVpb19odl9n
ZW5lcmljDQo+IFsgICswLjAwMDAwMF0gIHVpb19odl9nZW5lcmljDQo+IC4uLg0KPiANCj4gSSBy
dW4ga2VybmVsIDUuMTAuMjcsIHVubW9kaWZpZWQsIGJlc2lkZXMgUlQgcGF0Y2ggdjM2LCBvbiBB
enVyZSBTdGFjaw0KPiBFZGdlIHBsYXRmb3JtLCBzb2Z0d2FyZSB2ZXJzaW9uIDIxMDUgKDIuMi4x
NjA2LjMzMjApLg0KPiANCj4gSSBwZXJmb3JtIHRoZSBiaW5kLXVuYmluZCB1c2luZyB0aGUgZm9s
bG93aW5nIHNjcmlwdCAocGxlYXNlIG5vdGUgdGhlDQo+IGNvbW1lbnQgaW5saW5lKToNCj4gDQo+
IG5ldF91dWlkPSJmODYxNTE2My1kZjNlLTQ2YzUtOTEzZi1mMmQyZjk2NWVkMGUiDQo+IGRldl91
dWlkPSIkKGJhc2VuYW1lICIkKHJlYWRsaW5rICIvc3lzL2NsYXNzL25ldC9ldGgxL2RldmljZSIp
IikiDQo+IG1vZHByb2JlIHVpb19odl9nZW5lcmljDQo+IGVjaG8gIiR7bmV0X3V1aWR9IiA+IC9z
eXMvYnVzL3ZtYnVzL2RyaXZlcnMvdWlvX2h2X2dlbmVyaWMvbmV3X2lkDQo+IHByaW50ZiAiJXMi
ICIke2Rldl91dWlkfSIgPiAvc3lzL2J1cy92bWJ1cy9kcml2ZXJzL2h2X25ldHZzYy91bmJpbmQN
Cj4gIyMjIElmIEkgaW5zZXJ0ICdzbGVlcCAxJyBoZXJlIC0gYWxsIHdvcmtzIGNvcnJlY3RseQ0K
PiBwcmludGYgIiVzIiAiJHtkZXZfdXVpZH0iID4gL3N5cy9idXMvdm1idXMvZHJpdmVycy91aW9f
aHZfZ2VuZXJpYy9iaW5kDQo+IA0KPiANCj4gVGhhbmtzLA0KPiBMZW9uaWQuDQoNCkl0IHdvdWxk
IGJlIGdyZWF0IGlmIHlvdSBjYW4gdGVzdCB0aGUgbWFpbmxpbmUga2VybmVsLCB3aGljaCBJIHN1
c3BlY3QgYWxzbw0KaGFzIHRoZSBidWcuDQoNCkl0IGxvb2tzIGxpa2UgbmV0dnNjX3JlbW92ZSgp
IC0+IG5ldHZzY191bnJlZ2lzdGVyX3ZmKCkgZG9lcyB0aGUgdW5iaW5kaW5nIHdvcmsNCmluIGEg
c3luY2hyb25vdXMgbWFubnRlci4gSSBkb24ndCBrbm93IHdoeSB0aGUgYnVnIGhhcHBlbnMuDQoN
ClJpZ2h0IG5vdyBJIGRvbid0IGhhdmUgYSBEUERLIHNldHVwIHRvIHRlc3QgdGhpcywgYnV0IEkg
dGhpbmsgdGhlIGJ1ZyBjYW4NCmJlIHdvcmtlZCBhcm91bmQgYnkgdW5iaW5kaW5nIHRoZSBQQ0kg
VkYgZGV2aWNlIGZyb20gdGhlIHBjaS1oeXBlcnYgZHJpdmVyDQpiZWZvcmUgdW5iaW5kaW5nIHRo
ZSBuZXR2c2MgZGV2aWNlLCBhbmQgcmUtYmluZGluZyB0aGUgVkYgZGV2aWNlIGFmdGVyIGJpbmRp
bmcNCnRoZSBuZXR2c2MgZGV2aWNlIHRvIHVpb19odl9nZW5lcmljLg0KDQpUaGFua3MsDQotLSBE
ZXh1YW4NCg==
