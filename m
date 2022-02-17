Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A78F4B9ABC
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiBQIRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:17:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237370AbiBQIRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:17:03 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60120.outbound.protection.outlook.com [40.107.6.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EA81A1337;
        Thu, 17 Feb 2022 00:16:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1y927wEOBM96vIGLBFKHb02mg7318yN/0/iVgBWGuVmAp8X+pQno+vVAuI853d4LiK5G/2yT065m1jFhQmZSSzyt0Sl9Jydjz0x1YO3iXhSFTeEbTTCPmK9FbP0aVaBdTgWng0N33lQqmSZhhZ1TT2pxasfv0XeopDt0ATr1JZaI0qZlbLbKIYyriIPJYuYGTODwDXK9XOaJUDR/Mm+/VKC/xWyfog+N3M+twBVRVvL5bxZ1mgjaCX/b2syIQeWifXiDh1qO/mhfOSG0d+GdnvLo4lJfc3V0KWehBHj0QF6ambGbGD06mjJIZZXwNByPQ0nXr8/mapncicoBbTpPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSooHHPrfSzgj0vkmYMphOczCgdBR7zN9c4D0vj/hTo=;
 b=bSaJL6GgVMKFQqr0hqnmQpNznQiCXK6R5JXpzXtl/3tG5/yLxeyBPpVvtf0y/2O/vUWedXDA85WEMxHOT1JWNLvFZlFdXIHBNDkhazM+ksQL6qgUfDlcT/UH54l8N3yt8YytfZ1F62AakifNvMi/xu8YOKynqx3xrrZiewkISvdnsZtanuB0rn58mTx3Y7AJ2zF6PrK17y42MLLKagleqbYhM8/FXijMwNeTIY9wbY+izsl0tLcOs5k6oW/6DQEVRtAUhOyaKQXkRdV3gxt5mqaFwl5Y53ZzQwXlkXON9svOASHuIegFXXdDhxOc1yVRmeSswvlTtDK41SZExR2O1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSooHHPrfSzgj0vkmYMphOczCgdBR7zN9c4D0vj/hTo=;
 b=GAxikW/W2ve+28wNeYGQ0Nq3IRDfRCY6TqTJrL19wnnYvTkBa9O1C723FZ6AYbsFnqdv94PIOZC4Hq4e6eQTwdbEodn/7S66MavQVfU4seTFf6DEeBGymmwmaraph76+KBshJ03l/FvCIbqBdpuXV9UPz96ea4etGUa58aYUntQ=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM5PR03MB2849.eurprd03.prod.outlook.com (2603:10a6:206:18::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.20; Thu, 17 Feb
 2022 08:16:44 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 08:16:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Thread-Topic: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Thread-Index: AQHYI07dxnVE+WkWDUK/DhqhBDRISw==
Date:   Thu, 17 Feb 2022 08:16:44 +0000
Message-ID: <87v8xdrjpw.fsf@bang-olufsen.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
        <20220216160500.2341255-3-alvin@pqrs.dk>
        <20220216233906.5dh67olhgfz7ji6o@skbuf>
        <CAJq09z6XBQUTBZoQ81Vy3nUc_5QGTF0GH8V-S3bXOw=JpYODvA@mail.gmail.com>
In-Reply-To: <CAJq09z6XBQUTBZoQ81Vy3nUc_5QGTF0GH8V-S3bXOw=JpYODvA@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Thu, 17 Feb 2022 00:01:45   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf3c94bb-35b5-4302-ec99-08d9f1edd5a9
x-ms-traffictypediagnostic: AM5PR03MB2849:EE_
x-microsoft-antispam-prvs: <AM5PR03MB284939BB93801D91F2AB93AD83369@AM5PR03MB2849.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: THjuHmw6zNymDnbhgtxPASqhdDYJ6s9LLXe+0KKYrd68AemWRVcL9wWWibMWCA2kPeenXHhvoQdxuh5YgUeqo+hoOcAXZIu3La988pRFAeRf7xxvB60/349aAUF/f12EOATHZ/6cNiIVdvfIOJx2G87zWTltE1L9vTFIo3V852mfqxEEdCigL2doLX36amiNAoQyTDW20Kyi7MoDmo6Hmf6OoPILZKzAn1CV4CrSE45Yg/ye2dX9HSbzDKtrNZyawArgiRdHzaP5PcLsRS5X4iTSnSNOGLhppvEvnTN1blUV7K743AelJMVX/mciKoM9UhFMADVafIj2eLI5Xv0KKqtUbMerqvhfGlgL34iSDlYBhNN08IbcQNzvXko0hvfJVHKu8xpAM9nmvO4Q6bruhURZJshHNrfaWfKCHhi8s5jj4kVP7i4VQMuGAHoyBVe7H3Y2RoL/QAFf/Kg1aWBX5dK7dOty7b8LL7taqArO0nq0FEfum+ePErP3X/KLr0cLtXe3/4y8Z6/r/wBR16NwjziFAGs3JC94ikW+kUIWE+JF25of8c855iWY4/eJyOycH4HRBRYlmGxEP84kpXyobV7KGl+SDZoRMIB6QxxPKRB0YDwPJFTyUigxh4Eezzk9H0ddvIRg3HAL197WdgMUEFyy59d4mP5mGA31R1xMetDZUK8qhF4xrXaw3YSA9yxgEV8fSTNDgi4iBGvkqdSiEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(91956017)(86362001)(2906002)(71200400001)(6486002)(316002)(66556008)(6506007)(508600001)(76116006)(6512007)(7416002)(54906003)(8936002)(2616005)(5660300002)(6916009)(8976002)(36756003)(26005)(186003)(66476007)(66946007)(64756008)(85182001)(38070700005)(83380400001)(8676002)(66446008)(38100700002)(4326008)(85202003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkxwdU9RV3FURHRjN2RvbjhLcWZaOEh3cGU1ZVlub09VQ3cxMzFnZTdyc3Bn?=
 =?utf-8?B?VS8yRlpVRzRPSG0xVzNuMXdyalk2K0lLZ0l2cktPQ051aC9YOTFObitaTDlG?=
 =?utf-8?B?anNCUTlyRmkrSlJONkhseEZtbnlFSnpTamdVOE9Qb2NvVlJ2Qis1VlVNcDJq?=
 =?utf-8?B?R1I0REhxRWpBYkZNZmtxdmdNYnpBUG9aNnZjQ3hNRyt3UndEUXcxc2hRaW9j?=
 =?utf-8?B?am9OVE9UVlNWU1ZrQXlqQjc5QjVnTGNmMVpFdkhVM2g2WUZjWll1YWN5cUJT?=
 =?utf-8?B?OVY3TGphNjQ1RmF4YjkrMUgzSU9QK3NWeDVLTUhsZmFrb0NVRzBSd3k2NDRN?=
 =?utf-8?B?YzZwR1ZJTHBHMzkrRTYvdFkzVmd4WnorWithS0d0RHlmL2dVNEdYUGFGejhv?=
 =?utf-8?B?WEhWdnNwSUMzeHRyUHAyaEJHNGkyeHA0OVJnaUpEY2FKOEQxZ3VqSmVmNTgw?=
 =?utf-8?B?VFRJM2lyTVVHZndYa3NkdEcyTWZ1WnlVazRrRDBKekVpS3RlcVpTb0VpV25u?=
 =?utf-8?B?VFZoOURoQ2ZLZ1dRWGUyK1dtU3FKWXltbHM4NUh2RGpvRHB3MjhZVFZNek1j?=
 =?utf-8?B?TTVkMlAxODFKOGJvYzhSc0xCTkJ3YnRNcXdGZ0lwdklzS0hxczVrbkM5RFJC?=
 =?utf-8?B?LzZlWm5DT25rQVFMMDZaTXJPaExHWFJLdzNkSkIwSGFyNy8wZGhRbWRrRFFD?=
 =?utf-8?B?VG5BWndFdTREbkJXc3FzcENSOXJKRGFHNEVYZFo3S1Q0SHR1bUFFNG1tRnd2?=
 =?utf-8?B?Tk9yOERZQ3k3aEV2by81K3FyRWxOck5wa0oyY2VYMTlNdmZuOS94SW0rZHd0?=
 =?utf-8?B?WjIxZnB0NkkrVUpmSEJER04xZUVXK29wdkZCaVo0Z2lqSUhtOTR3OFpjaUVp?=
 =?utf-8?B?dTIxTHkwVzJQU2J0eG0zVmw0Nk5mN1RlSm9NNzZHRFk5RDdmU01JN1dHMFUv?=
 =?utf-8?B?dUM3R2VBOThhK0NwVjJuWUZxV2M5Nnl0d0M1K1FmZ0FkN3FFMHF6ME0yQ0x0?=
 =?utf-8?B?OXZUVGcxd1IvTFNRa1hNUWFENmp0MUpmZXFMcmo4elhaVnFENTdHTy96cm44?=
 =?utf-8?B?T1dPM3VsNTMwbHdWRjZ4cWIxVkl5aWp1OG5LTjJSS3NtaXpnaGJ3eTlwdFB4?=
 =?utf-8?B?Y2c1RFlVcWxSSDE5MTh6U1IzaXNyQjg5NC94NmkwaDMycWxZZnVZV2twSmVV?=
 =?utf-8?B?TWVxNFhHUmd5VjJxUlNFS0hHc1gzT3Azd01XR0wrd29LYVJKUkdEUmV4clR3?=
 =?utf-8?B?NGNWb3RhSThvcWt1RlVZdmpzaXV5Z05lay9OSWRVeUNhUk50d1lydFlZY3Ja?=
 =?utf-8?B?SnVqeEI0WnhtZEpHak9reXVDTTRiYWdnRGhKbkRBd0NXN0RiNTltY1MzYW5h?=
 =?utf-8?B?SVV4aXFzcGxKdnY5MEUwTWNjSmo0MHlCTkJoeC80SXlpdGdYNXZ2cy9QaXEz?=
 =?utf-8?B?UVFrUUlBOU9lajZML3Y2Y0Y3Mjg0a08xSHpGb2tIWDRWcWIveEp4djRFRHlw?=
 =?utf-8?B?c0dmVjhlaTFCeElPNGwyd1lJdkRUQ2Qyajl4bkUwbWF6blc2cXBTUFlTN0hL?=
 =?utf-8?B?SGFBNDdTZlpXUzRYck5mL1lycEtldGVxK0pjUEF0L25JaXR2UFFzTTl6U3Jj?=
 =?utf-8?B?NnM2MWtnb0F1bURQS1hEUmU0YWxjNmVnWWhNVTJyVGx5SE9udnNMZWQwb2Fm?=
 =?utf-8?B?SnF3bTVXUkhMT28reEVwUXFIVXg3TmQ3bUtLTVJzNFRoTWlTV0k5clROODdW?=
 =?utf-8?B?NVU0Z000c1haTnE1VUJlSTBzekJHODNPZEEycUs0T1dDdWFjbUxROE51OHBi?=
 =?utf-8?B?YkZVdi9aR29PTHU2V2EvOXNsYzRSNXNJWFMwNHFYNlcrNGtxTmNnVEhlWkZv?=
 =?utf-8?B?SEgvYmV1aXA5SWhCbXBRTXIwdnFKL0dPNkxzeUNiSGZCN0lSL1Jmb2NFeVNJ?=
 =?utf-8?B?Y3Q5VWxqWUFPempjS0hOU0V0ZzdKODZoOUJ5aWZ3b1R2elBOdDFaRk1laFpZ?=
 =?utf-8?B?bER6K2ViSklkYThCem9ab2Njb3NMdFZFclRkeVFxeHdvbXNhSzV2N3VaM3dQ?=
 =?utf-8?B?cFZ2WlNINWh5WnRpT0ZYd3VuWENTMUpFN01rQWNBZlB5U1BYb0VpR3JwY2dX?=
 =?utf-8?B?M1E0cHJkSnZzenJ3N3VuVFUvdHVpVzhYTS9wR3pqOWFDeWJzMGsrRFY4c0ti?=
 =?utf-8?Q?b6aLbUv5yyDz/wLNTjToSGo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D04B77EBDABFD47B9F4F99337E5D6C0@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3c94bb-35b5-4302-ec99-08d9f1edd5a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 08:16:44.3080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /OLvlA/qdarRxOwQjr9Ue7Zct0DY05+DQAeQ+2O22bRmWcu6r1v+kU0Sovq6qEWMwZys9H9QRYk8OYwaRGB7DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR03MB2849
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gSGkgVmxhZGltaXIsDQo+DQo+PiBUaGlzIGltcGxlbWVudGF0aW9uIHdoZXJlIHRoZSBpbmRp
cmVjdCBQSFkgYWNjZXNzIGJsb2NrcyBvdXQgZXZlcnkgb3RoZXINCj4+IHJlZ2lzdGVyIHJlYWQg
YW5kIHdyaXRlIGlzIG9ubHkganVzdGlmaWVkIGlmIHlvdSBjYW4gcHJvdmUgdGhhdCB5b3UgY2Fu
DQo+PiBzdHVmZiBqdXN0IGFib3V0IGFueSB1bnJlbGF0ZWQgcmVnaXN0ZXIgcmVhZCBvciB3cml0
ZSBiZWZvcmUNCj4+IFJUTDgzNjVNQl9JTkRJUkVDVF9BQ0NFU1NfUkVBRF9EQVRBX1JFRywgYW5k
IHRoaXMsIGluIGFuZCBvZiBpdHNlbGYsDQo+PiB3aWxsIHBvaXNvbiB3aGF0IGdldHMgcmVhZCBi
YWNrIGZyb20gUlRMODM2NU1CX0lORElSRUNUX0FDQ0VTU19SRUFEX0RBVEFfUkVHLg0KPg0KPiBJ
IHdhcyB0aGUgZmlyc3Qgb25lIHRyeWluZyB0byBmaXggdGhpcyBpc3N1ZSByZXBvcnRlZCBieSBB
cmluw6cgd2l0aA0KPiBTTVAgZGV2aWNlcy4gQXQgZmlyc3QgSSB0aG91Z2h0IGl0IHdhcyBjYXVz
ZWQgYnkgdHdvIHBhcmFsbGVsIGluZGlyZWN0DQo+IGFjY2VzcyByZWFkcyBwb2xsaW5nIHRoZSBp
bnRlcmZhY2UgKGl0IHdhcyBub3QgdXNpbmcgaW50ZXJydXB0cykuIFdpdGgNCj4gbm8gbG9jaywg
dGhleSB3aWxsIGV2ZW50dWFsbHkgY29sbGlkZSBhbmQgb25lIHJlYWRzIHRoZSByZXN1bHQgb2Yg
dGhlDQo+IG90aGVyIG9uZS4gSG93ZXZlciwgYSBzaW1wbGUgbG9jayBvdmVyIHRoZSBpbmRpcmVj
dCBhY2Nlc3MgZGlkbid0DQo+IHNvbHZlIHRoZSBpc3N1ZS4gQWx2aW4gdGVzdGVkIGl0IG11Y2gg
ZnVydGhlciB0byBpc29sYXRlIHRoYXQgaW5kaXJlY3QNCj4gcmVnaXN0ZXIgYWNjZXNzIGlzIG1l
c3NlZCB1cCBieSBhbnkgb3RoZXIgcmVnaXN0ZXIgcmVhZC4gVGhlIGZhaWxzDQo+IHdoaWxlIHBv
bGxpbmcgdGhlIGludGVyZmFjZSBzdGF0dXMgb3IgdGhlIG90aGVyIHRlc3QgQWx2aW4gY3JlYXRl
ZA0KPiBvbmx5IG1hbmlmZXN0cyBpbiBhIGRldmljZSB3aXRoIG11bHRpcGxlIGNvcmVzIGFuZCBt
aW5lIGlzIHNpbmdsZQ0KPiBjb3JlLiBJIGRvIGdldCBzb21ldGhpbmcgc2ltaWxhciBpbiBhIHNp
bmdsZSBjb3JlIGRldmljZSBieSByZWFkaW5nIGFuDQo+IHVudXNlZCByZWdpc3RlciBhZGRyZXNz
IGJ1dCBpdCBpcyBoYXJkIHRvIGJsYW1lIFJlYWx0ZWsgd2hlbiB3ZSBhcmUNCj4gZG9pbmcgc29t
ZXRoaW5nIHdlIHdlcmUgbm90IHN1cHBvc2VkIHRvIGRvLiBBbnl3YXksIHRoYXQgaW5kaWNhdGVz
DQo+IHRoYXQgInJlYWRpbmcgYSByZWdpc3RlciIgaXMgbm90IGFuIGF0b21pYyBvcGVyYXRpb24g
aW5zaWRlIHRoZSBzd2l0Y2gNCj4gYXNpYy4NCg0KSSBuZXZlciBvYnNlcnZlZCBhbnkgaXNzdWUg
d2hpY2ggc3VnZ2VzdHMgdGhhdCBzd2l0Y2ggcmVnaXN0ZXIgcmVhZHMgYXJlDQpub3QgYXRvbWlj
Li4uIEkgbWVhbiwgdGhleSBhcmUgKGFuZCBhbHdheXMgaGF2ZSBiZWVuKSBwcm90ZWN0ZWQgYnkg
dGhlDQpkZWZhdWx0IHJlZ21hcCBsb2NrLiBTbyB3aGF0IG1ha2VzIHlvdSBzYXkgdGhpcz8NCg0K
SSBoYXZlIG9ubHkgc2VlbiBpc3N1ZXMgcmVsYXRlZCB0byBQSFkgcmVnaXN0ZXIgYWNjZXNzLCBw
bGVhc2UgZW5saWdodGVuDQp1cyBpZiB0aGVyZSBhcmUgb3RoZXIgaXNzdWVzLg0KDQo+DQo+PiBy
dGw4MzY1bWJfbWliX2NvdW50ZXJfcmVhZCgpIGRvZXNuJ3Qgc2VlbSBsaWtlIGEgcGFydGljdWxh
cmx5IGdvb2QNCj4+IGV4YW1wbGUgdG8gcHJvdmUgdGhpcywgc2luY2UgaXQgYXBwZWFycyB0byBi
ZSBhbiBpbmRpcmVjdCBhY2Nlc3MNCj4+IHByb2NlZHVyZSBhcyB3ZWxsLiBTaW5nbGUgcmVnaXN0
ZXIgcmVhZHMgb3Igd3JpdGVzIHdvdWxkIGJlIGlkZWFsLCBsaWtlDQo+PiBSVEw4MzY1TUJfQ1BV
X0NUUkxfUkVHLCBhcnRpZmljaWFsbHkgaW5zZXJ0ZWQgaW50byBzdHJhdGVnaWMgcGxhY2VzLg0K
Pj4gSWRlYWxseSB5b3Ugd291bGRuJ3QgZXZlbiBoYXZlIGEgRFNBIG9yIE1ESU8gb3IgUEhZIGRy
aXZlciBydW5uaW5nLg0KPj4gSnVzdCBhIHNpbXBsZSBrZXJuZWwgbW9kdWxlIHdpdGggYWNjZXNz
IHRvIHRoZSByZWdtYXAsIGFuZCB0cnkgdG8gcmVhZA0KPj4gc29tZXRoaW5nIGtub3duLCBsaWtl
IHRoZSBQSFkgSUQgb2Ygb25lIG9mIHRoZSBpbnRlcm5hbCBQSFlzLCB2aWEgYW4NCj4+IG9wZW4t
Y29kZWQgZnVuY3Rpb24uIFRoZW4gYWRkIGV4dHJhIHJlZ21hcCBhY2Nlc3NlcyBhbmQgc2VlIHdo
YXQNCj4+IGNvcnJ1cHRzIHRoZSBpbmRpcmVjdCBQSFkgYWNjZXNzIHByb2NlZHVyZS4NCj4NCj4g
VGhlIE1JQiBtaWdodCBiZSBqdXN0IGFub3RoZXIgZXhhbXBsZSB3aGVyZSB0aGUgaXNzdWUgaGFw
cGVucy4gSXQgd2FzDQo+IGZpcnN0IG5vdGljZWQgd2l0aCBhIFNNUCBkZXZpY2Ugd2l0aG91dCBp
bnRlcnJ1cHRpb25zIGNvbmZpZ3VyZWQuIEkNCj4gYmVsaWV2ZSBpdCB3aWxsIGFsd2F5cyBmYWls
IHdpdGggdGhhdCBjb25maWd1cmF0aW9uLg0KDQpBcyBJIHN0YXRlZCBpbiB0aGUgbGFzdCB0aHJl
YWQsIEkgdGVzdGVkIE1JQiBhY2Nlc3MgYW5kIHRoZSBwcm9ibGVtIGRpZA0Kbm90IG1hbmlmZXN0
IGl0c2VsZiB0aGVyZS4NCg0KPg0KPj4gQXJlIFJlYWx0ZWsgYXdhcmUgb2YgdGhpcyBhbmQgZG8g
dGhleSBjb25maXJtIHRoZSBpc3N1ZT8gU291bmRzIGxpa2UNCj4+IGVycmF0dW0gbWF0ZXJpYWwg
dG8gbWUsIGFuZCBhIHByZXR0eSBzZXZlcmUgb25lLCBhdCB0aGF0LiBBbHRlcm5hdGl2ZWx5LA0K
Pj4gd2UgbWF5IHNpbXBseSBub3QgYmUgdW5kZXJzdGFuZGluZyB0aGUgaGFyZHdhcmUgYXJjaGl0
ZWN0dXJlLCBsaWtlIGZvcg0KPj4gZXhhbXBsZSB0aGUgZmFjdCB0aGF0IE1JQiBpbmRpcmVjdCBh
Y2Nlc3MgYW5kIFBIWSBpbmRpcmVjdCBhY2Nlc3MgbWF5DQo+PiBzaGFyZSBzb21lIGNvbW1vbiBi
dXMgYW5kIG11c3QgYmUgc2VxdWVudGlhbCB3LnIudC4gZWFjaCBvdGhlci4NCj4NCj4gVGhlIHJl
YWx0ZWsgIkFQSS9kcml2ZXIiIGRvZXMgZXhhY3RseSBob3cgdGhlIGRyaXZlciB3YXMgZG9pbmcu
IFRoZXkNCj4gZG8gaGF2ZSBhIGxvY2svdW5sb2NrIHBsYWNlaG9sZGVyLCBidXQgb25seSBpbiB0
aGUgZXF1aXZhbGVudA0KPiByZWdtYXBfe3JlYWQsd3JpdGV9IGZ1bmN0aW9ucy4gSW5kaXJlY3Qg
YWNjZXNzIGRvZXMgbm90IHVzZSBsb2NrcyBhdA0KPiBhbGwgKGluIGZhY3QsIHRoZXJlIGlzIG5v
IG90aGVyIG1lbnRpb24gb2YgImxvY2siIGVsc2V3aGVyZSksIGV2ZW4NCj4gYmVpbmcgb2J2aW91
cyB0aGF0IGl0IGlzIG5vdCB0aHJlYWQtc2FmZS4gSXQgd2FzIGp1c3Qgd2l0aCBhIERTQQ0KPiBk
cml2ZXIgdGhhdCB3ZSBzdGFydGVkIHRvIGV4ZXJjaXNlIHJlZ2lzdGVyIGFjY2VzcyBmb3IgcmVh
bCwgc3BlY2lhbGx5DQo+IHdpdGhvdXQgaW50ZXJydXB0aW9ucy4gQW5kIGV2ZW4gaW4gdGhhdCBj
YXNlLCB3ZSBjb3VsZCBvbmx5IG5vdGljZQ0KPiB0aGlzIGlzc3VlIGluIG11bHRpY29yZSBkZXZp
Y2VzLiBJIGJlbGlldmUgdGhhdCwgaWYgdGhleSBrbm93IGFib3V0DQo+IHRoaXMgaXNzdWUsIHRo
ZXkgbWlnaHQgbm90IGJlIHdvcnJpZWQgYmVjYXVzZSBpdCBoYXMgbmV2ZXIgYWZmZWN0ZWQgYQ0K
PiByZWFsIGRldmljZS4gSXQgd291bGQgYmUgdmVyeSBpbnRlcmVzdGluZyB0byBoZWFyIGZyb20g
UmVhbHRlayBidXQgSQ0KPiBkbyBub3QgaGF2ZSB0aGUgY29udGFjdHMuDQoNClRoaXMgaXMgbm90
IHRydWUsIGF0IGxlYXN0IHdpdGggdGhlIHNvdXJjZXMgSSBhbSByZWFkaW5nLiBBcyBJIHNhaWQg
aW4NCm15IHJlcGx5IHRvIFZsYWRpbWlyLCB0aGUgUmVhbHRlayBjb2RlIHRha2VzIGEgbG9jayBh
cm91bmQgZWFjaA0KdG9wLWxldmVsIEFQSSBjYWxsLiBFeGFtcGxlOg0KDQpydGtfYXBpX3JldF90
IHJ0a19wb3J0X3BoeVN0YXR1c19nZXQoLi4uKQ0Kew0KICAgIHJ0a19hcGlfcmV0X3QgcmV0VmFs
Ow0KDQogICAgaWYgKE5VTEwgPT0gUlRfTUFQUEVSLT5wb3J0X3BoeVN0YXR1c19nZXQpDQogICAg
ICAgIHJldHVybiBSVF9FUlJfRFJJVkVSX05PVF9GT1VORDsNCg0KICAgIFJUS19BUElfTE9DSygp
Ow0KICAgIHJldFZhbCA9IFJUX01BUFBFUi0+cG9ydF9waHlTdGF0dXNfZ2V0KHBvcnQsIHBMaW5r
U3RhdHVzLCBwU3BlZWQsIHBEdXBsZXgpOw0KICAgIFJUS19BUElfVU5MT0NLKCk7DQoNCiAgICBy
ZXR1cm4gcmV0VmFsOw0KfQ0KDQpEZWVwIGRvd24gaW4gdGhpcyBwb3J0X3BoeVN0YXR1c19nZXQo
KSBjYWxsYmFjaywgdGhlIGluZGlyZWN0IFBIWQ0KcmVnaXN0ZXIgYWNjZXNzIHRha2VzIHBsYWNl
Lg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
