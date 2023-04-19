Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA40A6E823F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjDST6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjDST6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:58:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7F26B5;
        Wed, 19 Apr 2023 12:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=LxBKG7hjPDqtJt40ExcWnkknGjlZ3Me2MkkSjoLZIu0=; b=aRbIiBZ5hqDSRRQx/dKT6t6Y0s
        3gCp2ICJLC7zm0VtCJJPLUwzshdNA9Ijl5nJCItJRJhuwuVL0UPnezMmzyccNYeEqF1qaggn2O8EH
        8jbfAoQC3c5WRe+n7H+cfOLDrg8SmCcM2P3zn27KLDosJ7QZKK3MEPBIhexwXnYeZI4e52cHIhEkL
        FHVn158LDcShC7iexE5hjYJj4FgLBPgIr/CRN8Ct/VoU7aDxdbOWcgDMSr0S2hqHWgjsNPLdrsjLN
        BfXobzuK41oki0wGDeZ9xaDIGW3uWRrLqHuY1INhnmxyEVBUmJa9s73r0qaqWHqAKvI+IS6tcWvMJ
        xZLU4S2A==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ppDx1-0002CQ-Rz; Wed, 19 Apr 2023 21:58:47 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2023-04-19
Date:   Wed, 19 Apr 2023 21:58:47 +0200
Message-Id: <20230419195847.27060-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26880/Wed Apr 19 09:22:57 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

We've added 3 non-merge commits during the last 6 day(s) which contain
a total of 3 files changed, 34 insertions(+), 9 deletions(-).

The main changes are:

1) Fix a crash on s390's bpf_arch_text_poke() under a NULL new_addr,
   from Ilya Leoshkevich.

2) Fix a bug in BPF verifier's precision tracker, from Daniel Borkmann
   and Andrii Nakryiko.

3) Fix a regression in veth's xdp_features which led to a broken BPF CI
   selftest, from Lorenzo Bianconi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Heiko Carstens, John Fastabend, Juan Jose Lopez Jaimez, Meador Inge, 
Nenad Stojanovski, Simon Scannell, Thomas Richter

----------------------------------------------------------------

The following changes since commit 829cca4d1783088e43bace57a555044cc937c554:

  Merge tag 'net-6.3-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-04-13 15:33:04 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git tags/for-netdev

for you to fetch changes up to 71b547f561247897a0a14f3082730156c0533fed:

  bpf: Fix incorrect verifier pruning due to missing register precision taints (2023-04-19 10:18:18 -0700)

----------------------------------------------------------------
bpf-for-netdev

----------------------------------------------------------------
Daniel Borkmann (1):
      bpf: Fix incorrect verifier pruning due to missing register precision taints

Ilya Leoshkevich (1):
      s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL

Lorenzo Bianconi (1):
      veth: take into account peer device for NETDEV_XDP_ACT_NDO_XMIT xdp_features flag

 arch/s390/net/bpf_jit_comp.c | 11 ++++++++---
 drivers/net/veth.c           | 17 +++++++++++------
 kernel/bpf/verifier.c        | 15 +++++++++++++++
 3 files changed, 34 insertions(+), 9 deletions(-)
