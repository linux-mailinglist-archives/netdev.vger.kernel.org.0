Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246054D10B9
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 08:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344501AbiCHHJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 02:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344488AbiCHHJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 02:09:27 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E744433882;
        Mon,  7 Mar 2022 23:08:31 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z4so15638148pgh.12;
        Mon, 07 Mar 2022 23:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Im7jvRNh/+Pw/q4dfL4KJR6p5CokLYnnteKa2XpYZZA=;
        b=L+97Fuk8zObxNl42ypmo1qi9vzxXbkUFXqkWSzZbTgZgoiMhmIglBUUitVLXx1cHcs
         WWGkJjlVtFGDG7PEJKUhxImdF+7xJlPBivXObMKxgdqSe95muesGgmdsZuHITtnB4qQF
         qXYkajqF/AxWIn+M8DOXoml6zIEM8uTausMCi/7b0iYZRjrqKwglWeqWcnR/HW16mn4B
         wI6gp+nCENFg/y5Rcz1hBWmyrOUVLv9P6cAJdsEtEDo0UUYDCe8JAJ7n6RcPX3l/f/jx
         jahiaosH1zgPiKKNKS8qXOLKRhzIvRj8b4s/yZjXRT6j6enWV4Z5sxTGv6xrS3Fcd9Q5
         sKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Im7jvRNh/+Pw/q4dfL4KJR6p5CokLYnnteKa2XpYZZA=;
        b=oR1JlWs/sXrSFxphW3aQPYrA28/VSAcjhamjz/cX3yJk9lYhqOZmksMaOWhvxuOCud
         mVGbzMNf0hpbxKfjV+40LmM2vN232iEhZOk+FRZ1bv525NtHKoadDgQszPd1PA8Gwwxm
         pfmjmr63c1IuxiBHgQtJx3umvZhGba+nWqlQM/e5UUKfD0pa7/fKPJ7J5D7QOuXA8LYX
         WKC9ZD+eY+QwXaHdMDkiQW6c6qlVdO7xA8yWA4vhu5ihLrmcDjidMRCs2FUCaujO8mwF
         WR6EgteVxKec/fbIHEslfGclSl0ZZqnNRJ8h9qsFcc+rZ73oaFR0NqUQH67JVy027IiA
         Kr/w==
X-Gm-Message-State: AOAM5302fHv7636v/cHPmCSBgCcmXqBHz7p7saxkgv4HPBcwdLtSbSvy
        idxmc0JRVJ+C08emII7NcBM=
X-Google-Smtp-Source: ABdhPJwOxxhbiazXA/g6xdgfKu9arPs1AmiYxfQtq0/YXWY7Cj9RksLbIpvVHOZV5/9Xa1OpbBTvrQ==
X-Received: by 2002:aa7:9017:0:b0:4df:e33f:f1b4 with SMTP id m23-20020aa79017000000b004dfe33ff1b4mr17131184pfo.80.1646723311380;
        Mon, 07 Mar 2022 23:08:31 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id y34-20020a056a00182200b004f71c56a7e8sm3429180pfa.213.2022.03.07.23.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 23:08:31 -0800 (PST)
Date:   Tue, 8 Mar 2022 12:38:28 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
Message-ID: <20220308070828.4tjiuvvyqwmhru6a@apollo.legion>
References: <20220306234311.452206-1-memxor@gmail.com>
 <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_pointer'
> > returning a packet pointer with a fixed immutable range. This can be useful to
> > enable DPA without having to use memcpy (currently the case in
> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
> >
> > The intended usage to read and write data for multi-buff XDP is:
> >
> >         int err = 0;
> >         char buf[N];
> >
> >         off &= 0xffff;
> >         ptr = bpf_packet_pointer(ctx, off, sizeof(buf), &err);
> >         if (unlikely(!ptr)) {
> >                 if (err < 0)
> >                         return XDP_ABORTED;
> >                 err = bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf));
> >                 if (err < 0)
> >                         return XDP_ABORTED;
> >                 ptr = buf;
> >         }
> >         ...
> >         // Do some stores and loads in [ptr, ptr + N) region
> >         ...
> >         if (unlikely(ptr == buf)) {
> >                 err = bpf_xdp_store_bytes(ctx, off, buf, sizeof(buf));
> >                 if (err < 0)
> >                         return XDP_ABORTED;
> >         }
> >
> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM, because
> > these pointers need to be invalidated on clear_all_pkt_pointers invocation, and
> > it is also more meaningful to the user to see return value as R0=pkt.
> >
> > This series is meant to collect feedback on the approach, next version can
> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer helper for TC
> > hooks, and explore not resetting range to zero on r0 += rX, instead check access
> > like check_mem_region_access (var_off + off < range), since there would be no
> > data_end to compare against and obtain a new range.
> >
> > The common name and func_id is supposed to allow writing generic code using
> > bpf_packet_pointer that works for both XDP and TC programs.
> >
> > Please see the individual patches for implementation details.
> >
>
> Joanne is working on a "bpf_dynptr" framework that will support
> exactly this feature, in addition to working with dynamically
> allocated memory, working with memory of statically unknown size (but
> safe and checked at runtime), etc. And all that within a generic
> common feature implemented uniformly within the verifier. E.g., it
> won't need any of the custom bits of logic added in patch #2 and #3.
> So I'm thinking that instead of custom-implementing a partial case of
> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynptr
> and do it only once there?
>

Interesting stuff, looking forward to it.

> See also my ARG_CONSTANT comment. It seems like a pretty common thing
> where input constant is used to characterize some pointer returned
> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
> that for bpf_dynptr for exactly this "give me direct access of N
> bytes, if possible" case. So improving/generalizing it now before
> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
> feature itself.

No worries, we can continue the discussion in patch 1, I'll split out the arg
changes into a separate patch, and wait for dynptr to be posted before reworking
this.

>
> > Kumar Kartikeya Dwivedi (5):
> >   bpf: Add ARG_SCALAR and ARG_CONSTANT
> >   bpf: Introduce pkt_uid concept for PTR_TO_PACKET
> >   bpf: Introduce bpf_packet_pointer helper to do DPA
> >   selftests/bpf: Add verifier tests for pkt pointer with pkt_uid
> >   selftests/bpf: Update xdp_adjust_frags to use bpf_packet_pointer
> >
> >  include/linux/bpf.h                           |   4 +
> >  include/linux/bpf_verifier.h                  |   9 +-
> >  include/uapi/linux/bpf.h                      |  12 ++
> >  kernel/bpf/verifier.c                         |  97 ++++++++++--
> >  net/core/filter.c                             |  48 +++---
> >  tools/include/uapi/linux/bpf.h                |  12 ++
> >  .../bpf/prog_tests/xdp_adjust_frags.c         |  46 ++++--
> >  .../bpf/progs/test_xdp_update_frags.c         |  46 ++++--
> >  tools/testing/selftests/bpf/verifier/xdp.c    | 146 ++++++++++++++++++
> >  9 files changed, 358 insertions(+), 62 deletions(-)
> >
> > --
> > 2.35.1
> >

--
Kartikeya
