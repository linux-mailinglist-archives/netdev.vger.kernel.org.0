Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25C251B9C6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346763AbiEEIQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346838AbiEEIQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:16:51 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2118.outbound.protection.outlook.com [40.107.114.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F30247AD2;
        Thu,  5 May 2022 01:13:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlttwBxMaksY02ZpK2j+nGMF0gNZOAZ231ON/GGln28j2N1kCrjHJTIcLbaQX2PLzEpjROyQtLp2SfErZoyxpmrSUPDxF8MMjbCAYzBgYyUqN0OBYNjO6aqF0FiCfMlcNnzIvSwnxphN1l3wX5jbk2NKd4EU47UPrezXjY7cGtp3b/SGRigD4jGNwfqO4RGr3c6f8bqIdPUpJw6uHLNZmRlUNUJCzAyG6KjNgKU1amDZHyz+mDIHb7RVlmY5WjLxECEmQ7ORPK8/NFfiqP1QTZuUJg10NH+p2XZnSd1OEtOwGI5JWhjvbk6tKSdfzOTV9pEuTUQ9PLmNHAA/mx2yOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZlCzVZe1mdhIqNAJoR8X5wasgigcctQ8t0TsGivHUc=;
 b=UpuSsqWd8L9GxT+YPduOSuDbWZTyjPQYvK9QVzg3t3aKmgsgPx7hQMCbQmfsgi6jdykv0ZCz/xYPMtgVr4EHtyIEC+5NuR4dc4p9Y5AHrnu6vMODw5n13Rm9hD7jikyqEYClbX1iwhMAsaUPaWwH8pLGPQQb8wDRRF4YRS7UyW2mLvojPVVCYtMmgyIpQzDT8Nx9aH5ru83vjEO0c841rPcP0yPR91OlVSKxN4l/yrCFVDeYJBGTMZ3CTXmPzdwClx5Ic4WQPM5jBFvHY3ASxnfeLK9BPgmRvYaNE7HUAVqg6d6Nxy/QUWyEOVixwikCKRmqRuRwEbfktMqnZQpKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZlCzVZe1mdhIqNAJoR8X5wasgigcctQ8t0TsGivHUc=;
 b=L/iASSwzvy+pmVoC+eoZPBS7VdGyGfDVDQuC7IXn+jSx7O2xfluCt2/La50H2isD3/und4G5DuT5lRpBVOiUQlQSj0vb1otHkSiLw58gGan8JKQjhenPvCJJ5A98hYoSIrBbYrYHBD7fsrZ2gwjweJq1DzzqoXBS2HS+wG79koo=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by TYCPR01MB7821.jpnprd01.prod.outlook.com (2603:1096:400:182::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Thu, 5 May
 2022 08:13:00 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 08:12:59 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 4/9] ravb: Separate handling of irq enable/disable regs
 into feature
Thread-Topic: [PATCH 4/9] ravb: Separate handling of irq enable/disable regs
 into feature
Thread-Index: AQHYX8cZWnhANdQKJku9QerTN9QvTq0PIfoAgADN47A=
Date:   Thu, 5 May 2022 08:12:59 +0000
Message-ID: <TYYPR01MB7086B40F6AC987F5B4AFF988F5C29@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-5-phil.edworthy@renesas.com>
 <d260937a-63bd-e3af-a032-c0b8848a4025@omp.ru>
In-Reply-To: <d260937a-63bd-e3af-a032-c0b8848a4025@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2e7646d-55ea-42de-8dbe-08da2e6f113e
x-ms-traffictypediagnostic: TYCPR01MB7821:EE_
x-microsoft-antispam-prvs: <TYCPR01MB78217D70D9B0C477E72BD2CDF5C29@TYCPR01MB7821.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SMYQteByON8YzDKqgJ68gJbgj1OcajX/Y7x+Z934U6FW2Yv5F2FW7/qt+/5KBN9OUevVH9fbY2UtR486ZkPWUEJKw+VY6PFZgkMQ/2h0YDz4NofRxEEOmksggff4i8xotROSNgCvYlrLrhiby3CfHPtMnhtWyEitFoUNG0B3MECdhkYneNpD27cZYtlOY/poaTkAKs2xMqUesFVEFoBeDtwo3b+QekPkgHFjKjRNs7p/DMxJJozdBPFaJFLlpHvRlxJuyOh0mbkq42CSYf9scG1+YgiLM42G4amcg2QHv+HZ/EU9kXBv0qDf+Vdhp2dKGUUw2POLksLU9Bsos/yVmqszWo2RnhYaeTYVjW9Fpzqa6yNy9mXcbvqAowLpPvyVVfe2SYafE00f6mko7qlI5KbZwK6XkhcGmn/du3CBJ/cSS3Cvu3JDrA9wloKFmoRimhZKs3GTOJqTeCywt/BAhgk03EOqXFQ651ovwf6l9MYGGSaRH2TfVGuUFB2qrGmDiPFOz4oN7g6MvQa72BQW1k2t/KmSvwLbM5ZaYHuC51JsnIU/Sw0QRj0KaHkVfRyX0YWnBbPbzJalF9AywaC83l5WIHCahwPK3DjcZ4AabyULUw+7FGu5xEomQpdVNuUooa+xqbsUBcHSyCYD3VwPgIGlmcLAYgyQncMXgqgz3Rll8BuApKR7EFpWa5mDKMBdFIN7++eltC+1jg61veunDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(122000001)(53546011)(44832011)(110136005)(54906003)(38100700002)(38070700005)(71200400001)(52536014)(76116006)(186003)(8936002)(66476007)(508600001)(9686003)(66556008)(83380400001)(64756008)(66446008)(4326008)(2906002)(316002)(55016003)(8676002)(7696005)(66946007)(26005)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V05sNXMycnQ4R3cvN1V5cWJ1ZllTVklJWHBoZ3AyUEFZZVNWbUtPb3NQUlZ1?=
 =?utf-8?B?VVRTb3hDWTBadXRCNzBTZVA5RkxVNHNralBLMWs1UTMzd3lMWmUwWnZQNVpU?=
 =?utf-8?B?ei9PZUlpbVlOWjAzc05hS1M0M1RSNnZZYUdlUmhMYmRwbVZWWDlHRkNRcGRT?=
 =?utf-8?B?MzN4b0NJQVgrQXJYa09VUDNlWFNabnhCTVZySmpCaEJyRmw4ZlI5MXdsSmYv?=
 =?utf-8?B?VGsvTTlOZGRDSUc2RVlKL0tlWkFNbHI5eENCSGgyNzhDN1VuYXFiZ09KbTgz?=
 =?utf-8?B?em1lV0xhTFpOLytSWDhHMjBnSE5OTEFYNjkwNjlmUzlNaWxIekZOSldvL1E3?=
 =?utf-8?B?a1NBUGVocXdiaWRMcytiSWhrVUNwNExVMVE5UjB5cUUxRmZvcFE1eDU4WnNE?=
 =?utf-8?B?U090SGVFQjRSY2RWWlJFL1JkYVYzSlpyWFNsNjFmWktONUFzbGdlbm53TnRx?=
 =?utf-8?B?UUlPQmR5bk84RkFHRmFKeFFpNEM1bmthYVV3RkYwaHZnRXhPTlhsQ005NVkw?=
 =?utf-8?B?VTlXWC9wemUwUUxMdHB1UUFNdE1TTDFoaDE2aExid3EwMGdEYzV0TkJDa0Ix?=
 =?utf-8?B?K3o1clJxYjQxbm5hTDBVVC9nck12MFZRMWFPa2JnZmtENXdiZ1BoQUpNNDJh?=
 =?utf-8?B?L2NiblczNFVUdmNOVlJzSloyMHlXdGhPYlhXUkRkL3RqeStHcGdQU055UHJ4?=
 =?utf-8?B?RzcvOWxHQjdjcU5ZMk8vTHIxZmxoZXBZK25ScTN5T1VieUFidm13YzFlUThq?=
 =?utf-8?B?QTRJcm9QTjcyWFNjSTdjbVhQa0NDSTZDMVlNOWRMWmdyWWN5NitjRlc0U2hN?=
 =?utf-8?B?TTRQM29pc2hHam9OTDk5bWNka0ZIeThoR1NzU2QwY0FVY0JEUzVDSGlubWEv?=
 =?utf-8?B?TUpJYk50eGpGeUxPNzlFUnROeTd4SDRnb29SQjArMnRSSVMyMkhLYXluMThY?=
 =?utf-8?B?RGVrQmFFQ0IxNll2VWlsTDl0R3NYMTRYTGJaTVNVL3U1NDVxMUM5V1BmcXl4?=
 =?utf-8?B?QnE3S3kvdzIrRUtjZUFqaDdrUlRMeFAwb2IxQ2ZXcHRBOEZoMkR4elQ0VzUv?=
 =?utf-8?B?Wmt2NmxiYWdQeWdUZHlGN0t1clkzd05DSlNmM25HTzA2OUc0aWl4UFV0Lzhv?=
 =?utf-8?B?RFZIR1k4M3dwVDRyVnU0a3NxT2tXNlRFakdlczh6aXk2ZkRqUXdXVFFMMGox?=
 =?utf-8?B?T2xyY2pJUnhrcUtSYWtRZ1NoSHFzcHJtMHhuRUYvdWhTZkk3czhyS0JEYTRB?=
 =?utf-8?B?TlVCSzJvcGxuNldhUmRKTk9JWXQ0b1puc1ZOSm4vZFFhU3h4NitNU29YMGNa?=
 =?utf-8?B?RGhjYS93TmdwNUpmTDZIRmhqY3d0V2UzekY0eEpjaGYwYmIxRDFWcnI5bmd2?=
 =?utf-8?B?WkpyTmlxUlJJMjdvcVJuUHNFb0tmazNuWVJNQ0UwcUJpNzB5UXFVZmJoNWh1?=
 =?utf-8?B?dlJjbVozYUt0REtLTFAwWEtNd01va3FwK25vUnpkV3ZFQ21zVVgxcngxTVpX?=
 =?utf-8?B?YWZQOHZoVzBPbTh2YW5PcFZjMzQ5QUVkU05CSjQ5cW1STUJMZVVWODVaR21W?=
 =?utf-8?B?NWd0bllCQWhRUnFBdWRNWWwvcGM2akxkWkRJSUlvR1JkL2ZudXVoRjdBZlB0?=
 =?utf-8?B?dFFXMGY5T0tOdnppck5Cc29KamZqeWoxeUdMb1lxTFh4UndhRDdyWGp3aGVE?=
 =?utf-8?B?c2IrZVdzZmtLZGp1bUJsZDlZdlAyR2VsTkMwRjg3MmNZVXRYVDJXTVh6K3lT?=
 =?utf-8?B?bXg5ZUlsVDNrc1k0YUV1WEF5V3UzZUtCTEVpUHE4RUg5OXZWenRYSEM1emZj?=
 =?utf-8?B?NUlpVWFTcUx3bkNpeXBtVU1SZ3dFTkIveFYxclV1ck8vMkIrZEh0ajRoU29j?=
 =?utf-8?B?dUpyQVVlMCtvTTk1R1JIYVd5UGNFSFZpUjJ0ZU94VEJmZ2ZXQTZPdnRlNFZw?=
 =?utf-8?B?dWdvYkEwWWFFUlVGaDhYZWlpbmRDdkgrSGtoZTNTSjNPUG45cHc2enNCOVRx?=
 =?utf-8?B?RUdFeVl6NExqZjcvaVlaeDg4bUNPVXoySGFWSXRZN0pFR3ViZ0lpNjVFZGlr?=
 =?utf-8?B?SVNhNXZNMmZNZVBOUDE3c2Y4T3VTUkh6V0RIT2xSUTloU3NhMk0yZFJmb0VH?=
 =?utf-8?B?N3l5SEx0c2MxeCtEOXg2NlRYZkdrR0c2ZkNuVUx5RzhKUVpCUEVlT0VTUC9O?=
 =?utf-8?B?QWUvNWM0dzgyUWFKRTZ2amcvWDB3VGxPTDhqQURyVkl5V3dvSFM5Y21IMEdY?=
 =?utf-8?B?UURHTmQwVm1wSmVYS3dvWHhxNVFkclRaRzNOY2wzTHpDMkRQRk5lRkNDK0ZQ?=
 =?utf-8?B?OW9IQ0pzQ3Rjc3JHR0JOZG1QWTRZck9WdG9ublVUeSswaXZxTTFmN3hGblRX?=
 =?utf-8?Q?HU7c0lEZvflxIv+Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e7646d-55ea-42de-8dbe-08da2e6f113e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 08:12:59.1367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NhX2lMUv9OzmvGEtpEivjyAEkEyZ/cDck32VFgOyJPuy/LugzpEZ2VZsSdHhTB0LQ6gxqtNP34Wok6ojZn6asLAVQYzQG/JG13pr7kXYI7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7821
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpPbiAwNCBNYXkgMjAyMiAyMDo1NSBTZXJnZXkgU2h0eWx5b3Ygd3JvdGU6
DQo+IE9uIDUvNC8yMiA1OjU0IFBNLCBQaGlsIEVkd29ydGh5IHdyb3RlOg0KPiANCj4gPiBDdXJy
ZW50bHksIHdoZW4gdGhlIEhXIGhhcyBhIHNpbmdsZSBpbnRlcnJ1cHQsIHRoZSBkcml2ZXIgdXNl
cyB0aGUNCj4gPiBUSUMsIFJJQzAgcmVnaXN0ZXJzIHRvIGVuYWJsZSBhbmQgZGlzYWJsZSBSWC9U
WCBpbnRlcnJ1cHRzLiBXaGVuIHRoZQ0KPiA+IEhXIGhhcyBtdWx0aXBsZSBpbnRlcnJ1cHRzLCBp
dCB1c2VzIHRoZSBUSUUsIFRJRCwgUklFMCwgUklEMA0KPiA+IHJlZ2lzdGVycy4NCj4gPg0KPiA+
IEhvd2V2ZXIsIG90aGVyIGRldmljZXMsIGUuZy4gUlovVjJNLCBoYXZlIG11bHRpcGxlIGlycXMg
YW5kIHVzZSB0aGUNCj4gPiBUSUMsIFJJQzAgcmVnaXN0ZXJzLg0KPiANCj4gICAgcy91c2UvaGF2
ZSBvbmx5Lz8NClllcywgSSdsbCBmaXggdGhhdC4NCiANCj4gPiBUaGVyZWZvcmUsIHNwbGl0IHRo
aXMgaW50byBhIHNlcGFyYXRlIGZlYXR1cmUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQaGls
IEVkd29ydGh5IDxwaGlsLmVkd29ydGh5QHJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBC
aWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAxICsNCj4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDUgKysrLS0NCj4gPiAgMiBmaWxlcyBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggMTVhYTA5ZDkzZmYwLi42N2Ey
NDA2NjVjZDIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
IEBAIC0xMDI3LDYgKzEwMjcsNyBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiAgCXVuc2ln
bmVkIHR4X2NvdW50ZXJzOjE7CQkvKiBFLU1BQyBoYXMgVFggY291bnRlcnMgKi8NCj4gPiAgCXVu
c2lnbmVkIGNhcnJpZXJfY291bnRlcnM6MTsJLyogRS1NQUMgaGFzIGNhcnJpZXIgY291bnRlcnMg
Ki8NCj4gPiAgCXVuc2lnbmVkIG11bHRpX2lycXM6MTsJCS8qIEFWQi1ETUFDIGFuZCBFLU1BQyBo
YXMgbXVsdGlwbGUNCj4gaXJxcyAqLw0KPiA+ICsJdW5zaWduZWQgaXJxX2VuX2Rpc19yZWdzOjE7
CS8qIEhhcyBzZXBhcmF0ZSBpcnEgZW5hYmxlIGFuZCBkaXNhYmxlDQo+IHJlZ3MgKi8NCj4gDQo+
ICAgIFBlcmhhcHMganVzdCBpcnFfZW5fZGlzPw0KQ2FuIGRvLg0KDQo+ID4gIAl1bnNpZ25lZCBn
cHRwOjE7CQkvKiBBVkItRE1BQyBoYXMgZ1BUUCBzdXBwb3J0ICovDQo+ID4gIAl1bnNpZ25lZCBj
Y2NfZ2FjOjE7CQkvKiBBVkItRE1BQyBoYXMgZ1BUUCBzdXBwb3J0IGFjdGl2ZSBpbg0KPiBjb25m
aWcgbW9kZSAqLw0KPiA+ICAJdW5zaWduZWQgZ3B0cF9wdG1fZ2ljOjE7CS8qIGdQVFAgZW5hYmxl
cyBQcmVzZW50YXRpb24gVGltZQ0KPiBNYXRjaCBpcnEgdmlhIEdJQyAqLw0KPiBbLi4uXQ0KDQpU
aGFua3MNClBoaWwNCg==
