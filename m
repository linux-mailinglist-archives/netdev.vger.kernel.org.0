Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825462A751B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbgKEByn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKEByn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 20:54:43 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A63C0613CF;
        Wed,  4 Nov 2020 17:54:42 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id k7so4725plk.3;
        Wed, 04 Nov 2020 17:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MoRDkYbSmmfL4fW1DuwGucYPQIYt/1BQrIe70jztWfg=;
        b=olkhqDVQyfSX+tNsHVJ1jhZ1Y4LWHsJN3A4Tj4GUyfvWQybxvIhNejCvOLIPbOGlEb
         XeHZC8Nj2O3V8785hlvNd2YwpG1e4qWf0qRzAPGuJjNCzkPPqOtmMDm2qdISnbs/hNh6
         kvrTAhjRiJIHM3GLW1b0EWI9C3VwXyyxh7+MSltPh0h6e7YEnUbvuKGb2tdgwEXMWN49
         H/Xah66SEQO1/6IYldqH05ZaSSU0W9xFqaSfDeGqjnVqNIbqDkphCaK8+ZaRiBnBCb1Y
         dNzpZdGynpoHxdaco9Rw7mZmKw01WipoiAdaaDQ3H+LiNUFJOjJ9NTazsrmwdAZPzXK6
         oEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MoRDkYbSmmfL4fW1DuwGucYPQIYt/1BQrIe70jztWfg=;
        b=VM6b8uZsxG1bhhb+njV9ez/JABtBZd/+r5QhOC+DJGPTBKpSkGmt39dHaAdZBjdxwo
         GK9+8aDQLECrO2ykQhxwjWL8oeNo6/mdsAmOXS5x6kNjluZrKx80nV5jNUXdrBKGGpl0
         BGmKdHB6Zri/UdBNLn14C3U1NlcM7cJCDlaDYL3qJGbBaiHxhCW4f7b21lgmntxz+0zB
         x/Y2BvO9XBAouWuFAekCCsjLbvcI2YhX8sJZK/odbkc5Yknja9tyfCqRV9Z4/h9C/zFF
         ibyxm397FFat1Y86wZpRXOMdsbUqF5CSDMQAOoqwfVHzgQ4qFjmXRLwAdNOejWitMh0J
         i1fw==
X-Gm-Message-State: AOAM531sOTK/3Oggq/wqi9TmsHibG5xHrpaRUgnqq0xGvqHYfh+QFSIL
        n+3a1TEsuNl0PfDvzX2CnW8=
X-Google-Smtp-Source: ABdhPJxpUvGVxQXb3TFxZR5nuGXu25j8c97cnCBvdXOOBjjkY3/Q8S9LZx3MdjiiIMDa5lk8UqcXYQ==
X-Received: by 2002:a17:902:9a46:b029:d6:f20a:83e1 with SMTP id x6-20020a1709029a46b02900d6f20a83e1mr37293plv.49.1604541282551;
        Wed, 04 Nov 2020 17:54:42 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id t26sm153008pfl.72.2020.11.04.17.54.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 17:54:41 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingtianhong@huawei.com,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2] net: macvlan: remove redundant initialization in macvlan_dev_netpoll_setup
Date:   Wed,  4 Nov 2020 20:54:04 -0500
Message-Id: <1604541244-3241-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for err with 0 seems useless, as it is soon updated
with -ENOMEM. So, we can remove it.

Changes since v1:
-Keep -ENOMEM still.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index dd96020..d9b6c44 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1096,7 +1096,7 @@ static int macvlan_dev_netpoll_setup(struct net_device *dev, struct netpoll_info
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	struct net_device *real_dev = vlan->lowerdev;
 	struct netpoll *netpoll;
-	int err = 0;
+	int err;
 
 	netpoll = kzalloc(sizeof(*netpoll), GFP_KERNEL);
 	err = -ENOMEM;
-- 
2.7.4

