Return-Path: <netdev+bounces-3660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CF0708377
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027591C210B3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF242099E;
	Thu, 18 May 2023 14:02:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801B23C6A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:02:55 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB6210E9
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:02:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9659c5b14d8so322968666b.3
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684418566; x=1687010566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uD7kSTiPWuwX+1ADZs48IGh6DhAs9FcfnrRRwpbYrzQ=;
        b=HOxKqmFmJbdu8mHqDiXbfgreSwul+o8HWlGyl0UbruUSHJFT7QGycSf5RZrbbo0rAQ
         I7VzBcgYXmfWo32648NZUsmX4lK/fLtu2Qka1PVDUq99+ahOJqb8TP0miRErvTngT5YS
         geWgKnLsjrUlHrzQSBvHBX7Wsr1ws0BnAEdgo3xiCJDcIUpo1Cw1HAjcK6LHpY9tHo8n
         pAu/ggeaJOtcFY8uN7AdPTA9f5gaCdD+p4swbM2ZP3QtiKDnmDzu9BC/TR2yKERA7Klu
         JyiO5cvtPcQ3obAB42PCdk+36NWZrXaKc8oTY+d/WaJ5CPk+B7yFqGmAwLnKGF7n6xkg
         Il2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684418566; x=1687010566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uD7kSTiPWuwX+1ADZs48IGh6DhAs9FcfnrRRwpbYrzQ=;
        b=VxUZs/5mfxoRJy+L6VeTQj7pIbImrAQfdYH6grpKrgMtowO21TULgQXD5Nl2KPGwmE
         y5iB2tf8jH08LQs19YvsYPZDo74bF2fQb2jl7ykFAce1ScMGUASNuCSCWtpmLplzbvkl
         xMu9kAm51C1+pm0/7hmlvBOspFBvwGcMjUVrTp+7oORCb9AX5j3kl8V4Ae7OdREi+unV
         rJO2+N5opn2UdLt0SoiWqPpP8fC7OJK8nYrXgfPkkdGyudLqDgZuJ80i570IvEAM6WhF
         ckmft09Xz0NlUPySOVduH6Ng9IWQMkLRqDNqetzjeajFs7gMosVQaMAXVQAPd9ICdqVg
         2E2g==
X-Gm-Message-State: AC+VfDwGwhMv5934xVJvo6/i6LDe1jksTq6ZkcqUGNHGzqdmbaQpKCd5
	MsBCDZe4fK16D0xKFFfU7Osu8A==
X-Google-Smtp-Source: ACHHUZ4jmrayQs8toXPqTKczKGSnFItmbMOMAbRxyHHvC3+cc2E/0hV2iyG+9PoiR38GIIpOfsytPg==
X-Received: by 2002:a17:907:36c6:b0:94f:562b:2979 with SMTP id bj6-20020a17090736c600b0094f562b2979mr40151142ejc.31.1684418566136;
        Thu, 18 May 2023 07:02:46 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ck7-20020a170906c44700b0094e6a9c1d24sm1025637ejb.12.2023.05.18.07.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 07:02:45 -0700 (PDT)
Date: Thu, 18 May 2023 16:02:43 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZGYwA/gUzNKt02MK@nanopsycho>
References: <20230428002009.2948020-2-vadfed@meta.com>
 <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
 <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <ZFygbd1H+VdvCTyH@nanopsycho>
 <DM6PR11MB4657924148B84F502A44903D9B749@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGH7uvxD55Pan0gf@nanopsycho>
 <DM6PR11MB4657670163F45823F66B28619B799@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGOUPCxCzVNuOrDZ@nanopsycho>
 <DM6PR11MB4657BD5424F8845A0BB9AF119B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657BD5424F8845A0BB9AF119B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 18, 2023 at 03:24:45PM CEST, arkadiusz.kubalewski@intel.com wrote:
