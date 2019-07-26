Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3741E764E7
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfGZLvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:51:18 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35642 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfGZLvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 07:51:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so52300797qto.2
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 04:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9gHO9TyKSj0CYwPdw5b5x4szapbbJYZPZ0dkycmRYIw=;
        b=LFvYBGdw1YWcerrJT3heh73/+M4WqEEq9co5TjwQuqGxyxCEJHgjtZZ4/GK42OBe3m
         SUOnTFupw47eCa0+JqoSXEOjF5D/6d0UdWFyfrntb69v1fm3e9kRblWQsXqnWfa/d718
         Xn9+aTgZg47Z+eZEw+lSB5e7kJwFBWQra17NKa6R755mFmvC2KH+8KWwbJUbBcgbKcC0
         Ux7sSzN1PPOIIA+CXLnFwm1eLb26e8u/N9cc6r4ZZIqCjZj+9ZwUBW/9Kc9wbArPeXID
         GltUkdw3WxNnNfXKAVA/nw9H/hh+WApPwOag744pn+EiaNRWoUmjFNGEA3bsFbmLHbVa
         l5bg==
X-Gm-Message-State: APjAAAWijlUJrntHYpHgDf9R9A7dOEz64hBzBssFQbsXQZbytSwPVJ1m
        4y+O4pjZSB9EeC3EBlwOpjfA7EQCtyEGOUn2
X-Google-Smtp-Source: APXvYqymcbOMEQ4lUl13pE8Gi7ZsmsaJk9G/++ds4UPazH2mBxi16XyvfrDkgsSarz23FJllDH4Qvg==
X-Received: by 2002:ac8:520e:: with SMTP id r14mr65932257qtn.50.1564141877674;
        Fri, 26 Jul 2019 04:51:17 -0700 (PDT)
Received: from redhat.com ([212.92.104.165])
        by smtp.gmail.com with ESMTPSA id 39sm28940576qts.41.2019.07.26.04.51.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 04:51:16 -0700 (PDT)
Date:   Fri, 26 Jul 2019 07:51:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost: disable metadata prefetch optimization
Message-ID: <20190726115021.7319-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This seems to cause guest and host memory corruption.
Disable for now until we get a better handle on that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I put this in linux-next, we'll re-enable if we can fix
the outstanding issues in a short order.

 drivers/vhost/vhost.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 819296332913..42a8c2a13ab1 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -96,7 +96,7 @@ struct vhost_uaddr {
 };
 
 #if defined(CONFIG_MMU_NOTIFIER) && ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE == 0
-#define VHOST_ARCH_CAN_ACCEL_UACCESS 1
+#define VHOST_ARCH_CAN_ACCEL_UACCESS 0
 #else
 #define VHOST_ARCH_CAN_ACCEL_UACCESS 0
 #endif
-- 
MST
