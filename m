Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5FC2D09E1
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 05:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgLGEyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 23:54:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10823 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgLGEyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 23:54:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcdb5570000>; Sun, 06 Dec 2020 20:53:43 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 04:53:43 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 7 Dec 2020 04:53:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+SK2+6JZvPxvCpBY+hgyvgkwOlzic3d81bkwwOj5xg5qMpxkFdEMYOmCHkr0ki1Aq6UNqfNgVNgn2S2AvkgJJoGw1j4wKIjbMWlDh//tXUajpG0I7aiOxzumaOb/hauXr425zRCYjT8Iy90d6ybQwY//J2pQhWZFbXlKVDhcm1Qi8rHHVpoqpk2bdHShYXk9qkou5qqxJbHjwnHcHiDM1+apRyC2g1li+YwiCKBeBX5xtSks/ti54O5XC2J/d0LEDcARdoxf2vJ9SQykXs+xrFzpNHCPc/BPXgZU33JIm7DUYh7oaz5TncJ2eHJ+DR0QoebZ+KIdTcfePTTA5NAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUOUCI3xgIo8NUE5FPKIhD9WrQRGqmOyUtz4Pvc0t4A=;
 b=It/CYZtIGpWM2BOCRa82BOy1pALwF53u6ni/Ru2DKs8BEwRxvuOGQ9y2QP9zS3pGue+1PdBQdcyD79UrmiX6Y9bJ5j4xelRO6lnvqrjKUuZ4Qcw0gc1k/hiu1+/NAslAbNlqVFWqqJeFDncKE2v5egmoaAGNOg562HlLR3YoQQy7EV6yPp7+NY9jquz/JqkZaG1bpuTM7RlUQ/iLB3C0kcbwWgx2VQl33UDD/ES9MpaYZPYX3ErfZUWzofCiIyBU8VXuyqMz0oH9JTMrOZ8Bi61ZA6zEUrjnZ0Q0qr+g0JQqrlkjznPhja9XZiGWUqaoxBACJwgLwnrxKjlwnT64hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4904.namprd12.prod.outlook.com (2603:10b6:a03:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Mon, 7 Dec
 2020 04:53:40 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Mon, 7 Dec 2020
 04:53:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
Subject: RE: [PATCH net-next 07/13] net/mlx5: SF, Add auxiliary device support
Thread-Topic: [PATCH net-next 07/13] net/mlx5: SF, Add auxiliary device
 support
Thread-Index: AQHWuSmQu0bszt9Z8UKZllddFO+mz6nrFJ8AgAAhRqA=
Date:   Mon, 7 Dec 2020 04:53:40 +0000
Message-ID: <BY5PR12MB432206A2436F40E4ED4C02DADCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-8-parav@nvidia.com>
 <b9e84fd1-1af4-d979-184d-cbbeedec1aa0@gmail.com>
In-Reply-To: <b9e84fd1-1af4-d979-184d-cbbeedec1aa0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a172908d-97d4-42e2-87ac-08d89a6c10d6
x-ms-traffictypediagnostic: BY5PR12MB4904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB490475DA4293FE8E737D5C6FDCCE0@BY5PR12MB4904.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khnj57/C507MA3TNjmlR95ETnSIRwgf1M5TC1RgyEKiYP+E9PRzcu5Sox9jJpBob6S96MaVDHsJJop4doBMq6Pmy1TwKyiqtwaFLVkjNAg6ydxJp8XcFK0dV6Qyy5uHfu9xcCsl7+3x1l0zMx+PV0v71Mu9Bao6AQMcGYfPOY87bZZ6lXDslWl5qtOoxWfHFJ5cR/AHI4psWKyMoy9DLYqlffsoQDR3/fOXJpAhq9KbLpqzJUPoNJX8AEY8LX+3aDLSPws88OW3+PJp26DYDjuo6lcTca49OojPr7Zr2dBQpHoDXMYBQQYG3qaAkGAHSguBpZVpYAj2Raa5B8hvv7RQfbR/ne0HR+1CInByfEmhJyh1rv+km1GEPhK18zeDTuobORGUDo55+f9HALWLmTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(33656002)(6506007)(55016002)(316002)(66556008)(478600001)(5660300002)(86362001)(26005)(53546011)(4326008)(66446008)(2906002)(64756008)(966005)(9686003)(76116006)(8676002)(8936002)(54906003)(110136005)(71200400001)(107886003)(66476007)(52536014)(66946007)(55236004)(186003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?allJUmwvNUNuaHRuSmFXYVdONUZBbVlyQ3FTbkpkRURXRmlmenZ5M3RSZk92?=
 =?utf-8?B?S1BVaDdMM21ocnRLSUE2czNOcnBUNVJCNUZqRDZvN0hoRTJGSFRrcGwvTkNi?=
 =?utf-8?B?UnNsUkZFOTEzQ2tHTU0zYVpBSEx4UlNFanY4N1NPWGZxVUlack5BSHRWUURu?=
 =?utf-8?B?VjhDKzJpZFYxMzI3MHRSL2lwSWZsYUxJV0ZERVlBM1JKOHBidCtZUFR6WHVY?=
 =?utf-8?B?UGxWQWMrcG1Jako2RjlmczVndmpEOWszS1BtTVc4NmFrS3FHaXVmYW5FNFBx?=
 =?utf-8?B?Z1UvZUVYcUtoNDZNRzUvYlJTQS8xSnhYN1hRYzdraXNFS0wzWHQvajJhbFRD?=
 =?utf-8?B?ZjBtWUl3N2h5RllqRFpldkpyWlh6dTc5Z3lEWU94TFM0VmkydkxoSTU0OTN0?=
 =?utf-8?B?TWFQNjRmT2xmU1N1ZklNNmpOcHBRZUxtV05sL0FOcnFGY1hMTWJDOTNHeVla?=
 =?utf-8?B?OVpYbFlCUHBCR2MzZUxSY1hJbUFDMWYralBVRXFDdlZmdis3ODY1QXY5YWZR?=
 =?utf-8?B?clRGM1o1aEc2cU5HclM0OGhZTDJqd1A5dW1mdUZ5SXJWcDBrOGxaMEZ5NU5B?=
 =?utf-8?B?Wi9JbXNqN0lVUDNBbXpHS1RUd0FyckpkWFMwWThGaXZFVklHeEFNVkV2TDlQ?=
 =?utf-8?B?SHl2Snp5b0JFbnpmUWdHek8rUEpIUlFOSlI0QnJoYmtLcGJ1Wk1EMERvTTNB?=
 =?utf-8?B?cis0cFhya3pHZTBuLzRrSnZFWFdHNlpEZnAzMnBPc21IQXpMTnNUSks4bUp5?=
 =?utf-8?B?ZVNhMUpBOFVwSG90cFhtb3U4THNCR21SS2I3MXo0cVNDTGcxUFpIL2xWOXJp?=
 =?utf-8?B?V2ZDa1EvcWc3aTlBNy9MRUFBUWc3eThPRTVBeG1tR2tEREFDSXRlU3FRcUxP?=
 =?utf-8?B?TUxvUzAyaVd0eHdTb1V0ZitQTXFMeFdteE1EbWpndVlCT2J4cFhwWW1vOEpS?=
 =?utf-8?B?RGFwcWUxcFN0Y0ZHQXZRVVhkOURxcEExZSs0V3ZXWEVXUkJKbGd0SkdNdnR0?=
 =?utf-8?B?UE9hRHVpOGt6bU9QbHE2WTRPOXRxYmdTeUhLSHFYVFRERzBBa0hNNjFkUGhL?=
 =?utf-8?B?ZllaZTZrcmVxbUYzcE5Ya0g1TDlGeXplcmNNNisrRDFxUWlYbkNreXlwalNN?=
 =?utf-8?B?Nm1qOWVKWlBhRVRWNzRrZ0xXbVhnUVFjQ1phNFA1VUlTZFNKNjNMc2kvMmhJ?=
 =?utf-8?B?UHhscEdPWUxRdWR6YWQxU3FSbG4xVHRjaFNIbHlpM3lmS3F4cDZtMFhKWE44?=
 =?utf-8?B?RkUwNHhCV1dFbGJodjNpY2QrcE5wMFdSTTBadmpjYnJ4MGl3ZXNORHB0ZWZY?=
 =?utf-8?Q?JV5T8ETWHqnXk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a172908d-97d4-42e2-87ac-08d89a6c10d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 04:53:40.0265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3B/yKwbeT6TQSwm6RfY5rH/U8kUxkiMcw1Jh4+dDyZYq4akpjDYbFzIH6ls4llWi+ocVP3+M91g7MIWl2cIIPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4904
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607316823; bh=TUOUCI3xgIo8NUE5FPKIhD9WrQRGqmOyUtz4Pvc0t4A=;
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
        b=gGXuR+2eI0DFpSWMedgM6Nc1ZO5GGMTnP6a5uNpN+MLYIHQznedcDEMfOrHDa8/H0
         zFMWHgP9ZUAYPkz7ETRTLzpS6mIJR6FB2gjuQY2lI9x9RZVNG5QXb/oNnVG+M6f9sg
         5E9cltSKIL2BNFaTx+EgZRTma/C5aNaB0XRGJWpYGn8bWOS/n5jWXH2t8kH9uinkJY
         S2Fmz5PahoL3vDz9OYf42mAzrRehe0zg7quvUd1ZLyhf1FTCr+YfgYl7zWMNApuQAs
         X+2VN8WBeMheG2eA1srhm/SgMa0aqsWYdwihDqAc54OxuZu+4tuFyDm5xxZmMAMqAB
         /ARLhNV2x8ykg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBNb25k
YXksIERlY2VtYmVyIDcsIDIwMjAgODoxOSBBTQ0KPiANCj4gT24gMTEvMTIvMjAgMTI6MjQgUE0s
IFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL0tjb25maWcNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9LY29uZmlnDQo+ID4gaW5kZXggNDg1NDc4OTc5YjFhLi4xMGRm
YWY2NzFjOTAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL0tjb25maWcNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvS2NvbmZpZw0KPiA+IEBAIC0yMDIsMyArMjAyLDEyIEBAIGNvbmZpZyBNTFg1
X1NXX1NURUVSSU5HDQo+ID4gIAlkZWZhdWx0IHkNCj4gPiAgCWhlbHANCj4gPiAgCUJ1aWxkIHN1
cHBvcnQgZm9yIHNvZnR3YXJlLW1hbmFnZWQgc3RlZXJpbmcgaW4gdGhlIE5JQy4NCj4gPiArDQo+
ID4gK2NvbmZpZyBNTFg1X1NGDQo+ID4gKwlib29sICJNZWxsYW5veCBUZWNobm9sb2dpZXMgc3Vi
ZnVuY3Rpb24gZGV2aWNlIHN1cHBvcnQgdXNpbmcgYXV4aWxpYXJ5DQo+IGRldmljZSINCj4gPiAr
CWRlcGVuZHMgb24gTUxYNV9DT1JFICYmIE1MWDVfQ09SRV9FTg0KPiA+ICsJZGVmYXVsdCBuDQo+
ID4gKwloZWxwDQo+ID4gKwlCdWlsZCBzdXBwb3J0IGZvciBzdWJmdWN0aW9uIGRldmljZSBpbiB0
aGUgTklDLiBBIE1lbGxhbm94IHN1YmZ1bmN0aW9uDQo+ID4gKwlkZXZpY2UgY2FuIHN1cHBvcnQg
UkRNQSwgbmV0ZGV2aWNlIGFuZCB2ZHBhIGRldmljZS4NCj4gPiArCUl0IGlzIHNpbWlsYXIgdG8g
YSBTUklPViBWRiBidXQgaXQgZG9lc24ndCByZXF1aXJlIFNSSU9WIHN1cHBvcnQuDQo+IA0KPiBw
ZXIgRGFuJ3MgY29tbWVudCBhYm91dCBBVVhJTElBUllfQlVTIGJlaW5nIHNlbGVjdCBvbmx5LCBz
aG91bGQgdGhpcyBjb25maWcNCj4gc2VsZWN0IEFVWElMSUFSWV9CVVM/DQpZZXMuDQpIb3dldmVy
LCBteSBwYXRjaHNldCBkZXBlbmRzIG9uIHBhdGNoc2V0IFsxXS4NCldpdGggaW50cm9kdWN0aW9u
IG9mIHBhdGNoc2V0IFsyXSwgTUxYNV9DT1JFIGRlcGVuZHMgb24gQVVYSUxJQVJZX0JVUy4gDQpN
TFg1X1NGIGRlcGVuZHMgb24gTUxYNV9DT1JFLg0KU28gSSBvbWl0dGVkIGV4cGxpY2l0bHkgc2Vs
ZWN0aW5nIEFVWEJVUyBieSBNTFg1X1NGLg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGludXgtcmRtYS8yMDIwMTIwNDE4Mjk1Mi43MjI2My0xLXNhZWVkbUBudmlkaWEuY29tLw0KWzJd
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fsc2EtZGV2ZWwvMjAyMDEwMjYxMTE4NDkuMTAzNTc4
Ni02LWxlb25Aa2VybmVsLm9yZy8NCg0KDQo=
