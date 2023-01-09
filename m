Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8FC662F3A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbjAISfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbjAISdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:51 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F23B63F61
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:32:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so13675973pjg.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toMP38RUz0n/Vf2/BW5zHRNWz3IaMqsFrcQNsREKqnU=;
        b=t1FEnjiuk6d0yNJMM3DGP4k7oW43aQQWYrdaoUo9whzkcFLnEWtZnvzOFkYJyAjFag
         PIj4Nsyf6jD3cE+E2DCQ9ugzztBSLvNSdL4V/NsVc4AEBWN8xdTn+q67gA4XYanayvyR
         sHhDfy0piu1rH3af6UUGEWrCMze7osgrKwhZXYmHJceICtneh+tBlJh/8C1AvdmvgtEf
         GdlMmJq9CL8DuchoFHqCE0x3G3iOvoB2GzOiuVDvxsZvX/uGQhORigog5+jI7ha3wur9
         ukpmSj7YQZFHeazB0TxX/eDB5HrwW/yV4oC3oeixZGXC1XBIZADsJ0hFOggsS6G30Nm0
         DjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=toMP38RUz0n/Vf2/BW5zHRNWz3IaMqsFrcQNsREKqnU=;
        b=Ki7tPGr5T/PLT4BAxOEoHIAmVsljmGydL+YHsIJYP0ot+aaaH6uiWT8WfEaqjRZxuE
         oCuZ/KJWoldrERE9/IhjyKIPqgg95ZNXagSShB5NwQn33j72rLYtyl6QVdV6B7OV2EJM
         4wAKnM85QJgty3Wu+nR3jsF4SbwDLnYmDf9FLDPBF/c6KZqNHgGUq3Nwglfv0TNAfC5O
         xJU4ANNZwAkUoDX6Nfolq3fCTE2HOK6wB4YeCCx6K5HNTmhKm5c4Jos/dfx0Zx7TqeHH
         eA94J07utbVnWqxG6itVSAWBCy0ydWB5X53lTLNJ5zxISiw3p7PyKdOG1K/muoqzICHu
         O4+w==
X-Gm-Message-State: AFqh2krV8+mHgaD/i5CSO4HC2+fdSg+x6JJJwIGQEvKb0PYST+tqJ0aV
        Xk/dJMBz+2AtuEHMpXq3HAWmmAUJZtjHvcAlNEDJWA==
X-Google-Smtp-Source: AMrXdXuBcZcr4ln5WV1u47elCgkbHic836Lf/b7KJSnrAkBiWnnF2QdjtN4XG9U5mNk4BROch3Xkkg==
X-Received: by 2002:a17:90a:1a41:b0:228:cb21:5028 with SMTP id 1-20020a17090a1a4100b00228cb215028mr130449pjl.10.1673289122901;
        Mon, 09 Jan 2023 10:32:02 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090a154700b002265ddfc13esm1556691pja.29.2023.01.09.10.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:32:02 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 11/11] devlink: add instance lock assertion in devl_is_registered()
Date:   Mon,  9 Jan 2023 19:31:20 +0100
Message-Id: <20230109183120.649825-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

After region and linecard lock removals, this helper is always supposed
to be called with instance lock held. So put the assertion here and
remove the comment which is no longer accurate.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 647deecd1331..7c612c5210da 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -83,9 +83,7 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
 
 static inline bool devl_is_registered(struct devlink *devlink)
 {
-	/* To prevent races the caller must hold the instance lock
-	 * or another lock taken during unregistration.
-	 */
+	devl_assert_locked(devlink);
 	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 }
 
-- 
2.39.0

