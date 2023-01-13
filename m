Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E09668F8F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjAMHu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAMHuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:50:40 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF6761468
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 23:50:37 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z11so30116515ede.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 23:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2i7KNwTr51UeTAQapQR/yudzsa2Yed6YPM5W8oSaRaM=;
        b=pGwEQhiHG3GBB46kXFxLIS4xx29TYj5UkSNb9IPzbyF87OSjY6I5sigh3zUIkhO1+F
         3Dvp50b7S1Baw/DCNOt1y8AKAn6MHfPCpFcLkttAPya2vbvzqMGksy821Rs6cVkwNzz4
         YMICHhE0/jp3JrA3t5eAMO1FlDIfekC4IH5Kx2DXddHHLSWQQoW6GPM7m0HSzANcrG5z
         h1FKIhmiJyMI0LxAByA5+r70LIxV72PI6eWKKr49M78OruWexiWTG/9UflBvsiBSsCqS
         359Sw7mPsREYuRNn+vYe9F8KebdG8D7p9h1+A4bNPBA9ARoUjTKoIBAawn/vAkOT56uq
         iwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2i7KNwTr51UeTAQapQR/yudzsa2Yed6YPM5W8oSaRaM=;
        b=KsHy09T/Xj3E5sDkbZgMAvhPDHZlSKdAS/0PYeWGtBkz5tvPXzvsdxLbmyyBQT5m3m
         AREI+rtpyXS1qwSDWeFe52Kh53PH59HycDYmMuVcS7HT1ZMGqeqeH/8ftZrpIGvbTnam
         LllB5PsksKejKuA21ZE4RekxwgHv9rvd2BrII3v6AeGJBTA4Seai4flVUmltQ3//Vhge
         YYcW3s6q5riLaEn3muaOrYDkSoUaolhsypIRqFSxpGbNNEMutKLfgYxHXD0ctiePlcXh
         M+xLv3VG0cYow6X44oElz9wUMhv+GwZaR7ley3vbVJVkL7Pqe1uxGOcODPil/VwJZQRO
         cmQQ==
X-Gm-Message-State: AFqh2koQRsMPpzBVOoKewvMlCioSqlX4hZA34iyvR0YC1QK1Z9J9bE4V
        24ehbvGd8pASPUcZvn41zDGn3+eFfg6i2jImT8c=
X-Google-Smtp-Source: AMrXdXsI3RulDiDxoRRWKvYX7qXIrXk5NRjumdr6vUzcg5AfO/A1R36b9R+40AXtszazY2PKs503uQ==
X-Received: by 2002:a05:6402:4011:b0:49a:d3c2:c76f with SMTP id d17-20020a056402401100b0049ad3c2c76fmr7894749eda.13.1673596235595;
        Thu, 12 Jan 2023 23:50:35 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id x14-20020a056402414e00b0045b4b67156fsm7940608eda.45.2023.01.12.23.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:50:34 -0800 (PST)
Date:   Fri, 13 Jan 2023 08:50:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8ENScADGSf2AUDA@nanopsycho>
References: <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
 <Y8AgaVjRGgWtbq5X@nanopsycho>
 <Y8BmgpxAuqJKe8Pc@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8BmgpxAuqJKe8Pc@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 12, 2023 at 08:58:58PM CET, leon@kernel.org wrote:
>On Thu, Jan 12, 2023 at 03:59:53PM +0100, Jiri Pirko wrote:
>> Thu, Jan 12, 2023 at 08:07:43AM CET, leon@kernel.org wrote:
>> >On Wed, Jan 11, 2023 at 01:29:03PM -0800, Jacob Keller wrote:
>> >> 
>> >> 
>> >> On 1/11/2023 8:45 AM, Jakub Kicinski wrote:
>> >> > On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
>> >> >>>> I'm confused. You want to register objects after instance register?  
>> >> >>>
>> >> >>> +1, I think it's an anti-pattern.  
>> >> >>
>> >> >> Could you elaborate a bit please?
>> >> > 
>> >> > Mixing registering sub-objects before and after the instance is a bit
>> >> > of an anti-pattern. Easy to introduce bugs during reload and reset /
>> >> > error recovery. I thought that's what you were saying as well.
>> >> 
>> >> I was thinking of a case where an object is dynamic and might get added
>> >> based on events occurring after the devlink was registered.
>> >> 
>> >> But the more I think about it the less that makes sense. What events
>> >> would cause a whole subobject to be registerd which we wouldn't already
>> >> know about during initialization of devlink?
>> >> 
>> >> We do need some dynamic support because situations like "add port" will
>> >> add a port and then the ports subresources after the main devlink, but I
>> >> think that is already supported well and we'd add the port sub-resources
>> >> at the same time as the port.
>> >> 
>> >> But thinking more on this, there isn't really another good example since
>> >> we'd register things like health reporters, regions, resources, etc all
>> >> during initialization. Each of these sub objects may have dynamic
>> >> portions (ex: region captures, health events, etc) but the need for the
>> >> object should be known about during init time if its supported by the
>> >> device driver.
>> >
>> >As a user, I don't want to see any late dynamic object addition which is
>> >not triggered by me explicitly. As it doesn't make any sense to add
>> >various delays per-vendor/kernel in configuration scripts just because
>> >not everything is ready. Users need predictability, lazy addition of
>> >objects adds chaos instead.
>> >
>> >Agree with Jakub, it is anti-pattern.
>> 
>> Yeah, but, we have reload. And during reload, instance is still
>> registered yet the subobject disappear and reappear. So that would be
>> inconsistent with the init/fini flow.
>> 
>> Perhaps during reload we should emulate complete fini/init notification
>> flow to the user?
>
>"reload" is triggered by me explicitly and I will get success/fail result
>at the end. There is no much meaning in subobject notifications during
>that operation.

Definitelly not. User would trigger reload, however another entity
(systemd for example) would listen to the notifications and react
if necessary.

>
>Thanks
