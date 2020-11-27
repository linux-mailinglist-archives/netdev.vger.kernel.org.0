Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168AB2C60D3
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgK0I0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgK0I0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:26:07 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FE3C0613D1;
        Fri, 27 Nov 2020 00:26:06 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id d20so5855890lfe.11;
        Fri, 27 Nov 2020 00:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PxUSb2nlGFNeF2j0IJo0PLdlyD/MmMIMA0h8pm4n4+c=;
        b=Mh8NlRqNoekbtjxr9S5tNcGvoXIuzwXfbJKgZ8SPxDUDbW0AZLXkgnSw9qDYOmaSpg
         i22Jh3bMXpjS4SyW2KWKL8O+OqvXafJkHgVt+dflGtcdUrILCeCFdJp3EFL1m22dt28n
         o6xrSCinSe2IpI0LT4tzO8B9zRcg6Nxh59hxBhItuJ/yKJhl3WRl2/9I8HyTAE+w3UFG
         HAK7QXXEnWchB2u7DpjX0tOjbhqxiJ7Ae68947KGe42sfQiqBIl/A6TiqBkRrh8kLfNm
         OavKyiw04pr/48w6VR9WjFLKdNw+ZitkpH/SjBIXtuRtNXEPLjgSAywg8UPm07Hcp/l4
         rvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PxUSb2nlGFNeF2j0IJo0PLdlyD/MmMIMA0h8pm4n4+c=;
        b=QRBtCfDlBcSFCvJ/hpcL8lRSBhwRPiiipqhBiZetaTfpywDqpPEinYqpTLSra2AAJf
         fgtud++kNyh/JqOxyJRcGPGH8MMkliXdH22B7If72KDBm5ZNAmEPkKfogN5gbOTyGthn
         IJybPiVysGXcICOZsg7sJpbx1RjHDxBBEFya7SBt/PIlgD97CvKXNdy0nSATaky7y6SU
         Yv5/zJ8JojTaf8QaTHOZepPtZJmiJon+gCTnF8MYCnUezlxoRTJCdMUA6CvQZUtVYLHG
         eRnpmCqnX0XxxqDY/25rEFEJjb7IgH3y27Df1vyOX2+P5QIIKxFwWQobeNt3pFV/X2qd
         p6Gg==
X-Gm-Message-State: AOAM530gx6z3YWewZNAY9vsfdsMaOy1EITJkavt0Njo38qPqNH4G+UTA
        gJ/jhcGkN+Kcwb9MOEelLZE=
X-Google-Smtp-Source: ABdhPJzMMjNEhS1dVk29n6vuCymXMWPZZj+bcUegxd6+BHowq7z1dl8xGF7ezEQOOBYvMFNTtHJ5nA==
X-Received: by 2002:a19:4154:: with SMTP id o81mr2695168lfa.540.1606465565088;
        Fri, 27 Nov 2020 00:26:05 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id 202sm598753lfg.203.2020.11.27.00.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 00:26:04 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v5 bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Fri, 27 Nov 2020 09:25:59 +0100
Message-Id: <20201127082601.4762-1-mariuszx.dudek@intel.com>
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

This patch set is based on bpf-next commit 830382e4ccb5
(Merge branch 'bpf: remove bpf_load loader completely')

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
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             |  92 ++++++++++++++--
 tools/lib/bpf/xsk.h             |   5 +
 7 files changed, 425 insertions(+), 19 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

