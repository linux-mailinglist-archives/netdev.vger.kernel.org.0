Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD344AFF3E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiBIVeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:34:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiBIVer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:34:47 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38EFC0045A5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:34:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/U+ycPNeht/0MLgt6y3WLfxBjYxRCOAYLSNh/OpuDY5Fx43Dz5Ty3j174SAEGqLjc9PuOsB6rX371ZveBYBLh/RYmEMmC7iBMdfl6rPKZRXyEwRmDQMwUswokWfZnFImzvKNr9qzmTz4PSv99KxLBBDS9C2XhGm97j49vrg8LdLBd/taYfddvCa8CLUQFmQjmC9dLqB/dyz7kSRw3OuqGcJNyiAWeMQuBtrOpTXVZPXDrPp2f/dP0SrfEWqueWPO+DChm1S60VFf7hYSkJMRHuWXI2kqYBJ+pRTqQJg11I3SIIpLiYCubOM1evsGi/WNsGCUZC1cQO/MMO4iYRYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCpbwlzxnIwYLw92oESZc5fO1JZZuu6786yhekpiv04=;
 b=EBochCUeTklkQo8pGuj0ylFhVP67ITCfPeX9Tt44WuuCTWRU+gkQ3J2vq/jkRYjb3ewADjHy5sEqsDvzwNh3wQum1ZvFp2orBpa2Wf0VhVkopxUHn8FQEf0jjCCWUA7+jqcBbBoWGeeXnkRspwb8+4DYPK95lK8HIJGBi2y3nFNa4jqdZpXkltIfA4g5igNe6eD+J9oxKQvtEfQpxxgd5mh7fi3bb1dJhEya3r1FVcC9jVeBsdzu+TsiQR8whGa13mvno7OXtxopsNBPoVqGLemcAdVDVD1kHiN3Gh6SYZom/ZvguOCgTpMawHxKVpzpkGeWqxKlAR1EX7WS1GZqTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCpbwlzxnIwYLw92oESZc5fO1JZZuu6786yhekpiv04=;
 b=KGlJATXhDiNHS/iftOyLCQSTQE9oOulTgz48p5/SZtMJxCl8d7nW4Mnm2XopaQ9aO0MEdm5p+4cFq+sLCx7JreK8obdSCaxMYDfSnzmWhhJsetRdLVPZQRw50HW/Xb3vPpZdh9RySteNVRl4ZTpHWOBd3wsPGlP1h5B8UAblYj0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR0302MB3297.eurprd03.prod.outlook.com (2603:10a6:208:c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:34:46 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:34:46 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: add rtl8_4t tag
Thread-Topic: [PATCH net-next 0/2] net: dsa: realtek: add rtl8_4t tag
Thread-Index: AQHYHfn6fbumxdxpa0iljSxNW4mBBg==
Date:   Wed, 9 Feb 2022 21:34:46 +0000
Message-ID: <87sfsrhgg9.fsf@bang-olufsen.dk>
References: <20220209211312.7242-1-luizluca@gmail.com>
In-Reply-To: <20220209211312.7242-1-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 9 Feb 2022 18:13:10 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6828b7a1-6023-4187-066b-08d9ec13fe5b
x-ms-traffictypediagnostic: AM0PR0302MB3297:EE_
x-microsoft-antispam-prvs: <AM0PR0302MB3297D8583943ABE5EAC812C8832E9@AM0PR0302MB3297.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNI91hu0Cyk4sO+hFU4mvUt1t2w3eBa4in149l5bSwVgYiOuC67+CPZMnsnEqWJGdY3EwW8gGPhE08/XE8CIRVZb7D+pNZ0YNIMJQzaQl0nC0ZDpeFndeiGw2cS3zGWExBV7FrlQ0DJxUjg3B7vyFv3CFdv2P76uGvwb14z9IBG2Ebv0vPde6BnSIdss2HGBXcFmP/uONvYv34WG32DpXaI33pIVwUGvstfat2tdlGDGOd1TLOxdL0wU4dS+Y7FvADHovgAiQPijPxvWcl83fORR26X0tWFhUP17e82sg7JEcdpS2Ws3cPbBQsAgj+OzPu39Rjl63CL96QaVuIkqgx+CGOnwBeZWn8YKe0Z4F93P9HNvjSQ0ha6P1dCYHP2fqsTgRUI8FxiC5O0pIVNz4rPN3MNTchvte3EGiEZhItrz3MwDiWtLFLPLSS+x0uf1pINhGbYjrIpoV02iAZ2/VJmNsgFJMesrJSGSi5VDQlghpXgXaNAcr+NcGCVEvXWz0o8M1Lz92nZcmal+WaAGDQp12K7XIEEvSBNabAgceqmklkcKvE75E++1tfyyhIcMrFqUWZ926+NwUHBpoRyFn57LmOKGrmNQu58qTprygpFRArEiEDC/YrDvSS7sFTIzb5xN3XE7DF/T1HePcDrZ+89XVZSMlK/IjHPOw7lkgufMgXYrGHdE9KsgZpVcBLzq52sEQ3aTc1eWcR/gOZ4Dfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(85182001)(83380400001)(5660300002)(36756003)(4744005)(86362001)(6916009)(7416002)(122000001)(26005)(6486002)(2906002)(38070700005)(66446008)(8936002)(316002)(2616005)(91956017)(6506007)(85202003)(38100700002)(76116006)(508600001)(54906003)(66556008)(64756008)(71200400001)(6512007)(66946007)(8976002)(66476007)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVBsQ3phSmxWVUxjZkJ4T0FYUHRUSkd0aTNvRlhQQTNHazB3OWk2Y3E4WXZF?=
 =?utf-8?B?Z2R5dmZUNkVxK3NIT2dvYWRVODVSekRhUVVMTmxDRm0zdTdPNk5zVGZDV3JH?=
 =?utf-8?B?bmQzSHg1Wm5GaWZZZE9rSitOWTVsMk80YUVkSFJOR0Evc2F4Q2VGdUxtMFhl?=
 =?utf-8?B?WStOYnErYUN1YStMT1Z5VlYyZWxrdEYzQ3RaRk1DY2k3dHdjUTlYYzNGYWRR?=
 =?utf-8?B?bVFkdXFpOGdRQUZ0Y0duR0psZlQ0N0grUGtxYzQvTWZKc21kWHVFK2FUSm9I?=
 =?utf-8?B?NjFKdzVDQkxUZkpFZDdqblhjRGNFbm5Sb2FiTWVIMWl3M2F0c1RJckRjbGhZ?=
 =?utf-8?B?NjJ4RnBiWm1JVVhpQUJpMi9rTjdBZFZrRjhZVTlqcmhQdnBpbVQ1S09GL2dB?=
 =?utf-8?B?bDB1MGpkZU1ZbUdzMVZ2SjNUeGd3elNSemFsN01vSlFjTzFBSWFQUFJxWWxk?=
 =?utf-8?B?Q0hLL2VIcFhnQWVNd1VFSm5GbjRyamJzejgvWlBha1d3RmRxS2lndGFGV1gr?=
 =?utf-8?B?bFJ2a0NFZEQ0OTZqaDdCWnBGdVd6S2ZncjdxK3AwZi8xYUdma21hZ0pWMnpv?=
 =?utf-8?B?bkF3M1Qycm9ZWEsvMzNNaUtYT1FDd1g5bk5ITjZhOVRRRDZNVlg0eHRKRXJa?=
 =?utf-8?B?Mzh0ZkUrWjlZN083MUF3TW9TMmdLL00vZHQ2cnJIVFdkT2R3MHFqZnJaVFYz?=
 =?utf-8?B?L28xOFhoUHp5V1BGdExtNlZWbWtlZUdoL0dlRnBvVENVU2JORisvUXRtTnN2?=
 =?utf-8?B?aXRYc0ZCdjR6enB6ODVrdERBZ2ZWVmxqVlJRSVlEMzVEZFRpMDUvT2hpL0Rp?=
 =?utf-8?B?aTVDMnVmZlZ1d0p3ekZtYXhMT2g1TmRjN1IxMUpkbFFSSVlhWWVncFplUDBS?=
 =?utf-8?B?SU42ZmhDclFRNmE4YkNVeHJiaWVFcmlOYVJNSHVxZnppdXdvYTU1akNhZ1ZG?=
 =?utf-8?B?QzVRMU9SWGtxaUJQMXQ5TzFCb1dCeGNQYW44N2s0WTZjRmJUS0JldzNoN29I?=
 =?utf-8?B?Y0s0UnNvTVJSRlE0d2ZKc0NUalRYK25RVzVQSXhSUU5JSHgycmt0eHl5KzVv?=
 =?utf-8?B?Y05Sbk0wTFBaSmFYY1ZINHVJRkdWd25wZ3A2a2hDNU4yK1ZvV1l4NUNCbnh2?=
 =?utf-8?B?Zm5vTE84REVtZkRiZWcxR0VVYndmUUJvK2RxcytXWXFuMkFScXNKRkpmZkZD?=
 =?utf-8?B?VDlZbnlCZWprUlpPMFpHQnpQWnl3OFR0ZFNQMFFCMGtIQzBkZFVuZVkzSWE1?=
 =?utf-8?B?ZTJtTTdDVWpEQmJEaWZUa2JVTUhkVHRlWHFwSll4TllRMThSeE5MSWVFT0dr?=
 =?utf-8?B?MnBxbzBvdXVFdjRSeWMralU2YzByYmk2R0RVL0hKZis2b2RaaXR0SjFDbW9q?=
 =?utf-8?B?U0szdGVwTFFQbWVMa1c2UzJiT2VZYnVzQ3VaOVhzNXp2QndIUWQ5YVovYmJF?=
 =?utf-8?B?bUIwaTBTL3BsNiswLzY1UW1aL25jbmV2QmJ5ZEJ3eWJGajVsWWlHLzhITEM3?=
 =?utf-8?B?cWJVYjdxbWRVbFNUeVY2REE2YmJ1cGVob1B5WkwzVWRtN2NxSzRjLzF5SG9t?=
 =?utf-8?B?RXRZYmxtUG4zZ3FPb2RwODBDVThDQnlQSG1lV1RkRXBZbnhIWHBZOUVKZDBl?=
 =?utf-8?B?MXBwaENsUVpjazRlalM4YnJTVVJUeU8yck0zSngwTGZTL3QyK2IvblNwVkVk?=
 =?utf-8?B?UmJJM2tWbkIyS256NmtqY2poMWtsOXVPTzU0RUwzT1BtZDFDOUh6dFhpV0I5?=
 =?utf-8?B?WDNWaDQvbHdXTXVTWlpvenhPUW1yeG8wak1nVm9oeU9NK2E0Z2IrNzFXMlFY?=
 =?utf-8?B?SGVpaFJEWitmY3U3QnduaWJVdlZLcG5HMDZ6VEdhWmVvTDBmZmZlZlcxc0hD?=
 =?utf-8?B?TFo4Njk4ZDYxOHh6eDhteVpnM3JxOFNIbDlpNkZ5L0J5dkwxcGhWN3AySW4w?=
 =?utf-8?B?ODV5SjZ6eVQ1cmNmT2Fha1hJaWl2WThyR3NwOVo5RDhxbU85K0lBSEY5VVZ5?=
 =?utf-8?B?ZVN5YUVlTngvYzVoekNES3puSEJyZVpEM2g5WHdha1ZrNk1vZklHdDVvQlBU?=
 =?utf-8?B?OS90c2ZXeDI5MElSMzBSSTJBNGo1cFk0eE1zOE1lN2VSVmluTVlpelkycERq?=
 =?utf-8?B?RFlzTFZWMmt0RXRGOG9OamcrczZMdURPS2RlclJkdnBld0s4NVlmaTByakU2?=
 =?utf-8?Q?NQ3vXc3sAuLRprLPMnC41dQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <128EBFAEDB6848428505DC6B13AB12A3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6828b7a1-6023-4187-066b-08d9ec13fe5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 21:34:46.4610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hZzMVt6AkvC9h2z5jHdU+s0g5wpO/X8IZHTSVbZ8aY0QxP9U46PDG+ZwIL9Pf4WKWrtzQ0N4q1UWpxbMMoi/mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0302MB3297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVpeiwNCg0KTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29t
PiB3cml0ZXM6DQoNCj4gVGhpcyBEU0EgdGFnIG1pZ2h0IG5vdCBiZSB1c2VmdWwgaW4gcHJvZHVj
dGlvbiBhcyB0aGUgY29uZHVpdCBkcml2ZXINCj4gbWlnaHQgZ2VuZXJhdGUgYSBicm9rZW4gY2hl
Y2tzdW0uIEl0IGlzIHVzZWZ1bCwgdGhvdWdoLCBmb3IgdGVzdA0KPiBwdXJwb3NlLg0KDQpZb3Ug
bWFrZSBpdCBzb3VuZCBsaWtlIHRoZSBjb2RlIGlzIG5ldmVyIHVzZWZ1bCBpbiBwcm9kdWN0aW9u
LCBidXQgaXMNCnRoYXQgcmVhbGx5IHRoZSBjYXNlPyBBbmQgd2hhdCBraW5kIG9mIHRlc3QgY2Fz
ZSBkbyB5b3UgaGF2ZSBpbiBtaW5kPw0KDQpBbHNvLCB5b3UgY2FsbCB0aGlzICJ0YWlsaW5nIiB3
aGljaCBzb3VuZHMgcXVpdGUgb2ZmLiBEbyB5b3UgbWVhbg0KInRyYWlsaW5nIj8gSSB0aGluayB0
aGF0IGlzIHRoZSBtb3JlIGNvbW1vbiB0ZXJtaW5vbG9neS4NCg0KSW4gYW55IGNhc2UgdGhlIHNl
cmllcyBsb29rcyBmaW5lIDotKQ0KDQpBY2tlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFu
Zy1vbHVmc2VuLmRrPg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
