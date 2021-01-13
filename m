Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AFA2F4B11
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbhAMMNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbhAMMNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:10 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39C0C06179F
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:29 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a12so1856699wrv.8
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2/6Viei4wUAY+PsK+PLnXLv1pWrXcOkQrAGShU5Kxx0=;
        b=aCvq8iXZdjuUWvW7dTYgMdsItdhNtG2eb+XPfDTlHe/Z2LH6srjt30M/pBh35TF0kY
         pwd9AtKft2XUOXusNn4SkFUkjWYALgvpbUz+GCn3UrxChDOy1MESKXZ1jDvSQgJAt107
         WcHEoPFKarrz0AxQpMMfkBuW+b21m5lxjFx2FG1eA42Mwg2gTvAmI1HzoVUkzcCujyhJ
         R2tO0hanqESY5EydvcOtay6YjzevEfjVb5MHb3mRSSQpKJ9Oefxs6idpC9PO1VXYlf7P
         FNZHiFcEPMOO+hFU1ifOQjfBcPV1+xqb+vbfU8XFAh25/yAU+yF7ODzvdtkwZxBIco1Z
         WHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/6Viei4wUAY+PsK+PLnXLv1pWrXcOkQrAGShU5Kxx0=;
        b=N2CiaF7f4xa4b4jaPehKReJqrz+pM9/p58yvEXVbQTa0Mqzkp3jR0XoJEIeKfq2t0t
         DhgFKKS19QnRwzi5vVR7HRo8uxD4pt8pfC7XmbO8cXTVA+zTUmWLlhHYYAi7TsxPZc68
         9FcKjSBWjAfQDGFsOxTDdfHJJyXjurXi6F4p8jcSm8nH6dJMb+gBf4WcZbiyVcf+6saZ
         381b+QkzSJcUy5M/HycAwna7WFLJrxUSp6+jOiOo9EBdTJgYn6fKp2CIoPOa50SmHUwH
         khQwjIx038U52Pipz1DRyNKVTr9TW5ZNsjd/yNkUknCUSyGX+Qrj0y0GIcLtXK1v9g6g
         6Apw==
X-Gm-Message-State: AOAM531VspmnRZbqJWcK0b5NWyn3s3lx681vH9dPNsXO75gQcwrWMag+
        wQl6Q5YfcTPorTAKRIW3debekFh3duYVkOqw
X-Google-Smtp-Source: ABdhPJzHNmitR6ByHql70eU9T1mupHyKJ7wwagKU8dtNCUQ3dMRuEPuAVuc4TiyRa4zSihoZuZC7CA==
X-Received: by 2002:adf:92a4:: with SMTP id 33mr2274641wrn.347.1610539948324;
        Wed, 13 Jan 2021 04:12:28 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id v65sm2867470wme.23.2021.01.13.04.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:27 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 04/10] devlink: append split port number to the port name
Date:   Wed, 13 Jan 2021 13:12:16 +0100
Message-Id: <20210113121222.733517-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of doing sprintf twice in case the port is split or not, append
the split port suffix in case the port is split.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9c76edf8c8af..347976b88404 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8654,12 +8654,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->phys.port_number);
-		else
-			n = snprintf(name, len, "p%us%u",
-				     attrs->phys.port_number,
-				     attrs->phys.split_subport_number);
+		n = snprintf(name, len, "p%u", attrs->phys.port_number);
+		if (attrs->split)
+			n += snprintf(name + n, len - n, "s%u",
+				      attrs->phys.split_subport_number);
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-- 
2.26.2

