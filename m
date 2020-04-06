Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BAB1A018B
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 01:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDFXUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 19:20:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51128 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgDFXUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 19:20:37 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jLb2d-0008Ds-8x; Mon, 06 Apr 2020 23:20:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nft_set_pipapo: remove unused pointer lt
Date:   Tue,  7 Apr 2020 00:20:31 +0100
Message-Id: <20200406232031.657615-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer lt being assigned with a value that is never read and
the pointer is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nft_set_pipapo_avx2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index d65ae0e23028..9458c6b6ea04 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1049,11 +1049,9 @@ static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long *fill,
 					struct nft_pipapo_field *f, int offset,
 					const u8 *pkt, bool first, bool last)
 {
-	unsigned long *lt = f->lt, bsize = f->bsize;
+	unsigned long bsize = f->bsize;
 	int i, ret = -1, b;
 
-	lt += offset * NFT_PIPAPO_LONGS_PER_M256;
-
 	if (first)
 		memset(map, 0xff, bsize * sizeof(*map));
 
-- 
2.25.1

