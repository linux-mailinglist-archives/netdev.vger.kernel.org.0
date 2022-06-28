Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B655EE6F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiF1Tx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbiF1Tu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CC82B268;
        Tue, 28 Jun 2022 12:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445791; x=1687981791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=42auUlJ9mEBV1h64OGRghrHR1EB9VY/2pp7kr00mF34=;
  b=jWtnNgFIhMALkWQWS2TQ6Li6D5A08upb/zA6uNPPzE0LdO+8Onpyxngu
   +voDegBTk9VTZ+yM+zl12icuHzvQDtXMW3wplNRvPhIhRsv70VYOkueiJ
   uhwKmxq+JxLThLSs3mObz5LMFTkz/L14NiyKLSv/Vp/jsqTpaQ1PrXcyb
   VmcaGY+SEYRLXSHG9kyT2xV8JiQpe1Ny+h4EdqH8pkYj+WhBAtLzEvTPK
   LBt9e2jfn5gbb3PgZapmYqmRNxo/KqXddfGvTSOWWyGhr/YMhioUtlkox
   N8Vic0QkeNWwRFJrIW5NxeKmXTvrODlHFauaCmfOB82ms5E1rUWJr5ZRT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280595981"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280595981"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="587988569"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2022 12:49:46 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9c022013;
        Tue, 28 Jun 2022 20:49:44 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 38/52] net, xdp: remove unused xdp_attachment_info::flags
Date:   Tue, 28 Jun 2022 21:47:58 +0200
Message-Id: <20220628194812.1453059-39-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since %XDP_QUERY_PROG was removed, the ::flags field is not used
anymore. It's being written by xdp_attachment_setup(), but never
read.
Remove it.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/xdp.h | 1 -
 net/bpf/core.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 1663d0b3a05a..d1fd809655be 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -382,7 +382,6 @@ struct xdp_attachment_info {
 	struct bpf_prog *prog;
 	u64 btf_id;
 	u32 meta_thresh;
-	u32 flags;
 };
 
 struct netdev_bpf;
diff --git a/net/bpf/core.c b/net/bpf/core.c
index d2d01b8e6441..65f25019493d 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -554,7 +554,6 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 	info->prog = bpf->prog;
 	info->btf_id = bpf->btf_id;
 	info->meta_thresh = bpf->meta_thresh;
-	info->flags = bpf->flags;
 }
 EXPORT_SYMBOL_GPL(xdp_attachment_setup);
 
-- 
2.36.1

