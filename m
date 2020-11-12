Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDCC2B0167
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgKLI67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgKLI66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:58:58 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A77C0613D1;
        Thu, 12 Nov 2020 00:58:58 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 74so7182801lfo.5;
        Thu, 12 Nov 2020 00:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDSqpIcl7HdFmlxtMPWQ5x4ZHjGK9IF0j+qgt/zu5Bc=;
        b=ECU8jS3CUGa761OY7yjSfUfYnZ4dgdBaiFuzE55IR2GKjXPyAtNZf7puqBBlsAfZOK
         EWEDUlPJkQ3wvQp1ZweIAUYiTSR9Gy4jVGzm4rdQKg3g8K43qOLsLNiDLhv0hcXeWgVZ
         +TvjP41b5tlE4FGav4QnJYQvsi8opgYzsiryLQWTUdDr5fsQ8afwL2MFCjUrCdsWMgtR
         3fSWqZfushvAFYOAWTWIJ272uz7/+IUPYgYsza7SenIv/Kkt1slSMmQq2hSlFlc7hKWI
         79Ucbdwa7Gt9wwA5CfyrkooaFsqzu1Pj7vgQ8UR5bKT6XfiIyj4vQNYqnTuZ4Rc+eLv3
         5TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDSqpIcl7HdFmlxtMPWQ5x4ZHjGK9IF0j+qgt/zu5Bc=;
        b=ccAiYu5u1J0FSttQ9Zp1Z0Am1uHcrSpp7+W020a/s9FCgRv99A7fPu8Irr2TaPsAIK
         u8AeYR8yGmEE8z4yk9H5zH92XrJRML+d8+QLFYjFyUAKvQTB5L2kmPw9d087Sw+wUZ85
         jdofo3tDgrOkR+gmc9tAZXfMWfGSUvI8xWix4aJbVhFFHXoThnTAEp3XPJvIhCOOhDCV
         bY3ZMDJBC/Vo0+NEiZk2z/NUIA8UOE2VvIU/wf+PMukEPbKV5Vx85MsjhGgcc3vvZhyu
         GskWUbQVmFHX99xpHwChpXTRRtw5JevYG7TDLD2K2Q1iZqoG6iz1PsK/ueNpnWFppgzV
         YIqg==
X-Gm-Message-State: AOAM532I0bhjSDnE9i1+KY2faj85nFDtishthNP3YEG5PEn2Gv5gYfZB
        vJHLAZyS7vKGA7jKHzzw6PU=
X-Google-Smtp-Source: ABdhPJy0ptNM7Rs/DIS74RjtayxQtQQTtMeJGm+5Ort/xApGyY96wPwVBJLCMtY2YNLBnWLD0OOFCQ==
X-Received: by 2002:a19:c1c5:: with SMTP id r188mr8589034lff.354.1605171536676;
        Thu, 12 Nov 2020 00:58:56 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id i4sm486833ljj.6.2020.11.12.00.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 00:58:56 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v2 bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Thu, 12 Nov 2020 09:58:52 +0100
Message-Id: <20201112085854.3764-1-mariuszx.dudek@intel.com>
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
- xsk_sokcet__update_xskmap - inserts an AF_XDP socket into an
xskmap for a particular xsk_socket

Usage example:
int xsk_setup_xdp_prog(int ifindex, struct bpf_prog_cfg *cfg,
		int *xsks_map_fd)

if cfg == NULL, then the default program is loaded.

Instead of NULL user can pass pointer to struct
bpf_prog_cfg and provide own bpf program. 

int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);

Inserts AF_XDP socket "fd" into the xskmap.

The first patch introduces the new APIs. The second patch provides
a new sample applications working as control and modification to
existing xdpsock application to work with less privileges.

This patch set is based on bpf-next commit 09a3dac7b579
("bpf: Fix NULL dereference in bpf_task_storage")

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
 samples/bpf/xdpsock_ctrl_proc.c | 184 ++++++++++++++++++++++++++++++++
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             | 160 ++++++++++++++++++++++-----
 tools/lib/bpf/xsk.h             |  15 +++
 7 files changed, 483 insertions(+), 36 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