>
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Tuesday, May 16, 2023 4:34 PM
>>
>>Tue, May 16, 2023 at 02:05:38PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Monday, May 15, 2023 11:31 AM
>>>>
>>>>Thu, May 11, 2023 at 10:51:43PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>>Sent: Thursday, May 11, 2023 10:00 AM
>>>>>>
>>>>>>Thu, May 11, 2023 at 09:40:26AM CEST, arkadiusz.kubalewski@intel.com
>>>>>>wrote:
>>>>>>>>From: Jakub Kicinski <kuba@kernel.org>
>>>>>>>>Sent: Thursday, May 4, 2023 11:25 PM
>>>>>>>>
>>>>>>>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>>>>>>>>> >+definitions:
>>>>>>>>> >+  -
>>>>>>>>> >+    type: enum
>>>>>>>>> >+    name: mode
>>>>>>>>> >+    doc: |
>>>>>>>>> >+      working-modes a dpll can support, differentiate if and how
>>>>>>>>> >dpll selects
>>>>>>>>> >+      one of its sources to syntonize with it, valid values for
>>>>>>>>> >DPLL_A_MODE
>>>>>>>>> >+      attribute
>>>>>>>>> >+    entries:
>>>>>>>>> >+      -
>>>>>>>>> >+        name: unspec
>>>>>>>>>
>>>>>>>>> In general, why exactly do we need unspec values in enums and CMDs?
>>>>>>>>> What is the usecase. If there isn't please remove.
>>>>>>>>
>>>>>>>>+1
>>>>>>>>
>>>>>>>
>>>>>>>Sure, fixed.
>>>>>>>
>>>>>>>>> >+        doc: unspecified value
>>>>>>>>> >+      -
>>>>>>>>> >+        name: manual
>>>>>>>>
>>>>>>>>I think the documentation calls this "forced", still.
>>>>>>>>
>>>>>>>
>>>>>>>Yes, good catch, fixed docs.
>>>>>>>
>>>>>>>>> >+        doc: source can be only selected by sending a request to
>>>>>>>>> >dpll
>>>>>>>>> >+      -
>>>>>>>>> >+        name: automatic
>>>>>>>>> >+        doc: highest prio, valid source, auto selected by dpll
>>>>>>>>> >+      -
>>>>>>>>> >+        name: holdover
>>>>>>>>> >+        doc: dpll forced into holdover mode
>>>>>>>>> >+      -
>>>>>>>>> >+        name: freerun
>>>>>>>>> >+        doc: dpll driven on system clk, no holdover available
>>>>>>>>>
>>>>>>>>> Remove "no holdover available". This is not a state, this is a mode
>>>>>>>>> configuration. If holdover is or isn't available, is a runtime info.
>>>>>>>>
>>>>>>>>Agreed, seems a little confusing now. Should we expose the system clk
>>>>>>>>as a pin to be able to force lock to it? Or there's some extra magic
>>>>>>>>at play here?
>>>>>>>
>>>>>>>In freerun you cannot lock to anything it, it just uses system clock from
>>>>>>>one of designated chip wires (which is not a part of source pins pool) to
>>>>>>>feed the dpll. Dpll would only stabilize that signal and pass it further.
>>>>>>>Locking itself is some kind of magic, as it usually takes at least ~15
>>>>>>>seconds before it locks to a signal once it is selected.
>>>>>>>
>>>>>>>>
>>>>>>>>> >+      -
>>>>>>>>> >+        name: nco
>>>>>>>>> >+        doc: dpll driven by Numerically Controlled Oscillator
>>>>>>>>
>>>>>>>>Noob question, what is NCO in terms of implementation?
>>>>>>>>We source the signal from an arbitrary pin and FW / driver does
>>>>>>>>the control? Or we always use system refclk and then tune?
>>>>>>>>
>>>>>>>
>>>>>>>Documentation of chip we are using, stated NCO as similar to FREERUN, and
>>>>>>>it
>>>>>>
>>>>>>So how exactly this is different to freerun? Does user care or he would
>>>>>>be fine with "freerun" in this case? My point is, isn't "NCO" some
>>>>>>device specific thing that should be abstracted out here?
>>>>>>
>>>>>
>>>>>Sure, it is device specific, some synchronizing circuits would have this
>>>>>capability, while others would not.
>>>>>Should be abstracted out? It is a good question.. shall user know that he
>>>>>is in
>>>>>freerun with possibility to control the frequency or not?
>>>>>Let's say we remove NCO, and have dpll with enabled FREERUN mode and pins
>>>>>supporting multiple output frequencies.
>>>>>How the one would know if those frequencies are supported only in
>>>>>MANUAL/AUTOMATIC modes or also in the FREERUN mode?
>>>>>In other words: As the user can I change a frequency of a dpll if active
>>>>>mode is FREERUN?
>>>>
>>>>Okay, I think I'm deep in the DPLL infra you are pushing, but my
>>>>understanding that you can control frequency in NCO mode is not present
>>>>:/ That only means it may be confusing and not described properly.
>>>>How do you control this frequency exactly? I see no such knob.
>>>>
>>>
>>>The set frequency is there already, although we miss phase offset I guess.
>>
>>Yeah, but on a pin, right?
>>
>>
>
>Yes frequency of an output pin is configurable, phase offset for a dpll or
>output is not there, we might think of adding it..

But wait, we are talking about controllig freq of NCO, that has to be a
different knob. Anyway, it is dropped, so the discussion is poitless
now.



