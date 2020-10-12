Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E996828BECF
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404024AbgJLRKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403948AbgJLRKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 13:10:39 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F92C0613D0;
        Mon, 12 Oct 2020 10:10:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x7so11425791wrl.3;
        Mon, 12 Oct 2020 10:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JQhCSXsyusOxGtjUFqayOObcSsTDfbxU0tyZvY/Vj6A=;
        b=s2r4/v0DYuqvGNTQcT9zgz4BWyfxkTPOGxK93WLomSMqB2kqeMffyXD89Fq3PXTYvC
         6a3f07TVZ8Gw1A4aO8hF6jlv0SVJbrghYj/s57G0LdOI3LnabDur/q8QPDXgw63fk2ig
         uLbcCU6I2nwfbsVw8dEyqYkdF4sQxLG56f/CZauWAQZE7HPiNaGzCzrpl3FASOQdozA0
         Hj7mn7eaSq2QyW9WKVFVOHUuZMPSwieUUiJlKmn+QRJw89CsmgQOgD+GckIqtGmzCJjl
         QBFwe37n7jt4+/IaC/kNVoAwZ7pR7i4Pef1JUMosNuxogbTDFzHWjIsq/0+3GfEaCIiC
         yjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JQhCSXsyusOxGtjUFqayOObcSsTDfbxU0tyZvY/Vj6A=;
        b=Bx93oxsmS4eMBpvIZzem/NvZEl5zsFN7K8TbqUH8T+1Tc96OOWj7NeP8HZm4zKmHXA
         vH1/X/Kltsbkepm+wsfHlKZg46RAAxE3MWQbcP5TKMvf1vT2lvs16VPQw83qPrd+dW3G
         g+lC+idUK5HdkDiiKQPL8qXmTvsPKYydwFgeDFK/7l0owXUzZhbwFl4iKLemt4RtiSVT
         kBi3m0Pt5rckkUCJ+jCaO+88s9M61/M8brDvdRFL+quGtQY+MHcqMUPitJGGiTeO4SjY
         kWEiw5Ud92TaETL2+lLVIyTn4fcRmYxqJWV0b43V3XKDZ/pjP0RqipGtwNZDaOOawqtU
         xApA==
X-Gm-Message-State: AOAM531looCiXl03v7E1mlWWyb221QfBX/3YVKieJ4IW2gZWW7RBdn6N
        oMqIFJAf8dBIJT9u+s4PNzRLqUK3clvRPvwv
X-Google-Smtp-Source: ABdhPJwGyRczTJ1YaqqPoszu5AOFLeprcyPNpPbK+gSRzKVT2oSaTGHdlKyI1sHe4p1gqj2bfhHvng==
X-Received: by 2002:adf:c64e:: with SMTP id u14mr30375186wrg.373.1602522637731;
        Mon, 12 Oct 2020 10:10:37 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id l11sm27199166wrt.54.2020.10.12.10.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 10:10:37 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sockmap: Don't call bpf_prog_put() on NULL pointer
Date:   Mon, 12 Oct 2020 18:09:53 +0100
Message-Id: <20201012170952.60750-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bpf_prog_inc_not_zero() fails for skb_parser, then bpf_prog_put() is
called unconditionally on skb_verdict, even though it may be NULL. Fix
and tidy up error path.

Addresses-Coverity-ID: 1497799: Null pointer dereferences (FORWARD_NULL)
Fixes: 743df8b7749f ("bpf, sockmap: Check skb_verdict and skb_parser programs explicitly")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 net/core/sock_map.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index df09c39a4dd2..a73ccce54423 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -238,17 +238,18 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	int ret;
 
 	skb_verdict = READ_ONCE(progs->skb_verdict);
-	skb_parser = READ_ONCE(progs->skb_parser);
 	if (skb_verdict) {
 		skb_verdict = bpf_prog_inc_not_zero(skb_verdict);
 		if (IS_ERR(skb_verdict))
 			return PTR_ERR(skb_verdict);
 	}
+
+	skb_parser = READ_ONCE(progs->skb_parser);
 	if (skb_parser) {
 		skb_parser = bpf_prog_inc_not_zero(skb_parser);
 		if (IS_ERR(skb_parser)) {
-			bpf_prog_put(skb_verdict);
-			return PTR_ERR(skb_parser);
+			ret = PTR_ERR(skb_parser);
+			goto out_put_skb_verdict;
 		}
 	}
 
@@ -257,7 +258,7 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 		msg_parser = bpf_prog_inc_not_zero(msg_parser);
 		if (IS_ERR(msg_parser)) {
 			ret = PTR_ERR(msg_parser);
-			goto out;
+			goto out_put_skb_parser;
 		}
 	}
 
@@ -311,11 +312,12 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 out_progs:
 	if (msg_parser)
 		bpf_prog_put(msg_parser);
-out:
-	if (skb_verdict)
-		bpf_prog_put(skb_verdict);
+out_put_skb_parser:
 	if (skb_parser)
 		bpf_prog_put(skb_parser);
+out_put_skb_verdict:
+	if (skb_verdict)
+		bpf_prog_put(skb_verdict);
 	return ret;
 }
 
-- 
2.28.0

