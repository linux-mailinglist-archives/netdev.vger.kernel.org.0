Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BAE2F02F1
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbhAISz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbhAISzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 13:55:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F43B239FC;
        Sat,  9 Jan 2021 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218453;
        bh=HJa9IxIP7Q035YSq3gk1tCBTIST4dvqtxPzRs77R/k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbT3qJJktvvYxhrSFFFmpw+Ud7ZsFB9EOhIcX54FkrADjC021RNMCKHdDEmbyvy5l
         faVRDROvKsGCZ4EJEGgjW5w5s4iQMKbSqqeewjKFxlU8VG5McU2hI9YwqeqIJePKkJ
         6kzhxcpK1SHHWyoAoodBPB/e5eS6zIsrmACvNGRmB50MYKERKI3Mmm39lEQwxL3zc2
         3Vf19y0D7++JLGaxXDEz6zR84awljBtIkkGWpp1yEqhD+JE0Dq/h8kC0AQZeTDa+dT
         YVPHJPx7mG8vyGI2Un928ERClCglQY6SfLN+iuXva0XVsNsvVS25FkOwIlhn2v7ftY
         AIAEbkiJ2GN1w==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/11] selftests: Make address validation apply only to client mode
Date:   Sat,  9 Jan 2021 11:53:55 -0700
Message-Id: <20210109185358.34616-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210109185358.34616-1-dsahern@kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
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
index b1d6874d69ee..ff64012ac586 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1718,6 +1718,12 @@ static int ipc_child(int fd, struct sock_args *args)
 
 	server_mode = 1; /* to tell log_msg in case we are in both_mode */
 
+	/* when running in both mode, address validation applies
+	 * solely to client side
+	 */
+	args->has_expected_laddr = 0;
+	args->has_expected_raddr = 0;
+
 	rc = do_server(args, fd);
 
 	free(outbuf);
-- 
2.24.3 (Apple Git-128)

