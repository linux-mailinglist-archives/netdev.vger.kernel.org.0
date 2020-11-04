Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769ED2A701E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgKDWDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgKDWC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 17:02:59 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38A8A206FB;
        Wed,  4 Nov 2020 22:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604527378;
        bh=ZOt4+TKYMGbSPdLYEkoN0f28rHX+s6H2VWyBDp19p2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eemFdJuiANFegXWrWpws/V+BAJT13pio1GNlB1Dm0HhDHNHZNbMA9Ihka+vVhOwt8
         owVYIQS3CxRtf5ErwUMQ1ntSwYFwYxpEi5ZZtd2vKF0uKq53wic38Xkx5heo7VeQQl
         imUq1DHsSWkI2GbAqO5ihTZ3+afFROKVi8SCt+XA=
Date:   Wed, 4 Nov 2020 14:02:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 09/12] net/mlx5e: Validate stop_room size upon user
 input
Message-ID: <20201104140256.1b65e751@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103194738.64061-10-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
        <20201103194738.64061-10-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 11:47:35 -0800 Saeed Mahameed wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>=20
> Stop room is a space that may be taken by WQEs in the SQ during a packet
> transmit. It is used to check if next packet has enough room in the SQ.
> Stop room guarantees this packet can be served and if not, the queue is
> stopped, so no more packets are passed to the driver until it's ready.
>=20
> Currently, stop_room size is calculated and validated upon tx queues
> allocation. This makes it impossible to know if user provided valid
> input for certain parameters when interface is down.
>=20
> Instead, store stop_room in mlx5e_sq_param and create
> mlx5e_validate_params(), to validate its fields upon user input even
> when the interface is down.
>=20
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

32 bit build wants you to use %zd or such:=20

drivers/net/ethernet/mellanox/mlx5/core/en/params.c: In function =E2=80=98m=
lx5e_validate_params=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/en/params.c:182:72: warning: format=
 =E2=80=98%lu=E2=80=99 expects argument of type =E2=80=98long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98size_t=E2=80=99 {aka =E2=80=98u=
nsigned int=E2=80=99} [-Wformat=3D]
  182 |   netdev_err(priv->netdev, "Stop room %hu is bigger than the SQ siz=
e %lu\n",
      |                                                                    =
  ~~^
      |                                                                    =
    |
      |                                                                    =
    long unsigned int
      |                                                                    =
  %u
  183 |       stop_room, sq_size);
      |                  ~~~~~~~                                           =
    =20
      |                  |
      |                  size_t {aka unsigned int}
