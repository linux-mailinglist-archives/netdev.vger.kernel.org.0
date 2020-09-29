Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE127B8EE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgI2AgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgI2AgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 20:36:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A817AC061755;
        Mon, 28 Sep 2020 17:36:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y20so51369pll.12;
        Mon, 28 Sep 2020 17:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LPW1bjFPvFAvn5HdwGhfvgueZwfxv91Vc8SJdeJ70Jo=;
        b=ZvX/OjZryHffZLKS0bKedaFWzGebEzcj3SMLfHn8IbI+IdiHzKviJvcY0fG9z0xw2u
         doxdelF/cJvjvI7k10Ad8WjTptX6OijoxFLklEJ2zpxRuxNKpB7Dw0jfDQ7vA0IRc+K9
         fuuMDWj1lugXTlflY9gJJDVzK4rMnxqJ1Ifirl+lqrJ8jnOOJGA/zL6X9CZCjlx119jA
         MQZ/ltpq7VliyO74k3dT/YDWVlwN3nxIz0GyVz6Feh4qFYIk7H+8cZfaSZiJi+zZTawo
         yYCVdwXtMnYLq3tJTOJK82OVWBNPaFm7dXQGgHR4v7na36mBX3rWjM5Dh2oy4GwDWhNS
         +4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LPW1bjFPvFAvn5HdwGhfvgueZwfxv91Vc8SJdeJ70Jo=;
        b=fitIJytAXlAYK4jMVHjs3xhjpd8JPojYSNHP3QMMV3nykFcg4V/mBnzdwlEnMhPHga
         5UhWXojklxDEAV/JmwoyKv8XKA5LC1Lk1/9uUjuF3yUb/MN3kdV1ez+rYcmKaLKoZbJi
         PdYCQ1nOyGx6naN2QgFfY84HSabA8qS6r3IWqEkdna9jNKmgoVtG8bWywW7lbhO0yuzf
         TaADE9zHxOlF1O0/blyEOKmpo4bS4zpOTi9oEUNJ0Z/iZ7jf4zCg/sgFdCeR+MzvJvSn
         ekb3+nCvtaPyre5Vqqvwh8zj3JmRoaf7ZrTKBWDOuc+PbXFi5/xxlc2MnuKgNM1Xha6B
         UNbA==
X-Gm-Message-State: AOAM5336LFSACFTuJvnvWKlP5c0ebizgpzNf1ViEsLsAOjTSIm7dooyd
        KKP6Gz9JWEwzgUqJOlWjEAHSS0NG/2ER6KLG2ZsQ0a2o
X-Google-Smtp-Source: ABdhPJyNnYljuRKu6gbq+5K2vqFvql3svZ7X9SYS9KKRrFq2hft8gPM2r1NKNCkVrmXfzPYzhbSy3rH4P8LtWIywDxw=
X-Received: by 2002:a17:90b:816:: with SMTP id bk22mr1554548pjb.66.1601339784308;
 Mon, 28 Sep 2020 17:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200926205610.21045-1-xie.he.0141@gmail.com> <20200928.155852.490566722532403628.davem@davemloft.net>
In-Reply-To: <20200928.155852.490566722532403628.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 28 Sep 2020 17:36:13 -0700
Message-ID: <CAJht_EPs03cTh=6PQWasZknRXOzysW-X+dC+RPMu02RsC417LA@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/x25_asy: Keep the ldisc running even
 when netif is down
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 3:58 PM David Miller <davem@davemloft.net> wrote:
>
> It could also go back down and also back up again after you do this
> test.  Maybe even 10 or 100 times over.
>
> You can't just leave things so incredibly racy like this, please apply
> proper synchronization between netdev state changes and this TTY code.
>
> Thank you.

OK! Thanks!

I'll try to ensure proper locking for the netif_running checks and re-submit.
