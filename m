Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E537659DB87
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353476AbiHWKX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 06:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355122AbiHWKWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 06:22:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2111.outbound.protection.outlook.com [40.107.22.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCE061731;
        Tue, 23 Aug 2022 02:04:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mE/4XGmteJ7nj1qOve1aFQiXBjfRbGsQwWXVpojdPMfpgRWco63UDAyqVqXSeM/kIVk100JStJvDPcai1lL25uaIYXbz0eqyC4FaoxhmbnsFCdryzBIdc46E/ejwPZwqO5z8+kYH6tnG5pA/8VvERy96p3MrP9dz3VkVtNG/c915u22jITNrhncPjfND6uPsRszFPhUMpoKHxLr/+zkXWxrnvHcUFXd7xBpP16q9Evk9YyAVF6yZ3iQvy0fpBr3oPDBJoBijf3MN8By0w0BsoeEnUXloPp8x+gE7T3uMvK1zDkTLivxCteTjZo/8F3HoTvBRxw6F50mvpAmx1+ppOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVOyJTqCBmfFQAE8IlZy5sr9FyrQpvLn0qQfTZiOaBM=;
 b=a80ZWVyL0v+42WsYU/jTlB0mLJ3y1NPsH+eKczE2k4Ki9bVA5H945gi6Ngzvj//dZUJNaYSABRViNBnOFRa2R3vaJ800ms8EUTeZ9r4Jdoi3bmanKIaPWuS5eYoReZ3mJWlRDYVrK6oaKs0U2zHvtdV5yzr1T9mWiuXjvhnhKe7QCaxJHf3kb15Wdg47vehYa/oXqkT2UlYhlIpFnmk798ctdxdFgdEYPSprJr5KPVb5KJXMUE8rY9GWu3oHSzP5rCvcVvQyR1GaqkUAxQ5S+3vPgDoUNTjA9JCX3w5G23Dd39Zp/N1Ux+z6kmkBY1t10ZLzqIRluDzEEskoRF380g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVOyJTqCBmfFQAE8IlZy5sr9FyrQpvLn0qQfTZiOaBM=;
 b=Rk1Nv/B0ITvYedM5p6oHwILdiWQKClZlWohXOUwDEv4SVtiXwIYuLJuV/+EK+xL2Kh9ha32Qdx9ynsAQ43DsPnBe8isaIBPn+/LqxXaaxqiYl0vk9qeHZVuqtMfSmExV29MAEpm6NvfpI18ue+WRbNVuHQB0xS96cvB/DlSjIS8=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by AM4PR0302MB2593.eurprd03.prod.outlook.com (2603:10a6:200:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.24; Tue, 23 Aug
 2022 09:03:58 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e%7]) with mapi id 15.20.5482.016; Tue, 23 Aug 2022
 09:03:54 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Franky Lin <franky.lin@broadcom.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Arend van Spriel <aspriel@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next 1/2] brcmfmac: Support multiple AP interfaces and
 fix STA disconnection issue
Thread-Topic: [PATCH -next 1/2] brcmfmac: Support multiple AP interfaces and
 fix STA disconnection issue
Thread-Index: AQHYncbIqgE6tTzSOEmqAWMY+pX2wK2oxbkAgAordoCACGfoAIABCeSA
Date:   Tue, 23 Aug 2022 09:03:53 +0000
Message-ID: <20220823090353.me2pxlq4uzotp6jz@bang-olufsen.dk>
References: <20220722122956.841786-1-alvin@pqrs.dk>
 <20220722122956.841786-2-alvin@pqrs.dk>
 <CA+8PC_fYF7aZCBEweF5s0+8Rr_5yRQcMutFJ2gCKs6QEdmrw6g@mail.gmail.com>
 <20220817085015.z3ubo4vhi5jeiopo@bang-olufsen.dk>
 <CA+8PC_fGeV09ve=VE=V9yneghg_rfDZmEAZBVmA9rivinMmd5A@mail.gmail.com>
