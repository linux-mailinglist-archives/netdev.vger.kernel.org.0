Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DFE48185F
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhL3CH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhL3CHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:07:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9CCC061574;
        Wed, 29 Dec 2021 18:07:53 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c3so3959193pls.5;
        Wed, 29 Dec 2021 18:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8IOmK1CoEzJz3HM16qK6cdC2z2n/t1ShoeG8aIu0xU=;
        b=o0fiD9tc+wJK4xNycdMD3blFstIj9UhhK0MTvjYgPW+lsCXI8mNrOszU7mgoHkhbus
         bnNkAeEx1U/PAlj37r5enn3NmZJ9Rc+4OR42i8f1lTA46fFIhNTzk94qCbOyjZ1Py2RQ
         P1zhCER+ER4UY7Qc618Cyefxgjxek+w5mE3GzukNAv8eju/RTmZLC2pYgQjsh4zoKcLX
         H7Rpchej1X0G04tpA7Lvs1Wy/3W+3WDixSbfeDHzIwbs2Kan2ej9eBYeGA0l4GlSPKOt
         KXzMu73SV0pz104co7Uc6DWlZcg6TnhE80n5UwQSG3ycvALjoAt9M2zHFcWwOksmb54n
         /9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8IOmK1CoEzJz3HM16qK6cdC2z2n/t1ShoeG8aIu0xU=;
        b=jFgotsUcPjQuuIfAuhsoxjithwA+jxTrRvw/slDPmxZaQMQAYbKIr6d1icrWfD0Jgq
         KWm/byt4y9+/+YV1FWlSgBwTwtJZszhJfh8qLrld4NAg+ieNcX7ZqAg4kXP70KZuVtWO
         wyRGjloavY3hC/UMJDFlEgzK/1cUOqOCcSerJ2cgL1sJI8aTSeR0g/FpS5YdOx0r46kG
         r5WBvbvr1cJq1+GfbfsWWDh3KsL+ZEZwKiYpMVaRgtusmR8pGfa57oQwBpPGLEZHwv52
         xrNrn+/jPJX4ICs1RO4vlhDp0DEgLx4v2laoHlOcKUZTLRKZS5JtX49JGadm0MJ2C3xc
         6JVg==
X-Gm-Message-State: AOAM530lb5lye3/b1gHb85Sq1X1jW4UGfU4wv8Y9faloOuprm05MfeGm
        Fs/GF/ZIOnaieelbM0jIAupDKHi66aHSiVwXJmiY3nSE
X-Google-Smtp-Source: ABdhPJyCyigfirE/8D3Mqh9esEYDbxQ891lF0ykf0T1ZIjvIPhvS3sCCsTVqVse0Kcic8xlumzTRhct35ZD6+vCC+5Q=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr29099112plm.78.1640830072624; Wed, 29
 Dec 2021 18:07:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1639162845.git.lorenzo@kernel.org> <YcsjAP383AmEb4pQ@localhost.localdomain>
In-Reply-To: <YcsjAP383AmEb4pQ@localhost.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 18:07:41 -0800
Message-ID: <CAADnVQKcHe9ToeZ=OCFax0v+GLrEgdtANyzU51jkZzhZYZTTwA@mail.gmail.com>
Subject: Re: [PATCH v20 bpf-next 00/23] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 6:45 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> [...]
> >
> > Eelco Chaudron (3):
> >   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
> >   bpf: add multi-buffer support to xdp copy helpers
> >   bpf: selftests: update xdp_adjust_tail selftest to include
> >     multi-buffer
> >
> > Lorenzo Bianconi (19):
> >   net: skbuff: add size metadata to skb_shared_info for xdp
> >   xdp: introduce flags field in xdp_buff/xdp_frame
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
> >   net: mvneta: simplify mvneta_swbm_add_rx_fragment management
> >   net: xdp: add xdp_update_skb_shared_info utility routine
> >   net: marvell: rely on xdp_update_skb_shared_info utility routine
> >   xdp: add multi-buff support to xdp_return_{buff/frame}
> >   net: mvneta: add multi buffer support to XDP_TX
> >   bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf
> >     program
> >   net: mvneta: enable jumbo frames if the loaded XDP program support mb
> >   bpf: introduce bpf_xdp_get_buff_len helper
> >   bpf: move user_size out of bpf_test_init
> >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> >   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
> >     signature
> >   libbpf: Add SEC name for xdp_mb programs
> >   net: xdp: introduce bpf_xdp_pointer utility routine
> >   bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
> >   bpf: selftests: add CPUMAP/DEVMAP selftests for xdp multi-buff
> >   xdp: disable XDP_REDIRECT for xdp multi-buff
> >
> > Toke Hoiland-Jorgensen (1):
> >   bpf: generalise tail call map compatibility check
>
> Hi Alexei and Daniel,
>
> I noticed this series's state is now set to "New, archived" in patchwork.
> Is it due to conflicts? Do I need to repost?

I believe Daniel had some comments, but please repost anyway.
The fresh rebase will be easier to review.
