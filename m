Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BFF3B678D
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhF1RXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhF1RXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:23:04 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD2C061766
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 10:20:38 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id l26so10468965vsm.9
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 10:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WCfkgePdAXqOIxhYMCh7+nsE9UVEyCQyOezwXfK4jGU=;
        b=cnlUh8EZePV1fNVsbGOiqKW75J+KfI5/gEcMyctU0EmsvIcxkeYGl3T6oMfbhC+1zh
         sVJFonJ8gW+si52FHTLci4zSkwVuZnHN4Sp9B5z3h9nRXrHoa6Hd1S08ETGbo3hJwBB5
         da0vEcvoePuMHcOjRMvRfqoUSrevbVZjKbW39sNZA7o9JdW2Y19sA9F1kTxE+kH1WGOW
         2nuTex3S4aaKH0BljzW5nyVqfhWdJb+GiHYvx451BhzROMAlFaVKxzcZRQcH8vCfzyNo
         bVi+9DoiqCZqceYFGhQFY2D5PQT4456zvGJr33FA4JqNnkc+tljZ7EVQCsXZ5zmTrmHP
         nZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WCfkgePdAXqOIxhYMCh7+nsE9UVEyCQyOezwXfK4jGU=;
        b=Pv984lVd8udfi7c1pXjn3Z+vHD83A68E7Z8ZHrl67ugOiJlc8eXR7axTHTJ9IfNLVe
         b2CEbkIBJlc+UeKqBNA3r9Ywi/Aohp0Zu/PCg/VyRzcr2MQIbkTK1TvJDkIy7+fDQfBm
         ysSIMpv24kJcAVv5ZqtxqiDQiAiiJB9TD90WJh4m7E76T1kJ3tsJZTEFZqDxNCIvCVQz
         jfFi1I7/hZQXld2PL4VmoETDpCq1u4muoTPHK6bftyJG6O6VKilun4NuAz4jJbSZ2WA2
         kh4Gg4hc47KTchoe4p3Jrwme7CquOl9Tje+afWvC2oYkT3vxPyOEMnDUHPgd1dqSW/2w
         H8sg==
X-Gm-Message-State: AOAM5315LUhxukHOmXfpfq+d7ARwtEaE8DYgZqKyfS0JZhvIpviyvESq
        /2ge275scPShvQE1MxsY7BYz9ln/hXgYx2qJvQeQ9Q==
X-Google-Smtp-Source: ABdhPJxiKGOBlX6w0xH2HLn2GlsqI0HtgVj7rs+38+B/6UkhcME+/mVuUGZ1XtNhmjxXMIik+jcx5oyKhKQDcSRdi1o=
X-Received: by 2002:a67:7707:: with SMTP id s7mr20202441vsc.16.1624900837435;
 Mon, 28 Jun 2021 10:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com> <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
 <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com>
In-Reply-To: <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 28 Jun 2021 13:20:19 -0400
Message-ID: <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
To:     Phi Nguyen <phind.uet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

)

On Mon, Jun 28, 2021 at 1:15 PM Phi Nguyen <phind.uet@gmail.com> wrote:
>
> On 6/29/2021 12:24 AM, Neal Cardwell wrote:
>
> > Thanks.
> >
> > Can you also please provide a summary of the event sequence that
> > triggers the bug? Based on your Reported-by tag, I guess this is based
> > on the syzbot reproducer:
> >
> >   https://groups.google.com/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPCAAJ
> >
> > but perhaps you can give a summary of the event sequence that causes
> > the bug? Is it that the call:
> >
> > setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
> > &(0x7f0000000000)='cdg\x00', 0x4)
> >
> > initializes the CC and happens before the connection is established,
> > and then when the connection is established, the line that sets:
> >    icsk->icsk_ca_initialized = 0;
> > is incorrect, causing the CC to be initialized again without first
> > calling the cleanup code that deallocates the CDG-allocated memory?
> >
> > thanks,
> > neal
> >
>
> Hi Neal,
>
> The gdb stack trace that lead to init_transfer_input() is as bellow, the
> current sock state is TCP_SYN_RECV.

Thanks. That makes sense as a snapshot of time for
tcp_init_transfer(), but I think what would be more useful would be a
description of the sequence of events, including when the CC was
initialized previous to that point (as noted above, was it that the
setsockopt(TCP_CONGESTION) completed before that point?).

thanks,
neal
