Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30577393C00
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 05:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbhE1Doi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 23:44:38 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:51668
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229883AbhE1Dof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 23:44:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cc5ohqf+v34x5DhG7su4cH74BxsKyZadhfUKaSovvmRrthWCz9JmdXN7zo9a6OfOrywpFsNPPJtfKGq/OxY7opuBmoG8ThiDltJqplhvvfT4YXRRPZkT4mr80p23anuhjjlfnoNHMWSAlHem81WFnTuPqM/kO1xIWvSdIetXpHfdVYYS8XNHxSSdjn4l00WTrJVyaSxbpOCucODhf6jPFOxmqbgdehsS63W1FfUpx5vpf/lBIWVk8kvUSQtxOw1oOPeLQtKqYrItq6IS4FslPbXDGGEKh7J9d+Ci39NrKmRaRB3O8IRQXE7Jr03wzNy8D06AkbOahTG4rcWi8mVLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoLWI4u0R0e1kQmJCe0RbwLRfqNsQPCAdSqLVem4Os4=;
 b=VsIiQHY/3m/yRQzWznvqUtzJfrhW/ajiFKJOzui8mp7pkdCX/5KLnalK9i6DJWmDBqlvL2X1YM3h6FZbWOopMepqG+Gblf93cZuRKQQbNeEOfHeWmjynaf3zd0UbHj+m4Rx6lb842eAbdBXiWzx7qqv5bsf5UDUvAQIGpDf4CqpsCyRImTYIwQdbgIhsBOBo9XAeWd6nHMBlsDr8xemBbGCkWArrF4tM3H21b4kfK3VHGTRB9N1GyEy8/DzIqPAKJdkp50+hLeI4kdIc6zziqLgxuV9Lx7GyAbWe4CGtAQvU4KCRSNeyNwS7B/dviZsCJJEZWtF0grlF5efHorl4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoLWI4u0R0e1kQmJCe0RbwLRfqNsQPCAdSqLVem4Os4=;
 b=n7bjTQ5ZFMYvB/DGvVZWMML5vDUgqDITWQCZyLttxVdnPKQ2gOWORVmshpznKjamCd00WVL6SW0vWONxWwCGjT0yum92EJaBK/T1MFcIKid7NiCCkTisIVb4wS4W1Fox/AGUsQuz/T4X7ao9qIBe9semBHSBfjU/uFB0myn/znWOvcwVWSWqNIBA489fHcwW7gYKwVj9KFC6ZVpYRnUk2TyjqVjjrdU7lk2Z+/r8zh16UejKxnQefrFMFEGlUC7K3aYS3/m9Ku0QS7unYX2B7qFbhViDeKiXB6AawV7STaxpgaNJ4Wr5oh9aGoGjPWOMVx+NHgSYlCimL2TpOOp4Bw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 03:43:00 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 03:43:00 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: RE: [net-next 17/17] net/mlx5: Improve performance in SF allocation
Thread-Topic: [net-next 17/17] net/mlx5: Improve performance in SF allocation
Thread-Index: AQHXUrH3qlFIS2GAPUCc7sjt4jqkRar2w/wwgADpegCAAJN3wA==
Date:   Fri, 28 May 2021 03:42:57 +0000
Message-ID: <PH0PR12MB5481A6D78F0304C5BDED25C8DC229@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210527043609.654854-1-saeed@kernel.org>
         <20210527043609.654854-18-saeed@kernel.org>
         <DM6PR12MB4330F30E51E9D86F2AA212A7DC239@DM6PR12MB4330.namprd12.prod.outlook.com>
 <9763798a76af3b392bf324af6fe3347b46fbd40c.camel@kernel.org>
