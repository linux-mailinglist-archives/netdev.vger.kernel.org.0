Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF81D7ADC
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgEROQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 10:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgEROQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:16:51 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E943C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:16:50 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id c24so8145911qtw.7
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEufxHro/U0BeUthE5FzPld1eQ9zNAA+DMVMxeZKT+8=;
        b=ZGeiG5OJ2Bz/lnrJnqTZ7H+2FU2FksP92iADpiCmM6/FKAJuukpt4f9B8C5hqVkFdn
         ZQm9rNtRdYLWIHB/kQHkBhuQMwNtSquaBnSfmxgfoOODy/PgwlD+dVq8OQa5MbjtlJ/v
         w4SVrBX0TKEfV+IyZNl3fy+1+jmGUgq21ezG1xV/zfX87SZ7y60wjBZSklPWota6pVHt
         uYDnZIhIMdK3rofT7A/7SMHRWV8FDC9ll+9YkQpLntoLT7wnYa6JTMYQyzjbc8XNPWgq
         xbMo6p+QpOvwJPKiXMXjbtP1RYMkQMptmY0Zw20W81zxdh8CFHpQ7DzWYygCBD50rsTs
         +FJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEufxHro/U0BeUthE5FzPld1eQ9zNAA+DMVMxeZKT+8=;
        b=juR8TJWs5eQcx5P6YMxWNME9v/URblxIcTTqe8GjQp7gSIXbcaUnyK7NLlEVLJ+gbu
         02rXmeXRcktbKEj9v7bxthP8XH0IGt7Om+lYUnbErEhppsrOZ8A3O8OEQjC3DDF4N/qL
         L1w5k6gq31eQ15DN9H4BKNLyomUUJPcl9LPzodTXH+1dSkvP2gmIwrzgjdk2l1vACZM8
         kCcAw6G4wswHGUbxv4QjSkw6gh2drLHnYveL2WqOOtBZD6+m4C9tkOuzt4iJ48qbsH3y
         FGlnFox8G+vMxSdLgPiNrXPaC6NfmIdL9I58UK50d3kWY88WJ0DvqUh3I3FhdcArP5W4
         kruQ==
X-Gm-Message-State: AOAM533DTgADlivqmW1swnrfMnjM1SbsYU/HaeMDWdTHK3iHbxyiYgmn
        UT7zpHj4zPSjoMOLwx3FZjv5IvInJhT8ZdEyROymTQ==
X-Google-Smtp-Source: ABdhPJzlj6OCKsSAy1/MX/895X24MRMD2MLKifWr01ftuHySS4iuJqlPSgakW43HeAtwxlSK+kERYbSurAlhkJoVNuk=
X-Received: by 2002:ac8:4987:: with SMTP id f7mr16195065qtq.160.1589811409609;
 Mon, 18 May 2020 07:16:49 -0700 (PDT)
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
 <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com> <CAM_iQpXR+MQHaR-ou6rR_NAz-4XhAWiLuSEYvvpVXyWqHBnc-w@mail.gmail.com>
In-Reply-To: <CAM_iQpXR+MQHaR-ou6rR_NAz-4XhAWiLuSEYvvpVXyWqHBnc-w@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Mon, 18 May 2020 16:16:38 +0200
Message-ID: <CANxWus8AqCM4Dk87TTXB3xxtQPqPYjs-KmzVv8hjZwaAqg2AYQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000054a02205a5ecd058"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000054a02205a5ecd058
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 17, 2020 at 9:35 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, May 8, 2020 at 6:59 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> > > > >
> > > > > I tried to emulate your test case in my VM, here is the script I =
use:
> > > > >
> > > > > =3D=3D=3D=3D
> > > > > ip li set dev dummy0 up
> > > > > tc qd add dev dummy0 root handle 1: htb default 1
> > > > > for i in `seq 1 1000`
> > > > > do
> > > > >   tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1mbit =
ceil 1.5mbit
> > > > >   tc qd add dev dummy0 parent 1:$i fq_codel
> > > > > done
> > > > >
> > > > > time tc qd del dev dummy0 root
> > > > > =3D=3D=3D=3D
> > > > >
> > > > > And this is the result:
> > > > >
> > > > >     Before my patch:
> > > > >      real   0m0.488s
> > > > >      user   0m0.000s
> > > > >      sys    0m0.325s
> > > > >
> > > > >     After my patch:
> > > > >      real   0m0.180s
> > > > >      user   0m0.000s
> > > > >      sys    0m0.132s
> > > >
> > > > My results with your test script.
> > > >
> > > > before patch:
> > > > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > > > real 1.63
> > > > user 0.00
> > > > sys 1.63
> > > >
> > > > after patch:
> > > > /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> > > > real 1.55
> > > > user 0.00
> > > > sys 1.54
> > > >
> > > > > This is an obvious improvement, so I have no idea why you didn't
> > > > > catch any difference.
> > > >
> > > > We use hfsc instead of htb. I don't know whether it may cause any
> > > > difference. I can provide you with my test scripts if necessary.
> > >
> > > Yeah, you can try to replace the htb with hfsc in my script,
> > > I didn't spend time to figure out hfsc parameters.
> >
> > class add dev dummy0 parent 1:0 classid 1:$i hfsc ls m1 0 d 0 m2
> > 13107200 ul m1 0 d 0 m2 13107200
> >
> > but it behaves the same as htb...
> >
> > > My point here is, if I can see the difference with merely 1000
> > > tc classes, you should see a bigger difference with hundreds
> > > of thousands classes in your setup. So, I don't know why you
> > > saw a relatively smaller difference.
> >
> > I saw a relatively big difference. It was about 1.5s faster on my huge
> > setup which is a lot. Yet maybe the problem is caused by something
>
> What percentage? IIUC, without patch it took you about 11s, so
> 1.5s faster means 13% improvement for you?

