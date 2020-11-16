Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545C62B425B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgKPLNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbgKPLNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:13:42 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A13C0613CF;
        Mon, 16 Nov 2020 03:13:40 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f18so12891243pgi.8;
        Mon, 16 Nov 2020 03:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fd3j9uuEENu9UlSJJCk2TZ/GIY6gOBNNv6sc0awLDhU=;
        b=VoCsjpglqNDJIPRyfEU01qzHu3pFHmMuPAw3EW8Zp+2zWGXnUU0uVq0u0/ywnba5Jr
         u+g2XZI3WsiBfJHaFdeyVBLITzGsSzRK2dH1GMy3QVaGYi7BznzCeFNNT6KIV7PYc3eN
         70HHVgjQ1Po1yy+7Vfqlyczkfz4pQcpS3VZlCkkHAXYAVa2km0rQy11RNwK/aKGXokvm
         Z1FnQIawwaMDEBDieuF2gpZWlJxMZu1VqH8KgcIEpFNiKe8dTSrmbhaRMzomFR6hVmV/
         ++ORjsd3j71zWDmvrWiDXYjU53o1s1WOKPUfms4W/3XJQ9l7K0afiQ+sRKR9ep0u682J
         0PLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fd3j9uuEENu9UlSJJCk2TZ/GIY6gOBNNv6sc0awLDhU=;
        b=NapGLpsjRBXGOZHhPd3/aVo0fje+/512H6DCkIisssixz8PAjCnkcjBQ6cFPYz07/o
         Fjv7+9wPCBNnofYaV8vxM/RiYokLl/JXHle+yw4x5Xh1p0DPtQ2gpdRWWlX2ojjxOmS4
         HMTe3whPzOFl/BgkA8+HCNpMFAoZ3err7sNrmlj1qyWPVn2mU6JTerLTAxC1eMEt0hYX
         NWtYXlq4k9l85QxMBh17rD2OA/JayxsJz8bZP21nl5HqSuK2olB0RzBB75Qi3ZXrruLw
         4OaO+o3Qt2PQEm2526petFZyMJruwBSlFp5AoOK9d8UGPQnVMH+KunAXnpANCrFi3Lv+
         AHnA==
X-Gm-Message-State: AOAM5329iXZ/QIuJJwJJDFlDxhx9rK/GVTzMSnu/swYl0zKFJQZlappE
        fbAqbVw/qMa8O8yFkyg1WpE=
X-Google-Smtp-Source: ABdhPJzlIOn+THuIXa9zMLmHVEWpB/XaQ2mDTUv9dx+ZAFlYZE58RuQBVqJigmPRuSsvhexy7CwFAQ==
X-Received: by 2002:a65:6219:: with SMTP id d25mr12185351pgv.1.1605525220388;
        Mon, 16 Nov 2020 03:13:40 -0800 (PST)
Received: from localhost.localdomain ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id u24sm19486826pfm.81.2020.11.16.03.13.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 03:13:39 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 0/5] xsk: i40e: Tx performance improvements
Date:   Mon, 16 Nov 2020 12:12:42 +0100
Message-Id: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
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

v2 -> v3:
* Fixed #pragma warning with clang and defined a loop_unrolled_for macro
  for easier readability [lkp, Nick]
* Simplified invalid descriptor handling in xskq_cons_read_desc_batch()

v1 -> v2:
* Removed added parameter in i40e_setup_tx_descriptors and adopted a
  simpler solution [Maciej]
* Added test for !xs in xsk_tx_peek_release_desc_batch() [John]
* Simplified return path in xsk_tx_peek_release_desc_batch() [John]
* Dropped patch #1 in v1 that introduced lazy completions. Hopefully
  this is not needed when we get busy poll [Jakub]
* Iterate over local variable in xskq_prod_reserve_addr_batch() for
  improved performance
* Fixed the fallback path in xsk_tx_peek_release_desc_batch() so that
  it also produces a batch of descriptors, albeit by using the slower
  (but more general) older code. This improves the performance of the
  case when multiple sockets are sharing the same device and queue id.

This patch has been applied against commit 2d38c5802f46 ("Merge branch 'ionic-updates'")

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
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 123 +++++++++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  16 ++++
 include/net/xdp_sock_drv.h                  |   7 ++
 net/xdp/xsk.c                               |  57 +++++++++++++
 net/xdp/xsk_queue.h                         |  93 +++++++++++++++++----
 samples/bpf/xdpsock_user.c                  |   6 +-
 8 files changed, 258 insertions(+), 56 deletions(-)

--
2.7.4
