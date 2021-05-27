Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899AD393082
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhE0ON3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:13:29 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:48225
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235487AbhE0ON1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 10:13:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgjKXy1UFtyMzypcclEQc4qK6+vD7L5f6Z1dcoTn0KWwXjOe000Ha+WW4lV+xTvUTDu7o+kPnPgyZvISS/s3WPvXhCQDjoy18OzuGFiG0ZACjyUtXGpOx5CLM3xwVtaSeAjnIhKHuSVTwHVmNnyboJeTcUyrttnYo4MObPMvi7ure5r0+p2McgolfJcH5xLnGpN0KJJQVm8GY9LjKYlIDOXCD4H32uNXxUovLxviD2RwGg6GY88a+3gvhGPig73zPtGLo6D5iyBdm7f+6dUFfikF2NCOYFmWjBaGRlqCa/wAfmJ+U7MhPEYnwaMMKY2xJklgH8HFo+//2VK10n3ePw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+7fz0Mm8R2366dw8qcJ2RqIG8KujEShq5UvxmqnniU=;
 b=IW2GNLHANxx6HUk+Ph/ZMI9IXWn+kgsYpgEmf1H6uG3xoI01/5J5E459LLiNY84TEbzEi1feV8DPKHdCM555DD647Ba2LC7ODcpPgCGLbs4bEfAH5b5qwlApLI5P/9SVpRgLX65zQwj3617TwYok6JPUYe/8l8NX00pKQfCPnN5nyluGQ4sYAU8wSafHPlcqd8Wu6P6FQGsQFQvEWMnsXVvMYrvNDmiudgVuA5m4XFvpgt/CebGYk824mK1Mdf1eSr4u6kJE8ZAXPbSTXnl1hYYdffW32ZfuNVAuY45iWjjKMwSa5fGtGpzcy0S4WnyImVLr+jEnUjZllFRKqMsFBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+7fz0Mm8R2366dw8qcJ2RqIG8KujEShq5UvxmqnniU=;
 b=cZQhUumGePWTTPSddhkHgWMKPOhpBy7ZK0Pvzhk2Ju7QpK1sf3vBNA0WZllbuyVlHbGxs3SIrfMr0g+MtT5rFhjWMsPkSxFZ7uzlMgtUp4pxSjwNBBVauZLjq0TnHnHckHJYUGkZxuQPWxAoO4j3FiS7KNRQfocfBqFxdizuXakKN0KRmyI5tvQ7xm9QgOFtpti8Eo/vqAxVntfKIlRCUj7WMfCKHVkBqr+SMZRJ8mwxbBbxmZEgjdfjdx/BDSJbSRgvjqfLZ96NZOAvC87j6uOtMprecogyKrtJ7GTSSsuRn04wJUCaX1lsIvcdSSIih2tAyS8lGXH+nlElKZPDSQ==
