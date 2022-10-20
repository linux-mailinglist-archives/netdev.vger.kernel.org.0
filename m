Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D247B605667
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 06:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJTEjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 00:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJTEjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 00:39:01 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2049.outbound.protection.outlook.com [40.107.22.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FAD16EA08;
        Wed, 19 Oct 2022 21:38:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4KXWhpuqAQqfHfWADxSLywMDyFDLlpt9eU6Csx8pLOXB6sVTemm+dsPi3Xi/rPlBJ6rxE6VMZtOJl5YRKNgR/5BxnaBx9kmvjM82fDdGoO17qrman8cn2KK8arYaZG+PSTEAsZHyOARLouIhyOb+vp7pdmMGtmpEKWOThdFPDSf9S4DEdhRo3npGFtw4gN170kwWjQ/O9waLydx3M4mHG4kaZRbEEOqGIzi9LAqK5BpvoAD6k3bZB8p6EexrwQo9KkO17XsG56d5FLPKJU3D04Mna1M9AMRXeBtN0TVeXY3H78FbLw1Rimi+Ba3WfEwGTQNxhKEKGCm7ZFOJIJxDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/Etkd6QXR/VHwohzLxNUEGFOfk9Zp5JKceT2oTy7kg=;
 b=alaaLbkV74Cg57aC8EaCTdwOdu4Cnd0oVDdXRssg5QkJg5IwQliy96EAcNel/asu9RrACpHqaspPAk6LDzNRMbYn4qX4CU7BJNj6LP3NXjMT693b6v2vk7KnMalxFT333saCY4ZEuM0bMfR7eWwf5/OOd89/VZLU4XWYMXWScROA3YwS+wlxUFTk1wh8M1UcOGGixgGwidMKG4V1rJakWzIst5+1WvEX369ITdHmXZdqQmU6AMSXI4udxmn5oWotCx24KK5YNyuSYSRThFmH7gJCqeO7ZrqZipQP/o861fkcA58lMvzTlHm1BqQiLZ07SXbTXk7CrgVyEgotBMq1Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/Etkd6QXR/VHwohzLxNUEGFOfk9Zp5JKceT2oTy7kg=;
 b=Y1We43LepRx1HG6nadaAaHj7yhx+56jlU356NlBjFC+D1BAERE8B1FLdzYCW49NAiPQZEdqh4D1nQeAiS0IfMl/fAB09MiNG1gYHOS9YSyq1stFYEIKk8pBxbwEm5ihmlttNvx29bPrniZfKNkS4T+tfnK/XLAKwchNdUsPR9gg=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DBBPR04MB7819.eurprd04.prod.outlook.com (2603:10a6:10:1e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 04:38:51 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::904:970c:dd08:fd47]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::904:970c:dd08:fd47%6]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 04:38:51 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frank Li <frank.li@nxp.com>
Subject: RE: [PATCH net-next] net: fec: Add support for periodic output signal
 of PPS
Thread-Topic: [PATCH net-next] net: fec: Add support for periodic output
 signal of PPS
Thread-Index: AQHY43kQFFe5EDsVvU2Ny+PSCQC3464WjCKAgAAoZLA=
Date:   Thu, 20 Oct 2022 04:38:51 +0000
Message-ID: <DB9PR04MB81065EDD6BCE838E48016C1B882A9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20221019050808.3840206-1-wei.fang@nxp.com>
 <20221019191327.34018fdc@kernel.org>
