Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992D4105BB6
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKUVOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:14:45 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42750 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUVOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:14:44 -0500
Received: by mail-qk1-f193.google.com with SMTP id i3so4398595qkk.9
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VNFCtSvVE5ZNnC/9WTyTadz2AFOd32sRLdFw7T4sa+I=;
        b=cIe2OBCJQMB4F+3htsRbXBvPKfVkLbAIh2pN40Bz2X46+OI8uBwB8zsWz2KRxQHl4b
         eg6kGgHI5pLt73BlFCJ3AbVbUa0WTcTdVOx2CGvO8Vn0IC83eFOH2l2VJxnGPxEAij7A
         X++Q6xrC+6tS4eb/LH9bN5MvPCL/doNXaHPDsZJIhCFLUXJX9tdUwPiThHpz121yPqql
         fDKhCGq+7/IRRFiPQhrJjTbQyAcpRd0MtANhyhPlWbm5nphLbZulQTLxsDR7EiU5k23Y
         s/L3zEF9uhUNIRoT0W5RLP04ob/Vpg/2lHV/4pRfaVM3YR/jSUZd2MOcljUSwjixBgcQ
         p4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VNFCtSvVE5ZNnC/9WTyTadz2AFOd32sRLdFw7T4sa+I=;
        b=O/0ev18v5ahEwXcsmcgNb6Pais3WSAsY3FftWdiqnUYCdfH0YJ+0e82/WFTs6TvU8S
         L03nBAo7EucJjQtBs4+IMmkrm1pBHnEGkgyFYYj4RyqEhSKf/I53KsD3dZitCXPEqeLK
         klsdoRrNdFvZACmy1pAc8Cl5VRBPhQb/1yoIyN7N8q2jUjmta10v38BvyEfNAqRQnHvF
         9VuiRBSiSRVoFf410HMYdVNYrpHPV3kTWdK9bX3wqc9BYczCrVAxU/B6aRaO0mLsIZ6d
         y/RotTE/43V7o8Gdmy6GaVD3iS0gfwA9usvcTzCyh3orUHk8pt6SYLHijjsFxiZ2zaLf
         P1MQ==
X-Gm-Message-State: APjAAAXE63R93lpNlBofunneSUqEhNKpvcVibljYIkavJQp87knu1eL/
        MT0kh2+LRwQInxGbt3KfkKn8Fw6BSY7ju8Uwzt8FpA==
X-Google-Smtp-Source: APXvYqyyVWTvkHmcJRa7iCCWXRZKxl8tIsVUuuXo9so2UqjzmINLrZ9QHotmGFd1xYCQl7jqxS60XiBLwWjjPhCGT14=
X-Received: by 2002:a37:4d16:: with SMTP id a22mr10082271qkb.237.1574370882861;
 Thu, 21 Nov 2019 13:14:42 -0800 (PST)
MIME-Version: 1.0
References: <20191119193036.92831-1-brianvv@google.com> <20191119193036.92831-10-brianvv@google.com>
 <4688ba20-0730-7689-9332-aa0dcef5258e@fb.com>
In-Reply-To: <4688ba20-0730-7689-9332-aa0dcef5258e@fb.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 21 Nov 2019 13:14:31 -0800
Message-ID: <CAMzD94SCUQTi=O694HN3Muh=F-NT81_C4kBnzyBu0pfoNi87DQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 9/9] selftests/bpf: add batch ops testing to
 array bpf map
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing it!

On Thu, Nov 21, 2019 at 10:43 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/19/19 11:30 AM, Brian Vazquez wrote:
> > Tested bpf_map_lookup_batch() and bpf_map_update_batch()
> > functionality.
> >
> >    $ ./test_maps
> >        ...
> >          test_map_lookup_and_delete_batch_array:PASS
> >        ...
>
> The test is for lookup_batch() and update_batch()
> and the test name and func name is lookup_and_delete_batch(),
> probably rename is to lookup_and_update_batch_array()?
>
Yes, you are right, I will change the name for next version.

> It would be good if generic lookup_and_delete_batch()
> and delete_patch() can be tested as well.
> Maybe tried to use prog_array?

 I did test generic_lookup_and_delete_batch with hmap and it worked
