Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6E3AFFF5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFVJMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 05:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFVJMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 05:12:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428FDC061574;
        Tue, 22 Jun 2021 02:10:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c7so21695179edn.6;
        Tue, 22 Jun 2021 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+VJZUPUQz88r9uBZtHaEykoyTdoX0rU4WajJbPzDto8=;
        b=htCdfqf6WMu0K1wO2niZdTlgugniSnEEAR2KlkxfcLtT+NQkjtCi7DJXKi1FPKBW5l
         QzgpLCS4ZhSgJQxPaVxdlSzV4bLf0rdvZclDamQToTPqEHtmifkz+sQGsAHH1epna+e8
         yQHr3btvwIIApK/e86+V+e1beuFDAei6Hr2ia1MdKzxUgXpkKoQ8TDHFzWJGaIUzpqXm
         q6sY2iY8CDBaIVJ6XMygEqk2CCWQTNQxb7yt3AJH9fEjTFmeWkAkrN4LBNStvtWeAFzS
         9Dn9nlBjjXempWsylxeVS72rTSX6cErCVptL5Ti128wGHGByiVkosPY5CZcZtMRp+Fed
         9Sog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+VJZUPUQz88r9uBZtHaEykoyTdoX0rU4WajJbPzDto8=;
        b=nDMkkZP/tQO+1p8r0CQEgWWXTlpSHYccf9Gal5zxFkLnWQDf4Lvis6ZoguyJ92JKb0
         S+52+MuGGkqhV7tEj/3ZbWKrQJP7WKWikk8l2Q+iBAgNSB2k4l2G7VrwsABCOay6cMcu
         bN8m7lCHS27e1K597EkwAJOUxU7tzz4EXLQ3Suxj1pYxGWLi+CgV8BhoRUU2D//mOghc
         obDOF0Q9N09tzm6mnLU/qA62A/4ilpwFilEKFfAcz5dqANLIGoe4+rIs6QIEK52n5DxU
         A6nD7flHSHufHRnQSMOXyEK7Xo7qE+bmHy56o1uh0rgX+Nrp8u6SBFXxPlrOvCsVgPKF
         Kfjg==
X-Gm-Message-State: AOAM530uCsKDX2wzmPp/RHtxL/bRx/+i2fV88OQPrU8R2ftT6tQvymDn
        CFFnsjJ+jn3CojoC+ABDOgdI+JSRFsRr2Vhh1vc=
X-Google-Smtp-Source: ABdhPJxSPQWOmNrW1JkuIl00eMsxzS7DPdnbALvUH5tX1L+65pon2hWT8qyEUKCQCmzd6uNzLt6ZfKNYM0eI2jqQOD4=
X-Received: by 2002:a50:d943:: with SMTP id u3mr3646718edj.175.1624353035898;
 Tue, 22 Jun 2021 02:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <60cb0586.1c69fb81.8015b.37a1@mx.google.com> <YNCwJqtKKCskB2Au@kroah.com>
In-Reply-To: <YNCwJqtKKCskB2Au@kroah.com>
From:   Amit Klein <aksecurity@gmail.com>
Date:   Tue, 22 Jun 2021 12:10:25 +0300
Message-ID: <CANEQ_++HfmyfOzjqS2b_XPvAedzy=zCvDXP_=cfuowZUBJ8JjQ@mail.gmail.com>
Subject: Re: [PATCH 4.19] inet: use bigger hash table for IP ID generation
 (backported to 4.19)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 6:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 17, 2021 at 01:19:18AM -0700, Amit Klein wrote:
> > Subject: inet: use bigger hash table for IP ID generation (backported to 4.19)
> > From: Amit Klein <aksecurity@gmail.com>
[...]
>
> I've queued this, and the 4.14 version up.  Can you create a 4.4.y and
> 4.9.y version as well?
>

Done and submitted (a few minutes ago). Note the subject line has
"[PATCH 4.9]" but it also fixes 4.4 (I didn't know what convention to
use for this case).

Best,
-Amit
