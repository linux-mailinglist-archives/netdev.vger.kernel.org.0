Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7475C4EDA93
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiCaNc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbiCaNcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:32:55 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20085.outbound.protection.outlook.com [40.107.2.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D4063512
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:31:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKRRA1ziUS8hUApTMdbpG31fFfyfaFOStEzvdpun60S0XFQtVgUIQztgm+8AB3B1uAPeAyitpOj8JL+Mx6nYcH7ZlowNZ13SlOYec/T74knd1rvZwyXszXV+0ctF57y3LVMrTjDo8GLYpDZsDumZgFG4BZyvh717EF6GN/fKUDvtZOuXy8vnhvNT4ZDYvQIy3jIJ9x9SW2oMDz7zP99s/9iy/9Xkr0B6ZwLNXcTDUt8B9b1cX7AyCMlBY3GyPDSvrRlD6UInXmIdkCuEJWB8G5WDrDHUD93v5sPmCHO/cKM+qi9MG0EPv5H+Pa+PnoBKCIZci7DZ55eT8O9/X+UD5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gs0vjGDHO4c5+5mTp3yPQBm4m/laR2k1afmIsfMEv9Q=;
 b=H6wx47gJbtItXhyzNcv3q8y2wJAbGCfWXOlnJdGOiG26acoyeeHYuWyaM9CfgwjlWajk/90xIMEN4sdWAsCIvVmGCrdSG5PdhFLBzEPkSQi5F1uOtMhtat3XG0LEjKhWgI7ypZFEncMNRUHsrEe9x5HggIyxO4iCwA33jz6q7D7KEzzPWiHSFwntckIeiKFrlHQyTTMcHpM+igBL651voOOaFm/OeDltr0qoOUcB0kJg3rDqGMUjNp89ht9yfBUbNF5fW8f7oiEE4dhtuohJUqO6ohNXWTZWx1WNOXpN9ClgFw6y+ahN+JavJAEuQeboFFnBJS/X/XGtosi50lBFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gs0vjGDHO4c5+5mTp3yPQBm4m/laR2k1afmIsfMEv9Q=;
 b=G/IOUZKR7Bn+BbV2+apil/BhecFvsVF0rW0nlxL3dAHnQRLF/YQO8+j9ldmY+8b6onB1Z2uoI7Ff7xCpJ1NSkfhXUCZ4F4HQXpzeFP1oSdjGaz1tGnGVvJogpU8/izaVFgpODPszn7tzlr8l0Dsp/FPu+locn8/BAgFvhAt70a0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6518.eurprd04.prod.outlook.com (2603:10a6:20b:f8::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 13:31:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e%3]) with mapi id 15.20.5102.022; Thu, 31 Mar 2022
 13:31:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <ALSI@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 3/6] net: dsa: stop updating master MTU from
 master.c
Thread-Topic: [PATCH v2 net-next 3/6] net: dsa: stop updating master MTU from
 master.c
Thread-Index: AQHYAomUg049RxI4PkmdoakqvhrUHKzZgksAgAB/xQA=
Date:   Thu, 31 Mar 2022 13:31:05 +0000
Message-ID: <20220331133104.jmhciszvxha2l4aq@skbuf>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
 <20220105231117.3219039-4-vladimir.oltean@nxp.com>
 <CAJq09z5PccRNoE8LZ=Ose--zGCVRRGvmp1Lb6NWh7rZHnHjznA@mail.gmail.com>
