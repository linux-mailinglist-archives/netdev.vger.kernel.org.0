Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969121960C2
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgC0VyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:54:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:50696 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgC0VyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 17:54:12 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHwvV-0006bl-IT; Fri, 27 Mar 2020 22:54:05 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-03-27
Date:   Fri, 27 Mar 2020 22:54:05 +0100
Message-Id: <20200327215405.29657-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 3 non-merge commits during the last 4 day(s) which contain
a total of 4 files changed, 25 insertions(+), 20 deletions(-).

The main changes are:

1) Explicitly memset the bpf_attr structure on bpf() syscall to avoid
   having to rely on compiler to do so. Issues have been noticed on
   some compilers with padding and other oddities where the request was
   then unexpectedly rejected, from Greg Kroah-Hartman.

2) Sanitize the bpf_struct_ops TCP congestion control name in order to
   avoid problematic characters such as whitespaces, from Martin KaFai Lau.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Potapenko, Alistair Delva, Andrii Nakryiko, Daniel Borkmann, 
John Stultz, Maciej Żenczykowski, Yonghong Song

----------------------------------------------------------------

The following changes since commit 32ca98feab8c9076c89c0697c5a85e46fece809d:

  net: ip_gre: Accept IFLA_INFO_DATA-less configuration (2020-03-16 17:19:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 5c6f25887963f15492b604dd25cb149c501bbabf:

  bpf: Explicitly memset some bpf info structures declared on the stack (2020-03-20 21:05:22 +0100)

----------------------------------------------------------------
Greg Kroah-Hartman (2):
      bpf: Explicitly memset the bpf_attr structure
      bpf: Explicitly memset some bpf info structures declared on the stack

Martin KaFai Lau (1):
      bpf: Sanitize the bpf_struct_ops tcp-cc name

 include/linux/bpf.h   |  1 +
 kernel/bpf/btf.c      |  3 ++-
 kernel/bpf/syscall.c  | 34 ++++++++++++++++++++--------------
 net/ipv4/bpf_tcp_ca.c |  7 ++-----
 4 files changed, 25 insertions(+), 20 deletions(-)
