Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41576BCA68
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCPJKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCPJKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:10:39 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2059.outbound.protection.outlook.com [40.107.241.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F115138EBD;
        Thu, 16 Mar 2023 02:10:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlFwlstz/MWlYuALOgvopnU8hjx2bBzIkdJEk2/Zzraig7TcOY/f2aZXLdaw4K6GaTI7OVpwNqmznx3OEiry1lwpEbZcJ2hwNRWNlnL51dEVevxym2Opl7NscCsJSKHrv61JdZpLHQeu7Vg+gGBw5m+lv5ktKm//ysJkNL3lzKcfAmuq2QDzt4+evfrdpnqOag/WSIvAYmi60K1/LK4/PfxRI8WsQcJoB0R2IxiAPbxfdydQNoLZ5OUGml7tYuq6rsQnCEkSqMdZuITUR1qv8RGW15/9+0VRu7dkz21cZ/rrmzIylsjNi5VvGyNWuZz38NvmcEXHNbDolWejuex6Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkg0IjH/SNjEhpXL7sV2B2UrGWEFGpCeoqjGn3twkVw=;
 b=fSuUg5SrUFCK57fnXXuj2P3InnjMB16zSUFeizbe9UNsnlwVZ4Z3PUgSEZ2c45GVlI4M/CuNjFBEKasAv+V1jkoHYk5c2UxhUSeQYIu6G7soDHsgwbKSNZWBFxTozKuXpJHhnUf+dxU+Pyn7Rj6Rm/Pjw3N6GzTKj3nkwKJrlS8lyofDRZgU5ld+fsQR6sijXdfyTKxz+O4QZukP4UGhjpDZNpqYLBtTVt0acYh5j9HrpzKHUQ2pIXKpdoof1ud08NIJInVE0h6UsxVIiNe6jbRl4zZytcfBt0hsXp12c7T/pGY2Ze6bIxZbmIw+xHTvrpDl5ePsyMKPawEkauVLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkg0IjH/SNjEhpXL7sV2B2UrGWEFGpCeoqjGn3twkVw=;
 b=Lu9B+Qcv6/NGdf/mf+Df75f0qNrQy4W9hkZoF3Iy3EUY39kM3pDG5BNW7HvGlACt7k2252m635J64ZOJA5UZi/JqTvIKR7rRotYbSTqvPApI5sYGKI3m4pEiUcMq5Hcix04isGKstEvq5E1ZTubo44G1QDR0kvrGGQOLiVTIuT0=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by PAXPR04MB8476.eurprd04.prod.outlook.com (2603:10a6:102:1df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 09:10:24 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::414:d11c:d215:4ed3]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::414:d11c:d215:4ed3%7]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 09:10:23 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to
 probe
Thread-Topic: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to
 probe
Thread-Index: AQHZVnb/KB/pqz+XYEihHV2b1uAXEK77VTGwgAAdBgCAAZwbgIAACHtw
Date:   Thu, 16 Mar 2023 09:10:23 +0000
Message-ID: <AM5PR04MB313943C24A61C48D761B452688BC9@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
 <20230314131443.46342-4-wsa+renesas@sang-engineering.com>
 <DB9PR04MB8106C492FAAE4D7BE9CB731688BF9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <ZBFzVjaRjcITP0bA@ninjato> <ZBLNCYgeTtNBSaMi@ninjato>
