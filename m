Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84621172EF5
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 03:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgB1C6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 21:58:07 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37818 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbgB1C6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 21:58:07 -0500
Received: by mail-lf1-f66.google.com with SMTP id b15so992016lfc.4;
        Thu, 27 Feb 2020 18:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G5nc7Ra8Buzd+enRZlcZV/Xbln391xZv5XUvG2qsBDw=;
        b=DfToJC/AnuEtgeHWi6MRYROd42RgYU59jIVWO+SQwD5qQXwW2toLDeoP6FiLBeSrdV
         T7xJYlfvqWt5OSTD7Ux0PGHCODgcNiV8RRxRSudGHs45jEdODKeCv6IT6dPE32dtNigx
         d+FPG+sklEFXIONZ55hNqvJ6wKNGzwvH87zRXtxI+q1YfAy/UEmsvZk0hKtFgf3ydF8z
         +re7OFt3UpP52MDJWLlFZOmJFYUGQ5551yteLsi3CFu4OdgJ/6gerZQ6kiJOAupXGmOM
         rSIdi7VRMEguKEvkKo0BJO1X8XtHwLz+0uigrJxZvVrIjfOCu67WZWRzo0W9cHoecwsw
         u2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G5nc7Ra8Buzd+enRZlcZV/Xbln391xZv5XUvG2qsBDw=;
        b=GGq2BWFSIfKfY431PmzrI5OCOueTGbqT2mZ3DybZTqAbOQzFyI3oFKSLUW7BGU4gUh
         0g+Hbe7RBrQDeuVi/57G1jPrOrUCaFgldovBX2yUjS0Qhe9fJCYGL+lhEh5Yrzn0I57I
         0X3llhlHaZBG0NRivBfhqD95h9bttEp8JnWJ8fYtMhGvYYxTSKhj0HLDn+aBiJrktCeS
         pnSCx02WSIYQetryWz2Lg2JhHiYinGK+cn7UCn4YygnNL9GP3SVKw5iP1JhbYppYpYjf
         eyei9xt3OEsTb77V3zilWwfwl6YBVLM9cb5eq+PJTxKw0yeGtHNtVcCzb4nGD2GXWHSA
         5zuw==
X-Gm-Message-State: ANhLgQ1FHLF0Gf1t1c+tXo9GHwy6N13MbgDG0229NgdGvGTsacHCzXyV
        DYLi3OzXRG37WUUp60xa+oRTMwaSJMxMtNf4Mvs=
X-Google-Smtp-Source: ADFU+vv9RYm92ssPFQTn3yIomzfh+Ik6kS/D/rJa+wDPsVBYnxL7/uM/PTUMuWSCMKmrB0LWHmxti3l2eLeaGIwgkvY=
X-Received: by 2002:a05:6512:304d:: with SMTP id b13mr1349272lfb.134.1582858683187;
 Thu, 27 Feb 2020 18:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20200225230402.1974723-1-kafai@fb.com> <20200225230427.1976129-1-kafai@fb.com>
 <938a0461-fd8d-b4b9-4fef-95d46409c0d6@iogearbox.net> <20200227013448.srxy5kkpve7yheln@kafai-mbp>
 <ca31484f-4656-fb3e-8982-6a068bcb0738@iogearbox.net>
