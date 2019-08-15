Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0618E847
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfHOJan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:30:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35936 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOJan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:30:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so1084732pgm.3;
        Thu, 15 Aug 2019 02:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kTFAWc0JUjDeUpp8J4EUaekX3B2TcxfY7XD+ywmcWkk=;
        b=tIsHIqGb3txOI62A4T58F5T4DzLbwcCOkN7pLJ6KDesq7t+eFMVqsyrGe8kj9hUeJq
         HnJ4uA0bo28Kaprvbah9qNTIgS+QUAkixSU+EHrgJEufzl4cGz3veAO1WxNcRTJ0WKZk
         j9RDYN4pcVRJd6nX/xCOCakAKUuI7KmbZlhjvsyr1EQH+sng99Sb2y807C3FZdHi2Bnl
         PzZ4NUrHz1f1Fem4y9WVB5FdhQ0V9oy3FrfhLi6fd4LiO5SnDurd6oYux1rkUJ/nv9Ja
         Ek1XBWR6QD3mgwbOjhMMvlQO4Q++021ZrVcacGZL88nNJR7SQ4hnyr3CTN/8cDgNs4xt
         NzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kTFAWc0JUjDeUpp8J4EUaekX3B2TcxfY7XD+ywmcWkk=;
        b=n86iMjcG9YY4r/73xIMwaE1KkcgpOU9SHf7YH0qt4Gt68XjsQNzPhRgm5UI5THHzQ5
         MuVIwAKynMlDvVJKErixk2giIf71zvPb27aS9pHh9ixhkZZnZvkVmO9kxUb7+105yEUv
         cU8d7iSx4J3Eu9mG5vpyzmoUZ68FH/JNbBSiS3S7/LnfWzgHOJ5Vm0ydDulye9RHreaz
         O01wHOFoqCiq2r+meKq7qb/2RLlosLDJP0tNObJNwEFoa61jL1AnY39q/uyneUquMRAQ
         0YdwQS6A+TOBcXmCIV+lI2g339qPdXka4Zof8TjHqEvDmS9qq3lfn5D0/JoZmiBaeVRG
         gsMA==
X-Gm-Message-State: APjAAAWD8rp8HlqadnQH1DAKC47PJxLcwAu/tq3UltEbBHKLhyAnjXaC
        aO+2xeG8Aj8efsIbvVDTNqM=
X-Google-Smtp-Source: APXvYqzqBv4UD226eFVKvzZp2ptRKRZa6rCOwd3F7GD5IJlDvwwYRJoM14EqX2sYVTCIA0td4GAPGw==
X-Received: by 2002:aa7:9abc:: with SMTP id x28mr4533744pfi.234.1565861442749;
        Thu, 15 Aug 2019 02:30:42 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g10sm2204195pfb.95.2019.08.15.02.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 02:30:42 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        bruce.richardson@intel.com, songliubraving@fb.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 2/2] xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP
Date:   Thu, 15 Aug 2019 11:30:14 +0200
Message-Id: <20190815093014.31174-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190815093014.31174-1-bjorn.topel@gmail.com>
References: <20190815093014.31174-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flags when updating
an entry. This patch addresses that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/xskmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 16031d489173..4cc28e226398 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -226,8 +226,6 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EINVAL;
 	if (unlikely(i >= m->map.max_entries))
 		return -E2BIG;
-	if (unlikely(map_flags == BPF_NOEXIST))
-		return -EEXIST;
 
 	sock = sockfd_lookup(fd, &err);
 	if (!sock)
@@ -257,6 +255,12 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 	if (old_xs == xs) {
 		err = 0;
 		goto out;
+	} else if (old_xs && map_flags == BPF_NOEXIST) {
+		err = -EEXIST;
+		goto out;
+	} else if (!old_xs && map_flags == BPF_EXIST) {
+		err = -ENOENT;
+		goto out;
 	}
 	xsk_map_sock_add(xs, node);
 	WRITE_ONCE(*map_entry, xs);
-- 
2.20.1

