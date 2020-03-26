Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0419358D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 03:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgCZCEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 22:04:46 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40398 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgCZCEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 22:04:46 -0400
Received: by mail-qt1-f196.google.com with SMTP id c9so4079484qtw.7;
        Wed, 25 Mar 2020 19:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N5bkQtuu9iQlJDxT62St8TPUscxkVcdWASODyg/UT1M=;
        b=O1+xgRCefbQlRiuZuIjkTmB/R+u5wp5fwmODgpsZz56FU9vaePzTpDzQaSX3N2OEmE
         Oy4l3hCr3va63/2e9oyZ+qOBHWHXDVYXDNzzxGZnOHwOuLr2HZ1UFXoteRs0UsrfHV1+
         L0gZ2iljcoomb2jJK7/iCXcEBkaYn5J0cFybHAobUOjoxMRX8MOsPyXQ9wr9pdUUTfRK
         yYa9IfmRhnVoexVTovWx0P61iJgGmltzSAY2UwNFUNN72+f5SnipvP1MwbGgM9uisOz8
         WwjbRYW5CRCr2B6klKoE5tNHdkscbHFAOcKfNGzM5h2R8XuAyDxSttnCKHz/RyEV5ej1
         +i1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N5bkQtuu9iQlJDxT62St8TPUscxkVcdWASODyg/UT1M=;
        b=hTpIole65leilg1KaNxPADG4PNBaO3BSVHnAytr4u0vQWSIZFVTvRYCMT3CY+yW091
         QIg4T0tnrd2eLcyb2cHCIoRJ/+Vr15Kc8uvo446g+LcaatELStPhS0Fn9cD+zsrdwBPg
         mtNzuO8la98Q3Bx2NtDG+LRCapU52QNEoXoljl1J02HthYHeQTEIYdwWqHY+DOEtfx5g
         eKFaGH12EaLIzZErOZ9POyk1g2ZbR/hGZV1gXzzxj3HACOKeJ0EKsxOEbpPP7a12htmB
         7tg3/mJOqgSeAuvTDRu3Gkpp7xQo0kn/R05hsENEd0nY+PWK4nlg93+bsnWgZ9mdnYEd
         pqyg==
X-Gm-Message-State: ANhLgQ22mdJXsJdzI6fzuji/Yw12GAuYDMVkyGWAm6w7VF63RWWjJ7N8
        Wodbj554hM8gB9fjI2CUmDq7Mo3eBDDFsEGf6Ic=
X-Google-Smtp-Source: ADFU+vuk7zcNEhOvNiM0X5r+laX6IFK+yyCCAvMF6t4L0Qg0s6LBWnyDc+A6yJObwePEfp9kGgaz4+j5leQc9BaUx3U=
X-Received: by 2002:ac8:7cb0:: with SMTP id z16mr5878580qtv.59.1585188285039;
 Wed, 25 Mar 2020 19:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
In-Reply-To: <20200325055745.10710-6-joe@wand.net.nz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 25 Mar 2020 19:04:34 -0700
Message-ID: <CAEf4BzbxWtC9H79ij+hzWU6VDHtEVWy5_FgGh6-X1SZhtXkz3g@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:58 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> From: Lorenz Bauer <lmb@cloudflare.com>
>
> Attach a tc direct-action classifier to lo in a fresh network
> namespace, and rewrite all connection attempts to localhost:4321
> to localhost:1234 (for port tests) and connections to unreachable
> IPv4/IPv6 IPs to the local socket (for address tests).
>
> Keep in mind that both client to server and server to client traffic
> passes the classifier.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Co-authored-by: Joe Stringer <joe@wand.net.nz>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---

Can you please check that you test fails (instead of getting stuck)
when there is something wrong with network. We went through this
exercise with tcp_rtt and sockmap_listen, where a bunch of stuff was
blocking. This works fine when everything works, but horribly breaks
when something is not working. Given this is part of test_progs, let's
please make sure we don't deadlock anywhere.

> v2: Rebase onto test_progs infrastructure
> v1: Initial commit
> ---
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
>  .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
>  3 files changed, 372 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
>

[...]
