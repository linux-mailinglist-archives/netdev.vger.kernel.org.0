Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367C8172E98
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 03:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgB1CJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 21:09:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730343AbgB1CJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 21:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=O2/XxYHXZhTXCp5fyW8svvdVtbM3DtHhBu801xlyEKI=; b=Xo8+ihGOAEicomrAmkUdwgMxXN
        UhauYvz0+5Z9GL1eoSBhFLMsN3UCZ12scQ0utaKddSYzGCAyzCMaYWuEHZc5HA9gaJztYa1vxKksK
        gK3PFPQDRlxrqzwGDrKqsvV9Qf7Pv1cs+Q1k+E0eInW5LONs0E3RMFlSr4NkcaX8vKuHnysRmSng9
        lWMtLyzomo6Zm3ca9FlhKjor6ErmGcLrGvqL3jKoIZ6UgtB9sjGjIXR51bHbNRxbEILk60ARU0D6T
        S5lCVr/lAcgCtT5NinL7WlSNWmA9T2VfkNRZNrlNjU0py1L+k5YEltuiVxXB8VdqoQPOrKBLcZcJR
        99SgF05A==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j7V61-0004rr-2B; Fri, 28 Feb 2020 02:09:45 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] atm: nicstar: fix if-statement empty body warning
Message-ID: <0ce2604d-191f-0af2-a2f4-9c70da21e907@infradead.org>
Date:   Thu, 27 Feb 2020 18:09:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

When debugging via PRINTK() is not enabled, make the PRINTK()
macro be an empty do-while block.

Thix fixes a gcc warning when -Wextra is set:
../drivers/atm/nicstar.c:1819:23: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]

I have verified that there is no object code change (with gcc 7.5.0).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/atm/nicstar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200225.orig/drivers/atm/nicstar.c
+++ linux-next-20200225/drivers/atm/nicstar.c
@@ -91,7 +91,7 @@
 #ifdef GENERAL_DEBUG
 #define PRINTK(args...) printk(args)
 #else
-#define PRINTK(args...)
+#define PRINTK(args...) do {} while (0)
 #endif /* GENERAL_DEBUG */
 
 #ifdef EXTRA_DEBUG

