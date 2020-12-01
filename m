Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12742CAAFA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgLASoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbgLASoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:44:22 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D126C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 10:43:42 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o17so1520021pgm.18
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 10:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Zqw9lpSwsR7kPDX1Jjacq09r9Ug30GS0Gl5eBLkuT2c=;
        b=YIfAws+nj6lKhPC8KUFN1OKsgvopv9xuzbI3U5vJIPWXhkvGnExMhYA3Ntv8GkxTCX
         GhVhddUhCP6y+WeS27lKH8t5St6NJikfi3MXGZUtxWtd2FdqpJHwzgzIERdC60qPGOjI
         Kr3Pv9mZFhJWj0iTT/sk/5paaa/0LIwDS56x8xSltKICodfGJsus9x/2CZHCVv36Ec+Q
         SCMeDlbpmBLH+9ZQy/MQS7xGGvQ2VrCek8lQzYV3gaHVUfhVn/dOZQJas/JjBnegB0g1
         gpSUGZptNwibu25A2Z5DWLpoTjND0pBioI6xwSRK7jj0mQebOKwUIm/9XXuxLtldWqyA
         i43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Zqw9lpSwsR7kPDX1Jjacq09r9Ug30GS0Gl5eBLkuT2c=;
        b=RzlVKbSGDDwXQUXMCOqWmwIn84SIsEzohNb0cRv9nih3S9gXcQbV4td6NEuh0fmU7K
         UsyXKVIMX7XLZbUuBaOBOZQPcQjaIL8pRouoBgim5X7F57igvcsqgYTebRstr6j7iRA6
         zqit7xvJpfboVxKB0kDOI+pM0pYK2igMvGmse95f7N0G8sFMon6CJPIJMzHlBx0kOG/3
         pfZDaivsm0pNN6Y74d8PmZlae6FtPn2FILjjplNcPDWWqIwuijOK9UwQrRtZ/OLRLI0+
         BK3tB2y3shOkRa7HiaWlKB5FLQEAYjTZ80JQI6Z5hzSSl7L2M7N9tz0zF19CAo5Zncq8
         P5ow==
X-Gm-Message-State: AOAM530zoABBwY49a+LIqfJmbR7N0PNtYWiKdMaDXOPvRxGx1L9KgxXd
        NNZIg5oiXQDz0wbWbB1ffD8Iyy0=
X-Google-Smtp-Source: ABdhPJyimm007+9lR3Ncvpa8upBMIJw6nWTKfPx1g6wzADhX7DYAys9UwoicIT/EduC9/j3DGcMjN5Y=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:90a:17a4:: with SMTP id
 q33mr422155pja.0.1606848221305; Tue, 01 Dec 2020 10:43:41 -0800 (PST)
Date:   Tue, 1 Dec 2020 10:43:39 -0800
In-Reply-To: <20201130230242.GA73546@rdna-mbp>
Message-Id: <20201201184339.GB553169@google.com>
Mime-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com> <20201118001742.85005-3-sdf@google.com>
 <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com>
 <20201130010559.GA1991@rdna-mbp> <20201130163813.GA553169@google.com> <20201130230242.GA73546@rdna-mbp>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
From:   sdf@google.com
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30, Andrey Ignatov wrote:
> sdf@google.com <sdf@google.com> [Mon, 2020-11-30 08:38 -0800]:
> > On 11/29, Andrey Ignatov wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> [Tue, 2020-11-17  
> 20:05
> > > -0800]:
> > > > On Tue, Nov 17, 2020 at 4:17 PM Stanislav Fomichev <sdf@google.com>
> > > wrote:
> > [..]
> > > >
> > > > I think it is ok, but I need to go through the locking paths more.
> > > > Andrey,
> > > > please take a look as well.
> >
> > > Sorry for delay, I was offline for the last two weeks.
> > No worries, I was OOO myself last week, thanks for the feedback!
> >
> > >  From the correctness perspective it looks fine to me.
> >
> > >  From the performance perspective I can think of one relevant  
> scenario.
> > > Quite common use-case in applications is to use bind(2) not before
> > > listen(2) but before connect(2) for client sockets so that connection
> > > can be set up from specific source IP and, optionally, port.
> >
> > > Binding to both IP and port case is not interesting since it's already
> > > slow due to get_port().
> >
> > > But some applications do care about connection setup performance and  
> at
> > > the same time need to set source IP only (no port). In this case they
> > > use IP_BIND_ADDRESS_NO_PORT socket option, what makes bind(2) fast
> > > (we've discussed it with Stanislav earlier in [0]).
> >
> > > I can imagine some pathological case when an application sets up tons  
> of
> > > connections with bind(2) before connect(2) for sockets with
> > > IP_BIND_ADDRESS_NO_PORT enabled (that by itself requires setsockopt(2)
> > > though, i.e. socket lock/unlock) and that another lock/unlock to run
> > > bind hook may add some overhead. Though I do not know how critical  
> that
> > > overhead may be and whether it's worth to benchmark or not (maybe too
> > > much paranoia).
> >
> > > [0] https://lore.kernel.org/bpf/20200505182010.GB55644@rdna-mbp/
> > Even in case of IP_BIND_ADDRESS_NO_PORT, inet[6]_bind() does
> > lock_sock down the line, so it's not like we are switching
> > a lockless path to the one with the lock, right?

> Right, I understand that it's going from one lock/unlock to two (not
> from zero to one), that's what I meant by "another". My point was about
> this one more lock.

> > And in this case, similar to listen, the socket is still uncontended and
> > owned by the userspace. So that extra lock/unlock should be cheap
> > enough to be ignored (spin_lock_bh on the warm cache line).
> >
> > Am I missing something?

> As I mentioned it may come up only in "pathological case" what is
> probably fine to ignore, i.e. I'd rather agree with "cheap enough to be
> ignored" and benchmark would likely confirm it, I just couldn't say that
> for sure w/o numbers so brought this point.

> Given that we both agree that it should be fine to ignore this +1 lock,
> IMO it should be good to go unless someone else has objections.
Thanks, agreed. Do you mind giving it an acked-by so it gets some
attention in the patchwork? ;-)
