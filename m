Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23662CD20E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 10:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388280AbgLCJGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 04:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbgLCJGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 04:06:31 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE60C061A4D;
        Thu,  3 Dec 2020 01:05:51 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id z21so1596356lfe.12;
        Thu, 03 Dec 2020 01:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QCqIrtOiA/TBxkmrYiBIjA6M/D0cNyEhK4rbuVGFEOU=;
        b=Mh3C3RGqCwK1whXMo3ds1s1AeJm6hqmpIvZxeiEv6yrgXMrZmu9jm3Ud6jARzmvI15
         Mobu2GHOWtm5lDeldgU30fpYeUmmy0W0nec/tq9wLx7Bp8FDPzMk06p/5PmSo9dtKOrQ
         LGR3JOsvPY53/oJB9l0r36uQW23I36h4SjPrXJYjO6+DHXm5N7qT9qIGxMUv3SUbbhK7
         cq5ZtO2KdY/OV20T6C8C17snCgz1lM0zzdkGAnwEjGdHJLn/C/htoT9NcaJiGsPTCj1m
         MoF14Kb1ubHfcZdPoibHrWZ0wPdIlw4M80ftSg84Cdo07YoeScU3hl4D6xGysuqCvz6G
         jgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QCqIrtOiA/TBxkmrYiBIjA6M/D0cNyEhK4rbuVGFEOU=;
        b=coujbDCQwWfqi6KyESj42Nyvf1rwYbkjobAJ3OK71tav/R8ASPb7w4EPrPusSXDNGA
         y+McnoCOtA6EA18ga6D6Yev+FcpyL2p/NAAZjVtwU3vq17exlID5fbgI3FFKtCVhEPs1
         96B+xWBav4D39hFHmrdlGlKDh8JaSWLPEqwifPF9sNc8WUeR9yoiqcfSsG5zMXTY2wKV
         B06HcZ+bKr2/T08GH+sYUPi9xUHDvjmxHoBgvgNYqLuBRHVYPE2B+9w2n3YJwfLJzy4/
         ld4J03R9y//88sZWSnm13/pNzd4SQo+3QwMIKOjK8qegK2nImiXl4jPiKv3y/T/We8vl
         gGWw==
X-Gm-Message-State: AOAM531XWg4fEGStPkBxx9Gy2zfLBcywzI4D6gmszEzdR57aili9oVcD
        NHDPqGHltnta4MKaPoLrf+g=
X-Google-Smtp-Source: ABdhPJyBBOesqCj6KXo8+QVZrcTZgxWwbVO6B97Y299PAMoT9uv2jvsO6ou81VEVJjrD3VoZuozMWQ==
X-Received: by 2002:ac2:54b8:: with SMTP id w24mr855921lfk.491.1606986349746;
        Thu, 03 Dec 2020 01:05:49 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id y14sm198744ljk.125.2020.12.03.01.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 01:05:49 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v7 bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Thu,  3 Dec 2020 10:05:44 +0100
Message-Id: <20201203090546.11976-1-mariuszx.dudek@intel.com>
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
- xsk_setup_xdp_prog - loads the built in XDP program. It can
also return xsks_map_fd which is needed by unprivileged
process to update xsks_map with AF_XDP socket "fd"
- xsk_sokcet__update_xskmap - inserts an AF_XDP socket into an
xskmap for a particular xsk_socket

Usage example:
int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)

int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);

Inserts AF_XDP socket "fd" into the xskmap.

The first patch introduces the new APIs. The second patch provides
a new sample applications working as control and modification to
existing xdpsock application to work with less privileges.

This patch set is based on bpf-next commit 97306be45fbe
(Merge branch 'switch to memcg-based memory accounting')

Since v6
- rebase on 97306be45fbe to resolve RLIMIT conflicts

Since v5
- fixed sample/bpf/xdpsock_user.c to resolve merge conflicts

Since v4
- sample/bpf/Makefile issues fixed

Since v3:
- force_set_map flag removed
- leaking of xsk struct fixed
- unified function error returning policy implemented

Since v2:
- new APIs moved itto LIBBPF_0.3.0 section
- struct bpf_prog_cfg_opts removed 
- loading own eBPF program via xsk_setup_xdp_prog functionality removed

Since v1:
- struct bpf_prog_cfg improved for backward/forward compatibility
- API xsk_update_xskmap renamed to xsk_socket__update_xskmap
- commit message formatting fixed

Mariusz Dudek (2):
  libbpf: separate XDP program load with xsk socket creation
  samples/bpf: sample application for eBPF load and socket creation
    split

 samples/bpf/Makefile            |   4 +-
 samples/bpf/xdpsock.h           |   8 ++
 samples/bpf/xdpsock_ctrl_proc.c | 187 ++++++++++++++++++++++++++++++++
 samples/bpf/xdpsock_user.c      | 144 +++++++++++++++++++++++-
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             |  92 ++++++++++++++--
 tools/lib/bpf/xsk.h             |   5 +
 7 files changed, 427 insertions(+), 15 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

