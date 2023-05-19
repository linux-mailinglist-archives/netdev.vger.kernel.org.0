Return-Path: <netdev+bounces-3822-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D29708FBE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DEDD1C21213
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A876065C;
	Fri, 19 May 2023 06:15:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8BF7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:15:58 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B88C1AD
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:15:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3075e802738so2726864f8f.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684476955; x=1687068955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oU2aaZIcfAL/J7x8hKgNcEmwTba6so0CuVNNIebXyJo=;
        b=VofQDRVT1jdG/lDa+izEbTfQZSQdPXUA+AlBPDKbeiloOfTHZ8kCdyoR7Df0sXAtix
         dUoEu4fRTeosTJ3qUfJDz2v2dkvKwPZcroDBm+D909j9XXnIfm7iBbGhPhuNYeOUh7XK
         pvmm3+eiQe3+Q0eINYgpEnTONkJwumRgzZUPAKMLPK+1ERAPxQBIRqX50WtPNe85Os5P
         JTPQznB+kf6ckenm/uitdJGARkLZ3PM7WpuBjwH+23Wn+RXLXllj1o2B8iYanABsyf83
         EqxshMNzFHtPrdmnX4qTL8+laetM18hIauFvX8qJoQomRfllrIWmGnuDu8XMArTMl9sk
         P4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684476955; x=1687068955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oU2aaZIcfAL/J7x8hKgNcEmwTba6so0CuVNNIebXyJo=;
        b=Iuu0kEAT0JutWtOqRyZR5JlnzumD3YSQEexdyQbnDjr021sP61wqO+SDsi2Pmesfph
         9xo5/m1oR4WpnA8R2K2m126t8w4Rb8t3ylweDbf1ee6BVInWdk5t08s8xGtDptsbsu5P
         F9VZM/AvexzuERPIK/FM7lgrMVvgFrHtIkabvt09bkuRkWwzHncizAoCYf2EdWjQxf4+
         RpyLCciUNXLiLlTFfZsKewbZcaSZaGA/V5J/CAaNfrerSG5fCBIZNrnBhb3RnwCoHTCk
         l4Dtn2Eh1f446ADO3TOEJ2AU/oKvUR3sO9YNxl4Zpx9RTFWqVgaN5WOmGYMbiyVlimH6
         nXYQ==
X-Gm-Message-State: AC+VfDy8ZJsTiXhuss2wdJFoQovij21DTENzuOWp7XfcE1K7t2piSYXT
	lO/7pnDxcmCBlPmtslMl68abWA==
X-Google-Smtp-Source: ACHHUZ5CXRNO+/Y9dUrlLh8l0PKouHwzklNi4pxgozOUKSXhvSQfzpurqtkaDV1PH5HIwXBp/bfUNw==
X-Received: by 2002:adf:e912:0:b0:309:3bb5:7968 with SMTP id f18-20020adfe912000000b003093bb57968mr1185087wrm.16.1684476954774;
        Thu, 18 May 2023 23:15:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l16-20020a5d4bd0000000b0030642f5da27sm4224263wrt.37.2023.05.18.23.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 23:15:54 -0700 (PDT)
Date: Fri, 19 May 2023 08:15:53 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Message-ID: <ZGcUGdSPSJJsO8Kl@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com>
 <ZGJn/tKjzxNYcNKU@nanopsycho>
 <DM6PR11MB46570013B31FCCF1FCE0854D9B799@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGNtH1W3Y/pnx2Hk@nanopsycho>
 <DM6PR11MB465765FA0C789D6D49B32C159B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB465765FA0C789D6D49B32C159B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 18, 2023 at 06:07:33PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Tuesday, May 16, 2023 1:47 PM
>>
>>Tue, May 16, 2023 at 11:22:37AM CEST, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Monday, May 15, 2023 7:13 PM
>>>>
>>>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>>>
>>>>[...]
>>>>
>>>>>+static const enum dpll_lock_status
>>>>>+ice_dpll_status[__DPLL_LOCK_STATUS_MAX] = {
>>>>>+	[ICE_CGU_STATE_INVALID] = DPLL_LOCK_STATUS_UNSPEC,
>>>>>+	[ICE_CGU_STATE_FREERUN] = DPLL_LOCK_STATUS_UNLOCKED,
>>>>>+	[ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_CALIBRATING,
>>>>
>>>>This is a bit confusing to me. You are locked, yet you report
>>>>calibrating? Wouldn't it be better to have:
>>>>DPLL_LOCK_STATUS_LOCKED
>>>>DPLL_LOCK_STATUS_LOCKED_HO_ACQ
>>>>
>>>>?
>>>>
>>>
>>>Sure makes sense, will add this state.
>>
>>Do you need "calibrating" then? I mean, the docs says:
>>  ``LOCK_STATUS_CALIBRATING``   dpll device calibrates to lock to the
>>                                source pin signal
>>
>>Yet you do: [ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_CALIBRATING
>>Seems like you should have:
>>[ICE_CGU_STATE_LOCKED] = DPLL_LOCK_STATUS_LOCKED
>>[ICE_CGU_STATE_LOCKED_HO_ACQ] = DPLL_LOCK_STATUS_LOCKED_HO_ACQ,
>>
>>and remove DPLL_LOCK_STATUS_CALIBRATING as it would be unused?
>>
>>Also, as a sidenote, could you use the whole names of enum value names
>>in documentation? Simple reason, greppability.
>>
>
>Yes, removed CALIBRATING.
>Fixed the docs.

Cool, thanks!


>
>Thank you!
>Arkadiusz
>
>>Thanks!
>>
>>
>>>
>>>>
>>>>>+	[ICE_CGU_STATE_LOCKED_HO_ACQ] = DPLL_LOCK_STATUS_LOCKED,
>>>>>+	[ICE_CGU_STATE_HOLDOVER] = DPLL_LOCK_STATUS_HOLDOVER,
>>>>>+};
>>>>
>>>>[...]

