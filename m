Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6231C9AC9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgEGTTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGTTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:19:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E375FC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 12:19:11 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b8so2914242pgi.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 12:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYIeEHlwbR9WF7AcFWuRUhAarSzHOe+pf/pZmtiKlAU=;
        b=qtmXirxDYQeLlcxViKvLgIxjDuFa2c7VNp4OdLiI9t5p5cdB5jxkf+G1kFrab6TEMK
         SYxCG88B4eGjmimDB9ZLegIRKl89OcStp8SrvsxmBeOqhkzXIFttF3yRzR4Qmw2sP1Ow
         oq12H96b3eXaww52wVbrs64R0klzb4rQTZ4V2wApuDk1sMlbMtPNUbj2+3GNw/f9K956
         Rxmtj4BsNJpCKxRgCm0bC3Ns4nh2WC3oFeI+ulNoyMyOTzYyxyrPRLBTkJPIIZy6wbpk
         BI5RGzn2/T+UqZXYQluglYOKZfxKKMFlMmxcmN6DKN+bdZAl73HaESVAEYFGBx3Q2GsV
         J5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYIeEHlwbR9WF7AcFWuRUhAarSzHOe+pf/pZmtiKlAU=;
        b=EANxd0PheH5fbwu1fvS8Zh5Qo7gGQf9Ka6IPjIgDQiwn1r2d3prWtVeeq5zJ9cLJxu
         WY4lmJn3NvVxhjH9W9+ZSGYXbEbK953GSoz7vj3Ow7/eDeJSo4LXjWMk26qWNKL1nbvK
         Xz+dEOyerurnIPu3LFh101JAT1KHplOnbEGh7+tMkem9F53KBt6VcSqvX7lJPg5HXE44
         +vaKgc0akPF+nHs5cDbC+HQ8EYdCYgXMdB3PdtBGI8SmTwKYsEliFPvW5lXVFk1gG6Xm
         vbOVdzBLrQDpy0aGNAXzV/T4J0up09+wPPt/6NyOCnTZGqG37ceCl8i+JdcgZYzPO1Mm
         b/Vw==
X-Gm-Message-State: AGi0PuZT6PJ0iYNcRJBL1+18Kl3RaXDJe3vhF7ywUIy3eMPwMoFFh/tX
        zii7vADkaDeL8SkWuwQ81Qi7el90aCE=
X-Google-Smtp-Source: APiQypIWKbSYMunbyL0S2LwdTtGbvU4suupXWHhW0CVZA+wdn36LRIVyUVCEELtSd0ZCxlTIZlgzNA==
X-Received: by 2002:a65:534d:: with SMTP id w13mr1912099pgr.161.1588879151174;
        Thu, 07 May 2020 12:19:11 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id f76sm5517389pfa.167.2020.05.07.12.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 12:19:10 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jann Horn <jannh@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [Patch net v3] net: fix a potential recursive NETDEV_FEAT_CHANGE
Date:   Thu,  7 May 2020 12:19:03 -0700
Message-Id: <20200507191903.4090-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
between bonding master and slave. I managed to find a reproducer
for this:

  ip li set bond0 up
  ifenslave bond0 eth0
  brctl addbr br0
  ethtool -K eth0 lro off
  brctl addif br0 bond0
  ip li set br0 up

When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
it captures this and calls bond_compute_features() to fixup its
master's and other slaves' features. However, when syncing with
its lower devices by netdev_sync_lower_features() this event is
triggered again on slaves when the LRO feature fails to change,
so it goes back and forth recursively until the kernel stack is
exhausted.

Commit 17b85d29e82c intentionally lets __netdev_update_features()
return -1 for such a failure case, so we have to just rely on
the existing check inside netdev_sync_lower_features() and skip
NETDEV_FEAT_CHANGE event only for this specific failure case.

Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jann Horn <jannh@google.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..6d327b7aa813 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8907,11 +8907,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			lower->wanted_features &= ~feature;
-			netdev_update_features(lower);
+			__netdev_update_features(lower);
 
 			if (unlikely(lower->features & feature))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
 					    &feature, lower->name);
+			else
+				netdev_features_change(lower);
 		}
 	}
 }
-- 
2.26.2

