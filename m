Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEFE27E704
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgI3Ktk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:49:40 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1560 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgI3Ktj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:49:39 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7462900002>; Wed, 30 Sep 2020 03:48:48 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 10:49:36 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 2/6] selftests: forwarding: devlink_lib: Add devlink_cell_size_get()
Date:   Wed, 30 Sep 2020 12:49:08 +0200
Message-ID: <12dedba4a0d466008b3fe888157335e93e24b56e.1601462261.git.petrm@nvidia.com>
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
        t=1601462928; bh=0VEnX2iOdugDux+klqr3itOvTIZF5XzgcDjixEbRm5s=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=rvdhXyDNDjWVjm9DIWbpgWed8iUFACC0OESgSKvToHCdNCrC5Ks+xMRCmSnizk0CU
         cvSJr+E/f0XZCVI2Oc7hz6z8w4kDT5/nf6UTRQRwCweWsjyRkAKpTZYBCHcT1lGypU
         deqxEVC3oytMlWfC0+yq3CcZZoIxFO13mHZaYcotwRlybOJ0lFmgzpCc6Y4Tru5uxT
         IHtQj7Je9woqzS27YdBhX7ygP4w5/ohK6i2r54hpqkQ6zcjGZis8Evx9ysRx3uoIuC
         ht5+Q8gXJxWo0DOpHz5akK+oo0wprMIHk8pC72keYAQoZBfGJrRIuqahCkUd3Xqdnl
         HAqFT8aB45aQw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper that answers the cell size of the devlink device.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/=
testing/selftests/net/forwarding/devlink_lib.sh
index ba6aca848702..cf4e5daf767b 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -549,3 +549,9 @@ devlink_cpu_port_get()
=20
 	echo "$DEVLINK_DEV/$cpu_dl_port_num"
 }
+
+devlink_cell_size_get()
+{
+	devlink sb pool show "$DEVLINK_DEV" pool 0 -j \
+	    | jq '.pool[][].cell_size'
+}
--=20
2.20.1

