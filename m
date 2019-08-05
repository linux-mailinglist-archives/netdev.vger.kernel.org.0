Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0C826F4
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfHEV3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729834AbfHEV3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:29:10 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF92D20B1F;
        Mon,  5 Aug 2019 21:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040549;
        bh=i/7VrDyauDUnOWh/jBVyZJrYNnTOpmGMAy5qLU3F4nw=;
        h=From:To:Cc:Subject:Date:From;
        b=Q1588paOMRvR+ZBYtYE+yN2FFfcmHIDgRgd7iH1g0yCzhvVexdsOJIPYQTBMBp5OZ
         6WlMScw0n8g9isPJDN2JqBuEO90jnLk+X/oAxgXqbW6ojPhdBy9b6bZhW7QstRPBjk
         tOrIfnCooMM/BLNFIrB5H456SrU9o84P5zfumzOE=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [WIP 0/4] bpf: A bit of progress toward unprivileged use
Date:   Mon,  5 Aug 2019 14:29:01 -0700
Message-Id: <cover.1565040372.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other than the mknod() patch, this is not ready for prime time.  These
patches try to make progress toward making bpf() more useful without
privilege

Andy Lutomirski (4):
  bpf: Respect persistent map and prog access modes
  bpf: Don't require mknod() permission to pin an object
  bpf: Add a way to mark functions as requiring privilege
  bpf: Allow creating all program types without privilege

 include/linux/bpf.h          | 30 +++++++++++++++-----
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/arraymap.c        |  8 +++++-
 kernel/bpf/cgroup.c          |  6 +++-
 kernel/bpf/inode.c           | 29 +++++++++++--------
 kernel/bpf/syscall.c         | 54 +++++++++++++++++++++++++-----------
 kernel/bpf/verifier.c        |  8 ++++++
 kernel/events/core.c         |  5 ++--
 kernel/trace/bpf_trace.c     |  1 +
 net/core/dev.c               |  4 ++-
 net/core/filter.c            |  8 ++++--
 net/netfilter/xt_bpf.c       |  5 ++--
 net/packet/af_packet.c       |  2 +-
 13 files changed, 115 insertions(+), 46 deletions(-)

-- 
2.21.0

