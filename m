Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2553930DA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhE0O07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:26:59 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:49025
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236629AbhE0O0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 10:26:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axYXADt4WRXY5msZ13djjr2Z0i8D5QQ7G2A1Yzf645ZGOX+0+3vi10dwXrYfp3l19wUuSnl+ZHFVDCN9xIH8LWCfo3FdAyVcWm5F+EaXWfdDdC0ZwurFyaT9kMidXJAUCYeuKCCTazr3XTU5c65Zm3EFlUXejc6gCDxKe/PtKgSWgQqwbvTn4pIH7o01OTqSGuK0BwvBqqSkpoDwSdyQGNbBTg5WaD6CD7LLHlT6VdpZsG9iaC+lz2qRgHG8nMt1enlQ7DVQLEtrImAHa2j62IoAYXR/LtNvxGrd096eKmUyoExGidxqH0RH9M3wDZB+N47DM8OeWc2828liZsmIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYYK002utmzosQyNfX5t5tnOqU9UrtS2LT/D9klHKiY=;
 b=bW4CDWrz1D8AL3iDMu0vheAqnr1SPOlQx4MXuoTOYt8uzOd4OeBF+rMeOq/V5qvKer8Z1vdirslHO2FywAYHRnlNgaHD58BiZQSZ+wDRPLaNnm0XPdXFN68F3H8NDoLv/VioOhBEC6xUgDSGo1LUbE2K549Tb9Txo73oIhcqiRPvU3QI2GJVr3A42c2mWJEqQwzVQMsL3VcT2jn0ZN2gG2E+kdV0S+22d6EGcViHoBM8bHwIw/3GUAhIrz4Fd5Lfbt1rdbbmsKxVNE5cPneTa2/gUaQFfajCL7XRfaQ6inDB6DteZqhhtloIFXBL6f6OkeG9dj0b0G6tX4SwzwmboQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYYK002utmzosQyNfX5t5tnOqU9UrtS2LT/D9klHKiY=;
 b=NuWpYyeonNMqqSTwgHQcz2XiAahBWcThDR3i695261NOYK9WkxMpIev/gcUyvJPOla909Ud4IDbDXwCt+U4U0oXhRUUJ5xqb/IFDUr4QQg92OlsExAitceN4X5J3AZlRMj3Hrk0NTgYgK/2FHllntq8OJrha1VN6U4nIILW/9MOCE17zsVo0c3z+9/WPAmTs4DWpgzPuo4Ah6HB0nibxHk+Wjld6a6D4i2E0dm9GXVd/s8yBB4NkZkg8EiTqfMbEB68Elg74eqLUyOFfPYPYyQGjveS4XemFScKzrkD/DMU6cV2MZvpwna9MEeHEhlFmv9HyYoyKL6FTBoKdE03d/Q==
