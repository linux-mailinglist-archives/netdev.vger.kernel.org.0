Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2B3189AE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhBKLka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:40:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19352 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhBKLhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:37:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602516ae0002>; Thu, 11 Feb 2021 03:36:14 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 11:36:14 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 11:36:11 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 2/3] net/tls: Select SOCK_RX_QUEUE_MAPPING from TLS_DEVICE
Date:   Thu, 11 Feb 2021 13:35:52 +0200
Message-ID: <20210211113553.8211-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210211113553.8211-1-tariqt@nvidia.com>
References: <20210211113553.8211-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613043374; bh=46Ejv8QFduxYBeMowkQSnD1kJdnzWdQLHpMB10zNevs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=ed/KypqyhegMsQjJecSnAbHPfwxVcXfKvT2qrX2Y7ZYT5Oiw7OU3WTe5+SR6ybSZQ
         UFiH1oByMVj3EMv9qfgfjCvbqTwe/nvc4h4h2bslo2CBPBnQL/wkU6ZTzd/ufv+3vm
         vYgTqMkM9aQkmPg193Yw4u/CtV2RNFyje5S4Y5VSTCMZ7O8IJZmDkMb7wrjXBNzicO
         kgFyZlMBjBZ5BdLpuYjzaTq/uJNwZSF0Wee4nPnfOSUTv0msPYMxKfgaARDc3eF3Vm
         CLnt3e0etsDftqZGKq11ck2DTTSzGsZvj1QEqyvGbPMu1cl9nbj1uzWbybvnrtBUFM
         AwJurXRewAEDg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compile-in the socket RX queue mapping field and logic when TLS_DEVICE
is enabled. This allows device drivers to pick the recorded socket's
RX queue and use it for streams distribution.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 net/tls/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/Kconfig b/net/tls/Kconfig
index fa0724fd84b4..0cdc1f7b6b08 100644
--- a/net/tls/Kconfig
+++ b/net/tls/Kconfig
@@ -21,6 +21,7 @@ config TLS_DEVICE
 	bool "Transport Layer Security HW offload"
 	depends on TLS
 	select SOCK_VALIDATE_XMIT
+	select SOCK_RX_QUEUE_MAPPING
 	default n
 	help
 	Enable kernel support for HW offload of the TLS protocol.
--=20
2.21.0

