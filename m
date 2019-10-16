Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02778D8F21
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392682AbfJPLQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:16:50 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:48634 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389063AbfJPLQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:16:49 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKhIC-0005C7-Va; Wed, 16 Oct 2019 12:16:37 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKhIC-0005Eo-Fc; Wed, 16 Oct 2019 12:16:36 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: bpf: type fixes for __be16/__be32
Date:   Wed, 16 Oct 2019 12:16:35 +0100
Message-Id: <20191016111635.20089-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf_skb_load_helper_8_no_cache and
bpf_skb_load_helper_16_no_cache they
read a u16/u32 where actually these
are __be16 and __be32.

Fix the following by making the types
match:

net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:215:32: warning: cast to restricted __be16
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32
net/core/filter.c:242:32: warning: cast to restricted __be32

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f7338fee41f8..eefb1545b4c6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -205,7 +205,7 @@ BPF_CALL_2(bpf_skb_load_helper_8_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_16, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u16 tmp, *ptr;
+	__be16 tmp, *ptr;
 	const int len = sizeof(tmp);
 
 	if (offset >= 0) {
@@ -232,7 +232,7 @@ BPF_CALL_2(bpf_skb_load_helper_16_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_32, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u32 tmp, *ptr;
+	__be32 tmp, *ptr;
 	const int len = sizeof(tmp);
 
 	if (likely(offset >= 0)) {
-- 
2.23.0

