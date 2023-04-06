Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9597D6D969C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbjDFMAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 08:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbjDFMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089D5AF18;
        Thu,  6 Apr 2023 04:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 750CC6448C;
        Thu,  6 Apr 2023 11:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B342DC433EF;
        Thu,  6 Apr 2023 11:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780860;
        bh=fHd5p+u3wf0voZ3oDttRIL4X67Yo6YPvWVEiI3rElds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEWGd4RgSq03YTvEn7O6jvEUYCm9BsS4kA2Z3p0phclRBFfJd/F/qJqjZt7gMZ0kP
         XQRRBx4fVJ9UwU0akyxEjw0p2elkuFIgJEAvFZEPXOKUAZEVJfQ/6cr4xPzoip9F1o
         jP8NcTU8tTdAHgMpyNUFE5+4YPaxGg0lFOqJosnn79KgKc1MmFLNiRm6NeQQPuVcmm
         RyQYP4AJj/FlITLV8bTsPEB7P4ucqPmcxiX2a4RGxTntCrVRr3l4sk+WAkeq8MUr/K
         MdSUZP+goACcxZRbTRV9TqTVP2o0YVaNy2qpZSHQC4CLq3wWDh2i2Udqgc5FpaCQWb
         7RZ3OxTrAxs+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Jan Beulich <jbeulich@suse.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        paul@xen.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 8/8] xen/netback: use same error messages for same errors
Date:   Thu,  6 Apr 2023 07:34:00 -0400
Message-Id: <20230406113400.649038-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113400.649038-1-sashal@kernel.org>
References: <20230406113400.649038-1-sashal@kernel.org>
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
index ed644b6824cef..d2b79d7c0b881 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -989,10 +989,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 
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

