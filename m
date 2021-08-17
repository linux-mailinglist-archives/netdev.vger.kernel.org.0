Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD713EEC4B
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhHQMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:20:21 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:25180 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236165AbhHQMUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 08:20:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2058.outbound.protection.outlook.com [104.47.12.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A733F4C0027;
        Tue, 17 Aug 2021 12:19:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dp0306PaPzlLydrGDO1+sMoi9KobQlL9bAwXjSz+EROT1wtgzDLCM5dPaBiBoIS0T+X8GQaIWs1WvxHWEcad0aQI+hzyII4QuSx77w0trqu3U14N1G2TH39s4ENx1jExFnIRKoWyOi7aNz0KUwxOawQj3Yi6VSMio9vbVarZQu3Xbh5bekTiqQ9jXcc3wp1VW8gco3RInD/HPBNtLwk0KqmWHfJ49z1w+RehrJN1kLlMSgh3j/9RQspzbLlTngHSLzVDGAb5o1NMT4rTK1xzDGRyfdtIAHohykJGmJt/53IsbdqL19x9LMRzZ7BbnUZ9drGvNWRm9BrMNl7qsCTT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0+O+QZ60RDYxniZrhjNzD7Mr3sDXWGBmFtcLjApYrY=;
 b=V8Mzo4jlrZtgw3xwprQOwnUM5IM+1eVnPxTyDwv72KZuiAm4SdqN/hW3w5hgoMworEFIVamoyj24xNOfdQKOHds0cUHLDu5lWsJXoat4QYIVEO3mt6hKrJJPwH45GBJ8FtIXvpkgFBXO6lNz76ZaxkmQTGUdvVauFRsW4rvv5HJ89WBee2K0ikbXbLr2jzHZ36WzrR/fNOlM/mxJwMVu0h5X16KcTdcqU7B7lH8EBefPxV/lxag+7CoeN4tlooqkbzqxjlBkDI0CUywxyQVosQpHfm5mJzBK8bqB7PwAYb2POKHBl/UMylWXPdLlzQpfaLG0KVEiGdPN8ZVyyTSbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0+O+QZ60RDYxniZrhjNzD7Mr3sDXWGBmFtcLjApYrY=;
 b=dtHrBKeFhaE0SpS97/QoTZ9QuJL7Ph83OKxVrfpXCJA42iX6GL0nOBoesIKd1WpX0tnE5IZN2u6uYhO+ZrVcGbW4rWqtkYFexAfbUQQYqubK3mnUmU7UP906BKFyt8D3pm0ow/KoeKBH+hvX5NC8dOo+or9JHCnxSVgd9VW1ejM=
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AM5PR0801MB1665.eurprd08.prod.outlook.com (2603:10a6:203:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Tue, 17 Aug
 2021 12:19:42 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 12:19:42 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "luwei32@huawei.com" <luwei32@huawei.com>,
        "wangxiongfeng2@huawei.com" <wangxiongfeng2@huawei.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: Improve perf of bond/vlans modification
Thread-Topic: [PATCH] net: Improve perf of bond/vlans modification
Thread-Index: AQHXk1e8yO+zaiHVZE2Gh7GsHEFRFat3klQAgAAJQACAAAILgA==
Date:   Tue, 17 Aug 2021 12:19:42 +0000
Message-ID: <BDF20DEF-7935-4392-928A-E96E99B01605@drivenets.com>
References: <20210817110447.267678-1-gnaaman@drivenets.com>
 <84c0c733-193a-97c7-1a68-c34f44cf2f61@nvidia.com>
 <6A2FF5BF-95A3-4BE2-A938-B3981116E066@drivenets.com>
In-Reply-To: <6A2FF5BF-95A3-4BE2-A938-B3981116E066@drivenets.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=drivenets.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e32a62d7-6310-48b3-42ed-08d961794ac6
x-ms-traffictypediagnostic: AM5PR0801MB1665:
x-microsoft-antispam-prvs: <AM5PR0801MB1665117E07C43560611AF3FDBEFE9@AM5PR0801MB1665.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bo+F8eEMytMK8Y5DZ3Eu4gJZojU+6uyGPzEIhE3YXuElJCTrRNZtgE6ofx8nSptTI8smNT3bM0edtKdPbZ621+XaK4nNlejaNyUklz5SDTnagXCUaseTWV6LtyOwvldAe4VdMp33c4/Osw1Zm2/zEeQoxgWAjNSLbL9h604FVHu+SVYdVJIwcRJr4cIcz/ZIVn8Pdj0GnzZic633eA8EXg+WhGyLRFwiV61b9H4tdlj7UMOIm3mpg/DNhj8ujR4/AbVzRvCrVbR4j0Y/c8OhDIdC8VEOmHxR3fk+8corRhgIFUFibz4L1LrB7hX751xjjFSm7uvX5nte875ab4KgFv/vRyQW7V5UauFxGTd5kGaYzCTrjbf7x0XKDWK2nSFZjSn6QLGC1PYtxLhyUq8MAEsCHLTj+bTS+F0WOEGKaXpLJ/z8T/FtJAwPOf4Uzb9YArEWtE/NzUO6D2q5v1aGEjqIGKekgSFWDrHHDc4KpHXoN8rcTqvlYUa7K9CsXmXfB4hqdyjuO5rBNtaQTOndFV22wXBFOeKzEUj6qoguIyxDWi0ZvLfcLIT2zeBH6aThXFtcEO/HYeAIDh7NBXkX1tzvdkxIdlVPEdzeIos+u9MuKdP6YJ712cZmo9bMgLw4uToSHy5f5TxXVRBc+LE3eygNci/8j1VZZuowwNkc8VwNQp5fqJKhHDpRTfVn8f9rjAq7Wqz9IVcyES6x7Z73ci0sZnIPESPAveQi1mXPxc+SEmumDPIJu/s/u2bByUfp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39840400004)(396003)(136003)(376002)(36756003)(66446008)(6916009)(122000001)(26005)(53546011)(6506007)(38100700002)(64756008)(4326008)(2616005)(33656002)(8936002)(86362001)(316002)(186003)(2906002)(66556008)(66476007)(91956017)(54906003)(8676002)(76116006)(6512007)(71200400001)(6486002)(5660300002)(478600001)(38070700005)(83380400001)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2g4NEZ0NXB5ald1b0txY0NxSldHWXh6c3RyTG1IRklDSm1CUVh0L2Z4OVZh?=
 =?utf-8?B?STczUGpMV1RrZG5HelVyMHg4cnRXMFg3S1VGVHpYQUhvNitMYTVZd2ZvYlJX?=
 =?utf-8?B?MUIraUpTTGJHOW42UTVMdzVRdzlGTlg4TGtCckF2YjJKYWhubjJsbFMwV1N1?=
 =?utf-8?B?ZVhZeE5wRjE5NWZZY01sZ2Z6a0VPcUw3TFNrZFNiWVZGSW13MTBzQmE2d2t6?=
 =?utf-8?B?R0U2bEw0Sys3RXpUcWhwZms4NlBsOHZJck8rRTBtVDh5aUlsS3FNYXhoeDg3?=
 =?utf-8?B?cVZxTmhYUCtyMmdnTHZBbXhRTmNQUUpEWE1oMkRjd0NzaCtkaTdicEFjUjA4?=
 =?utf-8?B?S3RCT0xRREEwU2p2cTRJV1lieTFVNGZQYzB5RkJ0bkhjK05JTGJROENZS2pm?=
 =?utf-8?B?M0Rsa2U5a0t4UC91RXQvOEp4T01qR3p5M2t4ZnozMW0vcGRYQWRtdEZBTE4z?=
 =?utf-8?B?QjRjaCtDVEo4cHMrQm13bCtuVkc4UVdqSTJCczlUQng3TFZEaDlObkp4Rkx0?=
 =?utf-8?B?cFdCQ3I3ajJrdWpJNGo2ZGIrYVo3VlA5djdMdjV3dUFneUd6bUhVYjlkV1dU?=
 =?utf-8?B?MzVNamh0c1VBU1cxdFZwY2xqaXdaY2todGVFQUFLanNySVFjRlJ6R25IR1RP?=
 =?utf-8?B?d0RlRGVFNmFkbjJ1RjhMaXhzcXYwUjZNZTlCcCtYbzRYODdKcG9rV1hrZitu?=
 =?utf-8?B?bzNqdlUvSllhMUpMSHFvR0lRYXpUQjg4QjZpaHJCT3RrWU00VDA3M3Rmdi9F?=
 =?utf-8?B?Sm44NE56OXpNS3FDUkp3OFBlQXE5K3FzRnJJYm9qMDROSWVrcTFaN042SW5L?=
 =?utf-8?B?alhHTW0vZ3ZkTzFWYzl4aVhSZGhIcEpJNXVLZWhJSzNITytsQ2lTTVpRRHFu?=
 =?utf-8?B?Z05ONm1BZ0xMbTFzeXhtNDkzVk1sRTR4TTdBTUliWWhVWlFDTjMxKzREMVl4?=
 =?utf-8?B?RzB5bDhyOW80Z1JNcEEyMHBET3dacm41YW5kTnR3STRDUnBHOVdZbkdpOWlM?=
 =?utf-8?B?U29DU1J5OHNjU29nS2ZwbGVLRmsvbi9iamZwMzRlVzJvMHZiYXpUeFQvUFVj?=
 =?utf-8?B?Rit4bHN2S2JIUTFkUVJVcTA4eGIzb1poRHVuNDFTZHZyUnRVbFBkakVWR2xo?=
 =?utf-8?B?U2s5RVVVOVh3N3VZS3ZWS2k2VmIwT0x6OGxjeWZGWTA2NUNoUklueDc3dUpL?=
 =?utf-8?B?Sy9WZ2ZZazhteHA0RmhuV25CMytlazk5dS8yblJZY3p5VE9xUmtYOEhoTXJO?=
 =?utf-8?B?T1VZUGt5Z25vdWpRUTR1TmtRc3U0dkRTQ2Y0VElnMndScnV0cW5DWVFiY3Qv?=
 =?utf-8?B?WEZLZ1dRWWljWTA5WkRVOXN4MDEvWW9aMXBBeDRlRm02bi9xOEovclMvL24y?=
 =?utf-8?B?UEtEUEg4NzdXOE5ra0Y5V2IxMkZKODFnM1VyZUFkOVhQa1FkRTlyVHo3RTF6?=
 =?utf-8?B?QndZS21LcVdDYThFRmRLdU5hVHhvaFlVWGJTVFp2ckRVR2pVZGo3WURpUFls?=
 =?utf-8?B?VDNTdjlQOEdSeG5HcmU4dThkVU42dU95TjYvN2t4amZ4Ykxwc09XdTdZNkZI?=
 =?utf-8?B?R1lzWnVUdTA0Q1ZlVk9XbFAyWGRYTFUvNXZvWGFzNjc4NUNjSStub2VhNnI1?=
 =?utf-8?B?R1grUVRTMm5nbTNiQkVKQU9VejdJZ0d5dUFzWEtJNzVwWWNXOXVTd1pEa3Rz?=
 =?utf-8?B?OGVXRk8wNUNTUU9Ya0lmVXJtOWJiVGE0czg3aHlzamo3a2hwVHBNa2lOdG9P?=
 =?utf-8?Q?XLw3TexbnrGOpCiB6A2tk0TRmFXA+k2soIKQlE3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <292C35BFB91A3A4AAB1F9E10AA8CE40C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32a62d7-6310-48b3-42ed-08d961794ac6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 12:19:42.2490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VfqcK2+ljnaeBFmYMObM+tzs8LlAcejEvkEnMXs+UHTmug+bVI/b/ZcgCQNASotyBVM1X52tJVqq+h0bElKwTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1665
X-MDID: 1629202786-XnpX6spkfexp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIDE3IEF1ZyAyMDIxLCBhdCAxNDozOSwgTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlrb2xh
eUBudmlkaWEuY29tPiB3cm90ZToNCj4gDQo+IE9uIDE3LzA4LzIwMjEgMTQ6MDQsIEdpbGFkIE5h
YW1hbiB3cm90ZToNCj4+IFdoZW4gYSBib25kIGhhdmUgYSBtYXNzaXZlIGFtb3VudCBvZiBWTEFO
cyB3aXRoIElQdjYgYWRkcmVzc2VzLA0KPj4gcGVyZm9ybWFuY2Ugb2YgY2hhbmdpbmcgbGluayBz
dGF0ZSwgYXR0YWNoaW5nIGEgVlJGLCBjaGFuZ2luZyBhbiBJUHY2DQo+PiBhZGRyZXNzLCBldGMu
IGdvIGRvd24gZHJhbXRpY2FsbHkuDQo+PiANCj4+IFRoZSBzb3VyY2Ugb2YgbW9zdCBvZiB0aGUg
c2xvdyBkb3duIGlzIHRoZSBgZGV2X2FkZHJfbGlzdHMuY2AgbW9kdWxlLA0KPj4gd2hpY2ggbWFp
bmF0aW5zIGEgbGlua2VkIGxpc3Qgb2YgSFcgYWRkcmVzc2VzLg0KPj4gV2hlbiB1c2luZyBJUHY2
LCB0aGlzIGxpc3QgZ3Jvd3MgZm9yIGVhY2ggSVB2NiBhZGRyZXNzIGFkZGVkIG9uIGENCj4+IFZM
QU4sIHNpbmNlIGVhY2ggSVB2NiBhZGRyZXNzIGhhcyBhIG11bHRpY2FzdCBIVyBhZGRyZXNzIGFz
c29jaWF0ZWQgd2l0aA0KPj4gaXQuDQo+PiANCj4+IFdoZW4gcGVyZm9ybWluZyBhbnkgbW9kaWZp
Y2F0aW9uIHRvIHRoZSBpbnZvbHZlZCBsaW5rcywgdGhpcyBsaXN0IGlzDQo+PiB0cmF2ZXJzZWQg
bWFueSB0aW1lcywgb2Z0ZW4gZm9yIG5vdGhpbmcsIGFsbCB3aGlsZSBob2xkaW5nIHRoZSBSVE5M
DQo+PiBsb2NrLg0KPj4gDQo+PiBJbnN0ZWFkLCB0aGlzIHBhdGNoIGFkZHMgYW4gYXV4aWxsaWFy
eSByYnRyZWUgd2hpY2ggY3V0cyBkb3duDQo+PiB0cmF2ZXJzYWwgdGltZSBzaWduaWZpY2FudGx5
Lg0KPj4gDQo+IFtzbmlwXQ0KPj4gQ2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD4NCj4+IENjOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPj4gQ2M6IEx1
IFdlaSA8bHV3ZWkzMkBodWF3ZWkuY29tPg0KPj4gQ2M6IFhpb25nZmVuZyBXYW5nIDx3YW5neGlv
bmdmZW5nMkBodWF3ZWkuY29tPg0KPj4gQ2M6IFRhZWhlZSBZb28gPGFwNDIwMDczQGdtYWlsLmNv
bT4NCj4+IFNpZ25lZC1vZmYtYnk6IEdpbGFkIE5hYW1hbiA8Z25hYW1hbkBkcml2ZW5ldHMuY29t
Pg0KPj4gLS0tDQo+IA0KPiBIaSBHaWxhZCwNCj4gR2VuZXJhbGx5IEkgbGlrZSB0aGUgaWRlYSwg
SSBoYXZlIGEgc2ltaWxhciBoYWNreSBwYXRjaCBmb3IgdGhlIHNhbWUgcmVhc29uIGJ1dCByZWxh
dGVkIHRvIGJyaWRnZQ0KPiBzdGF0aWMgZW50cmllcyB3aGljaCBpbiBzb21lIGNhc2VzIGdldCBh
ZGRlZCB0byBsb3dlciBkZXZpY2UgYWRkciBsaXN0cyBjYXVzaW5nIHNvZnQgbG9ja3VwcyBkdWUN
Cj4gdG8gdGhlIGxpc3QgdHJhdmVyc2Fscy4NCj4gDQo+IFRoZSBwYXRjaCBzaG91bGQgYmUgdGFy
Z2V0ZWQgYXQgbmV0LW5leHQsIG1vcmUgY29tbWVudHMgYmVsb3figKYNCg0KSGkgTmlrb2xheSwN
ClRoYW5rcyBmb3IgdGhlIHJldmlldywgSSB3aWxsIHJldGFyZ2V0IHRoZSBwYXRjaC4NCg0KPj4g
KwkvKiBBdXhpbGlhcnkgdHJlZSBmb3IgZmFzdGVyIGxvb2t1cCB3aGVuIG1vZGlmeWluZyB0aGUg
c3RydWN0dXJlICovDQo+PiArCXN0cnVjdCByYl9yb290CQl0cmVlX3Jvb3Q7DQo+IA0KPiBXaHkg
a2VlcCB0aGUgbGlzdCB3aGVuIG5vdyB3ZSBoYXZlIHRoZSByYnRyZWUgPw0KPiANCkkgd2FzIGFi
b3V0IHRvIHNheSB0aGF0IHRoZSBsaXN0IGlzIHVzZWQgaW4gUkNVIGNvbnRleHRzLA0KYnV0IGlu
IHJldHJvc3BlY3QgcmJ0cmVlIGNhbiBhbHNvIGJlIHVzZWQgd2l0aCBSQ1UsIHNvIHRoZXJl4oCZ
cyBubyByZWFsIHJlYXNvbiB0byBrZWVwIHRoZSBsaXN0Lg0KDQpJ4oCZbGwgd29yayBvbiBpbXBs
ZW1lbnRpbmcgdGhpcywgYnV0IEkgZmVhciBJIGRvbuKAmXQgaGF2ZSBhYmlsaXR5IHRvIHRlc3Qg
YWxsIGRvd25zdHJlYW0NCnVzZXJzIG9mIHRoaXMgbW9kdWxlLg0KDQo+PiArDQo+PiArCS8qIElu
c2VydCBub2RlIHRvIGhhc2ggdGFibGUgZm9yIHF1aWNrZXIgbG9va3VwcyBkdXJpbmcgbW9kaWZp
Y2F0aW9uICovDQo+IA0KPiBoYXNoIHRhYmxlPw0KPiANCk9vcHMsIG15IGVhcmxpZXIgaW1wbGFu
dGF0aW9uIGlzIHNob3dpbmcuDQoNCg0K