In-Reply-To: <ZBLNCYgeTtNBSaMi@ninjato>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|PAXPR04MB8476:EE_
x-ms-office365-filtering-correlation-id: 7a7782c5-6211-470c-9a82-08db25fe4648
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IisiI0L+o+Hj1mvXh7hzKuHihEl+tod2+r9JECYzvss9yqiTqvChuyoIblglB0HxVVHU3ExZrcjoocfQwBAX3JqdR2DOQK90tviZXpwjinw9UHlOEfoqpWaKAviIFB7fC4PrNeY+R1qrAjkP8qMk7O1eHBiUfcsPvX3UQgrr4FhMOu9HrlmkuyIG1rlImOzqyWbFHMER2SKWhhO6yDDxfT0jjfh9Dhbp1G496ez0k4h6Ti4lb1CTsFhzKmqAIfqkGRxf2RlhSrUEAUg6mmn7gwoix2/BCuBTJlBK5crVJtfZmhGrU7MTtAm0R9nyNw4q5Ac8D83IxI7EaKLiBkR9fJAVGHFqOWVwX/hTtXZSX2n4FlEZBba5fSUwgitEP/NvUJtmyLmTWsj2ldas68pAXgY5+K8Wf2rkmi5nQvmMJ4waS4nnaVZMBqEcJ5adhRApGT2foVopEWWzjqabVn8Q3TVXS0NpUtsQ9yWACBZRRNCKE9Odu9qUPmB2nEhliPc8GAhqCCIsN1WwG+EBsXvuzQgeriYJp79tSb25vyXXLqAQFUGalzMgubjZrDEQFWmY2QPQOFl1PUT3BZq9lOdA5KYJlyg8UxHycyXw+RWB23pc8gtAvGrpXprLp6JHPGqpAPikZ1ywfu7oxHFPT68IGotqtHQM/XgM5BWQDNtvDII9iSWpRcp8sM9r2pUFYKUWpGxeHA1ySGjafP7M1kueRMHjiM1j6DE/xU3fxoG+FsQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199018)(83380400001)(86362001)(478600001)(316002)(110136005)(53546011)(7696005)(26005)(6506007)(186003)(33656002)(71200400001)(55016003)(921005)(38100700002)(38070700005)(9686003)(2906002)(66946007)(122000001)(5660300002)(76116006)(44832011)(8936002)(66556008)(66446008)(66476007)(64756008)(52536014)(41300700001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?T0xTUUNmQURRY1RhMDBydkQ0MWF6Qk5pZFQwMWc3akw4eTNWamJHRjJBZCt1?=
 =?gb2312?B?NTF2WEMyY2FGRk1Mejl5elpwVHVVeFJ6U2c2REtIMyswWnFZVE0yNmF5bjF3?=
 =?gb2312?B?WUFUOWpvdWtKZ29DS2pPRitELzJlMythVDlzS3RtNDVRbG9SMFUvRkswekcy?=
 =?gb2312?B?UGNuazlkazRmeUk3Uzd4UlNNNXU2RzhHWTc1d3ZGYk9sZlYxaEN4T2VFWGpP?=
 =?gb2312?B?RTFxVkt0a2hMWmVyNXlqTGhpblJtbmZ2bWc4Uk1VdXFmVFBSbXhsbFJtak5z?=
 =?gb2312?B?MUU1UmVXUUhJWnhPOEg2TWJ2TDhLYzR4c0FxL1h1NVl3eDZDQ3VnME4vSTVP?=
 =?gb2312?B?Nzk0TmduT2hyNUdJZkh5a0xwUmkxU2k5VnUycHExbnV1cnh5clo0UlVob052?=
 =?gb2312?B?bjZiM0xqSVRNdVEwMGw2Y1dmdUNRck8rZ1VYT1ovZFlDaFFiQjVpWWVad1dV?=
 =?gb2312?B?ZS9HVzBrQ0QrclpYcS92R3I1Z0htTm9IK2EzL096V29DS0RRRnJ6YkFndWdo?=
 =?gb2312?B?Y1BQZUxxdUg0VUdmY3BUaTZqRCtvUEtBQlJuSVpMUWxoQlJ0MUdwM2l3N0RG?=
 =?gb2312?B?OVZxbDhiK1IwbHRuYk1vbFJaYnp1c2pZVlpIaUdaUXZMdXYvb0RZbHdFTG5i?=
 =?gb2312?B?ekN2bCtCS0oycXN5K1Y3ZDdSK2lCTnh6ZjgyLzRVYlovTGJvUHhqWUZNeS8x?=
 =?gb2312?B?NkNzeFIwSkh6VVRxdTJuSThzNUpwMlI0MWphUk5rNkF3M3ZNdWFwL1JyNkVF?=
 =?gb2312?B?b1ZnS1UwU2JlSmQzMGVKTStZbHhLQWtQMy9xdmpOTlluVkkzZ3VZejlUMklZ?=
 =?gb2312?B?ZHEzaUx5dGx5TlhmWHVJUGdPUHYrdktteVZ5QmxLU01la1VDTkNLNjBBVmJM?=
 =?gb2312?B?bTZDQ25xR1lmS1hMVEovM1ZKMG0yZ2RQOHA5KzNJSlZkZlNLSzI0dDdYZ2Jz?=
 =?gb2312?B?c2xDVFNwOW1VREJscGJqOUlteWpWVUZKVnJVZFVkQlUxamhvYnpEVjV1SFhJ?=
 =?gb2312?B?UExLMmZNS3FzbzlQcHBHUDBNWUtkVm1kVDVsT0tsYUVFYWRpZ2RrcFRzaVhI?=
 =?gb2312?B?ekxqY01EUFAzTCsxZ3lQczJKMFk2UTVuMytDNmNENjhMVVFBdlBaN3RJdlI5?=
 =?gb2312?B?Y0NSS1VwZm93VEc2T0owREROMHN4eUNKMk5QRVlCWnpKVVRuZWV3ekZBQjRk?=
 =?gb2312?B?TjJKVmlZbGJiNzM4eU1TL2ptMU5tNkNCd2JHZ1E0K3R3cmVBeU52NmptVW51?=
 =?gb2312?B?NGQ0bFR2UkY1NDkzT3RaSDJLRitwUjlqNEZKeDBYUEg1MWdjMHYwaE5oR3cw?=
 =?gb2312?B?MFpoOTRuUlFpTmgvTFVKQm1IZ2YzR1ZWbjYxRW44bmJpcnhxZUN4U29VQnZ1?=
 =?gb2312?B?ejFiNnpDbFdONkpFVUFlMVp3eCtHSUIzOXZSbytmdzM1OGlmSmVCV2VVaVJW?=
 =?gb2312?B?b2libys5QjlIVTRYZTQ5TGpTUjgzeXoyY0huN2p5cjY5T0xFQ0hXU2ppZDM3?=
 =?gb2312?B?UGZWUThJVzZIUnM2ZCszVGlTRklSTjJtb1lwNUlyLzFkS2ljRUFzbFIyR3NT?=
 =?gb2312?B?ckVORFV2NU5LTnBLdFN1dnQzUE9vaXlYeVVQNVNLZjlPQUh3aFlxS1VLYkE0?=
 =?gb2312?B?NnBSbzVTeldBUHJsRURTdGMrVVNrSmplaDhQN25WOUkxbFlnN2E2S3dRYlBq?=
 =?gb2312?B?eEN6VjhrMERpeStDL05RK0hqK3kyMjRYM0MyUThncUJmNUtDbjNNSFo2YWU0?=
 =?gb2312?B?RGZPa1V5ZEMrM0hSSHVDRWdNNFl6Ykw5QzMrUlpOSVIyZmlRdzJRVm5WK3Bm?=
 =?gb2312?B?ODJpb0VpekZOREZSZk9pM2U3UDZhOWVFTzU1MkdzNElSV09OcXQ0ZHk1ZFpR?=
 =?gb2312?B?ckdmUjBQYUQ1V1RJWTZETTUwZ2NNQS9rM0Y1TTB1RkdIWnV3Rkl4bmE0SkNK?=
 =?gb2312?B?WllUbXFSYW5iOHQ4aUd0VW5ZalBac2xRWmtEZ2dUUVhyM012Mis2RXpLSlpQ?=
 =?gb2312?B?VlJzK1hUNGlPNHFNZ0lXTkd1dWxYYnpnVEZvQ1pNc2hBZVphR25UeCtWc2tB?=
 =?gb2312?B?NExvS3dEcTRRUmFQclZVYU4weUpqRW1URzMxVkZ0eEZFcUx3Uk5Ga3hGSGZq?=
 =?gb2312?Q?Gvgk=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7782c5-6211-470c-9a82-08db25fe4648
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 09:10:23.3828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3iBDA11w7RuyK9lweZsVK6sbbT7+2zCG7LkMoqXXlSZZ/CMwlHYR0Y6WzkKI/muisqC/b9MuoZNRnGFH4x0/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8476
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBXb2xmcmFtIFNhbmcgPHdzYSty
ZW5lc2FzQHNhbmctZW5naW5lZXJpbmcuY29tPg0KPiBTZW50OiAyMDIzxOoz1MIxNsjVIDE2OjAy
DQo+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGxpbnV4LXJlbmVzYXMtc29jQHZn
ZXIua2VybmVsLm9yZzsNCj4ga2VybmVsQHBlbmd1dHJvbml4LmRlOyBTaGVud2VpIFdhbmcgPHNo
ZW53ZWkud2FuZ0BueHAuY29tPjsgQ2xhcmsNCj4gV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29t
PjsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IERhdmlkIFMuDQo+IE1pbGxlciA8
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47
DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5p
QHJlZGhhdC5jb20+Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMy80XSBmZWM6IGFk
ZCBGSVhNRSB0byBtb3ZlICdtYWNfbWFuYWdlZF9wbScNCj4gdG8gcHJvYmUNCj4gDQo+IA0KPiA+
IFllcywgSSB3aWxsIHJlc2VuZCB0aGUgc2VyaWVzIGFzIFJGQyB3aXRoIG1vcmUgZXhwbGFuYXRp
b25zLg0KPiANCj4gQmVjYXVzZSBJIHdhcyBhYmxlIHRvIGZpeCBTTVNDIG15c2VsZiwgSSdsbCBq
dXN0IGRlc2NyaWJlIHRoZSBwcm9jZWR1cmUNCj4gaGVyZToNCj4gDQo+IDEpIGFwcGx5IHRoaXMg
ZGVidWcgcGF0Y2g6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZp
Y2UuYyBiL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMgaW5kZXgNCj4gMWIyZTI1M2ZjZTc1
Li43Yjc5YzU5Nzk0ODYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNl
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiBAQCAtMzEwLDYgKzMx
MCw4IEBAIHN0YXRpYyBfX21heWJlX3VudXNlZCBpbnQNCj4gbWRpb19idXNfcGh5X3N1c3BlbmQo
c3RydWN0IGRldmljZSAqZGV2KQ0KPiAgCWlmIChwaHlkZXYtPm1hY19tYW5hZ2VkX3BtKQ0KPiAg
CQlyZXR1cm4gMDsNCj4gDQo+ICtwcmludGsoS0VSTl9JTkZPICIqKioqKiogTURJTyBzdXNwZW5k
XG4iKTsNCj4gKw0KPiAgCS8qIFdha2V1cCBpbnRlcnJ1cHRzIG1heSBvY2N1ciBkdXJpbmcgdGhl
IHN5c3RlbSBzbGVlcCB0cmFuc2l0aW9uIHdoZW4NCj4gIAkgKiB0aGUgUEhZIGlzIGluYWNjZXNz
aWJsZS4gU2V0IGZsYWcgdG8gcG9zdHBvbmUgaGFuZGxpbmcgdW50aWwgdGhlIFBIWQ0KPiAgCSAq
IGhhcyByZXN1bWVkLiBXYWl0IGZvciBjb25jdXJyZW50IGludGVycnVwdCBoYW5kbGVyIHRvIGNv
bXBsZXRlLg0KPiANCj4gMikgYm9vdCB0aGUgZGV2aWNlIHdpdGhvdXQgYnJpbmdpbmcgdGhlIGlu
dGVyZmFjZSAoYW5kIHRodXMgdGhlIFBIWSkgdXAuDQo+ICAgIEJyaW5naW5nIGl0IGRvd24gYWZ0
ZXIgaXQgd2FzIHVwIGlzIG5vdCB0aGUgc2FtZSEgSXQgaXMgaW1wb3J0YW50DQo+ICAgIHRoYXQg
aXQgd2FzIG5ldmVyIHVwIGJlZm9yZS4NCj4gDQo+IDMpIGRvIGEgc3VzcGVuZC10by1yYW0vcmVz
dW1lIGN5Y2xlDQo+IA0KPiA0KSB5b3VyIGxvZyBzaG91bGQgc2hvdyB0aGUgYWJvdmUgZGVidWcg
bWVzc2FnZS4gSWYgbm90LCBJIHdhcyB3cm9uZw0KPiANCj4gNSkgSWYgeWVzLCBhcHBseSBhIHNp
bWlsYXIgZml4IHRvIHRoZSBvbmUgSSBkaWQgZm9yIHRoZSBSZW5lc2FzIGRyaXZlcnMNCj4gICAg
aW4gdGhpcyBzZXJpZXMNCj4gDQo+IDYpIHN1c3BlbmQvcmVzdW1lIHNob3VsZCBub3Qgc2hvdyB0
aGUgZGVidWcgbWVzc2FnZSBhbnltb3JlDQo+IA0KPiA3KSB0ZXN0IGZvciByZWdyZXNzaW9ucyBh
bmQgc2VuZCBvdXQgOikNCj4gDQo+IEkgaG9wZSB0aGlzIHdhcyB1bmRlcnN0YW5kYWJsZS4gSWYg
bm90LCBmZWVsIGZyZWUgdG8gYXNrLg0KPiANCj4gSGFwcHkgaGFja2luZywNCj4gDQoNClRoYW5r
IHlvdSBXb2xmcmFtLiBCdXQgSSdtIG5vdCBzdXJlIHdoZXRoZXIgaXQncyByZWFsbHkgYW4gaXNz
dWUuIFRoZSBmbGFnDQoiIG1hY19tYW5hZ2VkX3BtIiBpbmRpY2F0ZXMgdGhhdCB0aGUgTUFDIGRy
aXZlciB3aWxsIHRha2UgY2FyZSBvZg0Kc3VzcGVuZGluZy9yZXN1bWluZyB0aGUgUEhZLCB0aGF0
IGlzIHRvIHNheSB0aGUgTUFDIGRyaXZlciBjYWxscw0KcGh5X3N0b3AoKS9waHlfc3RhcnQoKSBp
biBpdHMgUE0gY2FsbGJhY2tzLiBJZiBhIGV0aGVybmV0IGludGVyZmFjZSBuZXZlcg0KYnJpbmdz
IHVwLCB0aGUgTUFDIFBNIGNhbGxiYWNrcyBkbyBub3RoaW5nIGFuZCBqdXN0IHJldHVybiAwIGRp
cmVjdGx5LiBTbyBJDQp0aGluayBpdCdzIGZpbmUgZm9yIHRoZSBNRElPIFBNIHRvIGRvIHN1c3Bl
bmQvcmVzdW1lIHRoZSBQSFkgdW5sZXNzIHRoZSBNRElPDQpidXMgY2FuJ3QgYmUgYWNjZXNzZWQu
DQoNCg0KDQo=
