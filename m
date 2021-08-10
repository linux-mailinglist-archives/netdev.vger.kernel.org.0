Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA503E5AF2
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241190AbhHJNTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:19:45 -0400
Received: from mail-dm3nam07on2077.outbound.protection.outlook.com ([40.107.95.77]:43706
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241167AbhHJNTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:19:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnMMNdV1QMKvtrC1U7YGGV2P4QIwTz9rF6WX2wJWRk1yBDpJC3QuIqwoYgPo5u2k6R3qgypu6JlKG7yV6s3S0yxBl39PczPrWAMOXoYryI8g1UE8VjmGIUEYgaOGY9RFnMzmQpr7tnapOey/VwsA2AOIOT8bTUUJKUy21ASj8t9CjCKFbK7Y8LAAU4Jjr1JAaNdu3Hkb6PCOhNICoidC6AuyfKpgAgXTFbbTbX8ZvUApv+4C8rASeWG5DngPAZS0sFfzApDyvcXph1g6VAMGub8YwM9It8Cu3ul9FYNWEYNaJaYnl47CcrfulLAzfge/2hwviJBtoV1cY+ytQp3GOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sD0RTLFI+sfQvjYFjXImCIOykI55w4sy2OwFJTf94Hk=;
 b=FTkZ9Em7jnOSLrH2mDCiWtUSrG0LDKWrYipJ1z58jxlKdNwS8GI36QAq/6jdCwy1cSEWUPAWssxABzctltiRv1HBkdv7JflWqvPcFbAvNrtGgjfxoK9JQn5JmkKV3lNW2mRkKEYbp/LB61ZgZxcBsKgHzdixqDDhh8QSb6AWqWFb5+LlK1j3bBl3rkT/x2SH2o7t1fIwG+TAEWUALYTxOhbio76iXbZzIq4NSHM4vcMbMRTI2MMAcSa0HJ8F9+wojAgbIgUWmUt79cOgJYHrodnKH3ylIBx7P7ktat1lEwFEDpCM1SWUPE9QLxZhu1OzqxoU4pWViV0Z8WycHt0s/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sD0RTLFI+sfQvjYFjXImCIOykI55w4sy2OwFJTf94Hk=;
 b=rKJSZuaLQ53XkgHv6zvIe2eWHSYoul2FVJddVw/sR7rWRyxdLcquma1mVe7pAwqgA4N3cs4b5azG20F9ikD0IKI4+qfIabW4pVXaS/m6uEL5mHlm7TebCGpCsxWfm++Z0Y1P07qKIqHkLEOYzOHX+/mi7m62+svSvphMO0UnYbsA7RuUkPiEST8siwxuvL0NNhBTs/uLKpgZJujjRiJsJVgh/qreiH9kp8VfZanyuwDX+1NC3c08hkCO1I2omZGSuAeA8H5ZMBwfKYLsVcYnDV4lwss2dHVRoFCLmMjsncS7bU6sDB61VF/lIJeLJEHx9bLL1GuN79X/0qhtow4isg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 13:19:21 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::249d:884d:4c20:ed29]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::249d:884d:4c20:ed29%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 13:19:21 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next] devlink: Show port state values in man page
 and in the help command
Thread-Topic: [PATCH iproute2-next] devlink: Show port state values in man
 page and in the help command
Thread-Index: AQHXf9Kc8/l2o5ruJkWZP85tSCRlK6tsu66wgAAZAoCAAABBcA==
Date:   Tue, 10 Aug 2021 13:19:21 +0000
Message-ID: <PH0PR12MB5481B3F14ABEFA2DB4755AF4DCF79@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210723145359.282030-1-parav@nvidia.com>
 <PH0PR12MB5481796816B64C41F8230E0ADCF79@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1b476bdd-dc87-4ddf-08b1-e2aaf7cca7f6@gmail.com>
