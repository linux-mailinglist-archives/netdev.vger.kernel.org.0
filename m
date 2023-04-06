Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD46D95A1
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbjDFLfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbjDFLez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:34:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48961A244;
        Thu,  6 Apr 2023 04:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29EA16446C;
        Thu,  6 Apr 2023 11:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EE2C433A1;
        Thu,  6 Apr 2023 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780793;
        bh=92M1GKdP/0zGE9SErJaH+kBPncxID6AmAyQ6G+mp5Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGGRLJnk8qjic7eN7c12nElKyNd5bXmMCjG7/bjB3PqqoN+SbVBlfKzalzvLQIReV
         tyHgF0TW5nnzvp8CWHRO4EaeJATBDVEDxFWA392f+CJK3udrAgiShc9sjRBvpGK98w
         Ikza+T29g9Yv3i7hYwz7694Oje2lYmQ5nb9hggHiBk8wFQ8OUCg+RV2z+WbjtDEi/p
         0yomVtcyjlIngUdgNwxW8JuUFqmJ7R4JNLwFVGLyLHmWcLeI/8NUVpNaYJaWRrCg1z
         E3fK0pol1vJ/MZ5i1ENnKUYgfVacwAkF3TcmYFGX66k3yYNhUpTiYTfZpzz5ym6ogO
         giGGe/45zFh6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jan Beulich <jbeulich@suse.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        paul@xen.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/11] xen/netback: use same error messages for same errors
Date:   Thu,  6 Apr 2023 07:32:49 -0400
Message-Id: <20230406113250.648634-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113250.648634-1-sashal@kernel.org>
References: <20230406113250.648634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 2eca98e5b24d01c02b46c67be05a5f98cc9789b1 ]

Issue the same error message in case an illegal page boundary crossing
has been detected in both cases where this is tested.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Link: https://lore.kernel.org/r/20230329080259.14823-1-jgross@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 303d8ebbaafc4..63118b56c5289 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -996,10 +996,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
 		/* No crossing a page as the payload mustn't fragment. */
 		if (unlikely((txreq.offset + txreq.size) > XEN_PAGE_SIZE)) {
-			netdev_err(queue->vif->dev,
-				   "txreq.offset: %u, size: %u, end: %lu\n",
-				   txreq.offset, txreq.size,
-				   (unsigned long)(txreq.offset&~XEN_PAGE_MASK) + txreq.size);
+			netdev_err(queue->vif->dev, "Cross page boundary, txreq.offset: %u, size: %u\n",
+				   txreq.offset, txreq.size);
 			xenvif_fatal_tx_err(queue->vif);
 			break;
 		}
-- 
2.39.2

