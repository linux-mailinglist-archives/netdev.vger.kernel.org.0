Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15D81DDC63
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgEVBF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgEVBF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 21:05:29 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C5012072C;
        Fri, 22 May 2020 01:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590109529;
        bh=HV7gC8R+wl2s1Xr3gzpl86mdgofh3EV70CREEsDAoIE=;
        h=From:To:Cc:Subject:Date:From;
        b=X/OhYoCQn7FKxr0qxKuOvbpwROqJUSp/+btnm3KhuaqTMPzwwPnHL9fE4Md4YZCmh
         Gm/Hx/uIsLSTzj+sP1ugD5JBJ/jb6C/o39zzHCVTvC3c+DknT2bLGcmwVoKplsHeoR
         WheBBEBB0Yr9Ss5DQT40UoNEJg78Jb+JIDkpB+3c=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in DEVMAPs
Date:   Thu, 21 May 2020 19:05:22 -0600
Message-Id: <20200522010526.14649-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementation of Daniel's proposal for allowing DEVMAP entries to be
a device index, program id pair. Daniel suggested an fd to specify the
program, but that seems odd to me that you insert the value as an fd, but
read it back as an id since the fd can be closed.

David Ahern (4):
  bpf: Handle 8-byte values in DEVMAP and DEVMAP_HASH
  bpf: Add support to attach bpf program to a devmap
  xdp: Add xdp_txq_info to xdp_buff
  bpftool: Add SEC name for xdp programs attached to device map

 include/linux/bpf.h            |   5 ++
 include/net/xdp.h              |   5 ++
 include/uapi/linux/bpf.h       |   3 +
 kernel/bpf/devmap.c            | 132 +++++++++++++++++++++++++++++----
 net/core/dev.c                 |  18 +++++
 net/core/filter.c              |  17 +++++
 tools/include/uapi/linux/bpf.h |   3 +
 tools/lib/bpf/libbpf.c         |   2 +
 8 files changed, 170 insertions(+), 15 deletions(-)

-- 
2.21.1 (Apple Git-122.3)