fine because I didn't have concurrent deletions.
But yes I will add tests for generic delete and lookup_and_delete,
maybe for the trie map (prog_array doesn't support lookup ang hence
lookup_and_delete won't apply there)?

>
> >
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
> >   .../map_lookup_and_delete_batch_array.c       | 119 ++++++++++++++++++
> >   1 file changed, 119 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
> >
> > diff --git a/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
> > new file mode 100644
> > index 0000000000000..cbec72ad38609
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
> > @@ -0,0 +1,119 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <stdio.h>
> > +#include <errno.h>
> > +#include <string.h>
> > +
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +
> > +#include <test_maps.h>
> > +
> > +static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
> > +                          int *values)
> > +{
> > +     int i, err;
> > +
> > +     for (i = 0; i < max_entries; i++) {
> > +             keys[i] = i;
> > +             values[i] = i + 1;
> > +     }
> > +
> > +     err = bpf_map_update_batch(map_fd, keys, values, &max_entries, 0, 0);
> > +     CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
> > +}
> > +
> > +static void map_batch_verify(int *visited, __u32 max_entries,
> > +                          int *keys, int *values)
> > +{
> > +     int i;
> > +
> > +     memset(visited, 0, max_entries * sizeof(*visited));
> > +     for (i = 0; i < max_entries; i++) {
> > +             CHECK(keys[i] + 1 != values[i], "key/value checking",
> > +                   "error: i %d key %d value %d\n", i, keys[i], values[i]);
> > +             visited[i] = 1;
> > +     }
> > +     for (i = 0; i < max_entries; i++) {
> > +             CHECK(visited[i] != 1, "visited checking",
> > +                   "error: keys array at index %d missing\n", i);
> > +     }
> > +}
> > +
> > +void test_map_lookup_and_delete_batch_array(void)
> > +{
> > +     struct bpf_create_map_attr xattr = {
> > +             .name = "array_map",
> > +             .map_type = BPF_MAP_TYPE_ARRAY,
> > +             .key_size = sizeof(int),
> > +             .value_size = sizeof(int),
> > +     };
> > +     int map_fd, *keys, *values, *visited;
> > +     __u32 count, total, total_success;
> > +     const __u32 max_entries = 10;
> > +     int err, i, step;
> > +     bool nospace_err;
> > +     __u64 batch = 0;
> > +
> > +     xattr.max_entries = max_entries;
> > +     map_fd = bpf_create_map_xattr(&xattr);
> > +     CHECK(map_fd == -1,
> > +           "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
> > +
> > +     keys = malloc(max_entries * sizeof(int));
> > +     values = malloc(max_entries * sizeof(int));
> > +     visited = malloc(max_entries * sizeof(int));
> > +     CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
> > +           strerror(errno));
> > +
> > +     /* populate elements to the map */
> > +     map_batch_update(map_fd, max_entries, keys, values);
> > +
> > +     /* test 1: lookup in a loop with various steps. */
> > +     total_success = 0;
> > +     for (step = 1; step < max_entries; step++) {
> > +             map_batch_update(map_fd, max_entries, keys, values);
> > +             memset(keys, 0, max_entries * sizeof(*keys));
> > +             memset(values, 0, max_entries * sizeof(*values));
> > +             batch = 0;
> > +             total = 0;
> > +             i = 0;
> > +             /* iteratively lookup/delete elements with 'step'
> > +              * elements each.
> > +              */
> > +             count = step;
> > +             nospace_err = false;
> > +             while (true) {
> > +                     err = bpf_map_lookup_batch(map_fd,
> > +                                             total ? &batch : NULL, &batch,
> > +                                             keys + total,
> > +                                             values + total,
> > +                                             &count, 0, 0);
> > +
> > +                     CHECK((err && errno != ENOENT), "lookup with steps",
> > +                           "error: %s\n", strerror(errno));
> > +
> > +                     total += count;
> > +
> > +                     if (err)
> > +                             break;
> > +
> > +                     i++;
> > +             }
> > +
> > +             if (nospace_err == true)
> > +                     continue;
> > +
> > +             CHECK(total != max_entries, "lookup with steps",
> > +                   "total = %u, max_entries = %u\n", total, max_entries);
> > +
> > +             map_batch_verify(visited, max_entries, keys, values);
> > +
> > +             total_success++;
> > +     }
> > +
> > +     CHECK(total_success == 0, "check total_success",
> > +           "unexpected failure\n");
> > +
> > +     printf("%s:PASS\n", __func__);
> > +}
> >
