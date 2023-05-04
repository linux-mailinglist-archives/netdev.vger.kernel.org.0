Return-Path: <netdev+bounces-324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 072A16F718D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B745A280DD7
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C79BA43;
	Thu,  4 May 2023 17:51:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5E97E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:51:45 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA93C2
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 10:51:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2ac7462d9f1so9704141fa.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 10:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683222701; x=1685814701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O45EJsoDq0FqmHnerFViZl2wgrujScPaI15rEDqYMNE=;
        b=uFlPsO8rOXvRxLzCv8wu8QfDcuqRrwfKuf1HallJvCJGOewFVvgFbHzxus9dZORTyM
         dI/tqMDT+drHp2aGr0LMvK0AjH9nMQKVEpN70NfP0/9zVCT7EZDZnVLFAPqNYM0qGjWH
         kNnbG1xtu7iWY5T/O6JkdvO3xxRG0EvdrI4sSXknRaLDsUmPTX0pgBIK1IfFBSW+kdsY
         nyMUaSYyqM5Olpv8RHQtMW4qTBkYjFtsyAzXVnpFMpzVlR3i/awvRa6SJ67n6fazIIgr
         CndOZAOkaKFUG6yu4hSltD/I70enaaPBKq1BGP2jPyLunGzVa4GXVn4s1a1s6ForQW1/
         2NHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683222701; x=1685814701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O45EJsoDq0FqmHnerFViZl2wgrujScPaI15rEDqYMNE=;
        b=XOCUaQVojWaDK2qZ7hW0dr6AubozNN6Z/QsSeflOQepZ2MZ0Vh/7/YWhcM8zkieXR4
         eeC2KZnQBnLxUJaNS2I1th+6sUM4VDBDBUDIGrc1LMJhaLEX9tM598WuG3oxoOSU122i
         ZalLwa0vcr3/EILTkJaj45iEE7aMlBnpOzTjqZDT32cEBsmgaRhXc7cVuhjS6eGLwTz4
         Li0J76zDVafNyuiSa8MdfZ6cJAgEAfLzi1Q4BJngVaK4Ck1Tz+7zGKEdgLWbtH9Y/UBm
         HPOuKMuvK/IIEMt2YTpR9sEHnpn6YkS2AclhRm7za8i9SgRT0Zw9qTCk/+HFb3Q5paax
         G4Pw==
X-Gm-Message-State: AC+VfDxj7TLu4GA1MMF2Tpl7QHsRRbtB/saa377je2KeHrZZsgcoNH0e
	QzWhpSVAegI3BexPiQos9/h4zA==
X-Google-Smtp-Source: ACHHUZ7OfjupDiodfS/3ZFemfNnPjusNOrEf4cKdOHZtq3CRyMql0W2cUpmGdNjebY8nBN9KSOf/MA==
X-Received: by 2002:a2e:2403:0:b0:2a7:7259:9587 with SMTP id k3-20020a2e2403000000b002a772599587mr1111040ljk.46.1683222701245;
        Thu, 04 May 2023 10:51:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i3-20020a2e9403000000b002a8b5310642sm6707037ljh.5.2023.05.04.10.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 10:51:40 -0700 (PDT)
Date: Thu, 4 May 2023 19:51:38 +0200
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
Message-ID: <ZFPwqu5W8NE6Luvk@nanopsycho>
References: <ZDJulCXj9H8LH+kl@nanopsycho>
 <20230410153149.602c6bad@kernel.org>
 <ZDwg88x3HS2kd6lY@nanopsycho>
 <20230417124942.4305abfa@kernel.org>
 <ZFDPaXlJainSOqmV@nanopsycho>
 <20230502083244.19543d26@kernel.org>
 <ZFITyWvVcqgRtN+Q@nanopsycho>
 <20230503191643.12a6e559@kernel.org>
 <ZFOQWmkBUtgVR06R@nanopsycho>
 <20230504090401.597a7a61@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504090401.597a7a61@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 04, 2023 at 06:04:01PM CEST, kuba@kernel.org wrote:
>On Thu, 4 May 2023 13:00:42 +0200 Jiri Pirko wrote:
>> Thu, May 04, 2023 at 04:16:43AM CEST, kuba@kernel.org wrote:
>> >On Wed, 3 May 2023 09:56:57 +0200 Jiri Pirko wrote:  
>> >> Okay.
>> >> 
>> >> When netdev will have pin ID in the RT netlink message (as it is done
>> >> in RFCv7), it is easy to get the pin/dpll for netdev. No problem there.
>> >> 
>> >> However, for non-SyncE usecase, how do you imagine scripts to work?
>> >> I mean, the script have to obtain dpll/pin ID by deterministic
>> >> module_name/clock_id/idx tuple.  
>> >
>> >No scoped idx.  
>> 
>> That means, no index defined by a driver if I undestand you correctly,
>> right?
>
>Yes, my suggestion did not include a scoped index with no
>globally defined semantics.

