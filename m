Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09150327CBC
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhCAK7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:59:44 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5928 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhCAK5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:57:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cc8860000>; Mon, 01 Mar 2021 02:57:10 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 10:57:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next 4/4] devlink: Add error print when unknown values specified
Date:   Mon, 1 Mar 2021 12:56:54 +0200
Message-ID: <20210301105654.291949-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301105654.291949-1-parav@nvidia.com>
References: <20210301105654.291949-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614596230; bh=b7ZVOJ0CxDueeS4X1KzwxHEOsHogvQSQSIIA358SGXc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=CVD8Mcn7klXmLWhxnz3gnFN742/zycMMm3pe5bfo0vtuKWVfmS+KenU9GPB7NyOFh
         XwZ/WFWsIbF+JSf5m+CQVMDDSYQNgKhFP8YQNi1sX+kWSrXmM9CwCSXrvc/QLEc5+A
         VoyYJs5kKxGGvS2kOjid//S+Ks6zvrEd9BHTvJVOqwubNG9YPZ5wXtFHBsNUZ2nfA8
         Vdg9ApEVKbG+aLHvX3t86kV6xup2ihCoE/ltOCeKRZKB4/QRyBcT9+CT8zjwWOxlrz
         7UZfL25omlTHofkdPwpkIWDVOmWPH1RlMmHqEMIyFXPzCozjkcdLI+cdcG4fSsd2d7
         EQcg4CQmvMz6A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user specifies either unknown flavour or unknown state during
devlink port commands, return appropriate error message.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 devlink/devlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index eaac1806..16eca4f9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1372,8 +1372,10 @@ static int port_flavour_parse(const char *flavour, u=
int16_t *value)
 	int num;
=20
 	num =3D str_map_lookup_str(port_flavour_map, flavour);
-	if (num < 0)
+	if (num < 0) {
+		invarg("unknown flavour", flavour);
 		return num;
+	}
 	*value =3D num;
 	return 0;
 }
@@ -1383,8 +1385,10 @@ static int port_fn_state_parse(const char *statestr,=
 uint8_t *state)
 	int num;
=20
 	num =3D str_map_lookup_str(port_fn_state_map, statestr);
-	if (num < 0)
+	if (num < 0) {
+		invarg("unknown state", statestr);
 		return num;
+	}
 	*state =3D num;
 	return 0;
 }
--=20
2.26.2

