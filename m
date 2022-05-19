Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35E552D6B6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbiESPBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240355AbiESPAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:00:15 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E4CEBEB1;
        Thu, 19 May 2022 07:59:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3//GLyYYLy8KAsNI8bJwiKz2msvym/8CpEuY2hzVkCF+XrgudJzdWWBMk77aiI9ILvDlq5qVTSOYgRMQfbSr+8vWJqRwYk6w04JFuuRNInyYqtDFqFvhnpzJ46zeOYN0WufUofvif856UjGeQjpR22ftiBegrNrY4OGORXKGiz+r0DRkp+RTnq+u/ABhu+P+kBrYBG4u/ndXqL7G7YWbQQhw0Vws/UXxyT+/FToVCrldz/CNeaR0In+YG3etoVQuGhVoIazfBkJuPVdRxrzBgBXScOoOQSGe24vvfOrGTi5M1xBCmCOkrNA2oo82Yo79fqK+rCimDh3nj9CtD3bvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNnuyQj3aCvUr8U8HwismnBYei0fxlXTHlWMaKV0u7Q=;
 b=PSt6aAWQmieESnObzus/X9QUXHzow/o42M6ozXDKNUHrdx/b+xcHhxoFvfipHJIM86oKIWhtg5yiBkIkkQtg4E7JOzS40S+pgLiStSAzKQ2ekp3l286t9cBXjEhuGvXLu8EYIA9yZao45BL9XNatGF533CpRsGYJ0On+xGpseiS52RMk8rVc0OhEEJx0W2NuNYXLUB7OBPiZYKe7v50aTHlj42l/Ii9Yam1XzkWBWXxi9pq8GWMIwKmQqSKagg6uPbbzwIeZdtjKBrZUWBhglcz5FvCSZ/5nD4nWDQ7A79yhnUtABWzyOP62uo/cVIFiwZSA6hJJrGWpZnKg2PfCTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNnuyQj3aCvUr8U8HwismnBYei0fxlXTHlWMaKV0u7Q=;
 b=hdvHL+SV8DKsMFf9cKALimaudVeWDMLHYLHAtzkTDByzwgIIE40pApghwEya8zvQzmg+4P93oKWx+++zZqg/gNW3l4sUGYCX6gDMAr9rM7aGtndxhfrRhNR4ZHFgAtUCM6qNqmWEyYt2QgDcVDQ3j+iMiEiChNl2p30DwJRZfkk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8294.eurprd04.prod.outlook.com (2603:10a6:20b:3f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 14:59:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 14:59:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver that
 defers probe
Thread-Topic: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver
 that defers probe
Thread-Index: AQHYZyJUAF3LqZezX0WvBgnHz+VvNa0dg4GAgAjQVgA=
Date:   Thu, 19 May 2022 14:59:36 +0000
Message-ID: <20220519145936.3ofmmnrehydba7t6@skbuf>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
 <Yn72l3O6yI7YstMf@lunn.ch>
In-Reply-To: <Yn72l3O6yI7YstMf@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d40e726d-72c8-4688-71b8-08da39a83141
x-ms-traffictypediagnostic: AS8PR04MB8294:EE_
x-microsoft-antispam-prvs: <AS8PR04MB8294B74F23051F8A8B8EC83AE0D09@AS8PR04MB8294.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /bHI+UfygsDijd1C6p7A/LFmtFTXAuxOAwgT6oTVXtWD4pPGZWOx0N217TykEonkD9wcKDmNM6tHEq3XUkQVlgvGW748+yaey9YDUv/GOPOh+8lY7oGnwXXeodg+q1aAwmuTRhisieWcGtugiOfJ5xKSP8f7Lr7iqqq12xKbkpwKyuNDvwhBfxlREEdOvVwzFJKOS5IAB3tfu+Hye9u2Ac8I8Ob1sZTFwvDLUSkceHhk9zUgVhLoummSU5v0/LArLambw8/iBoEcxNBoFxgkNaqtnZUiuiDMlWMHBzYFB81BUXKPEu+pneMhhC5LzLZruMPIei51nnKCFWRVnVipiDgMGULxO0eqn4cvPnUj0BjLmto5ZSt02x0t9tGWruwvrMxeDtseF1E6qlsII61hFjuu8JvG6zkvqWVqDoyVH1ZzoMGZPXUdyAYDQztmzG82b+xB5nZaqlq4NE+r31aPXTQ4TaArQZJRbVABS49pVKYRughW/7xjnSoW/QyWCbp+LhBZqpZc/bOb+p6bCNnevY+rFlbsq6ZNd0SHuF+yVEo8KLAY1wC4R7lujV5JAEiZu0Ixxhrr3UQyvV9e+3I3oLPNNqD5xuuIedNkIz0iktUD0ifTZXJ/eCIbs+D4VYm3n6ekDRQb3Jzx3enwB/3iquyuZmZVSzHiWsavPST3oZA2+NeFNcvEeXmoUW3NNRzFtEzo9G8C+VLn2ts8hBabP8Di8mGKG7b/Aw4iOzaBA0v3sBszx5HSXj54QDZGpCx1RXaniFUu2EvCRgCREX8PkApyCj0mD4LdPLqmu7NbMg0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38070700005)(44832011)(71200400001)(38100700002)(6916009)(186003)(1076003)(2906002)(6506007)(54906003)(26005)(6512007)(9686003)(6486002)(966005)(508600001)(86362001)(91956017)(66476007)(64756008)(76116006)(66946007)(66446008)(8676002)(4326008)(66556008)(33716001)(8936002)(5660300002)(7416002)(83380400001)(316002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bW5RcFJZSkV3S1o1N0YyeituVDNHMUZnYVNHNnpwTnQwajNhNW9WcDB6SmFZ?=
 =?gb2312?B?bk5iemxuQzVhL3d5dURvVXRoSmhZVlgwY00rUlAyT2tkK0RMcmhRZk04ZExW?=
 =?gb2312?B?RlpKSWtia1dJTUZLVmlDV01sdHpMVmlJanA5Qm9QK3hkcTdqZU1aOUNtandn?=
 =?gb2312?B?dUdycWUrUE9FUEZOK1YxaXhaUEJ0SndsckZRMFJ5NURkUmdRMFhybkwzQXB1?=
 =?gb2312?B?MHRUNlZsUTZtNnR2UDB0UFIwWTY3VmpCVmtxUmdsMzh4YkxVOFNBa2xkMnFh?=
 =?gb2312?B?RnNaUURYSnZhZUZVS2MxTVNrL09zRWJMelJIb2ZEVnl6Z3VJaGpSeGJpWUl5?=
 =?gb2312?B?cE1nN1ROUmU1TVNXVkpxK1dNTy9ra09VTE50cldzNTNkYWFBVGcyS0l4bTl6?=
 =?gb2312?B?ckpQWElkR3BnRDlEMjQybnVNSUF5SlVYSXZhcUJtWTJxK3RETUVXYnJjMlNY?=
 =?gb2312?B?eEQycVdQcndnMnh0M0xySTNwT0ViZFgwSFE4UndRR3plTkJaUFF4TCszYWx2?=
 =?gb2312?B?UFp0Y1RVajErL0pGL01KTlpYMTRhc1F2WFVaVzl5Mno3WkFMT01kQ3dsV2kv?=
 =?gb2312?B?bEZKS1JYa1JTMjBSd000WmJ3c1QyZ2tyOEFFTFB0aGlYUXlLUHFQRlpGbWwx?=
 =?gb2312?B?ODFFd25xYU41NVl4YnBxc3FsTHdjNGZWS0NXQWkwR2R5bThxYzZBM0xmSGM2?=
 =?gb2312?B?TmJzS3JLbnN5R3pFOXU4VmQ3WjdGYW1TSkV3a0NjYy9VbjliSVA1WFBUaEgz?=
 =?gb2312?B?Tit4d24yZXdqdXEyQ0lQMHlwUENkUzQzeFZIdXJ3VVZTRTVocDZBMmhIdEtF?=
 =?gb2312?B?ZTl0SWYwVC9TV25ORUl0VXg1V1NOR3VKbFYvTFdxbVFpbTJJNUxBcTd3TGNP?=
 =?gb2312?B?d1l5WFlmWWVSelVyQWdlMG9RcTV3S29lRjIwekJCY2xXRmFFR3I0d2VXazQ2?=
 =?gb2312?B?RTBDeWhiZVEzU2J5YWZZWVZhaytTVE82aVBUdmo1V2F4V0JlVFgzMWpBWVNE?=
 =?gb2312?B?cnBZSnFjTmYyVURzK2tqVFRvUzVEYm9HQ1pNR3NTc3VlV0hyMGVqNzF6MWlG?=
 =?gb2312?B?U012N0I3L0FJdlZhR0I4ZVhNUFdxZjZpRDMzWmdqd1g5VkxQczJxUEZaTUVQ?=
 =?gb2312?B?clF1ZjVaTHEreWlsenBKeVB1aDI4U3c0K1BRV0VEaHY2bEw4Z2hxOHR5OFJx?=
 =?gb2312?B?c2JydjNkSEMyU1ptSmlZOXpva0Ura0R2SDN0K3VGTU41QUlqdmZRa3ZvRjZH?=
 =?gb2312?B?dnRxdTNzY3FaSlVlVXVWNU5Ma2RoT2ZlRkEwaS8vU3JpakIzTk5QL0E0WXl1?=
 =?gb2312?B?YzM3ZjlPM3pCRkNKOW1uaHB4YUdXdWFPYitXcnUrblNEM1czNUhCcTIydkFY?=
 =?gb2312?B?Vyt6SHlPNjAyMkVHLzVHVDRvaVNhWFVBSkhqN3FtL2F1OXhsRlhVeTZQS0JP?=
 =?gb2312?B?TWVIejR3clJOcGg4SUFob2J5dEpmWlRNblF6WG8vc0ZSZC9Gcm1oTitnU0VG?=
 =?gb2312?B?THRlcnFlTjFJMTdQbldPWmxrdXdLMHFBNTEyUTJrRXZrNVAvYk1qY3VocXZs?=
 =?gb2312?B?WENwSy8yK2R1UGVteURwZHJWcGUrNHEyRnRwUTBNYk9jWmphYTU3TkZVSU4r?=
 =?gb2312?B?eEhobmZ1bTVLUDRmL2ZrSFhMSTFoRTVHZ2JuWUxLdjJvb25GakwzZXdOQzdv?=
 =?gb2312?B?S1lmamJsa2RFcmQvdjRyNzJ5WEY2cWxXamFBd1FCM3krdHd2R3VOS0ZhWVBT?=
 =?gb2312?B?a253U1hUTzRIRVBabU02UXJCSDlWNGZLVGpXQXl5WCtsaHlUdDdOblB0OHRV?=
 =?gb2312?B?MFlzazBJUFVhTkZFSjhibmwzb3Y1aG5SNUxTLzMzK3g0UU5IbTRCbEQzbW1N?=
 =?gb2312?B?bnoxYnIwbE4rWlhZZTlDdFY4SWt0MVJGajA1RHFGZlNYbG1wWXJ2OGlHczd3?=
 =?gb2312?B?RHJOeTVjazdvbFdEV1ViTWNHeEFVKzRDU2pVWWtCV3BEaXpxdndCM3FZOXk3?=
 =?gb2312?B?Rkh4U2k2WmFnLzl5NlVldGZNeVkrcDN0UktKbG1WOU13eVBpOHMwNkhXUDli?=
 =?gb2312?B?SjR2SE1CQzhnUGRRVENDaUtZTVJ4Tmo0ZFU1S2pNbUprazBOdVFGWTJHY3VG?=
 =?gb2312?B?WWkvWE5sVW5mSGtGZW44KzhDbXkxMXRiVjZ2Y1NSMzg0cjA1L3BYbzU1VGZr?=
 =?gb2312?B?UC9SakxqWUI2QTd6RDVTUVBZZzdxUm9hL2Z0bStPOE1nSC9qbzNkNUlpWS94?=
 =?gb2312?B?NVB6TEZ4a1ZpQkRud0sxYmliRDJJR3N0MnNEUGVTc1QyRk1raFVRZEdlSmxa?=
 =?gb2312?B?T3B4citCeG02Z3h1MFNBKzgxVVZFVDVtL1M0VzlOd2VDV0dtamdLaDVoS2lE?=
 =?gb2312?Q?GL8PvdGmNz9T2DNk=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <3A8BC2521B57324384BB193C3E8503D4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40e726d-72c8-4688-71b8-08da39a83141
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 14:59:36.9539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pfE/bbARWq4nCk2cMAnc/gF0M7Gp7SX5O/mgCMndy8UMxhPhl0x/txR/TTDX3+wZ9TMdbskoy/xBXLfMG5Xz9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8294
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBTYXQsIE1heSAxNCwgMjAyMiBhdCAwMjoyMzo1MUFNICswMjAwLCBB
bmRyZXcgTHVubiB3cm90ZToNCj4gT24gU2F0LCBNYXkgMTQsIDIwMjIgYXQgMDI6MzY6MzhBTSAr
MDMwMCwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggc2V0IGNvbXBsZXRl
cyB0aGUgcGljdHVyZSBkZXNjcmliZWQgYnkNCj4gPiAnW1JGQyxkZXZpY2V0cmVlXSBvZjogcHJv
cGVydHk6IG1hcmsgImludGVycnVwdHMiIGFzIG9wdGlvbmFsIGZvciBmd19kZXZsaW5rJw0KPiA+
IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRkZXZicGYvcGF0Y2gvMjAy
MjA1MTMyMDEyNDMuMjM4MTEzMy0xLXZsYWRpbWlyLm9sdGVhbkBueHAuY29tLw0KPiA+IA0KPiA+
IEkndmUgQ0NlZCBub24tbmV0d29ya2luZyBtYWludGFpbmVycyBqdXN0IGluIGNhc2UgdGhleSB3
YW50IHRvIGdhaW4gYQ0KPiA+IGJldHRlciB1bmRlcnN0YW5kaW5nLiBJZiBub3QsIGFwb2xvZ2ll
cyBhbmQgcGxlYXNlIGlnbm9yZSB0aGUgcmVzdC4NCj4gPiANCj4gPiBNeSB1c2UgY2FzZSBpcyB0
byBtaWdyYXRlIGEgUEhZIGRyaXZlciBmcm9tIHBvbGwgbW9kZSB0byBpbnRlcnJ1cHQgbW9kZQ0K
PiA+IHdpdGhvdXQgYnJlYWtpbmcgY29tcGF0aWJpbGl0eSBiZXR3ZWVuIG5ldyBkZXZpY2UgdHJl
ZXMgYW5kIG9sZCBrZXJuZWxzDQo+ID4gd2hpY2ggZGlkIG5vdCBoYXZlIGEgZHJpdmVyIGZvciB0
aGF0IElSUSBwYXJlbnQsIGFuZCB0aGVyZWZvcmUgKGZvcg0KPiA+IHRoaW5ncyB0byB3b3JrKSBk
aWQgbm90IGV2ZW4gaGF2ZSB0aGF0IGludGVycnVwdCBsaXN0ZWQgaW4gdGhlICJ2aW50YWdlDQo+
ID4gY29ycmVjdCIgRFQgYmxvYnMuIE5vdGUgdGhhdCBjdXJyZW50IGtlcm5lbHMgYXMgb2YgdG9k
YXkgYXJlIGFsc28NCj4gPiAib2xkIGtlcm5lbHMiIGluIHRoaXMgZGVzY3JpcHRpb24uDQo+ID4g
DQo+ID4gQ3JlYXRpbmcgc29tZSBkZWdyZWUgb2YgY29tcGF0aWJpbGl0eSBoYXMgbXVsdGlwbGUg
Y29tcG9uZW50cy4NCj4gPiANCj4gPiAxLiBBIFBIWSBkcml2ZXIgbXVzdCBldmVudHVhbGx5IGdp
dmUgdXAgd2FpdGluZyBmb3IgYW4gSVJRIHByb3ZpZGVyLA0KPiA+ICAgIHNpbmNlIHRoZSBkZXBl
bmRlbmN5IGlzIG9wdGlvbmFsIGFuZCBpdCBjYW4gZmFsbCBiYWNrIHRvIHBvbGwgbW9kZS4NCj4g
PiAgICBUaGlzIGlzIGN1cnJlbnRseSBzdXBwb3J0ZWQgdGhhbmtzIHRvIGNvbW1pdCA3NGJlZmE0
NDdlNjggKCJuZXQ6DQo+ID4gICAgbWRpbzogZG9uJ3QgZGVmZXIgcHJvYmUgZm9yZXZlciBpZiBQ
SFkgSVJRIHByb3ZpZGVyIGlzIG1pc3NpbmciKS4NCj4gPiANCj4gPiAyLiBCZWZvcmUgaXQgZmlu
YWxseSBnaXZlcyB1cCwgdGhlIFBIWSBkcml2ZXIgaGFzIGEgdHJhbnNpZW50IHBoYXNlIG9mDQo+
ID4gICAgcmV0dXJuaW5nIC1FUFJPQkVfREVGRVIuIFRoYXQgdHJhbnNpZW50IHBoYXNlIGNhdXNl
cyBzb21lIGJyZWFrYWdlDQo+ID4gICAgd2hpY2ggaXMgaGFuZGxlZCBieSB0aGlzIHBhdGNoIHNl
dCwgZGV0YWlscyBiZWxvdy4NCj4gPiANCj4gPiAzLiBQSFkgZGV2aWNlIHByb2JpbmcgYW5kIEV0
aGVybmV0IGNvbnRyb2xsZXIgZmluZGluZyBpdCBhbmQgY29ubmVjdGluZw0KPiA+ICAgIHRvIGl0
IGFyZSBhc3luYyBldmVudHMuIFdoZW4gYm90aCBoYXBwZW4gZHVyaW5nIHByb2JpbmcsIHRoZSBw
cm9ibGVtDQo+ID4gICAgaXMgdGhhdCBmaW5kaW5nIHRoZSBQSFkgZmFpbHMgaWYgdGhlIFBIWSBk
ZWZlcnMgcHJvYmUsIHdoaWNoIHJlc3VsdHMNCj4gPiAgICBpbiBhIG1pc3NpbmcgUEhZIHJhdGhl
ciB0aGFuIHdhaXRpbmcgZm9yIGl0LiBVbmZvcnR1bmF0ZWx5IHRoZXJlIGlzDQo+ID4gICAgbm8g
dW5pdmVyc2FsIHdheSB0byBhZGRyZXNzIHRoaXMgcHJvYmxlbSwgYmVjYXVzZSB0aGUgbWFqb3Jp
dHkgb2YNCj4gPiAgICBFdGhlcm5ldCBkcml2ZXJzIGRvIG5vdCBjb25uZWN0IHRvIHRoZSBQSFkg
ZHVyaW5nIHByb2JlLiBTbyB0aGUNCj4gPiAgICBwcm9ibGVtIGlzIGZpeGVkIG9ubHkgZm9yIHRo
ZSBkcml2ZXIgdGhhdCBpcyBvZiBpbnRlcmVzdCB0byBtZSBpbg0KPiA+ICAgIHRoaXMgY29udGV4
dCwgRFNBLCBhbmQgd2l0aCBzcGVjaWFsIEFQSSBleHBvcnRlZCBieSBwaHlsaW5rDQo+ID4gICAg
c3BlY2lmaWNhbGx5IGZvciB0aGlzIHB1cnBvc2UsIHRvIGxpbWl0IHRoZSBpbXBhY3Qgb24gb3Ro
ZXIgZHJpdmVycy4NCj4gDQo+IFRoZXJlIGlzIGEgdmVyeSBkaWZmZXJlbnQgYXBwcm9hY2gsIHdo
aWNoIG1pZ2h0IGJlIHNpbXBsZXIuDQo+IA0KPiBXZSBrbm93IHBvbGxpbmcgd2lsbCBhbHdheXMg
d29yay4gQW5kIGl0IHNob3VsZCBiZSBwb3NzaWJsZSB0bw0KPiB0cmFuc2l0aW9uIGJldHdlZW4g
cG9sbGluZyBhbmQgaW50ZXJydXB0IGF0IGFueSBwb2ludCwgc28gbG9uZyBhcyB0aGUNCj4gcGh5
bG9jayBpcyBoZWxkLiBTbyBpZiB5b3UgZ2V0IC1FUFJPQkVfREVGRkVSIGR1cmluZyBwcm9iZSwg
bWFyayBzb21lDQo+IHN0YXRlIGluIHBoeWRldiB0aGF0IHRoZXJlIHNob3VsZCBiZSBhbiBpcnEs
IGJ1dCBpdCBpcyBub3QgYXJvdW5kIHlldC4NCj4gV2hlbiB0aGUgcGh5IGlzIHN0YXJ0ZWQsIGFu
ZCBwaHlsaWIgc3RhcnRzIHBvbGxpbmcsIGxvb2sgZm9yIHRoZSBzdGF0ZQ0KPiBhbmQgdHJ5IGdl
dHRpbmcgdGhlIElSUSBhZ2Fpbi4gSWYgc3VjY2Vzc2Z1bCwgc3dhcCB0byBpbnRlcnJ1cHRzLCBp
Zg0KPiBub3QsIGtlZXAgcG9sbGluZy4gTWF5YmUgYWZ0ZXIgNjAgc2Vjb25kcyBvZiBwb2xsaW5n
IGFuZCB0cnlpbmcsIGdpdmUNCj4gdXAgdHJ5aW5nIHRvIGZpbmQgdGhlIGlycSBhbmQgc3RpY2sg
d2l0aCBwb2xsaW5nLg0KDQpUaGF0IGRvZXNuJ3Qgc291bmQgbGlrZSBzb21ldGhpbmcgdGhhdCBJ
J2QgYmFja3BvcnQgdG8gc3RhYmxlIGtlcm5lbHMuDQpMZXR0aW5nIHRoZSBQSFkgZHJpdmVyIGR5
bmFtaWNhbGx5IHN3aXRjaCBmcm9tIHBvbGwgdG8gSVJRIG1vZGUgcmlza3MNCnJhY2luZyB3aXRo
IHBoeWxpbmsncyB3b3JrcXVldWUsIGFuZCBnZW5lcmFsbHkgc3BlYWtpbmcsIHBoeWxpbmsgZG9l
c24ndA0Kc2VlbSB0byBiZSBidWlsdCBhcm91bmQgdGhlIGlkZWEgdGhhdCAiYm9vbCBwb2xsIiBj
YW4gY2hhbmdlIGFmdGVyDQpwaHlsaW5rX3N0YXJ0KCkuDQoNCldoYXQgbW90aXZhdGVzIG1lIHRv
IG1ha2UgdGhlc2UgY2hhbmdlcyBpbiB0aGUgZmlyc3QgcGxhY2UgaXMgdGhlIGlkZWENCnRoYXQg
Y3VycmVudCBrZXJuZWxzIHNob3VsZCB3b3JrIHdpdGggdXBkYXRlZCBkZXZpY2UgdHJlZXMuIElm
IEkgd29uJ3QNCmJlIGFibGUgdG8gYWNoaWV2ZSB0aGF0LCBJIHNlZSBubyBwb2ludCBpbiBhZGRp
bmcgbG9naWMgdG8gdHJhbnNpdGlvbg0KZnJvbSBwb2xsIHRvIElSUSBtb2RlIGV2ZW4gaW4gbmV0
LW5leHQsIHNpbmNlIEknZCBoYXZlIHRvIHVwZGF0ZSB0aGUNCmtlcm5lbCB3aGVuIEkgdXBkYXRl
IHRoZSBEVCwgYW5kIGJ5IHRoZW4sIEknZCBoYXZlIGEgcHJvcGVyIGRyaXZlciBmb3INCnRoZSBJ
UlEgcGFyZW50IGFueXdheS4gU29ycnku
