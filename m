Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56581D91A0
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgESIEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgESIEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:04:30 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E99C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:04:30 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f83so13716439qke.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ocGXIwqORay17xst69UB6yvn1kgNBi9FzeC+D70pQfw=;
        b=EBAVRKyCxYoKRQLc2cgXYKN897DjzYZh4nKfbX4VSDWjA1TbjRR+ye4VnIVHe3gB9Y
         fbWxliFgIe47JZm04Y0WzT/qmQRFfVtRYCM/ZpRQtwPKI37Lq9GguJGe1dE+vZLd7j8N
         /6g7wTglZaFLuN8+HUl5sjqpDXU5ZyU52UicS8Tfgtxe/Qh3n51KORO0/6RrIZwiKmvw
         G8a3n+TBSqRGtIyJRL3h/skeNYJUAVHPRmhuILwViq/lfleDMB3ayeka/iVBVWMssNM7
         OCsaEL49qy4QlTFjkLNIz6klEZnRaQ/r/37MlXVH37UwC+II15cM6Cbqqk2fUk94WITn
         XVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ocGXIwqORay17xst69UB6yvn1kgNBi9FzeC+D70pQfw=;
        b=pAO5Cts5iqEWGrrHRmfHSOsuiLhfDCevilf8UnVtl6yOR6ybR9QfNvkoI16i2UUGoi
         gwSPxsvny3OzrUrG/j2kLacKfkPfJ9eTHoiN5Be0fxL71Nq9m7o9gl0QNUTPTD3zTDJC
         CtqhbfhSf8SmnlXcXNFJhw+S/SbHeU6EfbkGrMikTcNdtvmKltQa+LzgEWyQgtpQYJqV
         6z/aaI8iv2yVMaP430y2oVLwzjatnonu1JSlM41eQe3QLBfK0YTfMNZH+e6+gfhqJguS
         Qq7MU6RUv5OlraT/PJ5RrJRwUXII8bgGrbEcOtshc+o3D5N1zRTpx+Y1LGqttWfnstXR
         3Xhw==
X-Gm-Message-State: AOAM532oG6IMy7OhByH3+vaLScDvDCHknV67sA79VStvV/517sf8SkJV
        HVhLzoNqJj+8AaeV2LHHat11nrS7kVDbz3FJM7Kpe30nKUxPqw==
X-Google-Smtp-Source: ABdhPJxrr8dYO92uALrTLvV39gw4P6y8nio5oRLJIGvyT3JtKJ2Tr187foDdDC51cGokBAsKGZ/XbdSwme7ZyRHXRI4=
X-Received: by 2002:a37:bd45:: with SMTP id n66mr20113859qkf.108.1589875469248;
 Tue, 19 May 2020 01:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
 <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
 <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
 <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
 <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
 <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com>
 <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com>
 <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com>
 <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com>
 <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com>
 <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com>
 <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com>
 <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com>
 <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com>
 <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com>
 <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com>
 <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com>
 <CAM_iQpXR+MQHaR-ou6rR_NAz-4XhAWiLuSEYvvpVXyWqHBnc-w@mail.gmail.com>
 <CANxWus8AqCM4Dk87TTXB3xxtQPqPYjs-KmzVv8hjZwaAqg2AYQ@mail.gmail.com> <CAM_iQpWbjgT0rEkzd53aJ_z-WwErs3NWHeQZic+Vqn3TvFpA0A@mail.gmail.com>
