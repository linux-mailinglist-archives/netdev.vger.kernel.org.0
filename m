Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2DD136D38
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 13:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgAJMi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 07:38:27 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38028 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbgAJMi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 07:38:27 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so1671353wrh.5;
        Fri, 10 Jan 2020 04:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p66wV6h17U9wMewOqvO+9P744TVt+8ikPmNpbDPLxQM=;
        b=EA0/n8CD7hYuKCKGYNM5TV5Yj2fcCbV/6gqr0x7e7wcQ/xLh3nhNkWZyKuYyb4Y+1q
         YBV2KG4k620T8pBjnTGxwhCdBC0GP8pw0Kue3ZRCNbuYlu/znSj26ujN+r0b5emptZK5
         kVCjrO7INBvI+DTr9wF+NvX2JmV1+C5jx1e+xeCw0lmR1e8nb/tvpgi+ETKH0KxNrlrZ
         xKS6l6Lx+9xxZ4JasMbEzeG3Ee84qHqnUyl74tdqpD4pGu+cyyyvNe+tt16nq47/x8Li
         qBp41PAS6e/5O7jvvUt4OSreYX5Vs1L2NL4MeKkq4O5OArddB6RXxpM+XCJYxDxrCjE0
         jTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p66wV6h17U9wMewOqvO+9P744TVt+8ikPmNpbDPLxQM=;
        b=nmryVy9zvQ+8ImMs7PgnNC4x92Z7RB06bqq+okO9dmGSHC881BtXP4ahxoBtBiBjAd
         7chX6D1Nq4sfRGLW+OqReYsbthYA60/9UK9fsS9buONeRi7BDUU1wvf+a5Unu9nX+PY9
         KdONYK6L8HT8sqdk/QEMSgS5+Nm3Kww693tCQE/9gMSqO+QOuCh8PfEvJYA/nGGC+VXp
         zfKu81ak6fAAFlmaLY2PtMChPdhMciu4sw+c+8eJUgdEApZL2z4z63atA4/+kZst7dc/
         z2t8RHT4E6fFtD2TLoD5Aii23G9bSp4u/H9ms+L+1DYvgQKob+CTHD7NNron+pGivAlK
         AZcQ==
X-Gm-Message-State: APjAAAXWWmqhxOaohYNh2zt0FW9f+5xlSAaiSAZAjD8UaxuaypbZLdS1
        czcoIyEyMFk0zMbD8k5v0HSe/yBNB68rpow0SDzUMUYV
X-Google-Smtp-Source: APXvYqw5VnQiSbOUcIyPWMyywOGy2Zv260R7LJnXLfdXPETw5JZerPl9HHNaOo/GHtiPnH3iquUCM8emdQsVLsh0PV4=
X-Received: by 2002:a5d:5345:: with SMTP id t5mr3534597wrv.0.1578659904823;
 Fri, 10 Jan 2020 04:38:24 -0800 (PST)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
 <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
 <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
 <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com> <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
In-Reply-To: <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Fri, 10 Jan 2020 18:08:12 +0530
Message-ID: <CAA5aLPgjEGSWmfnCgbx+bn4tYFWAuwDHTopex7_r1qEFsLO+3Q@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for a detailed reply. Sorry I couldn't reply as I was
completely bed ridden.

In order for me to try this, I require few inputs (as I am new to all this)...

1. How do I register in Kernel, that my eBPF program should be called? Is this
https://netdevconf.info/1.1/proceedings/papers/On-getting-tc-classifier-fully-programmable-with-cls-bpf.pdf
and
http://man7.org/linux/man-pages/man8/tc-bpf.8.html
correct documents ?
2. Some info with respect to EDT and skb->tstamp and how things work.

On Mon, Aug 26, 2019 at 12:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 8/25/19 7:52 PM, Cong Wang wrote:
> > On Wed, Aug 21, 2019 at 11:00 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
> >>
> >> On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>> I am using ipset +  iptables to classify and not filters. Besides, if
> >>>> tc is allowing me to define qdisc -> classes -> qdsic -> classes
> >>>> (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
> >>>> then how can those lowest child classes be actually used or consumed?
> >>>
> >>> Just install tc filters on the lower level too.
> >>
> >> If I understand correctly, you are saying,
> >> instead of :
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000001 fw flowid 1:10
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000002 fw flowid 1:20
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000003 fw flowid 2:10
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000004 fw flowid 2:20
> >>
> >>
> >> I should do this: (i.e. changing parent to just immediate qdisc)
> >> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
> >> fw flowid 1:10
> >> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
> >> fw flowid 1:20
> >> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
> >> fw flowid 2:10
> >> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
> >> fw flowid 2:20
> >
> >
> > Yes, this is what I meant.
> >
> >
> >>
> >> I tried this previously. But there is not change in the result.
> >> Behaviour is exactly same, i.e. I am still getting 100Mbps and not
> >> 100kbps or 300kbps
> >>
> >> Besides, as I mentioned previously I am using ipset + skbprio and not
> >> filters stuff. Filters I used just to test.
> >>
> >> ipset  -N foo hash:ip,mark skbinfo
> >>
> >> ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
> >> ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
> >> ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
> >> ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20
> >>
> >> iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio
> >
> > Hmm..
> >
> > I am not familiar with ipset, but it seems to save the skbprio into
> > skb->priority, so it doesn't need TC filter to classify it again.
> >
> > I guess your packets might go to the direct queue of HTB, which
> > bypasses the token bucket. Can you dump the stats and check?
>
> With more than 64K 'classes' I suggest to use a single FQ qdisc [1], and
> an eBPF program using EDT model (Earliest Departure Time)
>
> The BPF program would perform the classification, then find a data structure
> based on the 'class', and then update/maintain class virtual times and skb->tstamp
>
> TBF = bpf_map_lookup_elem(&map, &classid);
>
> uint64_t now = bpf_ktime_get_ns();
> uint64_t time_to_send = max(TBF->time_to_send, now);
>
> time_to_send += (u64)qdisc_pkt_len(skb) * NSEC_PER_SEC / TBF->rate;
> if (time_to_send > TBF->max_horizon) {
>     return TC_ACT_SHOT;
> }
> TBF->time_to_send = time_to_send;
> skb->tstamp = max(time_to_send, skb->tstamp);
> if (time_to_send - now > TBF->ecn_horizon)
>     bpf_skb_ecn_set_ce(skb);
> return TC_ACT_OK;
>
> tools/testing/selftests/bpf/progs/test_tc_edt.c shows something similar.
>
>
> [1]  MQ + FQ if the device is multi-queues.
>
>    Note that this setup scales very well on SMP, since we no longer are forced
>  to use a single HTB hierarchy (protected by a single spinlock)
>
