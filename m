Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1A524BB5
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353272AbiELLd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353243AbiELLdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:33:25 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC821CEED2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:21 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id bx33so6070320ljb.12
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=poaAl/LWMtSjpF9E3ArKo5BaGizAmiyDHMdbPQU58wM=;
        b=L0BFpVLJQqlT0zt4b7FVLFd+SSf6LkTvIZONJ+ldc+OUcKRc4j/x60BAYklyj/+lMc
         CKZM+K1fF2jHLZUKhOEAHrdOVXtJy/71Z6j5BZLP19lHovNzo8VyrLuDe+oRiUerrKJT
         kGkAPi9eO0/bb7UnFYrT4as3ZAfrwqKBIjzfbbLHHUWLww4uTiQ8AUqNkgzgFZZuzDZH
         AVQ13nVULJHMSZYiLGoA6KclaPqR39FmHZvxbid1YuOLOF3AsJ1CIyySOmSNGAI5lm99
         x2Bnz9i/LNHo1qMPg0HGpNqIkDdwOYwXpBHu8XCP/lagjhocE8jHM40QiYnRR842wQo3
         9oOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=poaAl/LWMtSjpF9E3ArKo5BaGizAmiyDHMdbPQU58wM=;
        b=ctbEC4elHsiWvz7UZOGvMgNTPmGffrNMBYB6hmbZHdacxJpWl50q9+Wva46tTfJR3r
         9NONZfIsnWdPKuzudA+DjP+vzLii5o8Ko35tq0nnvsZ6J8w0rFWHSRooZOEQFaJ5GSEX
         hQQ2xe/E/J00EYE5a+193B9LTAlBkUNoHu67dxDvn/5QOIBY6xSlsySVTLATnQdbmk94
         SpNNJOxCTxwy7MoeM8oLof2xsZONC9yKJSjKOdHP9UDd2u1nKRkeFf7x+B7AhYNbNgl3
         CPi/jvjypNaFIPZL2sa/dLmSbAss96ZgN1hnP+AmolnBIkmW3xCTySm5Pxkv8c7knS2z
         2ogQ==
X-Gm-Message-State: AOAM530ZICj9v44z4qBqbckM3cYUbHPY0dxlLnZXZiKa10Bm76cyOsQW
        JGYwufuv3GxbAyEpKSyApDPATA==
X-Google-Smtp-Source: ABdhPJzq5JITT2BfM4tF1muCzbgjceuolUocorvsJ4Bs//pjuR3Cjamjp8cpK5UYGylTqv1LOmTXzw==
X-Received: by 2002:a2e:b712:0:b0:24f:150e:1a71 with SMTP id j18-20020a2eb712000000b0024f150e1a71mr20147165ljo.240.1652355199481;
        Thu, 12 May 2022 04:33:19 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id r29-20020ac25a5d000000b0047255d211a6sm741758lfn.213.2022.05.12.04.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 04:33:19 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH v2 1/5] uapi/linux/if_tun.h: Added new offload types for USO4/6.
Date:   Thu, 12 May 2022 14:23:43 +0300
Message-Id: <20220512112347.18717-2-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512112347.18717-1-andrew@daynix.com>
References: <20220512112347.18717-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 454ae31b93c7..e147dcb46d5c 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -88,6 +88,8 @@
 #define TUN_F_TSO6	0x04	/* I can handle TSO for IPv6 packets */
 #define TUN_F_TSO_ECN	0x08	/* I can handle TSO with ECN bits. */
 #define TUN_F_UFO	0x10	/* I can handle UFO packets */
+#define TUN_F_USO4	0x20	/* I can handle USO for IPv4 packets */
+#define TUN_F_USO6	0x40	/* I can handle USO for IPv6 packets */
 
 /* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
 #define TUN_PKT_STRIP	0x0001
-- 
2.35.1

