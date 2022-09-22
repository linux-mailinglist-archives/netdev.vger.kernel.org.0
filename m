Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3D5E6B2D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiIVSn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIVSn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:43:56 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20082.outbound.protection.outlook.com [40.107.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAF1DCE89
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:43:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V354m+hmZpS7Nf59Abj3zh10wEVtC2KD29+tUoGjFW8rk3Rur+KOwsvi6iMPPohde636vm0CVVJxYhRiE013FvSdNn4bINxCLSu0mkx18391lAOisa9QITE6f1xzVO50k6XPobzK/0amSuip5Mczk5XRa4WEKgXTwtsCBbO97LGm0vIdGJaAYU1QLjvW6yY+AUB7iO+DS8MDGf5GZGJJPM1bondGhrqZ9fZCoWXzlGGJc+9fm8QMdAyPNMbQtVjXjcpWa9+lmdjrOGyXiYegIQLsfQ1QSiXlm0UYwPjNVbmlCiENjBaHY4Djmw7v/uf0lET4NhfuOIknKP2Ai1qIlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxKFJk0rk/uN8e/mZAQzY4DN2t3QykgbLL/2ft1FrbQ=;
 b=Zr4jE274wa8WVpLBtkQriPZu4SEoxo36WOeFlNh08LfYG6Vxx2ldYljEAqR3mlKTFoP32jVL6YUIwUZA/JB9CywDxizeECvQP/pBBmE4TePKMmL9UAehYKm4wEB30CZCEJIMHvG8WXQWadlZYDgnbCQNvM+Ebzux0JJ0+rbF0GzkLuvkccY1okuHxGE9mQ2pE9ZEUyzxukjDY+WszuYqjogEmbLjuh0Ha8KVsqzTJ5QpKWy7BbCUreTPovXOch0lIzJAtcnOHuvCxg3mZ3EZH1xYx5l8WtdwA/Dxij2HXNirtn9DbABu0NiVLqtKimFtuqah0xpe50wesOtDmuTUVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxKFJk0rk/uN8e/mZAQzY4DN2t3QykgbLL/2ft1FrbQ=;
 b=OQqliPOyKUGGnAYxgxvOJrO14S/dSv0Fl0o33Nb89F/6nCuRSn7yjErWGM35NVUDi6fxZPzF0FdeCx/MfQOh25JV6cOIN9YlpFCqfMNKPxd/mnnJoSrUaPqh108iXLJd5d04kHcappKuHnMzQjF+D+mmDx4fzifhZuIPImEZaaU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8281.eurprd04.prod.outlook.com (2603:10a6:10:25f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 18:43:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 18:43:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEHDgIABDlWAgAARNICAADKKAA==
Date:   Thu, 22 Sep 2022 18:43:52 +0000
Message-ID: <20220922184350.4whk4hpbtm4vikb4@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
In-Reply-To: <YyyCgQMTaXf9PXf9@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8281:EE_
x-ms-office365-filtering-correlation-id: e8c34321-fc5d-44dd-c1bc-08da9cca6528
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DzyVZrZ5fH/OlewnxHPEbYmrWJ1A2Of6sPbABEjJ8n9iP8g5tWlLGtWpeJ2BhSJYjXF00g3CxO12c4kz4R9/dd/GEkzjMBQi0vJBUXHuEnyibbVxxLJi8aHZy4trs00cik4QyD6KA0q0loQnGI/NQ5OouzJ914c5y2pKtIrQQMoKWJFFJefKv2UJB6kqPp0fXFLN+C5MkB7XQwKETUIjCIJCWCb+dLKDNuLeagqJuCaEiGoTARyQX8mV+CgOSJS4x179oNvZK/az4Q8qZ0WKSiPkLPWJocZq0MR0sk94/FxunHTXZQXnXFoEmjYgnAWJ6KHjKwcPSWMqQex2WTTrq6/qCzPM5IXEXrT2AuNxhVdxPO+aDBsCpZOP8215Nz+vT0AeChojHapb8zOU9s9QRFC/9z+xigY5oJ74WbRpqvaZJ+twplaVlIXUx5VKEpDkfkaw/yI3Y5Ir0jiCvWMwOJ8JTINtp/8F6/EM1uWQJC7/t7CRhffgPX2qGCSk30TUUaRJqE6i1ciWNx8qg2ikFeW9fHHtGWkJp4iF1riTbBknp56zngvN1MVebjcOLCgych/tlmTObmwvob8zdgOt1rptUxd0gFFclMWW00ERQ2yDP2pd5zLu/PhPfKCV6bGUoCbkvHEGMBAeqThjpfnL0YXIPpCzHQmJuSk5KLWkOX4gipe7CpcLCy1H6CTcFte+B0ySsqjJePm3f5SEZJFHoGORefXH8Ci5OuZAZQaKr/+EjEX0WhBtkc8l89019x/uuAZg9EKsHPYPBoxfYH7zS2t6gmgfFYGfqTF6QIAKTh+pQ9ELdETYvj2Gg0NpYf2sGeU8NI4VP03nN3+bAcPm/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(6916009)(316002)(54906003)(71200400001)(38070700005)(5660300002)(2906002)(91956017)(44832011)(33716001)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(4326008)(86362001)(8676002)(8936002)(41300700001)(1076003)(186003)(83380400001)(6506007)(122000001)(966005)(6486002)(478600001)(38100700002)(6512007)(26005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KMLiSz7EeY6cu+hOV6WdaKNcVbduXwanpRXKzcbNLtD0yknD9xhjBB04b9RO?=
 =?us-ascii?Q?CGE53ncyH34SEaccxZvCPbANwbxRKSDLg4nsHxPVgsjox5NmRHrXIXRbc5+M?=
 =?us-ascii?Q?cYTTJH8Irh/ZnuCL+VaSr6QOgkQVvjADBHyYESNIcRWNcpZfDYY/Ywe/FE2H?=
 =?us-ascii?Q?xIato2j+436Do8fDB2NIZWCn6GiU+99RwH5CzO6hosO+7pg9QB9RrMr3219U?=
 =?us-ascii?Q?Ej9vJHweeXXRnIWU97GUwO+7XUiRgWoJ8n8BfihxyVVUfcaeXEH5mo6CIDVm?=
 =?us-ascii?Q?bbTfD5ULB/zlnbAtrSQq/m5F1RYRJo8DfTDiqXVaPmhNNH3PzPa2vbdm79lx?=
 =?us-ascii?Q?593qaZhh7j0f1TNGxPZ9juaUtksbvc4o5zYv1CFnYTzTAR41kPZLWTMUzaCP?=
 =?us-ascii?Q?BqMqjIFFgN1CbFhPnYTF9Gj3XPa0hsXHUf4YozhDwH0AICPVW+k8S86agsmb?=
 =?us-ascii?Q?6ERuY5qnH7FobACkaH8rqZ+kVuCZF2slo7Gwu56EUdXQK0FmtFXe+1qTTVND?=
 =?us-ascii?Q?LddnyvRkWSHYz88vaG19Lk72PKpdqhSHckgMpyLzvYAhkbBG1SF97SgtCejC?=
 =?us-ascii?Q?Rkin3FoAZ9Rt2Y9nr7MiuZ19LGM6Awm9j7v+Xul4ASgZm6SS2IrwkOE8cCpg?=
 =?us-ascii?Q?SFDT/78XSo4mvE/6/cyOm2yBf5vpIKP95RC6IsZ8cvWt+URyLIGVF1NH9b0/?=
 =?us-ascii?Q?k6gNPXowT0Y7DSXpwIu27vIJ6MipxECnQk86PErlSrOPufedQ6t2rcXWK5YO?=
 =?us-ascii?Q?xVxMvAeDIEjCDGG0M/v35mbpFY8rQjmFzGhcn0Oo6OFVKHLBCRjxQTz/x+P9?=
 =?us-ascii?Q?Nw/LOznQhRVCErqJfVxuxksbmvt7cE/ZJwB75wP921oaeFxQUXA+nHX3n9Qp?=
 =?us-ascii?Q?r5Bo9ziNjvLiH0zyKdMLJ6omTIdM+r5agBcjRXQeWbGEAcAmw2e17itHXRha?=
 =?us-ascii?Q?08N5Y5tusIF8nV4ko4i04TttXyfSZ3SRcYmiO5T8FexMuofgrvIZRmb6jGDd?=
 =?us-ascii?Q?9AsML+9ccAvIn4Mh1JEZSra1WWU7MT0UdECSVD50nfX0FS9wQUYhOrnE1HVq?=
 =?us-ascii?Q?jJi90P546i6fRwWNZz2e1xiM2x00UoiZrfXP/a0kx1Hs5JALrjXG0166DKbG?=
 =?us-ascii?Q?tcUPEkIFgDTYfp450RbRLxapotYYWUtt77tAcgr1a4XEhIfXt1mTsCHlc3M7?=
 =?us-ascii?Q?xfIFjXV+X5Kz1eGtvfpqoa3g4Cz+29bsJD7pJSxjr5+TKx/4D9lNL5VG03PM?=
 =?us-ascii?Q?ZReZA2tP20fkV/hKXHVLyEv17++o9RDuvuvVcC8U9O5N6dKf25aoyRTpm5ze?=
 =?us-ascii?Q?IHSD7ez0Ct8g9U8CfOqfjrri3mGUIq+N3ROosICNHVgfUlS799ua0OduSvOG?=
 =?us-ascii?Q?fOEUu+D3UtUz3OzndGJ8OYXiSaGcqlXd6rNLZeWr17hO6uvqnV6v1ISNeSjs?=
 =?us-ascii?Q?IrSgW3mJvxmzJ3o73TrhrvlTAicn393TsxCkwcHtznirB4uW+yJvPCkHtuUT?=
 =?us-ascii?Q?J4X0/RTvTgbrdakMfkYpbA6jBK6oXuu170pA2my5nPDIjH5Pd9rffeUABYPA?=
 =?us-ascii?Q?wLOoQjajWYWAnB9NS0gO01F+zyLZbtY4QhhmSzlbgWI5S7hvLEzXce2g0xWD?=
 =?us-ascii?Q?GQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0851537F1A72C74D9C447F8DF8855C53@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c34321-fc5d-44dd-c1bc-08da9cca6528
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 18:43:52.0530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7W4giw6SkyLGljNUKwVibfIiu9z0QVtUp5wXeFpxHdzwU0/ZVpR86WGqmo53x7yqIWhekLlFz5Iz89ePSbkow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 05:42:57PM +0200, Andrew Lunn wrote:
> On Thu, Sep 22, 2022 at 02:41:24PM +0000, Vladimir Oltean wrote:
> > On Wed, Sep 21, 2022 at 03:33:49PM -0700, Stephen Hemminger wrote:
> > > There is no reason that words with long emotional history need to be =
used
> > > in network command.
> > >
> > > https://inclusivenaming.org/word-lists/
> > >
> > > https://inclusivenaming.org/word-lists/tier-1/
> > >
> > > I understand that you and others that live in different geographies m=
ay
> > > have different feelings about this. But the goal as a community to
> > > not use names and terms that may hinder new diverse people from
> > > being involved.
> >=20
> > The Linux kernel community is centered around a technical goal rather
> > than political or emotional ones, and for this reason I don't think it'=
s
> > appropriate to go here in many more details than this.
> >=20
> > All I will say is that I have more things to do than time to do them,
> > and I'm not willing to voluntarily go even one step back about this and
> > change the UAPI names while the in-kernel data structures and the
> > documentation remain with the old names, because it's not going to stop
> > there, and I will never have time for this.
>=20
> Yes, what is being asked for is a very thin veneer. Everything
> underneath still uses master, and that is very unlikely to change. Do
> we really gain anything with:
>=20
> .BI master " DEVICE"
> - change the DSA master (host network interface) responsible for handling=
 the
> local traffic termination of the given DSA switch user port. The selected
> interface must be eligible for operating as a DSA master of the switch tr=
ee
> which the DSA user port is a part of. Eligible DSA masters are those inte=
rfaces
> which have an "ethernet" reference towards their firmware node in the fir=
mware
> description of the platform, or LAG (bond, team) interfaces which contain=
 only
> such interfaces as their ports.

Let me make sure I understand you correctly.

You're saying that you think it should be enough if we make iproute2
respond to "ip link set dev swp0 type dsa conduit eth0", and show "conduit"
in the "ip link show dev swp0" output, both human-readable and json?
And the man page description stays the same as what you've pasted, except
for replacing:

.BI master " DEVICE"

with

.BI conduit " DEVICE"

and so does the IFLA_DSA_MASTER netlink attribute name stay the same?

In this message, David Ahern said that the 'master' keyword could be
acceptable, if an alternative was also provided.
https://patchwork.kernel.org/project/netdevbpf/patch/20220904190025.813574-=
1-vladimir.oltean@nxp.com/#25002982
So could we also keep 'master' in addition to 'conduit'? The kernel
documentation already uses this iproute2 keyword:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Do=
cumentation/networking/dsa/configuration.rst#n412=
