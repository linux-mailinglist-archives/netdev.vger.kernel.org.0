Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150DB58762B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 06:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbiHBEJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 00:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHBEJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 00:09:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8611A1B7B0;
        Mon,  1 Aug 2022 21:09:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i14so5096991ejg.6;
        Mon, 01 Aug 2022 21:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UocwHfpqhdsaKRBjXUO3oWoo5VgvByxIYhhk++TJzww=;
        b=jx4n8eOOxofhaSZH8qAE8+C6TnYGtkoSskRxtdK6cpEuJs3B2/r/mtS+LfGdb607Z+
         Pt706y5owNULu/vT+bzuxlMpb2iAnCL2E0Y5Wi5ngS2662xLzjr/k72ssPZBwg7ee0M/
         zepD+iNbd8FUgpsRoAHdZUDWBWHTxN/pdEOFPX5Uha6kIcv96xO8u3cQvd4100gd9i1E
         O8ysJtP8T++KWGFyqQ68Xvs7n5ypjil/P8MXrTBcSLTJBBoeAg7ayjvnfyNgCh3r8xV8
         3LnE2hkBGhoIu41apN04xmyBhTNU+cphPbdgr5N+UbDCDF2MJhvMjx495VwSEh1m0AKL
         FxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UocwHfpqhdsaKRBjXUO3oWoo5VgvByxIYhhk++TJzww=;
        b=dmgK/cuh/Jx8iy0LSFNBUkx61D/OU3Z8GHxNI+V4k+ffZzsZZtE8JRFMINFb9fzvu6
         n17oVL/EIcduB1HYUWwQtZa320Z2OBr/CLqEhWJp1gjTVGjdD0m3Ml9Wpm06JuW1zrbx
         KJuTpSeyMakvEgIl4boHLJXcoD8FMUuXJsi4yDK/TVBYW2AUNQSkmJueEPzX714FgAto
         2vzw4pyAoSyln6vvJIGAAeuI2NhE1W6wR8adguNrKVtVYWAsES/K3WYCMXsIO+S+Ev3c
         FUQy/Ix6VrmHyzmsVyYSFtJijtl5iEpAp9F7R1ttppnlkarD0qrlBfhhKqrmrIDRwyVY
         tP5g==
X-Gm-Message-State: AJIora+MHXkvGH5o5N9qKlP8KcfzTjmQCkx/J4VF8NKZ6O/tM0a0RpSA
        e/TKeOTX7kbG1Jq/cfUi/NMOEtW1KdxZOF/4rb88BzAG8ZQ=
X-Google-Smtp-Source: AGRyM1ty5sQTlF8ub0NnxUzp5syP51LYgsz8b9F8DDUIfoi9492DqzuJLw/BVfKhXCQt6hC71NiFlKdCphZTEUPiAWI=
X-Received: by 2002:a17:907:2ccc:b0:72b:6907:fce6 with SMTP id
 hg12-20020a1709072ccc00b0072b6907fce6mr15019557ejc.115.1659413377003; Mon, 01
 Aug 2022 21:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-6-haoluo@google.com>
 <CAEf4Bzbdz7=Cg-87G2tak1Mr=1wJkqr6g2d=dkHqu0YH+j2unA@mail.gmail.com> <CA+khW7jiW=oAHS-N1ADLbqB74jTwAaLqUFFvYgb4xTz9WFwtZg@mail.gmail.com>
In-Reply-To: <CA+khW7jiW=oAHS-N1ADLbqB74jTwAaLqUFFvYgb4xTz9WFwtZg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Aug 2022 21:09:25 -0700
Message-ID: <CAEf4BzZcwN3N-8iHrHWFmunoWAVP4-snUs7kxpLLnQJpOtR+rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/8] selftests/bpf: Test cgroup_iter.
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 1, 2022 at 3:55 PM Hao Luo <haoluo@google.com> wrote:
>
> On Mon, Aug 1, 2022 at 2:51 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> > > of the following structure:
> > >
> > >     ROOT (working cgroup)
> > >      |
> > >    PARENT
> > >   /      \
> > > CHILD1  CHILD2
> > >
> > > and tests the following scenarios:
> > >
> > >  - invalid cgroup fd.
> > >  - pre-order walk over descendants from PARENT.
> > >  - post-order walk over descendants from PARENT.
> > >  - walk of ancestors from PARENT.
> > >  - early termination.
> > >
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 193 ++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> > >  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
> > >  3 files changed, 239 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
> > >

[...]

> > > +#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
> > > +       snprintf(expected_output, sizeof(expected_output), \
> > > +                PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
> > > +                (cg_id1), (cg_id2), (cg_id3))
> > > +
> >
> > you use format_expected_output{1,2} just once and
> > format_expected_output3 twice. Is it worth defining macros for that?
> >
>
> If not, we'd see this snprintf and format all over the place. It looks
> worse than the current one I think, prefer leave as-is.

All over the place == 4 places where it matters.

We are not trying to write the most beautiful code through macro
obfuscation. The point is to write tests that are easy to follow,
debug, understand, and potentially modify. Adding extra layers of
macros goes against this. Instead of clearly seeing in each individual
subtest that we expect "%llu\n%llu\n", I need to search what
"format_expected_output3" is actually doing, then I'm wondering where
expected_output is coming from (I scan macro input args, see nothing,
then I conclude it must be coming from the environment; I jump to one
of the format_expected_output3 invocation sites, see no local variable
named "expected_output", then I look around and see global variable;
aha, finally!) Sure it's a rather trivial thing, but this adds up.

*Unnecessary* macros are bad and a hindrance. Please avoid them, if
possible. Saving 20 characters is not a sufficient justification in my
view.

>
> > > +const char *cg_path[] = {
> > > +       "/", "/parent", "/parent/child1", "/parent/child2"
> > > +};
> > > +

[...]

> > > +       link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
> > > +       if (!ASSERT_ERR_PTR(link, "attach_iter"))
> > > +               bpf_link__destroy(link);
> >
> > nit: you can call bpf_link__destroy() even if link is NULL or IS_ERR
> >
>
> Ack. Still need to ASSERT on 'link' though, so the saving is probably
> just an indentation. Anyway, will change.

Yeah, of course you need to assert. But it's nice to have
unconditional assertion.

>
> > > +}
> > > +
> >
> > [...]
> >

[...]
