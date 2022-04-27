Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805F8512484
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiD0VbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbiD0VbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:31:05 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69252DD7;
        Wed, 27 Apr 2022 14:27:51 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1njpCO-0008ak-Hz; Wed, 27 Apr 2022 23:27:48 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-04-27
Date:   Wed, 27 Apr 2022 23:27:48 +0200
Message-Id: <20220427212748.9576-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26525/Wed Apr 27 10:19:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 5 non-merge commits during the last 20 day(s) which contain
a total of 6 files changed, 34 insertions(+), 12 deletions(-).

The main changes are:

1) Fix xsk sockets when rx and tx are separately bound to the same umem, also
   fix xsk copy mode combined with busy poll, from Maciej Fijalkowski.

2) Fix BPF tunnel/collect_md helpers with bpf_xmit lwt hook usage which triggered
   a crash due to invalid metadata_dst access, from Eyal Birger.

3) Fix release of page pool in XDP live packet mode, from Toke Høiland-Jørgensen.

4) Fix potential NULL pointer dereference in kretprobes, from Adam Zabrocki.

   (Masami & Steven preferred this small fix to be routed via bpf tree given it's
    follow-up fix to Masami's rethook work that went via bpf earlier, too.)

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Freysteinn Alfredsson, Magnus Karlsson, Masami Hiramatsu, Song Liu

----------------------------------------------------------------

The following changes since commit ec4eb8a86ade4d22633e1da2a7d85a846b7d1798:

  drivers: net: slip: fix NPD bug in sl_tx_timeout() (2022-04-06 23:00:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to ba3beec2ec1d3b4fd8672ca6e781dac4b3267f6e:

  xsk: Fix possible crash when multiple sockets are created (2022-04-26 16:19:54 +0200)

----------------------------------------------------------------
Adam Zabrocki (1):
      kprobes: Fix KRETPROBES when CONFIG_KRETPROBE_ON_RETHOOK is set

Eyal Birger (1):
      bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Maciej Fijalkowski (2):
      xsk: Fix l2fwd for copy mode + busy poll combo
      xsk: Fix possible crash when multiple sockets are created

Toke Høiland-Jørgensen (1):
      bpf: Fix release of page_pool in BPF_PROG_RUN in test runner

 include/net/xsk_buff_pool.h |  1 +
 kernel/kprobes.c            |  2 +-
 net/bpf/test_run.c          |  5 +++--
 net/core/lwt_bpf.c          |  7 +++----
 net/xdp/xsk.c               | 15 ++++++++++++++-
 net/xdp/xsk_buff_pool.c     | 16 ++++++++++++----
 6 files changed, 34 insertions(+), 12 deletions(-)
