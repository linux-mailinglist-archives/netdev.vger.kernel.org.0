Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DBA645953
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiLGLvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiLGLvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:51:39 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7735132D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:51:33 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id f7so24543019edc.6
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 03:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xi/1JoZF74FcvKn/bwOZmu6e38qXh11OS7Ij6MGyCE=;
        b=vvi8mLQ8FWGj1DPzR9o/wPIx9cj4psWvbIjzttwi0YJs8sN1dzhKa9aU6H5Pg7qTHy
         bsGtCZWl5YpQj/2x1qsouY2KCqhqRrWmTdYt6WqOtdGLDd19BWhQsBJosPC5Kjh+WztE
         igsPew/lrUSoQt5Ucf+U/+CDRsycLjxVoXrhQTuliGZVp3MWREKbZkFjzw4Dwu3GTdIi
         exYK+RzQ2FlMjAf6eqQaoXrJBg+zQUUrqQVDGSKI+qPsxXhQhOkS1taS2nmKW/ynkz4l
         SjwmFv0KSwkzUwTSl/iYWckExZiNhtRPu9zfD471HNPjdM9F8zb1GnVFejWc87H6ZFkl
         uRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xi/1JoZF74FcvKn/bwOZmu6e38qXh11OS7Ij6MGyCE=;
        b=52VLoN0pMJdcPxoz1ibRpY2EYtvoyOh4C9yxU/ADZgS9ZIKsFLmI1AsEvZ+fWGICHk
         cWwZzoqXo11Eq9EGby1lQd0xlmBKzYas2QgnoVLo6YlCGemZ6ZKcO4VD1oXy0avPcEMB
         BGoeeuW9nOEVsZd4xmSZf1rGv+LY2QXPfVHtBibqvb2TKHaDzdL75rzMEHolbJgOQLQD
         Ujx2AjX1/MqVFJGcU/2MUWsA+BDU/Dd8nSbXkHeFEbjQM29L0h1pdcWDV+/VgJkp0x6j
         3bQlV/6covxvWpycDUEQHNIZvDu2HnxFAIXR0Q/HcIlwXQmYL2fj6o3fi5nzcgEDJPNe
         fk2A==
X-Gm-Message-State: ANoB5pl0nrCuIGRnziaBoos7pIkVdXc1G+UcFPHPta2euyzInJnlGLT/
        RmZ+3ZcsVnvLzvB302EhVLeO+g==
X-Google-Smtp-Source: AA0mqf7hiBXQQAn0Y+l2ZkZr03wQTds9xREx1n21mzMwdfGo0jv5B6/ORm3N7D8kGcyItmXCulkrHw==
X-Received: by 2002:aa7:cdd2:0:b0:46c:7119:47ad with SMTP id h18-20020aa7cdd2000000b0046c711947admr15635310edw.387.1670413887674;
        Wed, 07 Dec 2022 03:51:27 -0800 (PST)
Received: from localhost.localdomain ([193.33.38.48])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm2132816edy.36.2022.12.07.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:51:27 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 2/6] uapi/linux/if_tun.h: Added new offload types for USO4/6.
Date:   Wed,  7 Dec 2022 13:35:54 +0200
Message-Id: <20221207113558.19003-3-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207113558.19003-1-andrew@daynix.com>
References: <20221207113558.19003-1-andrew@daynix.com>
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