In-Reply-To: <9763798a76af3b392bf324af6fe3347b46fbd40c.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c28c58e-9d66-4afb-2820-08d9218ab0d5
x-ms-traffictypediagnostic: PH0PR12MB5500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5500D4D7B6D177E887B60C1ADC229@PH0PR12MB5500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GvDG1n4BIFwn4/Ohp/BkGJOvQzoGSAenWqDycIKFibV1Q2S6CKvBhKxExvfaEMmR40Ixg8bck+glPTfeuqbHhCY9PDS6X5yoPHAFpWgpz9/RgoSFtym3OLco2X+3qpiC5sw6KriHkF23Uz1X4rEEnqFF5LkTKGP0qmzADwZsJgBHMFMZ8c0jsYqwWRwlqr+KX5kloZmGvlw21qNM9OPLBmsAoYHjCQpoU/LmgjEjiHtQwOBECrfuPgjjfoDhPvI+mh0ym4Agg9gmP07ZB2rY9Km5GWHVjiaD13Iv2aH0Tn9BHEbitudxcqwXMrBbfrv2bT63ErRuPWHOCWWYIYkNkiivEL1u1OcSe+SFXQ3e8GrMOgWiL9NxucmPkEhBpAYyWn38fWCzd8yokUWMARMZvnl/6wb8i4x4r/joT3jdhISsCR0wqFGu4+DpMbtm8f/HwRHRn3tUL8DPUZ1Mg7MQx+zE0t722jfAr+mqfoEx1Rx9u9K1CNn9jTf3w+A+zF/ShOeXYyWWSHoThsuvYcJnhJf3dKaEf884QixBLNUBRbsPvmLuypp2b5vQtqYqMewFFAJX2lbuZ5YPBW6xJOAFR8wgIr5tt66ePOKRUJsom+s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(4326008)(107886003)(4744005)(8676002)(6666004)(76116006)(66476007)(66556008)(64756008)(66446008)(71200400001)(33656002)(66946007)(86362001)(478600001)(122000001)(5660300002)(38100700002)(186003)(26005)(2906002)(6506007)(55236004)(110136005)(55016002)(54906003)(52536014)(8936002)(316002)(7696005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a3NIRFNzaG9raWVXSG9pQVBvc3pGVUVBQkZLUkF3Z2ZUcS8rcmFhUlV4UEcy?=
 =?utf-8?B?SlAzZDVPWUxuYUVObXQrZFAwc0RaYURDaHFZOHdmcklLWjVvQk8rb1plSTVR?=
 =?utf-8?B?bmdaSFozNm1kYSs2WkdQK3NXbktXZHo4T01FdjZtQVFkVUlPenpoMDZQUmVs?=
 =?utf-8?B?bmtjdkttNjVWYk5pdlNUaXREZ3ZicWRnTkZwKytWaktCdExyTDdReEZXWDJN?=
 =?utf-8?B?UTViVGhNWk5ZWVRDRXJ5MDlTaXF6NytlNWdRcTNscHk1QU1aTzY4WnFDcU5h?=
 =?utf-8?B?UGI1UG1aWHV3NThRcUQ4T2lpL25WaWpwNXpFQzRWVnkyYkliMnlVNE5QajEx?=
 =?utf-8?B?WEc1b0FQNEZrTmxmWHA5WXRIT1N1UlVHUEo3Y0ppb1A4aUpaaXJ4dFBNNUxH?=
 =?utf-8?B?YXN0MlZLRFFxWEpvbGVMa2tTQkZ6OHhueEtyY09PTU5oVFMyNVNyT29kU0ho?=
 =?utf-8?B?OWNLalVtOHh1MWoxV3lMdFJ3OFdET0E5MEFpRm94RVFXWFNXM0VBRW9lSmlC?=
 =?utf-8?B?OGNQdTNYaUVRUGRoTGxqTldHZmlraWRBMFdqdjlucm9yc0lRS29TamEzWjBW?=
 =?utf-8?B?MjNxdkhScFRhQzFsUU4raEU4dEpQZFBTeHluQis3K2xxR28vUzVPK3YrcFh1?=
 =?utf-8?B?Q1V6RFhLR3RZRDBGdnEycGJhQkJnQ1BMSkh4WjNVdWlYaGswSEl4LzR6Y3FK?=
 =?utf-8?B?RkNDYS9IY2ZxOTdZVFJJSExvUUwxTmRjSktFTWwxNjdNRlpXVzMvSFBCQW5H?=
 =?utf-8?B?S0l6OHFsRE9aK0Fuck4valBvaEZIUk9zUSt3NTkyelR3RGtmcHdMVWpjS1lQ?=
 =?utf-8?B?SlFSb1g5SHZzRVBsMksyckRWeU84WTdHSmowRWJFc3BoblJOdEpaS0ZqNnRa?=
 =?utf-8?B?aUhZNWVibGFmMkFGaXFKbFM3ZVoycys0cXNlZG1Qa05SWkh4aGszVldveHYv?=
 =?utf-8?B?dkxuRTNzbmVYSFFWTHhZUVYwaUI3cTcrNktaNC8zNXBJeDlyaU9jTG5iQ1Iw?=
 =?utf-8?B?ekZsb28rYmpHbklTTFdjaVBENWZ3K016V0ExVUFscmtNNm5CMVMxMys0aSt5?=
 =?utf-8?B?dXVMWTBuVk12OVBKa3c1S1FJa2ZsY3E0K2laZURvOTdsSkR1VkpDOExmSXpI?=
 =?utf-8?B?dHNwL0dTY1ErTHMzaWdRc3FvWHg2Zlk1dldSeXYxTnlpRW4weUNuQWdQejdr?=
 =?utf-8?B?c3lmYU1EVUQvTElVOTBzRkMxNkg2RzllQ1N5eXVET1VrWitmc3pXK2U5TjJY?=
 =?utf-8?B?NXJCd2ZEeXJaSFQvcjFvU24xdTh6R1NMN2xJenF0YnEzc2pGaUgraSt5K00x?=
 =?utf-8?B?Y1RnTDlqV2FPdVNUZnRSdVp2b0dwYThaQllQZ29KazJ1V25Sakl6VGl0NHZv?=
 =?utf-8?B?WVBpYzRkMHJ4b1owaFlvN0ZPL2NtUXBFZGh6OWdLM01pdFdyUXR1NzYrS0hD?=
 =?utf-8?B?eGZmYXpaaERwTHEvOFUveW41NnlQWlc4aWFlYkVSSVE0Ly9zN0ZpZnlSSjNM?=
 =?utf-8?B?RlQxU0tITTRCcDF0OFFQc244bGdMRjBGQXYrVTN0UzNaTjYxWFR1aWM1aHho?=
 =?utf-8?B?U3BqcnY1Y0ZDdGU3TnY1TEtNcUdWSG1SaGY1eHZBRTMyZkRZV3ZJOXd4VzhF?=
 =?utf-8?B?WGFCUXlKaHZpYnRYT0g4RU12QVNGL0xUTDRsaDRGdnY4Rmh5WWRJSDYyOEls?=
 =?utf-8?B?VE45OXFKc2ZYOU01Q0thM2RibVg2S2c0OUN4cXMrS0g2TCt4SmhmTjAxWG12?=
 =?utf-8?Q?3hiL9wBXSKcnPa1HLfpZewq/7bGDqeD612qiLyn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c28c58e-9d66-4afb-2820-08d9218ab0d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 03:43:00.4493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brtjf4wAI8vQ5aLs5Nhfq7GBMvz8k5L8UNBLoxObmm16PQtP11c3PB6FFZpUmmrJMpXwWzyzzaMaK0i50m6SLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IEZy
aWRheSwgTWF5IDI4LCAyMDIxIDEyOjIyIEFNDQo+IA0KPiBPbiBUaHUsIDIwMjEtMDUtMjcgYXQg
MDU6MzYgKzAwMDAsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+ID4gRnJvbTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+ID4gPiBTZW50OiBUaHVyc2RheSwgTWF5IDI3
LCAyMDIxIDEwOjA2IEFNDQo+ID4gPiBGcm9tOiBFbGkgQ29oZW4gPGVsaWNAbnZpZGlhLmNvbT4N
Cj4gPiA+DQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGNvbnRpbnVlOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9DQo+
ID4gPiArDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGh3Yy0+c2Zz
W2ldLnVzcl9zZm51bSA9PSB1c3Jfc2ZudW0pDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUVYSVNUOw0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoH0NCj4gPiA+IC3CoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PU1BDOw0KPiA+ID4gKw0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGZyZWVfaWR4ID09IC0xKQ0KPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PU1BDOw0KPiA+ID4gKw0KPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgaHdjLT5zZnNbZnJlZV9pZHhdLnVzcl9zZm51bSA9IHVzcl9zZm51bTsNCj4g
PiA+ICvCoMKgwqDCoMKgwqDCoGh3Yy0+c2ZzW2ZyZWVfaWR4XS5hbGxvY2F0ZWQgPSB0cnVlOw0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIDA7DQo+ID4gVGhpcyBpcyBpbmNvcnJlY3QuIEl0
IG11c3QgcmV0dXJuIHRoZSBmcmVlX2luZGV4IGFuZCBub3QgemVyby4NCj4gDQo+IFRoYW5rcyBQ
YXJhdiwgSSB3aWxsIGRyb3AgdGhlIHBhdGNoZXMsDQo+IFBsZWFzZSBwb3N0IHRob3NlIGNvbW1l
bnRzIGludGVybmFsbHkgc28gRWxpIHdpbGwgaGFuZGxlLCBJIHdhaXRlZCBmb3IgeW91cg0KPiBj
b21tZW50cyBpbnRlcm5hbGx5IGZvciB3ZWVrcy4NCk15IGJhZC4NCldoZW4gcmVncmVzc2lvbiB0
ZXN0cyBzdGFydGVkIGZhaWxpbmcgaXQgY2F1Z2h0IG15IGF0dGVudGlvbiBhbmQgdHJpZ2dlcmVk
IHRoZSByZXZpZXcuDQpJIHdpbGwgcmV2aWV3IHRoZW0gdGltZWx5IGdvaW5nIGZvcndhcmQuDQo=
