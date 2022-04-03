Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6854C4F0890
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 11:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356153AbiDCJVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 05:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiDCJVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 05:21:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030CF2C678;
        Sun,  3 Apr 2022 02:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648977597; x=1680513597;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UDCT08fSuAljQ3KsmV7M1mW+faCqhwtEgpoRXMbZEmE=;
  b=n84i/7irvDou4gyAPeEgJk4rAx/1dM9XsW4b3tDiEuR1wFUkBgBgoHgO
   GNvxtdx0kbQBgHpt1so7rPQdmAac4xXgfnfCEoVVCpEEy9gZUi/T0qFS7
   8BASXmWxKYf1g+U0Xln9y8R4VKXBmc3w0czH3Ad9uWfodi0frH9y0tstF
   9nyLSulTAbLmXq8/DG9WjQUMWPiQ3BL7RU150OeLc/h2LdhJnaNqNJyuj
   9efOCeV97z9XMXKndO/DTBfePvT36aDe0CKH5LSktEs58wXfs1dkvvMZb
   fv9pWs+B6Nc3+Qy7glF6yp7H9tzyhXSF2l4zjHevIFkH65fz4+fpdU/tQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10305"; a="259200727"
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="259200727"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 02:19:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="568846449"
Received: from npg-dpdk-haiyue-2.sh.intel.com ([10.67.111.4])
  by orsmga008.jf.intel.com with ESMTP; 03 Apr 2022 02:19:52 -0700
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     bpf@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] bpf: correct the comment for BTF kind bitfield
Date:   Sun,  3 Apr 2022 16:44:33 +0800
Message-Id: <20220403084433.200701-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 8fd886911a6a ("bpf: Add BTF_KIND_FLOAT to uapi") has extended
the BTF kind bitfield from 4 to 5 bits, correct the comment.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 include/uapi/linux/btf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index b0d8fea1951d..a9162a6c0284 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -33,8 +33,8 @@ struct btf_type {
 	/* "info" bits arrangement
 	 * bits  0-15: vlen (e.g. # of struct's members)
 	 * bits 16-23: unused
-	 * bits 24-27: kind (e.g. int, ptr, array...etc)
-	 * bits 28-30: unused
+	 * bits 24-28: kind (e.g. int, ptr, array...etc)
+	 * bits 29-30: unused
 	 * bit     31: kind_flag, currently used by
 	 *             struct, union and fwd
 	 */
-- 
2.35.1

