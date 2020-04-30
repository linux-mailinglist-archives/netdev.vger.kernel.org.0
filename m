Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E4C1BF851
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgD3MkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbgD3MkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:40:14 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1916C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 05:40:13 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id w18so2877585qvs.3
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 05:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SfIYKgPds4OejD3qxNFmtT7uVL/B8O59w3PXGuZWqkg=;
        b=GVOvIYH0wupNtVBqpZ/hh9wasQ580XNjGL2295E7+waOwpbIynXq+u6YMy68PJ6YmG
         N1ypEg5gu3mLyO6a0nRjzd/k/edYCJfWTsmI0W3SRKyRcLqlBHVb/gu6YM9byPQLXE22
         4w7D/KNesvYQVjXuf0Bfym5cBtivGRe4lIyR51kn5tL5Bnnlx2YAUsEVtHpGy/NZVVha
         B7dDRm6NjnpTWfeev6pOJ04cqrIIkI0F9sk3dw+Qq+Wdk97Ro6WjtmG0CuwpeqKQUC9O
         sT88iYIploJC0wmdmEhA02dOXynJFcAkI3c6I6kR6vid+h/r5sfvzCybaL44j8B5WPux
         HXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SfIYKgPds4OejD3qxNFmtT7uVL/B8O59w3PXGuZWqkg=;
        b=omHyotrla66tf75KAqEMof5Onwb+SEvXKL0UiRwOYxndtipOIwQ0Rov5ni5zPBO+qV
         EmpntQ5miyVLPA4qGPkYLhbVdj2WSqVEePX+BSf+0JlD1mJr0r7BlxeUcNxt8ft71kOy
         Ua9DL0SB5XBa4GVo6ZvXyKHqkOWvm7WgCSmGAqXxXmEGtyU4JeNOPjipNfgbowT5jj4a
         1CpGTVPKS5CogxCqko0ELIOIknyoEudNwG7mGJKCwNl383xJhRfrLaMR98Li92b5b2Iu
         z/BjMY3d9sUvQ0DprJd3RmUa6PMG/OCYZz/DcpPl+2EtIq/E9Vc+aCNZ8BL8yspL7B8J
         sE5w==
X-Gm-Message-State: AGi0PuYkDwSJyOG7yaJcPHLHiXzxJDmIhF4byD/CVxRZuGyHWEdC+mzQ
        SDxrkjbjws6rrjiAHiEp0fnGCbnTP/F+Q/tC196mmKi9Ads=
X-Google-Smtp-Source: APiQypJdpV0eEIb7b3258IQ+Y5MHoPPU1vL/DxV5eUartsIeB7tM9hWO99LM/1ClnU0AMv+X0TJGCAvQ056vnO862UA=
X-Received: by 2002:a05:6214:572:: with SMTP id cj18mr2667337qvb.209.1588250412831;
 Thu, 30 Apr 2020 05:40:12 -0700 (PDT)
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
 <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com> <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com>
In-Reply-To: <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Thu, 30 Apr 2020 14:40:01 +0200
Message-ID: <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 5:01 PM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
> > > > The problem is actually more complicated than I thought, although i=
t
> > > > needs more work, below is the first pile of patches I have for you =
to
> > > > test:
> > > >
> > > > https://github.com/congwang/linux/commits/qdisc_reset
> > > >
> > > > It is based on the latest net-next branch. Please let me know the r=
esult.
> > >
> > > I have applied all the patches in your four commits to my custom 5.4.=
6
> > > kernel source. There was no change in the amount of fq_codel_reset
> > > calls. Tested on ifb, RJ45 and SFP+ interfaces.
> >
> > It is true my patches do not reduce the number of fq_codel_reset() call=
s,
> > they are intended to reduce the CPU time spent in each fq_codel_reset()=
.
> >
> > Can you measure this? Note, you do not have to add your own printk()
> > any more, because my patches add a few tracepoints, especially for
> > qdisc_reset(). So you can obtain the time by checking the timestamps
> > of these trace events. Of course, you can also use perf trace like you
> > did before.
>
> Sorry for delayed responses. We were moving to a new house so I didn't
> have much time to test it. I've measured your pile of patches applied
> vs unpatched kernel. Result is a little bit better, but it is only
> about 1s faster. Results are here. Do you need any additional reports
> or measurements of other interfaces?
> https://github.com/zvalcav/tc-kernel/tree/master/20200415 I've
> recompiled the kernel without printk which had some overhead too.

Hello Cong,

did you have any time to look at it further? I'm just asking since my
boss wants me to give him some verdict. I've started to study eBPF and
XDP in the meantime so we have an alternative in case there won't be a
solution to this problem.
