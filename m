Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3AD4B6B01
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbiBOLcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:32:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiBOLcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:32:24 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC55B1EAC7;
        Tue, 15 Feb 2022 03:32:07 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id m22so15163654pfk.6;
        Tue, 15 Feb 2022 03:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O4Z8Ketg6lyMA/EQQF8dU+j1Mac7Pb0dZ9Rft1nzw4g=;
        b=PrtQyDh1qBTX3EI/Z4urEK9x28uIecGFO6ov87lhsW2sOQR8tl7jVP7vuo/3NTIQRe
         FPDBA1Pq2A7C107Vp5THopj0hOfpBK+8LPe3mplRzj81/S7UtCNWpNgJtKANuoYwnxHQ
         DAsaEs6qpQwUF+WK3SfAKPUhvDC4k+NQA4MsPYQVUiUd0vldYJqUXkepGzEWUEMNPevC
         +JHuGrWV3L95gVSigaD5kwR3It81ff/V8Fc+0GHAKTvFYd/JHC9j3Wq0auQHoXsr38Mt
         3ePum23mkNlh+5Qi1h9RouYhUBSM61z+83Nruac/LWZL2dKODAny7uN3CuMUtaiIYQ0U
         /P6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O4Z8Ketg6lyMA/EQQF8dU+j1Mac7Pb0dZ9Rft1nzw4g=;
        b=MrS6HV6MwHdqUYSFni7fPFNkKMfaKQwZysP4Oz+2AHHuL3T9E8EsVl8dfA2veC2nd3
         Eq1hecZ7gRUV9s+lq2upKIsZ9wcLsDeG1TT0BmIiCo/8v78psDA3ihUgx4ckbYt6kvFz
         5cRIR/7TOfIMLIZorcxSSrh4zA+efDwlapYBsCQxq8pIdI9JvXKGmrqVDuIOoQJ/3HbV
         QF/i+AqZv/1u91elO0BDecYND2Arb5YhifGX9liSp37BB0nr1LsAAdXB2334L9i+RZOm
         f/52s7vddJ1sNttOoFdp7kk2Lqp4Y2kDpZF/VZUgsK4dvmqO7EnOTAbWx7tr7eSG2a4M
         4N/A==
X-Gm-Message-State: AOAM531BTmcnRhLX1SrYQ+9XS8q9IxqeHbmCQfmNxTYyh+Eg24CE89q4
        W95FlgDoIV8RSm+jDDI9KqQ=
X-Google-Smtp-Source: ABdhPJwV64v2Uh201W7T6Z2LQGDLjIScOiG3UezVow2lAx6krzVZwC/mSfLTzXL7XlWo6NKeeAvxJg==
X-Received: by 2002:a63:1a4e:: with SMTP id a14mr3157207pgm.107.1644924727283;
        Tue, 15 Feb 2022 03:32:07 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:32:06 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 12/19] net: neigh: add skb drop reasons to arp_error_report()
Date:   Tue, 15 Feb 2022 19:28:05 +0800
Message-Id: <20220215112812.2093852-13-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

When neighbour become invalid or destroyed, neigh_invalidate() will be
called. neigh->ops->error_report() will be called if the neighbour's
state is NUD_FAILED, and seems here is the only use of error_report().
So we can tell that the reason of skb drops in arp_error_report() is
SKB_DROP_REASON_NEIGH_FAILED.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 4db0325f6e1a..8e4ca4738c43 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -293,7 +293,7 @@ static int arp_constructor(struct neighbour *neigh)
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb)
 {
 	dst_link_failure(skb);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_FAILED);
 }
 
 /* Create and send an arp packet. */
-- 
2.34.1

