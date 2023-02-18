Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397BE69B79F
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBRB71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRB70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:59:26 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38936745E;
        Fri, 17 Feb 2023 17:59:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ3hsFcSpiH8wsOpnaxjyaJnzBARnBJ4eDs4drCj5C3DF6YO4odnnKLKe2FO1cDwq02fNsSfK7u1mQ/Le9MsB/ouE2v/5pqypsD/4D7pS7dlYOkbBxPJjIR0VG9QgECxtQ0JzNnjlSSCFpGsWSM9NlngR8pTOprcyKPCY+T1Q9XfdB4ZBmprZjgACUZYr9rETCp06VAneAsMWxQhOgoTFz3MGHWycGKrcHr0FOawMnou3Kl2r6p2qBzWiuyAb9iQ/TEIAT6muy9NlogIBmtz5x7DB+E1rUobMIDXZHSHp+B07HJBoCnUXMXHmkxi15bfdA7F5bW8RcRzbFSihbEyEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xf/4WSs2K7MJFXK/Jgh8Jx5uEgXlr5+NQKgg9YmcWcY=;
 b=gOZTHxw9bWKizzFpK49eNvYQpioBh3vftggmr+CWt/cQomv1NfYTd7MhKaqag5nFfwftvlv+QgnA9oRnYPkXgDJJiAIoTT5Kt1ipYcMZjsQO6FsXFNYihkxN1u1O1DA4EBPrHyZ0T9KqcwHaYPKbLa8GmxrYo/aIDeXzZL7D9aQYOVyNJTWncNplIIfI9Vbv6IzfDqcsQ6+SXMcPc/qDScyvKcWg4AJgS4pQ8ty/+LEAgJOGIHsOdd20T4uYe4dyqhTuYPEJ69QI01pf3KiaA1GToaamLQM3uMHYRVnnrEBxkSGBwxqa5mXy8BoGI98fhLueMAQWOcESg6rhVvV1VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xf/4WSs2K7MJFXK/Jgh8Jx5uEgXlr5+NQKgg9YmcWcY=;
 b=LK8YFxmn470YeWEk7wuE2uB+ZlgCeX4okDpQ+8Curnzkh9x7TsOl96QxmMQ0In1lQgpfN2RgfXuvB5hEwdSUzud5q6J559DJgwDEpOBiIgBRzSwbMkDxgMXeBdUmfFL/0Sq0cILtUikWnNrz47A/hJ4Uk055jUz7ilCjWSi+8Rk=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DU2PR04MB9082.eurprd04.prod.outlook.com (2603:10a6:10:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 18 Feb
 2023 01:59:21 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6111.017; Sat, 18 Feb 2023
 01:59:21 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Index: AQHZP44WIaasQ+1ZZ0O2FaaW5aXAcK7NCrmAgAAEr4CAABcEgIAABoCAgAEHe7CAAE3BgIAC96rQgAJ0JoCAAATfcA==
Date:   Sat, 18 Feb 2023 01:59:21 +0000
Message-ID: <DB9PR04MB8106C0ADA70B24BFCF9D2BD988A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com> <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com> <Y+p8WZCPKhp4/RIH@lunn.ch>
 <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Y+uamTHJSaNHvTbU@lunn.ch>
 <DB9PR04MB810629C2CEB106787D6A2B8C88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Y/Amx27oh9Z1uMSp@lunn.ch>
In-Reply-To: <Y/Amx27oh9Z1uMSp@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DU2PR04MB9082:EE_
x-ms-office365-filtering-correlation-id: 15ed3845-8af4-4fd2-9126-08db1153c0d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GCTKIlaGVR0m00PWIZLSBBmtlnSvpAG9m5oL/koScA1h/3B9anr9B4cbjYXgKs6gQftjPcH6vuKtntG14a8t2vjcMIzk/N2JFnKjmy3mzXAydhwcGuy96f4W+mgwa3PZD1Iib6pyQ2YH3e42ljow9wCD09COJzMXArtGB9LEArdRqTDCuQ28OB4m+s2KvdFdTTAKrfN3bI+u8sqDKsrZ3wYcZKZrFHlgT+ERpFxcjDslGai4zkpga7H88+dNdRuP6c/YLMIHAdR5g1PTg67HvrhiqIFwgtJu07/4L8aPhC9Vip0AanvYLhb7RpQRhMo4JSIGSAy2Xxpdc+d613aZ1cE0bGKhAk9ZOlDuoC49xxAgLNG8+xXBmaDnh0QnJcumi/AEEJppkzzQbPv7AmHNc6ezFyi4/8JQKhjqqau7fe9RmkqDOG1CLzNp3NuyjmpIex+hmQ8MDrtpz6C1/eDHKdJBBFXp+FNdqqaheRJC+JGN236Ypcirzy4XsWiyifZXZtflkBhMFr0Zfk+eJPcRrfQ6kzMnCFuywiTTT45C3aNQdFYlTyngsB0MxdZkDgs1B7TIsZK+BA2O7T46FB3bjMyX6gyUHw+x0g+PmaXqtYAKXFKZ2DLdAPLG/T9DJvVGGlafpwTL/HKIEzDQ/ng2oHxQ/rtBgjwakQGjPzCdsVGewOW8TnCsCH/C8MMYheOBtkG/saqHfjy00+KLID1+og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(9686003)(2906002)(122000001)(38100700002)(44832011)(38070700005)(66946007)(83380400001)(33656002)(4326008)(6916009)(66556008)(66446008)(54906003)(66476007)(8936002)(316002)(52536014)(41300700001)(76116006)(64756008)(5660300002)(8676002)(86362001)(6506007)(478600001)(7696005)(71200400001)(186003)(26005)(55016003)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?TUVyUjlsMWM1enNSMUlPdVdlaTFiVUxsOTErV1lPVWIrdUdrQlJPN040VSty?=
 =?gb2312?B?S0dNVndMNlZ0ajYwb3BoTWNQMmNsYnh1MHdaNURURGF2UlpLRmxROWJsK1l4?=
 =?gb2312?B?aVNVaWZMdjcyS0k2ZVZGYktQRy9kaFFaR1o0TlBVb2h0WVVaR0FsTFhSUUdn?=
 =?gb2312?B?SEJHZmNCbnNrOFRzSjhaNmtrenIwblFZM0pKcDlucFhiaDgzR1d4ODI4cXhZ?=
 =?gb2312?B?b0NOMlRlR1pNZjVGTXVGL2kyYk5NUm8rS3hLQXBDaEEyR2cvVGNmQXhMUVpG?=
 =?gb2312?B?STFYa0xKd3pCRVVwQnBjNERhbERTRjBrZ3lxdHFVc1dYYkxsZTIzRjVMSy9R?=
 =?gb2312?B?SlVkNEs1Qkl1Q2hBSTdJcS9QWVVuUXVHVEc1WStXZzErb2RNVDRIUWxJd1Jk?=
 =?gb2312?B?SCt1TlAyeUN6dHRPZGd5T3UvYTdnZ1g0TlBpOTVac2ZkY1o4QTNBQkdmbFFy?=
 =?gb2312?B?SE5zckswMkYydHVYL2IvMDNqK3ZoUWZqeUtiYVVYcDZvMlJ0bmsrd25QaE01?=
 =?gb2312?B?T2VzVDlxSUF5YTVSWGZrYlZleXVjVU1FWXAxN2hqT1ZvM1JFdXRoT2dxZ1pk?=
 =?gb2312?B?citBN245SWt5bFRJT3ZwUERnTEFoV2I1MzFKZkFwME1GYmhDOHRwYlV4SVBN?=
 =?gb2312?B?UTNZUW1vMytQWkFRdHJrYjlaQ2FscXY2akxrNW05SVFOVUtSMm9VM0U4T3JS?=
 =?gb2312?B?ZDNKR1hRR0NlVXM1QndxcUU5amlSTS85bTVqS3ozS1Y2cEJWK1djejd1aWlU?=
 =?gb2312?B?QUxUVk5zeUJzcWFUdHBzQk5ZLzExbkNsYzJVUTJtclZiT2pRMkNNSzhCZnJT?=
 =?gb2312?B?VFJvVFMyWDJJUldHV2FMOFU5THNsdTRnU1hlRXZJTWdwNW1sV3pvZDU4MUFO?=
 =?gb2312?B?QzdTYllmMTlieGNJb08rSXJDR1N6ZEpsNVJtRDFTVjRjNjlEMDl3dlhYWW5j?=
 =?gb2312?B?bjdHY3AzZ1d2N01QTk9Ebm1vbWhPZ0RlekJwdEhpeVlGOHF2SWc4Z2xwcUdx?=
 =?gb2312?B?QitEaWNTTitPbHU1aFVwVEJsdjR2RlNKcFJwalNFRGVOVWQwbDVsQXh5ekdH?=
 =?gb2312?B?cW8ycFFwWElYVUpSdFh2YjhSQ1llSXFRK3dmakM0ZEZ2MmRrV3BqdlllaW5o?=
 =?gb2312?B?bEdOMWIxcnhXQStNaGRFK1ZicHU3cXRyTGYrWkFyclkyZkk5K2tpa0p4R0xI?=
 =?gb2312?B?MUc1NVVZTXpvM0ZqdzdJR3Z3UEFkT25rWDNQeFJURWh5WXREQ2VFcWxhUXlm?=
 =?gb2312?B?RGNnZzlBRnFDWTdBWHpIdStWR0t6bzZudGI0MzgxNTRJL2RXNTdzdk4xWlFh?=
 =?gb2312?B?cG8wSTNZZGdSTmF4eU5WOUZTa1BESmZEMGhuYzJmemhFV2szQjdoWklXa3A2?=
 =?gb2312?B?azQybXdueE1BSUlZSXZjZ3l4L3pnVzNFdm9leGZOY0M5QzVzNlBUMlFtZFRS?=
 =?gb2312?B?bmE1Y0p2WTJ1cThNOUZWcEE4NE5XdEFyWUl1UzRjVUgvbzdFemF4b1Z3NWlT?=
 =?gb2312?B?ejRxS2JFTHZqMUlCTlpYdUhlRnFqczFXM1BvU1BWbUF5Wk9icHYvd1ozaURV?=
 =?gb2312?B?SEtiR0h6NGRvaWxXTUJoOTJVNHNBWkdOS0pxT29iK3ZTUjhzQ0MrSGJVK0NH?=
 =?gb2312?B?UkJyNEowTEMySjhmZzBsaHAyNXYybUpVMkxzSzVzNXhIRWw2WFRXaUUxUVRj?=
 =?gb2312?B?MTdlNVAva0syOGdRU0lTNDBIaGVnMnVzZ0ltNUVac1Q3K21waG05TTlvV3B0?=
 =?gb2312?B?cGFUVzhQUHlNVEZRbmdmMmQ0cEZJSksvR3pFd2dnY1N5b1Z3QkFGbDVHbUtT?=
 =?gb2312?B?cFVxa0E4KzBhUkg4ajBNRjFOMmlMK0tvV3hRR1RKbXdZSitTdW4rWm5XNXJG?=
 =?gb2312?B?QitTazZORHlnY3F0akhaakpyeFRYYVNPajNQeEpMaHo3c21LVFo4YnZsRTBX?=
 =?gb2312?B?SW9rSmxYNVh2NFNyZkpjblpQdDhNRW9ycHk5Y3RHMnpnRUlRbkVFNWIzV3pR?=
 =?gb2312?B?ZWRjWTlGNGRWRDIyb1UvcDBBa01ORm5HMGh1azFhRmZsMUVMQ1N4NElWNWlH?=
 =?gb2312?B?MTlkMmMwYVhwRm1mMDJsTGZVK2hHNW1QS0VFWUwyRzMwdUZVMTBoUm1Cam5X?=
 =?gb2312?Q?Qdkv1+1QIUo6nOfIznZ31cDbm?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ed3845-8af4-4fd2-9126-08db1153c0d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 01:59:21.8277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EgtzI9Ar4yrHxDYB0cvf0ezc90To3p/7r/KAPhr8FDnm2XLZDP/LXt2DSHaPN6VkJ7LQCeBCKG+rxu8TFIuI1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IDIwMjPE6jLUwjE4yNUgOToxNg0KPiBUbzogV2VpIEZhbmcgPHdl
aS5mYW5nQG54cC5jb20+DQo+IENjOiBBbGV4YW5kZXIgTG9iYWtpbiA8YWxleGFuZHIubG9iYWtp
bkBpbnRlbC5jb20+OyBTaGVud2VpIFdhbmcNCj4gPHNoZW53ZWkud2FuZ0BueHAuY29tPjsgQ2xh
cmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
ZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNv
bTsgc2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4g
ZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dF0gbmV0OiBmZWM6IGFkZCBD
QlMgb2ZmbG9hZCBzdXBwb3J0DQo+IA0KPiA+IEkgaGF2ZSB0ZXN0ZWQgdGhlIHB1cmUgc29mdHdh
cmUgQ0JTIHRvZGF5LiBBbmQgYmVsb3cgYXJlIHRoZSB0ZXN0IHN0ZXBzIGFuZA0KPiByZXN1bHRz
Lg0KPiA+IExpbmsgc3BlZWQgMTAwTWJwcy4NCj4gPiBRdWV1ZSAwOiBOb24tQ0JTIHF1ZXVlLCAx
MDBNYnBzIHRyYWZmaWMuDQo+ID4gUXVldWUgMTogQ0JTIHF1ZXVlLCA3TWJwcyBiYW5kd2lkdGgg
YW5kIDhNYnBzIHRyYWZmaWMuDQo+ID4gUXVldWUgMjogQ0JTIHF1ZXVlLCA1TWJwcyBiYW5kd2lk
dGggYW5kIDZNYnBzIHRyYWZmaWMuDQo+ID4gUmVzdWx0czogcXVldWUgMCBlZ3Jlc3MgcmF0ZSBp
cyA4Nk1icHMsIHF1ZXVlIDEgZWdyZXNzIHJhdGUgaXMgNk1icHMsDQo+ID4gYW5kIHF1ZXVlIDIg
ZWdyZXNzIHJhdGUgaXMgNE1icHMuDQo+ID4gVGhlbiBjaGFuZ2UgdGhlIGxpbmsgc3BlZWQgdG8g
MTBNYnBzLCBxdWV1ZSAwIGVncmVzcyByYXRlIGlzIDRNYnBzLA0KPiA+IHF1ZXVlIDEgZWdyZXNz
IHJhdGUgaXMgNE1icHMsIGFuZCBxdWV1ZSAyIGVncmVzcyByYXRlIGlzIDNNYnBzLg0KPiA+DQo+
ID4gQmVzaWRlIHRoZSB0ZXN0IHJlc3VsdHMsIEkgYWxzbyBjaGVja2VkIHRoZSBDQlMgY29kZXMu
IFVubGlrZSBoYXJkd2FyZQ0KPiA+IGltcGxlbWVudGF0aW9uLCB0aGUgcHVyZSBzb2Z0d2FyZSBt
ZXRob2QgaXMgbW9yZSBmbGV4aWJsZSwgaXQgaGFzIGZvdXINCj4gPiBwYXJhbWV0ZXJzOiBpZGxl
c2xvcGUsIHNlbmRzbG9wZSwgbG9jcmVkaXQgYW5kIGhpY3JlZGl0LiBBbmQgaXQgY2FuIGRldGVj
dCB0aGUNCj4gY2hhbmdlIG9mIGxpbmsgc3BlZWQgYW5kIGRvIHNvbWUgYWRqdXN0Lg0KPiA+IEhv
d2V2ZXIsIGZvciBoYXJkd2FyZSB3ZSBvbmx5IHVzZSB0aGUgaWRsZXNsb3BlIHBhcmFtZXRlci4g
SXQncyBoYXJkDQo+ID4gZm9yIHVzIHRvIG1ha2UgdGhlIGhhcmR3YXJlIGJlaGF2ZSBhcyB0aGUg
cHVyZSBzb2Z0d2FyZSB3aGVuIHRoZSBsaW5rDQo+IHNwZWVkIGNoYW5nZXMuDQo+ID4gU28gZm9y
IHRoZSBxdWVzdGlvbjogU2hvdWxkIHRoZSBoYXJkd2FyZSBqdXN0IGdpdmUgdXAgYW5kIGdvIGJh
Y2sgdG8NCj4gPiBkZWZhdWx0IGJlaGF2aW91ciwgb3Igc2hvdWxkIGl0IGNvbnRpbnVlIHRvIGRv
IHNvbWUgQ0JTPw0KPiANCj4gSWYgeW91IGdpdmUgdXAgb24gaGFyZHdhcmUgQ0JTLCBkb2VzIHRo
ZSBzb2Z0d2FyZSB2ZXJzaW9uIHRha2Ugb3Zlcj8NCj4gDQpObywgYmVjYXVzZSB0aGUgY2JzIG9m
ZmxvYWQgZmxhZyBpcyBlbmFibGVkIGluIENCUyBkcml2ZXIsIHVubGVzcyBjb25maWd1cmUgY2Jz
IG9mZmxvYWQNCmRpc2FibGUgd2l0aCB0YyBjb21tYW5kLg0KDQo+IFRoZSBpZGVhIG9mIGhhcmR3
YXJlIG9mZmxvYWQgaXMgdGhhdCB0aGUgdXNlciBzaG91bGQgbm90IGNhcmUsIG5vciByZWFsbHkg
bm90aWNlLg0KPiBZb3Ugd2FudCB0aGUgc29mdHdhcmUgYW5kIGhhcmR3YXJlIGJlaGF2aW91ciB0
byBiZSBzaW1pbGFyLg0KPiANCj4gPiBJIHRoaW5rIHRoYXQgd2UgY2FuIHJlZmVyIHRvIHRoZSBi
ZWhhdmlvcnMgb2Ygc3RtbWFjIGFuZCBlbmV0Yw0KPiA+IGRyaXZlcnMsIGp1c3Qga2VlcCB0aGUg
YmFuZHdpZHRoIHJhdGlvIGNvbnN0YW50IHdoZW4gdGhlIGxpbmsgcmF0ZQ0KPiA+IGNoYW5nZXMu
IEluIGFkZGl0aW9uLCB0aGUgbGluayBzcGVlZCBjaGFuZ2UgaXMgYSBjb3JuZXIgY2FzZSwgdGhl
cmUgaXMgbm8gbmVlZA0KPiB0byBzcGVuZCBhbnkgbW9yZSBlZmZvcnQgdG8gZGlzY3VzcyB0aGlz
IG1hdHRlci4NCj4gDQo+IEl0IGlzIGEgY29ybmVyIGNhc2UsIGJ1dCBpdCBpcyBhbiBpbXBvcnRh
bnQgb25lLiBZb3UgbmVlZCBpdCB0byBkbyBzb21ldGhpbmcNCj4gc2Vuc2libGUuIEdpdmluZyB1
cCBhbGwgdG9nZXRoZXIgaXMgbm90IHNlbnNpYmxlLiBGYWxsaW5nIGJhY2sgdG8gc29mdHdhcmUg
Q0JTDQo+IHdvdWxkIGJlIHNlbnNpYmxlLCBvciBzdXBwb3J0aW5nIHNvbWV0aGluZyBzaW1pbGFy
IHRvIHRoZSBzb2Z0d2FyZSBDQlMuDQo+IA0KVW5mb3J0dW5hdGVseSwgRkVDIElQIGl0c2VsZiBu
b3QgZm9sbG93cyB0aGUgc3RhbmRhcmQgODAyLjFRYXYgc3BlYyBjb21wbGV0ZWx5Lg0KV2Ugb25s
eSBjYW4gcHJvZ3JhbSBETUFuQ0ZHW0lETEVfU0xPUEVdIGZpZWxkIHRvIGNhbGN1bGF0ZSBiYW5k
d2lkdGggZnJhY3Rpb24uDQpBbmQgSURMRV9TTE9QRSBpcyByZXN0cmljdGVkIHRvIGNlcnRhaW4g
dmFsdWVzLiBJdCdzIGZhciBhd2F5IGZyb20gQ0JTIFFEaXNjIGltcGxlbWVudGVkDQppbiBMaW51
eCBUQyBmcmFtZXdvcmsuIEl0IGlzIG1vcmUgZGlmZmljdWx0IHRvIGd1YXJhbnRlZSBzaW1pbGFy
IHNvZnR3YXJlIGJlaGF2aW9yIHdoZW4NCnRoZSBsaW5rIHNwZWVkIGNoYW5nZXMuDQpJZiB0aGUg
bWV0aG9kIG9mIGtlZXBpbmcgdGhlIGJhbmR3aWR0aCByYXRpbyB1bmNoYW5nZWQgaXMgbm90IHNl
bnNpYmxlLCBJIGNhbiBvbmx5IGdpdmUgdXANCkNCUyBvZmZsb2FkIGFuZCB1c2UgcHVyZSBzb2Z0
d2FyZSBDQlMuIDooDQoNCg0KDQo=
