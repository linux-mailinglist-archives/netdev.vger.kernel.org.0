Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A146BF52
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238747AbhLGPds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:33:48 -0500
Received: from mail-eopbgr50062.outbound.protection.outlook.com ([40.107.5.62]:43488
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238634AbhLGPdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 10:33:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+TQ3w190mQKUmaFSD0d38C+O6Z73c1LCgX/w0NcvukiKOG7yui0Zyl9SFLvfrQ8GduqdPFq/E4xZuTSa++Anzt+rw3G17ZXJmsMqH/ZLJRUDY6Ii2OoKTap33HQjXCnH7oO4uIh4ZufdZHCAp2hqy4zBRa+vtc3WxZ/Q5ELBnj5joPDeoJeshh3NSoaAx8Nt5GE+z3c2+ijODGKjkrq0xRHkThJ6NdWSND1zyHqJzjOhszBhz/473Dney0983wt8AHHG6gTsErAFquxSl7zVsMVyyUJyqZhHx965CyVGB0fZN1SxYShIKHDpEyqBL1kGfiFIHhTmwEOBrnYwlAQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krMzLzGsAid8ND5eTI+enGOuizFP9w8kKkR8V5gIsfM=;
 b=GncwONzo/T8ayZk0M/Gi3yRwBWcDJk9PmH5l7TOA6pIdR01Rob8VCGPPl2r70ly3rwGia145aGd0S3QHprc6KaXOZdQKkaRvai4V19NwaAh5MClu9JAn96D78WvGS8+z9N6neRn3gTyaDEgzRWD8nqIKMhKb3tyKFYQaGfg8Av95WEhTO3UTVrjHMepV/61Qkt1ts110jESCYmGAMQnxLtIRB3wKrmx1JIDUr/waKi4yPQ/RW5yhGEdsg+HQA2ub7a+2L/+GCkmNrtmrNGE8mRQ+IWl7LxxaPHqZvabB1AKBPFcbVdAn+PV7/38NtXUNagVLFdXvmJEU5njtn4xtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krMzLzGsAid8ND5eTI+enGOuizFP9w8kKkR8V5gIsfM=;
 b=Ck14i9nqal1KIsY+jzDucnQO4NChcyhk9Ck5IE/fmJrzmSIM+PkQLNVsSp6pasSX2kWHEtKQK4RPz1pqsG7t3NcFIPPZl4hDeH7ycILPZvyNDBsSZuvtdhBL25hKzMd8bmOz0n9wznN5OcIZdZQxMboTtugszJp8PCkKaJw5WWY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 15:30:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 15:30:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Colin Foster <colin.foster@in-advantage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Thread-Topic: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Thread-Index: AQHX6TzcVrh3MXhiPEioPLXtrf7S+6wmTGwAgACh6QCAAAZIgIAANqEAgAAA7YA=
Date:   Tue, 7 Dec 2021 15:30:12 +0000
Message-ID: <20211207153011.xs5k3ir4jzftbxct@skbuf>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
 <20211204182858.1052710-6-colin.foster@in-advantage.com>
 <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
 <20211207121121.baoi23nxiitfshdk@skbuf>
 <20211207072652.36827870@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207072652.36827870@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12933778-2415-4b1e-3824-08d9b99675fb
x-ms-traffictypediagnostic: VI1PR04MB6013:EE_
x-microsoft-antispam-prvs: <VI1PR04MB60130DFA013FE1F89653F139E06E9@VI1PR04MB6013.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DeAgGyPib4TKhxcYOnf0goawkFBVH4mkgMGcXp7Ao1aG0CSLZFpSnxUkOf4WJPvtDk3xoYTHASuNXk7RSp0xELyJ1RZIh47AR9rhg18Bk/2oTf73grSiIrBSDV2ET84V8Bdn3NaMZ2ofWeECGzN6VLVm+vLlKgiuGLU2VBI9bXJ3NLSdMU2L3Uu8ILmUhJ9sTaWRH9ZzCq54r/LUqQh9aINNu6GPrXJ8xuGSDFs13Ksx+HtGi1/Z7dgtnYREWkxMjNkdNKdcerbCIRImLPH7xpQwSWv519yutg9mgv8NzxGILoeqp4lP4HLch9KsUzgW67dSARCvVmuJgMTfj5Yu6ngn4hC2rQLdvfLo9bZUUtNW8iA1Rugd5Jh+unhJpuWXIyjL2RqjyQvVz7Jy4/wpo5khGDSCYcY8SjRB9leYVSBv0tPNgimvTA8iA8V+UrW2yNFz45cVoAzRI7PniuFJlXZ21EAkBdTqE6PacDy9kLHsn5rDoY7EKGZaCjyTq86Gtz36Uk/QgfLkQUBktmR7BYsW/O94V/8+n6/tl9em2Zn1mJmrE/RIC7sJ20ca9J192BBgMgV9OkEtgwkjpPomyW+AYGBWKiuSyhTs1RUts8AZdc0V5egnAM7FHdlrAl8c0gxMmdifeNwUJq3yaA19DphuM295fduiC1E0y6lXykGHm3RwPdSSoeNSv4o99c/O89bCCp+nDJdRI+B5ZT8CxKik9D0DszaDNvszNRHErRP3Ur4j5Mn1BucU9XFcYrZUZLG/T9ZKNvTn5E8ArTWyGMONp9gcZGilJnTP66S4VHQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66446008)(66556008)(71200400001)(64756008)(66476007)(66946007)(2906002)(7416002)(83380400001)(91956017)(76116006)(86362001)(38070700005)(8676002)(6506007)(508600001)(44832011)(26005)(186003)(122000001)(5660300002)(54906003)(33716001)(4326008)(6486002)(966005)(6512007)(9686003)(8936002)(1076003)(6916009)(316002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JhiUvyrgTblxGRnF6TjCcXktkHI6BS94J4fdSb6nYTw6vVUTrwhDXytDOlvh?=
 =?us-ascii?Q?1aJJ33CJLPrhW9DrCbr5HyPcAwlNWdZejvg66DqTWNq9poGiVjQe5mJ4wmH8?=
 =?us-ascii?Q?nfvdHksyGJRQJKGt1jQMhJc30ImS225jUJ/8/jWWsBf5QI+p3Io+NUwzdqrx?=
 =?us-ascii?Q?Rg+E3L3Iu0n/Fv97sHIpXOKPub0hJkvZhNoyEJ9jYJ5lZz5yyb4Xvekzx5CQ?=
 =?us-ascii?Q?dBdOormP4SrgdCpOuvZ2e+2wCAZnMqoeucZPX16PlFKmRtRKGC9Io1VJYi+5?=
 =?us-ascii?Q?rjBMAumvRPxQIjMlWexutxEqjdAK6U17FI4RPeWyHqwqSnLuVBdNm5L3jApV?=
 =?us-ascii?Q?USkCYKcsn/sdQhdvYOsg5ogitDXKErNX6kqOUkTdBmy1kCoTVQqcOE8/mMOn?=
 =?us-ascii?Q?vTwica3/NIjx2uOYB3liE/fR78GCETYCnL0t9Cyfda49680nrnVTzAtu+87Y?=
 =?us-ascii?Q?KDHT581zqQk8J9cG9P5Ps2QOBOhe9BOyRAJSOssV7FUYQlXuFrOBX80fvN+4?=
 =?us-ascii?Q?tAF+DWqJdhpVAEq1n80CKO/TotgBRkqOZsz9tbllSXy/IgGqmGzCRqvBn2yl?=
 =?us-ascii?Q?iP+igFYf0I4EWEVKZJIKl7YsfgGl0CQAD8ebM26rI2cMOy0/pA1NSrJEEMeE?=
 =?us-ascii?Q?zZwFzRdOfyeOF7hr+1f0V6/tNbXqBUfi40aO5wqi9nNeBBSDRnl2eERMb6Ij?=
 =?us-ascii?Q?Gz7d80wC9VyDk+obNrj4NxKF6dTeGY2a2Jhdie2DHq4kRgpYCGWWY3yb6Sxj?=
 =?us-ascii?Q?zzPt74/xOft/NB6RIeiVN6mPtFPj3zRGrLHEdY2f7DgDd8vQb1Cn68EhT2jA?=
 =?us-ascii?Q?AMW3C6bSZjoK+npGUzknYKA2IRLMbWSI5XmFWkek5auoxVqrYrVqQaesousg?=
 =?us-ascii?Q?XVFX3LBdQ8v1bcMONV2b0HNSAZVLeBToHt2sQ684Md8EkhwLH1bFXBvAT3ZP?=
 =?us-ascii?Q?JvsM0ZHmjHBdQpCPEUkOksMgTRXX4Bghggsa7byt6NF0F3pg6zMFU+O0AntN?=
 =?us-ascii?Q?ogxEchcyoD7rZjBGp89Wey8uQwC9zMI+tac63YbTZX/NoX3+VSVhRGPt8sfH?=
 =?us-ascii?Q?ZVv7TRCWv6YXLpYVsFEW14N9wt3SeU9/Usid3dGVq6MUP+iItK7Bvy+Nw8SJ?=
 =?us-ascii?Q?bK+0dn84PQNj+ASpeb59lHO9zyL+A3VQxnL8rY5im4q9mIlSND2H4X8jeoJY?=
 =?us-ascii?Q?/OY5tlyqD1Tc4DNc4V2VMtarShxfEf7RCXEba90p6XJ7yZhAEZy4tvzpY5ua?=
 =?us-ascii?Q?/4ZJ1YUamKy/5d+N9SKnIY/FmjWEEzpMjbk7QujPARBNMUcsJ1vo0mG/KMPk?=
 =?us-ascii?Q?T8Bf1IFs9f8JcOqXa/ZS8Ds+nAnLza/x4dr8n38Aadc6CO4tRNZXIGnSipyK?=
 =?us-ascii?Q?9uA5Fcoo1REIlG3EC5ZpyPNKnKXugui2o2te8PGqW7QPIWyuFJmVoLXVF2mp?=
 =?us-ascii?Q?U8VsHRSwAiYbTE9abhAU5etSUYSf20VRucLlr/cCf2xgsODTUMcqkFErxSpZ?=
 =?us-ascii?Q?AheRTu+B9ecbWA58CGOQxu+Yqe4QurtO85XsvwMssLvL1B4iLd6J0WSRrdim?=
 =?us-ascii?Q?ZxP+cE64mH/+aV23OrOvYAyz8Mdlx+eYSQ0JHXsAj8IUCtpE1+Tyapoh3nqc?=
 =?us-ascii?Q?fx870zhDKRp66O8QgvDRJAE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4DAFE18A51540241A32A572988E7C9AD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12933778-2415-4b1e-3824-08d9b99675fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 15:30:12.4329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DV0ps1MZ+/qsb97KuU1RtHBj78Fo//qHY/4tqRVONuEOlIjlUsHxivLjhkmwMUgDiasd/qbdV96Cb2TCffjAlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 07:26:52AM -0800, Jakub Kicinski wrote:
> On Tue, 7 Dec 2021 12:11:22 +0000 Vladimir Oltean wrote:
> > On Tue, Dec 07, 2021 at 11:48:52AM +0000, Russell King (Oracle) wrote:
> > > Thank you for highlighting this.
> > >
> > > Vladimir told me recently over the phylink get_interfaces vs get_caps
> > > change for DSA, and I quote:
> > >
> > >   David who applied your patch can correct me, but my understanding f=
rom
> > >   the little time I've spent on netdev is that dead code isn't a cand=
idate
> > >   for getting accepted into the tree, even more so in the last few da=
ys
> > >   before the merge window, from where it got into v5.16-rc1.
> > >   ...
> > >   So yes, I take issue with that as a matter of principle, I very muc=
h
> > >   expect that a kernel developer of your experience does not set a
> > >   precedent and a pretext for people who submit various shady stuff t=
o the
> > >   kernel just to make their downstream life easier.
> > >
> > > This sounds very much like double-standards, especially as Vladimir
> > > reviewed this.
> > >
> > > I'm not going to be spiteful NAK these patches, because we all need t=
o
> > > get along with each other. I realise that it is sometimes useful to g=
et
> > > code merged that facilitates or aids further development - provided
> > > that development is submitted in a timely manner.
> >
> > I'm not taking this as a spiteful comment either, it is a very fair poi=
nt.
> > Colin had previously submitted this as part of a 23-patch series and it
> > was me who suggested that this change could go in as part of preparatio=
n
> > work right away:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20211116062328.194=
9151-1-colin.foster@in-advantage.com/#24596529
> > I didn't realize that in doing so with this particular change, we would
> > end up having some symbols exported by the ocelot switch lib that aren'=
t
> > yet in use by other drivers. So yes, this would have to go in at the
> > same time as the driver submission itself.
>
> I don't know the dependencies here (there are also pinctrl patches
> in the linked series) so I'll defer to you, if there is a reason to
> merge the unused symbols it needs to be spelled out, otherwise let's
> drop the last patch for now.

I don't think there's any problem with dropping the last patch for now,
as that's the safer thing to do (Colin?), but just let us know whether
you prefer Colin to resend a 4-patch series, or you can pick this series
up without the last one.=
