Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4E195562
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgC0KgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:36:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33948 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgC0KgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:36:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id i6so10248423qke.1
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 03:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QckHBuB68RrVVhfXltDf1r8wvcPLyBHCsO+97jbVAtc=;
        b=Ht+4OxBFVTk3+fPxBZjgNWMaCvJ//J2zGMHkgkOSaX8HJ2u3oQnMCHgb+KOjlLXTlY
         eMR78/hiLXL009vB6UjuZ0e+GdU2DzsclqPppwtuo8klgbJ76IPxXM7Fq/eeJFKrlU+U
         K+SPVi9F4NVFKIFcJKqqHerF98OJEU2xPTy0HxuQFufsM9s0MeAcZg6vrGYzgjnq9qSw
         0l6aNSrs9VY6jNi9Bdpa9DBgqyR7JRr1A8jW5qyFsshgelyETjEEZCg4MTdwdMRN3mfK
         bE4B3oMr7bu/dTvEVr2lGiJpGCoHiJWd4C1j5SMVMBAtC3RlpoIHvqHHl10pDVsKo0Vz
         lijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QckHBuB68RrVVhfXltDf1r8wvcPLyBHCsO+97jbVAtc=;
        b=QivM3SuF6NnLB6/UsLePEdcKeI1PXr3C46+0KY+m2AbbDSwmGFe7f7ohT2iencFlF8
         uHVGV0KkA1LkHMS/IHydu30tVqsNMvZc6TnSWjgS9Tk1inls9+n0vl1Pl/OPoH49TN+F
         K7ymeWciSqU/xd2t3zIM8oPh35fW0D52B0Lch9mFU2UiyEur52P5o25X/EF+yJXW7wiU
         M+zt6E5cZObaoSGCc8McZ9vlnVRLhrgxMk7ngzF7BEzW4GEJQP856QgcG+Rq27m4NYMj
         o1hmAQE1tIg7cZ7gXh2n7PkoGjPSZKhBCy0OdYroG39x0K4GLysACNYHZ+eXyoXsiIRZ
         DlPw==
X-Gm-Message-State: ANhLgQ0DnTd74W09GikbnfOtegCluM4+71eNbw4qX95pxi1rwqtMlpq4
        o+oi2eqESxareAP5hbOs66BkBv/yLq7xXCryRI9/2Q==
X-Google-Smtp-Source: ADFU+vud0EKotcFAaoUF2mWvAa8/bDI3Zkv0y78MoBcPHCJ3fXQs66QIaxEAXnLmO0HaBbPPeBH9AsYBZcXYwszsMEw=
X-Received: by 2002:a37:9cd:: with SMTP id 196mr12954469qkj.157.1585305367275;
 Fri, 27 Mar 2020 03:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
 <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com> <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
In-Reply-To: <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Fri, 27 Mar 2020 11:35:56 +0100
Message-ID: <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 6:38 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
>Are the stack traces captured by perf any different with unpatched?

I've compared initial perf reports. There is difference in call stack
between sfp+ interfaces vs ifb and metallic interfaces. While ifb and
metallic interfaces have normal behavior on sfp+ interfaces the call
stack is different. I've added perf record of eno1 metallic interface
here https://github.com/zvalcav/tc-kernel/tree/master/20200325/Intel-82599E=
S
so you can compare the behavior of all of them. I've also added perf
report of patched kernel.

--100.00%--entry_SYSCALL_64_after_hwframe
          do_syscall_64
          __sys_sendmsg
          ___sys_sendmsg
          ____sys_sendmsg
          sock_sendmsg
          netlink_sendmsg
          netlink_unicast
          netlink_rcv_skb
                                   <-- call stack is similar to other
interfaces
          |
           --99.98%--rtnetlink_rcv_msg
                     tc_get_qdisc
                     qdisc_graft
                                      <-- call stack splits in this
function - dev_deactivate is called only on sfp+ interfaces
                     |
                     |--98.36%--dev_deactivate
                              <-- 98% calls of fq_codel_reset()
function are done here. These must be the excessive calls - see below.
                     |          dev_deactivate_many
                     |          |
                     |          |--49.28%--dev_deactivate_queue.constprop.5=
