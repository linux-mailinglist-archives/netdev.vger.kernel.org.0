Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB06E64B3F9
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiLMLRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiLMLRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:17:47 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053E410C8;
        Tue, 13 Dec 2022 03:17:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjZUVCKka+I1MvBAIf7CY/PdKifuZ9uQzTckO0hnYcfdkrC+lhybt+RSMnjYbuKYVQwaPoM4+QyKOyhW5ez02cJpM7TVg1yufcSO3lL2OZYKkae/v35JufyMERxp1WCQIXcPcNu+3xv4jvMB2pBbffdSNeCGaOUEN1fMejHlfrE2FWMNPEQdkCYws5fQC8I8bLBEwMtPSg+zljzCzQnPNaDms4s2F5PXkavvY/EGWtKgpqrO4faKnw12bnOFrDnSKN67a8010zZfdYB7iJVo2xfuUjglez5+ak55pCG4Pk3I7rbzKR5lSDbIitFE/fcYKUaPasgKD6P1S5xSAZbauA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yz2YgNzgrCMgPqnBQ5rYvWtPSxtyapZbH4bwpIvdyWg=;
 b=CoBQ8dKk2Ksht0QCyf96QQhdrDc8dC5gRKYM0gXSdynXTWyopQkcMWgdMQ8IPGPP7KPGNc46SnOCyzsVF8j6kXAXhmbmstd2hovyVT5PSRIDMCKAtNZ1Q7rgaAyiP9AtlMko78ijpG6ak97yUcEKGrpOEOY0aRPVUzLElrEfX/tT9EfpnXjMl6PhzVb/k0zL6pbXbtI4OHgY61grqLPhEZ0zPRmF+AfCSOJhffr+pQAqt61TMRdgSr4gLUEfuRBVpph7UsALYIO2Sqq8jFumFYCoHd7j6l3lcvaLuTZYiXehWZO8kynJMg07PnjCfzZsctHFLU1pDmvyARsJssF87g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yz2YgNzgrCMgPqnBQ5rYvWtPSxtyapZbH4bwpIvdyWg=;
 b=sFKh8UTjUtHINlbi3ZrxRyM39NkYXIt3LOtisS8KwXY3VEx1FoEEtF2B/buLiLulMJIT6hwMwAr/A2swUh86Mdw5Hq1FjEYMNeT0BoIlLEdSxsPEjNgscP9GArTjD4WspDCehZBQ947yL5sE53ovnA64GKFVe8wRiOnA6WTVXKo=
