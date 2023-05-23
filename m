Return-Path: <netdev+bounces-4668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 586AF70DCBC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4D451C20D65
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5CE4C7C;
	Tue, 23 May 2023 12:39:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14CD4A84E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:39:11 +0000 (UTC)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1BFC4
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:05 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-4f00d41df22so5850756e87.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684845484; x=1687437484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yttw4vAJtBVz7JStL7szpplE+ao7yv7ctWoRyvW3Dkk=;
        b=g2e5ir1O46uYaR+rrWBCGnJ4aSvLxHgUJMCENmHMLIAFdapJJ5qlDrttewo7hlF2B1
         Qrkb4xGOGWJZovR1Qjd4eZgs6O4Cp2reLAopkk1kSM58eRaKvnJ7qHad+gF8Zn5gjnxn
         DNIdovBcG290+reKIRhUgqzwqIppY92dj1ypM6jh99s2kZpTvbkvwe4bcEuIBZ+cgLXB
         LowG/exKctiRHNMvmcuzhdeuVsJxaX/Wet5FAiut3W566PboG029j15gUv4xG8uBbKcN
         1ut8E6WOKotg8AHwow49XbaQViACdHYokJNZMViTzE6J3fRnDrR9g/sJf1mboZEhGWlD
         ufdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684845484; x=1687437484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yttw4vAJtBVz7JStL7szpplE+ao7yv7ctWoRyvW3Dkk=;
        b=N9TOHzv+lu41NE2PSTm7TqjT86yKGPSDd33RY/j63VTmCm7sZbJosnsSkvAELSgatT
         dYgk3bNJ+LzI2/bQ3j2O2XqgqER53lyJXEsEVKAGeLNd9HlbqWAy0/hDJBhRl5yPykSO
         0ns1zuQEyVdM5uS77OglAEtnGDzcrizsGbsO/+QSlKQbB3OXfxf0dVD6v7oCM1K1R/cu
         dilIPT8g3T7D0bZ6n4YOwIWMKQP4HNuazd4a7AbzubNfoAAz5jK9Y3Vsl8HjzYN9f61i
         W8qNxn6MGMYRx2TjAgn6eLyIEOOPp8PFV7HEw9nFcH3yLui/Ph/xMbIWphqINB0Ku9VZ
         gtiQ==
X-Gm-Message-State: AC+VfDypbESj+HYgtsdkxwyv7+/XGvQvZ3X4N8Kyj3pNyDEwxkF9gmDo
	ewgb5LlpWMUwidpuuzbDEWTpyJDajadulgenoVM=
X-Google-Smtp-Source: ACHHUZ5+J671IoyZj4gT9lSFSATqxtpentx566yAarIbbQVKtucm4FDEPZCWvdDesiexkzfrnpigsA==
X-Received: by 2002:a05:6512:90d:b0:4f1:4898:d183 with SMTP id e13-20020a056512090d00b004f14898d183mr4402181lft.25.1684845483661;
        Tue, 23 May 2023 05:38:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j7-20020ac25507000000b004f3ab100161sm1345121lfk.15.2023.05.23.05.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 05:38:02 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	leon@kernel.org,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net-next 0/3] devlink: small port_new/del() cleanup
Date: Tue, 23 May 2023 14:37:58 +0200
Message-Id: <20230523123801.2007784-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
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

This patchset cleans up couple of leftovers after recent devlink locking
changes. Previously, both port_new/dev() commands were called without
holding instance lock. Currently all devlink commands are called with
instance lock held.

The first patch just removes redundant port notification.
The second one removes couple of outdated comments.
The last patch changes port_dev() to have devlink_port pointer as an arg
instead of port_index, which makes it similar to the rest of port
related ops.

Jiri Pirko (3):
  devlink: remove duplicate port notification
  devlink: remove no longer true locking comment from port_new/del()
  devlink: pass devlink_port pointer to ops->port_del() instead of index

 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 14 ++---
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   |  6 +-
 include/net/devlink.h                         | 12 +---
 net/devlink/leftover.c                        | 56 ++-----------------
 4 files changed, 16 insertions(+), 72 deletions(-)

-- 
2.39.2


