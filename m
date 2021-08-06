Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE2D3E218F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 04:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbhHFCec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 22:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhHFCeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 22:34:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8197BC061798;
        Thu,  5 Aug 2021 19:34:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ca5so13682953pjb.5;
        Thu, 05 Aug 2021 19:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l3yFM7Aq+tdblJGSgD+OMG6ojcZodZ4OUSc1uTav2Sc=;
        b=fqGqRuyaGjfkMG0jTnz+J4dGDwe6OmD/2S+5bEjgxIJUwN4E3oPOReLv2bsT85zHgx
         biubkZpKP6oRCZXdnphdz9+aHr3phUAwHbYAy4mJ99JzPqdiDric4pqEjZS4jiBqVxjx
         hCfANGhq3mcbyzzcE10ZUcQBdI5AEotGqAp+5IT9N4tJDlR6yEap9HdMmDEvdTrx8qoJ
         AbDLDsfqdH3W4Z7H6xLLPbexO9HRvSTlvJRbGLG/0e/76mO2InCuQWuFU4ISAp58h+ni
         JbadzriuonGlK6Yc6i1uWiPEnVaFfAD6XsATWV7bhXboXdAzwc3VkkfHMcW2EV9vZBFa
         dDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l3yFM7Aq+tdblJGSgD+OMG6ojcZodZ4OUSc1uTav2Sc=;
        b=eA2vewHAScwmXcofRlO0EyQRqbPJmcxyIR8J3dHeUwFM2bcPTa5KGyLAGMB1+DLVDB
         7ydaraQ1txn9HZfQsBhBOuQDcFDPopp3UuIyMR7mNfgBBNDbQF6K2xbJBezMdrseNtGw
         xYmUylHGfZ5eSeTAIX7tFMXLY3f4NFrAeKsLaYnoEv0C+K0joeqQ/I0fTAafzUsIJgTU
         v0U9QH7z0MgiVMUTHOaURvmPEMIzi5roeVgo15vckbbrS66WoCbHFQO0XY3peBDMHxSc
         sJoDP17Hwq5bWYQ9ITwn2N69Hkcwa1LdAAJJUKOQa0QBvZKjZFGAAQEzJna4qyotzyd+
         AH5A==
X-Gm-Message-State: AOAM5334uR8d0xAz2xIqwh1JHLv6HGpykkQQVYP5+DU7YDh3TVVyj1oe
        lzgEBdPUt0S/X6cYkuhfjerNLQbZ66F8igMniR0=
X-Google-Smtp-Source: ABdhPJyhn5g+f8LxB40t6eXCSwF+4XZmoleFKgRrFnEholrkMEzobxwR+84qJIMqoz5pJzWpnr4zKogtCiDCERfRuK4=
X-Received: by 2002:a63:154a:: with SMTP id 10mr2893567pgv.428.1628217255025;
 Thu, 05 Aug 2021 19:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
 <20210704190252.11866-12-xiyou.wangcong@gmail.com> <CAEf4BzaccTCGeONN4MB5iRBZfmzfS3rR0R6XEPVmUKukrLSJ3w@mail.gmail.com>
In-Reply-To: <CAEf4BzaccTCGeONN4MB5iRBZfmzfS3rR0R6XEPVmUKukrLSJ3w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 5 Aug 2021 19:34:04 -0700
Message-ID: <CAM_iQpWo7DU+LEVG42bWmxhWY-z9m3mx3=TWvUu6v7DgFN2OoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 11/11] selftests/bpf: add test cases for
 redirection between udp and unix
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 3:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Jul 4, 2021 at 12:05 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Add two test cases to ensure redirection between udp and unix
> > work bidirectionally.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  .../selftests/bpf/prog_tests/sockmap_listen.c | 170 ++++++++++++++++++
> >  1 file changed, 170 insertions(+)
> >
>
> [...]
>
> > +       n = write(c1, "a", 1);
> > +       if (n < 0)
> > +               FAIL_ERRNO("%s: write", log_prefix);
> > +       if (n == 0)
> > +               FAIL("%s: incomplete write", log_prefix);
> > +       if (n < 1)
> > +               goto close;
> > +
> > +       key = SK_PASS;
> > +       err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
> > +       if (err)
> > +               goto close;
> > +       if (pass != 1)
> > +               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> > +
> > +       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> > +       if (n < 0)
> > +               FAIL_ERRNO("%s: read", log_prefix);
>
> Hey Cong,
>
> This test is pretty flaky and quite frequently fails in our CIs (e.g., [0]):
>
> ./test_progs-no_alu32:unix_udp_redir_to_connected:1949: egress: read:
> Resource temporarily unavailable
>   unix_udp_redir_to_connected:FAIL:1949
>
> Please send a fix to make it more reliable. Thanks!

Using an unbound number of retries makes this reliable, but you
dislike it. ;) But, there must be some reason for the delay of
packet delivery, I guess it might be related to workqueue scheduling,
let me check it tomorrow.

Thanks.
