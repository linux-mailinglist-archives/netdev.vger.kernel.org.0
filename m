Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36CB42011C
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 11:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhJCJpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 05:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhJCJpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 05:45:35 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D1BC0613EC;
        Sun,  3 Oct 2021 02:43:47 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o4-20020a05600c510400b0030d55d6449fso3705338wms.5;
        Sun, 03 Oct 2021 02:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8s5Okeo6WxBJf1cFUUcrgLlXmGQNS6CIp0UlprQc2Q=;
        b=VVhvuakDJIz4tYWHBo4D8Hw7Wudh8jvcQJ6UkWt/xvd/xIWFgPKgBS5btNZjadLkJN
         /TG6GeCDAeZZBmrNlYSyYAq0Dno4QLvTHkRI7BgKZf7QdvWY5+1FWM0RYIGDewaJzxds
         6fKIoEh1RDpqJ9OVVNPLB1udWaqpj4Z8zOnj8D+fX1s1ICwbDHPsxukjy03JjA5pNjwa
         RXuEQ6nQMHlJbDWyFahLfhPMzSQR6N8sVJ/bmJMUvGhEW2c8xilMKXfqoGw2x9oExzkW
         EczR4cr5H4lF+S/i1tWCNKBSsTJBMSqKPsdzQKmGWr4tDlGPbHrrHIkSwcHIL/t1Z1+o
         BjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8s5Okeo6WxBJf1cFUUcrgLlXmGQNS6CIp0UlprQc2Q=;
        b=RS+1cBzxC2sAek/1+VsmXiLd8VtUvv3CTsYidoxaAEOwafTLT/dvJUfwAQHeThP3/w
         EsUsI+XdtYj0wyPSFADAR3mq1myyXhDpYlVy4F5LHYDiOQNK6MPj0WJ+CPxWczre2Gvd
         ju1MjqT1qap+0/VY2Xq4InF7fohRy7lKjA+OJr1Ti0wRgqgYrLoFvNb4JaE/4vMZ43ar
         7+QmS32O+cvk6yzEe9aNg0s8FFm2j8wmNw/4+LFBNGQtIXsEnwtyluhwNHTWJ2TYSaeo
         EImgWbDXxUpQv8yh5U874whurl20Vg+uJe3+DSFZVG8j5N4OMNrttun4gmZC1crkrlN5
         dKhw==
X-Gm-Message-State: AOAM5333MUd5XaPkgRzwWTJv+JEkjqPbtisZExWJF2jDOZw++CXuOL6q
        eZl0MHmI4QyQMoaLQdHte1LIRVAd1NwVgUMfMdY=
X-Google-Smtp-Source: ABdhPJyXF6565LiYj4CaeT54IjmpdEE3utOV93ftCvEPtDqBKu7zVjJKr2sicKViEj7sXZJdQJ1wFTeE2chr7lUia7o=
X-Received: by 2002:a05:600c:247:: with SMTP id 7mr13144159wmj.4.1633254225493;
 Sun, 03 Oct 2021 02:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009a53cd05cc788a95@google.com> <CADvbK_c-V6orWGm2ae1pxoUU-5J-1J-a057hYemA6oTESGhFMg@mail.gmail.com>
 <20210923093442.GC2048@kadam> <20210924171412.GF2083@kadam>
In-Reply-To: <20210924171412.GF2083@kadam>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 3 Oct 2021 17:43:34 +0800
Message-ID: <CADvbK_fso7ZLnOwcZbvoSORErT4BG0JwGGxdKg237e_wvv7Usw@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in sctp_rcv
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     syzbot <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 1:14 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Thu, Sep 23, 2021 at 12:34:42PM +0300, Dan Carpenter wrote:
> > On Wed, Sep 22, 2021 at 05:18:29PM +0800, Xin Long wrote:
> > > On Tue, Sep 21, 2021 at 12:09 PM syzbot
> > > <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    98dc68f8b0c2 selftests: nci: replace unsigned int with int
> > > > git tree:       net
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=11fd443d300000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=581aff2ae6b860625116
> > > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > >
> > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com
> > > >
> > > > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > > > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > > > CPU: 0 PID: 11205 Comm: kworker/0:12 Not tainted 5.14.0-syzkaller #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > Workqueue: ipv6_addrconf addrconf_dad_work
> > > > RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
> > > by anyway, checking if skb_header_pointer() return NULL is always needed:
> > > @@ -702,7 +702,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
> > >                 ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
> > >
> > >                 /* Break out if chunk length is less then minimal. */
> > > -               if (ntohs(ch->length) < sizeof(_ch))
> > > +               if (!ch || ntohs(ch->length) < sizeof(_ch))
> > >                         break;
> > >
> >
> > The skb_header_pointer() function is annotated as __must_check but that
> > only means you have to use the return value.  These things would be
> > better as a Coccinelle or Smatch check.
> >
> > I will create a Smatch warning for this.
>
> These are the Smatch warnings for this:
>
> net/sctp/input.c:705 sctp_rcv_ootb() error: skb_header_pointer() returns NULL
> net/ipv6/netfilter/ip6t_rt.c:111 rt_mt6() error: skb_header_pointer() returns NULL
> net/ipv4/icmp.c:1076 icmp_build_probe() error: skb_header_pointer() returns NULL
> net/ipv4/icmp.c:1089 icmp_build_probe() error: skb_header_pointer() returns NULL
Will post follow-ups for rt_mt6() and icmp_build_probe() too.

Thanks!
>
> regards,
> dan carpenter
>
