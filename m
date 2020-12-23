Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AB82E206E
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgLWS1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgLWS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:44 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69FDC061248
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:44 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D1M954rV5zQjVL;
        Wed, 23 Dec 2020 19:26:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GAc/WEJE+IuZLLJvGJ0EPuIt73APYrg//B1OeCkTGfk=;
        b=e3cvSSF/e4xKHGWDDl2M80xcyzC8FDpy4BMNkU0Hgp8QnMp6vWIgP4MK+ut557XEdTN8Bd
        sNFizx/09+HcM3EsgMMecUe/MjQB2//iQaMf4TVcM08JX8j5Sg9NZSjc1rDqSlacpEmsL+
        n+YV8kOAcK7lMJByuLmQRpq/kFfHhaKabpmkf4yXoUZCavO7ybwQS7ZYf7qlWfqzc9rPAc
        YMf9Qiv5QbAfaUeNCORPNEm3ir65UmYDvwIgkkE5tTyw3y0lhLdtfU8y+jd332XLUG10H+
        Pd/1lUSwLaSBPlgFLWVx2c5PqOt7770kCkw0eS0XhN2SEUV69mrEB6gAMj8H9w==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id kPmtOdt6vOHf; Wed, 23 Dec 2020 19:26:15 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 1/9] dcb: Set values with RTM_SETDCB type
Date:   Wed, 23 Dec 2020 19:25:39 +0100
Message-Id: <01bb5087a21e080af486b9e7f859193a2917915a.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.00 / 15.00 / 15.00
X-Rspamd-Queue-Id: A6F1C17D8
X-Rspamd-UID: 882d50
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dcb currently sends all netlink messages with a type RTM_GETDCB, even the
set ones. Change to the appropriate type.

Signed-off-by: Petr Machata <me@pmachata.org>
---
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
2.25.1

