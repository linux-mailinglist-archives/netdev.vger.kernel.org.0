Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A291340E0
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 12:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgAHLnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 06:43:13 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:33806 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbgAHLnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 06:43:12 -0500
Received: by mail-lf1-f54.google.com with SMTP id l18so2231002lfc.1
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 03:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XXfm8PhlopV3AkYcnPLvA6eEp627Iq7NjTcekZwIaDs=;
        b=pEMTfcU5jp6EcnRQeGp56SiT0YitreUnOzIMluGLUh7ZzTLxk4KM2YzQu30El1tDjT
         cANr108PeEjNI9cPiJun8UdDHxUdKjt1AzsSUke/H/HlsbbF8qE/RP+WH+YjA3uAsqD7
         3wIxwx4v6YG8t3SUuf6+Zz63QkAdB1Kh2k9DiP0WqAw2f4pQ1CO9EtnwoazCQ3RoZDQJ
         rgbRM8+pXWP+zOuJkWO0mTFzwAC4uBzxAELLyk1fUGp8hlYltN3zzwJ/5UL5RsyQ4edf
         FStamg9/r5wFZk0aE7kqXqWtBbWPDPK4Gt4gsMEiC6WetrjAYCvwFSxDv9M3aPhXpmEn
         M2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XXfm8PhlopV3AkYcnPLvA6eEp627Iq7NjTcekZwIaDs=;
        b=CdvwkEIDcK30D3KpY4QKY7aDJK3tDZSXXtGRVuIWQieyEImlkjZ57m4ZpLe7+Ol1pL
         rAoyXKjMR2r9ZEBo00XMTANvZkBbxae3veiqSMsNutmjjHGaZS6K3h1r4KbfBwPrGFuw
         sFlFa+RtS6H+GH02yF5uoPq/y8XKi6pzvtzu4SyAmpCnSFr0X7wehcBkeVQQwLQNXdi6
         0t3zhfWiEODxvpfvvGQ/mA4ttfxfmFghR2W5iFFTigU15mVOlloOTIV5B9Vb8jHZnv63
         UNTEf7Bep16Fk/H4l+zSUjG14u1wI5SRYLiew+jhU6X5kL505AKY8blVrn0remgP3V4d
         eqQw==
X-Gm-Message-State: APjAAAVyWQGZniWZUwnO7lHu/DaAwcLvJjmiCpZyVDOaowGy7MK1Y6Nh
        DokRUuX3V+DhjDikCqQIq2cWzcMlMINKq/t2FsU=
X-Google-Smtp-Source: APXvYqxDvWEOeRdrQd+xwgqJSgQj3h7KdTU03cafJp8sEyPCdInreZDznbejGd7Mmewwgr3QjWizoP+F9kSuED6oBSo=
X-Received: by 2002:ac2:430d:: with SMTP id l13mr2807474lfh.112.1578483789443;
 Wed, 08 Jan 2020 03:43:09 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com> <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
In-Reply-To: <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 8 Jan 2020 20:42:58 +0900
Message-ID: <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jan 2020 at 09:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Jan 7, 2020 at 3:31 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > After "ip link set team0 master team1", the "team1 -> team0" locking path
> > will be recorded in lockdep key of both team1 and team0.
> > Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
> > locking path also will be recorded in lockdep key. At this moment,
> > lockdep will catch possible deadlock situation and it prints the above
> > warning message. But, both "team0 -> team1" and "team1 -> team0"
> > will not be existing concurrently. so the above message is actually wrong.
> > In order to avoid this message, a recorded locking path should be
> > removed. So, both lockdep_unregister_key() and lockdep_register_key()
> > are needed.
> >
>
> So, after you move the key down to each netdevice, they are now treated
> as different locks. Is this stacked device scenario the reason why you
> move it to per-netdevice? If so, I wonder why not just use nested locks?
> Like:
>
> netif_addr_nested_lock(upper, 0);
> netif_addr_nested_lock(lower, 1);
> netif_addr_nested_unlock(lower);
> netif_addr_nested_unlock(upper);
>
> For this case, they could still share a same key.
>
> Thanks for the details!

Yes, the reason for using dynamic lockdep key is to avoid lockdep
warning in stacked device scenario.
But, the addr_list_lock case is a little bit different.
There was a bug in netif_addr_lock_nested() that
"dev->netdev_ops->ndo_get_lock_subclass" isn't updated after "master"
and "nomaster" command.
So, the wrong subclass is used, so lockdep warning message was printed.
There were some ways to fix this problem, using dynamic key is just one
of them. I think using the correct subclass in netif_addr_lock_nested()
is also a correct way to fix that problem. Another minor reason was that
the subclass is limited by 8. but dynamic key has no limitation.

Unfortunately, dynamic key has a problem too.
lockdep limits the maximum number of lockdep keys.
   $cat /proc/lockdep_stats
   lock-classes:                         1228 [max: 8192]

So, If so many network interfaces are created, they use so many
lockdep keys. If so, lockdep will stop.
This is the cause of "BUG: MAX_LOCKDEP_KEYS too low!".

Thank you!
Taehee Yoo