In-Reply-To: <1b476bdd-dc87-4ddf-08b1-e2aaf7cca7f6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26057538-72c7-43d3-454d-08d95c017727
x-ms-traffictypediagnostic: PH0PR12MB5420:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB54203BD576A6C7995BF46C5CDCF79@PH0PR12MB5420.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LQ8K+X0xP0bFjb6JVU/sDYDviIW3jXOPFQ9Xt75Rg4fVYO+yOi6PjgHN3ZcqGD/bKQmch5M2YoOW3IWJ9lCldHyvfuhhDlAqa/rRZbr8lprk3Z7QLpeE0l2mDRZPBpDylyR/DmSKnpJkO16iw5pWKqaaA1rSuhFPvE0Whvjog8KN5FIT2RY8YrlAEs5ZorU2FmjLw57G1QDF50uJ+QfWh/vu0VroPfZV4rdlllSHxsAnfyKxiFLOoA7sGM/mZSTAbvTQ4wmFHev5VtOUcNc/iCs9jAT/SBYv6F20dhm5cvIzzJjPtawrlvdWg7HSgnuoCcJ8eigV8e2S82l7ZhYDvVqeE2sQo5q2oo5JwMbh/aDS2WsHM7BnSfbZN5USEbcYlxuHVXV5hsKbnEGeC+MY/NjpEmBkIiCy764OUj+AYsYAeyrczoz0GiZSA24fg8iZ2KLFN5WTiz66Lo5KOTG0CrKLJvQxTBmkIrX5Q4T9CrHsOOYJ/IO3YUBbEiD20l2wGzI/FeaHJpyeEtFPeroLeAm8de8V0WeooLV87AIb3OPv95jzajNFXTCOHN5Hz4u7kJcGu/vvYTV6YQDH3Iu9cKZ00k0Ko6R5X90LEeb45CnFRU5NIfp6XMFuvwKw6CsxhSmjbJOMpDQ86HhirlxnH+gPhpJ4L6dBqBAM4vca8HBnQi1FCrh46p+nRgNwHspqOtrQMRMguQGIUpcUi17vNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(83380400001)(86362001)(316002)(122000001)(33656002)(53546011)(6506007)(38070700005)(38100700002)(52536014)(55016002)(9686003)(8936002)(8676002)(71200400001)(186003)(5660300002)(76116006)(64756008)(107886003)(66446008)(66946007)(66476007)(4326008)(66556008)(478600001)(55236004)(7696005)(2906002)(26005)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b01JY2ZoYWx2VkgxWmhKRFF0aDlQRWUwSlB3cWw2VnVQaGpuOHZiNWVtZ1Zy?=
 =?utf-8?B?bHlvdGVhK2NrbnBnK3FBVUZTQlJCcVJxaUFYRnlCaG0wNUNKUFVwVlFnUnZz?=
 =?utf-8?B?a3JRWWttazZ2S3A0VjVjTk1pdUdZTEhmQmhsbnErSS9tL0ZsWG1PUTdYenZE?=
 =?utf-8?B?bW01Slg0OGpzU0tSK0VGMGV5bnVLWnBIOUcvSFRLRlpDanY0anRGek1xRVox?=
 =?utf-8?B?R2ZIbGxzOVNaRDRWOFlMU0FrbE5jaVpMYStaRWtQcCtuL0sveUlBc3FZVzZC?=
 =?utf-8?B?V1E1M0VQNkptNitBeEF4L1ZjbWFzK0xnWEk0a2tiT0lDRDF4R1U5ZVp1ZkE5?=
 =?utf-8?B?S0w0SHdZeTVMOUdZODhNa2FNc3Q5VUFYRGZtS0hraWtLUW1XY0xvUm15ZmdC?=
 =?utf-8?B?RkNqcWl6SDhkMjhsUGhwcEoxQVFmQzM0RG1DQ3RYNGlncFhPOXpZbzZRNEpQ?=
 =?utf-8?B?aGswZ0tycFVCT3JoUzJ1SUtpeVFaTGtvVWNIQnd4OGVZYzJlZVF5Mm53andY?=
 =?utf-8?B?cXpYZjBPVGxsK2cwbWpGUFBUTWplREh1SWpDUnRia3lJckdSc2Nxb0p5aFdZ?=
 =?utf-8?B?aUg1aVowelp4RFBlY3RtN2VkUnBWWG5oNVBEZFVZM3cvWXNGWXFYbzFlZTZv?=
 =?utf-8?B?cWdOSDZIc0lka1dpTFgrZGNHR1k4V0xFblV0c0w1cXhjRmtBN2tXS25sV2lP?=
 =?utf-8?B?S0hNZzZxR3piUnUycy8xMnVXQmJXMEdEeFhlWnI4N2dYV0d5WFVad0wvTDJH?=
 =?utf-8?B?QlkvMk4yendzbXZiT2tLR2R4ZHBrRzNsSTd2dUQ0VStzRnlWMHhwbCt3c2FD?=
 =?utf-8?B?VWpQYXZoUWM1N2N4VWYxVHdwNWVsRkVrUHp0T2FhOVJhbjFFcXh3ZE42TlI2?=
 =?utf-8?B?RXcranBMekhSRk43MHl0RXVlWFNqWXQxSVNmU1FuRnZjb2E5UzZTOHNsT0Ri?=
 =?utf-8?B?RHEzZVFOT3pYNkhXaHZXZmoyeGZtby9oZnpMOU53VnJ5T0ZEVXJFSyt3aXlD?=
 =?utf-8?B?blVacjRqQUVoZGRHeEw2SmhZMThTemxNVTMrc3BjWXc5V0pSajRTWUJ0TE16?=
 =?utf-8?B?cnlVMDNEVWxjbjhVaExzZE90ODd2VVNzcTdUY2JoTG5IQSs2d2xUQlR2Nndu?=
 =?utf-8?B?UDU1SFpIcjZsSzhpZ1FDeFZtMmtZSXIzeFpnT3RURFNZbDVQd053d2YwZG1J?=
 =?utf-8?B?NlBDcVk0Ukkza0NFL1IrKzkzblc2WTlqZWZvcWhQNTBSOS8xclNBL3FRa290?=
 =?utf-8?B?Z0JsbGloRlFZNUdqbnVIeDRJUktXQ3l6K0w3c21OSGVKL0JqL0V5U1hOR083?=
 =?utf-8?B?R01QakF1ZE9pbjVtNW83cUxwUkZrSW9QUC9RODNzS2hKYTMrMVZyTlNjc2dH?=
 =?utf-8?B?SGxydlRzeWVDdXFycURINkgvUnBGcFpzR3FZQ0hUcFpvODRSNTBRTXNvdWpE?=
 =?utf-8?B?RVMyK2JCYXluZkdma3RTVWJDM09qdUZiK0l5aUJQclUzeExKWk0xNHVpV25s?=
 =?utf-8?B?QlJkL3JOb2Z4RkZwVU5DNmc3OHVoUENGUTYyekQvOGROUDFMOUdXRVJLNlhB?=
 =?utf-8?B?dmZNYXZpQ2RudHdNZjczZHF4RmpTaE9mMVJ3T2Yrei8yMlp4WTNSM2xWWFRz?=
 =?utf-8?B?clY4cEk4L1ZOR3pJeW5iYTJDQ1o5eHIvTDUrb3A5Qll0SWt6amVTSGtOQnRK?=
 =?utf-8?B?RUtnaGIrWndQNWU2QmxkcTFEYmRuU3NVMmlYTDNyZ2U0ekRORjVkdEk2RUhm?=
 =?utf-8?Q?2bW66sKDbjTyPJ3dZI9ju/DWplt1vRPrZWHm3xU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26057538-72c7-43d3-454d-08d95c017727
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 13:19:21.1310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVRF7wcZg7/QKEOrMyLWCZDe2pUp8Dc14y+HUnnvJ4w4ALpu3RPpDr0r6u08eC5Cut+6fENTTQ4e6diw4oOIhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBBdWd1c3QgMTAsIDIwMjEgNjo0OCBQTQ0KPiANCj4gT24gOC8xMC8yMSA1OjQ5IEFNLCBQ
YXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gSGkgRGF2aWQsIFN0ZXBoZW4sDQo+ID4NCj4gPj4gRnJv
bTogUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIEp1
bHkgMjMsIDIwMjEgODoyNCBQTQ0KPiA+Pg0KPiA+PiBQb3J0IGZ1bmN0aW9uIHN0YXRlIGNhbiBo
YXZlIGVpdGhlciBvZiB0aGUgdHdvIHZhbHVlcyAtIGFjdGl2ZSBvciBpbmFjdGl2ZS4NCj4gPj4g
VXBkYXRlIHRoZSBkb2N1bWVudGF0aW9uIGFuZCBoZWxwIGNvbW1hbmQgZm9yIHRoZXNlIHR3byB2
YWx1ZXMgdG8NCj4gPj4gdGVsbCB1c2VyIGFib3V0IGl0Lg0KPiA+Pg0KPiA+PiBXaXRoIHRoZSBp
bnRyb2R1Y3Rpb24gb2Ygc3RhdGUsIGh3X2FkZHIgYW5kIHN0YXRlIGFyZSBvcHRpb25hbC4NCj4g
Pj4gSGVuY2UgbWFyayB0aGVtIGFzIG9wdGlvbmFsIGluIG1hbiBwYWdlIHRoYXQgYWxzbyBhbGln
bnMgd2l0aCB0aGUNCj4gPj4gaGVscCBjb21tYW5kIG91dHB1dC4NCj4gPj4NCj4gPj4gRml4ZXM6
IGJkZmI5ZjFiZDYxYSAoImRldmxpbms6IFN1cHBvcnQgc2V0IG9mIHBvcnQgZnVuY3Rpb24gc3Rh
dGUiKQ0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+
DQo+ID4+IFJldmlld2VkLWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG52aWRpYS5jb20+DQo+ID4+IC0t
LQ0KPiA+PiAgZGV2bGluay9kZXZsaW5rLmMgICAgICAgfCAgMiArLQ0KPiA+PiAgbWFuL21hbjgv
ZGV2bGluay1wb3J0LjggfCAxMCArKysrKy0tLS0tDQo+ID4+ICAyIGZpbGVzIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPiBDYW4geW91IHBsZWFzZSBy
ZXZpZXcgdGhpcyBzaG9ydCBmaXg/DQo+ID4NCj4gDQo+IEl0IGlzIGFzc2lnbmVkIHRvIFN0ZXBo
ZW4sIGJ1dCBzb21lIGhvdyBtYXJrZWQgYXMgJ2FyY2hpdmVkJy4gSSByZW1vdmVkIHRoYXQNCj4g
bGFiZWwgYW5kIGl0IGlzIGJhY2sgaW4gU3RlcGhlbidzIGxpc3QuDQoNCk9rLiBUaGFua3MgRGF2
aWQuDQo=
