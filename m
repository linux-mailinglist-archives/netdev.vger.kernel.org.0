Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A884E36B0
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiCVCdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbiCVCdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:33:52 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2127.outbound.protection.outlook.com [40.107.255.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD63410D3;
        Mon, 21 Mar 2022 19:32:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbQ9OHgzbXPkbXwaHavYb3WE6cSi4S9NCT9WyNPloKFtwPB+QXrB2R41wdOIa6CEa0TjtaKZKR+kCRx0m1a4pD70LFO3UFmL3EOTJ3NfjklEWW3L6Pq0C66Z4OYg38+J+YVmiExp8PQpsAhJcf1lUe6jusKx0gtGFrkznKKFR+n80tz7D8Q5dWJvK6uciLKvofIrgGEelaInhNsL3A8dv3eiMrzyWsOrcpQ7ILWmfh98OLv8BLGl2u3sboEG4VkfN5TdgnMHjotXofYe2WP6WI0SVv4oetAEblPqh9kjV2T9TcC22CrKekU80LO0nP5UwupykwQ/e+Yis4vvct6UNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwtJUXWLhkNlM18AorWiAiM4iTP6qVAYLMh0PeiKRZI=;
 b=PPOodD5o66HPrMRlkdqy/MSF5/8YAGX8inZN1n92uo/0GWDTfZYL3forH+fOFMOp2BEO00EQaMEg9widbIu7IpzYxQPeV7aaMAmX0tujUy0HOxbVD0V23KopLyjgUEc9YXjP3TINSJncnIl/KfYNpXYiRAHPd4eyDtSRk/z4//e43qT+YiyCHwrTWwn0tHBgTt5c/1B6qFNPdaEEf9emYmDg1Iw6rESWc4PDTyjW5hrBRXFA7jg9UHWsbTaVyp3crrPXbkB8H706u2Q5jlc4I7xS8lRFjHLu3wDeTdkcXcP/dN3zoY+9g88njJelx7+5Z+g3SbEXAiYXnKIqgHnZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwtJUXWLhkNlM18AorWiAiM4iTP6qVAYLMh0PeiKRZI=;
 b=lQeiBCh4reeSJ3G85I0HIPFeWhR7Koy8H8WpbSmWcgT2OUFH7kKe5j1Wg9iqfgtU2074hZEWDoFCFb+o6QXGAED4uqEFMawxZwhUTGHd/N1v1NzDunu+L6XJrbo7+qg+dO5N+1pnj2Xha53qfFMxn0CQ2qdnY5nz5t0yJlvNBexaXsuRmyW0vcICS3Wr+8tCl8tFEWe4VryOmWvmejIkNVCKIHmivcswxyYXtDSzrBA/AeGdlF3NzvTvP7Y5/fnzFFwvazNZc5xr5wbfR1qTRp5W6YeZMpa80dBCnA8oZ7gcd7mc2TE83A52ltTZTqKKfQ/NIh0+aAXZ8PdsO2FWCQ==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by PU1PR06MB2391.apcprd06.prod.outlook.com (2603:1096:803:2c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Tue, 22 Mar
 2022 02:32:14 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 02:32:14 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Thread-Topic: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Thread-Index: AQHYPQnwNYsxHNQRykGxCSuH1L0VZ6zJ/XGAgACv7MA=
Date:   Tue, 22 Mar 2022 02:32:13 +0000
Message-ID: <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-4-dylan_hung@aspeedtech.com>
 <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
In-Reply-To: <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bda2ba3a-66e4-4c2c-848c-08da0bac2cea
x-ms-traffictypediagnostic: PU1PR06MB2391:EE_
x-microsoft-antispam-prvs: <PU1PR06MB239134962E520073F2869E0A9C179@PU1PR06MB2391.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dnD4sUTiUaKUrV8AysQOq1Rp/mFUvuBuy5FhhepPy6J3ECSaJs5xYMJUnRI65ROAqRvSQN+wilka5R0VvXBEzy40844b60u9ECUiX1xfGJr2Piloh5eGuWeHafvSMi6Z1+ix5FemDImFwu1YRlHXxvypg4xDLI6bML5UD6AJxdxb9garioOwps6Q9cTgIGrPkEnp15VFeIDKlMAvwKWJOikGke5dTMf/vjzBraoKtSsS6lItaSL9OPodWrZ51ngAZUvmO3WfuMC4L6lSIjXsHJgfEe1xUF9x1wD1U2dONt8eZqu3zgH8LqNaZRqrrh21m93OTzmfMPZF9iYUkqet+TF2KDuWUlPNON+JrERDyWyOouYz5QH+Lghl/x8QFZ93lez3p5W6ZXecrD5YsDw/ZzTNuCcwwhJg6xpwwnjb+nAlgT0iWxEr2msSVHJHVfzXn7h9SCdSbotXykdG/7ieqPW0tGkhYWDi4Ap15OiR0jnPzMHWY2JryveikPyKtRAV0Nz4PFeEgy6b0vLkgk0u6iz/Es5hjk6wkxCF2DZ0mnPYJwnaWiK/V1RZ+8yBLI3CDhPFdoQVoqnlr7zKMqLTqQqHPbR/35lGFE8IMHnpJV4V50LrWarZWVmtK+agDiI6EGG0i+ynwnmbAbZbLLEPDXFKW6QHiU5/Oiz6rLMSizlRc/VYfRw5iYgjkxnszPAto3aOsYXVTSAwJXWXSPDtAPhla2RC2bCTdqYcbC8WXvQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(39840400004)(136003)(346002)(366004)(396003)(26005)(33656002)(71200400001)(6506007)(7696005)(508600001)(316002)(54906003)(110136005)(8936002)(122000001)(38100700002)(66946007)(66556008)(5660300002)(7416002)(921005)(186003)(66446008)(66476007)(53546011)(4326008)(8676002)(83380400001)(38070700005)(2906002)(9686003)(52536014)(55016003)(86362001)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlNPVlhNWkdibUd5clhMOTNleEFhU3dnUVZ5WFJuMGtoNk9uRW9zdmdxSnhO?=
 =?utf-8?B?T1oxazdXWVdVNytta0NPamlmVGtOWjlJemVVU1A3TmdvbWk0d2dYOXU1MFBP?=
 =?utf-8?B?aVI0bVIvZFRwUkRmQVB0S2d3cTRoRHZMcWNjSjJUR2xZMlBJalU1NnBtcFhQ?=
 =?utf-8?B?VkkzR0k4K21uQ2JianFKV0Jsa0VOS0RVOTkwdVMwckVWaFJXQ0FqUVRuTDJ5?=
 =?utf-8?B?UWxMSUFHb3RqQVpjS2xZR0xCVGxUSi9qcHYyaklCbTQ5aWJxbGNNSUI4LzBZ?=
 =?utf-8?B?Y1VMU01NbWhlbTdoTmhWSjB4WS9IRERlaU9pMzJHYXVNU1pvZmZsUzJkSE44?=
 =?utf-8?B?RmRPT3U3WWp2dWRsek5JUHVNUGlKOC9BaFA3aTA1MitMaGJLYitsVVhCQWFX?=
 =?utf-8?B?Z3JEeFpFeWkzTTJHaDBsbzBTWmY1YTFtSkt6R3d3MVJwT3hGdkorbXRrNXRD?=
 =?utf-8?B?WmNWdkdnbU1NYlFkYkQra0d1OHpTODdNaENEQkY1YUYrSC9VcENDYmZzcjli?=
 =?utf-8?B?K3RQR2R2dlJoNUN0V0RSUTNZcjNydUR6YityZG8vQmc3QnNYVFY5YTRaR1Jj?=
 =?utf-8?B?dUZHTGJQQ0RnZmNSdGVQc21UQTBYUGZaVkljMjR6S0gzTmR6b1NrYnJrUzd0?=
 =?utf-8?B?Q05HU0dMNUNuYk04eWptcUwvUVFWaDFHYnZpcGdSVFdsV1h2bkplOG9lN1dz?=
 =?utf-8?B?ZnNOR2pjckxCNUFqMi9rK2t6MzBqU0tneUVLWFJQUXFoVHRyTXBCcFFmTmVy?=
 =?utf-8?B?SC8vWkhHMEZHdmhoeTlQVkNiaEJ5bWFIcGZDZlhSdVEyR2hYNEovTSt0UmdE?=
 =?utf-8?B?Nk5VZDZRTExkU042Z2NuTGo5NjVXS08wK29mTW56U21abW00TnBUeGwyOFZX?=
 =?utf-8?B?TXZGQlMycTNEVlZOYXJsTkROS0o1MTJBYVdmb2pGMHdScVF6bllpREZ6Q1h5?=
 =?utf-8?B?aVBLQ3FsSUlLSE9EU2dlOHlQOFlneUp5THloK2g2bjd0YWd0NEU4RHI4YzU2?=
 =?utf-8?B?SWIyRzV5RGlPMDF1eFk5YjR3NHZha0lSRC9KVFNIYkNTSVpKaWNhSzg5YmtM?=
 =?utf-8?B?dFhOK1hOUC9ybk1yM2JxZ3FocjhUNXdiejVrK0ZES0Jtb0dDTmx1UUN2aXcy?=
 =?utf-8?B?K0VpbW92Z1JNMFExeFlOWENSK3lhRVZrMkZmaEpib3h5WkN4SWRzRGM3VzV6?=
 =?utf-8?B?ZmNhcEJvMUh6VEhTZjFMK21jQmVRb3JQaTU5dWJnckhoeG1ZUm9xYWFqKzFG?=
 =?utf-8?B?YUw0TzBXNS9yNUhWOEdvZmpMS1NkOVdFYURTdGZxM2x3T3Nqc0I1a3BHRExM?=
 =?utf-8?B?OEpmdjlINlUzSWtoaVpUVVVwbjZMd0NJZkppN0lGQTBqMFVyeHVEOWZHTTl6?=
 =?utf-8?B?TDcyQnpLTnFzMEl3SlhZM2kzTkhib3lMaGFCVkc4NCtBcDBFclpwOVhkeWFl?=
 =?utf-8?B?aXlNZzFmU0k1NUkyV2FuUjMvYUJXOHdTdXJpNUJJQVU1VmhEUElzeGdhSzB5?=
 =?utf-8?B?bjAwcTZoYjg1VHVNTFgvQTZmNEpnQ2VMeDY0aEVvTGR3RXBwS2ZJVi9KKytY?=
 =?utf-8?B?S2habXZRdEpnWk4wOG5IeVY3a3hCY01Na2MrYTEzTjZNeWlhYmg4TXpOaVdW?=
 =?utf-8?B?LzN2RWNNL2VKaXNvdS85OFF6YzNRbWptN0dHSXJQTUkvM1ZvMCtBdDJTdExi?=
 =?utf-8?B?dVhCNE9EWEZjeDRyRWEwcm55WmJSbmFURkZuTG1ZM2JzcXZBT2tydUthUWNp?=
 =?utf-8?B?OXY3UFhUL1NZS0pMMnBORTFPNlBDZWkvU2podmR6emFGUU4wN0NaNWNWWUE0?=
 =?utf-8?B?RHJjWmxiRGxneE1iejVxb0ZKdWhmTVFPZFdjQ00rRldXNVV4L2RsejJiN0JV?=
 =?utf-8?B?b2tUa0lpNUovYnNldnZZV1ozQXFoazZCN0RuMDZNRVczYXJiUkR5a2xJVnFo?=
 =?utf-8?B?dGxHNVVvdUdxRjZKMnhoVktiaXg3UVFDQUxha1Q1eVBQbk5hSzBmVHhEb3hi?=
 =?utf-8?B?UUdGSjd2b05nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda2ba3a-66e4-4c2c-848c-08da0bac2cea
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 02:32:14.0006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: olsn1SA3ynW5f8LklYaK5DyHKyunHpSKCf+UA3K5XRUNipkJyYByeyau0CVPT1YZwCvTiyleeV7bSw4iayMJUqCnIo6ygpNDdBNHirZ7eao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IFttYWlsdG86a3J6a0BrZXJuZWwub3JnXQ0KPiBTZW50OiAyMDIy5bm0M+aciDIx5pelIDExOjUz
IFBNDQo+IFRvOiBEeWxhbiBIdW5nIDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29tPjsgcm9iaCtk
dEBrZXJuZWwub3JnOw0KPiBqb2VsQGptcy5pZC5hdTsgYW5kcmV3QGFqLmlkLmF1OyBhbmRyZXdA
bHVubi5jaDsgaGthbGx3ZWl0MUBnbWFpbC5jb207DQo+IGxpbnV4QGFybWxpbnV4Lm9yZy51azsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNv
bTsgcC56YWJlbEBwZW5ndXRyb25peC5kZTsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+
IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtYXNwZWVkQGxpc3Rz
Lm96bGFicy5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IEJNQy1TVyA8Qk1DLVNXQGFzcGVlZHRlY2guY29tPjsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDMvM10gQVJNOiBkdHM6
IGFzcGVlZDogYWRkIHJlc2V0IHByb3BlcnRpZXMgaW50byBNRElPDQo+IG5vZGVzDQo+IA0KPiBP
biAyMS8wMy8yMDIyIDEwOjU2LCBEeWxhbiBIdW5nIHdyb3RlOg0KPiA+IEFkZCByZXNldCBjb250
cm9sIHByb3BlcnRpZXMgaW50byBNRElPIG5vZGVzLiAgVGhlIDQgTURJTyBjb250cm9sbGVycyBp
bg0KPiA+IEFTVDI2MDAgU09DIHNoYXJlIG9uZSByZXNldCBjb250cm9sIGJpdCBTQ1U1MFszXS4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVj
aC5jb20+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gDQo+IFBsZWFzZSBkZXNj
cmliZSB0aGUgYnVnIGJlaW5nIGZpeGVkLiBTZWUgc3RhYmxlLWtlcm5lbC1ydWxlcy4NCg0KVGhh
bmsgeW91IGZvciB5b3VyIGNvbW1lbnQuDQpUaGUgcmVzZXQgZGVhc3NlcnRpb24gb2YgdGhlIE1E
SU8gZGV2aWNlIHdhcyB1c3VhbGx5IGRvbmUgYnkgdGhlIGJvb3Rsb2FkZXIgKHUtYm9vdCkuDQpI
b3dldmVyLCBvbmUgb2Ygb3VyIGNsaWVudHMgdXNlcyBwcm9wcmlldGFyeSBib290bG9hZGVyIGFu
ZCBkb2Vzbid0IGRlYXNzZXJ0IHRoZSBNRElPDQpyZXNldCBzbyBmYWlsZWQgdG8gYWNjZXNzIHRo
ZSBIVyBpbiBrZXJuZWwgZHJpdmVyLiAgVGhlIHJlc2V0IGRlYXNzZXJ0aW9uIGlzIG1pc3Npbmcg
aW4gdGhlDQprZXJuZWwgZHJpdmVyIHNpbmNlIGl0IHdhcyBjcmVhdGVkLCBzaG91bGQgSSBhZGQg
YSBCdWdGaXggZm9yIHRoZSBmaXJzdCBjb21taXQgb2YgdGhpcyBkcml2ZXI/DQpPciB3b3VsZCBp
dCBiZSBiZXR0ZXIgaWYgSSByZW1vdmUgIiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyI/DQoN
Cj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gS3J6eXN6dG9mDQo=
