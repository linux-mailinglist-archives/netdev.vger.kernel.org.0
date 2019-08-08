Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8768857DC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbfHHB46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 21:56:58 -0400
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:58131 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730038AbfHHB46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:56:58 -0400
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.146) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Thu,  8 Aug 2019 01:56:41 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 8 Aug 2019 01:55:33 +0000
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 8 Aug 2019 01:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b86St9Fx1q2tAVk8AHeKyIVgIoCI6jJrKfxhQfBPVUp1OeAksnAXCDp13wZPQt70hYUnr9Ynem0l9jOGjlqVhOusAfzmPsNCEVzVFq5Xipsvq1IUjTAckSY+VCBsLEwC+iJ8gSWyYB9kQMEPFrO8pDbF8/CFFoFVehH63B8ZvrAn33HoK8UUMNoT0R1FdtdLQukkk5n+zccdWjBXBzhnPdcujVf4c6B/+3d8btfaunKrQ6kVYZ36Wri9SCkxek5AnqDUNwSBu8wBKXzByUo9Kj3KVU6zTsu82sJ7k09TFA1jedxciUoEZci9vPPHjOdbBHVo6rmtgvlykwo9+uJPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoUPwFQSrGx0HyJLUcyEJA99ffvh+O/nfriQlQ/VMsg=;
 b=a7Yo2AZjieMX2EmdBDS6Hw1bXEAureJH2TvRcPRHF2JdKQedYfA0euIGytByWvtw8ZZopw96rbQtB44SUQvdLQVfNn3FYOxBoHY7qRfsFYXGa4i7n9yKktBYerhlPzMnNmVg5qSL9lbfF58yQaC5HU3qnBdD+2rOydoaBGS4Ycx9hfpkwrk7Wf61jabz0Mt5QFNj3upU06pgREEueMAXihxjo8zSBYtTgkns1F2oXmJ5OiZ7jnS4ZMX71AE4x6u81WLD6FpV71krsXTuOEg4FOF3YXaAyKPCGpXawQ1fhYy7pc1NVXIm25cVLwmtMgDAjgmn6BuMnI8bmOtYMbfJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=suse.com;dmarc=pass action=none header.from=suse.com;dkim=pass
 header.d=suse.com;arc=none
Received: from BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) by
 BY5PR18MB3347.namprd18.prod.outlook.com (10.255.138.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Thu, 8 Aug 2019 01:55:31 +0000
Received: from BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac]) by BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 01:55:31 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jacob Wen <jian.w.wen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH v2 1/1] ixgbe: sync the first fragment
 unconditionally
Thread-Topic: [Intel-wired-lan] [PATCH v2 1/1] ixgbe: sync the first fragment
 unconditionally
Thread-Index: AQHVTMrFkDapNm+vukGfNKy6YOsjCqbvUa91gACR04D///c5WIAApFwA
Date:   Thu, 8 Aug 2019 01:55:31 +0000
Message-ID: <20190808015521.GA18282@linux-6qg8>
References: <20190807024917.27682-1-firo.yang@suse.com>
 <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
 <20190807083831.GA6811@linux-6qg8> <20190807160853.00001d71@gmail.com>
 <CAKgT0UfEh8cvTht3yceyXqwReJOQkcpJV8j0vHSJwookTWhn_Q@mail.gmail.com>
