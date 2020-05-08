Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5B71CB6F4
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEHSRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgEHSRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:17:43 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8FC061A0C;
        Fri,  8 May 2020 11:17:42 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w11so2716594iov.8;
        Fri, 08 May 2020 11:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lBILQLPraCZ2i92EwfiMwaPKp0mpCtSZogr00s6stp4=;
        b=gPeGqdkOSOPk7Ttl7bsdHZRVmVAdFIeMnmWaQBdGSkmAUH07gxUzaJfzOJ9nRoFhts
         yNmK4/82zNr3PxaVSgtyQT3lzXhAT2/U7d+YfRqcnlqCF80kEoGAW+1AvgJsDs1wymJO
         kKdhr9rF9n5e//6rpfXrOTscp2xOwJAZKu6uvK1cCtwhGicJ/UGMnoFwv8xlW8fYY3JC
         NOx6v3CkhTZDNIAig9v3CFJa1QujL/cr/wC8368KT+6kRotpW8ZO4RR7Wz+Rkc1YgFLL
         AnUXA4Wrwt3fnKFRJnsXcqrHq4Q2Kygy9WBIgFQl/Rjy1jlyzBPQKWj4GxaTqCWPjsd+
         Ewgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lBILQLPraCZ2i92EwfiMwaPKp0mpCtSZogr00s6stp4=;
        b=ns0Y7nPVVOE6gF0qVAjiSFZFmhZ0wIx0FGDn2SCImGEcKis3LAy2kgSFkuB7cwPR5o
         54MjJBYtc4QPKvSUYd9Qz851O6PC+O66Jmnm1D4R3KQ8ep5BcoQ/WXpPf5F75CeyYh8O
         jT24p8P9RZ107Lh4RgIDrk5kG4gUdtUPk0XLXqpFkUaL2f+OwBPl5vI+JAZNl3/L4+CO
         gTtDm4r1bcwnm4SuQGtUH5xKj/hJbUDO93szjMSCJvVAWrpqEJlQh0DcWrrMNALmj1kM
         mb8Ov7o2gZKuYlk7B7F0QBpwg3et2YAHm1TUJ7pP+XSwGwtOK5rf1exu1ZQRMaBxRBM9
         TRSw==
X-Gm-Message-State: AGi0PuYOcLAB8pKKgIWLaItMc3u8SONiwPgb9O2JryvfN9GPHmcQFmeK
        5waaw0JsGMOkSqQ3Ct66FPHy28KdowNa487FwLA=
X-Google-Smtp-Source: APiQypKMd4Z+FXMqxKi0I6RnhY5kANFP6OCiZlSFMBO6dLAnEUGYRj78FFiz0Los+cS/msti453hUidCnEwmU/ktkZ8=
X-Received: by 2002:a6b:6c0a:: with SMTP id a10mr4081965ioh.140.1588961862116;
 Fri, 08 May 2020 11:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062608.2049044-1-yhs@fb.com>
 <CAEf4Bzae=1h4Rky+ojeoaxUR6OHM5Q6OzXFqPrhoOM4D3EYuCA@mail.gmail.com> <318a33ef-4b9e-e25c-f153-c063b87b2c50@fb.com>
