Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EF04899E9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiAJN00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:26:26 -0500
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:27552
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231574AbiAJN0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:26:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mpe83iYKznlkdsHq72oFHKrCsB8/POxG4kJvdDkEMUfhmniZH63XS2+yUhy1GL9mnEX7mHCc3qgH3uCpGiPsobwcUXaFkDgAE1vMGVPY/ZOcQrd1kGP9d8W9JvSJm3saaxpQOalywPcNlCA/CReSUPsyxXDdItxKnqJGG78/oHbIOJQZ6rR4+movi7tzTyBtqzGRFD+OCE98JPEDiIJmYNOPzKF36m97ZuijwVSDE4kDsKBSp1qcxoQ/TMjFhqx3JAZumdYhkzmSNwHAHLzc3/ykCpNH6WaRcPZN63J5oGO9lBZWD9MBRQZ7lywvgXIzMDy8S2+ZoaCiJC/U2JyHLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SH5c316rUCLMLMUXDaLfmhozwpZ2bMZ5Hit/g6UWlt0=;
 b=ksRjZ8y5hdIPbEpwxvfgq2CBIE+gbS+76022O4uZET4ryB7tGud5OLJNTCT0wH22x1BYVsSqOKWqH5K+LSNKBlE8o92S87QZC2iQSHDw2OCd5/ocjxgt7u+T846Slk0ue23YRkwWKYUHJdrxk+HStEmyo7EL0k9KKCJoVqrFkpvQLyqWY3AYHrDnNQMRVeeoQ/S3FL+5seHY1fzIKOrsgciyczkViSr50GYpbLPr0YfgmqZsB5zAefOugNL2x0nuMSnJZMpmFKNBCDDI7mwdkcjCGvEZI9ACfIxxsYPXTy2bxyy41VR06zE6blhmK74H4HAH14MexlYXJEfq8rvUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SH5c316rUCLMLMUXDaLfmhozwpZ2bMZ5Hit/g6UWlt0=;
 b=dpBNyskuyX1iRhS/QlxwY7I1m9uZ1aW+6D56xvuK5QzYVo3GBn/5Jl05SjLrMxzBH87N7rEb72KjnXcCos+4szNnt4j7ihs+53eqdfkBRLe+q1Wcmw98s7QgXhA8FCZHwyvykC9Fay4HS5quuuOsRPGImhATw5EH2NtUcNLbtWI=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5235.eurprd03.prod.outlook.com (2603:10a6:20b:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 13:26:21 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 13:26:21 +0000
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
Subject: Re: [PATCH net-next v4 10/11] net: dsa: realtek: rtl8365mb: add
 RTL8367S support
Thread-Topic: [PATCH net-next v4 10/11] net: dsa: realtek: rtl8365mb: add
 RTL8367S support
Thread-Index: AQHYAeKbzhJ2ADPOH0qrTIJVUfodmw==
Date:   Mon, 10 Jan 2022 13:26:21 +0000
Message-ID: <87ilurd8n6.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-11-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-11-luizluca@gmail.com> (Luiz Angelo Daros
        de Luca's message of "Wed, 5 Jan 2022 00:15:14 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ed1faa7-c2fa-499c-64a8-08d9d43ccae8
x-ms-traffictypediagnostic: AM6PR03MB5235:EE_
x-microsoft-antispam-prvs: <AM6PR03MB5235395A5FE2D52C8AF1AE6C83509@AM6PR03MB5235.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uwdhdVdLCTXDmfBXB7xkq+OVz8ntQHoIgLs6riq9ow+NwnL951QE3njI006v7BuOEeSn8I0bvzm6DFI9lGgqzHfUctyBhPWF2u8QoJsfezxR1UkU/Y4s0Ebh12LcOz3Qf0i4fj4cHruX2NpItl7yQaYko5NRFFQS4POxBkxWJRRZEOQgPTLVIGQrkJNTQWPs7I1XPpAHbyvqNSlRFqrk2JJCZxx2k3dr4dh6qZc1Q4zaFW4EDPoDc2Gznt1mx+5vXXZfRgvgUpF2+5WmfjLo4k1/lzfXyi8CMzL/sW9DRoR+eWSb1prbq2Wlx7sFEJsEILRdS8v5wu090OX+RYmmoFKioac1O1wx/wHt/iqciS3of2n5QUUicstf4SdTjJ67/1R9v0oRCNT+dWaZ/UGy10EzoEhHPWv0QRtU7qv+QipIVKc/XCjfT8eFJC7YuSpnSIAZ5z+BbhD0DMCLQ3V5ZklH5zbIdlrUXvuFGLpPrZ4g8wX0BntPiJGgm/xCZcZC06vhHqMUxTbN1IoiN4rOwvUMTZfQJBXBzkxBak73opz7otNLGJVtRBNyfLok+hGdDGADSE+oghEqGR7JntyLYO2YwBoFWJuJ0BF8wdzXIiX3gfAyhoyINhY+OTA6i9kA4/ZWGEmbzptxlzBB3MOq4Zm/iIFbgkqZ0254s3+PB4HHOgmO/JN41OcT4tcEXB82KUYNw/8k+ruEUaPX6MQKJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8976002)(8676002)(6506007)(508600001)(38070700005)(8936002)(85202003)(316002)(2616005)(54906003)(6486002)(186003)(26005)(71200400001)(6916009)(85182001)(38100700002)(122000001)(36756003)(86362001)(76116006)(4326008)(6512007)(91956017)(5660300002)(2906002)(66476007)(66556008)(66446008)(64756008)(66946007)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0xsWmQ0SlNVY0MrNGNmYlRSOSt5TTVNdXdlRHpqR01yaFFyeEVmSmZYbHZG?=
 =?utf-8?B?ZmtCWnBQMUhrVFFlbUxOUWNYTHNjUmg0amxyM3lnbHM5SzJybGlaZ0hjV2xE?=
 =?utf-8?B?RnFzZU13cERqQm4xc1VEcWJITTZsVXRGUWE1V0oyWS9mM3NscXRTYmFHbWlT?=
 =?utf-8?B?QTk1L3d2TVlnb0VFdVpIeFJkNmJ1U2JtVU8wcEdVUTVaMXQveFZLRXBuelZB?=
 =?utf-8?B?N2xJbzdBMkZmVVJMQWpabXpWYngybng1OVlNdTNZU2xHMzBNRVhRM1pqV1lW?=
 =?utf-8?B?TVd4eDBEVzh6Y3dXSldWYWo4VTRianJQQVNYUFZXdk9heXJuN3ZqVSsybWQ5?=
 =?utf-8?B?bGt2UVBhME5rRUtTTERsRlVPWG5iUTByV1A4a2dWdFluU3FuNUl5ZlRZTnpn?=
 =?utf-8?B?TEZBMXJVcG0xemtyV0JrMC9FTUMxY3czZkJ4dmtKMFM4eTBnTG45K3A4S3ZX?=
 =?utf-8?B?akZYbVFLOVQyWEYxc0lMZHQ3Z2hPc0RWamM0NTE1ZUZMbUlTUitkWjJxdXJ3?=
 =?utf-8?B?b0ZWdzBKSUlJdDlhcEpoU3Nybll6OW12UU00anJOSUlwTmdyT0Q0RStKZitI?=
 =?utf-8?B?VUJocUR5QkFnaEFncVVTbjZ6NDhFYjVPd3BURTg2S0Vud09MdUU5Z3ZTSnpI?=
 =?utf-8?B?amp2b3lEbzk1N3I4UWVUMGpnekhMVWRxaER3dTdhQ2pJRTMvWXBOY3BJcHlU?=
 =?utf-8?B?RENsNTlPdGJqeVpycmZCK3BqNVZBaHZ3UmhpZEVYL0YreXhKQS9JOWFKdzhV?=
 =?utf-8?B?bHdzbldNSmlvOFQzUXVDOEp3YW10TTZDUjVpaHBFNVY2VFY5eTRTaVpnazdy?=
 =?utf-8?B?ZXNUaG1GbDBncWI2UFVVejRkMThGdDV6Z25NVVN2bU5QdmRYbTFkM3RaeHhs?=
 =?utf-8?B?MXBlVkhtZVozL2dvTG54bTN5S0VoY2pGVktkcGlLU1pLTWFBZ1d4OHhsT1h1?=
 =?utf-8?B?WXEycDhRZ202eUZUS0JmcDdlcmcwM0luVk5Jb253c1U0aFlNLyt3cmJKdW5v?=
 =?utf-8?B?QmsrOTlOS29kMldlcHRXdXhHanRVQ1ZISEVhK0hpWis3UXNac2pjeVl0aGtI?=
 =?utf-8?B?Ly9wK25PenM3WDNFelN1a2R1OHhzTUZTdjdzZmF2VUlwTzEzREpiVnpWa3hD?=
 =?utf-8?B?cUdzTFVma015ZkpFVVpxRkxyZVZ0ZE53ZTlKRWZLWTBlZm84THFRVmc4QXFt?=
 =?utf-8?B?UVY0TmwrREhsZ3JxRXhKSnpCTzkzU0NBSkJmVnM2QXcxYi8yZ3VzRUxqc3k4?=
 =?utf-8?B?V1ROOEY1RzBuQTFCQmpkUU5aazJPeG9teGZBdXZFM09aa3UzNWliY1lTcFc4?=
 =?utf-8?B?NnE2N21DZzFDMFBVRTgwdUxTcmlZYndtWFlJdTRtTG4vaG1ab08vRFFyV1BY?=
 =?utf-8?B?Yy9nbndHd3JSeEVMOWRFb1dqY2RQdjB5cnl6cnhoUG9JUllFcnFEd1Z3aDZK?=
 =?utf-8?B?UWVGWVZlTFEvanhiTDZKSnptRUVHSnZXVEhINnVRS2FEUThXdUVFOTVDMHkw?=
 =?utf-8?B?Sjh4Sm5vK0VOVTZsdjZYdHZXSDZqR1loTTNwMlhkUFg3SGprQ0JST01jUXh2?=
 =?utf-8?B?OVhUSFgyRWdyTjdUVkpkUjRCempFbmhuSnBGaVpMRm9lUjJNUi9IWnFYczJ0?=
 =?utf-8?B?TnJHdis5TlFiNzA2Rzg3V1dTakVXTmIyaVVscWZZL29IdTJXNzJjTTlZamhN?=
 =?utf-8?B?VkZhZVl1QXJiTnczUEVJQm9TSHlDTWllSFcxQmpnRmVPNzUwZHJtODdwc2g3?=
 =?utf-8?B?ekFaUllwbnFVbWRyUkRYMHdKUWNpaHNHWUhuQ0tOaWpRTDFZR3Q1ZmsxNkxG?=
 =?utf-8?B?OTdBOGdXbU85VG1NYzFjQ1lJRFRrc3FPZ05Yc3JiS1g3NHVRM2NISnlRM3Q4?=
 =?utf-8?B?UWdBOWlWSSswWXZNRkhBVEdqNzI1cnFGUXZFbWxjSGRCUGtqbWdUQ2dxM2Nz?=
 =?utf-8?B?RjU4eTZaSVFTN2xReE1NbmxMenJkU08zWDNvaXRLYmJPQTFpSlBjODRPdkRL?=
 =?utf-8?B?NHFFVi9vSnpSaVo1dkVlUzhNaWFXcTI0My9rNkhRdDhId0Z5alpBeWZ6RUYv?=
 =?utf-8?B?b3lINHJsK0tsaWhyQVlHN3lpd1dvUnl4NEN4ckpKc1RyZzlCRzd0dDEvaDk4?=
 =?utf-8?B?cVRxTERoMi9QdEVPNTZkYUNqaHNDb05XSjNycXZYd2gyMTRFRFRXQ0MxT0hq?=
 =?utf-8?Q?k1qIGxBNEZtGJoaS75cFwk0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <037BCE685906B84CA2E4B20D9B049E4E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed1faa7-c2fa-499c-64a8-08d9d43ccae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 13:26:21.6364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5PneWb2ObxR7z+cYvXJRXwxAa2KSfTMo9fSN2GPTBXvzW0Vgc5wdLIEgr30hcvx5xFUy8kVJHRGYdKTo60A+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5235
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gUmVhbHRlaydzIFJUTDgzNjdTLCBhIDUrMiBwb3J0IDEwLzEwMC8xMDAwTSBFdGhlcm5ldCBz
d2l0Y2guDQo+IEl0IHNoYXJlcyB0aGUgc2FtZSBkcml2ZXIgZmFtaWx5IChSVEw4MzY3Qykgd2l0
aCBvdGhlciBtb2RlbHMNCj4gYXMgdGhlIFJUTDgzNjVNQi1WQy4gSXRzIGNvbXBhdGlibGUgc3Ry
aW5nIGlzICJyZWFsdGVrLHJ0bDgzNjdzIi4NCj4NCj4gSXQgd2FzIHRlc3RlZCBvbmx5IHdpdGgg
TURJTyBpbnRlcmZhY2UgKHJlYWx0ZWstbWRpbyksIGFsdGhvdWdoIGl0IG1pZ2h0DQo+IHdvcmsg
b3V0LW9mLXRoZS1ib3ggd2l0aCBTTUkgaW50ZXJmYWNlICh1c2luZyByZWFsdGVrLXNtaSkuDQo+
DQo+IFRoaXMgcGF0Y2ggd2FzIGJhc2VkIG9uIGFuIHVucHVibGlzaGVkIHBhdGNoIGZyb20gQWx2
aW4gxaBpcHJhZ2ENCj4gPGFsc2lAYmFuZy1vbHVmc2VuLmRrPi4NCj4NCj4gU2lnbmVkLW9mZi1i
eTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiBUZXN0
ZWQtYnk6IEFyxLFuw6cgw5xOQUwgPGFyaW5jLnVuYWxAYXJpbmM5LmNvbT4NCg0KUmV2aWV3ZWQt
Ynk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4=
