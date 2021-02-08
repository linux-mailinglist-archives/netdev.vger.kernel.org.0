Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D9A3140E1
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhBHUtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:49:01 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16169 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhBHUpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:45:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2920000>; Mon, 08 Feb 2021 12:44:02 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:44:02 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:59 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 13/13] nexthop: Enable resilient next-hop groups
Date:   Mon, 8 Feb 2021 21:42:56 +0100
Message-ID: <55948e3a0a3c7086df2443fde0de7b9c837a048d.1612815058.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1612815057.git.petrm@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612817042; bh=Uc8EW6NkeKLLz4Wh7HrTAW2uJw3Zzo+OSu+yF6RS46k=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lojUL5migtU+ueeUka+60dw9eSCcu6g8gKw0IprEEphE0j6KJjHsKetgyz/ThvsZr
         im2Ge+ZnO7juw7ODrf1RzuHDox5FsAIN6Df5p+s1uz5XnGxAFMjiypxfYXr3h7hBPr
         nVrGZw22wSOWoGYru9xtH979FkNWyqNa4jpDN8D5QtdZVWqApPw632SCAWw3c+kcNB
         gq/IpGeGyTrDsALzjvCsYFozG8qpCSLovDDkTN8SOK67RTOQj5cmihQXg8efk+QmZ6
         q41RWqacm6D2r6w3avqnDnLhpXwH61tzIUiZYyAjEpI8AEBgtLqxEcoEzpTKVJQx4z
         gnp0wkMzAh61A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all the code is in place, stop rejecting requests to create
resilient next-hop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 4d89522fed4b..2ddef22d4b78 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2437,10 +2437,6 @@ static struct nexthop *nexthop_create_group(struct n=
et *net,
 	} else if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_RES) {
 		struct nh_res_table *res_table;
=20
-		/* Bounce resilient groups for now. */
-		err =3D -EINVAL;
-		goto out_no_nh;
-
 		res_table =3D nexthop_res_table_alloc(net, cfg->nh_id, cfg);
 		if (!res_table) {
 			err =3D -ENOMEM;
--=20
2.26.2

