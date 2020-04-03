Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747DB19DFCC
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 22:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgDCUu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 16:50:29 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39560 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgDCUuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 16:50:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id b62so9595667qkf.6;
        Fri, 03 Apr 2020 13:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FmYPQx8YxN0VzxRVH60woHoEcaUG/mRpzY/F6fsmbBg=;
        b=EJv+/5Nw6GDaEXqkquLfhfMA1rBTppoDrc/bl8ZsoLXlaiqV6XArtEJafGx0r/wNUG
         gVPlv0zuax5cLTEdnaB31/Ir0toUsgayJeEYDmXYlv4j8eH3b74qyi4i4iUxJ4pYI1jV
         YLxrLwZE7tOBn8CY4JIdSlP2cBMIpGzzoBT+dMz7ePJwXUTkXa68FaVyNVxehsYJeiKn
         ypAvHYakv9qZQeAnNcXLg4S1fjamfzmkDIRavpcrkAp/SH3vEs98i4zTk2ZLEFSCNwAH
         EmNuUl1MB60bmWMutMrO2ilRWNZcZpRaAriAQY8ibvl0/Io05vW/6c9OlCRjbgn6hRGM
         UGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FmYPQx8YxN0VzxRVH60woHoEcaUG/mRpzY/F6fsmbBg=;
        b=Q62M5pasYY/1UVWV+Lryz/Niz9pns/pAr7xGnCAzmCikaA/5XDFCNwgjZkeeuYM/03
         mSHQVx9urzLNWqaZ8t1YcMcadQ3IsXSl1tGKFYz1G4YqNwb0V1wDmiIWF2g8f311c6Id
         lltfs0h0lIzFEXW/olfJBuL1q4AjnZDGsV/N+YFrAOGpV4IYNuiSlyBCtsI57rihqm/F
         ZUh1VpLlrlJ3Fib7s0LNIPE4p2f5gcT0SCs/fTFsbWRNlX/gUO+3DFZJezhKPc2agyO/
         6uQDbFJ7f/xfnvXc4YAJqsL8LPiXGEHT39u3brDMCxQNnkTJlRsJZmU8Ey27tE3zqvfP
         qUzw==
X-Gm-Message-State: AGi0Pua30/Iw455Ats3B4Tm2xxIyOKpZ6c/uPaUzeGCG0dtu5ZpQsImK
        5GTgp1JKn4WQ+cbSVBkmS8MfJJFRkoyxFfDUNmg=
X-Google-Smtp-Source: APiQypKUvNq9w5r6XWPwtMqzhHUDxkqXXWm97f7kOfRyDKGt5Fx1FGDnzJAAC8V3Ytk9/UDRmMJiuTTNfRxD84OaLjU=
X-Received: by 2002:a37:6411:: with SMTP id y17mr11285357qkb.437.1585947023853;
 Fri, 03 Apr 2020 13:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200329225342.16317-1-joe@wand.net.nz> <20200329225342.16317-5-joe@wand.net.nz>
 <CAEf4Bzb6Jr3qBOd0N2NsqMCXQ-19StU+TdFSmB=E+mDPeeC_Jg@mail.gmail.com> <CAOftzPj5aKspwmZ72t+ivjE72CUWObfgekpiQM+iCTya5hxgGw@mail.gmail.com>
In-Reply-To: <CAOftzPj5aKspwmZ72t+ivjE72CUWObfgekpiQM+iCTya5hxgGw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Apr 2020 13:50:12 -0700
Message-ID: <CAEf4BzaFbM+H1BRGeWTTTaBB_uwUxMadL-K7txFHJVWiGz34Tg@mail.gmail.com>
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

On Thu, Apr 2, 2020 at 8:46 AM Joe Stringer <joe@wand.net.nz> wrote:
>
> I'll take a look. Should just be iproute2 package I believe.
>

For anyone following along. iproute2, which is now a dependency of
sk_assign selftest brings in a ton of dependencies, including systemd
itself. This, beyond causing linux image problems we haven't
investigated too deeply, also increases our image almost three-fold.
See [0] for github discussion on topic.

So for now I'm going to disable sk_assign selftest permanently in
libbpf tests. Ideally sk_assign can be written to not rely on iproute2
to set things up. But until then, it won't be exercised in libbpf's CI
tests, unfortunately.

  [0] https://github.com/libbpf/libbpf/pull/144#issuecomment-608170330


> On Wed, Apr 1, 2020, 16:20 Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>
>> On Sun, Mar 29, 2020 at 3:58 PM Joe Stringer <joe@wand.net.nz> wrote:
>> >
>> > From: Lorenz Bauer <lmb@cloudflare.com>
>> >
>> > Attach a tc direct-action classifier to lo in a fresh network
>> > namespace, and rewrite all connection attempts to localhost:4321
>> > to localhost:1234 (for port tests) and connections to unreachable
>> > IPv4/IPv6 IPs to the local socket (for address tests). Includes
>> > implementations for both TCP and UDP.
>> >
>> > Keep in mind that both client to server and server to client traffic
>> > passes the classifier.
>> >
>> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>> > Co-authored-by: Joe Stringer <joe@wand.net.nz>
>> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
>> > Acked-by: Martin KaFai Lau <kafai@fb.com>
>> > ---
>> > v5: No change
>> > v4: Add acks
>> > v3: Add tests for UDP socket assign
>> >     Fix switching back to original netns after test
>> >     Avoid using signals to timeout connections
>> >     Refactor to iterate through test cases
>> > v2: Rebase onto test_progs infrastructure
>> > v1: Initial commit
>> > ---
>>
>> Hey Joe!
>>
>> When syncing libbpf to Github, this selftest is now failing with the
>> follow errors:
>>
>> tc: command line is not complete, try "help"
>> configure_stack:FAIL:46
>> configure_stack: Interrupted system call
>> #49 sk_assign:FAIL
>>
>> We are probably missing some packages or something like that. Could
>> you please help figuring out how we need to adjust libbpf Travis CI
>> environment to accomodate this? Thanks!
>> You can find one of the failed runs at [0]
>>
>>   [0] https://travis-ci.com/github/anakryiko/libbpf/jobs/311759005
