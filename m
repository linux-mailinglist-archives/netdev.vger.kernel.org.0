Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D730F2C2AEB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389621AbgKXPLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388174AbgKXPLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:11:44 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A80C0613D6;
        Tue, 24 Nov 2020 07:11:43 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id x17so19576977ybr.8;
        Tue, 24 Nov 2020 07:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=skcH4W/nW4VBMgtR2TYOTfiuGFnISkIorPj9FdwOEuA=;
        b=LQJykAZxuaZhzIUkeDgw4MlRQVh6yXMHl3/K4H0wEulIh8YpK94j5WylauGBiZijQn
         g6icHoy4dqtScKGBwJtSVe90kMeQnvaus7otQypwB7GFENv6rdshk28ANtOGCxBX18zz
         SBtl9GyNGw4HdzGyQb/eLftmgCDuULrqzmLEuaEzpTJpidzhZctV0Pne1vcFWzIUeLHm
         SzLBVa+8P14oKiMRFZBEzbC0NPFbmLAscOLyyWYKDkm609q1lwCioT3DunCbrG2FWd6K
         BfYOhxGU9zUuQSaFyJCpVaEQNYvj0529Cf6oUSxd9m+6ZHhv3+tAWmmzYzm/lgLbYwaK
         AkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=skcH4W/nW4VBMgtR2TYOTfiuGFnISkIorPj9FdwOEuA=;
        b=aIkMaa5Cms/vV6fUbPlcND2b+UWx8fWvbM/8PI6Q+jVs7pcyWv07BnH1HuiQNG2oov
         5yGU1I3S1TGHm73L/vch1YkBNlU56D4kLBdUnhdE64XLQRQrRRTgnNiSWHDtMVBFtwz9
         L43pIRQoPksgiRhpGqhbB8btK6tcRcpMb2T0szE7BTA4q2F9jJfXJKjwxBWG/SqBvNV3
         YeKXplupLl2ecNvac3Fu6J3fIRpgrIEkV05F89TAVnopx4DPVpX9iGEQtJX5inHJkQ8P
         ovBQzzvd7L5GPySg51FNB48ZmdpIk3Wa+3bvkjhAOxk+ksYMPUbUsP117a/9YJkoxNZV
         C0rQ==
X-Gm-Message-State: AOAM530e7glhZ6zqfIWig/nr0iJMNdjVu9pipiKUnn7TYDG3/rr3kYNy
        +RKJaRu0u4Ld8TY7Mfu49yO2SkvtCM6LfBjsY/0=
X-Google-Smtp-Source: ABdhPJxPBd5VYJBDDiqSa9wv4QP4BHLIYDh81QEx+6l5vhSAWVBSB31M8Mni2TbgkTYsyplJ47gAIQ1T8Pj9huYWZO4=
X-Received: by 2002:a25:7717:: with SMTP id s23mr8499376ybc.459.1606230702927;
 Tue, 24 Nov 2020 07:11:42 -0800 (PST)
MIME-Version: 1.0
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-6-weqaar.a.janjua@intel.com> <86e3a9e4-a375-1281-07bf-6b04781bb02f@fb.com>
 <CAPLEeBY_p_0QsZeqvrr0P+uf1jkL_eFGgawc=KD6Rkuh_177NA@mail.gmail.com>
