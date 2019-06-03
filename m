Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6640A328FA
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfFCG4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 02:56:24 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:52232 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfFCG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 02:56:24 -0400
Received: by mail-it1-f195.google.com with SMTP id l21so3676702ita.2
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 23:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ooOZ8aCismIzzPcMY1VTWsTBEe7b7TcB9sjbz4A8RV4=;
        b=QV0cPHPnK3fS+9Pj30mBk3EJNolqnegqOausWsF3KeigPRW1UDHE4cDmUCt52QGaoG
         o2DfahDuF3m+7pwHDz9XHj/Yud2N0e3Dej3Yd/lFBl+2qIZEOm3C3PkkSX8NTklthRPD
         Nm5dv/tgL2lbBbBuckHd+BOS6vaGu7PnnAXIpTZ9AErLVZSB4p/sSnAfha+5YqPfmGaF
         zRKaeOWwsoRniCJL1dnwriCXZ691hVwHD6ah2afo5iTBy9mi+RQsswozPHsWNHdN/Y2g
         NIWeFZogW92q4eBLVCTnjKAyt/yOJhsZkTHCswIhaB1Lc/eooWT3G/CGghTy9JVVYpVH
         orpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooOZ8aCismIzzPcMY1VTWsTBEe7b7TcB9sjbz4A8RV4=;
        b=d3L3fT/BzLOvQN6/ZeyVbepFMpZZL9YV6PCu3po8I3/MXQoiWojZnwEBNKN4ITvzQv
         6K2EHCn+47bgl+4g6iY0OjvTN0NMmAX8G4oADZ6nBEyVbrzQDNpZM4WLNw3Yx2v84kng
         +LjLtpW0gIhwWcAy0rwr8fqeV8UgHO2S1dFjXClOK7X/j4h7Ae2LiMk31zP/UKFK/vTX
         S83vVrxfDU5jwIWam6nLuowSQDvQfH1FTyPa2jh3e663+LwtCHTiOw2vKwdiljKFo0U2
         fz0FHWscnQKyVPeTcehI4b4Ia2+xwRpU1elELom9hvsA/4k0TNQfpMgBn+I5snLU8F/X
         +kTA==
X-Gm-Message-State: APjAAAVB+THMxEYoFr6qdVgwFo91oJ3D2SQa02RqQrGjLEnildjGVO8g
        9E1/jA+N/5xIUi/WQrQ9wiVqt7fjnxd4eyjVxud56w==
X-Google-Smtp-Source: APXvYqzpGauoTJieg32wk37//cRiF4h/aqH1Z79YNWgjJysa7Is5ms6lE/NZf3cE3Fq2u4wFUatF74z5A98JGk90B7I=
X-Received: by 2002:a24:9083:: with SMTP id x125mr9442626itd.76.1559544983323;
 Sun, 02 Jun 2019 23:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a7776f058a3ce9db@google.com> <178c7ee0-46b7-8334-ef98-e530eb60a2cf@gmail.com>
In-Reply-To: <178c7ee0-46b7-8334-ef98-e530eb60a2cf@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 3 Jun 2019 08:56:11 +0200
Message-ID: <CACT4Y+ZqM84Ny22p7=J6vVXG7XOkqVN_jjkb87DNetNCFQRFBQ@mail.gmail.com>
Subject: Re: KASAN: user-memory-access Read in ip6_hold_safe (3)
To:     David Ahern <dsahern@gmail.com>
Cc:     syzbot <syzbot+a5b6e01ec8116d046842@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 1, 2019 at 7:15 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/1/19 12:05 AM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    dfb569f2 net: ll_temac: Fix compile error
> > git tree:       net-next
> syzbot team:
>
> Is there any way to know the history of syzbot runs to determine that
> crash X did not happen at commit Y but does happen at commit Z? That
> narrows the window when trying to find where a regression occurs.

Hi David,

All info is available on the dashboard:

> dashboard link: https://syzkaller.appspot.com/bug?extid=a5b6e01ec8116d046842

We don't keep any private info on top of that.

This crash happened 129 times in the past 9 days. This suggests this
is not a previous memory corruption, these usually happen at most few
times.
The first one was:

2019/05/24 15:33 net-next dfb569f2

Then it was joined by bpf-next:

ci-upstream-bpf-next-kasan-gce 2019/06/01 15:51 bpf-next 0462eaac

Since it happens a dozen of times per day, most likely it was
introduced into net-next around dfb569f2 (syzbot should do new builds
every ~12h, minus broken trees).
