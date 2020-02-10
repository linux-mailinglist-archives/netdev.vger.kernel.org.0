Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DDF1573B6
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 12:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBJLwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 06:52:41 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36866 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgBJLwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 06:52:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id a6so3610888wme.2
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 03:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=v0jsfdDUzAOrCN8MLFPhyS4TShYPDB3NuAvx8HFlXUo=;
        b=ZfE2dAIoWQCCKQbXg/IGCuHB6GFkuDWFSAKaF5Rd8iG28tRFhT6YarG+OyIF5d/bW3
         hI4lfzfJaNWpYDLzVj8+1QYCgOkQ3TjWPVeDT/Gb0RPiiPDGeBcSkTiGjXyA2e2RtDhJ
         UuDQvKqLBc0zpechLd4ToaV5fnpnTa8KNcgmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=v0jsfdDUzAOrCN8MLFPhyS4TShYPDB3NuAvx8HFlXUo=;
        b=QEysH61Nr3wEGXWl8fRIiUD9BmEbef+tdjocj5Dg3bsEbiVLeDLwUwEbaxIsE4KZhn
         axJUUnYSeJoU8Z+Gnu5UcTGUd4IGUfIVLftfR4ueo4RzBl1XbrBLPPOEjxErie5OluG+
         dl6Gli0X65jUqVUxPRD5ui2cDUFJoSZuGUEuumB8fpHdv621O118kAVeZWS9Z7UkNCZb
         5sVwrNciBp8LDyeSWHnU5ac5tb4RAmhwTNC2pD9vfWcQUJDjzZKkEZutU5FxB1VQanEC
         SVljt26rHpGNfWcKYyh/q7F1QjIZLitV7uX15EJQUydz+Jz0jmH9SSDG6Sv6X2dEz2Tq
         jeAA==
X-Gm-Message-State: APjAAAU9d8bd8fZKC3NAUHk0uzpnu57gcBo5WYUgwsHVnbdpY+VoJuEC
        NLV/RlRbjSmnhOzH+3Hav4wrutxuXpceQeyz
X-Google-Smtp-Source: APXvYqy4WMchAPxTBVzuTtOmfOnSGwG4sYdP4mxAzL+6LjS3N56N26Hb0nKO0rvmB/8D4K4Gydyx2Q==
X-Received: by 2002:a1c:6189:: with SMTP id v131mr14964365wmb.185.1581335558374;
        Mon, 10 Feb 2020 03:52:38 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id i204sm244164wma.44.2020.02.10.03.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 03:52:37 -0800 (PST)
References: <20200206111652.694507-1-jakub@cloudflare.com> <20200206111652.694507-4-jakub@cloudflare.com> <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com> <87eev3aidz.fsf@cloudflare.com> <5e40d43715474_2a9a2abf5f7f85c025@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with a socket in it
In-reply-to: <5e40d43715474_2a9a2abf5f7f85c025@john-XPS-13-9370.notmuch>
Date:   Mon, 10 Feb 2020 11:52:36 +0000
Message-ID: <87blq6accb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 03:55 AM GMT, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Sun, Feb 09, 2020 at 03:41 AM CET, Alexei Starovoitov wrote:
>> > On Thu, Feb 6, 2020 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> w=
rote:
>> >>
>> >> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
>> >> down") introduced sleeping issues inside RCU critical sections and wh=
ile
>> >> holding a spinlock on sockmap/sockhash tear-down. There has to be at =
least
>> >> one socket in the map for the problem to surface.
>> >>
>> >> This adds a test that triggers the warnings for broken locking rules.=
 Not a
>> >> fix per se, but rather tooling to verify the accompanying fixes. Run =
on a
>> >> VM with 1 vCPU to reproduce the warnings.
>> >>
>> >> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear=
 down")
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >
>> > selftests/bpf no longer builds for me.
>> > make
>> >   BINARY   test_maps
>> >   TEST-OBJ [test_progs] sockmap_basic.test.o
>> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_bas=
ic.c:
>> > In function =E2=80=98connected_socket_v4=E2=80=99:
>> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_bas=
ic.c:20:11:
>> > error: =E2=80=98TCP_REPAIR_ON=E2=80=99 undeclared (first use in this f=
unction); did
>> > you mean =E2=80=98TCP_REPAIR=E2=80=99?
>> >    20 |  repair =3D TCP_REPAIR_ON;
>> >       |           ^~~~~~~~~~~~~
>> >       |           TCP_REPAIR
>> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_bas=
ic.c:20:11:
>> > note: each undeclared identifier is reported only once for each
>> > function it appears in
>> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_bas=
ic.c:29:11:
>> > error: =E2=80=98TCP_REPAIR_OFF_NO_WP=E2=80=99 undeclared (first use in=
 this function);
>> > did you mean =E2=80=98TCP_REPAIR_OPTIONS=E2=80=99?
>> >    29 |  repair =3D TCP_REPAIR_OFF_NO_WP;
>> >       |           ^~~~~~~~~~~~~~~~~~~~
>> >       |           TCP_REPAIR_OPTIONS
>> >
>> > Clearly /usr/include/linux/tcp.h is too old.
>> > Suggestions?
>>
>> Sorry for the inconvenience. I see that tcp.h header is missing under
>> linux/tools/include/uapi/.
>
> How about we just add the couple defines needed to sockmap_basic.c I don't
> see a need to pull in all of tcp.h just for a couple defines that wont
> change anyways.

Looking back at how this happened. test_progs.h pulls in netinet/tcp.h:

# 19 "/home/jkbs/src/linux/tools/testing/selftests/bpf/test_progs.h" 2
# 1 "/usr/include/netinet/tcp.h" 1 3 4
# 92 "/usr/include/netinet/tcp.h" 3 4

A glibc header, which gained TCP_REPAIR_* constants in 2.29 [0]:

$ git describe --contains 5cd7dbdea13eb302620491ef44837b17e9d39c5a
glibc-2.29~510

Pulling in linux/tcp.h would conflict with struct definitions in
netinet/tcp.h. So redefining the possibly missing constants, like John
suggests, is the right way out.

I'm not sure, though, how to protect against such mistakes in the
future. Any ideas?

[0] https://sourceware.org/git/?p=3Dglibc.git;a=3Dcommit;h=3D5cd7dbdea13eb3=
02620491ef44837b17e9d39c5a

>
>>
>> I have been building against my distro kernel headers, completely
>> unaware of this. This is an oversight on my side.
>>
>> Can I ask for a revert? I'm traveling today with limited ability to
>> post patches.
>
> I don't think we need a full revert.
>
>>
>> I can resubmit the test with the missing header for bpf-next once it
>> reopens.
>
> If you are traveling I'll post a patch with the defines.

Thanks, again.
