Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1A721D7FA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgGMOMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgGMOMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:12:22 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED957C061755;
        Mon, 13 Jul 2020 07:12:21 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d18so13823959edv.6;
        Mon, 13 Jul 2020 07:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ybYxR1GRnq5IyovTfClT+C6t+JkS/8OJ9dnDjjyYAlQ=;
        b=i/WhEHWB951iAbrT2J/PBgio1raDichTwdYsve8dmI8ewVDJrriAewvgU7COnYla31
         LQ73zLJwxVeM+kQPi/JhCJV6Y3xzt3yyn9BA8VikaPku6J3lQ0AHKpNkdS+ESDB3fmDi
         ppxsYSfxJ9fs9kGTTvyoDJqnuxSOQDqw9kRVRQ6iLaEep0fEO/RkDeHdvHbpJ1y2JmTA
         63qeBWuluhYGbEyclY2bm68Vx9eZ7mu4Jf7brLKiw96NeSNQMZYjLIJ02qgCqI7A7fza
         P86mMbYzly3TmQnvR7JF1CBVfE9xx0+rHQSxFQoMieF0HMNEmmmaWB7StPbn1s9efYWf
         nSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ybYxR1GRnq5IyovTfClT+C6t+JkS/8OJ9dnDjjyYAlQ=;
        b=lL+YTmQJZ1ESIqvO40t8axExqdYD3FUg2wKtIAFoamKb1VFYjfbAsC15HTx9Djk7T+
         EF8i/zN73mNOAfPLXyc9jmqRakv2N72QsEC/itdrhWWO1dltlFdy6tebXSdFJYRYBWa2
         7A4R3BoWmlcLRJuXrhl8QJpHsHi9RFT6uwj4NjVaOfmzSqztVlKNtzvbui3NloQFc1+S
         wmcG0IJmRziqvGhWOxbZKqgJby1ycSfkoCdxiYTj4/N2a4EUmnPFNqivo+IQu8kSSS6h
         atA6e4GQoIN9HsQcPI4mVtKO5zpDcZOqXpeeaoimLOlklij68g+IsqiZAE08UmQ7X14/
         5OcA==
X-Gm-Message-State: AOAM533/2mudr/Nba/qamPPCDSgKKP4C218zgBWQTHIDxEAc/DTaPyCH
        yZJw487F4tDAhI4XYXX2vaY=
X-Google-Smtp-Source: ABdhPJw/8jHf9QA0AJm4G5lfM69GPdfyK/swpa872/c1BG2bJZ2NWH3dR7A0bYnIc4r8J6YHnq//5w==
X-Received: by 2002:a50:9b18:: with SMTP id o24mr93210935edi.335.1594649540641;
        Mon, 13 Jul 2020 07:12:20 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ck6sm11436045edb.18.2020.07.13.07.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:12:20 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:12:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 4/8] net: dsa: hellcreek: Add support for hardware
 timestamping
Message-ID: <20200713141217.ktgh5rtullmrjjsy@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-5-kurt@linutronix.de>
 <20200713095700.rd4u4t6thkzfnlll@skbuf>
 <87k0z7n0m9.fsf@kurt>
 <20200713140112.GB27934@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713140112.GB27934@hoboy>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 07:01:12AM -0700, Richard Cochran wrote:
> On Mon, Jul 13, 2020 at 12:57:34PM +0200, Kurt Kanzenbach wrote:
> > > I would like to get some clarification on whether "SKBTX_IN_PROGRESS"
> > > should be set in shtx->tx_flags or not. On one hand, it's asking for
> > > trouble, on the other hand, it's kind of required for proper compliance
> > > to API pre-SO_TIMESTAMPING...
> > 
> > Hm. We actually oriented our code on the mv88e6xxx time stamping code base.
> 
> Where in mv88e6xxx does the driver set SKBTX_IN_PROGRESS?
> 

That's the point, it doesn't, and neither does hellcreek.

> I don't think it makes sense for DSA drivers to set this bit, as it
> serves no purpose in the DSA context.
> 

For whom does this bit serve a purpose, though, and how do you tell?

> Thanks,
> Richard

Thanks,
-Vladimir
