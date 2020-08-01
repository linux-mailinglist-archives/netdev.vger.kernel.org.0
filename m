Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D972354A6
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 01:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHAXqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 19:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHAXqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 19:46:10 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B902C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 16:46:10 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id t23so12526009ljc.3
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 16:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZMOGkwyk+2uEnUplsOHluFyRACy5ZEHgGFqZFevp/I=;
        b=ELVOJ1KLBrj+PsJAkUsND/KaMhcdbWYA2ubAmUPGagezmMEKvCPdO+jw3XIidJp5LB
         nKykDgvzoEo2v/DoR5fNqAvq2ENIMiAm/XEqfdIOzM92UHS6R8y6Fx21LKGDobCVNT9t
         ofUTocgD7MIBWDf/AFebKW9iYUhjbcX3++8dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZMOGkwyk+2uEnUplsOHluFyRACy5ZEHgGFqZFevp/I=;
        b=Ds51XOXiG0B6n+La+bB9GRbeDEvDE53Z2uq9Gw+2Z/U2ZvXXbSNT4g6JuzGjaO/pdc
         WaMJ98BvMv81WT6Hw4wnUzVwsEgYld4zMBgmdqEd5jHjxatPaQamzYzHH+rP7TZAmx7q
         OnqbfHnK30rLVZkgfGjt4NC5i3ofyOdc7p1aQrZFkWMGt2P2CZxs59Ei/Epg4iTzp4e6
         3a9Q+oLZpwHzx0YjY/tKK46SJja8mTgBq1/vPoyKY5Lap3w30Aint7dba0uBcGtSxlg6
         g421huniuFyqbjRcZgY2DTkb8vY46PmEIKb2MufZWjSicpa/caF6zyO5PPL8m+mPXyqe
         0hRg==
X-Gm-Message-State: AOAM532TUgUAit3hbOGwmL0lWOrYaseS9tnJpFMove6ZOjHbxfvDFp7q
        P2Foma1roAjoKL/x7W1+NxH2SEjeV3Y=
X-Google-Smtp-Source: ABdhPJy39Qwf+HjR88fRMwH1Ob8nT1B5F6/ufKS25gZGK/e9beDfGsgYlXmgXwNsqs3se70MFtPkKg==
X-Received: by 2002:a05:651c:1024:: with SMTP id w4mr2955787ljm.244.1596325568203;
        Sat, 01 Aug 2020 16:46:08 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id f24sm3136735ljc.99.2020.08.01.16.46.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Aug 2020 16:46:06 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id t23so12525961ljc.3
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 16:46:05 -0700 (PDT)
X-Received: by 2002:a2e:2e04:: with SMTP id u4mr313806lju.102.1596325565372;
 Sat, 01 Aug 2020 16:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200801.143631.1794965770015082550.davem@davemloft.net>
In-Reply-To: <20200801.143631.1794965770015082550.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 1 Aug 2020 16:45:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whiwBCM-a=k8bd4_umR2Od6gf7d8Do3ryGAaFneNRGFng@mail.gmail.com>
Message-ID: <CAHk-=whiwBCM-a=k8bd4_umR2Od6gf7d8Do3ryGAaFneNRGFng@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 2:36 PM David Miller <davem@davemloft.net> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

How is this wrt an rc8 or a final?

I have another possible small reason to do an rc8 right now. And this
roughly doubles my current diff.

On a very much related note, I really wish you didn't send the
networking fixes the day before a release is scheduled.

If it's really quiet., send them on (say) Wed/Thu. And then on
Saturday, send a note saying "no, important stuff", hold on. Or say
"nothing new".

Because right now the "last-minute network pull request" has become a
pattern, and I have a very hard time judging whether I should delay a
release for it.

                 Linus
