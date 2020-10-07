Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41DD285CAC
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgJGKRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbgJGKRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:17:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A50AC061755;
        Wed,  7 Oct 2020 03:17:51 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id m6so1515435wrn.0;
        Wed, 07 Oct 2020 03:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hq1qtMDcHnZaCWsCFExhGf1WrOAbdBkCMjxsihqFbE=;
        b=PRbZZUdhnTaeGB1qA5zqQhwAT3sWTbgoAha74JjnWy8pD0Oo8+ZqHbDj2B2fBzVzyo
         4iriJz6iQGhE5ZiarBL5RsyLacZ9BxBxesr8bFKM4uscG+bhB4RP6cnGEbA+0Rlj9GQW
         EHDiAS/icjaenIt+hEFxU/70u0E3oo5pBMA2/JLIjPJoehUUrUBoG8EQUlRTZA/22yph
         GPKmipLt+NC8hhcd9VA/CaZiu6rfaMlYN5eqewF2J7iTQ4ozTFCV/TEiJi6qJ6q/G0Tq
         0d7PzUyDu3D1O2D5GUhQNs0PM8DJ+NEwV7orH3gQxs4MwS/P4rEzbglFgzeS2KsZSNqR
         387Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hq1qtMDcHnZaCWsCFExhGf1WrOAbdBkCMjxsihqFbE=;
        b=sW+lq6buGadkyp/OVkp2BiVL8slMoMUwVwRuWOHR+f6UPSaJYxXDkAe3Iru6GkXXWu
         DcTPIRTVfX2QSUiMLb7y0RI5y1O7Y2FwXgfnnBdpA6tbr2RDTfsuA3K06YJQ7eKmM6V0
         oadCqrBdJBBFVJKmtSDy51BSt9xDOIFO7ehYSoXxjgxikWzmWgy+QWYi4dYv7M0dhE5o
         4ijHBAEW+BfWWq3Hcp81NuLYD2dKDO6Ix7NnoUIMU/86j0ib41g1GD7C1C6zkJLlJwK3
         wvYxCMVTHX1+Io9T6SklFxkDfHCVDb/IAp4gCATFIx4T5hn3RNTDr5qBsoM2BxlddJzZ
         eXiQ==
X-Gm-Message-State: AOAM532OZkzplznS0+F7OPCvt9PbjbZLW+SWG7w1emOkLmmYy309Tn+t
        x9sBZDZ7QWjxj2A9hvjcPe3aIdnadJ9Qywsq
X-Google-Smtp-Source: ABdhPJzR9sKgodW4Gf3zQ2ba+ZYityJcHDqjXrNvAScwqcCO+6cxdiiTGV6xMKodr4z14fOoQkRUQA==
X-Received: by 2002:a5d:5281:: with SMTP id c1mr2673483wrv.184.1602065869716;
        Wed, 07 Oct 2020 03:17:49 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id u12sm2249168wrt.81.2020.10.07.03.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:17:48 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH 0/2] net, mac80211: enable KCOV remote coverage collection for 802.11 frame handling
Date:   Wed,  7 Oct 2020 10:17:24 +0000
Message-Id: <20201007101726.3149375-1-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

This patch series enables remote KCOV coverage collection for the
mac80211 code that processes incoming 802.11 frames. These changes
make it possible to perform coverage-guided fuzzing in search of
remotely triggerable bugs.


The series consists of two commits.
1. Remember kcov_handle for each sk_buff. This can later be used to
enable remote coverage for other network subsystems.
2. Annotate the code that processes incoming 802.11 frames.

Aleksandr Nogikh (2):
  net: store KCOV remote handle in sk_buff
  mac80211: add KCOV remote annotations to incoming frame processing

 include/linux/skbuff.h | 21 +++++++++++++++++++++
 net/core/skbuff.c      |  1 +
 net/mac80211/iface.c   |  2 ++
 net/mac80211/main.c    |  2 ++
 4 files changed, 26 insertions(+)


base-commit: a804ab086e9de200e2e70600996db7fc14c91959
-- 
2.28.0.806.g8561365e88-goog

