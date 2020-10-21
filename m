Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA96294E38
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443219AbgJUOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440711AbgJUOFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 10:05:40 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506D9C0613CE;
        Wed, 21 Oct 2020 07:05:40 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id m128so2178045oig.7;
        Wed, 21 Oct 2020 07:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hWackn7QgGCUo6C9ARR0K33SjtrNVEEV12sdSP+7vYA=;
        b=FBRKvaEz9LujHwoT6c0nbLZ6cHP5qHloQPItQFyTxhpqcGutJuiB6D0u04Zc8S/riw
         tTRv4Y7fBJproOaWBQi34kokvwa1+mt0PJFwq/88B/EI2IHWwaf02tezI9IjriNMj5qH
         I/YEXFtL/pFvk0Ai6pNGQTSYqZWZdIb8cQzeDOSDnhGPsQi6xdjrYP/B6mvsUihwMchN
         5UGhnpiEEFj883NiIozTaehhwJS7GQn1JSGHGrURppnDDOCfkxuu8qsMfCgogXivKAU2
         ljuRYZzn7hYhEJmLal2lu7ingvOdfBgvRiLUCk7VfvAAH/dZWyfnT++xtCDmxpJGv7Cw
         vJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hWackn7QgGCUo6C9ARR0K33SjtrNVEEV12sdSP+7vYA=;
        b=OzMmpxgmcPGdqaoWDzayMskvaH6xohcb8PPEXT9rnep7fwFgj9C9r1v7i42SPUeAsC
         DG+BYSnxycBEMGQfhdn4+QORk2Fvyu/yfZRxY7fV4aMGU29IKXcCMdQvJVpqTCZcWX6L
         cyEQWXxEhRSSCZWWDhtz85meYEp9kRQdQluL79LH3d5Sam2dzfs9PRnDQ202evZOCq+R
         vYEXhYPVzHJJhCC0y3Ln97O2aotQ82bBMOnn8vQauaakikKclxn3ogmbeUhvLv9gZ2Y7
         /kX6r7OllMd2SVH/oMSXbdf0cyWz6BPRahXmZMP4wkWmDXd23pOCDqdcnYcpKquEpgUS
         f+ew==
X-Gm-Message-State: AOAM532k5ABfqbLvnDPLXeFAoP5fpyYf6DS/o5CC0kXDwN327IiJP/rs
        RMakJIIofgZNiPNP95LiiiJ2e7QtzznechCuXVtmQmX1tlQ=
X-Google-Smtp-Source: ABdhPJxKAJyFGKy1WNdsaIUOhazX+MRMNzKXnpZL6qckOtqBiRgDUmsCOtygh+0mb39mZzoQKlavlsF3G0uKieV2o3U=
X-Received: by 2002:aca:420a:: with SMTP id p10mr2263655oia.117.1603289139712;
 Wed, 21 Oct 2020 07:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201021135140.51300-1-alexandru.ardelean@analog.com> <20201021135802.GM139700@lunn.ch>
In-Reply-To: <20201021135802.GM139700@lunn.ch>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Wed, 21 Oct 2020 17:05:28 +0300
Message-ID: <CA+U=DsoRVt66cANFJD896R-aOJseAF-1VkgcvLZHQ1rUTks3Eg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: phy: adin: clear the diag clock and set
 LINKING_EN during autoneg
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alexaundru.ardelean@analog.com,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 4:58 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Oct 21, 2020 at 04:51:39PM +0300, Alexandru Ardelean wrote:
> > The LINKING_EN bit is always cleared during reset. Initially it was set
> > during the downshift setup, because it's in the same register as the
> > downshift retry count (PHY_CTRL1).
>
> Hi Alexandru
>
> For those of us how have not read the datasheet, could you give a
> brief explanation what LINKING_EN does?

So, clearing this bit puts the PHY in a standby-state.
The PHY doesn't do any autonegotiation or link handling.

>
> > This change moves the handling of LINKING_EN from the downshift handler to
> > the autonegotiation handler. Also, during autonegotiation setup, the
> > diagnostics clock is cleared.
>
> And what is the diagnostics clock used for?

The clock diagnostics is used for 2 things: the diagnostics block
[mostly for stuff like cable-diagnostics] and the frame-generator.
The frame-generator is an interesting feature of the PHY, that's not
useful for the current phylib; the PHY can send packages [like a
signal generator], and then these can be looped back, or sent over the
wire.
Maybe it's being used mostly internally by the group that created the PHY

Having said this, I'll include some comments for these in a V2 of this patchset.

>
>     Andrew
