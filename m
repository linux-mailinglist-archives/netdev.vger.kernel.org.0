Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3883F400E9D
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 09:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhIEHvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 03:51:18 -0400
Received: from mout.gmx.net ([212.227.17.20]:55495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhIEHvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 03:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1630828204;
        bh=v00yWsL4XEVZ7bXh82uXAMAbo31Pik3HWj63p8nK5ns=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=apyYQxqSCwjarPgAD2Z1HvI3n2Kfe3wUZ+nPu1NK+8/cdCXbvBuPsBR1olC7ZsFmO
         AqehUNL5LG4Pw1VHxuRhLiOGAfoTNdpAWx8DWqDLI8xlcKgk0bv1Aw+aWBY3Xnx6nm
         efF1KR3w49g1agVJgL/67Xol8v1XoKyxbDkvz3Mw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MhlGq-1mrhoy112O-00dp8K; Sun, 05 Sep 2021 09:50:04 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>, Kees Cook <keescook@chromium.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: DR, Prefer kcalloc over open coded arithmetic
Date:   Sun,  5 Sep 2021 09:49:36 +0200
Message-Id: <20210905074936.15723-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tMmxEffSTzXE4Bi0GOPfWgJ6Vy1HEY4xMiDcYJTvywx5Mza37MF
 PmNQJkymVUswaYdAYscm/4NDeeMcF+tHqrKrHlxbCfIJUzJMJjV6UbrnE68DCivadHpJwSG
 dKo4rqy8zC547KFXwBL//PVXo/AGBJK1BycTM72eCa7IVpIs5erhyQI2JeSS/IsH8p+WrUV
 Vk/ZxgwCMV33Hu6FJBSvg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NC7nl/kio1g=:Lyy8rF7rv2sr05B4FXhdIA
 RchAvfWvhDd+il/3FeEXeE7E3zyTbXFYQG7DSf8heIvW9VnmoxYjUiQ7cJcuB2JWQsZ96a4Fh
 1f0QIeGcceqQychifaFMZwELZeGPwlru3cfS1x+cb7ucAZIiL16cLvic1wrEuy+Uq1poRSxvH
 N+5Y0N3bk/z8/pnbAHuvNexa7VbTe3382V4eDWTODXeSndH5LN+jQsX3KNIOJeAhHP51ns7H/
 a1LI08HwoH+h+Ze+lqz6kp841tCzsXXvDE0q8GKurisrQDW/RFS9VGminFczEq8bO41reKZ7M
 xFtTidXgUV3aM/W1sdYQ5+2iqyoOeXaWjiEwp86z/ZrB/QxAZhbiXqIEEbe1vkHsIPTFo/nAc
 7HRnjxOKk0Oev4JdvQoF/+e6aN1vdV5g69TV5WuDhFt0zqsp2yXf+P7sbdv25rCOsQRyh/utc
 U1FX7spXejq+zx4shI4NYplzfQEeXgTTUii/Xh5D19cONFZO+unmFTOb1huXa/sxeLduyfPUH
 SKRuf79unO4jyJkuxQ45tJuRKfsL0apsMWrMdg2hhPFolOAHC5CrU6Y8GnyirTrZbEGTIj5KO
 Q26gPBJY3oU07lO+C/6yKENcopGMMtAqWr28pzovoCeolH9dBWS7rv3vR5nw73Ke+Y9591E+N
 duLeSM42IEG4mYGg5NEjEVkkSrd/W4zkWlqA90EFyuOPBf8iRgX8R+pBSkzy2nY/SF8wwqTMZ
 H/BkNOWdJdYO5jPah2CMPCVNZxr4wfEidBA9aAyHsjS7USO1qyGra+XF4dshjzEzH7X1euFjo
 /6lf/4/LJF6r+0flOsVTlVDeNg9gsSeVkITEDAk2AA3Tx1GjMRgPWnqAC+QMaOOpcOXbfvqOr
 hItBhmP4c5kYmbLChFI/b2BKyujxgcFZnN/fKa3qolfn/SneNEKQYHSj0nRUX3Iq5Os76JFOc
 6vpCCDhMcwSdHPHS1IKdXuIDttMb/2jXTal3rf9OzaGGJ7nzgZTXuPhtmRPtBy2U6CcX4F9X+
 4krhITW26G2x8nipTFPbqbjfdV9XbA3+nofjvPzTd6FBaOMevHAjJ9c0gqrnlQUJAGMK/Lhdj
 NET18qMvqsJ1QwqtnoeEX0NvMkcDTkhhzTbVGuIjQzgZ4PjxoFXmfW+UA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, refactor the code a bit to use the purpose specific kcalloc()
function instead of the argument size * count in the kzalloc() function.

[1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-cod=
ed-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c  | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 6475ba35cf6b..e8957dad3bb1 100644
=2D-- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -716,6 +716,7 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domai=
n *dmn,
 	struct mlx5dr_action *action;
 	bool reformat_req =3D false;
 	u32 num_of_ref =3D 0;
+	u32 ref_act_cnt;
 	int ret;
 	int i;

@@ -724,11 +725,14 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_dom=
ain *dmn,
 		return NULL;
 	}

-	hw_dests =3D kzalloc(sizeof(*hw_dests) * num_of_dests, GFP_KERNEL);
+	hw_dests =3D kcalloc(num_of_dests, sizeof(*hw_dests), GFP_KERNEL);
 	if (!hw_dests)
 		return NULL;

-	ref_actions =3D kzalloc(sizeof(*ref_actions) * num_of_dests * 2, GFP_KER=
NEL);
+	if (unlikely(check_mul_overflow(num_of_dests, 2u, &ref_act_cnt)))
+		goto free_hw_dests;
+
+	ref_actions =3D kcalloc(ref_act_cnt, sizeof(*ref_actions), GFP_KERNEL);
 	if (!ref_actions)
 		goto free_hw_dests;

=2D-
2.25.1

