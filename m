Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532E51D8817
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgERTT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgERTT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:19:27 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE62CC061A0C;
        Mon, 18 May 2020 12:19:27 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c24so9097019qtw.7;
        Mon, 18 May 2020 12:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s95MZNZk4da7VuxgfefKMgjRh1rPyTCBhD+EEEwkR/8=;
        b=SA4Oot4F2DqYFReKGdvYgKe/+AZrlkMOvo0WJDGw4yNkCYITIod2V2gndgjcW6qLna
         orp3MKF6MPTn9fa/3ZndIj/opCsBdk9mLp/o/hwWlXmYBDo7Y4z+h1GCpTq55ow+TjBB
         xgKB/9gC+4gOmmgoVBCa4eLMrEiwz2L4zqYRKuPIcbzW7XMQ2iqQ520++NgD+mCTdCBi
         JT6cxBfk5hryMmYEAu6PM4QskeiAl7SJhQuzMF5GcqqQ5KP9kEKK++4duOTDy8N3A64R
         /UWcHAPfqHm19JkP9WpSYmPqTuoU3MRKDYUc8siQY/xSJTKX9reS5TgyWch2C/SeIB2k
         PoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s95MZNZk4da7VuxgfefKMgjRh1rPyTCBhD+EEEwkR/8=;
        b=TGqNKVZ1aqJTtqmgUDo5s2CbbPvqf21QOZKqokO70zv9CujYCvxeeoVtDRgOXpRIRm
         TbAdmO34wScgqPY3mU6hJaVnYlVq2PPjVIjqr2KFf3alNqFANrRkXty/SbmX7WwcgHmF
         VVZqNaZZS5bElaHBDzwivHzDCbgT7LRtOgmaTVPv8tTHY4pnICEO0XzJROayVPCtZJTY
         HVQqylUF1IlgHngFutwLYMeDqK5dPtbiU5bKSU6mDxWDtyLllzBoc/fgr+XAYRs/1Kem
         oqfQ45Z0kWgLzJOhEgQ/I5R2ZQUoFvC2geg+gbAUZf6xXYpzk6+NIRVSx+qtUXMSct+/
         2Yvg==
X-Gm-Message-State: AOAM5323Pbj3B3mFi0z7ekmEn2267L759jK6JW17ggiHhTz1YJFN40NC
        VdIRs6+hc76a28lWPd/NjNZWQYrxs3213YHfdvRDew==
X-Google-Smtp-Source: ABdhPJz6w+itEf9XZE0mkutOkz7F9VZOhAdEtBxR+q7dCVFEDD8HWvwOmZpCqGX0iWGVTgTA1K+5UuDwesXIOJfwomw=
X-Received: by 2002:ac8:6d0a:: with SMTP id o10mr17504736qtt.141.1589829566900;
 Mon, 18 May 2020 12:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
 <158945349549.97035.15316291762482444006.stgit@firesoul> <CAADnVQLtJotzY==OfOHmA-KdTb6bF7uqKVYGhnPj-oyzSZ8C_g@mail.gmail.com>
 <20200518115234.3b6925de@carbon> <20200518123030.5f316e23@carbon>
In-Reply-To: <20200518123030.5f316e23@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 12:19:15 -0700
Message-ID: <CAEf4BzYgjR6BWG6RY1NFsVMp97RKsEG39cQy_USxkK95HRQFkA@mail.gmail.com>
Subject: Re: unstable xdp tests. Was: [PATCH net-next v4 31/33] bpf: add
 xdp.frame_sz in bpf_prog_test_run_xdp().
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>, sameehj@amazon.com,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 3:33 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Mon, 18 May 2020 11:52:34 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> > ... I'm getting unrelated compile errors for selftests/bpf in
> > bpf-next tree (HEAD 96586dd9268d2).
> >
> > The compile error, see below signature, happens in ./progs/bpf_iter_ipv6_route.c
> > (tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c).
> >
> > Related to commit:
> >  7c128a6bbd4f ("tools/bpf: selftests: Add iterator programs for ipv6_route and netlink") (Author: Yonghong Song)
>
> After re-compiling the kernel in the same tree, this issue goes away.
>
> I guess this is related to:
>   #include "vmlinux.h"
>

Yes, I ran into the same issue with libbpf CI tests for older kernel.
vmlinux.h for it simply doesn't contain definitions of bpf_iter__xxx
types. I think for selftests, it's better to have local copies of
those struct definitions, to make it compilable against older
vmlinux.h.


> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
