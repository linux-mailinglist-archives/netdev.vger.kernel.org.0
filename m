Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC2E99044
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732878AbfHVKA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:00:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:1799 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732115AbfHVKA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:00:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 03:00:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="180336970"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by fmsmga007.fm.intel.com with ESMTP; 22 Aug 2019 03:00:54 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v5 11/11] doc/af_xdp: include unaligned chunk case
Date:   Thu, 22 Aug 2019 01:44:27 +0000
Message-Id: <20190822014427.49800-12-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822014427.49800-1-kevin.laatz@intel.com>
References: <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190822014427.49800-1-kevin.laatz@intel.com>
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

