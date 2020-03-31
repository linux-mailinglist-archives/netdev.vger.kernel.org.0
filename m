Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EF61996C3
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbgCaMqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 08:46:14 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41253 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730742AbgCaMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 08:46:14 -0400
Received: by mail-qk1-f195.google.com with SMTP id q188so22734381qke.8
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 05:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nfaqgGEWFYgGX2gzXoxYE0BXb10XcZCgKGgC1DixpFk=;
        b=Ozdk8i6EuyQIkmcjZBcXBWrKoiOqDeFd1is9FB2PT8Gy38S1/em6FWO6RHpaXswLny
         4414HUTonyGSns/1RhP+cic7mRHY2F0JgxbsIp6vuhKZP4tswvJnFhDm1IEiD7qX6vLL
         NsFITB431crvN2Y9xAlVslLQ37sAxhRFWSF5c0vkKzFEXMDH1p4fV/jSy1ixrSY4LQFY
         li5C7Y4kNWRaztYti00LmwxwkO5LQULwzgqdgn+V+IRGxVNHjMCIsjdgdhoPxWhDWNeO
         2YxNykGFS7eAcyEMa+kfZuMNyCvgATEEOGo+5V5RKlLHthdhH+77FsrUPlnrOvHa3tgm
         dQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nfaqgGEWFYgGX2gzXoxYE0BXb10XcZCgKGgC1DixpFk=;
        b=A7cBbMpG9k3GJmcYDg8ov/XenVZmOKcK/k/Pee66SFt/MNwRhm50ZDFKKZcKvdaLRO
         fMWVI9pGiMQhW4lk/DsR31mQjKfS4EFvV3IHKCqvwRohbt8+kmZHMDt4ls3C3dfRbWx1
         ErGt5vQnsB8Ij/+xQHjHM6kGuHrRYb1i+yO2QROS9wex7olb2CNEOQk27cDsWpmkc3qe
         a0kqm/2tOd+zXXergHeOj8v5savqtYlbf0mveccc40e8SSppPhhenjTNMBOUPSy7sOgu
         kyTsfBn78n082E7Yr9pkl6jOXGFCPBjF8pYNI2wxitA60S3c7IaFPDQT9rEXbDQjzU9O
         LurQ==
X-Gm-Message-State: ANhLgQ1i2zCSl7bCY8mLT0Qvpn/H6zsHksFOzcVJC3uXYOfNYmfVcXZ/
        hmZyn64+ETeeA/rF/OtTHzRwTbkhoqHl+OsTBiqEea11kLM=
X-Google-Smtp-Source: ADFU+vvmpT0CM1O2QUTIYCYkUcQC+n4i3LKFxI9ddPzhOKyCr46Pcg/TpqK7eN9uf+f5obQGM1FRnvEXIawuyHNxPns=
X-Received: by 2002:a37:9e05:: with SMTP id h5mr4526562qke.71.1585658772930;
 Tue, 31 Mar 2020 05:46:12 -0700 (PDT)
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
 <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com> <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com>
In-Reply-To: <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Tue, 31 Mar 2020 14:46:01 +0200
Message-ID: <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 8:00 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Mar 28, 2020 at 6:04 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > On Fri, Mar 27, 2020 at 11:35 AM V=C3=A1clav Zindulka
> > <vaclav.zindulka@tlapnet.cz> wrote:
> > >
> > > Your assumption is not totally wrong. I have added some printks into
> > > fq_codel_reset() function. Final passes during deletion are processed
> > > in the if condition you added in the patch - 13706. Yet the rest and
> > > most of them go through regular routine - 1768074. 1024 is value of i
> > > in for loop.
> >
> > Ok, so I went through the kernel source a little bit. I've found out
> > that dev_deactivate is called only for interfaces that are up. My bad
> > I forgot that after deactivation of my daemon ifb interfaces are set
> > to down. Nevertheless after setting it up and doing perf record on
> > ifb0 numbers are much lower anyway. 13706 exits through your condition
> > added in patch. 41118 regular exits. I've uploaded perf report here
> > https://github.com/zvalcav/tc-kernel/tree/master/20200328
> >
> > I've also tried this on metallic interface on different server which
> > has a link on it. There were 39651 patch exits. And 286412 regular
> > exits. It is more than ifb interface, yet it is way less than sfp+
> > interface and behaves correctly.
>
> Interesting, at the point of dev_deactivate() is called, the refcnt
> should not be zero, it should be at least 1, so my patch should
> not affect dev_deactivate(), it does affect the last qdisc_put()
> after it.
>
> Of course, my intention is indeed to eliminate all of the
> unnecessary memset() in the ->reset() before ->destroy().
> I will provide you a complete patch tomorrow if you can test
> it, which should improve hfsc_reset() too.
>
> Thanks.

Sure, I'll test it and I'm looking forward to it. :-)

Thank you for all your help and effort. I appreciate it a lot.