In-Reply-To: <318a33ef-4b9e-e25c-f153-c063b87b2c50@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:17:31 -0700
Message-ID: <CAEf4BzbROqT_nu0zXhN3dDVc9zNFrC1Dv9kBGnvPhqHxfgbB7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 18/20] tools/bpf: selftests: add iterator
 programs for ipv6_route and netlink
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:09 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/5/20 11:01 PM, Andrii Nakryiko wrote:
> > On Sun, May 3, 2020 at 11:30 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Two bpf programs are added in this patch for netlink and ipv6_route
> >> target. On my VM, I am able to achieve identical
> >> results compared to /proc/net/netlink and /proc/net/ipv6_route.
> >>
> >>    $ cat /proc/net/netlink
> >>    sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
> >>    000000002c42d58b 0   0          00000000 0        0        0     2        0        7
> >>    00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
> >>    00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
> >>    000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
> >>    ....
> >>    00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
> >>    000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
> >>    00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
> >>    000000008398fb08 16  0          00000000 0        0        0     2        0        27
> >>    $ cat /sys/fs/bpf/my_netlink
> >>    sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
> >>    000000002c42d58b 0   0          00000000 0        0        0     2        0        7
> >>    00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
> >>    00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
> >>    000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
> >>    ....
> >>    00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
> >>    000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
> >>    00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
> >>    000000008398fb08 16  0          00000000 0        0        0     2        0        27
> >>
> >>    $ cat /proc/net/ipv6_route
> >>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
> >>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> >>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
> >>    fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
> >>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
> >>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> >>    $ cat /sys/fs/bpf/my_ipv6_route
> >>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
> >>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> >>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
> >>    fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
> >>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
> >>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >
> > Looks good, but something weird with printf below...
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> >>   .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 63 ++++++++++++++++
> >>   .../selftests/bpf/progs/bpf_iter_netlink.c    | 74 +++++++++++++++++++
> >>   2 files changed, 137 insertions(+)
> >>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
> >>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
> >> new file mode 100644
> >> index 000000000000..0dee4629298f
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
> >> @@ -0,0 +1,63 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright (c) 2020 Facebook */
> >> +#include "vmlinux.h"
> >> +#include <bpf/bpf_helpers.h>
> >> +#include <bpf/bpf_tracing.h>
> >> +#include <bpf/bpf_endian.h>
> >> +
> >> +char _license[] SEC("license") = "GPL";
> >> +
> >> +extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
> >> +
> >> +#define        RTF_GATEWAY             0x0002
> >> +#define IFNAMSIZ               16
> >
> > nit: these look weirdly unaligned :)
> >
> >> +#define fib_nh_gw_family        nh_common.nhc_gw_family
> >> +#define fib_nh_gw6              nh_common.nhc_gw.ipv6
> >> +#define fib_nh_dev              nh_common.nhc_dev
> >> +
> >
> > [...]
> >
> >
> >> +       dev = fib6_nh->fib_nh_dev;
> >> +       if (dev)
> >> +               BPF_SEQ_PRINTF(seq, "%08x %08x %08x %08x %8s\n", rt->fib6_metric,
> >> +                              rt->fib6_ref.refs.counter, 0, flags, dev->name);
> >> +       else
> >> +               BPF_SEQ_PRINTF(seq, "%08x %08x %08x %08x %8s\n", rt->fib6_metric,
> >> +                              rt->fib6_ref.refs.counter, 0, flags);
> >
> > hmm... how does it work? you specify 4 params, but format string
> > expects 5. Shouldn't this fail?
>
> Thanks for catching this. Unfortunately, we can only detech this at
> runtime when BPF_SEQ_PRINTF is executed since only then we do
> format/argument checking.
>
> In the above, if I flip condition "if (dev)" to "if (!dev)", the
> BPF_SEQ_PRRINTF will not print anything and returns -EINVAL.
>
> I am wondering whether verifier should do some verification at prog load
> time to ensure
>    # of args in packed u64 array >= # of format specifier
> This should capture this case. Or we just assume users should do
> adequate testing to capture such cases.
>

My initial thought is that it would be too specific knowledge for
verifier, but maybe as we add more generic logging/printf
capabilities, it might come in handy. But I'd defer for later on.

> Note that this won't affect safety of the program so it is totally
> okay for verifier to delay the checking to runtime.
>
> >
> >> +
> >> +       return 0;
> >> +}
> >> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> >> new file mode 100644
> >> index 000000000000..0a85a621a36d
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> >> @@ -0,0 +1,74 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright (c) 2020 Facebook */
> >> +#include "vmlinux.h"
> >> +#include <bpf/bpf_helpers.h>
> >> +#include <bpf/bpf_tracing.h>
> >> +#include <bpf/bpf_endian.h>
> >> +
> >> +char _license[] SEC("license") = "GPL";
> >> +
> >> +#define sk_rmem_alloc  sk_backlog.rmem_alloc
> >> +#define sk_refcnt      __sk_common.skc_refcnt
> >> +
> >> +#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
> >> +#define container_of(ptr, type, member)                                \
> >> +       ({                                                      \
> >> +               void *__mptr = (void *)(ptr);                   \
> >> +               ((type *)(__mptr - offsetof(type, member)));    \
> >> +       })
> >
> > we should probably put offsetof(), offsetofend() and container_of()
> > macro into bpf_helpers.h, seems like universal things for kernel
> > datastructs :)
> >
> > [...]
> >
