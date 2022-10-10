Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C265FA093
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJJOy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJJOy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:54:27 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EFC40E3D
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:54:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTS8+qz+w+P+j3baxrf+aLsGIAqaG1xPdBfL3BPTblrVx7e3qhScL5WGRfm/SM73t/EAqjO2ExfPkiEgU1eIPQ6Aq5/rXFDcAGAdWrKQNfGocgdiEarVFNDkGWZa2UclK9cbxo90Ngo/U1SCPLtYs3E1Hhjta6WGo33BFNs3oOC6SdjYw2GYEUS5X/rsR4GrX/EaVoH+ZciLoJgfjB1dK7lgXTP/iO4aM33FKW4NhCz5U72vfl50mK0sV4OmIcwBmi7dSSbXtHG19ouoJL+fQDL2oVJ1HZR+Fggfq0FPSIt/BJAcaBVmIKsMCp0ZdHSA8/m3g0GOT2gmlo0YRt/Tjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKgbzcOpghSKCzxIfiTkTxWG/eM//g1gA3p2ECFCW1Y=;
 b=LM8YFowzuH9IgfMMXXfjycBOGzIO4awM24LnTVKF+zsjK3LWza+KVwzy+tGYswwhLSlEj+SqHVVVMGQbta4CAOdA7Re3NRfAI1izecx6oq0FiEldsg/Mu4fgytoEVpnHuu0ySfZLyVYn+MDJmugqoqkiava2Lmr+hzjk5b2p/b4tGff5NLnyuK8jHsoB0jpp5dTGG+2f+1XWY+71fdRJN0YEE+MCvjYErBrQ5XI9BH9xiWaC9dpoG1Wii77PhoORKLYobq5UWRYIE9Lyi3zk1QYTed14iyjqubrQCzPXFbRvWLlQbF0xgH3YPeI5jrxVXhJLBiFtUGx9jtSuCJflyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKgbzcOpghSKCzxIfiTkTxWG/eM//g1gA3p2ECFCW1Y=;
 b=g4Viih0Oq0js2ltE5nlcaO/gsBhadTd9kA3Am1E+kDIPfJe619EnoNkg/JjAfje1beXyHSOD4tfl00Ey0PJlwkilj0rZ4v+CfEeQi5AcDgAFw5C/z5ggwX+PDwK/L+7wLLeWtledOUcA8R5Vyi5v+8DREbAvAWPAiUZW5P0zg5k=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DU2PR04MB9050.eurprd04.prod.outlook.com (2603:10a6:10:2e5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Mon, 10 Oct
 2022 14:54:23 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 14:54:23 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Index: AQHY2mN8NiUdjFp6H0SMw6HHEkZ4lq4DcfiAgARDuPA=
Date:   Mon, 10 Oct 2022 14:54:23 +0000
Message-ID: <PAXPR04MB9185EB623BDCA08A39F6B24C89209@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
 <3a95403f-0f26-6f64-1cd6-7770808f8514@gmail.com>
In-Reply-To: <3a95403f-0f26-6f64-1cd6-7770808f8514@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|DU2PR04MB9050:EE_
x-ms-office365-filtering-correlation-id: 2d70cb74-a744-4704-a99b-08daaacf51b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1cWhIS434RG0FPlRjQzOYnbfrIVzK5wUkSLareeez8QavYwDDwvzYgGtf/E87AXA1QbFueLjj2cFAo4+3VFcxiQMVuzBFelSHEwQ6J3a2ABhZFauaYA1jwZGb4v9tBVtMA4AhjA2/D0Jr+2jBlTq+AsqD3FiJFGAB9ESl7vEPpTTvEjvQyydalJnlDvyB2Jb9e+/+xcM5lxnwVUBh5r9iwPUwqIMYfskULCvSbhWKB0qlVebGHp7lIVuZF7EsiGLSM/GVdbXrFaP+YyrldEDG2lTXy0/xcUwPZaI3K0arWUMbWxMrizk6nhqlaDGOlM9XxcR77AMTrVj4XDFbI2tQwIlNuMoEJpvSAUboiIo8kp93dzWJyeSzMzrPiJYtVASTUwUEO4RI7z8fvjdgKIVMBL3K7uW0etPeSSqDmaLowBjnSy13wL+Y6oAYxXg5mSHJieJeWF8gx5+Gq2b4dyTWIoI3Vo4P5kvfhST/JpCnblnQW9yMYYVBU19lbTC99aX1GypcYIQ+hU8kU5Mos5sn4Qp8Fr404FPuUz/zjWz8xbVkAzK3uhfVhgqWHEj6n3NX+Q36QA2Fk+Osx0XXGIocmrB6I6jMf9AU6Cu9KJwYlFJVZmlRzT0Knd8PVqiZTuJTErqMzoLFRcpZJGf0VHmFgWkPxBeG5zR2RJdkka/0rUvR9oW6NARdc7dfniOcUN/zmw/sXagQHYs2sGaQ/RFW1TPFen8WKCBHdVcBo4fifdGtNEpqdOsROobDDqCCuTCXfhxPbSePLId9wo5E9oeKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199015)(38070700005)(8676002)(316002)(33656002)(66556008)(186003)(38100700002)(4326008)(122000001)(66946007)(478600001)(53546011)(6506007)(7696005)(66446008)(8936002)(64756008)(76116006)(55236004)(86362001)(52536014)(26005)(9686003)(66476007)(54906003)(71200400001)(83380400001)(7416002)(5660300002)(44832011)(110136005)(41300700001)(55016003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3ZZWEhZekZjY2tyd2ZmK2VGNjhhZnR5dzU0bGdXcXhEUmVvOGRua0VuVGxi?=
 =?utf-8?B?clVUK0FOL2dPMk5xQTdzWkl0NlF1S2l5WmNlTEl4UmlscTVIakdVU1E5a09L?=
 =?utf-8?B?Vkppdk5JczBDV0RJWHAwSU5ERjR3by9rSU5JbEZMOUZJbk1UU2NaQ2EzQmZF?=
 =?utf-8?B?UzlLVStERGwxU1JoUS9MbmtEUVhhVXFVcFVnM2J1UzFQWFhsY0xvWEQyeFUv?=
 =?utf-8?B?b2xVN0hVb0JkbXVwcUMyOWtxRzMzb29ROElBdVpPeGNMZFk4M01nZ0NMMERJ?=
 =?utf-8?B?aXY5QjhBVFc2amZLbDQzWEduTmZEaU1RYldqVEZVZzVUU080b0Y4cncwa3ZJ?=
 =?utf-8?B?emZSa0swV1JvcmkrZGhmLzVxR1dKdlBPR0lwUE9JVzczODl5eEt6WXlmSURI?=
 =?utf-8?B?Y1BLWkxtRWQ2bENjQVd0U3V3OW5UdFp4S3pxcVY1RWkzdWtIaGgzMVZlS1gr?=
 =?utf-8?B?amhpMVplQXFwcnZKQ01kUHVaRVRlOFhydjBoaXhSYTJCS1hnTjhKRGc0Q1ZT?=
 =?utf-8?B?aTc2NjRTbEZaNWlUc1hEVzFiZ2ZETXNWM2xzRjhjZ1hrbTdBZncwcUx4RXdl?=
 =?utf-8?B?azhyS3ovdFAvWDRobVR3ZXNnaVZvR1FuWDNSTnBLRzRnYVI5WXhyMmhkRk1j?=
 =?utf-8?B?UGlId0NBdGZTMWk1UlN4WTJTM3dNS1NEcDlYRjREcE05QkYyWHZWc3hvUkxz?=
 =?utf-8?B?YkFEdXhZdklFeHNUUTJRc2ZlcVJGOVp3WTBEdFBEM2wzUi9WalNvVHo1RC9D?=
 =?utf-8?B?QmNtWUFwOXNXVnl2ckdYQ0plSWV2dFFSZlRnTmhDL2thSjVRM1RYa3BoVUR2?=
 =?utf-8?B?OUZmMEpqTVJvM05ZdGNBTjlvZkNQektFdDJueWF2R1NiU3MzREQ2bDI1OURH?=
 =?utf-8?B?WEdlUFQwRUFsKy9kWU9nSTU1L1dJajZlbVl6MXdBWEE1VTlTTHlXbWRKZUtB?=
 =?utf-8?B?WThDcGN0UEFWVXBxTE0rakFTMUpmbE1EcHFjWUZUSi9jQkljK2VBV0l2dlBt?=
 =?utf-8?B?dmhZeEJVQ083WXlSa214amdZK1phWmQwVysvZjFCMXVjaHcwTG9DUmRKaVhv?=
 =?utf-8?B?VnJUSnpFalNpOXlTVDNudGRHeUQ5R0VobXVsdnVvVWNpK2FuY01NZzRpMTU5?=
 =?utf-8?B?N3hBQ2lSTnZGUUxmQkorTjAwZDBOSmF4UTUyUFpOYlVkSFNJaHlQYWVzNllm?=
 =?utf-8?B?eTIzWUcwNXFLemJ6dlhDM3VYMUhtUFNUOHNPZGFMU1cwZ0RlWjlWYVBpaUVS?=
 =?utf-8?B?Zkhnc3Q3U0lGaCtxQzBXbG81dTlPOEd1eUI2TGhIMnJjS2I1NG5nR1BjSkUv?=
 =?utf-8?B?c0dmNnl6TjB4RGxWbjZ2Y3BmZmZqOGRub1dEWDBKZEd5WWVCNklveVpQWUE4?=
 =?utf-8?B?NCs3RDVjbVRncVR5YklMQ25VVGtuMDRRcnBkMmp4bVBpUWVzcHkwVVYvbkxN?=
 =?utf-8?B?VFF6UjU4WkNMaU9tVElwbnFZVlRHSFQrTWtIYWZmNEU3S2pIRHMwR1VQR01t?=
 =?utf-8?B?T3AvUkowNmpFMkVtdTl3VUNrTXRPY2lJeVBWenUxdHAxdmxldjF5NVpvTzVt?=
 =?utf-8?B?V213WnF1dVR5RTBzQk4rZ3NUSDFrOE5uc1pDZk44Y0VzUXFocFhtYjdxMUgz?=
 =?utf-8?B?MUhGV0VCRVJsZFg3S0dqVUV5TGpZWGFIS3lCR3JjUCtRNkxJeHdUdU0yNUt2?=
 =?utf-8?B?MGxDSWorblpQcE1NOHIxc0d6djBwam1jUy9PYjRZQVFsMWpqOTFkSkI1Zndl?=
 =?utf-8?B?Q0thVHFtTFZVd3BnT2kzMW5VdkdPTFgycmM0dWpSNjBWWGxUNU9BZnpJVm1p?=
 =?utf-8?B?dkhvUmJhQVFnUlJ5NU9DRFdMTExKTVJGVTlyd0VMMkRhV3BiOUNlQmlSdERD?=
 =?utf-8?B?NldmUEtvUW40RkdDZmZUTlFtaHpMaFpFbDdmcDJTU2t4bGJaNHZiOHZXN1FR?=
 =?utf-8?B?ODluNnBFNHEySHNIaWxPMnZUamF6eDZmUUw1RTJLa0Q1b0hBRFBLVWZ1OHF0?=
 =?utf-8?B?dDVzQ1NpMDFzeGpNTitJZG05RExrdU4vaDNIdTJjTE9PcU9Za3lEa1BnZVU3?=
 =?utf-8?B?clFFRC9WSkhXMnVKb3hGeEVjL1R1WkRWaEdXd3ltMFlRc0dZa3VQQjBoaTBD?=
 =?utf-8?Q?NyRLAbMUu28v+sCe2rMd+ryDg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d70cb74-a744-4704-a99b-08daaacf51b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 14:54:23.1780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvLRjcjHcPKU2ECc7KgWBle+UHQ7ANlJGh7Br/D133pkVdz6xxXLjCoazr/YR/pQOTvkMl9X4e1kn/PfgxGufg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9050
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBGYWluZWxs
aSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciA3LCAyMDIy
IDQ6MjYgUE0NCj4gVG86IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+OyBSdXNz
ZWxsIEtpbmcNCj4gPGxpbnV4QGFybWxpbnV4Lm9yZy51az47IEFuZHJldyBMdW5uIDxhbmRyZXdA
bHVubi5jaD47IEhlaW5lciBLYWxsd2VpdA0KPiA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBEYXZp
ZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljDQo+IER1bWF6ZXQgPGVkdW1h
emV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8N
Cj4gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgaW14QGxpc3RzLmxpbnV4LmRldg0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENIIHYzIDEv
MV0gbmV0OiBwaHlsaW5rOiBhZGQgcGh5bGlua19zZXRfbWFjX3BtKCkgaGVscGVyDQo+IA0KPiBD
YXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IE9uIDEwLzcvMjIgMDg6NDIsIFNoZW53ZWkgV2FuZyB3
cm90ZToNCj4gPiBUaGUgcmVjZW50IGNvbW1pdA0KPiA+DQo+ID4gJ2NvbW1pdCA0N2FjN2IyZjZh
MWYgKCJuZXQ6IHBoeTogV2FybiBhYm91dCBpbmNvcnJlY3QNCj4gPiBtZGlvX2J1c19waHlfcmVz
dW1lKCkgc3RhdGUiKScNCj4gPg0KPiA+IHJlcXVpcmVzIHRoZSBNQUMgZHJpdmVyIGV4cGxpY2l0
bHkgdGVsbCB0aGUgcGh5IGRyaXZlciB3aG8gaXMgbWFuYWdpbmcNCj4gPiB0aGUgUE0sIG90aGVy
d2lzZSB5b3Ugd2lsbCBzZWUgd2FybmluZyBkdXJpbmcgcmVzdW1lIHN0YWdlLg0KPiA+DQo+ID4g
QWRkIGEgaGVscGVyIHRvIGxldCB0aGUgTUFDIGRyaXZlciBoYXMgYSB3YXkgdG8gdGVsbCB0aGUg
UEhZIGRyaXZlciBpdA0KPiA+IHdpbGwgbWFuYWdlIHRoZSBQTS4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFNoZW53ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+DQo+IA0KPiBUaGlzIGlz
IGZpbmUgYW5kIG5lZWRlZCwgYnV0IGZpcnN0IG5ldC1uZXh0IHRyZWUgaXMgY3VycmVudGx5IGNs
b3NlZCwgYW5kIHNlY29uZCwNCj4geW91IG5lZWQgdG8gc3VibWl0IHRoZSB1c2VyIG9mIHRoYXQg
aGVscGVyIGZ1bmN0aW9uIGluIHRoZSBzYW1lIHBhdGNoIHNlcmllcy4NCg0KVGhhbmsgeW91IGZv
ciB0aGUgcmV2aWV3LiBXaGVuIHNob3VsZCBJIHJlcG9zdCB0aGUgcGF0Y2hlcz8NCg0KUmVnYXJk
cywNClNoZW53ZWkNCg0KPiAtLQ0KPiBGbG9yaWFuDQo=
