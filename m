Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81B469B9FE
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 13:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBRM20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 07:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBRM2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 07:28:25 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2073.outbound.protection.outlook.com [40.107.104.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5FA15C80
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 04:28:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koxHcVSzuVi6J3FB5F7L1zr03EU6NscU3LLYstUUSbuIhQYC3W9ggOX6DiTNgtxpRCpK9u5Kku/9bZN35W5gESkSTNV6egVRXYdRT45nqch/srQwjIiRGsin0NfjOQtKnXpsFdRAqvZ5ymJCHGufpEkpkX3v0SeTv1VeynLyqKLzCv8MVR7hHUOWDlhVn/p/l6RSjRoVtkFSxZXeDR7NjDyuoaOqiV8yB8jO+/useBf/zcimJ4/hbG2zF4owuCyKO5OC4qmWm6t1X914h4SQw/CWzY+3gAkvboaal28/iT42AoSu1E91ZTli79k8aTcFFvMZQCFglrcy0p2WJjuuRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUFlnFHvOxfbCUzm5CIjM/RgI0J41Y9u4kvaU0KF+DM=;
 b=lMPxD3sv1R0ozfil7dTQrXAMSgkg5mFf2X40Xkvee5tNY9OJ0lrhGm5NBOEBOH5X36CGtV3BWq+kjAyyWK8gf8Yd9hJm5YCHvNkEgjJh8CasT1+KJHDfarfr5mtqQ6YAqA9XmA/xfPDJqR1WFItzVQfs2Svm9Hr3JQle2oATknlXFy0153hYmCI/S/rrxMl2lMToUoqWHL9jL995YXih9Yglg7PX3UNbfwJReoYtPt1S4OTKuuWg95lge0yyUnRJhhnXWbG2zhrmpkoLwpEU03W+Op+ArVtKy7bRgls4TbSTkrHVwQ9hyHStfuAXoN/hKv5x+KM6968f8sVaGdAi0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUFlnFHvOxfbCUzm5CIjM/RgI0J41Y9u4kvaU0KF+DM=;
 b=G6dWIsMGKuN5ywsiCpufwnwb7hnxX6eM77Lbjzhufnw80oD8gutPB/XS2aLSPgRzA76jj5nW7jsB0VGKMz+NHR0RhAliN8TvkN9HzFw8LO/M1rnnMDiWOEUcNPMKl0ED3iR4ea7MqbAtERPnIqrpNjUhbK3pZDijBiiPFvWH2pQ=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB8PR04MB6778.eurprd04.prod.outlook.com (2603:10a6:10:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sat, 18 Feb
 2023 12:28:20 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%7]) with mapi id 15.20.6111.018; Sat, 18 Feb 2023
 12:28:20 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Richard Weinberger <richard@nod.at>
CC:     Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: high latency with imx8mm compared to imx6q
Thread-Topic: high latency with imx8mm compared to imx6q
Thread-Index: KX6nItb3xzzXXgLsKrBE7F/dfPfNJbU33POAgABHTYCAAAZaMMtWSb1ctKpkzJDnhT13z5h6zK7w
Date:   Sat, 18 Feb 2023 12:28:20 +0000
Message-ID: <DB9PR04MB81068EF8919ED7488EE1E3D788A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
 <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
 <Y/AkI7DUYKbToEpj@lunn.ch>
 <DB9PR04MB81065CC7BD56EBDDC91C7ED288A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <130183416.146934.1676713353800.JavaMail.zimbra@nod.at>
 <DB9PR04MB8106FE7B686569FB15C3281388A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <2030061857.147332.1676721783879.JavaMail.zimbra@nod.at>
