Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CC9295679
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 04:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895172AbgJVCmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 22:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443489AbgJVCmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 22:42:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B857C0613CE;
        Wed, 21 Oct 2020 19:42:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n16so38895pgv.13;
        Wed, 21 Oct 2020 19:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kNdl5iodQjvM/F33JIUS3BxgGv7Zif9Z++QvccWd7nA=;
        b=GcZY1XCayghLGNFMu5xJ6PWnRjwFYDoW5qej1Ijg+WSFxEuAmhOBzxiZV5o9lMXUgW
         sMcI2t8Q5oyr6fyWkyapL3tqsujWmfogO/RDawbE5yLW7zH+EzrCflp/KkUsdCvysQbn
         TKKe0WBuqlNfEZoDVwNrOkepLpNXwwXHmECvGozow4MomVZMlrARzsoMR/jCnM3TrP02
         wACo4wntFodCTRbw/XAfkz6nRJj5NSnADKA7quzPyN4E8nwtTzH5uTvlhmiHEywvYtZB
         p/+Po3Kuo1l2VscijeXF9971T2PVJWUsBMojVa6nk2uN0Ql2t8dCb/dk4owx2l0PjPzT
         ffiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kNdl5iodQjvM/F33JIUS3BxgGv7Zif9Z++QvccWd7nA=;
        b=YcE3rkLrA3B27p6XyOUG6KDeQA+kc/GfX6CwKVpJ0shZZHlWjlR46Ik3+s/sohyOUv
         lPdwO5by++yWpSc1oEB+cQaE/sojObVwNyOi5sayNw2DN/yETA9yEToH3KoeeLZGPrgb
         FTBtXKrQHA1UlbSiGg8QvNLwo2QFT1Sw9WamxJopTuDrjoWQNCuFZ5vz34K01WHI6/P4
         XSGCUJHPPShQlckZHGAesM83tIA06xK2NmWB7CXVfK7ZWSBBq/WW7BFrMQaMZTIa0a5u
         Hsru9qnbeGwNnk+qcHWoGmdWPvR3meHEtW0rQHITRkiB7zRQHOwQYphaMtIXW+y1bs4i
         l/hA==
X-Gm-Message-State: AOAM532aUO0CpFUHhLnL7FDfcpaSGNSTndgTdLGFdt6LCAm7uCLSOEzr
        X2sJW+Rv0JHupFiSWhxOkTY=
X-Google-Smtp-Source: ABdhPJyEHAvSq+ESP/zNLJMXM9x1CikjSQMvhD7tzNLREKLtEYOcGVD7oGRU2O1ZN4k6lTyBCf8Cjw==
X-Received: by 2002:aa7:9dcd:0:b029:152:421f:23eb with SMTP id g13-20020aa79dcd0000b0290152421f23ebmr366136pfq.58.1603334525088;
        Wed, 21 Oct 2020 19:42:05 -0700 (PDT)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y16sm217167pgh.8.2020.10.21.19.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 19:42:04 -0700 (PDT)
Date:   Wed, 21 Oct 2020 19:42:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201022023233.GA904@hoboy.vegasvil.org>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-8-ceggers@arri.de>
 <20201021233935.ocj5dnbdz7t7hleu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021233935.ocj5dnbdz7t7hleu@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm just catching up with this.

Really. Truly. Please -- Include the maintainer on CC for such patches!

In case you don't know who that is, you can always consult the MAINTAINERS file.

There you will find the following entry.

    PTP HARDWARE CLOCK SUPPORT
    M:      Richard Cochran <richardcochran@gmail.com>
    L:      netdev@vger.kernel.org
    S:      Maintained
    W:      http://linuxptp.sourceforge.net/

On Thu, Oct 22, 2020 at 02:39:35AM +0300, Vladimir Oltean wrote:
> On Mon, Oct 19, 2020 at 07:24:33PM +0200, Christian Eggers wrote:
> > The PTP hardware performs internal detection of PTP frames (likely
> > similar as ptp_classify_raw() and ptp_parse_header()). As these filters
> > cannot be disabled, the current delay mode (E2E/P2P) and the clock mode
> > (master/slave) must be configured via sysfs attributes.

This is a complete no-go.  NAK.

Richard

