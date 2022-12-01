Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5579B63FAD7
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiLAWs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiLAWsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:48:54 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7D895832
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:48:52 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id r8so3539460ljn.8
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xi/1JoZF74FcvKn/bwOZmu6e38qXh11OS7Ij6MGyCE=;
        b=xzvF7+sKYs9FnkItHR1K33sb7MGYeSiGHvp2MIhfkwWzUiQxUL5b/bjUy5+9aoMJEA
         wz1hDfsiTefJ8w9dSjfPqA8Ly6b6WlKZLngPdEICZK4vxv6QufmYjI1/b5oyB1F1B8Lz
         k+DVnujYB0SnhaYWzGuHwbPsOk30z5V3OuTa3NxcXtIhLHit10GSfErJN9KBxDV9uBkw
         pal0X7LWtAxS1tmadnlATuUpNY3xZNnWMayPp4IUoBE30vVNQ4AmsHXVjg9WRTxZLXlb
         OrCzRlJoUxrfq84YMcrJYPPK0F5Kpws1z10QTUC53UCCLikAP8WRSbOiuzQe1hihjkdD
         O+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xi/1JoZF74FcvKn/bwOZmu6e38qXh11OS7Ij6MGyCE=;
        b=gtPVb9MgZUxq5vu3Z1DhiYe/f+E189ykBeN5fkPyzSKAMOy9wyNUdHrEoibIhD3hk0
         QSgGk+RuEtBNd6Mm+pURrgEIXh46tkyH7NQP1QFAyx3kZuBioz/uvw9KLMPHygq8urqF
         u4BClsgaM0dw3MIaPuS011SWwWCluUi3Ih3XvHYlw4IyjE3t6mX2NFpTYv1zfyY0BcE5
         R7baEdTiKHg9M/mvs4zak0VLfz1Zg3STAEeb+HPk/OzKsNYSW8qpfyvk711UHcdknnZq
         gfYTPIGvmPCBaoxHFB6yQnt4/QgIAbmP5BHHunErjCM2IEFxOndwWvbJcVBkkmDXObN+
         JkYw==
X-Gm-Message-State: ANoB5pkDiwncveHxBSfkV3EBU8sujmkGFGibXAUJ6qP5zeDoJraq80AS
        PKhECIxkBbhuU0e2JbVdcXuAew==
X-Google-Smtp-Source: AA0mqf418uc95r9fB9adti4adpv8zlD9n7w9EdZVolCHTCOFvVgKW4MDAgDvwPYxrs3JEmqj8JOlqA==
X-Received: by 2002:a2e:94cb:0:b0:279:8865:38e1 with SMTP id r11-20020a2e94cb000000b00279886538e1mr12232294ljh.217.1669934931102;
        Thu, 01 Dec 2022 14:48:51 -0800 (PST)
Received: from localhost.localdomain ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id g7-20020a056512118700b00497ab34bf5asm797573lfr.20.2022.12.01.14.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:48:50 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     devel@daynix.com
Subject: [PATCH v4 2/6] uapi/linux/if_tun.h: Added new offload types for USO4/6.
Date:   Fri,  2 Dec 2022 00:33:28 +0200
Message-Id: <20221201223332.249441-2-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201223332.249441-1-andrew@daynix.com>
References: <20221201223332.249441-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added 2 additional offlloads for USO(IPv4 & IPv6).
Separate offloads are required for Windows VM guests,
g.e. Windows may set USO rx only for IPv4.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/uapi/linux/if_tun.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index b6d7b868f290..287cdc81c939 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -90,6 +90,8 @@
 #define TUN_F_TSO6	0x04	/* I can handle TSO for IPv6 packets */
 #define TUN_F_TSO_ECN	0x08	/* I can handle TSO with ECN bits. */
 #define TUN_F_UFO	0x10	/* I can handle UFO packets */
+#define TUN_F_USO4	0x20	/* I can handle USO for IPv4 packets */
+#define TUN_F_USO6	0x40	/* I can handle USO for IPv6 packets */
 
 /* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
 #define TUN_PKT_STRIP	0x0001
-- 
2.38.1

