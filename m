Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1E44D8600
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbiCNNep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiCNNem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:34:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B374E24F26;
        Mon, 14 Mar 2022 06:33:31 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d19so7111286pfv.7;
        Mon, 14 Mar 2022 06:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WSiApMWrkRbeANEINoUs0lo7fVMDH1hs0RZuED9t7jo=;
        b=omyRoTKEBBDhJXJlPbqCbziUcgI/EmLVFlc65b6x2vz8ws9JefNclwJ3QdoyfjJsss
         m5TOA2ALlrALK/F6UlI9JO4qW21nw63yJGQY8pNOc66Jdehb7vswagqOPFLO7oOMrpYe
         uLlddok/auroZGrtbBFIEg6seFk6KTM0eH6vO+BxLZIYb5NoCWfP0CSxWeDeqICJWJW+
         4KJWMt0XXkL5Xh5qytLJJxp/hWxtAj9yzlplCsFDwUhoid0zdGbCUDdZEpxkEATXczRK
         HqHwkrqO+lGV1xwTjTP9Ly+Ka5DO0HsKbkZF9051UZDInVSMUVwMrCxh7+bbvfJSkta3
         UZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WSiApMWrkRbeANEINoUs0lo7fVMDH1hs0RZuED9t7jo=;
        b=zZCcSyB7jl9gS9OocTx5AWX2i+piDbR+PMDZNP0jmYt2NTiGbsutDPVVJallir2EJ9
         wlh9/n8WWuXtaD7hyCTK21VUyUgJS4a5nnky/ZgZd8uTVBVu/zgLmvTqLEBtYE4QFrx7
         Y2FJMPmp8povYSYW0YNfJbSNNXCeKl8Ih1sO5FpVVcZiv6kq3JAqpnDB1aycwqEagauu
         KpUUXsDTh7IbAPD/uKAL5ecrd8CTVHIWjMj0xRVHv0Re328gsakSxPBBj+BVNlSSBTSx
         s78s0CfbAydzH94k69NbZFqQqFEIW7UiuNuuoYnuLbE2etbNlTk7vIv586USRq9BsVmV
         xEgg==
X-Gm-Message-State: AOAM530rFCWCMNmMJFtzxB3ckUDF4hdK8kKstVg6d5/DAlw0IIs//Tfy
        Lrm2Y+MROaSz0rtPNZMCGJs=
X-Google-Smtp-Source: ABdhPJw0N5PFUhNg1pfu5DCSdFY92/y4+qT7fcOhQlkfD2PrQGfwC9R5EGQ9GA6E22LhBRNlTZEOSg==
X-Received: by 2002:a05:6a00:1350:b0:4f7:8c4f:cfca with SMTP id k16-20020a056a00135000b004f78c4fcfcamr16726905pfu.45.1647264811277;
        Mon, 14 Mar 2022 06:33:31 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm22118722pfu.202.2022.03.14.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 06:33:30 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: [PATCH net-next 2/3] net: ipgre: make erspan_rcv() return PACKET_NEXT
Date:   Mon, 14 Mar 2022 21:33:11 +0800
Message-Id: <20220314133312.336653-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314133312.336653-1-imagedong@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

PACKET_NEXT is returned in ipgre_rcv() when no tunnel device found. To
report skb drop reasons, we make erspan_rcv() the same way. Therefore,
we can know that skb is dropped out of tunnel device's absence when
PACKET_NEXT is returned.

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Biao Jiang <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/ip_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 99db2e41ed10..b1579d8374fd 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -341,7 +341,7 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 		ip_tunnel_rcv(tunnel, skb, tpi, tun_dst, log_ecn_error);
 		return PACKET_RCVD;
 	}
-	return PACKET_REJECT;
+	return PACKET_NEXT;
 
 drop:
 	kfree_skb(skb);
-- 
2.35.1

