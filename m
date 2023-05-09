Return-Path: <netdev+bounces-1106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 431706FC37D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AE912812AD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34997C2D8;
	Tue,  9 May 2023 10:09:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F18C08
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:09:45 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F86210F
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:09:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96598a7c5e0so897221766b.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 03:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683626982; x=1686218982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zZMjpej7/y2ohh+rCkW/+56nVtjhr/C6lqAEQukYjx0=;
        b=Q1hO1C8l84Okfb26EuaQLq+s2Tdw8pTF8Fk2U81JUDitu9ULqJtsZaG2Hvr3qmnYIq
         JS9ti4UhhUMNwMrAYl/iRNtXRhvyG+PK8BAlz5O/i69HK28IysPv8nCTmuYRg974aYxq
         ld9MXx36srxY8cVd/ckrr+QtiCzwQyI6gMGaUURmDMDV4B2dAfYr09S0BJP+8d6CAc54
         p2IdtcdIJ4J0L4/CKzm7+Fo0eXD0krVgbu3jEnigx/4nJJVBNoGU2s63Peu5WJscIewf
         wIoJZMNBKbwYTunOsS2eveYK4PJY/6oGY5J1NTKtk8t9Gh3VJgZgmsH5Nre1vJN890kp
         r8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683626982; x=1686218982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zZMjpej7/y2ohh+rCkW/+56nVtjhr/C6lqAEQukYjx0=;
        b=YjxTz+B3vjdjmd/UTnn1/tK1CFMzlcnTgcAomIk+81s071+D75LBsMvjYit6yOg0Rw
         Ml1Ywz4K66YfHUGld9L4o9bToDpu/oSmPnmEFYg0Db+OYgxYwth79X6/AQr0tEcgf4lX
         +tb7QjsNYWbd5gtsBco5Vi+GWWkEz4bVZwQJPAqZFAPRw+ETk+sIE7niM/581Bfn7c+A
         0xmE3QgLVYiuns6ZfBzKZFd31+hD+t7vCvfWQpWAvoimWL8E6AdeulgRVwU5vs/9Y7Mk
         ko/58BqxyMN+TTZpeoP4EVdWN/5iCjrDOfDK6P4o4210thqhO1wWLDfF047oRlz0wMzu
         uiEg==
X-Gm-Message-State: AC+VfDzVwSZbfrRll+SO4aScs5j0cvJfXD5pLBfeCHaE6y/y9Q0jATM/
	mAvXTFYUFo/Kvx4fB3lT8LEQKW9vPnzhsYvZnixBQg==
X-Google-Smtp-Source: ACHHUZ4w93KZpPpRGQQyOq+x1sJ0Pqxe8g5lHthDzWuQfIDfR5WThnNhht4+p5CdS3tuG/BQX6+6OQ==
X-Received: by 2002:a17:907:98e:b0:94a:5c6d:3207 with SMTP id bf14-20020a170907098e00b0094a5c6d3207mr11935847ejc.44.1683626981476;
        Tue, 09 May 2023 03:09:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y10-20020a170906914a00b009663cf5dc3bsm1119158ejw.53.2023.05.09.03.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:09:40 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	jacob.e.keller@intel.com,
	saeedm@nvidia.com,
	moshe@nvidia.com
Subject: [patch net 3/3] devlink: fix a deadlock with nested instances during namespace remove
Date: Tue,  9 May 2023 12:09:36 +0200
Message-Id: <20230509100939.760867-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jiri Pirko <jiri@nvidia.com>

The commit 565b4824c39f ("devlink: change port event netdev notifier
from per-net to global") changed original per-net notifier to be global
which fixed the issue of non-receiving events of netdev uninit if that
moved to a different namespace. That worked fine in -net tree.

However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
separate devlink instance for ethernet auxiliary device") and
commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
case of PCI device suspend") were merged, a deadlock was introduced
when removing a namespace with devlink instance with another nested
instance.

Here there is the bad flow example resulting in deadlock with mlx5:
net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
devlink_pernet_pre_exit() -> devlink_reload() ->
mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
mlx5e_destroy_devlink() -> devlink_free() ->
unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)

Steps to reproduce:
$ modprobe mlx5_core
$ ip netns add ns1
$ devlink dev reload pci/0000:08:00.0 netns ns1
$ ip netns del ns1

The first two patches are just dependencies of the last one, which is
actually fixing the issue. It converts the notifier to per per-net
again. But this time also per-devlink_port and setting to follow
the netdev to different namespace.

Jiri Pirko (3):
  net: allow to ask per-net netdevice notifier to follow netdev
    dynamically
  devlink: make netdev notifier per-port
  devlink: change port event netdev notifier to be per-net and following
    netdev

 include/linux/netdevice.h   |  6 +++++
 include/net/devlink.h       |  2 ++
 net/core/dev.c              | 34 +++++++++++++++++++++++-----
 net/devlink/core.c          |  9 --------
 net/devlink/devl_internal.h |  4 ----
 net/devlink/leftover.c      | 45 ++++++++++++++++++++++++++-----------
 6 files changed, 69 insertions(+), 31 deletions(-)

-- 
2.39.2


