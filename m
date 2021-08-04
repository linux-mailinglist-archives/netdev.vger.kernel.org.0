Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE4E3E0A15
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhHDVn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbhHDVny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 17:43:54 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65729C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 14:43:41 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id l12-20020a05622a050cb029025ca4fbcc12so1667230qtx.18
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 14:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AwsLFRNlGxJIFr7cp8dQzR2jonWQto7eXPKd1DAWM8k=;
        b=GRG78+fJmlHfVLzal/VXwzQ2vpU/DzRYWANQDOLLoyoCMf/2xn0WDoTYfR5iqtshRn
         TkU5KlJ1ODhic13FW78XCrW8lXqZ+3/BJX5z7JCXi8rKRHd/CKdfMbb/50YSRBAqNN78
         0RcmpBw/Si7E2B0cy4j0Qpst38Ci8GUY0j+p42knlEDMomFJ9TwaOFmHACvhSZobdLk9
         vNw9TJegwm/jkJD8agKysHcEMgS6XrepmPfCixVii4gb95he1ehHVQ4rfazW8vS9pfJg
         5XYhuej0hjCK7Q13RNdQV3wIH27N3ONjpRQQvrInfuixRHEZue77roYBWvakxAytUbpu
         c3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AwsLFRNlGxJIFr7cp8dQzR2jonWQto7eXPKd1DAWM8k=;
        b=khmeL4Q1EgSSjY9KXYFmvTyqJu5fj29iGBizPygOWhmqJDKOuxO9sUHqOF6uDGZWX9
         XbytY7x/EckGTSImJaFN6soat/RguslhGAABmyKHjxaKA4nSt3C2+zKi1eRJQAqF3ewK
         bU+Rkw8c8RVaJW4q1Yt5ZBPosbnpId4UVLpxkWeKTyW0wJDTaR1OuSRn9uy8XFBFpvUV
         X+xfsd6C2RAqOJhepybgGUvU9kOZHxJXSdibFg3e6y1wtYqkFaU+fWDruq/9ueRIqe66
         ccsaXOU2k7iFAxhKqXWuqey+30ve5xuG1uXBcZCmzKgYMEyqOnNaE7b9cWpkXyEwyglR
         L3Tw==
X-Gm-Message-State: AOAM532489KXOcZfKZ0a544/VUiAowwos+LhE3+LJMuc1jajIPOrPGoc
        zKEwulqYgDaZK0CH7L1uCoAO1CNA3lYI9vo=
X-Google-Smtp-Source: ABdhPJy5wZd0qQwrV9lCLdjeIDeQNAv67eI0v/xXRMMJ0vMhK3kTkn9YKHcCF8ffmOpHeh2yTDYAjwMPplHfzWk=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ffe5:1245:526e:3189])
 (user=saravanak job=sendgmr) by 2002:a0c:d68f:: with SMTP id
 k15mr1675008qvi.14.1628113420519; Wed, 04 Aug 2021 14:43:40 -0700 (PDT)
Date:   Wed,  4 Aug 2021 14:43:30 -0700
In-Reply-To: <20210804214333.927985-1-saravanak@google.com>
Message-Id: <20210804214333.927985-2-saravanak@google.com>
Mime-Version: 1.0
References: <20210804214333.927985-1-saravanak@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v1 1/3] net: mdio-mux: Delete unnecessary devm_kfree
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole point of devm_* APIs is that you don't have to undo them if you
are returning an error that's going to get propagated out of a probe()
function. So delete unnecessary devm_kfree() call in the error return path.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/net/mdio/mdio-mux.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 110e4ee85785..5b37284f54d6 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -181,7 +181,6 @@ int mdio_mux_init(struct device *dev,
 	}
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
-	devm_kfree(dev, pb);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
-- 
2.32.0.554.ge1b32706d8-goog