My whole setup needs 22.17 seconds to delete with an unpatched kernel.
With your patches applied it is 21.08. So it varies between 1 - 1.5s.
Improvement is about 5 - 6%.

> > else? I thought about tx/rx queues. RJ45 ports have up to 4 tx and rx
> > queues. SFP+ interfaces have much higher limits. 8 or even 64 possible
> > queues. I've tried to increase the number of queues using ethtool from
> > 4 to 8 and decreased to 2. But there was no difference. It was about
> > 1.62 - 1.63 with an unpatched kernel and about 1.55 - 1.58 with your
> > patches applied. I've tried it for ifb and RJ45 interfaces where it
> > took about 0.02 - 0.03 with an unpatched kernel and 0.05 with your
> > patches applied, which is strange, but it may be caused by the fact it
> > was very fast even before.
>
> That is odd. In fact, this is highly related to number of TX queues,
> because the existing code resets the qdisc's once for each TX
> queue, so the more TX queues you have, the more resets kernel
> will do, that is the more time it will take.

Can't the problem be caused that reset is done on active and inactive
queues every time? It would explain why it had no effect in decreasing
and increasing the number of active queues. Yet it doesn't explain why
Intel card (82599ES) with 64 possible queues has exactly the same
problem as Mellanox (ConnectX-4 LX) with 8 possible queues.

I've been playing with this problem today. Every deleted fq_codel
qdisc, root and non root, requires a network adapter to empty all
possible queues. But not just the active ones, but it cleared all
possible queues. Event those the adapter can't even use. For every
SFP+ I have tested it calls fq_codel_reset() and would call any other
reset function. 64 times for egress qdisc and 64 times for ingress
qdisc. Even when ingress is not defined. Solution to this whole
problem would be to let reset only activated queues. On the RJ45
interface I've tested there are 8 possible queues. So the reset is
done 8 times for every deleted qdisc. 16 in total, since ingress and
egress are processed all the time.

So a little bit of calculation. My initial setup contained 13706 qdisc
rules. For ifb it means 13706 for egress and 13706 for ingress. 27412
reset calls because there can be only one transmit queue for the ifb
interface. Average time spent between fq_codel_reset() according to my
initial perf reports is somewhat between 7 - 16 micro seconds. 27412 *
0.000008 =3D 0.219296 s. For RJ45 interface it does 8 calls for every
qdisc. 13706 * 8 * 2 =3D 219296 resets. 219296 * 0.000008 =3D 1.754368 s.
It is still ok. For SFP+ interface it is 64 resets per qdisc rule.
13706 * 64 * 2 =3D 1754368. So we are very close to the huge number I
noticed initially using printk. And now 1754368 * 0.000008 =3D
14.034944s. In case of slowest calls 1754368 * 0.000016 =3D 28.069888.
Woala. Gotcha. So my final judgement is - don't empty something we
don't use anyway. For Intel it may be reasonable, it can have all 64
queues defined. Mellanox has its limit at 8. But it still is being
reset 64 times. We mostly decrease the number of queues to 4.
Sometimes 2 according to the CPU used. Yet every CPU had to handle 64
resets.

With the attached patch I'm down to 1.7 seconds - more than 90%
improvement :-) Can you please check it and pass it to proper places?
According to debugging printk messages it empties only active queues.

Thank you for all your help and effort.


>
> I plan to address this later on top of the existing patches.
>
> Thanks.

--00000000000054a02205a5ecd058
Content-Type: text/x-patch; charset="US-ASCII"; name="netdevice_num_tx_queues.patch"
Content-Disposition: attachment; filename="netdevice_num_tx_queues.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kacjv5cn0>
X-Attachment-Id: f_kacjv5cn0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmggYi9pbmNsdWRlL2xpbnV4L25l
dGRldmljZS5oCi0tLSBhL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgKKysrIGIvaW5jbHVkZS9s
aW51eC9uZXRkZXZpY2UuaApAQCAtMjEzNSw3ICsyMTM1LDcgQEAKIHsKIAl1bnNpZ25lZCBpbnQg
aTsKIAotCWZvciAoaSA9IDA7IGkgPCBkZXYtPm51bV90eF9xdWV1ZXM7IGkrKykKKwlmb3IgKGkg
PSAwOyBpIDwgZGV2LT5yZWFsX251bV90eF9xdWV1ZXM7IGkrKykKIAkJZihkZXYsICZkZXYtPl90
eFtpXSwgYXJnKTsKIH0K
--00000000000054a02205a5ecd058--
