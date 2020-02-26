Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39016F6CD
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 06:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBZFIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 00:08:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgBZFIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 00:08:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=U+dB6gk2uJXVZhNfV7qCCj3YibiHAAJzd7aMktDlf4w=; b=P5VfpRzba9RVuKYOn675JtFGgV
        lEHciEPDCLvuLKw7PS89gAF6qajtrtM/CZxCT9V29zfCXR9lNqAeMZhoV7Lr94rp0KVhc4hdELmuW
        4nI6/xZFwyXP2Qt52QVDevvL/dCac3Ewvowg6LLF8jRbjVBafihzMf8vD00pO/7U1ckPuIfxhwtHL
        9KJo6ZpZpHbgaamu2suDsz4maQ6Yz0wSi2p58c54JrneF248ZDHD/VqCf5fcOU3iONVn6qTXGxV98
        b0ZR8TsJLmIPbiqTSVKfU+DRTn945my/KBhuP+IyxmLatvENKsnmDHelvdbLafh21c6tw+C6qgFRV
        t1S+dB8A==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6owH-0001Nn-2J; Wed, 26 Feb 2020 05:08:53 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next] af_llc: fix if-statement empty body warning
Message-ID: <4c9fed49-50a7-2877-e9bc-e650a20c0379@infradead.org>
Date:   Tue, 25 Feb 2020 21:08:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

When debugging via dprintk() is not enabled, make the dprintk()
macro be an empty do-while loop, as is done in
<linux/sunrpc/debug.h>.

This fixes a gcc warning when -Wextra is set:
../net/llc/af_llc.c:974:51: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

I have verified that there is not object code change (with gcc 7.5.0).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/llc/af_llc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200225.orig/net/llc/af_llc.c
+++ linux-next-20200225/net/llc/af_llc.c
@@ -47,7 +47,7 @@ static int llc_ui_wait_for_busy_core(str
 #if 0
 #define dprintk(args...) printk(KERN_DEBUG args)
 #else
-#define dprintk(args...)
+#define dprintk(args...) do {} while (0)
 #endif
 
 /* Maybe we'll add some more in the future. */

