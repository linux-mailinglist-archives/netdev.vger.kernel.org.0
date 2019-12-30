Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9255112D4CA
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfL3WTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbfL3WTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 17:19:34 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B32620863;
        Mon, 30 Dec 2019 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577743880;
        bh=iItIopwy+24kUYdzcBV6zT2lz3+S6e2kUsQemvsVNvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnqGO51RO8ZII88GJl8iqWlWFxp75yG2lpWqbrKcLaqFWYTvUPU9H0e4HSjeBKW5e
         YEI14kApEePhLnK2LRU2AYN3fFkliur5CaYr9r0RoyhoDilG/pEyNJ/h7o7PqVI3FA
         X6w7/gFH6uV0C6VHsbDwWDGv/iE27KT5hnKlFoGQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        roopa@cumulusnetworks.com, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 6/9] nettest: Return 1 on MD5 failure for server mode
Date:   Mon, 30 Dec 2019 14:14:30 -0800
Message-Id: <20191230221433.2717-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

On failure to set MD5 password, do_server should return 1 so that the
program exits with 1 rather than 255. This used for negative testing
when adding MD5 with device option.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index c08f4db8330d..bb6bb1ad11e2 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1194,7 +1194,7 @@ static int do_server(struct sock_args *args)
 
 	if (args->password && tcp_md5_remote(lsd, args)) {
 		close(lsd);
-		return -1;
+		return 1;
 	}
 
 	while (1) {
-- 
2.11.0

