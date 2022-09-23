Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384415E83CC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiIWUc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiIWUca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB1A1497A7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f23so1168016plr.6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=WK0bGuD2tAxqqCEo+J+Vcp/Ca26AMBReT0rLu9mHjWo=;
        b=Bq646OyB58An4Ya0i1tJSWid5B14G8+Igfn3fxCST+TPDeet6KAginBjtHf1G+96pP
         KMbRLvXh6hUd7mw6RJpRt7mflnBYm9ibc+vu8XY4rLIHczU3FqSb/xj3tEHFFGtr1oRe
         sICyRsZLX9/FsK6U8cZvA0aX8m/YlImy46ePk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WK0bGuD2tAxqqCEo+J+Vcp/Ca26AMBReT0rLu9mHjWo=;
        b=N88GsKp/OcWWb/A3KBTNyn7EPowtpKHCNNaqhGDhyU0VXxvXDEvNjjKRMuHCpkbwRY
         PbDDdcz3Vjxi1qy0x1JQhStg11N0kW37DTN8xZtb+ydPP1krg80ud1AkpquBdIhplt6t
         0itxpPTyULYfYDghnjumJLylTCxZ9y1ADhvaEMGdbHUTPfkaw0l9tuxoe9t3XrGwIWjv
         NpQPOJcsnenhKXdji5GOCTqeX1XkCM+EczeKh6QyQEdSLN6ejQ8xp+WGCF8ADKfe08FO
         cAzikOzg+iKoC0eu/dM4lneASUDaFJVX9Z0aVn+3QdTWovvxElRxNTr3LaHCw2sgnMXs
         mC7Q==
X-Gm-Message-State: ACrzQf3fdvX2/Irdb9lyFkG0If/g/Jwl6b9KJ/kKOYyX3efYJ8O0D583
        S+EiIguT5Wbqf3cDNBvuJIKhVg==
X-Google-Smtp-Source: AMsMyM72+AZrvCjzG0TpHX1QWIyqlT+yIJNjqD6XgzhlX4O0lN7py3H0HnAbWO3N8SQjTT6PAgNtPQ==
X-Received: by 2002:a17:90b:17cf:b0:202:95a2:e310 with SMTP id me15-20020a17090b17cf00b0020295a2e310mr23778042pjb.76.1663964906615;
        Fri, 23 Sep 2022 13:28:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t2-20020aa79462000000b0053639773ad8sm6832080pfq.119.2022.09.23.13.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:25 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 00/16] slab: Introduce kmalloc_size_roundup()
Date:   Fri, 23 Sep 2022 13:28:06 -0700
Message-Id: <20220923202822.2667581-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3290; h=from:subject; bh=6t8CTnxnusXxlhLGNxOhRs5l2789SVRbReUcmZgsVm4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbjKWBYYij171TDp3TdZmoZXSs7dXXkRN1eGod1 9RjCiP+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W4wAKCRCJcvTf3G3AJnMrD/ 9AYEfZWXDOv2krdFVvtjQthCuAcgKZVOWzfaX/ZBtQRlYjuppFlG2ED1IEpuIhD0Ir80c5xPT0sC6o NsiMZw3mMRacDRN1JKTgZIg3s63bBHGPVJzr9Ms7LrhbLULxcInTn8Kmx1m+j/SOpIaVQbOz2eMMkZ hq15TaNyE7pBLM9SdfCtAyTs9eRAtVTuYrwZqvgSDjZ61SXuxi2k37cjMCmPHUTq/sIlGgP+BbmYVU h4TXPtyeel8GsxvMTh+ZJLwcMIm74VL8RdFIlqhUbTT1t2IHy48AtxwQQhaVX0FoQuaeRVIHGZ6W3H G8nJ1wcWlIzz3bYBH022dj7eQTsTkVCk6mdVQzd0tBA9yKVcNDoLBacX1DCakWCtJtW9hB3nI7wGSo dddWD44+KFc7CqbVkUJUBWKf0KFDD+RBxraKtYUvKQrLMx0oq545fsuTe+Wx85iePymCMknPsuIu7T RqpkKnn423yOsp7n6oWGz2jCxpOIGyTubVpWH5O/cuXKNmrDFZz8jsL8Js/2Of2DYZ5nq9YGQsiXeg 2S+DEM7sXnFtd9YfGznNOceTXn0B6askh1+E8cTpDv624NJQscze/0hYjyKnnV10f4gf0FRf/X6SzA azwQEVgyfXgzY00yn92DXcmjocb95A4MMqEAG/m2SLnjQl6aJMp6R561rcig==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The main details on this series are in patch #2's commit log. It's long,
so I won't repeat it again here for the v2. As before, I've tried to
trim the CC list.