>
>>
>>>
>>>But I have changed my mind on having this in the kernel..
>>>Initially I have added this mode as our HW supports it, while thinking that
>>>dpll subsystem shall have this, and we will implement it one day..
>>>But as we have not implemented it yet, let's leave work and discussion on
>>>this mode for the future, when someone will actually try to implement it.
>>
>>Yeah, let's drop it then. One less confusing thing to wrap a head around :)
>>
>
>Dropped.
>
>Thank you!
>Arkadiusz
>
>>
>>>
>>>>Can't the oscilator be modeled as a pin and then you are not in freerun
>>>>but locked this "internal pin"? We know how to control frequency there.
>>>>
>>>
>>>Hmm, yeah probably could work this way.
>>>
>>>
>>>Thank you!
>>>Arkadiusz
>>>
>>>>
>>>>>
>>>>>I would say it is better to have such mode, we could argue on naming
>>>>>>though.
>>>>>
>>>>>>
>>>>>>>runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
>>>>>>>dividers before it reaches the output).
>>>>>>>It doesn't count as an source pin, it uses signal form dedicated wire for
>>>>>>>SYSTEM CLOCK.
>>>>>>>In this case control over output frequency is done by synchronizer chip
>>>>>>>firmware, but still it will not lock to any source pin signal.
>>>>>>>
>>>>>>>>> >+    render-max: true
>>>>>>>>> >+  -
>>>>>>>>> >+    type: enum
>>>>>>>>> >+    name: lock-status
>>>>>>>>> >+    doc: |
>>>>>>>>> >+      provides information of dpll device lock status, valid
>>>>>>>>> >>values for
>>>>>>>>> >+      DPLL_A_LOCK_STATUS attribute
>>>>>>>>> >+    entries:
>>>>>>>>> >+      -
>>>>>>>>> >+        name: unspec
>>>>>>>>> >+        doc: unspecified value
>>>>>>>>> >+      -
>>>>>>>>> >+        name: unlocked
>>>>>>>>> >+        doc: |
>>>>>>>>> >+          dpll was not yet locked to any valid source (or is in one
>>>>>>>>> >of
>>>>>>>>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>>>>>>>> >+      -
>>>>>>>>> >+        name: calibrating
>>>>>>>>> >+        doc: dpll is trying to lock to a valid signal
>>>>>>>>> >+      -
>>>>>>>>> >+        name: locked
>>>>>>>>> >+        doc: dpll is locked
>>>>>>>>> >+      -
>>>>>>>>> >+        name: holdover
>>>>>>>>> >+        doc: |
>>>>>>>>> >+          dpll is in holdover state - lost a valid lock or was
>>>>>>>>> >forced by
>>>>>>>>> >+          selecting DPLL_MODE_HOLDOVER mode
>>>>>>>>>
>>>>>>>>> Is it needed to mention the holdover mode. It's slightly confusing,
>>>>>>>>> because user might understand that the lock-status is always "holdover"
>>>>>>>>> in case of "holdover" mode. But it could be "unlocked", can't it?
>>>>>>>>> Perhaps I don't understand the flows there correctly :/
>>>>>>>>
>>>>>>>>Hm, if we want to make sure that holdover mode must result in holdover
>>>>>>>>state then we need some extra atomicity requirements on the SET
>>>>>>>>operation. To me it seems logical enough that after setting holdover
>>>>>>>>mode we'll end up either in holdover or unlocked status, depending on
>>>>>>>>lock status when request reached the HW.
>>>>>>>>
>>>>>>>
>>>>>>>Improved the docs:
>>>>>>>        name: holdover
>>>>>>>        doc: |
>>>>>>>          dpll is in holdover state - lost a valid lock or was forced
>>>>>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>>>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>>>>>	  if it was not, the dpll's lock-status will remain
>>>>>>
>>>>>>"if it was not" does not really cope with the sentence above that. Could
>>>>>>you iron-out the phrasing a bit please?
>>>>>
>>>>>
>>>>>Hmmm,
>>>>>        name: holdover
>>>>>        doc: |
>>>>>          dpll is in holdover state - lost a valid lock or was forced
>>>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>>>          if dpll lock-state was not DPLL_LOCK_STATUS_LOCKED, the
>>>>>          dpll's lock-state shall remain DPLL_LOCK_STATUS_UNLOCKED
>>>>>          even if DPLL_MODE_HOLDOVER was requested)
>>>>>
>>>>>Hope this is better?
>>>>
>>>>Okay.
>>>>
>>>>>
>>>>>
>>>>>Thank you!
>>>>>Arkadiusz
>>>>>
>>>>>[...]

