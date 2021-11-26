Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECB545F54D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbhKZTn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:43:26 -0500
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:18759
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234556AbhKZTlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 14:41:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOXvGLFLven36Hw++VuWZ3GInGcHnZC+C4keRv1BPNYTlWl2TtGACGJIsGCHg5qZQm/Ixdkl7KKBvur10bf6T4cQOB2FH4+l+51gttsBnshdy1lzFTknSPhh6sXRFJGL3RkKsLjplDgnvZJ94NesVQKz0c7W1ekW+N5UlDfpD7YU84Uh81C7vXj4eVumRD2czZsFxXmVr+AllVgZSsgevIn8jdR3y6o2ipoPLR93v6W5UNxAJHM3e6eUWrlBZUMkj4zUlAxkzVJld+BjL3a44Yxo1mC60/PJJ6iSjOxvTUnk7pySgoC3Sxv7EfsxsZa1j2G4tzJBpgSFVOignwQKGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TDK7Hjjglf1pIO2dXAGvGF8ao34Gi+ibzgcwEkrAigs=;
 b=Iuox5EbacRXHEmhXcmeTI4D4YKw7uLZTDtxpYaclnDKDhMRCYOLP0zo7mX/S1PcZi2reRMvXGQPs2c6yjWCEuHZ5huNOvwWWEpM/zOS3b8p0yt4YvIaEkAr0zyUA4tP2QeouW8eLBTExe63peOepHrCC/QTGhfQC3PX9nLxrwfCpZ/0IruYqdSNyQIexaDGARghY68nDdJkDqxoZdWbgo4jHjFaSSog6/BRyUh9Hk4VYNLNVX0hlr/F/mVUHYlwph/4VLJbm/NuEIsi7kKCt6m7p/pdVmPFlMfzhMjiEJ4WyzJ1ies6heITqBKOtLuqmqjXduSpO2/lxXYCy2zDQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDK7Hjjglf1pIO2dXAGvGF8ao34Gi+ibzgcwEkrAigs=;
 b=QPI1APvtmvwfT2e3+UANXD5fqbwUSh2tvDeedtlqPEO1tjpZbX5WAVrBrnqMTuYxqw/7t7F+oI7Ek/IGhE5a8EH4pmAAb/Ko7sMFnkd2CBw7U0LkEmWvdCep2830iItq6WeM2Ghgs4Ilq/XQgODU6ImCJ96E6rlAfXb97gHne6Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6701.eurprd04.prod.outlook.com (2603:10a6:803:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Fri, 26 Nov
 2021 19:38:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 19:38:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Thread-Topic: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Thread-Index: AQHX4lM06ld1R/REck2gHqZwslJbh6wU6FwAgAA2rYCAAHOqAIAAkVKAgAARmQA=
Date:   Fri, 26 Nov 2021 19:38:07 +0000
Message-ID: <20211126193806.fewy42a2hnpiudsj@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125234520.2h6vtwar4hkb2knd@skbuf>
 <20211125190101.63f1f0a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211126095500.tkcctzfh5zp2nluc@skbuf>
 <20211126103507.3bfe7a7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126103507.3bfe7a7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c94d657a-c0c4-4877-778f-08d9b1144586
x-ms-traffictypediagnostic: VE1PR04MB6701:
x-microsoft-antispam-prvs: <VE1PR04MB6701436149C055AD2D4EF0C4E0639@VE1PR04MB6701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZyoxxTDAHeYDa8h0mIoqsSadCkAI/lZKFHa2opDlVtcMzZhkUZuancKOuYSMO1eRBH452doSrRhPOilpI9L1UGCUeWO9WEwRcAyNfKll/fF9pG5xeAkOHhtbcuyuBVdTzZp7raOWmVcLFAdSF0eKyHUCiF7PU8jDin9Mm/HMCo52t/mrvZbvNCuHIAKvwVtHDoxsGmmMFMhpJB277XYRTSHbalGouMLYdRPFtJJTgwud062AfmOP0Wb8tGtXa2sb7bxQCiObAN+Cg06we9lkyGNccuF+dBsdjAYPHr521sQ1JIb2UcdeRKPW/N5ABsRlhaWHPUbjEFcp8ryF/0oquxqZ+fZvopuXt4ZFopmZ7nBrPtsoe8OEmCNkOFlhYXw2cnHNm9huN0BbCe9oWAV73EIto318YAYtBBSNh7Surm/AMlHGulyKfVGzByP6wNQILbsMUlAOstqz9c4PVMPV/jB7EVCIfXHB0xpAJFG/KWDCQ/2qoBnfN+IY68BSgRTs4GaGSnOhZKs7PCl0UsMgdlKgFggzWpcFh9RzjcRZNSfOPSevgLzkb/5r9zpSp4wD19q3U/m7bLxg34Y5kVlRw01PJWiiVlAF+bO9G2mNKrG1eSHH8rf88qTi8iRF6kDL3NbHTHGa27BERGA/hQuNk4xG89HValF9XjiWooAq5ZQXYxRfiz7ACc06QXpXmXEIlBSF/WQrYRgdkOywF2Zt12IC+aLLlcK3RlokeMl4XBhE4BUbekQpoGswEpE4piCuyz8qDYzjI3TuDMK06+pzhFL8/erQ5UH822YxUHkgtVY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(6506007)(26005)(66946007)(316002)(5660300002)(508600001)(44832011)(6486002)(966005)(2906002)(38070700005)(66476007)(8936002)(38100700002)(86362001)(33716001)(1076003)(83380400001)(7416002)(71200400001)(6512007)(6916009)(8676002)(186003)(54906003)(91956017)(66556008)(66446008)(64756008)(76116006)(122000001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UuPjE+xjV3Pi4gfaXaOQxglrHNWj4QEhSvsOyPYdeC24FR21DCIRGVr5qX5M?=
 =?us-ascii?Q?a51+zMwfk9GUhv/5C30rhv78pXX/0J0iz+1qdoulEsgv873qIYTNqPQZ1+H+?=
 =?us-ascii?Q?R0anKLwXbrLsdcDORk9SCfdO10qtc2ymo4BwUszY2Gc9Q5BpCr7anaoDpIEt?=
 =?us-ascii?Q?mHPSXMpMb+8e7O9/J7XiLjt6TQHgLnmVUQKOU9Q5EPVmvopgkjZoeks0L1+5?=
 =?us-ascii?Q?J1JHi0m3GL3dk9EIYEEKnDQSNuzMTe7cBPJVgk2oqdVaA8sRY7rQnHORXA/l?=
 =?us-ascii?Q?8dsxXwQcMYR2r3KkY6lly3IBCVgYbZFcsnDmNswrbOTFUT9Ik++GVCdrdc8N?=
 =?us-ascii?Q?+OgObGtTqLGvZUGzZIFjAnEg1edgNh7Be2yfauPXy15EjMJ/yYxc8VTF1PXx?=
 =?us-ascii?Q?w0nngwfKxQGPCSojISeJlhY5G0RQUcnm0bfQZi1Q8Cdh+JZJd6uYi3/oO3Rp?=
 =?us-ascii?Q?NZW+/VR++jxaZ2j/LMrU7X0TL5cLiwurSe99YJajCJLZ+TNZYh853Mn89Hzo?=
 =?us-ascii?Q?mkSBeedNkqoYRY4DttuTFszrX58ztbBZpHQMcG8LfqVKSVA5gA0f9+Ir3OgJ?=
 =?us-ascii?Q?B54l40KQRckqryUS6ljrOlBFQ8cY9TACgWz4TyMzbEg3C5s0SlxEv/OvgSim?=
 =?us-ascii?Q?G7FryFo/i8RvfHcJRkWC/68t1j15nXbZ//v6vzqQNbIExszSjJcR9xQrmZxW?=
 =?us-ascii?Q?3vFQda/U32DL+YUuIC+v+4Pn+CcFpESy8FM1FqawOlRqOZDKeXkp93iORx8k?=
 =?us-ascii?Q?rd0CgJiVSQgN33clGjCFsaNNULx5Te3Pw+1gy1PMFJouC1D622L7gOfqAzcU?=
 =?us-ascii?Q?sX39SZwm2BcDDWJXlJxKriCH63DWTvQy/gl/tvAnEJ622VZiH7WsZ2bICI8k?=
 =?us-ascii?Q?jIEtBFXjAk0lgGeqLG3E8T/XhbE7E67CE9+ZZ4FX1H0zdaSk6sJe5smhzXS4?=
 =?us-ascii?Q?7EF8a8Dr41wFRRBBwAyDk+MQH9fDTwwZczSBkq3kydZB3Z2ZJ0h3K+/mBL7Q?=
 =?us-ascii?Q?UwqkNvE8Dy0Ybo4WSBqT0yS4ovEFXNUr3lBN90nx6LN3OSyoui6ZNOx0lZ7o?=
 =?us-ascii?Q?F2iMiVx4x0OuOEHrod0/cPsuH4u20O2MTawU9OjsRQVFOrWO9tdHjwQlsBb/?=
 =?us-ascii?Q?WE9TpCYbeOB8pTT8uvehaZmdD/11cawRofhWBN2cbS8gaOgmsjf2N8kxmx0g?=
 =?us-ascii?Q?jH9jbhRnrTjFO/Q3bLyXicNeNi1eNCndf42okeDYAV18MAk9TCg/6wuo5kw0?=
 =?us-ascii?Q?THb9vpPYLFA83EhFM0BQZx2e3DJPcIvd7CI7v/4Sg4teivr+f1r7yeAFAT2z?=
 =?us-ascii?Q?DsBLipA9SORIZwCi06U2MlCUMinZSjXF9LTTw7BI0lpy0ne5Zqj1nTTFsuwr?=
 =?us-ascii?Q?gXRh0GiM3GsOf3BcS4B60hY8JAaS5WzTIKP+3UUYx4Pep43AvpheuP+2Ag4X?=
 =?us-ascii?Q?cACsI2ooa7GJvnAOYvvQds2+TuhwU0FbN2CFLbeet0uNNr8ejVXZe9XL2BYQ?=
 =?us-ascii?Q?5lUflfL+CevKcMyt+mJLlcUQGALcDAsMOav9BCjAuL77AjJLq4av+43fSVPW?=
 =?us-ascii?Q?PsT0FiS0UjsVJGxuSAiltFtFEL6D35hW+H4CUCLgbo8hS5oT2P3ZzFD74g4V?=
 =?us-ascii?Q?H/aCh/GDPv7bdpTOBQkiHe8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CD9F8B2C8179614294F9747813D1F616@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94d657a-c0c4-4877-778f-08d9b1144586
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 19:38:07.1529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uf1h1WJmvnWeqRzfC5PkGvUCBMQyBSHxlFmyQUUoQCxG/d32LeppzKRMgz6lARGsBXgzoJotwM8AjFWsckvkbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 10:35:07AM -0800, Jakub Kicinski wrote:
> On Fri, 26 Nov 2021 09:55:00 +0000 Vladimir Oltean wrote:
> > On Thu, Nov 25, 2021 at 07:01:01PM -0800, Jakub Kicinski wrote:
> > > On Thu, 25 Nov 2021 23:45:21 +0000 Vladimir Oltean wrote:
> > > > I don't know why I targeted these patches to "net-next". Habit I gu=
ess.
> > > > Nonetheless, they apply equally well to "net", can they be consider=
ed
> > > > for merging there without me resending?
> > >
> > > Only patch 1 looks like a fix, tho? Patch 4 seems to fall into
> > > the "this never worked and doesn't cause a crash" category.
> > >
> > > I'm hoping to send a PR tomorrow, so if you resend quickly it
> > > will be in net-next soon.
> >
> > It's true that a lot of work went into ocelot_vcap.c in order to make i=
t
> > safely usable for traps outside of the tc-flower offload, and I
> > understand that you need to draw the line somewhere. But on the other
> > hand, this is fixing very real problems that are bothering real users.
> > Patch 1, not so much, it popped up as a result of discussions and
> > looking at code. None of the bugs fixed here cause a crash, it's just
> > that things don't work as expected. Technically, a user could still set
> > up the appropriate traps via tc-flower and PTP would work, but they'd
> > have to know that they need to, in the first place. So I would still be
> > very appreciative if all 4 patches would be considered for inclusion
> > into "net". I'm not expecting them to be backported very far, of course=
,
> > but as long as they reach at least v5.15 I'm happy.
>
> Alright, but please expect more push back going forward. Linus was
> pretty clear on what constitutes -rc material in the past, and we're
> sending quite a lot of code in each week..

Thanks, and please don't hesitate to push back.

If for any reason you're not comfortable including these in the "net"
pull request, I'm okay with that, but at least allow me to keep the
"Fixes:" tags on the patches (because they do address incomplete
functionality), and consider applying them to net-next. Then maybe the
AUTOSEL people will notice and pick them up :)

Anyway I've noticed that the linux-stable maintainers are much more
generous these days when it comes to backporting. For example, I shouted
a few months ago that a relatively large quantity of DSA refactoring
patches was brought into "stable" because of some other patch that
wouldn't apply 100% cleanly:
https://lore.kernel.org/lkml/20210316162236.vmvulf3wlmtowdvf@skbuf/
But in the meantime I got used to it and I'm a bit more relaxed about it no=
w.=
