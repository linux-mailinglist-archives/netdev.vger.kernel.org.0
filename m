Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823725F2397
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 16:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJBOfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 10:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJBOfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 10:35:15 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060AA1144F
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 07:35:12 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id rk17so17644978ejb.1
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 07:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Enk2dM0C4eT6Sv++JaTkLKJvaPD74u7cEzApvj+1W9w=;
        b=tJvPZNDGMXxdVhP+xXUiILb9tv2wOEEPL9h3R4M+qXumk4AJp0vOVT3Fc5ivK4TLVs
         wsOWaorVAq4lo9UcT9vahp7bhduHu9s2IJ2Ue+fatRgZpaPq3cJX/z1XqBMWyNkxFZQB
         QoqJyGfenEXK+U7BlguuSHykznIkDEO2SaZOpwTtA72EEeHDQQhLdZs0MH+9AeqzP8C+
         Snev139AAjH1IqHDjjIu/11J1+WFeU2OVmceyRBIFXCip2Ks+tjOxik8Jx23a6MX4Ime
         M3IAboU61/ya+KnmTB5nrzFlCnjUaKXHjPI6s2ZQvEOtGOa7S39T+Ij2+7yz7zrQgJcS
         9X1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Enk2dM0C4eT6Sv++JaTkLKJvaPD74u7cEzApvj+1W9w=;
        b=o2g8t/F31qUzh4PTa8oRQ1uxuLeup/2KzQ6GlItrvpabf3CK4eOuM6kRYKUT7BTtNe
         PDODcjtHYAkb1MICCZ+CU2ZPqBC94TCm+ZShhmnWxPhfYMSDZwLUlsk7zfQ1UUnLeO8w
         54cCrg8wQZgzNDYZ/mxDkT52wbq0fY1IIXAp+Pi9LjdYf4LmS7zOy2bLcYbT8PpcsYX8
         MfDCU6Ce5k15seg7RrdEkh3HyHBF7pOMS5Vw+Ch6aShrnTwuYzGZhwzepb20JxiDUvgs
         pLiIqmxB8hPijs+oBBNh9+19t2j+XqkpRHG+1gqRtguLmztJRIrIPMl2Uk9jOYEYUOOB
         8sPQ==
X-Gm-Message-State: ACrzQf3ilenBaTqP68nDYzLG6iE8uyQmgL1Ndk1wlLuGH63ZsZYfi5rE
        zSK/NS9eLA2MJKqJraJNuywJ00RVxHExll/k
X-Google-Smtp-Source: AMsMyM6WR+UYVyxhw409NtcQaCJWZJN825wSFlNCOYFdO1PIkGwwOexQzN6SpBokEJnfNdDjn5UA8Q==
X-Received: by 2002:a17:906:9bca:b0:78a:49c4:4110 with SMTP id de10-20020a1709069bca00b0078a49c44110mr3111900ejc.345.1664721310182;
        Sun, 02 Oct 2022 07:35:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j5-20020aa7de85000000b004542e65337asm5447072edv.51.2022.10.02.07.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 07:35:08 -0700 (PDT)
Date:   Sun, 2 Oct 2022 16:35:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Gal Pressman <gal@nvidia.com>
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Message-ID: <Yzmhm4jSn/5EtG2l@nanopsycho>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <YzWESUXPwcCo67LP@nanopsycho>
 <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
 <Yzap9cfSXvSLA+5y@nanopsycho>
 <20220930073312.23685d5d@kernel.org>
 <YzfUbKtWlxuq+FzI@nanopsycho>
 <20221001071827.202fe4c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221001071827.202fe4c1@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 01, 2022 at 04:18:27PM CEST, kuba@kernel.org wrote:
>On Sat, 1 Oct 2022 07:47:24 +0200 Jiri Pirko wrote:
>> >> Sure, but more hw does not mean you can't use sysfs. Take netdev as an
>> >> example. The sysfs exposed for it is implemented net/core/net-sysfs.c
>> >> and is exposed for all netdev instances, no matter what the
>> >> driver/hardware is.  
>> >
>> >Wait, *you* are suggesting someone uses sysfs instead of netlink?
>> >
>> >Could you say more because I feel like that's kicking the absolute.  
>> 
>> I don't understand why that would be a problem. 
>
>Why did you do devlink over netlink then?

There were good reasons why to use netlink, many of those. I find it
redundant to list them here.


>The bus device is already there in sysfs.
>
>> What I'm trying to say
>> is, perhaps sysfs is a better API for this purpose. The API looks very
>> neat and there is no probabilito of huge grow.
>
>"this API is nice and small" said everyone about every new API ever,
>APIs grow.

Sure, what what are the odds.


>
>> Also, with sysfs, you
>> don't need userspace app to do basic work with the api. In this case, I
>> don't see why the app is needed.
>
>Yes, with the YAML specs you don't need a per-family APP.
>A generic app can support any family, just JSON in JSON out.
>DPLL-nl will come with a YAML spec.

Yeah, but still. For sysfs, you don't need any app.
Just saying.


>
>> These are 2 biggest arguments for sysfs in this case as I see it.
>
>2 biggest arguments? Is "this API is small" one of the _biggest_
>arguments you see? I don't think it's an argument at all. The OCP PTP
>driver started small and now its not small. And the files don't even
>follow sysfs rules. Trust me, we have some experience here :/

No problem. I don't mind one bit, don't get me wrong :)
I just pointed out alternative.


>
>As I said to you in private I feel like there may be some political
>games being played here, so I'd like to urge you to focus on real
>issues.

I don't know anything about any politics. I don't care about it at all
to be honest. You know me :)