In-Reply-To: <CAJq09z5PccRNoE8LZ=Ose--zGCVRRGvmp1Lb6NWh7rZHnHjznA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adb21342-b4b0-4746-4d8b-08da131ab539
x-ms-traffictypediagnostic: AM6PR04MB6518:EE_
x-microsoft-antispam-prvs: <AM6PR04MB65182506D2E2E7AB735D05ABE0E19@AM6PR04MB6518.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nG87ceCDkiHXwmMaRIrdWWy2Zy5xmGGoouJ3K8mofXPAUMi85450Ha9aObNzwTqXmDczeFKeK+AnXPSTov4SqgAXp2Pj/ODoxuGgwpFhhiE+Cmp2U2VXsxmej0DnPobLW0Ahy3Zf9/vjEf+wyGZnpLKMvcGvrqzisE6x99aBnC0RJlxSBb6ZE02nEoOvpSxR1V9bcETolVIxewMWnEpw69uu0PqhnqctWjWeBPhPL+VRiEujFl1Qsjz7+OYSACGVbySyncyNcjSYHWpW8FeyivZ1LN6cRXtOsXtqLdODlZQWPZ5TniGTWSL9YMnfOPqTUTvtrDwWWs4OChxqGSmKswtA+v0Zd+t20F4zmnG92KrnxCTtTiBIgfv7OHJAGUj1a63caeTRRHS1BtsTf6ldTKwGVXKbRry22Uufdl+OLRo89FSIKZbPxdejpSeLo+cm1AXwdOIr8plJ3zNnnsyOcXCGuKMXIwU4hfDhuNxK8tqYZQ0mcUGkK6l/2/DGK80zv1uuGrTVY7AFt3eNhKMP19UTpmnZ2aYSQGF8a3rr/E9gYTBuq9VZPD+Ep+9IVPefZrcbfUV50molsUao65OvULRpnPyXgN+Z6oipnvuo+txEBSNtWxJ8EBSGvDI/HKVC168heDWorg88bUOS8e0E2obEJEHEgtGV9xbcYb/Jj9+EIQiX8P32VMupSfuwKVKrxZzi7ZjyRr4j3JgTLDrEY+j6/Q9qA4+rKQWd/PPc9T1GepLlm4IvhVmylfHGf4vZJuN/tD9BtmsuXRkOBrb1rdfUgItLOc4asSmMcLuqhwE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(122000001)(86362001)(2906002)(316002)(6916009)(54906003)(6512007)(6506007)(38100700002)(38070700005)(66476007)(9686003)(71200400001)(83380400001)(44832011)(66446008)(64756008)(26005)(4326008)(33716001)(5660300002)(8936002)(91956017)(1076003)(8676002)(66946007)(186003)(76116006)(66556008)(966005)(508600001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?cUtkK0VtVi84dmV4cFpNaWI3TDFCZSt5SlpzSU5sOG85UjlINTA0b2Jmano0?=
 =?gb2312?B?eVpxRHFWbGJ3RnRlblBwQzRFYzVoelJZcjgrT2dMTnRNUDN3SzhadlVKYi9Z?=
 =?gb2312?B?SFZyV20rMis3aTJ3NVJxYjFvYWxnNW8rSEhWYm9BQ3ZVWDVWU0FiWU1INk1E?=
 =?gb2312?B?MW5WRDcxSlRsMGlvMlJJVmViMm9ra3dsK0E3U3kvb3JCN0Z0YUEzMHI4bUw3?=
 =?gb2312?B?a3ZKNy93a3gwY3FtU3VxRkhiM3NBcW1EZHczclZSRDdkcTdYYmFXUnB3L0Uv?=
 =?gb2312?B?YnV1NDZmRkdGZHdON01CTldxSVVMVzVSa2ZrSFB4bDFFZGYyaEVwdkE0U0ps?=
 =?gb2312?B?d08vQk1yMVZxb3lmdmdiMG43Z3p5Y0RUUlNvV0RjeURXN1h4eGFtZ0svRHUy?=
 =?gb2312?B?ejZXbmRBVFh3R2w4WkFkQ1lpV2lGbnJnTWZKVFl3VEZhRXFoQVZWOW9ZOEVP?=
 =?gb2312?B?V1ZPZnBZZExBUU1aM2hCb0h0THllR2VnMUxpaEhDa3MxOTdVOS9qOThvRjY4?=
 =?gb2312?B?VXMrRC9HK1dQWVpaNWV3TytaaWRxTVRUTkRDK1VQRlRFRDNiZUtMR0V2NTdm?=
 =?gb2312?B?Rm04dW1sWGJha0hneXpjSFBzSklnbWFBR3hGQ1U5VC9IdnovbWJIeXhNanI0?=
 =?gb2312?B?TVFyODVyRXVPenQraGJ1Yk9EdWM1b3cwQm5QaW04d1hUYkdDTTRCMkFkR0gv?=
 =?gb2312?B?VTNXazQrWVdkdDJRQU5qVmlxSmRRamFuaG5WekEzM1hhNFNTNWVyT014Q2VU?=
 =?gb2312?B?NERtYkZyYlg4OVBva2ltdDRDWW5jeHNNdDU5cXJzYUNram1qWU01KzBwM0d5?=
 =?gb2312?B?bHFPelRpQ3BaT01ESURxVVpUaTdrM2hyMGI0TlQ0MVFVdFlCdmJzREtjQ042?=
 =?gb2312?B?RzVLQnpxeTVTNWk5bUl0Y3dXampLT1FpRmRPZHRWWTcxWXIzVVkzbWFEanVN?=
 =?gb2312?B?ZWtSUVppV3RGMG84NWhzQkgyTFBSSWQ2L3BZMEs2MGhlVk14amgyalVtc0FK?=
 =?gb2312?B?UVlkVjQ3VjRObHg5TnJZeFowakdqTk91VjJZYmFGcDR4TnFYN0RYdlFhLzJw?=
 =?gb2312?B?NFFzemVSL3dCTlJteE85WmNJbVBqSTc0aFVwVWRFUUZCbDR2ZlZRa2I1dlNB?=
 =?gb2312?B?aFpxWWl4bm5iTEp5bExSbTNZVXM3MGVLRXVxT2NPT1JFMTNtTmJxZk5PaWpz?=
 =?gb2312?B?dGphN2lHVzZUdWpEc09TQ1lOOUg0emJxc1BkQW4rdUM0UCtnakwvUXRCL3Rw?=
 =?gb2312?B?eDZ3elhhSWl0ME56WHc5MnpQOEJHd2p3RWpCY2RGajkvU2l0TEdMYWZkNTJO?=
 =?gb2312?B?akxtazE1RDFIVFhhYWN5TERFRlkvNnU5MCt4clhUMVJEVGlpTmpkWVAxQXZP?=
 =?gb2312?B?L0N5L1JQWnJIaUhQdXhnbjd5bXBPakVhVmowcWk3d2ZzM29Pd0hSMWxHWElp?=
 =?gb2312?B?bTluU2VSVDdESTNIbFdUbE1lQk5ITWlmUmRVdXAzdVZrOTZEaURiSHZyUG9W?=
 =?gb2312?B?bVliYnFnL0g3ZFBteDRiYkdjODVwdXRWaG9Wc3BZeFowZnFRWS9rWWZQeVBC?=
 =?gb2312?B?M1BMNnl0NkFFd0lmSFhuYU9temRNVThkVUpTclhhR0E4TllPUEp6SDVDbHJ5?=
 =?gb2312?B?MkxmVS90QktjSVQzbndHL0NtZkcxMVRaYXc5b0FtejVTYnRFWk4veHhYMWlU?=
 =?gb2312?B?NmZIUUJLdXBVK1p4WG1Zb3ZaOEkzU1c2MStremRBZ0tXV2hSYSswWkhHUURL?=
 =?gb2312?B?Ri9HZVBJbjA2QlpSb1RXYVBSOEhJSGJkaDR4VG9oSjlsTW5MYTdsZGo3cU9Q?=
 =?gb2312?B?aXNSYjd5UmFkelVJTk5UZy9mWEZIR2VVSHRFN0FFaC93OFJzNGZUZlYvbWx2?=
 =?gb2312?B?Umhzd094RTdSN3ltdVRXK3BtUDNIQms4OGVVRU5qdE1lSnN4N0JYUEpncWlM?=
 =?gb2312?B?L1FYSTFpTzdwL2hVb2l4aWU2aUcvU2RBeEljTml6S01jbXR2WkVKbE5hUGdH?=
 =?gb2312?B?NnZLSXpEVnpiOFR5QnVJdytoYWlLYXd1WTFhaVZuWlFyWFUzOEFQQ2Q0SEFI?=
 =?gb2312?B?L3J3MHF4bmduYXFRUHV6VXhxakExNEhENGVDL1UxQWlwd0VJb1lVZkpEb2kz?=
 =?gb2312?B?TWNnYUxTQVhPRklsNHVmZnF3eFV3cGJ6YWcxUE9nbzdlOUVEemU2YTJCZkxS?=
 =?gb2312?B?ZEd6L2V6K1JVQnp4cFJKNVhRQkNSMjU4Q3haOG9SeDdidzZwSDYyNjdxWFQ1?=
 =?gb2312?B?ZEg3a1VVOHFyZHRaQkQxNERKL04veGxaU0loREdTWjZ6elVPODBwUDZFUkta?=
 =?gb2312?B?ZVRKclZDUU00QjhYcWlLRGJCbVVTcVBCMzJIRGkzZHdoUmJjS21UdkFtUDFB?=
 =?gb2312?Q?5hsl2uprqRLxADT4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <896D4E8E47CABD428C52FA50168B7DD0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb21342-b4b0-4746-4d8b-08da131ab539
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 13:31:05.5918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ofDyMX2x4+80CWhSwCRmV5ICLgkNegeb7nGRlXR4l7uf0xU54ZvJy9vhjRg05IFydi7nT8T7msiV/xm0WhUl0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6518
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBNYXIgMzEsIDIwMjIgYXQgMDI6NTM6NDZBTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gSGkgVmxhZGltaXIsDQo+IA0KPiBJIHRoaW5rIEkgZm91bmQg
YW4gaXNzdWUgd2l0aCB0aGlzIHBhdGNoLg0KPiANCj4gPiBBdCBwcmVzZW50IHRoZXJlIGFyZSB0
d28gcGF0aHMgZm9yIGNoYW5naW5nIHRoZSBNVFUgb2YgdGhlIERTQSBtYXN0ZXIuDQo+ID4NCj4g
PiBUaGUgZmlyc3QgaXM6DQo+ID4NCj4gPiBkc2FfdHJlZV9zZXR1cA0KPiA+IC0+IGRzYV90cmVl
X3NldHVwX3BvcnRzDQo+ID4gICAgLT4gZHNhX3BvcnRfc2V0dXANCj4gPiAgICAgICAtPiBkc2Ff
c2xhdmVfY3JlYXRlDQo+ID4gICAgICAgICAgLT4gZHNhX3NsYXZlX2NoYW5nZV9tdHUNCj4gPiAg
ICAgICAgICAgICAtPiBkZXZfc2V0X210dShtYXN0ZXIpDQo+IA0KPiBUaGUgZmlyc3QgY29kZSBm
cm9tIGRzYV9zbGF2ZV9jaGFuZ2VfbXR1KCkgaXM6DQo+IA0KPiAgICAgICAgIGlmICghZHMtPm9w
cy0+cG9ydF9jaGFuZ2VfbXR1KQ0KPiAgICAgICAgICAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7
DQo+IA0KPiBTbywgd2hlbiB0aGUgc3dpdGNoIGRvZXMgbm90IGltcGxlbWVudCBkcy0+b3BzLT5w
b3J0X2NoYW5nZV9tdHUsIHRoZQ0KPiBtYXN0ZXIgTVRVIHdpbGwgbmV2ZXIgYmUgdXBkYXRlZC4g
VGhpcyBpcyB0aGUgY2FzZSBmb3INCj4gZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1i
LmMuIEJlZm9yZSB0aGlzIHBhdGNoLA0KPiBvcHMtPnBvcnRfY2hhbmdlX210dSB3YXMgb3B0aW9u
YWwuIFdlIGVpdGhlciBuZWVkIHRvIHR1cm4gaXQgaW50byBhDQo+IG1hbmRhdG9yeSBmdW5jdGlv
biAoZXZlbiBpZiBpdCBpcyBhIG5vLW9wIHRoYXQgZmFpbHMgd2hlbiBtdHUgaXMNCj4gZGlmZmVy
ZW50KSBvciBjaGFuZ2UgdGhlIGRzYV9zbGF2ZV9jaGFuZ2VfbXR1IHRvIG9ubHkgcmV0dXJuDQo+
IC1FT1BOT1RTVVBQIHdoZW4gdGhlIG5ldyBzbGF2ZSBNVFUgZGlmZmVycyBmcm9tIGN1cnJlbnQg
c2xhdmUgTVRVLg0KPiANCj4gUmVnYXJkcywNCj4gDQo+IEx1aXoNCg0KVGhhbmtzIEx1aXosIHlv
dSBhcmUgcmlnaHQsIEkndmUgc2VudCBhIHJldmVydCBwYXRjaCBoZXJlOg0KaHR0cHM6Ly9wYXRj
aHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8yMDIyMDMzMTEzMjg1NC4x
Mzk1MDQwLTEtdmxhZGltaXIub2x0ZWFuQG54cC5jb20vDQpNeSBvbmx5IHByb2JsZW0gd2l0aCB1
cGRhdGluZyB0aGUgTVRVIGZyb20gZHNhX21hc3Rlcl9zZXR1cCgpIHdhcyB0aGF0DQppdCB3YXMg
dGFraW5nIHJ0bmxfbG9jaygpLCBidXQgaXQgbG9va3MgbGlrZSBJIHdlbnQgdG9vIGZhciBieSBk
ZWxldGluZw0KaXQgZW50aXJlbHkuIEkgcmVzdG9yZWQgdGhlIG9sZCBjb2RlIHN0cnVjdHVyZSwg
d2hpY2ggc2hvdWxkIG5lZWQgbm8NCmZ1cnRoZXIgY2hhbmdlcy4=
