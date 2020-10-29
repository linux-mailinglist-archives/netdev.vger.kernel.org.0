Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E229EE46
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgJ2Oa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJ2Oa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:30:59 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D37C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:21:05 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l8so28985wmg.3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sTeULBiD1OTQjCqK9NH7W04tF/RFSsIi0nh2m74wYYk=;
        b=qhvsU8bsyHVJX9wRizhkPR5eajPeSL7bPLRMb3qDtqMARlD7EFVdSIC6SRcevrZACK
         L8vsb1fr7B20CqoTncOmFClITuE6HnBp0sHZaz0SZp2KOM0JrwU8opuCfUfUlrce3WGs
         lm9PCgVl86LqZNSdIzV6IyqrRI16mpJoBiIZY1ADhscO7g5S9sSwxd40CIEsA4zegBpX
         V/tNwRalJ0wLd6dhRNecPSSFYY/INHQIZ5KSEKaeiKp/sZ2aJmGZNaF4Yuo6sbNXhwZq
         X/1u7444w6Jq+zDf91P2m1wUCVoZk/M39UpVMQdRmCty1igzY7WABHi9Dqwz+CgDLhGS
         nWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sTeULBiD1OTQjCqK9NH7W04tF/RFSsIi0nh2m74wYYk=;
        b=FIEEfi7L9O+7IQBpH/2U+Kd0IXhvg5rb59knyJri7W43VArC+cEWLKUqd7A6vsMBlp
         igrBpsVAk+LFT2MdssPbCtWTdbAqbuo3Z2jnNa6T+zDPAR7Md6M9WXtMXmIwmVp3j5ut
         tHpj/3TkOXF1LMuo/zsiIzf8S1LYiVDlGodQxlJa1/AGcQ05JSgR1VdendbHsi8CQ17O
         0EWYGLGbcoTo3JI70JMCn25ciJOFaZX7l5aIKGV2Q46PR9s3svVlvZuMVjrtNCgjH47n
         jBzRJBhf6YoP8ld6hiUjW7d0XMDB/4ATx2Q+Q95TDtG0NDBVjVU5KtEUOFSptMdYTc3h
         H6Mw==
X-Gm-Message-State: AOAM530npYWLPmaeH4JB/WnVbhKK1Hmq0NLeDg5RuJWmcMNkuK9rxWaI
        J9kaehzIEP6B9vCHr24TH37hGg==
X-Google-Smtp-Source: ABdhPJwdWqzb8nAOFfKiqSZqDZnJRGG4ub/zxddemdxHv4W5tmdrBgzh3Qz2buSjb2OsbUx8/Dh7zw==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr32575wmg.107.1603981264366;
        Thu, 29 Oct 2020 07:21:04 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id n5sm5290154wrm.2.2020.10.29.07.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:21:03 -0700 (PDT)
Date:   Thu, 29 Oct 2020 16:21:00 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201029142100.GA70245@apalos.home>
References: <20201017194904.GP456889@lunn.ch>
 <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch>
 <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch>
 <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch>
 <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
 <20201025144258.GE792004@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201025144258.GE792004@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

On Sun, Oct 25, 2020 at 03:42:58PM +0100, Andrew Lunn wrote:
> On Sun, Oct 25, 2020 at 03:34:06PM +0100, Ard Biesheuvel wrote:
> > On Sun, 25 Oct 2020 at 15:29, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sun, Oct 25, 2020 at 03:16:36PM +0100, Ard Biesheuvel wrote:
> > > > On Sun, 18 Oct 2020 at 17:45, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > >
> > > > > > However, that leaves the question why bbc4d71d63549bcd was backported,
> > > > > > although I understand why the discussion is a bit trickier there. But
> > > > > > if it did not fix a regression, only broken code that never worked in
> > > > > > the first place, I am not convinced it belongs in -stable.
> > > > >
> > > > > Please ask Serge Semin what platform he tested on. I kind of expect it
> > > > > worked for him, in some limited way, enough that it passed his
> > > > > testing.
> > > > >
> > > >
> > > > I'll make a note here that a rather large number of platforms got
> > > > broken by the same fix for the Realtek PHY driver:
> > > >
> > > > https://lore.kernel.org/lkml/?q=bbc4d71d6354
> > > >
> > > > I seriously doubt whether disabling TX/RX delay when it is enabled by
> > > > h/w straps is the right thing to do here.
> > >
> > > The device tree is explicitly asking for rgmii. If it wanted the
> > > hardware left alone, it should of used PHY_INTERFACE_MODE_NA.
> > >
> > 
> > Would you suggest that these DTs remove the phy-mode instead? As I
> > don't see anyone proposing that.
> 
> What is also O.K, for most MAC drivers. Some might enforce it is
> present, in which case, you can set it to "", which will get parsed as
> PHY_INTERFACE_MODE_NA. But a few MAC drivers might configure there MII
> bus depending on the PHY mode, RGMII vs GMII.
> 
>     Andrew

What about reverting the realtek PHY commit from stable?
As Ard said it doesn't really fix anything (usage wise) and causes a bunch of
problems.

If I understand correctly we have 3 options:
1. 'Hack' the  drivers in stable to fix it (and most of those hacks will take 
   a long time to remove)
2. Update DTE of all affected devices, backport it to stable and force users to
update
3. Revert the PHY commit

imho [3] is the least painful solution.


Thanks
/Ilias
