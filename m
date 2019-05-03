Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD60A1330E
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 19:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfECRT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 13:19:59 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36800 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfECRT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 13:19:59 -0400
Received: by mail-io1-f66.google.com with SMTP id d19so5842390ioc.3;
        Fri, 03 May 2019 10:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r2uAQt0Bvsy/cuLm6VMoad/e7q1topheHEBvBpUuRTg=;
        b=mBYVOpjae9uWiS11YJRP6uDNbxA54vBO40AZQnIJ6BjfKqgtLdVSnFyKVON0RN502M
         rgJG7BHUMCdm5baqBBvha2CmKhJZfXjuM9xLth/DxLe5QCnSWDbt3AWJOj/ajj8kFS9H
         tzJ/nqHQ6yic3sEfMTmZBYE/k+uDxLojsxt4i20B4+px8RfnXq5uYRnlRPrKx0QjoDXM
         lp3rOxaxu+sF8lHxDe8xbjB3dqI4RuJQFT59pVfqQQaRGYJ24M1GUmolrMjPvgKEe4N/
         ahH1IlJ29twLFBSitOhrN2TtzE6d9ilWXI1Ats4jxc8XDhTwR2Mkxm1QziGLtleoj+QN
         kArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r2uAQt0Bvsy/cuLm6VMoad/e7q1topheHEBvBpUuRTg=;
        b=gGpWirZMUePE/X7Y9c9ri65FUjvnhJDn/Um5HEdz1of3zIOmRET0WQJjKnDURqm9Yb
         642/Pk+0hxNFVQ+st/8TVnWX4LE2h5RGPtjdrXBNJ1/x9ET77ShPGFyeO7/jgh4zAauy
         1X9HXMhdL97mqbbRBCcqPAQnnNoKPXqEkf2lPEfFUXA7gA9UAUDUdT4yA95pcXnx4r+X
         t81g6T5zhT1Hj3+AaK5orPVm790ktqD8VLX4SxkjTL6JNxw3lM6Nr1SUFWGbZWjHDKVg
         0G0l6pH3QLDSSp0p9akEx5wgtipvwLEp6cLqtJkroGmN2z8BeJF+YOVNsYLWNVRn8L+N
         m8Nw==
X-Gm-Message-State: APjAAAWOeraQ/DzDa0oVeX7xQA2ld9BUgw+y98ChAT7Uypn5Fj6vjqN3
        SdinuP+YO3rTrlxsHOkqVGD/1COR7qP00gDAL0w=
X-Google-Smtp-Source: APXvYqxiF5PHNQiqJ0GHkKA8Wdz9mUC9o+Y3s6oZnGSYoKgvZ0APeckWE+zdGD+8yVenAIDzUudQV2J1cMo5WlyQrik=
X-Received: by 2002:a5e:890f:: with SMTP id k15mr6271446ioj.68.1556903998468;
 Fri, 03 May 2019 10:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190501205215.ptoi2czhklte5jbm@csclub.uwaterloo.ca>
 <CAKgT0UczVvREiXwde6yJ8_i9RT2z7FhenEutXJKW8AmDypn_0g@mail.gmail.com>
 <20190502151140.gf5ugodqamtdd5tz@csclub.uwaterloo.ca> <CAKgT0Uc_OUAcPfRe6yCSwpYXCXomOXKG2Yvy9c1_1RJn-7Cb5g@mail.gmail.com>
 <20190502171636.3yquioe3gcwsxlus@csclub.uwaterloo.ca> <CAKgT0Ufk8LXMb9vVWfvgbjbQFKAuenncf95pfkA0P1t-3+Ni_g@mail.gmail.com>
 <20190502175513.ei7kjug3az6fe753@csclub.uwaterloo.ca> <20190502185250.vlsainugtn6zjd6p@csclub.uwaterloo.ca>
 <CAKgT0Uc_YVzns+26-TL+hhmErqG4_w4evRqLCaa=7nME7Zq+Vg@mail.gmail.com> <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca>
In-Reply-To: <20190503151421.akvmu77lghxcouni@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 3 May 2019 10:19:47 -0700
Message-ID: <CAKgT0UcV2wCr6iUYktZ+Bju_GNpXKzR=M+NLfKhUsw4bsJSiyA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 8:14 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Thu, May 02, 2019 at 01:59:46PM -0700, Alexander Duyck wrote:
> > If I recall correctly RSS is only using something like the lower 9
> > bits (indirection table size of 512) of the resultant hash on the
> > X722, even fewer if you have fewer queues that are a power of 2 and
> > happen to program the indirection table in a round robin fashion. So
> > for example on my system setup with 32 queues it is technically only
> > using the lower 5 bits of the hash.
> >
> > One issue as a result of that is that you can end up with swaths of
> > bits that don't really seem to impact the hash all that much since it
> > will never actually change those bits of the resultant hash. In order
> > to guarantee that every bit in the input impacts the hash you have to
> > make certain you have to gaps in the key wider than the bits you
> > examine in the final hash.
> >
> > A quick and dirty way to verify that the hash key is part of the issue
> > would be to use something like a simple repeating value such as AA:55
> > as your hash key. With something like that every bit you change in the
> > UDP port number should result in a change in the final RSS hash for
> > queue counts of 3 or greater. The downside is the upper 16 bits of the
> > hash are identical to the lower 16 so the actual hash value itself
> > isn't as useful.
>
> OK I set the hkey to
> aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55:aa:55
> and still only see queue 0 and 2 getting hit with a couple of dozen
> different UDP port numbers I picked.  Changing the hash with ethtool to
> that didn't even move where the tcp packets for my ssh connection are
> going (they are always on queue 2 it seems).

The TCP flow could be bypassing RSS and may be using ATR to decide
where the Rx packets are processed. Now that I think about it there is
a possibility that ATR could be interfering with the queue selection.
You might try disabling it by running:
    ethtool --set-priv-flags <iface> flow-director-atr off

> Does it just not hash UDP packets correctly?  Is it even doing RSS?
> (the register I checked claimed it is).

The problem is RSS can be bypassed for queue selection by things like
ATR which I called out above. One possibility is that if the
encryption you were using was leaving the skb->encapsulation flag set,
and the NIC might have misidentified the packets as something it could
parse and set up a bunch of rules that were rerouting incoming traffic
based on outgoing traffic. Disabling the feature should switch off
that behavior if that is in fact the case.

> This system has 40 queues assigned by default since that is how many
> CPUs there are.  Changing it to a lower number didn't make a difference
> (I tried 32 and 8).

You are probably fine using 40 queues. That isn't an even power of two
so it would actually improve the entropy a bit since the lower bits
don't have a many:1 mapping to queues.
