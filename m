Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1093A642640
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiLEKAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiLEKAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:00:05 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A4CDF91
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 02:00:04 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fc4so19485901ejc.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 02:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+skmVhjTgF8LVzXJF4cu/aQGOzBZPdBfmN21d+xwSPI=;
        b=nkl80pSoG7caHAOP/CbvZBiYbywiiK4rtk8xnPfCfajrNo9f6eRhbxFOGMyKwU3602
         7xZgpVYz1n4eODGgQOLOEKW3M1nomS+fszi1hXPjBQvSCEwiBoE0eDcZme1zQAwPZjx+
         RaSLyuChUX8zLSXTKY1xltB2Rj4tEzCvzijV+vS4nPkKio+1/HoltKeuP2tHiSFpgFza
         dFwKwscnWDpGrjlQG/4zIV1EBw094n2LJ1BlGwap+ik9B9wQ4z8Ld5h0OPHGUYC8goRJ
         2ReTYrxIT4Rk/VMLzzbgW3gx3ZR0NJg9sfCH6Zw2umXU2jboczmCX1hqGyUPasNNiIVd
         WPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+skmVhjTgF8LVzXJF4cu/aQGOzBZPdBfmN21d+xwSPI=;
        b=Ev7WqFwZ5dd6lg9eEDIrvT3EKoyUBM+LNUmGhzhijNqzHGWjxfMd5EGKuHbYOuEjWH
         +RBuCcsYb8aaa+/dnc/0+HOJIshoxCmLzrhVRGpFMkaNOOAQtkHqi2xxDT7lqndrp5iG
         jjp4lBJb1bn34wtSjsEF7zCSlgFHbGjNu6shJ6vtcIOzoVQkJzW7T+aWnB41PZ5xQE92
         B3Vtad1+0l08qvWS6YPjT7qSKUBhuqOl/GE9LRjfXuGrTxqc/WHO9xIZfTb3tH+H/7np
         ErSng7qTS1fTldRpH6dU+8fYek/8rVi/uQcXTCK8A163g0seKwB/zpS2ibs65QsT4kw1
         pJdQ==
X-Gm-Message-State: ANoB5pnc2MDuCSkP9inU937GkATac8bj85IMiBJykM3DHdLVmYNea4Iw
        JjBzGuIxgbZpS76XWnklDEyNCg==
X-Google-Smtp-Source: AA0mqf5cSQYirTc/y492+qI1mcshbC322MsqCzyocpFUlL7Dht1DMhiFtaUTEq7Z2Ot0xLH8AaKIcQ==
X-Received: by 2002:a17:907:a4c3:b0:7c0:7c22:d70d with SMTP id vq3-20020a170907a4c300b007c07c22d70dmr28151302ejc.707.1670234402610;
        Mon, 05 Dec 2022 02:00:02 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090630cc00b007c0bc6860a0sm4234888ejb.37.2022.12.05.02.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 02:00:02 -0800 (PST)
Date:   Mon, 5 Dec 2022 11:00:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, yangyingliang@huawei.com
Subject: Re: [patch net-next RFC 0/7] devlink: make sure devlink port
 registers/unregisters only for registered instance
Message-ID: <Y43BIXPBAikNiGRH@nanopsycho>
References: <20221201164608.209537-1-jiri@resnulli.us>
 <Y4yGCTMyV2bdD+05@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4yGCTMyV2bdD+05@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Dec 04, 2022 at 12:35:37PM CET, leon@kernel.org wrote:
>On Thu, Dec 01, 2022 at 05:46:01PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>
><...>
>
>> Jiri Pirko (7):
>>   devlink: Reorder devlink_port_register/unregister() calls to be done
>>     when devlink is registered
>>   netdevsim: Reorder devl_port_register/unregister() calls to be done
>>     when devlink is registered
>>   mlxsw: Reorder devl_port_register/unregister() calls to be done when
>>     devlink is registered
>>   nfp: Reorder devl_port_register/unregister() calls to be done when
>>     devlink is registered
>>   mlx4: Reorder devl_port_register/unregister() calls to be done when
>>     devlink is registered
>>   mlx5: Reorder devl_port_register/unregister() calls to be done when
>>     devlink is registered
>>   devlink: assert if devl_port_register/unregister() is called on
>>     unregistered devlink instance
>
>Thanks, it is more clear now what you wanted.
>Everything here looks ok, but can you please find better titles for the
>commit messages? They are too long.

Okay, will try.


>
>Not related to the series, but spotted during the code review,
>It will be nice if you can get rid of devlink_port->registered and rely
>xarray marks for that. It will be cleaner and aligned with devlink object.

Okay, will look into it and address in a separate patch/patchset.


Thanks!

>
>Thanks
