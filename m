Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CFE2448E4
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHNLjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbgHNLjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:39:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0033EC061388
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id p20so8088243wrf.0
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y77AtHzguUcJCUMjPrpTvjpVQ3AGTioiQPnppwV8VKc=;
        b=iFWqnNShFxm/D8776BXHu/qVGwFhwXQ+8rfUFDSN73HTnVGrhjwoT90p1MDlIfUelr
         4u5AzjJC7607Eg0uQQQH5twyO0MQz0DNNC4vZ/3VLlLRboWX+XlyFs04QvCJ7lv/HAb/
         O71kBtX1paMcjGcapsvpmQJL3lS57YAx1xLl6qEiFielydjRTzc6DLCoP7sU21grqzGO
         fvp3qnjdaBwwnF3Xl9p4MQpF6U4WSieWI4Ta2lJCCqQShezjah9feA0i6wVahmIWiVIV
         1PcdyBRtW88tORF12WPdEw244Xm6tUELNaiz5HfmsnpjpxY0m8jhUFgL1ekx1ZZp5VnC
         BPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y77AtHzguUcJCUMjPrpTvjpVQ3AGTioiQPnppwV8VKc=;
        b=gXfLU3L3vn5S3XoeP47XoKdhzvcqCoQ5X395/gQXhbahHbVqhAVO+6/+TPZ/Wup98V
         mesCsMZUZA54gBgyTdI2dJmxfH3DYoxg5FF8L2N5OooGtB/6NJbDGz1PQLdH69u+JONi
         49xSzGaBQzwaB5uItKiV47H+/fpdE5+6anJfu2lFS4LTqXyXjYAVG8HUzgXcVhjrdoM3
         icF3ExPxbtDRdpmNNMwIjUuXj0ymRD5J5Wk7vsvG0ChT1QZC9XTboydTodEjgZBKOykR
         gp1UEehTrVEPQXBTZ7vqZGHPloV7VAPYKFQxCz/lMOlHQYbEfJ04xxxGG6Qqf2F9kUkM
         LEsg==
X-Gm-Message-State: AOAM533wWX9AJQdaGNjxNNxp3j0FNCUQ5sC5WCdYh2Jj1iHeRngQMoMT
        z1VrgSaUgKwE6Z8fQe3HE0I/9Q==
X-Google-Smtp-Source: ABdhPJzOO5hb0FwyFDV+Y5ePxRrJMQlbWLrBFcALYFBIbUTV5cFeHryeDHp37n3PhcwIn4sRkgmkSQ==
X-Received: by 2002:a05:6000:1149:: with SMTP id d9mr2276259wrx.335.1597405184635;
        Fri, 14 Aug 2020 04:39:44 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:44 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH 04/30] net: bonding: bond_alb: Describe alb_handle_addr_collision_on_attach()'s 'bond' and 'addr' params
Date:   Fri, 14 Aug 2020 12:39:07 +0100
Message-Id: <20200814113933.1903438-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/bonding/bond_alb.c:1222: warning: Function parameter or member 'bond' not described in 'alb_set_mac_address'

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/bonding/bond_alb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 095ea51d18539..4e1b7deb724b4 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1206,8 +1206,8 @@ static int alb_handle_addr_collision_on_attach(struct bonding *bond, struct slav
 
 /**
  * alb_set_mac_address
- * @bond:
- * @addr:
+ * @bond: bonding we're working on
+ * @addr: MAC address to set
  *
  * In TLB mode all slaves are configured to the bond's hw address, but set
  * their dev_addr field to different addresses (based on their permanent hw
-- 
2.25.1

