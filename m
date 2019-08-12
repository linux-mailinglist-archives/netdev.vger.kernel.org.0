Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B63789EA9
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfHLMok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:44:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39219 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfHLMok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:44:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id x4so6021214ljj.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CzrTbiHopzrJu+YLYHoIsujt53sT7XN4YE3jA26/XGg=;
        b=CZL/I2MFhnHG7WsGfil0Lhj0/vUbG22b1Ey4JJ+4mOZyN1TTt0k7l4o5BUszI4UGSt
         1n6tFYW9r96cIcKCqEuEC/X0AeIYX4H3btbse/XxA6HbmKV6iGxNC4/567RVUaDZR3nC
         HaBGbThoAuqSmKQ7S0HRYvg4C1CynhZlxF5TTej5/B6iJps7QKNTM4USoP9kAw899Z8y
         njUfwG3frFnuvYBLJG70NZ9gAM/sazFT3OtdhJd6YwKSg4tw6mibwBU/2nf6qJlB+PYs
         nEdfm2RkSbLQDJX7Q+RXVjY0XgH2jzOz2zIp+b1IMwxFfO6/cYmvcAAZd1PeK0vVqpsO
         voQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CzrTbiHopzrJu+YLYHoIsujt53sT7XN4YE3jA26/XGg=;
        b=V5QqxFbLLUJXIQVOc/OBMUlISht1w4MsZ3PkDyRuwfv1RhKWbO1qiTdLZ5rzuDoecK
         KAAtRdMZ7FJU7HpIsSaJAS2ayh7gCSQhp4vlY+2osuO3N3aY/RJuLcQWZArQU7O6e8DV
         J5t13bX2sHoQM0fLxeLr/Oz/gs4hXee0FXkw69ShKwMPrqlJiN3o+vISfAjKvH8PxaJO
         /lFEYV7ZjyraVOLGcfRkR6qVXnrB2L/7BdEwyxN5Bx/Ri9rjM1c+n45EkKYhJ7iwW3vw
         r4nHqryYEiwTRZ0W0wDEssXQxmWhfQ3ZEYN/VNXyFgLGtpLSo0J4md7l72Wfpu4ABMxw
         UKaQ==
X-Gm-Message-State: APjAAAVZUbwGdZ8WrTxIgW8Z58h3FBM8GhfQgfSa3qUbpbYwAdyKL6VN
        kXyxYHhtjq46pvVFGwOAVrWWTA==
X-Google-Smtp-Source: APXvYqwamKoAxWVn0ZtiV6XAfXemkV1C3L3E5zzwIiIeJc4CgQilmql9PxxJQosy2E9Ep5TEcoG4/g==
X-Received: by 2002:a2e:1459:: with SMTP id 25mr18650455lju.153.1565613878719;
        Mon, 12 Aug 2019 05:44:38 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id y25sm23432747lja.45.2019.08.12.05.44.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 05:44:38 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     bjorn.topel@intel.com, linux-mm@kvack.org
Cc:     xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, ast@kernel.org,
        magnus.karlsson@intel.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory size pgoff for 32bits
Date:   Mon, 12 Aug 2019 15:43:26 +0300
Message-Id: <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
established already and are part of configuration interface.

But for 32-bit systems, while AF_XDP socket configuration, the values
are to large to pass maximum allowed file size verification.
The offsets can be tuned ofc, but instead of changing existent
interface - extend max allowed file size for sockets.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on bpf-next/master

v2..v1:
	removed not necessarily #ifdev as ULL and UL for 64 has same size

 mm/mmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7e8c3e8ae75f..578f52812361 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1358,6 +1358,9 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
 	if (S_ISBLK(inode->i_mode))
 		return MAX_LFS_FILESIZE;
 
+	if (S_ISSOCK(inode->i_mode))
+		return MAX_LFS_FILESIZE;
+
 	/* Special "we do even unsigned file positions" case */
 	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
 		return 0;
-- 
2.17.1

