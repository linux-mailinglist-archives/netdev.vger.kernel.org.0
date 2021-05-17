Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF103825DE
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 09:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhEQHxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 03:53:02 -0400
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:26464
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229755AbhEQHxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 03:53:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNzlkvgCTeDNLtUXzfPTn0t/MD0/E81idzmynE4Quatfhx/oJ4t1iNbDhRVT3Wzcjza+sxu+T1nCSm87Z9k8kqRKFMmNNHwS+RpTNw+L4odi58twW+/hImz68CPJ4PI59i18nZt6UxZP3WavrDsZ9K+CGridyEcPTuNvKkZVr/QRvpjqD6/vGte0pdIpUOBCbXUyBNGeyqvGD4S1CIprYhLUqIbsMz9b3RjFfbKLBMsDm0xlzZSpj+mpazfT1m3kevYjPDuVim5nSILynlVgifX+wIYEYcHIRcjX8XMIVtXvxVngT4zeXjxOoB7lVnou0uau6OheA1n5ncEXlkK4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ1b+Cp8dYqQDearhjGUo/Jhx2tC+3GuIoNSjeTBXhE=;
 b=kQzkf93dVsCE3uZA8rn1758i4jcRl8IRVCaudwUJKivTbphbYSL15MuQ0Pq6O9yqMry5yiOWIFNSFrDTgOGsKDqa5QARQEbWa92qaJFI29IsVlUqdDvFFTKAu6Z5ClOYnoO2HxpRzXtU0bymDqlPBk9KEtYKkBy0QD/bRspnhnsODgvGCOaa8ZAFaV0E3ONp5gw3inJ+89PHrcrMOazYjugCQLx834nuqRR0fRsaCdPZV8UaB8RZyRRZbCkmJXwTvIhBk/kAyyrpfF60dhr05JVy/pqSKh80Oc/Q/Yp0TaVaH2DOp2nu0v+2005JoYC93Ib8fL8KzPd1F6s4q1c9Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ1b+Cp8dYqQDearhjGUo/Jhx2tC+3GuIoNSjeTBXhE=;
 b=diauJwnbw636/+cnQIP0wZUBK6MzEuoS5qBGWTFDnQ8jj4H0KZIptl4P/zzRPDOc4qmRzRDwqnkuYNW/lbPs51SQBYIBw5WhhUYwo9nSwNEeTjf27DXvmA6Vm+7LHr6yS6JAqyzQLou5MKg8aVNYaBNzw9wnnUd+yKLuzE7kRilES6ALbBVfpumT6BY4A3L850/M4ribbDEUpOpslUx0BVY7+RvL6ew7Pr/Vllww7UHqMNkluFFwiopd4ND+dpINLSv/bZW8RVUki7sCCbvT6QEyPz7Z9IM0bqVwQjfQ57HU1j6DOZQL7yzuRlwQB5Hl5PTC6n1QKpUqbqMUf7C2Kg==
