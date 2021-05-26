Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50350391545
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhEZKr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhEZKqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:46:54 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31095C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:14 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so256895wmq.0
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 03:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EvjdRq40i76fBOz4jsz7yVECNUjizAa9DOIRQy20y2o=;
        b=gKocqMWjuJMNUisgE+Sh5hPNxRxOVPp+e7n2Oufp0H05vSqqaZZfZrtUcktLE2ygO6
         gaLrYeR+wCYfAkNlUp+Wy5sKdZBSj/sbEKr5YVEE2KVfdPLo1FUtB4JEUUuDDCTrEK1/
         Og+w0IBO3doTeMGTC7uXXnQhb3UGzBrcSYcArZfp3V/6iWJFV/EQaK0wb/Kco4gYSvq6
         McH5BhPlyguTIR4HqI5cxoUYUVWWrSKIY72S0aobuZlyIth5UK/6uNAamRkf8oILfFXt
         +NZzhVi2omkNbG22X76wfnwtyr1mUtHsLKuf0xp+st27Y34mXd7SjW9BUIXEhBSpLwGF
         w8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EvjdRq40i76fBOz4jsz7yVECNUjizAa9DOIRQy20y2o=;
        b=jztraKyEMA9UXWV3o7waERXHYybcmodNf3ziD+pK0I7MIOx8wHAGb8SxoxTFiYswWV
         wgFc9WWSa8POi1xmAC0/jPM66QTGbMoZ/95JPyt37vcwwn4jkK/QLaAa1jjPSGYeBz9F
         WcPbVyhg5mcKaf0hZSg1kNrNbcATpKvb09yobtVrueFM9NLuDV/fHkF4OTdi9IcmYdMd
         lKAG8XAEtHRZIv6vwIjUVkf7uJAPBPrwt5TQGvjzpuqTCFX/5IgN6L9Oag0+58F62sh0
         SKBIW5/NfI+04xjm0gv3blLRaN5/E3UCLaa8XS2g4OhZ7sJXC2bzDC5uBQ0nrvStVAry
         AFlA==
X-Gm-Message-State: AOAM532rKQz0DlF9KFqc+GKoyFF4vD+70QyrwXtb/Bf1MA0rgacBYiSw
        1bsqH+h6rs26iE7adsIiQluBCobLg+4aX1erecM=
X-Google-Smtp-Source: ABdhPJzvuDxECIsA6kBfghyG9iaMVuc57hx3Mmu4h6Gyj+gWu6AFE/4jD2Ud+4z3BroytnRZ8lZiHQ==
X-Received: by 2002:a1c:7c0e:: with SMTP id x14mr2719472wmc.41.1622025912827;
        Wed, 26 May 2021 03:45:12 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id t14sm3330420wra.60.2021.05.26.03.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 03:45:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: [patch net-next 2/3] mlxsw: core: Expose FW version over defined keyword
Date:   Wed, 26 May 2021 12:45:08 +0200
Message-Id: <20210526104509.761807-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526104509.761807-1-jiri@resnulli.us>
References: <20210526104509.761807-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

To be aligned with the rest of the drivers, expose FW version under "fw"
keyword in devlink dev info, in addition to the existing "fw.version",
which is currently Mellanox-specific.

devlink output before:
       running:
         fw.version 30.2008.2018
after:
       running:
         fw.version 30.2008.2018
         fw 30.2008.2018

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index ad93e01b2cda..b543d4e87951 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1453,7 +1453,9 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	return 0;
+	return devlink_info_version_running_put(req,
+						DEVLINK_INFO_VERSION_GENERIC_FW,
+						buf);
 }
 
 static int
-- 
2.31.1

