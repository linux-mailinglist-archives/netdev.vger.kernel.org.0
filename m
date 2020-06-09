Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBB81F4812
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgFIU3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387652AbgFIU3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:29:45 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEA5C03E97C
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 13:29:45 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m1so10827548pgk.1
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 13:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pk656TsUJuK10JSeFJHgNch8J905bhLTJffzrmjaoW0=;
        b=G3LYVQE3kgZa52O1qrAqyWmJFU+2tTViQAcnJuNLMbNIs6Qu4xPteyvUQN6N9WJlso
         hhXM1fybFGcJ0zpI48p6hFz7uEm3dL3KFXOoVgaIRJHdbbgzR/xwggGUP5hb3opNT2C1
         kQHQ5U722EiLnMRrEsTK1sWx4kUzbQ4CLbZw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pk656TsUJuK10JSeFJHgNch8J905bhLTJffzrmjaoW0=;
        b=YyD7BhRQAYTiep+Yi5LeoMWIUIvxzEoefFVYqa1hLYQcTFgoHe28QKtCUdGP5KyETm
         LD2+FO8vg4GLD9C70s6lYyeshk6J9qTLMcXjQOqm6dOoWRD1+qz/XxtnWZbMLB1L8hoO
         LZQcDHk7wbA67uFjdt59WLqAhcwyxi++wJ0jghgcdpHaOWvsoAh2yMThw0/04OkrhPO4
         RaKCEQjA6kfhMRvLef9xyP/j+B2Gy/FdGw6yyPix39//GYfFtwCwB4GCywlBuvOro1hu
         1Qid9kLHfW9CnLjaE1XFxM09fgqXZgDoGIStVMPyVwPfVbbc1cIARixbyiDYy3toC70n
         Nc1Q==
X-Gm-Message-State: AOAM530iQ1+PyLrQfjiCynm2KjABm6lCITsN3mXlPSPtNOx0CQln/F3H
        g95G1kHOkFgxGVLrzEDab917gg==
X-Google-Smtp-Source: ABdhPJzZR0RarRXC4o/vHbofF0KapOHjx+EtxFodTOCgJldHereBfqtez3ElV9LNiWAAjv3PzMgcqw==
X-Received: by 2002:a63:e804:: with SMTP id s4mr26473158pgh.260.1591734584700;
        Tue, 09 Jun 2020 13:29:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w17sm11432412pff.27.2020.06.09.13.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 13:29:43 -0700 (PDT)
Date:   Tue, 9 Jun 2020 13:29:42 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Miller <davem@davemloft.net>
Cc:     stephen@networkplumber.org, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, mkubecek@suse.cz,
        linville@tuxdriver.com, david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mkl@pengutronix.de, marex@denx.de,
        christian.herber@nxp.com, amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <202006091312.F91BB4E0CE@keescook>
References: <202006091222.CB97F743AD@keescook>
 <20200609.123437.1057990370119930723.davem@davemloft.net>
 <202006091244.C8B5F9525@keescook>
 <20200609.130517.1373472507830142138.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609.130517.1373472507830142138.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:05:17PM -0700, David Miller wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Tue, 9 Jun 2020 12:49:48 -0700
> 
> > Okay, for now, how about:
> > 
> > - If we're dealing with an existing spec, match the language.
> 
> Yes.
> 
> > - If we're dealing with a new spec, ask the authors to fix their language.
> 
> Please be more specific about "new", if it's a passed and ratified standard
> then to me it is "existing".

Sure. But many kernel devs are also interacting with specifications as
they're being developed. We can have an eye out for this when we're in
such positions.

> > - If a new version of a spec has updated its language, adjust the kernel's.
> 
> Unless you're willing to break UAPI, which I'm not, I don't see how this is
> tenable.

We'll get there when we get there. I honestly don't think any old spec is
actually going to change their language; I look forward to being proven
wrong. But many times there is no UAPI. If it's some register states
between driver and hardware, no users sees or cares what the register
is named.

> > - If we're doing with something "internal" to the kernel (including UAPI),
> >   stop adding new instances.
> 
> Even if it is part of supporting a technology where the standard uses
> those terms?  So we'll use inconsitent terms internally?

What? I mean "internal" in the sense of "does not have an external
dependency". Maybe I should say "independent"?

> This is why I'm saying, just make sure new specs use language that is
> less controversial.  Then we just use what the specs use.
> 
> Then you don't have to figure out what to do about established UAPIs
> and such, it's a non-issue.

Yes, but there are places where people use these terms where they are
NOT part of specs, and usually there is actually _better_ terminology
to be used, and we can easily stop adding those. And we can start to
rename old "independent" cases too.

For example, if MS_SLAVE were being added now, we would rename it.

-- 
Kees Cook
