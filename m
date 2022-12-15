Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3713764DF26
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLORBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiLORBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:01:04 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA025E89
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:01:00 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b69so26360edf.6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NObXsKF11rDm6s+FbDqQtzK3Ls0OIKZMzx9iT9RweUY=;
        b=sJzdHaU+R3WwViUskKh5TyLxYwW5yjU1SU82JKIT3ExIDo8OImnDf+HlNDs0/Ye948
         OhhVPAAx9ELAsIa/xWKqi2cOZc7TR1VzKASXoAa+4dnADkiq8Ch78jNLzpTLC7RMsgax
         Hs/X4LWCSUm6zjV8PxWZz/FMHADajson+HjlqIoFy489kcklCFfS/vqWqCfdh7Pk8E2q
         +EMxBjTjwn1VYTYnhIsIH+ZsrNKw9rQGR1+Otg8WHq5dBxdmiP7UaKFBEncMIHBxT3pY
         hdxtctr0H6fFq0zKFVt/gg7wiuUrKlow6frGY2VSWmrGAj/9hVMXTA6E8m46ha0d1l88
         Oing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NObXsKF11rDm6s+FbDqQtzK3Ls0OIKZMzx9iT9RweUY=;
        b=553J8seCGRLqrtmwNUSDbsGF8LJEvxmKam6XagPTZ/mbUSvO37PAinxxgcg7EHckfy
         uyyjB2+llJnfkywvy3fSB96VJ8u0Dv0q25M4eWmrIPxSB89PeaNvIdPdZOrledIx6Xrb
         6Hv+7nPem74GsM2oNTiK8mBGI+jZb/Bu1nnaYBm7yu6fNhMO6E1991C8ipskhN75oEbf
         +oT320CcSfBSJTZNJvKdhjBRJ9tVgnbFKHG1tAgnPXJr5A+iBRpPmwJxFav6xWWsvI0M
         wdQsJj10sOesYBGAp05hXoe46yREDl1bfg+quSmr+NS/YlaMsMWAgu4i/UxSdYrMstsE
         sVjQ==
X-Gm-Message-State: ANoB5pkpAX8WAefDLC+w6vh4NcaxcRmaTy3xTkU/YlYk0aaJZMCU8H68
        VhSd2GCiYwIRzm088fRRf6krhXZVNZGi43Oo7Io=
X-Google-Smtp-Source: AA0mqf5po2SAnjN8jtvy9CADhAfw5MfnUYr/wBFPVHVs6TtoAKs4IkUkRdDrMI7PmU4JpRTDGL3Htg==
X-Received: by 2002:a05:6402:3710:b0:45c:835b:8fb3 with SMTP id ek16-20020a056402371000b0045c835b8fb3mr22835223edb.30.1671123658850;
        Thu, 15 Dec 2022 09:00:58 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906328400b007aed2057ea1sm7288631ejw.167.2022.12.15.09.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 09:00:58 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, idosch@nvidia.com
Subject: [patch iproute2-main] devlink: fix mon json output for trap-policer
Date:   Thu, 15 Dec 2022 18:00:56 +0100
Message-Id: <20221215170056.170827-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
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

There is a json footer missed for trap-policer output in "devlink mon".
So add it and fix the json output.

Fixes: a66af5569337 ("devlink: Add devlink trap policer set and show commands")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 11daf0c36e5d..4baac2a8d60f 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6522,6 +6522,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_policer(dl, tb, false);
+		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_LINECARD_GET: /* fall through */
 	case DEVLINK_CMD_LINECARD_SET: /* fall through */
-- 
2.37.3

