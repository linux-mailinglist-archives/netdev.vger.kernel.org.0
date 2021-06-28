Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231D93B66AD
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhF1Q1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 12:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhF1Q1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 12:27:08 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB4EC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 09:24:41 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id s72so4078954vkb.8
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 09:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RpJ7w32iGqwOk/oM/d0ecaefQixseDwgEeakcU32Bpk=;
        b=J5VVzZnCPxO4E4iVGvXs0S0FNIqPMIYqCPljwFsfMFBLSG5Xf/XsoDBBgz7XgOAHmm
         vj7AoYTLWtcJtxnNJHMOS4ONGe4/xLbiLzUhOqtIS+2VZ8TjR/p4Jp/sjGyshvcYALQV
         jiVsg2puI6vff5H82ZCHshluIz/QfrLLq8Q1ODcK2NxRkPvQDq4NlK8sQLRWj/URdKEZ
         ZLO4SE0JpCoP3lPkkachFV5wjB0I/V2WtBgJTHN8spUvLb5bKq89e41L9bsmNvmMK9vp
         dTyECvKDxu/nb0CWQCyyvTe4MPcCoERzBGkhHsCI7FYD+dGi9i2beYvViJ6+e6YeCT47
         NvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RpJ7w32iGqwOk/oM/d0ecaefQixseDwgEeakcU32Bpk=;
        b=POdGwcqLuk5cMYhCBKKTNvtZES7oV5jTZLaL0GD+h7hAmzyZtUyD8TcFFgSCWla3kS
         acTczSalgl3s0TvgR1pUcGElvdJ+oelXp9QaOgRFe8ShYmysLJcU+7hxk0PnB/amTNdP
         E3jkixuGxFzMcWNqWwZQlU/mWnD+V64ofa6fkcMdkk81cCZ3IwXkHKngkr/6wwPaZmzH
         ozKikwCQL17zrbaEpwe/7W+VyfrTFKWSN5pjmFVAeRpxMLNzsgbPx1w4XOCvRhxQpl8G
         lCwIq36JB5f/A9fLtWRBoxFqALrKVzKfFy0QaC+slRtC7QKgxok3zKOssw6E30UF5pxv
         sCGw==
X-Gm-Message-State: AOAM531RW0dNTOX+frEs4+uPkqNExlxXkpkqn1vmIckG3G89JSCcwIf9
        OWdg1xHC27LXfygJ5bH2AjoB7U2wam+LMlY7hQWEVQ==
X-Google-Smtp-Source: ABdhPJw91nOsdpuFZV/dLpAyCemkIwoeS+zWUP869PzyBrf5GyGV7tXMqGOVFz318/U7RCY6IgxhF5tRCxgIjbMCSos=
X-Received: by 2002:a1f:280e:: with SMTP id o14mr17539002vko.19.1624897480401;
 Mon, 28 Jun 2021 09:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com>
In-Reply-To: <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 28 Jun 2021 12:24:19 -0400
Message-ID: <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
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

On Mon, Jun 28, 2021 at 12:18 PM Phi Nguyen <phind.uet@gmail.com> wrote:
>
> On 6/28/2021 10:52 PM, Eric Dumazet wrote:
>
> > Unfortunately this patch might break things.
> >
> > We keep changing this CC switching, with eBPF being mixed in the equation.
> >
> > I would suggest you find a Fixes: tag first, so that we can continue
> > the discussion.
> >
> > Thank you.
>
> Thank for your feedback. I will resubmit it with a Fixes tag.
>
> Regard.

Thanks.

Can you also please provide a summary of the event sequence that
triggers the bug? Based on your Reported-by tag, I guess this is based
on the syzbot reproducer:

 https://groups.google.com/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPCAAJ

but perhaps you can give a summary of the event sequence that causes
the bug? Is it that the call:

setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
&(0x7f0000000000)='cdg\x00', 0x4)

initializes the CC and happens before the connection is established,
and then when the connection is established, the line that sets:
  icsk->icsk_ca_initialized = 0;
is incorrect, causing the CC to be initialized again without first
calling the cleanup code that deallocates the CDG-allocated memory?

thanks,
neal