Received: from PA4PR04MB9640.eurprd04.prod.outlook.com (2603:10a6:102:261::21)
 by AM7PR04MB7192.eurprd04.prod.outlook.com (2603:10a6:20b:11e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 13 Dec
 2022 11:17:41 +0000
Received: from PA4PR04MB9640.eurprd04.prod.outlook.com
 ([fe80::cc4:c5c2:db97:1313]) by PA4PR04MB9640.eurprd04.prod.outlook.com
 ([fe80::cc4:c5c2:db97:1313%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 11:17:41 +0000
From:   Jun Li <jun.li@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "bjorn@mork.no" <bjorn@mork.no>,
        Peter Chen <peter.chen@kernel.org>,
        Marek Vasut <marex@denx.de>, netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
Subject: RE: imx7: USB modem reset causes modem to not re-connect
Thread-Topic: imx7: USB modem reset causes modem to not re-connect
Thread-Index: AQHZDlUhV+kS2pCWsUGZGAatOM7Zpq5qm5mAgADc97CAABawgIAAG2RA
Date:   Tue, 13 Dec 2022 11:17:41 +0000
Message-ID: <PA4PR04MB9640B1C33E8D5704885A9A3B89E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
 <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
 <PA4PR04MB96407AC656705A79BF72D2E089E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
 <CAOMZO5AMy_H-zw1phB6MtNdpbCwtXg74BwHrs5YttykN=-wvnQ@mail.gmail.com>
In-Reply-To: <CAOMZO5AMy_H-zw1phB6MtNdpbCwtXg74BwHrs5YttykN=-wvnQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9640:EE_|AM7PR04MB7192:EE_
x-ms-office365-filtering-correlation-id: 31ef87e0-c95e-46d3-5b25-08dadcfba68a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: op9mS9mo3okVSKd4VEW3qSWZh2jiGYqovnDvGZ/YTCOfPX8nkrw8QBuhgZcBHhCuaUvGKvzZOIYWnhACqqmriPP9txYgqs8fYUxv5kV//zX0mTPx8pWtUAjHRlA0AFjyO8aW8TbfbTYtDm00MsKM0x4ujJSFwWULp3NLKjfNBMx5UPqMEtsFyNjOVrr5v1y/kai8PbWDOoJyWoPR5pi/ES1zg+8WPsmNt7F/7G6Ia8hxSzTfbJh5p+lMEpFlM+0dmIKa3fp38gh0WA8JFHINmxIxGKhSNKRU6lYjGGIWsng7UrS6BZZEViDmPLDxVkFrehGcVRI+tm+QBC9lXqXS6nIPyjNRTPVF7NS9uOBE19zTVjPxRKnjL3ljZK2PrbZMzpBBE4JhQ1Yv5YpDgeDcRbRZb4zmGgJQ178IB0rMi8mFqeZpnOZalp2Ue8esMSXhew8LzsnzOwGhux6Dv9skXvdWgUSSJlx0b7UYoOnPeGwpl3tmjTqLIQodGa53lo1b7ZIJuTXkMVaUzZ7yUftVMrP1CFu+5p3O2tCJffE5Tey/EhElnga3fryhHQ5qqDA09UV6mkOkbUQWaVkwdBjG3TmNqL09w/H/kDA6CyqebvCi63sOc1Eiw0BF1d6bsz1oE6g0lHhOCdtUSe6fcuJZ2FkxFCY2ALXZGLXcOcDAyKJswr5uJaee/AJ6MDh158DZgwj1y6qt8NU7L7+e+w/whw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9640.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199015)(33656002)(54906003)(6916009)(316002)(4326008)(8676002)(38070700005)(41300700001)(66556008)(76116006)(66476007)(66446008)(66946007)(64756008)(83380400001)(38100700002)(122000001)(86362001)(55016003)(7696005)(6506007)(71200400001)(52536014)(5660300002)(44832011)(2906002)(8936002)(26005)(186003)(478600001)(53546011)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0Z0RmYxdUJzSjA3TEVrQW5JeXVoVFdlYlVjVU8raDZNa1h0SENhNWREY3pF?=
 =?utf-8?B?UjJSS0RVU3EzTThmc2JUdk5ZbnhKa0Q4MG1PdkJhOHhBWC9qNkUvWVNjK2xr?=
 =?utf-8?B?SUtGTDZtMjFyS2hvMFl4dCsxM2dwa01DWWIyR1JFN3F4SkJ3dTZCeXMxcXVN?=
 =?utf-8?B?clh4ZWxjdWVRRUFmOWNOdHpJRzNTTCtLWVg5c0I2OVRiNkIrRFpMbTA3VElD?=
 =?utf-8?B?VlRYbjduQnd6b252ZnlyaVlGTjZJeEJVMVFHWTc1cEtVZnY3MHhNZG5ONHBl?=
 =?utf-8?B?Yy9iVkwzRTNlWUF0TGtIU3ZIeXRRVTJ4VzdRZzN0TGZOS0tGdmU5cCt1c0hn?=
 =?utf-8?B?bmFGY0U0SmRJNHpKb2R6UEIwQmIvT1hmUzZGQ1dCbGdDUU40TDl5WXNXWUVr?=
 =?utf-8?B?TkorNWR3YVNHMndyamV2MEtwT0FHZ21YSjZYUDFvMUVxQ0ppdXlnMFhjSEV6?=
 =?utf-8?B?V0UvbWxaMC9KdHdOWnp4T2pXYzczc2V3SThuUCtYRDZ1UVRTRUtJR2RmZXhG?=
 =?utf-8?B?MnZaTHpPRVNnWXhkZjJVZnBjQ3pQRUhBSUk5dVZCSDZCeVRZeHp3Y2MxdFFS?=
 =?utf-8?B?b0MxSTV1eUVYNjBVZGYvZ2lraHEzVEtMZUJ3Mms1VHZGQUZJUGtUMzBaWC9I?=
 =?utf-8?B?Y2NJdVNQNkpGRjkwWm95dWgwMTl3aUlWdThKUG5NUzlpL1RuUGZEYkhVQ0Y4?=
 =?utf-8?B?NHorN1hsTXlPUFk2Z1F0UGwvTWpNWFZSeGJUTThEZG5ZOE5JaGNCQktZTjBL?=
 =?utf-8?B?UnNHaW5LbE4rVDQvRW1TY0NyczhGazJGUUZxclkvczRodGZYT2lJcmlzbDJG?=
 =?utf-8?B?VFdpeXBlYkhJR0xQakFOQzRjdWZoTC9Ia2pLd3ZNYTRnWU8xalRNREJ6dXo0?=
 =?utf-8?B?QWV3b2VjRHNBV2k3VzBYbGlCU0ZPOU5TazJTSWpQeHNlREIyRCtrNlR3b25E?=
 =?utf-8?B?eXdjU213UlNFM0xzdVJNT1h3OGk3ZUM3U01rajBmN1VoTVFNbWd0MnY2WTNT?=
 =?utf-8?B?Z1NZZEZxUmh4UWpqZjQ3b2FMVXRRc3kwVm1mYXV6N2tZTlRreGw2dHB1ZGFU?=
 =?utf-8?B?YnJadnBkRWtReU0razhYaTZoQW9seTVwRy9Mb2RRYjJieHNkQzN3dldyQzR3?=
 =?utf-8?B?YS92MkFSanpucWNIOFdNNlR5ODR5blhTSXJTMTF4RVltOGhTaGt5dUxXZjJZ?=
 =?utf-8?B?ZU8yckxwdTVqZHREb0xGWW15Szl4ZkFJYzl2Mm5nSyt6MEkyd3dXS1lSbVJE?=
 =?utf-8?B?eHZ1UTdDMEs1alJPNHd6MzQwSTcycEhsbzV3c3BKZENiNHZOYzEzUFp1byty?=
 =?utf-8?B?MFo0VUUyWXFTeTMvSVV2ajl6NTd0bUxzOUlMUjRDWVVJdW8wTkpkcnZOY2ZU?=
 =?utf-8?B?cnpwMGNmeE53d0VVbmJNdFB2SlNyN1kxYmY3NEdFUzV0eW9LOWhUb3JNZW1N?=
 =?utf-8?B?Q1ZpdE1JOWZ6d0l0cHlTQlY2OHBiTmFISkhTSzVDWDc3eDk1ODFzNVh2ai9C?=
 =?utf-8?B?NWVEQVM3YUMrMkNCdm1LSGJsMXFpTE1WVzdIVFUrVnAxVEpKMGFRR1VDRTds?=
 =?utf-8?B?ZENUdWZ6cTBzd0l5WmNnbHJSbWowWG5JWmNycTJ2c3VaT1U3STVhdTAvVnlo?=
 =?utf-8?B?bHJud1V2QkZQOWFqd0NSUEdITGw1NnhQbzcyVzA4ZnFyZUtZUzUvRUZtY290?=
 =?utf-8?B?MUlQeUh0TjQzcXJraHU2N3hhUkE2eW56UlRQd3lsdkRQZ2FZcDR4UFI3Nmd6?=
 =?utf-8?B?TWs2NURnYk05NEl0UURPUkNKR0ZjQnpNYVBDdWpBRURpTWlPdTltNjBVMkVB?=
 =?utf-8?B?NlovWTYyTVRFaXlVSDlQWmMxVnBLMmhWdFFJc2tEWVNVWUU5MmNnZTVrRUJX?=
 =?utf-8?B?WUFGQmlNL2VkNXdKamlmVnVzOFhkN1dRcW5CekZyS0dZa1FWak9kR2J6TXlI?=
 =?utf-8?B?NjkvWWhyWEI1bDFsc3RoTWpWM3QwRVp1UCtIbXlYUlErazB5Smg1S0E5OGhl?=
 =?utf-8?B?TVZGVndVbTUvem1yVXlJRWNybm9DM28zVGpneDl0UEtjS294NTVUTzdVdlN1?=
 =?utf-8?B?MFlINldJQ1g2eXlrTnVrSldMYkVVekRMM1Zkc21OV0hkRmpxV3JXaVBXdnRN?=
 =?utf-8?Q?4gnw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9640.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ef87e0-c95e-46d3-5b25-08dadcfba68a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 11:17:41.4864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aqex2YwWQ87aFzANx5gL+yPVRccCj6erC72ETgjbv0T5lL6A9Em29jGeg9MBWy/f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7192
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
ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxMywgMjAyMiA1
OjMzIFBNDQo+IFRvOiBKdW4gTGkgPGp1bi5saUBueHAuY29tPg0KPiBDYzogYmpvcm5AbW9yay5u
bzsgUGV0ZXIgQ2hlbiA8cGV0ZXIuY2hlbkBrZXJuZWwub3JnPjsgTWFyZWsgVmFzdXQNCj4gPG1h
cmV4QGRlbnguZGU+OyBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBVU0IgbGlzdA0K
PiA8bGludXgtdXNiQHZnZXIua2VybmVsLm9yZz47IEFsZXhhbmRlciBTdGVpbg0KPiA8YWxleGFu
ZGVyLnN0ZWluQGV3LnRxLWdyb3VwLmNvbT47IFNjaHJlbXBmIEZyaWVkZXINCj4gPGZyaWVkZXIu
c2NocmVtcGZAa29udHJvbi5kZT4NCj4gU3ViamVjdDogUmU6IGlteDc6IFVTQiBtb2RlbSByZXNl
dCBjYXVzZXMgbW9kZW0gdG8gbm90IHJlLWNvbm5lY3QNCj4gDQo+IEhpIExpIEp1biwNCj4gDQo+
IE9uIFR1ZSwgRGVjIDEzLCAyMDIyIGF0IDU6MTUgQU0gSnVuIExpIDxqdW4ubGlAbnhwLmNvbT4g
d3JvdGU6DQo+IA0KPiA+IFNvIHRoaXMgZGlzY29ubmVjdCBhbmQgdGhlbiBjb25uZWN0IGlzIHlv
dSBleHBlY3RlZCBiZWhhdmlvcj8NCj4gDQo+IFllcywgY29ycmVjdC4NCj4gDQo+IEkgZm91bmQg
YSB3YXkgdG8gZ2V0IHRoaXMgYmVoYXZpb3IgaW4gYm90aCA1LjEwIGFzIHdlbGwgYXMgNi4xIGtl
cm5lbHM6DQo+IElmIEkgcmVtb3ZlIHRoZSBVU0JfT1RHMl9PQyBwaW5jdHJsIGVudHJ5IGFuZCBw
YXNzICdkaXNhYmxlLW92ZXItY3VycmVudCcsDQo+IGl0IHdvcmtzIGFzIGV4cGVjdGVkLg0KDQpT
byB0aGUgcGluY3RybCBpcyB1c2luZyBNWDdEX1BBRF9VQVJUM19SVFNfQl9fVVNCX09URzJfT0M/
DQoNCj4gDQo+IE9uIHRoaXMgYm9hcmQsIHRoZSBNWDdEX1BBRF9VQVJUM19SVFNfQl9fVVNCX09U
RzJfT0MgcGFkIGdvZXMgdG8gMy4zViB2aWENCj4gYSAxMEtvaG0gcHVsbHVwIHJlc2lzdG9yLg0K
DQpTbyB0aGUgcGFkIGlzIGZpeGVkIGF0IDMuM1YsIG5ldmVyIGNhbiBiZSB0aWVkIGxvdz8NCg0K
PiANCj4gQ291bGQgeW91IHBsZWFzZSBleHBsYWluIHdoeSByZW1vdmluZyB0aGVVU0JfT1RHMl9P
QyBlbnRyeSBtYWtlcyB0aGluZ3MgdG8NCj4gd29yaz8NCg0KU28gdGhlIGFjdHVhbCBib2FyZCBk
ZXNpZ24gZG9lcyBub3Qgd2FudCB0byBoYXZlIE9DIGZlYXR1cmUsIHJpZ2h0PyBpZiB0aGF0DQpp
cyB0aGUgY2FzZSwgZGlzYWJsZS1vdmVyLWN1cnJlbnQgaXMgdGhlIHJpZ2h0IHdheS4NCg0KV2hh
dCdzIHRoZSBPQyBwb2xhcml0eSBjb25maWcgaW4geW91ciBTVywgYWN0aXZlIGxvdywgb3IgYWN0
aXZlIGhpZ2g/DQpCYXNpY2FsbHkgaWYgdGhlIE9DIGNvbmRpdGlvbiBpcyBhY3RpdmUsIHRoZSBo
b3N0IG1vZGUgY2Fubm90IHdvcmsNCndlbGwuDQoNCkxpIEp1bg0KPiANCj4gVGhhbmtzDQo=
