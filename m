Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8595AAC67
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiIBKbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIBKbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:31:51 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70051.outbound.protection.outlook.com [40.107.7.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C13ADCEC;
        Fri,  2 Sep 2022 03:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cE47HYhRnaiVIKFO6c+UFjiFzHHdl/A1BsK+UhjRO8Vu78LDSkZJD0MwAuotoaPyP3RGcjlHSvwl+TrdFzMBO67lrtPg/VIDoeCsegM+NGDwjEM19ih0Yr9L6/A34o571VW035u6NQ3W1yT9zk9HDzkYL8JD6BjaemEdNGRJrviwmp5+8F6pLEmDhXT0roV26dlRnh2NZXtCntc0OAU8hoFNfCXTIywp6I3u807FX3MjqTq81gkxy22QVQbN47jCe5vHyzHyHk9Poof4Q028icQrxFL40WmbGQIqUDe9s2OPQNXxV9RrBUn+8XsV6zcH3VzjooGqXawYlyppMuNxmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfwsUl6wgK/8HwtZjcMANm2SQ6KXD0/W/lFPIkI46HQ=;
 b=XBaI2Gk5O1qtNVqKNx+0ql60Q5D7KvHfrANt69vsG+jSyyeOb3TLbcNt7aYwiDFykc47Pf7RRsYjvtwi2mOiWHTvLazuAarsZGKtYEI1FCglm9cxTyBdSVP/pKCzqvFRNgosU0b0b0RRhGhaVJyZkHJx8JpCtf1Mk0QzQH92/z1a6DSKgIjypwa8WWP7siN85Cy/kFAbksahIfF6cUcc0Y07SXRtkvRlIcHZR9BUZTC6PKWMBHFc24W3xUXMueoZ0DcPUnGuHT5A7cMMfFZGT/5f9SC3ktVv6HXRQZ7ZdHuKfFyAIvbpmE5ouu70UCDzQ5MytE45EaJfm2UEP7Pe4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfwsUl6wgK/8HwtZjcMANm2SQ6KXD0/W/lFPIkI46HQ=;
 b=iFGhNjsgCfsNO9H/g2tgxgz9fhn0+EMt0vn9Go4pepm6kyuSzn9iRMvuGPDeIoCp9Y/2wxsEGin+qk+ayYgRaIp9D5PC2W0VGGOpzUSIOphKWMRC+rmTXwwZivfDFhtxyQRxYdH22YkV2otu16EgNSYp9qRiMf5rfURmicUjjdY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7588.eurprd04.prod.outlook.com (2603:10a6:20b:2dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 10:31:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 10:31:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Topic: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Thread-Index: AQHYvKsLmg9+Fvc+3E2TksPGMZq+1a3L9Q+A
Date:   Fri, 2 Sep 2022 10:31:46 +0000
Message-ID: <20220902103145.faccoawnaqh6cn3r@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f23bbc9-c8cd-4521-ad06-08da8cce5641
x-ms-traffictypediagnostic: AM9PR04MB7588:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISnHgLupkBH0hiRO68jQ4dO+6JVv3obMqAP53ngJRllS7nPgn/B+t0StdpUm2ZP5cVgTPaAvE5eVFZfZ1ELNoO3shQob+xDuVd2rSGlXXYQiqp1rfv46k78oF0qpiOxrjTeOat5XmK6oh0W3IM3QMbUDROur+wbJAQ321GepCfMH9Nw7jkmqg5FmhcQcc6dR8qdLZXzWdcFsUo1wl833RMCWvSl1bNKYpOzjewij4JHFTTDcIHc2KFL0ZFpDEm704bmhjHJH8/dI+3qu8W9UFU9gRtd/80XgrVxZMPdQ40/1t+2RXi6sZ61GPS3wSiLZleba4xzhZ8S3o47kKVF1WzFHOfcEoPGqoDoezXkfDqJK0WysCk5SE3gMbNSRmNUUYQBMcK93qDyA4LICnU5bxJaISEYmXcbGKyoEaeBREm9t8jHv2YYz9bK9wNGttSbMGdz22+RyGQFP35S/0kVX5ZJSMSyVMUbiUn7ssDdvF/84lVLh9pOatcPNvlTs0jqB1mEg9g1tHg6AaOCGjl2tAws/irber+m+EWsiGPg+BgnEdWIsU3FhPwBFWPlGNXShJEsotC1vUMsBykzmArj5Dn6qaWITl7Jfgh6FrSPG4ABnJMW9h2VGgyeurl5hZ/ay1mi94CFPhmObo5WG5yAXtwwLx2HpTrsPXUncprDyscfYA5TO8wTx4y1CgOmIHjlcvrDyVp3E8fHZFq3VJyjy5d8DMj3ukhMZrPq4S8lpl2R8R8Wz6FCU8OhepTTJhT9B0JzNgcEWD4bQE+cDele29wAchDDbAobAln3C/dFh4Q8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(346002)(376002)(396003)(366004)(9686003)(26005)(6512007)(1076003)(44832011)(4744005)(186003)(8936002)(6506007)(5660300002)(7416002)(71200400001)(41300700001)(86362001)(6486002)(478600001)(966005)(38070700005)(83380400001)(38100700002)(91956017)(6916009)(2906002)(54906003)(33716001)(64756008)(66556008)(316002)(122000001)(66946007)(76116006)(66446008)(4326008)(8676002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?HPQLhQO2OXK/DsYBTHrlAaDVHmtlsAAmP/qLihBrZD/PDp/wPF7k7h5s?=
 =?Windows-1252?Q?7M9aP13qpNJ41oEAZYiFDyidLXasrdlfYp4H+jydQ6UIc85KxVBsXFjl?=
 =?Windows-1252?Q?WeSh9KVUVor9ucruwFZFxscOcSFLgf2yx05arslt29y4VRbqGQb9U6W9?=
 =?Windows-1252?Q?SPgfJ3LtZQmN4F3xu8iHDshAqnCcXIpX4WwlVSTQr6tNuO68DVYX/zoK?=
 =?Windows-1252?Q?bl64f65QaKhSxHATppuq+eJlheGbE5SVDaY6zbeGBAcZzHOZ+31Y9C5m?=
 =?Windows-1252?Q?Z71FzJ9AOsCZ4QGG1FR4BgOI0DVdWbGwMs08d4lL8gcIo3eSzuRRe3iu?=
 =?Windows-1252?Q?TSmdFSlsQWSrSevqhSumbagEhk2TgILnLvVR0FfGd3njvpznw3b2jpTj?=
 =?Windows-1252?Q?MT2VHHaFJaBElq8zh+55qobzT44eAhOL9NHW/Pr5DgZXebi6vZGTwmfz?=
 =?Windows-1252?Q?yqKhby2oq0lh8BeGnO+GuC3p8dmE+6Y1MY2gWf0aaUS8Y1QHduV0kt3V?=
 =?Windows-1252?Q?UHIsQDpR/CjoHj1gW628uWrvGBP5cWM6Q4pgTA3w8AFfc0OVXBS4L2kN?=
 =?Windows-1252?Q?rG8mqTv/YDTdgdRRAYL6roPefYcyDvFyXWGnYq3TqHMz8+8vHc338sQI?=
 =?Windows-1252?Q?Y3jB46SIW8gEJlS+RGIa++gdj9PaFlUQOM2WwUoCc3FdJrrovgP38IAW?=
 =?Windows-1252?Q?KaEW0mjwbuG+B+1JDkqNj48BfAJHUosWLe0VJROOvdgCTzO0bx+xrNPh?=
 =?Windows-1252?Q?UW1N9fdTORbmEyja+dZhLDX3ul6cRkscRQEUJcPG2sca5VGNPi8Wlqic?=
 =?Windows-1252?Q?YJeXtU+VaDw5dcxADn+xyC/lc/iqzJpIRbD+VwzGgXEe411qWEhUzekh?=
 =?Windows-1252?Q?/nUnsKe0qPE++gKz/cfpRRF3+acX+sf+js80SfYusAqFlbhRV1JcwOXc?=
 =?Windows-1252?Q?kkI3DOBqsnIJrJxqUNqEipo9kC9m6Y4GojQD49O8L52uq/BGDQDHMbPA?=
 =?Windows-1252?Q?vs2A2T1c7NwpXg13Ngw4Xg7IS4NrI/SaM9N9itFQWmOf+kzjbnsXVxsM?=
 =?Windows-1252?Q?xieKkKkUOJpIIiUIJncxxh11uijMa79DJoSaCnVzOFsNHTyGL5w60kDJ?=
 =?Windows-1252?Q?6SADlvRZwpX8nNfkxeOBXM9nZFEp24pAjr01R6eVv+neZ8RxqY7hy1yM?=
 =?Windows-1252?Q?Ujjr+f/wZh6VysqFCgYgXdcPSEllmOKBaQhhGdZF8FHFlzZK6AK1CAH7?=
 =?Windows-1252?Q?qXemeGgQ5x2sx9WfRHrNOdQ3woMDhEf0YESvMZz34z3NXNAyJDe4s5yL?=
 =?Windows-1252?Q?XaCFsAgDgZXDyvnrbIt0QO73S9sxw7/oyZRosfYnz7WfSBZ7jIPWWsKk?=
 =?Windows-1252?Q?UK6O2PutO5SgdK9+eFpXy0o3m6WSmiWxefzByK093KY2Z2Q+NDQTH6gB?=
 =?Windows-1252?Q?W2dtZVrydrjc/kZnzb2CpukTJ7LQN0T3SfFhi2SrdgwHCmvQw2mVmb3B?=
 =?Windows-1252?Q?g29OyMQIGsnmzq6vfFCvwIw+/Legcr2Kz/6htyEedJhYHsgCLxpUeRdg?=
 =?Windows-1252?Q?OvtwxCQnE6PXYzVq8GA4diZWIRO/TVQgWnItM61JQmYbSjdnWxKtrozG?=
 =?Windows-1252?Q?NaHggN/yhrsjbjZvdsY9KRFYKvFEv80zfzQ/9l+mUHjoVgc56JccOgcQ?=
 =?Windows-1252?Q?X6DwhhZYidyS6MArnabTPDVVVn9nFmBXHkaU7XW1ETXroXhVh0cKkg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <511B185B3C07CF4C9B2AEA7EF8B0759E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f23bbc9-c8cd-4521-ad06-08da8cce5641
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 10:31:46.4017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /zc56xnOGUqej3XBUoA8OuzSYO552P3PiJlYMdOF7eu9Jy9sNz2dLZAR3hBoqqWvjvY7OBwAgYi+l5Ff1kGTCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7588
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 10:59:23PM +0300, Vladimir Oltean wrote:
> This series represents the final part of that effort. We have:
>=20
> - the introduction of new UAPI in the form of IFLA_DSA_MASTER

Call for opinions: when I resend this, should I keep rtnl_link_ops,
or should I do what Marek attempted to do, and make the existing iflink
between a user port and its master writable from user space?
https://lore.kernel.org/netdev/20190824024251.4542-4-marek.behun@nic.cz/

I'm not sure if we have that many more use cases for rtnl_link_ops..
at some point I was thinking we could change the way in which dsa_loop
probes, and allow dynamic creation of such interfaces using RTM_NEWLINK;
but looking closer at that, it's a bit more complicated, since we'd need
to attach dsa_loop user ports to a virtual switch, and probe all ports
at the same time rather than one by one.=
