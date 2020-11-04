Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF142A60D9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgKDJqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgKDJqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:46:34 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3113BC0613D3;
        Wed,  4 Nov 2020 01:46:32 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id i6so26317261lfd.1;
        Wed, 04 Nov 2020 01:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JMKW2AFJKBbvyHNdmj0rshzU7XEGh8XGmlxj8IfZRIE=;
        b=iRt7d66utjU+hsGwwlScOiDE7g5ky2eBA6Iz8NnTE2QIIIoZys5CH1jN6FxLEx9vrJ
         w7PXT2WsOnzGUv1jmraWAjwbGHwEqFUO4xY3j1Hp2YaOne1TYpxT0GGt5MD0COCbBMI+
         ZEvFIztU2QWUW5pMK3N1O/cywMcG6PDT1CczYApm8QIfEMEX2YaASqJYk9jEeQnN5wkb
         +hUdPEXSUpzZpi6m9lexu7WBwMbhg52i0Tt4J1N518Y317OdSEm3KBocoTuFMpK47NwY
         dgJ6K2vwjeNCm8UIqh7cFSPnkcwWhh0RGoz3u8rYF6MQxJhdfGGd1cIqk+pZqvO66NL4
         oeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JMKW2AFJKBbvyHNdmj0rshzU7XEGh8XGmlxj8IfZRIE=;
        b=XHatvz/Pk276KRkoNJGMmbj435fbtmJ/acaPkA9xdUP4g927uyDctZDSjO+3HvzTiF
         XKDM1Xp4LD6g4Vi3ON1KNn3L1uskmI1F+Rme/4pcM5lsPWWAQ/Uf7LlxB5gMaY4zd4n3
         6Qz3HyoVaZY1bb0UmIhsMmtXCA4tX4uFE6xxQTDbghBBmsU4W8ulrYIXyaxq/vqD6YjC
         qUD4TuSAxcDHu28qSVoM0R/b2ZwQh1xIQ9FmBcUwJIt6ObHNXjI9CS5c6RwThxeD1C/H
         rveKrei9vXjcNMPGJhhryFCxGaph4XfQG9gHbYmnQLOWnjQ92QLmH4sna7rxqRyKot0V
         0/5Q==
X-Gm-Message-State: AOAM530RSC6VyhT/MvFRNMX3BV/eh+rOMDQnQEwculYAzCBf3z1B04XL
        ZjcyWFVAtfmE5KiIBUpkBhI=
X-Google-Smtp-Source: ABdhPJzGxrQE4UfIJaRsy6vQz+E0ImSj0JceLDiO425MIYhQ7+64xbm5/Qy2YriRxmXGzwG/ohmBdQ==
X-Received: by 2002:a19:48c6:: with SMTP id v189mr8801817lfa.284.1604483190654;
        Wed, 04 Nov 2020 01:46:30 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id x18sm355624lfc.73.2020.11.04.01.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:46:30 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Wed,  4 Nov 2020 10:46:24 +0100
Message-Id: <20201104094626.3406-1-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mariusz Dudek <mariuszx.dudek@intel.com>

	This patch series adds support for separation of eBPF program
	load and xsk socket creation. In for example a Kubernetes
	environment you can have an AF_XDP CNI or daemonset that is 
	responsible for launching pods that execute an application 
	using AF_XDP sockets. It is desirable that the pod runs with
	as low privileges as possible, CAP_NET_RAW in this case, 
	and that all operations that require privileges are contained
	in the CNI or daemonset.
	
	In this case, you have to be able separate ePBF program load from
	xsk socket creation.

	Currently, this will not work with the xsk_socket__create APIs
	because you need to have CAP_NET_ADMIN privileges to load eBPF
	program and CAP_SYS_ADMIN privileges to create update xsk_bpf_maps.
	To be exact xsk_set_bpf_maps does not need those privileges but
	it takes the prog_fd and xsks_map_fd and those are known only to
	process that was loading eBPF program. The api bpf_prog_get_fd_by_id
	that looks up the fd of the prog using an prog_id and
	bpf_map_get_fd_by_id that looks for xsks_map_fd usinb map_id both
	requires CAP_SYS_ADMIN.

	With this patch, the pod can be run with CAP_NET_RAW capability
	only. In case your umem is larger or equal process limit for
	MEMLOCK you need either increase the limit or CAP_IPC_LOCK capability. 
	Without this patch in case of insufficient rights ENOPERM is
	returned by xsk_socket__create.

	To resolve this privileges issue two new APIs are introduced:
	- xsk_setup_xdp_prog - prepares bpf program if given and
	loads it on a selected network interface or loads the built in
	XDP program, if no XDP program is supplied. It can also return
	xsks_map_fd which is needed by unprivileged process to update
	xsks_map with AF_XDP socket "fd"
	- xsk_update_xskmap - inserts an AF_XDP socket into an xskmap for a
	particular xsk_socket

	Usage example:
	int xsk_setup_xdp_prog(int ifindex, struct bpf_prog_cfg *cfg,
			int *xsks_map_fd)

	if cfg == NULL, then the default program is loaded.

	Instead of NULL user can pass pointer to struct
	bpf_prog_cfg and provide own bpf program. 

	int xsk_update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);

	Inserts AF_XDP socket "fd" into the xskmap.

	The first patch introduces the new APIs. The second patch provides
	a new sample applications working as control and modification to
	existing xdpsock application to work with less privileges.

	This patch set is based on bpf-next commit cb5dc5b062a9
	("Merge branch 'bpf: safeguard hashtab locking in NMI context')

Mariusz Dudek (2):
  libbpf: separate XDP program load with xsk socket creation
  samples/bpf: sample application for eBPF load and socket creation
    split

 samples/bpf/Makefile            |   4 +-
 samples/bpf/xdpsock.h           |   8 ++
 samples/bpf/xdpsock_ctrl_proc.c | 184 ++++++++++++++++++++++++++++++++
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             | 157 ++++++++++++++++++++++-----
 tools/lib/bpf/xsk.h             |  13 +++
 7 files changed, 478 insertions(+), 36 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

