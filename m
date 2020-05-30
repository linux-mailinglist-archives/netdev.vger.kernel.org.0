Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C22F1E9093
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 12:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgE3Kdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 06:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3Kdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 06:33:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFE9C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:33:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id mb16so4575432ejb.4
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sIYdpl9lLXr4tqNDG1WzhL1+k1sB9swTRR9XMrZ+KF4=;
        b=ANhxyxLiqmzNTOJyBy5hKXnfM7vGeMRbCuwW6wAgUTblkLqOT0kvMx4SA1n2tPkYZD
         frkb0d4hNli/n6n9syDjjWjJW+X7WESmp9MPRqPO8Awf0GWYtnxBmdw/153rcG6hPJbF
         wcz/vujijXuIepYKRQ4ETdI/DDeCP69JgjkGEOVoQS2/EalQ9+yRXbft0Xj/OOda1Zam
         zHnM1+uBqQWRwAdFcjbbJYENwPmZcy1h9d3vQJq5BQZyRXZIGgfx2r69ZX9htSNb8kzf
         dcENkyQTuaHSqgeQBfqO2vwopxUEGzfBQ1Wsz2PIDcfcUmHogJwfZ4oOsv5gXrgLoM+m
         Aiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sIYdpl9lLXr4tqNDG1WzhL1+k1sB9swTRR9XMrZ+KF4=;
        b=HBobXuWK1fHsw8HnJq3JWXktfCjpzQtypWeSyMR8bDa8DceknW6O3XygNguA+q1t6m
         R0EHExgU8Jbo77tcra4hekgLs56uk342oeeFnlxNKibaAjm1Nvm+SJ1/sCnolqFpb9yt
         UqhPKwWt4yDc7omptxRGigcHBLaVS9lFLTwKGtNtyR2tSAKp6kJdPakYYKH2gBdn1cSL
         d3hj53ivjiU6hJEBRPMqk72Ni96o0eyuBhQyNAGNOeWAUGy0CYsAtiNSKU2DCPdGYuSl
         WFG5OhdJkc8NiGm5eLllRG1Ul0sm4aAiy6UKM0oL+wDbgexAYtRTFz1A1S75clkHIMZW
         MKRw==
X-Gm-Message-State: AOAM532Trw9NfKgrIOAh+xTeeafa36DhqDHN054nFRPuAar2Hvr22WwQ
        xxOU3X6a/Ax6NRyCUcLmiUZSsjb9EhedOj6YKIY=
X-Google-Smtp-Source: ABdhPJw/b6F2hjETgOgO4oR+Za+ws1XJ1Gcg6cAgnBJjZbpb/7CPIAzaF3mwutD1cr8woV5L5rM9LkGCAEjo646P2QU=
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr5843879ejb.473.1590834824111;
 Sat, 30 May 2020 03:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200527164006.1080903-1-olteanv@gmail.com> <20200529.164506.2200622965835884094.davem@davemloft.net>
In-Reply-To: <20200529.164506.2200622965835884094.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 30 May 2020 13:33:33 +0300
Message-ID: <CA+h21hpKeBsxdeK5oFZJ+ndFHXD6tNaGa9hpPtpEk41KPrW69w@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix port mirroring for P/Q/R/S
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 May 2020 at 02:45, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Wed, 27 May 2020 19:40:06 +0300
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The dynamic configuration interface for the General Params and the L2
> > Lookup Params tables was copy-pasted between E/T devices and P/Q/R/S
> > devices. Nonetheless, these interfaces are bitwise different (and not to
> > mention, located at different SPI addresses).
> >
> > The driver is using dynamic reconfiguration of the General Parameters
> > table for the port mirroring feature, which was therefore broken on
> > P/Q/R/S.
> >
> > Note that I don't think this patch can be backported very far to stable
> > trees (since it conflicts with some other development done since the
> > introduction of the driver).
> >
> > Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Please fix the build errors reported by the kbuild robot.

So the kbuild robot said that it couldn't apply the patch on net, so
it tried on net-next and hit some further W=1 warnings.
So I've fixed the warnings and targeted the patch against net-next:
https://patchwork.ozlabs.org/project/netdev/cover/20200530102953.692780-1-olteanv@gmail.com/
(I don't think anybody should care enough that they should deal with
the resulting conflicts from targeting against net).

Thanks,
-Vladimir
