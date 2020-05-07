Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89DF1C99EC
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgEGSwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727891AbgEGSwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:52:53 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9690C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 11:52:53 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id b17so1598044ooa.0
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 11:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IV4NcF/F53NWUTcK0gRcws38ofw/IVGjP7ajCbvMeSY=;
        b=s066FSSv964J7mgqp2NFQBv3HBgixMofa4r0hw8zJBm45dNzvONu6HBv/X1xZDNh27
         qep3JX6+jF1SsObRs8H9KW/0YJCn8BUU6lLnDcFxdRpR7idZ5N92pLBlX9s9Hq0zIuHU
         mTxzt/NXYwGx0gp53deBnujdpc0rTxVLO42L/DIhrbSsPfOIOQ4VAL7gksqXh1x1DXOP
         j3jEtqpCAj2C5lIHSN4gHZ6ANmhPRgzt/lbvJpAufUPicLXxIhhzKmvTCXnzYV0bgq1G
         ozVO5AHkp26nYBqpFf7ftt7APA28se4g0WVqOQpwOTFk+zR6T0WB33H96wHzi7zaRSFe
         G8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IV4NcF/F53NWUTcK0gRcws38ofw/IVGjP7ajCbvMeSY=;
        b=ASVVn8/LeeMlj4evncRzbHZBGuyukTMmDXJB+J9vGtKDUocagSVN2rw079Rks07U6V
         /icbM3JFUXetoEVmL2koMia88TsphlJc7KRWVQp6itpGBYY6sL4XyiUYLLxZybQljkeT
         mz8D/bBPWBpCmIw1XB7ULv9FSsYAlGnx5gTtxejdS85wH/HC66oC7D1KldxIj5f/Ebiq
         TUmXlHEsXjNB2fkeSszU7V1qf2FgIMWVLfr6NJPxZkm8/6Dr9Ivw5aupdINnnCLeryZ9
         Gc2qa5LF8jJLekCChlMto7GNlQIr+Rgi5BQ8bTH7e8ItVObPCklJh/ZIF3IHvaYFl7Y9
         x4FQ==
X-Gm-Message-State: AGi0PuZTTBHmYvHjLibFuxYTWYOR17zM+71Yec3nwRoAGKdb9smz7jXe
        fy3+R03RjwR3it5PNCOxSaLluxHOi/lcJhNz5RxjJ8iU
X-Google-Smtp-Source: APiQypJnQc6fmEmLyTRtSbOkT1wNp0B4nQBqXvvvTC083KeqBY6xOgtHa4zOFdUSBNAqMfvUnbIyFbbuOJKSiX0/QAQ=
X-Received: by 2002:a4a:5147:: with SMTP id s68mr8272584ooa.86.1588877573055;
 Thu, 07 May 2020 11:52:53 -0700 (PDT)
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
 <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com> <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com>
In-Reply-To: <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 7 May 2020 11:52:42 -0700
Message-ID: <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 1:46 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Mon, May 4, 2020 at 7:46 PM Cong Wang <xiyou.wangcong@gmail.com> wrote=
:
> >
> > Sorry for the delay. I lost connection to my dev machine, I am trying
> > to setup this on my own laptop.
>
> Sorry to hear that. I will gladly give you access to my testing
> machine where all this nasty stuff happens every time so you can test
> it in place. You can try everything there and have online results. I
> can give you access even to the IPMI console so you can switch the
> kernel during boot easily. I didn't notice this problem until the time
> of deployment. My prior testing machines were with metallic ethernet
> ports only so I didn't know about those problems earlier.

Thanks for the offer! No worries, I setup a testing VM on my laptop.

>
> > On Mon, May 4, 2020 at 10:36 PM Cong Wang <xiyou.wangcong@gmail.com> wr=
ote:
> > >
> > > Regarding to your test result above, I think I saw some difference
> > > on my side, I have no idea why you didn't see any difference. Please
> > > let me collect the data once I setup the test environment shortly tod=
ay.
>
> I saw some improvement too. It was more than 1.5s faster. Yet it was
> still over 21s. I measured it with perf trace, not with time. I'll try
> it the same way as you did.
>
> >
> > I tried to emulate your test case in my VM, here is the script I use:
> >
> > =3D=3D=3D=3D
> > ip li set dev dummy0 up
> > tc qd add dev dummy0 root handle 1: htb default 1
> > for i in `seq 1 1000`
> > do
> >   tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1mbit ceil 1=
.5mbit
> >   tc qd add dev dummy0 parent 1:$i fq_codel
> > done
> >
> > time tc qd del dev dummy0 root
> > =3D=3D=3D=3D
> >
> > And this is the result:
> >
> >     Before my patch:
> >      real   0m0.488s
> >      user   0m0.000s
> >      sys    0m0.325s
> >
> >     After my patch:
> >      real   0m0.180s
> >      user   0m0.000s
> >      sys    0m0.132s
>
> My results with your test script.
>
> before patch:
> /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> real 1.63
> user 0.00
> sys 1.63
>
> after patch:
> /usr/bin/time -p tc qdisc del dev enp1s0f0 root
> real 1.55
> user 0.00
> sys 1.54
>
> > This is an obvious improvement, so I have no idea why you didn't
> > catch any difference.
>
> We use hfsc instead of htb. I don't know whether it may cause any
> difference. I can provide you with my test scripts if necessary.

Yeah, you can try to replace the htb with hfsc in my script,
I didn't spend time to figure out hfsc parameters.

My point here is, if I can see the difference with merely 1000
tc classes, you should see a bigger difference with hundreds
of thousands classes in your setup. So, I don't know why you
saw a relatively smaller difference.

Thanks.
