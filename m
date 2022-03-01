Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D97F4C7F7E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 01:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiCAApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 19:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiCAApf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 19:45:35 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2330FE6;
        Mon, 28 Feb 2022 16:44:55 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id w63so24035339ybe.10;
        Mon, 28 Feb 2022 16:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Nf/egCx0Q4I70uptkgfjEanQfEaR61lPRDpLPBXJeg=;
        b=M+GwEY56nFU9oLTxjb+5lEoD3/IkffH/Jqm+d2voDBhw0M2ZssZlz68XVTNiqKyZex
         2VYv/3KS0AQxzBjYeFCfmGuNnryR//ge5e5Xzm15Z8mqNUp9KLUmbhXKpD0W1YE64Uaa
         IXn7ED/d8T57Da2dbfaXSdp54mQuJ2ItYjUdGIrH5tPeWIgO8fNoJ8fTosV3Gt1AzSS3
         dyLNdP/Ree1IpO9xk4qOB31rUq8Uudb14yBkgUz4WKmb33H3RDnQD9+2QL9BSy62y8Wj
         Dykqh/rhsuUV/UiD50AK1Bvrt55DvegldSmB0GzIImVTOuiw+BZboMZn95y5UAoMewJR
         8EOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Nf/egCx0Q4I70uptkgfjEanQfEaR61lPRDpLPBXJeg=;
        b=VUreuHBzKsqw3BAw0IpLFshNwj0+RBTrJAmvUD7eDFi1jdscwQsopmjoYkQm60N1FU
         68xobvmoscpGzCjTl/cOCjX5vZmwbarTwtsHEi0W96lGaxdQLt5iGzSP1kW3xeN/tS3m
         QaS6TEqJN81cXZYSgGYDU/A7/3t1pepGzaeW/EWEOUErAQXBbTIrLuNRhHxkgh478z2w
         Saipwpm9ZNWZO+XU/R4NnR7kXD1HuMB6blkNuxDEEDSgkoL6wqvzlbaaJC37s2IndV8U
         udQeNHSUMMjL4WfEWJ6D75E+PssJIFhACABS4LobNwLH93CkEvN9mzIRRSASKPmQB1qG
         3sKQ==
X-Gm-Message-State: AOAM532L8pvyv7SA+gFg1D+sOEfaYF6aTgu8RcmaIIXN3yQD1QNmTTC7
        UEtXWeoF9tLLU3kfMMDYIUj06LXK94sPl+5pzGs=
X-Google-Smtp-Source: ABdhPJwsZJOjFD+cAucEDnn2/44FhTiZJamnT2r0djxxGeEJQ+yLbZW1dmeCwnmdpyrs9rjHJusatuYijDxFVPCWY3I=
X-Received: by 2002:a25:f80c:0:b0:624:40aa:44ab with SMTP id
 u12-20020a25f80c000000b0062440aa44abmr21715244ybd.51.1646095495077; Mon, 28
 Feb 2022 16:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20220228233057.1140817-1-pgwipeout@gmail.com> <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
In-Reply-To: <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Mon, 28 Feb 2022 19:44:43 -0500
Message-ID: <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 7:14 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Mon, Feb 28, 2022 at 06:30:57PM -0500, Peter Geis wrote:
> > The sentinel compatible entry whitespace causes automatic module loading
> > to fail with certain userspace utilities. Fix this by removing the
> > whitespace and sentinel comment, which is unnecessary.
>
> Umm. How does it fail?

It simply does not auto load the module by device id match.
Manually loading the module after the fact works fine.

>
> >  static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> >       { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > -     { /* sentinal */ }
> > +     {}
>
> These two should be 100% identical in terms of the object code produced,
> and thus should have no bearing on the ability for the module to be
> loaded.
>
> Have you investigated the differences in the produced object code?

Yes, you are correct, I just compared the produced files and they are identical.
This patch can get dropped then.
I'm curious now why it seemed to make a difference.

I am not familiar enough with how the various userspace elements
decide to match the modules to determine exactly why this is failing.
It seems to be hit or miss if userspace decides to auto load this, for
instance Ubuntu 20.04 was happy to load my kernel module built with
the arm64 official toolchain, but Manjaro will not load their self
built kernel module.
I originally suspected it was due to the manufacturer id being all zeros.
Unless there's some weird compiler optimization that I'm not seeing in
my configuration.

Any ideas would be appreciated.
Thanks!

> If not, please do so, and describe what they were. Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
