Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89E363D10B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiK3Is0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiK3Is0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:48:26 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A3624F0E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 00:48:24 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b2so23333355eja.7
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 00:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DTVEGpo4NEaXnWNUREClvDpKKkzwMpl1EPvhF5++dBs=;
        b=fjhzbv2XScYLa99NCPJJXYawmoBTu1yScQGMsSwW9C7kT/yh5+1wyuMX/EG03IeZ4q
         eNC7g0GcNnzeRGKOE7UYtoYRk2mGyVMJWNpgWw8bwAbjHgyHVEYChz2qptuEAcOTNzqb
         hOrBCyx9GgPKLh0zbtNb4KzG3JKjVtgog8oa6iKW2juoMQ3j+Vm+d8aaqrwbAkwdfEQf
         0NVXRguv4IHAqJ9SdAxBfp+yBmd6JqLRfEYOuViZTnRwHkxrdQdW2wB0AIsgUfviN6a1
         tGSczRMMldAzlSWoqhaImKhaqSxKByn4Zb7gSd4dU56PQGUflN2jcBpa9oll8xtH2kJs
         kHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTVEGpo4NEaXnWNUREClvDpKKkzwMpl1EPvhF5++dBs=;
        b=qYlVJnfebveWJ3gLRk/vH1EgTB4iOsSFlOsnJEYUoTKdUplMDyUq5UG+PrcalyBwcs
         aH3/LyQIT6ut35hI0DHm1eDUcQIKFsPeT9HeMeZmSXCcmbXRdx2ZuBa/fRvGQCvbB7TF
         vaxEwavxAd1vSZ7R9Ru6R+4PIGeYniJSuaH0W/cYvIklTJweo3iM5a2ep+ly1d/GTU4F
         +faWKWG2kCMbAhMuN4zRIroFbLxdD75X//diTLvAVPUa/qvi6Cm8UIjy7EqCczNfLqWi
         FBq+IW2+La3Ye0bwEL4OmSbkXxxsftTbLCWX6q0M1biwd9w4yLajwF555n6PYbu10Evu
         E3AA==
X-Gm-Message-State: ANoB5pmHRL0TU2GM7wsEjlMTSIWVrrK4P2GICp0T9u+O9wyFHSPUpggT
        oHK92MYR1vx5AF7+ryqbucd2vA==
X-Google-Smtp-Source: AA0mqf6MlMD+bLHFc74O1OM9r/sSlcin0L7FMBU9bMZA7CD1TllMTOpA9HJitZ5ywQe7Q8SLPwjRoQ==
X-Received: by 2002:a17:907:77d6:b0:78d:e26f:bfd8 with SMTP id kz22-20020a17090777d600b0078de26fbfd8mr51385920ejc.482.1669798102530;
        Wed, 30 Nov 2022 00:48:22 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o12-20020aa7c50c000000b00468f7bb4895sm381901edq.43.2022.11.30.00.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 00:48:21 -0800 (PST)
Date:   Wed, 30 Nov 2022 09:48:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next v2] net: devlink: convert port_list into xarray
Message-ID: <Y4cY1DIKYkwLA8ul@nanopsycho>
References: <20221128110803.1992340-1-jiri@resnulli.us>
 <20221129212736.60d3bb4b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129212736.60d3bb4b@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 30, 2022 at 06:27:36AM CET, kuba@kernel.org wrote:
>On Mon, 28 Nov 2022 12:08:03 +0100 Jiri Pirko wrote:
>> @@ -9903,9 +9896,9 @@ void devlink_free(struct devlink *devlink)
>>  	WARN_ON(!list_empty(&devlink->sb_list));
>>  	WARN_ON(!list_empty(&devlink->rate_list));
>>  	WARN_ON(!list_empty(&devlink->linecard_list));
>> -	WARN_ON(!list_empty(&devlink->port_list));
>>  
>>  	xa_destroy(&devlink->snapshot_ids);
>> +	xa_destroy(&devlink->ports);
>
>Will it warn if not empty? Should we keep the warning ?

I don't think so.

Will add the warning in next V.
