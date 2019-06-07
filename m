Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44900398FE
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbfFGWiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbfFGWiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 18:38:19 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA2720868;
        Fri,  7 Jun 2019 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559947098;
        bh=xM5DNrsmEG9g5p6X7sFE3f4jmCS9m0E85wnQOdos27o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKdfM46TRvrV7NbChfCjBo57GkOTg7sQi0V2zGO4x7HrXHShjxleXdcR4+VLec5T0
         bhOTOCxQ/D0N4lb3JrGdS9GEeMScSEP9klkrDlyit9QXt92eM+kDMjfIKY0rMZRRW2
         i3WRqsE3X5KqwsGETdrI2n0tdWCkBjDOMu/TspGo=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 iproute-next 01/10] libnetlink: Set NLA_F_NESTED in rta_nest
Date:   Fri,  7 Jun 2019 15:38:07 -0700
Message-Id: <20190607223816.27512-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607223816.27512-1-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
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

