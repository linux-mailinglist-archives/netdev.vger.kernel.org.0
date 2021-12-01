Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D044654D4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352201AbhLASOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351913AbhLASO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:14:27 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ED3C061758
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 10:11:03 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id az37so50838100uab.13
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 10:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nk3E20LvcSKY1TQfwjDkOaFMxwZSFJoLfi6V0SAfz4Y=;
        b=KpK/+I6nA8FV35jOxrYRqQTd45haxcumqY1QHSUejoPxjjRe6AuoemlyupAtoO1u6g
         TE04tk7IALFJEuoCGwSO/vsBqOXmnD1VEZVx6rKK+sv/yG03LpWGqOdfGVz9xGzBDsU7
         18l7CJmwa8GAPtr2u7Rnw1R8s/oVRKYfZ5pO9Ofoy81MREn4+KpGTgpkRSIaD5TnZ7/n
         oHXut+kmYkrPt4qnAit/i5xN1wq706CMfs4/Q3ThbBhbb+Ok1N7TL26s/5wW6VLhE0MR
         +Z2AZhpazJglvHgntTy3PHF9ZXv8Kg4WJ+W9M45NWF+VMewKXXXs+ZRo4V0EHmf0iXu2
         XDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nk3E20LvcSKY1TQfwjDkOaFMxwZSFJoLfi6V0SAfz4Y=;
        b=hLxP3BEtgUgMNK8M977og9OD1BdyKLr7/0ZkugTrQLjwDrF06XakQjbv3IslwjH8gO
         J1xTNpcyJRvCT3nho2mHHehf70HUi326rB3LS5ms594CXEyu0EwAPEG/tAzfYEWUjshm
         YFyW7NylE5QDPTyP1axD81kCmHyH6hWg4VXdc+cZySfyOZZ4cLhyGQzDmaY0KDjdCG52
         S9LCq3MyvqcXoWlQv3IqYfJzXddtqyIxG+G3g0OsztEmgibj0ELf0X2c+dCxi/Q1ATM1
         Lr/35IkProm82/eD5xVLcblS7HHZZHwbRa/+agMJCTrMZ2C8Wv4qA4scD6y0PYm78P0N
         WbeA==
X-Gm-Message-State: AOAM531HAmcMPiuIbvpr4JrHy21LsqUufsA1fv3xUKL06VS+d4vmrs1U
        XB0YSTQxyiNetUuAZ6NsENsUSZg0H+auDA==
X-Google-Smtp-Source: ABdhPJxel90Flswxoi8NjNOCdJFBGvRq72fdC1CyGqyk6SIAoN305rBmTP09GwPZC2pK67zcIKy/mA==
X-Received: by 2002:a05:6102:3a6d:: with SMTP id bf13mr9617319vsb.3.1638382262852;
        Wed, 01 Dec 2021 10:11:02 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id w22sm322632vsk.11.2021.12.01.10.11.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:11:02 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id i6so50766536uae.6
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 10:11:02 -0800 (PST)
X-Received: by 2002:a67:5fc6:: with SMTP id t189mr8956237vsb.79.1638382262155;
 Wed, 01 Dec 2021 10:11:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638282789.git.asml.silence@gmail.com>
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 10:10:22 -0800
X-Gmail-Original-Message-ID: <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
Message-ID: <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
Subject: Re: [RFC 00/12] io_uring zerocopy send
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> # performance:
>
> The worst case for io_uring is (4), still 1.88 times faster than
> msg_zerocopy (2), and there are a couple of "easy" optimisations left
> out from the patchset. For 4096 bytes payload zc is only slightly
> outperforms non-zc version, the larger payload the wider gap.
> I'll get more numbers next time.

> Comparing (3) and (4), and (5) vs (6), @flush doesn't affect it too
> much. Notification posting is not a big problem for now, but need
> to compare the performance for when io_uring_tx_zerocopy_callback()
> is called from IRQ context, and possible rework it to use task_work.
>
> It supports both, regular buffers and fixed ones, but there is a bunch of
> optimisations exclusively for io_uring's fixed buffers. For comparison,
> normal vs fixed buffers (@nr_reqs=8, @flush=0): 75677 vs 116079 MB/s
>
> 1) we pass a bvec, so no page table walks.
> 2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
>    still doing page get/put (see 4/12) slashed 4-5%.
> 3) avoiding get_page/put_page in 5/12
> 4) completion events are posted into io_uring's CQ, so no
>    extra recvmsg for getting events
> 5) no poll(2) in the code because of io_uring
> 6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
>    io_uring caches the structures reducing it to nearly zero-overhead.

Nice set of complementary optimizations.

We have looked at adding some of those as independent additions to
msg_zerocopy before, such as long-term pinned regions. One issue with
that is that the pages must remain until the request completes,
regardless of whether the calling process is alive. So it cannot rely
on a pinned range held by a process only.

If feasible, it would be preferable if the optimizations can be added
to msg_zerocopy directly, rather than adding a dependency on io_uring
to make use of them. But not sure how feasible that is. For some, like
4 and 5, the answer is clearly it isn't.  6, it probably is?

> # discussion / questions
>
> I haven't got a grasp on many aspects of the net stack yet, so would
> appreciate feedback in general and there are a couple of questions
> thoughts.
>
> 1) What are initialisation rules for adding a new field into
> struct mshdr? E.g. many users (mainly LLD) hand code initialisation not
> filling all the fields.
>
> 2) I don't like too much ubuf_info propagation from udp_sendmsg() into
> __ip_append_data() (see 3/12). Ideas how to do it better?

Agreed that both of these are less than ideal.

I can't comment too much on the io_uring aspect of the patch series.
But msg_zerocopy is probably used in a small fraction of traffic (even
if a high fraction for users who care about its benefits). We have to
try to minimize the cost incurred on the general hot path.

I was going to suggest using the standard msg_zerocopy ubuf_info
alloc/free mechanism. But you explicitly mention seeing omalloc/ofree
in the cycle profile.

It might still be possible to somehow signal to msg_zerocopy_alloc
that this is being called from within an io_uring request, and
therefore should use a pre-existing uarg with different
uarg->callback. If nothing else, some info can be passed as a cmsg.
But perhaps there is a more direct pointer path to follow from struct
sk, say? Here my limited knowledge of io_uring forces me to hand wave.

Probably also want to see how all this would integrate with TCP. In
some ways, that might be easier, as it does not have the indirection
through ip_make_skb, etc.
