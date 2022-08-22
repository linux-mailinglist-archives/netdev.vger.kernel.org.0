Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEFB59B896
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiHVE4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVE4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:56:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514C823171;
        Sun, 21 Aug 2022 21:56:31 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y141so9245741pfb.7;
        Sun, 21 Aug 2022 21:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=rWOeIzEAQ3i0RwbBaaqiWUHsFif2nUF2BGAPKZc3cuo=;
        b=d6xp2hPU4Ocy1F7oyTmLG6HZ2YhiFoOjoL1t3HVhiMhYCFxBwYSRXseIMDgRFGFh5a
         Hek9HBro73IH0Try9aqyDKWvWMlH8XhYbh2zjXqU9A0glYdVBmSoF0l5HsX2M4COAj63
         L9E5NQFAgoUjlc/8i88pFnyZ3Rt9VyIq+gl7xM2fEfUSqEDL7wvhV6Ihf2o+4Q6Z1p2K
         9HeB1zfu6MCZkHneRkhSFHQrPGSEkQxKeT1ZbYEkGyRl5pGgJ3K4CyVB3SvfrZ1Du+1R
         t3S8L507QdlbbeuADG5n3w/8aOZtPEGKYxbNv2wb0YslDAmuiJYirWFT8wk7gtEDT77A
         LXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=rWOeIzEAQ3i0RwbBaaqiWUHsFif2nUF2BGAPKZc3cuo=;
        b=puzJ0MJL2oYMnwajAhcUOFVyijOp5Ki1Mif0USvDNHLc3fVHy5dGSYTjyc3bClX90/
         8jPnSu4kouzmsdTJuD4kCBihxv++2zP00XGdUHt2LW0abODt3DwW3VGMG84xqyqG+1Zj
         mf7F8RT76NF8FaVAIjOcCzQ/mj40j8lydmxtb/VpyC/mLSr79t4ng6mYx1sV8WbiSNU2
         D9LZRVsnOTUucxVa11u3U8daLO6OryGzu/xqUAtWQmOXWYhouUd5m8yydZevJeVOOM1R
         v5Q2/CxevrYMc25TE96mW9DkWJ8a5ONa6LwpHPpoIJvkisp1Pp3Qr07iLZ8uHwq/sWsQ
         3B4w==
X-Gm-Message-State: ACgBeo3SOJVhsUlXlUnjxWwLQ9reMxzo+dtNT3n68BjuIQ5hj5egB2Qd
        QrG0nGqyvOGEPNrjNT2ivhM=
X-Google-Smtp-Source: AA6agR6RgaI4dI+dWl6NW/B6wAcyyqfa13LBrB0RIh364CScyneu7g1kQKY6AMCDFrhKhqDU4a78Xw==
X-Received: by 2002:a05:6a00:2192:b0:52f:6541:6819 with SMTP id h18-20020a056a00219200b0052f65416819mr19266007pfi.83.1661144190835;
        Sun, 21 Aug 2022 21:56:30 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id rt12-20020a17090b508c00b001f334aa9170sm9103938pjb.48.2022.08.21.21.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 21:56:30 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     corbet@lwn.net, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>,
        CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH 3/3] ipv4: add documentation of two sysctls about icmp
Date:   Mon, 22 Aug 2022 04:56:22 +0000
Message-Id: <20220822045622.203822-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822045310.203649-1-xu.xin16@zte.com.cn>
References: <20220822045310.203649-1-xu.xin16@zte.com.cn>
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

From: xu xin <xu.xin16@zte.com.cn>

Add the descriptions of the sysctls of error_cost and error_burst in
Documentation/networking/ip-sysctl.rst.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 56cd4ea059b2..c113a34a4115 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -156,6 +156,23 @@ route/max_size - INTEGER
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
+route/error_cost - INTEGER
+	The minimum time interval between two consecutive ICMP-DEST-
+	UNREACHABLE packets allowed sent to the same peer in the stable
+	period. Basically, The higher its value is, the lower the general
+	frequency of sending ICMP DEST-UNREACHABLE packets.
+
+	Default: HZ (one second)
+
+route/error_burst - INTEGER
+	Together with error_cost, it controls the max number of burstly
+	sent ICMP DEST-UNREACHABLE packets after a long calm time (no
+	sending ICMP DEST-UNREACHABLE). Basically, the higher the rate
+	of error_burst over error_cost is, the more allowed burstly sent
+	ICMP DEST-UNREACHABLE packets after a long calm time.
+
+	Default: 5 * HZ
+
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
-- 
2.25.1

