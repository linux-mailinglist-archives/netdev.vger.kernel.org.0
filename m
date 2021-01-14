Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D578C2F58FC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbhANDLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbhANDLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:11:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99E4423719;
        Thu, 14 Jan 2021 03:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593802;
        bh=znc4U6E72r24fegAtxZa3ihiNf9HEbk725YfFDGRE7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWGRHPsXEzOXqWRUWvrZDZsdKVj7pfg6N4pxigN1GjZj5iv4a9prIM2gja8bFelgF
         mW81ptZnQV0f6cR0J2m/ajtkIXx1jFHdLav3R7htg+zd2whovtfgcwzh1fxOsMwCl5
         xTXraoqTSSwKk2f5PyD1433Yt8abDC1gdQkoSrebYgmixWCGn1S1ieu88hBJtMBcRk
         iWyLBeH9Y9Bgu8jFB8tUHuuDLZbzGiLbas6uRWbAllES0ol3rDl5t25owZIcbgwNVi
         xhhb0yHMT+S0Cx7+5TppdjIatvhitYBwmsxYoGyYUoLwyuhAM5YC2FUSF/xooGQBfD
         GGIr0k3WNrk5Q==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v4 08/13] selftests: Make address validation apply only to client mode
Date:   Wed, 13 Jan 2021 20:09:44 -0700
Message-Id: <20210114030949.54425-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210114030949.54425-1-dsahern@kernel.org>
References: <20210114030949.54425-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

When a single instance of nettest is used for client and server
make sure address validation is only done for client mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 186262a702bf..0e01a7447521 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1720,6 +1720,12 @@ static int ipc_child(int fd, struct sock_args *args)
 
 	server_mode = 1; /* to tell log_msg in case we are in both_mode */
 
+	/* when running in both mode, address validation applies
+	 * solely to client side
+	 */
+	args->has_expected_laddr = 0;
+	args->has_expected_raddr = 0;
+
 	rc = do_server(args, fd);
 
 out:
-- 
2.24.3 (Apple Git-128)

