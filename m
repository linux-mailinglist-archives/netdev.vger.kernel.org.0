Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0A584C69
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiG2HKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiG2HKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:10:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDB051A10
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id va17so7082511ejb.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KBgRtB9pF0zE075FjQlLewZAn9Yyllc4PhkpHGfsM6Y=;
        b=1r/X81sXn6s8SWebxAGQWUidedl5kapXHutg0nNAhoVeUSasPDVv/VX/PyEJaDPXbu
         uUjOgPGaXuDIkS5kwrrPRvEFnk+5zySX5g2VhXU4kv55caj0r3aN+Rp8yLg3PqE4J2gk
         xke+Ci/nQ+7xF+jafa1/JdptlDoHSxDXWtbdeFNspiYzC37qJJDJ1xzPzh2yFDrmdDt2
         eOfaeNbFrTHQlk0C3oWmzU/4HOY5ELKejD+nMPld4yyTDY9ZZ4UOOqL8FKuIF9FxV1Tw
         CD3h6mx8Skd4SF8AXo5Jd7CAeELbpCd57Lvit6mhm45IPqFgRGpvQVzXiMxr3DAjuGiK
         NXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBgRtB9pF0zE075FjQlLewZAn9Yyllc4PhkpHGfsM6Y=;
        b=Yf/zdczhOVGFQrl9vOPBCbqy95aZxf+RmRrEhBrvz1TAkMXNImbSS85nGYpnXMq4sl
         8Scm7ZmpeEG0YxZr2KSSJiihqHk4Fw3gaaN8iEwmGDJgj0zCc+FIU8R5dUCo0mEC3JW8
         IOu5Qh7HPlGY8qTWfk9stxn3iNTuSmVibf/+s29louEh0+gCcsf+vRT2aMewTD6eGq4T
         EVcUB6bIdyAyYUJG4MmC9qRmU9PYHhIoumbJT535xtu3po8Vy6IggCTdClc4ySP0Ixmi
         bBliaUiD0G2opPStWwaqzQKe7laOpodwPOuXDSEyavWfDpzoM+6KAd/NKWIg0fZ/6p0N
         qhcQ==
X-Gm-Message-State: AJIora9yJF3hhL5mFamfijuc+pvCLUJEnUL5FADurhWCnzT/jl8A1Jhv
        MtEbPaEDeU6EO2Twr4XtZRjmKqtCy2/xfIH3
X-Google-Smtp-Source: AGRyM1tXiW37wmWbiKzWPJ66M0rcvtRh5aCLbSMqaD3spENsg4Java2z00Fn8aKbDrJqtJwff+Rd1Q==
X-Received: by 2002:a17:906:6a0a:b0:72b:60b8:d2e7 with SMTP id qw10-20020a1709066a0a00b0072b60b8d2e7mr1796901ejc.607.1659078641018;
        Fri, 29 Jul 2022 00:10:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906301a00b006fec56c57f3sm1327952ejz.178.2022.07.29.00.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:10:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: [patch net-next 1/4] net: devlink: introduce "unregistering" mark and use it during devlinks iteration
Date:   Fri, 29 Jul 2022 09:10:35 +0200
Message-Id: <20220729071038.983101-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
References: <20220729071038.983101-1-jiri@resnulli.us>
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

Add new mark called "unregistering" to be set at the beginning of
devlink_unregister() function. Check this mark during devlinks
iteration in order to prevent getting a reference of devlink which is
being currently unregistered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index c43c96554a3e..6b20196ada1a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -207,6 +207,7 @@ static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_
 
 static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 #define DEVLINK_REGISTERED XA_MARK_1
+#define DEVLINK_UNREGISTERING XA_MARK_2
 
 /* devlink instances are open to the access from the user space after
  * devlink_register() call. Such logical barrier allows us to have certain
@@ -305,6 +306,14 @@ devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
 	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
 	if (!devlink)
 		goto unlock;
+
+	/* In case devlink_unregister() was already called and "unregistering"
+	 * mark was set, do not allow to get a devlink reference here.
+	 * This prevents live-lock of devlink_unregister() wait for completion.
+	 */
+	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
+		goto retry;
+
 	/* For a possible retry, the xa_find_after() should be always used */
 	xa_find_fn = xa_find_after;
 	if (!devlink_try_get(devlink))
@@ -9809,11 +9818,13 @@ void devlink_unregister(struct devlink *devlink)
 	ASSERT_DEVLINK_REGISTERED(devlink);
 	/* Make sure that we are in .remove() routine */
 
+	xa_set_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
-- 
2.35.3

