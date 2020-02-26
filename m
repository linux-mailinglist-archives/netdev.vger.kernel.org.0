Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3055016F685
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 05:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgBZEf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 23:35:29 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39883 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgBZEf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 23:35:28 -0500
Received: by mail-qt1-f195.google.com with SMTP id p34so1359480qtb.6;
        Tue, 25 Feb 2020 20:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vxQWvF+rKCRU7B1Gx1aCuyYmxP3vKtv1siF7Z6n6r+A=;
        b=OjDy8mWFpPZTqwYMgSj5y8Y1ROEHZn86RsmCYuCiEZVwNom0VHszgbh3QfEDkjZqkx
         81uJqTX/4YAN5Hnu+zNHdN9TZhnDMkvncyPJfBKNhVmy8SC3fiIZdAHTVhEQJpqZ18Wa
         cf8PJTW9M6gthZNw3Qsf+pNPvu2WimzaZVUBEGttIZGx/AF3hOxikq645OJXTAUF04ae
         nT7jq5uhD5ulz6x+hMbz+CEfqJnteH3/O1LYw4IPQpM5UWmVRawGEK/z9LwzAzheD8Z/
         w35r6KNrha5qlIVjBupr4GJCc0DIC2GN/jwPGaaw+MS3FRWbLzfxqE1ZRb8KsDRr0nqI
         QP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vxQWvF+rKCRU7B1Gx1aCuyYmxP3vKtv1siF7Z6n6r+A=;
        b=TNtFGy5Z18ks/O552uTHF7lHJJomQ2juc0EnAya1Nlxdu/DVIVVHIHxRWEaLfJLyN9
         9kT/NPsC3O/kRcgTzDTXjDWcnrRvC5ZLBxlHqPjaNg/3TtFJ6Lmm9Rk5VlBTl9CjziDP
         otk1hZrSgK9aOIanR40BwsRQjFwQ9VHmrVgqGga0kTMmIqpQvf5GLHNbBSPSMs2SYckZ
         Q+0QbSbwNSfw/cMo6vPdZzPpScGxjilgqMhQy66X2rGpQfGEA9yeBMGLR8Ej+IKq4ndB
         1rPmuNN0NNS+9ntAuVWQyb1Ct9IYgmvTLQTRm5XkjchEytAX97B9xT2jh+mFZkOVS+4E
         EPTg==
X-Gm-Message-State: APjAAAUrDPhKSMxhacBIzIm8jvQg8IBT54eqrIHYmS0Pcy2ToCgoCbMi
        u22WH5cV+5PMv1pCQGQQObsKVj3wcDGClF7QATY=
X-Google-Smtp-Source: APXvYqz2kovWkenf80ECWnzzux+R+t9j6aeOQ7yftyoeChW4O/28JLTlxKc1cG5OWrjb7UyNiCb7GnS+i29+ScPrfK0=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr2786956qtl.171.1582691727421;
 Tue, 25 Feb 2020 20:35:27 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com> <20200225044538.61889-4-forrest0579@gmail.com>
 <CAEf4Bza5k92bxYH=c1DP_rcugF6z3NLos7aPS7DPoi9-3B_JrQ@mail.gmail.com>
 <CAH+Qyb+rQeebkb1TtLuNHPLmf-VRLqj1yvsHXtaqfzHKMA4azQ@mail.gmail.com>
 <CAEf4BzbM3ey=vUobB=H+j9bzAT+H1TgsNFp88MCB3BkOYQ+0Yg@mail.gmail.com> <CAH+Qyb+-Q7OSrobdojRiep5cmnzwfMnGJ2HPfjvEPiTPtse+LQ@mail.gmail.com>
In-Reply-To: <CAH+Qyb+-Q7OSrobdojRiep5cmnzwfMnGJ2HPfjvEPiTPtse+LQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Feb 2020 20:35:16 -0800
Message-ID: <CAEf4BzabauCm6Z+=EM46=xkAtGxPdLs3H7PhDnJNtrcH-4-iGQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/3] selftests/bpf: add selftest for
 get_netns_id helper
To:     Forrest Chen <forrest0579@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>, Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 5:20 PM Forrest Chen <forrest0579@gmail.com> wrote:
>
> Got it. So I think we could first merge this and refactor the tcpbpf test=
(or maybe also some other tests) in another thread, is that ok with you?

Sure, as long as there is a follow up.

Also, please make sure to reply inline.

>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2020=E5=B9=B42=E6=9C=
=8826=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=881:13=E5=86=99=E9=81=93=
=EF=BC=9A
>>
>> On Mon, Feb 24, 2020 at 11:20 PM Forrest Chen <forrest0579@gmail.com> wr=
ote:
>> >
>> > > It would be nice if this selftests becomes part of test_progs.
>> >
>> > You mean the whole tests of tcpbpf or only the changes I made in this =
test?
>> > If you mean the whole tests of tcpbpf, I think we could fire another t=
hread
>> > to do this?
>>
>> Yeah, I meant entire tcpbpf test.
>>
>> >
>> > Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2020=E5=B9=B42=E6=
=9C=8825=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:13=E5=86=99=E9=81=
=93=EF=BC=9A
>> >>
>> >> On Mon, Feb 24, 2020 at 8:47 PM Lingpeng Chen <forrest0579@gmail.com>=
 wrote:
>> >> >
>> >> > adding selftest for new bpf helper function get_netns_id
>> >> >
>> >> > Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
>> >> > Acked-by: Song Liu <songliubraving@fb.com>
>> >> > ---
>> >>
>> >> It would be nice if this selftests becomes part of test_progs. That
>> >> way it would be exercised regularly, both by committers, as well as b=
y
>> >> automated CI in libbpf's Github repo. Using global variables and BPF
>> >> skeleton would also clean up both BPF and user-space code.
>> >>
>> >> It seems like this test runs Python script for server, but doesn't
>> >> seem like that server is doing anything complicated, so writing that
>> >> in C shouldn't be a problem as well. Thoughts?
>> >>
>> >> >  .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
>> >> >  .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 +++++++++++++++=
+++-
>> >> >  2 files changed, 56 insertions(+), 1 deletion(-)
>> >> >

[...]
