Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E033FEF7F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbhIBOgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 10:36:13 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:49000
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345374AbhIBOgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 10:36:10 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 518E83F236;
        Thu,  2 Sep 2021 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630593306;
        bh=wlpGJ5ee6ruIXLtuYwTKVEbhYUO1CosIgO6wM8+sYmU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Ei39uQKaDZdgRSSzOoNXJILvCfifuQUemJgpNFucD3WUZPAkSzSpVaHMGYNWQyrHE
         CW0k9/r/+kpHCL03Y+BBfUP7wqM7yePnhWlcGEkGWUkAWk8mtOdo1HDyZqYrnzovpn
         FatBMs+wXzc7uzjCMbdtggG78OFVIHcRQPMpN5Z7zxglsjFJJPpdNsjsS7uQ4/PsES
         TxdiyY/Y/c6GZPNwGnG66VjzBQ/WV9vflv/HQo3/kp1ZKufdoVGOb5fXVW8vlJcxAz
         TOB2jHDbx1UNEUrqoFsArCd5j/maa3XBTOHGL/EH0ip6Elmk6S7M7n/zksyuzBTi7v
         6ZbUDY5wHi6+g==
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] seg6_iptunnel: Remove redundant initialization of variable err
Date:   Thu,  2 Sep 2021 15:35:05 +0100
Message-Id: <20210902143506.41956-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read, it
is being updated later on. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv6/seg6_iptunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 1bf5f5ae75ac..3adc5d9211ad 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -385,7 +385,7 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
 	struct seg6_lwt *slwt;
-	int err = -EINVAL;
+	int err;
 
 	err = seg6_do_srh(skb);
 	if (unlikely(err))
-- 
2.32.0

