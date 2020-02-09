Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BB3156AFC
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 16:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBIP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 10:29:50 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45196 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbgBIP3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 10:29:50 -0500
Received: by mail-lj1-f195.google.com with SMTP id f25so4255245ljg.12
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 07:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GeG1KWLb3anDrvTa9Q1tSCi6BsVsKZhJEV3LxmD8BUM=;
        b=BEZFSL2kjB0jykfKIYokzx8baCX9jKke3FqJsdl0OqF3I8O83CH/+Wd+SVCTB9KbDr
         KYsyXzw9piPUtm8HHVTMupikAHF6LRF57EJFdM0fLRqiQor3xqsSyUr5olkt8yF2kJWe
         RQiG5F8ibpgOLjiPUmPJ8EWLptQV1W+sxNw6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=GeG1KWLb3anDrvTa9Q1tSCi6BsVsKZhJEV3LxmD8BUM=;
        b=LsxoOGgHjBl4L19+2uuiNxw5iGdVaA8BtOYf29sWOcLzk8ecTf2n8dTrU4rcjVOlIn
         IdNvUjHpyep/wRXTM2KmJOMZ1hSFOQtqjzW6w1gXCYfh0EWdaubA2AnD4+AFyTjbNfBX
         TunAZbtZDuLUbfs2wOlrRdnUuxwTAT0uGoLxE6IIL6h/U9ufgGCtzTOl+RVlwFslT9Q0
         POf5eqKDpyzbGHQ0TR4mV2uZWpbTrM5cUiV4OgNhfPCLAYo/tD/oZdYG0No+VG1R7x4q
         euKTFkK/Yx/7iyI16xQnqVUgsfs3bbViQbBJMYJF1T9P+FAG8JNs0OiLeetom7y0ehhI
         9QVQ==
X-Gm-Message-State: APjAAAUsk3osHSAy+GK7rm/QyrbQAbT58G4UobNjjW1qBdiPvocTkuA/
        Nrrpvmo8BTcrAB79cwnv+vx8OQ==
X-Google-Smtp-Source: APXvYqyyhc5Hq9Up5D9WtT4+gync24YvGT2lp640zi8JRF9ONhPTeZnVEHQhfxmwCJyumbd3WfALXw==
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr5419310lji.274.1581262188646;
        Sun, 09 Feb 2020 07:29:48 -0800 (PST)
Received: from cloudflare.com (user-5-173-219-131.play-internet.pl. [5.173.219.131])
        by smtp.gmail.com with ESMTPSA id z13sm4859546ljh.21.2020.02.09.07.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 07:29:47 -0800 (PST)
References: <20200206111652.694507-1-jakub@cloudflare.com> <20200206111652.694507-4-jakub@cloudflare.com> <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with a socket in it
In-reply-to: <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
Date:   Sun, 09 Feb 2020 16:29:44 +0100
Message-ID: <87eev3aidz.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 09, 2020 at 03:41 AM CET, Alexei Starovoitov wrote:
> On Thu, Feb 6, 2020 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrot=
e:
>>
>> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
>> down") introduced sleeping issues inside RCU critical sections and while
>> holding a spinlock on sockmap/sockhash tear-down. There has to be at lea=
st
>> one socket in the map for the problem to surface.
>>
>> This adds a test that triggers the warnings for broken locking rules. No=
t a
>> fix per se, but rather tooling to verify the accompanying fixes. Run on a
>> VM with 1 vCPU to reproduce the warnings.
>>
>> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear do=
wn")
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>
> selftests/bpf no longer builds for me.
> make
>   BINARY   test_maps
>   TEST-OBJ [test_progs] sockmap_basic.test.o
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.=
c:
> In function =E2=80=98connected_socket_v4=E2=80=99:
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.=
c:20:11:
> error: =E2=80=98TCP_REPAIR_ON=E2=80=99 undeclared (first use in this func=
tion); did
> you mean =E2=80=98TCP_REPAIR=E2=80=99?
>    20 |  repair =3D TCP_REPAIR_ON;
>       |           ^~~~~~~~~~~~~
>       |           TCP_REPAIR
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.=
c:20:11:
> note: each undeclared identifier is reported only once for each
> function it appears in
> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.=
c:29:11:
> error: =E2=80=98TCP_REPAIR_OFF_NO_WP=E2=80=99 undeclared (first use in th=
is function);
> did you mean =E2=80=98TCP_REPAIR_OPTIONS=E2=80=99?
>    29 |  repair =3D TCP_REPAIR_OFF_NO_WP;
>       |           ^~~~~~~~~~~~~~~~~~~~
>       |           TCP_REPAIR_OPTIONS
>
> Clearly /usr/include/linux/tcp.h is too old.
> Suggestions?

Sorry for the inconvenience. I see that tcp.h header is missing under
linux/tools/include/uapi/.

I have been building against my distro kernel headers, completely
unaware of this. This is an oversight on my side.

Can I ask for a revert? I'm traveling today with limited ability to
post patches.

I can resubmit the test with the missing header for bpf-next once it
reopens.
