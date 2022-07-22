Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E075D57E185
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbiGVMlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiGVMlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:41:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F6CE0CA;
        Fri, 22 Jul 2022 05:41:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+U5VuEhAMIjtBgi9kvNnzy90uSP1PG0yyL0U6GhEnsBnn64aF77dinKmBME5vt+KpkOFiS2Ym7tvskKo6wnSd8ljpIUOT+/IV7hIlUz75AGu7lai8WoBZp48bVHob4nnEoUP6deYfeeIF/1tkj0hu3MPHn9JrZ5nHBEfcaB1qDt7+UdaLAD61cmjtY43a2krWHMbIk50jSUFw5i+ssFmYdk1B3O5oh6TaDO+Xh6FEB3Q8FlGopRDrWthmBz3cBTXbrGGQe167d1iPWnZKXMcgNVnXUOx/Zi/jVMbJJ+bhCWOmWsKuxJKq59qKwPdmd++/OXevRk0l9vQEr/gd/GTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5CtmxDYE1NcR5x5AeY2UuVY3z8ujVP2ZJO75M/4djA=;
 b=fO+LURSXRSLluaVAT741gsJBHo5FdlivDGv+XGC6++JRq8o6f3150R9yjjCW4xsYVW/BT4HtwUo8JuHqT1UV0W+G1KJj9/dIhFFqnShOgVuvKLc+OHGrdtCz+N9JJh7vAkwkeh3Gay0w/ymqiQfQ6WngNnQ3ZLHLgENpiYcL4q7+TyPgI1cmDsp4FqLYrq79C0iZEDSvndjSD0I7Uruu2sY7ZPdenof8D0FGnnLkVoh226h8tep4lC8FXGka7mc15a6azjAanHFDxkZIj4Wpx5G+lnYv75o9SRCmHqZsLqWZXmuPasS3kQKV78wMs0z3+eA/9vwSvKS9QxQPwUzR5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5CtmxDYE1NcR5x5AeY2UuVY3z8ujVP2ZJO75M/4djA=;
 b=iZen1UMScTLt7F+PZDsKMLWO7Kv5pSnYlsWlfAXAXKMehcX7zJD05kny3oIhCN23yRQFVcCmfrupGR0P6LROkb082lOgS2J6WnWnFwD5a7lUk8FqYw4Xr7zsoEwKDopttIEH6dABE/jdk5B7Vby4xfBK3AcR9oN//gwZjjb5qcQ=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AM6PR0402MB3688.eurprd04.prod.outlook.com (2603:10a6:209:22::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Fri, 22 Jul
 2022 12:41:40 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Fri, 22 Jul 2022
 12:41:40 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject: RE: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
Thread-Topic: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
Thread-Index: AQHYmJdO9OJQL8uRzkOwnuesK8wAT62I4DBggAAfFwCAAV64UA==
Date:   Fri, 22 Jul 2022 12:41:40 +0000
Message-ID: <VI1PR04MB58076F8E57D04F5F438385DCF2909@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-47-sean.anderson@seco.com>
 <VI1PR04MB58077A401571734F967FAF12F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <5f32679a-3af3-f3ba-d780-5472c4d08a81@seco.com>