7
                     |          |          |
                     |          |           --49.27%--qdisc_reset
                     |          |                     hfsc_reset_qdisc
                     |          |                     |
                     |          |                      --48.69%--qdisc_rese=
t
                     |          |                                |
                     |          |
--47.23%--fq_codel_reset             <-- half of excessive function
calls come from here
                     |          |                                          =
 |
                     |          |
     |--3.20%--codel_vars_init
                     |          |                                          =
 |
                     |          |
     |--1.64%--rtnl_kfree_skbs
                     |          |                                          =
 |
                     |          |
      --0.81%--memset_erms
                     |          |
                     |           --49.08%--qdisc_reset
                     |                     hfsc_reset_qdisc
                     |                     |
                     |                      --48.53%--qdisc_reset
                     |                                |
                     |
--47.09%--fq_codel_reset                       <-- other half of
excessive function calls come from here
                     |                                           |
                     |
|--2.90%--codel_vars_init
                     |                                           |
                     |
|--1.61%--rtnl_kfree_skbs
                     |                                           |
                     |
--0.82%--memset_erms
                     |
                      --1.62%--qdisc_destroy
                               <-- here are remaining, (I suppose)
regular calls. Call stack is similar to other interfaces here.
                                |
                                |--0.86%--hfsc_destroy_qdisc
                                |          |
                                |           --0.82%--hfsc_destroy_class
                                |                     |
                                |                      --0.81%--qdisc_destr=
oy
                                |                                |
                                |
--0.72%--fq_codel_reset
                                |
                                 --0.77%--hfsc_reset_qdisc
                                           |
                                            --0.75%--qdisc_reset
                                                      |
                                                       --0.70%--fq_codel_re=
set

> On Thu, Mar 26, 2020 at 10:07 AM Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
> >
> > On Thu, Mar 26, 2020 at 7:24 AM V=C3=A1clav Zindulka
> > <vaclav.zindulka@tlapnet.cz> wrote:
> > >
> > > > On Wed, Mar 25, 2020 at 6:43 PM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
> > > > > Are you able to test an experimental patch attached in this email=
?
> > > >
> > > > Sure. I'll compile new kernel tomorrow. Thank you for quick patch.
> > > > I'll let you know as soon as I have anything.
> > >
> > > I've compiled kernel with the patch you provided and tested it.
> > > However the problem is not solved. It behaves exactly the same way.
> > > I'm trying to put some printk into the fq_codel_reset() to test it
> > > more.
> >
> > Are the stack traces captured by perf any different with unpatched?
>
> Wait, it seems my assumption of refcnt=3D=3D0 is wrong even for deletion,
> in qdisc_graft() the last refcnt is put after dev_deactivate()...

Your assumption is not totally wrong. I have added some printks into
fq_codel_reset() function. Final passes during deletion are processed
in the if condition you added in the patch - 13706. Yet the rest and
most of them go through regular routine - 1768074. 1024 is value of i
in for loop.

But the most significant problem is that fq_codel_reset() function is
processed too many times. According to kern.log it was being processed
about 77 000 times per second for almost 24 seconds. It was over 1.7
million passes during rules deletion.

Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791176] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791184] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791192] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791199] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791207] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791214] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791221] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791228] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791236] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791243] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791251] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791258] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791266] Function
fq_codel_reset - regular exit - passes: 1024
Mar 26 15:26:23 shaperd-prelouc1-dev kernel: [  110.791273] Function
fq_codel_reset - regular exit - passes: 1024

Here is another 1.7 million of lines... Function doesn't take much
time according to timestamp but it is being called way too many times.

Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017811] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017823] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017836] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017849] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017862] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017874] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 15:26:46 shaperd-prelouc1-dev kernel: [  134.017886] Function
fq_codel_reset - patch exit - passes: 1024
Mar 26 21:05:54 shaperd-prelouc1-dev kernel: [  134.017899] Function
fq_codel_reset - patch exit - passes: 1024

>
> Let me think about how we could distinguish this case from other
> reset cases.

As above, the problem is most probably in excessive calls of
fq_codel_reset(). I'm not surprised it freezes whole server or network
adapter.

Thank you
