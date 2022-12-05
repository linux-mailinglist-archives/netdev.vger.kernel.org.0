Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4749E64263D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiLEJ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLEJ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:59:08 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F4364D7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:59:05 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id t17so1094084eju.1
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6VrLnnSMzSRJN7l7zVuZBYCLd8Wp+yXrhvFtjNyN/Cw=;
        b=HyiYhn4WfYPrw4edUlCeO/8K7Tu97RdLBKvxehPuM882nalHsMVa3NFC2/Tl25YIv+
         iQG8tJXrXvwz0D+NBj4GnBGt1rDfRHiFHhDml13bqtHC8D5u2+3rBsISEhkd03ddr06o
         LXmFkSqBW62JFvJEdt7Y0hHfNf8ceDgiEPjD0737he40rcjiDjGRySw52kKZ6pz0E/BO
         VAW23yUn0B+N39kSeU2CmExf5tlVDcgJO/mpAKkG0ZQpYnxnMVdpIKVwQiSy0QwEvXBa
         SGlRcpZnUHUIP2sUANi5oGnMt0DIu3FsiqZIUOG9YSRXWsXGCiGueirMMsKxVfDkZ52r
         nQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VrLnnSMzSRJN7l7zVuZBYCLd8Wp+yXrhvFtjNyN/Cw=;
        b=axhwp50jKOFOR7pR3Gn5F5lbWW0TD4huzEc63FnkZ5LLZRg0SuKmqPFfLY83X2SWIs
         CNByy2BwtawqaoVUAUJBH5bjU/YMI+JMut5OjiQg8dlYYx6vcPfad5gnCI/0Dx/fzDyJ
         eFAC3RhXf+fNtlq8DfC/kffUQr9Gm0fC3qZU42bABvLGBweHuDKtEVAkXItPYEdpwD7o
         awBICJT1fUP/loFajBt9MFQ/pLkx4I6yxJIv3PY75B0F5zmAgibO57HlhX0NwS9Ku/BO
         Todm7f0cnVWTM+DUtoXlHPlz4BCHojclV5DfsP92b3uU1bdlGtgYS3+ua6aHMqZzci+H
         m9HA==
X-Gm-Message-State: ANoB5plYuPZIyvaXlnOvN5ub5WyDkZO8nG/+SlIQcA1kCXRWp1n+fI62
        +fWmSSu6GukUnycWRUq4q1VYhQ==
X-Google-Smtp-Source: AA0mqf7i7G5raUXaTENwxRkEh/iGWn+3gseAb+6UnzRJYY5JCLRMjOsPhR5XrJ03/YNRCK7IKWsdHQ==
X-Received: by 2002:a17:906:c283:b0:7ae:2277:9fec with SMTP id r3-20020a170906c28300b007ae22779fecmr67384215ejz.623.1670234344406;
        Mon, 05 Dec 2022 01:59:04 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m10-20020aa7c48a000000b0045b3853c4b7sm6019675edq.51.2022.12.05.01.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:59:03 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:59:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, yangyingliang@huawei.com
Subject: Re: [patch net-next RFC 7/7] devlink: assert if
 devl_port_register/unregister() is called on unregistered devlink instance
Message-ID: <Y43A5nQYWwQpt6v2@nanopsycho>
References: <20221201164608.209537-1-jiri@resnulli.us>
 <20221201164608.209537-8-jiri@resnulli.us>
 <Y4yHGT7k4/boMFa0@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4yHGT7k4/boMFa0@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Dec 04, 2022 at 12:40:09PM CET, leon@kernel.org wrote:
>On Thu, Dec 01, 2022 at 05:46:08PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Now when all drivers do call devl_port_register/unregister() withing the
>> time frame during which the devlink is registered, put and assertion to
>> the functions to check that and avoid going back.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  net/core/devlink.c | 2 ++
>>  1 file changed, 2 insertions(+)
>
>You also need to remove delayed notifications from devlink_notify_register()
>
>   9862         xa_for_each(&devlink->ports, port_index, devlink_port)
>   9863                 devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
>

Correct, I forgot.

>Thanks
