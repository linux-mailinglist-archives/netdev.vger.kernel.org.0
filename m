Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB813F8683
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242218AbhHZL3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:29:54 -0400
Received: from mail-vi1eur05on2117.outbound.protection.outlook.com ([40.107.21.117]:47456
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241879AbhHZL3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 07:29:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElbpNU+zEHdjLhNV5CCBFrm/RhQiyZ1QiweBWyQb1U5ar4m7FyBhrLC96QKPehRzGtJHpDW/0peBJJtM6yflwWmDMHn4uXvYzFqBjmRbWCjReJSNmsc8UNeXIwtCBSJK+SAcav78K4ppv1jpDWpUfjrU8F9tCkZrfKZmr5NAiZh/ulQlW1Toa5OMpZfZd+1KCDajPLMAihEyOth/YVxsGEUGESb93TUtLXYYw2ICueSsR13ngipnm39d4mBLH4WnwExkuyFXWWAJ8SDRIULUkNQsFTW4LNsC57NREuL6nTWPFkEIRWYLH1smKURE2MomKcJN2sMPriI3UdOXCT7Dyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+botBeLrsokgI1l1/BhuXk9mRGQ+ckcFkdlZHMiWRU=;
 b=Cmm53oELk6le4qb3vj4LsGb0Mm+Tg7E447Uz3sZBXDTacXODmLseBoFcIPfVtueUtoXjiNYt5nTO/wKEJPggx1BxoiANQGnvkwVVVrthY0H63RVDZIoyrU24L8ySFfOsLuZDcKz5zMlH0KDbBbp838LIFQo+DvKVQDvUKiA5xC2Jp13HzmaBtYIadUhIEVW00v2Eoi1J3T80C8x8vBi7bvxaUXZubpPH9UNumBJBCB6aVWNahaZOdKfpvzgtB8SSqNWbFWt+Fl+/KjVT+GGDMpOWHXlMw+SsBdlJoa7ZmiAnrWi0arzSOWeoZ22ei+aJDVS0/kl0rYhm73yCvaCfJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+botBeLrsokgI1l1/BhuXk9mRGQ+ckcFkdlZHMiWRU=;
 b=amOfOJ2P1pEZ2FovYv2Crt4aubSw7TTh1PVOIbnQPKXi6gSRhSEEHi8TgRdEj2XCKQIGDLQpPcqVwpFFYXw21RpXFtHhYHtxNjvLLRBk5yKc2e0K5hEjnCMZepvF/NLQ/QirQFwIc+XFCDGBAWIygtxuImQhLz198jD2yZStt8o=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2779.eurprd03.prod.outlook.com (2603:10a6:3:ee::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Thu, 26 Aug 2021 11:29:01 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 11:29:01 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>
CC:     "kernel-team@android.com" <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with
 fw_devlink=on
Thread-Topic: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with
 fw_devlink=on
Thread-Index: AQHXmk5diAXgYO5EfEucUEByv4+R3KuFpoQA
Date:   Thu, 26 Aug 2021 11:29:01 +0000
Message-ID: <455824c8-51bf-9517-98fd-1f6b2a21261d@bang-olufsen.dk>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-3-saravanak@google.com>
In-Reply-To: <20210826074526.825517-3-saravanak@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52c4fee6-5f18-41f8-4163-08d96884b3f5
x-ms-traffictypediagnostic: HE1PR0302MB2779:
x-microsoft-antispam-prvs: <HE1PR0302MB2779729FD2738FC137F20B4483C79@HE1PR0302MB2779.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zJlFYtvuZLNxd3dS7gh1XGoq0FlglKM3omLJ+QoeB0gEy/OuGIq1MzAM76mCT/cl4xsZZkCo/2V4oEENf8/ZoPSrH3lOXShxt6eueZwWJejYbbVMELLiHErZX6ImFILcSijKkiBYrD6a1lNJ06TGfzlWkBmhnOwD4kLsVfZdW5joswGiiNx2zRgkdauzOxxJIHvh3W4pG9CoR/FuT59ghEWxqtfzTsSzA731ALEhnQmrGXIHg9CqoSK35m8fN4EnYh6XrYCm8fhZkeTS+XaDso3Au/UlsG4/jnK+phEJNDNwF1o7JrSJDXN5EGLnKbDV3BF3sPjZD8aLXCTfrCqAj72fUWtDbvtZqQ5SJ9GCtXmoEOUSAYDlNJ978B9dHAGmqRS4CMpXJYpiHW+FRY2FJJQ5Fd7LLs7rTn3uJT0PRsmjv6jfu5eK75kuI85KQpsISHxaQStoxvFZ+JJy0l4PVw9cVV8Wv7qDymkSFoD3RmBfneX8fcZd+iYVBy9PYMS2FgIsdLh6ajULt+5vadeXUYsj/25rpKIg+hgCDKTAKuf9zzor2cC0JhFloQ3pRlFoeRtR5CmBGYuwGIeD2+fkOZFq+JecGLxsZqMJGlgkwZOc03uq7o3ZsabS7lmE/DrZ7MeOBFuOxbAr7NRwh3aYn0BexhQ8TzAuPTtBxVn4mgqeiamhA/1miakbivhNy2CPucO/ByMjqDBlCIRhmITCwVAPWnPiiqDh5ghsUXxgKUDBGlNgMEa2FbCu8cavg7eoV4QJk6UFkisMAWoKx6Tpahcudd/f7y/lAZ9RINBpSMI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39850400004)(36756003)(2906002)(8976002)(110136005)(5660300002)(54906003)(478600001)(31686004)(921005)(38100700002)(122000001)(4326008)(66574015)(53546011)(85202003)(66946007)(66556008)(76116006)(26005)(91956017)(66446008)(66476007)(31696002)(6506007)(2616005)(8936002)(64756008)(85182001)(6486002)(86362001)(316002)(186003)(8676002)(6512007)(7416002)(71200400001)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWlKMjVSMmtYNUtTbDBmRHJjN292N1hLWEo0UlBCTGlwVjYyTys1bjZ6Um5k?=
 =?utf-8?B?dEpwZlU1MklQemppNmg2VjhhWDJVNExpNjRRekUrMXdnc2pZbnpXYjlwTGln?=
 =?utf-8?B?MFM2NkFVeDB4VXRzLzhTUEtVOXlYM3FPM2hmUmZZWWRSQU0xaW9GZmtzbm9Q?=
 =?utf-8?B?eE1NYTJqNC9ZcXhPTmtzeVRoWFdSeFFqZ1N3S1JFSE5OQ0NqNjFpWkIvYWtQ?=
 =?utf-8?B?TkVCck5hWU1OUW9pOGhXVHRJYnhjbnRKMEg3SmJpbkNmUkF0MVFSWnhlRCsw?=
 =?utf-8?B?ckRaS1Z5V21VTnp0NWFEYjRjdG0weWV4enlwZjFjQVdGUUpVQWp5L1Y2dHBX?=
 =?utf-8?B?bVdtNk1BOWlyeWl5azQxMUNyVGZrUDhPMDdzNE4xMEVLSTdHTVNQaWNLSWNX?=
 =?utf-8?B?RkdsMFcyWGxYYlppV1o4OEx1WlRXenMwbFVGZ0pYZjNFS29ROTQyY2YrVWJp?=
 =?utf-8?B?VTV5OWhJMVNCdmNEUE1iTFhQT1R4blA1VXNtNnY0b1ZDTk81OFVycmFQK2F4?=
 =?utf-8?B?a0wzRFV5QkVZcFVHK1huUWFSdzFsb0UrZGZhamZRclo5K205d0RWbjY5V1Vt?=
 =?utf-8?B?STFIMlVOQ2N3WG5KNG4rMlpKcXlJS0pJUVBuQkRyT0E2VExNZ0ptQUwvaEZh?=
 =?utf-8?B?b05vcENLdURmRmZ0cGtzYTc0S3BRNkx0d3ZPK3NOLy80N2pxYVlsK2FNSUdh?=
 =?utf-8?B?ZmxRbUFYOWl5NjE4NkxRekhhRHBpOUllZ0dWQ0JIN0ZrR0NVR2d4bzBvaExG?=
 =?utf-8?B?bDZYb0VpRU1YZGU3NFpFaXdlKzBiT3NySFhRTGRrM0Q1YUZCY1ZaeXBtUmhL?=
 =?utf-8?B?MmhsdFE5SlRMWXc0TFBjMmw2R0V5eHJLMW5HYk1WVDlrbDJuTWlreUlPL0hB?=
 =?utf-8?B?cmVpb1RtT0s0cE1qOS9QMVF0MXg5VDBRWWg0S2ppUFBZR25YVmRpT252VUJ0?=
 =?utf-8?B?WG5YUjlDcFlJUkk1RGVlclI4amc3ZG1zaE82VWZuRStsTjgycTkzbnkvR0py?=
 =?utf-8?B?ODVudUZ3M0R0QlBaemFrandEa0hXTzNrQUgzMkFUSHZ0Y2hYQWpqM2FNYzNS?=
 =?utf-8?B?c2ZhMEF2NGlyQzMxMm5kWXNxOTlqZEN4VXdLOXJFN1FzM05VcnYrRFJISzEw?=
 =?utf-8?B?aWh2aEJ0cDVpOWhMTVYrMDdHNW9GWG5DMlI0OFdSYTNoVzhkZE9vbkJPWVBj?=
 =?utf-8?B?ZmViZHRZM1JFaEJ6OEQ2SGtmUEtZZ3NDczJPMHlHOUVoVzliQ21GeW54K2Fn?=
 =?utf-8?B?cUZORnh6YmVoMGViTE5YSXlQcmd0Nk9xWFp5RHVTdTlNWEdrR3d6cHRMVXJs?=
 =?utf-8?B?UXNxcG1HcldLa0hyTDZnc01idktuSlpuWVh0dWFLZEo5MTJGTGh3cUhQU3ov?=
 =?utf-8?B?Q01VQ1AzYjNaRjBOeG1RSzcxTTNQUTR5a0lFWDhwWXJ6Ny9aems3WXVuTWNo?=
 =?utf-8?B?TW16VXowZGNYY1h2a1RzSm5hTmtobVBzcmJiREZtWGNVYnFRZmQ1TVVwVXRa?=
 =?utf-8?B?SWZDRkVsMnJhS2VDUzc2eWx4WFRpNUdETlBlTzNpWDk3Vk9NOFU1NGZ6ckth?=
 =?utf-8?B?Y1ZTZFZHTnhHN2lxV3NsVFBJZkJjNWhrZE1RbkYwV0k2Z0NGZkQ0V3VMNzdJ?=
 =?utf-8?B?RWhwSU96Y3BXM0hGTmpnUkdpZDZZUTJ6SzFUT3BqZkplaDVOaXh6ZHo2djRY?=
 =?utf-8?B?YStmVE5qb2lyd1RlVHZxeW9ncWErdHJEUkdjd2ZUZ2FmSStYdVJwNm9jYmxV?=
 =?utf-8?Q?8eCaaZ3jyvayi/8cbBImNPwqEz+mNrOtHzTG8wB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CFAC36317501E4F94522D7D39522AC6@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c4fee6-5f18-41f8-4163-08d96884b3f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 11:29:01.2852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Usc9AgayWkg8Jd+gFeHRHmrRnICA3wk49nCxAHTqXcS9BKF0NL/lOLXZeAmFSYkxzQlkfUtZA2zNSlN0WZafzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2779
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FyYXZhbmEsDQoNCiBGcm9tIGxvb2tpbmcgYXQgdGhlIGNvZGUsIHRoZSBNYXJ2ZWxsIERT
QSBkcml2ZXIgbXY4OGU2eHh4IG1heSBhbHNvIA0Kc3VmZmVyIGZyb20gdGhlIHNhbWUgcHJvYmxl
bSBpZiBmd19kZXZsaW5rPW9uLiBNYXliZSBzb21lYm9keSAoQW5kcmV3PykgDQpjb3VsZCB0ZXN0
IHNvIHRoYXQgeW91IGtub3cgd2hldGhlciBpbmNsdWRlIGEgc2ltbGFyIHBhdGNoIHRvIHRoYXQg
DQpkcml2ZXIgaW4geW91ciBzZXJpZXMuDQoNCk90aGVyIGRyaXZlcnMgbWF5IGJlIGVmZmVjdGVk
IHRvbyAtIGFzIEFuZHJldyBzYWlkIGluIHRoZSBvdGhlciB0aHJlYWQsIA0KdGhpcyBpcyBub3Qg
YW4gdW5jb21tb24gcGF0dGVybiBmb3IgRFNBIGRyaXZlcnMuDQoNCk9uIDgvMjYvMjEgOTo0NSBB
TSwgU2FyYXZhbmEgS2FubmFuIHdyb3RlOg0KPiBUaGlzIGlzIGp1c3QgYSBxdWljayBmaXggdG8g
bWFrZSB0aGlzIGRyaXZlciB3b3JrIHdpdGggZndfZGV2bGluaz1vbi4NCj4gVGhlIHByb3BlciBm
aXggbWlnaHQgbmVlZCBhIHNpZ25pZmljYW50IGFtb3VudCBvZiByZXdvcmsgb2YgdGhlIGRyaXZl
cg0KPiBvZiB0aGUgZnJhbWV3b3JrIHRvIHVzZSBhIGNvbXBvbmVudCBkZXZpY2UgbW9kZWwuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBTYXJhdmFuYSBLYW5uYW4gPHNhcmF2YW5ha0Bnb29nbGUuY29t
Pg0KDQpXaXRoIHRoZSBjYXZlYXQgdGhhdCBpdCdzIGEgdGVzdCB3aXRoIG15IFJGQyBydGw4MzY1
bWIgc3ViZHJpdmVyLi4uDQoNClRlc3RlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1v
bHVmc2VuLmRrPg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmMgfCA3ICsrKysrKysNCj4gICAxIGZpbGUgY2hhbmdl
ZCwgNyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3Jl
YWx0ZWstc21pLWNvcmUuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmMNCj4g
aW5kZXggOGU0OWQ0Zjg1ZDQ4Li5mNzljMTc0ZjQ5NTQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0
ZWstc21pLWNvcmUuYw0KPiBAQCAtMzk0LDYgKzM5NCwxMyBAQCBzdGF0aWMgaW50IHJlYWx0ZWtf
c21pX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAgCXZhciA9IG9mX2Rl
dmljZV9nZXRfbWF0Y2hfZGF0YShkZXYpOw0KPiAgIAlucCA9IGRldi0+b2Zfbm9kZTsNCj4gICAN
Cj4gKwkvKiBUaGlzIGRyaXZlciBhc3N1bWVzIHRoZSBjaGlsZCBQSFlzIHdvdWxkIGJlIHByb2Jl
ZCBzdWNjZXNzZnVsbHkNCj4gKwkgKiBiZWZvcmUgdGhpcyBmdW5jdGlvbnMgcmV0dXJucy4gVGhh
dCdzIG5vdCBhIHZhbGlkIGFzc3VtcHRpb24sIGJ1dA0KPiArCSAqIGxldCBmd19kZXZsaW5rIGtu
b3cgc28gdGhhdCB0aGlzIGRyaXZlciBjb250aW51ZXMgdG8gZnVuY3Rpb24gd2l0aA0KPiArCSAq
IGZ3X2Rldmxpbms9b24uDQo+ICsJICovDQo+ICsJbnAtPmZ3bm9kZS5mbGFncyB8PSBGV05PREVf
RkxBR19CUk9LRU5fUEFSRU5UOw0KPiArDQo+ICAgCXNtaSA9IGRldm1fa3phbGxvYyhkZXYsIHNp
emVvZigqc21pKSArIHZhci0+Y2hpcF9kYXRhX3N6LCBHRlBfS0VSTkVMKTsNCj4gICAJaWYgKCFz
bWkpDQo+ICAgCQlyZXR1cm4gLUVOT01FTTsNCj4gDQo=
