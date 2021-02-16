Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BACB31D26F
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhBPWGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:06:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10747 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBPWGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:06:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c41c40002>; Tue, 16 Feb 2021 14:05:56 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 22:05:56 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 22:05:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myXfQc8DZjEaLIgoFVZLCPlW7ByZS+Eah3gCwQdXkeEJ0vDsMYUgeoayKVflKli/UgVDhKQVUuAcHwJ0yjnvlNwwFyf9ZuvgXzvt0R4tnPqXzEtE3lSWbPwf30RaQiT64gjLMObfqKzhGVCxbtWtB0WQM0AVacwYXoF0TL9yfCdqaVAxnWcmWY/91a7Vgrbrteq+Oh4MPa3x1jUpRLAAATX8fxcGdYs68PbYTpF1J7TT4mLso4i6mJoetwr3ech+dMjbqcpucRXnR3uDXE1HfzmD4xnP+FVpoVkNJmI2ALdjDRvYZiSAw4H713dMNFown6gOU7/DptLYGI6pK6Uc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dcE2ilpuDiGu/oetlV2BVkG9Gi4380dXuZsMac6fXQ=;
 b=g3F/vJMzkRf/4zclfTQfponnGezfKZtlwl0IDAJY3jJJzIollAAVairNku+N9powKtUPQvekqYTZ0eCKh1OJ8FN1YahPSRwgcG7PcRwxGDDCZ3/kkeqooPShqxvM57MoiwHekrcjrVPoX51s16ZIHoj2DbhLSDhgi7b58L4XXlyIp0mKtCeZJ50ckQ6A/NluiBWqnq+3oUgFv2UZDnXuekkwe/MWXImlRlcopEfcRZVhA4zi9stSvSL7xOvEplCIEpiWcPdHm/flv9tnhJ+ML1cQ723CyyzKZYgO7DTjPEgJmrcEoChytSZjq0NGnttaCE3vj1bNpAQmnisbab9XxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3747.namprd12.prod.outlook.com (2603:10b6:a03:1ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Tue, 16 Feb
 2021 22:05:54 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e16c:ea19:c2a6:d8b8]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e16c:ea19:c2a6:d8b8%5]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 22:05:54 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/6] net/mlx5: Add new timestamp mode bits
Thread-Topic: [PATCH mlx5-next 1/6] net/mlx5: Add new timestamp mode bits
Thread-Index: AQHXAY7BhDXdvLAbP0OyDJ/IRkqbLKpbOniAgAAiM4A=
Date:   Tue, 16 Feb 2021 22:05:54 +0000
Message-ID: <70e16478e13445b6e5e871e572aac8a19c2343bf.camel@nvidia.com>
References: <20210212223042.449816-1-saeed@kernel.org>
         <20210212223042.449816-2-saeed@kernel.org>
         <20210216200329.GA2221694@nvidia.com>
