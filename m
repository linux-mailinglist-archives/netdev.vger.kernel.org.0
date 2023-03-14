Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210386B8826
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 03:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCNCMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 22:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCNCMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 22:12:33 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644CF8C832;
        Mon, 13 Mar 2023 19:12:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z13WtmqvXtIryLu5PosTOv8L1QaeqsTe1OOQc3ncKEGeepMLSalCfKH5uCuWqDoX4MZSB7CkFBlJSlrBPgc32/MZAw7iTQ8uEWLWZe7SWPWBsLanZHUnJ88EC5/1YKr2kKqCtpSsy24KY9l0W2KnKmLPOmYy5pqETMxaYoVW4g9hZnMRsNDTtInz2qM5nZj8qdbFXRXdYZKZrM9XbQHwxYD4hCZvfXrVX0TrGk86JkoS34DSXWL8AS7vatdwYci3t09XRSjP+Xv1gnDXVyhErvfxV6Fn1dvvadlpPbp/4PQ0KxuYWZ8qLjHpJRwDIfgm0zZgBpcHvAQgCkucVIqOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dkb6VVazSb6Mc2oHNe3AMZCcBbowLMz994dCJ7nCq8=;
 b=ehcueoZVjjI5D2A7kSEpHhZQ9oVq2E+FmEpSUefcZIKzwVe9Y0GvXDkWgFSnTjd6t1MDuyTTEPqRyxvK2jRCYATfhAduW3O7l63uJT8G/h3W5fLgzOG+w40i4agRWAlzac7RApHYWKotjfckDxsUhlQit4mKEA4qOF7Oodm3T616hbJdtzTGTw5U8V9M9jrKE85s5TRR3SVowmhwtbG6KATXnJ4oXLtdJDZlndiopRioRMhLed4jVcvWiZ7IXLmIJ5g2wRetaecpzbDq9Nqr41foZNYoFAPNGoTgJ/y9AiSAjBXSZ+g0DY7SYhXVIcnqAtl3HyXbTKY1Y4B2OjOwuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dkb6VVazSb6Mc2oHNe3AMZCcBbowLMz994dCJ7nCq8=;
 b=clYGY6UG/fcUhzoU7b0yDO6d1mzNUYZBUA2nbLcAFfaNczOjK7P+AFdmDZ3idBQ0of92dBWk6qHYlCth+IUDZD2bIfIk29sbY8gBhJOAW87/wZHFyGwmBCMcV45BbIdb4Y7v5GiqN+2hEiKTw+0gU69YmPJUmdxv5ZHPqZ+cS5I=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM7PR04MB6920.eurprd04.prod.outlook.com (2603:10a6:20b:101::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 02:12:25 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::7f2:8bc6:24d8:bb9a]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::7f2:8bc6:24d8:bb9a%8]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 02:12:25 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Qiang Zhao <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] net: Use of_property_read_bool() for boolean properties
