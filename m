Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B78690D6A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjBIPpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjBIPoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:44:24 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF4A65673
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:59 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ud5so7609662ejc.4
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahUNtoBUMUJEmN5YBzST2tGjBaSE++aFbMZBxs33E4A=;
        b=3agVf05Vg18i99L7Z0JFOAidJMiy1DNR2vmOwUIlP/5WFgbty5146RzZatOO8dWW/A
         qpj1knHGq8EvuDZuc8sLWzj4I8e4aerke+sCMc4jGHBh1L49D/YyqS7Q8IizHPoXZRoC
         vMnXcND8uOq/n6G6vihv9aambgkIezxmAnHzdT47JRypCup6XSX/asbfEvZxL/7IrymW
         dEO6TMxYdAtUj4YcmjvMBF2hnDtd3Ox6MHEmTkHB9b6Rdh6wgpFzRzbZnf9E3F5Ve1UW
         tLZTBPlNeqYbGAjCiwZVrMatOCaFqkoa5L/xyBquaQpz1LyPajdqOCkL8qNgPgqUxwD6
         qHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahUNtoBUMUJEmN5YBzST2tGjBaSE++aFbMZBxs33E4A=;
        b=XG+NWbMvPZJpjbMioEP4M5YuC61E/HM2CtQ5OjVPefX6hIj9xtu0gkOt0I7ODQWfVw
         m8dwT0aqn0ps8w6rdoQ62vYp0vpBC1iT566Rdnw5mnY6fjhdLqNQTHt4dGIULOaHFHdF
         77g7BbLGSD5sS3nQGWvpuuNtRWEN/ZUGUIYSaxcfmHicTWJZVl51PQnySj42gJsuxxRz
         CbWJW3QQm43knK3bdMcP59r2FB0xgl+rAVpe5OZRV+kJDtElTGuNMBICeZB3xlIwBS1n
         fELR9BfdzeT4mnDyNHRbSiBF1gnGbR5TCvTghKr+q2azEWT08el82lY+5EI1k9gjhuo+
         Mr/A==
X-Gm-Message-State: AO0yUKXRS8W7LgDRtLPenigJKFjYLcAb8/V2YNN4CfYWrnp0z+o1sLDV
        8NwWoen+4QUHPlXrwePEehqRDEsWN8tDxDrMmB0=
X-Google-Smtp-Source: AK7set8gkargCKvBVXyw3N+Hf7wxKT2R20PJhZHia7oPE2oZDYhpNbBARCO3wvdLaIehXBFULGKX9w==
X-Received: by 2002:a17:907:9c04:b0:8ad:d366:54ca with SMTP id ld4-20020a1709079c0400b008add36654camr7051696ejc.23.1675957408553;
        Thu, 09 Feb 2023 07:43:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id la12-20020a170907780c00b008a7936de7b4sm1002286ejc.119.2023.02.09.07.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:27 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 7/7] devlink: add forgotten devlink instance lock assertion to devl_param_driverinit_value_set()
Date:   Thu,  9 Feb 2023 16:43:08 +0100
Message-Id: <20230209154308.2984602-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
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

Driver calling devl_param_driverinit_value_set() has to hold devlink
instance lock while doing that. Put an assertion there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 775adcaa8824..ceacdb1cdf0b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9678,6 +9678,8 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
+	devl_assert_locked(devlink);
+
 	param_item = devlink_param_find_by_id(&devlink->params, param_id);
 	if (WARN_ON(!param_item))
 		return;
-- 
2.39.0

