Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C7C4D75FB
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 16:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbiCMPDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 11:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiCMPDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 11:03:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0BF9580CE
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647183746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OZkkggqsQIoWieW/oVrOCwUkJK6lKvyxEtn8wx8/DH4=;
        b=YPsgh1R4WIgXqnpYkir4DELeHTg+Mq21vYPqbz6wn81UooJYmi/k6IdVy60x0iqLyzozNi
        x6uMAAa3XxBMPQzktJG+UMClyemQUfMaC+ZxQkM2Ds4Nq0g0wLqSRYwqI1lXIYkluYsR7n
        PqFrjKN5uL2G8Jk9UqhD71uF1xUWXwU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-wleo5yuoOCueEfd5YrvmTA-1; Sun, 13 Mar 2022 11:02:22 -0400
X-MC-Unique: wleo5yuoOCueEfd5YrvmTA-1
Received: by mail-ot1-f71.google.com with SMTP id t16-20020a9d7290000000b005b24005289dso10029644otj.11
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OZkkggqsQIoWieW/oVrOCwUkJK6lKvyxEtn8wx8/DH4=;
        b=rZosCK5bSxyssEFoPRE0DUnEWXONUalddPZsgCvv1qxc3ulOU5Fckq5qzBOCifvCOF
         yfGZt/+Dm4fcZOT+/61ROA8ipB/h83S5yRncLXTIwg62XHeASw3LkjRa6GOMZqKX1TVZ
         jkt9A8cGVSk7NKFSBR1U1mFkuQScgWFFZoxZ+KgjHR1xV1Y3ccHVN0fnYDN9tyeI8vWI
         G6iEZuj1gwEy9dAwlfsU18/0cdB9aekDFPYOd7/UK6Hb+gaERpP7qo5EH5vOQkMFVjxx
         NN0sxR7Ynl/jyXzsl2L65527zeCH6fm4Anz8LuGJj2olm4siCatQ6IygfyH7GKYlblRx
         GV4g==
X-Gm-Message-State: AOAM530IJCaj/ErH8DYO1kdTxFVY9QvzTrUYVuloBMvCvh4KhxrxUNNu
        N63z8Ysxy5NkjrlrTYe6NmxqAYWMo925V7cCUJuScGgV75EYuA8LEXbDj4Tes90nycwFM56O/4i
        oiU9iYhUGd+BCnSEc
X-Received: by 2002:a9d:4e99:0:b0:5b2:54f4:75e7 with SMTP id v25-20020a9d4e99000000b005b254f475e7mr9119068otk.94.1647183741500;
        Sun, 13 Mar 2022 08:02:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjb1ejVgoHBYltkBU7cyugOD8fhaxKGdkCT++7rWLl8GnDe8scorY7NgLJqvOmNm3oOxRWWQ==
X-Received: by 2002:a9d:4e99:0:b0:5b2:54f4:75e7 with SMTP id v25-20020a9d4e99000000b005b254f475e7mr9119012otk.94.1647183739823;
        Sun, 13 Mar 2022 08:02:19 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id o17-20020a9d5c11000000b005b2611a13edsm6324116otk.61.2022.03.13.08.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 08:02:19 -0700 (PDT)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] igb: zero hwtstamp by default
Date:   Sun, 13 Mar 2022 08:02:10 -0700
Message-Id: <20220313150210.1508203-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this representative issue
igb_ptp.c:997:3: warning: The left operand of '+' is a
  garbage value
  ktime_add_ns(shhwtstamps.hwtstamp, adjust);
  ^            ~~~~~~~~~~~~~~~~~~~~

shhwtstamps.hwtstamp is set by a call to
igb_ptp_systim_to_hwtstamp().  In the switch-statement
for the hw type, the hwtstamp is zeroed for matches
but not the default case.  Move the memset out of
switch-statement.  This degarbages the default case
and reduces the size.

Some whitespace cleanup of empty lines

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 6580fcddb4be5..02fec948ce642 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -165,23 +165,21 @@ static void igb_ptp_systim_to_hwtstamp(struct igb_adapter *adapter,
 	unsigned long flags;
 	u64 ns;
 
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+
 	switch (adapter->hw.mac.type) {
 	case e1000_82576:
 	case e1000_82580:
 	case e1000_i354:
 	case e1000_i350:
 		spin_lock_irqsave(&adapter->tmreg_lock, flags);
-
 		ns = timecounter_cyc2time(&adapter->tc, systim);
-
 		spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
 		hwtstamps->hwtstamp = ns_to_ktime(ns);
 		break;
 	case e1000_i210:
 	case e1000_i211:
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
 		/* Upper 32 bits contain s, lower 32 bits contain ns. */
 		hwtstamps->hwtstamp = ktime_set(systim >> 32,
 						systim & 0xFFFFFFFF);
-- 
2.26.3

