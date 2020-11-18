Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921BD2B74A5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgKRDVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKRDVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:21:40 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C848C0613D4;
        Tue, 17 Nov 2020 19:21:40 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id w188so689583oib.1;
        Tue, 17 Nov 2020 19:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EwzV1WY7UR9Ao6IjTB0tUNCWpA/QmhX9rFcnwQF/QI=;
        b=BXsi3BHwkSZgpqF/ruIi1iLCxuN82HUaEjNUG8i2SBzUyfp6/01OXd5kLjCdsLbDr0
         IG7HlFCySu9+l9F+JjkuhHpInef7I/hi963bqnWJSrGp7zdvsNQVVoRwcLvx5lburgNw
         401eBUM4Vpb3KFAnEstjkXTeKj7RCX2wiqxNSUZ6Oxvnfqk/mgUuRfqKNhkvdsjg2YAV
         Hdih0WIRHQrOD3PaMmoMwGGb5fD3AlpJMExbVFjmY2pyInWo+FJnKB84EYMNpBcdbFrs
         BW7LYTcuizWzzLfDY1A9ab/tHq08ORkegHqtBb7WFwIeRL+bJk8f9LhEBvrrGTGJsdW2
         MN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EwzV1WY7UR9Ao6IjTB0tUNCWpA/QmhX9rFcnwQF/QI=;
        b=GtJDAYB9W81mLmdDyJHstlcic/Yrbt8GnvbiP08tWwTTpdhmlUSup1wKoBfSt9Kgis
         D/Pw7TecROvTfzT3fZu3986rH552PJ8oxulF619EI/3NOl5H+KkXaovqV/JhRDhGeFBz
         fHg6SBE2QH9O2mTTRn/kf5rgaypZpgpxd0jwQQjNydc7cJwxH8dWv2xpo2zOi2AcT4wp
         GmXcREPRaL4AGXEKO1ySfXRAvsekZEny/PG2zug8AinKoaoubqLU5+9f69SJrHJ6XLBc
         Yjt7jCTX1IqFgSOcs2Lp7VOVAWG3/u++fwpFshf6p4TZq1KsPVx7t4eYLw5Q5Wk+edIi
         6cxg==
X-Gm-Message-State: AOAM533w+PYlGMRnvq5eMnZtx69Q7RxgvTmVVpqOogJzvmjHQHZ49sWJ
        Q93t30S6o1zxIWS3+la2eaMYjgQILMyTAmoWLQ==
X-Google-Smtp-Source: ABdhPJzn7VyOySNpFE2m+Ct+hNPNMmJ6SatQ5RcWAq+bMaBCefU5Rj2+9+rflNkEL7cVVIA3sa4yepUnFgEpDReRvPQ=
X-Received: by 2002:aca:e007:: with SMTP id x7mr1531079oig.40.1605669699775;
 Tue, 17 Nov 2020 19:21:39 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-4-danieltimlee@gmail.com> <CAEf4BzbBT38n8YQNco7yfijahaKXWQWLqxiNGEq1q7Lj7N+_vA@mail.gmail.com>
In-Reply-To: <CAEf4BzbBT38n8YQNco7yfijahaKXWQWLqxiNGEq1q7Lj7N+_vA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 12:21:23 +0900
Message-ID: <CAEKGpzi8suN-ftSiERx4WT2y1vtq+=L=0aBYva8NgYmhkWbNeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/9] samples: bpf: refactor test_cgrp2_sock2
 program with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 12:02 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > This commit refactors the existing cgroup program with libbpf bpf
> > loader. The original test_cgrp2_sock2 has keeped the bpf program
> > attached to the cgroup hierarchy even after the exit of user program.
> > To implement the same functionality with libbpf, this commit uses the
> > BPF_LINK_PINNING to pin the link attachment even after it is closed.
> >
> > Since this uses LINK instead of ATTACH, detach of bpf program from
> > cgroup with 'test_cgrp2_sock' is not used anymore.
> >
> > The code to mount the bpf was added to the .sh file in case the bpff
> > was not mounted on /sys/fs/bpf. Additionally, to fix the problem that
> > shell script cannot find the binary object from the current path,
> > relative path './' has been added in front of binary.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile            |  2 +-
> >  samples/bpf/test_cgrp2_sock2.c  | 63 ++++++++++++++++++++++++---------
> >  samples/bpf/test_cgrp2_sock2.sh | 21 ++++++++---
> >  3 files changed, 64 insertions(+), 22 deletions(-)
> >
>
> [...]
>
> >
> > -       return EXIT_SUCCESS;
> > +       err = bpf_link__pin(link, link_pin_path);
> > +       if (err < 0) {
> > +               printf("err : %d\n", err);
>
> more meaningful error message would be helpful
>

Thanks for pointing out, I will fix it directly!

> > +               goto cleanup;
> > +       }
> > +
> > +       ret = EXIT_SUCCESS;
> > +
> > +cleanup:
> > +       if (ret != EXIT_SUCCESS)
> > +               bpf_link__destroy(link);
> > +
> > +       bpf_object__close(obj);
> > +       return ret;
> >  }
>
> [...]
>
> >
> >  function attach_bpf {
> > -       test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1
> > +       ./test_cgrp2_sock2 /tmp/cgroupv2/foo sock_flags_kern.o $1
>
> Can you please add Fixes: tag for this?
>

Will add it in the next version of patch :)

Thanks for your time and effort for the review.

-- 
Best,
Daniel T. Lee
