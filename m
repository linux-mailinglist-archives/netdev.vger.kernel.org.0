Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9C765BD73
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbjACJvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237108AbjACJvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:51:18 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A99B3E
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 01:51:17 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m3so13343539wmq.0
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 01:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mr582/0ctobwMhGCTpGPKnO8nE6NIMfwPvKICxhJLyI=;
        b=Zmmcru2GTlYLdRsB4aGd+zf33y5n3li+y7N9kXSVKo1aOWH3Q84c1bPpUcKa1f/2lX
         +AWiSXUfJO1TLKqbHYChShKhQVJoHyNA2bYukvJChk2uuORNJEhcwzNmpeUycPrbFyF1
         D6X6tgMd9dvHNS0R/VB0kEsauG8RkM273CY9JX2CrAyO0gmp9sxZ5g4MvK2lRpZ+xvCM
         VTD6q9VpC5uY1wsYAHiOOjLLgf3qD9lcuoaZj4sAP38QgJtpNI/B91zoFiBd+p9Irk7y
         0Slj8wO5K0lewOFW+yIXr9fpnxZKfg54pyHEHrecBEG+6ZnId2YagVP5Fo/LOoodyLIF
         W+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mr582/0ctobwMhGCTpGPKnO8nE6NIMfwPvKICxhJLyI=;
        b=pbZcwwYgIwRtIvKupelIzHfO5uthQShp/NNCleRZ18xV6HSc+Vvq0tDgT9W3mRxA3+
         hnIvukpOlY3kp+7xg0MJ0BDVL/LUypVO78Q22QQ/nmxykO/nVbsCxsjb4uZz8Ro45WOJ
         EHlC0KIr7AJGAmvQKDTy+BLjFm/TUMvmHpP/PJMeurLHLUGvSc0b7+CFTPW3FaNHVnWp
         A3el8dfGEpBEXDmD+UEdO6R2D367VyMogCZxZS7DWFDgEmgOvpr6eMWlYmqxwDkRPXeM
         RzZeRQl5OZ/NEiEGQYoNvzIDXLxE4K+Iu7MPI6tn+G+BrzOK2tM/i0vLqnBctyjxjOJx
         HIKw==
X-Gm-Message-State: AFqh2krn0zHi7FAW9SUt48CifhvbuQeTuzRZU4Ztb/gqHp0/bqsG4qP+
        o4DT20AYlPFPDAnbOM2OcjanTQ==
X-Google-Smtp-Source: AMrXdXuKIkQAGBQMSEWzGn/+34AqQzN08anGx3n5XIlqmhX2xejZ89sAy5k5ZTy8/tq+dYjzkt8MIw==
X-Received: by 2002:a05:600c:1d89:b0:3d3:5cd6:781 with SMTP id p9-20020a05600c1d8900b003d35cd60781mr30119988wms.37.1672739476192;
        Tue, 03 Jan 2023 01:51:16 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m22-20020a05600c161600b003cfa622a18asm43878615wmn.3.2023.01.03.01.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 01:51:15 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:51:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 10/10] netdevsim: register devlink instance before
 sub-objects
Message-ID: <Y7P6kieBDjB/K/30@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-11-kuba@kernel.org>
 <Y7Ldciiq9wX+xUqM@nanopsycho>
 <20230102152546.1797b0e9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102152546.1797b0e9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 03, 2023 at 12:25:46AM CET, kuba@kernel.org wrote:
>On Mon, 2 Jan 2023 14:34:42 +0100 Jiri Pirko wrote:
>> Sat, Dec 17, 2022 at 02:19:53AM CET, kuba@kernel.org wrote:
>> >Move the devlink instance registration up so that all the sub-object
>> >manipulation happens on a valid instance.  
>> 
>> I wonder, why don't you squash patch 8 to this one and make 1 move, to
>> the fina destination?
>
>I found the squashed version a lot harder to review.

I'm puzzled. Both patches move calls to devl_register/unregister().
The first one moves it, the second one moves it a bit more. What's
making the squashed patch hard to review?
