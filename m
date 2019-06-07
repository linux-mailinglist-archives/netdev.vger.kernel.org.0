Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39F1389C4
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfFGMHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:07:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33528 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfFGMHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 08:07:04 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so1217929iop.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 05:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r+xKOhdMA1on92kbEEKP0BNxlH6D+StiiYHuqe3PS7E=;
        b=DYv4BQPU/fEGit8INbTmIQn8OBAkOpFsjmkTzeMxT38WPKWIjaQg/nesz7yU9H3P4L
         dBhguWIlzToJ8MQgaQk2nq8yy7LHh98JiKnob73y2pHwVXR+ct3cP2nP37XrXC3ommfl
         qYZmeCquis/HXFBxeXxvvFr/cDhg6eLjzGgPwboGkCCC8XJD420rGpDalkBfBs0bWuyH
         GujadCQQrqY9I3QPIXBgs7jOFR8VbOamFAsVRF3zjMVEYIDgIRhhNMJ2Il/dsJkn4nH7
         mwH5GOJVgDjrXKfjAEEIwDdMj84VEzjL3O8Kjq8U3P2FK6TgvzJEhG9PzQfsnYfmoU6x
         L76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r+xKOhdMA1on92kbEEKP0BNxlH6D+StiiYHuqe3PS7E=;
        b=U0MXTjmxPSbewo/LQRB82FaWmo72RHh989TXxNh6L57VLw+cEzubjkNXUV11kROa0l
         JF6b70RQmGAC9nyNMzYQEMFk5p9n6DB2xHJbn3pUnaIY08LUKRjMJVMQ+h3D6KBHNZKR
         njrMmxjX903+dRMF7v+fgFBaVNblMSTRiditwNKm0Vv5wgfEeX0EjDnDn0sJq9tMZVsN
         MJMdRQngUYOEwcwfYPpVQjpifiBcQhssQVp1F3a0zNK6ZWJYGx9bFlX8JzSqUbg6OyZM
         B7FWAJY+W74o4IczYbR90wiWS7gI1Fe8cG/9dapP3KmRwy+bp0LXlF5N7cFLEL6RSYsC
         4Ofw==
X-Gm-Message-State: APjAAAV362r2AXoa/T7d11CNYdO0kLLLVXhqcSEW938vodclv/Fc/Ueg
        YsIr85Q8ag6Qjj/llMDQqVYtf4JTds0ROa3cdBPKbg==
X-Google-Smtp-Source: APXvYqz6qyYDQ4CuceyNSv7EvRaH7x37CRsVEM8yZN5IDuxinqyEXM66YXrk94X5KDZZTl7qwpJzV/YlTpIg8TFg/Pw=
X-Received: by 2002:a6b:8d92:: with SMTP id p140mr31430212iod.144.1559909223529;
 Fri, 07 Jun 2019 05:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190524160340.169521-12-edumazet@google.com> <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au> <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au> <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
 <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au> <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
 <20190531162945.GA600@andrea> <CANn89iLJAM8kB8ySk2hDReewbL3AqrcEZb8Zf64=mj-cda=onA@mail.gmail.com>
In-Reply-To: <CANn89iLJAM8kB8ySk2hDReewbL3AqrcEZb8Zf64=mj-cda=onA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 7 Jun 2019 14:06:52 +0200
Message-ID: <CACT4Y+bgHHS35oCkkNV1oFHy+iKpfYt6TbfiSdDnu5rTqtzSFw@mail.gmail.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary smp_store_release/READ_ONCE
To:     Eric Dumazet <edumazet@google.com>
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 7:11 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 31, 2019 at 9:29 AM Andrea Parri
> <andrea.parri@amarulasolutions.com> wrote:
> >
> > On Fri, May 31, 2019 at 08:45:47AM -0700, Eric Dumazet wrote:
> > > On 5/31/19 7:45 AM, Herbert Xu wrote:
> >
> > > > In this case the code doesn't need them because an implicit
> > > > barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
> > > > exists in both places.
> >
> >
> > > I have already explained that the READ_ONCE() was a leftover of the first version
> > > of the patch, that I refined later, adding correct (and slightly more complex) RCU
> > > barriers and rules.
> >
> > AFAICT, neither barrier() nor RCU synchronization can be used as
> > a replacement for {READ,WRITE}_ONCE() here (and in tons of other
> > different situations).  IOW, you might want to try harder.  ;-)
>
> At least the writer side is using queue_rcu_work() which implies many
> full memory barriers,
> it is not equivalent to a compiler barrier() :/
>
> David, Herbert, I really do not care, I want to move on fixing real
> bugs, not arguing with memory barriers experts.
>
> Lets add back the READ_ONCE() and be happy.

We will have get back to this later with LKMM and KTSAN.