Okay, makes sense. Devlink port index didn't end up well :/


> 
>> >> There are 2 options to do that:
>> >> 1) dump all dplls/pins and do lookup in userspace
>> >> 2) get a dpll/pin according to given module_name/clock_id/idx tuple
>> >> 
>> >> The first approach is not very nice.
>> >> The currently pushed RFCv7 of the patchset does not support 2)
>> >> 
>> >> Now if we add support for 2), we basically use module_name/clock_id/idx
>> >> as a handle for "get cmd". My point is, why can't we use it for "set
>> >> cmd" as well and avoid the ID entirely?  
>> >
>> >Sure, we don't _have_ to have an ID, but it seems go against normal
>> >data normalization rules. And I don't see any harm in it.
>> >
>> >But you're asking for per-device "idx" and that's a no-go for me,
>> >given already cited experience.
>> >
>> >The user space can look up the ID based on identifying information it
>> >has. IMO it's better to support multiple different intelligible elements  
>> 
>> Do you mean fixed tuple or variable tuple?
>> 
>> CMD_GET_ID
>>   -> DPLL_A_MODULE_NAME  
>>      DPLL_A_CLOCK_ID
>
>> What is the next intelligible element to identify DPLL device here?
>
>I don't know. We can always add more as needed.
>We presuppose that the devices are identifiable, so whatever info
>is used to identify them goes here.

Allright. So in case of ptp_ocp and mlx5, module_name and clock_id
are enough. In case of ice, DPLL_A_TYPE, attr is the one to make
distinction between the 2 dpll instances there

So for now, we can have:
 CMD_GET_ID
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
      DPLL_A_TYPE
   <- DPLL_A_ID


if user passes a subset which would not provide a single match, we error
out with -EINVAL and proper exack message. Makes sense?





>
>>   <- DPLL_A_ID
>> 
>> CMD_GET_PIN_ID
>>   -> DPLL_A_MODULE_NAME  
>>      DPLL_A_CLOCK_ID
>
>> What is the next intelligible element to identify a pin here?
>
>Same answer. Could be a name of the pin according to ASIC docs.
>Could be the ball name for a BGA package. Anything that's meaningful.

Okay, for pin, the type and label would probably do:
 CMD_GET_PIN_ID
   -> DPLL_A_MODULE_NAME
      DPLL_A_CLOCK_ID
      DPLL_A_PIN_TYPE
      DPLL_A_PIN_LABEL
   <- DPLL_A_PIN_ID

Again, if user passes a subset which would not provide a single match,
we error out with -EINVAL and proper exack message.

If there is only one pin for example, user query of DPLL_A_MODULE_NAME
and DPLL_A_CLOCK_ID would do return a single match. No need to pass
anything else.

I think this could work with both ice and ptp_ocp, correct guys?

For mlx5, I will have 2 or more pins with same module name, clock id
and type. For these SyncE pins the label does not really make sense.
But I don't have to query, because the PIN_ID is going to be exposed for
netdev over RT netlink. Clicks.

Makes sense?


>
>My point is that we don't want a field simply called "index". Because
>then for one vendor it will mean Ethernet port, for another SMA
>connector number and for the third pin of the package. Those are
>different attributes.

Got you and agree.


>
>>   <- DPLL_A_PIN_ID
>> 
>> >than single integer index into which drivers will start encoding all
>> >sort of info, using locally invented schemes.  
>> 
>> There could be multiple DPLL and pin instances for a single
>> module/clock_id tuple we have to distinguish somehow. If the driver
>> can't pass "index" of DPLL or a pin, how we distinguish them?
>> 
>> Plus is is possible that 2 driver instances share the same dpll
>> instance, then to get the dpll pointer reference, they do:
>> INSTANCE A:
>> dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
>> dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);
>> 
>> INSTANCE B:
>> dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
>> dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);
>> 
>> My point is, event if we don't expose the index to the userspace,
>> we need to have it internally.
>
>That's fine, I guess. I'd prefer driver matching to be the same as user
>space matching to force driver authors to have the same perspective as
>the user. But a "driver coookie" not visible to user space it probably
>fine.

Allright, lets leave them for now. As internal kernel API, could be
changed in the future if needed.

Arkadiusz, Vadim, are you following this?


