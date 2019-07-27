Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B3E7756E
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfG0AeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:34:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33461 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfG0AeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:34:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id f20so16266599pgj.0;
        Fri, 26 Jul 2019 17:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6pYHIy+mwaL68SKcFjWoeaZSFpVYov6pJP+2mUZ7+R4=;
        b=mp99quU7VQHfZ/ouxJTnIB9CB7nPFgtXepGd0jMtElhLSpgiuiqBqB8Zz3PZKebUis
         dqp4EesgNS9PYdE4murHzHBPPBd0irqXok8F+78VbTml3ObpWNkqajU/cA73ysU9J3H2
         uwVI6ksP8NLn+xIAjsFwAWYSF01vu9tLchr8bv3H01aV/sKjy0ZAUKZg0sguk5b4dWLS
         9jRVsRGHNOP/n8CxpPh1NVWzhQxBDwsc9nFgbS29IOeUUIne7JVUzDwwg67JGbT29uJo
         ASDGahSn45/PlvyrYjZz5KaP+nQ+CU2rK1IWYVlVq5lS2Eha6y8JLTinUANeTBcfgtMf
         I2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6pYHIy+mwaL68SKcFjWoeaZSFpVYov6pJP+2mUZ7+R4=;
        b=fTOOb8DWB5cKe3NjZ13cVht/83O2NQKkGSGf4UtgtvKEiK6DxRtlyfH5X7dHjkRjLj
         h/r5whwL3f1k30z40oc4k2wIlwK6EHOiAE8osuVg1CwL2I0t8w7YUrr1ttkgvMVS7qPF
         8gnRDm47/H9uXtXnKv5HhODG/oc7s2NrOxeNhxDgLRjXdCPy3zxTzgl8zTu7pKDVFzyw
         PYagCT8rvlnCRNs+UfZkb2bTC/+fAxHZCaR0DdDXRF99GMxSRoSRwpDGNBoHbzPLMHJO
         86d+Ps+FWwwmNUCHQjhlEkwvgYQLRWLnJMqQ11yKnB/2IQTN5e57NJ5WycXGCz+dPSG8
         /SCA==
X-Gm-Message-State: APjAAAWs1luFthdLkTrWybZSvaauY3EFMDPF1t7sdmCJ8yTb9r5CVz9d
        /TguImuujPEuLMxIJG775DY=
X-Google-Smtp-Source: APXvYqxIuSxJqCDbqK3XsXrMhQSdNIiMA7kPLBsMKXW78E6Rmbvac62R1Mh4fsYeAC/qBAs7BZkDkw==
X-Received: by 2002:a62:7552:: with SMTP id q79mr25165052pfc.71.1564187651739;
        Fri, 26 Jul 2019 17:34:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:2eeb])
        by smtp.gmail.com with ESMTPSA id 185sm62403024pfa.170.2019.07.26.17.34.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 17:34:10 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:34:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 6/9] selftests/bpf: abstract away test log output
Message-ID: <20190727003408.5hgu5prcz2mwqv22@ast-mbp.dhcp.thefacebook.com>
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-7-andriin@fb.com>
 <20190726213104.GD24397@mini-arch>
 <CAEf4BzaVCdHT_U+m7niJLsSmbf+M9DrFjf_PNOmQQZvuHsr9Xg@mail.gmail.com>
 <20190726222652.GG24397@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726222652.GG24397@mini-arch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 03:26:52PM -0700, Stanislav Fomichev wrote:
> On 07/26, Andrii Nakryiko wrote:
> > On Fri, Jul 26, 2019 at 2:31 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 07/26, Andrii Nakryiko wrote:
> > > > This patch changes how test output is printed out. By default, if test
> > > > had no errors, the only output will be a single line with test number,
> > > > name, and verdict at the end, e.g.:
> > > >
> > > >   #31 xdp:OK
> > > >
> > > > If test had any errors, all log output captured during test execution
> > > > will be output after test completes.
> > > >
> > > > It's possible to force output of log with `-v` (`--verbose`) option, in
> > > > which case output won't be buffered and will be output immediately.
> > > >
> > > > To support this, individual tests are required to use helper methods for
> > > > logging: `test__printf()` and `test__vprintf()`.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  .../selftests/bpf/prog_tests/bpf_obj_id.c     |   6 +-
> > > >  .../bpf/prog_tests/bpf_verif_scale.c          |  31 ++--
> > > >  .../bpf/prog_tests/get_stack_raw_tp.c         |   4 +-
> > > >  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
> > > >  .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
> > > >  .../selftests/bpf/prog_tests/send_signal.c    |   8 +-
> > > >  .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
> > > >  .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
> > > >  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
> > > >  .../selftests/bpf/prog_tests/xdp_noinline.c   |   3 +-
> > > >  tools/testing/selftests/bpf/test_progs.c      | 135 +++++++++++++-----
> > > >  tools/testing/selftests/bpf/test_progs.h      |  37 ++++-
> > > >  12 files changed, 173 insertions(+), 73 deletions(-)
> > > >
> > 
> > [...]
> > 
> > > >               error_cnt++;
> > > > -             printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > > > +             test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > > #define printf(...) test__printf(...) in tests.h?
> > >
> > > A bit ugly, but no need to retrain everyone to use new printf wrappers.
> > 
> > I try to reduce amount of magic and surprising things, not add new
> > ones :) I also led by example and converted all current instances of
> > printf usage to test__printf, so anyone new will just copy/paste good
> > example, hopefully. Even if not, this non-buffered output will be
> > immediately obvious to anyone who just runs `sudo ./test_progs`.
> 
> [..]
> > And
> > author of new test with this problem should hopefully be the first and
> > the only one to catch and fix this.
> Yeah, that is my only concern, that regular printfs will eventually
> creep in. It's already confusing to go to/from printf/printk.
> 
> 2c:
> 
> I'm coming from a perspective of tools/testing/selftests/kselftest.h
> which is supposed to be a generic framework with custom
> printf variants (ksft_print_msg), but I still see a bunch of tests
> calling printf :-/
> 
> 	grep -ril ksft_exit_fail_msg selftests/ | xargs -n1 grep -w printf
> 
> Since we don't expect regular buffered io from the tests anyway
> it might be easier just to add a bit of magic and call it a day.

I think #define printf()
is not a good style in general.
glibc functions should never be #define-d.