In-Reply-To: <20221019191327.34018fdc@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DBBPR04MB7819:EE_
x-ms-office365-filtering-correlation-id: fdd4052c-7385-4438-87bc-08dab254fc97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hPe/LbGL5e3dKeyy8UKNWiLFBrGKD6l0yAaQNfjoHy5ODO4EfmfPY2ke1Tf1YMwXALW2Vcxo3T/1CBNG81N+5l6wqfM8Z/BZbjkvuE218CZOrjQz9PjlxIYgQsU3U/p9yqE3qie54n/yrzgA524mlcEloJkfVyKKlDCfuqlNb1eIK4KRx7FrRy+D6cQr7xS41X0hh+TUB0/M/t/8zsujO7Ld9Sme2RkruCO2I2SH4+lxgm/iNT6fdQZtEZEIzI4vKjXwxermSGBMAb26kvpMIgvR8LC1isIlVs0M/rgEIOrxYnGbQ/wChNru7e13FKQwKpgbwNVaDaL16qFHSo2nf185WmNt3uLwH7A4cQ4zvKLLjzj7/us2niTOhrp/cDqil2nBkiHIJFSTg1znSgqmpnseMR0SXx4Cg0N9sBpWk7XCDP2Ui+ktJem96qVJvIBuUrpeeXbbEEs2rbmPdb0FwQf4cLYMNc88NCnbOIdDbHXsC5320GK7kAib42q4zf1pqgLKuMjvF4+SAm/itne/mO20eKRZ2KCVqrodPBSgkakm+i46nKlXz3rr+I8bW3rDP6NvQEWIMkfE5JdCNCBw1oCbOofvd0Uof99lI+7eYUTUqP6aysx8Pyh8YlPjLOAn2xCLyxN5VxAeW2lEOiuuki1FdA/O6lVOmI8i87qSLppixrlwoXPiha0EPq6P/I8aDbngWP87hLZJX+Hixl7rbZSGBGAF9a9FVhxGbaRz+8KpAJaKPSvKKdRJpOav1EAUxBoPPF33BdzSGIvQ9Tkytg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199015)(186003)(2906002)(38100700002)(33656002)(71200400001)(122000001)(38070700005)(478600001)(6916009)(8676002)(66476007)(66446008)(86362001)(66556008)(66946007)(64756008)(4326008)(54906003)(44832011)(76116006)(55016003)(52536014)(8936002)(7696005)(53546011)(6506007)(26005)(83380400001)(41300700001)(9686003)(316002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dFFaSnhZK1NvY0p5eXhxQ2d2bnhNS0paUUFRYWFBbXAzWkwyNlRpaW13ZkdY?=
 =?gb2312?B?b1VzZWw4RlhVRXQ4VFF6TG51S2JnaUEzYTNaOXhIYU1jVGMxSjVJejQzYkts?=
 =?gb2312?B?blY0a3JlREw5bS9vaythUjUvV1Q3UERLU00vTWwzeW9TaWJnOW1ta3JUWkh5?=
 =?gb2312?B?TXo0MmpiKy9xempxL2VOcFhUbVFkWG93T084eGtUc3lGcnBGeGFRYU55OG5l?=
 =?gb2312?B?c0lkWHRtREkrY3NEMEJZaTI4bGRWeno0alZrQWFFM1BEWUxFdWFNNUFjcm9K?=
 =?gb2312?B?OXhJMjhhRFN4WE9aWmlmT0hHc0tya2RQWUR2aThwN3RjR3NmN3N2dXEwbWdK?=
 =?gb2312?B?b2JUekI3ODRsUjIzSEt0czhrZUhmcEd1SFlrUUUzWXU2MmF3aDRkd2N0cmVv?=
 =?gb2312?B?azN3OW9GYldGdERHRGxPMTNWbzVRbEVRK1Y4bCtCcFhxK1ZwUDViS01NMlZS?=
 =?gb2312?B?Wi80ekdVQU9Gc21lWk42UHdCUVdGaWpqUXAvenp2ZXJBZ3d1WE5EVWhhblhI?=
 =?gb2312?B?a2NSQnlKMTF5cTNVaFpGMjlEUGNqTDRXN0pjU0FUd1hzd3BQMUhGYmN3Z0tu?=
 =?gb2312?B?SFFiaHZQYjBNQlZHVUdWZGpwUUsvY0I1VHA1YlFwaVZ5VG1GVXVlcnN0Yzgy?=
 =?gb2312?B?UlJlSkdlMXA0anlMU3BaaHpWbXlVN2VwYWUyL0RuS3BaL0k2RjRyTjNzMXZJ?=
 =?gb2312?B?RkFBVHlTaEFLUzZld1FzUXNuUGVZNk1wRDBqMU13RHVCRXR0NDZCOHFwWmpt?=
 =?gb2312?B?cmE4cW9Tb2VxNkEwbUlLbUZ5V3VHR1gyQytTR0JDMkVoblNJZXpONHphT043?=
 =?gb2312?B?cHl6K1RqakIvTys0UkFpdmVldHdOaTB0M0FHdmY5UVRQeWp6bC9Yc0Zhd2N6?=
 =?gb2312?B?U1dibjVCT0F2NWhQWml4Vlhick56OXBhVU1uMG5JREg4ZUplenZYeXpMSEN2?=
 =?gb2312?B?NkdvS3BmOWo3dmVaY0c3a1Jza1Q3UkxyeDJKUEg0dENDeFA3bjBEYy9GakpO?=
 =?gb2312?B?dEFIMmo1VjZpRXNlMjVwMEhxZUF6TkxLSzI1a3VkM0RvRHhWUm13VnYvZ2xK?=
 =?gb2312?B?Q245aDl0Rnl2WEpLVGxTdVR0SUU3S0NJMjBRL3Z0SXVDbXZzditEQnhIWVRy?=
 =?gb2312?B?Z1dtdkdzV3p1Si9rR25WejJwWU5sdzUyR3p2RUI1MnpVTUQxSThPRnpQQ1oy?=
 =?gb2312?B?K3ZDU21ETzNXRDBKd0hmdzBma3lGQVVDK3FNOEZIYlhvamt3M2JIYzR6cHo4?=
 =?gb2312?B?V0YvQ1Rla1RKckIxRHlVamlKSE5zd3pQcDdPRGRJTjNaUGM5ZzlLQWd4Mndq?=
 =?gb2312?B?amtwT0hKaHRVWkJKa1BiVzZhQ3FDRHozWFBnSU9WUjJZTjFaTHJZK05lRHdX?=
 =?gb2312?B?R2tnU29aNTdWYTFXMit6VFg4SFJBN284NHV3b3hRUFhvSFZ2Z3k4Y1Q2MkpL?=
 =?gb2312?B?akpDOUJqaGZmaitoZ0VoYjd3RGJsSG1yeFJqNHhMUzNzdHRJTUt5WWxEb3hx?=
 =?gb2312?B?UXBFdDNnTGpReDVwYVF1bU1Gb0VFN3NWSFp5OXRmVGpOZ2kwUmxhTjRrQnl5?=
 =?gb2312?B?dXJnSUpXVm9kMVFTbkVjaisxT1RVRWJudTY5bHBKR0pwSmNEWWw5OS9zeVBM?=
 =?gb2312?B?bzhLZkZsU3Njc0xvMXIrVW4zTVB5RmNkM0dFakI2ZUdyNXBoNm1VclcyZmJO?=
 =?gb2312?B?L0F2ZmtFa1RmdlZkSXkwRXFDSWJDSjh2T3QySSsrT2hNL3RMZjJjU0lab25j?=
 =?gb2312?B?UERLRk9WYzY0UU5RMUJwRm1oNklhcmJnY04rVXk5RmtGOUxVUE1ERUJaMjh3?=
 =?gb2312?B?UFZPT3pyakdKN0lkTXo3WkZRSlUrTmw1anhHcE5OZ1dUamlhbUhLWU5sQ2po?=
 =?gb2312?B?UTlJQ0hNbWlxNW1vMnpaUHRwQW0wSEV2R3BweEZBWnR2Y3pzVUdpWUFaSzFD?=
 =?gb2312?B?MG5jeWU5UkNRS3RHa0VyRUZjNEVlVmZIcnc5Uml2MEZzZlZORGZkUnZPTEhi?=
 =?gb2312?B?b1pCaGxZd1NDNGdKdHJtRVNrRERkM1QwR2N2TFRqaHJGWXJaRGNOUDJ3cGZG?=
 =?gb2312?B?WjFuekpCMzdKTEtTNi9zajN4TFBjRC85UFVyZ3VSeGN5VEl4YXBjakN6Myt0?=
 =?gb2312?Q?MB+E=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd4052c-7385-4438-87bc-08dab254fc97
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 04:38:51.0976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XjY+3g7Gq0WlRRZEu6oz/U3b/vngawuT01MGl6NcDWCPrqreT7t1+UWMyI35Z9vQxICRWZ2KEMIqNHN08Ru5lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7819
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjLE6jEw1MIyMMjVIDEwOjEzDQo+IFRvOiBXZWkg
RmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1h
emV0QGdvb2dsZS5jb207IHBhYmVuaUByZWRoYXQuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBGcmFuayBMaQ0KPiA8ZnJhbmsubGlA
bnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBmZWM6IEFkZCBz
dXBwb3J0IGZvciBwZXJpb2RpYyBvdXRwdXQgc2lnbmFsDQo+IG9mIFBQUw0KPiANCj4gT24gV2Vk
LCAxOSBPY3QgMjAyMiAxMzowODowOCArMDgwMCB3ZWkuZmFuZ0BueHAuY29tIHdyb3RlOg0KPiA+
IEZyb206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBh
ZGRzIHRoZSBzdXBwb3J0IGZvciBjb25maWd1cmluZyBwZXJpb2RpYyBvdXRwdXQgc2lnbmFsIG9m
DQo+ID4gUFBTLiBTbyB0aGUgUFBTIGNhbiBiZSBvdXRwdXQgYXQgYSBzcGVjaWZpZWQgdGltZSBh
bmQgcGVyaW9kLg0KPiA+IEZvciBkZXZlbG9wZXJzIG9yIHRlc3RlcnMsIHRoZXkgY2FuIHVzZSB0
aGUgY29tbWFuZCAiZWNobyA8Y2hhbm5lbD4NCj4gPiA8c3RhcnQuc2VjPiA8c3RhcnQubnNlYz4g
PHBlcmlvZC5zZWM+IDxwZXJpb2QuDQo+ID4gbnNlYz4gPiAvc3lzL2NsYXNzL3B0cC9wdHAwL3Bl
cmlvZCIgdG8gc3BlY2lmeSB0aW1lIGFuZA0KPiA+IHBlcmlvZCB0byBvdXRwdXQgUFBTIHNpZ25h
bC4NCj4gPiBOb3RpY2UgdGhhdCwgdGhlIGNoYW5uZWwgY2FuIG9ubHkgYmUgc2V0IHRvIDAuIElu
IGFkZHRpb24sIHRoZSBzdGFydA0KPiA+IHRpbWUgbXVzdCBsYXJnZXIgdGhhbiB0aGUgY3VycmVu
dCBQVFAgY2xvY2sgdGltZS4NCj4gPiBTbyB1c2VycyBjYW4gdXNlIHRoZSBjb21tYW5kICJwaGNf
Y3RsIC9kZXYvcHRwMCAtLSBnZXQiIHRvIGdldCB0aGUNCj4gPiBjdXJyZW50IFBUUCBjbG9jayB0
aW1lIGJlZm9yZS4NCj4gDQo+IFlvdSBuZWVkIHRvIENDIFJpY2hhcmQgQyB0aGUgUFRQIG1haW50
YWluZXIgb24gUFRQLXJlbGF0ZWQgcGF0Y2hlcywgcGxlYXNlDQo+IHJlcG9zdC4NCg0KT2theSwg
dGhhbmtzIQ0K
