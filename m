Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB75B5EB5BE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiIZX1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiIZX1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:27:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E526EF2B
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664234865; x=1695770865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pFuL3oGB1skylBc+oR2zLed0XO1DUoAGU+z8uS8xsQU=;
  b=gWoRUDB5flTUFTRBgO8MGGy3udfKC+Nz7jfMntsphdureHFyQgVka/8b
   qj/0k2wd7fuvzwx71++Pd+ySlzcpK6tMpdr6JQ0vhG5R1229m7dH1JLBs
   /6Ox+HFPdmH91SiIMAytDpkvBOxyoV4ZEcPXqbpiBunvWq4Kj+d229OIN
   qqfDkzY1fJdo3x8bf+Zg97+Q0N162w0Y0l80fPfzFq+pQR1TaKe7sXGJC
   Cuiu3FcC0dnOdW40k+QZ/uSd0hbP8yOM664BSQbif/BzN2ejqpQ6FndNc
   9Au4uLzA2RRe9MHhdY2Ii4CJlPeeQjmZ+uQZTjLS1yg2VPliqqMQtOGiR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280890870"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="280890870"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="572424286"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="572424286"
Received: from sankarka-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.3.132])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 16:27:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmytro@shytyi.net,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/4] tcp: export tcp_sendmsg_fastopen
Date:   Mon, 26 Sep 2022 16:27:37 -0700
Message-Id: <20220926232739.76317-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
References: <20220926232739.76317-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Hesmans <benjamin.hesmans@tessares.net>

It will be used to support TCP FastOpen with MPTCP in the following
commit.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
Signed-off-by: Benjamin Hesmans <benjamin.hesmans@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h | 2 ++
 net/ipv4/tcp.c    | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 27e8d378c70a..4f71cc15ff8e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -327,6 +327,8 @@ void tcp_remove_empty_skb(struct sock *sk);
 int tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
+int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
+			 size_t size, struct ubuf_info *uarg);
 int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5702ca9b952d..5237a3f08c94 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1162,9 +1162,8 @@ void tcp_free_fastopen_req(struct tcp_sock *tp)
 	}
 }
 
-static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
-				int *copied, size_t size,
-				struct ubuf_info *uarg)
+int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
+			 size_t size, struct ubuf_info *uarg)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-- 
2.37.3

