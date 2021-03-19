Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FA63412DB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhCSCdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:33:38 -0400
Received: from mail-eopbgr680058.outbound.protection.outlook.com ([40.107.68.58]:26630
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230108AbhCSCdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4aNu4034rq5GSXrhqe5zessElGlEj1+JJS3On661bujbNtKqpaGNX4a49HdN4pCv4j7rdbY1YCNBVW5BdhldWuh18IG0Ha5zIgOQNUDgkPUUb5Rn9YNqOS3c79GjGPKo26tvs5JTIOxsR307WxXRzJj+MBcklGQYqRnG7wBLcazeUuOyBn81aeqcOLGDY8RieO/5OnGW6e6Fbcbg25D02PJ9UrXry3CEx9zFi0MgyLMJz7VW0mmASexeXbXJ1q2eu+up5yzjsOj4sGFrwHGzZYPtVeBQ2uHEwGCNegyC+iqHoFPf7ILPpv0ZCEsIo3c6AOL+6cXB1T9hhgBi39npg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38IWsZ2ur0AhhUyvy0Gl5DxErsk6ti8bjCkg+dp2bxA=;
 b=F07Xef8HmiXvgjBft9Upayla7Lg8IjVc9RrTdDStL03axfwG1JWhdKPYLOkCobp8aVTjIjZ2YmbTvMU9eCkY+PRo/QswzUaJUxw5Rtu36ZoVthkgwO2hfRxYp+cXBB2qjjgEBAsAoTTO0ux2Va5I7VL+nGKzMsHEnJQwSMW3dSpPAIMdvWms90VTFD8C+ikuhVIEeSPwUmHBh9olujGTzFoByP0ByN3k65LzMESEVX181VevlY/+Q5Y8znso8UQmr0alODMVglD8U8q3n8/RPxcwBm1+8hgEI4ECNWaV2IHOz9BT04695lOjAIGWYyZSOrijGHAGjG2BA1HNMbHAfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38IWsZ2ur0AhhUyvy0Gl5DxErsk6ti8bjCkg+dp2bxA=;
 b=Fr6sDEn+VuadvoM4phWw1rW7aHN4GlKz90+ZgH1JJ4DKgdnTb5zf2+8JT/4cXvTetZm0ilgH6tgXvW2Kh6BAZWRMwqrpjgXMnkAqDXMyFMldkcziBGYLxoPXG8vuBQXgpuCR8yWjWeI6a2pA2jPJxRNWV1ih36rHxjPML+H1mkw=
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB4984.namprd11.prod.outlook.com (2603:10b6:510:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 02:33:10 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f%7]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 02:33:10 +0000
From:   "Liu, Yongxin" <Yongxin.Liu@windriver.com>
To:     "Creeley, Brett" <brett.creeley@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>
Subject: RE: [PATCH net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Topic: [PATCH net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Index: AQHXG88+TtWMvkSGH06dsjTfVBH0yqqKUiqAgABGGwA=
Date:   Fri, 19 Mar 2021 02:33:10 +0000
Message-ID: <PH0PR11MB517530C9E18DD3DCD8B0F610E5689@PH0PR11MB5175.namprd11.prod.outlook.com>
References: <20210318081507.36287-1-yongxin.liu@windriver.com>
 <5c5c7e89492526a7faffec9b03306ceefab86a3c.camel@intel.com>
In-Reply-To: <5c5c7e89492526a7faffec9b03306ceefab86a3c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00dca563-5440-4c6b-32c0-08d8ea7f5699
x-ms-traffictypediagnostic: PH0PR11MB4984:
x-microsoft-antispam-prvs: <PH0PR11MB49843E8A4267B5091F760F01E5689@PH0PR11MB4984.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NaFEnM1AGoIZQRO9HDzctH6ENeMEOHe0uhGBOC+X1H7Iy96wAnS3UpBz1rswc7f6+DXUFPoFGISGmE90J7TG4hjlMZsuZLILprsBslfNSNYkvV+OM1uopLHFHPoi1eLSATOLYzQ0RjRy32Wl+JGLjKO1QEgdTh5PprEKPd28RGoDc/HzRjGBRCcr+vEj6ECpTlUyGiHdUG4YfkTucfE/CfReSdi9zpnbZJY3lOIqv7CsNVqbcEz+rT4ezRDExHkHeSIjuuU1dpRjAuVZG7r+LypYH9pKvsdXIbACFt29NM7hFdyHALaQjHE6jG4VemO1KmGV6wZjfvyR7mNb9JfD5eccMJb2okMyCGnfNMNJDTOYDtVBfX5CpzRMEFcX+tKRwPzKKPy2CTAFkKIMXOneOr5AfoY8znuT65ECHtmKsrBHl6hEyxBBT+3cECXR1BTsxbv/CYBqYG4xeca+27l4sBE6+9DQYm+tooYzvkIG5+/k1oLTFUsK0oXW3qzy/0wf3wjLDy/MqIjGswd6GXDBwMJ30/yJCE4p4ugDE9FPlwgELlBYoq95oBFXk7jFWAKPynFvEohBIUjbzbJiV3c32Ysi3OA1BcbAkDNLxKpS6kOCOVYQpKFzXh8GJ110C0PF1JCtla3SAaq++fG37nNkqOKWHTNNv5M/hYcwPRgFLTA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(376002)(366004)(346002)(396003)(7696005)(8676002)(478600001)(86362001)(5660300002)(33656002)(53546011)(6506007)(55016002)(83380400001)(9686003)(8936002)(66946007)(66476007)(66446008)(64756008)(52536014)(66556008)(26005)(186003)(76116006)(71200400001)(15650500001)(6916009)(54906003)(2906002)(38100700001)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eVR4Z2lrYysxWjdWV2dCU0k4dzJqKzAvTHFXWGMrZlBVVnoxZ2ZYTlg5WkZD?=
 =?utf-8?B?RlMrdVcvKzF5ZktQeWlHK3ZEL1dpUHdzcHdFT0EwcDRScDBvTWg3U3hjdXB1?=
 =?utf-8?B?VStSSmdBNWJUekFPbmZRcWR3RzVhZitGMlkzV0NtTlpjMXR4S2ovd2FaQ0JW?=
 =?utf-8?B?QlFUVU1scHkrT3gwdGhYSWNGMklEdFdVNno0RmIrMzJCV045Y2kwMjdzTFlj?=
 =?utf-8?B?TzlqVXlyaG9wZ2I0SkNhVzJQOXk0T3dTZkZJMUp5MEg0S3VNeUVnNm1WOU9P?=
 =?utf-8?B?UzVQVzNTeGIxSmdPOEtEdW1pcXdZSGFyditvRENpUTY2dW1pMUNsb0plUkZo?=
 =?utf-8?B?QU03YXlKUFJ2Z3hhbC9STlpObnlDR0RCRDROdlB1eDZWc2ZyaVgrelVySFdz?=
 =?utf-8?B?NnN4dXVnTlZSalA3cnE2QnFlS0JFZm5NaUhBa3NQdytWRU9DMlVZL21NeEQ5?=
 =?utf-8?B?NTNYdHhmeklROHF2cDJkQk12VFhhQm9kcm1RdEkrdkl5NkFUR0V2dnVVSjFX?=
 =?utf-8?B?TmF3aEUxMGt2VDlXNlBaYmJwd083TDdpNjYwUjVXMWJRZWhNQU15YjRJTTZl?=
 =?utf-8?B?VkV5YVFPcVV1T3phSEx2cFpxamZmWHVpV1JIR0M2NGp0MW9ScWZiVnRSL0Ja?=
 =?utf-8?B?ZzFKaVFodjYrS3NEU0VFNjNSekZGNkgwc2lJVS96ajFuOG9oeTR6QmhVd3dp?=
 =?utf-8?B?aFg0eGN2K2dvR3ovbVZTTmZGSjBvSUNrRlUwOUhVbndYazdKbkoxZkRSSEYx?=
 =?utf-8?B?YndOaVdSdjBZNGVaYXk3SVhtYk52RDNzMjZtN2xPRjVhZjZHWGQrOHJZTnov?=
 =?utf-8?B?Ky9rODhqSlhyMGJvd0RINXRZaFRabGdZZ1BmQVFncE9zL1RaS3R5cUZQT0xh?=
 =?utf-8?B?M3BMS1BENXJUTXVTS2VjUmZsbmJjUTQyTEJ5bXFDRnRDcVdmbGxTQlRPMUtR?=
 =?utf-8?B?blNhb01wOGR3ME52ZHR1Z1R3ZDA2bEppMFd0Yjd1VGhpU3ozRCtUdFpaRmdt?=
 =?utf-8?B?Z3FwWmpXT09xVnkraVRKYUFYUDZtS2VBbHlNbC9NUmdHRjR3cCtZZS9wdk5Q?=
 =?utf-8?B?REZncW5GRHRIVlBMWWNzYnFmTVNxU1J0Vmsxc3ZmbFB0em9UMHpJMDRQRmVm?=
 =?utf-8?B?WkJmUXlacTB6eE5mbzAxZUVSRVFaZ1FicTdaTmI2dTR0cnZXSWtKVnQxU0Jv?=
 =?utf-8?B?bnNiMlBzMFM5YWdoS3YwVXZSYldLNHBZa2ZSaEVpejhaTE5nMlNHQ1MzYmdJ?=
 =?utf-8?B?L0tPT3lXUmpNMC9IZmQ1K0dKTnZXMGt6aFV2eFhnUUo4bjcwNE9LUWxoeGJ2?=
 =?utf-8?B?ZnVWNy9pdi9DcmVKbldSVHNlVDJjVUE1bTZwSGEzK1hibGtHQUE4S3I5ZFJh?=
 =?utf-8?B?V0o0aXhzanBrRTZON0N5ZUNnV0tQL1Y1bHlRSDhmVVVVeGwxSi9UYlM0aHdE?=
 =?utf-8?B?NjEyMlV2QjE3bW9nWjBFZ1lSa3BHRVBaSUpab01PME1XREUwNVYvaGgxdVpw?=
 =?utf-8?B?dTN5WXNNZnJmSVgrRlRYdkRnS2IrUXBCOWJCUWVybjI3bytLYmF6YVFXaEMz?=
 =?utf-8?B?SFlVVFRvNkh4R2dJV2ozbStFdng3WmhNR095YWRoNU9FSG9OSmlyTkYxMytk?=
 =?utf-8?B?bkFJalpEdkNTTklENHhMMVBnUHZnejNQL0ZJNU5weWdHdFJpQkoxemQxaHcv?=
 =?utf-8?B?ZlplanY0ajlER3o2aVlvTDltSkUyMzFKb2FTTTgycjVvYjZjQTRLQlQ5c3dB?=
 =?utf-8?Q?rbUUgcSUsVzFChDZzI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00dca563-5440-4c6b-32c0-08d8ea7f5699
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2021 02:33:10.5849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZxwKwa+bZBl4+GGNW1HydsJuemETYEQSl/G8/q8/TMgRvA2UWD6Io7mjuzm0lqhtRiFIuM8wK4NqRiZDj18W3GewSbsQWyoC/rTgGOfDbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4984
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENyZWVsZXksIEJyZXR0IDxi
cmV0dC5jcmVlbGV5QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBNYXJjaCAxOSwgMjAyMSAw
NjoyMA0KPiBUbzogTGl1LCBZb25neGluIDxZb25neGluLkxpdUB3aW5kcml2ZXIuY29tPjsgamVm
ZnJleS50LmtpcnNoZXJAaW50ZWwuY29tOw0KPiBDaGl0dGltLCBNYWRodSA8bWFkaHUuY2hpdHRp
bUBpbnRlbC5jb20+OyBOZ3V5ZW4sIEFudGhvbnkgTA0KPiA8YW50aG9ueS5sLm5ndXllbkBpbnRl
bC5jb20+OyBhbmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRdIGljZTogZml4IG1lbW9yeSBsZWFrIG9m
IGFSRlMgYWZ0ZXIgcmVzdW1pbmcgZnJvbQ0KPiBzdXNwZW5kDQo+IA0KPiANCj4gT24gVGh1LCAy
MDIxLTAzLTE4IGF0IDE2OjE1ICswODAwLCBZb25neGluIExpdSB3cm90ZToNCj4gPiBJbiBpY2Vf
c3VzcGVuZCgpLCBpY2VfY2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpIGlzIGNhbGxlZCwgYW5kIHRo
ZW4NCj4gPiBpcnFfZnJlZV9kZXNjcygpIHdpbGwgYmUgZXZlbnR1YWxseSBjYWxsZWQgdG8gZnJl
ZSBpcnEgYW5kIGl0cw0KPiA+IGRlc2NyaXB0b3IuDQo+ID4NCj4gPiBJbiBpY2VfcmVzdW1lKCks
IGljZV9pbml0X2ludGVycnVwdF9zY2hlbWUoKSBpcyBjYWxsZWQgdG8gYWxsb2NhdGUgbmV3DQo+
ID4gaXJxcy4NCj4gPiBIb3dldmVyLCBpbiBpY2VfcmVidWlsZF9hcmZzKCksIHN0cnVjdCBpcnFf
Z2x1ZSBhbmQgc3RydWN0IGNwdV9ybWFwDQo+ID4gbWF5YmUgY2Fubm90IGJlIGZyZWVkLCBpZiB0
aGUgaXJxcyB0aGF0IHJlbGVhc2VkIGluIGljZV9zdXNwZW5kKCkgd2VyZQ0KPiA+IHJlYXNzaWdu
ZWQgdG8gb3RoZXIgZGV2aWNlcywgd2hpY2ggbWFrZXMgaXJxIGRlc2NyaXB0b3Incw0KPiA+IGFm
ZmluaXR5X25vdGlmeSBsb3N0Lg0KPiA+DQo+ID4gU28gbW92ZSBpY2VfcmVtb3ZlX2FyZnMoKSBi
ZWZvcmUgaWNlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoKSwgd2hpY2gNCj4gPiBjYW4gbWFrZSBz
dXJlIGFsbCBpcnFfZ2x1ZSBhbmQgY3B1X3JtYXAgY2FuIGJlIGNvcnJlY3RseSByZWxlYXNlZA0K
PiA+IGJlZm9yZSBjb3JyZXNwb25kaW5nIGlycSBhbmQgZGVzY3JpcHRvciBhcmUgcmVsZWFzZWQu
DQo+ID4NCj4gPiBGaXggdGhlIGZvbGxvd2luZyBtZW1lb3J5IGxlYWsuDQo+IA0KPiBzL21lbWVv
cnkvbWVtb3J5DQo+IA0KPiA8c25pcD4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfYXJmcy5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlX2FyZnMuYw0KPiA+IGluZGV4IDY1NjBhY2Q3NmM5NC4uYzc0OGQwYTVj
N2Q0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
YXJmcy5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9hcmZz
LmMNCj4gPiBAQCAtNjU0LDcgKzY1NCw2IEBAIHZvaWQgaWNlX3JlYnVpbGRfYXJmcyhzdHJ1Y3Qg
aWNlX3BmICpwZikNCj4gPiAgICAgICBpZiAoIXBmX3ZzaSkNCj4gPiAgICAgICAgICAgICAgIHJl
dHVybjsNCj4gPg0KPiA+IC0gICAgIGljZV9yZW1vdmVfYXJmcyhwZik7DQo+IA0KPiBUaGlzIHNo
b3VsZCBub3QgYmUgcmVtb3ZlZC4gUmVtb3ZpbmcgdGhpcyB3b3VsZCBicmVhayB0aGUgcmVzZXQg
Zmxvd3MNCj4gb3V0c2lkZSBvZiB0aGUgc3VzcGVuZC9yZW1vdmUgY2FzZS4NCj4gDQo+ID4gICAg
ICAgaWYgKGljZV9zZXRfY3B1X3J4X3JtYXAocGZfdnNpKSkgew0KPiA+ICAgICAgICAgICAgICAg
ZGV2X2VycihpY2VfcGZfdG9fZGV2KHBmKSwgIkZhaWxlZCB0byByZWJ1aWxkIGFSRlNcbiIpOw0K
PiA+ICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9tYWluLmMNCj4gPiBpbmRleCAyYzIzYzhmNDY4YTUuLmRiYTkwMWJmMmI5
YiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21h
aW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbWFpbi5j
DQo+ID4gQEAgLTQ1NjgsNiArNDU2OCw5IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgaWNl
X3N1c3BlbmQoc3RydWN0DQo+ID4gZGV2aWNlICpkZXYpDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgIGNvbnRpbnVlOw0KPiA+ICAgICAgICAgICAgICAgaWNlX3ZzaV9mcmVlX3FfdmVjdG9ycyhw
Zi0+dnNpW3ZdKTsNCj4gPiAgICAgICB9DQo+ID4gKyAgICAgaWYgKHRlc3RfYml0KElDRV9GTEFH
X0ZEX0VOQSwgcGYtPmZsYWdzKSkgew0KPiA+ICsgICAgICAgICAgICAgaWNlX3JlbW92ZV9hcmZz
KHBmKTsNCj4gPiArICAgICB9DQo+IA0KPiBCcmFjZXMgYXJlbid0IG5lZWRlZCBhcm91bmQgYSBz
aW5nbGUgaWYgc3RhdGVtZW50IGxpa2UgdGhpcy4NCj4gDQo+IEFsc28sIEkgZG9uJ3QgdGhpbmsg
dGhpcyBpcyB0aGUgcmlnaHQgc29sdXRpb24uIEkgdGhpbmsgYSBiZXR0ZXIgYXBwcm9hY2gNCj4g
d291bGQgYmUgdG8gY2FsbCBpY2VfZnJlZV9yeF9jcHVfbWFwKCkgaGVyZS4gV2l0aCB0aGlzLCBp
dCBzZWVtcyBsaWtlIG5vDQo+IG90aGVyIGNoYW5nZXMgYXJlIG5lY2Vzc2FyeS4gSXQgYWxzbyBp
c24ndCBuZWNlc3NhcnkgdG8gY2hlY2sgdGhlDQo+IElDRV9GTEFHX0ZEX0VOQSBiaXQgd2l0aCB0
aGlzIGNoYW5nZS4NCg0KVGhhbmtzIGZvciB5b3VyIHZhbHVhYmxlIHJldmlldy4gSSB3aWxsIHNl
bmQgVjIuDQoNCi0tWW9uZ3hpbg0KDQo+IA0KPiA+ICAgICAgIGljZV9jbGVhcl9pbnRlcnJ1cHRf
c2NoZW1lKHBmKTsNCj4gPg0KPiA+ICAgICAgIHBjaV9zYXZlX3N0YXRlKHBkZXYpOw0K
