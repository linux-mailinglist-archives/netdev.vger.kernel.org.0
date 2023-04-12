Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E166DF78A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjDLNnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjDLNnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:43:45 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC2C1705;
        Wed, 12 Apr 2023 06:43:43 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-54f21cdfadbso168802597b3.7;
        Wed, 12 Apr 2023 06:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307022; x=1683899022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TzxfLnJ6ym9jFbneOVl4Zhho/DPSUKhosX5v7vCwnaA=;
        b=TdpjEqrR0NpixLlPAW0RsgYNPCQMUBGt2mX1/C3BRxpSWMHd2SLCmUN/mGSEy3DCZa
         y/qDaIKj4+isxzF3AmPBwHMx9hyI8866gyUkyRyYFoPBlMXeVga7kJBLzvKyx2dc8olh
         3iWLECLQnJkdi88kVEKljYXMdWs60do9PtZNdgxgWIABslsbn0C06VtIYqzENxtwchFv
         6yH44t+4l5QvzbahpjdKHL7ht/zYIYgrEFv60xd5uodAYBh/DOjjIlhgicNydf4YsOKe
         RjhwpHcrpj7bRBfGdpy0C4irvHP2U6ROBPT7sF9DTnaw6s9IcJjeDLr7uWxF8oBsibSA
         mk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307022; x=1683899022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzxfLnJ6ym9jFbneOVl4Zhho/DPSUKhosX5v7vCwnaA=;
        b=S6j0E9YCTzMVxH+oRdw4dJsc817hWNm4npgpqWV735B4D2qKaPaqCICtLbolas20aS
         Mm6JCQwoa+KzRy5sQbopw33INSy94uLx0z6KsJ0JVWa4pWXuNBKndB2IkcHBUjC4Z9H7
         vE/YP3xXWu5mQd+gkaUOaf0sqGgamK1R+de6+bmlUxg1tqbvWA4o3xNEUoy/5gRkcYjo
         LsgM1AgkBoSd3e1TXu3D6fmkwI5sn/5VcaI7nxLd3I2aS/gorT8mROAjMwhJ4KctwxGA
         5a0mrR/eOs/jsFBwD1bEbGc1vXhYkB2y9FbgJRYpOFP0HNCnlMXAH1/khfM8UMp94D6Y
         JaYA==
X-Gm-Message-State: AAQBX9fjJz4P6n/McCduj8lABsAATI6KUCiKlhrLwZdjkza9+OMeGg2H
        e8eHDUKyI2+xE5cyzXCV58SjuNqZMifhAVEUkTU=
X-Google-Smtp-Source: AKy350azWW7f0ZmfXpl9pAAyl+Im1D2Z4dViMNgFyz3rq82QFwX5mtlvNv0rh92pQZJc9jf+49iY2n7IDBPViyCBfo8=
X-Received: by 2002:a81:a948:0:b0:543:bbdb:8c2b with SMTP id
 g69-20020a81a948000000b00543bbdb8c2bmr10753315ywh.10.1681307022595; Wed, 12
 Apr 2023 06:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230410120629.642955-1-kal.conley@dectris.com>
In-Reply-To: <20230410120629.642955-1-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 12 Apr 2023 15:43:31 +0200
Message-ID: <CAJ8uoz1CmRNMdTu3on7VL2Jrvo9z3WvdmFE_hSEiZDLiO-xtFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/4] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Conley <kal.conley@dectris.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Apr 2023 at 14:08, Kal Conley <kal.conley@dectris.com> wrote:
>
> The main purpose of this patchset is to add AF_XDP support for UMEM
> chunk sizes > PAGE_SIZE. This is enabled for UMEMs backed by HugeTLB
> pages.
>
> Note, v5 fixes a major bug in previous versions of this patchset.
> In particular, dma_map_page_attrs used to be called once for each
> order-0 page in a hugepage with the assumption that returned I/O
> addresses are contiguous within a hugepage. This assumption is incorrect
> when an IOMMU is enabled. To fix this, v5 does DMA page accounting
> accounting at hugepage granularity.

Thank you so much Kal for implementing this feature. After you have
fixed the three small things I had for patch #2, you have my ack for
the whole set below. Please add it.

For the whole set:
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

It would be great if you have the time and desire to also take this to
zero-copy mode. I have had multiple AF_XDP users mailing me privately
that such a feature would be very useful for them. For some of them it
was even a requirement to be able to get down to the latencies they
were aiming for.

> Changes since v4:
>   * Use hugepages in DMA map (fixes zero-copy mode with IOMMU).
>   * Use pool->dma_pages to check for DMA. This change is needed to avoid
>     performance regressions).
>   * Update commit message and benchmark table.
>
> Changes since v3:
>   * Fix checkpatch.pl whitespace error.
>
> Changes since v2:
>   * Related fixes/improvements included with v2 have been removed. These
>     changes have all been resubmitted as standalone patchsets.
>   * Minimize uses of #ifdef CONFIG_HUGETLB_PAGE.
>   * Improve AF_XDP documentation.
>   * Update benchmark table in commit message.
>
> Changes since v1:
>   * Add many fixes/improvements to the XSK selftests.
>   * Add check for unaligned descriptors that overrun UMEM.
>   * Fix compile errors when CONFIG_HUGETLB_PAGE is not set.
>   * Fix incorrect use of _Static_assert.
>   * Update AF_XDP documentation.
>   * Rename unaligned 9K frame size test.
>   * Make xp_check_dma_contiguity less conservative.
>   * Add more information to benchmark table.
>
> Thanks to Magnus Karlsson for all his support!
>
> Happy Easter!
>
> Kal Conley (4):
>   xsk: Use pool->dma_pages to check for DMA
>   xsk: Support UMEM chunk_size > PAGE_SIZE
>   selftests: xsk: Use hugepages when umem->frame_size > PAGE_SIZE
>   selftests: xsk: Add tests for 8K and 9K frame sizes
>
>  Documentation/networking/af_xdp.rst      | 36 ++++++++++------
>  include/net/xdp_sock.h                   |  2 +
>  include/net/xdp_sock_drv.h               | 12 ++++++
>  include/net/xsk_buff_pool.h              | 12 +++---
>  net/xdp/xdp_umem.c                       | 55 +++++++++++++++++++-----
>  net/xdp/xsk_buff_pool.c                  | 43 ++++++++++--------
>  tools/testing/selftests/bpf/xskxceiver.c | 27 +++++++++++-
>  tools/testing/selftests/bpf/xskxceiver.h |  2 +
>  8 files changed, 142 insertions(+), 47 deletions(-)
>
> --
> 2.39.2
>
