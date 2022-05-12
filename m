Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B562524CF7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353848AbiELMe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353844AbiELMeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:34:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5C765D3B;
        Thu, 12 May 2022 05:34:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d22so4715541plr.9;
        Thu, 12 May 2022 05:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4qRhse/EElRlNlt5CjLk1lxqck1AwLgnmQmAk8U8knE=;
        b=C+xI6Uel5XoPC9VAdCee+cw2YQDuNTCtXZ9d5B2ntwHiDYMeajxivbXN5ptDz6lBML
         hqjXHE+42UHaiNVz8CmKXL8sp//jlMPI1mtY1e8aTtMq9FXU0c70+3xMxpEwrQYeU2yZ
         2w1pXUdnVUuu2HStV3QjU0QIMaCTX92Hs87KPCP0NWhYcZLpMOptflV1AUNEN7KkDmLc
         aMYe4fDQpj/dLuB7SHr4oxXKKntQUgiRydr4qe9Gk1KWLZOnwIL1A5yIGdTLjNO8djfN
         0hAaJtXfdcKkn8UfOfOQkEdqW2SPA9TOiLD6Fg8CnQi3WKNhXN2oUyjeywjECwOtsUXl
         uBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4qRhse/EElRlNlt5CjLk1lxqck1AwLgnmQmAk8U8knE=;
        b=NeoSguKwc7tAFX/zrsjsnONre3Zjtg1DM1RX2bNyyikmRnpusytZaH6buxdfU/9kBN
         1lY9NzUjxAP2OhUzh1rnhR1Rxkk2Wbyu3hxwAfGoc5UjQIDy9sjrb+41qsi8GP4+1aJl
         iGoFGegSoDFGU+U6qQAmw0373CFCW7gNO7dwBsjLSCBjmjkjqzuOmiQSF5jqsppNNIOO
         RZnNKNpoxdQbrIsS3fvLqVR9BpHcU9vRsyqjF1KZGqkjOrCgLnPeAqnoFwZU93jjdb44
         3g6UHFMYc6qlXYT+IAR/ALb+GYZz1s4iZc6KQzFN53HSYgiSUfw/jM1zqZHutW217lgu
         hy9g==
X-Gm-Message-State: AOAM532u5qZtutZgZ0k5mm5qtGsVTmDz8nojbv0z0SrewOhWv5ImH1x1
        Qja1d0UcyonQo1hJBQ7xgqE=
X-Google-Smtp-Source: ABdhPJy+qLF/vwUaeC0vpFzsUXpOlPWIH1u4fK9KybQ0x/Y/yyc1GHdj/+XljeZC7HGYV/vePxcfSg==
X-Received: by 2002:a17:902:b18e:b0:15f:b2c:6ca with SMTP id s14-20020a170902b18e00b0015f0b2c06camr20550250plr.84.1652358849787;
        Thu, 12 May 2022 05:34:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id y24-20020a63de58000000b003c14af50643sm1738130pgi.91.2022.05.12.05.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:34:09 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/4] net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()
Date:   Thu, 12 May 2022 20:33:13 +0800
Message-Id: <20220512123313.218063-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512123313.218063-1-imagedong@tencent.com>
References: <20220512123313.218063-1-imagedong@tencent.com>
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

The 'drop_reason' that passed to kfree_skb_reason() in tcp_v4_rcv()
and tcp_v6_rcv() can be SKB_NOT_DROPPED_YET(0), as it is used as the
return value of tcp_inbound_md5_hash().

And it can panic the kernel with NULL pointer in
net_dm_packet_report_size() if the reason is 0, as drop_reasons[0]
is NULL.

Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- consider tcp_v6_rcv()
---
 net/ipv4/tcp_ipv4.c | 1 +
 net/ipv6/tcp_ipv6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 918816ec5dd4..24eb42497a71 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2101,6 +2101,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	}
 
 discard_it:
+	SKB_DR_OR(drop_reason, NOT_SPECIFIED);
 	/* Discard frame. */
 	kfree_skb_reason(skb, drop_reason);
 	return 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 60bdec257ba7..636ed23d9af0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1509,6 +1509,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 discard:
 	if (opt_skb)
 		__kfree_skb(opt_skb);
+	SKB_DR_OR(reason, NOT_SPECIFIED);
 	kfree_skb_reason(skb, reason);
 	return 0;
 csum_err:
-- 
2.36.1

