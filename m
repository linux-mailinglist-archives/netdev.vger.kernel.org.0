Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20CC26DFF2
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgIQPPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 11:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbgIQPOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 11:14:18 -0400
Received: from Davids-MacBook-Pro.local.net (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32EC420795;
        Thu, 17 Sep 2020 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600355615;
        bh=VnR5LbVG0oCafg5QZpvtrSMYUghE0X82TPIu/E46ZGc=;
        h=From:To:Cc:Subject:Date:From;
        b=Wrhu2PqtvNN+291lICujYP/pqHU0igMd83FFouPea4sudHXmUvNUjjf0i/GjY/Xxo
         rmCk2DhvsktTUbEEHdxSNvVEbLxMivA9iiEso/cEJdoamHWxTQyAP4gKGgVyXpRY1D
         h/3be3a+jIMkB1uxjyOrbyXfGph5Q8HBquxUHw6E=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] selftests: Set default protocol for raw sockets in nettest
Date:   Thu, 17 Sep 2020 09:13:33 -0600
Message-Id: <20200917151333.41252-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPPROTO_IP (0) is not valid for raw sockets. Default the protocol for
raw sockets to IPPROTO_RAW if the protocol has not been set via the -P
option.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/nettest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 93208caacbe6..f75c53ce0a2d 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1667,6 +1667,8 @@ int main(int argc, char *argv[])
 		case 'R':
 			args.type = SOCK_RAW;
 			args.port = 0;
+			if (!args.protocol)
+				args.protocol = IPPROTO_RAW;
 			break;
 		case 'P':
 			pe = getprotobyname(optarg);
-- 
2.24.3 (Apple Git-128)

