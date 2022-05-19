Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DED52D7E6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiESPiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241296AbiESPiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:38:17 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2071.outbound.protection.outlook.com [40.107.20.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3486720F76;
        Thu, 19 May 2022 08:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9Ey/WZoBTvV+XQjUDDV3Sya4eamt1MxdXfenuGuVRO0JIVCHHN5WnfHvRrBhbvbcoe83c8u6HG5Q82+jEcITuR6GIMA2JoBUaGxKe0t06ft6/jjfNSe0SWbN/6g8Ynh9O4o743T6sfS6wWp/giBv+uq+Ed9skI8Bj8TeoYgjDmzc0mRU+rbvTcemsyT/YQ7WFVUMHjE1V9S84WdFtc828056V1E2g+s+Jm91ZWAHfAvQ7PMJn5w7EV1BFAwx6uUZcy/GNx9d++vCs0Ft5Et46SLDLM0FGpIYCdON6/BKWez1yK4XJISOhZ8dAl6Wx0Y1pDSw52HNYwQOfRlJcYnlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao9tj8XLfsFsRDZB/DuGxu0ZP5GzWk3fPxZcValgCo8=;
 b=frH00klLek6+V+S1mz2VgQtpLOUY41dcLI4KYeoa9jsjDcPu4cj4yfis3elAg9hUes5oPk8NGwtJ0tqRpkQQM0f78e0Hw1QuUSySkFmeajk3RpAfWvh+ckDgHhE94Ueo8aVPzLtwdsghaRQigOLR6uo9wXJV7aeGKXJXNaiYQbPAnI0Bw5n68XgumpKxvUiHidFhirg8cqY/L3bskoyr9lQ9fDZTuAPJ+nNkfThUL4qor6lQrMYllq+CyGxhgVs46C11RGCMklD3fnCLnmhWgsX4J+BrlPuTSSZMKngtT32413I5hbPVAxYlp4svjdJheR83npradNpN9aQB6LUCqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao9tj8XLfsFsRDZB/DuGxu0ZP5GzWk3fPxZcValgCo8=;
 b=GvS31IA5BG6HaYvlUJg+ZM4p9/LEvL28sMtY6D+M9Tu7Nj/lzC6zq873QE8jxg7oN4JnciIafcyOHi5cfxrwG5TO1ZLOUYDACS01IV0GzXzvsZ9wZYDg8F1TnF1ImVEsuakDEEqNwqkFFo0LoAzHQej02XsJQp7plBMxpxkcb38=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5910.eurprd04.prod.outlook.com (2603:10a6:20b:af::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 15:38:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 15:38:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver that
 defers probe
Thread-Topic: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver
 that defers probe
Thread-Index: AQHYZyJUAF3LqZezX0WvBgnHz+VvNa0dg4GAgAjQVgCAAAk3gIAAAZIA
Date:   Thu, 19 May 2022 15:38:13 +0000
Message-ID: <20220519153812.egofm2c2r55bvs7c@skbuf>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
 <Yn72l3O6yI7YstMf@lunn.ch> <20220519145936.3ofmmnrehydba7t6@skbuf>
 <YoZjE77QvIGifDnY@lunn.ch>
In-Reply-To: <YoZjE77QvIGifDnY@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7263124-3273-432c-2c56-08da39ad9611
x-ms-traffictypediagnostic: AM6PR04MB5910:EE_
x-microsoft-antispam-prvs: <AM6PR04MB591029CEDAB9CEFD12272881E0D09@AM6PR04MB5910.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 37mptYQdlJ907z1z13AqJKSUeYqTQMOv+eFGinWRakDc1pI9Z0eR01sg0cJ9E4G6QyrSzyTyns6A9U6MUIPwRGXpb3Yj77N/kZVNge4PohFyXPFiUzsOa5PrIkPrD7awQjZv3lEpLput02a7PGdXsmvbbPkE1Oc/n2Nx7cK4A+q7WdmCqwaUx1nEy/YtJrhu7PXwGX4Fq2pDCGl16nIHOp38zA/9faogucfMnqXs6ykY+NCZMIn5wLTImsuUi6mSaaIfbQQewR/fL25J+GgZ0mUDEHHjPXbzCKCoLxg9B8092mWXk2kGoq8FIlk60bFLg/cl5Uoi7CfE/X+liahRKk2ynqtsjMqzR5YxTYRB3fS+Og0sAKvjtlVRwa12UH3zferjQcUmM3PXBGBkVO8tWO314J4ka1TZMIUpCGNObn6l67YB5Lr1tRzTiwdgzMVInXwyZgs0a8HnXhjBX4aUPJdSflleJG5qBL2UX7+vDMndcs4Gat7Z+yeJfhfJp2NK/AyFrTMJbGuMtKDsh1Aii8Hk7rDZSxzg4NJYk255m3kx9yYDQYRy8Lgq8tifHXfUKSvAUGXGYD6fFwZB1aFGtg0xqbqDqgTYSNWjHVl9IRDl5CMiZRFtXM0UPGHPaTqx0sOqfZ9Di0sMhE6DejqkT411TB49cr2MnLDcMEw+2pWVQ7dYMseJdl/mjaBSYJgILZ3xbl71i3Qm+tbxMiAFQRyE2XFx+PF4TS6y+OETmQm5fIYTMkGkFl9foKXw+wIlxT2ScmU7Xz/UyVsdhyW4Bs3WSySRv1HKIXnhW4fesH4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(44832011)(8936002)(38100700002)(76116006)(38070700005)(7416002)(71200400001)(4326008)(64756008)(2906002)(66446008)(5660300002)(8676002)(66476007)(66556008)(66946007)(91956017)(186003)(6506007)(26005)(33716001)(1076003)(9686003)(83380400001)(508600001)(966005)(86362001)(316002)(122000001)(6486002)(54906003)(6916009)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?aG8wYTE0ek10MXhORFB2L1NrN01OUnhVTWZjdlBEcVcxbjl1azgzY29yUC83?=
 =?gb2312?B?Z3ZPTlladURodHpWY21kZmw5Wi83WllkaU9FRHJqazZlYlA3VmJKSUpWeE5o?=
 =?gb2312?B?MGRFMkl0TXRBcFQxRVdBdzRiQ2pxOFBKM0ViVXVGdWFtOFE2Z2Z4UFJsSmUr?=
 =?gb2312?B?VTQ1OTc2cTZNeEpTYS9kUTZmZ0FjL1g4WVB4NnRuTk1Wb2RCY2ljK3lteVBp?=
 =?gb2312?B?UWtlNFdPUUdwSGFueWlGVzB2N2ZJNWZHbGFTdHR4dkpvOGhQMnZaMVhjSG91?=
 =?gb2312?B?NEZ3WDh1NmNkMUIzQkVHK3l2UzI5VGR0Wm90enJ1UnJaTHJBWHBPNHREbEVF?=
 =?gb2312?B?SlVIWXJaYktiRGRGSFp6RWlVTmdpUnpzQ21tVjdsUUM4L1BvZjlETXF4eS9p?=
 =?gb2312?B?aFQwOTFmN0xlK2ZDejltait2K25CT1ZaYmRUcjBaZ3dWbGg5K1dZK3lBZ29s?=
 =?gb2312?B?MHhHL29mYlUveTZXd0hUSVZuQ1JrRzB3OGZyb29MNUE5OXlrR2lmNGhtdUUx?=
 =?gb2312?B?blFyeXIvOU81TVVtQ2ZPUFRwSVZJOEZUM0JQUGl4eHhEMHA4NzZ6dWpmdzZo?=
 =?gb2312?B?NW9TdHRvblRiRC9GMElvemt4UmdoeFVHdmVnU1JxOTFjcjJwbmlpS1VwQ2JM?=
 =?gb2312?B?bituWVM5THE2OTV5TDhtaDRKc1B1eVc0ek5oOTR6THNvY3k0alVtMmNrdHhZ?=
 =?gb2312?B?UmRaRS9WckVhUlV0UE5jZUQzeC80RndDR29BSi9Ra3duaW0wbWd0ZythSWdD?=
 =?gb2312?B?UkxlRnJrZGRtUU9SbzFUb2VXNThMV3hoMGlFd0ROWFo4VVJ4Q1NFaHAwZ3N3?=
 =?gb2312?B?bzZCcnVUSlFmbi9JeFFtZ3FqT0tOdDN0VkFVNTdXL011NHJrT2JPS2d3MnJL?=
 =?gb2312?B?NEVCMVhNNWd0ekI0dmx0R3MwNFpDR3NIN2szRS85enZMbDJzRmh2SzVxV0w4?=
 =?gb2312?B?ZTJWeFdPUUdvUHhKRUgwNDg3bzNUZUN5bUwvN3BNRE5VakZ0cDZaRitYT0dv?=
 =?gb2312?B?d2NLOVBhUDNVUTdqYmNvM0g2VVFCcnZjczd1OXQwblUreGdvUGxPZXhhWVc1?=
 =?gb2312?B?WXZ4b0k3bUNldTI1andrcjYvd3R2K1BvSUJWK3NRS1RZY1BkM2o3V05Bb2lM?=
 =?gb2312?B?bXovMmpDMDAzTUt4RExwYlBXWEFOZlhPV3Fyb3U0dk9HK21ONDh5a29hdFlV?=
 =?gb2312?B?UHljWnRKL21xOThPY1VpSktYVmtPQUpOR2hMK0hkTGhxZWIxdmN0VkhabGhq?=
 =?gb2312?B?MFJ2azJJQWhBM2xEK1Q3MlFybjhuaUZJTWM2Qm5vOGk0R09pUGpTdm1ZbHpV?=
 =?gb2312?B?TUMzemgrRGFkZVFFTEhvbkQwYWRoUlZ5UnBram1QRGNsRk14bmF1ZGFDU0Zo?=
 =?gb2312?B?bkNla2lIVDBLdkVyNktnMktTdjdxVkVoSzdxeFJaazlMdkJsVTlzVlFreXlO?=
 =?gb2312?B?aXZvQzJPYXU4dzEra2tsdTZwNVMrMFNsZ1FyT01GbS8xU241WVk3cUxRY2tn?=
 =?gb2312?B?KzlBeEovK3QxWkYxazlMUzNrK3NjT2dTUTk0T1hVOWxWTVRJQURRMGhNcHRn?=
 =?gb2312?B?ZlBEeTM3MFpxRjV0Y0x1a0pYaE1GZnRZZ0hwVzg0V3pXS1ZkdlhxK09jT2JU?=
 =?gb2312?B?Ti9aMVhXczRtMU5qR0FtQkQ3UW03MU9pUmx6UDg4V1htOE1jZ3hiQWhwZkpL?=
 =?gb2312?B?Y0FNWGRzSVdYWFpnZ3FGcU9YWGVCQWE3YjcwdiszYjZDZmRtTjhWYUU3NGFr?=
 =?gb2312?B?SFYyMGd5N2FWb2tTaGlvaDM4R2NVN3lxbGxwSGpFODRhQXpGSkhFc2QzRE4z?=
 =?gb2312?B?QzJCVnQrVlFFT3dORm5ibWJ0dnV0aHBqbThvVDBDU1VNTHlJUzBFaXExaWl4?=
 =?gb2312?B?bXFsMFlKUUh3Q2VqYjA3MFhrS2N3V0h0MVpTaDVRY1hTdzZNSGJibWZhMVJH?=
 =?gb2312?B?RjdGbXBHYllxK2paNE9KcHU1ZE9acXN0aTZoMXVUY3pwYUtLeVhMaVd0blhB?=
 =?gb2312?B?eXMvMFJuY0svTVdjbE5wMGprL3FGTTB0WFhXVjN4aFlLT3dqM08wNmdzN1BV?=
 =?gb2312?B?RE96aXNPM0NqY2tHSXdCSWtaU2pKQVgwT2gxNWZ0WXkvK29HeUxOcEZidXVE?=
 =?gb2312?B?dnhmNzNXclF2NndGYzRocnhYeU05VmRMTE1xTUttOWVNdE5RZnRaY1FyRGxG?=
 =?gb2312?B?MmtpKysrd01WaVNsVis5NmdaZ0M0cWFHVjBnUnBTWnhLckpnY0J4MnZDdXBa?=
 =?gb2312?B?dUEyUFdObVMwOVdIVmVvNjFCa2VsNkdXcWVHYXEwTCt3Y041cERkZUQvMVNL?=
 =?gb2312?B?Q3FVYXFjQVVIcVpCUTVLMzRhMnpJek9sUmFUZU4rMXFtZTE0S3FBSy9Kc3Z0?=
 =?gb2312?Q?cXaR+xAjoEaoZKCU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <28F2C2A6C5CCEE419D063AE45AFCF56D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7263124-3273-432c-2c56-08da39ad9611
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 15:38:13.5867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GSXO1kv7IsOCPGgRxWYu8lhUirSmafjPsv98GzKcpE48lqDRuD1WaBvHP6khMsJwnsiR21WIzK3Dyfi9wVpY9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBNYXkgMTksIDIwMjIgYXQgMDU6MzI6MzVQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+ID4gPiBUaGVyZSBpcyBhIHZlcnkgZGlmZmVyZW50IGFwcHJvYWNoLCB3aGljaCBtaWdo
dCBiZSBzaW1wbGVyLg0KPiA+ID4gDQo+ID4gPiBXZSBrbm93IHBvbGxpbmcgd2lsbCBhbHdheXMg
d29yay4gQW5kIGl0IHNob3VsZCBiZSBwb3NzaWJsZSB0bw0KPiA+ID4gdHJhbnNpdGlvbiBiZXR3
ZWVuIHBvbGxpbmcgYW5kIGludGVycnVwdCBhdCBhbnkgcG9pbnQsIHNvIGxvbmcgYXMgdGhlDQo+
ID4gPiBwaHlsb2NrIGlzIGhlbGQuIFNvIGlmIHlvdSBnZXQgLUVQUk9CRV9ERUZGRVIgZHVyaW5n
IHByb2JlLCBtYXJrIHNvbWUNCj4gPiA+IHN0YXRlIGluIHBoeWRldiB0aGF0IHRoZXJlIHNob3Vs
ZCBiZSBhbiBpcnEsIGJ1dCBpdCBpcyBub3QgYXJvdW5kIHlldC4NCj4gPiA+IFdoZW4gdGhlIHBo
eSBpcyBzdGFydGVkLCBhbmQgcGh5bGliIHN0YXJ0cyBwb2xsaW5nLCBsb29rIGZvciB0aGUgc3Rh
dGUNCj4gPiA+IGFuZCB0cnkgZ2V0dGluZyB0aGUgSVJRIGFnYWluLiBJZiBzdWNjZXNzZnVsLCBz
d2FwIHRvIGludGVycnVwdHMsIGlmDQo+ID4gPiBub3QsIGtlZXAgcG9sbGluZy4gTWF5YmUgYWZ0
ZXIgNjAgc2Vjb25kcyBvZiBwb2xsaW5nIGFuZCB0cnlpbmcsIGdpdmUNCj4gPiA+IHVwIHRyeWlu
ZyB0byBmaW5kIHRoZSBpcnEgYW5kIHN0aWNrIHdpdGggcG9sbGluZy4NCj4gPiANCj4gPiBUaGF0
IGRvZXNuJ3Qgc291bmQgbGlrZSBzb21ldGhpbmcgdGhhdCBJJ2QgYmFja3BvcnQgdG8gc3RhYmxl
IGtlcm5lbHMuDQo+IA0KPiA+IFdoYXQgbW90aXZhdGVzIG1lIHRvIG1ha2UgdGhlc2UgY2hhbmdl
cyBpbiB0aGUgZmlyc3QgcGxhY2UgaXMgdGhlIGlkZWENCj4gPiB0aGF0IGN1cnJlbnQga2VybmVs
cyBzaG91bGQgd29yayB3aXRoIHVwZGF0ZWQgZGV2aWNlIHRyZWVzLg0KPiANCj4gQnkgY3VycmVu
dCwgeW91IG1lYW4gb2xkIGtlcm5lbHMsIExUUyBldGMuIFlvdSB3YW50IGFuIExUUyBrZXJuZWwg
dG8NCj4gd29yayB3aXRoIGEgbmV3IERUIGJsb2I/IFlvdSB3YW50IGZvcndhcmQgY29tcGF0aWJp
bGl0eSB3aXRoIGEgRFQNCj4gYmxvYi4gRG8gdGhlIHN0YWJsZSBydWxlcyBzYXkgYW55dGhpbmcg
YWJvdXQgdGhhdD8NCj4gDQo+ICAgICAgIEFuZHJldw0KDQpIbW0sIG5vdCBzdXJlIGFib3V0IHN0
YWJsZSBydWxlcywgYnV0IGF0IGxlYXN0IE1hcmMgWnluZ2llciBoYXMNCnN1Z2dlc3RlZCBpbiB0
aGUgcGFzdCB0aGF0IHRoaXMgaXMgc29tZXRoaW5nIHdoaWNoIHNob3VsZCB3b3JrOg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC84N2N6bHpqeG16LndsLW1hekBrZXJu
ZWwub3JnLw0KDQpUbyBxdW90ZToNCg0KfCA+IEFzIGZvciBjb21wYXRpYmlsaXR5IGJldHdlZW4g
b2xkIGtlcm5lbCBhbmQgbmV3IERUOiBJIGd1ZXNzIHlvdSdsbCBoZWFyDQp8ID4gdmFyaW91cyBv
cGluaW9ucyBvbiB0aGlzIG9uZS4NCnwgPiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9s
aW51eC1taXBzL21zZzA3Nzc4Lmh0bWwNCnwgPiANCnwgPiB8ID4gQXJlIHdlIG9rYXkgd2l0aCB0
aGUgbmV3IGRldmljZSB0cmVlIGJsb2JzIGJyZWFraW5nIHRoZSBvbGQga2VybmVsPw0KfCA+IHwN
CnwgPiB8IEZyb20gbXkgcG9pbnQgb2YgdmlldywgbmV3ZXIgZGV2aWNlIHRyZWVzIGFyZSBub3Qg
cmVxdWlyZWQgdG8gd29yayBvbg0KfCA+IHwgb2xkZXIga2VybmVsLCB0aGlzIHdvdWxkIGltcG9z
ZSBhbiB1bnJlYXNvbmFibGUgbGltaXRhdGlvbiBhbmQgdGhlIHVzZQ0KfCA+IHwgY2FzZSBpcyB2
ZXJ5IGxpbWl0ZWQuDQp8IA0KfCBNeSB2aWV3cyBhcmUgb24gdGhlIG9wcG9zaXRlIHNpZGUuIERU
IGlzIGFuIEFCSSwgZnVsbCBzdG9wLiBJZiB5b3UNCnwgY2hhbmdlIHNvbWV0aGluZywgeW91ICpt
dXN0KiBndWFyYW50ZWUgZm9yd2FyZCAqYW5kKiBiYWNrd2FyZA0KfCBjb21wYXRpYmlsaXR5LiBU
aGF0J3MgYmVjYXVzZToNCnwgDQp8IC0geW91IGRvbid0IGNvbnRyb2wgaG93IHVwZGF0YWJsZSB0
aGUgZmlybXdhcmUgaXMNCnwgDQp8IC0gcGVvcGxlIG1heSBuZWVkIHRvIHJldmVydCB0byBvdGhl
ciB2ZXJzaW9ucyBvZiB0aGUga2VybmVsIGJlY2F1c2UNCnwgICB0aGUgbmV3IG9uZSBpcyBicm9r
ZW4NCnwgDQp8IC0gdGhlcmUgYXJlIHBsZW50eSBvZiBEVCB1c2VycyBiZXlvbmQgTGludXgsIGFu
ZCB3ZSBhcmUgbm90IGNyZWF0aW5nDQp8ICAgYmluZGluZ3MgZm9yIExpbnV4IG9ubHkuDQp8IA0K
fCBZb3UgbWF5IGRpc2FncmVlIHdpdGggdGhpcywgYnV0IGZvciB0aGUgc3Vic3lzdGVtcyBJIG1h
aW50YWluLCB0aGlzIGlzDQp8IHRoZSBydWxlIEkgaW50ZW50IHRvIHN0aWNrIHRvLg==
