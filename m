Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69BA2FAF6A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbhASEZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:25:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9308 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731315AbhASEWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 23:22:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60065e440001>; Mon, 18 Jan 2021 20:21:24 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 04:21:23 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 19 Jan 2021 04:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXTmudMiqH+l7iPri1oz8Jz69MsKXSmCd2A7B9+PP/1CQqYs6Bgp7w+UDIu66puRbm5zgyN4n5GkJFKsNOCAzNYSC5WfpTJYuUQRLzMxA+zn6Jii5w/2fahYf5IWhqgZWiWftsygE6LFHOi2wA3xuM5oAx8ORTambDd920sU1K3HHJMzUuTIlYVVbm/8v2VSEfEa4pnqRdXPzlQkDRELJevsJMjJGm9byJwhbTWY3nPb9MAjDuGKpTrHm47TKl4DZyLtycKhE7a5VfruvLQtU46eo+1CYF5MtB6Z/azXaZyIA56IzLst7Pn0+MBexZ/GuCC8eigt1WXsztWf28CPyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJwuMeRanw9QDPybdAfXWL30qv+SYH7vvb2+iurzYV0=;
 b=esXvEkdcT9T5eSBFvm2a3fg+GF64MW5O5ioW/MzaGMi3fIC+Npg+th5NgQd43oFtIfgJsNXk/e/zXume0ivQS9s2zALmLpaw2zK0pWeLksQcOahsxgDuO0oY65ZDiTlsNN9oGS3YMZDCqu6G+eVUgVG13Bjayatctr1oqOQTOt1aoRiv83EdZHLYxPUdicztdithUAXa7js7U+Bm6xQCa4PjGkXy1CPc0xo2BJKNPVfqBW1+MelC4PI0ECGF+empojFg0NDpUp8kVs0lyM7xEYAOImPDAsWhBQ08NUmYZSGECcy+FE5MDvvOJOnQK3yre6LgCgO0vP2NW/RWBtXpvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2887.namprd12.prod.outlook.com (2603:10b6:a03:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 04:21:21 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 04:21:21 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?utf-8?B?6LCi5rC45ZCJ?= <xieyongji@bytedance.com>
Subject: RE: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnbcCaAgBKGfYCAQMwJkA==
Date:   Tue, 19 Jan 2021 04:21:21 +0000
Message-ID: <BY5PR12MB43228D1A331E875D84C1FF68DCA30@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <831884f7-365d-b974-0bc5-f72729add98f@gmail.com>
In-Reply-To: <831884f7-365d-b974-0bc5-f72729add98f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5191f1c9-5805-4bd9-bdff-08d8bc31ad24
x-ms-traffictypediagnostic: BYAPR12MB2887:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2887713DFEF6F3D7328063EADCA30@BYAPR12MB2887.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tclt7B5xxqsJ0uI+55INPxqWwtbfzLgSHxEXQVIQxXLuP/gljDiFG/cTxaw0XQFOKTfrm3YJp0NWI+Y7zHrO0CbHFEoOqcg9Am3Z22wt4pKNAbnZxbtGpPw+qedzG4UMhHDMWMfOUvSYt3k+cB1glcJX6GlZeZbRhq8CHYQT+iDpuJgd1jc3HOUxjYBK3kI0GQ4k5b+D4lXYEJf9wqVAciv3CEKjOKCuLMg3LVOm3woTN0OrBHFQR8YEreN2+qkS1J9G8Ult5pZvQ1PbpD8kXQ72aDJv6sqMMOloZwN8IYHNYcccIKC/A9g/8zgoO7jVmzG1LRfekZQfqGGWs6DlD4mRS7IxMya/VOH470jX3MRaMgakxaf70cNlJQ0LYpoWeibqdslQQ5mHe9ijj8seQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(2906002)(8936002)(66946007)(53546011)(52536014)(33656002)(71200400001)(4744005)(76116006)(5660300002)(186003)(26005)(83380400001)(7696005)(54906003)(8676002)(110136005)(4326008)(9686003)(316002)(478600001)(55016002)(66556008)(66446008)(86362001)(6506007)(64756008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NUwwRG82c0Q4QUZpajM3K3ZBTU1FWTZTZ3A3VEpIUENnQ3J0bUhrazdpMzFI?=
 =?utf-8?B?TWJIR2ZwUnVpMnFBcnk0UG5RTnlyZHBzS1p6YWlWMlJHYjAwL2xPd1EzRzBj?=
 =?utf-8?B?cXhDZVFvdVdwUkluOWRiZmEvQUo0UjVDZkhoSHNQUDFTWVNjUzJYa3Zvd3FX?=
 =?utf-8?B?aHJQZ1BRbFB2Q2lUeDRlNlBRMUlrU09XWUZaZk45STZhYUtWSnpoMzRLWmZt?=
 =?utf-8?B?TWVDUkJtL0o5bjRzU3lTVDZrUWNMNmJTOUdNUUc0UzJWZExpRGt1ZXhGZEho?=
 =?utf-8?B?NHBwUk5KcTdEdVF5MzdSMmZpVXBOdmplMkdLYzdxa254TTRKeUFJSkx0elZw?=
 =?utf-8?B?RXZ0UkRwWFB4RVQ0TE0wdUVlMm92VDIrWWRSL2RXUmtxSDVVU3dxMzFyN2xZ?=
 =?utf-8?B?bkwvamhrMFIxeW14SGpvR3hwUklnRlZ1WVNDb2xZaWJyd2Y2V3VicGNUSDJB?=
 =?utf-8?B?RUdvRmtIcTJOdGE5Mi9uY3ZWblFNbzlQZ1hXbnErb2kwUXdkd3JrbU5nR0ZO?=
 =?utf-8?B?bUp4QWRLR2trVDF4WU9wSjAxWkZyRzJXdkg4NzRxejBHVlBlcUwvc3UrT0Rm?=
 =?utf-8?B?cDFKR1RNVEVQSldXdDN2aG42dXVobmpDZzVOR2d3UVlqQnBHSXhXTmhTL1Vw?=
 =?utf-8?B?ZVVzSUxPRXFDUW5GMkpEWVlrenhGckJDOTJqUEF4Nm9mNlBZdDBlQkkzbU5w?=
 =?utf-8?B?L3Nud2hmVVQ2cDJRL1hIQUxkZnJ4RFJHYk8xK1ZLeitYL2IyOXlpL2NIWXcv?=
 =?utf-8?B?N1luemd2ZDNnVm5WR3BlSkNsT0g0dkJ1Q2lkb215QVIySjRHd2xzaCtFbnhH?=
 =?utf-8?B?SHhsbEQzalVDZjZZbUlod0RldjlJZ0VMVC9DUFBpcTNsT1ZMQ2NTQ3JhWG4x?=
 =?utf-8?B?NkR0aVZMWXI5VnQ0UUZLVzdubDVsQUVCS3ZuaEp0ZTA1blp4SW5VK3lYK3ZG?=
 =?utf-8?B?ZmZTM2NpZittZVpMSXh3ZUQ5OEdWZlpVNEpiUUozbFZVeHNSU09tc1pYNmlX?=
 =?utf-8?B?MjJNMklLTGZBZUkxYnE0cXppT3dpdEZwK1l5eG0vL1lCSktsR1JjSkp0aEdv?=
 =?utf-8?B?TWxwZTl5Mm1BMHlTY1dVYVZVTGtUMnV4MHhieHV1NnJJL2hLOWtlaFZrRVNC?=
 =?utf-8?B?R2dkOVZ5Ky9WdFp4dWdrVDdYeW91TDlNMUtZekFZTVRyeGJJcUZWSzl1MWhD?=
 =?utf-8?B?ZGxvZDhicm5VNXdpZUJhOGVraW4xQXRBQzdrNTdqVE5FR0Qva0dyd1VBb0ZO?=
 =?utf-8?B?aGxmRjd3Y0t5VTRxV0tOd3FTUW56Tk1pM0hHakRoR1VOdEpkQXhLUFYzTUlq?=
 =?utf-8?Q?/d7JvNheS27yk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5191f1c9-5805-4bd9-bdff-08d8bc31ad24
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 04:21:21.5916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tM4/Zmps0kewGG0wrHOhHtmMfoA0u81KmhDqWsA2Ekkm5Ww2/Gpyc9JQLRVAXrZ2ZMHKJ0IOjeuOACqau+EEzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2887
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611030084; bh=CJwuMeRanw9QDPybdAfXWL30qv+SYH7vvb2+iurzYV0=;
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
        b=rUNJ5nJGilKz8Hv8nwrjQ/y8FTT+8YiAzQ79lnF+R/4Q7JndhU7wRpOYGeytFPA/S
         +K70g02sz0cAjxiWgxTuZ9FAcIiYxT7/F3Nny3K5T30irGuP5QItTApami9x8GzNgb
         4yKvnTUfesoJZ8DTWYmpAQCb12p9iAAQdu6xAH3AV6/u/9pUQCpOOhlHkkh9CBxI+J
         KbUZYMw1Z3ioV7obI37V09Z1F68Nd4PNBPxFnyPirXNLISxO04kq2DbiacpEu9MfzL
         MDPT6THhwMO+SUPSEANBbpmNKraImzC9YUhQjUFuy6UKib1VVDmeas7or1V7Bgq04W
         K7G9ENtIKfAXg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDksIDIwMjAgNDoxNyBBTQ0KPiANCj4gT24gMTEvMjYv
MjAgODo1MyBQTSwgSmFzb24gV2FuZyB3cm90ZToNCj4gPiAxLiBXaGVyZSBkb2VzIHVzZXJzcGFj
ZSB2ZHBhIHRvb2wgcmVzaWRlIHdoaWNoIHVzZXJzIGNhbiB1c2U/DQo+ID4gQW5zOiB2ZHBhIHRv
b2wgY2FuIHBvc3NpYmx5IHJlc2lkZSBpbiBpcHJvdXRlMiBbMV0gYXMgaXQgZW5hYmxlcyB1c2Vy
DQo+ID4gdG8gY3JlYXRlIHZkcGEgbmV0IGRldmljZXMuDQo+IA0KPiBpcHJvdXRlMiBwYWNrYWdl
IGlzIGZpbmUgd2l0aCB1cywgYnV0IHRoZXJlIGFyZSBzb21lIGV4cGVjdGF0aW9uczoNCj4gc3lu
dGF4LCBjb21tYW5kIG9wdGlvbnMgYW5kIGRvY3VtZW50YXRpb24gbmVlZCB0byBiZSBjb25zaXN0
ZW50IHdpdGgNCj4gb3RoZXIgaXByb3V0ZTIgY29tbWFuZHMgKHRoaXMgdGhyZWFkIHN1Z2dlc3Rz
IGl0IHdpbGwgYmUgYnV0IGp1c3QgYmVpbmcgY2xlYXIpLA0KPiBhbmQgaXQgbmVlZHMgdG8gcmUt
dXNlIGNvZGUgYXMgbXVjaCBhcyBwb3NzaWJsZSAoZS5nLiwganNvbiBmdW5jdGlvbnMpLiBJZiB0
aGVyZQ0KPiBpcyBvdmVybGFwIHdpdGggb3RoZXIgdG9vbHMgKGRldmxpbmssIGRjYiwgZXRjKSwg
eW91IHNob3VsZCByZWZhY3RvciBpbnRvDQo+IGNvbW1vbiBjb2RlIHVzZWQgYnkgYWxsLiBQZXRy
IE1hY2hhdGEgaGFzIGRvbmUgdGhpcyBxdWl0ZSBhIGJpdCBmb3IgZGNiIGFuZA0KPiBpcyBhIGdv
b2QgZXhhbXBsZSB0byBmb2xsb3cuDQoNClNvcnJ5IGZvciBteSBsYXRlIHJlcGx5LiBJIG1pc3Nl
ZCB5b3VyIG1lc3NhZ2UgdW50aWwgeWVzdGVyZGF5Lg0KVGhhbmtzIGZvciB0aGUgYWNrIGFuZCBp
bnB1dHMuDQpZZXMsIEkgbWlncmF0ZWQgdGhlIGlwcm91dGUyL3ZkcGEgdG8gdXNlIG5vdyB1c2Vz
IHRoZSBjb21tb24gY29kZSBpbnRyb2R1Y2VkIGJ5IGRjYiB0b29sLg0KV2FpdGluZyBmb3Iga2Vy
bmVsIHNpZGUgdG8gZmluaXNoLg0KDQo=
