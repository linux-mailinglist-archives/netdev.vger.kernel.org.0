Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432DC19B8E0
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 01:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733286AbgDAXTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 19:19:54 -0400
Received: from mail-qv1-f41.google.com ([209.85.219.41]:42776 "EHLO
        mail-qv1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgDAXTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 19:19:53 -0400
Received: by mail-qv1-f41.google.com with SMTP id ca9so731633qvb.9;
        Wed, 01 Apr 2020 16:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2URR2g44lQdCwfn/Tkh9j1lhueN+DBYJikDKN7H5608=;
        b=jZpoHJfuqEfG50YWYIlPGCUNNQ5rittqBuoVGQwBwdOc0NMOvwQes4JVF6JbUWWoUo
         m0OeCTiZ+5KKhBN71gDlRQZHu+UEzL06Rm3ud3XYWYzdrxrGEwSH72T1R2W/Vp9O+F8s
         6PHcvvAojAUhodlzhZdnMtIjWttWb79KWUQfMb3yUWElb3R9wiIT96VWjZ1Fr/iEQx/9
         t9RYArIO6+sNNOerr8NJ7XEkynQBJqRMNc2i3dncAoTN37IvpWeihyamvuV3QQVuDC6t
         k+fVfBz8w/zV4WBTCxwoevgA5choxEt2waFn0DAIQlyATuYKFYMt26UwDAD3PDT2HCzl
         JnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2URR2g44lQdCwfn/Tkh9j1lhueN+DBYJikDKN7H5608=;
        b=mXBpWoCCtTkEx0iK/1mWpJwYmzA6EilkBrUmDzCsskdF83NAy4t68VtGYJB4HNGZ0a
         np3n3atTgkkmUjHRibUzOxVn/xJGVad39L2mrpJ61K8TAa0QmeiDAxAm6nPpFh65MNRi
         rEUlNNQCEs45iRpEenZPImjLs7FXrYRsDrxJlJUuWRuKkXoI7Z4GzkYaF87uFe9GmHas
         01VXqJImMHe1V0qAlysuHv7jLk5+306p0QgUZ1T41rB3Z0DlyLuZPTFDDa6uYbSXBLxa
         b8760m39jXeD7jyuYpkRqLaKhP+2CUo8OD3YPi6MBXdYJnLlFWIDCPgsJFHh9Ho+xxQa
         SfSQ==
X-Gm-Message-State: AGi0PuY/uxGWfXyxl72/rKzi22yXGP42oTXFDLWfZv4rKfn5JyQWHNKn
        R388hv64FttrLlwSeGdz/ppzXJfz1/8JIPqgmRI=
X-Google-Smtp-Source: APiQypKp5ScZYtVmlvOUOH8jsenqRkI1KwDczEFJuV3oe7hocEQ64EEStMNYvhHmrySfkACgxvPkDz/C1lEzd5FYGGI=
X-Received: by 2002:a05:6214:14b1:: with SMTP id bo17mr568247qvb.196.1585783192726;
 Wed, 01 Apr 2020 16:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200329225342.16317-1-joe@wand.net.nz> <20200329225342.16317-5-joe@wand.net.nz>
In-Reply-To: <20200329225342.16317-5-joe@wand.net.nz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Apr 2020 16:19:41 -0700
Message-ID: <CAEf4Bzb6Jr3qBOd0N2NsqMCXQ-19StU+TdFSmB=E+mDPeeC_Jg@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 4/5] selftests: bpf: add test for sk_assign
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

On Sun, Mar 29, 2020 at 3:58 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> From: Lorenz Bauer <lmb@cloudflare.com>
>
> Attach a tc direct-action classifier to lo in a fresh network
> namespace, and rewrite all connection attempts to localhost:4321
> to localhost:1234 (for port tests) and connections to unreachable
> IPv4/IPv6 IPs to the local socket (for address tests). Includes
> implementations for both TCP and UDP.
>
> Keep in mind that both client to server and server to client traffic
> passes the classifier.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Co-authored-by: Joe Stringer <joe@wand.net.nz>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
> v5: No change
> v4: Add acks
> v3: Add tests for UDP socket assign
>     Fix switching back to original netns after test
>     Avoid using signals to timeout connections
>     Refactor to iterate through test cases
> v2: Rebase onto test_progs infrastructure
> v1: Initial commit
> ---

Hey Joe!

When syncing libbpf to Github, this selftest is now failing with the
follow errors:

tc: command line is not complete, try "help"
configure_stack:FAIL:46
configure_stack: Interrupted system call
#49 sk_assign:FAIL

We are probably missing some packages or something like that. Could
you please help figuring out how we need to adjust libbpf Travis CI
environment to accomodate this? Thanks!
You can find one of the failed runs at [0]

  [0] https://travis-ci.com/github/anakryiko/libbpf/jobs/311759005
