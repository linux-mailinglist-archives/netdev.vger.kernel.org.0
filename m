Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587871A6072
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 22:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgDLUSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgDLUSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 16:18:06 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01042C0A3BF0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 13:18:04 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 71so5721019qtc.12
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 13:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZsekIBHqshnbI/HS9TZMolVbNrgPMfffXxKjS45z4/Y=;
        b=DI6MjArWgMwA2MClDCTMvmLfloAgfiDQP2uCCQ70B+hDr/tjjl9mX2fRJRFCwVTPpm
         WekkW8ULkL01wb5f0O8z4aijpHfkpp1qOZhTF+W/LJp44PKyqWfnPBPtdcnvYM6tvwsj
         yDKH50lhZBtxcNu+Dc2OPb54GygwcXMKm8bSg2LflCJhW/h5lqN2D6zUsIaH1co5046N
         ubTyAdCXRFXL6BicmseNmQxPpFE5JMeu1bH2n/hyg2EOWXT9KmBbi/eG03i6Ok/F+249
         /Jc9zTnP6r4wOtgJtz9BaTWH2LZqNxCdw/iz9x/q6K/y2QlOsgD8PElhtdoH+2Z9a+MU
         UhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZsekIBHqshnbI/HS9TZMolVbNrgPMfffXxKjS45z4/Y=;
        b=AJo2ggr0bXFcAVDMBq3EEs3rqgpuZp1UE6ocBSmAHpx/Vazm9U+aZ7EBgjfc7Tky+l
         U4Siw20PUTZnkQL+RsK5DAtvkKgiRCqj7OsJ5xvHuQiGZVtwXOrCyTBO52azthEO1//P
         cQBnbr3q+3sowE0r3yajINWLboeGKlGbjMeiH/U8aUfbrotpd5PpwLx5Omeo1V9z+Fri
         4VvfTvss4MOY9d6FIi7wPHZdROsPXTfDuI1k/0gN+CpdJuq/zLfajpu5QqrSCMSTt9Tc
         h969tmD2LPpmX5FtHqOABOX1f0RauxDp7BXuyRqvP3Tq7CO/LezYtX4wVc+yTJ50U1Rs
         u5bA==
X-Gm-Message-State: AGi0PuZk47Mkkim9qtK9Gmnp3Q8ZJ/mWywKbpO/eBhLymBC3Op88cRH/
        +1jMomlYVKHcjLVo7r96MbaSoRZDK6+Yb5lmsQ20hg==
X-Google-Smtp-Source: APiQypJiLUuMZrk/V0hdntnjbbjNsFt/UGNCdtI/y1UtTb6j7cpFOJ8lQaNfEdeDwoYyLzdy0vxtJuydQniw16qkyiM=
X-Received: by 2002:ac8:7609:: with SMTP id t9mr8540377qtq.155.1586722683850;
 Sun, 12 Apr 2020 13:18:03 -0700 (PDT)
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
 <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com> <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com>
In-Reply-To: <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Sun, 12 Apr 2020 22:17:52 +0200
Message-ID: <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 10:18 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hi, V=C3=A1clav

Hello Cong,

> Sorry for the delay.

No problem, I'm actually glad you are diagnosing the problem further.
I didn't have much time until today and late yesterday to apply
patches and to test it.

> The problem is actually more complicated than I thought, although it
> needs more work, below is the first pile of patches I have for you to
> test:
>
> https://github.com/congwang/linux/commits/qdisc_reset
>
> It is based on the latest net-next branch. Please let me know the result.

I have applied all the patches in your four commits to my custom 5.4.6
kernel source. There was no change in the amount of fq_codel_reset
calls. Tested on ifb, RJ45 and SFP+ interfaces.

> Meanwhile, I will continue to work on this and will provide you more
> patches on top.

Thank you very much for your effort!
