Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91491461F1
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAWGTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:19:33 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43322 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgAWGTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 01:19:32 -0500
Received: by mail-qk1-f196.google.com with SMTP id j20so2334958qka.10
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 22:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DWVey0Ru8uHUhBHg8Dq4pq0wh0KSnHnAOppPY8DxmvU=;
        b=X0x8Mx1GQQoi5Ka3UtfcpeAY5E4aDhEqT+TuUQUE4s4eVdr5cEE4EMIQqggQyK52xE
         0vUx0ixeD065Hv3EPwWBpdLAbLOtB8keJnW0Q8FEOuYbO57iEAmBiimqIPor8v3TLPkI
         8Rv5WQ+COSZU9IJR3oGGMSt9Jaik4Xm5epJZ6oMJBdVMe4OOp0J8aAiig66avSrHTGFU
         ZMLxS/MrvuVnwkonxQyV/Wm/TCgWBgbXEwnJB0ygjDFFi8BgLJnxoAgUvk9cE2LvfS6Y
         y5wPGj98K15pRk3uydwUXLqAvwc/Me84ubXumKr8AL4l/YjQO/gKURXnIYIb3w17DuZS
         XgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DWVey0Ru8uHUhBHg8Dq4pq0wh0KSnHnAOppPY8DxmvU=;
        b=GLjkI0cZJBTzAgksIVNxMsdogpSNmwstDPuFxmHT76KoD413ZbsiBeIudx5AKJFF2Y
         UXoj+zyVnHxr7xffCgXTZHe/Kr5GgLJsUgJEU5+M6KTaAXzuwo1CVWyNrzuEUtHhDV8N
         CkkvTClw6XLB1/sg6Rl/w5y8zBYqUt/epEMYnx/4kb/hqC2eS1plo21BLDSrouNHhyiy
         q2WvcPAx8MsjHPGnf6j1/sWG5yiqzbeJtRnajuUWygtMTA+3CHpvCkoLlTGEivret1JC
         YCVeIvU8ccpE8c+mbZ2vMIB0rLmhDAMRmZV9HxJ7TDCYxjq2DZ1NQkUQJ/rujbLX+yj1
         8E+A==
X-Gm-Message-State: APjAAAWFHl+lN2tHFjccMSBXxi6YpZF1mEHVMw5QBZSCbZQ2eGyo7GvQ
        945lDc11uNk+FoSawOvwLhGpO0xEfpgz2auRAmr9Lw==
X-Google-Smtp-Source: APXvYqxPvFH2hb6DQNRFIML+u3GiHl/lpT3X039n8YspVHHtYOZyKKhAOruNUuna2r9SfobzTbU0HZvlMO0v6W4uyDQ=
X-Received: by 2002:a05:620a:4d:: with SMTP id t13mr11125976qkt.43.1579760371377;
 Wed, 22 Jan 2020 22:19:31 -0800 (PST)
MIME-Version: 1.0
References: <00000000000068843f059cc0d214@google.com> <a10a25dd-fa53-0e7f-d394-d0123bc95df9@gmail.com>
In-Reply-To: <a10a25dd-fa53-0e7f-d394-d0123bc95df9@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 23 Jan 2020 07:19:19 +0100
Message-ID: <CACT4Y+bHhqdsYdDrU+Wq4cA1iu6NbhAE2vjJKWAqfnH5EtQ3mA@mail.gmail.com>
Subject: Re: WARNING in bpf_warn_invalid_xdp_action
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kuba@kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 10:38 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 1/22/20 1:01 PM, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit 58956317c8de52009d1a38a721474c24aef74fe7
> > Author: David Ahern <dsahern@gmail.com>
> > Date:   Fri Dec 7 20:24:57 2018 +0000
> >
> >     neighbor: Improve garbage collection
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124a5985e00000
> > start commit:   d0f41851 net, ip_tunnel: fix namespaces move
> > git tree:       net
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=114a5985e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=164a5985e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8ce4113dadc4789fac74
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f99369e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d85601e00000
> >
> > Reported-by: syzbot+8ce4113dadc4789fac74@syzkaller.appspotmail.com
> > Fixes: 58956317c8de ("neighbor: Improve garbage collection")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >
>
> bisection looks bogus...
>
> It would be nice to have alternative helpers to conveniently replace some WARN_ON/WARN_ONCE/...
> and not having to hand-code stuff like :
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 538f6a735a19f017df8e10149cb578107ddc8cbb..633988f7c81b3b4f015d827ccb485e8b227ad20b 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6913,11 +6913,15 @@ static bool xdp_is_valid_access(int off, int size,
>
>  void bpf_warn_invalid_xdp_action(u32 act)
>  {
> +       static bool __section(.data.once) warned;
>         const u32 act_max = XDP_REDIRECT;
>
> -       WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
> -                 act > act_max ? "Illegal" : "Driver unsupported",
> -                 act);
> +       if (!warned) {
> +               warned = true;
> +               pr_err("%s XDP return value %u, expect packet loss!\n",
> +                      act > act_max ? "Illegal" : "Driver unsupported", act);
> +               dump_stack();
> +       }
>  }
>  EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);

If a single caller of this function would be enough (or maybe grand
caller with a macro), then we could use pr_err_once/ratelimited and
print 1 line with error and caller function.
