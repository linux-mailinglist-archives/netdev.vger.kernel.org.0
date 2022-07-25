Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5F57FEFD
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiGYM0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiGYM0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:26:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2056.outbound.protection.outlook.com [40.107.21.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF3B15733
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSGaDX7alcQz1J29LkhobpDvKoxaeMjkDFkmUbMZ/cFiobr4rmk4XOYygiKKHZv498xjm3jlvs20S7Th7bbuOausU5u8B+3ylT4nCIYE3MdnHRicQmolBhbNZXszuDiR0LK8Iit22OUi3qbQxNG2O0LeScGXrHxdzfmqD86iZczNeJ6r7dE8I4OQB9LmXnucahMvi3ewbRUxYYdM6eFcIdKG4ToJOUhX4z3PqkIVDQru06OLzLGTmJRHcGIoWChGgTwcvNHGxbHuuiyg+hg+3+LCx8m4jms+RPmmAEzINJmvJBj5VuCJFma1Ii27NKBy1tZ/4sq7wqKzrQ2NjhtK/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHmUlnMVyCmems2XlliAD44qmtU7Lmv+9de/3HYbJV0=;
 b=oXrExphc0xML+GqYmono60pxek+RlmtGPd9LAt3oqbmyQee3aEJvA2lLgy4zWiQYyQFPd/+52CIQI7fq+D/xQkPwzj/LhrCEMuS7LHLv3nppF2L6XBWqqljvNlW4feJpAIaMHFFOrvpxXYmkBkvNFdHrylKEFpLqbOyl/qLgN7LkVAImSOvZpd5ghtDPS0SrHD9KaOOXwMJ0lUakEOWhX+lPGD8E5OCl9NcPj6jXoWDUUjMFHm0eVWWinqEs1aD48AG8kHyO4DoUg+YTuCo2DjmqcCDo0R7wFeOOOmOBDIb1MtCv8weIYYH5QG2784i5NXG44l9xJO09ANdUT2+OXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHmUlnMVyCmems2XlliAD44qmtU7Lmv+9de/3HYbJV0=;
 b=oINM1CE1nk0BZJY419LhC6j96HAr4r6gYRVCxt4u6ARdsySj2075VkEj4Txph6lSt0QQIZH4BXCofh1Ksg1RY7WKrd9KAlXu/5gb2bMaT1iE4PfwFqHBFdiuOZC63RGLULqN5/pm3FIRTbmnZG7nvNhrBau613iZB+lVDjErFtE=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DB9PR04MB8220.eurprd04.prod.outlook.com (2603:10a6:10:242::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 12:26:41 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::f827:59f2:5617:5223]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::f827:59f2:5617:5223%5]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 12:26:41 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jules Maselbas <jmaselbas@kalray.eu>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: ethtool generate a buffer overflow in strlen
Thread-Topic: ethtool generate a buffer overflow in strlen
Thread-Index: AQHYnfHGHTXlmks7Y0mvkPhviTS/Iq2K6GsAgAQdhYCAAAFGMA==
Date:   Mon, 25 Jul 2022 12:26:40 +0000
Message-ID: <AM9PR04MB83970688661428BB1327A03B96959@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220722173745.GB13990@tellis.lin.mbt.kalray.eu>
 <20220722142942.48f4332c@kernel.org>
 <20220725122023.GB9874@tellis.lin.mbt.kalray.eu>
