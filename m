Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777761D6C65
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgEQTf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:35:57 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44017C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:35:57 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id s139so1603078oos.1
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iv4Y8/o5egzRhCBh31xKdiplT7WXa20FNOa2hJ3YvWI=;
        b=MbPWHsZuMS0aGofE3MNEaXsWRXlnUuGl5myoKwvfsEX1N049JgGfhYXvsdW/OzF5+o
         tkYqg+oiHtKxOt9CTjXx4FbLf7kVUDd4VctGFkzgXU4LmDKeCIuW/mtVhhoIzjkvA5pf
         D1qbCDirX4/RLLyqflOLSB9pnOtpaFUaJP/1mv7FwVj4hh2XaUnppDbzvOjblsLw0xYv
         2K6sztiRbV9xfJbQ5t2l2UH41BBlrUSiLNXaKpyUvgAV6CqzsMsucsIRHY6mU/9oOnUx
         WVJjYt0veaCirYod8oeX9xpJveMIrA4Q6QoC+mGLFo0nX0t+h7eiZ2cYJpbcD+oqf2qH
         jJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iv4Y8/o5egzRhCBh31xKdiplT7WXa20FNOa2hJ3YvWI=;
        b=Rtct0Ub7XKm+bQyNBkcHs2+GFVXiQTOFiocLdJJ205UNx0K5F17HDAEp4ithlywWkp
         72RJaNVdvqzXNI0Wc/SfGvgD5OFm4ti5c9AJIP1EBDAKlVvE+B32U81JDptzBXT1PIo7
         BrbbeRnV9VgthcUtkgtWN1m4FQXPk5ELcd2uwUtwP8m6T1qQkXuRaj3S4pmWcq6/laVO
         WGhiRLLDbI84dJVZ8kPnskQn8ddKN5rcKr7abu7qgMe5bISXfsfFJ2+zkOrFn7SilFlJ
         pa/Q2s/nIkPj4zBf96UgZW5VdcN/8AdfeGFhT50r6mYIG0jBzsaUjocYWOqqrlJ5q998
         Y0dA==
X-Gm-Message-State: AOAM530dca0y5/v/VEZKaCC/8K7Xme/MdaBps/WJo+duiMC707uOkbGC
        pQI+4Uus8NQvZZ6SGd2DWQ2gJV8Fa0SUcjxHYzSsA+tt
X-Google-Smtp-Source: ABdhPJyO/CDjBZgQPxTQOt6ddSQVfI7kKiYkO7KG6fWFno2lQ1/MRNItuBFv/lmp6tZnBZjkPI2HHiijMAeAD8Qn0h0=
X-Received: by 2002:a4a:e702:: with SMTP id y2mr3139592oou.44.1589744155753;
 Sun, 17 May 2020 12:35:55 -0700 (PDT)
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
 <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com> <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com>
In-Reply-To: <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 17 May 2020 12:35:44 -0700
Message-ID: <CAM_iQpXR+MQHaR-ou6rR_NAz-4XhAWiLuSEYvvpVXyWqHBnc-w@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 6:59 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Thu, May 7, 2020 at 8:52 PM Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
> >
> > On Tue, May 5, 2020 at 1:46 AM V=C3=A1clav Zindulka
> > <vaclav.zindulka@tlapnet.cz> wrote:
> > >
> > > On Mon, May 4, 2020 at 7:46 PM Cong Wang <xiyou.wangcong@gmail.com> w=
rote:
> > > >
> > > > Sorry for the delay. I lost connection to my dev machine, I am tryi=
ng
> > > > to setup this on my own laptop.
> > >
> > > Sorry to hear that. I will gladly give you access to my testing
> > > machine where all this nasty stuff happens every time so you can test
> > > it in place. You can try everything there and have online results. I
> > > can give you access even to the IPMI console so you can switch the
> > > kernel during boot easily. I didn't notice this problem until the tim=
e
> > > of deployment. My prior testing machines were with metallic ethernet
> > > ports only so I didn't know about those problems earlier.
> >
> > Thanks for the offer! No worries, I setup a testing VM on my laptop.
>
> OK
>
> > > >
> > > > I tried to emulate your test case in my VM, here is the script I us=
e:
> > > >
> > > > =3D=3D=3D=3D
> > > > ip li set dev dummy0 up
> > > > tc qd add dev dummy0 root handle 1: htb default 1
> > > > for i in `seq 1 1000`
> > > > do
> > > >   tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1mbit ce=
il 1.5mbit
> > > >   tc qd add dev dummy0 parent 1:$i fq_codel
> > > > done
> > > >
> > > > time tc qd del dev dummy0 root
> > > > =3D=3D=3D=3D
> > > >
> > > > And this is the result:
> > > >
> > > >     Before my patch:
> > > >      real   0m0.488s
> > > >      user   0m0.000s
> > > >      sys    0m0.325s
> > > >
> > > >     After my patch:
> > > >      real   0m0.180s
> > > >      user   0m0.000s
> > > >      sys    0m0.132s
> > >
> > > My results with your test script.
> > >
> > > before patch:
> > > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > > real 1.63
> > > user 0.00
> > > sys 1.63
> > >
> > > after patch:
> > > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > > real 1.55
> > > user 0.00
> > > sys 1.54
> > >
> > > > This is an obvious improvement, so I have no idea why you didn't
> > > > catch any difference.
> > >
> > > We use hfsc instead of htb. I don't know whether it may cause any
> > > difference. I can provide you with my test scripts if necessary.
> >
> > Yeah, you can try to replace the htb with hfsc in my script,
> > I didn't spend time to figure out hfsc parameters.
>
> class add dev dummy0 parent 1:0 classid 1:$i hfsc ls m1 0 d 0 m2
> 13107200 ul m1 0 d 0 m2 13107200
>
> but it behaves the same as htb...
>
> > My point here is, if I can see the difference with merely 1000
> > tc classes, you should see a bigger difference with hundreds
> > of thousands classes in your setup. So, I don't know why you
> > saw a relatively smaller difference.
>
> I saw a relatively big difference. It was about 1.5s faster on my huge
> setup which is a lot. Yet maybe the problem is caused by something

What percentage? IIUC, without patch it took you about 11s, so
1.5s faster means 13% improvement for you?


> else? I thought about tx/rx queues. RJ45 ports have up to 4 tx and rx
> queues. SFP+ interfaces have much higher limits. 8 or even 64 possible
> queues. I've tried to increase the number of queues using ethtool from
> 4 to 8 and decreased to 2. But there was no difference. It was about
> 1.62 - 1.63 with an unpatched kernel and about 1.55 - 1.58 with your
> patches applied. I've tried it for ifb and RJ45 interfaces where it
> took about 0.02 - 0.03 with an unpatched kernel and 0.05 with your
> patches applied, which is strange, but it may be caused by the fact it
> was very fast even before.

That is odd. In fact, this is highly related to number of TX queues,
because the existing code resets the qdisc's once for each TX
queue, so the more TX queues you have, the more resets kernel
will do, that is the more time it will take.

I plan to address this later on top of the existing patches.

Thanks.
