Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA902CE836
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 07:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgLDGlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 01:41:04 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:3746 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgLDGlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 01:41:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607064062; x=1638600062;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U9Bv6CSu61L55m4Y4nrJCWAQyrvlVO3cKWmWYfyR0bc=;
  b=iOUiQv4IL5oo7KPfx9y7omw+5rdhm/XL4axzXO9b4hJ2xUmpN7aLh18g
   OyZM8ZCPXgCNnl3kMHB2Ql3ZawX16NJbFt8Zs/kvnOEZoj2sjzDHgaZdw
   JEayu7jjqjje+FOMlNGtlq21Vz+q0y7ApEzYnsiWf2sq3SbVBQ4dt4Sff
   HgTS/SP2/RVfrXfnh7f+yekT+QQ/ZgVE1WG0IUurMuK4nMcqEWToKRj/4
   nGtv5PXn5CrS1gIwQfNBAKWllUY0HE8Ih33CPRsmOFW4tP6r62IpBDgg6
   0VzmVa1OF4i5xCJnKB9Pbvne9IjecHrjdwGL6HjHkJlKbW5xnv4BZZaDQ
   w==;
IronPort-SDR: wJr0uzb37dALAdFPgoSysiJh92lobIZf6qG/oMJmjADwJOlOpPfJQ6mk2PIRC9ywX8+xBv8w+S
 eifznkicuKjbqjSAhjCaN6AhUVkgDr6psupDA5LedKC4q/JKPSi02mCw+ikkJHjGKeQBy5ZxoJ
 /DIqT/i2pkGU7s+3MV9OmNFPmGPUjXWOOBm74wJGwq+pnlQuwC4a/F8x6PUkpEUSgiHV6PzVQ3
 nkUm4b4zZsY1UUC938IqzN09o3tj0fsJJ5NY8JV1hd5vkQtCfehxsPfTJf5Dhxlh5cWtFrKmIu
 PzE=
X-IronPort-AV: E=Sophos;i="5.78,391,1599548400"; 
   d="scan'208";a="98602428"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 23:39:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 23:39:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 3 Dec 2020 23:39:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTOBmhc1WvUYYFsEhf5PxetfDl1JPlLnuQhy6GK+IBM9TnvISDLJzGWISAYcNA7Oz3h91mmkChCQmrjBmmNq2ibz4H6Py3k+KnLrx5qZOWp0oi64ibV8lXkqfTTccDy9twF+K4nfmld3CDU3aF/QASTWoggjX5f7HDa+fCadOB6wxhMD/mElSnzKcxXR8QxdG6ewrW1x/3xH6eXHltGbtVMvL7ZvcNcwcHcCbuEq+O7EpWY69ZMmHRG4qEKUH+R5IBZUMxVrP5uiClvIjNyioFMjMG8Guk/PVFSzs122r6aG+PUmpHqcKcEwlhmzZ0IPPReR2CHaAS8fguOA6hncwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9Bv6CSu61L55m4Y4nrJCWAQyrvlVO3cKWmWYfyR0bc=;
 b=IwAaaX7UOcQIHzbLynSBs0WkZKERYzhfs/LAgvQ3xL0/ybxwlgoM4v3tUNqDyB+mEn1PALMn7Fs20A5gVHMypVh2rD15vIXTOUIGw8QrgqSMgv8xY50I21jjDH0o4C8OHaD7CSBRK4LQR4BWbIw/HGU8s4k2LCf4SEei8CdKbomDufRyNfXXTI5P8YHY5o5wv/jaMgpbRVPv3sS+nASvfaqshY8KiOz5dVQzKB+skkSN9gEfJF9uWZsdt/F6eSIcGbjMsJ7y5Alq7BoU/Gpl2hxAzWPjoCcfrsuJexgpH8wXqW07WIIxkrgyleHKzONPbrttggX8whZAlAnOgTtoWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9Bv6CSu61L55m4Y4nrJCWAQyrvlVO3cKWmWYfyR0bc=;
 b=tLPKAHevgSiZBnGUa9ZY0acfjQMpFz9eEiWe5zu47DMfPF4nTWemelnDJSADqyaf+7/a2xDzcvzfMpandTcr/2cuyJx1rxq7HwdySoqbWkow1ptaECGQhbaXL84wcyCl3Gv9mqid+lK7loKz8Rnto0rM5u9G+1gr4rS9xwkHcNE=
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 06:39:54 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::6813:6c9a:3f6:e947]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::6813:6c9a:3f6:e947%6]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 06:39:53 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <colin.king@canonical.com>, <Claudiu.Beznea@microchip.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] wilc1000: remove redundant assignment to pointer
 vif
