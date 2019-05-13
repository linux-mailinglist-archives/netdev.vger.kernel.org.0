Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC041BFC9
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfEMXTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:19:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:57876 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEMXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:19:22 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQKE3-0001rj-Pz; Tue, 14 May 2019 01:19:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 0/3] BPF LRU map fix
Date:   Tue, 14 May 2019 01:18:54 +0200
Message-Id: <cover.1557789256.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set fixes LRU map eviction in combination with map lookups out
of system call side from user space. Main patch is the second one and
test cases are adapted and added in the last one. Thanks!

Daniel Borkmann (3):
  bpf: add map_lookup_elem_sys_only for lookups from syscall side
  bpf, lru: avoid messing with eviction heuristics upon syscall lookup
  bpf: test ref bit from data path and add new tests for syscall path

 include/linux/bpf.h                        |   1 +
 kernel/bpf/hashtab.c                       |  23 ++-
 kernel/bpf/syscall.c                       |   5 +-
 tools/testing/selftests/bpf/test_lru_map.c | 288 +++++++++++++++++++++++++++--
 4 files changed, 297 insertions(+), 20 deletions(-)

-- 
2.9.5

