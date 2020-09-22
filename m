Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD5273F6F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 12:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIVKRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 06:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIVKRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 06:17:35 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C678C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:17:35 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g96so15083245otb.12
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 03:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C4wv3gq4jH4kXiqr9HoaHT5g3RKprwq2Zsckomw6Mug=;
        b=xAunoLiwJSD85u4GcMCZTb0HaWVBYP1IeHYBuva/rKcEz3d3wWA/5kTAsufc1NslLJ
         o7v06wwMgFZU9BgjZwgixvTaDaw9cX9CyfyGqAMEYtKoPek2D/naJuGpywMav20paRna
         fXavgDKykj++zR90Bp6tRmje1Iv/FELpQnO1VX5w+ePKHG/Qi6UDt7hUoVDgiOXpNlWo
         DAdiDPtHMRRefQQCEfG3iUyJBYzQ9+tDT2CwXKj8sSAVujd+T420gzKE/JaLa6z6Clf4
         tMl4MEImzwiBK9+P9oR+lZtfn8OH8oqsRAjTMqJ64nU1O26++/5dVg8BP2M7dHnevOXF
         Xcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C4wv3gq4jH4kXiqr9HoaHT5g3RKprwq2Zsckomw6Mug=;
        b=XqB+MUNO3q35OCQvkfPKXq4vX5sAj7MwkvJkK4SKF4H+TAySWkp9XYa8yBdWAU65Om
         VGoCZy0uo4z1cxVQ4Vfaqq3nJMk+vEZACj8jdmhh9/y4vB7LXTuAJL9mYlQEGE6i8xXH
         E6MBHY3//AFz/fll7QhrJtcmdEmVJZENHAVWSLx3oPfWTTzXY6zJSq5RMz6C1YLd6Le0
         WXVVYKcqbCQ6jMJ+x6x4UXivD0mJf00oOrQ/tbfhhkg9TkWm7gO9R3BuXXaUlkK43RhS
         1mhWaWh6edLnzlDDZlN7bPNEN5XH/4IA+twKME/6kSEZMfKqsawI1b8/si93Czlh8/of
         QvJg==
X-Gm-Message-State: AOAM533qc7BCGp+a1X9nmsIWD0/HNYHXXI+ks2QcmGQlqfO81cxqs6bl
        Cy6q2GsV5a8KCu984sNe3yh75hM+jVrAlsyvEUJt4w==
X-Google-Smtp-Source: ABdhPJxbwFx7g1eBM13nl+6wdUDexN4d6NL/JJklai3ilHkBZyhnBiqx8SgS8+AYox+Ug4Xo6oK5X3hqXwdsPr3reDM=
X-Received: by 2002:a9d:ecc:: with SMTP id 70mr2347123otj.66.1600769854529;
 Tue, 22 Sep 2020 03:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200920141653.357493-1-robert.marko@sartura.hr> <20200921.144841.1356454980970038338.davem@davemloft.net>
In-Reply-To: <20200921.144841.1356454980970038338.davem@davemloft.net>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Tue, 22 Sep 2020 12:17:23 +0200
Message-ID: <CA+HBbNFdPkkL-gtAsTFww7bWjLADbXQuEfaTa-YGT6cbzN3btw@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] net: mdio-ipq4019: add Clause 45 support
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 11:48 PM David Miller <davem@davemloft.net> wrote:
>
> From: Robert Marko <robert.marko@sartura.hr>
> Date: Sun, 20 Sep 2020 16:16:51 +0200
>
> > This patch series adds support for Clause 45 to the driver.
> >
> > While at it also change some defines to upper case to match rest of the driver.
> >
> > Changes since v1:
> > * Drop clock patches, these need further investigation and
> > no user for non default configuration has been found
>
> Please respin, in the net-next tree the MDIO drivers have been moved
> into their own directory.

Done,
I completely missed the commit moving them to MDIO subdirectory.

Regards
Robert
