Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2641B540386
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344062AbiFGQPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343740AbiFGQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:15:38 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50101.outbound.protection.outlook.com [40.107.5.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE54101700;
        Tue,  7 Jun 2022 09:15:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fb5e6eolhNxHYdE8xhPEW/ijMTveehn8vE0ZsdRhtLvAmJqlm4TMcF2QJqafxgfZGLvktef8QH6+PsRIyzk00U+1Sf+E+bqyOS9XS9J2JXLQezid/3BAsWqv4RONtM4JX/n2duGYPa31qKRI5t1I/jfnLtv1lNbPfEpVY7ZjVQp7nA+l8aLZEJSTe+2G73WFwMFjC6ohX0H63UmsAbnLtKwHW0KDZAjgMbFEpD2m59Fql/p9Q3qSO49gge/dYYsLxvtNjajnfPuGvwNvhYQveVS1HU31bUgFQYSFTSA3bP/4OpeAEWbaRVUL5N8AWh8WzFYbSG2To46ZQy51GcHvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwOLnViZdmBppkeY1OEU+44qmXXxNdx++EcMa4Idx1g=;
 b=ACwrrJdZ4j6KPrubh+hnDrMduC3tDBlbNOyVGRoTXHaRYxbs4ks3HQdcdQGdILVTswXOO3SGNsrZCYI34f8SoVyXi14FI/9mK8d8q7xLoEHCi0GTNw6vx8WF/34hHQFp7jtNSqGOobkmOyEyATU6MZcyCwXSDOYjARUKWSOL29A7J9LyTeqMuzjNRi6fIQEAKR8lGSbg/id23AqPT8hFOBLt+XrNkFECc1PnJFqM3tck7VAjUXXFnJc4GEW1+oJWno4PkywXgBEAkgRahcnkizkEFT4bp4ETyJt9lmXbENJ68RyzxxOjQZ+qjkonYAftMgig+CwR2kb0pHN4ZBRfBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwOLnViZdmBppkeY1OEU+44qmXXxNdx++EcMa4Idx1g=;
 b=cFKauRZeeVw0GnqlESxHPTkgE/fKbO1p35qK0vqAJ0DGUGzKKvcYYC5Xg/hldbKyqvF1+7avk3bYt1ZlphwYGYMz3PRq1Ti4iFv28fAZ/703AqEjt7vXYrbh7xgM70aRAkXWdAvSFfb1+TVQpwo+6L06xtd8Nnv9RLS0i1uPm/s=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR0302MB3471.eurprd03.prod.outlook.com (2603:10a6:803:1d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 16:15:33 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 16:15:33 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for ports
 with internal PHY
Thread-Topic: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for
 ports with internal PHY
Thread-Index: AQHYeaWWRGyRRdDb9EGDzfVT+zDwia1CYBkAgAAEbwCAAZPrAIAAA5gAgAADXwCAAAfEAIAAGSSA
Date:   Tue, 7 Jun 2022 16:15:33 +0000
Message-ID: <20220607161531.x5yfgkoyk55yieq4@bang-olufsen.dk>
References: <20220606130130.2894410-1-alvin@pqrs.dk>
 <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
 <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
 <CAJq09z6YLza5v7fzfH2FCDrS8v8cC=B5pKg0_GiqX=fEYaGoqQ@mail.gmail.com>
 <Yp9bNLRV/7kYweCS@shell.armlinux.org.uk>
 <20220607141744.l2yhwnix6aoiwl54@bang-olufsen.dk>
 <Yp9kjD0D9XYIvran@shell.armlinux.org.uk>
In-Reply-To: <Yp9kjD0D9XYIvran@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12f9bd6a-24c6-48f0-711f-08da48a0f2ea
x-ms-traffictypediagnostic: VI1PR0302MB3471:EE_
x-microsoft-antispam-prvs: <VI1PR0302MB34710347DE627656A8098B9883A59@VI1PR0302MB3471.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JvYIs3/4uqIFN68Th5AQ30jHsexRmIWPdIYHLFKecTLPrKbK1BV5opjji/THoana9Lga6ghbl6X2scxfdaXvkCn9yYc+PPEjkWPIU0jDpPRujb49uo7QgLClsiMKU5Uttp0oWUdRoTehwS8T7FgbvNw+wqr6K9JJpyn4IxcXhlJo5UkEsQVf+82ia0orhHwtWFBt2s4RKlB5hVSHM5mxKbDHoZcudlao/jIt3x0/9YCAiCMdGcS89rtBW85ZwcJfv5+stYtFxrMX8L6m4vxHP/s4SbILNYfqtDfO/+aEROscuCcDb1ewCYgU7smINQTUUfSOdPbZT+fKGe98tSrM1jsH0dCSNIIQwfu4Nd0M/I+Cw3cWtixX5VYPHmTsCKDc+DpHkSPBtJljz5IHsmdaTLyzObJV5x8H8Of55jmaW7ZQHrion5indldoezDuR/eJ6YvRSAOHsgE7GcWOoBZ+EPCCUSky3gDyPsgLFEhrFoqCgABWGMpfMfdlpPadPs/Yq2VlcM3b2sXtdj+ihZFe9PbEEyRzokTSJRxrHUJaZONNJJBrXXkf4pyacdX8JwzVV8qpuvgpuJCo7/M2+2iwyJygOJvnSnIHg6L+rHqwAAOKEid/ViY+aZP6OUI6ZBcqAhrONfLhmljI78IIU03KFvr8wvBcnzF8TQQgj7pWCBt6A4fuXmbjv2M2tz6cdxDClGK3aWOPlMP9RpQt1MlLBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(85202003)(6506007)(85182001)(71200400001)(54906003)(6486002)(76116006)(66946007)(8936002)(508600001)(5660300002)(66556008)(186003)(2616005)(66446008)(4326008)(8676002)(64756008)(7416002)(1076003)(66476007)(91956017)(26005)(8976002)(2906002)(122000001)(38100700002)(6916009)(316002)(36756003)(83380400001)(86362001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTlBNG9aeDM0S0NCb0Nhb01GUHhJU0hEcHRQcld6bk9PVTFxck5VOVM5bHBY?=
 =?utf-8?B?QlVkQ3dSTS84MVJUZ29wMWhta21ybnpjbWx3NjMxMFUzMVlNNEhJaG5DcE5L?=
 =?utf-8?B?dmpYODhOeUZaN3ZFMW5rVlJPSXlWUjFRM1l4QnFmM3I3TVpObjY5cG4xUElP?=
 =?utf-8?B?OTBiMEhETy9JQlJEVzlzUWpTUXQzNllCODY4ajUvMTZvNmRWbUFpc3dZU013?=
 =?utf-8?B?LzVHRFNnWkdWS2JSTGFXTjU2TjRqL1IxQ2FJWnNFYkZNeVlDWG9vVHhZN0JU?=
 =?utf-8?B?ZE5qVFB4SjBQYjJDdHA5QVdUeXpibStvQ0UxZWZFdi9xS1M3WnRyc0pweGYx?=
 =?utf-8?B?RGZXSnhtZHpSNDNReFJYS1hya2l0b3RicDRrTE81cm54VVdjOGtVVkI3MnRM?=
 =?utf-8?B?RWpWcmo5ZXQ2U3N5V2gvbzA3YjZ4NE5OWUlibzV5d0piZit5SzBlQ1Q2aDVy?=
 =?utf-8?B?RkpqQXZldExrekMxZjdzUWRYYzY1Y2ZsTWxZOEp1RDVXWnArMGpsU256clpw?=
 =?utf-8?B?ZEJ0QzZCK3BVSXJtVnBveCtDcnk1Q0ZESVd3MlpOamJIZGRaVWtaak9Ja3J2?=
 =?utf-8?B?VWhMVG1oWDlqK21FbHhSRWhPMHp6V0tRd2kwT1ZXMXRYcjRialRJQ0VoOUtK?=
 =?utf-8?B?K2hKdE5XeUhwUngrbHBBM1F3ME0yaEwvcEI1ZVpZUy9WN3ZpVi96Umt6ZGwz?=
 =?utf-8?B?NkFBSFkzN2E0dmkvcXRXS3pIWWE0Y3Q5aXErU1NKZmJGMXQxdzEvRitKbFVN?=
 =?utf-8?B?RGdQa3FlL0tBSFNackFiSlk4ZzM1TVdqK1IrOTdmeXBmdmJQdGlGQVpzdCtz?=
 =?utf-8?B?UmR1SkxpL3FmNHdHZjBUTFdCcE5rYmFKSUtEdTFOMGJDVWRCWDBaa0JTQ1k5?=
 =?utf-8?B?ZDZNT21lNnNEZnhiekJjK2kzWkNHZVVQdlBFSHp2SVA3OTdFdGgxNVlQbUpv?=
 =?utf-8?B?L1hxY01CMUlFbXRaOXhRcEljeUVuQ2xYaUJ0Z1REOS9qYWJPbURERHZqSGJM?=
 =?utf-8?B?bDkxcmE3KzVueHE1blFPZjRGSDFBN2l1Q3FVZVhDMDhwRDR5WE5FL0h2NkxS?=
 =?utf-8?B?eGx0bFRHNnljR0RzWENldFh3aExEZ0pXTG9rZDB5NlZUeU1ya2k1cC9EMWg0?=
 =?utf-8?B?YzdSOW9Ed0FjVjdaWUJxV0ErdHFJY0pnanZOUmo0VVA2UVdHNmovUkZRWWE3?=
 =?utf-8?B?RUJkUnVKd1BENXBTa1JMK0xHTWhwMGlIWHU0ZEx0MjNQLzVLU3NhbndaUStp?=
 =?utf-8?B?eGtQQlZlODdBOWJWMjVPNlVTMHluTVQ4dGVCMklvdnRBY1M2M1hJQzZFUm9D?=
 =?utf-8?B?TXFhT3diZlBENWN5WHFoTGI1cER1NDJaSUpDKy9ZODUxM0lGMXVnMHloQUJ4?=
 =?utf-8?B?dU1FSEZwWFBkVWJLNHdoNUQ5WVZUWUxxWk03cEFmWHN1aW5jd2NDTEdzZDhD?=
 =?utf-8?B?dlpTaDl4Z3RSbnJraEk3YWY5RmtQdmJ2V0lsNEpjbDdNVXpzamh4dU1rb05u?=
 =?utf-8?B?d1ZWTm51U3JNa0RTSEFJZjRYZlUrajRRR3QzcFI2emw5Rm9HejZoVjUwNlpE?=
 =?utf-8?B?MTFaY3VvQnB5cXZ5OHAwSk9RZmtrZFdlY2ZHNjZUbWwvVG1jTUIzdnduM2ww?=
 =?utf-8?B?cTFBUXJBNVYxZmg1Mis1VmgwYVZkekxsSDM0UUJaelNpaG81TkNrMnM0dnc0?=
 =?utf-8?B?Y2ZJUnlaaTdTdmxEZ2svd1FTMmtvZGJ4a1NKSG5Bc3hGa01vM1VmRlRMMUtU?=
 =?utf-8?B?N1FyYjY1VE11ZnVyZFh2Tm5qWWpzaGlnUmVraExja0NNajJUVGY2TytBYk1v?=
 =?utf-8?B?VVlENnI3VXQxSzdBSlcwUWlFQnl1dmtSWS9aZmEwMVhuaXJQYVdyYUVuYmpR?=
 =?utf-8?B?K2RENVUwOFZaS1pYSC9kc0NwTWFpMHk1dFR4MHlnWHpjcTBoK2NTc2JXNmht?=
 =?utf-8?B?OGZSa053UDFjSXlRRCtOalQwRUlibWJZdDRnZGEyMWhBbW9FaWttSUJDMGZP?=
 =?utf-8?B?dDR5T01GK0RFV040K1IzSkNZUHF0NkNmRjRJaEZpaXNFUlBjNVNUcVBEZktz?=
 =?utf-8?B?MmJwYlF5eW4wV1FGL1RyZnJRd0Qrbms5T25mM3ZKTzg5TVlSNkdKZTNhckFo?=
 =?utf-8?B?aUhxVTFHUS92MDJGb1g1MDl2ZTRkMGtVcjFNdDgrdzN4NWdvK1pBRVgvTUMr?=
 =?utf-8?B?TUc0bml6T3FQMHA4NytHM2xVeHRRTThIQVBSK0dubHFiMklzYzdvcnNaRTI0?=
 =?utf-8?B?SmVDaFN0TXBxZ2NlTlN0NURiZVZsNFFWc2k0N2trbmczWlVabmpDa2x1ck9p?=
 =?utf-8?B?RWNNelBNWmtpaXU1K2JTeDY2bEFIaGFzKzZBNllldVd6a0F2NkdEbmY0bytj?=
 =?utf-8?Q?uJo2dPc2q+/eagdw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29C574163DA35E458CCFD8D21BD9A95D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f9bd6a-24c6-48f0-711f-08da48a0f2ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 16:15:33.3139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5TWBIr8yBFwJ1ooTLCDVWHCnUEtdvsw7GnOn6l04v7jEZZ9hnglJwwHs4gN2ymMiqeSYp4SoXkTDB0ueQTmOaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3471
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBKdW4gMDcsIDIwMjIgYXQgMDM6NDU6MzJQTSArMDEwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiANCj4gVGhpcyBvbmUgSSBhZ3JlZSBjb3VsZCB3ZWxsIGJlIHRoZSBj
dWxwcmV0LCBidXQgaXQgbWVhbnMgdGhhdCB0aGUNCj4gb3JpZ2luYWwgcHJlbWlzZSB0aGF0IFBI
WV9JTlRFUkZBQ0VfTU9ERV9JTlRFUk5BTCB3YXMgYmVpbmcgdXNlZCBpcw0KPiBpbmNvcnJlY3Qg
LSBpdCdzIGFjdHVhbGx5IGJlZW4gcmVseWluZyBvbiB1c2luZyBQSFlfSU5URVJGQUNFX01PREVf
TkEuDQo+IA0KPiBJdCBpbnN0ZWFkIG1lYW5zIHRoYXQgUEhZX0lOVEVSRkFDRV9NT0RFX05BIHdh
cyBiZWluZyB1c2VkLCB3aGljaA0KPiByZWFsbHkgaXNuJ3QgZ29vZCwgYmVjYXVzZSBQSFlfSU5U
RVJGQUNFX01PREVfTkEgaW50ZXJuYWxseSBpbnNpZGUNCj4gcGh5bGluayBoYXMgYWx3YXlzIGhh
ZCBhIHNwZWNpYWwgbWVhbmluZyAtIHRoYXQgYmVpbmcgd2l0aCB0aGUNCj4gdmFsaWRhdGUgc3Rl
cCB3aGljaCBoYXMgYmVlbiB1c2VkIHRvIGdldCBfYWxsXyBwb3NzaWJsZSBtb2RlcyBmcm9tDQo+
IHRoZSBNQUMuIFRoaXMgd2FzIG5ldmVyIGludGVuZGVkIHRvIGJlIHVzZWQgZm9yIGFueXRoaW5n
IGV4Y2VwdA0KPiBwaHlsaW5rJ3MgaW50ZXJuYWwgdXNlIHRvIHJldHJpZXZlIHRoYXQgaW5mb3Jt
YXRpb24gZnJvbSB0aGUgTUFDDQo+IGRyaXZlciB0byBtYWtlIGRlY2lzaW9ucyBhYm91dCB3aGF0
IG1vZGUocykgYSBTRlAgc2hvdWxkIHVzZS4NCg0KUmlnaHQsIGFuZCB0aGVyZSBpcyBldmVuIGEg
ImRvIG5vdCB0b3VjaCIgd2FybmluZyBpbiB0aGUgZW51bSBkZWZpbml0aW9uIG9mDQpQSFlfSU5U
RVJGQUNFX01PREVfTkEgOy0pDQoNClRoYW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9uLg0KDQo+IA0K
PiBTbyB5ZXMsIHRoaXMgaXMgbW9zdCBsaWtlbHkgdGhlIGN1bHByZXQsIGFuZCBpZiBwcm92ZW4s
IHBsZWFzZSB1c2UNCj4gaXQgZm9yIHRoZSBGaXhlczogdGFnIGZvciBhbnkgZml4ZXMgdG8gZHJp
dmVycyB0aGF0IGluY29ycmVjdGx5DQo+IHJlbGllZCB1cG9uIHRoYXQgYmVoYXZpb3VyLg0KDQpJ
ZiBJIHRha2UgbmV0IGFuZCByZXZlcnQgdGhlIGFmb3JlbWVudGlvbmVkIGNvbW1pdCwgdGhlbiBJ
IGFtIGFibGUgdG8gY29ubmVjdCBhDQpQSFkgYW5kIGluZGVlZCB0aGUgbW9kZSBpcyBfTkEsIGFz
IGV2aWRlbmNlZCBieSBsb2cgbGluZXMgbGlrZSB0aGlzOg0KDQpbICAgMTAuNzAyMjA1XSByZWFs
dGVrLXNtaSBldGhlcm5ldC1zd2l0Y2ggc3dwMDogY29uZmlndXJpbmcgZm9yIHBoeS8gbGluayBt
b2RlDQoNClNvIGExOGU2NTIxYTdkOSBpcyBpbmRlZWQgdGhlIHJlYXNvbiBpdCBicm9rZSBmb3Ig
THVpeiB0byBiZWdpbiB3aXRoLg0KDQpTbywgaW4gc3VtbWFyeToNCg0KLSBpbml0aWFsIGRyaXZl
ciB2ZXJzaW9uDQoNCiAgcnRsODM2NW1iIHdpdGggbm8gcGh5LW1vZGUgc3BlY2lmaWVkIG9uIHRo
ZSBwb3J0IHdvdWxkIGNvbm5lY3Qgd2l0aCBfTkENCiAgYmVjYXVzZSBpdCBzdXBwb3J0ZWQgaXQg
ZXJyb25lb3VzbHk7IGF0IHRoaXMgcG9pbnQgaW4gdGltZSwgd2hlbiBubyBwaHktbW9kZQ0KICBp
cyBzcGVjaWZpZWQgaW4gdGhlIERULCBfTkEgZ2V0cyB1c2VkLCB3aGljaCBpcyBhbHNvIHRlY2hu
aWNhbGx5IHdyb25nDQoNCi0gYTE4ZTY1MjFhN2Q5ICgibmV0OiBwaHlsaW5rOiBoYW5kbGUgTkEg
aW50ZXJmYWNlIG1vZGUgaW4gcGh5bGlua19md25vZGVfcGh5X2Nvbm5lY3QoKSIpDQoNCiAgcnRs
ODM2NW1iIG5vdyBkb2Vzbid0IHdvcmsgd2l0aG91dCBwaHktbW9kZSBzcGVjaWZpZWQgYmVjYXVz
ZSB5b3UgZml4ZWQgdGhlDQogIF9OQSBiZWhhdmlvdXIgYW5kIG5vdyBfR01JSSBpcyB1c2VkICh3
aGljaCBpcyByaWdodCksIGJ1dCBydGw4MzY1bWIgZG9lc24ndA0KICBzdXBwb3J0IF9HTUlJDQog
IA0KICAgIA0KLSBhNWRiYTBmMjA3ZTUgKCJuZXQ6IGRzYTogcnRsODM2NW1iOiBhZGQgR01JSSBh
cyB1c2VyIHBvcnQgbW9kZSIpDQoNCiAgcnRsODM2NW1iIG5vdyBzdXBwb3J0cyBfR01JSSBzbyBl
dmVyeXRoaW5nIHdvcmtzIGFnYWluDQogIA0KLSA2ZmY2MDY0NjA1ZTkgKCJuZXQ6IGRzYTogcmVh
bHRlazogY29udmVydCB0byBwaHlsaW5rX2dlbmVyaWNfdmFsaWRhdGUoKSIpDQoNCiAgcnRsODM2
NW1iIGJyZWFrcyBhZ2FpbiBiZWNhdXNlIF9HTUlJIGlzIG5vIGxvbmdlciBzdXBwb3J0ZWQgZHVl
IHRvIHNvbWUNCiAgcmVmYWN0b3JpbmcNCg0KSSB3aWxsIHJlLXNlbmQgdGhlIHBhdGNoIHRoaXMg
ZXZlbmluZyB3aXRoIGFuIHVwZGF0ZWQgZGVzY3JpcHRpb24uDQoNCktpbmQgcmVnYXJkcywNCkFs
dmlu
