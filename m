Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EA059B742
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 03:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiHVB0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiHVB0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:26:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80043.outbound.protection.outlook.com [40.107.8.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABA721246
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 18:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJFwV11I7Sql2D1EMHQ3/6/yMmAyOf+1fj+EZBz0E9CPMupYMO1n6h9vUPxQm7LGQh758A6UUIChHidqq24ebqZnRGHFOdkwiYsgIyFNsMgsqNFyWFx3CCcCpvaLOziHIx0DQGAIU8MjIt0ztggpi8dO/2wRViF05ElqsyMgBGPcJWnbjjm7kJaDOCb2EPG8nt1KJPsk7AOpz1rla9oQnm+Q+QWuPXqMsXIO7OAY8+krxekP+OoNX6Qqc2n5Q2NOsf5POTEg/2Z/AkMTavl8n7sFApMN71lhHglQK3SCJSkHzZ2Z0a89VCd0sGIsqT2edKeromG9kKYFTXpr7OJvTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOwJ6AbqH0CkhAMREhJ1tEiXjKVG80tKW4kj8WuUyvM=;
 b=Ta86TtpLHC2KMg02L+vJ29nt8DBr+1e+ewnVYRynmYbLtAF2Gcuv0KxApAOpdH/wAV6oTE26KRkICUHGV3WE8HGcTte3he6n5430Udo2u4XudJvizlrr7dSlwi3mXePc7QqFJQ9ICYmYjwgnfMffMUJ/OLRKSJRMgb3DtjxvteDt1YOOg0VOf7ND24HbiJeoZ7ciOtDySs3B+XpOsiIVYFONf7+o2de2jyh0/ygltK0hst8iENCUIe2TrD2WAPCmcDUIWYlj/PUaFvvD+G8eM1/+bZ5Vmepa0tGL9vcvZ4Fn4eNnfK1h65IVsBVc/vnXQK+0AjGWxpFpT3Gu83UXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOwJ6AbqH0CkhAMREhJ1tEiXjKVG80tKW4kj8WuUyvM=;
 b=l42LDg4rAIRXxeZzxqb7dcjrl0t/yB/2SvMxxHMvq8WgH6NNkfR0wD4DuC4EIqgVEjOn/qEX5naus0GDaXtycNcKHZV6Bdiy1Jfx2J0euE/ICvJrOYO5+1+2metWnT8P9aFYtWUX3H0l9hxv8HWhvxOXxbUC3IwiG8CVFGPYSSI=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB3PR0402MB3802.eurprd04.prod.outlook.com (2603:10a6:8:f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 01:26:39 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 01:26:39 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Clark Wang <xiaoning.wang@nxp.com>
Subject: RE: [PATCH V3 net-next] net: phy: realtek: add support for
 RTL8211F(D)(I)-VD-CG
Thread-Topic: [PATCH V3 net-next] net: phy: realtek: add support for
 RTL8211F(D)(I)-VD-CG
Thread-Index: AQHYsdm4gWHSiXu610uzRENpiupEOq26KD5g
Date:   Mon, 22 Aug 2022 01:26:39 +0000
Message-ID: <DB9PR04MB8106229260E474A87E08161588719@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220817013618.6803-1-wei.fang@nxp.com>
In-Reply-To: <20220817013618.6803-1-wei.fang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3a1d3ad-9c40-4457-0074-08da83dd5cd4
x-ms-traffictypediagnostic: DB3PR0402MB3802:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Ds2gSvjA0JzAjlhdsOexLWHDb+dIOSVhxoyFS7R4dX/5uvszXC1H30VNfAH2QHihLIEUdn9al3cwCxIDsq8LL02t3qMboIc0WPhjznSFI8hVKMA7/1Hh57vP39YMDAPJJrQNK7yK98Q5nr5dmlx2BRDUXzJ+6QciJk4T0oCA8dFLVo7ObRaquHbZG9UvGSW6GGP1OUh5l0yivbmyAwV4wIARX6Zs36l0uo9xmea7NH08lnHx5wqXHIctpc1KQUm5+Em46RrcidUN3l3vK/G909VLbt3eO9ObTMP8HABZBd9gU/Xe5fPI+94FaHbgFNZHcVrBpcUCx/y3lS3PebmVoYQAxLdHlpj72Ut8pCZwJqux18IEvOsHe72kUnUgg4YBeiITbPBHHtmZveKH+vUkmzOIavbuHUjn2RFtVm73qsBCohxHDLCEW6IPuK9+/clBrdyh7sRCd/OMh11MvwCjV+VpCjp25e6J6TRSEXPXHR6fCvv2vOefDSk0b+oHhdIfTJLMyugQnYEFdGvNFrOSmlxlCVdwEHxJpmCuxzllgrX3Kca9SaDaD+KctDHjPH4TUs1334Pe1ZqTFGftDsriMW10Cjrj8DZZtlNiQEXoOOtb9WzEbl3svBfCgLxOpXNiey7vcyH/NwMt3Kpcs4IO3G6Rf85TVp72cZys4Rz3q6S1bnh1mFI0F2lE3g+xmRILMLc1lPd8NMdks3x0zeFhRCaK6tdwmoqjxxDlAZY/n6xasptEmUSfRmJGp9U/Ci1OOqkY9UiL1YJkoq5i1ld5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(55016003)(38070700005)(86362001)(33656002)(38100700002)(122000001)(52536014)(8936002)(41300700001)(5660300002)(44832011)(110136005)(76116006)(478600001)(66946007)(66556008)(64756008)(8676002)(71200400001)(66446008)(4326008)(66476007)(316002)(186003)(83380400001)(53546011)(26005)(2906002)(9686003)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?aksrK21IejNJWGlyNlVjR2RQaFZWT3BwK3B4V2ZySW5sRENranNzelIxREF0?=
 =?gb2312?B?VHZUN1ZXSlhyTzM1U1IwMTdueGQyd0lIdCt6K3IxU1M3QURiVjFxK1VsTmh0?=
 =?gb2312?B?N0dmQ2ZxNUFvWCs5LzMrNU5LNzFFK2lWNW04ZjRncWo2NWl0ZldlYlhxQ0do?=
 =?gb2312?B?OVQwNlBlYVM3K2JLYjF6M29HckZjWlYzclB1b3p1RVY4WnB4bmhlYkFJOEtm?=
 =?gb2312?B?UUJaZ0k1bDExMFY5MEE3dFlVYUo2YXVFMVhIdm81WjhvK3Fkc3hiRU9OQnBq?=
 =?gb2312?B?dFp1ZmpMYlZyVmRNZDNFa3oxTUVmcDRpZnlOUWlVY0ozVFg0UFBqNDF3TU11?=
 =?gb2312?B?WUUrWnIzRVBjTXpLVGRRanExbjU3b3ZZSmt5Z1lkRlNOZ1VJQXhubmp5TXlo?=
 =?gb2312?B?bkpidFZYejNyem9zR2dJTXJteXBoTHlhNWNqZkVrcmVhOFZ4Y3FrTlhWYk4z?=
 =?gb2312?B?UmZ1ZkZXd2gra203KzJ4K2VMQ0RKMFJISjk0OG9TKzg0azhrVzRIbHBiRk5j?=
 =?gb2312?B?N2trbWlVMVI1NCsvN3NSWHFiWThHUHg4dVNGa25wejBCejdyQzVTS3hvNlFr?=
 =?gb2312?B?MmIwS3hBcjA5WUsyRUlUQytvL1g2NE1qQm53MEg0eWFRcGVJbVBKdW0xenZB?=
 =?gb2312?B?c0RiMmsyLy9Ud1NWcDBiNHFxRkFHcncxaFFTbDZ1MkwzbFhYMDkvd0x0ZVgr?=
 =?gb2312?B?KzgyWUlPTCtrcU9DdVV4bmhnclpWclRkTVhzTFJ5TEpEYU1sQ01UUWx0ZlJO?=
 =?gb2312?B?YjFZWGpZKzVWdGkyc2RQWDFqclhBNXgzNk45NHE1aEtCNXBCZlNLdjRaQVNo?=
 =?gb2312?B?RkJLY1YzWUZ0bVczd1k0MXg1NWFSMmRzYnZxTkxJQ3RXc0tvcTNHV0QwbGc1?=
 =?gb2312?B?LzNkNFBOQUUwN2IrZ2lvQXUzaGdSdVcyOWZMQzQvWUhsTnpmeVFjejlaZk4x?=
 =?gb2312?B?ZmtnS1U0VTBVaDdpeWtnQzBJRHBvL01MbW9FMlR5a29weHBXYzlnUWt3ald5?=
 =?gb2312?B?SS84bTg1d1l0Z0lUTWlaSkVINVBlVUwzTG9sWHU0TE96RlZURXZLTWptYXlO?=
 =?gb2312?B?OVJQUHJNeDVjZnd1VE9lMSt6VXNZZ3Fkd2JXMGYyaFZybjNaeEV0dlM1bzNF?=
 =?gb2312?B?cEl0aExmSWJMNVZrL3ZTOVVFQ2JPZlZScFhXNGx6ZVBlTEM3OFc5SitoK0Rw?=
 =?gb2312?B?S2wzNkI1Q1ZZdkFyU2J2eVBZdVhiNy9KOVgyMUZTa0FJS2tzMWxqNk9TVmF4?=
 =?gb2312?B?QjlITjd2ekwwaWZ0WkZSMXU4RkdNaXloZi9FRjZwTE44Z21BQkE2SVJEbmhm?=
 =?gb2312?B?cHNUekZCRTlRUW15WUFzNHl5N01vWjY1MVB1SXBMakh6STFOaG96cU5Zd1Jo?=
 =?gb2312?B?RGpkMFJjZmI0eHVXb3hFZndKWXRnZzdOelF2Mzk3UWs5SmFrN0hWSndQbnpT?=
 =?gb2312?B?d1lsK256c0h0V1FmRWNSa2dDTGRDenk3ZmNESkFYNmtLSU5FUEN1bnUwYTdX?=
 =?gb2312?B?NEtuMVgwbS84VEt3TFNUMlk1SHVJckU0Tkdsa3hsbEhWQWYwV2N2enNyNXFZ?=
 =?gb2312?B?SFd6ejVFeGlBSTE1TUd1UlpoVXY4dXhaaHNVNmVnV0s5bUlMN3BkQURSUW9F?=
 =?gb2312?B?WmhaYktBL0FzTEUwb0ZaWGUrUGVuKy8xVFZTcEgxWHFURjVTT2duRG5IbGdW?=
 =?gb2312?B?UkNxQm4rd3k0eTQrQXM3alBWeS9GUWxDTG9va0IrY2JHbkF1eXFJNk4xY0Jj?=
 =?gb2312?B?WEo4L3N3aGpnU2xnL3lXUElqN2NGR1NrKzVnUnZiUldnbjQwMHErL1VXWk81?=
 =?gb2312?B?WWNXTmJyMjU0Y1ZmaFlHUDBSTndPSHBIU3piRnFialpnL2hxRyt6L1RmQXdn?=
 =?gb2312?B?R3NrRzcxNTM3dWllMU1mMlZFRWhjNTB3a0xpRkpmZElWMyt0c2JWbnBLUEJ6?=
 =?gb2312?B?bGJCSlBzemJ3YmFrQVlJa2dVZk05N2lYeGdUTXhDakJabzJCd2FmVnNHaWlP?=
 =?gb2312?B?K3NHajdXWVc3Nk1nYTFDVGIwUi9zcjN6Mnc2NGhJU3NCSndZTE1MenNPTGhL?=
 =?gb2312?B?bDUwZlB6OHdGcTk2U25qMnYrOVlzM2ZiSUd4UW01WlJFekV0RndZYnoyZWMr?=
 =?gb2312?Q?NtEM=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a1d3ad-9c40-4457-0074-08da83dd5cd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 01:26:39.4285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PTxJzrk4kyExMFnRQMdKjIoFCdAoIfmBQF+eZWmFvK2WA097lN37qiLM1Hgw+C/JoFIUU5nnMDKd70bDLNP/9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

S2luZGx5IHBpbmcuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogV2Vp
IEZhbmcNCj4gU2VudDogMjAyMsTqONTCMTfI1SA5OjM2DQo+IFRvOiBhbmRyZXdAbHVubi5jaDsg
aGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51azsNCj4gZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJl
bmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogQ2xhcmsgV2FuZyA8
eGlhb25pbmcud2FuZ0BueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggVjMgbmV0LW5leHRdIG5l
dDogcGh5OiByZWFsdGVrOiBhZGQgc3VwcG9ydCBmb3INCj4gUlRMODIxMUYoRCkoSSktVkQtQ0cN
Cj4gDQo+IEZyb206IENsYXJrIFdhbmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT4NCj4gDQo+IFJU
TDgyMTFGKEQpKEkpLVZELUNHIGlzIHRoZSBwaW4tdG8tcGluIHVwZ3JhZGUgY2hpcCBmcm9tIFJU
TDgyMTFGKEQpKEkpLUNHLg0KPiANCj4gQWRkIG5ldyBQSFkgSUQgZm9yIHRoaXMgY2hpcC4NCj4g
SXQgZG9lcyBub3Qgc3VwcG9ydCBSVEw4MjExRl9QSFlDUjIgYW55bW9yZSwgc28gcmVtb3ZlIHRo
ZSB3L3Igb3BlcmF0aW9uDQo+IG9mIHRoaXMgcmVnaXN0ZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFdl
aSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiAtLS0NCj4gVjIgY2hhbmdlOg0KPiAxLiBDb21t
aXQgbWVzc2FnZSBjaGFuZ2VkLCBSVEw4MjIxIGluc3RlYWQgb2YgUlRMODgyMS4NCj4gMi4gQWRk
IGhhc19waHljcjIgdG8gc3RydWN0IHJ0bDgyMXhfcHJpdi4NCj4gVjMgY2hhbmdlOg0KPiBUaGVy
ZSBpcyBhIHR5cG8sIGFjdHVhbGx5IHRoZSBwaHkgY2hpcCBpcyBSVEw4MjExLCBTbyBJIGNvcnJl
Y3QgaXQgaW4gdGhlIGNvb21taXQNCj4gbWVzc2FnZSBhbmQgc3ViamVjdC4NCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC9waHkvcmVhbHRlay5jIHwgNDQgKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgMTIgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYyBi
L2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMgaW5kZXgNCj4gYTU2NzFhYjg5NmIzLi4zZDk5ZmQ2
NjY0ZDcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYw0KPiBAQCAtNzAsNiArNzAsNyBAQA0KPiAgI2RlZmlu
ZSBSVExHRU5fU1BFRURfTUFTSwkJCTB4MDYzMA0KPiANCj4gICNkZWZpbmUgUlRMX0dFTkVSSUNf
UEhZSUQJCQkweDAwMWNjODAwDQo+ICsjZGVmaW5lIFJUTF84MjExRlZEX1BIWUlECQkJMHgwMDFj
Yzg3OA0KPiANCj4gIE1PRFVMRV9ERVNDUklQVElPTigiUmVhbHRlayBQSFkgZHJpdmVyIik7ICBN
T0RVTEVfQVVUSE9SKCJKb2huc29uDQo+IExldW5nIik7IEBAIC03OCw2ICs3OSw3IEBAIE1PRFVM
RV9MSUNFTlNFKCJHUEwiKTsgIHN0cnVjdCBydGw4MjF4X3ByaXYNCj4gew0KPiAgCXUxNiBwaHlj
cjE7DQo+ICAJdTE2IHBoeWNyMjsNCj4gKwlib29sIGhhc19waHljcjI7DQo+ICB9Ow0KPiANCj4g
IHN0YXRpYyBpbnQgcnRsODIxeF9yZWFkX3BhZ2Uoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikg
QEAgLTk0LDYgKzk2LDcNCj4gQEAgc3RhdGljIGludCBydGw4MjF4X3Byb2JlKHN0cnVjdCBwaHlf
ZGV2aWNlICpwaHlkZXYpICB7DQo+ICAJc3RydWN0IGRldmljZSAqZGV2ID0gJnBoeWRldi0+bWRp
by5kZXY7DQo+ICAJc3RydWN0IHJ0bDgyMXhfcHJpdiAqcHJpdjsNCj4gKwl1MzIgcGh5X2lkID0g
cGh5ZGV2LT5kcnYtPnBoeV9pZDsNCj4gIAlpbnQgcmV0Ow0KPiANCj4gIAlwcml2ID0gZGV2bV9r
emFsbG9jKGRldiwgc2l6ZW9mKCpwcml2KSwgR0ZQX0tFUk5FTCk7IEBAIC0xMDgsMTMNCj4gKzEx
MSwxNiBAQCBzdGF0aWMgaW50IHJ0bDgyMXhfcHJvYmUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
dikNCj4gIAlpZiAob2ZfcHJvcGVydHlfcmVhZF9ib29sKGRldi0+b2Zfbm9kZSwgInJlYWx0ZWss
YWxkcHMtZW5hYmxlIikpDQo+ICAJCXByaXYtPnBoeWNyMSB8PSBSVEw4MjExRl9BTERQU19QTExf
T0ZGIHwNCj4gUlRMODIxMUZfQUxEUFNfRU5BQkxFIHwgUlRMODIxMUZfQUxEUFNfWFRBTF9PRkY7
DQo+IA0KPiAtCXJldCA9IHBoeV9yZWFkX3BhZ2VkKHBoeWRldiwgMHhhNDMsIFJUTDgyMTFGX1BI
WUNSMik7DQo+IC0JaWYgKHJldCA8IDApDQo+IC0JCXJldHVybiByZXQ7DQo+ICsJcHJpdi0+aGFz
X3BoeWNyMiA9ICEocGh5X2lkID09IFJUTF84MjExRlZEX1BIWUlEKTsNCj4gKwlpZiAocHJpdi0+
aGFzX3BoeWNyMikgew0KPiArCQlyZXQgPSBwaHlfcmVhZF9wYWdlZChwaHlkZXYsIDB4YTQzLCBS
VEw4MjExRl9QSFlDUjIpOw0KPiArCQlpZiAocmV0IDwgMCkNCj4gKwkJCXJldHVybiByZXQ7DQo+
IA0KPiAtCXByaXYtPnBoeWNyMiA9IHJldCAmIFJUTDgyMTFGX0NMS09VVF9FTjsNCj4gLQlpZiAo
b2ZfcHJvcGVydHlfcmVhZF9ib29sKGRldi0+b2Zfbm9kZSwgInJlYWx0ZWssY2xrb3V0LWRpc2Fi
bGUiKSkNCj4gLQkJcHJpdi0+cGh5Y3IyICY9IH5SVEw4MjExRl9DTEtPVVRfRU47DQo+ICsJCXBy
aXYtPnBoeWNyMiA9IHJldCAmIFJUTDgyMTFGX0NMS09VVF9FTjsNCj4gKwkJaWYgKG9mX3Byb3Bl
cnR5X3JlYWRfYm9vbChkZXYtPm9mX25vZGUsICJyZWFsdGVrLGNsa291dC1kaXNhYmxlIikpDQo+
ICsJCQlwcml2LT5waHljcjIgJj0gflJUTDgyMTFGX0NMS09VVF9FTjsNCj4gKwl9DQo+IA0KPiAg
CXBoeWRldi0+cHJpdiA9IHByaXY7DQo+IA0KPiBAQCAtNDAwLDEyICs0MDYsMTQgQEAgc3RhdGlj
IGludCBydGw4MjExZl9jb25maWdfaW5pdChzdHJ1Y3QgcGh5X2RldmljZQ0KPiAqcGh5ZGV2KQ0K
PiAgCQkJdmFsX3J4ZGx5ID8gImVuYWJsZWQiIDogImRpc2FibGVkIik7DQo+ICAJfQ0KPiANCj4g
LQlyZXQgPSBwaHlfbW9kaWZ5X3BhZ2VkKHBoeWRldiwgMHhhNDMsIFJUTDgyMTFGX1BIWUNSMiwN
Cj4gLQkJCSAgICAgICBSVEw4MjExRl9DTEtPVVRfRU4sIHByaXYtPnBoeWNyMik7DQo+IC0JaWYg
KHJldCA8IDApIHsNCj4gLQkJZGV2X2VycihkZXYsICJjbGtvdXQgY29uZmlndXJhdGlvbiBmYWls
ZWQ6ICVwZVxuIiwNCj4gLQkJCUVSUl9QVFIocmV0KSk7DQo+IC0JCXJldHVybiByZXQ7DQo+ICsJ
aWYgKHByaXYtPmhhc19waHljcjIpIHsNCj4gKwkJcmV0ID0gcGh5X21vZGlmeV9wYWdlZChwaHlk
ZXYsIDB4YTQzLCBSVEw4MjExRl9QSFlDUjIsDQo+ICsJCQkJICAgICAgIFJUTDgyMTFGX0NMS09V
VF9FTiwgcHJpdi0+cGh5Y3IyKTsNCj4gKwkJaWYgKHJldCA8IDApIHsNCj4gKwkJCWRldl9lcnIo
ZGV2LCAiY2xrb3V0IGNvbmZpZ3VyYXRpb24gZmFpbGVkOiAlcGVcbiIsDQo+ICsJCQkJRVJSX1BU
UihyZXQpKTsNCj4gKwkJCXJldHVybiByZXQ7DQo+ICsJCX0NCj4gIAl9DQo+IA0KPiAgCXJldHVy
biBnZW5waHlfc29mdF9yZXNldChwaHlkZXYpOw0KPiBAQCAtOTIzLDYgKzkzMSwxOCBAQCBzdGF0
aWMgc3RydWN0IHBoeV9kcml2ZXIgcmVhbHRla19kcnZzW10gPSB7DQo+ICAJCS5yZXN1bWUJCT0g
cnRsODIxeF9yZXN1bWUsDQo+ICAJCS5yZWFkX3BhZ2UJPSBydGw4MjF4X3JlYWRfcGFnZSwNCj4g
IAkJLndyaXRlX3BhZ2UJPSBydGw4MjF4X3dyaXRlX3BhZ2UsDQo+ICsJfSwgew0KPiArCQlQSFlf
SURfTUFUQ0hfRVhBQ1QoUlRMXzgyMTFGVkRfUEhZSUQpLA0KPiArCQkubmFtZQkJPSAiUlRMODIx
MUYtVkQgR2lnYWJpdCBFdGhlcm5ldCIsDQo+ICsJCS5wcm9iZQkJPSBydGw4MjF4X3Byb2JlLA0K
PiArCQkuY29uZmlnX2luaXQJPSAmcnRsODIxMWZfY29uZmlnX2luaXQsDQo+ICsJCS5yZWFkX3N0
YXR1cwk9IHJ0bGdlbl9yZWFkX3N0YXR1cywNCj4gKwkJLmNvbmZpZ19pbnRyCT0gJnJ0bDgyMTFm
X2NvbmZpZ19pbnRyLA0KPiArCQkuaGFuZGxlX2ludGVycnVwdCA9IHJ0bDgyMTFmX2hhbmRsZV9p
bnRlcnJ1cHQsDQo+ICsJCS5zdXNwZW5kCT0gZ2VucGh5X3N1c3BlbmQsDQo+ICsJCS5yZXN1bWUJ
CT0gcnRsODIxeF9yZXN1bWUsDQo+ICsJCS5yZWFkX3BhZ2UJPSBydGw4MjF4X3JlYWRfcGFnZSwN
Cj4gKwkJLndyaXRlX3BhZ2UJPSBydGw4MjF4X3dyaXRlX3BhZ2UsDQo+ICAJfSwgew0KPiAgCQku
bmFtZQkJPSAiR2VuZXJpYyBGRS1HRSBSZWFsdGVrIFBIWSIsDQo+ICAJCS5tYXRjaF9waHlfZGV2
aWNlID0gcnRsZ2VuX21hdGNoX3BoeV9kZXZpY2UsDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
