Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35BC668F9E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbjAMHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbjAMHx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:53:59 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C876147A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 23:53:58 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ud5so50436909ejc.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 23:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jzcmz/UTZlwnAxec3rVe1nzt7BdRmCyqA9oAryW6tNo=;
        b=s1QIoUc2fuGI2OabgKhJiR9vwa/k7MFPFTrPlFlWNAkn7c3VXTwy/9aIShDnEAQD3l
         VkQHSD5E2ypXgUU7a182JvRsuo+llVgqPoW+B/94aPsTo4xVuH9Vzp3hRxMTd96joeHc
         QOWkR3nmozR5mokxge3x7Xq2l+u3oGu+LeRbUUKyDsxaeHhFxCjQMiI3YeJpo2sbr6DX
         d3GOzymtkJxjSxM9/461Uh5ZRbPirDrqQyX8LAnQy8DVrT67GASSFJomUWUjxx7auYlH
         gVimqNeseif/fyJQSdQsVgW/lvGZH0D7rD5k/HKJGG05porsMpHqB7VjfuEHOmymErtL
         Hy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jzcmz/UTZlwnAxec3rVe1nzt7BdRmCyqA9oAryW6tNo=;
        b=4JMSPhTaz35f7vkqZ8YowDx/tGk1kHIMtdpJ4OOcCHyLQkkeqp6zhGbt4ZRXCQ7jVn
         JTn1JoRuCsHOpgwXogOnXjXkhdpyeQ1Nh1VvYo5E5YELJldwJOCnT+pFSIfDjq/NiEpx
         Ntn/qQ34ZSCWWO3PoMmQntgrIJPiqJ+MNorPo23g5EXYGtmUVpw0TL/N/egdXRqmLhyN
         o7TQm1VEkgAKbrjfYkBErNU06r/IcMLFfErN+BCvI3yFRaKjV5sy1Q+wGmznwmPtHtF9
         28Xr93F8NIR+nN4D0q1THqw1YMCnCItXnHzb31Isb3kmm4SPPsY1gb3gf+Qoy2wwVrzE
         i3UA==
X-Gm-Message-State: AFqh2koxed7gF3NrerJTxMW7WirThK+BFrlgSMaIig0JG+IuClofpb6f
        S0i/BqpUHm6TF2OFeeAqgYFj3Q==
X-Google-Smtp-Source: AMrXdXvQzM84EsMFLcfvBxUsR2GzI69qAjSLEt2A4p5FagqNaPPIMdmmWMC5mTXqdAj6bJkd7yqJng==
X-Received: by 2002:a17:907:8d17:b0:7c1:1ada:5e1e with SMTP id tc23-20020a1709078d1700b007c11ada5e1emr67406564ejc.26.1673596436863;
        Thu, 12 Jan 2023 23:53:56 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id kv23-20020a17090778d700b008699bacc03csm730150ejc.14.2023.01.12.23.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:53:56 -0800 (PST)
Date:   Fri, 13 Jan 2023 08:53:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8EOE7WSlSP1SrBO@nanopsycho>
References: <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
 <20230112112021.0ff88cdb@kernel.org>
 <Y8Bo7m3zl4WhRBtW@unreal>
 <c712d89c-48ca-920b-627e-93305e281a03@intel.com>
 <Y8D+GjYZKvtstIC+@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8D+GjYZKvtstIC+@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 13, 2023 at 07:45:46AM CET, leon@kernel.org wrote:
>On Thu, Jan 12, 2023 at 02:44:43PM -0800, Jacob Keller wrote:
>> 
>> 
>> On 1/12/2023 12:09 PM, Leon Romanovsky wrote:
>> > On Thu, Jan 12, 2023 at 11:20:21AM -0800, Jakub Kicinski wrote:
>> >> On Thu, 12 Jan 2023 09:07:43 +0200 Leon Romanovsky wrote:
>> >>> As a user, I don't want to see any late dynamic object addition which is
>> >>> not triggered by me explicitly. As it doesn't make any sense to add
>> >>> various delays per-vendor/kernel in configuration scripts just because
>> >>> not everything is ready. Users need predictability, lazy addition of
>> >>> objects adds chaos instead.
>> >>>
>> >>> Agree with Jakub, it is anti-pattern.
>> >>
>> >> To be clear my preference would be to always construct the three from
>> >> the root. Register the main instance, then sub-objects. I mean - you
>> >> tried forcing the opposite order and it only succeeded in 90-something
>> >> percent of cases. There's always special cases.
>
>Back then, we had only one special case - netdevsim. I still think that
>all recent complexity that was brought to the devlink could be avoided
>if we would change netdevsim to behave as HW driver (remove sysfs).
>
>> Right. I think its easier to simply require devlink to be registered first.
>
>devlink_register() is no more than a fancy way to say to the world: "I'm
>ready to accept commands". Right now, when the need_lock flag is removed
>from all devlink commands, we can place devlink_register() at any place.
>
>> 
>> >> I don't understand your concern about user experience here. We have
>> >> notifications for each sub-object. Plus I think drivers should hold 
>> >> the instance lock throughout the probe routine. I don't see a scenario
>> >> in which registering the main instance first would lead to retry/sleep
>> >> hacks in user space, do you? I'm talking about devlink and the subobjs
>> >> we have specifically.
>> > 
>> > The term "dynamic object addition" means for me what driver authors will
>> > be able to add objects anytime in lifetime of the driver. I'm pretty sure
>> > that once you allow that, we will see zoo here. Over time, you will get
>> > everything from .probe() to workqueues. The latter caused me to write
>> > about retry/sleep hacks.
>> > 
>> > If you success to force everyone to add objects in .probe() only, it
>> > will be very close to what I tried to achieve.
>> > 
>> > Thanks
>> 
>> Yea. I was initially thinking of something like that, but I've convinced
>> myself that its a bad idea. The only "dynamic" objects (added after the
>> initialization phase of devlink) should be those which are triggered via
>> user space request (i.e. "devlink port add").
>
>Exactly.

And reload as well.

>
>> 
>> Thanks,
>> Jake
