Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9136E3AEA63
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFUNwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhFUNwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:52:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D9AC061574;
        Mon, 21 Jun 2021 06:50:20 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v13so8581146ple.9;
        Mon, 21 Jun 2021 06:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nQXYpr9OGIzLz2GoYn3JoWophCOazgqDgqjJlPCW9Rs=;
        b=lv9U+FuTpoaz7AymRBNPFNKHjQcfwKiwWvhz1Hdsy28AWvlUDmXgBbGSTehyn8QEzF
         MD6zLkgSKagDIpdWXB/WoYDb8mMK3Vghy3WAOWoivQculdGRbRsfGmTRJWgsVAmH4Qe2
         HCWIhP4rXcEJ1xU29jjK8zrxsJ5l5XyUCirCUT/OLlwm1ny80NucLs8bXUkbMFk9wNQk
         y75q0JMy2C2Q8op1YWqdSGANcVQUUfqZcZZMBMIk1+M/US+fDoDzG7lRY0sHmt0QEriK
         gg249+gg9XDwoV6ZrkGCUkDO/FN/+PnonfDZV3g08FSN7v2CfE7JiIO1bwLF9ujNMS1r
         LS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nQXYpr9OGIzLz2GoYn3JoWophCOazgqDgqjJlPCW9Rs=;
        b=M0H3OP4oeZcrgoU9zP5kKb7k/VIlXaHbrNQC2FAk88f8oRuvi/x5mkNsHnrPVzl+63
         T4hMDSWtN0ceOLB4dyVi4kUTm89yUDhuExDpknW03LU+viGicTr+Fm8MD6w3RvQFB0um
         JwbDHZwprt/oodax6YDAqCRpNmwHdfFq2vmmcvgI7HVvdAdG/3+u1ZIxeZAGaXwGHmxB
         Vwbs/2DYvBA2H6y9JxpVihK1Zie9XZg6TZm+8js1sd0gifb3Hr1f21KTVzlBWjqr7eav
         9A3f94UMHU6qhPztimPgq8XjmBV9p/XWQYxUVtmPyR844vhDh5iCogYwwEcX7PEhKObW
         B8AA==
X-Gm-Message-State: AOAM532ubXGxma/UgTHKIZqYVjR681J+gQTIFKToLNkiSE0DZOFps6GZ
        nohCusXy8/YkK9JqMqiPYBA=
X-Google-Smtp-Source: ABdhPJyPXvMmTVBBrohbhigbDD75fOJj+C8VChO1klkLtEa4TIchsmrFlvmYANSMpmEV0qTu6XMEiw==
X-Received: by 2002:a17:90b:3646:: with SMTP id nh6mr14994751pjb.73.1624283420237;
        Mon, 21 Jun 2021 06:50:20 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n6sm16959160pgt.7.2021.06.21.06.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:50:19 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 07/19] staging: qlge: remove the TODO item of unnecessary memset 0
Date:   Mon, 21 Jun 2021 21:48:50 +0800
Message-Id: <20210621134902.83587-8-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 953b94009377419f28fd0153f91fcd5b5a347608 ("staging: qlge:
Initialize devlink health dump framework") removed the unnecessary
memset 0 after alloc_etherdev_mq. Delete this TODO item.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 8c84160b5993..cc5f8cf7608d 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -4,8 +4,6 @@
   ql_build_rx_skb(). That function is now used exclusively to handle packets
   that underwent header splitting but it still contains code to handle non
   split cases.
-* some structures are initialized redundantly (ex. memset 0 after
-  alloc_etherdev())
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
 * reorder struct members to avoid holes if it doesn't impact performance
-- 
2.32.0

