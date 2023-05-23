Return-Path: <netdev+bounces-4670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 204EC70DCBE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D884A281342
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDAA41E50F;
	Tue, 23 May 2023 12:39:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC5F1E50A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:39:13 +0000 (UTC)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6797C109
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:10 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4f4ba3e0b98so1091688e87.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684845489; x=1687437489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U0qhfsEvZoF7QnWAe9SbLvU2tPZyPhFHthFLH4EIz50=;
        b=LNDtahBXgiVwPe9Yt6dNeXhE/p5ALtFGCe6UxB5Jvo3BavtJQGA8HrFpM9cbOldngs
         o7rOVnKcKSFlayKBuM5nPzTYH+hwlNHHmuVcfbF5brY3xfYhT20gVxRma7vYaaSEmU7+
         dGw6IzPILSmPrQbaFH0w6lbXpzngfSkeBhqDhg3xQkIyF4wnI2I1o8XeQRB10IHwAfbI
         WTJfvIqkdiMMyRl3oRjnwFiv7Lqsg4BQevdrKfDNhSBqCiBkSwC4Y6cTtMpJ7PCK6NkT
         WZHnDBS25m9MJHT+duyGAi/NxrEJUhHl2gNB96/RTZ+nbQpcWSKfU0Xo3ZEyGKvt64ul
         2Bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684845489; x=1687437489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U0qhfsEvZoF7QnWAe9SbLvU2tPZyPhFHthFLH4EIz50=;
        b=DdHnxeWthpfzkpGADd38w2khiMIZnxBQyCdu4+JsHQmBVqa/CklUtuVtz+40lYbH1P
         rNQvN7gp5XzKbfOnU0c7G1wf3uaVh3wBUHrHb+v6GZfJ4jK1BP6GoEStbDZVYIwa97xy
         1lgrItD4TwNWXd0XNVfYLihPwYRmRrKsIXzEPCME01vseHjcbpDIEhnS9Ct4QZR3rf4y
         xwB8ucWxFafNctNVw5ZtOmWlB2hjtOP+4ZXrOAgKN24aw7E3j2wsJt9Nap7V9+ThPMWq
         dj5qk+HeS7MCwZdlhyflvWqz4jGrpPl9pj2CdWOxkOcdlp2oFtXZDaMNYQIjtKBfIo/M
         u91Q==
X-Gm-Message-State: AC+VfDww80JfH31Mr3ykhTCkdx4Bw0UiNPnZFIwJyqj6llcieNuGBpOM
	YUJTfxmYtIrewQOPbR8AadSxb2wiOUPuygILsic=
X-Google-Smtp-Source: ACHHUZ508p4M5Bp6Zef3JQQBjWHf6ljsIstP+kw5LV/spV9cnI4r1uLzxZDA3XmjS7R8dLB01phx/A==
X-Received: by 2002:ac2:599a:0:b0:4f3:80a3:b40a with SMTP id w26-20020ac2599a000000b004f380a3b40amr3402458lfn.69.1684845488862;
        Tue, 23 May 2023 05:38:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a4-20020ac25204000000b004f3880f900dsm1320565lfl.196.2023.05.23.05.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 05:38:08 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net-next 2/3] devlink: remove no longer true locking comment from port_new/del()
Date: Tue, 23 May 2023 14:38:00 +0200
Message-Id: <20230523123801.2007784-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523123801.2007784-1-jiri@resnulli.us>
References: <20230523123801.2007784-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

All commands are called holding instance lock. Remove the outdated
comment that says otherwise.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ccea6e079777..24a48f3d4c35 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1506,8 +1506,6 @@ struct devlink_ops {
 	 * attributes
 	 *
 	 * Notes:
-	 *	- Called without devlink instance lock being held. Drivers must
-	 *	  implement own means of synchronization
 	 *	- On success, drivers must register a port with devlink core
 	 *
 	 * Return: 0 on success, negative value otherwise.
@@ -1525,8 +1523,6 @@ struct devlink_ops {
 	 * to delete a previously created port function
 	 *
 	 * Notes:
-	 *	- Called without devlink instance lock being held. Drivers must
-	 *	  implement own means of synchronization
 	 *	- On success, drivers must unregister the corresponding devlink
 	 *	  port
 	 *
-- 
2.39.2


