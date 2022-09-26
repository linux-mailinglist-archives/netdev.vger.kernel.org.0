Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5A5EA783
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbiIZNmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 09:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiIZNlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 09:41:35 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7553009
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:59:57 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y8so8641831edc.10
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=B1uHGqTvOywhRYzeVXjBcmFOMxjIUzN5HodeanuZfxE=;
        b=wlOtRe7Hc/ANzyzD3oFPUjEJB2iFw/hzsaR/+44S0dfnQxE2GcDFtJxTm0dfrt9M5y
         y9+ALJUSPc+iltIgg+LqjTyrFo662xQIw183A2/hshATVCUqGNZ8iliBWMwaRGeauP5z
         JW2o7xIBVIl6s8x/0vLztj21stm/jryc8kgrFC9yqMCOdpe5xCGb9nsyrkwz1mMmidqi
         RB6c4irOzgZRc+0czieqMtMziVwFZynw6tvV2M6Cz/2bsSnqBzQwq+g2bNxfP97WhQqQ
         vThh65jzIN1SLeth8q6sgj/UPtVTrVbEdXksrDtVyz8i2dkFwkoPXvK0BliT85mIiuw9
         dQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=B1uHGqTvOywhRYzeVXjBcmFOMxjIUzN5HodeanuZfxE=;
        b=edi7xhwBnrcpBxleH3iocgyEI+amHPf+KJIgieDm7zD5kj9f+YTQR8O7C0Wj1RglUl
         8g/fkUYA93n9I2JIkZ33a/CF6SH2ssJ8w4al/CdahSPHnQy7ujPNGETegpC+m6SiUaMR
         CUIM9hwzOWY8q7nVgcJqpqKWE4n8m0RckhzlGF1AFc8ffpbuJZQRBgU+4tHWdJCy9Nrs
         0LPZ7gSpNqOh3ylXHNWzZ228gRvlNlrVvgWZiNcSV68F9sVTeEa+Nq9wQfLJY5P4Q7EI
         if9IvMivxPYQXmjkn7n4vVGlIzxCaqWsdclhuHaSX7BxM7ba7xy0HlDGivDkg7ROFcxd
         mrFg==
X-Gm-Message-State: ACrzQf24J9/dQdrzqoWrQNQ2uV9p3Vh6z65CNLWruqPYJX/Ot1d+T2TO
        TQPgVds43IY5jWGCRUNwBAdhhA==
X-Google-Smtp-Source: AMsMyM7BQFgaIiWuQX8a9zc6L0WAR/RZgL2hZXZ0Nfel84VPlpFVHTnoZ0bbZuwIRf+byc3YWt+Ktg==
X-Received: by 2002:a05:6402:cab:b0:457:5a5c:88a8 with SMTP id cn11-20020a0564020cab00b004575a5c88a8mr2727769edb.9.1664193534867;
        Mon, 26 Sep 2022 04:58:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709063ca200b00780a26edfcesm8189009ejh.60.2022.09.26.04.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:58:54 -0700 (PDT)
Date:   Mon, 26 Sep 2022 13:58:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     "Wilczynski, Michal" <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        dchumak@nvidia.com, maximmi@nvidia.com, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <YzGT98W0+Pzhahl8@nanopsycho>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
 <7ce70b9f-23dc-03c9-f83a-4b620cdc8a7d@intel.com>
 <24690f01-5a4b-840b-52b7-bdc0e6b9376a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24690f01-5a4b-840b-52b7-bdc0e6b9376a@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 20, 2022 at 01:09:04PM CEST, ecree.xilinx@gmail.com wrote:
>On 19/09/2022 14:12, Wilczynski, Michal wrote:
>> Maybe a switchdev case would be a good parallel here. When you enable switchdev, you get port representors on
>> the host for each VF that is already attached to the VM. Something that gives the host power to configure
>> netdev that it doesn't 'own'. So it seems to me like giving user more power to configure things from the host

Well, not really. It gives the user on hypervisor possibility
to configure the eswitch vport side. The other side of the wire, which
is in VM, is autonomous.


>> is acceptable.
>
>Right that's the thing though: I instinctively Want this to be done
> through representors somehow, because it _looks_ like it ought to
> be scoped to a single netdev; but that forces the hierarchy to
> respect netdev boundaries which as we've discussed is an unwelcome
> limitation.

Why exacly? Do you want to share a single queue between multiple vport?
Or what exactly would the the usecase where you hit the limitation?


>
>> In my mind this is a device-wide configuration, since the ice driver registers each port as a separate pci device.
>> And each of this devices have their own hardware Tx Scheduler tree global to that port. Queues that we're
>> discussing are actually hardware queues, and are identified by hardware assigned txq_id.
>
>In general, hardware being a single unit at the device level does
> not necessarily mean its configuration should be device-wide.
>For instance, in many NICs each port has a single hardware v-switch,
> but we do not have some kind of "devlink filter" API to program it
> directly.  Instead we attach TC rules to _many_ netdevs, and driver
> code transforms and combines these to program the unitary device.
>"device-wide configuration" originally meant things like firmware
> version or operating mode (legacy vs. switchdev) that do not relate
> directly to netdevs.
>
>But I agree with you that your approach is the "least evil method";
> if properly explained and documented then I don't have any
> remaining objection to your patch, despite that I'm continuing to
> take the opportunity to proselytise for "reprs >> devlink" ;)
>
>-ed
