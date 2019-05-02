Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B0011597
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEBIj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:39:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:64537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfEBIj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:39:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:39:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="296322421"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.43])
  by orsmga004.jf.intel.com with ESMTP; 02 May 2019 01:39:52 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com
Subject: [RFC bpf-next 4/7] netdevice: introduce busy-poll setsockopt for AF_XDP
Date:   Thu,  2 May 2019 10:39:20 +0200
Message-Id: <1556786363-28743-5-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new setsockopt that enables busy-poll for XDP
sockets. It is called XDP_BUSY_POLL_BATCH_SIZE and takes batch size as
an argument. A value between 1 and NAPI_WEIGHT (64) will turn it on, 0
will turn it off and any other value will return an error. There is
also a corresponding getsockopt implementation.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/uapi/linux/if_xdp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index caed8b1..be28a78 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
 #define XDP_UMEM_FILL_RING		5
 #define XDP_UMEM_COMPLETION_RING	6
 #define XDP_STATISTICS			7
+#define XDP_BUSY_POLL_BATCH_SIZE	8
 
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
-- 
2.7.4

