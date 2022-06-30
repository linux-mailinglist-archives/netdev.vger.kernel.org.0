Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3415623C5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiF3UEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbiF3UE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:04:29 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140119.outbound.protection.outlook.com [40.107.14.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678BF33A3F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 13:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzW3e6Tlu+vFOTGzCgLEz8wxhiYqKXTuurIgOalvpstCzRdah/R2qUscizJzj9XC+ZmjjFDo/458mHF51lt6rJ1YbJbgfFszzTuiNvdFP8SywlfZ3tTblaKv7WisJamlDQhSQ+W3vdL3lcc4hfsloboG6J2S3E8oV2bMUJzQyF6XtyfrtInI7AeIX8fVncUy/jOS23GxDuaqWYHOKm3ASWSsPJ1+eMZtjFWPPG59F2PCPJqLk1lIoczIyxU7Fxlya/Suf4znDGZR6lSxk0uwS8YgaB/Vg/soXpU68L0MOWIhsUXFLX5q1fyben5IiONeJaPNj3i/WS+Q0AErZc5eKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0d04v5rxk9bCqu8GNb2b2+8/Rv+aSUuigAsFj4xcFHs=;
 b=c9nuHVvlSPG7FIEthub1mjguQvv7cYC9rTp8aSwki1op/Y33Y8X0RjPK+zNmIe5MEWgdMne/xy8a/Wu3ckWKIvyUTI9GlZDczhHN0dHQRCcONlHnM3z9paRwIWL6266s6C3Og4HTQiq2inrg1PMYpVwZZafypMtRRV1BSePHTvxEXhpOGvW7RWPOHokgE1Yk8duXIecDeyrlOgiBrXdwfbiqnEvDg7LYveDaQyKRXjzlj7zloxs/WVsMPojBbW1qxZ8drSo/lIyGOI3SVNbVrshP2vwIUuGUtnN7oG5XZZ+sP4qkDb5kC6AYqQW26lnvuNO6gUz0VYzug6qlw3sl2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d04v5rxk9bCqu8GNb2b2+8/Rv+aSUuigAsFj4xcFHs=;
 b=S2h37Z5ZIfQYrlN9oIdtPXg7QRK6lkTIJqbwwp2sSOn+9ExgWBnICu5FdiMBsT1Zz0kkDOeAq9PqvaUIs6neQYtHTXv4CLLZusNbrjwcFQoH1qP37sScBLPp6oU6Ys2p55NDRgu2LHrMXg7okjlip+4SuWNXMPMDfyVTRVpdX5M=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by DB7PR03MB4298.eurprd03.prod.outlook.com (2603:10a6:10:1b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Thu, 30 Jun
 2022 20:04:24 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78%6]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 20:04:24 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
Thread-Topic: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave
 MII
Thread-Index: AQHYi2v6y8XzldS8b0+51yVWVr7FnK1ml/OAgAAZeYCAAX76gIAAMfCA
Date:   Thu, 30 Jun 2022 20:04:23 +0000
Message-ID: <20220630200423.tieprdu5fpabflj7@bang-olufsen.dk>
References: <20220629035434.1891-1-luizluca@gmail.com>
 <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
 <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
 <CAJq09z6iX9s75Y2G46V_CEMiAk2PSGW6fF4t4QSPbjEXgs1iTQ@mail.gmail.com>
In-Reply-To: <CAJq09z6iX9s75Y2G46V_CEMiAk2PSGW6fF4t4QSPbjEXgs1iTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0dbcf988-0782-42d5-5fde-08da5ad3ba84
x-ms-traffictypediagnostic: DB7PR03MB4298:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nrGD9TvLktkvWvQfYAdyiZ7IW0ARx4EmJXuEuRQ846CXPcAO9WqrCz8IyPkQBfkkHfeWBqOYyf8yDaKlS3DvzPTfY2K14hT9/TF0btU4abkgQEJ5sZacaOTzHwiJ7UEtH+iJBAcwr91GYf24sljDEc5Wom8kTQ+T/gk3Ic53wElpwOQI51yjoytsVd1BW0lPOJCugSE4biyu1xqVDSky46shOXnBfs9nj2MTe1j1+yMGrWreWEyO512D4LQpmE1durs0e5Q0ZAMf9es3jS4JGsqcHfT+qzNTdoGCDAwIVM/RJecfAhxAJXA+9YoaMEcKcjIWmBLSNxOg/X5IHgq0xnfMdJyYwIyAXYVgx5ytgd0XfPCiMVhVGabd6wfo5txEwcIra91LGsCdHVx1SMGG9PECTNO1BmPjpT0+iBAGbXkU36wsV5NMv6srKr+pqA42sxPDg4y/dXu7A3xssR7KojKIBRQYdel6PRUR/dHdNoXQmJc8UooELqu7BsNVhCt3R9PJ4EUVrYBZX+Qnte4iQ+6SoOxh96N3fu7NWaX2i18danw/qJTSB661lEzCX4WyIOzbUwyaAncgScV5IhGHOk7mMcdaoR+A7TP7mmSwL1ehdOIsIeYHrpX2hvNXxPwAzc+H20bkMx85/fm4gs5xnotnYXrwajNy1ALe6o2nhslwcut9oKo4rAM4tznL2KLwIyajtHM1hch0+QE949Pk30uRCEGYAU3EmmlFCgNnqmsomX3QmuSZIZItZEQ9yAlA0f2Ba3+IElyFGsBZe/7TMI0EK973A9f87xDa1/CGc057rG6tpYRgkAVat2emGWsj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(376002)(39850400004)(396003)(76116006)(86362001)(2616005)(66446008)(316002)(4326008)(6486002)(85202003)(8676002)(6916009)(26005)(66556008)(66476007)(36756003)(66946007)(6512007)(91956017)(54906003)(71200400001)(5660300002)(41300700001)(8976002)(38070700005)(8936002)(186003)(38100700002)(478600001)(122000001)(2906002)(1076003)(7416002)(85182001)(64756008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWh1b3dVNWVISTJ4aVAvV2s4T1JTa09wYkl0Nk5kcHNJNjV3dnpheVFmdmFp?=
 =?utf-8?B?WDlpcDlhVWZUYjBaQVNzclhMVHB2aWhVK3U0RVhKQWV4WGt6elVsUTdsSnkv?=
 =?utf-8?B?ZHBodzRwRkNqT0FzZ0xUSTkzTDdZMjFHK2pJeDhNQXYyWTBPckNjM2VXcjRy?=
 =?utf-8?B?Wmc4Z3hwY0JUTlFVNExWQ2RsTkdSUzdoR2cvMDBvcWtHUi83cEU1eFY4ajJH?=
 =?utf-8?B?aHVoTktLS2hEdk56bnF2TEJOTGR4N281VGhza1NSR25YMmkwdi8rV00vTUpZ?=
 =?utf-8?B?MzQyQWZpcjFUZVZxTzAydFZ3T2hpK0JNMUdjNVEreTNHNnpDZktQNkVtaTZk?=
 =?utf-8?B?KzNudkQveVRnK3JiVFhybG5vY0NPMS9XWm1zRzA0RENWc0ljbHpGSlozdmJC?=
 =?utf-8?B?L2pNeXN5MlYzbWNHQ3kvWXphS3JYYmhKV2xwVE80QmluUVovQ0FSZXVhZzdR?=
 =?utf-8?B?NnBvbzZDcGVObmgwQWxOOWIzUys3c21pTEMwNGEzMFBiRmNLcFRXWE5KNnFP?=
 =?utf-8?B?RUxhQndoSmQzWTNNenkwV0xFZUc5dkkrUGFWMVUrdTcvcXJtZVhkb1h2dTQ3?=
 =?utf-8?B?ZEsya09VUU9Oc2hYaWhJeHFhUnF0N1V1R2VvWU4yNlRUNGZxK2ZSWXdjZFg0?=
 =?utf-8?B?SFhabk1oakU5Z0pzc0EyeTJHV1g4U3dZYmJ6bnYxRkNSa3RDejgyalUwYTNX?=
 =?utf-8?B?MlJRZHkxNnFUY1ZBaVpjeXk3aVlxNG1CVlVQRE9VMFlXN2FmSXVwUExRekM2?=
 =?utf-8?B?YWFTVm9jUDFWYnJOT05BbmFjSjMyRGFFeWplWU4wQ09Dc3NsRW1EbmRNQk9k?=
 =?utf-8?B?UE9Idzh4RDJuU3lQSlhNYzYxOWVUL1VQVGFmQUVrWHZ4ZEFJT0E2UHhtU2ZK?=
 =?utf-8?B?L3pFL0ZrczEzMW02OXVVL0pOV29yR291Nkd4QXBvelFOSmhvZDFBWnY4MnhD?=
 =?utf-8?B?TElyVnNydHFNRm1CRW1EVmtVMnJEQTZwV0JsUW9yZ1hzVUZJOTZBNU9mRjdw?=
 =?utf-8?B?bkRWSUplZm1SZGU4eE44dld3SGVZNER3TVBpajRQeW9WQnBIa2hsZTFyeEpp?=
 =?utf-8?B?UXlCa1BjSlVJQWNXcTArM2tiTDY1YnBRcnNyQUFXaU5DbTNpVWhzMzh4bG1u?=
 =?utf-8?B?Qm1yVGg4NU9JeE1jRjRvTUZTQ3B2VlF2Q2twbzY5ZFlZSGRKOUZPSnVwbW51?=
 =?utf-8?B?WU9xK3JNamphSyt5Y3JKU0pzcGhpM2FyTjZ6SlVMWEY0c3JYZ2tnOUdIeDBO?=
 =?utf-8?B?VUMvdjh0Y2tCRmVZMXFsRnhyWXJhdURPdW91eTdXTzRoZzRjQ2NnYkNKdStB?=
 =?utf-8?B?OE44cFJsR1lNaGp2S09RSjlpa2RYc3RzVTJDMitLRmFqMm41WWlTN0tGNlJ1?=
 =?utf-8?B?bmlyWkwzZjhOK0IxYW4xU01ad2lnOStMNmticlJ2VlM5TUdkU1RnSlFmam9p?=
 =?utf-8?B?YkRRSytGMlpQaXJ6SEtRSm9CcVpPT1dBdUdHME43dnN6aGhZc0xWNVVoQWls?=
 =?utf-8?B?NEFYOFpGejFtRXM3ZWxGb3Z3eGJrYzI1Q1VRQzYrV3p6MVFhMVV6dmEzdHpk?=
 =?utf-8?B?Q0x3V3BGTlUrdTk5Q1RTTm1Ya0I2MDVSTmc0a0ljTHBjUkZOMkVpQkFzclhH?=
 =?utf-8?B?ZHhoRk5NREd2Nlg4Z1IwWVBBLzEwUnJHTW1JUDJNRWdvYjh1aW8vSHgxZjBU?=
 =?utf-8?B?YUt3b2E5c281OWZRa2tXQ3ZWODJCYXp0ZHBTRFFJQWcvc0JwdWRNNktyV0hx?=
 =?utf-8?B?WUcxeTdOTDA0QjZwU0ZnT05EWW1wUk1JWG5sOXpTMzZsbDRxdHFDVkNhNXlC?=
 =?utf-8?B?R3pUUWRXcnhsa3RpK3NWcUpkU3VHUWpWRVE3U1Uwalo5UVZXSXNFNWpZQTJ2?=
 =?utf-8?B?RnlLN2RObUlwSnFNa2tLcjlxTi8rWkxnSXZTMmgyeU1tQUE5MXJOOFhIclJF?=
 =?utf-8?B?eWRpcjBBaGh2c0JSOEtXZHE0eG5xeVRUSWV4UDBoWXBCclZSaVMwWStuREsy?=
 =?utf-8?B?SkdJMlVuaW1GdmJuenlQb3Q2VUdoelV6SDA5NzVDcERpRVVXOEdaN0cvS3Ru?=
 =?utf-8?B?dnp6QXhmWWNQaS9VYmkxMlJpejJGODVMeks3Ly95YlRjNUVPNGhkU0RyaTkr?=
 =?utf-8?B?VXFqUGdzV05KMWt0WUVMR3A3bFl1S1poRjBvVDdhMm4wUmo4VXRnZkFqc1Ny?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDF5F76EF23E7445A8F3804C3FD4F36B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbcf988-0782-42d5-5fde-08da5ad3ba84
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 20:04:23.9714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S8MM/XamydCDWx8FuYYo1W2CAFMAhtHJlclcxebkFu7EbCsStrffPRv+rfLfNhZZRXUXHb0k/oFByaOpg4fhkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4298
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBKdW4gMzAsIDIwMjIgYXQgMDI6MDU6MzlQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBJZiB5b3Ugd2FudCB0byBhdm9pZCB0aGF0IGRlYmF0ZSwg
d2hhdCB5b3UgY291bGQgZG8gaW5zdGVhZCBpcyBhZGQgYQ0KPiA+IGNvbnN0IGNoYXIgKnNsYXZl
X21paV9jb21wYXRpYmxlOyBtZW1iZXIgdG8gc3RydWN0IGRzYV9zd2l0Y2gsIGFuZCB0cnkNCj4g
PiBzZWFyY2hpbmcgaW4gZHNhX3N3aXRjaF9zZXR1cCgpIGZvciBhIGNoaWxkIG5vZGUgd2l0aCB0
aGF0IGNvbXBhdGlibGUgaWYNCj4gPiB0aGUgbG9va3VwIG9mIGEgbm9kZSBuYW1lZCAibWRpbyIg
ZmFpbHMuIEkgZG9uJ3Qga25vdyBpZiB0aGlzIHdvdWxkIGhlbHANCj4gPiB5b3UgZG8gdGhlIHNh
bWUgdGhpbmcgd2l0aCBvdGhlciBkcml2ZXJzLg0KPiANCj4gVGhlIERTQSBjaGFuZ2UgdG8gYWNj
ZXB0ICJtZGlvIiB3YXMgYW4gaW1wcm92ZW1lbnQgdG8gYXZvaWQgYWRkaW5nIGENCj4gY3VzdG9t
IHNsYXZlIG1kaW8gd2hlbiB5b3UgYWxyZWFkeSBoYXZlIGEgc2luZ2xlIG1kaW8gYW5kIGp1c3Qg
bmVlZCB0bw0KPiBwb2ludCB0byBhIERUIG5vZGUuIEFkZGluZyBjb21wYXRpYmxlIHN0cmluZ3Mg
Zm9yIHRoYXQgc2l0dWF0aW9uIGRvZXMNCj4gbm90IG1ha2UgbXVjaCBzZW5zZSBhcyBhIGNvbXBh
dGlibGUgc3RyaW5nIGlzIG5vdCBuZWNlc3Nhcnkgd2hlbiB5b3UNCj4gYXJlIGFscmVhZHkgcmVz
dHJpY3RpbmcgeW91ciBjYXNlIHRvIGEgc2luZ2xlIG1kaW8uIEZvciBtb3JlIGNvbXBsZXgNCj4g
c2V0dXBzLCB5b3Ugc3RpbGwgbmVlZCB0byBjcmVhdGUgeW91ciBvd24gc2xhdmUgbWRpbyBpbXBs
ZW1lbnRhdGlvbi4NCj4gU29tZSBkcml2ZXJzIGFscmVhZHkgZGVwZW5kIG9uIHRoZSAibWRpbyIg
bmFtZSBhbmQgdGhpcyBzZXJpZXMgaXMgYWxzbw0KPiBhIHN1Z2dlc3Rpb24gZm9yIHRoZW0gdG8g
dHJ5IHRoZWlyIGRyaXZlcnMgZHJvcHBpbmcgdGhlaXIgY3VzdG9tIHNsYXZlDQo+IG1kaW8gaW1w
bGVtZW50YXRpb25zLg0KDQpJdCB3YXMganVzdCBhIHN1Z2dlc3Rpb24gZm9yIGhvdyB0byBhY2hp
ZXZlIHdoYXQgeW91IHdhbnQgKGxlc3MgY29kZSBpbg0KdGhlIGRyaXZlcikgd2l0aG91dCBicmVh
a2luZyBiYWNrd2FyZCBjb21wYXRpYmlsaXR5LiBPYnZpb3VzbHkgbmV3bHkNCnN1Ym1pdHRlZCBk
cml2ZXJzIHNob3VsZG4ndCB1c2UgdGhlIGludGVyZmFjZSBmb3IgdGhlIHJlYXNvbnMgeW91IGp1
c3QNCmdhdmUuDQoNCldoZXRoZXIgaXQgaXMgYSBnb29kIGlkZWEgdG8gYWRkIHN1Y2ggYW4gaW50
ZXJmYWNlIHRvIHRoZSBEU0EgY29yZSwNCmlkay4gUGVyc29uYWxseSBJIHRoaW5rIGl0J3MgZmFp
ciBlbm91Z2gsIGJ1dCBJIGFsc28gZG9uJ3QgbWluZCB0aGUNCnN0YXR1cyBxdW8uIFRoZSBjb2Rl
IHlvdSdyZSByZW1vdmluZyBpcyBub3QgZXhhY3RseSBkb2luZyBhbnkgaGFybS4NCg0KSSB0aGlu
ayBteSBzdWdnZXN0aW9uIG9ubHkgbWFrZXMgc2Vuc2UgaWYgeW91IGNhbiBzaG93IHRoYXQgb3Ro
ZXINCmRyaXZlcnMgY2FuIGJlbmVmaXQgYXMgd2VsbC4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
