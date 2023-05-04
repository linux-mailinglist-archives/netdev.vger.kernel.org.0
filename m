Return-Path: <netdev+bounces-267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C93AD6F6961
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86D9A280CFE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A52AFBEE;
	Thu,  4 May 2023 11:00:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C51DED4
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:00:48 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D163358A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 04:00:46 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f19afc4fd8so2413855e9.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 04:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683198044; x=1685790044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5AbvHIm13pUXGDUyW2ngqVKs0jOuzsuSmuOEczfa29c=;
        b=rvcyw62eFefV9eX4VUnpGOtV+I+5zhwnu4Lno69aVf/xs+EYJKgRhkngvEoo3IZh2M
         6GrCE1Xho8iZKWj3nJNkMh3g9sclv743pjWidbmp6fTJZq7O0Vn1UdxDvu7qj2SNfyos
         BEJ2SN+c+U3+Z264N+jxVjOwtXM3AweOvEVDqTBmNRqeZ2SRFw5IBXf5qWxIxJH2/1yC
         a2ygRQx9hxj5I+ff/CidfG1l8VT9eV3/I49+ri9JZJeS3U3nUKVzffC33TR/mpxmirxB
         dyT3paIkXTvM0rLc82m+yd9Xg+ksGw+KuGOk6RbAw9+3OE9/FtcL5vr30e/uEiW2oTIa
         87Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683198044; x=1685790044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AbvHIm13pUXGDUyW2ngqVKs0jOuzsuSmuOEczfa29c=;
        b=ZOkZxUghTPdAf5pa95azmOTiSWmiOG1tLa5SQuZlicvV5fgkXOKcVJywz/3L2gemmc
         HZWV30Rtjzrs5SZgjNB+9At84duv7++HcXasSAmbad4G1IrFzQfRlHUWizWtPRgvVY/8
         XIRIgfBClYiEpFeDTYK+AQPSDb1jtDr/f/WIbnntHJc/LXjtORLwmbmMoPLmUf6ns7f4
         OoNoDy/i+6dENAkPFHTFXDH0ExWMaRchVpg0tnzu7DWX3ZG1NAti1qYWh5D2WWPbkqpk
         DzGt5BF4z1VbQji3kz8CC7Gm7YPcC6LcTDscLnG0puJUGisrASsFMO8XGPthFx4riMz7
         JZEQ==
X-Gm-Message-State: AC+VfDwr/H5tDtnHAh1hVURVZbg1jRDhxjs8DboI0W5XApmoj0Bl08+Z
	RXoiFV7sQ03uINaCjHp2GRU/fw==
X-Google-Smtp-Source: ACHHUZ7Xt8Q8wHgW0dOVY4B3WuZrnKey2oMRQtWw1LOL0mJs55ReMKmVqK6biI5XJRsg6qM0U0+naQ==
X-Received: by 2002:a05:600c:214e:b0:3f1:7277:eaa with SMTP id v14-20020a05600c214e00b003f172770eaamr17156472wml.31.1683198044365;
        Thu, 04 May 2023 04:00:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m20-20020a7bce14000000b003f3195be0a0sm4560383wmc.31.2023.05.04.04.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 04:00:43 -0700 (PDT)
Date: Thu, 4 May 2023 13:00:42 +0200
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
Message-ID: <ZFOQWmkBUtgVR06R@nanopsycho>
References: <ZBGOWQW+1JFzNsTY@nanopsycho>
 <20230403111812.163b7d1d@kernel.org>
 <ZDJulCXj9H8LH+kl@nanopsycho>
 <20230410153149.602c6bad@kernel.org>
 <ZDwg88x3HS2kd6lY@nanopsycho>
 <20230417124942.4305abfa@kernel.org>
 <ZFDPaXlJainSOqmV@nanopsycho>
 <20230502083244.19543d26@kernel.org>
 <ZFITyWvVcqgRtN+Q@nanopsycho>
 <20230503191643.12a6e559@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503191643.12a6e559@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 04, 2023 at 04:16:43AM CEST, kuba@kernel.org wrote:
>On Wed, 3 May 2023 09:56:57 +0200 Jiri Pirko wrote:
>> >Yup, non-deterministic, just a cyclic ID allocated by the core starting
>> >from 1. Finding the right device / pin needs to be done via
>> >informational attributes not making assumptions about the ID.  
>> 
>> Okay.
>> 
>> When netdev will have pin ID in the RT netlink message (as it is done
>> in RFCv7), it is easy to get the pin/dpll for netdev. No problem there.
>> 
>> However, for non-SyncE usecase, how do you imagine scripts to work?
>> I mean, the script have to obtain dpll/pin ID by deterministic
>> module_name/clock_id/idx tuple.
>
>No scoped idx.

That means, no index defined by a driver if I undestand you correctly,
right?


>
>> There are 2 options to do that:
>> 1) dump all dplls/pins and do lookup in userspace
>> 2) get a dpll/pin according to given module_name/clock_id/idx tuple
>> 
>> The first approach is not very nice.
>> The currently pushed RFCv7 of the patchset does not support 2)
>> 
>> Now if we add support for 2), we basically use module_name/clock_id/idx
>> as a handle for "get cmd". My point is, why can't we use it for "set
>> cmd" as well and avoid the ID entirely?
>
>Sure, we don't _have_ to have an ID, but it seems go against normal
>data normalization rules. And I don't see any harm in it.
>
>But you're asking for per-device "idx" and that's a no-go for me,
>given already cited experience.
>
>The user space can look up the ID based on identifying information it
>has. IMO it's better to support multiple different intelligible elements

Do you mean fixed tuple or variable tuple?

CMD_GET_ID
  -> DPLL_A_MODULE_NAME
     DPLL_A_CLOCK_ID
  <- DPLL_A_ID

CMD_GET_PIN_ID
  -> DPLL_A_MODULE_NAME
     DPLL_A_CLOCK_ID
  <- DPLL_A_PIN_ID



>than single integer index into which drivers will start encoding all
>sort of info, using locally invented schemes.

There could be multiple DPLL and pin instances for a single
module/clock_id tuple we have to distinguish somehow. If the driver
can't pass "index" of DPLL or a pin, how we distinguish them?

Plus is is possible that 2 driver instances share the same dpll
instance, then to get the dpll pointer reference, they do:
INSTANCE A:
dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);

INSTANCE B:
dpll_0 = dpll_device_get(clock_id, 0, THIS_MODULE);
dpll_1 = dpll_device_get(clock_id, 1, THIS_MODULE);

My point is, event if we don't expose the index to the userspace,
we need to have it internally.


