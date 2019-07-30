Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533E97AF21
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbfG3RKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:10:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:33179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfG3RKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 13:10:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 10:10:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="183192748"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2019 10:10:10 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v4 11/11] doc/af_xdp: include unaligned chunk case
Date:   Tue, 30 Jul 2019 08:54:00 +0000
Message-Id: <20190730085400.10376-12-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730085400.10376-1-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The addition of unaligned chunks mode, the documentation needs to be
updated to indicate that the incoming addr to the fill ring will only be
masked if the user application is run in the aligned chunk mode. This patch
also adds a line to explicitly indicate that the incoming addr will not be
masked if running the user application in the unaligned chunk mode.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 Documentation/networking/af_xdp.rst | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index eeedc2e826aa..83f7ae5fc045 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -153,10 +153,12 @@ an example, if the UMEM is 64k and each chunk is 4k, then the UMEM has
 
 Frames passed to the kernel are used for the ingress path (RX rings).
 
-The user application produces UMEM addrs to this ring. Note that the
-kernel will mask the incoming addr. E.g. for a chunk size of 2k, the
-log2(2048) LSB of the addr will be masked off, meaning that 2048, 2050
-and 3000 refers to the same chunk.
+The user application produces UMEM addrs to this ring. Note that, if
+running the application with aligned chunk mode, the kernel will mask
+the incoming addr.  E.g. for a chunk size of 2k, the log2(2048) LSB of
+the addr will be masked off, meaning that 2048, 2050 and 3000 refers
+to the same chunk. If the user application is run in the unaligned
+chunks mode, then the incoming addr will be left untouched.
 
 
 UMEM Completion Ring
-- 
2.17.1

