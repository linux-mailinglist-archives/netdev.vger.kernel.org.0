Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C151CB138
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgEHN7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHN7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 09:59:36 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C900DC05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 06:59:34 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id c4so246442qvi.6
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 06:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PPx0pe4LNZjaMeuOKW6YPLm3SaiMNuOYqFlNdlpXbfg=;
        b=adTUu4nNmDzGLMYkG7i7hNZuVfVRcutDdrhT0+Pr2J1o2etXNil4D+k/xyn5Xki3aU
         vTT5zquzBiMtVdhE6HSvlEbgjrgII4Fh6SXII/2iPINbct9ADUGzxobDgFSPV4Uu26xi
         7W7sPhbrP2/5thHr6n2BLhoexBk516ACjknDbMv72TMH2KQuTZPOcDUaswHD1hSLXU4R
         k62kvlcB99KRNZxpfdVnn9p/FS/XTsySfh/CDkcdSVcghR4AynWJea3usuRxJ3ZEAW3y
         Bf1ZuyTl/WHiyrwhyNVQw9LGqgb8Lcpc6VGTGGmq2V6iwbDNNiYJHiq7VmGvlLE+e5zk
         exnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PPx0pe4LNZjaMeuOKW6YPLm3SaiMNuOYqFlNdlpXbfg=;
        b=I6ObG+VbCUI0oFPC9AmBO6n9ICQkHwItBDEYtEQn/Y5PlswW2L0uj0xXjs25/S/LQT
         GBp+jAl8UQamLjhdXXkXfu+Xi8CcA5urpAdEFlTW4dN9ZWMrd/0/j51wtbCO9gezrAaj
         GFD+hD4GHijf7bB55hl48FF0ps2uOQ+VCcGtZp7n0rdTI5nIuoq++O4RrJ67BSFXpoBj
         ke2254s8Q+oxP0B6Re7VuvHpUbeF85FkD3ozl+1PUNHeqU0BqGhhip/svKbi/Fj06BMB
         lf1t9Na17tBH76TSd+P4vBWpQit0hI3KjP+5lfyUtk0XAjb0D8GiMEmuoPDSa7XhSpgz
         o6DA==
X-Gm-Message-State: AGi0Pub+wMe+/QcJ3NMeHlD612mjES4+7dGkrCq/DQXxu+4eARpLhg1S
        4akQn4jAAp+K9mRcIeT3Ai2z2UrHZKsabI5DEnN+Jg==
X-Google-Smtp-Source: APiQypLaOH0TpaHk+7AbSLVot8e+4MhVGaQW5MPQ5xxakc7+Ypw6uo+0rQ045DJjTw0WOuenmYyHmtiAmkou6pBHNTY=
X-Received: by 2002:a0c:f34b:: with SMTP id e11mr2931732qvm.76.1588946373950;
 Fri, 08 May 2020 06:59:33 -0700 (PDT)
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
 <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com> <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Fri, 8 May 2020 15:59:22 +0200
Message-ID: <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 8:52 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, May 5, 2020 at 1:46 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > On Mon, May 4, 2020 at 7:46 PM Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
> > >
> > > Sorry for the delay. I lost connection to my dev machine, I am trying
> > > to setup this on my own laptop.
> >
> > Sorry to hear that. I will gladly give you access to my testing
> > machine where all this nasty stuff happens every time so you can test
> > it in place. You can try everything there and have online results. I
> > can give you access even to the IPMI console so you can switch the
> > kernel during boot easily. I didn't notice this problem until the time
> > of deployment. My prior testing machines were with metallic ethernet
> > ports only so I didn't know about those problems earlier.
>
> Thanks for the offer! No worries, I setup a testing VM on my laptop.

OK

> > >
> > > I tried to emulate your test case in my VM, here is the script I use:
> > >
> > > =3D=3D=3D=3D
> > > ip li set dev dummy0 up
> > > tc qd add dev dummy0 root handle 1: htb default 1
> > > for i in `seq 1 1000`
> > > do
> > >   tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1mbit ceil=
 1.5mbit
> > >   tc qd add dev dummy0 parent 1:$i fq_codel
> > > done
> > >
> > > time tc qd del dev dummy0 root
> > > =3D=3D=3D=3D
> > >
> > > And this is the result:
> > >
> > >     Before my patch:
> > >      real   0m0.488s
> > >      user   0m0.000s
> > >      sys    0m0.325s
> > >
> > >     After my patch:
> > >      real   0m0.180s
> > >      user   0m0.000s
> > >      sys    0m0.132s
> >
> > My results with your test script.
> >
> > before patch:
> > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > real 1.63
> > user 0.00
> > sys 1.63
> >
> > after patch:
> > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > real 1.55
> > user 0.00
> > sys 1.54
> >
> > > This is an obvious improvement, so I have no idea why you didn't
> > > catch any difference.
> >
> > We use hfsc instead of htb. I don't know whether it may cause any
> > difference. I can provide you with my test scripts if necessary.
>
> Yeah, you can try to replace the htb with hfsc in my script,
> I didn't spend time to figure out hfsc parameters.

class add dev dummy0 parent 1:0 classid 1:$i hfsc ls m1 0 d 0 m2
13107200 ul m1 0 d 0 m2 13107200

but it behaves the same as htb...

> My point here is, if I can see the difference with merely 1000
> tc classes, you should see a bigger difference with hundreds
> of thousands classes in your setup. So, I don't know why you
> saw a relatively smaller difference.

I saw a relatively big difference. It was about 1.5s faster on my huge
setup which is a lot. Yet maybe the problem is caused by something
else? I thought about tx/rx queues. RJ45 ports have up to 4 tx and rx
queues. SFP+ interfaces have much higher limits. 8 or even 64 possible
queues. I've tried to increase the number of queues using ethtool from
4 to 8 and decreased to 2. But there was no difference. It was about
1.62 - 1.63 with an unpatched kernel and about 1.55 - 1.58 with your
patches applied. I've tried it for ifb and RJ45 interfaces where it
took about 0.02 - 0.03 with an unpatched kernel and 0.05 with your
patches applied, which is strange, but it may be caused by the fact it
was very fast even before.

I've commits c71c00df335f6aff00d3dc7f28e06dc8abc088a7,
13a5aec17cc65f6aa5c3bc470f504650bd465a69,
720cc6b0d12fb7c8a494e441ebd360c62023dad2,
51287a4bc6f2addd4a8c1919829aab3bb7c706c9 from
https://github.com/congwang/linux/commits/qdisc_reset applied on 5.4.6
kernel. I can apply them on the newest one if it can have any impact.
I hope I've applied the right patches and haven't missed any older
commits.

I've even tried to compile the kernel from your repository - branch
qdisc_reset. Times are a little bit lower than with patched 5.4.6.
1.52 - 1.53. Yet I still can't get to great improvement like you saw.

Thank you.
