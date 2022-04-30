Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42F8515AD1
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 08:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379782AbiD3GbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 02:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiD3GbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 02:31:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026B167D3
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 23:27:39 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z19so11223365edx.9
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 23:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i+LTQEPl7NXWDN24ss9ndyFJDveLiAitkdaPH+ZXAEE=;
        b=k2/ow2oglC33LaeQEJyoyCQSc2+X5fa2o5GYVckYaGwOnzRUYJpTphVcZCMpJTNlZE
         SebM5oG6/LieuauM8RqI1YWhR5kJA9E0I/ldAzoWRDS6si7EE34Mhl1YPZ8vVew0B8ow
         dlxSIPn9fFNMD4wpz2Hf8YhPfPbqPjEasWupYhqd2woQYHSLxxqFU6qE3Mk37yNHb386
         duSLkZAYR0oltq1/suzGDhEksFcFNXda4noVLuJrjg94RK66PwWrYuC9T5p9nR3n2LKZ
         sGJMLgd3thYbWDN+VZL/cwItdmBJEjiKgNGiGfe1fsBJT303fNf5Os9goWtglM0+VmjK
         12IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i+LTQEPl7NXWDN24ss9ndyFJDveLiAitkdaPH+ZXAEE=;
        b=SKn4WU+iUAyI4bUa9Zmrz/m1bka9CgZviyt6jOjEgBC6Ubdz/BMtEOMVUtjD/rzeRK
         5u42TpGTdAi4AJyg3Y3XUIKKc58o7VCHHI9803lU2Ga8ZGAJovyL988xHplCXFHysZCQ
         S5yAoulgAhOaCT4A5Xyp2iBiHptklvw6Q95ezAomSlYMoNRF6kWbUIFBWbDZSKyOsO4a
         sTzq0lS6h+0vmnU/VUbtuS+7hK1Extek+kKw7tkGbFAxTSDpQFn6+FXa3uMTWpJO9kKA
         IY4eiSp+D0jISk2WOXRogUtugEN07/RFaiYpy2m32J97V/Lcmg9qIYk+tNridVeD/WYM
         8cOg==
X-Gm-Message-State: AOAM533IMlERhY5Fm7/P416JhlkGVPD1zpcMtsx6WKbr1y75VlXV7DFt
        PLkwcH3aqNDgr28PkxjLjZJZUA==
X-Google-Smtp-Source: ABdhPJxZkhLnoHQJzyIj83bv/oZdKJ4fSeJFDDnAqDFeA+e9rd+83oSpDuGowFE/+MYCUFUYlauI5Q==
X-Received: by 2002:a05:6402:e9f:b0:41c:df21:b113 with SMTP id h31-20020a0564020e9f00b0041cdf21b113mr3107435eda.217.1651300057506;
        Fri, 29 Apr 2022 23:27:37 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gx3-20020a1709068a4300b006f3ef214dc4sm1295743ejc.42.2022.04.29.23.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 23:27:36 -0700 (PDT)
Date:   Sat, 30 Apr 2022 08:27:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmzW12YL15hAFZRV@nanopsycho>
References: <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
 <Ymf66h5dMNOLun8k@nanopsycho>
 <20220426075133.53562a2e@kernel.org>
 <YmjyRgYYRU/ZaF9X@nanopsycho>
 <20220427071447.69ec3e6f@kernel.org>
 <YmvRRSFeRqufKbO/@nanopsycho>
 <20220429114535.64794e94@kernel.org>
 <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429153845.5d833979@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Apr 30, 2022 at 12:38:45AM CEST, kuba@kernel.org wrote:
>On Fri, 29 Apr 2022 21:29:16 +0200 Jiri Pirko wrote:
>> >The main question to me is whether users will want to flash the entire
>> >device, or update line cards individually.  
>> 
>> I think it makes sense to update them individually. The versions are
>> also reported individually.
>
>Okay, but neither I want that, nor does it match what Ido described as
>the direction for mlxsw, quoting:
>
>  The idea (implemented in the next patchset) is to let these devices
>  expose their own "component name", which can then be plugged into the
>  existing flash command:
>
>    $ devlink lc show pci/0000:01:00.0 lc 8
>    pci/0000:01:00.0:
>      lc 8 state active type 16x100G
>        supported_types:
>           16x100G
>        devices:
>          device 0 flashable true component lc8_dev0
>          device 1 flashable false
>          device 2 flashable false
>          device 3 flashable false
>    $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0
>
>Your "devices" are _not_ individually flashable. It seems natural for
>single-board devices like a NIC or a line card to have a single flash
>with all the images burned together.

Wait a second. I think that we don't understand each other. Currently,
we have a single device to flash on a linecard, the gearbox.
There is one file to flash it. So 1:1 between line card and file to
flash. That is exactly as I described in the proposal. 1 component name
per line card.


>
>> What's the benefit of not doing that.
>
>As already mentioned in my previous reply the user will likely have 
>a database of all their networking assets, and having to break them
>up further than the physical piece of gear they order from the supplier
>is a pain. Plus the vendor will likely also prefer to ship a single
>validated image rather than a blob for every board component with FW.

Depends on the vendor :) But it is hypothetical, let's see what the
future brings. But I agree with you.


>
>> Also, how would you name the "group" component. Sounds odd to me.
>
>To flash the whole device we skip the component.

Sec. I think these is a misunderstanding here. The component it what we
already have in devlink dev flash. Quoting devlink-dev man page:
   devlink dev flash - write device's non-volatile memory.
       DEV - specifies the devlink device to write to.

       file PATH - Path to the file which will be written into device's flash.
       The path needs to be relative to one of the directories searched by the
       kernel firmware loaded, such as /lib/firmware.

---->  component NAME - If device stores multiple firmware images in non-
       volatile memory, this parameter may be used to indicate which firmware
       image should be written.  The value of NAME should match the component
       names from devlink dev info and may be driver-dependent.

This is currently not used in devlink capable drivers. It is a concept
taken from ethtool (I think you were the one that requested to take it,
but my memory could be wrong).
Anyway, the default is component NULL. In case of mlxsw, in that case
the target is ASIC FW.

Now I just want to use this component name to target individual line
cards. I see it is a nice fit. Don't you think?

I see that the manpage is mentioning "the component names from devlink dev info"
which is not actually implemented, but exactly what I proposed.


>
>> >What's inside mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2? Doesn't
>> >sound like it's FW just for a single gearbox?
>
>Please answer questions. I already complained about this once in 
>this thread.

Sorry, I missed this one. The file IS a FW just for a SINGLE gearbox.


