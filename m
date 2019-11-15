Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDAFFE761
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKOWGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:06:20 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35800 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfKOWGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 17:06:20 -0500
Received: by mail-ed1-f65.google.com with SMTP id r16so8697485edq.2;
        Fri, 15 Nov 2019 14:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8xlYsY3/EuMU6SUYikqpTC+YTJRQ0QCCVMCv6b65D9I=;
        b=YhhpZZoT6t9vthlXViqcx1vBKmyfbT04uMdF2gNe9SlbwnJaPK1aP7VVYhR2rkIbwE
         5l5RsyTWaB4Cvg+M3/etYQ9e+lHXpLEGLBIr8MgaFTrCJuu1WxdbxB8Yg4gKUi+o5G6z
         fc+y+KgdqOCG4dGgJ8JkCP+lfhnB7sRntalLCiVydM3kiCtTK5hY2908UPmbFantTIZa
         1aVF1T5tW/FJ4DHCUQ+EsQGRPZ8OM87/h8lii9HgsM3cOmtYeH2TwC6VpSp8tPi+7s5M
         Qs689P5Y98UJrV4KRKoI2V0CHWdzaONbgpLXtpJxFFlNCiUWiiveX536LY3L44uLRZfp
         IXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8xlYsY3/EuMU6SUYikqpTC+YTJRQ0QCCVMCv6b65D9I=;
        b=sV/M+CsGzr9Zt9HBXVkfVgoP0c5vZYEZp62YNRtMBZJtoErYIHPN4roGXWjA2VFemW
         P8ptoZ201/1n/FYMGtO1MrnBiaeWGxr5APjbZtw8/hFKBJJajzPlBZ2N8iG+2li5Jtzd
         2p65bmNsb5DQmpwn/bLcUfDb6AJdHUqS7nsJfiCJdCoBn0XFWPtk4qlpQC0MjyXFGKVi
         J2SgKxzMJZoHi2KDyq2PVP6/wY7YE1Su7xflDi9T1qdd8JJVwShVVxyl5kjHxIlQg5kp
         XGlu8QyGWdGhXW6YBPJ/TI4JEAmqVP9rO3KfnlfzKUw6jqSv0H6cn9KRGMFF3zXMjWr5
         YqVQ==
X-Gm-Message-State: APjAAAUV/DApo0Kt/IE+K8MLUEDvMxkXWOYOJNStQEsx63ww4/7YJpoh
        D98p2pwcWPLSfP04t+UqSlzoEmoyr8z6GG6npL6LGw==
X-Google-Smtp-Source: APXvYqxppfY32SR1B7m/pA6oGeOY1kHut49m0usVOorsVN7taDlLJGsg4aFjxP1C9goAJZyRgw+gO3dN83bgjj8JAU0=
X-Received: by 2002:a17:907:2122:: with SMTP id qo2mr4328124ejb.12.1573855578167;
 Fri, 15 Nov 2019 14:06:18 -0800 (PST)
MIME-Version: 1.0
References: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
 <dc889f46-bc26-df21-bf24-906a6ccf7a12@iogearbox.net>
In-Reply-To: <dc889f46-bc26-df21-bf24-906a6ccf7a12@iogearbox.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 15 Nov 2019 17:05:42 -0500
Message-ID: <CAF=yD-K53UaChX7S6YzNaCTArYf3RVWGPdskeEd5bEaBfuaonQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix test_tc_tunnel hanging
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Benc <jbenc@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 5:02 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/15/19 1:43 PM, Jiri Benc wrote:
> > When run_kselftests.sh is run, it hangs after test_tc_tunnel.sh. The reason
> > is test_tc_tunnel.sh ensures the server ('nc -l') is run all the time,
> > starting it again every time it is expected to terminate. The exception is
> > the final client_connect: the server is not started anymore, which ensures
> > no process is kept running after the test is finished.
> >
> > For a sit test, though, the script is terminated prematurely without the
> > final client_connect and the 'nc' process keeps running. This in turn causes
> > the run_one function in kselftest/runner.sh to hang forever, waiting for the
> > runaway process to finish.
> >
> > Ensure a remaining server is terminated on cleanup.
> >
> > Fixes: f6ad6accaa9d ("selftests/bpf: expand test_tc_tunnel with SIT encap")
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Jiri Benc <jbenc@redhat.com>
>
> Looks like your Fixes tag is wrong:
>
> [...]
> Applying: selftests: bpf: Fix test_tc_tunnel hanging
> Switched to branch 'master'
> Your branch is up to date with 'origin/master'.
> Updating 808c9f7ebfff..e2090d0451c5
> Fast-forward
>   tools/testing/selftests/bpf/test_tc_tunnel.sh | 5 +++++
>   1 file changed, 5 insertions(+)
> Deleted branch mbox (was e2090d0451c5).
> Commit: e2090d0451c5 ("selftests: bpf: Fix test_tc_tunnel hanging")
>         Fixes tag: Fixes: f6ad6accaa9d ("selftests/bpf: expand test_tc_tunnel with SIT encap")
>         Has these problem(s):
>                 - Target SHA1 does not exist
> [...]

Ah, a typo. This is the SHA1 in my tree, note the aa9d --> aa99d

$ git fetch davem-net-next
$ git log -1 --oneline -- tools/testing/selftests/bpf/test_tc_tunnel.sh
f6ad6accaa99d selftests/bpf: expand test_tc_tunnel with SIT encap
