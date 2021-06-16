Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0566A3A96EF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhFPKKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhFPKKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:10:46 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD60C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:08:39 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 102-20020a9d0eef0000b02903fccc5b733fso1949447otj.4
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mpEfB3lhZ7ivqczlGwZPOMECzMi8TzmMowmqIZoPkQw=;
        b=udqHVSbcXOzi0w8NsExUeNriFrj8+dBNuyhqVs3mC/GmMjKa7db1oZgpt29/KfTBWD
         hb2OwC0bIl6GQhWrWBjomVRR8yMo7wmgfKFjaqVoNbXzEUDYshV46BY/OpEYhzj5EAX0
         3hP8SjK5fsYYysWV202vig1hIkuPZAdYr54Vu7P0fFHEe8rB6aKmtGdukdMV5g+xuJgF
         nKKS6F3R7QbQNcmIQ639jueVr42+VEMSvFTWzpa62PHSTViuO+hpduKgphtli5PMBziY
         EUNG780nsu22KUHhhJ0zvKc7yGjuGFmUUAk4L5POTIUNoh3LQ66JlY8YDvVduya7bBCD
         9zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mpEfB3lhZ7ivqczlGwZPOMECzMi8TzmMowmqIZoPkQw=;
        b=WOGf7MCmYvlP0J8dGwsJBcmBZwbO2J5ban4bq55N1eOD3YrTRR1y53ngskFLsaQW5o
         reRLQFdJifzSxZ/d6ZNcf42jRXg56j7gh18Shm1UVs1avE14nqqOBXVva8ewfvWqJVc0
         pUoYOjWm+ubDk5uWCcR1lP6JLmZYbfeP5Eo051J3xV+m/B8AUghmF5lASL992gSiWwX9
         Xg8oH0wnGfI/MWhGul9kqB/6CDJP0M7eb2N1743zIQLPXUpdS73oHaRT4Ftxod+P1skS
         jvEDbzTAuP/2+yovId9nsRh9UNPhCCWptPwwSVBCAsirdrAxeralqbe2gA5DQvT8aLWX
         XgAA==
X-Gm-Message-State: AOAM532khOVsM0VSu1y+vnofFMCrrZA08v5xIy0b3Jwk7p2p4pgYuG24
        ywroHUvawZNByIPlr7YfSyZPukMO4i5WRnviAMESjXhA
X-Google-Smtp-Source: ABdhPJyLY9VUkEB9WUfvN3bBHNO7qU4KrWliBnoA3mXCNp/GdEb3YKUUlNLdveNZ/ZExFo77SBkRyzWvi2lQrpw1DiE=
X-Received: by 2002:a05:6830:cd:: with SMTP id x13mr3423096oto.166.1623838118914;
 Wed, 16 Jun 2021 03:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
 <8735tky064.fsf@miraculix.mork.no> <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
 <877divwije.fsf@miraculix.mork.no> <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
 <CAKfDRXhraBRXwaDb6T3XMtGpwK=X2hd8+ONWLSmJhQjGurBMmw@mail.gmail.com>
 <871r93w8l9.fsf@miraculix.mork.no> <20210615122604.1d68b37c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210615122604.1d68b37c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Wed, 16 Jun 2021 12:08:28 +0200
Message-ID: <CAKfDRXjuCBj=jq+s93L3xHJAtAZbtEt0p4O5omrXgZfX1Xa6YQ@mail.gmail.com>
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 15, 2021 at 9:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
> Tricky piece of code. Perhaps we could add another return code
> to the rx_fixup call? Seems that we expect 0 or 1 today, maybe we
> can make 2 mean "data was copied out", and use that for the qmimux
> case?

I took another look at the qmi_wwan and usbnet code, and I think we
can solve the problem at hand with the current infrastructure. I
believe all we have to do, is to change qmimux_rx_fixup() to return 0
and not 1. When the rx_fixup() callback returns 0, rx_progress() will
jump to "done" and queue the skb for clean-up. This is the same
behavior as if FLAG_MULTI_PACKET was set. I will test and prepare a
patch changing the return value, assuming it works well. Looking at
the loop in qmimux_rx_fixup I also see room for some clean-up, I will
try to merge everything into one.

Kristian
