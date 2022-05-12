Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018775245BC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350460AbiELG1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350396AbiELG1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:27:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A8A5C870;
        Wed, 11 May 2022 23:27:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso3989277pjb.5;
        Wed, 11 May 2022 23:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SId0BSKGJByzADGTc0Pg51EQum2GGJlUi90u8v9tdUk=;
        b=WECu1swx+WybchdEtIuAQaqI4jZ9KRW+ZyK8KnsDwP4klZxjdt9tcrf0JuZhFzC8sx
         hOwdTQo5S5H5yabn+YWtsYnFqtCyo1Ar9K9Uyrl6O+vKO3Qc/R/fASlcgZVNhEjDiKaB
         5W1N531AtdQ6+btW89Cw5D+JyleqgvzMXkmhTvn6MJl8aNeTTcweeLjrZtGadBUDpDhN
         b0RaChgaCqMloQ9afgUeRUj1fR5aHCvDM+z+u5eXa51aD/qpbHHbJj1L76ogf8vufOek
         RmNxfpXAsYHvK3qa/jE52i7NGQT0Toz1upe3a00w6H7OSx9nbD1PC8DJGlb+lYpURz4t
         X3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SId0BSKGJByzADGTc0Pg51EQum2GGJlUi90u8v9tdUk=;
        b=bT6ojLUPJ1r1+OO9zTOOCwh6ufuki4Z6uJ2wWGUcGKYT1mw6/9WoZqQh3ixTpJiMyZ
         9a1J5yKUidHnM2uYMSnj2GAe6/25PqzuzVFOcL88x+1O+Yiugi+uAAjTUN9flqpSNbr9
         5lYOMzJPTP6PIY6kY3vobW9zUUtDM0M5W6VRFB3v3KQp7nktzNCR6fqwerySZZgVusQI
         DqgZyUXg/EmREWOfEkwny1ViVfcEtqHNena5pULWy+JgL5pNP/QeQPq0JkWIlAVwo26I
         +bpw53OjbJRiAyQXmwYPrqdNoDFNPiunssqaIJl75tF12qjXIax74v7dD9OZ52h5+yNl
         rIzQ==
X-Gm-Message-State: AOAM532jpdqC58Nh+4In2L9t/14uXs7oDlmP74aYaf3uDWsOfUW6z+xU
        BwBG31kzKljA5MkZv59GG9M=
X-Google-Smtp-Source: ABdhPJyA7aM0RLXM7wBs20dQIFZCRvUi6LExaQDa7qsMHUdY+nLD3+Ep9+Df5QI+ZVPq6bmdlAaCwQ==
X-Received: by 2002:a17:902:dac5:b0:15e:8ba0:a73d with SMTP id q5-20020a170902dac500b0015e8ba0a73dmr28551468plx.22.1652336823205;
        Wed, 11 May 2022 23:27:03 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id gn21-20020a17090ac79500b001d903861194sm999748pjb.30.2022.05.11.23.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:27:02 -0700 (PDT)
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
Subject: [PATCH net-next 4/4] net: tcp: reset skb drop reason to NOT_SPCIFIED in tcp_v4_rcv()
Date:   Thu, 12 May 2022 14:26:29 +0800
Message-Id: <20220512062629.10286-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512062629.10286-1-imagedong@tencent.com>
References: <20220512062629.10286-1-imagedong@tencent.com>
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
can be SKB_NOT_DROPPED_YET(0), as it is used as the return value of
tcp_inbound_md5_hash().

And it can panic the kernel with NULL pointer in
net_dm_packet_report_size() if the reason is 0, as drop_reasons[0]
is NULL.

Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/tcp_ipv4.c | 1 +
 1 file changed, 1 insertion(+)

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
-- 
2.36.1

