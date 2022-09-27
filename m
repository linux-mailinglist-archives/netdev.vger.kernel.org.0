Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750555EC4D3
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiI0NpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiI0NpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:45:14 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70057.outbound.protection.outlook.com [40.107.7.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53E91ADAE;
        Tue, 27 Sep 2022 06:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdbPE1j2Whtv7H1QCbWzwWMTR86BaeLY5ftwTE0X6iVfzK8eyeCjCAifHNuzZg9KEBwZf2XeQJPqD0mNmf3XSONyVkJ8d7M874ArK07hQm8Qo8cUUqQObRo+zrT0ok3CfYMWM3AtXKiDo4vVjBjhjC46lEPol6wxTj+0Xj7oiF8vQbMTH26T88ESMA9tfadN1dao+Z6260akecO0bPXmsevNDAXJShqU7LauYE0Ov/QvicKCpwJksBjIDia2qxgthVc3RXY/w6etPMlnbNzCLaTdypnoDphCROW+ClifTqJqAPvYKB/iMDPR9zIishoekUtSH5PHJ4Z+xbNGc1MXeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvfmh7b+tA48POhhJVmWHAMHKzsFtMuHSnxNlVof3YE=;
 b=Psie1MqXjZ+vjntuBeH+zMjWxQvw1wPqXDyK+2NwXKvNcM8Rt6GfbFUp9PsSDA+Qwt4bFfR4RUQTUvPKtsGqvW3zrIVoDtLtFvDrl1gnlNObLHhm9/uzywFsfAmeYRxeiR3sfNcPSRXepfVFSft5iw/PNPMiMY3tIXwvsk0c2VdXRQjxSsQrDmI2UXWopvR6ljreDs4Q9BB8aPw3MQT2UwZNj1LNkGLVLT6Eetzcrx8Kahcj0UFuKTT53wEQXZwCZjxsf56syshM/OZM0lvoglu1QNT/S9VvqjFG2GRAyIxdmp64EbEZqyJFNFgZGzf59ZoBXr415i1Z7m5Slx0nUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvfmh7b+tA48POhhJVmWHAMHKzsFtMuHSnxNlVof3YE=;
 b=j6AUZXxljeqp7KE1hBMACAK8n/uuD221WzxK5LO2EKT3F7dOgQADXXu0baaULWoPZUOfvNe532ouAxsQ3eMhv31pfBUYLT6TxM2JLN5DhFWwKy66KzIqAHOSSI/3SowTMMfGpHyyooCRwFX2bqkyoYrwxZwBeYhu32i0BhNVHFM=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB7981.eurprd04.prod.outlook.com (2603:10a6:102:c0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 13:45:09 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 13:45:09 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v2 07/12] net: dpaa2-eth: use dev_close/open
 instead of the internal functions
Thread-Topic: [PATCH net-next v2 07/12] net: dpaa2-eth: use dev_close/open
 instead of the internal functions
Thread-Index: AQHYz2OwlY9w+MsZU0iGCLo+j3U2J63zQeoAgAAOBAA=
Date:   Tue, 27 Sep 2022 13:45:08 +0000
Message-ID: <20220927134508.k737zjfjzos36wt6@NXL49225.wbi.nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
 <20220923154556.721511-8-ioana.ciornei@nxp.com>
 <415734628d8626088b74e49cb062f86a2733dd0e.camel@redhat.com>
In-Reply-To: <415734628d8626088b74e49cb062f86a2733dd0e.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR04MB9055:EE_|PA4PR04MB7981:EE_
x-ms-office365-filtering-correlation-id: b079c78a-1714-42b9-ecb8-08daa08e7e30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9TCPrmllBWG3gxFysSLu3UFm+RsrQez2cGtb7BVGoX14UbJQg16UDs1bAzVtjo09d8Wrxw0JjufVzbkNbiYilOTkwnhRh+EzW+/xZ7O3w9qnoSSDYgDXrhhifw4ytxSiwKtDRhbDXTpUZGdg2/0G/q1Lpeq0gcZANuL8QBvOBS5e89e/xjJfwYF4MXSGLgIKQdI1eAbVdV3TwDmDTjHLzrQUfG8RqO2u/yn5jjbBRkDWmJdoXPHtnMoB7zaNMMWmABzVzeqxkHu8ypUQTpDK6FWNHa79DMjhErhBI1PkvUJqAIWSV2Mc+jrzjG4cxiaZWDablt0+BxuXQv1JKtGjHTqnsz7HQUiuL/u69hnkUL1oihIC2J43ISbr9RFfta3wLsWhPB8N7N3zkaW0P9S+sUqxhQFFSPBOVa+NDsegfGiNxrL7f6TxI/iQUhWReWe2eFo2H+F/JnEfjtW5rVb1xjELnzwD1CW1RrAxL57uegM4fnlAiTAvtJW/tE4CpCTo0bafUpfvQl2EW+yDDLDXg7GlD9sM5WxP0papJnqYustH4v0Vj4K0s/PeWl7z9CZTnqzKrAA8Ju3IIja0E+SuaKhkOBKveIXdsmr8FP3RzL+UHmzywx5lyUahczcWkYQIElvEXW6MtIV9nM4EATYjZ5TW2JVelAIEV3jj6WIjda3i6U7iL8LDZrRa3mEi23pRIqdaSzJOV05ePw8I2oH2qxg3vYbdHonXA0oCbM2on62nlGfytk1HZ6BLRKayIZFgrxjyY3iuKF8sQSprEpZnjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(6916009)(316002)(38070700005)(38100700002)(54906003)(5660300002)(44832011)(66476007)(4326008)(66446008)(66556008)(66946007)(122000001)(64756008)(7416002)(8676002)(6512007)(2906002)(71200400001)(83380400001)(478600001)(86362001)(26005)(41300700001)(1076003)(186003)(6506007)(91956017)(6486002)(76116006)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j0DxJfj6ZjmFX/N1Q0PQL1D2VY+P5c1UervSXYBtyQ1BN7OfJT15zqRSmfET?=
 =?us-ascii?Q?bSrm7RNGXFadT5YhOA/ZZ4RNfb3bKPlMDKxZhqaEk8FNYuSuIK+iap1dL6G2?=
 =?us-ascii?Q?zPWWJshPk34obWkObASIG1CRvLUie5byyibHtnluuuRCI53v3ayMBENz8BLE?=
 =?us-ascii?Q?N8jQD0ji2pOxTfMVXwcUHWRQtaX69IsI8Isq+ha4nZ82t5VwFLPXqoMustku?=
 =?us-ascii?Q?3uW/Ea3Fys3LighVWsAeg3VsCdBsUO+EvtFNAG3qQEwltn638KjavEs066L0?=
 =?us-ascii?Q?2GBOesJT3FQk2dH/HLTOUEPx9Yo6nkphhc6HGVkPbni/WU27L3iMITS6ai+J?=
 =?us-ascii?Q?M5hYPKerDQ6Cn7xdwH/GPZjDJD/XmpTYjflDXt5AeBXeYQ7JhFx+w+6Ktin8?=
 =?us-ascii?Q?LdsszYqOM8m4muIJzMifeIXUh1n3qo2x10+PtiudQ+RKrqR6IkREXdDaPxOr?=
 =?us-ascii?Q?omNQwFMP9kQgDjwRUBAbtalMkhYjMPE49y23C6tG0Olmrvt8wz7DWyfVx22v?=
 =?us-ascii?Q?JPh8zCRJt0uVzzmQzfh6fjB4G15FddtvDUzFeZEZFVs6+mSX/LgYo51Nlhp0?=
 =?us-ascii?Q?5Q+KfeEQPNU0NAh/sqqSJhotiYy65rTShUwvjadf14PSPqCGlY49Im/l9ur4?=
 =?us-ascii?Q?4pDh7x1nZLV15MqZDfDXwbyc+oR8dLzrhz1Co/k8spBdahAghBTJh3X0FlO3?=
 =?us-ascii?Q?kXr6E/eSo+duY6E41ZZspq6otBsKgsw7O9Og71mncm2+4o4ovCgudF02QrVV?=
 =?us-ascii?Q?bBcbbIi/FWQxhZJf/bkkQPKV+JQ52crR8X3ZjUZc8e/Xg7UX7x2MjcrmrIrA?=
 =?us-ascii?Q?s2e7CJHd/2Qswo+XczVfLcHxkFGlEW8a/18sZlZj2M4fUmECFiZ8epYGBm9g?=
 =?us-ascii?Q?UMXroNz2e2xRuaYTTZdpHgx39UqlImk/mZr+VRMUTS9GdsFL8ahFaZ+V5mbh?=
 =?us-ascii?Q?vPN0A5SqbRKFYEC/U8/e5hfpwtskWuH02b0h9azFsDoCd8U6gOLsSoR5mQNL?=
 =?us-ascii?Q?AZz6g7b9+W+8qoLZSXN3WrdHeijlMbixu1JASk810arhL+frChlivo66GvUm?=
 =?us-ascii?Q?6ZdRQi03YHolv3bSjjlwnvbMa7rA1GanQNRdeFLkx+bV8hfYWSBnVhHz918H?=
 =?us-ascii?Q?K+DhDqk8fQ56E4KvrskIJPBA4AwBmTvsGkHDfzpHInievK/2J+18hjPAESm3?=
 =?us-ascii?Q?jYGPPCNS42QOtfmG+TfwDauPWMMGQVuNS2vMIxsdu+vXXe/gdEPQKUSmyEJ+?=
 =?us-ascii?Q?HEbordT3DvvK5vrj5p5AtgLUZtMqrZJa5twenRJY4L5R4KbdwCfTNIgipMzN?=
 =?us-ascii?Q?+ZSSKG2/W58Mp3uN3VTOAd8qvC209Dpm/3r3TkjKJAQcZJ/FG/DsnUtdDpK6?=
 =?us-ascii?Q?SpE+5vU631BNLhcesMRtYnsYVabFmWMcVb9p4TO4f4qAWtmFcEywuJJBM6iK?=
 =?us-ascii?Q?zSvZmrVOXo52yMOfga5rtz+0VWbt6xrrlKI2zPCOq4K6+LqUSB8vx3NkfVEm?=
 =?us-ascii?Q?GCT85oq5dRcNctVnkfPhSTtrTqiCEOOF5G38fIVPd5hD+43GBEi+xVT6qn0m?=
 =?us-ascii?Q?dEdlFyId9W5W6kbA/o08rG6hEYPUuaxmGLAIKoR0zwIPZiA81NV3xnhAiYqJ?=
 =?us-ascii?Q?CQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30BE6B5D76008448A765874A0E81A98A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b079c78a-1714-42b9-ecb8-08daa08e7e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 13:45:08.8657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EVREY8LOU50oF2ZWQAmUbFVVeVFzeR8ExK9B45jctvrnlZ1DgEGXLmGN6B2+85zoMl2w7S9XKcK2hcdqZvpI9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7981
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 02:54:58PM +0200, Paolo Abeni wrote:
> On Fri, 2022-09-23 at 18:45 +0300, Ioana Ciornei wrote:
> > Instead of calling the internal functions which implement .ndo_stop and
> > .ndo_open, we can simply call dev_close and dev_open, so that we keep
> > the code cleaner.
> >=20
> > Also, in the next patches we'll use the same APIs from other files
> > without needing to export the internal functions.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> This has the not so nice side effect that in case of dev_open() error,
> the device will flip status after dpaa2_eth_setup_xdp(). We should try
> to avoid that.
>=20
> I think it's better if you export the helper instead (or even better,
> do something more low level-cant-fail like stop the relevant h/w queue,
> reconfigure, restart the h/w queue).
>=20

I would also have wanted to not have to stop the entire interface but
unfortunately this is not possible.
In order to change which buffer pool is used on which queue I have to
stop the interface (dpni_disable() ) which would flip the link.

I can export the helpers but this would not change the behavior since
the dpaa2_eth_stop() and dpaa2_eth_open() are the exact callbacks
setup for .ndo_stop() and .ndo_open().

Ioana=
