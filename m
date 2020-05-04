Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598A71C4860
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgEDUg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgEDUg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:36:58 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB69C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 13:36:58 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id c124so7868363oib.13
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 13:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RsF8nWsy+NmWqDg6mINJgccaISm++s0fpdvhQhqn6ME=;
        b=k5f6p7htiRbHze7B1lvL2237gWaZq9QE9Ab8VfPAqm+akbDsAei6kUipPMSa6iNExF
         Qe5uE/bytkr604h6q/O5n0ji97RanLfI0yEIt1cSw8QQUK0R7tgcBZ/Da0duHt2A/FJd
         GlV4VQU6oKHpnj4ev5BBNoVZOZbrJBKBXIJdjdxRGskTN2aI/W95vCSMFISrUox8jCvY
         XvYOocKREXeXXYVowGHSBGFuNoj9cu427MxjSu5wSieQy0SXr0w7zmReL0L9JnS2fdvM
         z1+u0an5K8JqmmZ1rfRSAV6Suo/wUQzR0x33PNRnjOclR63DwVS2wCO9blME8jMfLpCW
         ZV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RsF8nWsy+NmWqDg6mINJgccaISm++s0fpdvhQhqn6ME=;
        b=nurUGXLovD+WNsuSL1wDjvorm+5+FLvbTvqsgnsxXfdGC8ttD3Ob9S1pj31MdTMc/p
         1IP8XwslLJgeuW6evk8X3AUCqjRTb1/3PD0LwE6XMtBUptF2leHZcpkCVMSFKFp+eDkW
         cK7rnNIwzvXejWCdrTYILdSBATTWifVvqiikghxucQkDMq2/F6LHkYKQBRpqpL2irGFS
         7tN+QQuW9W/DKf/oYrqPf22uKstyTGvxogmMlaIvvYdQ79UdGrwwwUEe6AALR+JjAxFm
         AZ5op/7LJ76MrIWH33erIdDexuBXYkQCiVWqZzMjGJbTAlbyFSM2ZWvQnIcVzih1eUOg
         r5ag==
X-Gm-Message-State: AGi0Pua4eXNzeyOOuN/0K9rzr0x3/X2nlqJ4vu1E+mpSN6UJfsaPVhcT
        XyYje100h3GmbTpMASsk7rmFlRlwtfw2NK4epBGZUYbwE/w=
X-Google-Smtp-Source: APiQypKvAs64MD/pNeyXo0W74g+pRLTmhnVBJqjSQPOtXXu9oRRbcApCob3nbgzPawlqMFZLSVlL90Vqf900xgamhuA=
X-Received: by 2002:a54:4e84:: with SMTP id c4mr179761oiy.142.1588624617627;
 Mon, 04 May 2020 13:36:57 -0700 (PDT)
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
 <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com> <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com>
In-Reply-To: <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 4 May 2020 13:36:45 -0700
Message-ID: <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 10:46 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Regarding to your test result above, I think I saw some difference
> on my side, I have no idea why you didn't see any difference. Please
> let me collect the data once I setup the test environment shortly today.

I tried to emulate your test case in my VM, here is the script I use:

====
ip li set dev dummy0 up
tc qd add dev dummy0 root handle 1: htb default 1
for i in `seq 1 1000`
do
  tc class add dev dummy0 parent 1:0 classid 1:$i htb rate 1mbit ceil 1.5mbit
  tc qd add dev dummy0 parent 1:$i fq_codel
done

time tc qd del dev dummy0 root
====

And this is the result:

    Before my patch:
     real   0m0.488s
     user   0m0.000s
     sys    0m0.325s

    After my patch:
     real   0m0.180s
     user   0m0.000s
     sys    0m0.132s

This is an obvious improvement, so I have no idea why you didn't
catch any difference.

Thanks.
