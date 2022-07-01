Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8745563CA3
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 01:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiGAXB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 19:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiGAXBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 19:01:25 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342027125C;
        Fri,  1 Jul 2022 16:01:24 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7Pda-0003pK-Gg; Sat, 02 Jul 2022 01:01:22 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-07-02
Date:   Sat,  2 Jul 2022 01:01:21 +0200
Message-Id: <20220701230121.10354-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26590/Fri Jul  1 09:25:21 2022)
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

We've added 7 non-merge commits during the last 14 day(s) which contain
a total of 6 files changed, 193 insertions(+), 86 deletions(-).

The main changes are:

1) Fix clearing of page contiguity when unmapping XSK pool, from Ivan Malov.

2) Two verifier fixes around bounds data propagation, from Daniel Borkmann.

3) Fix fprobe sample module's parameter descriptions, from Masami Hiramatsu.

4) General BPF maintainer entry revamp to better scale patch reviews.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Hao Luo, Jiri Olsa, John Fastabend, KP Singh, Kuee K1r0a, Magnus 
Karlsson, Martin KaFai Lau, Mykola Lysenko, Quentin Monnet, Song Liu, 
Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit a2b1a5d40bd12b44322c2ccd40bb0ec1699708b6:

  net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms (2022-06-17 20:29:38 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to a49b8ce7306cf8031361a6a4f7f6bc7a775a39c8:

  bpf, selftests: Add verifier test case for jmp32's jeq/jne (2022-07-01 12:56:27 -0700)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf, docs: Better scale maintenance of BPF subsystem

Daniel Borkmann (4):
      bpf: Fix incorrect verifier simulation around jmp32's jeq/jne
      bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals
      bpf, selftests: Add verifier test case for imm=0,umin=0,umax=1 scalar
      bpf, selftests: Add verifier test case for jmp32's jeq/jne

Ivan Malov (1):
      xsk: Clear page contiguity bit when unmapping pool

Masami Hiramatsu (Google) (1):
      fprobe, samples: Add module parameter descriptions

 MAINTAINERS                                  | 115 ++++++++++++++++++++++-----
 kernel/bpf/verifier.c                        | 113 +++++++++++---------------
 net/xdp/xsk_buff_pool.c                      |   1 +
 samples/fprobe/fprobe_example.c              |   7 ++
 tools/testing/selftests/bpf/verifier/jmp32.c |  21 +++++
 tools/testing/selftests/bpf/verifier/jump.c  |  22 +++++
 6 files changed, 193 insertions(+), 86 deletions(-)
