Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29F32338DE
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgG3TT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730411AbgG3TT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:19:57 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16994C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:19:57 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e5so7183563qth.5
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o8Qcp6UYu/AwRpOfmT/2gGbG6QiB9KOv8ZsebKXGjxA=;
        b=O71muXcbjS+AQhdrYp3rP/Oq3wA2x0Bshh7svkdi7T5qIqpFrB4DAla8m+jgG139WM
         mu9h80gMcvvG3REpQ0xWeEBiLAEO9ouc7CHVvNy3LlbUO9w/VzRgVK7O0hesil0/uGPb
         XM2dhjX4TfvhczKFQNkcZRnOyn93pHQ/sHrDaLahetyY9oeD814+JNlGB9G4410sjJpR
         KiX4qdCJrtcUnuqbgHH/ZXql47zD/IdwPIth+qPs2VKdWBQp5JRO5u1lWW2ItF4OQ/+W
         g4LhmLIkvKXHjxy4m37HYkEqJ0cM4kg2xxRFz3anmFWDZky7WUjuZ6xy09UgeL4rxttF
         pb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o8Qcp6UYu/AwRpOfmT/2gGbG6QiB9KOv8ZsebKXGjxA=;
        b=nUR+g3C2bg2yDM7fi9o9CyLwztPw6fKW3ZqkDkPqfLuc1vo8TC1Zsa3XskuuWa77iv
         hU/llukC5PUDSBJ71dfo44ER/3A2CqeWxNawJ4wdSkM7LGRXgjD3d3KI1DOpRHpd37tS
         wnR3PaM0E1fo5ZZVw7WDw+0+eGPx1p12XpnIhUCC8Ag+DtopcPpwuuzl9Fpyx+TajCvX
         CgBjn29OA2+gp/7IaVYgxugt3woDnAZ2TbLYbcCFPBh3xVKhf2Ivv9qKGvB5vWmi2Z/L
         G1SjpSkkGC1MpCaV9K+FoTQ7/yTXJfYTdIW4LxiqSkicjs9uyLd3tgjA2nKWZpbZM5IE
         PqkQ==
X-Gm-Message-State: AOAM533SX5FJUYTKpEqbwmZREqH+VLdz31+NsAGFuGfLsabcDcvC2NG7
        RVl6Z7e1Yk0fJkwuuA41ok4GtDZllfK6Px1uEpW5XQ==
X-Google-Smtp-Source: ABdhPJxGY+3yiLfWMLQGFR+u0XpEd9XrA00TfNj19g9cW2Ub4rj5e+f6P4RueKWbKrI7OD2cX1nec7UeUiSPprga/hE=
X-Received: by 2002:ac8:7609:: with SMTP id t9mr210248qtq.158.1596136795878;
 Thu, 30 Jul 2020 12:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006f179d05ab8e2cf2@google.com> <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com>
 <87tuxqxhgq.fsf@intel.com> <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com>
 <87pn8cyk2b.fsf@intel.com>
In-Reply-To: <87pn8cyk2b.fsf@intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 30 Jul 2020 21:19:43 +0200
Message-ID: <CACT4Y+ZY-JnawN5Tmeh0+EfbsXgcv11QDiE-Lh2t8Cc3L1OEXg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogSU5GTzogcmN1IGRldGVjdGVkIHN0YWxsIGluIHRjX21vZGlmeV9xZA==?=
        =?UTF-8?B?aXNj?=
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 7:44 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> Dmitry Vyukov <dvyukov@google.com> writes:
>
> > On Wed, Jul 29, 2020 at 9:13 PM Vinicius Costa Gomes
> > <vinicius.gomes@intel.com> wrote:
> >>
> >> Hi,
> >>
> >> "Zhang, Qiang" <Qiang.Zhang@windriver.com> writes:
> >>
> >> > ________________________________________
> >> > =E5=8F=91=E4=BB=B6=E4=BA=BA: linux-kernel-owner@vger.kernel.org <lin=
ux-kernel-owner@vger.kernel.org> =E4=BB=A3=E8=A1=A8 syzbot <syzbot+9f78d5c6=
64a8c33f4cce@syzkaller.appspotmail.com>
> >> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B47=E6=9C=8829=E6=
=97=A5 13:53
> >> > =E6=94=B6=E4=BB=B6=E4=BA=BA: davem@davemloft.net; fweisbec@gmail.com=
; jhs@mojatatu.com; jiri@resnulli.us; linux-kernel@vger.kernel.org; mingo@k=
ernel.org; netdev@vger.kernel.org; syzkaller-bugs@googlegroups.com; tglx@li=
nutronix.de; vinicius.gomes@intel.com; xiyou.wangcong@gmail.com
> >> > =E4=B8=BB=E9=A2=98: INFO: rcu detected stall in tc_modify_qdisc
> >> >
> >> > Hello,
> >> >
> >> > syzbot found the following issue on:
> >> >
> >> > HEAD commit:    181964e6 fix a braino in cmsghdr_from_user_compat_to=
_kern()
> >> > git tree:       net
> >> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12925e38=
900000
> >> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df87a5e42=
32fdb267
> >> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D9f78d5c664=
a8c33f4cce
> >> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> >> > syz repro:
> >> > https://syzkaller.appspot.com/x/repro.syz?x=3D16587f8c900000
> >>
> >> It seems that syzkaller is generating an schedule with too small
> >> intervals (3ns in this case) which causes a hrtimer busy-loop which
> >> starves other kernel threads.
> >>
> >> We could put some limits on the interval when running in software mode=
,
> >> but I don't like this too much, because we are talking about users wit=
h
> >> CAP_NET_ADMIN and they have easier ways to do bad things to the system=
.
> >
> > Hi Vinicius,
> >
> > Could you explain why you don't like the argument if it's for CAP_NET_A=
DMIN?
> > Good code should check arguments regardless I think and it's useful to
> > protect root from, say, programming bugs rather than kill the machine
> > on any bug and misconfiguration. What am I missing?
>
> I admit that I am on the fence on that argument: do not let even root
> crash the system (the point that my code is crashing the system gives
> weight to this side) vs. root has great powers, they need to know what
> they are doing.
>
> The argument that I used to convince myself was: root can easily create
> a bunch of processes and give them the highest priority and do
> effectively the same thing as this issue, so I went with a the "they
> need to know what they are doing side".
>
> A bit more on the specifics here:
>
>   - Using a small interval size, is only a limitation of the taprio
>   software mode, when using hardware offloads (which I think most users
>   do), any interval size (supported by the hardware) can be used;
>
>   - Choosing a good lower limit for this seems kind of hard: something
>   below 1us would never work well, I think, but things 1us < x < 100us
>   will depend on the hardware/kernel config/system load, and this is the
>   range includes "useful" values for many systems.
>
> Perhaps a middle ground would be to impose a limit based on the link
> speed, the interval can never be smaller than the time it takes to send
> the minimum ethernet frame (for 1G links this would be ~480ns, should be
> enough to catch most programming mistakes). I am going to add this and
> see how it looks like.
>
> Sorry for the brain dump :-)
>
> >
> > Also are we talking about CAP_NET_ADMIN in a user ns as well
> > (effectively nobody)?
>
> Just checked, we are talking about CAP_NET_ADMIN in user namespace as
> well.

OK, so this is not root/admin, this is just any user.
