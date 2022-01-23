Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D4497471
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbiAWSkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239650AbiAWSkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:40:14 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D4CC061744;
        Sun, 23 Jan 2022 10:40:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y17so3130394plg.7;
        Sun, 23 Jan 2022 10:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wuCEC1DNMMa7rD1lJm/KbzT4QoZBEAK+Wq0lZsijL0E=;
        b=adBm5C46WHa+SqaVcfg/e7fBkpNQqkpVo+XFem4Slx6gw952BGG6XbNnKPU+0j7a1z
         CV9pkYrmO/yS2n03l5PKu9DuG7U8o+2dLXjMRbayjl4y7ovc6A14u23xvv++vlL2RwZb
         QBOnNfjUAXDNvJ0ils0KPIaveiqyrImHkBU5YO8vJeuD+wXqT7Vd/npI4VLDyp2sIUEh
         9TpvMAiivxyIJvIAKnoVKMnfIRBi+0uh53dq6uCARjaZqdpPQgtBg0+xE8okK8qJUw5x
         GkFNj1C6hy7fktEJHJ4RaFYXgSegQ1d9X2bTja4WR/1sp9o36n4hN/tS1Y2dfuUXihBK
         KLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuCEC1DNMMa7rD1lJm/KbzT4QoZBEAK+Wq0lZsijL0E=;
        b=PvBCyqFrXaxokdRwLpkokMr7JOSbDvna2M2wj6PmvX2TPCJxnGuYpU6w0ehERWp+d+
         8LMBiQD6/w3ukOJ9Ceord6VvnBY5P7YSLJYYqbkXuRLEYAKCYzBNVXTsCNIy/y+4zjFt
         24s9uOID5oMuc9q9KpzayB3yQOJ+Qll+QgBRq+5GBHK1z/d2Ot3+rFSDmfZEH+iEGv5i
         bO5vHtc8FouKcMjh4lwlgT25NzJQ2oDCpEsNkiry2x7XmmgBJIMmH/7iuXb4Gy6dOLvE
         XKIUipJX6UhCs5CYO6TPLhBTG3sTRCcCuCQuIlGuoIXb8TPAKQCQelJsGFEpGk0vdHfs
         GFIA==
X-Gm-Message-State: AOAM531INligb4Xonb5ylcepuLd4QKg1QXjM3ex4iiKfNVYYj/d0nqh0
        28fA987bx1SUGJxM13A67SVbMXo/LuM=
X-Google-Smtp-Source: ABdhPJzACqIpOshcLMvZufgVtTCkTi5/v/UXrPKbyjQvs/zo09oEZyQLbdgvh5reWb2CzD5QERIA/A==
X-Received: by 2002:a17:903:1c5:b0:14b:f87:bf3b with SMTP id e5-20020a17090301c500b0014b0f87bf3bmr11650785plh.130.1642963213640;
        Sun, 23 Jan 2022 10:40:13 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id om12sm5089855pjb.48.2022.01.23.10.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:40:13 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 08/54] net: ethernet: replace bitmap_weight with bitmap_empty for intel
Date:   Sun, 23 Jan 2022 10:38:39 -0800
Message-Id: <20220123183925.1052919-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ice_vf_has_no_qs_ena() calls bitmap_weight() to check if any bit
of a given bitmap is set. It's better to use bitmap_empty() in that
case because bitmap_empty() stops traversing the bitmap as soon as it
finds first set bit, while bitmap_weight() counts all bits
unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 39b80124d282..9dd52aab68cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -267,8 +267,8 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
  */
 static bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
 {
-	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
-		!bitmap_weight(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
+	return (bitmap_empty(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
+		bitmap_empty(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
 }
 
 /**
-- 
2.30.2

