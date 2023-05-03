Return-Path: <netdev+bounces-101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF116F5266
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53A081C20BA4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAB863AD;
	Wed,  3 May 2023 07:57:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1521C15
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:57:04 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90BB2736
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:57:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bd87539c2so1870910a12.0
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 00:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683100619; x=1685692619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pcYFfZqejHZcwp6Yf370vPWTJUqUejy/+clrmToxzqI=;
        b=olDiilzCabAGiFawMWw7motGsETub6lHxM/WovTgYKHi1YXDv/jO0fLpvUPxuI6SEY
         AnJmrxUvXv74KkirN14i5EkJD0o/00UrFAs12SeFh0qIFrPGsbycIoSXNCo8DUVB/Fej
         SH1mxGk1GfOWpqzCsKZSRcxVnPEcLEPDccLXVaS0Sp+EEkrt5z61aKH23a7Fv8pqdDVL
         +6zDalgXJBKwh0eoXNcwLGPomF+uen0Zx0CqOjGOdDbn2u4gsy7Hj3UMqDNpzUG1bV34
         D8ADLZTOPFVd/TEJO1P+5ptI5y0v9z+ipJx5bfJIu74uSUa7mCQYT8sprl7AzZy2WWOS
         m8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683100619; x=1685692619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcYFfZqejHZcwp6Yf370vPWTJUqUejy/+clrmToxzqI=;
        b=exnDfcCKTGzzE+uWdppp66o7LR8GQe3ZeNq1kWUDNEWNUlI99Z2a53Gd3tQlyzUvYy
         d5fiVnCKrcSDcn12phT12E3ZUDADlTlPg6G+dodvXBPAAMDp6qsbjrsAvJ//6NCe6ggR
         KtWDYTePsSkfm2tROqtzOJ5N6d0uYCgFmCLwfMUk7IkX7h2QZ3AVp9HAtMM73a4m/fvi
         zSIjimjrkJTHrP31mQvrDB+Gvbi0NxQ48bDrJszqmqDtlPHLRXQWZxXpXcmLPADmDaS9
         mbI6K2gw5YDNSRseuGdJ+6wb6K7/ipG5zCikMfVIOwOG25sqKrioQS7NnZfAxYUO5uCU
         uTiQ==
X-Gm-Message-State: AC+VfDxejM/n+Kt8eg2ulgau5AikZART9//HMWKGRvzx6ypF0p+9Zu9u
	wZbVS8EA4udeCwwmpa5vcVd02/MwdnPnmyw4H+g=
X-Google-Smtp-Source: ACHHUZ75tPCKlOQ/bn/9cUaJxhFluM9jLzpY4mk18g4A1GcSnQv350qD16SCW+v0l8wSswuicKZcUg==
X-Received: by 2002:a17:907:9724:b0:962:582d:89d7 with SMTP id jg36-20020a170907972400b00962582d89d7mr2527333ejc.38.1683100619256;
        Wed, 03 May 2023 00:56:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g22-20020a170906595600b0094ed3abc937sm16841404ejr.82.2023.05.03.00.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 00:56:58 -0700 (PDT)
Date: Wed, 3 May 2023 09:56:57 +0200
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
Message-ID: <ZFITyWvVcqgRtN+Q@nanopsycho>
References: <ZBA8ofFfKigqZ6M7@nanopsycho>
 <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBGOWQW+1JFzNsTY@nanopsycho>
 <20230403111812.163b7d1d@kernel.org>
 <ZDJulCXj9H8LH+kl@nanopsycho>
 <20230410153149.602c6bad@kernel.org>
 <ZDwg88x3HS2kd6lY@nanopsycho>
 <20230417124942.4305abfa@kernel.org>
 <ZFDPaXlJainSOqmV@nanopsycho>
 <20230502083244.19543d26@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502083244.19543d26@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Adding back the cclist stripped due to Claws bug.

Tue, May 02, 2023 at 05:32:44PM CEST, kuba@kernel.org wrote:
>On Tue, 2 May 2023 10:52:57 +0200 Jiri Pirko wrote:
>> >> Index internal within a single instance. Like Intel guys, they have 1
>> >> clock wired up with multiple DPLLs. The driver gives every DPLL index.
>> >> This is internal, totally up to the driver decision. Similar concept to
>> >> devlink port index.  
>> >
>> >devlink port index ended up as a pretty odd beast with drivers encoding
>> >various information into it, using locally grown schemes.
>> >
>> >Hard no on doing that in dpll, it should not be exposed to the user.  
>> 
>> So you say to have ID fully dynamic and non deterministic? I'm lost a
>> bit.
>
>Yup, non-deterministic, just a cyclic ID allocated by the core starting
>from 1. Finding the right device / pin needs to be done via
>informational attributes not making assumptions about the ID.

Okay.

When netdev will have pin ID in the RT netlink message (as it is done
in RFCv7), it is easy to get the pin/dpll for netdev. No problem there.

However, for non-SyncE usecase, how do you imagine scripts to work?
I mean, the script have to obtain dpll/pin ID by deterministic
module_name/clock_id/idx tuple.

There are 2 options to do that:
1) dump all dplls/pins and do lookup in userspace
2) get a dpll/pin according to given module_name/clock_id/idx tuple

The first approach is not very nice.
The currently pushed RFCv7 of the patchset does not support 2)

Now if we add support for 2), we basically use module_name/clock_id/idx
as a handle for "get cmd". My point is, why can't we use it for "set
cmd" as well and avoid the ID entirely?

What am I missing here?

