Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAB74D0F76
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 06:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiCHFuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 00:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiCHFt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 00:49:59 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421BDB90;
        Mon,  7 Mar 2022 21:49:04 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id b16so5429075ioz.3;
        Mon, 07 Mar 2022 21:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SvVgbRCoJ3f3R8rD30iOqtOeMBt+aEK3x/P1jvJWyPI=;
        b=WnL4Knf6KMVhNEW/jjZQUyVqydDR4r9W+bhJRiwnc6ypRXg9DWVjqCRP1coza9I+bp
         ZEtnyk1/NBcnL4OMKzGk+FOtWcHMaSaTBXVrif97u5DWAvxAmSXeeibZDdnzT11JutAq
         6Dhs0frsKMVXVmaaxGDbiOgQf0u4XnBB3Z8xbo7u/1r5ymNd3AWbK4hq901Hy8/g5HNS
         lYN13c27xgdNjaQOaQKkOL7MnJGrKmqAQ7Rzco9DQQnp9RZcJ+CvOGu39OsRfhKDIoc+
         XfixZkWjDxrFPndgEl4SFMuGsPh+KwxqmD0rPX7Iw1zC4PUKsVIKK3dml1Ox0MbECbfn
         Cwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SvVgbRCoJ3f3R8rD30iOqtOeMBt+aEK3x/P1jvJWyPI=;
        b=0V24ypAkXL7wFDBL0Y9a53WfHSu+2CICSyoeRCzUgc/oAua+Oh7a0ftTLs988ZRK3L
         4LfZN2P+xgPOaal2GtalyXVuBPUk3Ykk75om4uD/GLMtteWYvi+zBECirJCMX6AZDiRY
         iL3LG0zO9XmdmXbOQbcsMaSw9peSwxuKFkV0oTEjvsFEVoZyJ64SZqWuRbm7Ih5w2gqy
         0NvWBBdwjan/0Yp4hSnE9HMvqTxlcm9Bg+KI1QvbdZco6PE/tr4Zomr+nJpbMiRdyL4h
         u9JiiJRUrwqXx6UGZEfwSPe6H1p2OvR3drY+Q7qhg0DCZotlmtIj4m3zAAZrRiIPlbAp
         zUUQ==
X-Gm-Message-State: AOAM533zzIHqjpHkuSPg5MWr42uzkgZq5GkWBUC954v3plqkldTjIMte
        7L67y3+zr0xRnN3gRPeb02eost364oARAkjc2qw=
X-Google-Smtp-Source: ABdhPJz48Pz1mxWQzVhSmNLbDFPR4fF7OL88EG2lz+h6tIDjPeifjK+06dDlqOUafYzeN7PuWNswzBoEz3hcYFcE0xM=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr4399871ioi.154.1646718543541; Mon, 07
 Mar 2022 21:49:03 -0800 (PST)
MIME-Version: 1.0
References: <20220306234311.452206-1-memxor@gmail.com>
In-Reply-To: <20220306234311.452206-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 21:48:52 -0800
Message-ID: <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_pointer'
> returning a packet pointer with a fixed immutable range. This can be useful to
> enable DPA without having to use memcpy (currently the case in
> bpf_xdp_load_bytes and bpf_xdp_store_bytes).
>
> The intended usage to read and write data for multi-buff XDP is:
>
>         int err = 0;
>         char buf[N];
>
>         off &= 0xffff;
>         ptr = bpf_packet_pointer(ctx, off, sizeof(buf), &err);
>         if (unlikely(!ptr)) {
>                 if (err < 0)
>                         return XDP_ABORTED;
>                 err = bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf));
>                 if (err < 0)
>                         return XDP_ABORTED;
>                 ptr = buf;
>         }
>         ...
>         // Do some stores and loads in [ptr, ptr + N) region
>         ...
>         if (unlikely(ptr == buf)) {
>                 err = bpf_xdp_store_bytes(ctx, off, buf, sizeof(buf));
>                 if (err < 0)
>                         return XDP_ABORTED;
>         }
>
> Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM, because
> these pointers need to be invalidated on clear_all_pkt_pointers invocation, and
> it is also more meaningful to the user to see return value as R0=pkt.
>
> This series is meant to collect feedback on the approach, next version can
> include a bpf_skb_pointer and exposing it as bpf_packet_pointer helper for TC
> hooks, and explore not resetting range to zero on r0 += rX, instead check access
> like check_mem_region_access (var_off + off < range), since there would be no
> data_end to compare against and obtain a new range.
>
> The common name and func_id is supposed to allow writing generic code using
> bpf_packet_pointer that works for both XDP and TC programs.
>
> Please see the individual patches for implementation details.
>

Joanne is working on a "bpf_dynptr" framework that will support
exactly this feature, in addition to working with dynamically
allocated memory, working with memory of statically unknown size (but
safe and checked at runtime), etc. And all that within a generic
common feature implemented uniformly within the verifier. E.g., it
won't need any of the custom bits of logic added in patch #2 and #3.
So I'm thinking that instead of custom-implementing a partial case of
bpf_dynptr just for skb and xdp packets, let's maybe wait for dynptr
and do it only once there?

See also my ARG_CONSTANT comment. It seems like a pretty common thing
where input constant is used to characterize some pointer returned
from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
that for bpf_dynptr for exactly this "give me direct access of N
bytes, if possible" case. So improving/generalizing it now before
dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
feature itself.

> Kumar Kartikeya Dwivedi (5):
>   bpf: Add ARG_SCALAR and ARG_CONSTANT
>   bpf: Introduce pkt_uid concept for PTR_TO_PACKET
>   bpf: Introduce bpf_packet_pointer helper to do DPA
>   selftests/bpf: Add verifier tests for pkt pointer with pkt_uid
>   selftests/bpf: Update xdp_adjust_frags to use bpf_packet_pointer
>
>  include/linux/bpf.h                           |   4 +
>  include/linux/bpf_verifier.h                  |   9 +-
>  include/uapi/linux/bpf.h                      |  12 ++
>  kernel/bpf/verifier.c                         |  97 ++++++++++--
>  net/core/filter.c                             |  48 +++---
>  tools/include/uapi/linux/bpf.h                |  12 ++
>  .../bpf/prog_tests/xdp_adjust_frags.c         |  46 ++++--
>  .../bpf/progs/test_xdp_update_frags.c         |  46 ++++--
>  tools/testing/selftests/bpf/verifier/xdp.c    | 146 ++++++++++++++++++
>  9 files changed, 358 insertions(+), 62 deletions(-)
>
> --
> 2.35.1
>
