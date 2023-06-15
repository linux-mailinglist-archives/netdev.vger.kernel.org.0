Return-Path: <netdev+bounces-11056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 767587315C8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A79991C20E49
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBB863A7;
	Thu, 15 Jun 2023 10:51:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38E3D9F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:51:15 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30871191
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:51:13 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b203891b2cso25108811fa.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1686826271; x=1689418271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RxABSA54+1ndzmLNmZc5u8v2UwgqGaT/6Aux105ZiwY=;
        b=YlBhxC9SsA7xXolvSHwGBszYEeQt4M1YptXKT6oY63kmp6DhZgXBCvIo96TXyhwlae
         9V9XyN5cV410mH3NM0t94LFEs/52dmwJFC/21TKyb63L6pWWDS3ofOK8vDRnJggD0upX
         4b3VarvIWFQttOXpqvBTuGcBQ4fWxnXG9+T1PP5UwAo2SxXO2zmmRzc78b9JF18IyGFy
         wSEuvjv5uXJ+DI8s0pSCTzBJwSEXRRrF1maoh3Bq5VOUTaa/gdaT5PciChNVN446lozJ
         q356EV0x6WW4/AzqD02ibIubbLH3b5O0qLtMphndlSj1Ma1XBhD6sJ/kzJEVgHjIJ30a
         6WNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686826271; x=1689418271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxABSA54+1ndzmLNmZc5u8v2UwgqGaT/6Aux105ZiwY=;
        b=ggy9wstFECsl4U5MmeZ7yf4h6ZJiAiwM6NfZP3hq/tJv633L28NqreWshrjL7M9+F1
         RYg4hT6x7hn2KUlv6wpGuJGhQc6bAvGyK8q2v2iw5r+TBnM4zh78sAt2Mhm88pIMSZpx
         kZmYOsTRe+BqOW4gRsZMOVFym4hoDgktR/6rZ9Tn8tjUBUkbIiB3hA+15ppe6bnP4oEc
         Sw4kW1kYf3cHL2PK8vBKAaj9jKtV0RDDxLrRkyUJd3fIb5wJSPOEGa+Fddw3Fn9ZVOmw
         BXHfg4MN/GOShgOfN4AhnoMsA1bL0YxdLrxkAvofHaR7Kr36EK7qgv8GS1/C1VVnBHCh
         ueRw==
X-Gm-Message-State: AC+VfDxfAT7EorBQfKid6ing8iragKCQcVd+7loAo6o0YNymGc6yGgHx
	lZf7Wk19LAb0jaT50kBMwyGzOg==
X-Google-Smtp-Source: ACHHUZ5vF46a1ThPvEJim0Qw8qDy1wNiruk6U7avl3ag0dwBArzZypxJqI/1K9To155M+OZKuCjJ0w==
X-Received: by 2002:a05:651c:22a:b0:2b1:a874:34c9 with SMTP id z10-20020a05651c022a00b002b1a87434c9mr10078580ljn.22.1686826271296;
        Thu, 15 Jun 2023 03:51:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d3-20020a2e8903000000b002b4430dda25sm358793lji.92.2023.06.15.03.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 03:51:10 -0700 (PDT)
Date: Thu, 15 Jun 2023 12:51:09 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
Message-ID: <ZIrtHZ2wrb3ZdZcB@nanopsycho>
References: <20230610014254.343576-1-saeed@kernel.org>
 <20230610014254.343576-15-saeed@kernel.org>
 <20230610000123.04c3a32f@kernel.org>
 <ZIVKfT97Ua0Xo93M@x130>
 <20230612105124.44c95b7c@kernel.org>
 <ZIj8d8UhsZI2BPpR@x130>
 <20230613190552.4e0cdbbf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613190552.4e0cdbbf@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, Jun 14, 2023 at 04:05:52AM CEST, kuba@kernel.org wrote:
>On Tue, 13 Jun 2023 16:32:07 -0700 Saeed Mahameed wrote:
>> On 12 Jun 10:51, Jakub Kicinski wrote:
>> >On Sat, 10 Jun 2023 21:15:57 -0700 Saeed Mahameed wrote:  
>> >> I think we did talk about this, but after internal research we prefer to
>> >> avoid adding additional knobs, unless you insist :) ..
>> >> I think we already did a research and we feel that all of our users are
>> >> going to re-configure the SF anyway, so why not make all SFs start with
>> >> "blank state" ?  
>> >
>> >In the container world, at least, I would have thought that the
>> >management daemon gets a full spec of the container its starting
>> >upfront. So going thru this spawn / config / futz / reset cycle
>> >is pure boilerplate pain.
>> 
>> That's the point of the series. create / config / spawn.
>> 
>> personally I like that the SF object is created blank, with dev handles
>> (devlink/aux) to configure it, and spawn it when ready.
>
>I think we had this discussion before, wasn't the initial proposal for SF
>along those lines? And we're slowly trending back towards ports in
>uninitialized state. It's okay, too late now.
>
>> I don't see a point of having an extra "blank state" devlink param.
>
>Yeah, the param would be worse of both worlds. 
>We'll need to ensure consistency in other vendors, tho.
>
>> >What use cases are you considering? More VM-oriented?
>> 
>> Mostly container oriented, and selecting the ULP stacks, e.g RDMA, VDPA,
>> virtio, netdev, etc .. 
>
>Odd, okay.
>
>> >> This was the first SF aux dev to be created on the system. :/
>> >>
>> >> It's a mess ha...
>> >>
>> >> Maybe we need to set the SF aux device index the same as the user index.
>> >> But the HW/port index will always be different, otherwise we will need a map
>> >> inside the driver.  
>> >
>> >It'd be best to synchronously return to the user what the ID of the
>> >allocated entity is. It should be possible with some core changes to
>> >rig up devlink to return the sfnum and port ID. But IDK about the new
>> >devlink instance :(  
>> 
>> I think that's possible, let me ask the team to take a shot at this.. 
>> 
>> I am not sure I understand what you mean by "new devlink instance".
>> 
>> SF creation will result in spawning two devlink handles, the SF function port of
>> on the eswitch and the SF device devlink instance..
>
>Yes, I mean "SF device devlink instance" by "new devlink instance".
>
>In theory this should all be doable with netlink. NLM_F_ECHO should
>loop all notifications back to the requester. The tricky part is
>catching the notifications, I'm guessing, because in theory the devlink
>instance spawning may be async for locking reasons? Hopefully not,
>then it's easy..

The problem is scalability. SFs could be activated in parallel, but the
cmd that is doing that holds devlink instance lock. That serializes it.
So we need to either:
1) change the devlink locking to be able to execute some of the cmds in
   parallel and leave the activation sync
2) change the activation to be async and work with notifications

I like 2) better, as the 1) maze we just got out of recently :)
WDYT?

>

