Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA01ABDEA
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392278AbfIFQmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:42:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38031 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732712AbfIFQmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:42:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so4876351pfe.5;
        Fri, 06 Sep 2019 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8F4vyAP7xufW5sYJcgtxJXKLIYDbjk5khl9fDuHf24A=;
        b=dBmU6TMrljwjRO2IWF/BCZHJDgxj9cvCSZ7GRmAvS0XysSxcJRaReaBhSYoArUz8KE
         PlGwZO+/eNuRZ90iZalarVTROtWOrOaerTb6zkBhMKxahXz+vksiknkPK6Gngzb90Qpq
         vZ2PCapsL0qYQomJRVl8uw3s98BspY5D/Rv6LWIhCh3m+TqPp1NmU/iv5WqBJ8e5gCCD
         DJoD61bsIxCBDgaHJF921fz0k7n6sT8IxmaKI4YHU4KxZzerEdmMATsd6o5ZFaebDr7h
         4L/U9GLLxqwbTzxTyW9bRxSRBGTEguLP1s2rHbOOm4Q1AdbyuWLc28TugywKuzF+6oQX
         BVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8F4vyAP7xufW5sYJcgtxJXKLIYDbjk5khl9fDuHf24A=;
        b=J2Ict8K9raLCdStUOqMgV+bXAhK3a4BQemuEOxObU0O2dj+Dc58D44k/YSb5pwCq5x
         3L278cBFlzMwv+/r+d030TtOHrdbWzhWYd28UFdyr1UtSvquq7mZVrhnBJjYaFwdMV/7
         xhUoKKAB5vwCECK7i2fTa7jQFAeF+yxRysM+fFWmUziJIPavkOrqkSkS1fIoWy9sCOPQ
         zcXjyHMO7+4HOcFq2fmZTZGk3BhlwkiRcWSHhWc3SQDi31vXs3MfDWZodgzVtI3R7lYU
         6lnkt/y2kMDmS6IVGHKsAXaZLOHJd+2MKplCXeTIuek1DAuvfSQKvLAI01ytJ70Oq2u5
         JFEA==
X-Gm-Message-State: APjAAAXxqVP1h1AJqS/i99yQ3Gp0C3glyJXg4I6az6tXhCqOJhnorAPH
        wXmCRntt4ZeW+Cw1E5udzWM=
X-Google-Smtp-Source: APXvYqzPpvPo2Qc+q/Yy5oo0nF+VvgkhJcZPO667cTqUhNR9jQKNkIYzFbniu5TkfQbQAlNXhvxNMg==
X-Received: by 2002:a62:2b16:: with SMTP id r22mr11769282pfr.254.1567788156710;
        Fri, 06 Sep 2019 09:42:36 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:46a4])
        by smtp.gmail.com with ESMTPSA id g14sm6726362pfb.150.2019.09.06.09.42.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:42:35 -0700 (PDT)
Date:   Fri, 6 Sep 2019 09:42:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 0/6] selftests/bpf: move sockopt tests under
 test_progs
Message-ID: <20190906164233.npuhtaeoezpp2dol@ast-mbp.dhcp.thefacebook.com>
References: <20190904162509.199561-1-sdf@google.com>
 <20190904230331.ld4zsn4jgldu7l6q@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzaoh0Ur6Ze0VLNYqhTJ21Vp6D2NBMkb7yAeseqom=TyKA@mail.gmail.com>
 <20190906151808.GD2101@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906151808.GD2101@mini-arch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 08:18:08AM -0700, Stanislav Fomichev wrote:
> On 09/06, Andrii Nakryiko wrote:
> > On Wed, Sep 4, 2019 at 4:03 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Sep 04, 2019 at 09:25:03AM -0700, Stanislav Fomichev wrote:
> > > > Now that test_progs is shaping into more generic test framework,
> > > > let's convert sockopt tests to it. This requires adding
> > > > a helper to create and join a cgroup first (test__join_cgroup).
> > > > Since we already hijack stdout/stderr that shouldn't be
> > > > a problem (cgroup helpers log to stderr).
> > > >
> > > > The rest of the patches just move sockopt tests files under prog_tests/
> > > > and do the required small adjustments.
> > >
> > > Looks good. Thank you for working on it.
> > > Could you de-verbose setsockopt test a bit?
> > > #23/32 setsockopt: deny write ctx->retval:OK
> > > #23/33 setsockopt: deny read ctx->retval:OK
> > > #23/34 setsockopt: deny writing to ctx->optval:OK
> > > #23/35 setsockopt: deny writing to ctx->optval_end:OK
> > > #23/36 setsockopt: allow IP_TOS <= 128:OK
> > > #23/37 setsockopt: deny IP_TOS > 128:OK
> > > 37 subtests is a bit too much spam.
> > 
> > If we merged test_btf into test_progs, we'd have >150 subtests, which
> > would be pretty verbose as well. But the benefit of subtest is that
> > you can run just that sub-test and debug/verify just it, without all
> > the rest stuff.
> > 
> > So I'm wondering, if too many lines of default output is the only
> > problem, should we just not output per-subtest line by default?
> Ack, we can output per-subtest line if it fails so it's easy to re-run;
> otherwise, hiding by default sounds good. I'll prepare a v3 sometime
> today; Alexei, let us know if you disagree.

If the subtests are runnable and useful individually it's good to have
them as subtests.
I think in the above I misread them as a sequence of sub-checks that needs
to happen before actual test result.
Looking at test_sockopt.c I see that they're separate tests,
so yeah keep them.
No need to hide by default or extra flags.
Let me look at v1 and v2 again...

