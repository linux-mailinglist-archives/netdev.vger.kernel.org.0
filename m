Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D77D39E6A1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFGS2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:28:52 -0400
Received: from mail-mw2nam08on2087.outbound.protection.outlook.com ([40.107.101.87]:39424
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230253AbhFGS2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 14:28:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTl1pqm04gfFCg7aSavJdsJXn7eSeFB0b59kO9N6l+PjpEZoxUzh6gCLY5BEbvkAx4cIWnRJIe690OlWuE7JO/QLrX7Rcbu9JqI+J3smwFX/w3zi+wD3dv69KIayvbN/weknrE/PtBZ3yPyd3Lxliqvwl3tlYwufLZGMdJMz3Bk3RRkEaS3V5+iKcH2ywrezd8dY/jVJRbzgEZU2Nf5KpXer4Dpo+pduuK/L4VRbSd0bosE7/XC5JXGZ+w2nNRC09zR2LCJ5sUa6xIrEAEO4yLbmjhAD8dVGVlMxXrlpE3mywbdMCmqJ6bKhQYeGN9RDl90DOSUIks4gi4Z8/+xHOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80Ktmndb3MZ/D7Ig8mEdswTkxR+4fSRdf1Dwg0lNbos=;
 b=bMQmIForI0TBUBPupWRXDvgkfX6Z0eAQIaVtitVHsL38fEHVXV3fGa50tbtbGxCoPJqokff5x6hJs4CHfvsfF/Lka/ZcSeELlJziEc6oIictFSTAQWgS8ykLnQYUiuRjeBDL7A75I+ohQgia5VUlGHa7K/F3e7oCCn7LkctlS+iYP0d7aa6zHpv1wL7zK4YFKP0WBi2CYyNuNv4J1M1bW/TzKMHZcZ2lm8cA+hCHXx9ktMHz+3ixgBTepy7G5rBoDk8dWk8UJvxoorZDVhzmr3Aw91mI6tJhqILlQLV4n37Y4iqWWVQGvlMj0GOCFDUH+d0mc5CO9raEZhGGPog72A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80Ktmndb3MZ/D7Ig8mEdswTkxR+4fSRdf1Dwg0lNbos=;
 b=dCir1G+5PZp/m7hqk8pxQ/X8WKx2f/7KoEvvwCCc120a84W42GlX65ull4moz38PxOkAMufhY4+MmyZWZKJitFcjbFobpQ7aLXFBuJRokdg0QwVp6ioAfPCTMEcZeLzudv8V8HgzXjWvWYzldRMDd7uIG1o6wAqc3/9BPcZWkVdDhmTeWoaf1wGACuDdISCFASHdWrMorfbtonxIDamiEGvuIDlncuY5KxFToqW/Ykd7gcINaHi4aT/qn4aXeWXyh1FNDWLW2leYWticpqBSfwtjRnB9ePbzn2VQqycQktC2GGB2j9+m38v9OTzryH9whio4YkXcbsXAzaG7oGDQJA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5467.namprd12.prod.outlook.com (2603:10b6:510:e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 18:26:58 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 18:26:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Topic: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Index: AQHXWGpNwXhSEOm/yUu2yThJsUjGQKsH4bwAgACRO4CAADKKgIAABmLAgAATiACAACTXQA==
Date:   Mon, 7 Jun 2021 18:26:58 +0000
Message-ID: <PH0PR12MB548168FCE64748069A45A6C1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <43ebc191-4b2d-4866-411b-81de63024942@gmail.com>
 <PH0PR12MB548101A3A5CEAD2CAAB04FB1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <d41a4e6c-0669-0b6c-5a2d-af1f3e5ae3bd@gmail.com>
 <PH0PR12MB54813150C3567170590BE36DDC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <5a3a1292-a18d-8088-f835-44060aeb6a8a@gmail.com>
In-Reply-To: <5a3a1292-a18d-8088-f835-44060aeb6a8a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.218.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51446de2-ff68-48b9-8d1d-08d929e1d62d
x-ms-traffictypediagnostic: PH0PR12MB5467:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5467208AF8DEF024B603599ADC389@PH0PR12MB5467.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/jwpWKkAwEN9Ew3o1xp3yBWwyO+sNJD04t6G/gmeY7h9hwue5dPwrHV2sAT215s6VGkk7SrWYs4f+9NKuVaVHi/Vuy0ZP4vRF+WWuFgQOUixftc9skxF4+SF/45xlEGuVajRUeYc9tkUGqts0h9F2jkG7TS/oRiqF+lbjK/vGRG6fbLTD84AJDGystsKa63N5sXJOsJMBpn8bKAPZeeaTIM+C2+rdp8CKRyInPAk3EcFfOdbzSVrNaRJxl6VTXOtd/TF5pz3iZxKzi3ddZNqfTTcfF3Dwro1AAW5wlSYOVJijwGmw6OsXxyC3FvjW889Z92CnLCQLKiAjU4biH8Q4MAgJgzuQwT4spTmeotYQxhg1wwWbDSjQlWqiYEluw1rmyCBnaXxxfNefZiXHlVBxsoreRx09i3fdM0rZ7l+XaMg49vBNlPttrOueoB1HOUNRhGXm8EJUYcmE9nuXqisx6Gnbi9JzpuaL+kO+yqzmGDkUcZmbMpQVgZ7Rbm7zNxPL5X1ymclVxOmUtEvsvIlIIo49SUkjoXxyXjDtEEZ4Wg+3fr96m29ibzGyBwYF28IQlIor/NX9pwc4ZGpuqHLsicrEZ7Ri93IIY0XNgSwCihpswgUBYWbDqP0bQHVB4F4c6o+5fJ1ImzedgVpJ0kNjilghM9HCU0Drb1l9d/BDkh7dGaJWSeAWTVQ+CacHflt0X36aaHrK21F5UpCO6Wg656JPxY3lpq7E0GfRJoKbw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(8936002)(76116006)(7696005)(478600001)(64756008)(966005)(52536014)(66556008)(110136005)(316002)(55016002)(122000001)(53546011)(6506007)(38100700002)(186003)(9686003)(2906002)(107886003)(26005)(55236004)(4326008)(66476007)(66946007)(5660300002)(71200400001)(33656002)(86362001)(8676002)(66446008)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a0R2c1Y0RVNsNWwzOGtyTnRmRkxYSEY5QnA0ZW9OT0NVRldUWHRvMkpTQUpF?=
 =?utf-8?B?eUhhbVJ5RU9Vbk4wRGRNUlg1UXE0WjN4U05VbFdJRkJ1bFBFTUhaME85YUtE?=
 =?utf-8?B?QVpSd2hNbXlOT1ZnSWxQTnNPenRjRzNPRXgvcG1GV3V1WFh2VzBRUGUrNFRW?=
 =?utf-8?B?VlRxNXpKYUFUQnpxWk9KQ0F2RDFwTzNGMW5EdUNNSDNjcG5Cd2hmK1RzcHFq?=
 =?utf-8?B?dVp6ZnpZcU5SMTNzbXRIZmlqWkFrZVVvMXc3Sm1nQnhkaVIwU0g0dzIydSs2?=
 =?utf-8?B?cjQwNHA2dG5TV3dKdTdBSWVsTHIwcFYxdGtXV05Ud0x3RTdzQWdodUs2ajNV?=
 =?utf-8?B?K1FnWjVKSm5uQzZOOStYUXYvMEN5c3dJZ0pnMnI4TG1sT0daaWlYTkFpcmh1?=
 =?utf-8?B?M1oySVVtd1pHdk9LbGcwemJiYmJlY1FzM29MYVR3WnNlazlFTk1VbGhwZ0NB?=
 =?utf-8?B?M2lvM1BTVWxYWE1Idks5bVhrQkp6dkovcHgrOVhYMFo1RENOakMrdkV5di9H?=
 =?utf-8?B?ZFNkek5jQ3R6SnNYVjlTZWl6a2dDMkdEVjgyZEx1eUpTcUZuemNzME8rWENF?=
 =?utf-8?B?TUtRUGpVUTk3OWYyY29iZ0VFVUtXdFJCU1R5a0kzVnpkdHkzeU1kejFQL3ho?=
 =?utf-8?B?R2xZcFVNekRrMFZsZlhPSDZtY0ZqVVd2dHRwU0ZOYzBpTnNvSVh6c0tOR083?=
 =?utf-8?B?QzUzWkZUMVhiY0NObUpKY0srUmVZbW9QaktDdUhHRlNSSkkzQVhnN0ovU2pO?=
 =?utf-8?B?UVRQQnZIOTh2eVhVT2ZneEV3MjNpTmd5RWZuZWFxUmthMHRRL1ZibnJFL3FM?=
 =?utf-8?B?TnlDdnIxQS8vNFVoRkdqeWkvczRuZW51eU9KUG9hYVBJbUlVVWVXbUp1bDlU?=
 =?utf-8?B?Z0lxellhYWM4N3RoRjdxekJjVUdZdFJQeWU4WEYweDNiNVJObDhjV1YzaVdy?=
 =?utf-8?B?ckVPaGszR25EZnJYMjJJdEE5eE16WTVPSUNqMDJKMUEySHU5Rk16VUp0TzFR?=
 =?utf-8?B?UWcraGFEayt3c1JyNGNsY1NDeEdBYWhWdnNJbnBnU0RESzA4OEdCU1kwZHQ3?=
 =?utf-8?B?cnJvWW50c1lJdDJrSUc5Z3dZOGZUeUJPQ1poQ2l0RWFzbjhHdjBraStTcW1n?=
 =?utf-8?B?dWJ0eEN2R1Q2T3I2di92VXpyajR2dFpmNnNvakdFVnVRTHNCdXJ3MGNzYjNC?=
 =?utf-8?B?VE9VbUpEWDNiZGdRZzBjMm9JL1d5M3JLNzgyNUcrOW9zVXBaSndFdlB5d2o0?=
 =?utf-8?B?NTRpalcxSERQMEM2clFCbUczTUpoeDNDUXcwUW9KMUY5RWNORVJ0c3NWU1lX?=
 =?utf-8?B?UlNHelREcWQwT05jM0NKQXR2K0xlTUg1WFNvL0g0LzJCZzUzeTF6TXFzTUkr?=
 =?utf-8?B?Zkdnb2c4STJqUmVTN2ZuZU5MVW94WEFPdHNCeFJISDczL1ljNXlMVFdudGJp?=
 =?utf-8?B?UlVZcHlwTFlNUlVLRkN6b1YrU0N6NHV5L0RpU001MU8rTDBMMDQxaFhkeU1Q?=
 =?utf-8?B?bUhXc3B4RHcxcityY2xTaGwzQzE1MzRrblNMbXo0QU03QlJodEZYdnEzMGlP?=
 =?utf-8?B?MFJBbXdnUzBJN0xYTnhCWmZNQTVjNnA0bjc0Y2tiaUxYck9KNmRFaW9yTW1j?=
 =?utf-8?B?REVwdDk2VU9NamFnZ0JwS3ZpS2QzdnZ1MEloc0huZEF4OGlBZ3l3OG9tWHl5?=
 =?utf-8?B?UzlCamtTN01HejNaVlNhaFducjNERS8ydXZPZ3NjZ0FvVG9ZU0thSU13RzNs?=
 =?utf-8?Q?bT+ABYiPCq2gwczF0V5pDiTIXBCgPiIM/m4xmry?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51446de2-ff68-48b9-8d1d-08d929e1d62d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 18:26:58.6240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aI5oCOLD5KE40dXpyW628bz8y7ipAKnLX5ySliyFEvZegoJ3tJU8/cnNMakl7Bp86Oi3SCJD2uf7AnS738KqcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5467
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBNb25k
YXksIEp1bmUgNywgMjAyMSA5OjQ0IFBNDQo+IA0KPiBPbiA2LzcvMjEgOToxMiBBTSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+DQo+ID4NCj4gPj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5A
Z21haWwuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEp1bmUgNywgMjAyMSA4OjExIFBNDQo+ID4+
DQo+ID4+IE9uIDYvNy8yMSA1OjQzIEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+PiBIaSBE
YXZpZCwNCj4gPj4+DQo+ID4+Pj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29t
Pg0KPiA+Pj4+IFNlbnQ6IE1vbmRheSwgSnVuZSA3LCAyMDIxIDg6MzEgQU0NCj4gPj4+Pg0KPiA+
Pj4+IE9uIDYvMy8yMSA1OjE5IEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+Pj4+IEBAIC0z
Nzk1LDcgKzM4MDYsNyBAQCBzdGF0aWMgdm9pZCBjbWRfcG9ydF9oZWxwKHZvaWQpDQo+ID4+Pj4+
ICAJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IHBhcmFtIHNldCBERVYvUE9SVF9JTkRFWCBu
YW1lDQo+ID4+Pj4gUEFSQU1FVEVSIHZhbHVlIFZBTFVFIGNtb2RlIHsgcGVybWFuZW50IHwgZHJp
dmVyaW5pdCB8IHJ1bnRpbWUNCj4gPj4+PiB9XG4iKTsNCj4gPj4+Pj4gIAlwcl9lcnIoIiAgICAg
ICBkZXZsaW5rIHBvcnQgcGFyYW0gc2hvdyBbREVWL1BPUlRfSU5ERVggbmFtZQ0KPiA+Pj4+IFBB
UkFNRVRFUl1cbiIpOw0KPiA+Pj4+PiAgCXByX2VycigiICAgICAgIGRldmxpbmsgcG9ydCBoZWFs
dGggc2hvdyBbIERFVi9QT1JUX0lOREVYIHJlcG9ydGVyDQo+ID4+Pj4gUkVQT1JURVJfTkFNRSBd
XG4iKTsNCj4gPj4+Pj4gLQlwcl9lcnIoIiAgICAgICBkZXZsaW5rIHBvcnQgYWRkIERFVi9QT1JU
X0lOREVYIGZsYXZvdXIgRkxBVk9VUg0KPiA+Pj4+IHBmbnVtIFBGTlVNIFsgc2ZudW0gU0ZOVU0g
XVxuIik7DQo+ID4+Pj4+ICsJcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGFkZCBERVYvUE9S
VF9JTkRFWCBmbGF2b3VyDQo+IEZMQVZPVVINCj4gPj4+PiBwZm51bSBQRk5VTSBbIHNmbnVtIFNG
TlVNIF0gWyBjb250cm9sbGVyIENOVU0gXVxuIik7DQo+ID4+Pj4+ICAJcHJfZXJyKCIgICAgICAg
ZGV2bGluayBwb3J0IGRlbCBERVYvUE9SVF9JTkRFWFxuIik7DQo+ID4+Pj4+ICB9DQo+ID4+Pj4+
DQo+ID4+Pj4+IEBAIC00MzI0LDcgKzQzMzUsNyBAQCBzdGF0aWMgaW50IF9fY21kX2hlYWx0aF9z
aG93KHN0cnVjdCBkbCAqZGwsDQo+ID4+Pj4+IGJvb2wgc2hvd19kZXZpY2UsIGJvb2wgc2hvd19w
b3J0KTsNCj4gPj4+Pj4NCj4gPj4+Pj4gIHN0YXRpYyB2b2lkIGNtZF9wb3J0X2FkZF9oZWxwKHZv
aWQpICB7DQo+ID4+Pj4+IC0JcHJfZXJyKCIgICAgICAgZGV2bGluayBwb3J0IGFkZCB7IERFViB8
IERFVi9QT1JUX0lOREVYIH0gZmxhdm91cg0KPiA+Pj4+IEZMQVZPVVIgcGZudW0gUEZOVU0gWyBz
Zm51bSBTRk5VTSBdXG4iKTsNCj4gPj4+Pj4gKwlwcl9lcnIoIiAgICAgICBkZXZsaW5rIHBvcnQg
YWRkIHsgREVWIHwgREVWL1BPUlRfSU5ERVggfQ0KPiBmbGF2b3VyDQo+ID4+Pj4gRkxBVk9VUiBw
Zm51bSBQRk5VTSBbIHNmbnVtIFNGTlVNIF0gWyBjb250cm9sbGVyIENOVU0gXVxuIik7DQo+ID4+
Pj4NCj4gPj4+PiBUaGlzIGxpbmUgYW5kIHRoZSBvbmUgYWJvdmUgbmVlZCB0byBiZSB3cmFwcGVk
LiBUaGlzIGFkZGl0aW9uIHB1dHMNCj4gPj4+PiBpdCB3ZWxsIGludG8gdGhlIDkwcy4NCj4gPj4+
Pg0KPiA+Pj4gSXTigJlzIGEgcHJpbnQgbWVzc2FnZS4NCj4gPj4+IEkgd2FzIGZvbGxvd2luZyBj
b2Rpbmcgc3R5bGUgb2YgWzFdIHRoYXQgc2F5cyAiSG93ZXZlciwgbmV2ZXIgYnJlYWsNCj4gPj4+
IHVzZXItDQo+ID4+IHZpc2libGUgc3RyaW5ncyBzdWNoIGFzIHByaW50ayBtZXNzYWdlcyBiZWNh
dXNlIHRoYXQgYnJlYWtzIHRoZQ0KPiA+PiBhYmlsaXR5IHRvIGdyZXAgZm9yIHRoZW0uIi4NCj4g
Pj4+IFJlY2VudCBjb2RlIG9mIGRjYl9ldHMuYyBoYXMgc2ltaWxhciBsb25nIHN0cmluZyBpbiBw
cmludC4gU28gSSBkaWRuJ3Qgd3JhcA0KPiBpdC4NCj4gPj4NCj4gPj4gSSBtaXNzZWQgdGhhdCB3
aGVuIHJldmlld2luZyB0aGUgZGNiIGNvbW1hbmQgdGhlbi4NCj4gPj4NCj4gPj4+IFNob3VsZCB3
ZSB3YXJwIGl0Pw0KPiA+Pj4NCj4gPj4+IFsxXQ0KPiA+Pj4gaHR0cHM6Ly93d3cua2VybmVsLm9y
Zy9kb2MvaHRtbC9sYXRlc3QvcHJvY2Vzcy9jb2Rpbmctc3R5bGUuaHRtbCNicmUNCj4gPj4+IGFr
DQo+ID4+PiBpbmctbG9uZy1saW5lcy1hbmQtc3RyaW5ncw0KPiA+Pj4NCj4gPj4NCj4gPj4gWzFd
IGlzIHJlZmVycmluZyB0byBtZXNzYWdlcyBmcm9tIGtlcm5lbCBjb2RlLCBhbmQgSSBhZ3JlZSB3
aXRoIHRoYXQNCj4gPj4gc3R5bGUuIFRoaXMgaXMgaGVscCBtZXNzYWdlIGZyb20gaXByb3V0ZTIu
IEkgdGVuZCB0byBrZWVwIG15IHRlcm1pbmFsDQo+ID4+IHdpZHRocyBiZXR3ZWVuDQo+ID4+IDgw
IGFuZCA5MCBjb2x1bW5zLCBzbyB0aGUgbG9uZyBoZWxwIGxpbmVzIGZyb20gY29tbWFuZHMgYXJl
IG5vdCB2ZXJ5DQo+ID4+IGZyaWVuZGx5IGNhdXNpbmcgbWUgdG8gcmVzaXplIHRoZSB0ZXJtaW5h
bC4NCj4gPiBJIHNlZS4gU28gZG8geW91IHJlY29tbWVuZCBzcGxpdHRpbmcgdGhlIHByaW50IG1l
c3NhZ2U/DQo+ID4gSSBwZXJzb25hbGx5IGZlZWwgZWFzaWVyIHRvIGZvbGxvdyBrZXJuZWwgY29k
aW5nIHN0YW5kYXJkIGFzIG11Y2gNCj4gPiBwb3NzaWJsZSBpbiBzcGlyaXQgb2YgImdyZXAgdGhl
bSIuIPCfmIoNCj4gPiBCdXQgaXRzIHJlYWxseSB1cCB0byB5b3UuIFBsZWFzZSBsZXQgbWUga25v
dy4NCj4gPg0KPiANCj4gDQo+IFRoZXJlIGFyZSBkaWZmZXJlbnQgdHlwZSBvZiBzdHJpbmdzOg0K
PiAxLiBoZWxwLA0KPiAyLiBlcnJvciBtZXNzYWdlcywNCj4gMy4gaW5mb3JtYXRpb25hbCBtZXNz
YWdlcywNCj4gNC4gZGlzcGxheWluZyBhIGNvbmZpZ3VyYXRpb24NCj4gDQo+IDEuIGlzICJob3cg
ZG8gSSB1c2UgdGhpcyBjb21tYW5kIi4gVGhlcmUgaXMgbm8gcmVhc29uIHRvIG1ha2UgdGhhdCAx
IGdpZ2FudGljDQo+IGxpbmUuIEFsbCBvZiB0aGUgaXByb3V0ZTIgY29tbWFuZHMgd3JhcCB0aGUg
aGVscC4gTXkgY29tbWVudCBhYm92ZSBpcyBvbg0KPiB0aGlzIGNhdGVnb3J5Lg0KPiANCj4gMi4g
YW5kIDMuIHNob3VsZCBub3QgYmUgd3JhcHBlZCB0byBhbGxvdyBzb21lb25lIHRvIGF0dGVtcHQg
dG8gZ28gZnJvbQ0KPiAid2h5IGRpZCBJIGdldCB0aGlzIG91dHB1dCIgdG8gYSBsaW5lIG9mIGNv
ZGUgKG9yIG1hbnkgbGluZXMpLiBUaGlzIGlzIHRoZSBrZXJuZWwNCj4gcmVmZXJlbmNlIGFib3Zl
Lg0KPiANCj4gNC4gRGlzcGxheWluZyBhdHRyaWJ1dGVzIGFuZCBzZXR0aW5ncyBmb3Igc29tZSBv
YmplY3QgZ2V0dGluZyBkdW1wZWQuDQo+IFRoZSBsaW5lcyBjYW4gZ2V0IHJlYWxseSBsb25nIGFu
ZCB1bnJlYWRhYmxlIHRvIGh1bWFuczsgdGhlc2Ugc2hvdWxkIGJlIHNwbGl0DQo+IGFjcm9zcyBt
dWx0aXBsZSBsaW5lcyAtIGxpa2UgaXByb3V0ZTIgY29tbWFuZHMgZG8uIFRoZXJlIGlzIG5vIHJl
YXNvbiBmb3IgdGhpcw0KPiB0byBiZSBvbiBvbmxpbmUgdW5sZXNzIHRoZSB1c2VyIGFza3MgZm9y
IGl0IHZpYSAtb25lbGluZSBvcHRpb24uDQoNClRoYW5rcyBEYXZpZCBmb3IgdGhlIGRldGFpbGVk
IGV4cGxhbmF0aW9uLg0KSXQgdG90YWxseSBtYWtlIHNlbnNlLiBJIGFtIGZpeGluZyBpdC4NCg==
