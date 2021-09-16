Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2BE40D8EA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbhIPLik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:38:40 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:5312
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235650AbhIPLih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 07:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZsTtUawqp51sFLaRcD+ov+Bs2T/99M9XBLzJcJHI4gQf5/sOi85N6f7BCT0jzVGzLfICGM6B+orqT0XQk7P2D4JUxdceHi/077QpME/x503r/AxdmfhmTj8Tly0njgVw/TNl2r40B8kFJdNQRJB2mks8YYZlPLcak2Hj15sDw1yCkr0mqd4s+UgH8tEzamcpwD48QdWRT+50Uo/Fpl+4zw9s1JOvvSiblI592rwmcnZEizZ/h0VZanGr743BUPXBeWzO5UGd9SWe3X90CMLUEBEAAQ8Q9ESEbMZuEdILVpl88ig1rmWvzeALPn5JJXhtqgzjn97d7/LhqqSBRgWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AdCI640ugEZqPApD34/25Eg/pfoi5tOHFnEGoo7ZOuc=;
 b=Waec/rSyrKT3gtyHgcNjS9Reyadp1Hm+hSNlc/48A7qlssFObFmNhKv8bmBopdtgn6eWu1dhcfWtzBP82cMBi22ixmQpMaVyPH2R61NNOfY5FQTc2/F96rDG34YOOhsRxN5qIcTlKWimALTN5DRP1tUoTWjh3UcPPndWWWleDePbab89rJ65ztUc6nbRMt+1VZ5/GHIAVvLsdeOt4t6Ytp0xmk4CTLA07aAOnai61Qq+vdsa4lOUzGeE6S3fxPCab1daixY936kONvY1frOAwqDfMKH1ni0GJCqfGq7lVNUZHmIv2SoyJgpvRX9jvjklYFBXxr4WJ8W0c6HR4N8vxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdCI640ugEZqPApD34/25Eg/pfoi5tOHFnEGoo7ZOuc=;
 b=JLpW8hJ9u6QaI49jivcPVHOccijjABipuLOvdgBwPpmjd13Z3umqIrrgQwJtIBYlPZ+T9cVEMDtwaWIxo0BDn7N7aFkuiasl+OWKr3ZYupqY+WZGY2oELBoSTjuSglEiyXkn36xCWnoXgUfSdbuANL4vWHIZHqpwHaeCxqwYkxw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5856.eurprd04.prod.outlook.com (2603:10a6:803:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 11:37:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 11:37:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing
 MAC speed
Thread-Topic: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing
 MAC speed
Thread-Index: AQHXqfnm86w4MNSgi02/MgrVZkbyjqulBbCAgADKT4CAALpvgA==
Date:   Thu, 16 Sep 2021 11:37:14 +0000
Message-ID: <20210916113713.eaquhezzoxheqkxg@skbuf>
References: <20210915062103.149287-1-colin.foster@in-advantage.com>
 <20210915122551.kol3f5jz4634nvrm@skbuf> <20210916002957.GA513411@euler>
In-Reply-To: <20210916002957.GA513411@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80810fa5-4acd-4559-288a-08d979065467
x-ms-traffictypediagnostic: VI1PR04MB5856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB58560961D16488A8AC417DF0E0DC9@VI1PR04MB5856.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4sAaPAM2Q0GFSru/qUPDDUwwSc9lUPja+Rlxqp/Ug+Dy1/fxyrzveAe27m2pwIAAXX5EbhrTvkCQBPRloF2YW1q5SkcAw31D4mLWbNlJwSpkraCB64jrRq7YY19G36yGB/ZDZO1zmfmS605uCmeuwgSeyTV4wpRdmkCXqQDI8TgF1f6G8FMI63Mk5rB96XbhkXshiwZByVCHcmAvNDAs99u5SVXCQCHYrExfnA24xK60j5yTVTi8SEKXlRNewjekugSCjkF4+Ko+SxpHg4Rp4jebKaVNmszSJwdCYy0e4UXAZOr+1Cf3I2fn4ZsXlEb+cLCyLBRLABGWfRhJq8o+ScIxNma8xaLp9/Elean4b/A6tn790vdrl2FjNB6AiIGPmkJql5UnWXeHFWEjiDjEExzHkpu+ZTMWVMEVQJvniB4taylK8PT/BojZmJJap4OQuDPJJVosC0I3wNdvf/AjgttE9R4OqbnyPfMxOXIGIFQfTRTsNz0GJ/ZXVGa47/guSWjQC0kGYeisIDL9vMtXo3XHtwKiKwGzYhDBRNrH8jHvFCVs2qUpuNtezEmA38CYoRGzAjMhF5WZKTS2KRvn83vGT0slz8mSztPHU+SIzgGVuEpS/ZlrsE8nPOWBK6Nqr3m7lXTtSyvkNUQgEBFohSpU3OmXwBcffG3GTNdokkbKIKbKGytg4uYfjzhqPu8WgUUTg7a010+J9M0KQGMR5xyFYSIxeq5YvaRiILNCZzAwYzLxf382XSfiPoL0BnbJLMxtqXGJCp6kYoWkDbuLOlmmwUjxsDkLqxqSUMKF1Dw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(136003)(366004)(376002)(39860400002)(6916009)(9686003)(44832011)(2906002)(6486002)(76116006)(86362001)(71200400001)(38100700002)(122000001)(6512007)(33716001)(83380400001)(6506007)(3716004)(316002)(4326008)(1076003)(54906003)(5660300002)(8936002)(186003)(38070700005)(8676002)(66476007)(966005)(66556008)(64756008)(478600001)(26005)(91956017)(66946007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G8ADj0dDUNpuNAp4fv9+ze+mKm9WEuFFku0BTzOwoyWryq/sSXVGhmv6qkH3?=
 =?us-ascii?Q?1ZIOB2Mlfi9BpPuS1hC7PWwJvHUMuBM+vcZcFU6AfEG7+WQtWSMfgo1zivtq?=
 =?us-ascii?Q?8JfzVQDV4XAHRqYW9FvdH40/Od0U89KSmrx5hVIpDZiC9J++rs3tr3kE/NwL?=
 =?us-ascii?Q?R1QC9Y2ipCMs0wqHf4/N3LEjcpFyl3PMVI6VAohG1WnZwJzw+2zqwo/yBt6r?=
 =?us-ascii?Q?zR/iKGiq5Xxp1oc6aYFP2N7jjt1CQkPiKb8+Wfn0XMmqdAA9VHpX9aQ051zv?=
 =?us-ascii?Q?C3N/wsY/Yj0rI9JRcBztJuRGCYIsfYRH5T9JKG0Stlb4Fa1EPMkr/pn+TNNm?=
 =?us-ascii?Q?8p1pIPLD/G1L8PmDmYCv/d17gOdBkXvSR1LWxjhHgOe6DS1LrZfadgZfQEow?=
 =?us-ascii?Q?Xy+BZ2cLinZokz3ELBLNtYNFnV5yEYPrY4CNU0XjTASVbu8t9lHcfZgGQuaI?=
 =?us-ascii?Q?e3u+a1bMeC+ikYseu63xXIRQhMuan4FRPPvIp6vWKe9hoTZcFFQOIsQmcX3r?=
 =?us-ascii?Q?DspzElLPKxCJNU63HACV3DDIoOLTrO2qFcVWDprTE4XgwahL4VyFRKFcMDEV?=
 =?us-ascii?Q?b+hqqP8BDzP2Tn6hI+RK4eqgqkTCYFDlut0cjBW/P8OSuU4FrZEuwIpPzYBY?=
 =?us-ascii?Q?vkg3MAGQJD43bWfwk596vjkK9wB08IAltEjvOPFWrdB/kignx4u6p5maBKcm?=
 =?us-ascii?Q?dhJYIUe8OSOSEgFIJyyXFr5fIiivlfhy7JTcZiHSP7mEZbS+VOtVEasKQ2HQ?=
 =?us-ascii?Q?x/eKGbWSlrblEIW7iNs/mE4wvbRdsHOne6gSMWKt8ZHEjq4vwXutC49eGcuW?=
 =?us-ascii?Q?wldNBZiyBL6mXzJo8qkMb8voNeLrrPSKRywMq6TigY69Wcj0sFdSf9iv2Hi0?=
 =?us-ascii?Q?aA51yBGtLvkN+/+6zhWh6V7ErrMwK9l7/040JXsfgMFZgIXH4r1V7THpi1Nw?=
 =?us-ascii?Q?jzzmlEwNt7YyuUYJnIc2JGGgJeGVBxYZsxegZDvqIZRsXAqMNmLCUb8yGPK8?=
 =?us-ascii?Q?eqYPOxJKVzgHmXRyJLEcZ1xrYY5UbHXu5xGvOjOQwUE5ovXK7/pevoQVX1NY?=
 =?us-ascii?Q?P+orsdcxkFJDpYf8W+2+W+Obe71iAS99EsjY1B6zkbQMwdec3oNPPL2IsbGQ?=
 =?us-ascii?Q?3DuS4OGe0ylpGB90Xc6YzjQ64ZEDyTMxo9x580gwZhngA1jdrxsD1l2vZ5iT?=
 =?us-ascii?Q?AZK9NDnTjfZ8z6SmH4A+tgbcvoAiSGqb8gIzZphj/7/3R7UqPQOJT4QDDf2u?=
 =?us-ascii?Q?HhvM5CEv20sOLSBvWRSurU87a0KkrQ0Td6Zsb/w4kxn/WGWaTLK0wtL9EdLv?=
 =?us-ascii?Q?ymdjEwpKTvDpTN0lLPg0fnnN?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <07B895F9A57C3243BFF429A8F4EE019A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80810fa5-4acd-4559-288a-08d979065467
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 11:37:14.1287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMgVcNKNqSxzYQexUnj0WgSORjT7KkVRDqNxlPmuLDPQhUHnQpvKO6jXQ1K09MZLLzw/WCiFmBx5h8aGDzK7wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 05:29:57PM -0700, Colin Foster wrote:
> On Wed, Sep 15, 2021 at 12:25:52PM +0000, Vladimir Oltean wrote:
> > On Tue, Sep 14, 2021 at 11:21:02PM -0700, Colin Foster wrote:
> > > Converting the ocelot driver to use phylink, commit e6e12df625f2, use=
s mac_speed
> > > in ocelot_phylink_mac_link_up instead of the local variable speed. St=
ale
> > > references to the old variable were missed, and so were always perfor=
ming
> > > invalid second writes to the DEV_CLOCK_CFG and ANA_PFC_CFG registers.
> > >=20
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/net/ethernet/mscc/ocelot.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/etherne=
t/mscc/ocelot.c
> > > index c581b955efb3..91a31523be8f 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > > @@ -566,11 +566,11 @@ void ocelot_phylink_mac_link_up(struct ocelot *=
ocelot, int port,
> > >  	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
> > >  	 * reset
> > >  	 */
> > > -	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
> > > +	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed)=
,
> > >  			   DEV_CLOCK_CFG);
> >=20
> > Oh wow, I don't know how this piece did not get deleted. We write twice
> > to DEV_CLOCK_CFG, once with a good value and once with a bad value.
> > Please delete the second write entirely.
>=20
> It seemed odd to me at first, but I looked into the datasheet and saw
> that multiple writes to the DEV_CLOCK_CFG register in section 5.2.1
> https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf
>=20
> 11. Set up the switch port to the new mode of operation. Keep the reset b=
its in CLOCK_CFG set.
> 12. Release the switch port from reset by clearing the reset bits in CLOC=
K_CFG.
>=20
> From that it seems like maybe the routine must be two-fold. First a
> write to set up the link speed with:
> ocelot_port_rmwl(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),=20
>                  DEV_CLOCK_CFG_LINK_SPEED_M, DEV_CLK_CFG);
> ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),
>                    DEV_CLK_CFG);

Yes, that cycle is supposed to be completed by ocelot_phylink_mac_link_down
which does put the port in reset, and ocelot_phylink_mac_link_up puts it
back out of it. The third write to DEV_CLOCK_CFG is simply nonsensical.

> Of note: I'm currently only using the VSC7512 ports 0-3, which don't
> have a PCS and therefore don't have the PCS_RATE_ADAPTATION requirement.

Observation: as long as Alex's original code is correct, then the
PCS_RATE_ADAPTATION quirk is only needed for an _NXP_ PCS. The VSC7514
family uses a Microchip PCS1G block and the code unconditionally changes
the DEV_CLOCK_CFG_LINK_SPEED, so if this is correct, it means that
different PCS blocks have different requirements.=
