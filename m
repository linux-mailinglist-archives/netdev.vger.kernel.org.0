Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0002C3403
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbgKXW2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbgKXW2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:28:46 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A45BC0613D6;
        Tue, 24 Nov 2020 14:28:46 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id q22so857400qkq.6;
        Tue, 24 Nov 2020 14:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6qMIhhD46wjafMaBI21a9ElTyDuse9nsqsmVwzT8Ik=;
        b=rP4DYdE7UjerZlo7keZfkgNqBJHFNWsMd9asuVuFtDUyUZdqIOeVmSG/elFu0VxEyO
         FxsaHwtTwOKxoDIAVqFvQNqBwviaag9+tzjc8bqW48TClJQbKDb24LZCHBxRysDh4IQv
         viJNCKxlWY12DIZZiG/qkdh9Ix7MSaXIyFJv6+VwquqZeE5FSTXXatM9mSkgGXsFAB7S
         hIydWSXmExCXW81D++/PJdBe1RDCy2V9EjP4/82MQ0QQtrjLnML3z88w/K1qmQ+2eQW7
         vt/wHhOgZtPO7ISMHUe6Sxecksm4gkOBMguK0h7PcmPnRY0b/gbZQ9jQh2i06GsrbK6J
         3pOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6qMIhhD46wjafMaBI21a9ElTyDuse9nsqsmVwzT8Ik=;
        b=NQzgFetUAQ1LQACKTvfIQYcpZSWBTb9xKIfaOebaTJvOlATsvX0RTIYP5SamI/o6yz
         0KYaW9DtrLWvAKdXRJqMyXAgblV6lHvaGaWSGdkB8U0xJhGlBv/DVwAjJkbk9h26OQ+N
         UjJgRBMDdvrxj3kjsKNnNlQwkJyWh/V7QUJGxkhXikzX06ygYEheMAlHyPzISd6yvIeO
         6S21pvHPUAZniF2ZK7l5yfWmD9Mcrt8xTio0/1CfJB3hLKIW4zrYugZnufAhZgiMHT0O
         pqtm4eXitO986yAXFkt90WlexB/j0ztFuAMZUFcm0be0Q50HiFiLWCHipe73YY3C2knK
         atZA==
X-Gm-Message-State: AOAM533yRM+wDafzZ68aWwG195rhPz2mF6WwIOJXYlvIF4FWHjsleSAa
        4nMdLk3cjTU7FXAaMSnFhu7S6YiMrDBvBOYZ0fQ=
X-Google-Smtp-Source: ABdhPJwI4LWUge2nxBwIPjqMgyQ9sFqVrE0uXQ1iuSeG0Mg6lIidvh2/K7fbvboxzO+Z71bC4L9RQdUdp5b74/jxQnU=
X-Received: by 2002:a25:493:: with SMTP id 141mr380822ybe.104.1606256925365;
 Tue, 24 Nov 2020 14:28:45 -0800 (PST)
MIME-Version: 1.0
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-6-weqaar.a.janjua@intel.com> <86e3a9e4-a375-1281-07bf-6b04781bb02f@fb.com>
 <CAPLEeBY_p_0QsZeqvrr0P+uf1jkL_eFGgawc=KD6Rkuh_177NA@mail.gmail.com>
 <CAPLEeBYMy3N0D9XT6zO9HPrZfSua4_KpnTh4fY8JyFJ6JickZA@mail.gmail.com> <ebfb17fa-39e0-5810-f1a6-20c6804172c8@fb.com>
In-Reply-To: <ebfb17fa-39e0-5810-f1a6-20c6804172c8@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Tue, 24 Nov 2020 22:28:19 +0000
Message-ID: <CAPLEeBb3oVRY_mSJYzEHAeCwFD2+ZsozZt-JQfU=Qd+MAh6ieg@mail.gmail.com>
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