In-Reply-To: <CAM_iQpWbjgT0rEkzd53aJ_z-WwErs3NWHeQZic+Vqn3TvFpA0A@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Tue, 19 May 2020 10:04:18 +0200
Message-ID: <CANxWus8GQ-YGKa24iQQJbWrDnkQB9BptM80P22n5OLCmDN+Myw@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 8:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, May 18, 2020 at 7:16 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > On Sun, May 17, 2020 at 9:35 PM Cong Wang <xiyou.wangcong@gmail.com> wr=
ote:
> > >
> > > On Fri, May 8, 2020 at 6:59 AM V=C3=A1clav Zindulka
> > > <vaclav.zindulka@tlapnet.cz> wrote:
> > > > > > >
> > > > > > > I tried to emulate your test case in my VM, here is the scrip=
t I use:
> > > > > > >
> > > > > > > =3D=3D=3D=3D
> > > > > > > ip li set dev dummy0 up
> > > > > > > tc qd add dev dummy0 root handle 1: htb default 1
> > > > > > > for i in `seq 1 1000`
> > > > > > > do
> > > > > > >   tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1m=
bit ceil 1.5mbit
> > > > > > >   tc qd add dev dummy0 parent 1:$i fq_codel
> > > > > > > done
> > > > > > >
> > > > > > > time tc qd del dev dummy0 root
> > > > > > > =3D=3D=3D=3D
> > > > > > >
> > > > > > > And this is the result:
> > > > > > >
> > > > > > >     Before my patch:
> > > > > > >      real   0m0.488s
> > > > > > >      user   0m0.000s
> > > > > > >      sys    0m0.325s
> > > > > > >
> > > > > > >     After my patch:
> > > > > > >      real   0m0.180s
> > > > > > >      user   0m0.000s
> > > > > > >      sys    0m0.132s
> > > > > >
> > > > > > My results with your test script.
> > > > > >
> > > > > > before patch:
> > > > > > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > > > > > real 1.63
> > > > > > user 0.00
> > > > > > sys 1.63
> > > > > >
> > > > > > after patch:
> > > > > > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > > > > > real 1.55
> > > > > > user 0.00
> > > > > > sys 1.54
> > > > > >
> > > > > > > This is an obvious improvement, so I have no idea why you did=
n't
> > > > > > > catch any difference.
> > > > > >
> > > > > > We use hfsc instead of htb. I don't know whether it may cause a=
ny
> > > > > > difference. I can provide you with my test scripts if necessary=
.
> > > > >
> > > > > Yeah, you can try to replace the htb with hfsc in my script,
> > > > > I didn't spend time to figure out hfsc parameters.
> > > >
> > > > class add dev dummy0 parent 1:0 classid 1:$i hfsc ls m1 0 d 0 m2
> > > > 13107200 ul m1 0 d 0 m2 13107200
> > > >
> > > > but it behaves the same as htb...
> > > >
> > > > > My point here is, if I can see the difference with merely 1000
> > > > > tc classes, you should see a bigger difference with hundreds
> > > > > of thousands classes in your setup. So, I don't know why you
> > > > > saw a relatively smaller difference.
> > > >
> > > > I saw a relatively big difference. It was about 1.5s faster on my h=
uge
> > > > setup which is a lot. Yet maybe the problem is caused by something
> > >
> > > What percentage? IIUC, without patch it took you about 11s, so
> > > 1.5s faster means 13% improvement for you?
> >
> > My whole setup needs 22.17 seconds to delete with an unpatched kernel.
> > With your patches applied it is 21.08. So it varies between 1 - 1.5s.
> > Improvement is about 5 - 6%.
>
> Good to know.
>
> >
> > > > else? I thought about tx/rx queues. RJ45 ports have up to 4 tx and =
rx
> > > > queues. SFP+ interfaces have much higher limits. 8 or even 64 possi=
ble
> > > > queues. I've tried to increase the number of queues using ethtool f=
rom
> > > > 4 to 8 and decreased to 2. But there was no difference. It was abou=
t
> > > > 1.62 - 1.63 with an unpatched kernel and about 1.55 - 1.58 with you=
r
> > > > patches applied. I've tried it for ifb and RJ45 interfaces where it
> > > > took about 0.02 - 0.03 with an unpatched kernel and 0.05 with your
> > > > patches applied, which is strange, but it may be caused by the fact=
 it
> > > > was very fast even before.
> > >
> > > That is odd. In fact, this is highly related to number of TX queues,
> > > because the existing code resets the qdisc's once for each TX
> > > queue, so the more TX queues you have, the more resets kernel
> > > will do, that is the more time it will take.
> >
> > Can't the problem be caused that reset is done on active and inactive
> > queues every time? It would explain why it had no effect in decreasing
> > and increasing the number of active queues. Yet it doesn't explain why
> > Intel card (82599ES) with 64 possible queues has exactly the same
> > problem as Mellanox (ConnectX-4 LX) with 8 possible queues.
>
> Regardless of these queues, the qdisc's should be only reset once,
> because all of these queues point to the same instance of root
> qdisc in your case.
>
> [...]
> > With the attached patch I'm down to 1.7 seconds - more than 90%
> > improvement :-) Can you please check it and pass it to proper places?
> > According to debugging printk messages it empties only active queues.
>
> You can't change netdev_for_each_tx_queue(), it would certainly at least
> break netif_alloc_netdev_queues().

You are right. I didn't check this. But that is the only one occurence
of netdev_for_each_tx_queue() except sch_generic.c. I've duplicated
netdev_for_each_tx_queue() to netdev_for_each_active_tx_queue() with
real_num_tx_queues in for loop and altered sch_generic.c where I
replaced all the occurences with the new function. From my point of
view it is easier to fix unnecessary excessive calls for unallocated
queues. Yet I totally understand your point of view which would mean a
cleaner approach. I'm more than happy with that small fix. I'll help
you test all the patches necessary yet our production will run on that
dirty fix. You know, my first kernel patch. :-D If you want I'll send
it to you.

>
> Let me think how to fix this properly, I have some ideas and will provide
> you some patch(es) to test soon.

Sure, I'll wait. I have plenty of time now with the main problem fixed :-)

Thank you.
