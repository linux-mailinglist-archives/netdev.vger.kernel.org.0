Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168663A5B7C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 04:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhFNCNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 22:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhFNCNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 22:13:47 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9FAC061574;
        Sun, 13 Jun 2021 19:11:31 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id w4so12266674qvr.11;
        Sun, 13 Jun 2021 19:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=/pYpS7z9b3a/6qRwLgr21klDpDKmQtlWnOviQqkYZ5Y=;
        b=MXFiXfB//FGQvrfCVcyKi13yZLX8QO3gQ1Fs8a+3hEVU+pqPP7gM0F8+tFH0i61t1z
         a9OS7MAgUfMo4ti4QzqUs8m63FSCEYOHEZwTPrZuk+0nbW9/lwXyelMxcwzXsznBm0ge
         /FJ3NDdxgT5PHQggefPEe0VId1ROWsP28XLOLKyyf5LfECNU5eIFfetf4GaWNjxxREN6
         wfPWARvyXRWxNYkSzTCWhzsEQHquYAsoMqeljVSo6At7Zuhk0J584TDYFA0sMaRH9ZOT
         ChHz4ax7eCED4sgUbe8AQKUtUpKngCIuYB0UdKqj4ghFpzesfNw3YbINupGepEBWOPqf
         FPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=/pYpS7z9b3a/6qRwLgr21klDpDKmQtlWnOviQqkYZ5Y=;
        b=r8CzcGkDL+ZIegGygQty0QAxUidHj0eoKiVERaEOCZoP+cqR/MhVFtOx5UJdGuiq7C
         6+/KoPXAgNv8QdWD5pq+lNGcu4NCzRsHwXeo9u6k/9ehP0dDiM4oCXPUZ8TcEpqGgRuR
         Kux0mVGjWXY4tZsVVM+fQZeDRdav0N/tEy+NGM7ScDOIs9amIvLL5MRyeiI8wPskcnOr
         q8oWn4CuQ2URbJTibffvFzaBmLu36j+M6xF6GpjHDN6GyisR3OAwBB/3PhwgEP+KA+Ng
         ZYMyu4NA1TVgNChi9b0E0smSUyJqnZq+2EFhkpFWomCmEKPmrwa1mINxgs2ZTFrT80bQ
         cmTA==
X-Gm-Message-State: AOAM533lbZ5PvV713QgGLE2Ggeo2r+bH3vVk2Ww+fraqaXsqzSuiq1BY
        TmWfzT/RnZ0OKvYVjm7JYy16rnvsYFR+6zyxRb4=
X-Google-Smtp-Source: ABdhPJwxRYJeq9Jsx574+RgiHVOKhUsOAnplR8AyrKgoOtsl57ncyd0oeoda6WAU93g3Y6VdAofllw==
X-Received: by 2002:a0c:9e68:: with SMTP id z40mr16402873qve.17.1623636691013;
        Sun, 13 Jun 2021 19:11:31 -0700 (PDT)
Received: from tobias-VirtualBox (ool-18ba8988.dyn.optonline.net. [24.186.137.136])
        by smtp.gmail.com with ESMTPSA id o5sm8747078qta.51.2021.06.13.19.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 19:11:30 -0700 (PDT)
Date:   Sun, 13 Jun 2021 22:11:30 -0400
From:   Tobias Alam <tobiasalam@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: change msleep to usleep_range
Message-ID: <YMa60p5dl0LMV/9D@tobias-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes msleep() to usleep_range() based on
Documentation/timers/timers-howto.txt. It suggests using usleep_range()
for small msec(1ms - 20ms) because msleep() will often sleep longer than
the desired value. Issue found by checkpatch.

Signed-off-by: Tobias Alam <tobiasalam@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index b70570b7b467..87d60115ac67 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -553,7 +553,7 @@ static int qlge_run_loopback_test(struct qlge_adapter *qdev)
 		atomic_inc(&qdev->lb_count);
 	}
 	/* Give queue time to settle before testing results. */
-	msleep(2);
+	usleep_range(2000, 2100);
 	qlge_clean_lb_rx_ring(&qdev->rx_ring[0], 128);
 	return atomic_read(&qdev->lb_count) ? -EIO : 0;
 }
-- 
2.30.2

