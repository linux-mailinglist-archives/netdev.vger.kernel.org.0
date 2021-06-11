Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52713A45DA
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFKQCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:02:17 -0400
Received: from mail-mw2nam10on2069.outbound.protection.outlook.com ([40.107.94.69]:26209
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230387AbhFKQCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:02:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaBUW/f/Ufy0YlXaTj9vB5ir0YI3O0eLEeVPVTpXmzpylfMUDqox8wM328pQ5Gox07qAjcQTg68chWRJs171TFzCkTmTGfTcdMeuncXxFrUsVM/s6nBms2PCEOPblxvFpeUcGSHUsVjQcwkh+x5xTlti4KEq+sjdXdcsoJhSJCcZvhn7fdfUycq/psVRnxceVKJOO3kmgo4tjjA30/eo4AWJQs7lchlg1XE4NHHrB2f5UDCYw2qBrAh6zFSa7QafDss+hGmjYKPSGL8xEaHbvvSYjte+t5gy5sh/oZpkfGjm3CX3wlH5NoOa7I5M84E7LKF3aG9c/7Abrm3QcFa/1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKK6POpSHBKdM6ogtoOB0sE31TBhlUBK7zEv37NJlhI=;
 b=ih4KaTwXX7wiEO+O3k18/B6la6ljUk/pCZOac4Z/L1r3I7YAH4V8vC8wTym/18wAnTDcqUUebccfQwVNyhZ0r/KAUlzB5h69X57Dk/vEaoCjy8q8vDVGyiBIJLzEvEQ45Viq3sAOdEt2knDVn5a2+KsV2UnS+RTPqNCm448J4EUGZ9fT9Ad8UUCkBRq3HEhpCjiYnVjCxxzMywF7GNVUcdqLUtox42gBzukDMrZYj+XFowpVJfzjVy7ySSzNp44wNJo/AGLmSlWiozK6+ASMGV5eNvhnC2RYDsZ+1zmDMVuuhHqJbh9TsnJ4sqAOWtRkP1k5NRyoFqNkSqK0MmRoRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKK6POpSHBKdM6ogtoOB0sE31TBhlUBK7zEv37NJlhI=;
 b=Sm0QjH6aHPvKRE38otJFh2dylpTEcU00j/yMI+99jEHb8z7vZbTPDagLcA0JCeDPUJa/+qLvmhBpIsANr2cxyclsuzTRFylzSS30fZbnIep97tzQrlpvtC6kyrjBh6OgW7GUSeh10KhRTJI9ybH9DePjFkrwc51wbN0DJvz65zv5At0EjY0KNmmhyNtWljY10BqiTQxvXOboCW5iKjLHYSIykXctea7dlDqxvvAgMjwByqDIX9z+VCtCtEJM26vvh68xxQBiGI+vGlyi2V1XVGBgMmCtIQxWJoqOxNtEDkU4UdogOF8F99P58brO378w6SF2tlYoi8nt2xbWaKRd6A==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5483.namprd12.prod.outlook.com (2603:10b6:510:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 16:00:15 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdf9:42eb:ed3b:1cdb%7]) with mapi id 15.20.4219.023; Fri, 11 Jun 2021
 16:00:15 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: RE: [PATCH net-next v2 2/3] rtnetlink: add
 IFLA_PARENT_[DEV|DEV_BUS]_NAME
Thread-Topic: [PATCH net-next v2 2/3] rtnetlink: add
 IFLA_PARENT_[DEV|DEV_BUS]_NAME
Thread-Index: AQHXXh74CfJ1JCE4JUaG6m7m5f+1aasOw8rwgAAx0gCAAABocA==
Date:   Fri, 11 Jun 2021 16:00:15 +0000
Message-ID: <PH0PR12MB5481E2A21AE5E9B7BF0B2C73DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-2-git-send-email-loic.poulain@linaro.org>
 <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAMZdPi9HhO9Z0W9hDLgNaj6jwiofVyQEp6pAwAO1Z8zqFGmGCA@mail.gmail.com>