Thread-Topic: [PATCH][next] wilc1000: remove redundant assignment to pointer
 vif
Thread-Index: AQHWyZvOLF3wgioisEqJpJYkMKkrzKnmfUsA
Date:   Fri, 4 Dec 2020 06:39:53 +0000
Message-ID: <1cef50d3-dfd4-9b0d-67f3-4cd1eee2192e@microchip.com>
References: <20201203174316.1071446-1-colin.king@canonical.com>
In-Reply-To: <20201203174316.1071446-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [171.61.34.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a224a3f9-9122-4e17-d9eb-08d8981f689d
x-ms-traffictypediagnostic: MWHPR11MB1293:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB129322E67749BF25C3116CD6E3F10@MWHPR11MB1293.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: etAWTTglRQWDrMtPdtvdVfa9rbXjbiIYBuYVrDLeYXERoi/63mWlz3lS26J28zlZZIJ2vODqzpmVSPzhzDXkw7JZZ2s/BOJnd/DEd+bND6Kcv+ZuGWB83sXIZR7t/gUwn2bD03O5UHxR7WnPswc8GEpicahJEqgedITbTgO84PKfvVHVF/VZIrmEjVx0VsC7xMStPQxiYfaifjBmK/SIZuxlSzV8WSxX1SQAeBdRZDO+Bf9A1lWIyZ+q/GnrmGLM944Kt5JlXev9oSvhB3UU6GrUXWWnyNHqwzMdKilh+1FHN78YyHWIHMVM5BbHSMaHR1lhqbCHQ6I/XRntwq8YaemT+CBolDkBaq247G1It07V9wheya0SzgbnZxzuO4wZVXwpaHwyGtsBjvHgLEfQj5LTfsc0YQy7fUuKg18VteM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(4744005)(54906003)(2906002)(86362001)(36756003)(31696002)(110136005)(83380400001)(2616005)(316002)(66556008)(64756008)(91956017)(66476007)(6512007)(76116006)(71200400001)(66946007)(66446008)(478600001)(8936002)(186003)(26005)(4326008)(6506007)(6486002)(53546011)(8676002)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aEp5NVZmS2J6ellSYmVmVk9wRGs3LzVtcW5JbDVhSDR2T2RVMU5hR3JvVGVx?=
 =?utf-8?B?Ty9EbWw3UzVteWF4bFhubDVBeHhtM3NKUGx1UU10M1EzcTlQQjkwNzVGdWVY?=
 =?utf-8?B?NVZtY205VEdseG11Yk1QSDFlVXcvMGIvMHlqTlp6OEk4djAzM244ZFpOQ1dP?=
 =?utf-8?B?R3RQazRYYnRkaU9oSEFuOHQ0TE1Ka291L0hGMkRZMW5NVlJBTzNmdWZjTnJh?=
 =?utf-8?B?amFnWUJqY0J0Ym9pM2t0alVlQ1BsRVRPYkdwV05hdlQvUEl4bkZ1anNLM09U?=
 =?utf-8?B?MFBibkdGMmE2Q1lRNEs0K1hNRUhqYUltQzArRkNVdVlqVHRUdWRja2g3SlZU?=
 =?utf-8?B?cWVhSno2VlZQZWR5UGQ2RmltbXM0YmZVS085MVBmRVlQV29tQWZyN3ppMG9Y?=
 =?utf-8?B?dkdjRHAzU3IyME42NkQwb0pIRzVsNEFCb1JHZTB6UXQrQm03UWt0TXF2YmpO?=
 =?utf-8?B?OXdINGFBOGlCQ1FuYlMxRTlvYXpNdHlMVnJmVTdLQ0J1TEF2bWZCRE90VWdN?=
 =?utf-8?B?RDFiQVA5NjlxdzhDc2pQaERVcVJqTnpQUGE2MkdVWjFtUXFKV2VuUmlBaWlB?=
 =?utf-8?B?ajNoa2FQNE5OODc0SDM4L3VtaDZtbVRHRy8zU1l4MElLc0FRay8xWkRvUXUx?=
 =?utf-8?B?OElHdVM2RGxyL1ZuRHlyS3daVUltck9yVUYyUUlhSTgzQTBxd2ZDQ0dNbWFS?=
 =?utf-8?B?dDJIdHhEeENuQzAxM0FkMTU2RzJic3lzWVZBQU5xRFV3c29xZjVucjFTT1NG?=
 =?utf-8?B?T2kvQXhCaFpYbjhHS3NjTC9Za2laMFdiNjBwM01DUElxNlNkSDg1ZEphQTBt?=
 =?utf-8?B?U3VoNmxkQlc1WTVBR2kwbHlpNUVjbldUV3M2QWJtbWg1R0pGZXRqQkU3dTZU?=
 =?utf-8?B?eVZqbmxXd1VZWThacU9Idi9yUVp2SXJHa0t1S3duQmtjM01NN0tzbFZCQ2hi?=
 =?utf-8?B?enJEcFZteWFFMlpwRWp2c0RzRGdJTjNrcnp4SUhFbktwemFqYzVFWFRhVDA2?=
 =?utf-8?B?d25samkzWFV2eEhqMlJXTzR0VTIvNGZzTUkxWlBFY2lUSHZ1NFB2Q2ZONXUy?=
 =?utf-8?B?VjRCMXEvZkFiSEttSkpyRTJZSENBVmFTaHFNd1NvVVk0K0dvNjBRYy9hLzhO?=
 =?utf-8?B?REFtcE9CZWttNW15ei9wZ3kwT2J0SWcycVdaeDZ1S3EzSGxMb0xPdUR5V0pj?=
 =?utf-8?B?SzhiamMrUDZybG9UejEvYXBFdUo3NUF0V21oRko5aExBNTlxKytWaVhFVFJJ?=
 =?utf-8?B?VEUxdXFIOHROTGhWd2RqWnZwbEZMVDNmbHBFalIxbTZNRld5VXAzRW9pcllR?=
 =?utf-8?Q?5BdgQajb8GyQONkcKW/QcsUQxQJLfzpafB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91A9998E75A43141A00AD75DD6621D35@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a224a3f9-9122-4e17-d9eb-08d8981f689d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 06:39:53.7829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UhCS+aqeG1ScMwFXH6MwFu3X5+dCS4KajpYrL7acnL3zoli0MXWYW/e0jkL8SekMh4XfDovAmrmEN7p2sMLTHNz2FhN6wwL3jqhuKAea0Lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDAzLzEyLzIwIDExOjEzIHBtLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBFWFRFUk5BTCBF
TUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xp
bi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBUaGUgYXNzaWdubWVudCB0byBwb2ludGVyIHZp
ZiBpcyByZWR1bmRhbnQgYXMgdGhlIGFzc2lnbmVkIHZhbHVlDQo+IGlzIG5ldmVyIHJlYWQsIGhl
bmNlIGl0IGNhbiBiZSByZW1vdmVkLg0KPiANCj4gQWRkcmVzc2VzLUNvdmVyaXR5OiAoIlVudXNl
ZCB2YWx1ZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNh
bm9uaWNhbC5jb20+DQoNClRoYW5rcy4NCg0KQWNrZWQtYnk6IEFqYXkgU2luZ2ggPGFqYXkua2F0
aGF0QG1pY3JvY2hpcC5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9taWNy
b2NoaXAvd2lsYzEwMDAvd2xhbi5jIHwgMSAtDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93
aWxjMTAwMC93bGFuLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAv
d2xhbi5jDQo+IGluZGV4IDk5M2VhN2MwMzQyOS4uYzEyZjI3YmU5Zjc5IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvd2xhbi5jDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC93bGFuLmMNCj4gQEAgLTY4
NSw3ICs2ODUsNiBAQCBpbnQgd2lsY193bGFuX2hhbmRsZV90eHEoc3RydWN0IHdpbGMgKndpbGMs
IHUzMiAqdHhxX2NvdW50KQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoIXRxZV9xW2Fj
XSkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gDQo+IC0g
ICAgICAgICAgICAgICAgICAgICAgIHZpZiA9IHRxZV9xW2FjXS0+dmlmOw0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICBhY19leGlzdCA9IDE7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGZv
ciAoayA9IDA7IChrIDwgbnVtX3BrdHNfdG9fYWRkW2FjXSkgJiYNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAoIW1heF9zaXplX292ZXIpICYmIHRxZV9xW2FjXTsgaysrKSB7DQo+IC0t
DQo+IDIuMjkuMg0KPiA=
