Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF1287846
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbgJHPxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731454AbgJHPxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:11 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C896C061755;
        Thu,  8 Oct 2020 08:53:11 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so2953281pll.11;
        Thu, 08 Oct 2020 08:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XRB/SE5ZIyzVwPq8rfA3EILsvcmS/wCMmuxLyXreGRU=;
        b=UNE5wlzCE6dcVmGBgbrkWNdT5/TF9pu/6adTaXuXwBcMfZAAgRbRSfc9vcrPHmrSUF
         8TaLYfDVqF9gzRev11KlfaKzYMVCjiIKsBMjGUc5ENjtdPezwewtf3u15B5da4rf0ktf
         6UmW11MNWwJ5N4xNoEfBRdSz8+uDP/+ilS0/APVY8r/5GyVqOMxz7FE9WZK+EgshA8QS
         wWWmMV06tQpyDiI/lWy18YheAXfgn76R6nH2sBHPOXGX+vyTl+11nVGaEZnkPsruRnMF
         T1vOYSji1MmiGFs3rCdHCnWm8JPWU5g9kqAbP3su80NbklQe7TU51ISPRU+txuM7dH5Q
         oSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XRB/SE5ZIyzVwPq8rfA3EILsvcmS/wCMmuxLyXreGRU=;
        b=i3gcfSWQLK/0tlfAv2ZYEdL1WkUazb8JM+I3UgR8vH+HPX8E1LrYo9YRRtcM7xmcbY
         ZpH2lDtRzSz8WUW+iIruLg+tDEdOQ+sQJXVIVoMna8G5XTcPthMv1wC8no3SIBShyydM
         ++1sWbVzXvrnv+tJ+GIhHJLdSdH5hMrWf25NZ4IZYwuZaLV4fp9HNR/DJA0gjwnG9V9B
         FggAcKoalYScBPLNZjrlfd7p+ZV3mlS27IOTljAYSeLmBnam9FW4dtWgRZHPj2LBJIJH
         qhT8XlLluzVPDx+3G84Z/I0L50e1Q2cIiS3LVDYAOv5IuX9P0+1amv0koxNypjVXD8w6
         p+zg==
X-Gm-Message-State: AOAM5326gHJ5e7fTeAlPZ7ds0Q37t39fsm4xSlpwMmEDhtPF3QtW5s2F
        P5KYn8uUAAF5vIcBmXQOM98=
X-Google-Smtp-Source: ABdhPJztiAcRQh7p/ClIJBuHfez2AEMMXCTsdMSMBC4Td5d7BPxH5WfMmKCJzklWQaPEOzC8h/Y5PA==
X-Received: by 2002:a17:902:6a86:b029:d3:b2d4:4a6 with SMTP id n6-20020a1709026a86b02900d3b2d404a6mr7936444plk.73.1602172391044;
        Thu, 08 Oct 2020 08:53:11 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 016/117] mac80211: set DEBUGFS_DEVSTATS_FILE.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:28 +0000
Message-Id: <20201008155209.18025-16-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 97eec43a6945..adde0b2797c9 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -542,6 +542,7 @@ static const struct file_operations stats_ ##name## _ops = {		\
 	.read = stats_ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_STATS_ADD(name)					\
-- 
2.17.1

