Return-Path: <netdev+bounces-2757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C9B703DA3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FCBC281107
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5011018C3D;
	Mon, 15 May 2023 19:23:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B08318C2B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B45C433D2;
	Mon, 15 May 2023 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684178578;
	bh=DKn8V8qUKyC2zS5fdUFCFELhcOoHQyGjcH5utef8LHY=;
	h=Date:From:To:Cc:Subject:From;
	b=A+yw4vltayGbht8KlO20c43CyrKY4QDPdDHOE5eQDbtYKb+Vbj7QQwhXZQFzvIQ8F
	 JozRAGk3+yuoVDOyrjOUbf51E6YZVkKr3/xr1IdZcy9QMc6u4XsSra9+nI2Re9yY/b
	 v6r0ojfrb3t9xQ9D2OwIp09rg1DZJOJonBqkLVuFHL8B46SBSHWo+uzkdEuoES4Kej
	 8ywaRDF1thUteDlk7CAB1qpdmAI7rPJYD0lQQk5SupLVCMDpUnIf4ozyhQP2z2px0t
	 mC6LAS5LOIv6LZYnrj3JHVF0VDXxyI/zkye0rg2s0PHtYIBW2ZsLs0Z4ipit9Cb4U9
	 Fq4iyGxK6VwhQ==
Date: Mon, 15 May 2023 13:23:46 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jiawen Wu <jiawenwu@trustnetic.com>,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: libwx: Replace zero-length array with
 flexible-array member
Message-ID: <ZGKGwtsobVZecWa4@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Zero-length arrays as fake flexible arrays are deprecated, and we are
moving towards adopting C99 flexible-array members instead.

Transform zero-length array into flexible-array member in struct
wx_q_vector.

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/286
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 32f952d93009..cbe7f184b50e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -598,7 +598,7 @@ struct wx_q_vector {
 	char name[IFNAMSIZ + 17];
 
 	/* for dynamic allocation of rings associated with this q_vector */
-	struct wx_ring ring[0] ____cacheline_internodealigned_in_smp;
+	struct wx_ring ring[] ____cacheline_internodealigned_in_smp;
 };
 
 enum wx_isb_idx {
-- 
2.34.1


