Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3665E3EED6F
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbhHQN3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbhHQN3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:29:19 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3572AC061764;
        Tue, 17 Aug 2021 06:28:46 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f3so24893160plg.3;
        Tue, 17 Aug 2021 06:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIKkDqG4Bg10qu8DR0aLV3Va/c5MtW/oah6DQGWgYF4=;
        b=RHCBR/4kIwAVhymzHU1dvwJ5hgAg08CLTTzU5H2kj7nd6R52lnSIb78rZEkoMjt51O
         9FnmFbGPKGRes+/FsuX6Dn0O3hKEcJ8ahlpmxvO3yVbaL88CPwGGmQBQwdl8T+AQD6am
         1ayqZRj5bdRHi41Z8nL7av893v3PhgDS0HfwrB4QgE4SMdrwccA+gfqMmV1e6a5VO5//
         5eMSKm4c/2wLGUoJDOpbJAnV2m90CcH4+A53XwEXd/hA9q2nzrJSd0UskCdnyNe1fVLi
         oJDWa3iifaXYyQ8PJ4KNe+IdUkcn2vsnhS367yLa0rdoC/A6OPvIqxq+gX8XWaJYo754
         AzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIKkDqG4Bg10qu8DR0aLV3Va/c5MtW/oah6DQGWgYF4=;
        b=Uoh/shGjTIOogExeTMe4rMMS7CQHaDyEIdpPWoaHpvUKe1XowctKWFhGoJ93nF78xw
         7cG3TkGe/E8FBgbKDFqxQx6icmwGOTL5TiciJ7x1/oAVIAACpDc2kjEjWFUFPKDGxuvX
         yXMSsvD9RghHE3KRfWtSCAcHUgp9cpdmoGNm59ZNnF4XMpGVyCODq4/mxDgcdtbDAQDl
         2PTdx34b77IR5akEmtVufkGYwb24euVDSoT4BTCG1qBC7RV7eLbqgskgUBwBava08rKG
         /Ok1EEDbRAI1nyS1SkCt6AtqwZB2B/MWg5u3+a/+hNY2igR3l2MZWW5qsp+GGPTBoZDz
         hENA==
X-Gm-Message-State: AOAM531I2hNSPk3UXClLRGhrzYZ61r4zhQ4kysAd9TpuhN6AzcMsP2sx
        UT7BIIBXlpWpG11w7s0H/uU=
X-Google-Smtp-Source: ABdhPJy96PxmH0bAK+Ra4yO7Ly45J4qpAOr9MpBpGFiLLiz3+Ua/51QnU6DQgNHjkf5DXfnag9etCw==
X-Received: by 2002:a63:1e4e:: with SMTP id p14mr3551907pgm.261.1629206925874;
        Tue, 17 Aug 2021 06:28:45 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id j6sm2791577pfi.220.2021.08.17.06.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 06:28:45 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 4/8] selftests: nci: Fix the code for next nlattr offset
Date:   Tue, 17 Aug 2021 06:28:14 -0700
Message-Id: <20210817132818.8275-5-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

nlattr could have a padding for 4 bytes alignment. So next nla's offset
should be calculated with a padding.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index b4d85eeb5fd1..cf47505a6b35 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -113,8 +113,8 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		if (nla_len > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
-		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
-		prv_len = na->nla_len;
+		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
+		msg.n.nlmsg_len += prv_len;
 	}
 
 	buf = (char *)&msg;
-- 
2.32.0

