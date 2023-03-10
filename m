Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8524B6B3C38
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjCJKcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjCJKcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:32:20 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46AA111685;
        Fri, 10 Mar 2023 02:32:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3BDB120655;
        Fri, 10 Mar 2023 10:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678444335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SABMsfykBuZLlX/EID5G4jmWDCswPlY6bB+XmpUmDDI=;
        b=foj1gEREC5pFoZcss66MTasW9SmKGZ8VO45QQ5RxFr2/gbLbCBrgbYL8TlQQxufdOQ3EFE
        czVB8jboaSapWQSAvTbgzlr6p+6za4Flui5sC1W23abuExTqIegh6cm1gPfGqBzmxekr0H
        TCUXtSdOonDGjPPPUlKUoc9FsmC5aAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678444335;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SABMsfykBuZLlX/EID5G4jmWDCswPlY6bB+XmpUmDDI=;
        b=JCOpFCvpQJqkp5/VtYAnLRuXjAB156OkLDECkwvRNK9kuNoHX2iWKKVfw/Gx5/VOde/eYE
        9dMcNAa9idgNdMBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0984B13592;
        Fri, 10 Mar 2023 10:32:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6Ay0AS8HC2SsXQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Mar 2023 10:32:15 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4/7] mm, pagemap: remove SLOB and SLQB from comments and documentation
Date:   Fri, 10 Mar 2023 11:32:06 +0100
Message-Id: <20230310103210.22372-5-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SLOB has been removed and SLQB never merged, so remove their mentions
from comments and documentation of pagemap.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 Documentation/admin-guide/mm/pagemap.rst | 6 +++---
 fs/proc/page.c                           | 5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index b5f970dc91e7..bb4aa897a773 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -91,9 +91,9 @@ Short descriptions to the page flags
    The page is being locked for exclusive access, e.g. by undergoing read/write
    IO.
 7 - SLAB
-   The page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator.
-   When compound page is used, SLUB/SLQB will only set this flag on the head
-   page; SLOB will not flag it at all.
+   The page is managed by the SLAB/SLUB kernel memory allocator.
+   When compound page is used, either will only set this flag on the head
+   page..
 10 - BUDDY
     A free memory block managed by the buddy system allocator.
     The buddy system organizes free memory in blocks of various orders.
diff --git a/fs/proc/page.c b/fs/proc/page.c
index 6249c347809a..1356aeffd8dc 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -125,7 +125,7 @@ u64 stable_page_flags(struct page *page)
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 *
-	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
+	 * Note that page->_mapcount is overloaded in SLAB/SLUB, so the
 	 * simple test in page_mapped() is not enough.
 	 */
 	if (!PageSlab(page) && page_mapped(page))
@@ -166,8 +166,7 @@ u64 stable_page_flags(struct page *page)
 
 	/*
 	 * Caveats on high order pages: page->_refcount will only be set
-	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
-	 * SLOB won't set PG_slab at all on compound pages.
+	 * -1 on the head page; SLAB/SLUB do the same for PG_slab;
 	 */
 	if (PageBuddy(page))
 		u |= 1 << KPF_BUDDY;
-- 
2.39.2

