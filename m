Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F8C287849
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgJHPxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731454AbgJHPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:14 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DD6C061755;
        Thu,  8 Oct 2020 08:53:14 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o9so2947771plx.10;
        Thu, 08 Oct 2020 08:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0GBIGnkeb8hxg4Z2SyWOu9N3DUwNWWvvWeAFenzOnsw=;
        b=plSBdPyXyaCzHG9iyMo/N8xqmAVVxcdpYPd6goD+zGqKcylDfeb6Zk0qhUrKEzR85/
         hGRaHdVVqK3EmCvSZxkdGvlGS8KFApKsSoQBh+DJRJEFPPwS2apccjFq8VROo/PyrY9G
         6UHoSQH2xby/Jj2DtbFDYBoLg8ol8fDu/KUp8sF5WyRbTEKOVBasJizuT/LTCOXLllOx
         RsmHprOa/u1JJ3eOPWav+dU9A74u5jbb1lJGzCes1/rBG8p1wZekEJl19AFzs1rfu+1C
         atIJjKBUB59FfI7HTX5MV6yvKIfrraz5pMBoVvP7jWHUnOFJn/1UTzEZdh+fIi7DmtL1
         uU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0GBIGnkeb8hxg4Z2SyWOu9N3DUwNWWvvWeAFenzOnsw=;
        b=d01ZAvWDY2TADkYp7hC7t4yAcbJsaNIlibZZRUncKhDcvHdrIwuQqKYybvZAAXIHam
         NnSef9Fwt9itjQiSgL4mU75a2gweoDUlOh+0vxyegkMauEbOGFjEy+x4uLHUE93F+My+
         CHJRVp2Fzb1ntbl4PDsWK0z5XuOxa8ED/mTg3AC+5ZKL4oWFnGomaqmbOLK/TTN67Dj4
         JOD5VoVTxaZJ4IaS9mRF4YcCRNwMikGPbrsdSV44SWF/GJx410cxYx5CHUMXWrwBl0Cg
         3qLly2DCSDuDDgVSvzpvTGdfSYoSl8qafPLW1T1lHR9V05V5ZQx84URdI3iyZKlJe4vJ
         NKrQ==
X-Gm-Message-State: AOAM532ldRDp9NHDuywTyn3YNXUIkIbhnaSzfZF4bhtu8uk0BrcpjbDI
        zq8hZeFR1kozplhpI+XRJccjwpM62so=
X-Google-Smtp-Source: ABdhPJyX6CdpCYL607GjhwX/nJhpiHHAfe+XcFzMjFPsuQtLMzofh1BoUFNP+r7ECq/9jWneD7xN4Q==
X-Received: by 2002:a17:902:b592:b029:d3:8dc4:391e with SMTP id a18-20020a170902b592b02900d38dc4391emr8453849pls.76.1602172394388;
        Thu, 08 Oct 2020 08:53:14 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:13 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 017/117] mac80211/cfg80211: set DEBUGFS_READONLY_FILE.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:29 +0000
Message-Id: <20201008155209.18025-17-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 1ac61302dcd1 ("mac80211/cfg80211: move wiphy specific debugfs entries to cfg80211")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/wireless/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 76b845f68ac8..a00ebcc552e9 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -26,6 +26,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
-- 
2.17.1

