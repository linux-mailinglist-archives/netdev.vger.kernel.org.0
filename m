Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350FD2AD44D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgKJLCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgKJLCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:02:03 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043A1C0613CF;
        Tue, 10 Nov 2020 03:02:03 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f18so5356083pgi.8;
        Tue, 10 Nov 2020 03:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tIKGrt6J+Y8Csinv4zD15DzbbGsvacQGOQzlpB8RApI=;
        b=bUm3ugH/WQyhNNfXO9goc2kRRJEKo1uOcw7LOry7/J4y1zlDwvUDDi8gIoFKskhxtm
         m+uUuDpgB3XPI9912mg4Pqxliae4UHqzlRqTyodZUEhylKDCAZli0BdC5zpJ/4fuCNgD
         OD9BE8Jz3TflqDPfD7B6pPzHFwPWY/wNcrxzMp0t2HkgFuZqlY9QsGZTuPcw0rNjEyaC
         6YuC9MuA1C3/rucA0rxndCHNuW8f4VyqF0g8afL5fkyg4YYVoZggHk7jH27ys3rSSyr9
         X78TN8ls0CL/PzK9BRK9K9ba44eCUgErDxenOURPkGk3+L528zeEUkQDlBNAO+ggDyU+
         jLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tIKGrt6J+Y8Csinv4zD15DzbbGsvacQGOQzlpB8RApI=;
        b=KWUlTNihNEBL7QUuB9T/N2c6NSerWdcWL16S7lQ8wV648fHEOwynqL9dWvMDDZr86R
         fMqFNEMy2Kne7hPff0xUcNWlJwKlLfaioMh5zTGbhqSvhsdc0rxNBVTMugkGehyIQV1A
         DOfqr3Q0TDjes+mHxaUDwbS3rOgmwN0XEJ/lYa3iMpqoIabRNX0hPHgdLZp7ML44Q91z
         kmCtgNOs75Wy9wZBouv9VPaPuyb0+NPrao+OppgzW5sCP7Zz/HL/AH1IwWveB94YilC+
         DDxB6vpfQY8uHXyUNDsa3bZkiIHZ7NCbasHeA+wIuqT6eVjaHR8rtflbIl96N6uihZ2b
         Ex8w==
X-Gm-Message-State: AOAM532EGESHpkzjG08zpB94OjBqNfEGa2oDHQKpGG9rTe/WskGpMdx6
        7/dVVEEVEFzuT6yGnjTQN8E=
X-Google-Smtp-Source: ABdhPJxWM9IZLP4RLhCzAfXWllkGCFfb1U9El/YV03L7+W5dopH6LLZvyszz1tc78C3UAnUEVkaQBw==
X-Received: by 2002:a17:90a:ec17:: with SMTP id l23mr4584694pjy.154.1605006122575;
        Tue, 10 Nov 2020 03:02:02 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 22sm3012024pjb.40.2020.11.10.03.01.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 03:02:02 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v2 0/5] xsk: i40e: Tx performance improvements
Date:   Tue, 10 Nov 2020 12:01:29 +0100
Message-Id: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set improves the performance of mainly the Tx processing of
AF_XDP sockets. Though, patch 3 also improves the Rx path. All in all,
this patch set improves the throughput of the l2fwd xdpsock
application by around 11%. If we just take a look at Tx processing part,
it is improved by 35% to 40%.

Hopefully the new batched Tx interfaces should be of value to other
drivers implementing AF_XDP zero-copy support. But patch #3 is generic
and will improve performance of all drivers when using AF_XDP sockets
(under the premises explained in that patch).

@Daniel. In patch 3, I apply all the padding required to hinder the
adjacency prefetcher to prefetch the wrong things. After this patch
set, I will submit another patch set that introduces
____cacheline_padding_in_smp in include/linux/cache.h according to your
suggestions. The last patch in that patch set will then convert the
explicit paddings that we have now to ____cacheline_padding_in_smp.

v1 -> v2:
* Removed added parameter in i40e_setup_tx_descriptors and adopted a
  simpler solution [Maciej]
* Added test for !xs in xsk_tx_peek_release_desc_batch() [John]
* Simplified return path in xsk_tx_peek_release_desc_batch() [John]
* Dropped patch #1 in v1 that introduced lazy completions. Hopefully
  this is not needed when we get busy poll. [Jakub]
* Iterate over local variable in xskq_prod_reserve_addr_batch() for
  improved performance
* Fixed the fallback path in xsk_tx_peek_release_desc_batch() so that
  it also produces a batch of descriptors, albeit by using the slower
  (but more general) older code. This improves the performance of the
  case when multiple sockets are sharing the same device and queue id.

This patch has been applied against commit f52b8fd33257 ("bpf: selftest: Use static globals in tcp_hdr_options and btf_skc_cls_ingress")

Structure of the patch set:

Patch 1: For the xdpsock sample, increment Tx stats at sending instead
         of at completion.
Patch 2: Remove an unnecessary sw ring access from the Tx path in i40e.
Patch 3: Introduce padding between all pointers and fields in the ring.
Patch 4: Introduce batched Tx descriptor interfaces.
Patch 5: Use the new batched interfaces in the i40e driver to get higher
         throughput.

Thanks: Magnus

Magnus Karlsson (5):
  samples/bpf: increment Tx stats at sending
  i40e: remove unnecessary sw_ring access from xsk Tx
  xsk: introduce padding between more ring pointers
  xsk: introduce batched Tx descriptor interfaces
  i40e: use batched xsk Tx interfaces to increase performance

 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  11 +++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |   1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 131 +++++++++++++++++++---------
 include/net/xdp_sock_drv.h                  |   7 ++
 net/xdp/xsk.c                               |  57 ++++++++++++
 net/xdp/xsk_queue.h                         |  96 +++++++++++++++++---
 samples/bpf/xdpsock_user.c                  |   6 +-
 7 files changed, 253 insertions(+), 56 deletions(-)

--
2.7.4
