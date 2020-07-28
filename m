Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171EF2313AE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgG1UN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgG1UN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:13:27 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29AFC061794;
        Tue, 28 Jul 2020 13:13:27 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id t6so4838313qvw.1;
        Tue, 28 Jul 2020 13:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3RLDHD39/r1rmOySE5ClkH2D+Frc+P84o5NIcJQVME=;
        b=NLdQ+U3jhrg4A1dbk9egYqWyUVe535fXRhoO5WeSXvJkubETsH0jIOENmqSJCKhnKG
         5+jXjrNhHN4mBvPbIacIjWgg9WeEU0upGzOYyCg2iQz1pRTek1+NkLD+9vKrkvwkXBfR
         Rn5uL6y++Z3prUikzBCClY+sRVBxeRI0qklyVJR5Gjz34CNhNYU1IZirpmlhbKl7fsJj
         nsUNFJ9UXHXmjDpkArwta+yEBUt9j6VKWWTYSsE33zOhZFi16KxGOsBSgEr/Q9IbneGb
         fvC38LpiLcnsVMMz1IVovCnEFiIXKtL00vgCYibLlfwKDX4CvfYdd/8NfVTpMy+E/22h
         UdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3RLDHD39/r1rmOySE5ClkH2D+Frc+P84o5NIcJQVME=;
        b=FGiu57CyvbKgMtxhabD1SsmeObkwAoFmvXcjtZ8k+G8bbGdNc4U0/hxaMzcSfYkNmW
         03yrm1fI2yVHnN32Ffrze8DR4vWQ0p+VksR9V63lUExgfHw0hkwrG2poGPSKmwUUHmPr
         rMoylU3tJtALLgJNOJpWMPiMaQU+n4cd/FhFO856ztezbS9SBsDZlX6KnaXHVfbWtHOs
         ZTLx+I6UJpo7ZqJXatYJ6ntfu85K5yA4YJTYrHznyp7M7UsNj4UxOpDf6K7anzOhmqvl
         S+oXSgblLcrH5KYnpywJCf8kMv3M188bvio5bUvo8QOiL9t/8z6QuKns8EVIRET0DcUa
         VolQ==
X-Gm-Message-State: AOAM532kMFN8QApVFFSROmzTupn9e9523VmxWUfOegT7C+pw66cnqwpi
        RkAH/Pwv4UY1nxGoYtybFW7oJAPmBY5XocR8UYA=
X-Google-Smtp-Source: ABdhPJy4X6I/ubIcqPj9bL5WWuuF4F+jowryjRulDp1rNe4NsS/hiSaM864rldPcngVnqF4+OML69bFcavJRbxD2/9k=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr30044484qvv.163.1595967206980;
 Tue, 28 Jul 2020 13:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200717103536.397595-1-jakub@cloudflare.com> <20200717103536.397595-16-jakub@cloudflare.com>
In-Reply-To: <20200717103536.397595-16-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 13:13:16 -0700
Message-ID: <CAEf4BzZHf7838t88Ed3Gzp32UFMq2o2zryL3=hjAL4mELzUC+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 15/15] selftests/bpf: Tests for BPF_SK_LOOKUP
 attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 3:36 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Add tests to test_progs that exercise:
>
>  - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
>  - redirecting socket lookup to a socket selected by BPF program,
>  - failing a socket lookup on BPF program's request,
>  - error scenarios for selecting a socket from BPF program,
>  - accessing BPF program context,
>  - attaching and running multiple BPF programs.
>
> Run log:
>
>   bash-5.0# ./test_progs -n 70
>   #70/1 query lookup prog:OK
>   #70/2 TCP IPv4 redir port:OK
>   #70/3 TCP IPv4 redir addr:OK
>   #70/4 TCP IPv4 redir with reuseport:OK
>   #70/5 TCP IPv4 redir skip reuseport:OK
>   #70/6 TCP IPv6 redir port:OK
>   #70/7 TCP IPv6 redir addr:OK
>   #70/8 TCP IPv4->IPv6 redir port:OK
>   #70/9 TCP IPv6 redir with reuseport:OK
>   #70/10 TCP IPv6 redir skip reuseport:OK
>   #70/11 UDP IPv4 redir port:OK
>   #70/12 UDP IPv4 redir addr:OK
>   #70/13 UDP IPv4 redir with reuseport:OK
>   #70/14 UDP IPv4 redir skip reuseport:OK
>   #70/15 UDP IPv6 redir port:OK
>   #70/16 UDP IPv6 redir addr:OK
>   #70/17 UDP IPv4->IPv6 redir port:OK
>   #70/18 UDP IPv6 redir and reuseport:OK
>   #70/19 UDP IPv6 redir skip reuseport:OK
>   #70/20 TCP IPv4 drop on lookup:OK
>   #70/21 TCP IPv6 drop on lookup:OK
>   #70/22 UDP IPv4 drop on lookup:OK
>   #70/23 UDP IPv6 drop on lookup:OK
>   #70/24 TCP IPv4 drop on reuseport:OK
>   #70/25 TCP IPv6 drop on reuseport:OK
>   #70/26 UDP IPv4 drop on reuseport:OK
>   #70/27 TCP IPv6 drop on reuseport:OK
>   #70/28 sk_assign returns EEXIST:OK
>   #70/29 sk_assign honors F_REPLACE:OK
>   #70/30 sk_assign accepts NULL socket:OK
>   #70/31 access ctx->sk:OK
>   #70/32 narrow access to ctx v4:OK
>   #70/33 narrow access to ctx v6:OK
>   #70/34 sk_assign rejects TCP established:OK
>   #70/35 sk_assign rejects UDP connected:OK
>   #70/36 multi prog - pass, pass:OK
>   #70/37 multi prog - drop, drop:OK
>   #70/38 multi prog - pass, drop:OK
>   #70/39 multi prog - drop, pass:OK
>   #70/40 multi prog - pass, redir:OK
>   #70/41 multi prog - redir, pass:OK
>   #70/42 multi prog - drop, redir:OK
>   #70/43 multi prog - redir, drop:OK
>   #70/44 multi prog - redir, redir:OK
>   #70 sk_lookup:OK
>   Summary: 1/44 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>

Hey Jakub!

We are getting this failure in Travis CI when syncing libbpf [0]:

```
ip: either "local" is duplicate, or "nodad" is garbage

switch_netns:PASS:unshare 0 nsec

switch_netns:FAIL:system failed

(/home/travis/build/libbpf/libbpf/travis-ci/vmtest/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1310:
errno: No such file or directory) system(ip -6 addr add dev lo
fd00::1/128 nodad)

#73 sk_lookup:FAIL
```


Can you please help fix it so that it works in a Travis CI environment
as well? For now I disabled sk_lookup selftests altogether. You can
try to repro it locally by forking https://github.com/libbpf/libbpf
and enabling Travis CI for your account. See [1] for the PR that
disabled sk_lookup.


  [0] https://travis-ci.com/github/libbpf/libbpf/jobs/365878309#L5408
  [1] https://github.com/libbpf/libbpf/pull/182/commits/78368c2eaed8b0681381fc34d6016c9b5a443be8


Thanks for your help!
