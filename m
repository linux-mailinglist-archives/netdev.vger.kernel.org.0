Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1492FC96C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbhATDse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:48:34 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6171 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbhATDrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:47:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007a7b20001>; Tue, 19 Jan 2021 19:46:58 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 03:46:58 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 20 Jan 2021 03:46:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOTkUTfaKtv1xFZdFp+Iuz2UoYNE3dzUmlSmsDhbcG2BkC/299Wc+A9TwZ/hbnfVOYqSILCMOSbgFhSusyG7Kwlf34O8qX3RE/4YX7QWkrzV/JQ6Cuc9iFGz1G+ts7TPOB+ljayHD2S+7z4WvkoAb1/qSbDeUGxnLNEjalaZmg7pYraL/PJMJBFD+6aSUXWpiE4NqxcjkURxPqR9O9LqsRV5KmcWOloaR7LSiEO7FydytJx7CNSrs8EXi98qZsjUPxodugXUNyHwASFRLkLSKx4G6xeHda2+BvnJO0z8PrceJWJEPLZa2GjoiYVjZBCsdAlVt/7RaSEZL8YS/3+qOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7+hP31UYSLO97dhSiaNsQva+ow0+lGAHr76q9LMjyw=;
 b=auCK9UTKD5XXhAW1xMLp/jynaBlnMTFu8WpHWlC4SUYY+m5nd9GpRklBmDaB7K2WUv0VyychygP9ILIc4K4Fj+9lgmvKFqTqwxC+w4MAo3fEhX6n4nw0iAB3zgdTlMhB6DbPWEwU13QE1ZSBb9Z2g1CFomVuL9afBcwdkqHDhWsju91eVDTEjAlg7oHAdKODN66cUzPlxa2a9sBOV3lzEa3kZGrDz5odpLDlAr4G7XHPZVww9xTcYHIEcEl7sgPKWLVf5dzD9y4gc2GPh++XDiXbCAEUkFV1s1EoK2CxBt9w52Z9D4qxGTAW69MTTkXnHuZ1hZjYs8quktjGKqMMrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3730.namprd12.prod.outlook.com (2603:10b6:a03:1ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Wed, 20 Jan
 2021 03:46:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 03:46:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <elic@nvidia.com>, Sean Mooney <smooney@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Topic: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Index: AQHW404ZeuD1Nrf6EkKQQnhYNrY/9qoY6uQAgAAB4oCAAAVhgIAAAsjwgAAQXACAAoNJoIALCUSAgAAyM0CAAXa1gIAADQPggAaYp4CAAQ5YIIAAB8JQ
Date:   Wed, 20 Jan 2021 03:46:57 +0000
Message-ID: <BY5PR12MB4322A3FF3FC2609588AB0C98DCA20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105082243-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
 <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
 <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
 <BY5PR12MB4322309C33E4871C11535F3CDCA70@BY5PR12MB4322.namprd12.prod.outlook.com>
 <8bc2cf97-3ee4-797a-0ffb-1528b7ce350f@redhat.com>
 <BY5PR12MB4322C4FE356BDAEDD91E3917DCA20@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322C4FE356BDAEDD91E3917DCA20@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6512f41f-442d-4842-4ff7-08d8bcf60919
x-ms-traffictypediagnostic: BY5PR12MB3730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB373015424A8B4AD11512F484DCA20@BY5PR12MB3730.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zepzuGSaLKMBgoEaJT3sZgrGCk0eSROQfrvdalajOcyTQtxot8lEawTljHCWvRjf5lAXo1Wg/Q+45cdN4BWzgoT8c/Tx1eiUDSLyjr1jHwwkCXtGnhqhrGs9XKCE14BstVhT+373ZbaGXabRnrz/j9hB8YFaW8CvjCIUAmL3vMHflzIZUxvVBQ5rHSqE6ZoeNHT6zpJnSD6F41y8RsvTqHOIJyOsD+MVBZxA1Aa+UrlxiCvf+KdBUcWROBTfezoMTVQtvXIAsesaizPpipDy7bFO3+N2RL3eljkguTdazui6L8agwDMYfIhw6lHVMkSdrtDEls/ZvtWkLanJH5QoagXdcliZ5of/KoQx+ACi09imUTVn1aCOuvqtzIWgxJ/GtCmnBY3BX99praoGiAF1JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(53546011)(71200400001)(66946007)(478600001)(66556008)(4326008)(2940100002)(6506007)(33656002)(76116006)(66476007)(5660300002)(86362001)(64756008)(186003)(52536014)(8936002)(26005)(66446008)(9686003)(55016002)(54906003)(110136005)(2906002)(316002)(7696005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WXI4SkpSZzg2LzN2S2RFSUs5LzFNeEdVbk1YaFV1bys4YlZXYURPcElldWw5?=
 =?utf-8?B?cHIxMHhCQzA3Z3dyZXFLcjVkRzY3LzQrNWxmU25aNFZRek5aekdramU4NDVJ?=
 =?utf-8?B?cUhHS1pUM1plQy82YWUwTWRPcEJKbmIzdjJjNnM3SGFlYW82SEN5a2p5cTNY?=
 =?utf-8?B?QTlZQXVCaU5HQm9CZkZGNy9rYmE5ZGdyVEFQWXFuWXVnTDJJd09HSW9nbXl1?=
 =?utf-8?B?cXRhUVJMbENvNDVoMWlxS1hsM2dTU3d6MnpDcEJaNy9iYkJZME1Md0hnZnhr?=
 =?utf-8?B?YTZQYzVCeXc1bEZaNHVMS0xpZXBzNXpVZ0ZFMEpMUmw4TnhXUXRVWmxvd3FV?=
 =?utf-8?B?Wk8rUTZnblk2eTEyNmJXNEpQb1p4Z0ozNjQ4U2NIRDFTYUZ5U2ptWDdBZ044?=
 =?utf-8?B?MjZZNXlhS01WWlNrSXNUQVB0UXplbS8xcEo5cjAxRXV0VGR6R1lUYjNxSStq?=
 =?utf-8?B?TVNiM1Z6K3hhWnI0RmpBT2J1K1Jhd2h2dDBtY1ZiSWE0MnN0MFAyTHRWQ3RY?=
 =?utf-8?B?S094WDRCR0NGVlVqMTg3V2FQQXBQckFXdFN6WVBTTkhqU2JZdlFQczFXcTF4?=
 =?utf-8?B?Smc2SUloMjZGMFgwT2dwL0ZOYkIxVy9PNTN1bEIvUFNPN1ozbTAwYThtZ2h1?=
 =?utf-8?B?RnEvRklxMlJyZVBZMTVEUmVGclZHK2JVWGJmeFc1enlKZ3ZGNnBOQkpDOXdN?=
 =?utf-8?B?TER2ajFtb09maEt5WllXL1JLQU9BZ1BONnpuUTZBTDV1VEtUY2RyUWVHK0tl?=
 =?utf-8?B?SUxtRTBhK2pzdGNDZXM2V3JNcXc2bEVxR3hHVTc2Q1dDMTUzQ0FmbjF4cnJa?=
 =?utf-8?B?anFYdWM2RU96c2tOVFVxM2tGdEF2a2kzaWR3MUZJbkN5V1dQckFhb292dXBw?=
 =?utf-8?B?WXk4WHQ0Q1ArTndaQnZYcUY2MjRaeFVrTWlSTXNUZS9vdGsyWVl5YW5PcFFi?=
 =?utf-8?B?NXlUZlduZ3pvOTYwbDcrL0NLNXlHdmlveWEzWDk2eHdtbndWZWg5akN6c3pY?=
 =?utf-8?B?YTVWTUpLazhJR2dlSzlBQ1pLakV1WTVvR2UxSDd3R1hSVXYzQUl0Uk5WMWZI?=
 =?utf-8?B?N29aQWN1alRiSWdONXhydTR0WWN1eUpUUnJmYzBvYTExSWNHRDllSXY1Myt5?=
 =?utf-8?B?M0JkMkQweGhvSWtaSVR4VWhHMjRNdStyTFhsbkNwZkhlbm9aNkJmOWFWNW96?=
 =?utf-8?B?eElHUFVDcXNGN1B1eGNMRU1zeHllbHFsL0lsYitNQUZrdkVSd04rV0JSS3RZ?=
 =?utf-8?B?eXd4dFVzUHNZUjJCdmx2TFVhVTJVdVYweEhieEMramdVY3pSdDZncVE2T3Vn?=
 =?utf-8?Q?3dhnFky9NEhOo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6512f41f-442d-4842-4ff7-08d8bcf60919
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 03:46:57.2510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dywbuLYgLW1noTAon85gARyy5eiVuD9Ol05wvXe/JgHcv7dZK7tbkbf7cmX/4ZbtvAyBIMV8WUUtsSrfqLEDkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3730
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611114418; bh=N7+hP31UYSLO97dhSiaNsQva+ow0+lGAHr76q9LMjyw=;
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
        b=hTeNd3VH79pwGu99ypRVGnpSWXzwkqtOjHoteOuQ2D1rJ+vIVZ/m7NfpzG+r4eFth
         LKxE7uogHcFq3S8wuEu7PcYaZiL7FdppgD5hMEd5dQLeAcKlFAJUAgGQ1LpdW9cw31
         ub9U4V5V88+jZ/qnrtpGCk+09OT9i29KpwKM52izbXGQRH9BnZSfDJ298umD8adAsU
         inEU99QfpuuZFEpBsz0Qt4PDqqWzB8T5mm9N0O+E6wqY+FLTsFsEq7qyfL2K/TfcWa
         bQxmgk5ROZ84MSkGxGo/jBuGPMn6t2ZvhGtBQXVMKS/Bu3Ghj0H4tBXuvw9zXGRf+h
         UsGMVfjmwARLQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogVmlydHVhbGl6YXRpb24gPHZpcnR1YWxpemF0aW9uLWJvdW5jZXNAbGlzdHMu
bGludXgtZm91bmRhdGlvbi5vcmc+IE9uDQo+IEJlaGFsZiBPZiBQYXJhdiBQYW5kaXQNCj4gDQo+
ID4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gPiBTZW50OiBUdWVz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIxIDQ6MzkgUE0NCj4gPiBUbzogUGFyYXYgUGFuZGl0IDxwYXJh
dkBudmlkaWEuY29tPjsgTWljaGFlbCBTLiBUc2lya2luDQo+ID4gPG1zdEByZWRoYXQuY29tPg0K
PiA+IENjOiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsgRWxpIENv
aGVuDQo+ID4gPGVsaWNAbnZpZGlhLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFNlYW4g
TW9vbmV5DQo+ID4gPHNtb29uZXlAcmVkaGF0LmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW1BBVENI
IGxpbnV4LW5leHQgdjMgNi82XSB2ZHBhX3NpbV9uZXQ6IEFkZCBzdXBwb3J0IGZvcg0KPiA+IHVz
ZXIgc3VwcG9ydGVkIGRldmljZXMNCj4gPg0KPiA+DQo+ID4gT24gMjAyMS8xLzE1IOS4i+WNiDI6
MjcsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiA+Pj4gV2l0aCB0aGF0IG1hYywgbXR1IGFzIG9w
dGlvbmFsIGlucHV0IGZpZWxkcyBwcm92aWRlIHRoZSBuZWNlc3NhcnkNCj4gPiA+Pj4gZmxleGli
aWxpdHkNCj4gPiA+PiBmb3IgZGlmZmVyZW50IHN0YWNrcyB0byB0YWtlIGFwcHJvcHJpYXRlIHNo
YXBlIGFzIHRoZXkgZGVzaXJlLg0KPiA+ID4+DQo+ID4gPj4NCj4gPiA+PiBUaGFua3MgZm9yIHRo
ZSBjbGFyaWZpY2F0aW9uLiBJIHRoaW5rIHdlJ2QgYmV0dGVyIGRvY3VtZW50IHRoZQ0KPiA+ID4+
IGFib3ZlIGluIHRoZSBwYXRjaCB0aGF0IGludHJvZHVjZXMgdGhlIG1hYyBzZXR0aW5nIGZyb20g
bWFuYWdlbWVudA0KPiBBUEkuDQo+ID4gPiBZZXMuIFdpbGwgZG8uDQo+ID4gPiBUaGFua3MuDQo+
ID4NCj4gPg0KPiA+IEFkZGluZyBTZWFuLg0KPiA+DQo+ID4gUmVnYXJkaW5nIHRvIG1hYyBhZGRy
ZXNzIHNldHRpbmcuIERvIHdlIHBsYW4gdG8gYWxsb3cgdG8gbW9kaWZ5IG1hYw0KPiA+IGFkZHJl
c3MgYWZ0ZXIgdGhlIGNyZWF0aW9uPyBJdCBsb29rcyBsaWtlIE9wZW5zdGFjayB3YW50cyB0aGlz
Lg0KPiA+DQo+IE1hYyBhZGRyZXNzIGlzIGV4cG9zZWQgaW4gdGhlIGZlYXR1cmVzIHNvIHllcywg
aXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRvDQo+IG1vZGlmeSBpdCBhcyBwYXJ0IG9mIGZlYXR1cmVz
IG1vZGlmeSBjb21tYW5kLiAoaW4gZnV0dXJlKS4NCj4gVXNlciBuZWVkcyB0byBtYWtlIHN1cmUg
dGhhdCBkZXZpY2UgaXMgbm90IGF0dGFjaGVkIHRvIHZob3N0IG9yIGhpZ2hlciBsYXllcg0KPiBz
dGFjayB3aGVuIGRldmljZSBjb25maWd1cmF0aW9uIGxheW91dCBpcyBtb2RpZmllZC4NCj4gDQpK
dXN0IGN1cmlvdXMsIHdoeSBPcGVuc3RhY2sgY2Fubm90IHNldCB0aGUgbWFjIGFkZHJlc3MgYXQg
ZGV2aWNlIGNyZWF0aW9uIHRpbWU/DQpJcyB2ZHBhIGRldmljZSBjcmVhdGVkIGJ5IG5vbiBPcGVu
c3RhY2sgc29mdHdhcmU/DQpEb2VzIGl0IGFsd2F5cyB3YW50IHRvIHNldCB0aGUgbWFjIGFkZHJl
c3Mgb2YgdmRwYSBkZXZpY2U/DQoNCj4gPiBTZWFuIG1heSBzaGFyZSBtb3JlIGluZm9ybWF0aW9u
IG9uIHRoaXMuDQo=
