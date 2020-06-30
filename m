Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98E20FE5B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgF3VBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgF3VBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:01:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAF5C061755;
        Tue, 30 Jun 2020 14:01:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so6507222pje.0;
        Tue, 30 Jun 2020 14:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mkOAB8z32J6Z2L4bZ6WIKlHYAkU+alvSVGgHUWyXWTg=;
        b=EjZg25Cp2sT9iYula4AwDwMjdrsNhh3Z7BCiQT4+Pkv9bVWEuqEZD19KhhZ4HNK2Ns
         V/tFc+BM/vuWBlB1whIiL0Y7boAZhuFbUiFgh7p0Wjg1zZa1Hf2jy2rs1xW4h1NrrSww
         66u2HyrMGI61qe85aN/5K8P86YbTW/Wtwzlmpt9N9i6pgVd8mNqb90sUXJWciuGRJRiB
         DH/BPtMqq4q6agM2wNhr2+sugkklsCFJ4+Bozl6epF6SQuzNiIkPl5bhWeS0+LWD/8SW
         yaM4xPLtzvXS7TN6MCrHWC1DuSA8L3ApTOTdwixYMW9EvhNEOT8spAtE5ik62GjBZMEg
         cqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mkOAB8z32J6Z2L4bZ6WIKlHYAkU+alvSVGgHUWyXWTg=;
        b=Vz5wHDJrIs9cpEsdGuCd+vm32vH81fV82DQyQCVFgCT+gq+tSp1q3TlL+6Y8zUCgyO
         LtakwDMctmjR35CL43QAVPib0q85Ly9HL02ApdkAcSe3/Uz+fQ/oaKfnIi4GR3OMGU+Z
         9jQAoy/SeoLCh9DgOVrJpAf7H6IxE/JVzseRGU/FqIDaFL1kldic2iPwsmEitoixRD9X
         Nz4/X+nmA/yZvz7jeik9spNuEwv7CI5zPVYzaNGes0mAf1QoB27WDb5nDdCpPz6oMiib
         n5m4ovbL4gMQrbnWcd6hnk8HTWW0m8peZOlNJ7i3YzOn0lj4feSCBTF8Fgk4Jk7nSVC3
         dx6w==
X-Gm-Message-State: AOAM5335fB8l9jDppPHeL4muwLpsE05YHXN143eCQnHPeEY1fYj3fBpK
        bS6Dj4i/J1jfXo41XRSKv6Rt7Enw
X-Google-Smtp-Source: ABdhPJwAAxFf+8JDsTagoryqO7/Gr2RWnC+YC7W6M0nJxV+aeBzOkzFxj0O0zNpjLH0fHn5rhtDDYA==
X-Received: by 2002:a17:90a:b25:: with SMTP id 34mr22768335pjq.220.1593550871906;
        Tue, 30 Jun 2020 14:01:11 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:1000:7a00::1])
        by smtp.gmail.com with ESMTPSA id c19sm3070079pjs.11.2020.06.30.14.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:01:11 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Don Fry <pcnet32@frontier.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next 2/2] pcnet32: Mark PM functions as __maybe_unused
Date:   Tue, 30 Jun 2020 14:00:34 -0700
Message-Id: <20200630210034.3624587-2-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630210034.3624587-1-natechancellor@gmail.com>
References: <20200630210034.3624587-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In certain configurations without power management support, the
following warnings happen:

../drivers/net/ethernet/amd/pcnet32.c:2928:12: warning:
'pcnet32_pm_resume' defined but not used [-Wunused-function]
 2928 | static int pcnet32_pm_resume(struct device *device_d)
      |            ^~~~~~~~~~~~~~~~~
../drivers/net/ethernet/amd/pcnet32.c:2916:12: warning:
'pcnet32_pm_suspend' defined but not used [-Wunused-function]
 2916 | static int pcnet32_pm_suspend(struct device *device_d)
      |            ^~~~~~~~~~~~~~~~~~

Mark these functions as __maybe_unused to make it clear to the compiler
that this is going to happen based on the configuration, which is the
standard for these types of functions.

Fixes: a86688fbef1b ("pcnet32: Convert to generic power management")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index d32f54d760e7..f47140391f67 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -2913,7 +2913,7 @@ static void pcnet32_watchdog(struct timer_list *t)
 	mod_timer(&lp->watchdog_timer, round_jiffies(PCNET32_WATCHDOG_TIMEOUT));
 }
 
-static int pcnet32_pm_suspend(struct device *device_d)
+static int __maybe_unused pcnet32_pm_suspend(struct device *device_d)
 {
 	struct net_device *dev = dev_get_drvdata(device_d);
 
@@ -2925,7 +2925,7 @@ static int pcnet32_pm_suspend(struct device *device_d)
 	return 0;
 }
 
-static int pcnet32_pm_resume(struct device *device_d)
+static int __maybe_unused pcnet32_pm_resume(struct device *device_d)
 {
 	struct net_device *dev = dev_get_drvdata(device_d);
 
-- 
2.27.0

