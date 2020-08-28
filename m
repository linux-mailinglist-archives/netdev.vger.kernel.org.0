Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBA82554D6
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 09:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgH1HIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 03:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1HIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 03:08:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5932C061264;
        Fri, 28 Aug 2020 00:08:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s2so111425pjr.4;
        Fri, 28 Aug 2020 00:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QKDUbYPcPEh8IBd+SIHE5bvSSUow+Zho8PuNcnzF93Q=;
        b=oEsScVLblMKfSEP1QEYR9B1R6dZSAtZAbml7BDMDCoTnWnSyNFtCGBgqKMjF88CEGX
         G1FtgKUHMZfM1L3sjghPQXJ5WFFqBXjx9HIQoht/Dw+CL4vDyJNddadzkScAJLKIhHX+
         5h8qxdXVjEx2gYOLZtDEQ9Wr89boL8zXto4DFFVsBhAbpu2zrkdm4a7FY9RV09lJl1+O
         LydZLXT1Z1ZGuMXvS/uhWs1oqtTZ43muGe3vn8NWYi8VdrZloKnlK/qKf7/TX4/h5N/+
         YkYG0hhWGobNv+UTexKHNpOODDcCZqUCdbQOBoOmaQvkqclWP+9tfODYuiVCRDWlfwZM
         qASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QKDUbYPcPEh8IBd+SIHE5bvSSUow+Zho8PuNcnzF93Q=;
        b=fUtrceJimXtMigglEynuSf+Y4ZoQ0G9wl7XhX4TnVDrqXofcpk0QC0Nb+SrUW/jxQn
         3xktsnnefhbyEeM67e/+rrnkD41zyiQT/IrIXAKL/mk/pIjfpL2qYwmX1YYMcYl3iiV/
         RpH5Wa9VwYkPOjGk+YdfUzeh54Om3CrAzEEofYCghnlKMrkE6xA7BiI4HDhABdD00Slp
         q+JuSJ4XqY10gb+YxYQFcvmJoxzpWzNz0OJqDgtJegpIwp3q2vtqF4/79nlMhKG+gEFm
         VOzTfWsZVyPDxgotg2rwYwXVS0cDGbv2Q6qhAIWCj47G1xBDDrW+WfIG9Zbeebnf/hz0
         rVeA==
X-Gm-Message-State: AOAM531TZqE0T7qb2n6QW0gpFRwxpFR/KFzuCGPxwtZ/DyhRM93FnJfN
        1MyHzpGjLL/aiS6J771TB70=
X-Google-Smtp-Source: ABdhPJycyDfw8uZMHIfKVJw+n62ExArLbwu/fPa6q0T9K+JFC5wpBeyzT7hhgGdJrVE1mF1p5FOdlw==
X-Received: by 2002:a17:90b:1b12:: with SMTP id nu18mr72152pjb.126.1598598492452;
        Fri, 28 Aug 2020 00:08:12 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:b81a:ad7:9450:beeb])
        by smtp.gmail.com with ESMTPSA id i1sm473447pgq.41.2020.08.28.00.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 00:08:11 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/hdlc_cisco: Add hard_header_len
Date:   Fri, 28 Aug 2020 00:07:52 -0700
Message-Id: <20200828070752.54444-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver didn't set hard_header_len. This patch sets hard_header_len
for it according to its header_ops->create function.

This driver's header_ops->create function (cisco_hard_header) creates
a header of (struct hdlc_header), so hard_header_len should be set to
sizeof(struct hdlc_header).

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_cisco.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index d8cba3625c18..444130655d8e 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -370,6 +370,7 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		spin_lock_init(&state(hdlc)->lock);
 		dev->header_ops = &cisco_header_ops;
+		dev->hard_header_len = sizeof(struct hdlc_header);
 		dev->type = ARPHRD_CISCO;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_on(dev);
-- 
2.25.1

