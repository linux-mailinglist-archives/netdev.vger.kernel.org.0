Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18E028A997
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgJKTPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJKTPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:15:47 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7313AC0613CE;
        Sun, 11 Oct 2020 12:15:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t7so12722231ilf.10;
        Sun, 11 Oct 2020 12:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EU2TM8VEffEJBj5T95XmFwjfPtti7OHO6q6oz4uMTK0=;
        b=XjdQOIimwfwPLO5ZthMIsdXA4/ncGNQNwTk3KSbBhhX1VA66f6Yvt48saPZ1dKvmuB
         WkGw40/eAVRXGVPXzwS71hxeWA0en4wRJ4Uf/eO/faUqsnzZK5vQiptu0sqJbhFPvYx5
         BZXkl/Eppn1BYL6BiprBWNshROT9F7cta7074XenAQiD/iCElKslEtSJ3kdz/kTMmgKf
         gI65eR3XkMzyP7tYwTm4E2d5V5de9FNbWT8VYnF7gkqFDV7UP9nuphKpC6gUEIdgQRxD
         /gEp6jmNPTxBqD5pnFRJ/6gUUdivWPAt/5SvRTmT9qrCRfUT9pATdKY24Y3tdBV1DZRb
         B8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EU2TM8VEffEJBj5T95XmFwjfPtti7OHO6q6oz4uMTK0=;
        b=ip2yr7zzpsDE6x91oNaUuWGERKCG1Lel0c0jUJKNphh9l+o7hQmmQTxKzaoXuijn3E
         tkqsxi0nq3vsVjLX+9bmPgG1qxoMBDqCaKLAC6AllJhvQYtmrVtpftf51Wee+4IBKBPP
         Uew1GhXJaJVESiwQgrE0caOKe+91+MnMiK8UpXUq3gh54Y3z4CDBxz9rY2wrb28iZHlO
         ZOHNrdcSSi13hBsOutunDjiykf8e/InExh34wJqykhFQsiR6qOyJnfDiTbipcHKd62cM
         wnFY19mn5RtBAfp3T2n8Fu7IEQVauqieIySzkdRfgVrZmKUMLDrlqHmGYN1XcY9kC5cF
         wwBw==
X-Gm-Message-State: AOAM530yi3lw6rUNCHdBtdvkI1p7esmahZi/NmlxuddN9MzSTVn6mBF/
        L4iH2MeVTnwA3BiWiyBqzBxHBE/ZuWbqbZ/xszvFg5CwLK9WLLne
X-Google-Smtp-Source: ABdhPJzBfFOyubZJcrXf0XlX9EXMU2lYYB/OA10n+NKMaqlH+elRSzW6t1z1vg9ccSr+o9Qx/qMc6tuzgDuODiD/vLU=
X-Received: by 2002:a05:6e02:e82:: with SMTP id t2mr15227596ilj.238.1602443746821;
 Sun, 11 Oct 2020 12:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b3d57105b05ab856@google.com>
In-Reply-To: <000000000000b3d57105b05ab856@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Oct 2020 12:15:35 -0700
Message-ID: <CAM_iQpUFgGhxWnv5q2J5WUYRsHZqkkobY3ePo8x+3ZVdA=KZwg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in tcf_action_dump_terse
To:     syzbot <syzbot+5f66662adc70969940fd@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net_sched: check error pointer in tcf_dump_walker()