v2:
- _keep_ ksize(), but remove instrumentation (makes patch series smaller)
- reorganized skbuff logic to avoid yet more copy/paste code
- added a WARN to a separate skbuff ksize usage
- add new refactorings: bpf, openvswitch, devres, mempool, kasan
- dropped "independent" patches: iwlwifi, x86/microcode/AMD (sent separately)
v1: https://lore.kernel.org/lkml/20220922031013.2150682-1-keescook@chromium.org

Notes:

Originally when I was going to entirely remove ksize(), there were a
handful for refactorings that just needed to do ksize -> __ksize. In
the end, it was cleaner to actually leave ksize() as a real function,
just without the kasan instrumentation. I wonder, however, if it should
be converted into a static inline now?

I dropped Jakub's Ack because I refactored that code a bunch more.

The 2 patches that didn't need to call kmalloc_size_roundup() don't need
to be part of this series. (One is already in -next, actually.)

I'd like to land at least the first two patches in the coming v6.1 merge
window so that the per-subsystem patches can be sent to their various
subsystems directly. Vlastimil, what you think?

Thanks!

-Kees


Kees Cook (16):
  slab: Remove __malloc attribute from realloc functions
  slab: Introduce kmalloc_size_roundup()
  skbuff: Proactively round up to kmalloc bucket size
  skbuff: Phase out ksize() fallback for frag_size
  net: ipa: Proactively round up to kmalloc bucket size
  igb: Proactively round up to kmalloc bucket size
  btrfs: send: Proactively round up to kmalloc bucket size
  dma-buf: Proactively round up to kmalloc bucket size
  coredump: Proactively round up to kmalloc bucket size
  openvswitch: Use kmalloc_size_roundup() to match ksize() usage
  bpf: Use kmalloc_size_roundup() to match ksize() usage
  devres: Use kmalloc_size_roundup() to match ksize() usage
  mempool: Use kmalloc_size_roundup() to match ksize() usage
  kasan: Remove ksize()-related tests
  mm: Make ksize() a reporting-only function
  slab: Restore __alloc_size attribute to __kmalloc_track_caller

 drivers/base/devres.c                     |  3 +
 drivers/dma-buf/dma-resv.c                |  9 ++-
 drivers/net/ethernet/intel/igb/igb_main.c |  5 +-
 drivers/net/ipa/gsi_trans.c               |  7 +-
 fs/btrfs/send.c                           | 11 +--
 fs/coredump.c                             |  7 +-
 include/linux/compiler_types.h            | 13 ++--
 include/linux/skbuff.h                    |  5 +-
 include/linux/slab.h                      | 46 +++++++++++--
 kernel/bpf/verifier.c                     | 49 +++++++++-----
 lib/test_kasan.c                          | 42 ------------
 mm/kasan/shadow.c                         |  4 +-
 mm/mempool.c                              |  2 +-
 mm/slab.c                                 |  9 ++-
 mm/slab_common.c                          | 62 ++++++++++-------
 net/core/skbuff.c                         | 82 ++++++++++++-----------
 net/openvswitch/flow_netlink.c            |  2 +-
 17 files changed, 192 insertions(+), 166 deletions(-)

-- 
2.34.1

