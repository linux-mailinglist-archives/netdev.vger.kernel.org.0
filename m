Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198321A6B62
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbgDMRda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732808AbgDMRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:33:29 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20760C0A3BE2
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:33:29 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k15so4802834pfh.6
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RhKxw9cYF681ZRE/eKDhxSKbEnVj0UK/UJs3G6qW8+U=;
        b=MRt2n4cYb8i9MegKQONX1+RFIOZLIMWxA/gdpOeVqnogJI8vmqxeJrvM9g3lKQx+qW
         2uNjJS49GPzbdz7F4sOa88UHC6pEURW22BA7AMAr6S4dHrmPAaxzyAw2IISZkOCZ8CW5
         tQlK9f646K8/8gYhLeIH3c3QL2l1YtEuM9fuIHWCinzv0adcdSOcOOb7PkPE76OGtvU8
         wpBPyk6bWAZhGOMap+y4qZlrC6GLVyfUqxRkDOMUPZ4eWejYq1HAGHog5zfSc1S8SGF2
         Ha15TbS2I2cL/W0z94g6wTcer57CpmblIpoB2UGXr1PsEmWxbvALu5lwvTnYztO6/JXR
         7C6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RhKxw9cYF681ZRE/eKDhxSKbEnVj0UK/UJs3G6qW8+U=;
        b=KZoOXWLqcpqI7F6tRdHxCkBKdNWMlYtVkR2h37An/flaTsH+AyG+CNKpPLqZwB8G+w
         TPe9/IH2ejFksJU376JDs5a/EYONTsoLVwKsmBfw1ZypXTTq22O+3K24VzGMc8yuR1+E
         9yyZfnlflfqDOv95QuV25fqMcx9ZasrS38ZEBqtFf5b0zJQfbCq3uTz73J7cVaxFlR54
         vw1KfN/fofcc8IjevqSkKXSDqFHVLGiZzZxnqGqbSqB29353Gq98uDybgUMik+dDblYQ
         Lo5vayFvs/LuieEALhvq2jRtKRXNaW08CSxIkaxC/G3AGoBd75Toe8ldfdROSKy3NhPi
         0pTw==
X-Gm-Message-State: AGi0Pub+q+8t9psbBJqxSvrqEq0O98324S5xe9E6/oC09dzaC5hQBmf/
        KQpngv4ZA0ELg3OJ0o4dFNj85Q==
X-Google-Smtp-Source: APiQypLfq24ZnXBb3+Nwzsk39BrZdDFQ1uZDMiq5Om0cYHfWb/fpb2KV8ap+PUvtWbKFvsr1lE+skA==
X-Received: by 2002:a62:834c:: with SMTP id h73mr19169612pfe.59.1586799208738;
        Mon, 13 Apr 2020 10:33:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y71sm9234409pfb.179.2020.04.13.10.33.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 10:33:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/2] ionic: add dynamic_debug header
Date:   Mon, 13 Apr 2020 10:33:10 -0700
Message-Id: <20200413173311.66947-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413173311.66947-1-snelson@pensando.io>
References: <20200413173311.66947-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the appropriate header for using dynamic_hex_dump(), which
seems to be incidentally included in some configurations but
not all.

Fixes: 7e4d47596b68 ("ionic: replay filters after fw upgrade")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index f3c7dd1596ee..27b7eca19784 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
 
 #include <linux/netdevice.h>
+#include <linux/dynamic_debug.h>
 #include <linux/etherdevice.h>
 
 #include "ionic.h"
-- 
2.17.1

