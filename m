Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90D660D65
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjAGJtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjAGJtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:49:42 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38407CDD2
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:49:41 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r18so2727592pgr.12
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 01:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyrMFYMpDwJrP4wZGU94xNWhMaXJyPqmR+ydD4RxfFo=;
        b=YD6Zapx1zPTRnQGbslRIpftQgy6kgjQnNscSGeCU64Uv2QBntBA+S2JXBNlEDccSq5
         qAKD4o/YVoTugT+tmNmo4gMtBjpH8vp5H3OAtjl/az0rfva/VPd04y4MoFQHF1C0kHtR
         g7WT0a2Myf1NU13ppUyzNsXxCki1vN8r8HeDp38tdDkN0GK0Uzf0329eS/5dZtHlVklm
         JUrJbqGs9k+19XkeOUcuCODfUooXFj80AdEwgFGmzI4riOY6t9AZhKPu1FbhNMQSl72I
         v3NF4Qi79i0rE2tZ2+mGXz24pZDmVCT8Pc/cq74x3l2R5U4dptrr4JAr2JRIZmPaQDu6
         zKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OyrMFYMpDwJrP4wZGU94xNWhMaXJyPqmR+ydD4RxfFo=;
        b=z3xY/gMV5EDw+TQ2gthy0upUKuQdJJJgnoyQNcwUKdX6C7BDvliH9wxiKskavtlgfR
         kNMMFqXc7SUJG33EVtNhGfsk+FxMDv5z8u0jP/OQ9QfkvqZ9/o1oc1cDs+xHAZPcjBfK
         hlbc5zjTxAXPN867DCHjg/PZkQimNi6Djj0FEP46Kd+CVjHF//N7RMiHgMdEf2JFmRHZ
         y7f+fIiW4cZM4lgVA/NkHxuvtdqcZ5Xwnofz+ZhQyRNF7VoJNgNB+dfX2pzpgD+bopcZ
         7QhA15ktaP+V7EFRc2GPZN6ag/dlohrqks2Ew9JS447626j5rZmnl/B1sVEYfz8Oal6+
         h69g==
X-Gm-Message-State: AFqh2kpMAI8MKKSQbqtCR7aZSv6wEujLv15dk6VnDslztdtAFxxfERmg
        18ZyFPR7bSoT3CAJJsTI9K3I6x5LlrUj/h/2mRbzpQ==
X-Google-Smtp-Source: AMrXdXsmX0zg4DSIH1PRtePhXLCKf6JjLMEiCCUIuv0VFRCC2O+pzrVF18HsyPRJC/+jF476VoUFRQ==
X-Received: by 2002:aa7:8649:0:b0:583:219a:670e with SMTP id a9-20020aa78649000000b00583219a670emr8720393pfo.30.1673084981438;
        Sat, 07 Jan 2023 01:49:41 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id o10-20020a63f14a000000b00477602ff6a8sm2021591pgk.94.2023.01.07.01.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:49:40 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, maximmi@nvidia.com, gal@nvidia.com
Subject: [patch net-next 8/8] devlink: add instance lock assertion in devl_is_registered()
Date:   Sat,  7 Jan 2023 10:49:09 +0100
Message-Id: <20230107094909.530239-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107094909.530239-1-jiri@resnulli.us>
References: <20230107094909.530239-1-jiri@resnulli.us>
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
index 2b0e119e7b84..09fc4d60fefb 100644
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

