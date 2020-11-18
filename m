Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164C72B78D4
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgKRId1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgKRId0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:33:26 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58942C0613D4;
        Wed, 18 Nov 2020 00:33:26 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id b17so1366536ljf.12;
        Wed, 18 Nov 2020 00:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KLJgQlu6oxV+ucveDOs7U5kEuKAa22Jo6V5uCqp1lVM=;
        b=QajlMOF1EVFyX1k1ZrecPCY57ZVBbxb2G6JP3YlqN2YbYLVpWA6jRR6+DlR2efrqeS
         sB0NaS8aHRBycEoeQiwRqzTKyVW/eZONRzAf+N+3HCAY8W4n+8QEUtcjPpD4ivioza2m
         Erkuk1dmhaCStfaoY2DR43rPFr3QdtpqGvdS81HhlIkOfT2iLzjT5gjdnjKU4odaNOMP
         fAx4wJX4YWKzEgb3EQFTrMnDKAJPMtP0WCjHRrPFqc8Qg4s60gXenKlhIzHUUVBdtyvC
         N5pGEYr6pFT8j0v3HZEJXYzJeX5ArDjLm6bP3KD9T6jRez4XMl6fI4djN/SXr1ri1+Rh
         USxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KLJgQlu6oxV+ucveDOs7U5kEuKAa22Jo6V5uCqp1lVM=;
        b=CQA6pBsxsY1ECVo+ADhgVi4qYJLqem0OidCGWmv38i1pQ6RKHvc/mkke2e/Z6lcst0
         7cwAArifZkNZQdWyT5+jDF45D3wi/m7Ua5DFPdFVQ6LabfuAszgZO7V3DhNjQYoSAWWT
         nsM0Z8JiuwIBPjQGMFZWVXGS5QaV1lzHoLEkJ2vxADI3e47aj0QykdEjP6IEu9tgVq7G
         1i6rEfIZA5wRBMChlH9HdYmFFbLu3Iv1Pb8MWDchIU2kczUbzCvmazJXuL3liBTezr2a
         fSOJ4zCg3ZrjjJLYvXHizkwGqku5QIuyYenCnBA/I3rL7A1lgeB3xm4zRnCxuqVuBOqF
         28sw==
X-Gm-Message-State: AOAM531QOvWPrvd+DDY0Ikc08ZQa4iQAVvkHneBV2vSKjJH6bY9SHhRa
        LI8YJcyOjcLeBX+XPsfFpzA=
X-Google-Smtp-Source: ABdhPJxZiN3RJNbLVa0lg6JGFCRiNnpnBTMB/QPoUNxusvBJ1tW4G8zgDYaO283RT3/aAak9JgSxhQ==
X-Received: by 2002:a05:651c:10b:: with SMTP id a11mr3614022ljb.334.1605688404830;
        Wed, 18 Nov 2020 00:33:24 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id r12sm3542107lfc.80.2020.11.18.00.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 00:33:23 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v3 bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Wed, 18 Nov 2020 09:32:51 +0100
Message-Id: <20201118083253.4150-1-mariuszx.dudek@intel.com>
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

This patch set is based on bpf-next commit ea87ae85c9b3
("bpf: Add tests for bpf_bprm_opts_set helper")

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
 samples/bpf/xdpsock_ctrl_proc.c | 184 ++++++++++++++++++++++++++++++++
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             |  97 +++++++++++++++--
 tools/lib/bpf/xsk.h             |   5 +
 7 files changed, 427 insertions(+), 19 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

