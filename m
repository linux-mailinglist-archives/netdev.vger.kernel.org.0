Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFD52E85EC
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 00:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbhAAX1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 18:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbhAAX1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 18:27:13 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FDCC0613C1
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 15:26:32 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4D71PH41SMzQlY3;
        Sat,  2 Jan 2021 00:26:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609543585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gle0vtMIVZMesU3tvmOBxGiadQ9e6zl1S4q9t4+Ukgc=;
        b=hOq7aQdlny0gGC6GIH0MVHl9UOm+YbtxXD2qQeCEKZ+4SCdzpS93qLN1C6u6Zvqo3puYQ1
        RgqnviF5OkTNjpHfTaaf0scbbHpicAuEo1LF/7Gp4u13jPeEQ+H03Aa0Byt3zManJAmQea
        uU0HzKAM2k4oe7OwQuFe0nmHOaCZxhLAsasqqyCS2cd+sosADlIOd2Lqr0cFoSCKOKJ1Im
        cSMszOxVOFohxfqd+LM2XTXWIgg/RsnflcH9zOqg2LgmFU3he7ylTCCLD9DvcmJQaZpJpc
        pytncecY6EdmF2l+hv9wPjbmTKO6jy+iry3VZ72NDKR8wgd+BfTH8TtvEPxrnA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id 5uOPJ0T4GPwn; Sat,  2 Jan 2021 00:26:22 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2 1/3] dcb: Set values with RTM_SETDCB type
Date:   Sat,  2 Jan 2021 00:25:50 +0100
Message-Id: <61a95beac0ea7f2979ffd5ba5f4a08f000cc091a.1609543363.git.me@pmachata.org>
In-Reply-To: <cover.1609543363.git.me@pmachata.org>
References: <cover.1609543363.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: 58D511835
X-Rspamd-UID: cac559
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
2.26.2

