Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084662C5102
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 10:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389252AbgKZJWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 04:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbgKZJWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 04:22:54 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2906C0613D4;
        Thu, 26 Nov 2020 01:22:53 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id t22so1592830ljk.0;
        Thu, 26 Nov 2020 01:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W5cDrqOq1jzXEgXMRHHlPKanhU5lRqHfG08zZXyqcKE=;
        b=npQznwAg0T5cbCntbegXSBXM30S87sWTYC2hE94mbOncuuIF1qRbLsnAdAB7Bk8x8r
         SFYGDkna8xw+ggQDHwW61FwOpqeH7o1MFhmN14xzqqdPrRF+AOw6OGXHwhIhlgbuxgya
         wZ1GfhiZZtIx9y5bL4VFjntheEAJy0JcX48uDhOuMnHt5tPVS9doetvKyYmuJq6AYMkJ
         qziHVh7eHzGrkj7DLgB1QVqrO0F38rrp7QEYd4E+XeXAc4tUg8V7TRRsy6MIVzcJcY0k
         mzV8GKZ1g/4nU9QcCQbgtTcSifqnTMAcd85Nv2l1gLlRyr/eC40k617/Qp3Y5OSCvcQZ
         PrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W5cDrqOq1jzXEgXMRHHlPKanhU5lRqHfG08zZXyqcKE=;
        b=WtaQVhnXODQ1RWstwgIiEtrzwUG1MyLNxlvAq4Hx4NXOVd72d6TSWMkR11iIdds2mn
         bzGlaU7uFWQTx0cBlPlenjfL2CcfHJ7jsEKlz8ba933l4/m+uqvVIylMT2Wo74Ibi4wL
         zGMYKGSmD/vgsR/+B/vb0Y57xgT0smQpfx3VwlTLqYjmUvJaLO4AvB/wcht06JQnBPJy
         RNo/1b7XGFVxOFYz9fxV1nxKxitKlfSYmWRjxPHuR193LRO3B4QSHTBUqDQ15KZbO1kc
         Vboa5GP3JFTp0dKNR9JQNJbUT8awKM5ZbNgZhtk/4vLUYJyCfUAjVbTAQU4Y7x8P03lZ
         eplg==
X-Gm-Message-State: AOAM532yUTAagJ26C8ufulafgli/yJzskQftTjsamJLqVWwGRygU1Kyg
        18cSUqbPkVYVSllp98fDMCRu5BbBOLGnaszJ
X-Google-Smtp-Source: ABdhPJwovc0C7ek/CqZD2u2n6U4XSN9cv+D3S9k/8kZq+ZryELqUq/dxcBGVb0Yp49/Yc7FZDxcwzQ==
X-Received: by 2002:a2e:9793:: with SMTP id y19mr895984lji.437.1606382572183;
        Thu, 26 Nov 2020 01:22:52 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id z188sm239622lfa.141.2020.11.26.01.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 01:22:51 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v4 bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Thu, 26 Nov 2020 10:22:46 +0100
Message-Id: <20201126092248.6192-1-mariuszx.dudek@intel.com>
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

This patch set is based on bpf-next commit fb3558127cb6
("bpf: Fix selftest compilation on clang 11")

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
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             |  92 ++++++++++++++--
 tools/lib/bpf/xsk.h             |   5 +
 7 files changed, 425 insertions(+), 19 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

