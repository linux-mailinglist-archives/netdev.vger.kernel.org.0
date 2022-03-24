Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0424E6333
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350074AbiCXMXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237339AbiCXMXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:23:05 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20053.outbound.protection.outlook.com [40.107.2.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075CFA5EA8;
        Thu, 24 Mar 2022 05:21:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xbkrf8S2HYlxR7ggFYjM/QJNiHXpSK1HZ9lWHScSNVPXgtQR7p8TI8XYyyugaq8a4Z4h+7Ezv/46FOkxdtfT9t6PKnVdYPya/vnWi89ltTyxWsyzG6RoQD6DnB8o023YCjegeIYY926zVTZVm7oevYJK3zY/l+9vfW+UZvHZJWlLGBkzoqqEIwPUL8dSBRyBTm1oLnFANy6JC94PgizuISxiw59TQBG0/FvhrjsWlqp/ZjjjxDjvaZH5lHgqPo4A2PzzfOCYelMZgBukPv3s+mVwIOZcr+E5XmFYAvIiVuLvCqjP08a3ay5KrjEyc/1Q9E9omDCySVafn6BVtv1X5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qznbgZp1reG0ZlfBZ/GBB07wnfhxAkqxBTLuEnT2gxo=;
 b=WNsQstxtGXdREIgHkCsbNwsYIsBEMUuCuWV/turNoSOKHgi2/4gpnBScE4xad0AnN5byqui9xaurLTlF8WQZpGtctQhBzzKLKq9a7xwu1S5jnZgZd+sInvQdomH42cRhvvA/o7vxEL8kQl+mF59znguMsHfpRkpgTiinfl9pq5hszO5BpKXbqTzPVl3/Xivh9iOU8+ARVuT1gmmjNCxajedr5Bg0idNu4Vjjm1p2XtJrSLEqjA4x+A05LB5a/ZpzWKPBhQu5v7BjEwYNn9NxAvkV3LrO3Mzqu7+ZtRrrPKriMXm7Hd82DtkXlfS8ha0KQJGLFtC3wH1bq26F2yDrKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qznbgZp1reG0ZlfBZ/GBB07wnfhxAkqxBTLuEnT2gxo=;
 b=mhaDY3LB3BvWSojzBRQYmGCzKJlgEf9eVbBuKQ/Kw9HyZT8TeRowjxLqdi3i3fdILHQ6H/5z+hx9mH4+7lzNMYMIEZpnR1FFTjWQ5qP+e/h7q2q9dxKf32e2Is8p/0OV5r2u7OArp758ZoGKE0GKHz4MEPF9wDqoFHAdnyd3g+A=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM0PR04MB7169.eurprd04.prod.outlook.com (2603:10a6:208:19a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 12:21:30 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff%3]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 12:21:30 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
CC:     "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "srinivas.kandagatla@linaro.org" <srinivas.kandagatla@linaro.org>
Subject: RE: [PATCH 0/4] dt-bindings: imx: add nvmem property
Thread-Topic: [PATCH 0/4] dt-bindings: imx: add nvmem property
Thread-Index: AQHYPzDdeGvQwiTmbEmT1yMzXeipjazOYVIAgAAS90A=
Date:   Thu, 24 Mar 2022 12:21:30 +0000
Message-ID: <DU0PR04MB941779F67C9FFE6BD4334B6188199@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
 <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
In-Reply-To: <20220324111104.cd7clpkzzedtcrja@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bc2fc1c-2fd5-4790-0f57-08da0d90d3a9
x-ms-traffictypediagnostic: AM0PR04MB7169:EE_
x-microsoft-antispam-prvs: <AM0PR04MB71696B665183F0FF8847515F88199@AM0PR04MB7169.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q68EAhRKSnoTaQ1RVUSxbG5w60Q5HV3Ck3isUqnwLhrm6u6ZFHazgGQoCWzLe1ZWmZdbm7rIBlgF14W+IBDrmxX2P/FDuz9KPYQ2Wl0GTSKV/DP3Dk8Lw8ZlD3mGpOPVhB61+kwoMqzhUiHz5mUNVZKm4judDQ4HpMMnOmXNqPTC2nf1MumqXNQRBS7YMP/TFFED3zwb6ao+0gWdlobtPH5GI1lwKIeIUkCK19oSlgtIiAR8MG+bPsbhN73qseyxyqjEULHZ9mKbZhIdM9GOAwQiD7nqABb87io94GAsI6IAHx57dsCi0sAVxnhrE60Puy+y5Jy7EwhAkzhrbFisoQiPQ7t5pU76OT2yn3YGwsWiqlPR+90GuqX/lU6+kN3RhjrO9QVqVAEmB5C6X9SwpMApcQ7/shBP5yHzGU6Ki1NGMcQCFKVeSRHvK0Kcv8WLR9AkWVHpziJic+Cmi3GQQOfCzn5Zzs5rm8daO4vkjjJguLsVz5HY7EVpMqNRo9KgFRLcQb7OEB6EFAhxC7+UvbZalD0WBjvbfowCPS+zPsoGXwY7YOAYAzySjBzy4nlvbNzySayEgbM8qtctZNfi1hy9ZkRBXoyyN+vyJJQlUJrIkC8td44lmASUpMLysKMVuxfL+MEX8J1dbqUTKwSDxdN/v01pVPEJr9Ni9ti2LLOhY3ow6h4su/Iq0BUS2NGITNS4zni/ca7MmgyBBthtcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(7696005)(6506007)(38070700005)(316002)(2906002)(7416002)(9686003)(83380400001)(55016003)(33656002)(38100700002)(8936002)(26005)(186003)(76116006)(66476007)(64756008)(66446008)(4326008)(8676002)(66556008)(66946007)(122000001)(86362001)(508600001)(110136005)(5660300002)(52536014)(71200400001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d29jU2tDbVNLZFliNGtiT1VBZXB4U0dJbXZPWnViUk1JeTJUVUJvTjI1M0Zw?=
 =?utf-8?B?eFNLWVowQ1I3SGtXUi8vU2JOb1N0VS85VDlBUnlweVAwZmV3UXdlVVBZTmNT?=
 =?utf-8?B?ejVxMGRmU2UyVkdBNmFLUXhlTk9sbEY4V3V4YTNSdk5ObXNZR2EweTFxVFJ6?=
 =?utf-8?B?K1crbTFjUCtkWDFSbTdhcFpzZFhodVpXVDMyUDZwekZ6UWxMNjVRS2hoclhq?=
 =?utf-8?B?cHFieUZwVkRaVEw0ZnFseVc1WTZUTE51OXNiTXVPTzlHQzlqWHIwT2M5dDc0?=
 =?utf-8?B?cm9tQms2Wk4vaCtWQjgyVXZNS1RRQXVQNGZEem5yRU12WldlUTFESWNmMjNh?=
 =?utf-8?B?T1VEVEVCSjUzT0w1NkpESWRhTFN4OFl2am5qWC9xc3BBTXdidEJGSWlaMnkv?=
 =?utf-8?B?dlNDSUJOYitvTzJQL0xsYWpjMGp6bldRRlNmZ0FzVDkrcVdhWnU1cUZSaG1H?=
 =?utf-8?B?VmlOQ1Q5NU5pM1NVTDI4RWZJUUY4c2ZSTmZLcWhHZG9TNEFJWCtwaXdmNHEv?=
 =?utf-8?B?OGtMb3dpNjdiVjRCeFF5SHIyQ1lYbnVYTW1hSkVvU1BYMkFDejNCbHk0L293?=
 =?utf-8?B?bC91bGxCdTdrZGRibGViMFcxc0E4dnBlQk5VSmFhVDlVN05BTU94blp5VGxM?=
 =?utf-8?B?WkJsZFNxWWcwb3h3cVZQV1FFby9DeGY2MzNuMm1rbVhadzNiK0ZNRnRteWQv?=
 =?utf-8?B?UXpuUnpRVExyTkV6anl2MHNxSjFzS29LNFdUK0lUbFBVbnVxY3ZmV1pkdHBM?=
 =?utf-8?B?MCszSkZ2U09na1F0OXRjR3FRZ0pSTzdUd2F3VGl0RUNLeHBzM0RwektwT0xG?=
 =?utf-8?B?dGN0S3I5SzlIcXlxREMxSHlyQktHZjRUejFLNWEyMnFIT0g0RkIybzUyNEFa?=
 =?utf-8?B?dC9CRHUrUTQ1cjhHK2MzWVZxZ3VJTU9WaGppQm03Zng5a2VNUzhEVFl5L0tE?=
 =?utf-8?B?SkluM1lWRkdMaHNrRHhiMCtzOHJ4cmhaYllsbURXc0hzditocTRCYjRYUTlm?=
 =?utf-8?B?RVJ0cEp6ZjZaL05rR0dNWXBYa3NhUTU2b3hwQ2U0eGZKNE1iVmRJK1RCSy9T?=
 =?utf-8?B?RWtSZ0JTYzZrMmh6d3NuaEoyMTFIVStPcHdOMU1YNHVWckZpTC9xdjZ4U1Ft?=
 =?utf-8?B?b2QzQzBQcW5oZE5Tc2Znb0Q1ckJVdXFsOGZSQkhnRWxUN0NiVUlzSHE1U3Jx?=
 =?utf-8?B?UjhaWVZhRU02clBzVHFPZjhmRlErSW53NkQ2d0Q1Wjhqa25ZanVYRTJWa1RY?=
 =?utf-8?B?ZHZyRHBDTTZacGNrT0pTU0xheUlTQ2s3ejFlVXR3eGNjTkh6NkIxVVRQanBS?=
 =?utf-8?B?T0xydWRZenhrVUhheDREMnlvdklNSEliTWxXcWR0RlhrOHJkbEs2MjRmd3pH?=
 =?utf-8?B?WEZocXNoU2s3Q3g3ZjNOaUtFaCtPSHIzbWFabEdVU2VMRlJLeHg4Tmo1a0F5?=
 =?utf-8?B?dCs3VWFDQ1pjSm9WWldXdEhUaVF6bTlBN2tvTDJlNU1kVFI4ZlpEMmRIdWM3?=
 =?utf-8?B?cVoxVEFyYVlCMlcyWFNiTmFhaEJuMVEzNHpBcnA2b0VZWkExWXJ5R3pnTmJO?=
 =?utf-8?B?Q0pQd3VEQzVzaFRJa3lOT2o1U1BBM0FlYmNwNFFzUUhkdFZGRzdqVEMwNjVU?=
 =?utf-8?B?cU9YUS9ITGpIa2xTaHJ5a05uSmZIcFJ1ZE1QMnZsdCt1WHlOdms5ZHFNa2Fn?=
 =?utf-8?B?LzUySm5xSTRUaTVMQzMwc0I3NldGNkZQVXlRaGR3WVZGTjd4MlNVNlI4Vnpm?=
 =?utf-8?B?UE10ejAxVmp4Y0FvREszenVjRkNRYjJ4a1g5ZkE0WUdmOHRtNkdkZWd2dms4?=
 =?utf-8?B?em5PNXFxR2dzUnFRRXhjUmpUYytGMDIxNWwzalZiRi9RVVhmVjU3SVNYQU00?=
 =?utf-8?B?dlBIeWtKRzNUMGUwUVV4K1dtaVNYQ2pydVdQeGFSTEozMlgyb0c5UkZhRFNa?=
 =?utf-8?B?QUFvRmtkbTlzRHVmMjhFMzZTdysvZzlYWXhlNnh4RnRZUEx4V0VCdzJRU1pC?=
 =?utf-8?B?YzFhVUhKZEJwKzh1eC9TWjBrSm85d0hkTlA3akRYSFZtM09BSlM2WTVqd1BR?=
 =?utf-8?B?UEtvMWcxb0tjRkkwdGljU2dLUTk2TlRPR0dUNGNzQ2VzTzcrMktoSldGQU1W?=
 =?utf-8?B?bWdkVGh5U2gxTjFTMGNqRXEwdEp3bTFmY3ZjNG1KSjdTazFuM0lEeUsyMzZw?=
 =?utf-8?B?OVByNU5Nd0JvY0dZWkl1NHlsMG9kQVhsaG83TFN2ejJjc2ZyVndUUVgzTVla?=
 =?utf-8?B?TGlmcEdMRFF2Y1BCZW1MVjYzZGJsRloxQTlTaEdQVDdERU5kbUJzZjBGZW5h?=
 =?utf-8?Q?csdDRA/24uR9nuoF+x?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc2fc1c-2fd5-4790-0f57-08da0d90d3a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 12:21:30.2308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /erUl3xxCWk6wtCtA3ZWUuBPc08AppiIdZCH5O86nUMrU1LvRdPPk/nfCiWK3uzyAXQt+Rxim8oznjSvYOIt1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7169
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIDAvNF0gZHQtYmluZGluZ3M6IGlteDogYWRkIG52bWVtIHBy
b3BlcnR5DQo+IA0KPiBIZWxsbywNCj4gDQo+IE9uIFRodSwgTWFyIDI0LCAyMDIyIGF0IDEyOjIw
OjIwUE0gKzA4MDAsIFBlbmcgRmFuIChPU1MpIHdyb3RlOg0KPiA+IEZyb206IFBlbmcgRmFuIDxw
ZW5nLmZhbkBueHAuY29tPg0KPiA+DQo+ID4gVG8gaS5NWCBTb0MsIHRoZXJlIGFyZSBtYW55IHZh
cmlhbnRzLCBzdWNoIGFzIGkuTVg4TSBQbHVzIHdoaWNoDQo+ID4gZmVhdHVyZSA0IEE1MywgR1BV
LCBWUFUsIFNESEMsIEZMRVhDQU4sIEZFQywgZVFPUyBhbmQgZXRjLg0KPiA+IEJ1dCBpLk1YOE0g
UGx1cyBoYXMgbWFueSBwYXJ0cywgb25lIHBhcnQgbWF5IG5vdCBoYXZlIEZMRVhDQU4sIHRoZQ0K
PiA+IG90aGVyIHBhcnQgbWF5IG5vdCBoYXZlIGVRT1Mgb3IgR1BVLg0KPiA+IEJ1dCB3ZSB1c2Ug
b25lIGRldmljZSB0cmVlIHRvIHN1cHBvcnQgaS5NWDhNUCBpbmNsdWRpbmcgaXRzIHBhcnRzLA0K
PiA+IHRoZW4gd2UgbmVlZCB1cGRhdGUgZGV2aWNlIHRyZWUgdG8gbWFyayB0aGUgZGlzYWJsZWQg
SVAgc3RhdHVzICJkaXNhYmxlZCIuDQo+ID4NCj4gPiBJbiBOWFAgVS1Cb290LCB3ZSBoYXJkY29k
ZWQgbm9kZSBwYXRoIGFuZCBydW50aW1lIHVwZGF0ZSBkZXZpY2UgdHJlZQ0KPiA+IHN0YXR1cyBp
biBVLUJvb3QgYWNjb3JkaW5nIHRvIGZ1c2UgdmFsdWUuIEJ1dCB0aGlzIG1ldGhvZCBpcyBub3QN
Cj4gPiBzY2FsYWJsZSBhbmQgbmVlZCBlbmNvZGluZyBhbGwgdGhlIG5vZGUgcGF0aHMgdGhhdCBu
ZWVkcyBjaGVjay4NCj4gPg0KPiA+IEJ5IGludHJvZHVjaW5nIG52bWVtIHByb3BlcnR5IGZvciBl
YWNoIG5vZGUgdGhhdCBuZWVkcyBydW50aW1lIHVwZGF0ZQ0KPiA+IHN0YXR1cyBwcm9wZXJ0eSBh
Y2NvcmlkbmcgZnVzZSB2YWx1ZSwgd2UgY291bGQgdXNlIG9uZSBCb290bG9hZGVyIGNvZGUNCj4g
PiBwaWVjZSB0byBzdXBwb3J0IGFsbCBpLk1YIFNvQ3MuDQo+ID4NCj4gPiBUaGUgZHJhd2JhY2sg
aXMgd2UgbmVlZCBudm1lbSBwcm9wZXJ0eSBmb3IgYWxsIHRoZSBub2RlcyB3aGljaCBtYXliZQ0K
PiA+IGZ1c2VkIG91dC4NCj4gDQo+IEknZCByYXRoZXIgbm90IGhhdmUgdGhhdCBpbiBhbiBvZmZp
Y2lhbCBiaW5kaW5nIGFzIHRoZSBzeW50YXggaXMgb3J0aG9nb25hbCB0bw0KPiBzdGF0dXMgPSAi
Li4uIiBidXQgdGhlIHNlbWFudGljIGlzbid0LiBBbHNvIGlmIHdlIHdhbnQgc29tZXRoaW5nIGxp
a2UgdGhhdCwgSSdkDQo+IHJhdGhlciBub3Qgd2FudCB0byBhZGFwdCBhbGwgYmluZGluZ3MsIGJ1
dCB3b3VsZCBsaWtlIHRvIHNlZSB0aGlzIGJlaW5nIGdlbmVyaWMNCj4gZW5vdWdoIHRvIGJlIGRl
c2NyaWJlZCBpbiBhIHNpbmdsZSBjYXRjaC1hbGwgYmluZGluZy4NCj4gDQo+IEkgYWxzbyB3b25k
ZXIgaWYgaXQgd291bGQgYmUgbmljZXIgdG8gYWJzdHJhY3QgdGhhdCBhcyBzb21ldGhpbmcgbGlr
ZToNCj4gDQo+IAkvIHsNCj4gCQlmdXNlLWluZm8gew0KPiAJCQljb21wYXRpYmxlID0gIm90cC1m
dXNlLWluZm8iOw0KPiANCj4gCQkJZmxleGNhbiB7DQo+IAkJCQlkZXZpY2VzID0gPCZmbGV4Y2Fu
MT4sIDwmZmxleGNhbjI+Ow0KPiAJCQkJbnZtZW0tY2VsbHMgPSA8JmZsZXhjYW5fZGlzYWJsZWQ+
Ow0KPiAJCQkJbnZtZW0tY2VsbC1uYW1lcyA9ICJkaXNhYmxlZCI7DQo+IAkJCX07DQo+IA0KPiAJ
CQltNyB7DQo+IAkJCQkuLi4uDQo+IAkJCX07DQo+IAkJfTsNCj4gCX07DQo+IA0KPiBhcyB0aGVu
IHRoZSBkcml2ZXIgZXZhbHVhdGluZyB0aGlzIHdvdWxkbid0IG5lZWQgdG8gaXRlcmF0ZSBvdmVy
IHRoZSB3aG9sZSBkdGINCj4gYnV0IGp1c3Qgb3ZlciB0aGlzIG5vZGUuIEJ1dCBJJ2Qgc3RpbGwg
a2VlcCB0aGlzIHByaXZhdGUgdG8gdGhlIGJvb3Rsb2FkZXIgYW5kIG5vdA0KPiBkZXNjcmliZSBp
dCBpbiB0aGUgZ2VuZXJpYyBiaW5kaW5nLg0KDQpHb29kIGlkZWEuIEJ1dCBJIHN0aWxsIHByZWZl
ciBMaW51eCBhY2NlcHQgdGhpcyBiaW5kaW5nIGFuZCByZWxhdGVkIGRldmljZSB0cmVlIGFzDQp5
b3UgZGVzY3JpYmVkIGFib3ZlLCBiZWNhdXNlIFUtQm9vdCBzeW5jIHdpdGggbGludXggZGV2aWNl
IHRyZWUgYW5kIGJpbmRpbmdzLg0KDQpUaGFua3MsDQpQZW5nLg0KDQo+IA0KPiBKdXN0IG15IDAu
MDLigqwNCj4gVXdlDQo=
