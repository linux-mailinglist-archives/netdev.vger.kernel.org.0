Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC0A2B8285
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgKRRCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:02:32 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:63029 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgKRRCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 12:02:32 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb553a60000>; Thu, 19 Nov 2020 01:02:30 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Nov
 2020 17:02:30 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Nov 2020 17:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/nZmH8djTJu/8CUm0wt+Ufi9AfZGdEAqFHWFasNiwqkP4ncUpIPhmdctZ+8RdajWfoEgHqYy6FIPqxRcTVMgQ5sihskIgmJoyMaKaa0stFHJ7qgIsFY0EOukFi+OBxaDR4zfk1J3pRX6OICloZBBHshrwBdXDIcDS0yebwOl5KIhA1zQXIku0lDh4Tmh4eUmlxgYA/WUS28UvTPxW3EA3olsOyWqFBbJLL5qVjuP55tFJVOk2M5DDvmTePbR9E42yGv12LBvfLXItG5PTX67vL8zEHtQ+YeFPd4HwJKIKXG+8Az0oL5lsx96dd+XCqr7p/s3cn1SslX2ud4GX3L3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rv+iPBSp+sYNSo2nWvy42jMpHnh6slneiIVlAQ5GoE=;
 b=URPvC2Izs9kSkeOhU27Q7zLmUE16iBycgFZehWvvkGG8gYGsCZf9ancX3e+D2i98SlJf3fig0geAQw85b9orYwuEsLKwogjuu94p5v821E/X+HUq8A/qn0VHVp2bVBHnVwuIYkTQKRiLgHxs8R7pqpt/jFKaSbQmdFnKUglAJKtMxEoJ+/CeHJspgsfn7hXMQBpHOEepPvrMUm7yeCyzQREdNU70edbCxgjevC8TfuGSkUW1C6+7E1Fs99q4hV3FcaaWcyLaNDDpaG0EJQW5oSQCgndB9/XXtu16rKrWN4nt4Y5UuyOJP4BDvBQxIpxDR+tDQm+3S+suXl6HnmMdQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3270.namprd12.prod.outlook.com (2603:10b6:a03:137::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Wed, 18 Nov
 2020 17:02:27 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 17:02:27 +0000
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
Subject: RE: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
Thread-Topic: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
Thread-Index: AQHWuSmOH7LCCBYTi0yxfqvbYXKqLqnOG2YAgAAG43A=
Date:   Wed, 18 Nov 2020 17:02:27 +0000
Message-ID: <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
In-Reply-To: <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd06ee29-f454-48ec-ef93-08d88be3baa3
x-ms-traffictypediagnostic: BYAPR12MB3270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB32705429E3D9566A1C79A4BADCE10@BYAPR12MB3270.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q8kWE9fAjtjm49O9VRyU+wa2CqiKbT/s0mSpzfQj26+PPeXJG3DoYUgEMveJRzWVuiDln4DqJE4iTEgrsVv75VzZvbIryR42XJ06FS56E0QJzP0SxA2n15AaS9PtSel/n2xZuR/rgd/Gj+40aPHpSQJ881jOr4Xrv4kbnVjlFiQ7InrjpSmNvx0mqrNi+msDy8TvUxyoJv7VdTNn2jkGYm7qiomkxoGUEcd01lDegLTuHzrKnG0qtc0xqL/GYL/kYacljWQLFhpnKFg6ZYy9d/q45s4Y6x0Kjq6ERTq4RKhWizrqSbW2Ti0vFlk4TaH3EPC2YILk6Xa/+z/ht8uhUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(52536014)(316002)(4326008)(83380400001)(107886003)(6506007)(5660300002)(66476007)(7696005)(8676002)(110136005)(55016002)(66556008)(9686003)(2906002)(8936002)(33656002)(54906003)(66446008)(64756008)(71200400001)(86362001)(55236004)(186003)(26005)(53546011)(66946007)(76116006)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LA9fZacxqbZ+YgTWEYqUyUagTXXwoUHZ55qrWU7TqHdCl0Kp138Zh8K/ENMzR0hsp0qfLHYh7VmnCKGgg/+OvVsMxhlz4r7mkEJDMoj39TAEwqoWZbnBAvNwF79SlYUFlSxf2lxQJDxZjJ3KlgPG3j8nzenpFqqgAXsFVi3fyl4K82MYq8Y1SSeers9q/UeuhYlFPaJWcpZA7iCpjADB4tZoEUN9CVjvYx1Nunkv4+JL/4t7oSO2ia+N4t0J4s9wJoniMij3qfWR0oRuiTHmQXzS8NroJLTvmaD5MtWLhi1EADUGljWJJA2m9rRJHN9/0VoXUkooPTedNZTBOWwoGgt034t9GufxAreAGX7vf1qEmsi+hlGf3XU2YH8okc0UZPXsE05FoJ/3gEYnDMknynY3oGonKAzzS1A9SkvRSi1MxkO5PKhvDoie/9AIvU1ujljz6EaFxB4Pt2IWx/BzJkPfbs/Ch3kP05lvAZdtICkxAN//I+rDNTWKFIRvj2ndNL/v9j/Ea0AhpE2Wj+cvusoqE8o8+wfsPYeoIbwG4Qm4w8VDCv5HzHMR2wfW8YWbwkZThe7n8tvd0fgWK1Q1tFFdRshN1s4hffyBEn4HRYv5kpzaqtpy/XcHtU6fW1LEKFI834Epl4sk5ZGGA6Tn9w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd06ee29-f454-48ec-ef93-08d88be3baa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 17:02:27.3846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSlV5pJ/YCYkeramXzeRGVi7KPPkTFAZ/dmkufcd4+kD4hGJ0tf/qiFaEyNe6IXlDQyMMSh3ELimgP3hk60d0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3270
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605718950; bh=+rv+iPBSp+sYNSo2nWvy42jMpHnh6slneiIVlAQ5GoE=;
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
        b=Iw1lyS6GRnhP+6N5KS+gxmNhqZg+c0meJmtds692TsUKHyu9YniObK6VQbI82rVUQ
         Gk5eZ0PEWSvp4RAtyzFXBmtqU4RWLLkiqCHbmdJqrvpfEMfZD996d/w7ENBxHb83rY
         4cQXwZAGa7YFo2PvVwjViy0rPivZQmqzT4PpMfnok0RHafAZH+6pEPj/8zoTlcjZ9W
         U2NAPi87HrYyk0PIrgwQGGTdM22ErLpi1r6cATXzAYsv6WFOiBTu6KGLSPR7PuiSFT
         rLT09ZggOGn8vsQVKd8iKTQnA9trZfJ5mpAgueKjWFUx0BW1VsU3cn5xt+Fif7WrxU
         5ADFCtHKYb+jw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVz
ZGF5LCBOb3ZlbWJlciAxOCwgMjAyMCA5OjUxIFBNDQo+IA0KPiBPbiAxMS8xMi8yMCAxMjoyNCBQ
TSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IEV4dGVuZGVkIGRldmxpbmsgaW50ZXJmYWNlIGZv
ciB0aGUgdXNlciB0byBhZGQgYW5kIGRlbGV0ZSBwb3J0Lg0KPiA+IEV4dGVuZCBkZXZsaW5rIHRv
IGNvbm5lY3QgdXNlciByZXF1ZXN0cyB0byBkcml2ZXIgdG8gYWRkL2RlbGV0ZSBzdWNoDQo+ID4g
cG9ydCBpbiB0aGUgZGV2aWNlLg0KPiA+DQo+ID4gV2hlbiBkcml2ZXIgcm91dGluZXMgYXJlIGlu
dm9rZWQsIGRldmxpbmsgaW5zdGFuY2UgbG9jayBpcyBub3QgaGVsZC4NCj4gPiBUaGlzIGVuYWJs
ZXMgZHJpdmVyIHRvIHBlcmZvcm0gc2V2ZXJhbCBkZXZsaW5rIG9iamVjdHMgcmVnaXN0cmF0aW9u
LA0KPiA+IHVucmVnaXN0cmF0aW9uIHN1Y2ggYXMgKHBvcnQsIGhlYWx0aCByZXBvcnRlciwgcmVz
b3VyY2UgZXRjKSBieSB1c2luZw0KPiA+IGV4aXNpbmcgZGV2bGluayBBUElzLg0KPiA+IFRoaXMg
YWxzbyBoZWxwcyB0byB1bmlmb3JtbHkgdXNlIHRoZSBjb2RlIGZvciBwb3J0IHVucmVnaXN0cmF0
aW9uDQo+ID4gZHVyaW5nIGRyaXZlciB1bmxvYWQgYW5kIGR1cmluZyBwb3J0IGRlbGV0aW9uIGlu
aXRpYXRlZCBieSB1c2VyLg0KPiA+DQo+ID4gRXhhbXBsZXMgb2YgYWRkLCBzaG93IGFuZCBkZWxl
dGUgY29tbWFuZHM6DQo+ID4gJCBkZXZsaW5rIGRldiBlc3dpdGNoIHNldCBwY2kvMDAwMDowNjow
MC4wIG1vZGUgc3dpdGNoZGV2DQo+ID4NCj4gPiAkIGRldmxpbmsgcG9ydCBzaG93DQo+ID4gcGNp
LzAwMDA6MDY6MDAuMC82NTUzNTogdHlwZSBldGggbmV0ZGV2IGVuczJmMG5wMCBmbGF2b3VyIHBo
eXNpY2FsDQo+ID4gcG9ydCAwIHNwbGl0dGFibGUgZmFsc2UNCj4gPg0KPiA+ICQgZGV2bGluayBw
b3J0IGFkZCBwY2kvMDAwMDowNjowMC4wIGZsYXZvdXIgcGNpc2YgcGZudW0gMCBzZm51bSA4OA0K
PiA+DQo+ID4gJCBkZXZsaW5rIHBvcnQgc2hvdyBwY2kvMDAwMDowNjowMC4wLzMyNzY4DQo+ID4g
cGNpLzAwMDA6MDY6MDAuMC8zMjc2ODogdHlwZSBldGggbmV0ZGV2IGV0aDAgZmxhdm91ciBwY2lz
ZiBjb250cm9sbGVyIDANCj4gcGZudW0gMCBzZm51bSA4OCBleHRlcm5hbCBmYWxzZSBzcGxpdHRh
YmxlIGZhbHNlDQo+ID4gICBmdW5jdGlvbjoNCj4gPiAgICAgaHdfYWRkciAwMDowMDowMDowMDo4
ODo4OCBzdGF0ZSBpbmFjdGl2ZSBvcHN0YXRlIGRldGFjaGVkDQo+ID4NCj4gDQo+IFRoZXJlIGhh
cyB0byBiZSBsaW1pdHMgb24gdGhlIG51bWJlciBvZiBzdWIgZnVuY3Rpb25zIHRoYXQgY2FuIGJl
IGNyZWF0ZWQgZm9yDQo+IGEgZGV2aWNlLiBIb3cgZG9lcyBhIHVzZXIgZmluZCB0aGF0IGxpbWl0
Pw0KWWVzLCB0aGlzIGNhbWUgdXAgaW50ZXJuYWxseSwgYnV0IGRpZG4ndCByZWFsbHkgY29udmVy
Z2VkLg0KVGhlIGRldmxpbmsgcmVzb3VyY2UgbG9va2VkIHRvbyB2ZXJib3NlIGZvciBhbiBhdmVy
YWdlIG9yIHNpbXBsZSB1c2UgY2FzZXMuDQpCdXQgaXQgbWF5IGJlIGZpbmUuDQpUaGUgaHVyZGxl
IEkgZmFjZWQgd2l0aCBkZXZsaW5rIHJlc291cmNlIGlzIHdpdGggZGVmaW5pbmcgdGhlIGdyYW51
bGFyaXR5Lg0KDQpGb3IgZXhhbXBsZSBvbmUgZGV2bGluayBpbnN0YW5jZSBkZXBsb3lzIHN1YiBm
dW5jdGlvbnMgb24gbXVsdGlwbGUgcGNpIGZ1bmN0aW9ucy4NClNvIGhvdyB0byBuYW1lIHRoZW0/
IEN1cnJlbnRseSB3ZSBoYXZlIGNvbnRyb2xsZXIgYW5kIFBGcyBpbiBwb3J0IGFubm90YXRpb24u
DQpTbyByZXNvdXJjZSBuYW1lIGFzIA0KYzBwZjBfc3ViZnVuY3Rpb25zIC0+IGZvciBjb250cm9s
bGVyIDAsIHBmIDAgDQpjMXBmMl9zdWJmdW5jdGlvbnMgLT4gZm9yIGNvbnRyb2xsZXIgMSwgcGYg
Mg0KDQpDb3VsZG4ndCBjb252aW5jZSBteSBzZWxmIHRvIG5hbWUgaXQgdGhpcyB3YXkuDQoNCkJl
bG93IGV4YW1wbGUgbG9va2VkIHNpbXBsZXIgdG8gdXNlIGJ1dCBwbHVtYmluZyBkb2VzbuKAmXQg
ZXhpc3QgZm9yIGl0Lg0KDQokIGRldmxpbmsgcmVzb3VyY2Ugc2hvdyBwY2kvMDAwMDowMzowMC4w
DQpwY2kvMDAwMDowMzowMC4wLzE6IG5hbWUgbWF4X3NmcyBjb3VudCAyNTYgY29udHJvbGxlciAw
IHBmIDANCnBjaS8wMDAwOjAzOjAwLjAvMjogbmFtZSBtYXhfc2ZzIGNvdW50IDEwMCBjb250cm9s
bGVyIDEgcGYgMA0KcGNpLzAwMDA6MDM6MDAuMC8zOiBuYW1lIG1heF9zZnMgY291bnQgNjQgY29u
dHJvbGxlciAxIHBmIDENCg0KJCBkZXZsaW5rIHJlc291cmNlIHNldCBwY2kvMDAwMDowMzowMC4w
LzEgbWF4X3NmcyAxMDANCg0KU2Vjb25kIG9wdGlvbiBJIHdhcyBjb25zaWRlcmluZyB3YXMgdXNl
IHBvcnQgcGFyYW1zIHdoaWNoIGRvZXNuJ3Qgc291bmQgc28gcmlnaHQgYXMgcmVzb3VyY2UuDQoN
Cj4gDQo+IEFsc28sIHNlZW1zIGxpa2UgdGhlcmUgYXJlIGhhcmR3YXJlIGNvbnN0cmFpbnQgYXQg
cGxheS4gZS5nLiwgY2FuIGEgdXNlciByZWR1Y2UNCj4gdGhlIG51bWJlciBvZiBxdWV1ZXMgdXNl
ZCBieSB0aGUgcGh5c2ljYWwgZnVuY3Rpb24gdG8gc3VwcG9ydCBtb3JlIHN1Yi0NCj4gZnVuY3Rp
b25zPyBJZiBzbyBob3cgZG9lcyBhIHVzZXIgcHJvZ3JhbW1hdGljYWxseSBsZWFybiBhYm91dCB0
aGlzIGxpbWl0YXRpb24/DQo+IGUuZy4sIGRldmxpbmsgY291bGQgaGF2ZSBzdXBwb3J0IHRvIHNo
b3cgcmVzb3VyY2Ugc2l6aW5nIGFuZCBjb25maWd1cmUNCj4gY29uc3RyYWludHMgc2ltaWxhciB0
byB3aGF0IG1seHN3IGhhcy4NClllcywgbmVlZCB0byBmaWd1cmUgb3V0IGl0cyBuYW1pbmcuIEZv
ciBtbHg1IG51bSBxdWV1ZXMgZG9lc24ndCBoYXZlIHJlbGF0aW9uIHRvIHN1YmZ1bmN0aW9ucy4N
CkJ1dCBQQ0kgcmVzb3VyY2UgaGFzIHJlbGF0aW9uIGFuZCB0aGlzIGlzIHNvbWV0aGluZyB3ZSB3
YW50IHRvIGRvIGluIGZ1dHVyZSwgYXMgeW91IHNhaWQgbWF5IGJlIHVzaW5nIGRldmxpbmsgcmVz
b3VyY2UuDQoNCg==
