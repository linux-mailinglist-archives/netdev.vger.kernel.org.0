Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0047E2E8BCF
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 11:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhACK6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 05:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbhACK6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 05:58:40 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5E8C0613C1
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 02:58:00 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4D7whk6QfZzQlWy;
        Sun,  3 Jan 2021 11:57:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609671477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SkvSfzhAWhLW7JEYgHP2iP6pqqrYXhbZVe4QPvTI2gc=;
        b=sl+DdZGXNzEkRsAcbE1l2P2Vvgw17TMC9an/azoyUNJ+xnywPsqIDLTyLdncIyzK2cyuuS
        J9XyLZPe8h+qa6fRxrYcn8Bx2HNHqYIttEGFjmlBgHSMn2EoBFf5ovCFJj/pLqm8ln6nVc
        CaZGz4npqV+6kGLA47aBVanfxdLD88xa+SlP3g3DDDqfWbwJbcNF4aGl67E0OYefBJ5mx6
        hjE+RLBOR4VCAPj4VFpobf+SahszvruT72wYoTrIsvnQf4E07OEd+0LPRXqUvKLFuSGUTM
        rmQWzmUXqfFjMbf+Waw8MeCpu/Unp8oEM9uSI5alzK+4cSYW5+RwG+TUbkV3oQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id wRDt_selC-AZ; Sun,  3 Jan 2021 11:57:56 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 v2 1/3] dcb: Set values with RTM_SETDCB type
Date:   Sun,  3 Jan 2021 11:57:22 +0100
Message-Id: <c50c9c6c982b7cd6b3b5c4affb0c975211c8a70a.1609671168.git.me@pmachata.org>
In-Reply-To: <cover.1609671168.git.me@pmachata.org>
References: <cover.1609671168.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.09 / 15.00 / 15.00
X-Rspamd-Queue-Id: EE40A1856
X-Rspamd-UID: b0b5db
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dcb currently sends all netlink messages with a type RTM_GETDCB, even the
set ones. Change to the appropriate type.

Fixes: 67033d1c1c8a ("Add skeleton of a new tool, dcb")
Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v2:
    - Add Fixes: tag.

 dcb/dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index adec57476e1d..f5c62790e27e 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -177,7 +177,7 @@ int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *da
 	struct nlattr *nest;
 	int ret;
 
-	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_SET);
+	nlh = dcb_prepare(dcb, dev, RTM_SETDCB, DCB_CMD_IEEE_SET);
 
 	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
 	mnl_attr_put(nlh, attr, data_len, data);
-- 
2.26.2

