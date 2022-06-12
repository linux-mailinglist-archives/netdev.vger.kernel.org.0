Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7CB5479D9
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 12:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiFLK4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 06:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiFLK4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 06:56:37 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140107.outbound.protection.outlook.com [40.107.14.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FF335260;
        Sun, 12 Jun 2022 03:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMcXBuujyykmzAvcktR4aGfaJq9R9nXBPFHtjMkMtKiA5NNxGLc7dRTvgzrvjIcrICXi5tsmu5TUPCsxpy1A432RcqMBgS5dGJMDJH63Z5XwMLmychuFxMGLlX+JFC78U3HkgZvPRjkq2Eu8gL9T88eKAiGqjLTFCRHsEIFqleKKlqSCZ2NL5UQSfxJ0wuKLLJfknqQfNZTGVlB+ossxuRhXcZz72ZihaIdoUW3px+5JWydT7SnIMQpZzxtDirooIlZvvx51y9Xl7OG8bX83Cr1I7WnI3cxylPwCboF+IQ+QC1z8u9Rh9/8vp4SGaLhqph/kZuguFB18Ype07lHYJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXdmUBcSuMQrIQPJIBrQm5OGr2AQ+2PZRdClvPeHnNo=;
 b=PqnSD+WqhUK/Q2mJm5hUslgz8wizTmKKI3hnQES9V/xEEUYX65auVNsOKnDE8Q1uK2SATdpAWz3ySBODKqIQn5fbDkScLHEDe9yxWBwKaEvfpK4yMyb69Fla2Zy5ENwIrQguN0HGnIYXUMANyaWYBdnqlE/7e2zZwok15nnw8qoxsMs26UBFUsD1tncjhTTg0rVwjCs7IPveXRTLTiRsSY/Byq02QnV15Jf9kPzHlnReRwzcWC4CDt/gEFo2CEmsvt2F/WinPbxtJerhne/XOTVLUW/GalcJlBAH0Nr0cHT99rXKkMCU/DynLxYTH9/tul3FZYt23PDrfZvZG/rZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXdmUBcSuMQrIQPJIBrQm5OGr2AQ+2PZRdClvPeHnNo=;
 b=VoRjp5dmLEIzXeMV3nuAZmK8D8UEhECCkK9fm6TqGfZt93MS/CxdkdNDpwOd0Mo6NVxFo/rmNatPM6uyqAQGMxS9KOkiIemqrOIxRq+Yvxq1WMcksLEBkbyvWZf2TRaXI1EBii7quyeB8nmg048ev2e106j6zgPSvr0WT7gTt/k=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PAXPR03MB8168.eurprd03.prod.outlook.com (2603:10a6:102:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Sun, 12 Jun
 2022 10:56:32 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5332.014; Sun, 12 Jun 2022
 10:56:32 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/5] net: dsa: realtek: rtl8365mb: remove
 learn_limit_max private data member
Thread-Topic: [PATCH net-next v2 4/5] net: dsa: realtek: rtl8365mb: remove
 learn_limit_max private data member
Thread-Index: AQHYfOBAT7bgWIysTES0q8WzwFtMfa1LAQ+AgACbVoA=
Date:   Sun, 12 Jun 2022 10:56:32 +0000
Message-ID: <20220612105631.7fboskjgcf6oijor@bang-olufsen.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
 <20220610153829.446516-5-alvin@pqrs.dk>
 <CAJq09z5gdfZtdoh5i1Bp08M-S6UiATXzcYNMArHxvsi3ch===g@mail.gmail.com>
In-Reply-To: <CAJq09z5gdfZtdoh5i1Bp08M-S6UiATXzcYNMArHxvsi3ch===g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb8df307-8bee-4bab-e523-08da4c6235fb
x-ms-traffictypediagnostic: PAXPR03MB8168:EE_
x-microsoft-antispam-prvs: <PAXPR03MB816873F77546AD85DD5E76D883A89@PAXPR03MB8168.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2t4OgrGfEg3BvzLyxgbLeVW7Yfyej5cKLxIEg7QsHEv+pBwcBjhNXYhmAL2d7TSMQO7HwfOkfFtlyvgCErj42pQzDdQafRf+fPDoi7ACQCdSWavngjFdXLBQRpisk0i2GzwV2YsO6wXPbWqOI/8G1FrxhzsoZKMQRCdT5iaEw3HMikMmOK0RrSDre0mJgC4cfnuqn3s8YAa5FeTgNTqVXrGuWykgkBQ7942FB/Ni7mPLw6T11D/JJhHKn2FPkWmUhyzY1dPYaMg9xhR9kUZZQwBNfv3hsfYYXBmgdUvlAi9joYBJ9ljRxmVJnPuKBdtpOdYPPNMOA5j9N4CGHygFqF2lZVA9lTiKXcXL/UrSMnQIdn5RDF5uFvzdcG/RTOd6xMHKw0Da5nQwE65cA9zXd2BgeZZoMdRfRnZRu/lTqB01uTojbbaToTa/E72+xDlt6Q2NGrWngWqEf2RUjEaViLKn2V3JneQzPF/6WNYQH/qmOaiQIb9GOSUSUV0r0zsLn26GXGuSYCANmYi35H3SN+aXJ8x9cCET82mBAt+RlnqIc6r+KkjXmIEm78dR6IjTEbCysK4TEVd0l2l40UryolAYw2RAsIn8JSTnTJmz4N1+zXxccXcX8+loZSVO+pBbKroxvtMx6uL9TTBJ/TOxcXYLk8pYpI3I7A8Cgmo17UIyZX4eBt8Ru9AwplYcMlyz3qEESygTc0BKqgj4n7YBZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(64756008)(8676002)(66446008)(4326008)(66556008)(76116006)(91956017)(66476007)(66946007)(2616005)(508600001)(6486002)(71200400001)(1076003)(83380400001)(85202003)(86362001)(85182001)(36756003)(186003)(2906002)(38070700005)(5660300002)(4744005)(8976002)(6512007)(54906003)(6916009)(6506007)(26005)(38100700002)(122000001)(316002)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2tWVnZIRzNKNjRLN3pIV05JQ0F5M0phWUxJYWlYK01QWnNGYWttc2ZPa2ox?=
 =?utf-8?B?OVk3ekFBeUpwL2o0MTZhc3VXNU12Q3VkWUFmYmVIZUlFb2NZQUtVTHBVMVNH?=
 =?utf-8?B?bFMycmJvbjFCUXAyMTJFRHdNN1VBcGJLTWVEZjdLalpDc2pibFMwUHZiZXdj?=
 =?utf-8?B?NXJ2MGptZ0s3WUdvY05nS2dGVGJielNJNTl5Nk41bm45eUFBVjU1ZithT2lw?=
 =?utf-8?B?clkvb2tzeXhzbHVDdTFyRlVXWThQeG51OE0wbDVITm85STdEZU1aTWFDQUE1?=
 =?utf-8?B?aE5iSlI1TmtwMEcrc09WejcrMFRYV2NnYkpUWURmY0NzZE9vb3FUQVBydUpo?=
 =?utf-8?B?RzE0K2lxTGRvYTEzTmRuN0xIZU9abXo4WmNoSWJHbjg3bVBuSmtqeXQzbnYx?=
 =?utf-8?B?MWRHbCtFa05IMzRuVllXUXlweEc5dklBdXp3akZGT0ViTndlQkJiY0ZTY2Nw?=
 =?utf-8?B?REdaM1NqaXM5UTUwUFpLVXFqMjd5N0VnTm1EaENnczl1VzA2dWFUQUVLOUJF?=
 =?utf-8?B?OXFqZzVtVnZnRkE4bFJ2SDlobTNLbnFWSFh1NzczdU5mSW1RdUUwcUs4dHBD?=
 =?utf-8?B?Zkp6TDIzcWtTcnZqUXliSS9aZWkwWU1CaHJMdEw4VG5QNUh5a1gxYTNJMDR3?=
 =?utf-8?B?R1ZqUTFmemhrSlIvcnpFZ2ZBUVR2QVRaVlpBRUhYVzdnNTJvUGtUbXZOWEp3?=
 =?utf-8?B?NzJ5VlArZ1JDdFFJNkttZERNKzN4ZGh1cWRKNkM2T1llV3EwWkp5NHNGSjlu?=
 =?utf-8?B?azR4cHRJRGlLYlpZMWduSnFSZ1dDMlFJVFI5QlIvM252QkRGZnVlQ29UWGdv?=
 =?utf-8?B?YkdvcE5rSHZ6NnVCNk1zc1JjamhaRGszVHBkd0doK1cxcTFzaEtrTTRoVURx?=
 =?utf-8?B?ZXVVUFZjU2lTaFBtNUVWQUJoUHVIbGJtMEFiQ0FTb0dSajNIMElpdWJQU2d5?=
 =?utf-8?B?ektoTm9VNkZqZXVpMVl6SkxBU01sY2Y3WlJ4b1hYenNnQVZuQTROQVZsd08z?=
 =?utf-8?B?czVkR3pzLytEUUgrSXRCNzdhVkdZK044cUdOWS96T1ZORklPTGlIK2drazFU?=
 =?utf-8?B?RGJjYnkxMHdDN3lxYUVCQlB3YlhmbXhJT3NtYVFlZU43cmJ0cGpvUDFlalRq?=
 =?utf-8?B?TCtiV2VEc0h5TXNta2MzR1kxTFZ2ME5XQTBtcG5tRUNVT1hscnIvME0zdzNL?=
 =?utf-8?B?d1g2am9uZzRpNnl3dUlXbXNBRmFDc3dqaFVjRHhMdURWQy8zdnpjejVsZEhv?=
 =?utf-8?B?YTVOMHhJbzBhVll1ZUE3N2tVQ3dZcVFDeW16SFp4a2hCMWg1VFZLL1lyaUhP?=
 =?utf-8?B?VS96TGRtbm1CcmE0UCtUZWR0WVk0aFhYMmxncW9NY1NKdkNCT1Vmd29ia0pN?=
 =?utf-8?B?OW9sS3J0ZG1OV2hhOXBLczdQZldqNTVhQitDdUhoVW9obG03Qk5zREp5b3FB?=
 =?utf-8?B?clJjVk05M1hJU1Z4RGs3d1I3c1ZvUGpVWFZNaW9lbGtkYjNMcWk5U3B0clZW?=
 =?utf-8?B?b2tGMTczQWxQam9STDhlZGVmRXU4MFlwaURDSFdtbE9ndlNsZ1VLYkJTMUVQ?=
 =?utf-8?B?eFJvSnRxeE5hbGVnSll0MCt5T1RrbTBhaE9tQ3ZLTDkxNWlydHJaMVUwS1BN?=
 =?utf-8?B?d3hNTTBURVFYZEVnTmVXcEdoU0ZoSVdCR1E4c0VrQXU0c0Zsb01BZ29hTm51?=
 =?utf-8?B?Rk1vdGVyWDBQNmRVQ0I1MlpkajVGcGp3THo1QXlqc3hFZzNYWml0b21YbTJH?=
 =?utf-8?B?bUMwb2dzeEpic2VXN0w3T2xHNk5TemtLTTNPbGZ1T3dlMzZGRDNUeGFpQkJ6?=
 =?utf-8?B?bXNVbXpTS1grcjlHeGhHdlczQ1RBalZLeXE0ckZvTmJkWWZWMTVRWWdTcmFX?=
 =?utf-8?B?Z2NYa0RHQXBzaHNvSUEwWDZyaExkaHVOakNsaEdqYkl3NmZiTnVoM05zdXBG?=
 =?utf-8?B?U3JCSzVrdlhTQVk5ekF3TVI0aXAwdTVtL2NzcWtnWk9WTHhhaWxMNTZtTXBR?=
 =?utf-8?B?UEhyL1dzZTEzYmIxQzBEekFzMXE4cmNtZTNqM3o2d2xRWFVVWHJoM0NNQ2x0?=
 =?utf-8?B?VFJjL1JxKyt5UDkyL3hjUjdzRVJlZFppRmVuSENOY2FYUE4yL1FidnVtSGN6?=
 =?utf-8?B?UzZac2ZJODJqelcybk96SjBLQTdsclU5MkdUaTMrUVFJcGJLM2NSeGtFWm9x?=
 =?utf-8?B?M3Z0WEdPODJ4MzRrbjVGWjJQcUQ0eGI5ai9IV2Z1VjJFaEp0WWcxMGdMdkR3?=
 =?utf-8?B?dnYwWWxiMFZTbTV6Q3o2Q2R3ZXlBWUJWanM1N25OeFlRMEpReUtRMkh3Qytp?=
 =?utf-8?B?Z2hsMjVseFNrWkU2VlNyOXBtWVAvVjhmME5sRDdMcmZ4ZXlGUmx5K3lRSmFM?=
 =?utf-8?Q?doMptwsxQNx+dqu4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B4ECA3216F30044AE0EEDE6ADD8003F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8df307-8bee-4bab-e523-08da4c6235fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2022 10:56:32.1928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5wLVKkjzb2aBZLavMsjo0Zh6HzCjtynJ1BAxOE+ZMIy3NmtHTaKjPatnr5NGRz8IWaMq1iA/yL8t21NTLZm5aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBKdW4gMTEsIDIwMjIgYXQgMTA6NDA6MzNQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBUaGUgdmFyaWFibGUgaXMganVzdCBhc3NpZ25lZCB0aGUg
dmFsdWUgb2YgYSBtYWNybywgc28gaXQgY2FuIGJlDQo+ID4gcmVtb3ZlZC4NCj4gDQo+IEFzIEkg
Y29tbWVudGVkIHByZXZpb3VzbHksIHRoZSBzd2l0Y2hlcyBpbiB0aGlzIGZhbWlseSB3aXRoIDEw
IHBvcnRzDQo+IGRvIGhhdmUgYSBkaWZmZXJlbnQgdmFsdWUgZm9yIFJUTDgzNjVNQl9MRUFSTl9M
SU1JVF9NQVguDQo+IE9uY2Ugd2UgYWRkIHN1cHBvcnQgZm9yIG9uZSBvZiB0aG9zZSBtb2RlbHMs
IHdlIHdpbGwgc29tZXdoYXQgcmV2ZXJ0IHRoaXMgcGF0Y2guDQoNCkkgd291bGRuJ3QgY2FsbCB0
aGF0IGEgcmV2ZXJ0LCBqdXN0IG5vcm1hbCBkZXZlbG9wbWVudC4NCg0KPiANCj4gSSBiZWxpZXZl
IGxlYXJuX2xpbWl0X21heCB3b3VsZCBmaXQgYmV0dGVyIGluc2lkZSB0aGUgbmV3IHN0YXRpYw0K
PiBjaGlwX2luZm8gc3RydWN0dXJlLg0KDQpPdGhlciBwZWRhbnRzIG1heSBhc2sgbWUgd2hhdCB0
aGUgcG9pbnQgb2Ygc3VjaCBhIHBhdGNoIGlzIHdoZW4gdGhlIGhhcmR3YXJlIGlzDQpub3QgZXZl
biBzdXBwb3J0ZWQuIFRoYXQgd2FzIG15IG1haW4gcmVhc29uIGZvciBub3QgaW5jb3Jwb3JhdGlu
ZyB5b3VyDQpzdWdnZXN0aW9uLg0KDQpUaGUgb3RoZXIgcmVhc29uIGlzIHRoYXQsIGhhdmluZyBh
Y3R1YWxseSBleHBlcmltZW50ZWQgd2l0aCB0aGUgbGVhcm4gbGltaXQNCm15c2VsZiwgSSBjb3Vs
ZCBpbiBmYWN0IG1ha2UgbXkgUlRMODM2NU1CLVZDIGxlYXJuIG1vcmUgdGhhbiB0aGlzIHByZXN1
cHBvc2VkDQptYXhpbXVtIHRoZSB2ZW5kb3IgZHJpdmVyIHVzZXMuIEkgdGhpbmsgaXQgYWxzbyBk
ZXBlbmRzIG9uIHdoZXRoZXIgSVZML1NWTCBpcyBpbg0KdXNlLiBTbyB0aGVyZSBtaWdodCBiZSBt
b3JlIHRvIGl0IHRoYW4geW91IHRoaW5rLg==
