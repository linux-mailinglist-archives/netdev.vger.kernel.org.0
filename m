Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F3F2F083
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732749AbfE3EEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbfE3DRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:17:49 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A89724479;
        Thu, 30 May 2019 03:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186269;
        bh=xM5DNrsmEG9g5p6X7sFE3f4jmCS9m0E85wnQOdos27o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wl4KHB1fvi1rfeemWen6YkVZ0HQ3DaEjbLJ3bJOZ31c1ciqQhQ3lsDHhWDikOgw3Z
         qejwP/z6l382QJ/9qw/E+7rwrt38grrqzjq0mM0McjkQitRBD/o6z1wDYucQ4/j48V
         DZTzCP1csVQtuWkKtQlV3xmOGDTw7I23OndjmYwE=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 1/9] libnetlink: Set NLA_F_NESTED in rta_nest
Date:   Wed, 29 May 2019 20:17:38 -0700
Message-Id: <20190530031746.2040-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530031746.2040-1-dsahern@kernel.org>
References: <20190530031746.2040-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Kernel now requires NLA_F_NESTED to be set on new nested
attributes. Set NLA_F_NESTED in rta_nest.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 lib/libnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 0d48a3d43cf0..6ae51a9dba14 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1336,6 +1336,7 @@ struct rtattr *rta_nest(struct rtattr *rta, int maxlen, int type)
 	struct rtattr *nest = RTA_TAIL(rta);
 
 	rta_addattr_l(rta, maxlen, type, NULL, 0);
+	nest->rta_type |= NLA_F_NESTED;
 
 	return nest;
 }
-- 
2.11.0

