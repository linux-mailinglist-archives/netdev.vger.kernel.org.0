Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4827198C02
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 08:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgCaGAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 02:00:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43242 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgCaGAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 02:00:08 -0400
Received: by mail-ot1-f68.google.com with SMTP id a6so20835432otb.10
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 23:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CXXOUsdlGnj26N+iA7SMD6V0EP1D1IvyP4A5rEv/314=;
        b=oOzu0tpFaFjqEknxZ9sNViabnRjWpZMb0jUT3s423py5e4+kaeYoZmCCwJMBPmk7+W
         vxSKSmz29o7HmI/rDhRdpHPL8UmccJfzCkNfBpNMoMzcmpJWRMz96Czytex8jnwqfIvm
         4S95cTAraCBoCD3D0/lGxccEvZr87ZTNYuHezh2AkP1nb6+Zn+CwzouDXI2K7jYzrNO4
         NrVQDD+cCIBTqH16fS7/Hs257i/INcAE9w9bYQLMDOEClxkKE1fn/agKhQZEA1WM94Tu
         M0+7Cc9/ESUz6FZ7wHEqpEDYvWWmMjQMAh4TQASLv1uYfzoBEMZUK4PNUugoBdYTxaIK
         itHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CXXOUsdlGnj26N+iA7SMD6V0EP1D1IvyP4A5rEv/314=;
        b=aaxe/Kaj+B4YndC926hZrvRtmmmis06h9YysGSJQ/tiAUKvcaxV3jAAk0IXK17S45J
         nc9YxbmJ7bLx++y1LGVDGh2Azx5Vvnw8I/QCETYr9LPKQhpT3RamUrxBf2S7X0ba5y2e
         rkpJ8ZV7fHXa8yLPAosVGgD5lI7V4MzNAb38YTMQs0SrDR0af7zx9wmotApyXHFdVawi
         LI9Jj1rioQn/YzA3ryz0mayFBPnLpdRb3r9jhI/WA4qJ9Df1mA7s3B11mcQ7/hUsV63v
         RvODfzoTAR1bqdy4X968p4L/fxpLh9lc5af6iXOYHjlxpI/WY/4E2ZD5kjQhxOKRpHBE
         0aLA==
X-Gm-Message-State: ANhLgQ3tdUVlPztrfsKuiekAAwkYI3QJKMJSsIsIN/8/+WY9qSveczwP
        E/GbrkW27CTsgvBU27Wg7kGdHACUhE6XBwR0r3M=
X-Google-Smtp-Source: ADFU+vv6GkLUwtWZccpAqTJ/L1osIAcGp6aYYTB1J0BYMenKXMeqwOHpeaNC9vBziCwgo/qpM72s0idMh+aobCR7W7s=
X-Received: by 2002:a05:6830:22e8:: with SMTP id t8mr2213599otc.48.1585634407996;
 Mon, 30 Mar 2020 23:00:07 -0700 (PDT)
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
 <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com> <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
In-Reply-To: <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Mar 2020 22:59:56 -0700
Message-ID: <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 6:04 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Fri, Mar 27, 2020 at 11:35 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > Your assumption is not totally wrong. I have added some printks into
> > fq_codel_reset() function. Final passes during deletion are processed
> > in the if condition you added in the patch - 13706. Yet the rest and
> > most of them go through regular routine - 1768074. 1024 is value of i
> > in for loop.
>
> Ok, so I went through the kernel source a little bit. I've found out
> that dev_deactivate is called only for interfaces that are up. My bad
> I forgot that after deactivation of my daemon ifb interfaces are set
> to down. Nevertheless after setting it up and doing perf record on
> ifb0 numbers are much lower anyway. 13706 exits through your condition
> added in patch. 41118 regular exits. I've uploaded perf report here
> https://github.com/zvalcav/tc-kernel/tree/master/20200328
>
> I've also tried this on metallic interface on different server which
> has a link on it. There were 39651 patch exits. And 286412 regular
> exits. It is more than ifb interface, yet it is way less than sfp+
> interface and behaves correctly.

Interesting, at the point of dev_deactivate() is called, the refcnt
should not be zero, it should be at least 1, so my patch should
not affect dev_deactivate(), it does affect the last qdisc_put()
after it.

Of course, my intention is indeed to eliminate all of the
unnecessary memset() in the ->reset() before ->destroy().
I will provide you a complete patch tomorrow if you can test
it, which should improve hfsc_reset() too.

Thanks.
