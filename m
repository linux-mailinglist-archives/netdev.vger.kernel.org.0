Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14930287987
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbgJHQA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgJHPyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA25C0613D4;
        Thu,  8 Oct 2020 08:54:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o25so4676049pgm.0;
        Thu, 08 Oct 2020 08:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kJEIuY10ai6zlbPjp0VSBvV/r2DU/7+6Msx8VOGe6WQ=;
        b=JEAaOm9Md/xQZge4rDB6D7HpTeX4CIHFlviVx0d1d6Rhx3FjCSG93aCDavRLmYKSMw
         go2XcQol81GAlyJo1mEcsBYZP2fa//xxKOieNWv36kbDXtgtHSoDbuxh+U9D0DBO8+x2
         FJ4KK1lF4kZL+a9HfJO1NjfRWKESn1ONTYY9yt1TfzWpGv24xfNlUnGurpO/hw8WOPDi
         IOBPTlYG2nG+VXgRkaQ4rk9/O0Paqm9UhB1MamWF8yGlUVJmtbS2Wp09UwYHHFyh3lYU
         UTvbea2hZ/lCQIZa0sPDS4dXkme2eEtTAOyi7nJLc1zdNrtCsMWZbXDMFtVLO/wnQrPH
         tMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kJEIuY10ai6zlbPjp0VSBvV/r2DU/7+6Msx8VOGe6WQ=;
        b=ohbPLA2Ji7dVOhhdLFl8EmH8cQBYGoFk6VER/64wRVIfvdvkmrKB+BnQwD7d46OLhN
         8WAI/DksmM6e3cUPYkKGxvajzgc+kPyyCZskH3gigucH2zW7zKThzTZUBB+Hsz2SQZH5
         5ys79s9sdYMPs9PcYWozCVFSOxJiUTJGE3gdymCKnhVKRoSbC08VFwTjhuGiT25dJgsn
         Wa6Siis0sUx7nehkUOfcu24i7P/FxihU7DlqXqZ2tPyhPjh+0O7CmYsdh+j8zDd5ME96
         YLdS5ol8BdatzQGXw2h7mEcAALEDzQ7bu0nDljpLuitJ7+OOTc4+f3MgaIO+Pzc9Yf9s
         VQQw==
X-Gm-Message-State: AOAM530acHOzLb8T+AGax98nfGgE2R3Xe0XQqpm7YaFKnCa0722zErCk
        X0XnVSMglGRMzWtCKXijj3U=
X-Google-Smtp-Source: ABdhPJz4mgHqd9MgOMKVCXidvPBkl5jKCepJKOydTGr2HH+h3BQ5ALZkOToXvJ1/kWK+I67U75YcVw==
X-Received: by 2002:a17:90b:118a:: with SMTP id gk10mr8415823pjb.218.1602172459423;
        Thu, 08 Oct 2020 08:54:19 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 038/117] wl1251: set tx_queue_status_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:50 +0000
Message-Id: <20201008155209.18025-38-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: b7339b1de0f7 ("wl1251: add tx queue status to debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wl1251/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index 165e346bf383..0a26cee0f287 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -237,6 +237,7 @@ static const struct file_operations tx_queue_status_ops = {
 	.read = tx_queue_status_read,
 	.open = simple_open,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void wl1251_debugfs_delete_files(struct wl1251 *wl)
-- 
2.17.1