In-Reply-To: <2030061857.147332.1676721783879.JavaMail.zimbra@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DB8PR04MB6778:EE_
x-ms-office365-filtering-correlation-id: 80a911a4-4b41-4960-21e0-08db11ab9ef5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwg+jPbSjgVqmALRZCmGv6H1l6RsWUI2/STHyi5k9g5ewgySjkOxow5Z9tawRMR2plydqR2y/5MGFqJUrRq84YNyqLE8yttJn1E6+fpuAULuaBjf+nn6kmaAx/Rs+yr3b7n4jajQi1HHe8H+m5GzCI+zAFg4FTYRU9WuFItGvjQkHueTv4OPksuhV4qq3zhvMGUJq4CBbFmI4Afm5gx6YgeX9jS5FFyGQfvsV6WoTvKffdV9dL7Z0mhYZ3Ff11y71ZytJLmER1U+qav6FMqm8UO6SRub1fN05mnLq4fM+PPstrUmhYT6QdmD6v+cfedFN6i2CCMAY3WW27uvA0Wy7chXMqyx3STNqrJ+es/HMWcdApYJ3yUQFqHHgL8lYGqKt6lnUEm3y1t9PKHQ5cZIXZnLitMzD55o0gkO8t2BzutXihqOnKbhFsY/o1Vb1BomgcbJJmKliipeXD9fhtVCG3lur/KMpzPkqRwSdJYeyPZwTkKueO/Q+n4RDzcwPM75uobmFh3AsPk1voy1sZS6A9BZ2DnKBqfxt4puLfN4D3Oy7mvNCZPK8VT1Q2ITjgPTXMB5WUgmy9mSeZlump3dVGG6tDQNF1C4DBqptpPUQyXXHpp26Lk1hnxOuKTDs6ujx3DEcVy1vxZx/uZriqbaJ8MtLcW2O2Xirh3hEF6C6kSasNl6UEBTa1YFrB1RF6ua1ijlUATX0iemIBf9Bty/5bpU0ABupRLx1SRayshztDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199018)(33656002)(55016003)(83380400001)(2906002)(44832011)(6506007)(71200400001)(7696005)(26005)(186003)(9686003)(86362001)(122000001)(38100700002)(38070700005)(53546011)(5660300002)(6916009)(52536014)(478600001)(41300700001)(64756008)(66446008)(66476007)(8676002)(4326008)(66946007)(8936002)(76116006)(316002)(66556008)(54906003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTMzT0J2bjc1ZG1icy9RNW9iWmZGSUVNRnBBOVUyenk2Y1JoRFFjVGoxQktS?=
 =?utf-8?B?OFpxTXl5V3JyUkpacUhEL0hSQ2pYaHF4amJpNGdLbHpydk9FR3FzMUJkQnJ5?=
 =?utf-8?B?ZTc1THpkMzZjWWVzdUY0VzhTa09WQm5ieUdrTU85dXd4QmI0K2RtNkYxVGVq?=
 =?utf-8?B?Zmt1bHE0Y1NIb0pTSnJEb3p1ZnlFQ1BiWjRFb2tnSU05UGtzNFBTOE1PNk9M?=
 =?utf-8?B?V2VWbTNud29CZHNrQWxiSDIzOXRMTEE3OEJSbmxMUG1pZC9Qcy9Ody9UN0VH?=
 =?utf-8?B?d3hvYitGdytHMlpRKzkzMkNwaGxiZmdIeS9PZElnYWpyeVBONXREVEIxRUpp?=
 =?utf-8?B?TWYvTHdHc1QxNWxxZVNjM2VoYW8veGZPblJhd01mM0cvSHlxOFEyOEhsK3NN?=
 =?utf-8?B?NjJYYTczMjNWZE9NV0F1YkZXNiszOFVvVGJIb2JmSTFSRU1TMlkvQmVTTWVE?=
 =?utf-8?B?c3ZnYmMrSitWZHhOREZjbDNNNmQwekF3ZVlxMkdyRW96Q295MFJBRk9QR0lM?=
 =?utf-8?B?bzRSOEVYWWcycnpKYXdObjZWbmJjU2FLakpLYS9OZTBHa2M2MUFBc2ZQbENw?=
 =?utf-8?B?Um5MbVhTaWpOK3JVUFZEbWNXUHAyZXpjWktEUDliNmExSzgrWVhiZWlVQno1?=
 =?utf-8?B?M2FGNjNPVlEvSVNKK1d5Vk9FelFWOERIUWtSZXJuUjR6eDJiaHV0RFRFZzZv?=
 =?utf-8?B?cFR6N0pTcDRmWnJtRnBCMW1xT09PTkhrcGdYWUNraEVocGY5WGc2WnNDZGJ3?=
 =?utf-8?B?QXZ1akZZSmt2dHBqbnFCbDl4SHo0czFNcUdEV1ZmWVptSlkwOW5JcTRDUzlj?=
 =?utf-8?B?S0VOdkczbWttQU1oNU5DaHMyNXZVZnlrb2lMdklvdHpjWVFxQTY1UDAxU3ZR?=
 =?utf-8?B?eUJLamhRU1RyVmlLbHFTZmtHemMzempYdjRXZFRjWHFrMHlrQjZ5Z0JpTjNH?=
 =?utf-8?B?cG9ZVW5JemwwRnd1NDFyRU1CV1pkZTdrL01nWXR4a1VBR2tZcVpMTUcrTHhp?=
 =?utf-8?B?UFU5TklsNFoyM0N0TkFheVFwNVl5NkphaUVOdmtjQUt0V0FwOWJvVCtMcHBk?=
 =?utf-8?B?eWd3MDZTdERDM0pTN2d5NWFzMklkZWVPaGdMUVVwUEFXMWVtR1BBNlpXZmxR?=
 =?utf-8?B?eXhRSFZyaUV4VkZLM25nVllEdmFIZmdqb0ViQWU0MVlDMDRzdUZLM1drc29C?=
 =?utf-8?B?L3VLNkh5Vmh6a3pZM1hmNDB5eFdjVzJqbC81WExEK0lRdERrMEszdktIQ1hv?=
 =?utf-8?B?RHBWUU9xTUdjZU5xbGttV1NETDRib0lTMUJPUmNDUzNPUDVPWFlCWG5Ic2RI?=
 =?utf-8?B?RDZ0dUhiaG9Pa2x2Y3VORWdrRDlmaTdWcVkzYXVtQURlallvVGpBYkZ6Rnhp?=
 =?utf-8?B?VnNreVJrTkZvN2lVN2dzaXEyckxQM01jZlpCWVpzeXlvMnBvbm1GcW5MQ0VW?=
 =?utf-8?B?b2hpUFhubGFBbUdSRkQ0UHRKOXZZS3IrWkpQblhvejVUcWhpS1pKR3d6azhB?=
 =?utf-8?B?ZzYwU284YnRVemtpWG1NRHI1TXpXRXY3MGdoZ0FMVGZJNFZzeGFSNjYxMVZ4?=
 =?utf-8?B?QXlOSnFDcG5jd2x5L2JRQXZCcnZkV0hVbU9GOVlFUkRXaXRqYlNFTDZMbGFV?=
 =?utf-8?B?YkRWMzBrZXorMlZQb29pUmtLd1lRZmZvb2VPMXFyaGxGSHV6VjRZc1hHYTlS?=
 =?utf-8?B?NWQvUytFYXVVeW9UUWZlK2h5OHVUQjhCU3dTNksyVVZUTlNCRGlCcUM3blJ6?=
 =?utf-8?B?V0dqa0IyYUxmanQwNTVjK3oxZ3BWOUg3TmQ2Ly96OXFxTVVITHBmNUc4Q3g0?=
 =?utf-8?B?eXM0TURjZXJQdzRncWtGMXNjV3lPSjRRbXF0NzE0VW9jMlRZNmxuandsOUhH?=
 =?utf-8?B?WWdaWGkxVFdHai9aN2hxMVl0OStQcHQrMVlMdVVRRCtQeGI2SVVvc1ZreDUw?=
 =?utf-8?B?VWxlYjBqNTdocEp2QjNybGxGWHBFV0RjMWwybW1WblJNdUhpa0RIUHN2azZK?=
 =?utf-8?B?MmE5ZDVaK1czWmt3eUFIeDNDZ1RQcmdYNnV4SWZXc0wrdHdwU0tGNEdlanov?=
 =?utf-8?B?T3ozcVZISUk0SlgzOVpBSVU3WHg4TmNlZEJxV0NkU1hjK0dLSCtCd01FRjZU?=
 =?utf-8?Q?+CEk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a911a4-4b41-4960-21e0-08db11ab9ef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 12:28:20.6533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Ip6KUEMtLSKr2xoZscmg8/4+fjH4JDhCZ/4OJBTy/92JG1mFowhsgNT/hY0XQrX34vsIEu+HpjIyY6yZ2qXzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6778
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJpY2hhcmQgV2VpbmJlcmdl
ciA8cmljaGFyZEBub2QuYXQ+DQo+IFNlbnQ6IDIwMjPlubQy5pyIMTjml6UgMjA6MDMNCj4gVG86
IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPjsgRGF2aWQgTGFpZ2h0DQo+IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNvbT47IG5ldGRl
diA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IFNoZW53ZWkNCj4gV2FuZyA8c2hlbndlaS53YW5n
QG54cC5jb20+OyBDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+Ow0KPiBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogaGlnaCBsYXRlbmN5IHdp
dGggaW14OG1tIGNvbXBhcmVkIHRvIGlteDZxDQo+IA0KPiAtLS0tLSBVcnNwcsO8bmdsaWNoZSBN
YWlsIC0tLS0tDQo+ID4gVm9uOiAid2VpIGZhbmciIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+PiBI
bSwgSSB0aG91Z2h0IG15IHNldHRpbmdzIGFyZSBmaW5lIChJT1cgbm8gY29hbGVzY2luZyBhdCBh
bGwpLg0KPiA+PiBDb2FsZXNjZSBwYXJhbWV0ZXJzIGZvciBldGgwOg0KPiA+PiBBZGFwdGl2ZSBS
WDogbi9hICBUWDogbi9hDQo+ID4+IHJ4LXVzZWNzOiAwDQo+ID4+IHJ4LWZyYW1lczogMA0KPiA+
PiB0eC11c2VjczogMA0KPiA+PiB0eC1mcmFtZXM6IDANCj4gPj4NCj4gPiBVbmZvcnR1bmF0ZWx5
LCB0aGUgZmVjIGRyaXZlciBkb2VzIG5vdCBzdXBwb3J0IHRvIHNldA0KPiA+IHJ4LXVzZWNzL3J4
LWZyYW1lcy90eC11c2Vjcy90eC1mcmFtZXMNCj4gPiB0byAwIHRvIGRpc2FibGUgaW50ZXJydXB0
IGNvYWxlc2NpbmcuIDAgaXMgYW4gaW52YWxpZCBwYXJhbWV0ZXJzLiA6KA0KPiANCj4gU28gc2V0
dGluZyBhbGwgdmFsdWVzIHRvIDEgaXMgdGhlIG1vc3QgIm5vIGNvYWxlc2NpbmciIHNldHRpbmcg
aSBjYW4gZ2V0Pw0KPiANCklmIHlvdSB1c2UgdGhlIGV0aHRvb2wgY21kLCB0aGUgbWluaW11bSBj
YW4gb25seSBiZSBzZXQgdG8gMS4NCkJ1dCB5b3UgY2FuIHNldCB0aGUgY29hbGVzY2luZyByZWdp
c3RlcnMgZGlyZWN0bHkgb24geW91ciBjb25zb2xlLA0KRU5FVF9SWElDbltJQ0VOXSAoYWRkcjog
YmFzZSArIEYwaCBvZmZzZXQgKyAoNGQgw5cgbikgd2hlcmUgbj0wLDEsMikgYW5kDQpFTkVUX1RY
SUNuW0lDRU5dIChhZGRyOiBiYXNlICsgMTAwaCBvZmZzZXQgKyAoNGQgw5cgbiksIHdoZXJlIG49
MGQgdG8gMmQpDQpzZXQgdGhlIElDRU4gYml0IChiaXQgMzEpIHRvIDA6DQowIGRpc2FibGUgSW50
ZXJydXB0IGNvYWxlc2NpbmcuDQoxIGRpc2FibGUgSW50ZXJydXB0IGNvYWxlc2NpbmcuDQpvciBt
b2RpZnkgeW91IGZlYyBkcml2ZXIsIGJ1dCByZW1lbWJlciwgdGhlIGludGVycnVwdCBjb2FsZXNj
aW5nIGZlYXR1cmUNCmNhbiBvbmx5IGJlIGRpc2FibGUgYnkgc2V0dGluZyB0aGUgSUNFTiBiaXQg
dG8gMCwgZG8gbm90IHNldCB0aGUgdHgvcnggdXNlY3MvZnJhbWVzDQp0byAwLg0KDQo+ID4+DQo+
ID4+IEJ1dCBJIG5vdGljZWQgc29tZXRoaW5nIGludGVyZXN0aW5nIHRoaXMgbW9ybmluZy4gV2hl
biBJIHNldA0KPiA+PiByeC11c2VjcywgdHgtdXNlY3MsIHJ4LWZyYW1lcyBhbmQgdHgtZnJhbWVz
IHRvIDEsICpzb21ldGltZXMqIHRoZSBSVFQgaXMNCj4gZ29vZC4NCj4gPj4NCj4gPj4gUElORyAx
OTIuMTY4LjAuNTIgKDE5Mi4xNjguMC41MikgNTYoODQpIGJ5dGVzIG9mIGRhdGEuDQo+ID4+IDY0
IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT0xIHR0bD02NCB0aW1lPTAuNzMwIG1z
DQo+ID4+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT0yIHR0bD02NCB0aW1l
PTAuMzU2IG1zDQo+ID4+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT0zIHR0
bD02NCB0aW1lPTAuMzAzIG1zDQo+ID4+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21w
X3NlcT00IHR0bD02NCB0aW1lPTIuMjIgbXMNCj4gPj4gNjQgYnl0ZXMgZnJvbSAxOTIuMTY4LjAu
NTI6IGljbXBfc2VxPTUgdHRsPTY0IHRpbWU9Mi41NCBtcw0KPiA+PiA2NCBieXRlcyBmcm9tIDE5
Mi4xNjguMC41MjogaWNtcF9zZXE9NiB0dGw9NjQgdGltZT0wLjM1NCBtcw0KPiA+PiA2NCBieXRl
cyBmcm9tIDE5Mi4xNjguMC41MjogaWNtcF9zZXE9NyB0dGw9NjQgdGltZT0yLjIyIG1zDQo+ID4+
IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT04IHR0bD02NCB0aW1lPTIuNTQg
bXMNCj4gPj4gNjQgYnl0ZXMgZnJvbSAxOTIuMTY4LjAuNTI6IGljbXBfc2VxPTkgdHRsPTY0IHRp
bWU9Mi41MyBtcw0KPiA+Pg0KPiA+PiBTbyBjb2FsZXNjaW5nIHBsYXlzIGEgcm9sZSBidXQgaXQg
bG9va3MgbGlrZSB0aGUgZXRoZXJuZXQgY29udHJvbGxlcg0KPiA+PiBkb2VzIG5vdCBhbHdheXMg
b2JleSBteSBzZXR0aW5ncy4NCj4gPj4gSSBkaWRuJ3QgbG9vayBpbnRvIHRoZSBjb25maWd1cmVk
IHJlZ2lzdGVycyBzbyBmYXIsIG1heWJlIGV0aHRvb2wNCj4gPj4gZG9lcyBub3Qgc2V0IHRoZW0g
Y29ycmVjdGx5Lg0KPiA+Pg0KPiA+IEl0IGxvb2sgYSBiaXQgd2VpcmQuIEkgZGlkIHRoZSBzYW1l
IHNldHRpbmcgd2l0aCBteSBpLk1YOFVMUCBhbmQNCj4gPiBkaWRuJ3QgaGF2ZSB0aGlzIGlzc3Vl
LiBJJ20gbm90IHN1cmUgd2hldGhlciB5b3UgbmV0d29yayBpcyBzdGFibGUgb3INCj4gPiBuZXR3
b3JrIG5vZGUgZGV2aWNlcyBhbHNvIGVuYWJsZSBpbnRlcnJ1cHQgY29hbGVzY2luZyBhbmQgdGhl
IHJlbGV2YW50DQo+ID4gcGFyYW1ldGVycyBhcmUgc2V0IHRvIGEgYml0IGhpZ2guDQo+IA0KPiBJ
J20gcHJldHR5IHN1cmUgbXkgbmV0d29yayBpcyBnb29kLCBJJ3ZlIHRlc3RlZCBhbHNvIGRpZmZl
cmVudCBsb2NhdGlvbnMuDQo+IEFuZCBhcyBJIHNhaWQsIHdpdGggdGhlIGlteDZxIG9uIHRoZSB2
ZXJ5IHNhbWUgbmV0d29yayBldmVyeXRoaW5nIHdvcmtzIGFzDQo+IGV4cGVjdGVkLg0KPiANCj4g
U28sIHdpdGggcngtdXNlY3MvcngtZnJhbWVzL3R4LXVzZWNzL3R4LWZyYW1lcyBzZXQgdG8gMSwg
eW91IHNlZSBhIFJUVCBzbWFsbGVyDQo+IHRoYW4gMW1zPw0KPiANClllcywgYnV0IG15IHBsYXRm
b3JtIGlzIGkuTVg4VUxQIG5vdCBpLk1YOE1NLCBJJ2xsIGNoZWNrIGkuTVg4TU0gbmV4dCBNb25k
YXkuDQo=
