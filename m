Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62277400
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfGZW0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:26:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40767 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfGZW0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 18:26:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so25133263pfp.7
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 15:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UTijqTalaHjEMl8XOEIA/Zh+v74r2+x8ZUdX+8Ud+6Q=;
        b=U/P/dN31lbJIBpvcaz8y7Cb1Ibe97EfU1muwLVRY6tQCC4EkPlIwP1Rn9Ii5gfoHO5
         9n3Cu/v277SX79h+l0uwjDnSVZrA/AKxxO3Gy9UeOCFkqcsFdl8eRRc2OnHL3u4qFRD/
         DTOInQyjfqROxRZrCsikkw/U4vVsB/bER3aeT7c9exgz1WYW76r/+eyX1jjC+AHoJRcT
         0Gxud8B2MQQVwGg7w93xgOiyNw6QzOrt8DbxFaCYDZLI42BST+6sZ1nLR56WmSn3yVBb
         6IRl+miawVboIlxa6Xaqtlv9JWjHlFR7d9HycTWqXXkzUYj+r8YRwlsz4jh1Sa3NX4tS
         kepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UTijqTalaHjEMl8XOEIA/Zh+v74r2+x8ZUdX+8Ud+6Q=;
        b=WXvDhzs/Rua7gSlfoTi/2dWH2Ov2mUdW1r59IJZ9PgMr1hu922qEsB21d9zCP5fZwD
         vgwlO1hqWPtkOfJR6QHGKFW4pqeoG9lDO6O1ktEWFIsnv4V50dH3ezM8MRfyuw41VF92
         7Dzcxv5xnprZVsmobyqEtBMKbgjyj0mNGVRvjMLMgxuumwwrglnS7mdB2x1GZqwvXB15
         Hp5jWySYlpkpWEz7GEKmetl9OLoYy5e7vHlBkVvY+Ac/p0Sq0dopsNypwFz8q6zLdQQ2
         qtmm1M7HtRuVb3cOc/0/DbTKple05112UISuVmnqnAkrFb4fYOnbb6vMo3h+53O6E4tA
         j44A==
X-Gm-Message-State: APjAAAXNJ981JpMhnTHiNstly+JeVZ3CFgbSPL+y2GKJzsTGeXhpTJAU
        hfwuwuJ2//0U/V/XV/+TvRo=
X-Google-Smtp-Source: APXvYqwjA3WWW1QgAJolExsTKW0fkunyFpH/kPU79FwVkPJjqEnKDgqS8bbcVG+bQr4A0C3rfOhJ9w==
X-Received: by 2002:aa7:8752:: with SMTP id g18mr23678771pfo.201.1564180014246;
        Fri, 26 Jul 2019 15:26:54 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s67sm55454275pjb.8.2019.07.26.15.26.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 15:26:53 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:26:52 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 6/9] selftests/bpf: abstract away test log output
Message-ID: <20190726222652.GG24397@mini-arch>
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-7-andriin@fb.com>
 <20190726213104.GD24397@mini-arch>
 <CAEf4BzaVCdHT_U+m7niJLsSmbf+M9DrFjf_PNOmQQZvuHsr9Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaVCdHT_U+m7niJLsSmbf+M9DrFjf_PNOmQQZvuHsr9Xg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/26, Andrii Nakryiko wrote:
> On Fri, Jul 26, 2019 at 2:31 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 07/26, Andrii Nakryiko wrote:
> > > This patch changes how test output is printed out. By default, if test
> > > had no errors, the only output will be a single line with test number,
> > > name, and verdict at the end, e.g.:
> > >
> > >   #31 xdp:OK
> > >
> > > If test had any errors, all log output captured during test execution
> > > will be output after test completes.
> > >
> > > It's possible to force output of log with `-v` (`--verbose`) option, in
> > > which case output won't be buffered and will be output immediately.
> > >
> > > To support this, individual tests are required to use helper methods for
> > > logging: `test__printf()` and `test__vprintf()`.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/bpf_obj_id.c     |   6 +-
> > >  .../bpf/prog_tests/bpf_verif_scale.c          |  31 ++--
> > >  .../bpf/prog_tests/get_stack_raw_tp.c         |   4 +-
> > >  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
> > >  .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
> > >  .../selftests/bpf/prog_tests/send_signal.c    |   8 +-
> > >  .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
> > >  .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
> > >  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
> > >  .../selftests/bpf/prog_tests/xdp_noinline.c   |   3 +-
> > >  tools/testing/selftests/bpf/test_progs.c      | 135 +++++++++++++-----
> > >  tools/testing/selftests/bpf/test_progs.h      |  37 ++++-
> > >  12 files changed, 173 insertions(+), 73 deletions(-)
> > >
> 
> [...]
> 
> > >               error_cnt++;
> > > -             printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > > +             test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
> > #define printf(...) test__printf(...) in tests.h?
> >
> > A bit ugly, but no need to retrain everyone to use new printf wrappers.
> 
> I try to reduce amount of magic and surprising things, not add new
> ones :) I also led by example and converted all current instances of
> printf usage to test__printf, so anyone new will just copy/paste good
> example, hopefully. Even if not, this non-buffered output will be
> immediately obvious to anyone who just runs `sudo ./test_progs`.

[..]
> And
> author of new test with this problem should hopefully be the first and
> the only one to catch and fix this.
Yeah, that is my only concern, that regular printfs will eventually
creep in. It's already confusing to go to/from printf/printk.

2c:

I'm coming from a perspective of tools/testing/selftests/kselftest.h
which is supposed to be a generic framework with custom
printf variants (ksft_print_msg), but I still see a bunch of tests
calling printf :-/

	grep -ril ksft_exit_fail_msg selftests/ | xargs -n1 grep -w printf

Since we don't expect regular buffered io from the tests anyway
it might be easier just to add a bit of magic and call it a day.

> > >       }
> > >  out:
> > >       bpf_object__close(obj);
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > > index ee99368c595c..2e78217ed3fd 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
> > > @@ -9,12 +9,12 @@ static void *parallel_map_access(void *arg)
> 
> [...]
