Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6751C6073
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEESuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgEESuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:50:25 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CC2C061A0F;
        Tue,  5 May 2020 11:50:25 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id k81so3461443qke.5;
        Tue, 05 May 2020 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49JmiC7bTnH0NKVYLaRO6zscoFFAOZpuEJ5KQfVZ5tY=;
        b=EzjqxmbnI+youBr6wa1kjihSCJfbqSGVf7qcOIR3qkMC5kCinGbbf4CTLDRRoEGJWM
         DqDuIqcxlH/IIdLBsHa0+shMP0IGqQnFnVRJFgp0Si4KKDvEmr2v2HE55qpDBDpN8r1U
         n9hN0/A2ggKKd4Wu9nlSAq3rpvebYITxtmv15smNTK7Y1xuGCGcohg5OGl49zik/i8KJ
         Hb6kZr2+sioM16CycTO0AiEQDxVuE+OT/sJH5aD9qtF3ewPhGQY6GX7rM4R7gphc2quj
         svEOrwnFKls5UZ+xxQiOvqyGC280Isx3ggypK0gLyOfLHpViZCt3XokTYzSuTYUIPnxz
         IWGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49JmiC7bTnH0NKVYLaRO6zscoFFAOZpuEJ5KQfVZ5tY=;
        b=Q+E/zpIIWs+0n+N5YscEYBe5qjbnN657RPICfIx4H31wDRJw4y/ITQAMgQzkfjYsgz
         JhNnZYTaDnHWIo9RrkzoUu0F/Gr1cL1MbiNilBo3k6Y19sx5LSO3zjFtktsB2Qq6JiCZ
         oamN3OEo3lkPS0BeHiMasNnj3nZPt3xZbmJbEAu1Jlf4vM603ARUWLyTCobQu34S7ttu
         oY3/kQeDJ0Y2mqyu1mrEvHzs5eoStZ4yqnyN6LXnTlqAoiC5H6akx8TFz9WTd30VMzju
         I6eG+Es/RD4MyrgbPcnYgBXyFtZDOKkttPBsj6d8U5EmA7jS3zFkD+gch5TUmDYmimz+
         oUew==
X-Gm-Message-State: AGi0PuartWU84NUaIJ7bXYiFRlZ1UrOhR4pH/+Tvxx/OX96B3l5PM9pQ
        Ws970uqOpCa/pFRCbtYg5cC2Rm0qxjKppkeVttMX2A==
X-Google-Smtp-Source: APiQypJppkU4hBsm0HIVxnTOGDMQuHW1RM/nYfxPTvgKvDc9NVGnaQJGkj7TnJm7zy25BZMqGrE6CBQQraMMbAVzF1w=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr5357145qkm.449.1588704624315;
 Tue, 05 May 2020 11:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com> <20200504173430.6629-2-sdf@google.com>
 <CAEf4BzahmBZmffPq2xL8ca0TpQPNHZtdOnduhHoA=Ua7oy99Ew@mail.gmail.com> <20200505160854.GD241848@google.com>
In-Reply-To: <20200505160854.GD241848@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 11:50:13 -0700
Message-ID: <CAEf4Bzamt9PNeQT451c+caYD3PHY_=AT0r=SLMbTcOWZoRAt2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] selftests/bpf: generalize helpers to control
 backround listener
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 9:08 AM <sdf@google.com> wrote:
>
> On 05/04, Andrii Nakryiko wrote:
> > On Mon, May 4, 2020 at 10:37 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Move the following routines that let us start a background listener
> > > thread and connect to a server by fd to the test_prog:
> > > * start_server_thread - start background INADDR_ANY thread
> > > * stop_server_thread - stop the thread
> > > * connect_to_fd - connect to the server identified by fd
> > >
> > > These will be used in the next commit.
> > >
> > > Also, extend these helpers to support AF_INET6 and accept the family
> > > as an argument.
> > >
> > > Cc: Andrey Ignatov <rdna@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/tcp_rtt.c        | 115 +--------------
> > >  tools/testing/selftests/bpf/test_progs.c      | 138 ++++++++++++++++++
> > >  tools/testing/selftests/bpf/test_progs.h      |   3 +
> > >  3 files changed, 144 insertions(+), 112 deletions(-)
>
> > Can this functionality be moved into a separate file, similar to
> > cgroup_helpers.{c.h}? This doesn't seem like helper routines needed
> > for most tests, so it doesn't make sense to me to keep piling
> > everything into test_progs.{c,h}.
> test_progs_helpers.{c,h}? And maybe move existing helpers like
> bpf_find_map, spin_lock_thread, etc in there?

bpf_find_map is generic enough, I'd leave it in test_progs.c, at least
for now. spin_lock_thread is used in just two files, I'd just put it
(copy/pasted) in those two and remove it from test_progs. But that can
be done separately.

As for these new functions, they are network-specific, so I'd just add
a new network_helpers.c or something along those lines.




>
> Or do you think that these networking helpers should be completely
> independent
> from test_progs?