Received: from DM6PR11CA0024.namprd11.prod.outlook.com (2603:10b6:5:190::37)
 by DM6PR12MB3308.namprd12.prod.outlook.com (2603:10b6:5:182::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 07:51:44 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::66) by DM6PR11CA0024.outlook.office365.com
 (2603:10b6:5:190::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 07:51:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 07:51:44 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 07:51:43 +0000
Date:   Mon, 17 May 2021 09:53:01 +0200
From:   Thierry Reding <treding@nvidia.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Message-ID: <YKIg3VDupFYPLB1o@orome.fritz.box>
References: <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
 <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <c4e64250-35d0-dde3-661d-1ee7b9fa8596@nvidia.com>
 <DB8PR04MB6795D3049415E51A15132F59E6569@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <e75fee5a-0b98-58b0-4ec8-9a0646812392@gmail.com>
 <DB8PR04MB6795166AB5A04B4D4B7DE53AE6549@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pS1m3niJB58aDBvC"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795166AB5A04B4D4B7DE53AE6549@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-NVConfidentiality: public
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2121b3b-b732-42ec-0d69-08d919089d8c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3308:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33080321BAAD9BE87914ED49CF2D9@DM6PR12MB3308.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AtZJwhNXKBaumvjrPOAZqNSovitKYpXsgn/mW5jAlKJbS7RVpMjmwbBV/P9GA4fdMc59nC7rTZrJJtxh5xhXK5gsvnNMjCb8f2YlVvuVbjSuHztWqk24twvJpxqp58QxQCbgPQqPYno/dbps1i+rF/zUGzFiiFxxuA8Efojn5IDJDQ+WLJ2kdk9LZ6lYHgrr55exDMrC+haQAzPPA4fJzSPDGVN4CaDFaqkYtBabR0I+by35gc7d+gQCoIQqEFeLp98vcw+TzhcSMzswBU9QUHrenWtoYWMJpPNTO71WSDJJx4qoDaIxCjOb6CDbUV7VFpLdNJfRBlH4qGi8JiiCz5uPw9qQ1X25vg0qRUcwNg8+F1ruaSZLawUtE+Gd0y0DfDkxRts7QhPrcqzp5qAfZmlnTC3G8QuC0f8nS6vPwh0ullcki4/8s33nNCClBuX2rAtQyEJMI097losMbD2gzWApOf7Lhx8PFnwi+Db9NSqNChCPmnw9Gj1C4OFCbfj7fXnAPlMsm+JbkajRhfH8mSM7YZFgA2A72faBlD+DJX0vpOfk4Q4RQIv7OnfNgCyHcxMBJLMmMJHUPF+hWp+oMTFH5H+IMMuhN5z8vZAb7KNrXJ73HBNKEXbGv00n3xWBW5Gkp8dG298PUmkd1pGgekKfk7TGIdcBHdWyJQkXbuCTgVCC7VU6VdiythgYb27LD69AfQ7BJQp2ZXh5t2LOtg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(316002)(36906005)(54906003)(5660300002)(4326008)(53546011)(33964004)(44144004)(478600001)(70206006)(70586007)(8676002)(86362001)(16526019)(36860700001)(7416002)(82740400003)(8936002)(186003)(21480400003)(426003)(6666004)(9686003)(47076005)(82310400003)(336012)(6916009)(2906002)(356005)(83380400001)(26005)(7636003)(574254001)(2700100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 07:51:44.1700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2121b3b-b732-42ec-0d69-08d919089d8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--pS1m3niJB58aDBvC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 10, 2021 at 02:10:21AM +0000, Joakim Zhang wrote:
>=20
> Hi Florian,
>=20
> > -----Original Message-----
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > Sent: 2021=E5=B9=B45=E6=9C=888=E6=97=A5 23:42
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; Jon Hunter
> > <jonathanh@nvidia.com>; Jakub Kicinski <kuba@kernel.org>
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net;
> > mcoquelin.stm32@gmail.com; andrew@lunn.ch; dl-linux-imx
> > <linux-imx@nxp.com>; treding@nvidia.com; netdev@vger.kernel.org
> > Subject: Re: [RFC net-next] net: stmmac: should not modify RX descripto=
r when
> > STMMAC resume
> >=20
> >=20
> >=20
> > On 5/8/2021 4:20 AM, Joakim Zhang wrote:
> > >
> > > Hi Jakub,
> > >
> > >> -----Original Message-----
> > >> From: Jon Hunter <jonathanh@nvidia.com>
> > >> Sent: 2021=E5=B9=B45=E6=9C=887=E6=97=A5 22:22
> > >> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Jakub Kicinski
> > >> <kuba@kernel.org>
> > >> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > >> joabreu@synopsys.com; davem@davemloft.net;
> > mcoquelin.stm32@gmail.com;
> > >> andrew@lunn.ch; f.fainelli@gmail.com; dl-linux-imx
> > >> <linux-imx@nxp.com>; treding@nvidia.com; netdev@vger.kernel.org
> > >> Subject: Re: [RFC net-next] net: stmmac: should not modify RX
> > >> descriptor when STMMAC resume
> > >>
> > >> Hi Joakim,
> > >>
> > >> On 06/05/2021 07:33, Joakim Zhang wrote:
> > >>>
> > >>>> -----Original Message-----
> > >>>> From: Jon Hunter <jonathanh@nvidia.com>
> > >>>> Sent: 2021=E5=B9=B44=E6=9C=8823=E6=97=A5 21:48
> > >>>> To: Jakub Kicinski <kuba@kernel.org>; Joakim Zhang
> > >>>> <qiangqing.zhang@nxp.com>
> > >>>> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > >>>> joabreu@synopsys.com; davem@davemloft.net;
> > >> mcoquelin.stm32@gmail.com;
> > >>>> andrew@lunn.ch; f.fainelli@gmail.com; dl-linux-imx
> > >>>> <linux-imx@nxp.com>; treding@nvidia.com; netdev@vger.kernel.org
> > >>>> Subject: Re: [RFC net-next] net: stmmac: should not modify RX
> > >>>> descriptor when STMMAC resume
> > >>>>
> > >>>>
> > >>>> On 22/04/2021 16:56, Jakub Kicinski wrote:
> > >>>>> On Thu, 22 Apr 2021 04:53:08 +0000 Joakim Zhang wrote:
> > >>>>>> Could you please help review this patch? It's really beyond my
> > >>>>>> comprehension, why this patch would affect Tegra186 Jetson TX2
> > board?
> > >>>>>
> > >>>>> Looks okay, please repost as non-RFC.
> > >>>>
> > >>>>
> > >>>> I still have an issue with a board not being able to resume from
> > >>>> suspend with this patch. Shouldn't we try to resolve that first?
> > >>>
> > >>> Hi Jon,
> > >>>
> > >>> Any updates about this? Could I repost as non-RFC?
> > >>
> > >>
> > >> Sorry no updates from my end. Again, I don't see how we can post this
> > >> as it introduces a regression for us. I am sorry that I am not able
> > >> to help more here, but we have done some extensive testing on the
> > >> current mainline without your change and I don't see any issues with
> > >> regard to suspend/resume. Hence, this does not appear to fix any
> > >> pre-existing issues. It is possible that we are not seeing them.
> > >>
> > >> At this point I think that we really need someone from Synopsys to
> > >> help us understand that exact problem that you are experiencing so
> > >> that we can ensure we have the necessary fix in place and if this is
> > >> something that is applicable to all devices or not.
> > >
> > > This patch only removes modification of Rx descriptors when STMMAC
> > resume back, IMHO, it should not affect system suspend/resume function.
> > > Do you have any idea about Joh's issue or any acceptable solution to =
fix the
> > issue I met? Thanks a lot!
> >=20
> > Joakim, don't you have a support contact at Synopsys who would be able =
to
> > help or someone at NXP who was responsible for the MAC integration?
> > We also have Synopsys engineers copied so presumably they could shed so=
me
> > light.
>=20
> I contacted Synopsys no substantive help was received, and integration gu=
ys from NXP is unavailable now.
>=20
> But, some hints has came out, seems a bit help. I found that the DMA widt=
h is 34 bits on i.MX8MP, this may different from many existing SoCs which i=
ntegrated STMMAC.
>=20
> As I described in the commit message:
> When system suspend: the rx descriptor is 008 [0x00000000c4310080]: 0x0 0=
x40 0x0 0x34010040
> When system resume: the rx descriptor modified to 008 [0x00000000c4310080=
]: 0x0 0x40 0x0 0xb5010040
> Since the DMA is 34 bits width, so desc0/desc1 indicates the buffer addre=
ss, after system resume, the buffer address changed to 0x4000000000.
> And the correct rx descriptor is 008 [0x00000000c4310080]: 0x6511000 0x1 =
0x0 0x81000000, the valid buffer address is 0x16511000.
> So when DMA tried to access 0x4000000000, this valid address, would gener=
ate fatal bus error.

Okay, that's interesting. If i.MX8MP supports only 34 address bits but
the driver tries to set a DMA address of 0x4000000000, that's way out of
the valid range.

I suspect what might be happening is that the DMA mask isn't properly
set for your device. There's in fact some code in the driver that deals
with this. If you look at the implementation of stmmac_dvr_probe() in
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c around line 4980,
there's a comment that actually mentions i.MX8MP and the 34 address bit
limitation. Can you find out what that priv->plat->addr64 is set to on
your system?

Or alternatively find out what priv->dma_cap.addr64 ends up being set a
few lines further down? That value is effectively used to set the DMA
mask and if that's wrong it might explain why the driver is setting a
bad DMA address.

In fact, maybe that information is already in the kernel log. There's a
dev_info() there that should print out something like:

	Using 34 bits DMA width

in your case. If that says something other than 34 in there, it's very
likely that this needs to be correctly set somewhere. Looking at the
code in dwmac-imx.c, I see that that's already set to 34, so this looks
like it should be setting things correctly, but better make sure.

> But for other 32 bits width DMA, DMA seems still can work when this issue=
 happened, only desc0 indicates buffer address, so the buffer address is 0x=
0 when system resume.
> And there is a NOTE in the guide:
> In the Receive Descriptor (Read Format), if the Buffer Address
> field is all 0s, the module does not transfer data to that buffer
> and skips to the next buffer or next descriptor.
> For this note, I don't know what could IP actually do, when detect all ze=
ros buffer address, it will change the descriptor to application own? If no=
t, STMMAC driver seems can't handle this case.
> I will contact Synopsys guys for more details.
>=20
> It now appears that this issue seems only can be reproduced on DMA width =
more than 32 bits, this may be why other SoCs(e.g. i.MX8DXL) which integrat=
ed the same STMMAC IP can't reproduce it.

On Tegra186 and later we support up to 40 address bits. The newer
Tegra194 has a special quirk where bit 39 has special meaning, so we
have to override the DMA mask as well. I recall that this was causing
issues at some point, which is why I suspect something like this could
be happening in your case as well.

Thierry

--pS1m3niJB58aDBvC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmCiINoACgkQ3SOs138+
s6EKOxAAnsgThB5hCPbrvjTTuLC9Iu/f+QvPiRj+SPlCxpdHQ9XCVlv1gtcXW+Hn
w7N3Uj7RUOIoJKG/L8ztW5930PPwLL/99i+U7gZARDnzavgr0MhLpIiAxJ4Ans9v
/Rp/Nutx2gmx2aBl4dxBD8kd+8lUCtQ+gXqvvRAY9j34pIJEeBKV9EUNKcncVkvS
WyVdWEB4+Vl0N4ESFPiylVKTrUYF5ZPzERs+wSy+ZpQRy1tPoVAUHQ+UCpOeOH/6
TxBlpTZTKASg+J25T6CjLyiJTRYURJ2QsfxLhiHMrAx34YSDRc1UOMMM4zwlhCaJ
a1ELddPJGdFrjPX9DwCOcnjYySZi4/Lnl7/mB8yHOsaQC7mljJmhLVNxFV4swT5J
mCztbhRqVQfQeIpz9Dbn2k9JXI8lXhrERFaRgKcSGLduw35r4VrQXiTlbQerGWpo
RnZ35RgBSpvsMdlmr38or4HZ/q6tXlCMrD/sX1nBNAp/oNS7DNaryQeSCBbLcQqJ
1EjmSm5DFSlTAUA94hDr6wnZqaqLrEePUwqhjkOSF8zvVlsxcr+WxpOOAvJEqKHE
8PY/t1RffSQJvFah3hjbVJFCArt+2n/UyTmDgku61iwf57JhwYeZ3bQ7Rufi8Ckn
22LJgXClm5cg6Q0FuF0unqPcr6i/fchefraOLwPegBi6c/LebDw=
=5nmL
-----END PGP SIGNATURE-----

--pS1m3niJB58aDBvC--
