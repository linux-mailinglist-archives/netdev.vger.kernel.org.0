Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04303F4296
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 02:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhHWA3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 20:29:44 -0400
Received: from mail-eopbgr30093.outbound.protection.outlook.com ([40.107.3.93]:7909
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231835AbhHWA3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 20:29:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTQSaexgg0xRZlTCG3xBmKvztVnXdi/ZvPsoqACro0JJJyH4t8g8U0HV7uaK617HPR2XQaeH7g1FUDmYmzUVsseXn8hhDCgYjudfIadpI+LF6apbTFcnnjhqTxks8TTVcsAw+ouHUZng1+hDPUHwJXQ0OwENGrAe+D+jeBk1AYgLLWGevJIb1Uh1V6HRQGmrNGPjcJpvaYOG8Bfo3ZrVmYfH660C9JguNDcrzoNPE8sC/8gxIP3MWJ5ICqR2htoqDGg2jJcDfRguvys9L0kBtZcQZp/E+EdF6rlFafX+/+ahTRUlsNsNSOKn9KXgVtCwYZFoWlkCdCwtSEUqLVCPfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjpolQ5A6Ub5Jv38eVocgE6OdkTV/6xT10anNtqugLA=;
 b=Q2RW0dB5kx36fTeDtdBX1GK8BY4QED1hYlHjvfDLSPonPgMikS0Pcg/55UWPjgFSJRCrRxEd+zH2NzBIhiOV2MVeSVKNkonUEeVnqIHmMxKBS35KihJbgZ+pbR9TsuvJ8E5exsFjI+IECimWoMjPy5AKuSr9vRJTShobQZDsxM/5VAAdGzHgiJzJnv3SbBsC90lwmBnNFBzIA6UH3A7VULd0AZAVE1bopKA3H1knV6UiC9jsRvGR4jdPYbKJYFlzocjf764YHeQMzUR86lt6Y4eJcr7q5qpSdFGcRBy1+xtKZms3rtDxZlCctRkMKEp4c02MbLaEhtnUwM0BLrRHWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjpolQ5A6Ub5Jv38eVocgE6OdkTV/6xT10anNtqugLA=;
 b=D9z/Yqm40s6IWV+7FryZeedgA6+oAiIuQiMkgm/mca2vOKf02vCyt6OjkYJJJrjVi6bMNrq0J/H36UXrM/xE3NAXec+JlQnvDN3u4JzcNu4tJWp9IoP/hKLGxnPkG7elmAqJiUJppSSpfUHEket9qSRbqHqJsPwntYUcG69Nwnw=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2681.eurprd03.prod.outlook.com (2603:10a6:3:ee::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Mon, 23 Aug 2021 00:28:52 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Mon, 23 Aug 2021
 00:28:51 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Topic: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Thread-Index: AQHXl4yAoQircf8Jw0+inLvWs8TmmauAFquAgAAQRACAAAP/AIAAA02AgAACLwCAAAwugA==
Date:   Mon, 23 Aug 2021 00:28:51 +0000
Message-ID: <e92dd0b2-0720-b848-900d-7f383f133111@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
 <20210822221307.mh4bggohdvx2yehy@skbuf>
 <9d6af614-d9f9-6e7b-b6b5-a5f5f0eb8af2@bang-olufsen.dk>
 <20210822232538.pkjsbipmddle5bdt@skbuf>
 <0606e849-5a4e-08c9-fcd1-d4661c10a51c@bang-olufsen.dk>
 <20210822234516.pwlu4wk3s3pfzbmi@skbuf>
In-Reply-To: <20210822234516.pwlu4wk3s3pfzbmi@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e383ce57-3845-4f9a-5683-08d965ccfba1
x-ms-traffictypediagnostic: HE1PR0302MB2681:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB268103A2E8EC38F5B7BC0C6783C49@HE1PR0302MB2681.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jtYN/q/nvJ0C4pvFGQ9ApgC8VmYW0cGF/a1Vg6XWFCu+sRob10H15hYyCXCPSkunGpSeYV+SJZUZuL1tb/qpYbjP6qdwwGbEHVkVWDQa4xwnj9z+u2km3Hsx4/geafKk3ngd3YHH3EMjmHddiW68qvWjBvo/r8Qw1kv2rUlKJ1TpBJM2PcK9PllGR7kC/K+uBCWEUegh3kI8JsNtCk0Jkiv5uWHJig8dy4l/vRb2yOERrBbmQKuQXiUJQyA9ArDDRSX3EasPwqINyVAD0B/tWg+hKUddfD0KI8QxCyOKorBUY2NFEgHkG2lGPIvaSo7s2mBiIVOYOnyrdV0X5R0I7tfDVuEnOynIfHBWK3gMy3UmfZZwovzZcd2TqnQ5KwDDx3pZMNI4cwRRjGhh62DEZsQiv7Acl4S+V6im6INZzM45BMfFk9dqlActzZHsjFqFR08snfitLmSxyLm2CFw/U0Qsini0A2rI0MijKfpwSsdlowwLHAsDtUacwYpyx8u3Q/wTDqLZ4NblZeJmeXSD9yDllUTNOEHZB0u70cmndwnAur32iziB1HqEgEtVkSjdJ01FndotCpCE2x7Lr4TsBdc3qwJ2LReQPdl0bHGdEzTQtXWRIk2iFHwJBGtxCD57/UZbGzw7xe6a+BRduL5riANDk+cxpQ3QOcS5zcyjj1a4ilI5U3bfd/rkSTFnp4ALeFs+P83tCNQ00bGRrFWRXF4PZ+VTlTdqtvGfkv1WBWuOkeQ2EEqOCUW0tWCQSQxRfOs62Dq1xEmds3BsoXsBCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(376002)(366004)(346002)(136003)(396003)(8936002)(2906002)(186003)(31696002)(5660300002)(83380400001)(8976002)(8676002)(26005)(6506007)(53546011)(85202003)(6916009)(85182001)(6486002)(6512007)(478600001)(4326008)(36756003)(76116006)(54906003)(66556008)(66476007)(66946007)(66446008)(64756008)(86362001)(7416002)(91956017)(2616005)(31686004)(122000001)(38070700005)(316002)(71200400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGtkTHJ0bUNMb0JuRGR1bTBVK0I3cWNLNnhQbzRQVGZpM1htWUNmeEJMeE5T?=
 =?utf-8?B?dmRpR1RHUGd0UDZQUElBa0hHS0hDMnVoTUZwQTVJdDk4RUZyNXNJRy9ncEd2?=
 =?utf-8?B?UUxpc0p4NDIzRjBzNkRZWlRDZTlSSnJDRkEvWlM4OC8xdG8xUEtEMDdnSTNx?=
 =?utf-8?B?RThEaDdsMWwwNGoyUUI3ZG1ibCtzaEo4OFc4enc3OWdWd3R5MFNzNXpzMkEv?=
 =?utf-8?B?QWYzQU9FWFVmWEhZbXRoczBSQXMrUXB0TytPQTFvbnNoUUcwbFBhOTNIeXZs?=
 =?utf-8?B?MjhuY1hiMzNUNGN4a3dxZnQ5R25HSzdGQmdKL254dksxK25BMkRoazhQWFpo?=
 =?utf-8?B?ZGE4Ujd2dXlIVVlXZ05DZyttQXA5MHZBSDdjSGZtOWNDV2JUMTgwZ0VKT0hx?=
 =?utf-8?B?VFNQZ1RPK3pSZ0F0SUY0OHQ5czZQUTZKYnArZW5FeitYTUNmNThzSmFUVlY3?=
 =?utf-8?B?WkUyOE5pdzNNYU5BUTI2dnAwa21EQ2ZiWjFLMkNLSE1XempaSWdtK3hoS3VX?=
 =?utf-8?B?VjRseG9sUWhDQVJJQ3VIdU5jRXBjZ1RnS3ZmajRDSEZnSGprOGhKNG1pYkE2?=
 =?utf-8?B?SVVob1hZQ1NMaVNQemlKY3NEMWhmL2Y0Z1YzTEl0UnpFRC9VVzRVQll4dmFH?=
 =?utf-8?B?NXlkTit4SHlCYTlUeDdMU1lZaG1SUmdsMHoxYS80TGdOSHVjTUcrSklWZEF6?=
 =?utf-8?B?TlJFWExJZHg2U0U2MjZ2eEpQTTlGOFdHWms2ZHdnVFRVN1NncVlDcDRNTDRq?=
 =?utf-8?B?UWJSSVhtYWZ0TndySnBicWVFNDErbmxmV1lsbWpuOGVWb2VmVllmYmZ2cU1S?=
 =?utf-8?B?dmQ4VDlVK3U0b1JsbVEzTXJlWkNVY0RZNTR4Y3U1bm5DUXBvRWRqUnBxVzhC?=
 =?utf-8?B?OEpnZzgzV3NzNlFwYVRkRXc0bzdGY2QzZzR1VGNqTktMQTVHMnNVUmpzU2Vp?=
 =?utf-8?B?R0xkRXdvNFRYOTVsZ216S3pWdFByZUFYbmpJOTJaUDZXeFNzTnMrQU5sWnJL?=
 =?utf-8?B?TVNzMTZ0YU5jZWtFay8yK1FQZDliWGRQMXlZazBHUmo1WkNCQmE0V3NMSmta?=
 =?utf-8?B?a05IQmpmNExDbzZ3TUl5WC9RUTZkRGIxOEErYnRhRE51NUFBNjQ1QXhyOFI5?=
 =?utf-8?B?UW5KbGV4WXZWZmdDZjMyN3p2MTA2ZDFCSkFpbW5SZTlBK2NtVUI0VHp0ck14?=
 =?utf-8?B?TEU0eVdRcjNWdjlkOWE5NGQ5ZGVwb1VRY3lCSit3bVAzZlRzMWt5WVN2M2JH?=
 =?utf-8?B?TGNva0pUbmFxTmxIL0pBR3BoRWJta0xCaTk2V2VNVXAvbGxleFNKWmUyQ0VY?=
 =?utf-8?B?dUY1dEpMVkppM0JWSUh5aEJOemVlSUp0Yk1HcFJubm1ZaWtPU1c0RDhSSFJr?=
 =?utf-8?B?YTV6RS9ONSs3MWlqVFVCL1VXWXBKSHk2Ym1EY044YjNmczdVOXNnRENHeVFQ?=
 =?utf-8?B?bitJNFE5TWRzNkJVUktxK0YzQzJBd2hiZXVWeHhQZXB5SWpKT0x3K3YyMWlQ?=
 =?utf-8?B?eXRkek1TVFRtRld0ODQydlBvT3h6VDR1QnNzRy9hSFRZdFhzQ3pDcG9aM3ZP?=
 =?utf-8?B?TnUzd1hNb05Fend1TDROREZ4NVZ6NXFUaTFkNGxub3RKVWQ3ZzA2cDZaSktt?=
 =?utf-8?B?eUpqOWw2UHBpSkpncGtzYUNQS0tPOTZFTldxNlZkUjM2UVRGam9JdWc0WHpx?=
 =?utf-8?B?SXhzMXdzUHpjcEtCRjdQWVZLcWZieGhLR1c1M090V0pQVXJiOTJGODUwcytC?=
 =?utf-8?Q?g9zXWyyJgUYxVL+Il9sJp3XxfEHsfr3hPZ466Xr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <736FC8E98238FB4AA9B5FCB19C8104E6@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e383ce57-3845-4f9a-5683-08d965ccfba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 00:28:51.7215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rFWTAU1XJoralg2tS45lxoL/IhFWLA3DL32gl50iNn1asNNwF/7X6r85rwRxETibFxa/b1a5R7p1SYGVvKrNkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMy8yMSAxOjQ1IEFNLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IE9uIFN1biwgQXVn
IDIyLCAyMDIxIGF0IDExOjM3OjI4UE0gKzAwMDAsIEFsdmluIMWgaXByYWdhIHdyb3RlOg0KPj4+
Pj4+ICsJc2tiLT5vZmZsb2FkX2Z3ZF9tYXJrID0gMTsNCj4+Pj4+DQo+Pj4+PiBBdCB0aGUgdmVy
eSBsZWFzdCwgcGxlYXNlIHVzZQ0KPj4+Pj4NCj4+Pj4+IAlkc2FfZGVmYXVsdF9vZmZsb2FkX2Z3
ZF9tYXJrKHNrYik7DQo+Pj4+Pg0KPj4+Pj4gd2hpY2ggZG9lcyB0aGUgcmlnaHQgdGhpbmcgd2hl
biB0aGUgcG9ydCBpcyBub3Qgb2ZmbG9hZGluZyB0aGUgYnJpZGdlLg0KPj4+Pg0KPj4+PiBTdXJl
LiBDYW4geW91IGVsYWJvcmF0ZSBvbiB3aGF0IHlvdSBtZWFuIGJ5ICJhdCB0aGUgdmVyeSBsZWFz
dCI/IENhbiBpdA0KPj4+PiBiZSBpbXByb3ZlZCBldmVuIGZ1cnRoZXI/DQo+Pj4NCj4+PiBUaGUg
ZWxhYm9yYXRpb24gaXMgcmlnaHQgYmVsb3cuIHNrYi0+b2ZmbG9hZF9md2RfbWFyayBzaG91bGQg
YmUgc2V0IHRvDQo+Pj4gemVybyBmb3IgcGFja2V0cyB0aGF0IGhhdmUgYmVlbiBmb3J3YXJkZWQg
b25seSB0byB0aGUgaG9zdCAobGlrZSBwYWNrZXRzDQo+Pj4gdGhhdCBoYXZlIGhpdCBhIHRyYXBw
aW5nIHJ1bGUpLiBJIGd1ZXNzIHRoZSBzd2l0Y2ggd2lsbCBkZW5vdGUgdGhpcw0KPj4+IHBpZWNl
IG9mIGluZm8gdGhyb3VnaCB0aGUgUkVBU09OIGNvZGUuDQo+Pg0KPj4gWWVzLCBJIHRoaW5rIGl0
IHdpbGwgYmUgY29tbXVuaWNhdGVkIGluIFJFQVNPTiB0b28uIEkgaGF2ZW4ndCBnb3R0ZW4gdG8N
Cj4+IGRlY2lwaGVyaW5nIHRoZSBjb250ZW50cyBvZiB0aGlzIGZpZWxkIHNpbmNlIGl0IGhhcyBu
b3QgYmVlbiBuZWVkZWQgc28NCj4+IGZhcjogdGhlIHBvcnRzIGFyZSBmdWxseSBpc29sYXRlZCBh
bmQgYWxsIGJyaWRnaW5nIGlzIGRvbmUgaW4gc29mdHdhcmUuDQo+IA0KPiBJbiB0aGF0IGNhc2Us
IHNldHRpbmcgc2tiLT5vZmZsb2FkX2Z3ZF9tYXJrIHRvIHRydWUgaXMgYWJzb2x1dGVseSB3cm9u
ZywNCj4gc2luY2UgdGhlIGJyaWRnZSBpcyB0b2xkIHRoYXQgbm8gc29mdHdhcmUgZm9yd2FyZGlu
ZyBzaG91bGQgYmUgZG9uZQ0KPiBiZXR3ZWVuIHBvcnRzLCBhcyBpdCB3YXMgYWxyZWFkeSBkb25l
IGluIGhhcmR3YXJlIChzZWUgbmJwX3N3aXRjaGRldl9hbGxvd2VkX2VncmVzcykuDQo+IA0KPiBJ
IHdvbmRlciBob3cgdGhpcyBoYXMgZXZlciB3b3JrZWQ/IEFyZSB5b3UgY29tcGxldGVseSBzdXJl
IHRoYXQgYnJpZGdpbmcNCj4gaXMgZG9uZSBpbiBzb2Z0d2FyZT8NCg0KWW91IGFyZSBhYnNvbHV0
ZWx5IHJpZ2h0LCBhbmQgaW5kZWVkIEkgY2hlY2tlZCBqdXN0IG5vdyBhbmQgdGhlIGJyaWRnaW5n
IA0KaXMgbm90IHdvcmtpbmcgYXQgYWxsLg0KDQpEZWxldGluZyB0aGUgbGluZSAoaS5lLiBza2It
Pm9mZmxvYWRfZndkX21hcmsgPSAwKSByZXN0b3JlcyB0aGUgZXhwZWN0ZWQgDQpicmlkZ2luZyBi
ZWhhdmlvdXIuDQoNCkJhc2VkIG9uIHdoYXQgeW91IGhhdmUgc2FpZCwgZG8gSSB1bmRlcnN0YW5k
IGNvcnJlY3RseSB0aGF0IA0Kb2ZmbG9hZF9md2RfbWFyayBzaG91bGRuJ3QgYmUgc2V0IHVudGls
IGJyaWRnZSBoYXJkd2FyZSBvZmZsb2FkaW5nIGhhcyANCmJlZW4gaW1wbGVtZW50ZWQ/DQoNClRo
YW5rcyBmb3IgeW91ciBkZXRhaWxlZCByZXZpZXcgc28gZmFyLg==