In-Reply-To: <20210216200329.GA2221694@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ed044e8-ca9e-4315-2569-08d8d2c707ed
x-ms-traffictypediagnostic: BY5PR12MB3747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB37474B8FFDABCF546151D666B3879@BY5PR12MB3747.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iw6pvicp8krUlMq+t1qqAeDStIWZnbX1JeDmw02TL4I+79OCuU5sLj2wTbpPpzQvTow6arpNHr6MorsDN4oIH4W44VviqBh37krtpMfWQdy+v4HB/OnEpXYfNjaSSTPPGcuvfVOvGxJGBCdqRtTbKvfH3VAkP4xUbiIuSOHuhQebQqD7JpcpQlVPwuPR65gcrVZJ6ZaKII1d1hp5lBslrR9j1wsdiZtVxOoJiMcvbOawJ3MAkek38kIGrY7uFLPdjaHvZ2A/eKLwLHwOYJ2LJnXkJ2UDp3vGOAsojKefRErN/tTY44bPlTcuYMo5gh2NXAYls784mEMezI8mXMIs2IkZXxx7kcbRuHSZKTLmuXCPUOjOwMO+NnnFfd0q9IMiahIoorOPXfLPGfX9dM4zf3LPX+Z0hHIwnLd3+i+GKB+zouz0JDyoh5B9p3zBZ56y9QvJ6rf35a8hpK03DkNmOSo3hqQ3fdVcOSyfBNOVx5qNKjpsG1JU3PIZ8Li6e/L/V0E1cTAHh3bF4OCxfFAWKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(91956017)(6512007)(26005)(4744005)(71200400001)(6636002)(66946007)(66476007)(66556008)(76116006)(2616005)(64756008)(86362001)(66446008)(8676002)(186003)(6506007)(5660300002)(37006003)(36756003)(4326008)(478600001)(316002)(2906002)(6862004)(83380400001)(54906003)(8936002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?KzNsdE1YY0FlcU55dytnWFAwZ0xxaWg1aGZ5d3cveElIQzNhRFZaQTl2b2VN?=
 =?utf-8?B?MXRNd1pPS3dybTlySU12LytBV2hzWWIxUWhwcC9GbHhjdE84bFFkL3lRdnFH?=
 =?utf-8?B?N1Y4dmNhQUQybnFGdUoyNHJONnMvdE5nTFN6TzBueE5CTC9jM2VKK0tQaWxv?=
 =?utf-8?B?TFB4MWxrMEd2bzd6SEd1NGdZVUtZVFlrTkVxVTdwRG1ISzBZaEswdEo3bFRP?=
 =?utf-8?B?c0FOSUFtWnVaN2VjM2t1N2JOZCsyVDRtdzB1TGdvQlZ4NGI5bXZnNVZ4ZlZC?=
 =?utf-8?B?YW12bGgyMTdsMEhNbDB5OVZqOWsrVVI1UDRaT0dQM3hJK3B4UW5vWklhOTd3?=
 =?utf-8?B?cFdCeDZWK1RSc25pZmJPNERrQmpBR0tsVm0venRKZW8wdnVDUEoxWCtWbnNz?=
 =?utf-8?B?UUpneWE5K3NFbGc0L3JDdnFmSmZyV0FNYWE1V3FXbmp5bWNpc2sxQUNFcHBX?=
 =?utf-8?B?Y21XdEpiOG0va1JBcno2eVBtVmlFb0tGSGFreUdFQitiYUpYVEFSYlBxTmQz?=
 =?utf-8?B?emR5VDhoUlVCaEs0ZFFjNFlPa3VjbzkwMUo3NmxBRXM0ck4vQkJwQ013OU00?=
 =?utf-8?B?ZzVQTnF5NGZnZHkrYjBEVG5helQvbFdadUFIYVFVa0dRZExYa0hha0tJL0tU?=
 =?utf-8?B?TVF6aVVWYjdoaDIwRGUvOStJSExsNWJPNnplaGRVd3l3L2ZBcktBZ2p4V2kv?=
 =?utf-8?B?a0t6bmZTbW13RzB2VmRCdGsveFVCU0lWdVA0VGI0V3UrSEtMZVVZSHV3M3RH?=
 =?utf-8?B?TVNyOVgrcDhuOG9RUE0wQzFVb2xaVGllUUExcHBXUGZ6UGczOTNTM0hvRnNK?=
 =?utf-8?B?SE0xbjVGWEg0R3RRb2d0VzJmME9HYTJ1NVBnNU5yQ0xsR1JjMWNCQzhYVHdN?=
 =?utf-8?B?cUFSbWtHNEMrU0NCQlZkTmFndGhoMDdTUktmT0NVZ2c1dnROa05FS0thdERS?=
 =?utf-8?B?b25pYzc2b1RiVFNYMEhTZllkM2NFMkUwQTJmL2YyQmFEOWltV1Y1Z1U2dW9T?=
 =?utf-8?B?eVNGN3QrNk5WMUVRQlRuSUZGTWZBYUtsd3R2bGhMK3lmRit5azhQdkk5OER4?=
 =?utf-8?B?TVl4VUVIZGN6Tlo2YnpLaXZ0S1d1T3JtTkI5ak84WmIzaFc4MFFiTFE5NlFZ?=
 =?utf-8?B?bUxYK05HNEp2ZVdUSXVZbGhCMmV4S0VUcjB6VWQzdXFWc2F3RXlPNU9ac3Rs?=
 =?utf-8?B?M05zK2lyUjZWR2JWZjZwSHVDWWxxUWwwS3hNSzRpK0F5aTNRazFuZXhnRnZH?=
 =?utf-8?B?a09tVTE2ZzljdTVTcUoyNVh3bHRxMlRqa1k5OXEzOEVIMzVKODFTT0YyUzR4?=
 =?utf-8?B?dUlVcTZhOTlrbGtJK1AwOEJ1L1c3bkJYZndCUFl4VStjaGthajMzUE1GbHV4?=
 =?utf-8?B?clY4RmlSWS85RnJMSVo4WWdWaXl1Zk5QdFgyS1RlRWNVaGhDRlRCc1lXWElU?=
 =?utf-8?B?aG90aXYvalpZWVplb0haUVFxdGFETGhxSzhlcHRudzVSTTI2bEZDQnp3Mndw?=
 =?utf-8?B?WGIvUGlFR1BZT0FxOTEweFEyd1pWaHRsSVN5czNZWElSOENyYmJmamNxU25w?=
 =?utf-8?B?dklONFRtYjYrZ0F1SXlzWmtzdFhHQkVmWnFRaWFoTFZHeWxyOUVoWldHM1k0?=
 =?utf-8?B?anBhZ1I0WEw4REwzdTUxeUM2bHVpblJ4RDBPa2YzSkgrQmRtQlNqYzJ4RUVB?=
 =?utf-8?B?Skd5UGtvN1NiRnhPT0RTL29OZWRHdnBxVWJKMEZwM29idGlIVXRZMU1ydWhT?=
 =?utf-8?Q?Kpl9XXoU3maWbzif3HNGgW1rCcZrNCBJKY4J1/j?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBB887BDBFA2AA4A9C4F91A7760D4A90@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed044e8-ca9e-4315-2569-08d8d2c707ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 22:05:54.5117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xrRs6SHE/7jiJSri1nOkqyCvKTdqaCRnR9jPtOdVWSEUgNBFyK3eM5IXiZtEFTIiBGNpEjbka5ldmvGiGILfIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3747
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613513157; bh=+dcE2ilpuDiGu/oetlV2BVkG9Gi4380dXuZsMac6fXQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:x-header:
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
        b=CgW7Ruht21UuHMSD+1gIqzeKcoRUyak/oXwQlu2aF/yWh+nEOr13QGBx0dUdrpdc1
         SA2LDZEWKBWa9Eu1lDshoc/rqwMITX9/BwW7MMRI1QKE9b+urwX0EFqVFUJmTxXQoc
         xCNt5j8ObpXNcu/OcTEr/In+OHB3bH3sGXTd/ulPoTWXaigx78wm9KrextXG1JZiTg
         3In5UVnWiNcO2w5o0/KciUbyM+GovuP8TRsgxOlvN0afOEjd8CZfPHiVDd0bI4qU4G
         3gha18k1JKsu9YItpn2GpeyHUrsbwED6eumFV6++0r1WxgleAAy4/APv2QbJKPL2M/
         g5DX5ZAEbBCOg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAyLTE2IGF0IDE2OjAzIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIEZyaSwgRmViIDEyLCAyMDIxIGF0IDAyOjMwOjM3UE0gLTA4MDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IEZyb206IEFoYXJvbiBMYW5kYXUgPGFoYXJvbmxAbnZpZGlhLmNvbT4N
Cj4gPiANCj4gPiBUaGVzZSBmaWVsZHMgZGVjbGFyZSB3aGljaCB0aW1lc3RhbXAgbW9kZSBpcyBz
dXBwb3J0ZWQgYnkgdGhlDQo+ID4gZGV2aWNlDQo+ID4gcGVyIFJRL1NRL1FQLg0KPiA+IA0KPiA+
IEluIGFkZGl0aW9uIGFkZCB0aGUgdHNfZm9ybWF0IGZpZWxkIHRvIHRoZSBzZWxlY3QgdGhlIG1v
ZGUgZm9yDQo+ID4gUlEvU1EvUVAuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQWhhcm9uIExh
bmRhdSA8YWhhcm9ubEBudmlkaWEuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFt
ZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGluY2x1ZGUvbGludXgvbWx4
NS9tbHg1X2lmYy5oIHwgNTQNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0p
DQo+IA0KPiBUaGlzIGlzIGEgY29tbWl0IGluIHRoZSBzaGFyZWQgYnJhbmNoIG5vdywgc28gdGhp
cyBzZXJpZXMgd2lsbCBoYXZlDQo+IHRvDQo+IGdvIGFzIGEgcHVsbCByZXF1ZXN0IGlmIGl0IHdh
bnRzIHRvIGdvIGJlZm9yZSB0aGUgbmV4dCByYzENCj4gDQo+IEphc29uDQoNClNlcmllcyBhcHBs
aWVkIHRvIG1seDUtbmV4dCwgaSB3aWxsIHNlbmQgdGhlIFBSIHNob3J0bHkuDQoNCg==
