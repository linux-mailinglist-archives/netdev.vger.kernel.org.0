Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E83673CE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhDUT5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbhDUT5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 15:57:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348A4C06174A;
        Wed, 21 Apr 2021 12:56:48 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b17so30962078pgh.7;
        Wed, 21 Apr 2021 12:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YaP76f57fr8M5B0srgLas/By2wC7svJGkUQc0Meajao=;
        b=NlMBPTkoGCcIn0HBpsyVVcGsiF/yIB92Mp1Ccrv6lVhahuKfumyBXvuBLxq7WzFjWm
         8wahATrym7TOyF96y7Zq/3iQgYjreBxUyhOsz/KuwY1XAsvedrpr3QkMotQhzoO1hnxf
         TU8bbwtZ4F9f+o8VN7TXijWWOMLZmwnFt50KVQwWE/WjpabSm8PfH1xslONSICp65V7g
         IYHXAzP5FOHqd60XO6HmOb2oTJ+i9+UU0P3LL4eKfIovQJeTC3NFAqFukhWlrJZj9GuC
         kAwcBbYxI4usKGcxoOBrlEhX6rQkm406ueFHRM6fKM640dmyCLtBwU4JfHh0kS13DP+J
         6KfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YaP76f57fr8M5B0srgLas/By2wC7svJGkUQc0Meajao=;
        b=X4Hx/XIKuvef0TGWzJnjJVcU5KZjRZ/21xVc8T0EPf6/t9UdR9guotvNj8sAGUjWza
         dP8jILU5jjDhZ8UFBeg7TSQ2GNK/P/pEBOTe/Xw1KOFtULosDEt9E/dbzFcOL47msQp6
         UF6WDzn8qyWsqM9IcQeFC/nJT6EYWobEpG3w23s5wIGlYPtDRiu9AUYMwq99/p4nDsW3
         HNL4NvpmuwvBz6bhRsKjLT8vupcclSZk9SAcokg9foIJDlgaqx/yff5XVEIwrTPVTwaM
         HC9VU99t1OfwlNDCPNc9BANBD3gC0NPpSPq5QkBne4DhJRsy+DHlslwEwuOkgklFdMC3
         PIIQ==
X-Gm-Message-State: AOAM530ciOY/dhLPVfe0PClYZfkEDKx1DULOvc0VzUyxtgNRV9L08iHv
        UJB1QHqON+Gre0ZuHvLJKxc=
X-Google-Smtp-Source: ABdhPJz18+nvPjrRIddS2etAicHooiWoZrSmCZFpi11tJGeCx1VBrRUP7xGqW78jRc/dnYRo6DLwxg==
X-Received: by 2002:a17:90b:19ca:: with SMTP id nm10mr13202045pjb.175.1619035007444;
        Wed, 21 Apr 2021 12:56:47 -0700 (PDT)
Received: from localhost ([112.79.248.97])
        by smtp.gmail.com with ESMTPSA id y3sm163492pjr.40.2021.04.21.12.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 12:56:46 -0700 (PDT)
Date:   Thu, 22 Apr 2021 01:26:43 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 3/3] libbpf: add selftests for TC-BPF API
Message-ID: <20210421195643.tduqyyfr5xubxfgn@apollo>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-4-memxor@gmail.com>
 <CAEf4BzbQjWkVM-dy+ebSKzgO89_W9vMGz_ZYicXCfp5XD_d_1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzbQjWkVM-dy+ebSKzgO89_W9vMGz_ZYicXCfp5XD_d_1g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:54:18PM IST, Andrii Nakryiko wrote:
> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This adds some basic tests for the low level bpf_tc_* API.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 ++++++++++++++++++
> >  .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
> >  2 files changed, 181 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>
> we normally don't call prog_test's files with "test_" prefix, it can
> be just tc_bpf.c (or just tc.c)
>

Ok, will rename.

> >  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
>
> we also don't typically call BPF source code files with _kern suffix,
> just test_tc_bpf.c would be more in line with most common case
>

Will rename.

> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> > new file mode 100644
> > index 000000000000..563a3944553c
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
> > @@ -0,0 +1,169 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/err.h>
> > +#include <linux/limits.h>
> > +#include <bpf/libbpf.h>
> > +#include <errno.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <test_progs.h>
> > +#include <linux/if_ether.h>
> > +
> > +#define LO_IFINDEX 1
> > +
> > +static int test_tc_internal(int fd, __u32 parent_id)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
> > +                           .class_id = TC_H_MAKE(1UL << 16, 1));
> > +       struct bpf_tc_attach_id id = {};
> > +       struct bpf_tc_info info = {};
> > +       int ret;
> > +
> > +       ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
> > +               return ret;
> > +
> > +       ret = bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> > +               goto end;
> > +
> > +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
> > +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch") ||
> > +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
> > +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
> > +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
> > +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
> > +                      "class_id incorrect") ||
> > +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
> > +               goto end;
> > +
> > +       opts.replace = true;
> > +       ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach in replace mode"))
> > +               return ret;
> > +
> > +       /* Demonstrate changing attributes */
> > +       opts.class_id = TC_H_MAKE(1UL << 16, 2);
> > +
> > +       ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc attach in replace mode"))
> > +               goto end;
> > +
> > +       ret = bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> > +               goto end;
> > +
> > +       if (!ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 2),
> > +                      "class_id incorrect after replace"))
> > +               goto end;
> > +       if (!ASSERT_EQ(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT, 1,
> > +                      "direct action mode not set"))
> > +               goto end;
> > +
> > +end:
> > +       ret = bpf_tc_detach(LO_IFINDEX, parent_id, &id);
> > +       ASSERT_EQ(ret, 0, "detach failed");
> > +       return ret;
> > +}
> > +
> > +int test_tc_info(int fd)
> > +{
> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
> > +                           .class_id = TC_H_MAKE(1UL << 16, 1));
> > +       struct bpf_tc_attach_id id = {}, old;
> > +       struct bpf_tc_info info = {};
> > +       int ret;
> > +
> > +       ret = bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opts, &id);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
> > +               return ret;
> > +       old = id;
> > +
> > +       ret = bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &info);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> > +               goto end_old;
> > +
> > +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
> > +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch") ||
> > +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
> > +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
> > +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
> > +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
> > +                      "class_id incorrect") ||
> > +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
> > +               goto end_old;
> > +
> > +       /* choose a priority */
> > +       opts.priority = 0;
> > +       ret = bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opts, &id);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
> > +               goto end_old;
> > +
> > +       ret = bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &info);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
> > +               goto end;
> > +
> > +       if (!ASSERT_NEQ(id.priority, old.priority, "filter priority mismatch"))
> > +               goto end;
> > +       if (!ASSERT_EQ(info.id.priority, id.priority, "priority mismatch"))
> > +               goto end;
> > +
> > +end:
> > +       ret = bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id);
> > +       ASSERT_EQ(ret, 0, "detach failed");
> > +end_old:
> > +       ret = bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &old);
> > +       ASSERT_EQ(ret, 0, "detach failed");
> > +       return ret;
> > +}
> > +
> > +void test_test_tc_bpf(void)
>
> test_test_ tautology, drop one test?
>

Ok.

> > +{
> > +       const char *file = "./test_tc_bpf_kern.o";
>
> please use BPF skeleton instead, see lots of other selftests doing
> that already. You won't even need find_program_by_{name,title}, among
> other things.
>

Sounds good, will change.

> > +       struct bpf_program *clsp;
> > +       struct bpf_object *obj;
> > +       int cls_fd, ret;
> > +
> > +       obj = bpf_object__open(file);
> > +       if (!ASSERT_OK_PTR(obj, "bpf_object__open"))
> > +               return;
> > +
> > +       clsp = bpf_object__find_program_by_title(obj, "classifier");
> > +       if (!ASSERT_OK_PTR(clsp, "bpf_object__find_program_by_title"))
> > +               goto end;
> > +
> > +       ret = bpf_object__load(obj);
> > +       if (!ASSERT_EQ(ret, 0, "bpf_object__load"))
> > +               goto end;
> > +
> > +       cls_fd = bpf_program__fd(clsp);
> > +
> > +       system("tc qdisc del dev lo clsact");
>
> can this fail? also why is this necessary? it's still not possible to

This is just removing any existing clsact qdisc since it will be setup by the
attach call, which is again removed later (where we do check if it fails, if it
does clsact qdisc was not setup, and something was wrong in that it returned 0
when the attach point was one of the clsact hooks).

We don't care about failure initially, since if it isn't present we'd just move
on to running the test.

> do anything with only libbpf APIs?
>

I don't think so, I can do the qdisc teardown using netlink in the selftest,
but that would mean duplicating a lot of code. I think expecting tc to be
present on the system is a reasonable assumption for this test.

> > +
> > +       ret = test_tc_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
> > +       if (!ASSERT_EQ(ret, 0, "test_tc_internal INGRESS"))
> > +               goto end;
> > +
> > +       if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> > +                      "clsact qdisc delete failed"))
> > +               goto end;
> > +
> > +       ret = test_tc_info(cls_fd);
> > +       if (!ASSERT_EQ(ret, 0, "test_tc_info"))
> > +               goto end;
> > +
> > +       if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> > +                      "clsact qdisc delete failed"))
> > +               goto end;
> > +
> > +       ret = test_tc_internal(cls_fd, BPF_TC_CLSACT_EGRESS);
> > +       if (!ASSERT_EQ(ret, 0, "test_tc_internal EGRESS"))
> > +               goto end;
> > +
> > +       ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
> > +                 "clsact qdisc delete failed");
> > +
> > +end:
> > +       bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> > new file mode 100644
> > index 000000000000..18a3a7ed924a
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
> > @@ -0,0 +1,12 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +/* Dummy prog to test TC-BPF API */
> > +
> > +SEC("classifier")
> > +int cls(struct __sk_buff *skb)
> > +{
> > +       return 0;
> > +}
> > --
> > 2.30.2
> >

--
Kartikeya
