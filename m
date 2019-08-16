Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE69490002
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 12:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfHPK0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 06:26:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:12004 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfHPK0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 06:26:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 03:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,391,1559545200"; 
   d="scan'208";a="328646255"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.52.109])
  by orsmga004.jf.intel.com with ESMTP; 16 Aug 2019 03:26:21 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, yhs@fb.com
Subject: [PATCH bpf-next] libbpf: remove zc variable as it is not used
Date:   Fri, 16 Aug 2019 12:26:11 +0200
Message-Id: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The zc is not used in the xsk part of libbpf, so let us remove it. Not
good to have dead code lying around.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/xsk.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 680e630..9687da9 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -65,7 +65,6 @@ struct xsk_socket {
 	int xsks_map_fd;
 	__u32 queue_id;
 	char ifname[IFNAMSIZ];
-	bool zc;
 };
 
 struct xsk_nl_info {
@@ -608,8 +607,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		goto out_mmap_tx;
 	}
 
-	xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
-
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = xsk_setup_xdp_prog(xsk);
 		if (err)
-- 
2.7.4

