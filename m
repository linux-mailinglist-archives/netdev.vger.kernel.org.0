Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89877BA2E7
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 16:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfIVOgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 10:36:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40561 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbfIVOgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 10:36:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id 7so11234049ljw.7
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uXYxVcVlwAUugYdpyvE9xzuT74SxE0XON9vZMPgW3ls=;
        b=RjmfUTjVxsXaDUFiGFkAvgEJeIirxIRt1ctQE1IFJSHht9Va5ysgVcfbeafAbkPukL
         X4Q8MAr6QHqPbkau7DoHnK1dpDW7iznVIBcT2GllHJp31fs1NoYVouzZPlW38avLObqY
         f1u7/oczxzzLNwVuFK3b1uo5qY/OoDu2pOuSiVHut1+Ab8lO2U4FSM5gg9cNb0zoWkbj
         pFclTceQM/Zf784f9iFYoCW5Yd0FQor4FfHMFWVR/fkyCymwYHdEuGShqFcCo5glYf9d
         +gzswPfm1/oHJIrpdWHKSy4uQ74dYUqHGWpLZLPJQMZWJ5CRR68pfuo9S1S7MyhGLCdb
         8/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uXYxVcVlwAUugYdpyvE9xzuT74SxE0XON9vZMPgW3ls=;
        b=bU1x4EG0FkzgUvyhI8DAZz0eioqYGFRw9KOJ75+1E25G/bQhngALLS2G+ylzJ/bLML
         bj26WGSFhn897Vci3qjNOVgOko+CbqZFCLJ8l7WHTxa0WdKZEN9i5f9Q07P1rBay07ph
         ANW8tHXxRWavqa1IaOliz6SvKUlH7nzcNWqc0Yx9axPvrk0cdQqspDZ28ur1xknyt9LZ
         CHDzNgoXBseBRcpfcLrqfxh4YnTR3uQxX3QcIZJCWIN4gcrPPRFfoQkO+8meQYziTcB/
         sNf+Meih4oBoP4362PDAUemUatMurv4u6a829dD40OgbTJo6TMvUySDqUMCVuSDOzxwp
         D39Q==
X-Gm-Message-State: APjAAAXY8h2OQm79+yFUxlT4NEiZrjTM9ABEAYDJmsE2+k6FfcHkKmcR
        PFMJlApRk2FUzdERuXrbS6XQcIHjmfQc7ObAv+Y=
X-Google-Smtp-Source: APXvYqxLJdPFrPcx/rJyE/g8qVFiCQl2T1oZZMioJsw9uEIzoY/dACl7ltOIkojiqzQaXYzX5KHSOTCbx/KZDZfpfWo=
X-Received: by 2002:a2e:9f4f:: with SMTP id v15mr14400801ljk.222.1569162971831;
 Sun, 22 Sep 2019 07:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190916134802.8252-1-ap420073@gmail.com> <20190920165942.7e0d6235@cakuba.netronome.com>
In-Reply-To: <20190920165942.7e0d6235@cakuba.netronome.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 22 Sep 2019 23:36:00 +0900
Message-ID: <CAMArcTUm6opp1J2pAhshhJvUYkqM15REhem_Dw+Fyu9m17rDXA@mail.gmail.com>
Subject: Re: [PATCH net v3 00/11] net: fix nested device bugs
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 at 08:59, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 16 Sep 2019 22:47:51 +0900, Taehee Yoo wrote:
> > This patchset fixes several bugs that are related to nesting
> > device infrastructure.
> > Current nesting infrastructure code doesn't limit the depth level of
> > devices. nested devices could be handled recursively. at that moment,
> > it needs huge memory and stack overflow could occur.
> > Below devices type have same bug.
> > VLAN, BONDING, TEAM, MACSEC, MACVLAN and VXLAN.
>
> Is this list exhaustive? Looks like qmi_wwan.c perhaps could also have
> similar problem? Or virt_wifi? Perhaps worth CCing the authors of those
> drivers and mentioning that?
>
> Thank you for working on this!

I couldn't test all interface types.
So there could be more interface types that have a similar problem.
I will send a v4 patch and add more authors to the CC list.

Thank you so much for your review again!
