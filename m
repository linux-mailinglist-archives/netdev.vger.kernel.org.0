Return-Path: <netdev+bounces-270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA746F69A1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BCE9280D02
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCCFFBFD;
	Thu,  4 May 2023 11:14:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1056410EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:14:29 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E618D49CA
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 04:14:26 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3063b5f32aaso211023f8f.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 04:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683198865; x=1685790865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PUa05Tm/5AD86rND95WZHUr+PT5uRa9QsOrn0+SQoe4=;
        b=FNrcp8eahY9HHQAPrOgE2l3jAoEftR2Qknbq5yzRzzIUIAFx3S8UYtGuYvyHSs3d1Q
         Wu23bwG/gQPhj19eBHus6zkVE8PogGJ48pXiWcVb7wzQ/O+UImiQfq/ug2TabGweL5Xr
         e/g7lIsR88buuDlgb/o9V8l0zZRrOHujpWoJKnvAZWrYlYrXlVhhMdNWY3LqFwgNbo04
         edoAYMRQVGAiZOhQxa9biNJOTD4BlVf0wjMeWVrdzu2SYrKt9YRuNhtkiHT4jKPlRk7P
         NYaHV3lRr5axoeVEnnsavGi82lcY366W0bS8vpCJNUQtkROgPyXHEeKPfRDSpNt5y2m2
         JTqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683198865; x=1685790865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUa05Tm/5AD86rND95WZHUr+PT5uRa9QsOrn0+SQoe4=;
        b=e6CDdHsjFzddMgH6FOD3gr6QvRGSOLr/9ttrcPynCbXjM7Lmk+b0Kgk1qOZu8Hu2ad
         3pSQFUQqDBDWCLqi1vBxo5rgVLjeQtZP1KOEIXidX6867ZB9oWdlz9E0+V/BnDyC6Ch8
         pFZJHEM6DZNIMMQKMqIvpjDAT8XpAAieo6JRU/jNNRa2RJEy7NvjoYSyYkDYQvEflpms
         ZlfGqLCuygxX9/m+UHbvZ39VUNsiYKjh+n7kfEh9l/lMX1PKanLedRM28cOwW8p4FD5v
         RQZgM5brClhm3fhEaN0lKDQIW/KE6Ib72YZ5Jzyk1NJw3WiiKlkDuEKpYFKZyhGWtyG2
         2t8Q==
X-Gm-Message-State: AC+VfDzo852dAY3o2F5JJINtSN3nb9PvTR9EprYtokvESRgKFS2FsUUf
	O2IAUt+/TPwFoN84nosJgiW57g==
X-Google-Smtp-Source: ACHHUZ5HJnCkhVQ11dRZ+saw0vpjw8c6PMeCja53U+LDrpNNXXiocrze1hQAaIb3Oks6llFH6BLBVw==
X-Received: by 2002:a5d:558b:0:b0:306:3bf0:f1ec with SMTP id i11-20020a5d558b000000b003063bf0f1ecmr2498018wrv.7.1683198865228;
        Thu, 04 May 2023 04:14:25 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6e89000000b0030629536e64sm12715926wrz.30.2023.05.04.04.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 04:14:24 -0700 (PDT)
Date: Thu, 4 May 2023 13:14:23 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
	mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZFOTj70DxE2IMitO@nanopsycho>
References: <20230403111812.163b7d1d@kernel.org>
 <ZDJulCXj9H8LH+kl@nanopsycho>
 <20230410153149.602c6bad@kernel.org>
 <ZDwg88x3HS2kd6lY@nanopsycho>
 <20230417124942.4305abfa@kernel.org>
 <ZFDPaXlJainSOqmV@nanopsycho>
 <20230502083244.19543d26@kernel.org>
 <ZFITyWvVcqgRtN+Q@nanopsycho>
 <20230503191643.12a6e559@kernel.org>
 <ZFOQWmkBUtgVR06R@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFOQWmkBUtgVR06R@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 04, 2023 at 01:00:42PM CEST, jiri@resnulli.us wrote:
>Thu, May 04, 2023 at 04:16:43AM CEST, kuba@kernel.org wrote:
>>On Wed, 3 May 2023 09:56:57 +0200 Jiri Pirko wrote:
>>> >Yup, non-deterministic, just a cyclic ID allocated by the core starting
>>> >from 1. Finding the right device / pin needs to be done via
>>> >informational attributes not making assumptions about the ID.  
>>> 
>>> Okay.
>>> 
>>> When netdev will have pin ID in the RT netlink message (as it is done
>>> in RFCv7), it is easy to get the pin/dpll for netdev. No problem there.
>>> 
>>> However, for non-SyncE usecase, how do you imagine scripts to work?
>>> I mean, the script have to obtain dpll/pin ID by deterministic
>>> module_name/clock_id/idx tuple.
>>
>>No scoped idx.
>
>That means, no index defined by a driver if I undestand you correctly,
>right?
>
>
>>
>>> There are 2 options to do that:
>>> 1) dump all dplls/pins and do lookup in userspace
>>> 2) get a dpll/pin according to given module_name/clock_id/idx tuple
>>> 
>>> The first approach is not very nice.
>>> The currently pushed RFCv7 of the patchset does not support 2)
>>> 
>>> Now if we add support for 2), we basically use module_name/clock_id/idx
>>> as a handle for "get cmd". My point is, why can't we use it for "set
>>> cmd" as well and avoid the ID entirely?
>>
>>Sure, we don't _have_ to have an ID, but it seems go against normal
>>data normalization rules. And I don't see any harm in it.
>>
>>But you're asking for per-device "idx" and that's a no-go for me,
>>given already cited experience.
>>
>>The user space can look up the ID based on identifying information it
>>has. IMO it's better to support multiple different intelligible elements
>
>Do you mean fixed tuple or variable tuple?
>
>CMD_GET_ID
>  -> DPLL_A_MODULE_NAME
>     DPLL_A_CLOCK_ID

Sorry, I hit the send button by a mistake.
I ment to add a question here:
What is the next intelligible element to identify DPLL device here?

>  <- DPLL_A_ID
>
>CMD_GET_PIN_ID
>  -> DPLL_A_MODULE_NAME
>     DPLL_A_CLOCK_ID

What is the next intelligible element to identify a pin here?

>  <- DPLL_A_PIN_ID
>
>
>
>>than single integer index into which drivers will start encoding all
>>sort of info, using locally invented schemes.
>
>There could be multiple DPLL and pin instances for a single
>module/clock_id tuple we have to distinguish somehow. If the driver
>can't pass "index" of DPLL or a pin, how we distinguish them?
>
>Plus is is possible that 2 driver instances share the same dpll
>instance, then to get the dpll pointer reference, they do:
>INSTANCE A:
>dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
>dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);
>
>INSTANCE B:
>dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
>dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);
>
>My point is, event if we don't expose the index to the userspace,
>we need to have it internally.
>