In-Reply-To: <5f32679a-3af3-f3ba-d780-5472c4d08a81@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d206c661-dcd1-4423-4017-08da6bdf869a
x-ms-traffictypediagnostic: AM6PR0402MB3688:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wq/vq5oC3CUUdMoJq6X0PgJyGAU/cjsWgrVDrwcWJAdHXBThvOi2TiRkYqBGrLr+rFaJaobfpbT+Hhqy3idlha51jqV0nLasG1ZFMFHaEORdzlmJ3jtJ3OqkRuEQxw/DKA8z0gTDQMHtepkaJQG++4GBXD18TZ1b255c/oeyMWAZn/VCJ/w4mmoiE94H70V7QPqCjgcqx90ItQ1vKokBYuPXJ/MFrVXW02RS2KwapBd2yIlulzhlfBLhRPVVwFLZUwUqfFFtjWioOgQ/OPy47dId26P3X5TPM2oV86VRAHbmkeLsacKr+FcN1sxh+gF34QXHOMXxoEyDAG5in435XvYRigaN7Jh/3ZmmaO58vsqc4RXRhF83NNElG7AWV2WAZtWe7Ya1XXpO9UCDrGw9ddVbK/QvMW2xFshEaNfLIeibq55iE/9UpWdmATpF+XqXWSrUHuzUK1cXhFvCIHshU2OzA7/ZdH2KbXi93/sjz1MhWDPzRePwaqGOrdu5zWdE/b2ZGXcQTMSgg4HVXuXuyXRrITPij72LJW6Jm5hUPY4OPRs8FbwkEEJgom7UHrsTvx/cpedTGLHxO9xdFldXtsNHQMuCXH/gNONUczrVAMQyxgK2ah7f3m5zVITUDdUcJxzI4WfeaS/qupCFxMFH+UA811lCxg7Y3vQZkhiFUAEUcbpuVsPfk2bs0C3m8f/m2+RXMS1V9sfIJBuy6SPrC8yA5VhLJAZwZHyGxkNYgS8tnL3KHTU4lGXMr81XxMgpW7vDdAGHhqXNkCpt5Eb8BcIC5tcYiOYt2rgwnV/h173MIZniUZh8FfCP5cNW0Phz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(122000001)(66946007)(8676002)(76116006)(66556008)(55016003)(316002)(4326008)(38100700002)(71200400001)(66476007)(64756008)(66446008)(38070700005)(54906003)(41300700001)(2906002)(26005)(52536014)(5660300002)(9686003)(186003)(53546011)(6506007)(478600001)(110136005)(7416002)(33656002)(86362001)(7696005)(8936002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rmhpd2Q0NTdWakFLVlhhdmdrdzVQT1E2dW5xQWpMWDBOMHZ6eXB4NkYzUXpw?=
 =?utf-8?B?cGJsS3VGUWhlUnZNeCtydEFsbmFQYkduWkpWUmpIUW43Rk9oTUIzUW5UMlRv?=
 =?utf-8?B?L2Q0YjlFbER1R05tOUhycXU4THRvbEVxQ1o0ZHhwekNmZG9iQ2lRWVAvOW02?=
 =?utf-8?B?Vnc1dUhOUkFSOHJVYXBwZkZZWXR1WEwyb2FRMytwYjd3YWI0MGJncFJNVWV4?=
 =?utf-8?B?R0Zvd2huOUIyY0l5aDArZ0kxOGp4aTFjZFB2bTAwY0EvekxrRzlLcEFoMjZ3?=
 =?utf-8?B?VlpYUUVobGk5MWFKaWwxOWZhd0tmSE9yclVEUnNkbUp1MHBZWGhJOUhXRU9G?=
 =?utf-8?B?cmVOWC9jak9KWWxUVG40TGcrb0hDY1l0VTN0bDlHOFJmVVBpdVVybDNZclgy?=
 =?utf-8?B?Yk1GK29rWkJtRGRCc1U0YkJmWEJsaWdKbjdKT3FlWkxVQy8zWjRXQnFra3Fw?=
 =?utf-8?B?SE90NStZZnV6SmU0ZUgwM213b1MreEJXWDYzRkErZmpVTlhON1lMcU9aYmI0?=
 =?utf-8?B?TTRua1UvMFZ6MjlaanUyQ2RTMWVRbnp0ME84OGZWV01qSnR0eTUzQUgzZmhv?=
 =?utf-8?B?TjA4NUI2Z05NaCt6V1NBelIvNGRFazFlaGoranU0Y0JwcXFGaGU5VTdpc0tX?=
 =?utf-8?B?YVg2SUk2dlU5bi8vVlV2Rkp0cVJEQlMvcWF0cnZEaWdSVEFGUmxUMkZpNnFh?=
 =?utf-8?B?cXRTWmIrQi93VHJBditmK1cvNVRJeUk4K0FldUxSUUFYTDdFcVVJR2pnbytP?=
 =?utf-8?B?b1BEZGVlN3RxL0EydWMwZUFhK04wY2V0anhzTkNxdVRVOTkzT21zTVZzeFc3?=
 =?utf-8?B?L2h2elJvN2o1czFCand2MjVUaFFHREYyQzk2WU8zK2p5MnJ6TjU5cVlrVjFw?=
 =?utf-8?B?VEZhby8vT3UxbzlSZ2MzUDhXZmZOSEF6VEhTdzZvaGFtWFdvSXVVbWhQSVFS?=
 =?utf-8?B?a3RMYndiVGFjak1WN0JKalU2MTVaRmVJSmRmeU1FSmFBVjVKejlndEdkU0gv?=
 =?utf-8?B?RkZJMmpoZUFQVXBna1pzWW50Vjl6YVFnMGl4VDRNem51UVlqL1c2U2VxNUdL?=
 =?utf-8?B?QW45YjNsemVPdk43a0k0VElaRUJHQVpEQXJjT2MyN2N0MHVlZEVzUWtidmVu?=
 =?utf-8?B?RTErUXJnR2pSVHU2eDlVYm81emRmaCtIaTdYWFllRGZZeXFBZ2o4OExDeU1G?=
 =?utf-8?B?bnppem9EWEdPbERMT1hzNnprTnZXdlNHQURYZC9PNnRMR05nRFl5SGhXZ0Fk?=
 =?utf-8?B?V0F1MEIwbndJeXh3NXMwcC9YbkpKR1lJQlBpbjJKR3VyNE05ZkJkcmRZdjhT?=
 =?utf-8?B?cFdRQmRSN1V5aVYwVlcrRlNNMWJ3UEU3ZTBiUmtvdGxWL2ZaZ0U5bTBFb05F?=
 =?utf-8?B?RWNQOEp3N3BiS1B3bFArcmljakZXT1UvZ3lmekRJLzhYbEIwOUQvMk15S3lL?=
 =?utf-8?B?bVlBcGh5dHEzbmtVdXp0alhKM2lJMDlnWE9QM0FSZnVaOG5sdE9rekFMNHVo?=
 =?utf-8?B?WHMwNW1zRzlPMTBWQWtsL2cyTVA5eDBNMlZyNTVCWnN6bDMyT3B0TERldWps?=
 =?utf-8?B?YVBmUVpRUE5Jb0J6ZjFsbHd0SVF6R3NaOTFqdnhWcklWckY0ZS9qOTdKdFI1?=
 =?utf-8?B?K0hKZ1gwU2JXZ1B3VHdmNWh2RWRVRXJKb2E1RDZBeHNiNXVrYVVlRFNWZ3NJ?=
 =?utf-8?B?RnNVdmF3UzlPUVZXUkdvQTJqc2t1aVFiejZ1WWpLd1hPNGhPdUhianBNb1R2?=
 =?utf-8?B?UHNST1hmZ01uNGdFclRSSmY3WEFma2Y3VS9IRmdMUDdtOVVpZklqaHNuNkx3?=
 =?utf-8?B?blNRTFZidUFsK1QrY0dZY3QyYXk5cSsvRDFrRDhySzdKU2tnRGk0RlBDQndH?=
 =?utf-8?B?ZEY2ZGJ5QlZZKzgvNHZiQ3JUMUFYd2lzMWdlUzRqRUVEb1VZNElaQlVYTG4y?=
 =?utf-8?B?VGYzK3Znbis4RDRRaExxcCtpdjV4RC9uWkEwM3d6Ym9mOHFmbkxNU0NGUk0y?=
 =?utf-8?B?bjFXZEl6T21xRUo4QTBCR2l1S213SjA4VU8wQ2k3TzJQeUY4L1NIeFpucytu?=
 =?utf-8?B?ZldSNC9ocW1NSThqMGdlOG83TmVqWHBWSng3bm1ZM3FYRTMwUEpnMlowVlBI?=
 =?utf-8?Q?mhucO7okOOVdj8IAo1WOErAoj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d206c661-dcd1-4423-4017-08da6bdf869a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 12:41:40.6012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KfIrc3bnMmzcDKDeUbtCXgoPhEUwYRhGyLH2YTIMpbSX7DsGRWSyLvF6lWESc6ub0yJbqt2sOEFSW365EegZNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3688
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFu
LmFuZGVyc29uQHNlY28uY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyMSwgMjAyMiAxODo0
MQ0KPiBUbzogQ2FtZWxpYSBBbGV4YW5kcmEgR3JvemEgPGNhbWVsaWEuZ3JvemFAbnhwLmNvbT47
IERhdmlkIFMgLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgTWFkYWxpbiBCdWN1cg0KPiA8bWFkYWxpbi5idWN1ckBueHAu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogUGFvbG8gQWJlbmkgPHBhYmVuaUBy
ZWRoYXQuY29tPjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgbGludXgt
YXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBSdXNzZWxsDQo+IEtpbmcgPGxpbnV4QGFy
bWxpbnV4Lm9yZy51az47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEtpc2hvbiBWaWph
eQ0KPiBBYnJhaGFtIEkgPGtpc2hvbkB0aS5jb20+OyBLcnp5c3p0b2YgS296bG93c2tpDQo+IDxr
cnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc+OyBMZW8gTGkgPGxlb3lhbmcubGlAbnhw
LmNvbT47IFJvYg0KPiBIZXJyaW5nIDxyb2JoK2R0QGtlcm5lbC5vcmc+OyBTaGF3biBHdW8gPHNo
YXduZ3VvQGtlcm5lbC5vcmc+OyBWaW5vZA0KPiBLb3VsIDx2a291bEBrZXJuZWwub3JnPjsgZGV2
aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBwaHlAbGlzdHMuaW5mcmFkZWFkLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYzIDQ2LzQ3XSBhcm02NDogZHRzOiBs
czEwNDZhcmRiOiBBZGQgc2VyZGVzDQo+IGJpbmRpbmdzDQo+IA0KPiANCj4gDQo+IE9uIDcvMjEv
MjIgMTA6MjAgQU0sIENhbWVsaWEgQWxleGFuZHJhIEdyb3phIHdyb3RlOg0KPiA+PiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFuLmFuZGVy
c29uQHNlY28uY29tPg0KPiA+PiBTZW50OiBTYXR1cmRheSwgSnVseSAxNiwgMjAyMiAxOjAwDQo+
ID4+IFRvOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2lj
aW5za2kNCj4gPj4gPGt1YmFAa2VybmVsLm9yZz47IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVj
dXJAbnhwLmNvbT47DQo+ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gQ2M6IFBhb2xv
IEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IEVyaWMgRHVtYXpldA0KPiA+PiA8ZWR1bWF6ZXRA
Z29vZ2xlLmNvbT47IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgUnVzc2Vs
bA0KPiA+PiBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBTZWFuDQo+IEFuZGVyc29uDQo+ID4+IDxzZWFuLmFuZGVyc29uQHNlY28uY29t
PjsgS2lzaG9uIFZpamF5IEFicmFoYW0gSSA8a2lzaG9uQHRpLmNvbT47DQo+ID4+IEtyenlzenRv
ZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2krZHRAbGluYXJvLm9yZz47IExlbyBMaQ0K
PiA+PiA8bGVveWFuZy5saUBueHAuY29tPjsgUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVsLm9y
Zz47IFNoYXduIEd1bw0KPiA+PiA8c2hhd25ndW9Aa2VybmVsLm9yZz47IFZpbm9kIEtvdWwgPHZr
b3VsQGtlcm5lbC5vcmc+Ow0KPiA+PiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgt
cGh5QGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gPj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IHYz
IDQ2LzQ3XSBhcm02NDogZHRzOiBsczEwNDZhcmRiOiBBZGQgc2VyZGVzDQo+ID4+IGJpbmRpbmdz
DQo+ID4+DQo+ID4+IFRoaXMgYWRkcyBhcHByb3ByaWF0ZSBiaW5kaW5ncyBmb3IgdGhlIG1hY3Mg
d2hpY2ggdXNlIHRoZSBTZXJEZXMuIFRoZQ0KPiA+PiAxNTYuMjVNSHogZml4ZWQgY2xvY2sgaXMg
YSBjcnlzdGFsLiBUaGUgMTAwTUh6IGNsb2NrcyAodGhlcmUgYXJlDQo+ID4+IGFjdHVhbGx5IDMp
IGNvbWUgZnJvbSBhIFJlbmVzYXMgNlY0OTIwNUIgYXQgYWRkcmVzcyA2OSBvbiBpMmMwLiBUaGVy
ZSBpcw0KPiA+PiBubyBkcml2ZXIgZm9yIHRoaXMgZGV2aWNlIChhbmQgYXMgZmFyIGFzIEkga25v
dyBhbGwgeW91IGNhbiBkbyB3aXRoIHRoZQ0KPiA+PiAxMDBNSHogY2xvY2tzIGlzIGdhdGUgdGhl
bSksIHNvIEkgaGF2ZSBjaG9zZW4gdG8gbW9kZWwgaXQgYXMgYSBzaW5nbGUNCj4gPj4gZml4ZWQg
Y2xvY2suDQo+ID4+DQo+ID4+IE5vdGU6IHRoZSBTZXJEZXMxIGxhbmUgbnVtYmVyaW5nIGZvciB0
aGUgTFMxMDQ2QSBpcyAqcmV2ZXJzZWQqLg0KPiA+PiBUaGlzIG1lYW5zIHRoYXQgTGFuZSBBICh3
aGF0IHRoZSBkcml2ZXIgdGhpbmtzIGlzIGxhbmUgMCkgdXNlcyBwaW5zDQo+ID4+IFNEMV9UWDNf
UC9OLg0KPiA+Pg0KPiA+PiBCZWNhdXNlIHRoaXMgd2lsbCBicmVhayBldGhlcm5ldCBpZiB0aGUg
c2VyZGVzIGlzIG5vdCBlbmFibGVkLCBlbmFibGUNCj4gPj4gdGhlIHNlcmRlcyBkcml2ZXIgYnkg
ZGVmYXVsdCBvbiBMYXllcnNjYXBlLg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBTZWFuIEFu
ZGVyc29uIDxzZWFuLmFuZGVyc29uQHNlY28uY29tPg0KPiA+PiAtLS0NCj4gPj4gUGxlYXNlIGxl
dCBtZSBrbm93IGlmIHRoZXJlIGlzIGEgYmV0dGVyL21vcmUgc3BlY2lmaWMgY29uZmlnIEkgY2Fu
IHVzZQ0KPiA+PiBoZXJlLg0KPiA+Pg0KPiA+PiAobm8gY2hhbmdlcyBzaW5jZSB2MSkNCj4gPg0K
PiA+IE15IExTMTA0NkFSREIgaGFuZ3MgYXQgYm9vdCB3aXRoIHRoaXMgcGF0Y2ggcmlnaHQgYWZ0
ZXIgdGhlIHNlY29uZCBTZXJEZXMNCj4gaXMgcHJvYmVkLA0KPiA+IHJpZ2h0IGJlZm9yZSB0aGUg
cG9pbnQgd2hlcmUgdGhlIFBDSSBob3N0IGJyaWRnZSBpcyByZWdpc3RlcmVkLiBJIGNhbiBnZXQN
Cj4gYXJvdW5kIHRoaXMNCj4gPiBlaXRoZXIgYnkgZGlzYWJsaW5nIHRoZSBzZWNvbmQgU2VyRGVz
IG5vZGUgZnJvbSB0aGUgZGV2aWNlIHRyZWUsIG9yDQo+IGRpc2FibGluZw0KPiA+IENPTkZJR19Q
Q0lfTEFZRVJTQ0FQRSBhdCBidWlsZC4NCj4gPg0KPiA+IEkgaGF2ZW4ndCBkZWJ1Z2dlZCBpdCBt
b3JlIGJ1dCB0aGVyZSBzZWVtcyB0byBiZSBhbiBpc3N1ZSBoZXJlLg0KPiANCj4gSG0uIERvIHlv
dSBoYXZlIGFueXRoaW5nIHBsdWdnZWQgaW50byB0aGUgUENJZS9TQVRBIHNsb3RzPyBJIGhhdmVu
J3QgYmVlbg0KPiB0ZXN0aW5nIHdpdGgNCj4gYW55dGhpbmcgdGhlcmUuIEZvciBub3csIGl0IG1h
eSBiZSBiZXR0ZXIgdG8ganVzdCBsZWF2ZSBpdCBkaXNhYmxlZC4NCj4gDQo+IC0tU2Vhbg0KDQpZ
ZXMsIEkgaGF2ZSBhbiBJbnRlbCBlMTAwMCBjYXJkIHBsdWdnZWQgaW4uDQoNCkNhbWVsaWENCg==
