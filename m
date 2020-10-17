Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0E8291286
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 16:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438409AbgJQOqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 10:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438394AbgJQOqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 10:46:36 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 070D92076D
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602945995;
        bh=MHaMFyw66K1LRWJ4lLT2U9DsB1+QhMM7S24Md658u0E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wUJV8tFKoBCuIyJ1UKCJYVL01lE8ts+i58WMtlUwWqvPeMWwvQhTbvmPymygKqf7h
         fPwXdXGmoECU5KLoMbaSvkiot7tPR8CG6Vv5h0G1xcYKpKrcXKXGYa2syFWxcpyBso
         +phOeL7sO4pcTkNt5fwkZlMJ9bH9laaeavV74GYY=
Received: by mail-ot1-f46.google.com with SMTP id i12so5501278ota.5
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 07:46:34 -0700 (PDT)
X-Gm-Message-State: AOAM531u9ZqdLUlavbaA8pvY/r/9cE52AQqV1a3Ags1ahgE2ifOjUI/x
        Bm5CTzRajac5kuGPZ6zc/bTG+YqwuInFKxlheqU=
X-Google-Smtp-Source: ABdhPJwPoIdDwfYixJlVPKR4O7Ry/rr1pU/36dIxvpsnfp7/t9H+eBZKHjCZPOtR8REWLKxwZj0dOEWfPALpTYtlszQ=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr5966382ots.90.1602945994351;
 Sat, 17 Oct 2020 07:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch>
In-Reply-To: <20201017144430.GI456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 17 Oct 2020 16:46:23 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
Message-ID: <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Willy Liu <willy.liu@realtek.com>,
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

On Sat, 17 Oct 2020 at 16:44, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Oct 17, 2020 at 04:20:36PM +0200, Ard Biesheuvel wrote:
> > Hello all,
> >
> > I just upgraded my arm64 SynQuacer box to 5.8.16 and lost all network
> > connectivity.
>
> Hi Ard
>
> Please could you point me at the DT files.
>
> > This box has a on-SoC socionext 'netsec' network controller wired to
> > a Realtek 80211e PHY, and this was working without problems until
> > the following commit was merged
>
> It could be this fix has uncovered a bug in the DT file. Before this
> fix, if there is an phy-mode property in DT, it could of been ignored.
> Now the phy-handle property is correctly implemented. So it could be
> the DT has the wrong value, e.g. it has rgmii-rxid when maybe it
> should have rgmii-id.
>

This is an ACPI system. The phy-mode device property is set to 'rgmii'
