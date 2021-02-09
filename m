Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251BA314B4C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhBIJRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:17:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13098 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhBIJNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:13:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602251f50001>; Tue, 09 Feb 2021 01:12:21 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 09:12:21 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 9 Feb 2021 09:12:19 +0000
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <idosch@nvidia.com>, <dsahern@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH iproute2-next] ip route: Print "rt_offload_failed" indication
Date:   Tue, 9 Feb 2021 11:12:00 +0200
Message-ID: <20210209091200.1928658-1-amcohen@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612861941; bh=lQTQ0bPuzPyFNZA/hvXnw0dmf/fLwAEiJf5/ZLfds2Y=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=ApXjsRTnf+Bzf3cBmRSENyTC6ivTEmrQoJCfLfDPiedRkDEYwN1pg8+x2vkweAzcE
         1ZEfXVqzCMOMMpJaS9EOcA0Z7qx5H1z0Ul3HS0eju71qq78Y5Y5Qk8n0FOIb7o/EeA
         BVWUyLXdBZuiNEk7f+bkqvv0RU78f13FLWQ4+Kwu2exOVOp8GEN4otVzztPk+IzapO
         sqeLNtLV6HSO4t99GO37a85zCYnZt1ruCzggyPQ+hwNc/zWLUb6w5GQK2XB1K3mjPp
         4jfwnl+vh91ykg/GVNM25xe1YVoaS+g1SsFcgLN72PixFXmw3Ab4cwNyhMONaoTSnb
         jIzh9geA2JGFw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel signals when offload fails using the 'RTM_F_OFFLOAD_FAILED'
flag. Print it to help users understand the offload state of the route.
The "rt_" prefix is used in order to distinguish it from the offload state
of nexthops, similar to "rt_offload" and "rt_trap".

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iproute.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/iproute.c b/ip/iproute.c
index ebb5f160..a8c4886b 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -374,6 +374,8 @@ void print_rt_flags(FILE *fp, unsigned int flags)
 		print_string(PRINT_ANY, NULL, "%s ", "rt_offload");
 	if (flags & RTM_F_TRAP)
 		print_string(PRINT_ANY, NULL, "%s ", "rt_trap");
+	if (flags & RTM_F_OFFLOAD_FAILED)
+		print_string(PRINT_ANY, NULL, "%s ", "rt_offload_failed");
=20
 	close_json_array(PRINT_JSON, NULL);
 }
--=20
2.26.2

