Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DDC287841
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgJHPxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730063AbgJHPxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5C1C0613D2;
        Thu,  8 Oct 2020 08:53:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so4314115pfp.13;
        Thu, 08 Oct 2020 08:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T1P3vjpDjU+9KxXxsbq876rgerqwTW2vQ6eqsdtxYn8=;
        b=gxcG9rWo45rxPYd3ATiq6NxkN2HRkxGSetM4MZUx3RyRAjrTqV2gFtPc3Rphlm4uZ9
         8OEimP5pwcHT+DW57H5nMxdj6Qw8uhqmRqmtm+6dfWcGpNAdErekMv5/j7jSscgYlbkL
         YFH9BGgp9i3+UDaBK/d96jInLszHfDJMJ+xfXyx4SCuVWS549HZXF0CLieOPJjREdmUV
         O1GJ7WMyLNR4KAgnhlimJtgXKSK1RwFUEF7FTuVRn9Skp6OR9AGSXKmhcnZn5aOT0prh
         QUe+Vjsof+OTsNiZgvy0aiGP6uMwm/ZghylY7hXMT49lLO4XdfpkPLCIaAo50JUlhOuG
         zyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T1P3vjpDjU+9KxXxsbq876rgerqwTW2vQ6eqsdtxYn8=;
        b=S/7+v0N3wN9oenbUD8pnxCzMJomHVKerlPrBJ0vs5AeDkdnnwAdlRdjhK4F8oNfP9+
         MlT7sbtE0Avf06ghKkVFo3mFoqYNCeKjOkrE9GLACm+0H2Xp8jZ6wsSRXDeOG29nngdX
         UY2T12+lejYpnWGUS/ZausnXt+IARxV4HCy2Gxy9ZSdaxncOKIFiELTkFk322hNQLS9b
         P2F9fE/fAagPLGy3pq7l3A1IElDkOUopBex+ucH/akxuTgZm25I9+WdPRqyL/Z/Vyjqz
         MzDQrhjFrrGmz/OG3I1LS5xgdk8IZqgXrLbdCprxYyr8bZyQRLC0Rsiz5+lVPtCwWPa9
         7s2g==
X-Gm-Message-State: AOAM531vPNH5DQiVJhRMEa6DZK/OniR1IDDngsCmSyDB7SlRgt2T0f5v
        ZU3QjMWNfihhnP1++Uad7l0=
X-Google-Smtp-Source: ABdhPJyfYHS8gv4LvMbGux4K3EspxAEg/9UxdowmVOLtF42yEC9tPtKvux1W1oGeD79M+e84vW5u3w==
X-Received: by 2002:a17:90a:46c2:: with SMTP id x2mr9008354pjg.60.1602172384733;
        Thu, 08 Oct 2020 08:53:04 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 014/117] mac80211: set force_tx_status_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:26 +0000
Message-Id: <20201008155209.18025-14-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 276d9e82e06c ("mac80211: debugfs option to force TX status frames")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index ff690feb56a4..a3f3e3add3c2 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -338,6 +338,7 @@ static const struct file_operations force_tx_status_ops = {
 	.read = force_tx_status_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 #ifdef CONFIG_PM
-- 
2.17.1

