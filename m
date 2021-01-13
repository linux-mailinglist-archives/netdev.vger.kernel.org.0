Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1C2F42BF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbhAMECS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbhAMECS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:02:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28ABE23133;
        Wed, 13 Jan 2021 04:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610510461;
        bh=AnMUXiH8Q7mxhUIukUaGP8BL/EouVF+WBAX49+owjnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3C4QWgSXwghQ6yxp9gz5CE154L/DDAAuX+ctexXmuo5V0hmOFKXJejuxDgWCk7OJ
         XQS9q2hAmTFp0/ewENJ3C/zSq6bOFXQsuzAOl2o9fnj4sn5XyIw0dNUo5SQfkefmj1
         yed96NALLkgNtAbv0aDtnpCev/RkPwN3rbGkX1PVwxDaRnRVQrE/gjtq4JgR/TI0N9
         tVY3zlYUzQMnQDmhb0N/dHHvW7buImmKS2OloSYr4DT0nlItJNW6doaN8KovsM/kp1
         bYXsDCPHfk114cCo27lgT8+WmejNe0aK44Vlkci6aVfgRyRiOVAekWgsVp9y70F66H
         Rixvzx9JfyMeQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 08/13] selftests: Make address validation apply only to client mode
Date:   Tue, 12 Jan 2021 21:00:35 -0700
Message-Id: <20210113040040.50813-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210113040040.50813-1-dsahern@kernel.org>
References: <20210113040040.50813-1-dsahern@kernel.org>
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
index dded36a7db41..b436e2942e86 100644
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
 
 	free(outbuf);
-- 
2.24.3 (Apple Git-128)