Received: from BN9PR03CA0605.namprd03.prod.outlook.com (2603:10b6:408:106::10)
 by CO6PR12MB5411.namprd12.prod.outlook.com (2603:10b6:5:356::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 14:11:51 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::bf) by BN9PR03CA0605.outlook.office365.com
 (2603:10b6:408:106::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 14:11:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 14:11:51 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 14:11:50 +0000
Date:   Thu, 27 May 2021 16:13:20 +0200
From:   Thierry Reding <treding@nvidia.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     Jon Hunter <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
Message-ID: <YK+pABnNUyhIzPt7@orome.fritz.box>
References: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
 <e2f651f8-e426-1419-dbdc-4854b3d6ee83@nvidia.com>
 <DB8PR04MB67959938BC55D9ADA00488EAE6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oGbpdr+N3CmChJPv"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB67959938BC55D9ADA00488EAE6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-NVConfidentiality: public
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a708fed-10d7-4a36-447a-08d921195ff2
X-MS-TrafficTypeDiagnostic: CO6PR12MB5411:
X-Microsoft-Antispam-PRVS: <CO6PR12MB5411DD52973CB61F3C2A41CACF239@CO6PR12MB5411.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Npxw51j6sWFOWgWyuKLRYwT6Vgb2YRm3P40gRSvDEOrgDy9osUC6qW5zH+uzOFeuaK6HZAFblk0f8QFbgVCuv/ztzZssRur68L3jBujbPMdFKt0hPIbtJSQ3TsaEDha43jO6n4aPkVq4JsuiKIAvHNKmphINOKhhWUu+UCwSwCTWxVtyzCz94XmPUdk/KAr1/4vXbYLauWIqqJ8W1UKBNPvD+on5QmMbMag9jRqHkGB6kz3G08+8ax7GnBbjLVWTAR0txtvqIJr0keu/jVgjOty7ae1YlW3/9xp5LW0XvnlAaEi/mSTf8yKmIQeNSiQ+jpCJkj8x6JfkHaF6fSUrlk92mclJXSjAFfU13JM/uYwcF9EB21Vv29EzSi8kn7WysKOSrKGJJDyBQUQMksiV7yPdxLP+bkmm5xpmRqL5e/JPl39jFzYRcvMR0MAegpdLWv15KP0G7xq+KMDHsi7D8v1vYPjM5z5A7IwSS5a0u3WheXMnvE3VosnSi2hxadm/Akz8h3uI2BdnQYecnxvn13mdkgxjxbZnsZlyTuqEKksjdhVN+dQ4sN29RAIYHGSd9Y+RqQeyolI4yhhtt2eQbCVYmjUg5sGirzrVBObjFngFgDEC1E2nXRfdbWkia8wPlx7pJEC7WxScqytJs2Wf3MeLEhJ186HpI2CdjH2IP1EmEb3qXF8lw6dsQxdShGl9Z61HcGXIHdN3rScbAwvS+NnBKnuzwjsq3LfSpuKHA8zu8IO1VqJssnCcPC/iEicxszihwIF8l4YzCVTz4DEgenuVyU20z3tFfhlvfPTvnpI9xIeAklAUQXbD29mhjcaA/8pS9Du2CCD5lcbpIKv2Jg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(36840700001)(46966006)(54906003)(86362001)(16526019)(8676002)(70586007)(33964004)(26005)(966005)(186003)(36860700001)(36906005)(316002)(478600001)(426003)(6916009)(44144004)(45080400002)(70206006)(336012)(53546011)(47076005)(21480400003)(9686003)(82310400003)(6666004)(4326008)(7416002)(82740400003)(83380400001)(5660300002)(356005)(2906002)(8936002)(7636003)(2700100001)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 14:11:51.5408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a708fed-10d7-4a36-447a-08d921195ff2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5411
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--oGbpdr+N3CmChJPv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 27, 2021 at 01:13:06PM +0000, Joakim Zhang wrote:
>=20
> Hi Joh,
>=20
> > -----Original Message-----
> > From: Jon Hunter <jonathanh@nvidia.com>
> > Sent: 2021=E5=B9=B45=E6=9C=8827=E6=97=A5 20:43
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; f.fainelli@gmail.com;
> > peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > mcoquelin.stm32@gmail.com; andrew@lunn.ch; treding@nvidia.com
> > Cc: netdev@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH V1 net-next] net: stmmac: should not modify RX desc=
riptor
> > when STMMAC resume
> >=20
> >=20
> > On 27/05/2021 09:49, Joakim Zhang wrote:
> > > When system resume back, STMMAC will clear RX descriptors:
> > > stmmac_resume()
> > > 	->stmmac_clear_descriptors()
> > > 		->stmmac_clear_rx_descriptors()
> > > 			->stmmac_init_rx_desc()
> > > 				->dwmac4_set_rx_owner()
> > > 				//p->des3 |=3D cpu_to_le32(RDES3_OWN |
> > RDES3_BUFFER1_VALID_ADDR); It
> > > only asserts OWN and BUF1V bits in desc3 field, doesn't clear desc0/1=
/2
> > fields.
> > >
> > > Let's take a case into account, when system suspend, it is possible
> > > that there are packets have not received yet, so the RX descriptors
> > > are wrote back by DMA, e.g.
> > > 008 [0x00000000c4310080]: 0x0 0x40 0x0 0x34010040
> > >
> > > When system resume back, after above process, it became a broken
> > > descriptor:
> > > 008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040
> > >
> > > The issue is that it only changes the owner of this descriptor, but do
> > > nothing about desc0/1/2 fields. The descriptor of STMMAC a bit
> > > special, applicaton prepares RX descriptors for DMA, after DMA recevie
> > > the packets, it will write back the descriptors, so the same field of
> > > a descriptor have different meanings to application and DMA. It should
> > > be a software bug there, and may not easy to reproduce, but there is a
> > > certain probability that it will occur.
> > >
> > > i.MX8MP STMMAC DMA width is 34 bits, so desc0/desc1 indicates the
> > > buffer address, after system resume, the buffer address changes to
> > > 0x40_00000000. And the correct rx descriptor is 008 [0x00000000c43100=
80]:
> > > 0x6511000 0x1 0x0 0x81000000, the valid buffer address is 0x1_6511000.
> > > So when DMA tried to access the invalid address 0x40_00000000 would
> > > generate fatal bus error.
> > >
> > > But for other 32 bits width DMA, DMA still can work when this issue
> > > happened, only desc0 indicates buffer address, so the buffer address
> > > is 0x00000000 when system resume.
> > >
> > > There is a NOTE in the Guide:
> > > In the Receive Descriptor (Read Format), if the Buffer Address field
> > > is all 0s, the module does not transfer data to that buffer and skips
> > > to the next buffer or next descriptor.
> > >
> > > Also a feedback from SYPS:
> > > When buffer address field of Rx descriptor is all 0's, DMA skips such
> > > descriptor means DMA closes Rx descriptor as Intermediate descriptor
> > > with OWN bit set to 0, indicates that the application owns this descr=
iptor.
> > >
> > > It now appears that this issue seems only can be reproduced on DMA
> > > width more than 32 bits, this may be why other SoCs which integrated
> > > the same STMMAC IP can't reproduce it.
> > >
> > > Commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume
> > > back") tried to re-init desc0/desc1 (buffer address fields) to fix
> > > this issue, but it is not a proper solution, and made regression on J=
etson TX2
> > boards.
> > >
> > > It is unreasonable to modify RX descriptors outside of
> > > stmmac_rx_refill() function, where it will clear all desc0/desc1/desc=
2/desc3
> > fields together.
> > >
> > > This patch removes RX descriptors modification when STMMAC resume.
> > >
> > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > ---
> > > ChangeLogs:
> > > 	V1: remove RFC tag, please come here for RFC discussion:
> > >
> > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fl=
ore
> > > .kernel.org%2Fnetdev%2Fcec17489-2ef9-7862-94c8-202d31507a0c%40nvidia
> > .c
> > >
> > om%2FT%2F&amp;data=3D04%7C01%7Cqiangqing.zhang%40nxp.com%7C16be3
> > 6b4a2584
> > >
> > a4c208608d9210d09ef%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%
> > 7C63757
> > >
> > 7162155074221%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJ
> > QIjoiV2lu
> > >
> > MzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DBdsNu6l4%2Bt
> > Q6WllA
> > > tVn%2BP1jD3sRXfpIH2XErmRh%2BjLA%3D&amp;reserved=3D0
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index bf9fe25fed69..2570d26286ea 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -7187,6 +7187,8 @@ static void stmmac_reset_queues_param(struct
> > stmmac_priv *priv)
> > >  		tx_q->mss =3D 0;
> > >
> > >  		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
> > > +
> > > +		stmmac_clear_tx_descriptors(priv, queue);
> > >  	}
> > >  }
> > >
> > > @@ -7251,7 +7253,6 @@ int stmmac_resume(struct device *dev)
> > >  	stmmac_reset_queues_param(priv);
> > >
> > >  	stmmac_free_tx_skbufs(priv);
> > > -	stmmac_clear_descriptors(priv);
> > >
> > >  	stmmac_hw_setup(ndev, false);
> > >  	stmmac_init_coalesce(priv);
> > >
> >=20
> >=20
> > So as previously mentioned this still causing a regression when resumin=
g from
> > suspend on Jetson TX2 platform. I am not sure why you are still attempt=
ing to
> > push this patch as-is when it causes a complete failure for another pla=
tform. I
> > am quite disappointed that you are ignoring the issue we have reported =
:-(
> I first pushed the RFC and discussed about the issue, I think this patch =
trigger a potential issue at your side.=20
> IMHO, you may need try to find the root case why this patch make regressi=
on on your platform.
>=20
> > To summarise we do not see any issues with suspend on Jetson TX2 without
> > this patch. I have stressed suspend on this board doing 2000 suspend it=
erations
> > and so no issues. However, this patch completely breaks resuming from
> > suspend for us. Therefore, I don't see how we can merge this.
> If you read the commit message, you should know you can't reproduce
> this issue if your DMA bit width is 32 bits.

Tegra186 and Tegra194 have DMA bit masks of 40 and 39 bits,
respectively, so according to what you're saying we should be able to
reproduce this, but as Jon explained we were unable to even reproduce
this once.

Thierry

--oGbpdr+N3CmChJPv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmCvqP0ACgkQ3SOs138+
s6FaMxAAnzlw0u07VYKEe4zNRA29iPujK2/E+ZHNlohFqw+lZ4K1LEE07HoORVEG
aj5E/f9pG1LreocNL/M8jj3OZqUVqbRQHp9LQ0BuD+Rp3YyWIBFctpFTXPtt4IeL
XEOEutC3BfcGcPf6vylxXiZ0Mis+JzvKlndr3trTUcCcy1HcyS1dFArXEysQt3xO
Mx9CDT1ovu8qZ/HB7Hp83oKmjUVY3RVmTzlacRyhBeCaM0RhhWGmvjbotQblzjrp
WR3JNNMtdQWG9YWAJgWvRoJTNwngBQ+2Ug4jZfXrRlli+fZKfffNMKVgrng7sRvy
bi97kwa8zcIWt2pzwEBYSMngphar1CTFLz1C6RMpQ/vewX5HVJ2EP4YNDVDd0od3
gCk8ZzmsZEobIMUbZUP9a/3NgdZ01zlcPlwWxiVSOsfYsGMfWsgDmJ1xcRkW0aPU
JUhbYOPSfPcL0hUHC8YRmdjQPVoh+hpYPr82nsE9R3kKpF2GCGiZj2tzUF4xaHY1
bpM9HahxopevGp8q9zHBTa3VzAnIc99tXfl1DStkjl/jVgl3T0FsNegwzPQkcpfj
78TewIfCY70/kuNCUTxCOZZsGzCiqPMRTm92OCM7vZpdnSM6XBtFrzLHe2ge/axZ
C2eJV/1dnlLvX1glfj9hq2Ql2huWB2F+Bcry40wBCr2vQSOyJWg=
=bUHS
-----END PGP SIGNATURE-----

--oGbpdr+N3CmChJPv--
