Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A67A272DA7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgIUQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:42:03 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7006 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgIUQlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:41:45 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68d76b0001>; Mon, 21 Sep 2020 09:40:11 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep
 2020 16:41:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/2] devlink: Enhance policy to validate eswitch mode value
Date:   Mon, 21 Sep 2020 19:41:29 +0300
Message-ID: <20200921164130.83720-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200921164130.83720-1-parav@nvidia.com>
References: <20200921164130.83720-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600706411; bh=ZBvyhuSngg9GjiVPl7vGvHXNJ6PJDH2p0sWe9mXGZ48=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Jdz0gQl9zo0hp6R5Ej+7MtQWrRUnAMUAUAiTt+85or7PivwuUHwNh06Wju9lDktV+
         l14OfFPZVp4SeqsBqR2UBvdZVg4lLG2lvbpL5uHaUwkUHpPlo7MBhHDt6iPB2V0kvz
         99HV7EkUB8g82Z+2PvSNnrJij1gRpoJ1hfYFN7JudRj1VJfp73GQwMsqPAC/PWELm5
         pK1zRv6l4nDTFXcHijX8GC+HgOMRtXUzBtlb8t1YqdBNurujoPYckpPPnPynuNPjHo
         rxQfCxU3Er5ewRzy8EiSfshUcRpgiGYIZmoucaOG5Ma4CBzKRLM/raPUxMa2NocdnH
         plKd7sC34IB0g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use range checking facility of nla_policy to validate eswitch mode input
attribute value is valid or not.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 25dd9309e86f..4ecc68a9c7df 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7202,7 +7202,8 @@ static const struct nla_policy devlink_nl_policy[DEVL=
INK_ATTR_MAX + 1] =3D {
 	[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE] =3D { .type =3D NLA_U8 },
 	[DEVLINK_ATTR_SB_THRESHOLD] =3D { .type =3D NLA_U32 },
 	[DEVLINK_ATTR_SB_TC_INDEX] =3D { .type =3D NLA_U16 },
-	[DEVLINK_ATTR_ESWITCH_MODE] =3D { .type =3D NLA_U16 },
+	[DEVLINK_ATTR_ESWITCH_MODE] =3D NLA_POLICY_RANGE(NLA_U16, DEVLINK_ESWITCH=
_MODE_LEGACY,
+						       DEVLINK_ESWITCH_MODE_SWITCHDEV),
 	[DEVLINK_ATTR_ESWITCH_INLINE_MODE] =3D { .type =3D NLA_U8 },
 	[DEVLINK_ATTR_ESWITCH_ENCAP_MODE] =3D { .type =3D NLA_U8 },
 	[DEVLINK_ATTR_DPIPE_TABLE_NAME] =3D { .type =3D NLA_NUL_STRING },
--=20
2.26.2

