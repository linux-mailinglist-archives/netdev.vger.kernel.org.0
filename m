Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927C34899A9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiAJNPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:15:48 -0500
Received: from mail-eopbgr150107.outbound.protection.outlook.com ([40.107.15.107]:23558
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231664AbiAJNPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:15:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKhA6zeg/VCn3ZzpOsJ5cdg9GjA4x1I9485T3XsboVwooKnL73BM/Ne6i3Z1MU/vjcC66mk5H8u141wGKeyP6X8UoMJwPM9gOK9150whkCZKrdUbYcJW7LbHKpALDJ6epAqyN/OpImuYcXMbBrBxFVFeHREhbh94+Q1hFg/8QUo8UQHPzIyVW2FO9XSmooMd1eseBj8EgiUwmmszVankAlPxj4uD8IjdPRLpcbxy5EiVxb6mVsFW+c8T717pZLaZqL3laPwh08oelPt1C4BV28SGziNfL0bfam6hANIGetezg6SbtsfPziO5QlZGi6nxWvuYYHARhnSSCOA9o0D+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLFJ+07AFP3YdeJPHMH4qL0Jc7Ns69MqgCvl+1NLy8w=;
 b=By1qMao4XJBW4UhHNm3UjfQQBtNZgxEkNPXkSiEm4vWx1COS/y9hNU6/BqniKjAGLSpmMp8lrfy8Ab09+rzSFHnd/gRY2DDM9gjqCn4eHE1xWuzVC9JEldaL/X7gBMfPh3VhFUps39ClHTFNdE2lpBPDr/NLM83tTjgYfJkCsrTKjj3jxIL+J3u1CbQ8mVY9kGFaZyf0zI2cRl3q/LE/Su/40FqC730+EY9QYGn4h3TnZseZCpBSpj3FZBluDFz1mJ8/E8WfLj1XZ7bGncwYGOhoRNPSz77iLuB14hcu9l0sWzHC7x+Nf3l/drD7HGsmx2ZNbLm/DxnEH8sxzHnPaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLFJ+07AFP3YdeJPHMH4qL0Jc7Ns69MqgCvl+1NLy8w=;
 b=QWmS9LWX6Jhv+d2/2IDUk5wGnKRtk5UtAqxiplXPe+kyupcfexDynUnIi+YtqRRMRCWLX1stDz9tQ00/qWOo7dnnH6SSWWmnCAi32OUSAU9A3fyO++iEbOAhQ3p7gykV6SXbENMuYzkoE2H82jujR9+uLcNA83Popto0OODvCDU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5458.eurprd03.prod.outlook.com (2603:10a6:20b:c6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 13:15:44 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 13:15:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 07/11] net: dsa: realtek: rtl8365mb: rename
 extport to extint, add "realtek,ext-int"
Thread-Topic: [PATCH net-next v4 07/11] net: dsa: realtek: rtl8365mb: rename
 extport to extint, add "realtek,ext-int"
Thread-Index: AQHYAeKVzu71+54MoEybSm59gcfesg==
Date:   Mon, 10 Jan 2022 13:15:44 +0000
Message-ID: <87v8yrd94w.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-8-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-8-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 5 Jan 2022 00:15:11 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db331a2b-1baf-420c-4c04-08d9d43b4f18
x-ms-traffictypediagnostic: AM6PR03MB5458:EE_
x-microsoft-antispam-prvs: <AM6PR03MB5458F11F9630C4206E2D680883509@AM6PR03MB5458.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l8ULRzUgojTLvCmP3afs9rBnSu6Rwo2jgeNBlmLGyojtLydHUc2Ub46bqhkg/pdCh2mm6vL8Fjl0wZ0zYYCyy3qtQsexXg8N4e++tTknlNvlUPk64lXNsBMEa+uWs/dcJaovq7jpXv69G5rn18WNLku/qvCHd0Xbcx2Va0DR1u+OQkRAAgRsp7S+X93ZaVDu689N/t30NbPcFQ0RficKdFz5Oz3y92b0sJmL0r9MUcVXcmH4MYOo3yM7tptvat6gQgYwQiMRAYh9vKWiWyPrI95M7+Y+IuN+8s5hZXt+NY0nuuLoFVBx3F2vc0rVDgJYalzpHXIOA87lDMbMWeGBKX7hYhylfiFsSu3W3QVk8rBC4A1dArMkrb8qz/WcoDwTls/qo8k2BY7CGU/+1RSCXksYnf7yADv6uW3/vsvqqX2R7o73rHXVi3dyNl8lXMcdmLlU7JncSklA8JgbPJhLdsPugeKufWTRxsldiBtNwmy84PAR6yt0dwl5uI79WSZrcG8hmk9uYsY8DsieNJ4jt3X9p1a0BaKdX76CjJBEjvgo1LZKaZnn9ozDgdCwrxm77oePLZhRWCsLXIoG1myL4juzi8VuHQEq0dAEtcgSKwKH9C/qDZcUUWI0TExjmUsf3uIhts18F42c5hOdph+PLhI61gIJEyPW9IG44zujGvEvhQVcplDgu+LCZlSOepe/XvJfKrRTESEYHGOhukoR3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6916009)(8676002)(8976002)(8936002)(86362001)(316002)(6486002)(6512007)(186003)(54906003)(26005)(2616005)(85202003)(4326008)(71200400001)(6506007)(85182001)(83380400001)(5660300002)(38070700005)(91956017)(2906002)(66476007)(36756003)(38100700002)(76116006)(66946007)(122000001)(66446008)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzhnUnU5QWd4TlNaTUdMSEloTnlVNWJwUy84Ky9iSEthdWVGNmMyRkNxRVZV?=
 =?utf-8?B?SlpZa2lDVXlNZ3dLc3FSN0VqVjREQWtlRUxPN3BjbHVLTmJFcEVqYkExSzV3?=
 =?utf-8?B?d0VTRVB1ZmVRMitFVWNQZVJacTgrWnZiWU5aVDZtZWhzWXJCWlZpRnM2bnVP?=
 =?utf-8?B?Lzk2bE9PSWwxaXdyUW9Vb05IMFkwV2czM3dtZkY4Sk1yOU1xSldBNlFCdUM2?=
 =?utf-8?B?RTFFekZDTit1VEVCNUFmSXdpSnE0eWxGbkNvZlA5YUhkMzZUL1piVVJtUW53?=
 =?utf-8?B?SUozUVJhdHlWcGVKV2RSN3JMaCtleHlqWnZLcXUxcFJuWGtrQW01eXk1TmQ4?=
 =?utf-8?B?UUxldUppVUp2eVZZRDF4aEVFc21KLzdOelhLR3V1T21TTmpIQWwzc1NqMkI2?=
 =?utf-8?B?WllyZUErWTd3ZDdiYTFvR2NZb0ZhK0ZoTEtuc2FFSkR5K1FlWHVQN0JGcnYx?=
 =?utf-8?B?alpGMjZ1SUdFdHhkckFqaTcyQXpPYkx5UTFTUDl2akF1cE9pVS92TFlzNzdj?=
 =?utf-8?B?ZmxoMzM3MnF2Zy9YbXBtcGVtRzdxeHBGNTFVUlZ5bm5IQU1qRnhWZ3lPME9L?=
 =?utf-8?B?OEJ0RE1vdkw4VnFOVkFNeGhvdVB6STNFakJCTHNvRGYxd29mRndaM1AvTjA1?=
 =?utf-8?B?SXA4ZXFidGtoelRMSk1qSmZWV1FScWR5L2krSVVENTlhL3dWMCtXMXd6dTJV?=
 =?utf-8?B?aHlQRTVDTDVQcjBhQTBYZW8ydU51anZGeFBHc2ZwR01TRDkyRkljaGJXV2xt?=
 =?utf-8?B?UmtGMUg3bXI4L1UyaGhQbjVHWm5ja0FDVXJlQlZHYmtKUGtRYlVFNEo5aHJJ?=
 =?utf-8?B?ZmtCQ0IxZVo2MUpYeDBGcXREZkZRbW5kZEpVL1ZXM0lYQVJpRXNrOXhuR2tm?=
 =?utf-8?B?eHo3M0Rnek5CRnd4YkZNcUE2djgvVjA1ZHh6SnlvSTN4VW1HNjRPcW5MdEQr?=
 =?utf-8?B?Y3JlU1puakUwYzBQOTExWlpqUlJkWjM4ZHRULzhwa21maUxUTTVOcnFudFl1?=
 =?utf-8?B?WDBKbUNpUmxVRktZMnJ6dkVOZnNlWVRhTW5aQjBDeFIwTmY4K0pyMnhRWml3?=
 =?utf-8?B?RmJMTTFKZ0JFUE54Y2xRWklpOGU4VFVRTSt4M050RC9ReWFwK0lkMUQ2Rytj?=
 =?utf-8?B?WGVaZVJOVWdQaTdYTGdJL2p5L0pQWi9HMGtkK3h6K0pTckoxcmRNeEM2NTJT?=
 =?utf-8?B?MHcwV21JSHNGbVFwR3krY2wyMHZpQUo4a01DNEtPamoxbUpkSFR6cGhLckM0?=
 =?utf-8?B?VWc5amM4ZStlbVE4cUsvTTZyVFdYWThFVW14SHIwNEM1RytNSHJYN1d6WFBa?=
 =?utf-8?B?ZkNLY2V6OEh2Unl6ZTBDcTBSbjJPVlBYWVZpelFTOUZYSlg1YStkODRaajlS?=
 =?utf-8?B?b3ljbmRvSGg4WHVac0k4RWU0b2dFOEd1ZUNTYkUvbkQ3bUtMYVAzVmdPalFR?=
 =?utf-8?B?emZwRE9tSTdtNVlsYitXOHBqTnBySFFBbnZsNHRSUVErUDhqbFJqOGxRMGQ3?=
 =?utf-8?B?RlVNTzNrU011ZHdZKzRRNFo2TnEzZHh0aDY0NVo3T2J0N29HMUxUdHZCN2hw?=
 =?utf-8?B?V1FzTGtBKzZyRFdpU0RYTmtUWWZOaUpaNVE3THRvRXNvTWM1dlNrbm12aFRP?=
 =?utf-8?B?Q0ViNFY4R2FJekJPSWpOTk9LR3ErbkljMGFIVForcGI5cTRBclFCdkwxajZp?=
 =?utf-8?B?ekdXRmxxYUpBVzNPbFdSVTJDcXVsdWVQbWU3b2JMZUxiL0FqcEhVTC9uTEhq?=
 =?utf-8?B?TERDYzR2SWErV2hCUU5oODNyWGhZQnJyRlRPWnkwQTBLclFNK1Z1VlhmK3N2?=
 =?utf-8?B?ajBObnVCMXNnNVh0UTQ3eGVMd2tNWjhqUVU1WnJNSFNqcjBRZE5WYTZEanZW?=
 =?utf-8?B?TVk2M21kb3I1U21BRXlUVzZjdW5VR3Z0RGhxWXM2STZ6cEpFbWtDZVJDOVZF?=
 =?utf-8?B?Nmw1djFiZE5DMUgvVUI0OFJJa3FydmhUQkFOSWlvdDdkdURxRE1ub3RoQXV4?=
 =?utf-8?B?M3lxRS9BTEcvUEZjOTJYNkMrM1dJUDQwc2hyWmd1THZiNzBWM3VZRERQYnB2?=
 =?utf-8?B?NDdhTENMQUloYXJ1c2lpeG9Rc0g0aE5ZVzBMcXJmTXhKamRUL1Z5UWR5akoz?=
 =?utf-8?B?N0tneTJuZHB5NnpnOWVQU29udzBMeDRtY1VWZGxHSklrdmI3am9LYXBCS09K?=
 =?utf-8?Q?PFJe8D6c4jbf9cyi4JPiD1U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2861BD9F6AA60642A7A5A2FDB8620CD0@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db331a2b-1baf-420c-4c04-08d9d43b4f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 13:15:44.3849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V73JShjN31rzdVopW8pBx/ovanhkpoP81+WXEovZdshzSp0gCJqJt+Zn8okemG2/jlQ9ErvyUYmFGce24CcO/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5458
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gImV4dHBvcnQiIDAsIDEsIDIgd2FzIHVzZWQgdG8gcmVmZXJlbmNlIGV4dGVybmFsIHBvcnRz
IChleHQwLA0KPiBleHQxLCBleHQyKS4gTWVhbndoaWxlLCBwb3J0IDAuLjkgaXMgdXNlZCBhcyBz
d2l0Y2ggcG9ydHMsDQo+IGluY2x1ZGluZyBleHRlcm5hbCBwb3J0cy4gImV4dHBvcnQiIHdhcyBy
ZW5hbWVkIHRvIGV4dGludCB0bw0KPiBtYWtlIGl0IGNsZWFyIGl0IGRvZXMgbm90IG1lYW4gdGhl
IHBvcnQgbnVtYmVyIGJ1dCB0aGUgZXh0ZXJuYWwNCj4gaW50ZXJmYWNlIG51bWJlci4NCj4NCj4g
VGhlIG1hY3JvcyB0aGF0IG1hcCBleHRpbnQgbnVtYmVycyB0byByZWdpc3RlcnMgYWRkcmVzc2Vz
IG5vdw0KPiB1c2UgaW5saW5lIGlmcyBpbnN0ZWFkIG9mIGJpbmFyeSBhcml0aG1ldGljLg0KPg0K
PiAiZXh0aW50IiB3YXMgaGFyZGNvZGVkIHRvIDEuIEhvd2V2ZXIsIHNvbWUgY2hpcHMgaGF2ZSBt
dWx0aXBsZQ0KPiBleHRlcm5hbCBpbnRlcmZhY2VzLiBJdCdzIG5vdCByaWdodCB0byBhc3N1bWUg
dGhlIENQVSBwb3J0IHVzZXMNCj4gZXh0aW50IDEgbm9yIHRoYXQgYWxsIGV4dGludCBhcmUgQ1BV
IHBvcnRzLiBOb3cgdGhlIGFzc29jaWF0aW9uDQo+IGJldHdlZW4gdGhlIHBvcnQgYW5kIHRoZSBl
eHRlcm5hbCBpbnRlcmZhY2UgY2FuIGJlIGRlZmluZWQgd2l0aA0KPiBhIGRldmljZS10cmVlIHBv
cnQgcHJvcGVydHkgInJlYWx0ZWssZXh0LWludCIuDQo+DQo+IFRoaXMgcGF0Y2ggc3RpbGwgZG9l
cyBub3QgYWxsb3cgbXVsdGlwbGUgQ1BVIHBvcnRzIG5vciBleHRpbnQNCj4gYXMgYSBub24gQ1BV
IHBvcnQuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2EgPGx1
aXpsdWNhQGdtYWlsLmNvbT4NCj4gVGVzdGVkLWJ5OiBBcsSxbsOnIMOcTkFMIDxhcmluYy51bmFs
QGFyaW5jOS5jb20+DQoNClJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9s
dWZzZW4uZGs+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIu
YyB8IDEzNSArKysrKysrKysrKysrKysrKystLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
ODggaW5zZXJ0aW9ucygrKSwgNDcgZGVsZXRpb25zKC0p
