Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865AC1478E
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 11:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfEFJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 05:24:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41679 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfEFJYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 05:24:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id l132so1488088pfc.8;
        Mon, 06 May 2019 02:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bbVsvot2x4RM6lhwKlWScnYY9MVylr01/MGlbMndDbM=;
        b=QDwVpKS14jMj9CmIWwK7wRD8VOiTC+OERdyw3t6E01VLXwdr2A9kQpknziVTj3nt9N
         8+HKvYBdIuXIeIn6YbaH34DSPWsKhGDQ1egEV2ezL0RFgQrs7qoIVqRn6sH1/y42N5P7
         y6VV/LcEtDH/W/jq1nqmocXbbi7J44kCzGpcSG0e8XWqVudyJO3lifsicnlFzsBCR45F
         WB3PnpV/bSwa0s9NyFBjCw31eeHRvQpYwTefUsHc7SF1k1KPdR1Ve/JpM8MV/i9PIwtZ
         dq9Hj/KOwNM7ZqSZsPWwNUz8Ro0wdYgnXjcsoMTtnZu0U8o5f+v2gYAjrO3pHBUzSjpu
         NR5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bbVsvot2x4RM6lhwKlWScnYY9MVylr01/MGlbMndDbM=;
        b=R9MYjOAlA0sxXtacSfwAY2WydLDFy1uzFvlK6j+RsVFfa0lAe25HoqbNHE4mx7hyKi
         7nZIXJ1c7BYunaNlQkwcy6A6LsVSNsdaPl52sOGJGOVQCRUy8jhoZAZfNWMlwfvrqCaP
         lw4Xn970Lfa0HolGLVLzOoyluMN6kNs0asxVagM7++OPc0PNIw4y0cZGPhqwinmz3g32
         P/RcO7TbIlTAB7UR1HQ+ZpXykkMQs0tEnXOGvig2ZdeDPJgWCAXH728vuhCWgikS8nx6
         vJIS5gFkKjWI4UrKy+2bgita/yFGQAzPsbz/jI55FZmkyYokP+6jKqdIYIdbJ2t0+GjX
         8law==
X-Gm-Message-State: APjAAAWyFyl/6mhBLEcnRunPb0plZupxEht92Z6n9edxOHJrrpnNKe7Z
        Em0VTVKFTO2J0m/te8bLqSelEhcgfX0k6A==
X-Google-Smtp-Source: APXvYqzLeagxOVSnShh8OqqADl5djpMTNKs+aUXum6lav94yFRRNEbjmENTAVUhFMx/qMfXBy6XPUA==
X-Received: by 2002:a62:520b:: with SMTP id g11mr30922263pfb.215.1557134693334;
        Mon, 06 May 2019 02:24:53 -0700 (PDT)
Received: from btopel-mobl.isw.intel.com ([192.55.54.45])
        by smtp.gmail.com with ESMTPSA id k10sm10353225pgo.82.2019.05.06.02.24.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 02:24:52 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org
Subject: [PATCH bpf] libbpf: remove unnecessary cast-to-void
Date:   Mon,  6 May 2019 11:24:43 +0200
Message-Id: <20190506092443.24483-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The patches with fixes tags added a cast-to-void in the places when
the return value of a function was ignored.

This is not common practice in the kernel, and is therefore removed in
this patch.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 5750902a6e9b ("libbpf: proper XSKMAP cleanup")
Fixes: 0e6741f09297 ("libbpf: fix invalid munmap call")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 525f1cc163b5..a3d1a302bc9c 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -459,8 +459,8 @@ static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
 {
 	int qid = false;
 
-	(void)bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
-	(void)bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
+	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
+	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
 }
 
 static int xsk_set_bpf_maps(struct xsk_socket *xsk)
@@ -686,12 +686,10 @@ int xsk_umem__delete(struct xsk_umem *umem)
 	optlen = sizeof(off);
 	err = getsockopt(umem->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
 	if (!err) {
-		(void)munmap(umem->fill->ring - off.fr.desc,
-			     off.fr.desc +
-			     umem->config.fill_size * sizeof(__u64));
-		(void)munmap(umem->comp->ring - off.cr.desc,
-			     off.cr.desc +
-			     umem->config.comp_size * sizeof(__u64));
+		munmap(umem->fill->ring - off.fr.desc,
+		       off.fr.desc + umem->config.fill_size * sizeof(__u64));
+		munmap(umem->comp->ring - off.cr.desc,
+		       off.cr.desc + umem->config.comp_size * sizeof(__u64));
 	}
 
 	close(umem->fd);
@@ -717,14 +715,12 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
 	if (!err) {
 		if (xsk->rx) {
-			(void)munmap(xsk->rx->ring - off.rx.desc,
-				     off.rx.desc +
-				     xsk->config.rx_size * desc_sz);
+			munmap(xsk->rx->ring - off.rx.desc,
+			       off.rx.desc + xsk->config.rx_size * desc_sz);
 		}
 		if (xsk->tx) {
-			(void)munmap(xsk->tx->ring - off.tx.desc,
-				     off.tx.desc +
-				     xsk->config.tx_size * desc_sz);
+			munmap(xsk->tx->ring - off.tx.desc,
+			       off.tx.desc + xsk->config.tx_size * desc_sz);
 		}
 
 	}
-- 
2.20.1

