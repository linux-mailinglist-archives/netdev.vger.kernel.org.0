Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650313952E9
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 22:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhE3U5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 16:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhE3U5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 16:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB4760E0B
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 20:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622408151;
        bh=amUoeuvMjFEs42/bioBdr7U4c/JLhyh90fU1jPwiRbM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sbHFTd0lah1gg5tssqqWVexXPaJtHTlTOa/j4hBMejgbx7TCYa7f1BI/hSbwF143h
         4hbXepa1qfNublExCKXZh3LhFrNo2Qm4A9DHrKbIYv9umunRIfHMnf9sZIWOcrs5PP
         q4qrLw77zQRLIs1o0k53kYtC9ua2bTUJaDaNlZOoNL25fGVttTep1VekyBhVidhLvy
         r1wTj0+69D5tOzJBVApFlluWc5kE4N2YiMfTWu60e6cwNbQUZAm8RiyICHHWGbnXYv
         egyNRMmYob8XOQHcmo3K/TSL+rBacQZCgOkhWVaBycQkKvFkg/9wz9dplZuLP+pSfB
         bJKo7va+Raxig==
Received: by mail-wr1-f52.google.com with SMTP id r10so8747258wrj.11
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 13:55:51 -0700 (PDT)
X-Gm-Message-State: AOAM531cu2uDyI4HdKuA1JXQ/X+B/yVWewpWc6/suNJrUk9Gs6wGw5iH
        MhR7OSdBY1KKGcL2Iv1BRF1697+Et81+4X4W0J0=
X-Google-Smtp-Source: ABdhPJwIkMh6nQBNmFVC/cEUrOTSrnFD9KGdTSQTdQIERj587YKhxUpid32XlugTpgo+f4ex5YsyW0r4VxdXgBMJbxk=
X-Received: by 2002:adf:a28c:: with SMTP id s12mr19920144wra.105.1622408150275;
 Sun, 30 May 2021 13:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
In-Reply-To: <60B3CAF8.90902@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 30 May 2021 22:54:15 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
Message-ID: <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        tedheadster <tedheadster@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, whiteheadm@acm.org,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 7:19 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> Hi all,
>
> 30.05.2021 13:36, Nikolai Zhubr:
> > So, 8139too 0.9.18-pre4 as of kernel 2.2.20 is the one that apparently
> > works correctly here. I feel the bisect is going to be massive.
>
> It appears the problem arrived between kernel 2.6.2 and 2.6.3, that is
> respectively 8139too versions 0.9.26 and 0.9.27.
> Unmodified kernel 2.6.2 works fine, unmodified kernel 2.6.3 shows
> reproducable connectivity issues.
>
> The diff is not small, I'm not sure I can dig through.
> Any hints/ideas greatly appreciated.

This is apparently when NAPI was introduced into the driver.

One thing I noticed here was the handling for shared IRQs changing in
the process. Do you happen to have shared IRQs, and if so, can you
change it so this card has an IRQ that is not shared with any other
device?

        Arnd
