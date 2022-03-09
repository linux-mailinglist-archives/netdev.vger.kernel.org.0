Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E655A4D3DBB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 00:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbiCIXt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 18:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiCIXtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 18:49:55 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70045.outbound.protection.outlook.com [40.107.7.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B711C7C5;
        Wed,  9 Mar 2022 15:48:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb+3K046mK/b8zF3EdWo0/3qJLF4T/tUuGDqgbDxklJZXYDQT2yrDGrOEQYEO159ecvzCtMMJBnX64HcN5T6/T7HGIqrLxwYAPNxIMBwfOetX2r+cTnxaZuyMivovhDyXHh85mP1YPr03WTPiipw+qq8oUF0yfUIbXG0JSrvHeDoufZI9ZU6rUJFUTjfIhGNMpCAKOcup7/YwJMfBN+c91of0DnmsdN4jloI9H4daGa9gyarW6wMCmBDEXMDt4UMUauh0LcYKLbyzfe4UWjywc4U36c+f/As6QzgyC7KFV/yYKuI8euQy0YthT+pkvByE09qCpvKyILtOErrjk9WYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APaUYjC802+RC1s9TLyra/6tn2wpRzkeO/WuN8EoQxw=;
 b=FReedZdRPJrdl9+Bji3TYpKpocJraF6pQ0NVatnJflTipkPBdohjxzgp2YrbLIei46M2kjr9Q/mfYMn50CYogOGtN1kF9KoazZlrco896ge0YYhYZWA0BDIzPBsxalpWShhwT7Z3++gSEbFMwiXakGaymGK17FkhVB2Yqw6n7aCCYsu2i2TSCF2E8Od+DhpT/p6V6xRzh/GD1XPeBSpDoeOKKm0D6rf2nJqZ+5D1rag8qYI6Qtw5pnE7GfGy5fqm7aESN9Mg0urATTtix8nsF2OhYhsfgeyPA1peqyb+mGiuaE7cuW/sHKC4i8MryR2XsOv821p1IDWaYT3QTA+bXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APaUYjC802+RC1s9TLyra/6tn2wpRzkeO/WuN8EoQxw=;
 b=aRjlJIY7tWOqQ/284eq6pm3sQ8Pjz75Rdlr9iZ1Bz3McA2VymK3YjAoCyZaAoEzGQQ9WmtvKrI5NuwDT9kq9BuEHK7tVG4MinFcWU1U37gB1lxNCPan1vM7r9r1i1f18CxtAgoeKCw6RwpzF+BbdDe5G/dqufQXVX9aZ8mDuP5A=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8210.eurprd04.prod.outlook.com (2603:10a6:20b:3e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 23:48:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 23:48:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next] docs: net: dsa: describe issues with checksum
 offload
Thread-Index: AQHYM9/NC+3mEspv+kGYTn+QoTcLVqy3uLEA
Date:   Wed, 9 Mar 2022 23:48:50 +0000
Message-ID: <20220309234848.2lthubjtqjx4yn6v@skbuf>
References: <20220309180148.13286-1-luizluca@gmail.com>
In-Reply-To: <20220309180148.13286-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 945fe9a8-ca74-4e30-a2aa-08da02275cc1
x-ms-traffictypediagnostic: AM9PR04MB8210:EE_
x-microsoft-antispam-prvs: <AM9PR04MB8210502FCACA20C185F616E7E00A9@AM9PR04MB8210.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nc+09Fx155n0Qrrw0YOey6gMP2WwquvJoD5cAZbvakyEfq1Jyb6RZEL+Ep1abbqooqreAAxHaNPGTb93k2f0XZbCYf/jbD0x7b5AaWEst9IZHDjEtTdMlqhMKvNNcnAaqypKLidIi0CyTuNsbnm7a/ausA2e4GMCGIYutyatB6vSrHrK5BqHKf2T0x+zlH2D3J1gG0CmlCPYzU4cAvRcrxGpxw8bg1Gdhh4B3GOYweu3wNc43Wmii8Ca+FA6yroxM9BKRn8505YhJQpMJi97OxYiS0eAuyubL4pjf7taAUfwj/FlA37IbZHnqQi3A2Dbd+nqAehVf6N/gyG7fYptkKJxEvVN4iAglrH/t2jctYukWqK/AMIJH6gfDGE29isa1J21uWku2GB+WzwXN6UgmW/wg8dmLOeyUx0E059AgVfbFkAj1JGWtiZesDiZiOplRe+8kno9/l7DNcFDqX30abpWY9bbaDMGNBnq78XntmdIelLT/hm+k4WxA9vsvMs0NU5taxDPPOAMTvWYibSPUvCKcc8xsz/21oI2JxO9BgmWTHde7GwS9amypjmq/oazEoyR3Bb+zDxavxQ+WbqaQ8gbtJoGGGS9Vg0i3F/L6ytbcAPgCTA8mh3ZcVFFaqtacJNGd/MO0ml1pOOC9v5UH4vvq2B0Gwoyagkr0NpRRWYdqI6m60rSKFDUy+Ve8hZXSUVaGjslHECMSvPe9l6qYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(44832011)(8936002)(7416002)(4326008)(2906002)(86362001)(38070700005)(66946007)(66446008)(64756008)(508600001)(66476007)(6916009)(5660300002)(316002)(66556008)(8676002)(54906003)(76116006)(6486002)(6512007)(9686003)(1076003)(6506007)(33716001)(26005)(186003)(38100700002)(122000001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnNXSVcwLys3cjZHUFEzWkVXVk9nb3JRdFF2M0NKbDFaTk45NHA1dEhXWGdJ?=
 =?utf-8?B?ellFdVR2b09lSE0zRklsSVFacDIwZ0dLRHluaGthN1NSRGhqUGJhbkwwSHFB?=
 =?utf-8?B?TTA2QW14czI0WXcrbXVvbkxYTlNOKzNoNmFXYW96cFc5cEFLajNXVUZ1dFNL?=
 =?utf-8?B?c3BPcUhBZk90MFJING1TSHpWVnRKQ1Nkem9UL2Y2bnRWQ0M2UFRyd2gvcFpU?=
 =?utf-8?B?N3cxSVZMdElPa1o4b0Z4dktZMWt0UjJHa0VmbGJYNzl6cUJvSjgyWW9yRDIv?=
 =?utf-8?B?WUxrQkczRCtURzV5TllFZXZOUjI4S0ZkYUpmck9leURjbFl6cjUybmNzc2kv?=
 =?utf-8?B?Wk9HeVc1MlJmL2tpMUdXeVlDSmc2N0lnTGdMQlROaGpwTXJwbm5WejdjMnBu?=
 =?utf-8?B?RnF4N2hYbHZKQmgvdE5TemVVOXgyT3RDS29yL0I2ZWY5V3p3ZEtkbGVsSm1I?=
 =?utf-8?B?eFVJTk1iVnJVdTlicnQ3Sml2U20rNkFQV2tGeEcvOVh4aVJJbFg4aHBPODJP?=
 =?utf-8?B?c0hmS2FTd0RKOXMzcG9Kcy9iR05jYXZqbHhERkZYU254VXE1bHJEM3ZKUDJN?=
 =?utf-8?B?cEl3QlJHNWxCMjlTdUhLRENmZDVvVVphRGpoTm42czBzT0UyVkVDenYxVHRS?=
 =?utf-8?B?OG5EK2lEcklXUmVMSy9rVVZuVjJnMVBteGtZRkpqU1E0N0dVNjFuYmNDcWpI?=
 =?utf-8?B?WkMyVTdVMGVZUWJZOFBNcGwzdlo0RzVDZ01jTzJ6RzVqcmczM1kvaDdIT1NW?=
 =?utf-8?B?cWRMYjBKVjNKUEJKUWd2ZDVFTHVIeDd3THNRYk4zRTRKcG9udmNyR0VzZk5P?=
 =?utf-8?B?MDYrTG5VN0YwbDN1cXlRdk4ydytncGhYcmFCMk5tTGNpVW4xYS8vOWE2VFgy?=
 =?utf-8?B?ck1HYnl5dHJVUEdXVWxHSTRCbUdsTEJXbFhka3o1Z3N0eWhkQWIvdVd3QU1x?=
 =?utf-8?B?WE83RVB5RENTSmlMTTBTSXBRSjdDQ1NsaUJJc3BOek1MVGI0QnNmbTh6TGJa?=
 =?utf-8?B?MDFvd3h3Y25FZ2JrRUMrcS9lb3hPbmJ3Q3d0YXYxa1lCYS8rUkxrWDVXd0h1?=
 =?utf-8?B?TXB3dWlOdTQ1ZHhGOGE3bGY0VmNaa2hvVVFGczlKangrR1lCcmdUTkwraDVY?=
 =?utf-8?B?QXdLQ1NmMmRLaGdYK015NXZBNXN4QjhvWnI4Q3hkV3pBd2RtV0lJSnBSbi9I?=
 =?utf-8?B?Q1h4dTE3V3p4OXdsUFVTN2FBVzdEVEhwUS8xdGdtWVNpQm9lOHpJS1RUc1BL?=
 =?utf-8?B?Q1N2OXBjc01NdTBpL2h3YzVpeXMxT29WVXc1RHRnL0lWQnUxQWVZeU92SHhT?=
 =?utf-8?B?STcyUUZ2T0hZVStRSHc0cWVxRXhpLzRJb2dqQlNwdGdsWjYwZlkwdElaQ05C?=
 =?utf-8?B?RzBWaTNQQVFUUWtvQm9EdldyYVhkelBHckFWcFg0SmZ3djRKWGdFUlVNVndK?=
 =?utf-8?B?OVZnbFpJcUFmUVhTZkZCdzNlQlM4UStYaFEzYk5wS0JzOUZDNHFwQWR4NnBN?=
 =?utf-8?B?dS9FMXUxWXBKV2gwVHpYNHA1RVkvcVZSbFU3ZUNxZzFqbFBDdlFqb3VrWEh6?=
 =?utf-8?B?UUNkWkVUV2srL2N5NitSUWNVUGZ1QzcvdXFQbTB3a2NwWUl4cHVHRkphb2Fl?=
 =?utf-8?B?YjFOTFp6cTZtQWVLWDJCdzNMeDRQMTJIc3dOR2RhUXA3dnZuc0NRVXNvTkda?=
 =?utf-8?B?VThUTzVHWjEzNXNxT2tuUS84a0wzV2Y4L01LTDhPVm50UndzK0dDV3Qvb0NS?=
 =?utf-8?B?WXNuMW4zcFNpS1NTYit5a09RbFRqTXZBUDBTS1ZsZ2EzOGVyTXAyUWIyWkJY?=
 =?utf-8?B?Z2gzL1dxdEhoZUVFaUtWOTJUbHVtR25Ed2xlN282Sm12VlJhbUx2RWl4YjY5?=
 =?utf-8?B?WjV5bGF5UWtvc0QvdWFGUFhNOWZYL3p4Tk8yNm1BaUxsOEpMd0pGajhuVVpv?=
 =?utf-8?B?V29nWUdrK0kyWlNiSmVEdkNteXYva2FMNVQzTmorVkZySjhMZlBDaXAxbDVY?=
 =?utf-8?B?VXY4QytpT3lteCtHcTJrTjhRSllaaGNaS2JhblVya1Fzdmx2VkhkblU3TnUv?=
 =?utf-8?B?T1hEMmU2dUhRRmFMRDQwVk0ydzFJMS9jQ3VWN3FOK0dVSVRrbndPOXoxR1lW?=
 =?utf-8?B?YUJDNGtDZk1LL1JVUVVtdmdGSWk3VFY3TE9ydHRSYXh0VWZibHpTRmVYa2Vr?=
 =?utf-8?Q?fOqGrcH7hRJ3uSB0o43HgQ4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F692DE756EAAB242B5ED885330D9290E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 945fe9a8-ca74-4e30-a2aa-08da02275cc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 23:48:50.7020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8M2vPVKBAvV+9Z4k7dDXJ+UP4qL1OndY0Mrb44xLYbB9Dwl6HT55GbGrKnS48k/9w33X6f/f0v0f9PEgwr+fzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8210
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBNYXIgMDksIDIwMjIgYXQgMDM6MDE6NDlQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gRFNBIHRhZ3MgYmVmb3JlIElQIGhlYWRlciAoY2F0ZWdvcmll
cyAxIGFuZCAyKSBvciBhZnRlciB0aGUgcGF5bG9hZCAoMykNCj4gbWlnaHQgaW50cm9kdWNlIG9m
ZmxvYWQgY2hlY2tzdW0gaXNzdWVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8g
RGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiBSZXZpZXdlZC1ieTogQXLEsW7D
pyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0KPiAtLS0NCj4gIERvY3VtZW50YXRpb24v
bmV0d29ya2luZy9kc2EvZHNhLnJzdCB8IDEyICsrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL25l
dHdvcmtpbmcvZHNhL2RzYS5yc3QgYi9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZHNhL2RzYS5y
c3QNCj4gaW5kZXggODliYjRmYTRjMzYyLi5jODg4NWU2MGVhYzUgMTAwNjQ0DQo+IC0tLSBhL0Rv
Y3VtZW50YXRpb24vbmV0d29ya2luZy9kc2EvZHNhLnJzdA0KPiArKysgYi9Eb2N1bWVudGF0aW9u
L25ldHdvcmtpbmcvZHNhL2RzYS5yc3QNCj4gQEAgLTE5Myw2ICsxOTMsMTggQEAgcHJvdG9jb2wu
IElmIG5vdCBhbGwgcGFja2V0cyBhcmUgb2YgZXF1YWwgc2l6ZSwgdGhlIHRhZ2dlciBjYW4gaW1w
bGVtZW50IHRoZQ0KPiAgZGVmYXVsdCBiZWhhdmlvciBieSBzcGVjaWZ5aW5nIHRoZSBjb3JyZWN0
IG9mZnNldCBpbmN1cnJlZCBieSBlYWNoIGluZGl2aWR1YWwNCj4gIFJYIHBhY2tldC4gVGFpbCB0
YWdnZXJzIGRvIG5vdCBjYXVzZSBpc3N1ZXMgdG8gdGhlIGZsb3cgZGlzc2VjdG9yLg0KPiAgDQo+
ICtUYWdnaW5nIHByb3RvY29scyBtaWdodCBhbHNvIGJyZWFrIGNoZWNrc3VtIG9mZmxvYWQuIFRo
ZSBvZmZsb2FkIGhhcmR3YXJlIG11c3QNCj4gK2VpdGhlciBiZSBhYmxlIHRvIHBhcnNlIHRoZSBw
cm9wcmlldGFyeSB0YWcsIHVzdWFsbHkgd2hlbiBpdCBtYXRjaGVzIHRoZSBzd2l0Y2gNCj4gK3Zl
bmRvciwgb3IsIGluIHRoZSBjYXNlIG9mIGNhdGVnb3J5IDEgYW5kIDIsIHRoZSBkcml2ZXIgYW5k
IHRoZSBoYXJkd2FyZSBtdXN0DQo+ICtiZSBhYmxlIHRvIHVzZSB0aGUgc3VtX3N0YXJ0L2NzdW1f
b2Zmc2V0IGFkanVzdGVkIGJ5IHRoZSBEU0EgZnJhbWV3b3JrLiBEcml2ZXJzDQoNCnMvc3VtX3N0
YXJ0L2NzdW1fc3RhcnQvDQoNCkFsc28sIEkgd291bGRuJ3QgbmVjZXNzYXJpbHkgcHV0IHRoaW5n
cyBpbiB0aGlzIGxpZ2h0LiBJIHdvdWxkbid0IHN0YXJ0DQpvZmYgYnkgc2F5aW5nIHdoYXQncyBi
cm9rZW4sIGJ1dCByYXRoZXIgd2hhdCB3b3Jrcy4gSSB3b3VsZCBzYXkgdGhhdA0KY2F0ZWdvcnkg
MSBhbmQgMiB0YWdnZXJzIGFyZSBleHBlY3RlZCB0byB3b3JrIHdpdGggYSBEU0EgbWFzdGVyIHRo
YXQNCmRlY2xhcmVzIE5FVElGX0ZfSFdfQ1NVTSBhbmQgbG9va3MgYXQgY3N1bV9zdGFydC9jc3Vt
X29mZnNldCwgc2luY2UgRFNBDQphZGp1c3RzIHRoYXQgY29ycmVjdGx5LiBGb3IgRFNBIG1hc3Rl
cnMgd2hpY2ggZGVjbGFyZSB0aGUgbGVnYWN5DQpORVRJRl9GX0lQX0NTVU0gb3IgTkVUSUZfRl9J
UFY2X0NTVU0gaW4gdmxhbl9mZWF0dXJlcywgRFNBIGluaGVyaXRzIHRoaXMNCmZsYWcgYXNzdW1p
bmcgdGhhdCB0aGUgbWFzdGVyIGVpdGhlciBoYXMga25vd2xlZGdlIG9mIHRoZSB0YWdnaW5nDQpw
cm90b2NvbCBpdCBpcyBwYWlyZWQgd2l0aCAocGVyaGFwcyBkdWUgdG8gbWF0Y2hpbmcgdmVuZG9y
cyksIG9yIGZhbGxzDQpiYWNrIHRvIHNvZnR3YXJlIGNoZWNrc3VtbWluZyBmb3IgcGFja2V0cyB3
aGVyZSB0aGUgSVAgaGVhZGVyIGlzbid0IGF0DQp0aGUgb2Zmc2V0IGV4cGVjdGVkIGJ5IHRoZSBo
YXJkd2FyZSAod2hpY2ggaXMgYWxzbyB0aGUgY2FzZSBmb3IgSVANCnR1bm5lbGluZyBwcm90b2Nv
bHMpLg0KDQo+ICt0aGF0IGVuYWJsZSB0aGUgY2hlY2tzdW0gb2ZmbG9hZCBiYXNlZCBvbmx5IG9u
IHRoZSBuZXR3b3JrL3RyYW5zcG9ydCBoZWFkZXJzDQo+ICttaWdodCB3cm9uZ2x5IGRlbGVnYXRl
IHRoZSBjaGVja3N1bSB0byBpbmNvbXBhdGlibGUgaGFyZHdhcmUsIHNlbmRpbmcgcGFja2V0cw0K
PiArd2l0aCBhbiB1bmNhbGN1bGF0ZWQgY2hlY2tzdW0gdG8gdGhlIG5ldHdvcmsuIEZvciBjYXRl
Z29yeSAzLCB3aGVuIHRoZSBvZmZsb2FkDQo+ICtoYXJkd2FyZSBjYW5ub3QgcGFyc2UgdGhlIHBy
b3ByaWV0YXJ5IHRhZywgdGhlIGNoZWNrc3VtIG11c3QgYmUgY2FsY3VsYXRlZA0KDQpUbyBiZSBj
b25zaXN0ZW50IHdpdGggdGhlIHJlc3Qgb2YgdGhlIGRvY3VtZW50Og0Kcy9wcm9wcmlldGFyeSB0
YWcvc3dpdGNoIHRhZy8NCg0KPiArYmVmb3JlIGFueSB0YWcgaXMgaW5zZXJ0ZWQgYmVjYXVzZSBi
b3RoIHNvZnR3YXJlIGFuZCBoYXJkd2FyZSBjaGVja3N1bXMgd2lsbA0KPiAraW5jbHVkZSBhbnkg
dHJhaWxpbmcgdGFnIGFzIHBhcnQgb2YgdGhlIHBheWxvYWQuIFdoZW4gdGhlIHN3aXRjaCBzdHJp
cHMgdGhlIHRhZywNCj4gK3RoZSBwYWNrZXQgc2VudCB0byB0aGUgbmV0d29yayB3aWxsIG5vdCBt
YXRjaCB0aGUgY2hlY2tzdW0uDQoNCkkgd291bGQgc2F5OiAiT3RoZXJ3aXNlLCB0aGUgRFNBIG1h
c3RlciB3b3VsZCBpbmNsdWRlIHRoZSB0YWlsIHRhZyBpbg0KdGhlIGNoZWNrc3VtIGNhbGN1bGF0
aW9uIGFzIHdlbGwsIGJ1dCB0aGlzIGdldHMgc3RyaXBwZWQgYnkgdGhlIHN3aXRjaA0KZHVyaW5n
IHRyYW5zbWlzc2lvbiB3aGljaCBsZWF2ZXMgYW4gaW5jb3JyZWN0IElQIGNoZWNrc3VtIGluIHBs
YWNlIi4NCg0KPiArDQo+ICBEdWUgdG8gdmFyaW91cyByZWFzb25zIChtb3N0IGNvbW1vbiBiZWlu
ZyBjYXRlZ29yeSAxIHRhZ2dlcnMgYmVpbmcgYXNzb2NpYXRlZA0KPiAgd2l0aCBEU0EtdW5hd2Fy
ZSBtYXN0ZXJzLCBtYW5nbGluZyB3aGF0IHRoZSBtYXN0ZXIgcGVyY2VpdmVzIGFzIE1BQyBEQSks
IHRoZQ0KPiAgdGFnZ2luZyBwcm90b2NvbCBtYXkgcmVxdWlyZSB0aGUgRFNBIG1hc3RlciB0byBv
cGVyYXRlIGluIHByb21pc2N1b3VzIG1vZGUsIHRvDQo+IC0tIA0KPiAyLjM1LjENCj4=
