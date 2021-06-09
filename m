Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23C3A15EC
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhFINrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:47:16 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:45281
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236498AbhFINrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 09:47:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOPp3Gal4kJcqk4QTNZ1aK7PO9CLTm5261EnD8vVTPYi7DF1G45+VihWxytlxzC6TEcvEpWUUiK/8cv17IdV00f+FaC1n8VKtr0WnZg/6AisoUGWEAw6OjQtPJ1/J7kPBTTzncNnXey5oiu7YSGGkN93nSvu9KmEDMGg2qSD2malgRrYJ83ObmHIlGIxICrrzHT7e32eY0N6eJ8zoHpfdFd+u1XQFUFHOD59qtk+PBS5g078Lg0HAoEhsTT+lLrafmYVCqXxCIaFmtCXLl1KtE6Yy/+qrgj4Uoz/YSheotghFeNmHpndkFt2YPHgE1Mwp6I54jWTD1GYKeVL8IcKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccESFkTSrUmSbBg9Ise5r8uuNyqfEyFGoJpLgrFwwCo=;
 b=EZSnzULFztlL7zDeKHydNCvb+/QJ5vVET/Cc74Yd+wE8IXM/Q6+v9phby8Ivu/rEbsBUz2hlthRuaCmv2qjsTsHp3V2flusCpeoFzqPmPgvel3lwESFHDdqoU97XaPm8mMgpyLLDXT5K6MJjzgzwU2S+W77AdZ9bF95GlMW23H6j6rzSRmvluMdLJsa4eAGN5/ogpuJ692V/toQnypME1o4zR6PEdS7q+wjjIVXp4j25Z86b2iQQEvPdE59IMX2uFnze0CUKiPaAIpDYKMzqx/z0kgsn0XLMNX48fHd1e6qYP4ia9el2t7DhdmVszTy/nNZvGpi8W9OKLrU+hHO8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccESFkTSrUmSbBg9Ise5r8uuNyqfEyFGoJpLgrFwwCo=;
 b=fC0smKf54xCJOCS7DOvlQy3HWkH3OwT674AaNq8VULKw9JJj6gDCmbEYF+ZUfNJczyQzzWJH59WepZnl2meaMAjxaBn9iEsz0ouJledx0gA8UMd7phEugIP8+Y8e/BTy1tNvaYwRTep9ZcRuyaSNr1hjqnc4Q/uNVFKKjIQT+iIzF7NJvQ1qtcPe6Y9jrU8FAgirRlwryr3wj+TXtl0oWvzBTA0+8DRzYhrRWqVPRhQEPkzSrcfjAa21mPaK8dfZ4bPLoBIcU95nr8PHwHSYDPYBKFwpeymo10GNxPJvNmBg1JcCMncPgGEMww/ob3rB52CTrfxbGAsiuC6B5/iOBQ==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM8PR12MB5493.namprd12.prod.outlook.com (2603:10b6:8:3d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.23; Wed, 9 Jun 2021 13:45:19 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 13:45:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Topic: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Thread-Index: AQHXVqgtOTo5DdccDUWHkWiFIp83jqr+w2yAgADrK4CAAFDXgIAA7Z8AgAC7xYCAAOyAgIAAfE0AgAEjb4CAA5i/AIABMJGAgAES5oCAAFkqgIABCGgAgAAEzBCAABm9gIAACjJAgAANgwCAABLRQA==
Date:   Wed, 9 Jun 2021 13:45:19 +0000
Message-ID: <DM8PR12MB5480CA5904F1242202F9D51ADC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
 <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
 <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
 <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
 <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
 <DM8PR12MB54802CA9A47F1585DC3347A5DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <d54ae715-8634-c983-1602-8cd8dea2a5e2@huawei.com>
 <DM8PR12MB5480F577E5F02105B8C1FE9BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <acf08577-34c6-bc9e-a788-568b67fa8d2e@huawei.com>
In-Reply-To: <acf08577-34c6-bc9e-a788-568b67fa8d2e@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 706f06e8-1455-40d2-9b12-08d92b4cd220
x-ms-traffictypediagnostic: DM8PR12MB5493:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM8PR12MB5493FE9A4D761C62FF324BB8DC369@DM8PR12MB5493.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1xJJ71wtseF9zz5qvBDurZbKYfFqlHwYgccicdxucHRxOb3MfTBq0Faa12hPGqQCJJI+bovR3yfkgh26Rm8f72Hkp4IQuWH4afazCk4h7o71sSOerp3Ba9BxqEmYQr/SJ3AC77EsuAHE31Vgy2JQC3rVnk/+uTRQF2i+6NOqZ0rvsdlCTA4Os9HFhcBuJ+iqXn8W1DhAN00wPAFCOgyxH9vo1ZrfT3wjefXE2qBtbAy4UdlaOUl29e+rgSg5GXdHZmnZaCJthFJ4kYtH2VJokFDlleoSru+5cDT/dHR7MYYUyzKZeDcq4IDUrEvRTAvyCkqJBtW5YSZHbJ5uqSJVcmkcDgzlmy4Jzi5HnuA1810C9+Nj6qO7Kyqsc2AONN3vh7udG5pvTEitWba6FyWnay15NWGm/WIPKUifCJI1r3BZFg3wyNgrxX79MSMC0xJp3HcXHxEF8z4IAQkGlAAPnOexPIjbA90fr0lIL10uKRPvHoV98kcedVFXMqF8CofRHfC5VWykhQFUbENzUhmjzaq+q8mDPDjt1Q61S2plC2WwQHxIiYPSjX8t8UMijgPaw0o3HVLuqCHVTcu9RWg66LFsLjHVl8mLFTNFNun37VA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39850400004)(346002)(136003)(7696005)(66476007)(316002)(26005)(186003)(86362001)(66446008)(64756008)(33656002)(71200400001)(38100700002)(5660300002)(7416002)(66946007)(6506007)(53546011)(54906003)(55236004)(76116006)(83380400001)(55016002)(66556008)(9686003)(8676002)(8936002)(478600001)(122000001)(110136005)(52536014)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzBFWCtUdzY0djNFSXNncHdkTUhMa0RFWjhELzZMM3NQdXFIZGphQ2dSSHJK?=
 =?utf-8?B?cmFkY1c5UUlZeWY5VDZvVkkvSSswams0QnJsOWJCenZxR1lJL1lOb1AvbXo1?=
 =?utf-8?B?SVlmaFNsNHoxQVUzaVh3UUk0dDNZTGkyckNPd2ZBdE9FcGg2UXo1NG90RXRP?=
 =?utf-8?B?Slk5UUIyTHZDd2ZjWW5tNnFtWm82S1pSTVFNcUh1NFFlYjFYa2tlTktQNTdW?=
 =?utf-8?B?WkxoZ2dqYTVhTDZ5a0VUSzNhQ1V2aVpRd3RpenFybEJRQmMvRmk0NDZvKzg0?=
 =?utf-8?B?L21sNk1MdEtwU2hwUTBEbktMN3FWd2hLb0ZUWWNPWmJPS2xZOHRpU1hPaG5J?=
 =?utf-8?B?WUUvUkNld2t3UU1DeU1rSVpsUjcxWm9RaEtCUWxmYzFaa1NBRzA3Wnc1YjBN?=
 =?utf-8?B?YS9VUm1sSTNxbTNNUWtVWGVMUXQ1QS94cThqd3FYNnd5S095eEFiZ1ZDYkhL?=
 =?utf-8?B?cGJ6aXU5WURjQWVJdVVzRVZjcXBHekJhMjN5Q3J4Z09sWWFYcEFrMkRMY1dK?=
 =?utf-8?B?YXNMVllwMGpNT1Q3ZDZXRnJJbXl2TThtUzdKVnJ5b3pKYWhpNXoxam5DOElG?=
 =?utf-8?B?RVNnVkZneFQ3YTNRcDc0cjZYdUp4elZyK25Dc1FqQjBHUm1ZVnpkRTdkWUxL?=
 =?utf-8?B?aTRRN0lPbUd4NC9VTG1nblZ3TEEvZjI1c2tVSjJzZ3hIY0toeXFmZmxJSm9s?=
 =?utf-8?B?bEZ3dU12enZuMVd0L2N6Ymp0enV5djdwd1RUUmZuUUQwMFcrRzhzOUJuYWRQ?=
 =?utf-8?B?T0tSVXVxaGtqWTdteXlhSmFNN055aEdoK09US2pGU1JkRWxkdFpxREdYSTcx?=
 =?utf-8?B?KzJWTTNVZ1BRZEQ0U24vUG1Hejh3aDNxY01IaURDaWlXRndMdHFCYVRadTY3?=
 =?utf-8?B?bTZaNkNlaE91SEV3eUVaQndSTXNQR0RmUjVBV0Z4TlhIczlRT25MUHRzZ21R?=
 =?utf-8?B?NXJMTmxvVng2elIzZ1ZFdzEzV2VMSE9FUmdpQ2ZHc3p0aHFrOXBxRE5YZ0Q5?=
 =?utf-8?B?SlBYZDdWWE1sd3UwOTlkT003SkFLRUpSMjRSa1ZkOFJHVk4zN3F2MzEwclFj?=
 =?utf-8?B?aVhIVW0rTWUzSXpYM3V5MkFCa1Z2QWJqZ0d0ODFUSmJJYkRaUTRYQTJQUmNZ?=
 =?utf-8?B?d1NZbEJEbzBuV3BiRys0bGxscTRiN0JHcGJmUmJTYWw2dHc4Uk16MUVpL05C?=
 =?utf-8?B?N2N1OUVTdHplaWtYQmZuVWhOSUJIMllJNmxmeXVQY21ub0pCOURsZjd0N0lx?=
 =?utf-8?B?eHZJQTlZVGdpdUNNbVJkbnZDVkRudnA3V09WVWdNYjErNzFHcG9DSFZ6RVpp?=
 =?utf-8?B?MjlKZjU5N2tob28xTHUvczgvV0ZWdG5VTVU1SnRTN3IwMmEzNGxtK0dhYUNT?=
 =?utf-8?B?YkZteUR2NWJxUDFENlNvdUNmejBITUpsWUkyNytSRzcrb2l0QWUwaTVsTEpR?=
 =?utf-8?B?aEFxNEJIZWJKY3FWT0drNXowaXEwVm9KbVJ6RUx6SVBsTXNsVmk1SnNUc0x1?=
 =?utf-8?B?NmowWGdZZXBtTFRldUFES3RXUFZvblFRQzlIVWdJVTJ3MkluWGNwd29WbDBu?=
 =?utf-8?B?NWhCMjlnZWIwQ0dBdDhkbjFod1JmdkhOcVJLRmVqYWExYkF3RHpTZzN3clNu?=
 =?utf-8?B?dE45cVpFVlM3K1lMaTRXS1RwQlBGbmVvdU9BeTdDa1VULzZUTml6cE5Yei9S?=
 =?utf-8?B?L21URXZHb1Jud2xXYmFhTkUxZlpWWjZTajNwTWdvNTB5Y3dmS3VEb0FlOXJL?=
 =?utf-8?Q?vpM1EyOqORFsvMteHUikxHxNEUW7naYL5YpZT5V?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706f06e8-1455-40d2-9b12-08d92b4cd220
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 13:45:19.1411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ho4dTZJjsZkGkFdSwct6ImzJr6D4RwwOup70uxG+7pz4HJs+NN+QLciRzz6iyG/eQBk+o/HMY8qrDMA/hxGBHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5493
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIEp1bmUgOSwgMjAyMSA2OjAwIFBNDQo+IA0KPiBPbiAyMDIxLzYvOSAxOTo1
OSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+PiBGcm9tOiBZdW5zaGVuZyBMaW4gPGxpbnl1bnNo
ZW5nQGh1YXdlaS5jb20+DQo+ID4+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSA5LCAyMDIxIDQ6MzUg
UE0NCj4gPj4NCj4gPj4gT24gMjAyMS82LzkgMTc6MzgsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4g
Pj4+DQo+ID4+Pj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0K
PiA+Pj4+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSA5LCAyMDIxIDI6NDYgUE0NCj4gPj4+Pg0KPiA+
Pj4gWy4uXQ0KPiA+Pj4NCj4gPj4+Pj4+IElzIHRoZXJlIGFueSByZWFzb24gd2h5IFZGIHVzZSBp
dHMgb3duIGRldmxpbmsgaW5zdGFuY2U/DQo+ID4+Pj4+DQo+ID4+Pj4+IFByaW1hcnkgdXNlIGNh
c2UgZm9yIFZGcyBpcyB2aXJ0dWFsIGVudmlyb25tZW50cyB3aGVyZSBndWVzdCBpc24ndA0KPiA+
Pj4+PiB0cnVzdGVkLCBzbyB0eWluZyB0aGUgVkYgdG8gdGhlIG1haW4gZGV2bGluayBpbnN0YW5j
ZSwgb3ZlciB3aGljaA0KPiA+Pj4+PiBndWVzdCBzaG91bGQgaGF2ZSBubyBjb250cm9sIGlzIGNv
dW50ZXIgcHJvZHVjdGl2ZS4NCj4gPj4+Pg0KPiA+Pj4+IFRoZSBzZWN1cml0eSBpcyBtYWlubHkg
YWJvdXQgVkYgdXNpbmcgaW4gY29udGFpbmVyIGNhc2UsIHJpZ2h0Pw0KPiA+Pj4+IEJlY2F1c2Ug
VkYgdXNpbmcgaW4gVk0sIGl0IGlzIGRpZmZlcmVudCBob3N0LCBpdCBtZWFucyBhIGRpZmZlcmVu
dA0KPiA+Pj4+IGRldmxpbmsgaW5zdGFuY2UgZm9yIFZGLCBzbyB0aGVyZSBpcyBubyBzZWN1cml0
eSBpc3N1ZSBmb3IgVkYgdXNpbmcNCj4gPj4+PiBpbiBWTQ0KPiA+PiBjYXNlPw0KPiA+Pj4+IEJ1
dCBpdCBtaWdodCBub3QgYmUgdGhlIGNhc2UgZm9yIFZGIHVzaW5nIGluIGNvbnRhaW5lcj8NCj4g
Pj4+IERldmxpbmsgaW5zdGFuY2UgaGFzIG5ldCBuYW1lc3BhY2UgYXR0YWNoZWQgdG8gaXQgY29u
dHJvbGxlZCB1c2luZw0KPiA+Pj4gZGV2bGluaw0KPiA+PiByZWxvYWQgY29tbWFuZC4NCj4gPj4+
IFNvIGEgVkYgZGV2bGluayBpbnN0YW5jZSBjYW4gYmUgYXNzaWduZWQgdG8gYSBjb250YWluZXIv
cHJvY2Vzcw0KPiA+Pj4gcnVubmluZyBpbiBhDQo+ID4+IHNwZWNpZmljIG5ldCBuYW1lc3BhY2Uu
DQo+ID4+Pg0KPiA+Pj4gJCBpcCBuZXRucyBhZGQgbjENCj4gPj4+ICQgZGV2bGluayBkZXYgcmVs
b2FkIHBjaS8wMDAwOjA2OjAwLjQgbmV0bnMgbjENCj4gPj4+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBeXl5eXl5eXl5eXl5eDQo+ID4+PiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgUENJIFZGL1BGL1NGLg0KPiA+Pg0KPiA+PiBDb3VsZCB3ZSBjcmVh
dGUgYW5vdGhlciBkZXZsaW5rIGluc3RhbmNlIHdoZW4gdGhlIG5ldCBuYW1lc3BhY2Ugb2YNCj4g
Pj4gZGV2bGluayBwb3J0IGluc3RhbmNlIGlzIGNoYW5nZWQ/DQo+ID4gTmV0IG5hbWVzcGFjZSBv
ZiAoYSkgbmV0ZGV2aWNlIChiKSByZG1hIGRldmljZSAoYykgZGV2bGluayBpbnN0YW5jZSBjYW4g
YmUNCj4gY2hhbmdlZC4NCj4gPiBOZXQgbmFtZXNwYWNlIG9mIGRldmxpbmsgcG9ydCBjYW5ub3Qg
YmUgY2hhbmdlZC4NCj4gDQo+IFllcywgbmV0IG5hbWVzcGFjZSBpcyBjaGFuZ2VkIGJhc2VkIG9u
IHRoZSBkZXZsaW5rIGluc3RhbmNlLCBub3QgZGV2bGluaw0KPiBwb3J0IGluc3RhbmNlLCAqcmln
aHQgbm93Ki4NCj4gDQo+ID4NCj4gPj4gSXQgbWF5IHNlZW1zIHdlIG5lZWQgdG8gY2hhbmdlIHRo
ZSBuZXQgbmFtZXNwYWNlIGJhc2VkIG9uIGRldmxpbmsNCj4gPj4gcG9ydCBpbnN0YW5jZSBpbnN0
ZWFkIG9mIGRldmxpbmsgaW5zdGFuY2UuDQo+ID4+IFRoaXMgd2F5IGNvbnRhaW5lciBjYXNlIHNl
ZW1zIGJlIHNpbWlsaWFyIHRvIHRoZSBWTSBjYXNlPw0KPiA+IEkgbW9zdGx5IGRvIG5vdCB1bmRl
cnN0YW5kIHRoZSB0b3BvbG9neSB5b3UgaGF2ZSBpbiBtaW5kIG9yIGlmIHlvdQ0KPiBleHBsYWlu
ZWQgcHJldmlvdXNseSBJIG1pc3NlZCB0aGUgdGhyZWFkLg0KPiA+IEluIHlvdXIgY2FzZSB3aGF0
IGlzIHRoZSBmbGF2b3VyIG9mIGEgZGV2bGluayBwb3J0Pw0KPiANCj4gZmxhdm91ciBvZiB0aGUg
ZGV2bGluayBwb3J0IGluc3RhbmNlIGlzIEZMQVZPVVJfUEhZU0lDQUwgb3INCj4gRkxBVk9VUl9W
SVJUVUFMLg0KPiANCj4gVGhlIHJlYXNvbiBJIHN1Z2dlc3QgdG8gY2hhbmdlIHRoZSBuZXQgbmFt
ZXNwYWNlIG9uIGRldmxpbmsgcG9ydCBpbnN0YW5jZQ0KPiBpbnN0ZWFkIG9mIGRldmxpbmsgaW5z
dGFuY2UgaXPvvJoNCj4gSSBwcm9wb3NlZCB0aGF0IGFsbCB0aGUgUEYgYW5kIFZGIGluIHRoZSBz
YW1lIEFTSUMgYXJlIHJlZ2lzdGVyZWQgdG8gdGhlIHNhbWUNCj4gZGV2bGluayBpbnN0YW5jZSBh
cyBmbGF2b3VyIEZMQVZPVVJfUEhZU0lDQUwgb3IgRkxBVk9VUl9WSVJUVUFMIHdoZW4NCj4gdGhl
cmUgYXJlIGluIHRoZSBzYW1lIGhvc3QgYW5kIGluIHRoZSBzYW1lIG5ldCBuYW1lc3BhY2UuDQo+
IA0KPiBJZiBhIFZGJ3MgZGV2bGluayBwb3J0IGluc3RhbmNlIGlzIHVucmVnaXN0ZXJlZCBmcm9t
IG9sZCBkZXZsaW5rIGluc3RhbmNlIGluIHRoZQ0KPiBvbGQgbmV0IG5hbWVzcGFjZSBhbmQgcmVn
aXN0ZXJlZCB0byBuZXcgZGV2bGluayBpbnN0YW5jZSBpbiB0aGUgbmV3IG5ldA0KPiBuYW1lc3Bh
Y2UoY3JlYXRlIGEgbmV3IGRldmxpbmsgaW5zdGFuY2UgaWYNCj4gbmVlZGVkKSB3aGVuIGRldmxp
bmsgcG9ydCBpbnN0YW5jZSdzIG5ldCBuYW1lc3BhY2UgaXMgY2hhbmdlZCwgdGhlbiB0aGUNCj4g
c2VjdXJpdHkgbWVudGlvbmVkIGJ5IGpha3ViIGlzIG5vdCBhIGlzc3VlIGFueSBtb3JlPw0KDQpJ
dCBzZWVtcyB0aGF0IGRldmxpbmsgaW5zdGFuY2Ugb2YgVkYgaXMgbm90IG5lZWRlZCBpbiB5b3Vy
IGNhc2UsIGFuZCBpZiBzbyB3aGF0IGlzIHRoZSBtb3RpdmF0aW9uIHRvIGV2ZW4gaGF2ZSBWSVJU
VUFMIHBvcnQgYXR0YWNoIHRvIHRoZSBQRj8NCklmIG9ubHkgbmV0ZGV2aWNlIG9mIHRoZSBWRiBp
cyBvZiBpbnRlcmVzdCwgaXQgY2FuIGJlIGFzc2lnbmVkIHRvIG5ldCBuYW1lc3BhY2UgZGlyZWN0
bHkuDQoNCkl0IGRvZXNu4oCZdCBtYWtlIHNlbnNlIHRvIG1lIHRvIGNyZWF0ZSBuZXcgZGV2bGlu
ayBpbnN0YW5jZSBpbiBuZXcgbmV0IG5hbWVzcGFjZSwgdGhhdCBhbHNvIG5lZWRzIHRvIGJlIGRl
bGV0ZWQgd2hlbiBuZXQgbnMgaXMgZGVsZXRlZC4NCkFuZCBwcmVfZXhpdCgpIHJvdXRpbmUgd2ls
bCBtb3N0bHkgZGVhZGxvY2sgaG9sZGluZyBnbG9iYWwgZGV2bGlua19tdXRleC4NCg==
