Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475FE298206
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416496AbgJYOQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733290AbgJYOQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 10:16:48 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B361822269
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603635407;
        bh=BpT7dGUcv92fHdCH8L+Qxv2MWcDoKlpgTSWW0BGhye8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y8gFUByrLx2IuY0aSywgmKE+ahXE96VCgQ2XXa1qwF0ETrwHZtMqlM3MdVikBBeLH
         t9wcA++2GIwIx4nnYVZsaGM/SzLcFvnRmv6hOT83BGonhD0445cB3Xpk+UdbC8z4SN
         m7/iYT54vqVjCNeFsncXhhB1Q+fxVLZI/iqSRWbM=
Received: by mail-ot1-f45.google.com with SMTP id o14so5782475otj.6
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 07:16:47 -0700 (PDT)
X-Gm-Message-State: AOAM530pGP3S3M8eCUqRHF7ZgXGn6UgEizfrrVGc419oR2/dseI0lm2d
        ou+gmyA1tjo3lXrZjO11dwK5YbpxwjS3fI2iRIw=
X-Google-Smtp-Source: ABdhPJwTnliM3TRQ0arh9bvvmdH24GAHs/h1IwB0F0IZYMxXibWPuAggUFQ0oSklDABddx1ujXmIzKe8BGh2gFsrahs=
X-Received: by 2002:a05:6830:1f13:: with SMTP id u19mr1099923otg.108.1603635407106;
 Sun, 25 Oct 2020 07:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch> <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch> <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch> <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch> <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com> <20201018154502.GZ456889@lunn.ch>
In-Reply-To: <20201018154502.GZ456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 25 Oct 2020 15:16:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
Message-ID: <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 at 17:45, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > However, that leaves the question why bbc4d71d63549bcd was backported,
> > although I understand why the discussion is a bit trickier there. But
> > if it did not fix a regression, only broken code that never worked in
> > the first place, I am not convinced it belongs in -stable.
>
> Please ask Serge Semin what platform he tested on. I kind of expect it
> worked for him, in some limited way, enough that it passed his
> testing.
>

I'll make a note here that a rather large number of platforms got
broken by the same fix for the Realtek PHY driver:

https://lore.kernel.org/lkml/?q=bbc4d71d6354

I seriously doubt whether disabling TX/RX delay when it is enabled by
h/w straps is the right thing to do here.
