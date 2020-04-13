Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B742A1A6B59
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgDMR3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732781AbgDMR3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 13:29:04 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32318C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:29:04 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id j4so3243177otr.11
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 10:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A3en5iyzOMVENH6eYpzFeSxk3riVmI1mcWKP8c73T7Y=;
        b=ChZazmm7KvFDFM3VM3pWatlAHNL0YXMcxCPK2CDpAnUyJhsjPQxWXacPI8HtajY1x0
         I3syb90d59WFS/Ukp6CPForM/Trwa9hY9Kv2oJS3IGfaENAiQxAIajgRxBxQ4usskkCd
         gvimN4rhrYxe7t8sKvOKw7DZ8hT3QChZ32p6jDrIQz/1PLSysYystK22P/6IrnVPXm1C
         O0mwy+SCPmOiONTmKwQv/quBg+AZONun9UxX7J4MzYIv8e+7oL3UiGTL5i/d4GmiIokg
         BZT4qLZH1aP8UBg2LN5ojGH7pUwUb1Z4d5ccsH3lxo7chlviekQJEnx41rg4XpnX/Yw7
         ZznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A3en5iyzOMVENH6eYpzFeSxk3riVmI1mcWKP8c73T7Y=;
        b=bnYEQUtDhNFI0fP29ht1HFiiOR5lZ0XyfZUTVHF9SOpPSkxp/jE1BH+zgJY0wjBqt2
         UnWXXhH+2ezK8+CgdH1sAC0pvy4bFfvvXT2f7bi6ppNxqumMmPyo+HIG80oesSjEAX6Z
         ruVF9YPshS/lbxr9HmqGO90lH2EMFnw4F8GvLiVxXW0Rx209f1ywB5PUlMiiYJNziymH
         FnHfJ5Pa25Tmuw7UnTzgIV93qDjRplUVXS4iNCk+YvPQrRyZE4coiOy4M7+OykhlCb/W
         n5uVTXaTZx5nqHuiWyqkxTSeekbOa21q/2hs2gMD4GZtgvGi0ZmAJ0ZSMLI4aZYitgWs
         KMBg==
X-Gm-Message-State: AGi0PuYy2Qkjx4NxxogMHy5Tt4IOo7kYPJhYNhyz71rBJFu7rgetGdZy
        j6nTdiLGPTafFmPUBNCwiYNsJO+wDJRe91GdVqhL3w==
X-Google-Smtp-Source: APiQypKPm1BjjKl0/1AZ/ilvFZz+12ikgKDW+CyVhqrA0ULNWKiWlkhsCVop2KnOA7ErbWADOBi/Il7TG4AmZa1wKXc=
X-Received: by 2002:a05:6830:2410:: with SMTP id j16mr517387ots.189.1586798943455;
 Mon, 13 Apr 2020 10:29:03 -0700 (PDT)
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
 <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com> <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com>
In-Reply-To: <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 13 Apr 2020 10:28:52 -0700
Message-ID: <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 1:18 PM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Wed, Apr 8, 2020 at 10:18 PM Cong Wang <xiyou.wangcong@gmail.com> wrot=
e:
> >
> > Hi, V=C3=A1clav
>
> Hello Cong,
>
> > Sorry for the delay.
>
> No problem, I'm actually glad you are diagnosing the problem further.
> I didn't have much time until today and late yesterday to apply
> patches and to test it.
>
> > The problem is actually more complicated than I thought, although it
> > needs more work, below is the first pile of patches I have for you to
> > test:
> >
> > https://github.com/congwang/linux/commits/qdisc_reset
> >
> > It is based on the latest net-next branch. Please let me know the resul=
t.
>
> I have applied all the patches in your four commits to my custom 5.4.6
> kernel source. There was no change in the amount of fq_codel_reset
> calls. Tested on ifb, RJ45 and SFP+ interfaces.

It is true my patches do not reduce the number of fq_codel_reset() calls,
they are intended to reduce the CPU time spent in each fq_codel_reset().

Can you measure this? Note, you do not have to add your own printk()
any more, because my patches add a few tracepoints, especially for
qdisc_reset(). So you can obtain the time by checking the timestamps
of these trace events. Of course, you can also use perf trace like you
did before.

Thanks!
