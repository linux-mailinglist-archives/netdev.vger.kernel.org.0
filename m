Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C655FF01
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 13:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiF2Lrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 07:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbiF2Lr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 07:47:28 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CF33F88A
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:47:26 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ay16so32042715ejb.6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xAPX6GqWzgTnXl12HGmecePjsjgx6ysCX22LSso1BeM=;
        b=EnWS/Dl8XbTDf+jSLd1nJPVDSXjV5bC2dmMFUGglOFtJrFWPVFyYLf+qGzycK1yJFu
         Sbr1g+2kCBSF3eG9cJHss1htVShfUrQ7sVrQ3SbI0A+sxYwy9+xHSvL1FiJxbjuFieif
         Y9NCjFeM9aJ7cgZWb7u0YfF5vHUuFtPV0XncepnOec84Ag87WEoHu+R63iXA/psnYjZP
         S4dE9ikYDMT5nosxZ0mA469sSyytS7lECn92Pv1U7SZp0rOLCbdW/WoPSZkuY8HHQjho
         f7bRq9HCRoF5fH8mU2QshQHmS+R9XElPcaJzT2dPXr1P3oXp3TnJwfTg9q3NI43Fs02F
         PwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xAPX6GqWzgTnXl12HGmecePjsjgx6ysCX22LSso1BeM=;
        b=aFzg6e/FbvST/NiOYhSHaxr0w6QrC6WOYkwzaLQjJe2KnKP/2chmSfM1/LA4axZ3P5
         SPE6X0hkeLXo7dUaCFQYCK7DEGi6PXVzqZ/+Kj711zOvQ41UkkjP2uF2o67wPyvOp0NR
         JxG54zPvh8je8gajbFasy6sIKJMrff1TNF/ipsiI+08HPQoSiW4HzhWGs/hiiUCD4NHL
         6WO8n1af4xD+z5LwgOGaeV3uzLkgMnVDb7mlvpiqPClLmM1ZabRB1iGsKCdI2Y/CiFSI
         uxKYbG4mApnLVtq0n/CpApeOjcWYDJP79XBbgn1oMLbkr9FLtVFoxCcAZuPmkxB62p8B
         l/MA==
X-Gm-Message-State: AJIora9LjJKh2cMtmVgf2PwFo1pWDwyTV/+8uYNkbNZMd+GMfQqdP+6F
        O9uNFFKT1DIeR/XIoHszGFooZA==
X-Google-Smtp-Source: AGRyM1sv2hOcEkNfbv0oq815kjDoaUYRM+t1Gjr5y6BjgSJ6xYS51vzGqLXU1AeeLSyQzdk9F8apsA==
X-Received: by 2002:a17:906:58cb:b0:722:fc1a:4fd with SMTP id e11-20020a17090658cb00b00722fc1a04fdmr2942793ejs.548.1656503244908;
        Wed, 29 Jun 2022 04:47:24 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s17-20020a1709060c1100b00722e52d043dsm7732684ejf.114.2022.06.29.04.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 04:47:24 -0700 (PDT)
Date:   Wed, 29 Jun 2022 13:47:22 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <Yrw7yl+hTbBuDFvU@nanopsycho>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <YrnS2tcgyI9Aqe+b@nanopsycho>
 <YrqxHpvSuEkc45uM@shredder>
 <YrworZb5yNdnMFDI@nanopsycho>
 <YrwrKDAkR2xCAAWd@nanopsycho>
 <Yrw3vz4+umAxXVrc@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrw3vz4+umAxXVrc@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 29, 2022 at 01:30:07PM CEST, idosch@nvidia.com wrote:
>On Wed, Jun 29, 2022 at 12:36:24PM +0200, Jiri Pirko wrote:
>> Wed, Jun 29, 2022 at 12:25:49PM CEST, jiri@resnulli.us wrote:
>> >Tue, Jun 28, 2022 at 09:43:26AM CEST, idosch@nvidia.com wrote:
>> >>On Mon, Jun 27, 2022 at 05:55:06PM +0200, Jiri Pirko wrote:
>> >>> Mon, Jun 27, 2022 at 05:41:31PM CEST, idosch@nvidia.com wrote:
>> >>> >On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
>> >>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >>> >> 
>> >>> >> This is an attempt to remove use of devlink_mutex. This is a global lock
>> >>> >> taken for every user command. That causes that long operations performed
>> >>> >> on one devlink instance (like flash update) are blocking other
>> >>> >> operations on different instances.
>> >>> >
>> >>> >This patchset is supposed to prevent one devlink instance from blocking
>> >>> >another? Devlink does not enable "parallel_ops", which means that the
>> >>> >generic netlink mutex is serializing all user space operations. AFAICT,
>> >>> >this series does not enable "parallel_ops", so I'm not sure what
>> >>> >difference the removal of the devlink mutex makes.
>> >>> 
>> >>> You are correct, that is missing. For me, as a side effect this patchset
>> >>> resolved the deadlock for LC auxdev you pointed out. That was my
>> >>> motivation for this patchset :)
>> >>
>> >>Given that devlink does not enable "parallel_ops" and that the generic
>> >>netlink mutex is held throughout all callbacks, what prevents you from
>> >>simply dropping the devlink mutex now? IOW, why can't this series be
>> >>patch #1 and another patch that removes the devlink mutex?
>> >
>> >Yep, I think you are correct. We are currently working with Moshe on
>> 
>> Okay, I see the problem with what you suggested:
>> devlink_pernet_pre_exit()
>> There, devlink_mutex is taken to protect against simultaneous cmds
>> from being executed. That will be fixed with reload conversion to take
>> devlink->lock.
>
>OK, so this lock does not actually protect against simultaneous user
>space operations (this is handled by the generic netlink mutex).
>Instead, it protects against user space operations during netns
>dismantle.
>
>IIUC, the current plan is:
>
>1. Get the devlink->lock rework done. Devlink will hold the lock for
>every operation invocation and drivers will hold it while calling into
>devlink via devl_lock().
>
>This means 'DEVLINK_NL_FLAG_NO_LOCK' is removed and the lock will also
>be taken in netns dismantle.
>
>2. At this stage, the devlink mutex is only taken in devlink_register()
>/ devlink_unregister() and some form of patch #1 will take care of that
>so that this mutex can be removed.
>
>3. Enable "parallel_ops"

Yes, exactly. With devlink_mutex removal in between 2 and 3.

>
>?
