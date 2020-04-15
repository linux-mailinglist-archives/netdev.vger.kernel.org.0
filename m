Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37B81AAB2C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgDOPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 11:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729634AbgDOPBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 11:01:14 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140FAC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:01:14 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id v38so164191qvf.6
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 08:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mNIp0Kdot9FDRrFvUr4+w9a30uBv7DsgDCQSVOvqmEk=;
        b=Khe1JGR6/j2TJI37r4ihSPj0CSOtlouACt5LJxoDdbCiE/am43qGFvxFnJce+Vkv4j
         kyb0yBAzWWYvUcaL6WkLXmNV1qJLhT6B2tKqqsT9vvCQv3Ve8dz8Z7vm1av1LcEdP0fu
         D9VhUQEEiI4qjq6iKxKguuhgvP4iwGmkRT7fYzKnoiH/0JXv4L6FXfby3eVe6SBs06hW
         O9FFL7+afCr05YMLgENwIu8K+y6GZRVvX/YyR7xudqyf0j9bj2lYccA11IjmtMxtH9vO
         EeG9CHzeDNTcmgUQfp62i9syDapK5grdeKR3s7DP+XtSNQimlhlunVLQWW1tynFFpw3X
         KrEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mNIp0Kdot9FDRrFvUr4+w9a30uBv7DsgDCQSVOvqmEk=;
        b=Cy+5NabkJUlixSRnS0inOn/MzVBWvAF01eutEmASWlKOEfsgOLmK/n5M2K4YF/Q5tK
         wwI9hGBpYuw9VRi6UldTJGv7zMVCeLLLtmOIFdkMK3G++dCpBPed1Q6F+eMPXnrRwVrI
         uiRydKjREoVSvu95H0qQrJkVuorWSKej56rB1RLKdXnAXJZXxYx6fWY+3bbJdslHW/H3
         a3Zg4WTugbh1rhU9Vy3LClS7udyRmzwrGEqRH5nnwoiNk4a/i5aLSHGigD8OmA/+Gtfv
         WuWwiP+p/6kEYnfCNqxogtlZsyj8Pe8YLdrM98w4f31O41TU42+wVKlV/dAOOXCPoesB
         f3DA==
X-Gm-Message-State: AGi0PuYKa/wtUURc7EV0DdLpCwWK2NcNEE7+C/KG1G+r+soL9WT87HE+
        92wcsl2P8Mmh5V20pVVZWB922xs2V7hjQ1Xtp73+kw==
X-Google-Smtp-Source: APiQypKETDduT8D+7vnJ8GMxPaK6Hkwmy5etn1YQmS2ARVrw8rEOZpM3kJnUO30srYWQJFLdo5eUiYREXdJsx7ZxTvE=
X-Received: by 2002:a0c:c305:: with SMTP id f5mr5372473qvi.220.1586962873121;
 Wed, 15 Apr 2020 08:01:13 -0700 (PDT)
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
 <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com> <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Wed, 15 Apr 2020 17:01:01 +0200
Message-ID: <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 7:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Apr 12, 2020 at 1:18 PM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > On Wed, Apr 8, 2020 at 10:18 PM Cong Wang <xiyou.wangcong@gmail.com> wr=
ote:
> > >
> > > Hi, V=C3=A1clav
> >
> > Hello Cong,
> >
> > > Sorry for the delay.
> >
> > No problem, I'm actually glad you are diagnosing the problem further.
> > I didn't have much time until today and late yesterday to apply
> > patches and to test it.
> >
> > > The problem is actually more complicated than I thought, although it
> > > needs more work, below is the first pile of patches I have for you to
> > > test:
> > >
> > > https://github.com/congwang/linux/commits/qdisc_reset
> > >
> > > It is based on the latest net-next branch. Please let me know the res=
ult.
> >
> > I have applied all the patches in your four commits to my custom 5.4.6
> > kernel source. There was no change in the amount of fq_codel_reset
> > calls. Tested on ifb, RJ45 and SFP+ interfaces.
>
> It is true my patches do not reduce the number of fq_codel_reset() calls,
> they are intended to reduce the CPU time spent in each fq_codel_reset().
>
> Can you measure this? Note, you do not have to add your own printk()
> any more, because my patches add a few tracepoints, especially for
> qdisc_reset(). So you can obtain the time by checking the timestamps
> of these trace events. Of course, you can also use perf trace like you
> did before.

Sorry for delayed responses. We were moving to a new house so I didn't
have much time to test it. I've measured your pile of patches applied
vs unpatched kernel. Result is a little bit better, but it is only
about 1s faster. Results are here. Do you need any additional reports
or measurements of other interfaces?
https://github.com/zvalcav/tc-kernel/tree/master/20200415 I've
recompiled the kernel without printk which had some overhead too.
