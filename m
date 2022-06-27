Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94755CE73
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiF0PzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237635AbiF0PzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:55:13 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED66226F1
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:55:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o9so13662457edt.12
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yJaBhc9q1DFH3alwVLSrzvjXQz1O2gmM0R8q/IQid0w=;
        b=yAdwXGxlNZP+t9moaoZJgaSiWOdMAcRbKIvoI0K833sDVwt0K3KSxbWKAQqpGaRJ2c
         Nh0xcr4Ef0cpbgBUonCMIeEur3FkRynmvVylTDuatOUx0XwlBetWyxTGBJ0NL2N3xx+E
         16/ujTp/zPpzD7jU/wSfVwoYjERg/GrE8u0Z+if50JZjC6wxIouJ93KHJZGxZmx93LAW
         VmTDUpcvOaRlNao69TPr7L62ToDK+4PXfdT93VhNpF7KW/d7z7SDF4rJ7mz1xMobde+3
         AoP4yvrHdeSR9zCsFeN24mNQvkuWhpgVVmgXZcDamQzyzETSRGT2XRpZqVAczgr1Hpna
         tH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yJaBhc9q1DFH3alwVLSrzvjXQz1O2gmM0R8q/IQid0w=;
        b=LhPG3jhSrFr+mzWUN89/sq5a+GggIv+MTl6V8TyG2r4b4GBkLysd1bfMyJxeRkcMAF
         GGo9RCfu8SkPXqvOlvuTaI2uDMzqaX0XzlgmZeDUVDC3qWD58RqChmToSB3qXl08ORyg
         6nJpEwdngjgwRp6eFkM9NSojrJKqcM8Ef3F0kHdsyPXem9Tv/R0zSQO9MKZ6fUFZwqJ+
         AOjYIPSm0kfVzE1U1Z5kgwiiOQLRFpok2LU0/dq1a5yG40Sq7sJxXR51aks4m/dE9E/O
         HtFpk/NrjcGOnEfIW4lOE2jkXUfjcKINaVWObNBeSOj3FE+Y4Watbo6RVnHELlpbi8ur
         iLZg==
X-Gm-Message-State: AJIora+Rl5+oKWBKZijHB3+5Lw5Eiaseyq+gMKqTzkzTTA7mRr87DAbj
        ioRKK2FnZITHebM3x86ti38/WQ==
X-Google-Smtp-Source: AGRyM1u2XtPTWRmsDD4fj74spZunTYsnBBxtbx3hZ2kEQbSKdBTEouF0obXmWkvA/zooa+Wv2bZxMQ==
X-Received: by 2002:aa7:d393:0:b0:435:59d7:6e6d with SMTP id x19-20020aa7d393000000b0043559d76e6dmr17323285edq.129.1656345307416;
        Mon, 27 Jun 2022 08:55:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906340400b0070abf371274sm5208585ejb.136.2022.06.27.08.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:55:07 -0700 (PDT)
Date:   Mon, 27 Jun 2022 17:55:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <YrnS2tcgyI9Aqe+b@nanopsycho>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrnPqzKexfgNVC10@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 27, 2022 at 05:41:31PM CEST, idosch@nvidia.com wrote:
>On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> This is an attempt to remove use of devlink_mutex. This is a global lock
>> taken for every user command. That causes that long operations performed
>> on one devlink instance (like flash update) are blocking other
>> operations on different instances.
>
>This patchset is supposed to prevent one devlink instance from blocking
>another? Devlink does not enable "parallel_ops", which means that the
>generic netlink mutex is serializing all user space operations. AFAICT,
>this series does not enable "parallel_ops", so I'm not sure what
>difference the removal of the devlink mutex makes.

You are correct, that is missing. For me, as a side effect this patchset
resolved the deadlock for LC auxdev you pointed out. That was my
motivation for this patchset :)


>
>The devlink mutex (in accordance with the comment above it) serializes
>all user space operations and accesses to the devlink devices list. This
>resulted in a AA deadlock in the previous submission because we had a
>flow where a user space operation (which acquires this mutex) also tries
>to register / unregister a nested devlink instance which also tries to
>acquire the mutex.
>
>As long as devlink does not implement "parallel_ops", it seems that the
>devlink mutex can be reduced to only serializing accesses to the devlink
>devices list, thereby eliminating the deadlock.
>
>> 
>> The first patch makes sure that the xarray that holds devlink pointers
>> is possible to be safely iterated.
>> 
>> The second patch moves the user command mutex to be per-devlink.
>> 
>> Jiri Pirko (2):
>>   net: devlink: make sure that devlink_try_get() works with valid
>>     pointer during xarray iteration
>>   net: devlink: replace devlink_mutex by per-devlink lock
>> 
>>  net/core/devlink.c | 256 ++++++++++++++++++++++++++++-----------------
>>  1 file changed, 161 insertions(+), 95 deletions(-)
>> 
>> -- 
>> 2.35.3
>> 
