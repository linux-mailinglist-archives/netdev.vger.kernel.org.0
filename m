Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F811222F53
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgGPXpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgGPXpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:45:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FC0207CB;
        Thu, 16 Jul 2020 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594938387;
        bh=Vk2hYYH909BQq0WfC/fowIVxMBoXf0qtB0ADc87Bnqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=00JNp6fBetTtZM+Sz6W3WPSw0GI5lqsP13WC2angXSdnty7BwVYp2FBXz5JowvoB3
         hKFDFPX19neVnoGO462o+VwvO7mRC4ad69BJPtWWDnytvz28hX29e/qA8+QocutCAR
         Jl9YhPcCxrMCUuIyj+Rmouj04ltUCp5JMhoVGC2M=
Date:   Thu, 16 Jul 2020 15:26:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [net-next 12/15] net/mlx5e: XDP, Avoid indirect call in TX flow
Message-ID: <20200716152625.01651110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716213321.29468-13-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
        <20200716213321.29468-13-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 14:33:18 -0700 Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
>=20
> Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
> when/if CONFIG_RETPOLINE=3Dy.
>=20
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Are these expected?

drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:251:29: warning: symbol 'm=
lx5e_xmit_xdp_frame_check_mpwqe' was not declared. Should it be static?
drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:306:29: warning: symbol 'm=
lx5e_xmit_xdp_frame_check' was not declared. Should it be static?
drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:251:29: warning: no previo=
us prototype for =E2=80=98mlx5e_xmit_xdp_frame_check_mpwqe=E2=80=99 [-Wmiss=
ing-prototypes]
  251 | INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct=
 mlx5e_xdpsq *sq)
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:306:29: warning: no previo=
us prototype for =E2=80=98mlx5e_xmit_xdp_frame_check=E2=80=99 [-Wmissing-pr=
ototypes]
  306 | INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e=
_xdpsq *sq)
      |        =20
