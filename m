Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FE513B18
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfEDQHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:07:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34107 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:07:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so4258195pgt.1;
        Sat, 04 May 2019 09:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lS00FWHyTFR/FJuO91xXRMo5CVp7ykNCRIiy16tO7jc=;
        b=JsFg9epaupPV7iKZ39JCayZMQ9nw2lrjF6cMtCBDJT+7R5wYmlRnI/vk9fAdT4sV4Y
         VeV3w4Dk0ldqkIUcHmD/SwLQSqpuP0YidI/H0io78GxiawwbrK2/2gyWt73vuHu4gJhX
         3JAlO/DpXSvzDpaWr+icOGvHvvJ3gJILeqpF9bHctQQC/13mNsnwEYnj+nUMAsBMI/9r
         8zaOXaqzYS3FcvqYMrd39S6ZgsyXQSk96cnIjfsZka++5O++8t2G26EMAlpANacUiuYR
         jcDSPcE3eji9uWHqIbkk2DKif5mhE04ehIvjwpWQWO8NoT1QNdwbUf8FKCIsDDIf92Nf
         VRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lS00FWHyTFR/FJuO91xXRMo5CVp7ykNCRIiy16tO7jc=;
        b=kyo3JL6nwjkqL0Ld913VwLZ8/L2nPj4oYxytR3WwVyVtHGUcnBq2/q87CZigIAdrDH
         5TJF+yHgW4mwfSEOYYtla9jlS8LtGGVrjIxPugrMxAkJy3dEJ08WysMaOg0rvEu3sWb/
         CpEdnFtx5xxFy8oj4u5XrGGArpZ3Ao8zWNg+qVHQe6z2jTXOwo3by5epHC6j9seDYa/J
         lott4GZyG6CguEohtLenWKwy5WHxD1NnESOo/+AH4pm7D3jFgwy3y2n4LKenmqM9Yo8/
         T/46R31V41fRXAMjKjzIybkHpFoQWBUC/PY17UVJhHx5I62G2rdDSbpzs7Uu87wpacv9
         89ng==
X-Gm-Message-State: APjAAAWe2KFwCSm7GJ2iqVVpVp+2st7xGqL+bYs3ieulHXMJp46h0x3t
        iH6lwQP9mEk5FcWi+2Isq+8=
X-Google-Smtp-Source: APXvYqwAmuH2qndIpc0pucEuioTwFb2HFdinvmSJMBpUQ/JQOH2PbH+xAao75xHrT5dDuKQK6PyyxA==
X-Received: by 2002:aa7:8c84:: with SMTP id p4mr20310671pfd.164.1556986022616;
        Sat, 04 May 2019 09:07:02 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id n67sm8032593pfn.22.2019.05.04.09.06.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:07:02 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bruce.richarson@intel.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/2] xsk: honor BPF_EXIST and BPF_NOEXIST flags in XSKMAP
Date:   Sat,  4 May 2019 18:06:03 +0200
Message-Id: <20190504160603.10173-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504160603.10173-1-bjorn.topel@gmail.com>
References: <20190504160603.10173-1-bjorn.topel@gmail.com>
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
 kernel/bpf/xskmap.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index ad15e8e92a87..4214ea7b8cfc 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -236,8 +236,6 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EINVAL;
 	if (unlikely(i >= m->map.max_entries))
 		return -E2BIG;
-	if (unlikely(map_flags == BPF_NOEXIST))
-		return -EEXIST;
 
 	sock = sockfd_lookup(fd, &err);
 	if (!sock)
@@ -263,15 +261,28 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 
 	spin_lock_bh(&m->lock);
 	entry = &m->xsk_map[i];
+	old_xs = *entry;
+	if (old_xs && map_flags == BPF_NOEXIST) {
+		err = -EEXIST;
+		goto out;
+	} else if (!old_xs && map_flags == BPF_EXIST) {
+		err = -ENOENT;
+		goto out;
+	}
 	xsk_map_node_init(node, m, entry);
 	xsk_map_add_node(xs, node);
-	old_xs = xchg(entry, xs);
 	if (old_xs)
 		xsk_map_del_node(old_xs, entry);
 	spin_unlock_bh(&m->lock);
 
 	sockfd_put(sock);
 	return 0;
+
+out:
+	spin_unlock_bh(&m->lock);
+	sockfd_put(sock);
+	xsk_map_node_free(node);
+	return err;
 }
 
 static int xsk_map_delete_elem(struct bpf_map *map, void *key)
-- 
2.20.1

