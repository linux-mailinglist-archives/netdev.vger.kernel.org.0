Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D155307668
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhA1MvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:51:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4074 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhA1Mu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:50:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3080000>; Thu, 28 Jan 2021 04:50:16 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:13 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 01/12] nexthop: Rename nexthop_free_mpath
Date:   Thu, 28 Jan 2021 13:49:13 +0100
Message-ID: <9471a24d9c43c2ace3e68c88165c5212ae6944fa.1611836479.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1611836479.git.petrm@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL111.nvidia.com (172.20.187.18)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611838216; bh=yHDiFG6FZbgDt6riDeoxHrSYA0kNiJhtydX23xMEwr0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Z+ivNenSigiJvu/1ohUMrZRxBpWTsNY0t/1jPFo3YZAnINmvPRLTPPrceKjyW7k7K
         uP7ihqDHfU2JKvuPpuYLlaUU8+bpUA7ZUKbbUdOGBpdwsOVLaDaCxc5fC7NpJVhNuC
         x+B8JRaFurRwpkmsSTpfpvZmmdwKX/UVq54NqdVS2aL/0qW5xadv1Z89JDAnSdqTCw
         A120iSCJl8+U2cBP04hEiOHamVfmCR31AvCVR6hJbOEnahcuBrHVmasJVFCcVq/Mbm
         /BoJdhmIu9JlmBeGY8uB3SYmAMXTXSyqM2ceJ+47mNMLu+B5m7RzlpPy27Hef7FWQZ
         kNjsSk1pOVjEQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

nexthop_free_mpath really should be nexthop_free_group. Rename it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 net/ipv4/nexthop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e6dfca426242..1deb9e4df1de 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -209,7 +209,7 @@ static void nexthop_devhash_add(struct net *net, struct=
 nh_info *nhi)
 	hlist_add_head(&nhi->dev_hash, head);
 }
=20
-static void nexthop_free_mpath(struct nexthop *nh)
+static void nexthop_free_group(struct nexthop *nh)
 {
 	struct nh_group *nhg;
 	int i;
@@ -249,7 +249,7 @@ void nexthop_free_rcu(struct rcu_head *head)
 	struct nexthop *nh =3D container_of(head, struct nexthop, rcu);
=20
 	if (nh->is_group)
-		nexthop_free_mpath(nh);
+		nexthop_free_group(nh);
 	else
 		nexthop_free_single(nh);
=20
--=20
2.26.2