On Tue, 24 Nov 2020 at 17:10, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/24/20 7:11 AM, Weqaar Janjua wrote:
> > On Sat, 21 Nov 2020 at 20:14, Weqaar Janjua <weqaar.janjua@gmail.com> wrote:
> >>
> >> On Fri, 20 Nov 2020 at 20:45, Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>>
> >>>
> >>> On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> >>>> Adds following tests:
> >>>>
> >>>> 1. AF_XDP SKB mode
> >>>>      d. Bi-directional Sockets
> >>>>         Configure sockets as bi-directional tx/rx sockets, sets up fill
> >>>>         and completion rings on each socket, tx/rx in both directions.
> >>>>         Only nopoll mode is used
> >>>>
> >>>> 2. AF_XDP DRV/Native mode
> >>>>      d. Bi-directional Sockets
> >>>>      * Only copy mode is supported because veth does not currently support
> >>>>        zero-copy mode
> >>>>
> >>>> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> >>>> ---
> >>>>    tools/testing/selftests/bpf/Makefile          |   4 +-
> >>>>    .../bpf/test_xsk_drv_bidirectional.sh         |  23 ++++
> >>>>    .../selftests/bpf/test_xsk_drv_teardown.sh    |   3 -
> >>>>    .../bpf/test_xsk_skb_bidirectional.sh         |  20 ++++
> >>>>    tools/testing/selftests/bpf/xdpxceiver.c      | 100 +++++++++++++-----
> >>>>    tools/testing/selftests/bpf/xdpxceiver.h      |   4 +
> >>>>    6 files changed, 126 insertions(+), 28 deletions(-)
> >>>>    create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> >>>>    create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_bidirectional.sh
> >>>>
> >>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> >>>> index 515b29d321d7..258bd72812e0 100644
> >>>> --- a/tools/testing/selftests/bpf/Makefile
> >>>> +++ b/tools/testing/selftests/bpf/Makefile
> >>>> @@ -78,7 +78,9 @@ TEST_PROGS := test_kmod.sh \
> >>>>        test_xsk_drv_nopoll.sh \
> >>>>        test_xsk_drv_poll.sh \
> >>>>        test_xsk_skb_teardown.sh \
> >>>> -     test_xsk_drv_teardown.sh
> >>>> +     test_xsk_drv_teardown.sh \
> >>>> +     test_xsk_skb_bidirectional.sh \
> >>>> +     test_xsk_drv_bidirectional.sh
> >>>>
> >>>>    TEST_PROGS_EXTENDED := with_addr.sh \
> >>>>        with_tunnels.sh \
> >>>> diff --git a/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> >>>> new file mode 100755
> >>>> index 000000000000..d3a7e2934d83
> >>>> --- /dev/null
> >>>> +++ b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> >>>> @@ -0,0 +1,23 @@
> >>>> +#!/bin/bash
> >>>> +# SPDX-License-Identifier: GPL-2.0
> >>>> +# Copyright(c) 2020 Intel Corporation.
> >>>> +
> >>>> +# See test_xsk_prerequisites.sh for detailed information on tests
> >>>> +
> >>>> +. xsk_prereqs.sh
> >>>> +. xsk_env.sh
> >>>> +
> >>>> +TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
> >>>> +
> >>>> +vethXDPnative ${VETH0} ${VETH1} ${NS1}
> >>>> +
> >>>> +params=("-N" "-B")
> >>>> +execxdpxceiver params
> >>>> +
> >>>> +retval=$?
> >>>> +test_status $retval "${TEST_NAME}"
> >>>> +
> >>>> +# Must be called in the last test to execute
> >>>> +cleanup_exit ${VETH0} ${VETH1} ${NS1}
> >>>
> >>> This also makes hard to run tests as users will not know this unless
> >>> they are familiar with the details of the tests.
> >>>
> >>> How about you have another scripts test_xsk.sh which includes all these
> >>> individual tests and pull the above cleanup_exit into test_xsk.sh?
> >>> User just need to run test_xsk.sh will be able to run all tests you
> >>> implemented here.
> >>>
> >> This works, test_xsk_* >> test_xsk.sh, will ship out as v3.
> >>
> > An issue with merging all tests in a single test_xsk.sh is reporting
> > number of test failures, with this approach a single test status is
> > printed by kselftest:
> >
> > # PREREQUISITES: [ PASS ]
> > # SKB NOPOLL: [ FAIL ]
> > # SKB POLL: [ PASS ]
> > ok 1 selftests: xsk-patch2: test_xsk.sh
> >
> > This is due to the fact Makefile has one TEST_PROGS = test_xsk.sh
> > (thus kselftest considers it one test?), where in the original
> > approach all tests have separate TEST_PROGS .sh which makes reporting
> > match each test and status. This can be a problem for automation.
> >
> > An alternative would be to exit each test with failure status but then
> > the tests will stop execution at the failed test without executing the
> > rest of xsk tests, which we probably wouldn't want.
> >
> > Suggestions please?
>
> I think it is okay to put everything xsk related to one test.
> If later on the test becomes more complex, you can have
> test_xsk_<1>.sh test_xsk_<2>.sh etc. But each .sh should be able to
> run independently without any particular order.
>
> You can have subtests inside the .sh file. See test_offload.py as
> an example. You do not need to exit after one subtest fails, you can
> continue to run the next one. currently test_offload.py
> may exit when some subtest failed, but I think you don't have to.
>
ACK, I will go ahead and merge all test_xsk_*.sh into test_xsk.sh.

Just to clarify that all current xsk tests are independent, there is
no subtest at present, and do not need to run in any order.

Thanks,
/Weqaar

> >
> >>>> +
> >>>> +test_exit $retval 0
> >>>> diff --git a/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
> >>> [...]
