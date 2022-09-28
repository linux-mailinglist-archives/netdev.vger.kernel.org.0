Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E295ED698
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiI1HoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiI1HnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:43:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D916111DC8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:40:12 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x92so2986469ede.9
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=h9cilNAgrtuxE9Wz+hbxSN/qr3UM1d+UsEE6Utf3CM4=;
        b=Kpo7SawYVwGoKD8ZpTB8YfqL2v1IE4h9ye+w6K+FEXoEeTSInhEVKwDPVifyAhqAg3
         BeJfuvc7ZyY6WWXYh0GpihaUiVbuXDgjKKn6C6GWkc5ZcR4SmOUzLQG4Pc6HiV/7FyMq
         YQq9BOZOwNA+l6BLa+egBZ8s+5+T01Eaufu4rrd5h28ePRFXtuzb1tnDgh+xQFQtBbFV
         J6QJbyDaMp+go86FGcK+sftdnziGMCEZiex1r5ogLkOWHmzWpXvGErz8xG/BaPMmz8Qr
         5CUcMaD/TyCrkBUidbAlNfTM7f28vDKBkT2HyT2b4oqIuug+y5zTsp2UV69F4p+4C1GT
         sfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=h9cilNAgrtuxE9Wz+hbxSN/qr3UM1d+UsEE6Utf3CM4=;
        b=I1vS7R2nsNN0/dLuzFUJ4QUhrHO8aD3D6r/L12ZzAwK0zoIv8tRDqqute58QnsKvfe
         f1FKJwtAJhyVb41IPaBAn6jfZj0EsJ1OxyaMBB7s3Om9a62zlHxQEE+IZx/uxVP2jxZC
         rmurjtZghU280m+tUpBjFDolx4VO9wokVLLfAdYtRt8H7cm0I+dnu4Wiulb2hKvgJrc/
         /IpaCM2dYwFjl9CaeUxvHAewT8XcwF6Zs9MeA9I231Ak8YhRly2TrSxA+e9npHmsmo3I
         6IJZnE5DcTGl1EL2Yi9FEJiS5Qty5i5lgMwdeNc9Be9W7u2vEcHbCAzb4oZ5Xmpv2Soj
         7rLQ==
X-Gm-Message-State: ACrzQf3fh9IaByNymjqRXmbkT9mi1MLDGZVNJygaNzEMeJfMCsjC8jjX
        T9H5E9QqE+W91CU0Xdz+p/GRGA==
X-Google-Smtp-Source: AMsMyM5hlVFt/3OdkhwFRGvpGj8Uh6QdLGcjmOWlXYZ6BMVpTcxj30QCuHbSVMrL+lSXAI/yW8fSwA==
X-Received: by 2002:aa7:dd57:0:b0:453:2d35:70bb with SMTP id o23-20020aa7dd57000000b004532d3570bbmr32670414edw.26.1664350810613;
        Wed, 28 Sep 2022 00:40:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ky9-20020a170907778900b0077826b92d99sm1996369ejc.12.2022.09.28.00.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 00:40:09 -0700 (PDT)
Date:   Wed, 28 Sep 2022 09:40:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next v2 3/7] net: devlink: add port_init/fini()
 helpers to allow pre-register/post-unregister functions
Message-ID: <YzP6WOVxQbFB5a6h@nanopsycho>
References: <20220927075645.2874644-1-jiri@resnulli.us>
 <20220927075645.2874644-4-jiri@resnulli.us>
 <20220927181041.7be7b305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927181041.7be7b305@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 28, 2022 at 03:10:41AM CEST, kuba@kernel.org wrote:
>On Tue, 27 Sep 2022 09:56:41 +0200 Jiri Pirko wrote:
>> To be consistent with devlink regions, devlink port regions are going to
>> be forbidden to be created once devlink port is registered. Prepare for
>> this and introduce new set of helpers to allow driver to initialize
>> devlink pointer and region list before devlink_register() is called
>> That allows port regions to be created before devlink port registration
>> and destroyed after devlink port unregistration.
>
>The patches look good but I think the commit message needs an update,
>no?  We no longer plan to forbid the late registration IIRC.

Ah, yeah, leftover. Let me send v3 with this fixed.