In-Reply-To: <CAMZdPi9HhO9Z0W9hDLgNaj6jwiofVyQEp6pAwAO1Z8zqFGmGCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17d242f7-be4d-4648-31f7-08d92cf200bd
x-ms-traffictypediagnostic: PH0PR12MB5483:
x-microsoft-antispam-prvs: <PH0PR12MB54831F4C70EDF32658964DAFDC349@PH0PR12MB5483.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XrMopRrEikYCbKitM91YJVFjhbxspTzLTJk85FSB2OwRA+P+u2gcFX2vOAK7nr/4fuR/1t7mRW+XXu3JinG26S06WyVXjbffyzC+tQpJh5uNnJj45Cqjwm9Ob5JimZDUFscUANwKha1WtDsjMPU8im7c/1qj3qmbWtsWzUt4336q10x5+OjKhA92wWzi0u9b05ZhoMcBCWFjNUDsoHnkZ29UHvWRVNBVLiuAsUBEWCcZAf0cES+MIXlXEFQ9bAj1RtY4XNz6pesGK0+zLwoirS3krHOitbJPaRXFdo5Fg21LAXI6kdVv4mhhOKsZb0/PkNgIAp1TfkEVyJaD7CIjWBe9qqev0lppATqg6Uj+V/r/G4FYAu8bIHOV/H2c9OFM4eqQb5GATp6oI1P3QAj4cTwMa/MJJOD/gCz4q59RItAPnoJedoBQy89lSkO2BjU/UuFvxtxkQf60AWVeSi1G1Q1YXuPlQ10UFrfVW41Dgj5nuVQCCAhhYq1bcd43n1Xo0aG3fm1PRR2Z6IhOqhLGi05z8HM700OV0Vpo/9HtXG4HiPpJpnqMC1yHayBHIMXZvA2IS9YI3EdCB9ZNfBa62Q26YUi+fuYY08Yrgz6e6RiKKvQ1sy25PHQ+tqQVmi3+x1sgHtyqCUwsIvP9bwFq+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(66946007)(66556008)(64756008)(66446008)(9686003)(316002)(54906003)(55016002)(66476007)(76116006)(8936002)(83380400001)(8676002)(6506007)(478600001)(71200400001)(86362001)(7696005)(38100700002)(55236004)(122000001)(4326008)(33656002)(52536014)(2906002)(186003)(26005)(5660300002)(6916009)(83133001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHFVV1VDWE12elJVVVJ3eUNLMjFLSGt2SU5OSHg1R3FONkRzcGRNMkcyM3dG?=
 =?utf-8?B?ci9ocWd2dlY1R2xCR2FCUEs3cXplVWFTZ2FMektBbEl5ciszNENSc0lCY2JC?=
 =?utf-8?B?K2VwcXdMN3puTGhvVUp4UDhCZzEwSTNVei9kRXRGQjZzRGlyMjJhTjJLQmFl?=
 =?utf-8?B?RU1HYkhXRElSWWJiRmZKbmVGaXljN3VTcEVxUFRIYSt3SHNIM1VDbDFRdzhM?=
 =?utf-8?B?bDA5aFBacGtFN015dkZtbFZDWWJ4V1lRazB6cmhybjRDUWNteDVZRE5TdWJQ?=
 =?utf-8?B?NHJMK0FCWDE1am4wMmt4WFJrYkQxQWxnUkhmNmdpWkQ4TzdsMHJtbFNhcFFT?=
 =?utf-8?B?TGNmRS9xWlNGS2I0MHI1VDFoRll0ZGxRUGpHazUvYU52MjNUN1drc2xxZlBG?=
 =?utf-8?B?cjZMWmVsVWN5dEZ1TTFGZWdsMjZyUDk2TlN5eWFGSkRZT1NEK0R4ZE1sclB3?=
 =?utf-8?B?NFd1QktRejQ5V0RMbytQa3dOTjAwQ3p6TW5NY29pTGtjdVkyOENqMmNydGZF?=
 =?utf-8?B?NkJJNDJlazBSVkNaVWJ0WE91MFhYK1FoZnJ3TmJHckp4SXg3bGhmaWd6WVhz?=
 =?utf-8?B?QUJDcmp3YTRtWGlrb0piVGZNUnRGYzJ1RFEyQ0hxVXJpWUY0dzBHMFh3NmdW?=
 =?utf-8?B?bTRSMSsrZDVVbzQzOE9kOVVoYVdCRnVkaDhwRkg0UUYxM0Y2OGhMaE9BWmhX?=
 =?utf-8?B?L0pIT1laZFduVndUcXJrNkZ0Z202elAvcDl3K1pYWmxCR2luYVJzdzdBLzBB?=
 =?utf-8?B?TzN3YWZ1Smo3dmt1V2kxRnFyWVg2dC8wMm10QVo4M0JKQVdwbnJpTDNuam1j?=
 =?utf-8?B?S3lJWGlXSDVmSUxFNXVxSUVPWlRSVDBZekRoYVNITGVDWWR3S2NYY0xoNlpZ?=
 =?utf-8?B?U1F0YVZQWXlvMTNPcXVYKzlNc0JSYmxPbU9FYkhZV3RPWDFOVnVyQ3ZwdlVv?=
 =?utf-8?B?TjZ2UXhOcDQzNlRhOWlDbm5wRU9xa09ld0RHZWZ1dkt2UjlqOVRvZDlZYzRN?=
 =?utf-8?B?V2JKSjFkeW9QZGZXb0tnNjZXc3ZLMXIycmFLQXVEbzdKSUVKSU5CdS8wVnBj?=
 =?utf-8?B?WE40elpVdytSOHJaVUkrdGY0eXBocHFCUUhXM0hxNnpNMm5PN0dxdlJZdDBh?=
 =?utf-8?B?amJoTmdPR1E3aFZ2ckNOUFRBTXNDQ1lMUGFYSHFFZU1kVzBZNWVpcSs3OVBj?=
 =?utf-8?B?cVNtVTV6SnF4b3M4NC91S00vVXBQVjNBMmRRY21IVW51MTNZb2NJa2FSYnE0?=
 =?utf-8?B?TXh1UFJ0bEpWSGErUDJkOWcvSmNNTFB2THFHWVVML1dUUjY2ZU1FR0YxaXpJ?=
 =?utf-8?B?S2kyUEJvQmFkYW9Yd05SN1N5UXRpM2poVlJiQmJlNXluR0tLUEV4ZGlYaTJQ?=
 =?utf-8?B?UlJsTXo4Nkw2UkFmR2VNRzhmTjEyVjBVblRSeW12TDFFczM3RExtVGEza0px?=
 =?utf-8?B?NHFlS0E0SkMzUFRZS2kxaHNTaUZpUWk1YlhCNGR2K20vR2JEVHVKSHFDaDJP?=
 =?utf-8?B?R05KRU5LY0UxeG1uRVdNVnNQc1NWbDd2d3JoSHpzSkN5eWtnZnJiYXRQVzU1?=
 =?utf-8?B?OXRLS2cwOTgyZys3dVNsYzVZdnAvai9qaE9hUDRRVjRZU0dWVlJzd0pBVEJO?=
 =?utf-8?B?RDdFTk5PTlhKUjZwSEJ0L3N1bE5KdCtOam5GQzlpeUlxdk9YWHZkaXEvQ1Jq?=
 =?utf-8?B?ejI2SFZEaG9ZRUVJSmFSTlZPc25uN2p6bUUrSnFlMTUxVTNFdVVGcGd3SlVy?=
 =?utf-8?Q?01MeWvk4nB1/9o46RXXzjQmmmNmkBoRYcOaYGXo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d242f7-be4d-4648-31f7-08d92cf200bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 16:00:15.4129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d9msU5d8siXK+j2oRAEATDb4B3Y0ZykE100xZQL9EceZ0RN9t+NuYtRxL5SnPTwxezPNBqJTC77OLnnZqOlKDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5483
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogTG9pYyBQb3VsYWluIDxsb2ljLnBvdWxhaW5AbGluYXJvLm9yZz4NCj4gU2Vu
dDogRnJpZGF5LCBKdW5lIDExLCAyMDIxIDk6MTYgUE0NCj4gDQo+IEhpIFBhcmF2LA0KPiANCj4g
T24gRnJpLCAxMSBKdW4gMjAyMSBhdCAxNTowMSwgUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEu
Y29tPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiA+IEZyb206IExvaWMgUG91bGFpbiA8bG9p
Yy5wb3VsYWluQGxpbmFyby5vcmc+DQo+ID4gPiBTZW50OiBUaHVyc2RheSwgSnVuZSAxMCwgMjAy
MSAxMToxNSBQTQ0KPiA+ID4NCj4gPiA+IEZyb206IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJl
cmdAaW50ZWwuY29tPg0KPiA+ID4NCj4gPiA+IEluIHNvbWUgY2FzZXMsIGZvciBleGFtcGxlIGlu
IHRoZSB1cGNvbWluZyBXV0FOIGZyYW1ld29yayBjaGFuZ2VzLA0KPiA+ID4gdGhlcmUncyBubyBu
YXR1cmFsICJwYXJlbnQgbmV0ZGV2Iiwgc28gc29tZXRpbWVzIGR1bW15IG5ldGRldnMgYXJlDQo+
ID4gPiBjcmVhdGVkIG9yIHNpbWlsYXIuIElGTEFfUEFSRU5UX0RFVl9OQU1FIGlzIGEgbmV3IGF0
dHJpYnV0ZSBpbnRlbmRlZA0KPiA+ID4gdG8gY29udGFpbiBhIGRldmljZSAoc3lzZnMsIHN0cnVj
dCBkZXZpY2UpIG5hbWUgdGhhdCBjYW4gYmUgdXNlZA0KPiA+ID4gaW5zdGVhZCB3aGVuIGNyZWF0
aW5nIGEgbmV3IG5ldGRldiwgaWYgdGhlIHJ0bmV0bGluayBmYW1pbHkgaW1wbGVtZW50cyBpdC4N
Cj4gPiA+DQo+ID4gPiBBcyBzdWdnZXN0ZWQgYnkgUGFyYXYgUGFuZGl0LCB3ZSBhbHNvIGludHJv
ZHVjZQ0KPiA+ID4gSUZMQV9QQVJFTlRfREVWX0JVU19OQU1FIGF0dHJpYnV0ZSBpbiBvcmRlciB0
byB1bmlxdWVseSBpZGVudGlmeSBhDQo+ID4gPiBkZXZpY2Ugb24gdGhlIHN5c3RlbSAod2l0aCBi
dXMvbmFtZSBwYWlyKS4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvdWFwaS9saW51eC9pZl9saW5rLmgNCj4gPiA+IGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX2xp
bmsuaCBpbmRleA0KPiA+ID4gYTVhN2YwZS4uNDg4MmU4MSAxMDA2NDQNCj4gPiA+IC0tLSBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9pZl9saW5rLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51
eC9pZl9saW5rLmgNCj4gPiA+IEBAIC0zNDEsNiArMzQxLDEzIEBAIGVudW0gew0KPiA+ID4gICAg
ICAgSUZMQV9BTFRfSUZOQU1FLCAvKiBBbHRlcm5hdGl2ZSBpZm5hbWUgKi8NCj4gPiA+ICAgICAg
IElGTEFfUEVSTV9BRERSRVNTLA0KPiA+ID4gICAgICAgSUZMQV9QUk9UT19ET1dOX1JFQVNPTiwN
Cj4gPiA+ICsNCj4gPiA+ICsgICAgIC8qIGRldmljZSAoc3lzZnMpIG5hbWUgYXMgcGFyZW50LCB1
c2VkIGluc3RlYWQNCj4gPiA+ICsgICAgICAqIG9mIElGTEFfTElOSyB3aGVyZSB0aGVyZSdzIG5v
IHBhcmVudCBuZXRkZXYNCj4gPiA+ICsgICAgICAqLw0KPiA+ID4gKyAgICAgSUZMQV9QQVJFTlRf
REVWX05BTUUsDQo+ID4gPiArICAgICBJRkxBX1BBUkVOVF9ERVZfQlVTX05BTUUsDQo+ID4gPiAr
DQo+ID4gPiAgICAgICBfX0lGTEFfTUFYDQo+ID4gPiAgfTsNCj4gPiA+DQo+ID4gPiBkaWZmIC0t
Z2l0IGEvbmV0L2NvcmUvcnRuZXRsaW5rLmMgYi9uZXQvY29yZS9ydG5ldGxpbmsuYyBpbmRleA0K
PiA+ID4gOTJjM2U0My4uMzI1OTlmMw0KPiA+ID4gMTAwNjQ0DQo+ID4gPiAtLS0gYS9uZXQvY29y
ZS9ydG5ldGxpbmsuYw0KPiA+ID4gKysrIGIvbmV0L2NvcmUvcnRuZXRsaW5rLmMNCj4gPiA+IEBA
IC0xODIxLDYgKzE4MjEsMTYgQEAgc3RhdGljIGludCBydG5sX2ZpbGxfaWZpbmZvKHN0cnVjdCBz
a19idWZmICpza2IsDQo+ID4gPiAgICAgICBpZiAocnRubF9maWxsX3Byb3BfbGlzdChza2IsIGRl
dikpDQo+ID4gPiAgICAgICAgICAgICAgIGdvdG8gbmxhX3B1dF9mYWlsdXJlOw0KPiA+ID4NCj4g
PiA+ICsgICAgIGlmIChkZXYtPmRldi5wYXJlbnQgJiYNCj4gPiA+ICsgICAgICAgICBubGFfcHV0
X3N0cmluZyhza2IsIElGTEFfUEFSRU5UX0RFVl9OQU1FLA0KPiA+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgIGRldl9uYW1lKGRldi0+ZGV2LnBhcmVudCkpKQ0KPiA+ID4gKyAgICAgICAgICAg
ICBnb3RvIG5sYV9wdXRfZmFpbHVyZTsNCj4gPiA+ICsNCj4gPiA+ICsgICAgIGlmIChkZXYtPmRl
di5wYXJlbnQgJiYgZGV2LT5kZXYucGFyZW50LT5idXMgJiYNCj4gPiA+ICsgICAgICAgICBubGFf
cHV0X3N0cmluZyhza2IsIElGTEFfUEFSRU5UX0RFVl9CVVNfTkFNRSwNCj4gPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICBkZXYtPmRldi5wYXJlbnQtPmJ1cy0+bmFtZSkpDQo+ID4gPiArICAg
ICAgICAgICAgIGdvdG8gbmxhX3B1dF9mYWlsdXJlOw0KPiA+ID4gKw0KPiA+ID4gICAgICAgbmxt
c2dfZW5kKHNrYiwgbmxoKTsNCj4gPiA+ICAgICAgIHJldHVybiAwOw0KPiA+ID4NCj4gPiA+IEBA
IC0xODgwLDYgKzE4OTAsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG5sYV9wb2xpY3kNCj4gPiA+
IGlmbGFfcG9saWN5W0lGTEFfTUFYKzFdID0gew0KPiA+ID4gICAgICAgW0lGTEFfUEVSTV9BRERS
RVNTXSAgICAgPSB7IC50eXBlID0gTkxBX1JFSkVDVCB9LA0KPiA+ID4gICAgICAgW0lGTEFfUFJP
VE9fRE9XTl9SRUFTT05dID0geyAudHlwZSA9IE5MQV9ORVNURUQgfSwNCj4gPiA+ICAgICAgIFtJ
RkxBX05FV19JRklOREVYXSAgICAgID0gTkxBX1BPTElDWV9NSU4oTkxBX1MzMiwgMSksDQo+ID4g
PiArICAgICBbSUZMQV9QQVJFTlRfREVWX05BTUVdICA9IHsgLnR5cGUgPSBOTEFfTlVMX1NUUklO
RyB9LA0KPiA+ID4gKyAgICAgW0lGTEFfUEFSRU5UX0RFVl9CVVNfTkFNRV0gPSB7IC50eXBlID0g
TkxBX05VTF9TVFJJTkcgfSwNCj4gPiA+ICB9Ow0KPiA+ID4NCj4gPiBUaGlzIGh1bmsgc2hvdWxk
IGdvIGluIHRoZSBwYXRjaCB0aGF0IGVuYWJsZXMgdXNlcnMgdG8gdXNlIHRoZXNlIGZpZWxkcyB0
bw0KPiBzcGVjaWZ5IGl0IGZvciBuZXcgbGluayBjcmVhdGlvbi4NCj4gDQo+IERvbid0IGdldCBp
dCwgdGhlIHByZXZpb3VzIGNoYW5nZXMgSSBzZWUgaW4gdGhlIHRyZWUgY2hhbmdlIGJvdGggaWZf
bGluay5oIGFuZA0KPiBydG5ldGxpbmsuYyBmb3IgbmV3IGF0cmlidXRlcyAoZS5nLiBmNzQ4Nzdh
NTQ1N2QpLiBDYW4geW91IGVsYWJvcmF0ZSBvbiB3aGF0DQo+IHlvdSBleHBlY3QgaGVyZT8NCj4g
DQpDb21taXQgZjc0ODc3YTU0NTdkIGRpZCBpbiBzYW1lIHBhdGNoIGJlY2F1c2Ugb25lIG9mIHRo
ZSBvYmplY3RpdmUgb2YgY29tbWl0IGY3NDg3N2E1NDU3ZCBpcyB0byBhbHNvIGJsb2NrIFBFUk1f
QUREUiB1c2luZyBwb2xpY3kgTkxBX1JFSkVDVC4NClRoaXMgcGF0Y2gtMiBpcyBub3QgZW5hYmxp
bmcgdXNlciB0byBwYXNzIHRoZXNlIHBhcmFtcyB2aWEgbmV3X2xpbmsgY29tbWFuZC4NCkl0IGlz
IGRvbmUgaW4gYSBsYXRlciBwYXRjaC4gU28gaWZsYV9wb2xpY3kgZG9lc27igJl0IG5lZWQgdG8g
aGF2ZSB0aGVzZSBmaWVsZHMgaW4gdGhpcyBwYXRjaC4NCg==
