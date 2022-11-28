Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CEE63B016
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiK1RsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiK1RrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:47:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ADA27FDD;
        Mon, 28 Nov 2022 09:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C83FB80D1A;
        Mon, 28 Nov 2022 17:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2FDC43470;
        Mon, 28 Nov 2022 17:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657339;
        bh=Z8F0hZv64L9U7HllT2FAD/SVLF4zGevn7Eh66ZOy9MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOGbkDzjKUP50dlbc6j8fesUMD21iyi61x8/5WfyO3fvMnqwtgaWTm5oeDIcRzEEB
         46glF1lrwFYlwjiSKmdZYZTUM1DdrJ90NmrhiLtTZWAiE+F38o2yDzGFLmn4LNeRs6
         ldWub/QEU/WTK4w5OWgPiyXJ0o19+4MPboLDe+zKpw0vSS7bZDK61o9LSZx+qFne2m
         gpz51fn/lNRqkY4WTNAwWB+fReKNJnZDE7ZncDVyeIz6TfPBqbD5n/O86CNGJf3qB/
         RoRt9fWefymjaf+xbmyoWyWjoMYVmaiNYxfnLJ/YiWYwuX6dR/9UWNY221YJ2/hWVA
         7b6g8EQNipM0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/16] 9p/fd: Use P9_HDRSZ for header size
Date:   Mon, 28 Nov 2022 12:41:51 -0500
Message-Id: <20221128174201.1442499-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174201.1442499-1-sashal@kernel.org>
References: <20221128174201.1442499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 6854fadbeee10891ed74246bdc05031906b6c8cf ]

Cleanup hardcoded header sizes to use P9_HDRSZ instead of '7'

Link: https://lkml.kernel.org/r/20221117091159.31533-4-guozihua@huawei.com
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
[Dominique: commit message adjusted to make sense after offset size
adjustment got removed]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index b691871d9a02..05faded536cb 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -118,7 +118,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -289,7 +289,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -312,7 +312,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
-- 
2.35.1