In-Reply-To: <CAPLEeBY_p_0QsZeqvrr0P+uf1jkL_eFGgawc=KD6Rkuh_177NA@mail.gmail.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Tue, 24 Nov 2020 15:11:16 +0000
Message-ID: <CAPLEeBYMy3N0D9XT6zO9HPrZfSua4_KpnTh4fY8JyFJ6JickZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: xsk selftests -
 Bi-directional Sockets - SKB, DRV
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 at 20:14, Weqaar Janjua <weqaar.janjua@gmail.com> wrote:
>
> On Fri, 20 Nov 2020 at 20:45, Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> > > Adds following tests:
> > >
> > > 1. AF_XDP SKB mode
> > >     d. Bi-directional Sockets
> > >        Configure sockets as bi-directional tx/rx sockets, sets up fill
> > >        and completion rings on each socket, tx/rx in both directions.
> > >        Only nopoll mode is used
> > >
> > > 2. AF_XDP DRV/Native mode
> > >     d. Bi-directional Sockets
> > >     * Only copy mode is supported because veth does not currently support
> > >       zero-copy mode
> > >
> > > Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> > > ---
> > >   tools/testing/selftests/bpf/Makefile          |   4 +-
> > >   .../bpf/test_xsk_drv_bidirectional.sh         |  23 ++++
> > >   .../selftests/bpf/test_xsk_drv_teardown.sh    |   3 -
> > >   .../bpf/test_xsk_skb_bidirectional.sh         |  20 ++++
> > >   tools/testing/selftests/bpf/xdpxceiver.c      | 100 +++++++++++++-----
> > >   tools/testing/selftests/bpf/xdpxceiver.h      |   4 +
> > >   6 files changed, 126 insertions(+), 28 deletions(-)
> > >   create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> > >   create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_bidirectional.sh
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 515b29d321d7..258bd72812e0 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -78,7 +78,9 @@ TEST_PROGS := test_kmod.sh \
> > >       test_xsk_drv_nopoll.sh \
> > >       test_xsk_drv_poll.sh \
> > >       test_xsk_skb_teardown.sh \
> > > -     test_xsk_drv_teardown.sh
> > > +     test_xsk_drv_teardown.sh \
> > > +     test_xsk_skb_bidirectional.sh \
> > > +     test_xsk_drv_bidirectional.sh
> > >
> > >   TEST_PROGS_EXTENDED := with_addr.sh \
> > >       with_tunnels.sh \
> > > diff --git a/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> > > new file mode 100755
> > > index 000000000000..d3a7e2934d83
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> > > @@ -0,0 +1,23 @@
> > > +#!/bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright(c) 2020 Intel Corporation.
> > > +
> > > +# See test_xsk_prerequisites.sh for detailed information on tests
> > > +
> > > +. xsk_prereqs.sh
> > > +. xsk_env.sh
> > > +
> > > +TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
> > > +
> > > +vethXDPnative ${VETH0} ${VETH1} ${NS1}
> > > +
> > > +params=("-N" "-B")
> > > +execxdpxceiver params
> > > +
> > > +retval=$?
> > > +test_status $retval "${TEST_NAME}"
> > > +
> > > +# Must be called in the last test to execute
> > > +cleanup_exit ${VETH0} ${VETH1} ${NS1}
> >
> > This also makes hard to run tests as users will not know this unless
> > they are familiar with the details of the tests.
> >
> > How about you have another scripts test_xsk.sh which includes all these
> > individual tests and pull the above cleanup_exit into test_xsk.sh?
> > User just need to run test_xsk.sh will be able to run all tests you
> > implemented here.
> >
> This works, test_xsk_* >> test_xsk.sh, will ship out as v3.
>
An issue with merging all tests in a single test_xsk.sh is reporting
number of test failures, with this approach a single test status is
printed by kselftest:

# PREREQUISITES: [ PASS ]
# SKB NOPOLL: [ FAIL ]
# SKB POLL: [ PASS ]
ok 1 selftests: xsk-patch2: test_xsk.sh

This is due to the fact Makefile has one TEST_PROGS = test_xsk.sh
(thus kselftest considers it one test?), where in the original
approach all tests have separate TEST_PROGS .sh which makes reporting
match each test and status. This can be a problem for automation.

An alternative would be to exit each test with failure status but then
the tests will stop execution at the failed test without executing the
rest of xsk tests, which we probably wouldn't want.

Suggestions please?

> > > +
> > > +test_exit $retval 0
> > > diff --git a/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
> > [...]
