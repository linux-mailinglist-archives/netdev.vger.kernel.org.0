Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E426678AD
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbjALPMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbjALPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:11:37 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C03F59518
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:59:56 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso4058968wmb.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OraHuU0LejEvVpz3R1JAyMl5Rmr7lbl9q8bE2HLGS48=;
        b=SQjuSrgXTRMUpiVvZDNubT6cxHaozFZZLOy+YjJeMbxGnc4UZT1nabhPYQDpWayDEV
         P+43Ssk9FlWw/wfXWn+8/bshsTaA66nyp5iXyDLIJ77UGkBj5l/hWSBc3mhh01kKCbba
         R1u+aZrO6Zwhxc3uvyylKPwo2C8oVg1w+9z/rktTCMIuFlu+NLUroGphP7GDRS4X1HjK
         R1SKIJKKQdhzPU0e8wjKkZcwsYtL5ykU5aSvbtYVrK+IEjAr+sFLRnuVWUfdITXp+dzc
         8HxywYWBOlVib0SWEoaj4vZbZYd00bpvco/NTP17uM45/76WEWBwneJleeyqoiy9IgNN
         vkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OraHuU0LejEvVpz3R1JAyMl5Rmr7lbl9q8bE2HLGS48=;
        b=yHpLUmQZcwHFO4Dd8oAou1QafK8470wl7dpLfOPnkRq0wUCqtk4IW/JbiKgvB6pH7s
         aCVeWnwS5XSOncmn7m3uJbE+RDRKRctfuyw6Zrh+BAO3y05Z5xwTyQzZgym5UOl7UEo2
         aE4lfjHUtQnD+sRPBRtJAmLT5n5qtkqaBVUpjIKjjwwmNA57TXhAjx6LKhMc1lbqVFT2
         m1l/WNZ6esE+ylERSbHdgB3rM51GvUktWvN8MBtbHo4mJiecQkrDjbJ1YHBwnEJOicbk
         o7fWl625VClyoWgfdGMpr0YPNlnCYbfzTN6zLSOGeOTXD7ITvbq0j6gOG2h6chMTK96k
         OF+w==
X-Gm-Message-State: AFqh2kp4ITcyURfoGUj2dQxp/fKA4VTBemOCRxPQ9xfduyPchZbVlY8k
        kalFT1v5Nx0R8SdvajrWUj44Yw==
X-Google-Smtp-Source: AMrXdXtI0T6LjiWFU7yg/6bucUh/eI8k2BvKWNGBKndf4zBpChHRjSf4Dcn/jcLk6UPc3MnZx2KEUg==
X-Received: by 2002:a05:600c:a4d:b0:3cf:6e78:e2ca with SMTP id c13-20020a05600c0a4d00b003cf6e78e2camr59385620wmq.5.1673535595144;
        Thu, 12 Jan 2023 06:59:55 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id i8-20020a05600c354800b003cf894dbc4fsm23936718wmq.25.2023.01.12.06.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:59:54 -0800 (PST)
Date:   Thu, 12 Jan 2023 15:59:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8AgaVjRGgWtbq5X@nanopsycho>
References: <20230106063402.485336-8-kuba@kernel.org>
 <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7+xv6gKaU+Horrk@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 12, 2023 at 08:07:43AM CET, leon@kernel.org wrote:
>On Wed, Jan 11, 2023 at 01:29:03PM -0800, Jacob Keller wrote:
>> 
>> 
>> On 1/11/2023 8:45 AM, Jakub Kicinski wrote:
>> > On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
>> >>>> I'm confused. You want to register objects after instance register?  
>> >>>
>> >>> +1, I think it's an anti-pattern.  
>> >>
>> >> Could you elaborate a bit please?
>> > 
>> > Mixing registering sub-objects before and after the instance is a bit
>> > of an anti-pattern. Easy to introduce bugs during reload and reset /
>> > error recovery. I thought that's what you were saying as well.
>> 
>> I was thinking of a case where an object is dynamic and might get added
>> based on events occurring after the devlink was registered.
>> 
>> But the more I think about it the less that makes sense. What events
>> would cause a whole subobject to be registerd which we wouldn't already
>> know about during initialization of devlink?
>> 
>> We do need some dynamic support because situations like "add port" will
>> add a port and then the ports subresources after the main devlink, but I
>> think that is already supported well and we'd add the port sub-resources
>> at the same time as the port.
>> 
>> But thinking more on this, there isn't really another good example since
>> we'd register things like health reporters, regions, resources, etc all
>> during initialization. Each of these sub objects may have dynamic
>> portions (ex: region captures, health events, etc) but the need for the
>> object should be known about during init time if its supported by the
>> device driver.
>
>As a user, I don't want to see any late dynamic object addition which is
>not triggered by me explicitly. As it doesn't make any sense to add
>various delays per-vendor/kernel in configuration scripts just because
>not everything is ready. Users need predictability, lazy addition of
>objects adds chaos instead.
>
>Agree with Jakub, it is anti-pattern.

Yeah, but, we have reload. And during reload, instance is still
registered yet the subobject disappear and reappear. So that would be
inconsistent with the init/fini flow.

Perhaps during reload we should emulate complete fini/init notification
flow to the user?
