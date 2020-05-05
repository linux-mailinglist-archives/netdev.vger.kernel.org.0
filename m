Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0A1C50BD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgEEIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbgEEIqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:46:19 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92922C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 01:46:18 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id i14so1481249qka.10
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 01:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfUjy8na400+ow1P9rnl6ZQG3r/B8w9L9NIvN0XlX3E=;
        b=W3X8sF9iVciApUpFnQwQOt4GQMuJVVgzrEiLdKpUaL8G5sky4aVvbLYSvMB5bD+R1n
         wBWsGf6ekPI9v7+uwArqoS65b8Am88ktsjvGmoPVCrsWC/mv2pQwjlZW/QjcrVKwdoAh
         D1SpVMv7qsML9E1afdy5a3V5RFbyxq+8dbOqosDYgwwBL0avFhmklFyZPAszI24rW0C7
         TKuwWqbzZlljywYVLJ0+Km1uliaJbtjOr174Qf7/Mzvg/vkIB2oKEgqgQUdk7xPZDoo0
         vyHUtL8Sr+DwAaoN9QGJb9jNRqHIRYyoWX/oCfdAsY4qaEj2tsMt71d4d3wonDzdTOu7
         KhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sfUjy8na400+ow1P9rnl6ZQG3r/B8w9L9NIvN0XlX3E=;
        b=P1+maeyHokLlYOCfG53cIbsGHLYXvPILYDbKnNgWVO8lZa4hrmoPZMfY5tJp9zYI5K
         kcUA4I+Bg5TQ3WBxuDJmMVPmmvr2OM6Bs5BkvF/Z7szvJGY9kNa77iUMygm/JE9fS9sS
         k6bZSnDfiZBrvYsV6j0z9+dg9l89+JT1Aal1Qz0C13iNcy6/JWNd4zIxvSOZaajtMJaj
         1AbztJ5l1ErxKVbFy26VC/9OuxRd2AqI7vMAm0+TzYCqgn9Fl6QI7yTGs3RHUVeJU3bB
         99rG/oloc4zte3eVfONorqDi42xnbjh+flTk1fcVNup2opMobuKwI3h+MaAcrCiOYYvD
         yZIw==
X-Gm-Message-State: AGi0PuYuhZQ0jD2TLquUAEBO07t89Qk72Gyqp3Ajt08B/6U9IIO55fJ0
        JCgOZb19Q+TBfOgL993Wc7ALf6RquZSfWI93tyRGng==
X-Google-Smtp-Source: APiQypK06+lny+eL5ornYkOtl5hsjdq9ICetvA7vNWCf18gfZcKsZH1zv2tjFPOWvv5KRZleUSsue1DduSTWrTdmGSc=
X-Received: by 2002:a37:e214:: with SMTP id g20mr2316487qki.374.1588668376651;
 Tue, 05 May 2020 01:46:16 -0700 (PDT)
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
 <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com> <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com>
In-Reply-To: <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Tue, 5 May 2020 10:46:05 +0200
Message-ID: <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 7:46 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Sorry for the delay. I lost connection to my dev machine, I am trying
> to setup this on my own laptop.

Sorry to hear that. I will gladly give you access to my testing
machine where all this nasty stuff happens every time so you can test
it in place. You can try everything there and have online results. I
can give you access even to the IPMI console so you can switch the
kernel during boot easily. I didn't notice this problem until the time
of deployment. My prior testing machines were with metallic ethernet
ports only so I didn't know about those problems earlier.

> On Mon, May 4, 2020 at 10:36 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Regarding to your test result above, I think I saw some difference
> > on my side, I have no idea why you didn't see any difference. Please
> > let me collect the data once I setup the test environment shortly today.

I saw some improvement too. It was more than 1.5s faster. Yet it was
still over 21s. I measured it with perf trace, not with time. I'll try
it the same way as you did.

>
> I tried to emulate your test case in my VM, here is the script I use:
>
> ====
> ip li set dev dummy0 up
> tc qd add dev dummy0 root handle 1: htb default 1
> for i in `seq 1 1000`
> do
>   tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1mbit ceil 1.5mbit
>   tc qd add dev dummy0 parent 1:$i fq_codel
> done
>
> time tc qd del dev dummy0 root
> ====
>
> And this is the result:
>
>     Before my patch:
>      real   0m0.488s
>      user   0m0.000s
>      sys    0m0.325s
>
>     After my patch:
>      real   0m0.180s
>      user   0m0.000s
>      sys    0m0.132s

My results with your test script.

before patch:
/usr/bin/time -p tc qdisc del dev enp1s0f0 root
real 1.63
user 0.00
sys 1.63

after patch:
/usr/bin/time -p tc qdisc del dev enp1s0f0 root
real 1.55
user 0.00
sys 1.54

> This is an obvious improvement, so I have no idea why you didn't
> catch any difference.

We use hfsc instead of htb. I don't know whether it may cause any
difference. I can provide you with my test scripts if necessary.

Thank you.
