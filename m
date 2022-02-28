Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46704C69AD
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiB1LKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbiB1LJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:09:41 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D306C928;
        Mon, 28 Feb 2022 03:09:02 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id lw4so23947313ejb.12;
        Mon, 28 Feb 2022 03:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ewSqtxWpAEouzx42J3KLaoNJ3zRCYps/nc7KO/73VjI=;
        b=NJzfXKcN7hL1Nl33p4E04eSCSKXsmXm0guAXz3+luhQpanQnRU99MCp2hnFUKYaL+B
         1x361O+pkC4o39HmFVweecOA5EyrbgRoo6hBpKoe+ZK3uwuMgKcjXUUzcyKnqq4Ihz7Y
         0pE7mGFU6qwm5nlEaQI6CtIcQNt/P0yiVszOfwFWGIKlTpST4oUB8Axjb2KGdfFCf6oM
         BF7gos7RIFK+C7zFe1BBqWlnyj9ABXdIe2RTMFKfzCdWuqPXqav1BQyfcB8KfJDsFPFC
         rwx0y6HLf2zquaEOFfVg855ZoIJbHt3hF+DdFMjnEF9CZ4aqYu3RYVbCj5tslcC60Xqy
         JDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ewSqtxWpAEouzx42J3KLaoNJ3zRCYps/nc7KO/73VjI=;
        b=cpZVpveY7srDDOckQNQzga2h6shbCDDU84DQ5tMtLl3NkmLBKOeJjOf7Bl2Xyk725P
         AJ7w+ZTGcuchMbYuX/m05L7hBaCm//45J2aehR2ZYf/eeebplRPMDEuAJb07cUP/vo5t
         yFmWXl0yrK/vt0TexR9FQ9xi8wuTU0FNpjOnVZkcAt+GZ8xXjvUWol+a1bAnsIppT2dW
         zV6POB4NQPFngAxpbz0k056G8L/ubO+Z7GOXkfVduRlMxOnYpGCz77/B+9Tszh21lgxg
         pqzT84KAHS669RGmdB+CnR27go4+RreVaT2MXq3RoufefBEv069xhmUYeCG2O7lsOsP3
         7u8A==
X-Gm-Message-State: AOAM533KJ1dB1aDmLRJMUjImlaH/7M2wxr0J2FXoZThqg/ppuN/FzhDq
        i3HQCCf8/FC3rDAKdPoSgFs=
X-Google-Smtp-Source: ABdhPJzNtnbGg8Nz3uHKd7Xw6L7mCtzAWYaq4yun9pZXXpwsqc9NwfSvsBrijeUqxIoEXwfdb0F3Mg==
X-Received: by 2002:a17:906:26da:b0:6d6:da2e:d338 with SMTP id u26-20020a17090626da00b006d6da2ed338mr451651ejc.700.1646046541112;
        Mon, 28 Feb 2022 03:09:01 -0800 (PST)
Received: from localhost.localdomain (dhcp-077-250-038-153.chello.nl. [77.250.38.153])
        by smtp.googlemail.com with ESMTPSA id z22-20020a17090655d600b006d229436793sm4209049ejp.223.2022.02.28.03.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 03:09:00 -0800 (PST)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: [PATCH 5/6] treewide: remove dereference of list iterator after loop body
Date:   Mon, 28 Feb 2022 12:08:21 +0100
Message-Id: <20220228110822.491923-6-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228110822.491923-1-jakobkoschel@gmail.com>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The list iterator variable will be a bogus pointer if no break was hit.
Dereferencing it could load *any* out-of-bounds/undefined value
making it unsafe to use that in the comparision to determine if the
specific element was found.

This is fixed by using a separate list iterator variable for the loop
and only setting the original variable if a suitable element was found.
Then determing if the element was found is simply checking if the
variable is set.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c | 11 +++++++----
 drivers/scsi/wd719x.c                          | 12 ++++++++----
 fs/f2fs/segment.c                              |  9 ++++++---
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
index 57199be082fd..c56cd9e59a66 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
@@ -471,20 +471,23 @@ nvkm_pstate_new(struct nvkm_clk *clk, int idx)
 static int
 nvkm_clk_ustate_update(struct nvkm_clk *clk, int req)
 {
-	struct nvkm_pstate *pstate;
+	struct nvkm_pstate *pstate = NULL;
+	struct nvkm_pstate *tmp;
 	int i = 0;

 	if (!clk->allow_reclock)
 		return -ENOSYS;

 	if (req != -1 && req != -2) {
-		list_for_each_entry(pstate, &clk->states, head) {
-			if (pstate->pstate == req)
+		list_for_each_entry(tmp, &clk->states, head) {
+			if (tmp->pstate == req) {
+				pstate = tmp;
 				break;
+			}
 			i++;
 		}

-		if (pstate->pstate != req)
+		if (!pstate)
 			return -EINVAL;
 		req = i;
 	}
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 1a7947554581..be270ed8e00d 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -684,11 +684,15 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 	case WD719X_INT_SPIDERFAILED:
 		/* was the cmd completed a direct or SCB command? */
 		if (regs.bytes.OPC == WD719X_CMD_PROCESS_SCB) {
-			struct wd719x_scb *scb;
-			list_for_each_entry(scb, &wd->active_scbs, list)
-				if (SCB_out == scb->phys)
+			struct wd719x_scb *scb = NULL;
+			struct wd719x_scb *tmp;
+
+			list_for_each_entry(tmp, &wd->active_scbs, list)
+				if (SCB_out == tmp->phys) {
+					scb = tmp;
 					break;
-			if (SCB_out == scb->phys)
+				}
+			if (scb)
 				wd719x_interrupt_SCB(wd, regs, scb);
 			else
 				dev_err(&wd->pdev->dev, "card returned invalid SCB pointer\n");
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1dabc8244083..a3684385e04a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -356,16 +356,19 @@ void f2fs_drop_inmem_page(struct inode *inode, struct page *page)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct list_head *head = &fi->inmem_pages;
 	struct inmem_pages *cur = NULL;
+	struct inmem_pages *tmp;

 	f2fs_bug_on(sbi, !page_private_atomic(page));

 	mutex_lock(&fi->inmem_lock);
-	list_for_each_entry(cur, head, list) {
-		if (cur->page == page)
+	list_for_each_entry(tmp, head, list) {
+		if (tmp->page == page) {
+			cur = tmp;
 			break;
+		}
 	}

-	f2fs_bug_on(sbi, list_empty(head) || cur->page != page);
+	f2fs_bug_on(sbi, !cur);
 	list_del(&cur->list);
 	mutex_unlock(&fi->inmem_lock);

--
2.25.1

