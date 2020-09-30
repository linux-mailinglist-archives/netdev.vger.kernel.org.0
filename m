Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81B27E709
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgI3Ktu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:49:50 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17958 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgI3Ktm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:49:42 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7462b90001>; Wed, 30 Sep 2020 03:49:29 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 10:49:39 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 3/6] selftests: forwarding: devlink_lib: Support port-less topologies
Date:   Wed, 30 Sep 2020 12:49:09 +0200
Message-ID: <15c667b9ba01498290d2c842e54e6c335b1bc37d.1601462261.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1601462261.git.petrm@nvidia.com>
References: <cover.1601462261.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601462969; bh=N6fjJ6Rf5mDLZZWmysulTFNF/pwjAXbTIfcUJA2lEpg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HsfbilWjX8tVIME53cAayqqhVSvCmM6Fta6Bx3Z/76Nr4okljyJGNOWmSfIkqEj+h
         U9Tz7V23S6KpcIFOriDk9PQ3y23gpi3+2z5FTvx9thPQuue9SxZj8M4hE4wEc6ZKVI
         2jTrQmQeYeQYrGUykq9wwNZdWGcCn3yYx1Yu0M52pPU67cS9klBUmkSGyINdokpIPA
         Pj63QYFIjSnFMYFyfemth5WGy3Zuvzx4ofkTBNwiANz9G4M3HDLmVbWxg6SGs+7mTa
         ASDjKlkV+pjJ5g85E0Izo9dsksMWnO+DAlc09GPi5Bdc8cU587jzJwslDbcfMzPcoS
         /vnM2WCB/VQZQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some selftests may not need any actual ports. Technically those are not
forwarding selftests, but devlink_lib can still be handy. Fall back on
NETIF_NO_CABLE in those cases.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/=
testing/selftests/net/forwarding/devlink_lib.sh
index cf4e5daf767b..9c12c4fd3afc 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -5,7 +5,7 @@
 # Defines
=20
 if [[ ! -v DEVLINK_DEV ]]; then
-	DEVLINK_DEV=3D$(devlink port show "${NETIFS[p1]}" -j \
+	DEVLINK_DEV=3D$(devlink port show "${NETIFS[p1]:-$NETIF_NO_CABLE}" -j \
 			     | jq -r '.port | keys[]' | cut -d/ -f-2)
 	if [ -z "$DEVLINK_DEV" ]; then
 		echo "SKIP: ${NETIFS[p1]} has no devlink device registered for it"
--=20
2.20.1

