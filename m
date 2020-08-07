Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACE723F3FD
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgHGUsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgHGUsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:48:09 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BE8C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 13:48:09 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l17so3212579iok.7
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 13:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7iIBF1J+NEJEikkCV/4feQpExfS0moZa3I7t1+tchgE=;
        b=rOxUor36lsN7qB5Z5BqJC5kQzuqtYwepEaZ4E9HKFeKXfXD5PZv10pN08CZSblIz4E
         v9N8KiRKLXwRGSHOe2Oe30aQVVBwwN2n69qN7GmAy9O/7BT6urVQ1duXVuKdruQMl5wr
         aYatRjIc4vWQUhkbKGk+9FK/GwCpmzCrqMzDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7iIBF1J+NEJEikkCV/4feQpExfS0moZa3I7t1+tchgE=;
        b=NU1xHEZ861/WPW/6rxFfIzZdApwA9f2qcNXEhEQO7tU8ehq4t6AlqLU9TxVtX1RP0C
         u2ceQfeYGp8y9fXh4MrPOwUsOBfba0cLXbQhRetXo1xxGPhJIJnDXmWSex7f+9icLeMy
         DkQ0atQx0qhdgQdAxBVzHZUrTTvqp/9P4PDUshlJE+xbMdhpCags2ZM6rwoBHNQcUlHF
         3BtaNeA2f5byr9EbWP7qVFYyqtHXJ0ZLKCFJ/7pyBNVb4i+8PNN3STmTRUOF2eBjd+1L
         fJn9l4SLEBZIBJsRjG6SmmWbXC2xZg+Dp6VxQ9mlWtVXKOnQeEZIIZBe45+QDxTHf6Jf
         iuYg==
X-Gm-Message-State: AOAM530ouCAcMpbhKDRHebblCuKPrJ5FoyWjniPW/DDpXPbRDN0o2jGt
        KJJIkFqWRmCPW0AS6xpACzq5m5GvDS+7d2t3+UTzRQ==
X-Google-Smtp-Source: ABdhPJyOmtN9oTufHad6ruymZgFZK4XIjgOoXU50DtognrW1IEcWNyB9WTXx+6+UtQt5Vks4f+d7kcyQQJ3L46MKrYQ=
X-Received: by 2002:a02:3843:: with SMTP id v3mr6918832jae.23.1596833287922;
 Fri, 07 Aug 2020 13:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
In-Reply-To: <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 7 Aug 2020 16:47:56 -0400
Message-ID: <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Cc:     Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Adding more of us working on RCU as well. Johan from another team at
Google discovered a likely issue in openswitch, details below:

On Fri, Aug 7, 2020 at 11:32 AM Johan Kn=C3=B6=C3=B6s <jknoos@google.com> w=
rote:
>
> On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wrote:
> >
> >
> >
> > On 8/3/2020 12:01 PM, Johan Kn=C3=B6=C3=B6s via discuss wrote:
> > > Hi Open vSwitch contributors,
> > >
> > > We have found openvswitch is causing double-freeing of memory. The
> > > issue was not present in kernel version 5.5.17 but is present in
> > > 5.6.14 and newer kernels.
> > >
> > > After reverting the RCU commits below for debugging, enabling
> > > slub_debug, lockdep, and KASAN, we see the warnings at the end of thi=
s
> > > email in the kernel log (the last one shows the double-free). When I
> > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> > > fix possible memleak on destroy flow-table"), the symptoms disappear.
> > > While I have a reliable way to reproduce the issue, I unfortunately
> > > don't yet have a process that's amenable to sharing. Please take a
> > > look.
> > >
> > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callback=
 handling
> > > e99637becb2e rcu: Add support for debug_objects debugging for kfree_r=
cu()
> > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() work
> > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> > >

Note that these reverts were only for testing the same code, because
he was testing 2 different kernel versions. One of them did not have
this set. So I asked him to revert. There's no known bug in the
reverted code itself. But somehow these patches do make it harder for
him to reproduce the issue.

> > > Thanks,
> > > Johan Kn=C3=B6=C3=B6s
> >
> > Let's add the author of the patch you reverted and the Linux netdev
> > mailing list.
> >
> > - Greg
>
> I found we also sometimes get warnings from
> https://elixir.bootlin.com/linux/v5.5.17/source/kernel/rcu/tree.c#L2239
> under similar conditions even on kernel 5.5.17, which I believe may be
> related. However, it's much rarer and I don't have a reliable way of
> reproducing it. Perhaps 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 only
> increases the frequency of a pre-existing bug.

This is interesting, because I saw kbuild warn me recently [1] about
it as well. Though, I was actually intentionally messing with the
segcblist. I plan to debug it next week, but the warning itself is
unlikely to be caused by my patch IMHO (since it is slightly
orthogonal to what I changed).

[1] https://lore.kernel.org/lkml/20200720005334.GC19262@shao2-debian/

But then again, I have not heard reports of this warning firing. Paul,
has this come to your radar recently?

Thanks,

 - Joel
