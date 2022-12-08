Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5373646E88
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLHL27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLHL25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:28:57 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC15391FD
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:28:55 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id kw15so3092177ejc.10
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 03:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7jGKjRaadAUWcKSMtuLDogAQ/W6NGI72ajRE5rNrApc=;
        b=KjLGzqUKS159EmmEtRJx7xfA5ut9ROS2kHppVMWG6+QIhhcjUUE8Qq4zH9hBC6vxwZ
         5ZRTeOYJQ9wwXKcjgfDx9KbdXCiPAtzRYszxiGN2FmmsODYxrZt/FBg6CS9PXI4nWZaG
         WBnPvtqzSRq3pC3V34cZ7ID+JHdMECICzoymGWLxgNXa1lUUOdXm0TLTj9u8PV2x8H6e
         N47hJthEE7Xx9ZpV+TWBUvhZZo63w3QMXWBK61gOKSd/VOET3AV8FpWmPXtc+v25kQWG
         qju4uQGp+nnvgoc+8c1KP6zGe/GWpwG4Fa1YLjijc7CC5OeOfHTNtSR5oem8LJWcqinj
         +nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jGKjRaadAUWcKSMtuLDogAQ/W6NGI72ajRE5rNrApc=;
        b=UNz8lRWVUjNCYTt65JC4nzRfP7XEiEI8Joghh/ZevpsYsljU4ONLdgjHaPnohKfL12
         Vpe1XOrXHV2ZrIdkho6EFmvUQCJlnEHkovw107EVZRtKqfRWvK40axW/NEIrbZqzcKM0
         YxzL+cY2FkYuKIPDbCk88V89yNtnQ4KJYsyULit/THKZ82PWTYw0BA6bQg4gWH5WIxO2
         LAQsaz7fKJqSwcVyG53neMEgpXkEUzYiX8C+/2cBifyetUHRcNF9wSCuAZCXGJtiBh3U
         k1nga7IBDaghLHwPUS1tAs+PlJhg1nbHZBh3rMB6cVLr8UroISQfOPu3NTscvCyp3aMl
         +FEA==
X-Gm-Message-State: ANoB5pmjdjrZM5zNUtrrXrD7icWUfwqzt8iDrWwqH6JJ93ndHmmj1Cyp
        ZG0S8d/xid2BvrNwTuv43sRLxg==
X-Google-Smtp-Source: AA0mqf759X1K6h12OhkxauKHQLHS1lYoLdNVreZYJllcF0e8LARSjsjhaDfQLMBgcNgpC6cQJQnWjQ==
X-Received: by 2002:a17:906:af6a:b0:7c1:12ef:bf52 with SMTP id os10-20020a170906af6a00b007c112efbf52mr1489681ejb.3.1670498933806;
        Thu, 08 Dec 2022 03:28:53 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g2-20020a170906198200b007bd1ef2cccasm9634138ejd.48.2022.12.08.03.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 03:28:53 -0800 (PST)
Date:   Thu, 8 Dec 2022 12:28:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev.dump@gmail.com,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y5HKczFwRnfRVtnR@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207152157.6185b52b@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 12:21:57AM CET, kuba@kernel.org wrote:
>On Wed, 7 Dec 2022 15:09:03 +0100 netdev.dump@gmail.com wrote:
>> > -----Original Message-----
>> > From: Jakub Kicinski <kuba@kernel.org>
>> > Sent: Wednesday, December 7, 2022 3:48 AM
>> > Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
>> > 
>> > On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:  
>>  [...]  
>> capable
>>  [...]  
>> require
>>  [...]  
>
>Please fix line wrapping in your email client. 
>And add a name to your account configuration :/
>
>> > > Yep, you have the knowledge of sharing inside the driver, so you should
>> > > do it there. For multiple instances, use in-driver notifier for example.  
>> > 
>> > No, complexity in the drivers is not a good idea. The core should cover
>> > the complexity and let the drivers be simple.  
>> 
>> But how does Driver A know where to connect its pin to? It makes sense to
>> share 
>
>I think we discussed using serial numbers.

Can you remind it? Do you mean serial number of pin?


>
>> pins between the DPLLs exposed by a single driver, but not really outside of
>> it.
>> And that can be done simply by putting the pin ptr from the DPLLA into the
>> pin
>> list of DPLLB.
>
>Are you saying within the driver it's somehow easier? The driver state
>is mostly per bus device, so I don't see how.

You can have some shared data for multiple instances in the driver code,
why not?


>
>> If we want the kitchen-and-sink solution, we need to think about corner
>> cases.
>> Which pin should the API give to the userspace app - original, or
>> muxed/parent?
>
>IDK if I parse but I think both. If selected pin is not directly
>attached the core should configure muxes.
>
>> How would a teardown look like - if Driver A registered DPLLA with Pin1 and
>> Driver B added the muxed pin then how should Driver A properly
>> release its pins? Should it just send a message to driver B and trust that
>> it
>> will receive it in time before we tear everything apart?
>
>Trivial.
>
>> There are many problems with that approach, and the submitted patch is not
>> explaining any of them. E.g. it contains the dpll_muxed_pin_register but no
>> free 
>> counterpart + no flows.
>
>SMOC.

Care to spell this out. I guess you didn't mean "South Middlesex
Opportunity Council" :D


>
>> If we want to get shared pins, we need a good example of how this mechanism
>> can be used.
>
>Agreed.
>
>> > > There are currently 3 drivers for dpll I know of. This in ptp_ocp and
>> > > mlx5 there is no concept of sharing pins. You you are talking about a
>> > > single driver.
>> > >
>> > > What I'm trying to say is, looking at the code, the pin sharing,
>> > > references and locking makes things uncomfortably complex. You are so
>> > > far the only driver to need this, do it internally. If in the future
>> > > other driver appears, this code would be eventually pushed into dpll
>> > > core. No impact on UAPI from what I see. Please keep things as simple as
>> > > possible.  
>> > 
>> > But the pin is shared for one driver. Who cares if it's not shared in
>> > another. The user space must be able to reason about the constraints.
>> > 
>> > You are suggesting drivers to magically flip state in core objects
>> > because of some hidden dependencies?!
>> 
>> If we want to go outside the device, we'd need some universal language
>> to describe external connections - such as the devicetree. I don't see how
>> we can reliably implement inter-driver dependency otherwise.
>
>There's plenty examples in the tree. If we can't use serial number
>directly we can compare the driver pointer + whatever you'd compare
>in the driver internal solution.
>
>> I think this would be better served in the userspace with a board-specific
>> config file. Especially since the pins can be externally connected anyway.
>
>Opinions vary, progress is not being made.
