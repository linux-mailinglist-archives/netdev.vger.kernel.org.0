Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563F0381243
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhENVCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbhENVBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FB2C06134A;
        Fri, 14 May 2021 14:00:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v5so47237edc.8;
        Fri, 14 May 2021 14:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXAbPq5h3YA9NQN4q/AURsjkpOOLQrTGRK7wcDN+KLA=;
        b=uiqsts2V4vvFMMFhYnJq3AMjLXaqgxYcY3YxhkgPhZB5t45aT58TqCdeU6q2SEvoHK
         gZNftdm2nv+rq+GHbIRSaPcg7mmaKuQYLu2fgBOy0ZgJjmg2S/eerHZAQ3kp+ekWbGG9
         AlNE6TIV/EG6uS3qpZ1osqg7NZtG7Cha+k2HByexjfA0bLWXOTpUe52tz1W6TA7eq9Hq
         jn6vMyNgsEdv5c9WKug29PM4xDLJcr5sAnwMtulNNvtlqg/6eyR4bX5fwn0ZpuY0RfK9
         hUIv3OLCGuWbN1BQKzgnIgkZu3tO+6egf/bw+Yvg7dJI41kXKwK1YtdC+o0Xyo2c/5KO
         RVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXAbPq5h3YA9NQN4q/AURsjkpOOLQrTGRK7wcDN+KLA=;
        b=HUbZ92g/gpe5i8gxMRVJBOplC5ipNrIAZi2/friEwSh1NB1zaxU9uTieK+v2VtwhBl
         JMAHw0gx48FzfpGxYF36NrrN4WoSZgNe0NQYEehstk4RJkBZrlQ4ck5HlI3GmOv8Dq5B
         Gy+8YZ3XjrNqIvMtlF1SKqqxCfBC0COPPV4lKj71D+4py8+serVJTHalZDJ85QgzNum7
         uoZF+29v5Bhov4dIvEt20bqZOFxzBgbn1e1z011+CClEXGyF+p6guZR/ZwrlrEJDekNj
         7VLCxD9vG9bCUUsRpjlveEJLZfi9RaojBMY6llkrKNhFmH7AFqqUFMc13BmGlhY2y57M
         hXWQ==
X-Gm-Message-State: AOAM5327OmEEGj5Lis9TAyOahtHmtw1KVfHeoTz+dRfvF9D+tQhgnSlP
        OXx1ZE4tZw0kBBQWf5FrWIKSqRAiSlzF6A==
X-Google-Smtp-Source: ABdhPJwvVwXNdhG0DcfQ44pCWwAgM2nuQIjiJRMYQPEFzRowzgRcPYD9VUvHNA7wycDCoMAAubC1SA==
X-Received: by 2002:a05:6402:17d9:: with SMTP id s25mr26604736edy.337.1621026026088;
        Fri, 14 May 2021 14:00:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v6 10/25] devicetree: net: dsa: qca8k: Document new compatible qca8327
Date:   Fri, 14 May 2021 23:00:00 +0200
Message-Id: <20210514210015.18142-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for qca8327 in the compatible list.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index ccbc6d89325d..1daf68e7ae19 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,6 +3,7 @@
 Required properties:
 
 - compatible: should be one of:
+    "qca,qca8327"
     "qca,qca8334"
     "qca,qca8337"
 
-- 
2.30.2

