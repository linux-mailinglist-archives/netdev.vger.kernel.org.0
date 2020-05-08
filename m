Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA20E1CBB14
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgEHXFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:05:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:36838 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgEHXFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:05:30 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jXC3b-0005vh-SA; Sat, 09 May 2020 01:05:27 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-05-09
Date:   Sat,  9 May 2020 01:05:27 +0200
Message-Id: <20200508230527.24382-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25806/Fri May  8 14:16:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 4 non-merge commits during the last 9 day(s) which contain
a total of 4 files changed, 11 insertions(+), 6 deletions(-).

The main changes are:

1) Fix msg_pop_data() helper incorrectly setting an sge length in some
   cases as well as fixing bpf_tcp_ingress() wrongly accounting bytes
   in sg.size, from John Fastabend.

2) Fix to return an -EFAULT error when copy_to_user() of the value
   fails in map_lookup_and_delete_elem(), from Wei Yongjun.

3) Fix sk_psock refcnt leak in tcp_bpf_recvmsg(), from Xiyu Yang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Jakub Sitnicki, Martin KaFai Lau

----------------------------------------------------------------

The following changes since commit 37255e7a8f470a7d9678be89c18ba15d6ebf43f7:

  Merge tag 'batadv-net-for-davem-20200427' of git://git.open-mesh.org/linux-merge (2020-04-27 13:02:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 81aabbb9fb7b4b1efd073b62f0505d3adad442f3:

  bpf, sockmap: bpf_tcp_ingress needs to subtract bytes from sg.size (2020-05-06 00:22:22 +0200)

----------------------------------------------------------------
John Fastabend (2):
      bpf, sockmap: msg_pop_data can incorrecty set an sge length
      bpf, sockmap: bpf_tcp_ingress needs to subtract bytes from sg.size

Wei Yongjun (1):
      bpf: Fix error return code in map_lookup_and_delete_elem()

Xiyu Yang (1):
      bpf: Fix sk_psock refcnt leak when receiving message

 include/linux/skmsg.h |  1 +
 kernel/bpf/syscall.c  |  4 +++-
 net/core/filter.c     |  2 +-
 net/ipv4/tcp_bpf.c    | 10 ++++++----
 4 files changed, 11 insertions(+), 6 deletions(-)
