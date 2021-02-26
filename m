Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835463268FF
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBZUzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 15:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhBZUzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 15:55:54 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A7FC06174A;
        Fri, 26 Feb 2021 12:55:13 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a17so15346482lfb.1;
        Fri, 26 Feb 2021 12:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YBCcayDorilbuVZ5LKt+V42Rkj40O3IYrjxA5yym7pw=;
        b=N+NqO/RiymX19xEQY7GLckgAjk37EVpnQf0k3/gfiv2ezIDm2Ah2t3V26Ftbn8mp8N
         qyMk1Rqbnf8sRcuPAWVGe8qEkH0085wU/sm0RO5gghQ7q1eVCK6RpyCdvTRo5o26wh2b
         MEmpbUhTqtq1Q0uPzYoyJVwC5y1uedhZ4tdqn/SAIZ76Gu3IbHR7hHwN0YZcL94grV9c
         QT9Xk8rJxHme9LUdspFM+jAJCmiMCIrDoMiwsKPKaFn1SNraxfMNmHYcxDeDwvzvPBOU
         wNV+r/rNhpHzfVeF9NOaONZtnIcOcjKivSjsQyIUAlYdcpTNp2XdE5qL0ElkA5CSRh6p
         7Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YBCcayDorilbuVZ5LKt+V42Rkj40O3IYrjxA5yym7pw=;
        b=HRnXSU6fsy4KpN/a6MXeG3OG8tUG8Fv4MKWvvC+CJgpaLIqY36sEN3gyPoq6cQjzV1
         o4BOrkv6xnsIyTY4qqjUIQvqG1TEpD5/wOWGjVxHjKwNrHj0OitjW6q7+1uAuem5nDRp
         qI1Q2xL8k+5PXlQzL/VwPPXCZkuHLaO/DnpKzQJM7jpPxzqlan0aNy5uLtfpYi58ctLq
         hBMjZZSWU9wNgakw0l8NBVT2HE2WYmT80sFxWLGl4Xv3nT1LIyByCVi2oYdga24an5Ph
         9ZkKOJjGVbSCCjQFzW+xABXjARpoUlsWReIqCI9m6vn+eYXvQYUyzh/3zxK3PmSoedGf
         +3/Q==
X-Gm-Message-State: AOAM530qLVtNVBgspl7ivKn7GdAEJx0rvbsYh4GPDEgkCc7cn0OAU2dA
        aNykYqk9XzwnhVO44vmRnNYYirsV9ll+1Mxh3ro=
X-Google-Smtp-Source: ABdhPJy3470LdGOl0mBFJ89ovgeeAb0dhcj1z5lDy34rqbTeDyS4SRFcQ6mGWPIrCFUJbn4QjteIp3lqytpFzkW993s=
X-Received: by 2002:ac2:5486:: with SMTP id t6mr2968225lfk.75.1614372912300;
 Fri, 26 Feb 2021 12:55:12 -0800 (PST)
MIME-Version: 1.0
References: <20210226103103.131210-1-lmb@cloudflare.com>
In-Reply-To: <20210226103103.131210-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Feb 2021 12:55:01 -0800
Message-ID: <CAADnVQJi_==XB8=PdqfOa24HfSAcyaasnbZCzxvbcOtCWaP7EQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] PROG_TEST_RUN support for sk_lookup programs
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 2:31 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> We don't have PROG_TEST_RUN support for sk_lookup programs at the
> moment. So far this hasn't been a problem, since we can run our
> tests in a separate network namespace. For benchmarking it's nice
> to have PROG_TEST_RUN, so I've gone and implemented it.
>
> Based on discussion on the v1 I've dropped support for testing multiple
> programs at once.
>
> Changes since v1:
> - Add sparse annotations to the t_* functions
> - Add appropriate type casts in bpf_prog_test_run_sk_lookup
> - Drop running multiple programs

Looks good.
I applied it, but then reverted since test_verifier needs to be adjusted:
./test_verifier 349
#349/p valid 1,2,4,8-byte reads from bpf_sk_lookup FAIL: Unexpected
bpf_prog_test_run error (Invalid argument) (run 1/1)

That's the only test that has ACCEPT for sk_lookup prog type
and the framework now is trying to run it.
Pls respin.
