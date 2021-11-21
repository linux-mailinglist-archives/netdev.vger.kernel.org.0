Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DFF4585EC
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 19:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbhKUSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 13:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhKUSfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 13:35:05 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E123CC061574;
        Sun, 21 Nov 2021 10:31:59 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o20so22406707eds.10;
        Sun, 21 Nov 2021 10:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SFC/pSdprH3d2GT5i6Gdky4mSVlOXEPJWz3Dvjdgs6g=;
        b=IkRGtU8232pQLDQpwe4jJ69B7xwok6qiK3CAvnQFOypTz3phKLwChIqe7gG84/5aYd
         NfwTIsQpo7otoq45wCKsHN3MK9XiPaQwUO8MGtvztNdgZq+43vj8Oo4B1tlxaGBr+PD1
         h997mHyv4psCSh4DLZoORJPTstECYgsU1X8IeZdab7QF/53g5UyR+sRlQ5v0koQtev2A
         4jFzRZI+MDH2rdbXAU/B/5VvGmqegwxKi1UV6jhj9PWSDFvx3TamzKgSbPE7NHq1uwwm
         WVR66cpOsbfhAO0hhXTSfUHDEJvqNe2cgL3aRzYbTFvWBNsDt9TzHeY50aJQxVsiAYPA
         efaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SFC/pSdprH3d2GT5i6Gdky4mSVlOXEPJWz3Dvjdgs6g=;
        b=Uk1oOTnvuQaJrNmjWfZKosM3sLDzhh0ClDi7gHNhHKC9ez77X8LysdqAhh7680uB9D
         dZjV7OWmGdUKp1YYZmbfJPtSx8YeYOxkVIP91CJ8hsFXlZWqX2lwlvN1wTvSUwudYP2C
         LcNYCXZWmHFzeYYA3Diodn8+iA88SsSkDtVAjEO8G2bUUHTaNgFTN1MkJ6Nc6IdhfLi7
         LvrfyyFr+XJPYHx5Hk5zj/E7PEPNwUfJEnZJ8rYa4TlsNE1SocAFGWvFHWJBaX17WX2y
         uhJFbyt3YnvyuHAAeaasIWs6nnk2fh3n/7zZCTz/ObdUkm04R2MBBy4JbvoFbvZJNhJj
         yuhQ==
X-Gm-Message-State: AOAM533Yy0YbbYTe3gyk7zCtrUO833Mm2PBk8rdchj2U8yOeV77Mz2Dh
        KUBk1TRAy7I6wkIXksjNtbY=
X-Google-Smtp-Source: ABdhPJy/y1ny1DMj2OV7awKiZUpZ26QU9mNNUr9g8JD9lr8azn19PnVkkSURWcTduNPFokn8iK+u7g==
X-Received: by 2002:a17:907:6d99:: with SMTP id sb25mr35068688ejc.261.1637519518342;
        Sun, 21 Nov 2021 10:31:58 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id hg19sm2646270ejc.1.2021.11.21.10.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 10:31:58 -0800 (PST)
Date:   Sun, 21 Nov 2021 20:31:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 08/19] net: dsa: qca8k: convert qca8k to regmap
 helper
Message-ID: <20211121183157.nbpkqznmockbh6ck@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-9-ansuelsmth@gmail.com>
 <20211119011410.nvrfm72ccvp4psi6@skbuf>
 <6196fdbb.1c69fb81.e8741.2b6c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6196fdbb.1c69fb81.e8741.2b6c@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 02:28:23AM +0100, Ansuel Smith wrote:
> On Fri, Nov 19, 2021 at 03:14:10AM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 17, 2021 at 10:04:40PM +0100, Ansuel Smith wrote:
> > > Convert any qca8k read/write/rmw/set/clear/pool to regmap helper and add
> > > missing config to regmap_config struct.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > 
> > The important question is "why" and this commit message seems to omit that.
> > Using regmap will be slower than using the equivalent direct I/O.
> 
> Yes sorry, will improve the message.
> The transition to regmap is needed to permit the use of common code by
> different switch that have different read/write/rmw function.
> It seems cleaner to use regmap instead of using some helper or putting
> the read/write/rmw in the priv struct.
> Also in theory the overhead created by using regmap should be marginal
> as the internal mdio use dedicated function and bypass regmap. So the
> overhead should be present only in the configuration operation or fdb
> access.

Ok, no problem with that, just consider that reviewers have limited
attention span, and most of them are not in fact familiar with the
switches you're working with or with what you're trying to do with them,
so providing as much relevant information in the commit message as
possible is crucial to having a smooth way forward with your work.
IMHO I shouldn't have to ask "why" on every one of your patch, the "why"
should already be there.