In-Reply-To: <20220725122023.GB9874@tellis.lin.mbt.kalray.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2361f879-102e-40f3-8b73-08da6e38ed9d
x-ms-traffictypediagnostic: DB9PR04MB8220:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CPlnMB+6VW4LIkiXuKt2RnuhPXTyf1pCHAtswckjTHpSX96tNuy2MbX/KeF/vknHy6YTDhuxKb5+ZL0iaXtFv4PUyop6xHEm9C9EfDrO4HBrSdU7xX07ujjeqv2ffThNmKUswn49bnY3exA6RBlZQI947eJz40yV2acf00yHCPDbi6WsivX/Z/7h13USEWH66mFn8suN3fkNJf5fYcGHaJxVTN3RljH5/Ffon0XWPBW+EYQXWg0v8euJUd3sxjIdl4BrYyVYVS1bm6zcbAAyW2hGRF5cTETdKR0ta/Qhst+MW3nLo3CAhQxYemz31uYPEb9YfeVBIFE/TyDNgqXyGGxHrZ6kbDh0sQbLrct+hnlLjZFLPKRWlzoAm+H4MwdIvZerd3T0P6Zzs5q65wOlAWJuJsgqAMga0Aa36jEZ1JbHnwDxUNnwUG+jaXxeOJzgriM+353q2NveCPLJNnsbn5toqLCf1jsTsPJVUoxZXJ06xbgREy+1gO2N4sPFd05qY4TYxdVJi0islPZbcacR3DXc39Wmg9eqrPNdSOEME/LoCG7Qvd7T9gV75KB3AHHCwxFKJ8G+GnhJm8UxwRbDausVSBv5Ts+TQZtypOyprsiVX2kUJzJpS8loDxSOfT59XTKBM3Di22ncLCpjTH6FvHeq5m6M2UQ7mM7XMr60ql8Pr83z3PJquDC6/eBRDnmRWTRaOLsMciKHdQCgkacugKDN8NcPBkMzxfsKR/cXOBUlzAt/6Usp52WqXO2mTC/XG78NYAA4DBLtzsw8jrlCZ16EHScH7ZbwXBDKrLKBiZab0asmCC3xOiW8eUNHU3DwwdP+IAZeMbQ/eUrIb3SR9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(41300700001)(110136005)(122000001)(38070700005)(38100700002)(66946007)(66476007)(66556008)(54906003)(66446008)(8676002)(76116006)(64756008)(4326008)(316002)(71200400001)(52536014)(55016003)(478600001)(9686003)(5660300002)(26005)(8936002)(2906002)(33656002)(83380400001)(53546011)(6506007)(44832011)(7696005)(86362001)(186003)(20673002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M3lsWmwycTlVQUoyQ1hxbmVFaHZoN1FTejJDWldLSFVKWFR3emlyQU5Vc0M0?=
 =?utf-8?B?NC84Z0QvQlVNY20zRjhmT28wdzNma1ZrTkZMc1NNcnRnbGJzVFg1ZmhvWTRO?=
 =?utf-8?B?b0MrWTlVSkxqRGNGR0R1WXR1MnhsZUtjZWM2Z2JkYWtUVWsrVmpoMmpMd09V?=
 =?utf-8?B?VER6WlNsalNWY004TEh6bGY3SzRFOUxsUlp3bDFvdEpUWHRYZmdsS0NlMzJh?=
 =?utf-8?B?VUVRTXBkVllWQ3pqZ0pBaXoySTR5VWlQQklhcEFrQ0dZbnBjTDhBR1U1bEVn?=
 =?utf-8?B?SlBkZnN4RlE0ZUdvamxlYXF5Vjd3Wlhrc09pZUlhbTRuSm9WdExBQjl5em1R?=
 =?utf-8?B?cmFQNVJNZU9SQ1VVdkk2ejRacWljRWNTeUQ1c0xyUE9tbnl1a0g4V05GaUtl?=
 =?utf-8?B?SXBhTzZhMUpPVEdoa0ZCT2oyL3R6RU9YeU55Z29XQVpET2YxTDd3a3pLZUxv?=
 =?utf-8?B?U1Qzeis1enBrbEozbURKN0d4MVNSUkZZblFnem02Zjh5YTlvQTgrR056M25V?=
 =?utf-8?B?TkU1UzE5V1F2UzNLTGxnbmIxQmswMDhkZWg2bThtcUNGKzBhQWdjQzJ4a3Vw?=
 =?utf-8?B?SWU2M1M2eEZOMVdPdTE0TjBGN0lvUVdNOWJIQVdOTm8vWjVDY3o3RFZIb3hn?=
 =?utf-8?B?TUduZUx2UTg4U1VGNGw1a2FBaUR4L1F3d2RlMElkWGxZenhIbnFoTllKQktZ?=
 =?utf-8?B?d0kzdENXc2FRN2owclpzcXJZWGROejdOMjUrYzcyQXFuYndxNU95YjRTaDdr?=
 =?utf-8?B?ei95UHJJS3JTNGZtTis0WjV0UTFUbTZyZzdqanB2U2N6Z0owakdacWJaWE1x?=
 =?utf-8?B?ajhscUd0NFpPeC81ZjhpK29aTWhIYWl3b2x3NHlrcmplck1UdU8xSUhvc2kx?=
 =?utf-8?B?RDVBMUg2TG1YaTJjWGNCSng2TUNwZ3VFc2FEUHc0UHgzRDNSdU5OYlpYY2VV?=
 =?utf-8?B?OTIzVVdiVTR4UU9Bbkwzem44TE1hN25sMEhHL3BjRXdxQkxCOTU2M2ZBN2Iw?=
 =?utf-8?B?OEN2UDNpZXNsVFZDa3BrMlFXeTRjdHF3RGY3amxPQlBMSEtnZVBkd1lHV0ZO?=
 =?utf-8?B?S2lHSm11UG1XYWNiOGgvZFlsTWtiQ1pyQTlyTGNVbloyY2ljMWJteURIVDU0?=
 =?utf-8?B?QUkrVWtXZ2taaVNaSmxzc09LZFBYNENvT1BwOVYzZnV3WElVN0F2b1JhY0Jl?=
 =?utf-8?B?ZHNIN0FlVEJJbTEzaTR6ZUtOSkVwZkxrMlZqTHZCVlJlQ3lnZWJ2S0xrWk8z?=
 =?utf-8?B?V1BVd0hwaGtWRzk2Sk9ncFBiN1Q0aTY3Y0ZsN2VHd01XSzgwTVdNeTNxcVhB?=
 =?utf-8?B?TVZ5Ykx1L2oxSG81Q1FrV1FSbVlPV3d3NFN1VHZOU2Y2cDR4UzhVMTFYcFhE?=
 =?utf-8?B?c3Zib0Fzck5UZkxQSWd0SUR5Qk1NMUJjaVIvK0JkL3JiZExwbmhNMlY1Mzdh?=
 =?utf-8?B?YzZ3K1BvWWFSSGcxMzh6MEcvVXc4NDBKVTY0d3ZmVVg1Vy92d1lueVBONVNo?=
 =?utf-8?B?WXNPakNYdTlacEMvY3ZHRVVBK01zWS9VdWxqcnFaOEYzV2dwZjB5Yno0OXpi?=
 =?utf-8?B?Tm9DR1hCMzRnZitHYzIxSFB0dXFmRU1NYzRGc0VCUDQrZmFnb3ZkTi9oeUxW?=
 =?utf-8?B?WUxjUkdmOHAyUGh3VTJRV0R5cGZja25EWFI1bVE3SVVJQ1lpbHZ6MHJUTVhq?=
 =?utf-8?B?UXJiR3J1UndtLytLcGtoMG9vUWVpdWwycmpkSXcrUklLSFFzTEoxMUZweXFO?=
 =?utf-8?B?NE5PTkkzV3o4RkI1LytpZ2N3M0xMcEdzSXcvNVRicU9YUXdNektlbEEwREM2?=
 =?utf-8?B?NzU4bEczUGd5aEJhRnJKQmpOaXpNbnlUcVBHN2hDKzdSOHIrakVkb2hUaUsx?=
 =?utf-8?B?SmV0UDdBM0JQS1prTjRkbVp3endCMXpxSXBpZmhNOUp5ODFGTlRvd2xRSHdu?=
 =?utf-8?B?MXRSdXRCZnk4VHVOOTQyZExCcGd5ZWNUYS9hNklOeHJuRUpzWmRpODNYeVA4?=
 =?utf-8?B?QlNyWjduUWl2cGU0bVpTNEdFL1FYRWhaSmxWRExPRXdkMnB1aGpXMnBRQjA0?=
 =?utf-8?B?dy9ialZ2WDUvbC94di9NUXFtMlg2NlJZZXNDYnlkWThTTEdDcGJ4V0hHaTRY?=
 =?utf-8?Q?66ryJKTTgSm6i/A9ZHmpmlcyh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2361f879-102e-40f3-8b73-08da6e38ed9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 12:26:40.9627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IcvmQ/3XEthu2VIvuJcJb5BCP0DTsC7MuEsdCRumrnZr9B7EPHTdDkGDI0iQLt23IJzZv9hkHNaBtGvhhd5f7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8220
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSnVsZXMgTWFzZWxiYXMg
PGptYXNlbGJhc0BrYWxyYXkuZXU+DQo+IFNlbnQ6IE1vbmRheSwgSnVseSAyNSwgMjAyMiAzOjIw
IFBNDQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzogQ2xhdWRp
dSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBEYXZpZCBTLiBNaWxsZXINCj4gPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJl
OiBldGh0b29sIGdlbmVyYXRlIGEgYnVmZmVyIG92ZXJmbG93IGluIHN0cmxlbg0KPiANCj4gT24g
RnJpLCBKdWwgMjIsIDIwMjIgYXQgMDI6Mjk6NDJQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3Jv
dGU6DQo+ID4gT24gRnJpLCAyMiBKdWwgMjAyMiAxOTozNzo0NiArMDIwMCBKdWxlcyBNYXNlbGJh
cyB3cm90ZToNCj4gPiA+IFRoZXJlIGlzIHN1c3BpY2lvdXMgbGluZXMgaW4gdGhlIGZpbGUNCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2V0aHRvb2wuYzoNCj4g
PiA+ICAgIHsgRU5FVENfUE0wX1IxNTIzWCwgIk1BQyByeCAxNTIzIHRvIG1heC1vY3RldCBwYWNr
ZXRzIiB9LA0KPiA+ID4gYW5kOg0KPiA+ID4gICAgeyBFTkVUQ19QTTBfVDE1MjNYLCAiTUFDIHR4
IDE1MjMgdG8gbWF4LW9jdGV0IHBhY2tldHMiIH0sDQo+ID4gPg0KPiA+ID4gV2hlcmUgdGhlIHN0
cmluZyBsZW5ndGggaXMgYWN0dWFsbHkgZ3JlYXRlciB0aGFuIDMyIGJ5dGVzIHdoaWNoIGlzIG1v
cmUNCj4gPiA+IHRoYW4gdGhlIHJlc2VydmVkIHNwYWNlIGZvciB0aGUgbmFtZS4gVGhpcyBzdHJ1
Y3R1cmUgaXMgZGVmaW5lZCBhcw0KPiA+ID4gZm9sbG93Og0KPiA+ID4gICAgIHN0YXRpYyBjb25z
dCBzdHJ1Y3Qgew0KPiA+ID4gICAgICAgICBpbnQgcmVnOw0KPiA+ID4gICAgICAgICBjaGFyIG5h
bWVbRVRIX0dTVFJJTkdfTEVOXTsNCj4gPiA+ICAgICB9IGVuZXRjX3BvcnRfY291bnRlcnNbXSA9
IHsgLi4uDQo+ID4gPg0KPiA+ID4gSW4gdGhlIGZ1bmN0aW9uIGVuZXRjX2dldF9zdHJpbmdzKCks
IHRoZXJlIGlzIGEgc3RybGNweSBjYWxsIG9uIHRoZQ0KPiA+ID4gY291bnRlcnMgbmFtZXMgd2hp
Y2ggaW4gdHVybnMgY2FsbHMgc3RybGVuIG9uIHRoZSBzcmMgc3RyaW5nLCBjYXVzaW5nDQo+ID4g
PiBhbiBvdXQtb2YtYm91bmQgcmVhZCwgYXQgbGVhc3Qgb3V0LW9mIHRoZSBzdHJpbmcuDQo+ID4g
Pg0KPiA+ID4gSSBhbSBub3Qgc3VyZSB0aGF0J3Mgd2hhdCBjYXVzZWQgdGhlIEJVRywgYXMgSSBk
b24ndCByZWFsbHkga25vdyBob3cNCj4gPiA+IGZvcnRpZnkgd29ya3MgYnV0IEkgdGhpbmtzIHRo
aXMgbWlnaHQgb25seSBiZSB2aXNpYmxlIHdoZW4gZm9ydGlmeSBpcw0KPiA+ID4gZW5hYmxlZC4N
Cj4gPiA+DQo+ID4gPiBJIGFtIG5vdCBzdXJlIG9uIGhvdyB0byBmaXggdGhpcyBpc3N1ZSwgbWF5
YmUgdXNlIGBjaGFyICpgIGluc3RlYWQgb2YNCj4gPiA+IGFuIGJ5dGUgYXJyYXkuDQo+ID4NCj4g
PiBUaGFua3MgZm9yIHRoZSByZXBvcnQhDQo+IFRoYW5rcyBmb3IgdGhlIHJlcGxpZSA6KQ0KPiAN
Cj4gPiBJJ2Qgc3VnZ2VzdCB0byBqdXN0IGRlbGV0ZSB0aGUgUk1PTiBzdGF0cyBpbiB0aGUgdW5z
dHJ1Y3R1cmVkIEFQSQ0KPiA+IGluIHRoaXMgZHJpdmVyIGFuZCByZXBvcnQgdGhlbSB2aWENCj4g
Pg0KPiA+IAlldGh0b29sIC1TIGV0aDAgLS1ncm91cHMgcm1vbg0KPiBJIGFtIG5vdCBmYW1pbGlh
ciB3aXRoIGV0aHRvb2w6IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IHlvdSdyZQ0KPiBzdWdnZXN0
aW5nLiBXb3VsZCB5b3UgbWluZCBnaXZpbmcgc29tZSBoaW50cy9saW5rcyB0byB3aGF0IFJNT04g
c3RhdHMNCj4gYXJlPw0KPiANCg0KSSBjYW4gZG8gaXQgaWYgeW91J3JlIHBhdGllbnQuDQo=
