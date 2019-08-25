Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31D9C54E
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfHYRwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:52:39 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:33135 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfHYRwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:52:39 -0400
Received: by mail-pf1-f179.google.com with SMTP id g2so10087460pfq.0;
        Sun, 25 Aug 2019 10:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRdy6DBgNd6uaPx/aa/9AFdmyvouH4INH60SDvCM99U=;
        b=t6Tq+Wdvgxv62t/0yoGN2Ernd7b25qDBYgMm8mzTDcUOob1BEedzcHcnOQe+yFcTnH
         TCzew7gxk+wRzNDUyfO5UcrlOahiaKKWMLFq0oXeeZxCsOZOhkjL0s66HutLB/U2y7pv
         hwlkQOrO2z8r6177R9mBUUDxfUxbTuuwGywlxU5o2yVgVCEX7Pi5C89igxPrGOXFJUwQ
         +VMyA3ImZFccy0wS+w62rElFHkhiHsOxVFGvG45SfzIPViBtPwn8Bxgh1q9cX2B8BJcB
         eJIZKvwNHuJKGaCWvXCEUWTQAcohsK3PYuMzHdyrMO3J5spsyEttONopHQ4w15Ne9dlC
         h0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRdy6DBgNd6uaPx/aa/9AFdmyvouH4INH60SDvCM99U=;
        b=CpMX9eIX7PQ8id9VdHJq5AHF7ixOlbNYk4AfYPP8mn2nqt3Hc2KBNBLU+cbZEDjruq
         8ht6L/PfNk9MAyyneil4qzQk5n6SeBHFLrRXAoEIhCFurMuzEUf6Ac75PE6PkyEZDaRZ
         aGUbwSZIX6yLewFeNdhtwrufL4199kBuqBKYue82okUmp0JC/xSO0E5f53CqdaloVF8w
         OTUHAkoLH7Br5+sD/F2bGLh5ULnEiBDo5nBK1GtNWys/87IpUPhHCZ7le/2MZo5XVWg+
         6/KdYqqg00GzI7RCyKw6GQvB3bkwyw4mte+KsB5Z6AXZwBJ4T3IGSWCGcJYA79w2FXF2
         Opig==
X-Gm-Message-State: APjAAAUhmJOxGQgw7xvHs+6HWfNz9X7ieXPsECukk0Jr7z3lJ+hwYBic
        Xy0rs+pYjnh5A2TKzvbqyRCrlCT5JMjbUBHhf8bnq5kI
X-Google-Smtp-Source: APXvYqzUBAdViNre6pTAcceEcq8yiQ0SRL0lMKzFdjSQo1Zdrub61iSHHApDF7DHdd/mE2hCSVdEWrZGmOq6td3Xyew=
X-Received: by 2002:a62:2ac4:: with SMTP id q187mr15778717pfq.242.1566755558563;
 Sun, 25 Aug 2019 10:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
 <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com> <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
In-Reply-To: <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 25 Aug 2019 10:52:27 -0700
Message-ID: <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Akshat Kakkar <akshat.1984@gmail.com>
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:00 PM Akshat Kakkar <akshat.1984@gmail.com> wrote:
>
> On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > I am using ipset +  iptables to classify and not filters. Besides, if
> > > tc is allowing me to define qdisc -> classes -> qdsic -> classes
> > > (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
> > > then how can those lowest child classes be actually used or consumed?
> >
> > Just install tc filters on the lower level too.
>
> If I understand correctly, you are saying,
> instead of :
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000001 fw flowid 1:10
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000002 fw flowid 1:20
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000003 fw flowid 2:10
> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> 0x00000004 fw flowid 2:20
>
>
> I should do this: (i.e. changing parent to just immediate qdisc)
> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
> fw flowid 1:10
> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
> fw flowid 1:20
> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
> fw flowid 2:10
> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
> fw flowid 2:20


Yes, this is what I meant.


>
> I tried this previously. But there is not change in the result.
> Behaviour is exactly same, i.e. I am still getting 100Mbps and not
> 100kbps or 300kbps
>
> Besides, as I mentioned previously I am using ipset + skbprio and not
> filters stuff. Filters I used just to test.
>
> ipset  -N foo hash:ip,mark skbinfo
>
> ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
> ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
> ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
> ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20
>
> iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio

Hmm..

I am not familiar with ipset, but it seems to save the skbprio into
skb->priority, so it doesn't need TC filter to classify it again.

I guess your packets might go to the direct queue of HTB, which
bypasses the token bucket. Can you dump the stats and check?

Thanks.
