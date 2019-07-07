Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C347E6176F
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 22:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfGGU2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 16:28:37 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44438 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfGGU2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 16:28:36 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so12642400edr.11
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 13:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Vk/w8aVbR01nk+PcSPbfm51PoM62chtu6XzbTNR+5w=;
        b=sfk7Y9owqbcwUGY4kulUCY0FnEkbRABT2a0KMYlHNbqeQCW1Vlh65GYC3X9EluY9bq
         JOwHC2JFDrxZciiIrqpveLL4OG+kH+4G2ndGDyW5WglPcMEJpNk/ZQzFTVPmABNXhbRy
         76zfKG3kLw5/KUaLvCf/U3aGgRqBXDQYdL8VUzqiMpvmc+7V5KOadqDIVr9aYt6mhQBz
         pmZZEg12ARDk4sOlvWazmXTZgLjS+x5NLzDctPulqBLXSs/+flVotZinEm+OAUz8nNAf
         MPhtT2Tv0QJvRWvpux7M++XQWCo3egEJtcJM4c9ND4rMAFIuTn4iekYnu2tTBJTGsFHQ
         QOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Vk/w8aVbR01nk+PcSPbfm51PoM62chtu6XzbTNR+5w=;
        b=VJVYZKVXsbAZ3kl0GKCd9asex+JqFmgWZNLcSsdZbcRxv/8OyAvIiL1A9pLt5/z4O5
         MuJHVs35BIgtER8zofiGwZCx3MPUFsgrrw2IC4BmZPur1T+Fx2Hxtcgzh+gzWtkN3ej0
         62GMHwOEWIm7qOt6+qLxMr3TZrDsyrRcLghss6ae8d5fZNouUx0fpfCgLT7EVug76Uve
         WaZutmEYHo2T7skjix/esDRg5Oo4EpYXRs7Yw1OME9G3mPFM1rKnMvTRGeTamF07ajX7
         +MNuyHnd90bAFDQnyVjGiVlqlNyUl2eX+BDR3N/zGnbhXh46CNo0IFQ7LcZ0uvnn15H5
         2QXw==
X-Gm-Message-State: APjAAAWW0Gliqun7GqwuvTfT6lK9Cn54Az56gmkmZ7FbvQ89saj2Ie2i
        4rTweyK5dRuYUGXpN3YvmLlz04nhJpFZ5ZmQCYSNbRMmPOM=
X-Google-Smtp-Source: APXvYqzjm2DwJtRiRna4NtadMBqKmr4mJnZ+rlBExWD1RSSA2u1iLbgK5/VLOk6PymIIcPbdPs/td/COZyB5OYh+piY=
X-Received: by 2002:a17:906:b7d8:: with SMTP id fy24mr13645786ejb.230.1562531315216;
 Sun, 07 Jul 2019 13:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190707172921.17731-1-olteanv@gmail.com> <20190707174702.GC21188@lunn.ch>
In-Reply-To: <20190707174702.GC21188@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 7 Jul 2019 23:28:24 +0300
Message-ID: <CA+h21hoZ-ZgweMEDSBjANVhkVTNDONA+YkSz5y6TAJWByHHzDg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] tc-taprio offload for SJA1105 DSA
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Jul 2019 at 20:47, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > - Configuring the switch over SPI cannot apparently be done from this
> >   ndo_setup_tc callback because it runs in atomic context. I also have
> >   some downstream patches to offload tc clsact matchall with mirred
> >   action, but in that case it looks like the atomic context restriction
> >   does not apply.
>
> There have been similar problems in the past. We can probably have the
> DSA layer turn it into a notifier. Look at the dsa_port_mdb_*
> functions for example.
>
>           Andrew

Ok, thanks. I thought the dsa_port_notify functions are just to be
called from switchdev. I'm still not sure I fully understand, but I'll
try to switch to that in v2 and see what happens.

-Vladimir
