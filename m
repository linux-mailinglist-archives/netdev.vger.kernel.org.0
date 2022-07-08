Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7642656C202
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbiGHVeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 17:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbiGHVeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 17:34:23 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6562A026E;
        Fri,  8 Jul 2022 14:34:21 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o9vcB-000CH5-5E; Fri, 08 Jul 2022 23:34:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-07-08
Date:   Fri,  8 Jul 2022 23:34:18 +0200
Message-Id: <20220708213418.19626-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26596/Thu Jul  7 09:53:54 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 3 non-merge commits during the last 2 day(s) which contain
a total of 7 files changed, 40 insertions(+), 24 deletions(-).

The main changes are:

1) Fix cBPF splat triggered by skb not having a mac header, from Eric Dumazet.

2) Fix spurious packet loss in generic XDP when pushing packets out (note
   that native XDP is not affected by the issue), from Johan Almbladh.

3) Fix bpf_dynptr_{read,write}() helper signatures with flag argument before
   its set in stone as UAPI, from Joanne Koong.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

syzbot

----------------------------------------------------------------

The following changes since commit ae9fdf6cb4da4265bdc3a574d06eaad02a7f669a:

  Merge branch 'mptcp-path-manager-fixes' (2022-07-06 12:50:27 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to f8d3da4ef8faf027261e06b7864583930dd7c7b9:

  bpf: Add flags arg to bpf_dynptr_read and bpf_dynptr_write APIs (2022-07-08 10:55:53 +0200)

----------------------------------------------------------------
Eric Dumazet (1):
      bpf: Make sure mac_header was set before using it

Joanne Koong (1):
      bpf: Add flags arg to bpf_dynptr_read and bpf_dynptr_write APIs

Johan Almbladh (1):
      xdp: Fix spurious packet loss in generic XDP TX path

 include/uapi/linux/bpf.h                           | 11 +++++++----
 kernel/bpf/core.c                                  |  8 +++++---
 kernel/bpf/helpers.c                               | 12 ++++++++----
 net/core/dev.c                                     |  8 ++++++--
 tools/include/uapi/linux/bpf.h                     | 11 +++++++----
 tools/testing/selftests/bpf/progs/dynptr_fail.c    | 10 +++++-----
 tools/testing/selftests/bpf/progs/dynptr_success.c |  4 ++--
 7 files changed, 40 insertions(+), 24 deletions(-)
