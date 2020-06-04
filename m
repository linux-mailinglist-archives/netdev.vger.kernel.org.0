Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402071EEBBC
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgFDUSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgFDUSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:18:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62760C08C5C2
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 13:18:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m1so4059372pgk.1
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 13:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KSgduwKhAGu1Me5hdrsNlT/LSTVts5IMrrdQbnnmgtM=;
        b=iwsRqxQEY+LpPM+s+DR5Kt1prnKy4GHGxqj/QUqqkkqSMBCDJe1CHdT/yKZJkiBDXL
         Y6szw+en5NZ6khTYpwS0FGviJsYX/r26zXRpTi2oURHUxJskaDdTNYF20YKqgU+50wUG
         aJZ2WjX85SJKBXLpicthf/oXnlRh2W1BmzGAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KSgduwKhAGu1Me5hdrsNlT/LSTVts5IMrrdQbnnmgtM=;
        b=nowMnB4YaYo3ReYPq05t53OOUnwsmJwcA131mlx1Y3nzL6avom6pnBilkr+Em6mQZj
         O6lmT6oS3lplskoIid0vYwkZWy6Psqr2vQ6kSSa9quBeleraDIKSEdxPVFlbD/uz2EOj
         yfCT+8WCAHtXBdEjWr3LccWHImlUkXg1xNdyJ9gYRE4cbWEDQ7lmaubKor/j9pJu95Cp
         SilQcDtG20TTwFHTU+9BCMsy14XzA+mqQeeWuOwzcRjn2YM6iADC6UeBDxtQHRSou+ib
         BBf0/QghPgVcnYB6WrhF21Xzal3JVfDu46r6VQXR081lXc3AkvjZIlbiTyZV7FQ4iEQe
         URRg==
X-Gm-Message-State: AOAM531aNqDzLKlFb0RQvehW5PgiYff7fjRgEsyMd5aWf2x6CVPu3/lH
        AV7lKY7vbgDXXBDMbFLiDnzlKw==
X-Google-Smtp-Source: ABdhPJy6jmo6NLjATFT9PEAZE69aJp2ake2/5E+UKA7LNV6vmFPBoWj+KBik/aUM7ISRTcCYuBBaWw==
X-Received: by 2002:a63:c58:: with SMTP id 24mr6232804pgm.246.1591301913875;
        Thu, 04 Jun 2020 13:18:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r5sm5581320pji.20.2020.06.04.13.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 13:18:33 -0700 (PDT)
Date:   Thu, 4 Jun 2020 13:18:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH 03/10] b43: Remove uninitialized_var() usage
Message-ID: <202006041316.A15D952@keescook>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-4-keescook@chromium.org>
 <CAKwvOdnNuFySqAMk7s_cXqFM=dPX4JfvqNVLCuj90Gn4tzciAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnNuFySqAMk7s_cXqFM=dPX4JfvqNVLCuj90Gn4tzciAw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 01:08:44PM -0700, Nick Desaulniers wrote:
> On Wed, Jun 3, 2020 at 4:32 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > (or can in the future), and suppresses unrelated compiler warnings (e.g.
> > "unused variable"). If the compiler thinks it is uninitialized, either
> > simply initialize the variable or make compiler changes. As a precursor
> > to removing[2] this[3] macro[4], just initialize this variable to NULL,
> > and make the (unreachable!) code do a conditional test.
> >
> > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/net/wireless/broadcom/b43/phy_n.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> > index d3c001fa8eb4..88cdcea10d61 100644
> > --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> > +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> > @@ -4222,7 +4222,7 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
> 
> The TODOs and `#if 0` in this function are concerning.  It looks like
> `rf_pwr_offset_table` is only used when `phy->rev` is >=7 && < 19.
> 
> Further, the loop has a case for `phy->rev >= 19` but we would have
> returned earlier if that was the case.

Yeah, that's why I put the "(unreachable!)" note in the commit log. ;)

> 
> >         u32 rfpwr_offset;
> >         u8 pga_gain, pad_gain;
> >         int i;
> > -       const s16 *uninitialized_var(rf_pwr_offset_table);
> > +       const s16 *rf_pwr_offset_table = NULL;
> >
> >         table = b43_nphy_get_tx_gain_table(dev);
> >         if (!table)
> > @@ -4256,9 +4256,13 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
> >                         pga_gain = (table[i] >> 24) & 0xf;
> >                         pad_gain = (table[i] >> 19) & 0x1f;
> >                         if (b43_current_band(dev->wl) == NL80211_BAND_2GHZ)
> > -                               rfpwr_offset = rf_pwr_offset_table[pad_gain];
> > +                               rfpwr_offset = rf_pwr_offset_table
> > +                                               ? rf_pwr_offset_table[pad_gain]
> > +                                               : 0;
> >                         else
> > -                               rfpwr_offset = rf_pwr_offset_table[pga_gain];
> > +                               rfpwr_offset = rf_pwr_offset_table
> > +                                               ? rf_pwr_offset_table[pga_gain]
> > +                                               : 0;
> 
> 
> The code is trying to check `phy->rev >= 7 && phy->rev < 19` once
> before the loop, then set `rf_pwr_offset_table`, so having another
> conditional on `rf_pwr_offset_table` in the loop is unnecessary. I'm
> ok with initializing it to `NULL`, but I'm not sure the conditional
> check is necessary.  Do you get a compiler warning otherwise?

I mean, sort of the best thing to do is just remove nearly everything
here since it's actually unreachable. But it is commented as "when
supported ..." etc, so I figured I'd leave it. As part of that I didn't
want to leave any chance of a NULL deref, so I added the explicit tests
just for robustness.

*shrug*

-Kees

-- 
Kees Cook
