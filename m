Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA524C314
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgHTQMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgHTQMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:12:31 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F0AC061388
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:12:31 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id o21so2306703oie.12
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ud0t0O/A9Zxe4AUQrrfIW1bhDjfdc8SKj1ooJkDSnEc=;
        b=OG8nWb3xyhE1WjhqnLw+bu8z2arHxNdpvBUUxE713nK5l/9FVUUvdMaxu0aiJ/QJkp
         v0eEF8Y9nrBafzmEg7AiAQzgIMA32FhyYPWEc7o7zz0NRivisQeRFNKh+4x+rgETdweS
         Ar6aVVMzVPpzpMQYvX3xQg1HRbjItfwGiGDM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ud0t0O/A9Zxe4AUQrrfIW1bhDjfdc8SKj1ooJkDSnEc=;
        b=ZPi7OxDFESgfLhWw8FP6lCKRL8iOJo4YT+FN++sERJsH47m+8bHwBH8XNmt0EkXOAL
         mUKVxAiZ8K4+HofplC56+oMpLuySLMn+OcCbe4EA0b7OEpBnsFu6SzroA2XEbEfzRs4S
         S7AIJ3iN4avqdKBU6HnxylJXJC1AJhYW/LSOxrgdmJigaPwI95K0wLa/TEOHRB7sTkd5
         yypPSftMM/qhJaq0iEH0XbVhTdesXmwqx5frpBau6fVFRfupM0qvx3uYMIffTsjLAi7g
         z8IteNuPLytXx7mQ1UJv3LypjwO5JwkIeFV6Y/A88eyxwp+JtP5dmo9oS5F+1EeTzWl7
         VqGw==
X-Gm-Message-State: AOAM530PAV/ceOOWglLseKl+d8wAe9huz1IWLAgu3fOKvOaHGZ+dOgi0
        QgXeY9tJsyUT2t4jSJWWVjSSz50G5ENRQkq4sa3To33vWv6mgg==
X-Google-Smtp-Source: ABdhPJyOjtYelp22Uu3YGbeY+hgPk19hR7Mb45ss3oGk4BF19/Wv9MbETzwWzjM5dduq31TsR0O7FMA/xPtxyFMHsZM=
X-Received: by 2002:aca:cfd0:: with SMTP id f199mr2098445oig.102.1597939950149;
 Thu, 20 Aug 2020 09:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200819092436.58232-1-lmb@cloudflare.com> <20200819092436.58232-7-lmb@cloudflare.com>
 <1ad29823-1925-01ee-f042-20b422a62a73@fb.com> <CACAyw9-ORs29Gt0c02qsco9ah_h88OqQh5cq36SpDCD19x89uw@mail.gmail.com>
 <582e57e2-58e6-8a37-7dbc-67a2a1db7ecb@fb.com>
In-Reply-To: <582e57e2-58e6-8a37-7dbc-67a2a1db7ecb@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 20 Aug 2020 17:12:18 +0100
Message-ID: <CACAyw98oAK2Ds1DShkNHq6AYKNF0sL_LOAji3rriuxRa35brAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/6] selftests: bpf: test sockmap update from BPF
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 at 15:49, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/20/20 4:58 AM, Lorenz Bauer wrote:
> > On Wed, 19 Aug 2020 at 21:46, Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 8/19/20 2:24 AM, Lorenz Bauer wrote:
> >>> Add a test which copies a socket from a sockmap into another sockmap
> >>> or sockhash. This excercises bpf_map_update_elem support from BPF
> >>> context. Compare the socket cookies from source and destination to
> >>> ensure that the copy succeeded.
> >>>
> >>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> >>> ---
> >>>    .../selftests/bpf/prog_tests/sockmap_basic.c  | 76 +++++++++++++++++++
> >>>    .../selftests/bpf/progs/test_sockmap_copy.c   | 48 ++++++++++++
> >>>    2 files changed, 124 insertions(+)
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> >>> index 96e7b7f84c65..d30cabc00e9e 100644
> >>> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> >>> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> >>> @@ -4,6 +4,7 @@
> >>>
> >>>    #include "test_progs.h"
> >>>    #include "test_skmsg_load_helpers.skel.h"
> >>> +#include "test_sockmap_copy.skel.h"
> >>>
> >>>    #define TCP_REPAIR          19      /* TCP sock is under repair right now */
> >>>
> >>> @@ -101,6 +102,77 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
> >>>        test_skmsg_load_helpers__destroy(skel);
> >>>    }
> >>>
> >>> +static void test_sockmap_copy(enum bpf_map_type map_type)
> >>> +{
> >>> +     struct bpf_prog_test_run_attr attr;
> >>> +     struct test_sockmap_copy *skel;
> >>> +     __u64 src_cookie, dst_cookie;
> >>> +     int err, prog, s, src, dst;
> >>> +     const __u32 zero = 0;
> >>> +     char dummy[14] = {0};
> >>> +
> >>> +     s = connected_socket_v4();
> >>
> >> Maybe change variable name to "sk" for better clarity?
> >
> > Yup!
> >
> >>
> >>> +     if (CHECK_FAIL(s == -1))
> >>> +             return;
> >>> +
> >>> +     skel = test_sockmap_copy__open_and_load();
> >>> +     if (CHECK_FAIL(!skel)) {
> >>> +             close(s);
> >>> +             perror("test_sockmap_copy__open_and_load");
> >>> +             return;
> >>> +     }
> >>
> >> Could you use CHECK instead of CHECK_FAIL?
> >> With CHECK, you can print additional information without perror.
> >
> > I avoid CHECK because it requires `duration`, which doesn't make sense
> > for most things that I call CHECK_FAIL on here. So either it outputs 0
> > nsec (which is bogus) or it outputs the value from the last
> > bpf_prog_test_run call (which is also bogus). How do other tests
> > handle this? Just ignore it?
>
> Just ignore it. You can define a static variable duration in the
> beginning of file and then use CHECK in the rest of file.

Ok, will do in v3!

>
> >
> >>
> >>
> >>> +
> >>> +     prog = bpf_program__fd(skel->progs.copy_sock_map);
> >>> +     src = bpf_map__fd(skel->maps.src);
> >>> +     if (map_type == BPF_MAP_TYPE_SOCKMAP)
> >>> +             dst = bpf_map__fd(skel->maps.dst_sock_map);
> >>> +     else
> >>> +             dst = bpf_map__fd(skel->maps.dst_sock_hash);
> >>> +
> [...]



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
