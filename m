Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407613A76C3
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFOFyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhFOFxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 01:53:44 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06DCC061767
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 22:51:37 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id l3so14735997qvl.0
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 22:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uurbqWGujms+eM8JjaOpUapUD5h6wnD/q/UNp8oKl/0=;
        b=KMnP3cU+UZcfuVAa70h5h4J59Tw7wMGEV/XJzlxQEe4gi1xU4yErHIp7f4syUQ/GAm
         ew9DmxJHOiCQGZQH/8mzD+blLUobDi0ORbJubvIqQs9SyNP6NXgRiWaKGU59PMskZQcy
         DZIzOPWMUiwPmVctMq7Yv0LcoOaGmp09jnJQR1Tgoddw7odW2FBLOcnZiLCpfya++vre
         2ZecCASMGkyaPk78lfWjI39tfslVTCTQEWup2wd0XsoFsJR5OAWy1cc4nGjHUwk2I11I
         pbvpPN8spFGsYAtW+O8nsIerU3VDfssegfuHf+Fo7fRaYhP1y73NLNu1iR/RdUKD+FB8
         bqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uurbqWGujms+eM8JjaOpUapUD5h6wnD/q/UNp8oKl/0=;
        b=FRfuGT4js05cgjkJ4jcx2s0g06sM//xJveXZdJ3dcBsc3RzOrSn9S4a4xO/Eth7Wev
         JPIOpmNvSseG0CrQK32wsyb89vkWioWoVSnXNpJ7y2A1RTGDzEgy/zl+YyRUEgE43WIV
         lfc6u+xEZpzaj9PM1zRpnJdNTjf5PoqQdxNZIytTTv2Y/fyGIlRHScgTdxvXBnkMLt//
         KwI5ver/S8MFJiNwIFuNLpaHt0q8kxfxJZJtsC8EQxIVAzdZdsWUP4r4tE6+aayTwXbq
         iHVVOACqyYbTsV5/d839CEvbNL1yqDAP+PSDW1bVeTmrgZ1CwTnSxtTxx0OM3ngXBDY9
         WwLw==
X-Gm-Message-State: AOAM530LQxkTCqXrk5U1A7kjMrxLHBczv9wLwDJCctk6IVw2Z17w6spl
        1TW5qMgQ3GBB23pel71+KXHRjdc6SlBTY+ErKKEa0w==
X-Google-Smtp-Source: ABdhPJwhRw/kAGedkBG+GyFU4tJnyB7sLBulrfz7RgYLWi9/K81O4TYSNRbFgMwjHwX9Rs/Wk6PAGzwDSbK2agtyRcQ=
X-Received: by 2002:a0c:f652:: with SMTP id s18mr3342726qvm.18.1623736296550;
 Mon, 14 Jun 2021 22:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000008a6c05c46e45a4@google.com> <20210615053159.GA5412@gondor.apana.org.au>
In-Reply-To: <20210615053159.GA5412@gondor.apana.org.au>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 15 Jun 2021 07:51:25 +0200
Message-ID: <CACT4Y+YZVgJiRkQdmw-Oc407u9xg2nzeYstv0QVe40xrDimtUQ@mail.gmail.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_selector_match
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+e4c1dd36fc6b98c50859@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 7:32 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 10, 2021 at 12:19:26PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    13c62f53 net/sched: act_ct: handle DNAT tuple collision
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16635470300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e4c1dd36fc6b98c50859
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+e4c1dd36fc6b98c50859@syzkaller.appspotmail.com
> >
> > UBSAN: shift-out-of-bounds in ./include/net/xfrm.h:838:23
> > shift exponent -64 is negative
> > CPU: 0 PID: 12625 Comm: syz-executor.1 Not tainted 5.13.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]
> >  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
> >  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
> >  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
> >  addr4_match include/net/xfrm.h:838 [inline]
> >  __xfrm4_selector_match net/xfrm/xfrm_policy.c:201 [inline]
> >  xfrm_selector_match.cold+0x35/0x3a net/xfrm/xfrm_policy.c:227
> >  xfrm_state_look_at+0x16d/0x440 net/xfrm/xfrm_state.c:1022
>
> This appears to be an xfrm_state object with an IPv4 selector
> that somehow has a prefixlen (d or s) of 96.
>
> AFAICS this is not possible through xfrm_user.  OTOH it is not
> obvious that af_key is entirely consistent in how it verifies
> the prefix length, in particular, it seems to be possible for
> two addresses with conflicting families to be provided as src/dst.
>
> Can you confirm that this is indeed using af_key (a quick read
> of the syzbot log seems to indicate that this is the case)?

Hi Herbert,

This was triggered by this program and, yes, it creates an AF_KEY socket:


18:01:48 executing program 1:
r0 = socket$inet_udp(0x2, 0x2, 0x0)
socket$key(0xf, 0x3, 0x2)
bind$inet(r0, &(0x7f00000001c0)={0x2, 0x0, @local}, 0x10)
socketpair$tipc(0x1e, 0x5, 0x0, &(0x7f00000000c0)={0xffffffffffffffff,
<r1=>0xffffffffffffffff})
ioctl$TUNSETLINK(r1, 0x8912, 0x400308)
connect$inet(r0, &(0x7f0000000480)={0x2, 0x0, @multicast2}, 0x10)
setsockopt$inet_IP_XFRM_POLICY(r0, 0x0, 0x11,
&(0x7f0000000080)={{{@in6=@ipv4={'\x00', '\xff\xff', @dev},
@in6=@private0, 0x0, 0xfffc, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x0,
0xee01}, {0x2}, {}, 0x0, 0x0, 0x1}, {{@in, 0x0, 0x32}, 0x0,
@in6=@loopback, 0x0, 0x0, 0x0, 0xb7}}, 0xe8)
socket$key(0xf, 0x3, 0x2)
sendmmsg(r0, &(0x7f0000007fc0), 0x800001d, 0x0)