In-Reply-To: <CAKgT0UfEh8cvTht3yceyXqwReJOQkcpJV8j0vHSJwookTWhn_Q@mail.gmail.com>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To BY5PR18MB3187.namprd18.prod.outlook.com
 (2603:10b6:a03:196::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a19b384-710a-49c2-a2a0-08d71ba37e88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR18MB3347;
x-ms-traffictypediagnostic: BY5PR18MB3347:
x-microsoft-antispam-prvs: <BY5PR18MB33472ED454F796EDAA2F392A88D70@BY5PR18MB3347.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(7916004)(39860400002)(346002)(396003)(376002)(366004)(136003)(199004)(51444003)(189003)(316002)(81166006)(6116002)(3846002)(5660300002)(186003)(54906003)(76176011)(478600001)(52116002)(86362001)(14454004)(256004)(446003)(386003)(11346002)(26005)(476003)(14444005)(33716001)(44832011)(102836004)(66066001)(53936002)(6506007)(53546011)(486006)(6512007)(9686003)(6436002)(6916009)(66446008)(66556008)(66476007)(64756008)(8936002)(66946007)(1411001)(6486002)(8676002)(229853002)(4326008)(2906002)(81156014)(6246003)(33656002)(71190400001)(71200400001)(25786009)(305945005)(99286004)(7736002)(1076003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3347;H:BY5PR18MB3187.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vN5lTuVAtHcVIQXk9sVG4pZ/z56AU18P/DaCckp5mHWJInq6fonsLkbHHvatCpRhqOlQUrpKKXUn5+8GhyYPxuoW+af1zD6V5vheTwvDT/WPaB4aI63eujK2csZj0alOqXVlbyAKWBqQHRRGLrm9btMiOu4tYr//l1bS0vDEByfYyTfLgp8tNBGKDczeMA6kBBx00obaHY2e0WUKkEO2/vt7gBZt6JiPw3OhgRMEg9LbhnHc4YIdLOI61ynSpgj905ibPKsaawfYBGjI0FD0mHOZt1cOCR8UxrUS714boXEXLUtatutEgrrHHiRT96r/mzVGRtudnBDvghrKTOO6/1pnQBJsT50cgF1fBW//9xhvqtZtaabJ6DoyOBzmIUJyTYuOQMjT9d2K0Ml+OGowtDTJhYBf/sxfzAOlCgLlZuo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97E5D852608B934B8A97E83AD666C5BB@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a19b384-710a-49c2-a2a0-08d71ba37e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 01:55:31.4436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OnN2KTi8aOWibYKdoF6Uc2gEWm1TtrgK5oqpHlat6n3ZS656KfS76/4HidfhIuTqfpWdD2MtwFxAfied6dYxPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3347
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA4LzA3LzIwMTkgMDk6MDYsIEFsZXhhbmRlciBEdXljayB3cm90ZToNCj4gT24gV2VkLCBB
dWcgNywgMjAxOSBhdCA3OjA5IEFNIE1hY2llaiBGaWphbGtvd3NraQ0KPiA8bWFjaWVqcm9tYW5m
aWphbGtvd3NraUBnbWFpbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gT24gV2VkLCA3IEF1ZyAyMDE5
IDA4OjM4OjQzICswMDAwDQo+ID4gRmlybyBZYW5nIDxmaXJvLnlhbmdAc3VzZS5jb20+IHdyb3Rl
Og0KPiA+DQo+ID4gPiBUaGUgMDgvMDcvMjAxOSAxNTo1NiwgSmFjb2IgV2VuIHdyb3RlOg0KPiA+
ID4gPiBJIHRoaW5rIHRoZSBkZXNjcmlwdGlvbiBpcyBub3QgY29ycmVjdC4gQ29uc2lkZXIgdXNp
bmcgc29tZXRoaW5nIGxpa2UgYmVsb3cuDQo+ID4gPiBUaGFuayB5b3UgZm9yIGNvbW1lbnRzLg0K
PiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gSW4gWGVuIGVudmlyb25tZW50LCBkdWUgdG8gbWVtb3J5
IGZyYWdtZW50YXRpb24gaXhnYmUgbWF5IGFsbG9jYXRlIGEgJ0RNQScNCj4gPiA+ID4gYnVmZmVy
IHdpdGggcGFnZXMgdGhhdCBhcmUgbm90IHBoeXNpY2FsbHkgY29udGlndW91cy4NCj4gPiA+IEFj
dHVhbGx5LCBJIGRpZG4ndCBsb29rIGludG8gdGhlIHJlYXNvbiB3aHkgaXhnYmUgZ290IGEgRE1B
IGJ1ZmZlciB3aGljaA0KPiA+ID4gd2FzIG1hcHBlZCB0byBYZW4tc3dpb3RsYiBhcmVhLg0KPiA+
DQo+ID4gSSB0aGluayB0aGF0IG5laXRoZXIgb2YgdGhlc2UgZGVzY3JpcHRpb25zIGFyZSB0ZWxs
aW5nIHVzIHdoYXQgd2FzIHRydWx5DQo+ID4gYnJva2VuLiBUaGV5IGxhY2sgd2hhdCBBbGV4YW5k
ZXIgd3JvdGUgb24gdjEgdGhyZWFkIG9mIHRoaXMgcGF0Y2guDQo+ID4NCj4gPiBpeGdiZV9kbWFf
c3luY19mcmFnIGlzIGNhbGxlZCBvbmx5IG9uIGNhc2Ugd2hlbiB0aGUgY3VycmVudCBkZXNjcmlw
dG9yIGhhcyBFT1ANCj4gPiBiaXQgc2V0LCBza2Igd2FzIGFscmVhZHkgYWxsb2NhdGVkIGFuZCB5
b3UnbGwgYmUgYWRkaW5nIGEgY3VycmVudCBidWZmZXIgYXMgYQ0KPiA+IGZyYWcuIERNQSB1bm1h
cHBpbmcgZm9yIHRoZSBmaXJzdCBmcmFnIHdhcyBpbnRlbnRpb25hbGx5IHNraXBwZWQgYW5kIHdl
IHdpbGwgYmUNCj4gPiB1bm1hcHBpbmcgaXQgaGVyZSwgaW4gaXhnYmVfZG1hX3N5bmNfZnJhZy4g
QXMgQWxleCBzYWlkLCB3ZSdyZSB1c2luZyB0aGUNCj4gPiBETUFfQVRUUl9TS0lQX0NQVV9TWU5D
IGF0dHJpYnV0ZSB3aGljaCBvYmxpZ2VzIHVzIHRvIHBlcmZvcm0gYSBzeW5jIG1hbnVhbGx5DQo+
ID4gYW5kIGl0IHdhcyBtaXNzaW5nLg0KPiA+DQo+ID4gU28gSU1ITyB0aGUgY29tbWl0IGRlc2Ny
aXB0aW9uIHNob3VsZCBpbmNsdWRlIGRlc2NyaXB0aW9ucyBmcm9tIGJvdGggeGVuIGFuZA0KPiA+
IGl4Z2JlIHdvcmxkcywgdGhlIHYyIGxhY2tzIGluZm8gYWJvdXQgaXhnYmUgY2FzZS4NClRoYW5r
IHlvdS4gV2lsbCBzdWJtaXQgdjMgd2l0aCB3aGF0IEFsZXhhbmRlciB3b3J0ZSBvbiB2MS4NCg0K
VGhhbmtzLA0KRmlybw0KPiA+DQo+ID4gQlRXIEFsZXgsIHdoYXQgd2FzIHRoZSBpbml0aWFsIHJl
YXNvbiBmb3IgaG9sZGluZyBvZmYgd2l0aCB1bm1hcHBpbmcgdGhlIGZpcnN0DQo+ID4gYnVmZmVy
PyBBc2tpbmcgYmVjYXVzZSBJSVJDIHRoZSBpNDBlIGFuZCBpY2UgYmVoYXZlIGEgYml0IGRpZmZl
cmVudCBoZXJlLiBXZQ0KPiA+IGRvbid0IGxvb2sgdGhlcmUgZm9yIEVPUCBhdCBhbGwgd2hlbiBi
dWlsZGluZy9jb25zdHJ1Y3Rpbmcgc2tiIGFuZCBub3QgZGVsYXlpbmcNCj4gPiB0aGUgdW5tYXAg
b2Ygbm9uLWVvcCBidWZmZXJzLg0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IE1hY2llag0KPiANCj4g
VGhlIHJlYXNvbiB3aHkgd2UgaGF2ZSB0byBob2xkIG9mZiBvbiB1bm1hcHBpbmcgdGhlIGZpcnN0
IGJ1ZmZlciBpcw0KPiBiZWNhdXNlIGluIHRoZSBjYXNlIG9mIFJlY2VpdmUgU2lkZSBDb2FsZXNj
aW5nIChSU0MpLCBhbHNvIGtub3duIGFzIExhcmdlDQo+IFJlY2VpdmUgT2ZmbG9hZCAoTFJPKSwg
dGhlIGhlYWRlciBvZiB0aGUgcGFja2V0IGlzIHVwZGF0ZWQgZm9yIGVhY2gNCj4gYWRkaXRpb25h
bCBmcmFtZSB0aGF0IGlzIGFkZGVkLiBBcyBzdWNoIHlvdSBjYW4gZW5kIHVwIHdpdGggdGhlIGRl
dmljZQ0KPiB3cml0aW5nIGRhdGEsIGhlYWRlciwgZGF0YSwgaGVhZGVyLCBkYXRhLCBoZWFkZXIg
d2hlcmUgZWFjaCBkYXRhIHdyaXRlDQo+IHdvdWxkIHVwZGF0ZSBhIG5ldyBkZXNjcmlwdG9yLCBi
dXQgdGhlIGhlYWRlciB3aWxsIG9ubHkgZXZlciB1cGRhdGUgdGhlDQo+IGZpcnN0IGRlc2NyaXB0
b3IgaW4gdGhlIGNoYWluLiBBcyBzdWNoIGlmIHdlIHVubWFwcGVkIGl0IGVhcmxpZXIgaXQgd291
bGQNCj4gcmVzdWx0IGluIGFuIElPTU1VIGZhdWx0IGJlY2F1c2UgdGhlIGRldmljZSB3b3VsZCBi
ZSByZXdyaXRpbmcgdGhlIGhlYWRlcg0KPiBhZnRlciBpdCBoYWQgYmVlbiB1bm1hcHBlZC4NCj4g
DQo+IFRoZSBkZXZpY2VzIHN1cHBvcnRlZCBieSB0aGUgaXhnYmUgZHJpdmVyIGFyZSB0aGUgb25s
eSBvbmVzIHRoYXQgaGF2ZQ0KPiBSU0MvTFJPIHN1cHBvcnQuIEFzIHN1Y2ggdGhpcyBiZWhhdmlv
ciBpcyBwcmVzZW50IGZvciBpeGdiZSwgYnV0IG5vdCBmb3INCj4gb3RoZXIgSW50ZWwgTklDIGRy
aXZlcnMgaW5jbHVkaW5nIGlnYiwgaWdidmYsIGl4Z2JldmYsIGk0MGUsIGV0Yy4NCj4gDQo+IC0g
QWxleA0KPiANCg==