Thread-Topic: [PATCH] net: Use of_property_read_bool() for boolean properties
Thread-Index: AQHZU19tQbLpti0xJk2NKV+pnLw91a75jQ4A
Date:   Tue, 14 Mar 2023 02:12:25 +0000
Message-ID: <DB9PR04MB81066B40588B750F1A79906F88BE9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230310144718.1544169-1-robh@kernel.org>
In-Reply-To: <20230310144718.1544169-1-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|AM7PR04MB6920:EE_
x-ms-office365-filtering-correlation-id: 974d5643-46a2-4da1-637f-08db24318da5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OPcw/Oy+rL2FBkPNpOlUTXKn31N6xK+LTYxOaPkKK14SwFexAMl+t2CfybStSTMDKMY+lEpf1mzLnw+1MfTVT1N+sY30d4YWTn5Ncs1eB7Qhsj3xc23eWiKVZ2YCnt0iPjCxXFt4iBkP8US660URacfsjxDWuf478t4r7+heg6zgjlqQ1J4PGjS5ygTxivAxRAYV2Iyj9Cs3vcXeFTkDq1gd4WSLyYwBZSUXJs1Xf2X8bdIRgNc1YmhoTBe4R5CoB9Fi01kbir+8KPpJRzbZUX4cNEAOflVyCfrbEQRNbk3Aj+dixWUU4uIET5k93EvSL1LppcJFTDVSTz1CPdKP0aeXpm4E6BIpoY59FaJ48mAZp0zVMR8PePQH1I4ccRqrIawPgGknivu+l/55Oxghou7Y80hOmp0IFL33+wA0NbsZM4ujlU4oMXbBS9I9a/5Rbe7ACXWtPhrtaNL/ZMIA4Qqda7aArtuPr24zLcijk8E+0LdNQVYMkzhJrIVPIcfrE/tYUGePKigp78HIJ6Ix09L18XHRvpHPwycjePPMb85RS1u3Tz0ImSB/1AN44gLXzLbY8pTpGgNx8UKZOgdGbSpbME8bACWW9W2M2SSg6h+Gqzlpz2iglcD9dTEsBInQkKGFa1LdL9dP8mGAqyEOXUsXsRp5CPsKfCV1XRva/v/UJbTI+a7N9GS7gA2T7+F0xC1jchzKUtz/ueNyl/zGz32cYTFDSOGa3jUJJus3RU0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199018)(7696005)(83380400001)(110136005)(316002)(38100700002)(478600001)(122000001)(54906003)(33656002)(52536014)(186003)(71200400001)(6506007)(921005)(44832011)(53546011)(9686003)(5660300002)(26005)(86362001)(7406005)(64756008)(66476007)(4326008)(8676002)(66556008)(66446008)(8936002)(7416002)(76116006)(66946007)(55016003)(41300700001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Qm5FdklueUNKeG5Pbi9jbzN3c3ZqdmpoaEZ1emIzY1dvN2c2TW9uZnNyNUsr?=
 =?gb2312?B?K0Iwb0RkYWVmMjhyNHlGMHg1SjNIMjZLTUJLQm0vNVdoSkJzdFRNYmlhVURR?=
 =?gb2312?B?d2Fwd2ZGVGhlS1BVdUxmbk0walA5R1BGZDhZNHF6ZGVEdWFEWm9GbDVmaXNG?=
 =?gb2312?B?aHJMdnVpbXZWTG1ncEZzcEttREZQWGdodldGUlMwbEpacWRkVTRaUjFQRnNy?=
 =?gb2312?B?VFY0aUVMdnBIS0k0bWRTNS9hZG1kTzd0a1AvaEJCLzQ3Ny9WelNKeVREbGlo?=
 =?gb2312?B?eGJPaUtWZlNWQTRsY0tnN1lnSk5vVFZldUxxZjMwSHdBNkZNU1AvRzZxeWl6?=
 =?gb2312?B?L29QdHRHeVF5QVVoWi9oTUVtaVRUNTJYZWs5Wm5BZ2xLdG9NSjdRYUpzclB6?=
 =?gb2312?B?bmk4cWc5clNiOUpMdzd6T2NTbWFBTzVLWEMzNGFFcTVaVk5ENkdESGR1N1lR?=
 =?gb2312?B?ZVdoSVB1OW9yUlAyVlVjb1N1MTdYTnZsd3dMa3BpOEFka3pwSXE0Y0lMak1B?=
 =?gb2312?B?d1pNNDZ5RFl2bEhNZUgrNnFhT0w2STZjVDc0UDcrbFNRNWlIQ3MrZzl6ZDRX?=
 =?gb2312?B?MmZoOXV1WVpLYmloMWNyeGNBTzgydlBmWE5KUUd6MXhwWjM3cFdtUkw4S0o1?=
 =?gb2312?B?anV4YVp4UW5jRGdqNDdGUzBkQkRNUy9JUm0wQjZaZ0FrbDh5Qm5yNnVPRk9h?=
 =?gb2312?B?RnBNT2V3WVk4Q2todmQyamV6VmZoVm9pVFNvMFUrTk5lcXpDQU81RDk0UGwz?=
 =?gb2312?B?aEJXckZKMXc4Z3NYd3JrSnQwOWkvZE40MFZ1WEtiNnkyNmdNUm1WNkhvQTJ0?=
 =?gb2312?B?YWV2Sk9HZXphMldteUp1SzZIZ1hSTXRpZTdvZDFjQklTVjZjeDBlQmM2SXZ2?=
 =?gb2312?B?YlczOGc0R1V4NkJmTEdxTEZjeHRxalk3WjlJSktCOHhwSDV4c1pvZmh2QnlT?=
 =?gb2312?B?UGl3RitWUG8zUFlwV3cvdHUrbDB6QkVtUWVYQXhYYXJNekJycmxsb0lJMEJk?=
 =?gb2312?B?eHRUMGFySGY5TUNKeTFxYmZZbUdBR0tNS2NVaXA2OUZNYVNJMTcrM0FMeVFK?=
 =?gb2312?B?ZTZqMlFYTHFqVmNXZ3NVNm5QNjlXUkxzRmgvVTVnZ1cvOTFQMFhQbzJCNjQ0?=
 =?gb2312?B?UDVpenV3UUpJb0cvMDZSRnVFSy8zbXZRbGpUZzBRRm5XaHdvVW8zbjdKdWVi?=
 =?gb2312?B?ZWprV08xdHpPWngwTUJjT0NRV2U0RTF4cW5sYXVQR0pvTmtSNVRLUENWT3ho?=
 =?gb2312?B?N2Vma2ZIM2w4NTkrcU9Oc2NKLzAvWmRFc0p6OWhBWUJqZktiUjZoOUdjTlRn?=
 =?gb2312?B?b1FZQjkzQTlGejgyQUgzL3lwakxFZHhQWjZxbnF5bElXTHpVTEJhVDBPTUla?=
 =?gb2312?B?S3kzY0JwNlU3QjhJd3UyY0c2UVNCWVlUa1h2L0dkNzZXNTFwWjFqclJPdFVk?=
 =?gb2312?B?anhWNmV1UG5adUlwT3A0bGFHdWxKSTg2eVBOT2dJT0t6MStsUFI4N1pQa2J5?=
 =?gb2312?B?bGEvdWJoTGJmV0hUcXRRQ09JLzhzeUR4VTBXQUM3WHU2dCtScytQYWw4eDdh?=
 =?gb2312?B?UytGUE1jUjFwYVhJYjJXQ3BLVjA3SUtvV0xhUlpEQzFzR3UrZWE2bThzZzZP?=
 =?gb2312?B?N2taaG8vYWZycW9SaVM2MDkzUytsZnoxRkh5OG8vMjZPa280UnBCdERNVHdj?=
 =?gb2312?B?QW9TZlVOVjdEdi9vOWsxaDZ1MUozSUtHQ2xWZ0tqenJ1Nk5mWUN1enRZZDdB?=
 =?gb2312?B?N1ZTNmFzeG9LQ2c1THV2TnNBQ0t6UGlQSGhiM0ZkaFd6emtPNXlkeVpZekp2?=
 =?gb2312?B?bk1SdHJOR2VWYlhub0pMT2xEaVRkV1cyc0RSbVNTT01kTnh4VUFmZFh3Vnhu?=
 =?gb2312?B?UTB6N1Uyby9zN0RXYUdtUjFhVklGQ0o1Q2hVSWRncjRNTE4rK2tVK09uNzUy?=
 =?gb2312?B?VE9HWjVuRTgwdlNWTnRuRGRmUjNUZm9VanNGWlNBYW81amM1Vm9FNjdZSHVX?=
 =?gb2312?B?OWVLai8rQnZNOFlNdTNKZm1lZjRCK2VhbHlkN09ndEtRakYxM09MK3BHdE5s?=
 =?gb2312?B?RmZzNktESUpXbjRCOUVVSVc4NCtwNWVOY08wTzN0cUVpUks0OE5HOTlia3hS?=
 =?gb2312?Q?BGMI=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974d5643-46a2-4da1-637f-08db24318da5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 02:12:25.1167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bx3evN7cXvcOyin/GvekK2dmt8SobOPe6fOJ+B0c28jN6k64WqufXSe9EorjYfOg+eAGNBq5Apv7l5+Jk0h3/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6920
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb2IgSGVycmluZyA8cm9iaEBr
ZXJuZWwub3JnPg0KPiBTZW50OiAyMDIzxOoz1MIxMMjVIDIyOjQ3DQo+IFRvOiBXb2xmZ2FuZyBH
cmFuZGVnZ2VyIDx3Z0BncmFuZGVnZ2VyLmNvbT47IE1hcmMgS2xlaW5lLUJ1ZGRlDQo+IDxta2xA
cGVuZ3V0cm9uaXguZGU+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBF
cmljDQo+IER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsgUGFvbG8NCj4gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgTmljb2xh
cyBGZXJyZSA8bmljb2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tPjsNCj4gQ2xhdWRpdSBCZXpuZWEg
PGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+OyBXZWkgRmFuZw0KPiA8d2VpLmZhbmdAbnhw
LmNvbT47IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+OyBDbGFyayBXYW5nDQo+
IDx4aWFvbmluZy53YW5nQG54cC5jb20+OyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29t
PjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBHaXVzZXBwZSBD
YXZhbGxhcm8NCj4gPHBlcHBlLmNhdmFsbGFyb0BzdC5jb20+OyBBbGV4YW5kcmUgVG9yZ3VlIDxh
bGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tPjsNCj4gSm9zZSBBYnJldSA8am9hYnJldUBzeW5v
cHN5cy5jb20+OyBTaGF3biBHdW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+Ow0KPiBTYXNjaGEgSGF1
ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU+OyBQZW5ndXRyb25peCBLZXJuZWwgVGVhbQ0KPiA8
a2VybmVsQHBlbmd1dHJvbml4LmRlPjsgRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29t
PjsgTWF4aW1lDQo+IENvcXVlbGluIDxtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tPjsgR3J5Z29y
aWkgU3RyYXNoa28NCj4gPGdyeWdvcmlpLnN0cmFzaGtvQHRpLmNvbT47IEZyYW5jb2lzIFJvbWll
dSA8cm9taWV1QGZyLnpvcmVpbC5jb20+OyBNaWNoYWwNCj4gU2ltZWsgPG1pY2hhbC5zaW1la0B4
aWxpbnguY29tPjsgUWlhbmcgWmhhbyA8cWlhbmcuemhhb0BueHAuY29tPjsgS2FsbGUNCj4gVmFs
byA8a3ZhbG9Aa2VybmVsLm9yZz47IFNhbXVlbCBNZW5kb3phLUpvbmFzIDxzYW1AbWVuZG96YWpv
bmFzLmNvbT4NCj4gQ2M6IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOw0KPiBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29t
Ow0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LW9tYXBAdmdl
ci5rZXJuZWwub3JnOw0KPiBsaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZzsgbGludXgtd2ly
ZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSF0gbmV0OiBVc2Ugb2ZfcHJv
cGVydHlfcmVhZF9ib29sKCkgZm9yIGJvb2xlYW4gcHJvcGVydGllcw0KPiANCj4gSXQgaXMgcHJl
ZmVycmVkIHRvIHVzZSB0eXBlZCBwcm9wZXJ0eSBhY2Nlc3MgZnVuY3Rpb25zIChpLmUuDQo+IG9m
X3Byb3BlcnR5X3JlYWRfPHR5cGU+IGZ1bmN0aW9ucykgcmF0aGVyIHRoYW4gbG93LWxldmVsDQo+
IG9mX2dldF9wcm9wZXJ0eS9vZl9maW5kX3Byb3BlcnR5IGZ1bmN0aW9ucyBmb3IgcmVhZGluZyBw
cm9wZXJ0aWVzLg0KPiBDb252ZXJ0IHJlYWRpbmcgYm9vbGVhbiBwcm9wZXJ0aWVzIHRvIHRvIG9m
X3Byb3BlcnR5X3JlYWRfYm9vbCgpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUm9iIEhlcnJpbmcg
PHJvYmhAa2VybmVsLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZmVjX21haW4uYyAgICAgICB8ICAyICstDQoNClJldmlld2VkLWJ5OiBXZWkgRmFuZyA8d2Vp
LmZhbmdAbnhwLmNvbT4NCg0KDQo=
