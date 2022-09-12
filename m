Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2265B5DB2
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiILPwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiILPwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:52:39 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2083.outbound.protection.outlook.com [40.107.20.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564CE11A3B;
        Mon, 12 Sep 2022 08:52:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icP09uMUYdLWGDzx2rJidh6a2Fdrsu9MYZbfjZWfOYK5fxaGAR6iaIiBnNwkdQ3ldvC590ig89Zm8EV/3X1vxpeIgMCn1RB9LvWBOg4R8UvLfpspt7J8vmfzISUnZIS9/9LlSNKMU6sAIS7ybolum2PXxQ+klYP2mmKUUC/9G36d9OBRM97JLoOu8+LcUC+rwuXkRq90pkpHmvpYsPD0lKPeGfsUTk0H/vZfnEop1FD3Z/eLNfP7kJa55cq2IMdXdNpOBEdH4JkYYr4ovXtlYUEUxwmpDkOL/mUe1YG4yWP2QKRbb7sf9ZSGwECqxUenyC4f9V7jAmbizOkb6W1mNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DY9T1UP7lQWf2BM3lP7iaHujmPjuY6Y+MhJHEaqg2ds=;
 b=CbAeLKEy3PyS59FojgzOA6Z/w9qkJQRe7vzEumCayWuzu48D8AeClwo3FypOCUhYijN7cq5Hqa6U7cDp/EO10KJ+t5ElBC7PfDlDV1Sdtmw4ITek74I2l5OLDKpOQtYVexlTelBkQjfPbIlJwiNCjLaEnOKPR8j4NZ/TsCqnCneJobAiq9Tzxifs8aA/qdUWyDNT/k+1w+K4i9Wp3XwN4wCAPnUNvGPCMTH3EkkWHU4/t364leYw0rJkZp+ynuHjb38qvCi8mxfCQvqQSV0q0FMwp7mKZahsIAokLjcHBmzmecY8MFwTLubgWqv83YQTWAzxmE8b5dW0w68x+2dGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DY9T1UP7lQWf2BM3lP7iaHujmPjuY6Y+MhJHEaqg2ds=;
 b=KQm3hNnUop7RPtPzLoN3REu5SVw1SVWWDDMDTpR/8wKMs9oZKmcu9Qa29WrR4ti5a+4CfsW/lofGx8KpOfH4GMsOmGjf/vrFtESeWZ8XhTeLvgXsRxNjqWuu6bBOCa/euneRmgcMc6OAgmGZeiMZIK95O1mZqyduX0hruxY6E7s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7792.eurprd04.prod.outlook.com (2603:10a6:102:c0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 15:52:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:52:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Thread-Topic: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Thread-Index: AQHYxhmBz++3+4sxbkG2gbfVifdN+a3bfLEAgAAYhICAAFyagIAAAVYA
Date:   Mon, 12 Sep 2022 15:52:35 +0000
Message-ID: <20220912155234.ds73xpn5ijjq3iif@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
 <20220912101621.ttnsxmjmaor2cd7d@skbuf> <Yx9Uo9RiI7bRZvLC@colin-ia-desktop>
In-Reply-To: <Yx9Uo9RiI7bRZvLC@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB7792:EE_
x-ms-office365-filtering-correlation-id: 5f15341d-d708-42c5-e417-08da94d6cfa7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ndzIucW9sbADoYuP2T7+BS/FP+aJ5baR3MMyL0bc6QTb38g+LWqfeeQHCYEvHH5HJ+bYiOOdviKBaNN8510OFHCOx9Oj8pIeUcq/4IIJyIOpxxLChjN60lECYRpu3JEzCRJlLEbmh5u6bHDHBXVDCCyN0EzIWaZot33k69qZAxugyOiXmrugr9s8lbpfix9HLk3VG/yfo3UmiFtai2V165RZX76QWlIa18AOVOXwDiwUmIRFGBfVUSvkLnfiwVbOoycGQCEM+mS2yPl2GZpYJb6+bXfTDban3a94vX9qFOJOrynNxYM+k4l/Dgda7jC5392yGnPYwCT4/XirAUnNX/Fp7FrjzOyW8DDImDmwqar7KRiE2LdaXdDpoQ4ugM58PcyYQracAIRbAXBLfGAeiG/7NZZNl/SbWA1KY1ioy4y6hlbQKs+gMxvb/pV+e8aQYSYPnJrho19zZA5c3jv2BjE3olyUegLZTuupA0ZguKtRBIJaXJwB4UUtd0pDR6x4rXpHM+c9tZv8Dfzhuyz2fWnTeQrrEdzPhaB2e1kO54MwyPLm7bjGhDEygPIDP8uhDX1nfKsie63aChHUTykWWoSGwmxVYAMnVc5ocnUEW7cYgV6r2gSkxNqb8xwHEwtCuztiSvnmKvXd5e+M0P1VMI42eHuDEQEA3fxnw0z7Li8GZPsP3Kg3kCqS6Ld2Kv18qYkKgac9ow4LU3VcYZDfJR7qk8vjjCoTsRZDsOcv3nJ54qW8ugHjPneYulajISKS8sJk4b2HbLozfjtsC/mEJCBNyOID40CWFFLGr6Ksj00cLt6uO+pAG8mrzLozeRfL5m17gVXmUihtTu8LCTLOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(39860400002)(366004)(136003)(376002)(86362001)(38070700005)(122000001)(4326008)(38100700002)(64756008)(66946007)(76116006)(8676002)(66556008)(66476007)(91956017)(66446008)(9686003)(6512007)(71200400001)(26005)(44832011)(478600001)(41300700001)(6486002)(6506007)(966005)(33716001)(6916009)(54906003)(316002)(1076003)(2906002)(5660300002)(186003)(7416002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mwWX0NlE2V+BobHyvj0SwfEsL54y3zjDnJti6bruCO9T+giSzgHnTVMYKf8X?=
 =?us-ascii?Q?qoru0WSvkSwqCI4nBgtc4ay0k536zo1OwZcEIzWSFAuxSX7EfXMXCK/+K/Zj?=
 =?us-ascii?Q?et+x6iRcqauL/GXna/7r1UNAKuG5g8Ua65E1xyawsYA4re2e1BTsUMADgN6U?=
 =?us-ascii?Q?y7ArkpLuVkaQMdLgtVDBzBpIFn8MzbygIiI+rmfYsD2l4Ub8U34AxnGBfH05?=
 =?us-ascii?Q?/aqJ8IUgHvFcWyM43B1JTo4vS4MYf1LfWxPhXJ7cimX0PtzvvBF4ifk/Aj5R?=
 =?us-ascii?Q?sW2HROI+jghazKtNGVOA+dsggyaz/qGy2+3qWQDBUpFIN3DXuPtkTMttXpqV?=
 =?us-ascii?Q?4Kq7ldZUfnstmCetSzCwRwj9D8sEQ+Sw7494Fci70RwKq0uewf6Bs8eTlOG+?=
 =?us-ascii?Q?0p+dYKmjr+f+kN3mh0F4X9SOd90ukQoaA+jKjl5K3whQHNGNdtPgxFwvX6gJ?=
 =?us-ascii?Q?W1wXPyM89mCXkWj8V0wySCw/G4oeqOkcLofgtfd81E8jZnkOhRXT6+I0VD/q?=
 =?us-ascii?Q?cZb8wYTIEabBB4vMRLTbtNFbAeg1U4ARIozIxfQt95+oyvbeO+gckWGEF9vi?=
 =?us-ascii?Q?/9m9aM+XkBi6dsRfquWBPoXyiJewSf0rReXY6fmeiWDyqnkKOmBB/iQ3aEr3?=
 =?us-ascii?Q?PDqIpl6aniSGmL36X4yQRS3QwfHiWf1TcqN/8fi1R40y5YO2o+ydCxA+COf/?=
 =?us-ascii?Q?P90bAWVab7gLATzAWqGPPqqRqhP3NDuEn02n3GjaAlpQhIKUq4VHKXLYrQUb?=
 =?us-ascii?Q?MO20wnldCDozwoGc2ZKz/GfB7XX/ZxEladM2NHYZnWTiug/O8YHv3iUoA6xZ?=
 =?us-ascii?Q?fzZYlXl7yzJBB6VuXgG0T9KhP6SS22GZmJ8k/OVORndbHWfAXAvKNSpk4K3f?=
 =?us-ascii?Q?KeuSdGoX4rJOs23d97t3c1mYX/0RQeQDxeQbeWHz5/VFayMbGRDL/b8d31Wm?=
 =?us-ascii?Q?ocihUS1wdVfu/4Kr3LnwcWN6yKNSPxRW7wWSix8pok+yDR5OiofG/yzVBVce?=
 =?us-ascii?Q?i5Wb7Yx1lSyz/bJbCChVZwJo2skbTrAePnPeBdUt56i/kr19gw+ObRv2uW0W?=
 =?us-ascii?Q?D/34VrKDNKkn2sntTj7/vilxT1PHyTecSV+bSOVERDtVP8R2nZXMALSzoc4e?=
 =?us-ascii?Q?n/ytd3YvvOOKFLOR9DDONrWAaut4Vt5to4+HpSpo1S1T1z3SvDZg/l4+Ow2h?=
 =?us-ascii?Q?EsW6Ory4zhGdTLFy0JfDdxRZ6TQrTF3LZadvRXvZwovMYCc2Cw2MU/qakbIi?=
 =?us-ascii?Q?T7m/pnuGrkvlpeCjylFwVyoNbbrDpS0IZYWKtEydgoOfuO0sdEuVkWNMLioB?=
 =?us-ascii?Q?Eybs2x1zCOTxctXi3pFT3HsKKDMlzJmM1e06CMmO2HugAmwxPtB/cc+ahe5W?=
 =?us-ascii?Q?g28kpT4/jwC3H/rq/lPAEKo1NsGKw0P3qX72Ifks9Sm2gi/dcQCWqNeuQeDx?=
 =?us-ascii?Q?yFzAP+qG9vspeigPSIqao0LfOMDPB/LpPKTTjHOI38uhHyTJUk43TB6lL1LZ?=
 =?us-ascii?Q?3Y25utKDAR5WmXOKINd5x9XaqyS1F9+fRz/2f3DLh1p9duR1nQo4TJ+PJtku?=
 =?us-ascii?Q?A5zIkOSOs1T2fSBwR+SpNBxebs3AQ+Ml8vyU++4uJKtdx3u7aW1zpZRC2EJL?=
 =?us-ascii?Q?xQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17702AF084BED348BB2632EB323CFE40@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f15341d-d708-42c5-e417-08da94d6cfa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 15:52:35.3832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ij06imq7tkxDdBwtv1C8j83tf+27YAc0lPn/32UwCmHVM9LcW4MDSCvpH4LExQ3HGUSn8JqAlgc4nyZTLfvjXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7792
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 08:47:47AM -0700, Colin Foster wrote:
> > This is true. I am also a bit surprised at Colin's choices to
> > (a) not ask the netdev maintainers to pull into net-next the immutable
> >     branch that Lee provided here:
> >     https://lore.kernel.org/lkml/YxrjyHcceLOFlT%2Fc@google.com/
> >     and instead send some patches for review which are difficult to
> >     apply directly to any tree
>=20
> As mentioned in the cover letter, I don't expect this to necessarily be
> ready by the next merge window. But seemingly I misjudged whether
> merging the net-next and Lee's tree would be more tedious for the netdev
> maintainers than looking at the RFC for reviewers. I'm trying to create
> as little hassle for people as I can. Apologies.

What is it exactly that is keeping this patch set from being ready for 6.1?
There's still time...

It mostly looks ok to me, I'm in the process of reviewing it. You
mentioned documentation in the cover letter; I suppose you're talking
about dt-schema? If so, I just started off by converting ocelot.txt to
mscc,ocelot.yaml, since I know that the conversion process is typically
a bit daunting to even start.
https://patchwork.kernel.org/project/netdevbpf/patch/20220912153702.246206-=
1-vladimir.oltean@nxp.com/=