In-Reply-To: <ca31484f-4656-fb3e-8982-6a068bcb0738@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 27 Feb 2020 18:57:51 -0800
Message-ID: <CAADnVQJpb3xL0ynW3+R8ikVpc0L1LwZG_HqzE+6JzEYfZWnZ=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] bpf: inet_diag: Dump bpf_sk_storages in inet_diag_dump()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 3:45 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/27/20 2:34 AM, Martin KaFai Lau wrote:
> > On Wed, Feb 26, 2020 at 06:21:33PM +0100, Daniel Borkmann wrote:
> >> On 2/26/20 12:04 AM, Martin KaFai Lau wrote:
> >>> This patch will dump out the bpf_sk_storages of a sk
> >>> if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
> >>>
> >>> An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
> >>> INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
> >>> If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
> >>>
> >>> bpf_sk_storages can be added to the system at runtime.  It is difficult
> >>> to find a proper static value for cb->min_dump_alloc.
> >>>
> >>> This patch learns the nlattr size required to dump the bpf_sk_storages
> >>> of a sk.  If it happens to be the very first nlmsg of a dump and it
> >>> cannot fit the needed bpf_sk_storages,  it will try to expand the
> >>> skb by "pskb_expand_head()".
> >>>
> >>> Instead of expanding it in inet_sk_diag_fill(), it is expanded at a
> >>> sleepable context in __inet_diag_dump() so __GFP_DIRECT_RECLAIM can
> >>> be used.  In __inet_diag_dump(), it will retry as long as the
> >>> skb is empty and the cb->min_dump_alloc becomes larger than before.
> >>> cb->min_dump_alloc is bounded by KMALLOC_MAX_SIZE.  The min_dump_alloc
> >>> is also changed from 'u16' to 'u32' to accommodate a sk that may have
> >>> a few large bpf_sk_storages.
> >>>
> >>> The updated cb->min_dump_alloc will also be used to allocate the skb in
> >>> the next dump.  This logic already exists in netlink_dump().
> >>>
> >>> Here is the sample output of a locally modified 'ss' and it could be made
> >>> more readable by using BTF later:
> >>> [root@arch-fb-vm1 ~]# ss --bpf-map-id 14 --bpf-map-id 13 -t6an 'dst [::1]:8989'
> >>> State Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
> >>> ESTAB 0      0              [::1]:51072        [::1]:8989
> >>>      bpf_map_id:14 value:[ 3feb ]
> >>>      bpf_map_id:13 value:[ 3f ]
> >>> ESTAB 0      0              [::1]:51070        [::1]:8989
> >>>      bpf_map_id:14 value:[ 3feb ]
> >>>      bpf_map_id:13 value:[ 3f ]
> >>>
> >>> [root@arch-fb-vm1 ~]# ~/devshare/github/iproute2/misc/ss --bpf-maps -t6an 'dst [::1]:8989'
> >>> State         Recv-Q         Send-Q                   Local Address:Port                    Peer Address:Port         Process
> >>> ESTAB         0              0                                [::1]:51072                          [::1]:8989
> >>>      bpf_map_id:14 value:[ 3feb ]
> >>>      bpf_map_id:13 value:[ 3f ]
> >>>      bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
> >>> ESTAB         0              0                                [::1]:51070                          [::1]:8989
> >>>      bpf_map_id:14 value:[ 3feb ]
> >>>      bpf_map_id:13 value:[ 3f ]
> >>>      bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
> >>>
> >>> Acked-by: Song Liu <songliubraving@fb.com>
> >>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> >>
> >> Hmm, the whole approach is not too pleasant to be honest. I can see why you need
> >> it since the regular sk_storage lookup only takes sock fd as a key and you don't
> >> have it otherwise available from outside, but then dumping up to KMALLOC_MAX_SIZE
> >> via netlink skb is not a great experience either. :( Also, are we planning to add
> >> the BTF dump there in addition to bpftool? Thus resulting in two different lookup
> >> APIs and several tools needed for introspection instead of one? :/ Also, how do we
> >> dump task local storage maps in future? Does it need a third lookup interface?
> >>
> >> In your commit logs I haven't read on other approaches and why they won't work;
> >> I was wondering, given sockets are backed by inodes, couldn't we have a variant
> >> of iget_locked() (minus the alloc_inode() part from there) where you pass in ino
> >> number to eventually get to the socket and then dump the map value associated with
> >> it the regular way from bpf() syscall?
> > Thanks for the feedback!
> >
> > I think (1) dumping all sk(s) in a system is different from
> > (2) dumping all sk of a bpf_sk_storage_map or lookup a particular
> > sk from a bpf_sk_storage_map.
>
> Yeah, it is; I was mostly brain-storming if there is a cleaner way for (1)
> by having (2)b resolved as an intermediate step (1) can then build on, but
> seems it's tricky w/o much extra infra.
>
> [...]
> >
> > or the netlink can return map_id only when the max-sized skb cannot fit
> > all the bpf_sk_storages.  The userspace then do another syscall to
> > lookup the data from each individual bpf_sk_storage_map and
> > that requires to lookup side support with another key (non-fd).
> > IMO, it is weird and a bit opposite of what bpf_sk_storage should be (fast
> > bpf_sk_storage lookup while holding a sk).  The iteration API already
> > holds the sk but instead it is asking the usespace to go back to find
> > out the sk again in order to get the bpf_sk_storages.  I think that
> > should be avoided if possible.
> >
> > Regarding i_ino, after looking at sock_alloc() and get_next_ino(),
> > hmmm...is it unique?
>
> It would wrap around after 2^32 allocations, so scratch that thought,
> iget_locked()/find_inode_fast()-based lookup usage must ensure it's unique.
>
> > If it is, what is the different usecase between i_ino and
> > sk->sk_cookie?
>
> Agree that advantage of reusing diag is that you already hold the sk and
> are able to iterate through all of them, the ugly part is having to place
> the value data into netlink as an API along with all other socket data as
> a, for better or worse, bpf sk map lookup/introspection interface given
> there is no other way to have a fast and global (non-fd based) id->socket
> lookup interface that we could reuse atm.
>
> I was wondering about sk->sk_cookie as well, but it wouldn't make sense
> to do a ss dump, get (sk cookie, map_id) from the dump and use that for
> a bpf() lookup if we need to reiterate the diag tables once again in the
> background just to get the storage data. And I presume it won't make sense
> either to reuse the diag's walk as a stand-alone for a bpf sk storage dump
> interface API via bpf() ... at least from ss tool side it would require a
> correlation based on sk cookie. Not nice either ... so current approach
> might indeed be the tradeoff. :/

I agree with all the points above.
I've applied this set. I think making ss show it via standard way is necessary.
We should continue thinking on other options.
