Return-Path: <netdev+bounces-7375-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A04871FF0D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED74B1C20C73
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC82918C10;
	Fri,  2 Jun 2023 10:22:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A263D18C0F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:22:10 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A309132;
	Fri,  2 Jun 2023 03:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685701329; x=1717237329;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=aF+00fMmCxB5g2z9dZZXQyc7aZrPeManS84M0BOgQmc=;
  b=Ji+g8NPtFP5ReehOvBW/GcMc04TY4r2x3deAIMvzv4ckGHuvGHcLx45T
   hasD/slbVCPzClzwi9u6Es8Kk1aXdp3fNrbFWjmrWWWVqRCkYbXwhlJjp
   ZJwrkkYtOXLptgp7bMN/5WAs3T41h0Re+Z/XXpO3o7p0+YaqicBEdn51F
   nfWtUn8DBVBZF+U8JFSrmFfiRKhGRIAE4StFeYJpwA3TdJWj4AP5CzGdj
   h5rqsfHCemFxWNF7BkFcBVP6IETQQ5GgiizjFedeTxRynGqpJ29kI5I0x
   K6lvN62Df4w4PELQfEAmyqRy9AONUTme3P0BotjucPbnpxy7Hhc2bEsIs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="358267640"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="358267640"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 03:22:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="707805001"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="707805001"
Received: from lab-ah.igk.intel.com ([10.102.138.202])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 03:22:05 -0700
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Fri, 02 Jun 2023 12:21:36 +0200
Subject: [PATCH v9 4/4] lib/ref_tracker: remove warnings in case of
 allocation failure
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-track_gt-v9-4-5b47a33f55d1@intel.com>
References: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
In-Reply-To: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
To: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, 
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>, 
 netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
 Andi Shyti <andi.shyti@linux.intel.com>, 
 Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Library can handle allocation failures. To avoid allocation warnings
__GFP_NOWARN has been added everywhere. Moreover GFP_ATOMIC has been
replaced with GFP_NOWAIT in case of stack allocation on tracker free
call.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 lib/ref_tracker.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index cce4614b07940f..cf5609b1ca7936 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -189,7 +189,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
 	struct ref_tracker *tracker;
 	unsigned int nr_entries;
-	gfp_t gfp_mask = gfp;
+	gfp_t gfp_mask = gfp | __GFP_NOWARN;
 	unsigned long flags;
 
 	WARN_ON_ONCE(dir->dead);
@@ -237,7 +237,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 		return -EEXIST;
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
+	stack_handle = stack_depot_save(entries, nr_entries,
+					GFP_NOWAIT | __GFP_NOWARN);
 
 	spin_lock_irqsave(&dir->lock, flags);
 	if (tracker->dead) {

-- 
2.34.1


