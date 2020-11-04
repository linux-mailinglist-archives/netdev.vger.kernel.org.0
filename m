Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24732A65FE
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgKDOKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730127AbgKDOJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:09:33 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04A3C0613D3;
        Wed,  4 Nov 2020 06:09:33 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id g12so16707678pgm.8;
        Wed, 04 Nov 2020 06:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zvWqwPBwGiZ2MsWmzeudBmT5RUtfYx6rpVfpWTyIQxo=;
        b=kZ6/upa+TFOrj8kQW4cldkJOCRYF0SPuSig+boblXP8cXym15pxx3J3SLQ98uLdkjH
         +HwDr8imuWk4azRG834k7mFT9mbO96Pe6hom1wcUKO4b8lL0JLWzXm48LLnW7h1b5Lfe
         7rtjzkyxmP8VltYVz7OgDLGykA3IBssXOuCbySMN7iqNX/OKIgHV5j5sfnSh507LFxhq
         qQ+ohgShJ7vQyRxDnHVnESP8JHS4D9J21KbwGzcdFzIEpQURICqW9AbH5Okfc5QZCFgy
         nnVptr2zkJtUOCO78SfJVbdaFkm07Mi38ODZe+YZfH/I/xVVZIQA89s5AuF64Oq2cHUz
         +DgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zvWqwPBwGiZ2MsWmzeudBmT5RUtfYx6rpVfpWTyIQxo=;
        b=F/s1HkRjNZtLGy41L1V4mJ8w2bWst2S4HWE//ydCdwCUKOMJFO5W08cfsx6I3ghe68
         LsaFQ6gWIFVg4XkWmjBf/J2m0NxWsMjS+ISaYNzDpWIco1bNriKYL0KZBvyDtWOmD3+m
         ufL5lAS0JSyuNc0b11tajV9G1sXIEiYY0sUeBKW0xhjDRI6moFDsQf/+2hDt7OAzrh2z
         cnu02LAG5Rw0Pdu7dYvqM3+9yAstP1w+rBJKvgIdbmeLQXa0IldB8Zp+eJKImT9mzjSI
         npJg3gKplki0sC/VkA3jWctTv37bFqemQjK5khML2mP7a4t8zN9VdiKRD4ybn0GjN0Mf
         vudQ==
X-Gm-Message-State: AOAM533Kq/7Y4HNV3ipwVGo4pv4Ym2qWqnR24Dnz9XsO0nbKqXTuoSRY
        SXgz4IJRZAPaqOfdCwGxYPMNDeuNmoTQxpR8clI=
X-Google-Smtp-Source: ABdhPJz+BhCegRf9c9cn7GWbuBbLx9eu+DDSpEFSV4VcIdy7x/7CoUhxcRa7zyDBnU/2UUCz8PK04A==
X-Received: by 2002:a62:2bd0:0:b029:18a:df0f:dd61 with SMTP id r199-20020a622bd00000b029018adf0fdd61mr15398993pfr.19.1604498973244;
        Wed, 04 Nov 2020 06:09:33 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:32 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 0/6] xsk: i40e: Tx performance improvements
Date:   Wed,  4 Nov 2020 15:08:56 +0100
Message-Id: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: xsk: i40e: Tx performance improvements

This patch set improves the performance of mainly the Tx processing of
AF_XDP sockets. Though, patch 4 also improves the Rx path. All in all,
this patch set improves the throughput of the l2fwd xdpsock
application by around 14%. If we just take a look at Tx processing part,
it is improved by nearly 50%.

Hopefully the new batched Tx interfaces should be of value to other
drivers implementing AF_XDP zero-copy support. But patch #4 is generic
and will improve performance of all drivers when using AF_XDP sockets
(under the premises explained in that patch).

@Daniel. In patch 4, I apply all the padding required to hinder the
adjacency prefetcher to prefetch the wrong things. After this patch
set, I will submit another patch set that introduces
____cacheline_padding_in_smp in include/linux/cache.h according to your
suggestions. The last patch in that patch set will then convert the
explicit paddings that we have now to ____cacheline_padding_in_smp.

This patch has been applied against commit d0b3d2d7e50d ("Merge branch 'selftests/bpf: Migrate test_tcpbpf_user to be a part of test_progs'")

Structure of the patch set:

Patch 1: Introduce lazy Tx completions in the i40e driver.
Patch 2: For the xdpsock sample, increment Tx stats at sending instead
         of at completion.
Patch 3: Remove an unnecessary sw ring access from the Tx path in i40e.
Patch 4: Introduce padding between all pointers and fields in the ring.
Patch 5: Introduce batched Tx descriptor interfaces.
Patch 6: Use the new batched interfaces in the i40e driver to get higher
         throughput.

Thanks: Magnus

Magnus Karlsson (6):
  i40e: introduce lazy Tx completions for AF_XDP zero-copy
  samples/bpf: increment Tx stats at sending
  i40e: remove unnecessary sw_ring access from xsk Tx
  xsk: introduce padding between more ring pointers
  xsk: introduce batched Tx descriptor interfaces
  i40e: use batched xsk Tx interfaces to increase performance

 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  14 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c     | 140 +++++++++++++++++--------
 include/net/xdp_sock_drv.h                     |   7 ++
 net/xdp/xsk.c                                  |  43 ++++++++
 net/xdp/xsk_queue.h                            |  93 +++++++++++++---
 samples/bpf/xdpsock_user.c                     |   6 +-
 9 files changed, 249 insertions(+), 63 deletions(-)

--
2.7.4
