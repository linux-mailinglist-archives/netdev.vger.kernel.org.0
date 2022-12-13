Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6A364B0DA
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiLMIMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbiLMIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:12:17 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2085.outbound.protection.outlook.com [40.107.8.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A9016592;
        Tue, 13 Dec 2022 00:12:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSypFZmua9iIzhYvUf5GVgF8in1zbUJq9xMWxA+d1v6WfgAJM2A6HNgvkishriYrK18hE/ZMsvz3+Dc6FY0EOOzJlgWGhpn8O009yDyooyL3/OouKyQh2+eM+Os8sLmpJ3CUEh8UjQ7rMTCep3/WoGAzDJ18XoIKlTikDzg2Hy9pzaxFqOybhJMkMJm/CNCRH0ZdaQViWkN9UfgyxsGp2Oj7Ag9mZ+H3zMUoxKGqOOKGI8IE8zDQxFO+7CyfpbApyQzr1aQpRLaedIMML4sHZbYlqkvqF+l7pS81pRxxS7Fd4mWUTlisay04Fza51FPudS2sXiEs9f9IoAqe0/gLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebtbpeysHpeng/Zi1oSOf1SKtdkJEwVUajIP1Sphn9A=;
 b=fOHXa7GiGN+s37kJzbzSRI/FmiZQ2/EWRo2Xb84/shdT89S0wI9OtuzqlrofuKdj0KPRUvh96bczy1yc2vKvOOF+GwRC0U7EBR9klKn5hpQvsdIfEDdOzWLlJsA8rrgn6W7qV+vzjwL9MG6QtKlEh2l97fNQyW8ouXJCGB8E7MAtQYndcWKqOL4Vd5mxQgHKJx1UYHnHwU6NO+N3Vso28SddoGJdpllH1yp7vP5zlLdvfunkyWvxXPfewg0S2LSsPD3JCNPZvWimkAPyMbKlLiR8G5j02d4702QRaTZKdDgZhxVKMvZaktPESHH7uV7RlnmwBqSt+HeegjrTSDnyRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebtbpeysHpeng/Zi1oSOf1SKtdkJEwVUajIP1Sphn9A=;
 b=cOgJe9EYBe05d4P95G0yrBrkTg1cacAe5q8K4pgzP8zMkCHDnFbarAjNzIX62951jHlWj+NAVA9ehOeVtPQAjwJOeiAcKIfATcc0VvmkNBSo6pau5p9jvCoDgLc85ERg3UUrx9lUdusRM5Kr0pfSFUbcmAKMOYSD5OfcsJ3JBJk=
Received: from PA4PR04MB9640.eurprd04.prod.outlook.com (2603:10a6:102:261::21)
 by AM9PR04MB8292.eurprd04.prod.outlook.com (2603:10a6:20b:3ef::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 13 Dec
 2022 08:12:11 +0000
Received: from PA4PR04MB9640.eurprd04.prod.outlook.com
 ([fe80::cc4:c5c2:db97:1313]) by PA4PR04MB9640.eurprd04.prod.outlook.com
 ([fe80::cc4:c5c2:db97:1313%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 08:12:11 +0000
From:   Jun Li <jun.li@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "bjorn@mork.no" <bjorn@mork.no>,
        Peter Chen <peter.chen@kernel.org>, Marek Vasut <marex@denx.de>
CC:     netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
Subject: RE: imx7: USB modem reset causes modem to not re-connect
Thread-Topic: imx7: USB modem reset causes modem to not re-connect
Thread-Index: AQHZDlUhV+kS2pCWsUGZGAatOM7Zpq5rdqrQ
Date:   Tue, 13 Dec 2022 08:12:11 +0000
Message-ID: <PA4PR04MB9640A6C1E25988292480132889E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
In-Reply-To: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9640:EE_|AM9PR04MB8292:EE_
x-ms-office365-filtering-correlation-id: 3db51290-efd4-4260-79c4-08dadce1bc80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3rsDSxJt9Aa8KEeWyqhmQYOMqOxoug877YKaSuph3UqUJHWSZbyNtWYptwJwszAH9DwEZ/FfLgJrHsj8fhdM0E3GpFMRnLrtDrv3r8XLQLzAG3+uqZBLX3kvs37JXiNjZPV2P0P03MOMAwbzvT3aGzSOp0f2uppbWt5BJnEmTfJ2bQsIh2g89r4QzATjZMf973+BEzsHV4juIIdx4xo3Bw5Ta9jG9lhxPvcb/bnbj6SAjolrU/soL/AqNWWcozETrgkWRAI7SmLazt2NBawzaTg2Bt0SIoxdbW3CRXE7o6HjgaDwfycA5UCK0x6gXd+XZEVeRBhqCbb4ErHJWam6UcnMXL0Pnm4dmB1KVXTp8FJtGT8sf59J00CsqspKaOeiAH8hORQlt5SnRE0yX8kViMHllRwN0n5tQbanIMbTYeYxCFT31o1hWzAgrO/frUYonwGNMMvKdP/OkdoULCesz/NoUPWIwduNjLG501+WvnBvUvIrPi1oYz6gn3gwaVFM23M4Kqb6yAYhn6tgRIvv393wy44Noz8GrJkk28KxNGakGnp/QF9xp6mC7i/yvbuOImDgLSNR4hW7hXQifkkl74KfWLmaGtvzOGx3sEjctr27FR8puOUdE8XrMCdmHFpiiMTzjKsJYhPQGV/Zd6Cn29Xkr/BZF3maHQ2sCAF0IWCi4WTWv6JbY/ln0nLdBCHTg9lSrfiZ5lJEAEQVSi4gQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9640.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199015)(38070700005)(55016003)(86362001)(33656002)(316002)(54906003)(110136005)(478600001)(44832011)(71200400001)(2906002)(8676002)(76116006)(66446008)(64756008)(5660300002)(66556008)(4326008)(66476007)(8936002)(66946007)(52536014)(41300700001)(38100700002)(122000001)(186003)(26005)(9686003)(53546011)(7696005)(6506007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGhhaHJWbm1tZG9Dbi9aNGFGKy8zMWN6dFMxMHZPbVJzYlc5MDJmUDhDQlFm?=
 =?utf-8?B?Z1pFWEkydWdmVlVuaVRVZTExcVJFdFFaRUxseUQyaEJjVFZwakNFc2tVdEp6?=
 =?utf-8?B?S3FMbEg3ZmprTkk3RGJ5cWcvUGVWN0lPVzRIVTFVSFhMUC9Kd25vQU1sUDQ3?=
 =?utf-8?B?RjJsNlpkTHh3VlZ3eHlkYkhrZzJDM3dPZzZLMzZESXFBd3hRYlBjWlpaR1RV?=
 =?utf-8?B?WmV1ZXJUQWp1MzhtdHNESlg1d3lXbEhESldrNEg2M3l0ZmxBeEE4UWErblYw?=
 =?utf-8?B?MjZrVEZPVWFydXFhOUxscnQ3TkV3UTBsWGIzNEs5NGxkaXQvR1hWRzU0VSth?=
 =?utf-8?B?dXBHcE12NFV1NmVVTjJuc2s3eEJHYzM2Z3RwNGJBVG1hYmM1aXZWMjBZU3lM?=
 =?utf-8?B?MlJheklHdU1IQXFhMzljT1RBMWpZSVAvdlJ5U1R1Z01xV2ZEVFJFRkpDc0Fy?=
 =?utf-8?B?enVqSFIzdys1ekxKc21WZWJEZXJpeEovUVY5c3pWS01NL3NXdldoWStNZE4v?=
 =?utf-8?B?Q1BKWnFNZm91VDlWUm40Tlh6YWcwOE9Na3NGZi9SZmRvS3lVM3l3VENBcHVY?=
 =?utf-8?B?cW1CaDlIQmY1Z3g4YkNVaXlpT3dVQlByTmJMa2VwTHBORzhuOXhwaTJKelZ5?=
 =?utf-8?B?Z0tmVzdWMUZlRXR6VVMwTXNQZ2RZRFJmTVhVYXB0WkxHOWI2cGR1eXRRY1BU?=
 =?utf-8?B?cXdDN3d4dmdjQmEza2RuTEZoaE9SRndqdjVqL2txR2RJOU1sQiszRlp3VklW?=
 =?utf-8?B?c1g3TTI2NjBoakJMMmc0a3ZlSWlTS05TZHdndUtwZXJDekFwQTBMNmZ3Mnh4?=
 =?utf-8?B?QjhoWGVQTXB0dHFENkJPM3RyWWxvUE5WTlhrMzdkaWVRc2JqenFIM0lZeUJT?=
 =?utf-8?B?eTJuZklXWDgwNmlaMDNHdmY4ZU5ZYlBPVlB6MGRYWFJyL3o2ZlB2bjZjeVYv?=
 =?utf-8?B?RE00RVdHOFk0Q1JhVUJSVFVDTnc1YUFKTWJLdmF5bitENWRYWjllYnVxdlR6?=
 =?utf-8?B?Q1NWWEYzandJWGd2U2tEaEhXUFJvblBlc3BsWmhabjFoaVJneVN4NW82OSs4?=
 =?utf-8?B?MVRvSWJaOGVnTUJ3SjFHRC9YQ1k5dTk1YWsvQmZsQnNzUGp5aXNuSVlvaGlS?=
 =?utf-8?B?MmNQTEhBd1lsSytTSzc4MDVHcWJFbWpTWUsyVWlralVubkg2QnE2NjV1L2Jq?=
 =?utf-8?B?SzRSRjRSTHQ1alZUUEZnWlZXUGswU1p4NW1IaDI5Z294cXUxNG5DcjRVVktG?=
 =?utf-8?B?eVNKaUJndERKelJZcVJvR3NrMmJzUUh4UDdOUVR4dTZ1YTR2RjFreFMxdXBB?=
 =?utf-8?B?ZC9MRjVETXU0QzNWSVpvZGdnUXdLdWtCSi8vcDJDUHpnSmR5WUduZzkyZlhU?=
 =?utf-8?B?bDlJMlZUQndaejlxdUhGZ3RMS2FuclBpVW8vVEkxNks0Tm8rakFrZUtrZDll?=
 =?utf-8?B?U28rbEs0UmdwN3RmcUpHUUlNOG5RNU9UcDRtTlRidnhBYlJGcVZ0ZEpScnRw?=
 =?utf-8?B?WHZpRnk2NHJtMFQ5QjRZeEg3aDJBbmxyS2k3elROdXkwWTBaVm9JSHU4MW1I?=
 =?utf-8?B?MldacHFZa3FHb0tSQlR5L1I2OGZLa3VsZTVBVVpBNkdDSkhFVkhKZ3dKU1Js?=
 =?utf-8?B?K2NYMnY0TTR4YTBlaUFzRW5IV1pkN0Nrc0JZdk5BOUZoTTg3M1JORlVzVHVk?=
 =?utf-8?B?UFlxekJHRGxENUlhclVORUkweCtzL2dFaThSVnJwTjFHQkZQSGhDdEo2dkV3?=
 =?utf-8?B?eWNvTStnRmkzbkRzdEFzRU1JWWtLWXhwVjZoZFNCSjVtdTFmMXBnQmF0aHJu?=
 =?utf-8?B?UTNLU1VMd1dxbFBNTUhjVjdXWFI2TS9jZGJLanVFbEN5UWZOU0tBUENXRjc5?=
 =?utf-8?B?SnlGRXhUUEVWbXVOdm8zRTNUNFAxS091WjVTTWM2MXQ2Ri9haWNPNmw3Zmt6?=
 =?utf-8?B?aVZtRG04ZlE4bUtUNjB1UUVtOXRRUVNJSmJVUnRRbXp1NjI5WllkUmNrZUps?=
 =?utf-8?B?UExPRkdHckNYR05LMk4wN2RpTDEvNTg1ZjkxMnU0Qjc0UEw1TjZ1eHhRcGg2?=
 =?utf-8?B?cW9oT1BDaGRtWTZ2WVNXU2FYYnB5bFZDZzBWQ2djUk1Ra3NiR1kzcThZbVlY?=
 =?utf-8?Q?A1zk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9640.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db51290-efd4-4260-79c4-08dadce1bc80
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 08:12:11.4166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FUJn23z/SdL7Dze79Pr7/Az1iQ4+VpVi/0Jxi9yhqkNqnZR5OZiI+zvPsBz7LjYS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8292
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmFiaW8gRXN0ZXZhbSA8
ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxMywgMjAyMiAy
OjExIEFNDQo+IFRvOiBiam9ybkBtb3JrLm5vOyBQZXRlciBDaGVuIDxwZXRlci5jaGVuQGtlcm5l
bC5vcmc+OyBNYXJlayBWYXN1dA0KPiA8bWFyZXhAZGVueC5kZT47IEp1biBMaSA8anVuLmxpQG54
cC5jb20+DQo+IENjOiBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBVU0IgbGlzdCA8
bGludXgtdXNiQHZnZXIua2VybmVsLm9yZz47DQo+IEFsZXhhbmRlciBTdGVpbiA8YWxleGFuZGVy
LnN0ZWluQGV3LnRxLWdyb3VwLmNvbT47IFNjaHJlbXBmIEZyaWVkZXINCj4gPGZyaWVkZXIuc2No
cmVtcGZAa29udHJvbi5kZT4NCj4gU3ViamVjdDogaW14NzogVVNCIG1vZGVtIHJlc2V0IGNhdXNl
cyBtb2RlbSB0byBub3QgcmUtY29ubmVjdA0KPiANCj4gSGksDQo+IA0KPiBPbiBhbiBpbXg3ZC1i
YXNlZCBib2FyZCBydW5uaW5nIGtlcm5lbCA1LjEwLjE1OCwgSSBub3RpY2VkIHRoYXQgYQ0KPiBR
dWVjdGVsIEJHOTYgbW9kZW0gaXMgZ29uZSBhZnRlciBzZW5kaW5nIGEgcmVzZXQgY29tbWFuZCB2
aWEgQVQ6DQo+IA0KPiAjIG1pY3JvY29tIC9kZXYvdHR5VVNCMw0KPiA+QVQrQ0ZVTj0xLDENCj4g
T0sNCj4gIHVzYiAyLTE6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDYNCj4gb3B0aW9u
MSB0dHlVU0IwOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIG5vdyBkaXNjb25uZWN0ZWQg
ZnJvbSB0dHlVU0IwDQo+IG9wdGlvbiAyLTE6MS4wOiBkZXZpY2UgZGlzY29ubmVjdGVkDQo+IG9w
dGlvbjEgdHR5VVNCMTogR1NNIG1vZGVtICgxLXBvcnQpIGNvbnZlcnRlciBub3cgZGlzY29ubmVj
dGVkIGZyb20gdHR5VVNCMQ0KPiBvcHRpb24gMi0xOjEuMTogZGV2aWNlIGRpc2Nvbm5lY3RlZA0K
PiBvcHRpb24xIHR0eVVTQjI6IEdTTSBtb2RlbSAoMS1wb3J0KSBjb252ZXJ0ZXIgbm93IGRpc2Nv
bm5lY3RlZCBmcm9tIHR0eVVTQjINCj4gb3B0aW9uIDItMToxLjI6IGRldmljZSBkaXNjb25uZWN0
ZWQNCj4gb3B0aW9uMSB0dHlVU0IzOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIG5vdyBk
aXNjb25uZWN0ZWQgZnJvbSB0dHlVU0IzDQo+IG9wdGlvbiAyLTE6MS4zOiBkZXZpY2UgZGlzY29u
bmVjdGVkDQo+IHFtaV93d2FuIDItMToxLjQgd3dhbjA6IHVucmVnaXN0ZXIgJ3FtaV93d2FuJyB1
c2ItY2lfaGRyYy4xLTEsIFdXQU4vUU1JDQo+IGRldmljZQ0KPiANCj4gIyBsc3VzYg0KPiBCdXMg
MDAyIERldmljZSAwMDE6IElEIDFkNmI6MDAwMiBMaW51eCBGb3VuZGF0aW9uIDIuMCByb290IGh1
Yg0KPiBCdXMgMDAxIERldmljZSAwMDE6IElEIDFkNmI6MDAwMiBMaW51eCBGb3VuZGF0aW9uIDIu
MCByb290IGh1Yg0KPiANCj4gVGhlIFVTQiBtb2RlbSBpcyBnb25lLg0KPiANCj4gRm9yY2luZyBh
biAnZWNobyBvbicgdG8gcG93ZXIvY29udHJvbCBtYWtlcyB0aGUgVVNCIG1vZGVtIHJlYXBwZWFy
Og0KPiANCj4gIyBlY2hvICdvbicgPiAvc3lzL2J1cy91c2IvZGV2aWNlcy91c2IyL3Bvd2VyL2Nv
bnRyb2wNCj4gdXNiIDItMTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgNyB1c2lu
ZyBjaV9oZHJjDQo+ICB1c2IgMi0xOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MmM3
YywgaWRQcm9kdWN0PTAyOTYsIGJjZERldmljZT0NCj4gMC4wMA0KPiAgdXNiIDItMTogTmV3IFVT
QiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTQNCj4gdXNi
IDItMTogUHJvZHVjdDogUXVhbGNvbW0gQ0RNQSBUZWNobm9sb2dpZXMgTVNNDQo+ICB1c2IgMi0x
OiBNYW51ZmFjdHVyZXI6IFF1YWxjb21tLCBJbmNvcnBvcmF0ZWQNCj4gdXNiIDItMTogU2VyaWFs
TnVtYmVyOiA3ZDE1NjNjMQ0KPiBvcHRpb24gMi0xOjEuMDogR1NNIG1vZGVtICgxLXBvcnQpIGNv
bnZlcnRlciBkZXRlY3RlZA0KPiB1c2IgMi0xOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVy
IG5vdyBhdHRhY2hlZCB0byB0dHlVU0IwDQo+ICBvcHRpb24gMi0xOjEuMTogR1NNIG1vZGVtICgx
LXBvcnQpIGNvbnZlcnRlciBkZXRlY3RlZA0KPiB1c2IgMi0xOiBHU00gbW9kZW0gKDEtcG9ydCkg
Y29udmVydGVyIG5vdyBhdHRhY2hlZCB0byB0dHlVU0IxDQo+IG9wdGlvbiAyLTE6MS4yOiBHU00g
bW9kZW0gKDEtcG9ydCkgY29udmVydGVyIGRldGVjdGVkDQo+ICB1c2IgMi0xOiBHU00gbW9kZW0g
KDEtcG9ydCkgY29udmVydGVyIG5vdyBhdHRhY2hlZCB0byB0dHlVU0IyDQo+IG9wdGlvbiAyLTE6
MS4zOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIGRldGVjdGVkDQo+IHVzYiAyLTE6IEdT
TSBtb2RlbSAoMS1wb3J0KSBjb252ZXJ0ZXIgbm93IGF0dGFjaGVkIHRvIHR0eVVTQjMNCj4gcW1p
X3d3YW4gMi0xOjEuNDogY2RjLXdkbTA6IFVTQiBXRE0gZGV2aWNlDQo+IHFtaV93d2FuIDItMTox
LjQgd3dhbjA6IHJlZ2lzdGVyICdxbWlfd3dhbicgYXQgdXNiLWNpX2hkcmMuMS0xLA0KPiBXV0FO
L1FNSSBkZXZpY2UsIDEyOmJjOjhjOnp6Onl5Onh4DQo+IA0KPiAjIGxzdXNiDQo+IEJ1cyAwMDIg
RGV2aWNlIDAwNzogSUQgMmM3YzowMjk2IFF1ZWN0ZWwgV2lyZWxlc3MgU29sdXRpb25zIENvLiwg
THRkLg0KPiBCRzk2IENBVC1NMS9OQi1Jb1QgbW9kZW0NCj4gQnVzIDAwMiBEZXZpY2UgMDAxOiBJ
RCAxZDZiOjAwMDIgTGludXggRm91bmRhdGlvbiAyLjAgcm9vdCBodWINCj4gQnVzIDAwMSBEZXZp
Y2UgMDAxOiBJRCAxZDZiOjAwMDIgTGludXggRm91bmRhdGlvbiAyLjAgcm9vdCBodWINCj4gDQo+
IFNlbmRpbmcgdGhlIEFUIHJlc2V0IGNvbW1hbmQgYWZ0ZXJ3YXJkIHdvcmtzIGZpbmUsIGFuZCB0
aGUgbW9kZW0ga2VlcHMNCj4gY29ubmVjdGVkLg0KDQpPbiB0aGlzIHRyeSwgaXMgdGhlIG1vZGVt
ICJmaXJzdGx5IGRpc2Nvbm5lY3QgYW5kIHRoZW4gY29ubmVjdCIgb3INCml0ICJrZWVwcyBjb25u
ZWN0cyBiZWZvcmUgYW5kIGFmdGVyIiB5b3Ugc2VuZGluZyB0aGUgQVQgcmVzZXQgY29tbWFuZD8N
Cg0KRnJvbSB5b3VyIG5leHQgZW1haWwsIEkgYW0gc2VlaW5nIGl0J3MgYSAiZmlyc3RseSBkaXNj
b25uZWN0IGFuZCB0aGVuIGNvbm5lY3QiDQppbiB0aGF0IHRyeSwgSSB3YW50IHRvIHVuZGVyc3Rh
bmQgd2hhdCdzIHRoZSBtb2RlbSBiZWhhdmlvciBvZiBBVCByZXNldA0KY29tbWFuZCwgYm90aCBv
biBTVyhob3N0IGRyaXZlciwgZm9yY2UgYSBkaXNjb25uZWN0PykgYW5kIEhXKG1vZGVtIHNpZGUs
DQppdCBhY3R1YWxseSBwaHlzaWNhbGx5IGRpc2Nvbm5lY3QgYW5kIHRoZW4gY29ubmVjdD8pLg0K
DQpMaSBKdW4NCg0KPiANCj4gUHJldmlvdXNseSwgdGhpcyBib2FyZCB1c2VkIGEgdmVuZG9yLWJh
c2VkIDQuMTQga2VybmVsIGFuZCBzdWNoIGENCj4gcHJvYmxlbSBkaWQgbm90IGhhcHBlbi4NCj4g
DQo+IEtlcm5lbHMgNS4xMCBhbmQgNC4xNCBoYXZlIHRoZSBzYW1lICdhdXRvJyBvcHRpb24gc2Vs
ZWN0ZWQgYnkgZGVmYXVsdC4NCj4gDQo+IEFsc28gdGVzdGVkIGtlcm5lbCA2LjEgYW5kIGl0IGJl
aGF2ZXMgdGhlIHNhbWUgYXMgNS4xMC4xNTguDQo+IA0KPiBXaGF0IGNhbiBiZSBkb25lIHNvIHRo
YXQgdGhlIHJlc2V0IG1vZGVtIGNvbW1hbmQgZG9lcyBub3QgY2F1c2UgdGhlDQo+IG1vZGVtIHRv
IGRpc2FwcGVhciBieSBkZWZhdWx0Pw0KPiANCj4gVGhhbmtzLA0KPiANCj4gRmFiaW8gRXN0ZXZh
bQ0K