Received: from MW4PR04CA0157.namprd04.prod.outlook.com (2603:10b6:303:85::12)
 by DM6PR12MB4604.namprd12.prod.outlook.com (2603:10b6:5:169::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 14:25:19 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::bc) by MW4PR04CA0157.outlook.office365.com
 (2603:10b6:303:85::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 14:25:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Thu, 27 May 2021 14:25:18 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 14:25:17 +0000
Date:   Thu, 27 May 2021 16:26:47 +0200
From:   Thierry Reding <treding@nvidia.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     <f.fainelli@gmail.com>, <jonathanh@nvidia.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-imx@nxp.com>
Subject: Re: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
Message-ID: <YK+sJ20/z5i6rYVK@orome.fritz.box>
References: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Z9P4gUmUp/vjjgJn"
Content-Disposition: inline
In-Reply-To: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
X-NVConfidentiality: public
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0970400-20f4-4b01-f117-08d9211b4117
X-MS-TrafficTypeDiagnostic: DM6PR12MB4604:
X-Microsoft-Antispam-PRVS: <DM6PR12MB460417E10F3604280E790E1ACF239@DM6PR12MB4604.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8oILpfQ/Xn0IL/2SKi7rgkndimPSb9MhVPJpDDl3uOWw9Hgv/u7lR1d2qEj9CSsPr6QYBr6i2Slxexoi43kx8cK9i4+2Mkt5a6PK1FBcNm3vmO9FAeHdct9rqVIsjudrSjlgSfop8JWAsgg90hGCi/qhCXOOQ6xQ+qrWFJZ3k6ZHNWu6A93vULRmBT7MoQZbYOnm5WcfxD7xB1X0TYcMRrXmdiWZ0m/E18HZPRM2FyiJ20b4PKyTjFYygO5wmZMYNAcBpCLJXSjUmGhZvqXtIhJKS7weBNxDF4Hu24y5NVv6cZZhU53p6599vxYUnOiRJptTea7Iyp2y4+snqfmm6gFoV+ZAGPXISTlcKZqQOELP2XRwztd63Okz14qxDcfFK7baRzCgUxGYmn2LKWBsfcjrHd7odfGVaCyF1eAZG/xvncF4Z4uw2Wd/iqA+9uAcJx5S3y/E0o3tgQIl0JaMIjU4hkT3yRdANQ5ezEw9CgpkXibtm+37vgv9R073T3E+55X2+mnnO/c6YBdTwEjRtQ+zqX+0dYyBWxjhVh6sodGDkSxZcRuOiHYE5BQgOaGhnvhg4Ygy06mgrSGjlWTswYbXlZeMXtDjkDgET7KKyuejG1Ojk/sa4OA4o1Lv+dch9zKutmPW7p8NXyR9ccDOrqoUo4n2/jzH2OWMW2YDybqLJhMo93zwQk6aCEaNWzz/
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(26005)(9686003)(8676002)(86362001)(8936002)(47076005)(70206006)(4326008)(70586007)(44144004)(6666004)(316002)(16526019)(186003)(426003)(36906005)(21480400003)(83380400001)(6916009)(7416002)(2906002)(7636003)(36860700001)(336012)(54906003)(5660300002)(356005)(82740400003)(82310400003)(478600001)(2700100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 14:25:18.8478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0970400-20f4-4b01-f117-08d9211b4117
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4604
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Z9P4gUmUp/vjjgJn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 27, 2021 at 04:49:11PM +0800, Joakim Zhang wrote:
> When system resume back, STMMAC will clear RX descriptors:
> stmmac_resume()
> 	->stmmac_clear_descriptors()
> 		->stmmac_clear_rx_descriptors()
> 			->stmmac_init_rx_desc()
> 				->dwmac4_set_rx_owner()
> 				//p->des3 |=3D cpu_to_le32(RDES3_OWN | RDES3_BUFFER1_VALID_ADDR);
> It only asserts OWN and BUF1V bits in desc3 field, doesn't clear desc0/1/=
2 fields.
>=20
> Let's take a case into account, when system suspend, it is possible that
> there are packets have not received yet, so the RX descriptors are wrote
> back by DMA, e.g.
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0x34010040

This is something that completely baffles me. Why is DMA still writing
back RX descriptors on system suspend? stmmac_suspend() should take care
of completely quiescing the device so that DMA is no longer active. It
sounds like for some reason that doesn't happen when you run into this
problematic situation.

I see that some platform adaptations override the DMA ->stop_rx()
callback (see dwmac-sun8i.c and dwxgmac2_dma.c), so perhaps some similar
override is required on your platform to actually stop DMA?

Thierry

--Z9P4gUmUp/vjjgJn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmCvrCUACgkQ3SOs138+
s6Fqhw//XLqBsROIJpjHTy5nV+UVyvLT1jDIwor3xNZHw+ppaTN2UeLVcUmhgj5i
ehMz2TC4yXnLj2rvBy3vNnPpgXA8g1uo0XnYU29FdlPg1c6t4DclmCA8iwPRudTv
K0mtfv3QVJqqWGg0Iy/XTuCVP44KvKQEMD+M0iCIIKyinHxMOqTtKdrSybORfkdz
i2p6/GxtXX8OY23iOEIRF2Q7ldTUlGLq6BrQGJYd3DJ75EHLJMEuNt4/OHb4+BeT
3nW7P3o7b0FempUkh5L3rc8fyGlFxxnhorrYQG6uU04mrbSog3r78srHYqdkrivx
xp8qJMwFmyvRoUr94ivAMMNJAismXkT6mASLisgDPpr/qXe5bOa1CqapR0To5PiT
PFB2NY2V0vJQ4VEROyziNwNEOhN5tHtGdZHd3yjwmPYcjfOmjIPzBmYA+RzHRQ/r
Fichf91e8SMOcD0ElDKhAhDmk0ZfRha0/j9QuCtu98dGId/YoXtTF3TgQAu/D5IQ
+BYwWlYvZl92gWy7H8/+w1vtNOrlvhP6EAGvYn9odZjdM8nglQa2nh7Jk3ywW+Sk
JVXXTvGly0LztMy1gzkbs3jb+ikcv4vPrSu9y/c0v12ax+60KYXNXnHFDS92OUsk
cl49qCUoGHQUSDmKg1Knw28kGaI9ki4+EzyRm22U/X9Dg07NPyU=
=JZgS
-----END PGP SIGNATURE-----

--Z9P4gUmUp/vjjgJn--
