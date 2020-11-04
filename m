Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661F12A65F4
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgKDOJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730237AbgKDOJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:09:52 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD3CC061A4A;
        Wed,  4 Nov 2020 06:09:51 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c20so17355649pfr.8;
        Wed, 04 Nov 2020 06:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SjS5TEp5z8cEIBGlzyQMwfGUqpE+fsLHvYNxytW1zhE=;
        b=iInZt+7vo/656g3R+HqOPQwJLDpnDzLZdTp/NyL9cIzNchStu1zbL61zamGqJi1Ymy
         6JE480O5LJ8U+EtaZtqVenWwm6nuiLxFhlk6+T0SCkqJj+FRtTW2K4JDGt5PYfNvSHFD
         49CAxFvktj6Vti/2g4zzxuQ7xUcT/Dhr2sCCVh7ZbB3qFJ9WaE62x9HrCfQwg7RmWjMW
         5KqicybSFNNgSX3YTuBECODXL6x9gaHBgMg2h1AHzbro/VbwfCxGENPPkg+k7GzUnY+D
         MzTdbGrsvQfbsMi/YRUO9DzLCjB0xRp5m4UeRyQrrYOsqqX14WyMLgDAgufN1ZNmv5xn
         0y9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SjS5TEp5z8cEIBGlzyQMwfGUqpE+fsLHvYNxytW1zhE=;
        b=KSqVB+hR3yxq7XIjEkXqNvpikXyrD7C6Zp7pUiBp00y0YT0Dt43hXxgQPie22EyGZg
         VP8+skP+pw+vzjM8rGcQ+zF8oQAr2oPOLwzX8t/aR9eMGkEKQEGUhNRKgnvzWLqi2JEu
         TwQqQojUHCgZKYH8jZP9bqKyjOTmchc0aPbi3fouDM/i+F+3wpE+izB3Y6HFRu/Lwdxh
         cOFD7cvYcxFYzsVuixEjPEmDzAoTsGJxz7FEvSNVQY0PUMMBi96StKz9bJdZhl2Dorhl
         XVU4DwMRf8YHreFdNbk5jHG2mrJYutmtLgsRH2GVYEIHOR9q9EUtTPpHTp3K3nN5EylO
         H/LA==
X-Gm-Message-State: AOAM530iwjFECXKzKi3k4ePFQrsaoJU/dZ3p2B0qmaSbFt5ZNmIKhxMX
        fq4SMIsNuvPeIZFJNVyCR27dewui4Qyjxf5p2AQ=
X-Google-Smtp-Source: ABdhPJwNBSJJDYLtTsXrcjAt4hqpccMQ5da+iMvYUZs5LnvSwt+eTwObKsSYWc1EFBYyXl1kjAiLQw==
X-Received: by 2002:a63:1924:: with SMTP id z36mr21497231pgl.354.1604498991045;
        Wed, 04 Nov 2020 06:09:51 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:50 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 4/6] xsk: introduce padding between more ring pointers
Date:   Wed,  4 Nov 2020 15:09:00 +0100
Message-Id: <1604498942-24274-5-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce one cache line worth of padding between the consumer pointer
and the flags field as well as between the flags field and the start
of the descriptors in all the lockless rings. This so that the x86 HW
adjacency prefetcher will not prefetch the adjacent pointer/field when
only one pointer/field is going to be used. This improves throughput
performance for the l2fwd sample app with 1% on my machine with HW
prefetching turned on in the BIOS.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index cdb9cf3..74fac80 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -18,9 +18,11 @@ struct xdp_ring {
 	/* Hinder the adjacent cache prefetcher to prefetch the consumer
 	 * pointer if the producer pointer is touched and vice versa.
 	 */
-	u32 pad ____cacheline_aligned_in_smp;
+	u32 pad1 ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
+	u32 pad2 ____cacheline_aligned_in_smp;
 	u32 flags;
+	u32 pad3 ____cacheline_aligned_in_smp;
 };
 
 /* Used for the RX and TX queues for packets */
-- 
2.7.4

