Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD86B1F4718
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389227AbgFITaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgFIT35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:29:57 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA42C03E97C
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 12:29:57 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b201so18808pfb.0
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 12:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lrNZt0MHOnjftD+toCJiTQv+PMA1xMJhh4w8++pUPGM=;
        b=gbtZcQEDLCUU9CqWf+7FbEgPhzVhA9ZDHdZzwBqQC+hOj8SA68uFyMiv0ElgZZWjtK
         V5TqAf9eBnpuGEAzu03YHBDyI4V1WauNT+QAnXUwF0y8KFKAYEtYpNvXpg8v+QYhwio5
         en6xulro9ueMLbkq3Vlyck9Gza7Bs8r5E3fNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lrNZt0MHOnjftD+toCJiTQv+PMA1xMJhh4w8++pUPGM=;
        b=ghvjDGqwEdCSalsxQVzfQFXOqC2kEIRWutKewKF9IxQM6s6TMN8EBv+O6PhP8X5yJM
         82snY+Ks4A3iPDOOVe8f1Rrz9p0cu57KgTQyEsJShrf9+Q0eHQ3vmEVu96KAe+3bE5PE
         5pY3PuZPNtm4BpCjjk/JTo+I2cZFxuUvEkHos3DVcXbk5PMHL8FxXMGEZJUpybNSwdcY
         cxfLp+BmlfLUFuC/an21shE1yLT8pzcHHDX1Ph/50NHT0wy2XHeE6Hrcuj9jkXzT2hvj
         rffKg1Zmt4q5XyRohAbRYIVZ7Gg7o9GrcjvV9gDruJBOSQ4HUKmLiFVECvOLT+gxOejq
         MBiQ==
X-Gm-Message-State: AOAM532yQ0fNcXQT3/Y+PPvowfxq6W61OH5kr9Mdi/5p8YCKKvDyy0cZ
        wovrRDrOQEa1QFkmrpxF+WikQQ==
X-Google-Smtp-Source: ABdhPJw3u9YjiwkoOUaSfzuKhTCx4daVvmPUXp8gu4QHLoH55ck5aMiWVypH2wi+kNplt0PhZUmWLQ==
X-Received: by 2002:aa7:9558:: with SMTP id w24mr26619306pfq.241.1591730997079;
        Tue, 09 Jun 2020 12:29:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o96sm3319015pjo.13.2020.06.09.12.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 12:29:56 -0700 (PDT)
Date:   Tue, 9 Jun 2020 12:29:54 -0700
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
Message-ID: <202006091222.CB97F743AD@keescook>
References: <20200607153019.3c8d6650@hermes.lan>
 <20200607.164532.964293508393444353.davem@davemloft.net>
 <20200609101935.5716b3bd@hermes.lan>
 <20200609.113633.1866761141966326637.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609.113633.1866761141966326637.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 11:36:33AM -0700, David Miller wrote:
> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Tue, 9 Jun 2020 10:19:35 -0700
> 
> > Yes, words do matter and convey a lot of implied connotation and
> > meaning.
> 
> What is your long term plan?  Will you change all of the UAPI for
> bonding for example?
> 
> Or will we have a partial solution to the problem?

As a first step, let's stop _adding_ this language.

Given what I've seen from other communities and what I know of the kernel
community, I don't think we're going to get consensus on some massive
global search/replace any time soon. However, I think we can get started
on making this change with just stopping further introductions. (I view
this like any other treewide change: stop new badness from getting
added, and chip away as old ones as we can until it's all gone.)

-- 
Kees Cook
