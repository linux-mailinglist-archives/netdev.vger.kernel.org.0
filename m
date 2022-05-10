Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDEC521FF2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346351AbiEJPww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347238AbiEJPwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:52:08 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8501A81A;
        Tue, 10 May 2022 08:47:59 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id hf18so13860148qtb.0;
        Tue, 10 May 2022 08:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8XwVIoqaEjrb3iMSCaJMjNScsN/uhpRfrQ8NarzetBA=;
        b=TRtRj0OV5KH470cMHDPWUxl3cSGx95ngPsN0DC93pj0q8lGKr6CIDI7KqIjvYte1Hq
         DqQZeHliFkhzx++RKygoPz5nE4Aqk2UIQzgMw/6D7YlBFtqCr1XJQeY0aXrD7Z3I7zL8
         vdYXHH5j0T9lwr4UaICLcWXUHX0ik0X+sJnHHfGa8ofweq10xOcV5vZi7VReLlWYtqqn
         nHzBpLgUII9FKyjiNIqU9JJdGkKXpJ8qxoycCK70hC8aBK07eSXmnxo2CnbJXB+wPmRf
         eG+ftCF5WaKR0/SbaXZWXn93wkpkW1VusQ4Xh9LxdA3A1hrUIpyXsC+T7vM12H0qF72o
         ZkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8XwVIoqaEjrb3iMSCaJMjNScsN/uhpRfrQ8NarzetBA=;
        b=YttMwB8O6ncQnx11oCNG/1q2sfqdNlXA9Dr7W8V5gnSwyoVwYv/UTG1qi5m1p2Jzry
         urcXOzFtut1WnmVPNCU+elgC2WlEFqSTaOcaiMjHxv6v/DVfTrOi8Mhkm4zUy4llY9T/
         oGPg8zSoy2NsvpDmM3SbmjiyceAW9RIB43TdbmtbRR6hpdRp2LZ0Y/ZpACTgqGPZzDcX
         1aVmCNyrigv2AvgpacenE/Vb9Xyp/6mui3BvUU5RuYDq6e+4AdtD41FqoEU8v/jo6VCb
         /ckD70zNhU0NUnhF/w9qgiuNf4ZHN+LDGrfxy+A9CIvSeTcrXfmv3ygmhs/8dGddmt05
         CnAQ==
X-Gm-Message-State: AOAM533FC8mRzanlHpvbT+ujwA1IDP90Oa6GMAnXlCPWUAq2Hp8Zqo+t
        Q3t+1X/EE57ZDQz0+44dqmA=
X-Google-Smtp-Source: ABdhPJx1lvQ2cAFBLJUoEVeXgxIKrxcn5z7aIGeJaHLVOgtu8J7l1okT1ZHyyT7jgo7gM8c1D/jlvA==
X-Received: by 2002:ac8:58ca:0:b0:2f3:da32:ab1 with SMTP id u10-20020ac858ca000000b002f3da320ab1mr10163209qta.308.1652197678887;
        Tue, 10 May 2022 08:47:58 -0700 (PDT)
Received: from localhost ([98.242.65.84])
        by smtp.gmail.com with ESMTPSA id a123-20020ae9e881000000b0069fc13ce227sm8659793qkg.88.2022.05.10.08.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:47:58 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 04/22] ice: use bitmap_empty() in ice_vf_has_no_qs_ena()
Date:   Tue, 10 May 2022 08:47:32 -0700
Message-Id: <20220510154750.212913-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510154750.212913-1-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
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

bitmap_empty() is better than bitmap_weight() because it may return
earlier, and improves on readability.

CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <edumazet@google.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Paolo Abeni <pabeni@redhat.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>
CC: intel-wired-lan@lists.osuosl.org
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 6578059d9479..de67ac4075f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -740,8 +740,8 @@ bool ice_is_vf_trusted(struct ice_vf *vf)
  */
 bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
 {
-	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
-		!bitmap_weight(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
+	return bitmap_empty(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
+	       bitmap_empty(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF);
 }
 
 /**
-- 
2.32.0