In-Reply-To: <CA+8PC_fGeV09ve=VE=V9yneghg_rfDZmEAZBVmA9rivinMmd5A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b464e8c4-e0e8-4f2b-3245-08da84e6677c
x-ms-traffictypediagnostic: AM4PR0302MB2593:EE_
x-ld-processed: 210d08b8-83f7-470a-bc96-381193ca14a1,ExtAddr
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q3U6i4iIGsOqxihyETXXYJ7o4gBrHZfgeYUbrNaZqgCV1sIsQtg5/TdmxlzPc6Mim1ZboyKSvUIRGxu9m4WQe+EB3ROvyUvPLvVD72icRdwg+r5Ux81O2QpGpUKtobTAZ/Ojrg1L7Vwjr5VSkw2G0lROqMMKaKBAv+iJEodhTNhjSU8LZxlmB69MjXFRBvB2ZuqOtIi6TmHRGuDEgsFTsJHcODIxkgeCbtot67EblX96Wx9xcPBTwxG2h6AOmgK5SEXSM7onBx6/pOJ/dgmiGFDVvBdRXvfYm4LlHqO6/qFLUQIPM/TitL8mvkp30fV/sBgy8yQYUGss3HjZqd39uV6KT3gFwXT4+9dVjuGTx+EIBcOiPkUVCdI52AgJn5P3Yfo5Dfc+CJwnB4JO5r6+3TrIY36wHgQQzzfupanXHIGrIILK5BIsTicJDfr6WbIK2n3HJj/vccXgcaqFOzZehHEmH217Zd8+KStYb5HYw1g5u4R6Yqq/y7VdiKx19Z7zwnWjiD6q+/S/ZTqdtWV+302w4wA7TdKXQhE44Su+/rPZi7VK9drvBx+imsFa3XT4TpwOonWvfmb2uTV+FltcbcByyqo8aUjEhHMf6JmbSeWS+mRyJ2htg/zFFo8vBmffcioLN2N74vjuYe68cgSxBwvxwVyXzihbSpn00BcJahz1ZSOVjigRmKcAVRmEtC4eAB/utSmCh5gfYb1IQAMHF71qgOOwD+qsouv3sFMG+FPxr2N1hUQsC+WOcnhqW14E5iGti+8+AwYyT5RYsA2SKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39850400004)(376002)(396003)(346002)(122000001)(316002)(36756003)(85182001)(54906003)(6916009)(8936002)(8976002)(71200400001)(83380400001)(38100700002)(85202003)(6506007)(66476007)(478600001)(66556008)(66446008)(6486002)(76116006)(66574015)(66946007)(91956017)(38070700005)(8676002)(64756008)(4326008)(1076003)(186003)(7416002)(5660300002)(2906002)(53546011)(41300700001)(2616005)(86362001)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzhSN2xVN0NWWWZPUHRIcDE3cjRmQVZHVUlhN05ycDI4c0E5amlIVmFkSWo0?=
 =?utf-8?B?V0xWcHVEQmM4aS9NakN1RElmYnozZmNSMnZFSzZnNVBIMks2ZkM2MTkvUEJh?=
 =?utf-8?B?cXF1RHp6NlpQV2x2Rmk2VXJERWUwcDBZRjRodmtVekIrZit0VkZWTTE5TVVy?=
 =?utf-8?B?aGE1SW5keGdNMTd6ZWVDMnNoTi9IT1cyeXJoUjlFbzRQV1l0OTM2SE1nb0lj?=
 =?utf-8?B?TEJUbTNRdTlxcWJlR0M1SENCOEpod2NwaHphZHh0S1c1Wkh1S2hVa2NGdXcr?=
 =?utf-8?B?cEJleDdMRUNobHFYb2srRDdEZ3BxRUYzZXF4eE5jSXUvYzBFTFVjZE1Fdzkx?=
 =?utf-8?B?SHJsL1FrS3JKb1kwaXNaNkpvZTZqbVdITUFNL3YvY3J2dGFobzFYQ1hUOTBY?=
 =?utf-8?B?YnRtaVRaUHI4MHZsa1JhcnZLMEN5aFJuc0ZrTGtNb1BpL0t3VjdjMEpucEx6?=
 =?utf-8?B?WUp5ZDgwUFRiWUNZMGtEdVNlYmVUdUxwcUUvTlBjWlFrMlFOTW10RnJxUENY?=
 =?utf-8?B?UTgxT1RLV1JNRVh4c1kwaHNEVFlaWDg5MFJwWUxSbjJRdUQxQ0ZqQmV3NHNv?=
 =?utf-8?B?M1g1VDVrTmJEK1lYdnZqMncvSzlnN1JPQ0FTVnoyS1ZnWWk5ZkF4YnBTcWlG?=
 =?utf-8?B?Z3VRdWNQTU9TSFNHNnp3bmtaOUlKMGwzNytDUEtoM1NxVkE4OGY3UkNTdzJR?=
 =?utf-8?B?M0d4MTk1Rko4N0ZsSGV3OVZydmZXcUl5dFNEYy9nSisyZmJPcnJDZUpJK25D?=
 =?utf-8?B?d1RESVpqeWlYYU1GQUxOZFJuQXJLNG1yKzJZcWxQUUhydmpNRzErMVBTbkw0?=
 =?utf-8?B?VEFIcXY4K2JtT1VLSEtwK2VRV0w0bFlLN1VnaTYrVjM3WjEwWW1wSmFyR1Ry?=
 =?utf-8?B?di9mNmh2Ly9lTEl5UVIwV21uLytNUUlTdCtQb3RUL1FneEpRZ2s5Z29sQkxl?=
 =?utf-8?B?NzV0WVNwMHBManZNR0FROFRRYXNZUTQ0eXRON0lKZE9VYkxiUERwcDRLSVg4?=
 =?utf-8?B?eUtsTHdhUWpvc2EyMVE4TERUY0d2eUl1dkpiaStmSUh2ZG9qbUZjSENuS2ly?=
 =?utf-8?B?cSs4UkZKUld1Rk9BT3hFSStOYXVTK2xkN2I2eThtWGVTZlg0aTVhaitEZ2JU?=
 =?utf-8?B?aGtwOTdpcFBobVZaYVI4blhPdDZSSWdHUjhRaExYTzcweWJMbjI0ZUMwQWRp?=
 =?utf-8?B?QThnMmMrUm9oSG5WeXVKV1RNallrQjJtT3Bib3RaUWZIemFqUlVBbTc3bTBu?=
 =?utf-8?B?YnNwa1dPTXAxb1d1VE8yRGRncExKWnNjS0FoWE5yVmZHc1I0c2xQRGpLOVFR?=
 =?utf-8?B?dXo5L2d0Y0VuTkJiY1cycnkzTFpmenQ4dDhlZDhPV2pPSk95QU92QWlrTGlB?=
 =?utf-8?B?ZVAycjNEL3JvVjVPVlZDVnFzRjZmNlBNS1JzTGlhVkpScHB4SzNVNDVQQys3?=
 =?utf-8?B?azlweFBYUG45S3hwOThOcWRIaGJsNWlWc3dZdnpjdkdGYVpncDQyamJBRXNU?=
 =?utf-8?B?eDBYc3R0R2pSZWFMdDVZQ3k0NFFQRVVkV2lUaXprV0xud3VGMnhSUkRBb0ZE?=
 =?utf-8?B?Z1VmcUxIR25lbHVIdjVCTXlWUytEdUpQNzUxbFQ0bForNGdvdzFUM0VWUm1I?=
 =?utf-8?B?OE1RSnYwVjhYeTl3OVhuWGMvNGVUSHZYR2xCeUtCMk1OSlg2bk84T00rVmVX?=
 =?utf-8?B?dW5QcWpPc1VjQURVTG1NamZ3ZW9sSHJEY2tZL21KK1VWN25zVkxnS1g3YWY0?=
 =?utf-8?B?UllUMjd4YzZTSHE0ZmVSNDZLS2J3a1NwdC9CQTVyZXBPWUlQanpwNjRVaVhF?=
 =?utf-8?B?dk5ibnlJRWp1ZGlROHAxeStoZkZta2tYcitIUE9Jc3g1cHJyWGsweGx6YTRE?=
 =?utf-8?B?Zjgxc1lQaVgxM1R3aHJnbk5HbFdTbGFXMmtNOENtOUtGSU9qUHVZczJhaWIz?=
 =?utf-8?B?eStqWkVYQ0Q2eFQxb0xhVTVJYXZta2p3VmlQczJ1YVIva0YzemUwWm5ZTVFr?=
 =?utf-8?B?MTVDeWlLb3M3ajF3UElEb2lZNzRjcGZ0U3NCREJJSU1Gc2R6aTNGc1BGTmxQ?=
 =?utf-8?B?c3VlT1lubHlTVWtVMm9XZVpzaFN5eGdGTlRhKzhMWURpODNPWm1NU1Y2T0Nw?=
 =?utf-8?B?NEtLSTZWLzJvNUwvNGNoVnM4dllla3lhZkVzcHVoTmlvZWFyR3FWWnJHcEFw?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E4C073E9F54D948A66F88C8F19CADC7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b464e8c4-e0e8-4f2b-3245-08da84e6677c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 09:03:53.9571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AVl3IsQgTEc/wDGlJm7J1bo3qtcUvAV1wPoD58ugZUdKPck0DG4GuO5u8kY2NbmPQxJM17/OWvc5vwb+GDbOvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0302MB2593
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRnJhbmt5LA0KDQpPbiBNb24sIEF1ZyAyMiwgMjAyMiBhdCAxMDoxMjoxNEFNIC0wNzAwLCBG
cmFua3kgTGluIHdyb3RlOg0KPiBPbiBXZWQsIEF1ZyAxNywgMjAyMiBhdCAxOjUwIEFNIEFsdmlu
IMWgaXByYWdhIDxBTFNJQGJhbmctb2x1ZnNlbi5kaz4gd3JvdGU6DQo+ID4gT24gV2VkLCBBdWcg
MTAsIDIwMjIgYXQgMDI6MzI6MDZQTSAtMDcwMCwgRnJhbmt5IExpbiB3cm90ZToNCj4gPiA+IE9u
IEZyaSwgSnVsIDIyLCAyMDIyIGF0IDU6MzAgQU0gQWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMu
ZGs+IHdyb3RlOg0KPiA+ID4gPiAgLyoqDQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29tbW9uLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY29tbW9uLmMNCj4gPiA+
ID4gaW5kZXggZmUwMWRhOWU2MjBkLi44M2UwMjNhMjJmOWIgMTAwNjQ0DQo+ID4gPiA+IC0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb21tb24u
Yw0KPiA+ID4gPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEv
YnJjbWZtYWMvY29tbW9uLmMNCj4gPiA+ID4gQEAgLTMwMyw2ICszMDMsMTEgQEAgaW50IGJyY21m
X2NfcHJlaW5pdF9kY21kcyhzdHJ1Y3QgYnJjbWZfaWYgKmlmcCkNCj4gPiA+ID4gICAgICAgICAg
ICAgICAgIGJyY21mX2RiZyhJTkZPLCAiQ0xNIHZlcnNpb24gPSAlc1xuIiwgY2xtdmVyKTsNCj4g
PiA+ID4gICAgICAgICB9DQo+ID4gPiA+DQo+ID4gPiA+ICsgICAgICAgLyogc2V0IGFwc3RhICov
DQo+ID4gPiA+ICsgICAgICAgZXJyID0gYnJjbWZfZmlsX2lvdmFyX2ludF9zZXQoaWZwLCAiYXBz
dGEiLCAxKTsNCj4gPiA+ID4gKyAgICAgICBpZiAoZXJyKQ0KPiA+ID4gPiArICAgICAgICAgICAg
ICAgYnJjbWZfaW5mbygiZmFpbGVkIHNldHRpbmcgYXBzdGEsICVkXG4iLCBlcnIpOw0KPiA+ID4g
PiArDQo+ID4gPg0KPiA+ID4gSSBkbyBub3QgdW5kZXJzdGFuZCB3aHkgZW50ZXJpbmcgYXBzdGEg
bW9kZSBieSBkZWZhdWx0LiBUaGUgbW9kZSBpcw0KPiA+ID4gc3VwcG9zZWQgdG8gYmUgZW5hYmxl
ZCBvbmx5IHdoZW4gYW4gQVAgaW50ZXJmYWNlIGlzIGNyZWF0ZWQgaW4NCj4gPiA+IGJyY21mX2Nm
ZzgwMjExX3N0YXJ0X2FwLiBJIHRoaW5rIG9uZSBvZiB0aGUgc2lkZSBlZmZlY3RzIG9mIGFwc3Rh
IG1vZGUNCj4gPiA+IGlzIHRoYXQgbWVtb3J5IGZvb3RwcmludCBzaWduaWZpY2FudGx5IGluY3Jl
YXNlcy4gSXQgc2hvdWxkIHJlbWFpbg0KPiA+ID4gZGlzYWJsZWQgZm9yIFNUQSBvbmx5IG1vZGUg
KHdoaWNoIGlzIHRoZSBtYWpvciB1c2UgY2FzZSkgZm9yIGJldHRlcg0KPiA+ID4gcGVyZm9ybWFu
Y2UuDQo+ID4NCj4gPiBCeSBiZXR0ZXIgcGVyZm9ybWFuY2UsIGRvIHlvdSBqdXN0IG1lYW4gImxv
d2VyIGNoYW5jZSBvZiBtZW1vcnkNCj4gPiBleGhhdXN0aW9uIj8gSWYgc28sIHN1cmVseSB0aGUg
ZmlybXdhcmUgd291bGQgYmUgZGVzaWduZWQgc3VjaCB0aGF0IGl0DQo+ID4gZG9lc24ndCBydW4g
b3V0IG9mIG1lbW9yeSB1bmRlciB0aGUgYWR2ZXJ0aXNlZCB1c2UtY2FzZXMgKFNUQSwgQVArU1RB
DQo+ID4gZXRjLiksIHJlZ2FyZGxlc3Mgb2YgdGhlIGN1cnJlbnQgYXBzdGEgc2V0dGluZz8NCj4g
DQo+IEkgdGhpbmsgc29tZSBwYWNrZXQgcmVsYXRlZCBidWZmZXJzIHdpbGwgYmUgYWRqdXN0ZWQg
Zm9yIGFwc3RhIG1vZGUgc28NCj4gdGhlIHN0YSBtb2RlIHBlcmZvcm1hbmNlIHdpbGwgaHVydCBi
ZWNhdXNlIHRoZXJlIGlzIGxlc3MgYnVmZmVyIHRvDQo+IHVzZS4NCj4gDQo+IEFub3RoZXIgc2ln
bmlmaWNhbnQgaW1wYWN0IEkgYW0gc3VyZSBhYm91dCBpcyBzb21lIHBvd2VyIHNhdmluZw0KPiBm
ZWF0dXJlcyB3aWxsIGJlIHR1cm5lZCBvZmYgb25jZSBhcHN0YSBtb2RlIGlzIGVuYWJsZWQuIFNv
IHRoZSBjaGlwDQo+IHdpbGwgZHJhaW4gbW9yZSBwb3dlciBldmVuIHRoZSBBUCBpbnRlcmZhY2Ug
aXMgbm90IGNyZWF0ZWQuDQoNCk9LLiBBbmQgdGhpcyBhcHN0YSBtb2RlIHNlZW1zIG9ubHkgdG8g
YmUgdXNlZCBmb3IgU1RBICsgUDJQIG1vZGUgaW4gdGhlDQp1cHN0cmVhbSBkcml2ZXIncyBjdXJy
ZW50IGZvcm0uIEJ1dCBkb2Vzbid0IHRoZSBkcml2ZXIgYWxzbyBzdXBwb3J0IEFQICsNClNUQSBt
b2RlIG9yZGluYXJpbHk/IFdvdWxkIGFwc3RhPTEgbm90IGJlIG5lY2Vzc2FyeSBmb3IgdGhhdCB1
c2UtY2FzZT8NCk9mIGNvdXJzZSBJIGFzc3VtZSB5b3UgY2FuIG9ubHkgYW5zd2VyIG1lIGZvciBC
cm9hZGNvbSBjaGlwc2V0cy4NCg0KVHJ5aW5nIHRvIHVuZGVyc3RhbmQgd2hldGhlciB0byBkcm9w
IHRoaXMgd2hvbGUgc2VyaWVzIG9yIHdoZXRoZXIgYQ0KbW9kaWZpZWQgdmVyc2lvbiBjYW4gYmUg
c3VpdGFibHkgdXBzdHJlYW1lZC4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4NCg0KPiANCj4gUmVn
YXJkcywNCj4gLSBGcmFua3k=
