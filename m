Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCA91C4331
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgEDRq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729667AbgEDRq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:46:26 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE56C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:46:25 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id i27so9634285ota.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MjTATQ7LbIo2uv8z5dmlz6+xjDe7vQE3zrHBN2+KSWg=;
        b=Rhfv2M39Y7tql9Kp/HJaWMS4WYtH2AsqszK6HbGvnZbkFtJFi1bKu0VoXUQgqyNB31
         Ij0ES9lkjZIbH0hRDTo6KlIDKf93unJ8JQNGFfYmEHC+PuCp3a876fmjM7xRKFeB4Far
         U026UFVAQtDeDvLQZuZnwIXgTXVXtpJlEaksEpI4z9c2Xh90yZuYPVxqTeiHprPSYeKD
         xLtARysWy24kI0l56jyyeDq9f7zsYCKajtJwEB8sbQX6pMWHoNG0eEFU4PsBUhgmznDq
         eYj7TJw6Moy2Snp5zEaV1NPITS54j5gbGfgUmLnSmVSF67JlSyQJUXaEZpbspy9D/gm8
         Gjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MjTATQ7LbIo2uv8z5dmlz6+xjDe7vQE3zrHBN2+KSWg=;
        b=TbUOl0db856bpB2eET0J8DfGHecq+k3tlOa+54ajiI4F1Xow/2hN9Qj2wTmBsVYTWs
         AJFk9SZ5Jq7LpgKOqFfxtuz/k5JTVvC+gVGdnEjE6Ih4Qi0ZdHFsYfx74vFdA4pAcRbI
         JYH2H0Kje118o31h7OwAwlsJg00dqK2/cLEWpaw47Z1Afv5C0Px8KWMe2h7w3BAqJOz4
         yaGrI/o/Gg+RLSV/b7KKImF3YIGtlDNPWkeXFJvNwCB1JO7E1QYUEWW09dZy3iexkhmX
         L5gpseU0yeheiR9xpB2M6KdCyB6mU+OTDlpFF+km2ue2eIXz8kF7AmM3/adl8anl+gpY
         m0XQ==
X-Gm-Message-State: AGi0PuYjLJZc6RQfVGKzNfUvzb8JYjub/T/2bzE24rUF0nLDBVxExQOD
        wuITHsn9vWRPni8AYW+NJ5vB3ux+37cwZmRPatQe1brq
X-Google-Smtp-Source: APiQypJWz20W8ZlYaF2Od9GgRbf/GP72Yf3QBGWAHSTx8QDZxL+IuGsWSexEoEMM5L8N2/pP96Y9MlfycQy8p/v7Y8I=
X-Received: by 2002:a05:6830:1409:: with SMTP id v9mr756599otp.189.1588614385286;
 Mon, 04 May 2020 10:46:25 -0700 (PDT)
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
 <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com> <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com>
In-Reply-To: <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 4 May 2020 10:46:13 -0700
Message-ID: <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 5:40 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Wed, Apr 15, 2020 at 5:01 PM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> > > > > The problem is actually more complicated than I thought, although=
 it
> > > > > needs more work, below is the first pile of patches I have for yo=
u to
> > > > > test:
> > > > >
> > > > > https://github.com/congwang/linux/commits/qdisc_reset
> > > > >
> > > > > It is based on the latest net-next branch. Please let me know the=
 result.
> > > >
> > > > I have applied all the patches in your four commits to my custom 5.=
4.6
> > > > kernel source. There was no change in the amount of fq_codel_reset
> > > > calls. Tested on ifb, RJ45 and SFP+ interfaces.
> > >
> > > It is true my patches do not reduce the number of fq_codel_reset() ca=
lls,
> > > they are intended to reduce the CPU time spent in each fq_codel_reset=
().
> > >
> > > Can you measure this? Note, you do not have to add your own printk()
> > > any more, because my patches add a few tracepoints, especially for
> > > qdisc_reset(). So you can obtain the time by checking the timestamps
> > > of these trace events. Of course, you can also use perf trace like yo=
u
> > > did before.
> >
> > Sorry for delayed responses. We were moving to a new house so I didn't
> > have much time to test it. I've measured your pile of patches applied
> > vs unpatched kernel. Result is a little bit better, but it is only
> > about 1s faster. Results are here. Do you need any additional reports
> > or measurements of other interfaces?
> > https://github.com/zvalcav/tc-kernel/tree/master/20200415 I've
> > recompiled the kernel without printk which had some overhead too.
>
> Hello Cong,
>
> did you have any time to look at it further? I'm just asking since my
> boss wants me to give him some verdict. I've started to study eBPF and
> XDP in the meantime so we have an alternative in case there won't be a
> solution to this problem.

Sorry for the delay. I lost connection to my dev machine, I am trying
to setup this on my own laptop.

Regarding to your test result above, I think I saw some difference
on my side, I have no idea why you didn't see any difference. Please
let me collect the data once I setup the test environment shortly today.

Thanks!
