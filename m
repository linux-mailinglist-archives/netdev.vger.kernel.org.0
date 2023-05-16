Return-Path: <netdev+bounces-3021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 926847050DA
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A351C280FB1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9944B27712;
	Tue, 16 May 2023 14:33:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF2B34CD5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:33:41 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238C030DC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:33:37 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so7906607a12.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684247615; x=1686839615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+LK2OpAFas8P3MmZmqwSI9CreYUGyjnN2bl4gbEEJPE=;
        b=LOB613eVdoxppxmElUsDS9NLW72MvlmqIJ1rWlXnCjikMf7ujDA9v4ZeULFwZeLJj0
         kQICBSgRGXDrzZkDr/LfoeDSp1S6n4rfK9slpy6NWsXQoWPnIFiNDVP5lZQ9XwOGbIdZ
         FSsMlVh43XqnYSu4XJilR2ye8BSPBlnNLzJl84UG9cSMHx2qrR5yaD+hQjZ/sStdKzNE
         ExOvtv4IfUWD0gGNJGdq690lH0DzEXGzJohxDZv/1aGJk/kK9YZCWYEUBrjEb7JNV89P
         5ketniaPbYUKPLswVp96d51TBlL0oKIbAdxX+82vWyszg3RgjY4Yrhfd2RNb0fbcrS4D
         8wvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247615; x=1686839615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LK2OpAFas8P3MmZmqwSI9CreYUGyjnN2bl4gbEEJPE=;
        b=CD1bpwGzEW2MQTd9ngzfMxtOGQp0Yb9FMOMdIMN1GF9WQ5Dnp/BW9womS3rxv05iaF
         +ocqXH1sM70352KRvK9M1ppuwm0UU2PF0p+xVtW14X1wSKSjQypQoiPL9hYluWF4RMYe
         5L7JyzIVPtxKwn310rjLMSqpCii74cC70sYuAzKtrgM4gUhDsor6ISBBgqfh89P2zdn2
         Ql/SdHaxYAi8cGkhAifSWiENvyhgbGaF7XkiGgI5TvS7O2I5GLPL/1OA5Dzv8cvFFupX
         5hK1KHUdJqL7W9JdXQEqDEmWDQQ/0NA4HIPCp1T+eTniWLsEHEcWG3fwCVPdYrnVRWwL
         3/DA==
X-Gm-Message-State: AC+VfDzanTuHUMG6C3HA4JsPuab+BEWhkW9P1ffazqhw8W0SlwprsDYA
	/GPyMO3Gqv+wZaXigarvOm3Pyw==
X-Google-Smtp-Source: ACHHUZ5RjbCf8rDXcfvsTR7OhaJEnOnHYqYV1g3YaVX2C1PrNk9uJcx8rEsXXhpD/No4Aq0xGW5UqA==
X-Received: by 2002:a17:907:3209:b0:94e:4b26:233c with SMTP id xg9-20020a170907320900b0094e4b26233cmr32498469ejb.16.1684247615440;
        Tue, 16 May 2023 07:33:35 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id gz4-20020a170907a04400b009571293d6acsm10988779ejc.59.2023.05.16.07.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 07:33:34 -0700 (PDT)
Date: Tue, 16 May 2023 16:33:32 +0200
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
Message-ID: <ZGOUPCxCzVNuOrDZ@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com>
 <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
 <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <ZFygbd1H+VdvCTyH@nanopsycho>
 <DM6PR11MB4657924148B84F502A44903D9B749@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGH7uvxD55Pan0gf@nanopsycho>
 <DM6PR11MB4657670163F45823F66B28619B799@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657670163F45823F66B28619B799@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 16, 2023 at 02:05:38PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Monday, May 15, 2023 11:31 AM
>>
>>Thu, May 11, 2023 at 10:51:43PM CEST, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Thursday, May 11, 2023 10:00 AM
>>>>
>>>>Thu, May 11, 2023 at 09:40:26AM CEST, arkadiusz.kubalewski@intel.com wrote:
>>>>>>From: Jakub Kicinski <kuba@kernel.org>
>>>>>>Sent: Thursday, May 4, 2023 11:25 PM
>>>>>>
>>>>>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>>>>>>> >+definitions:
>>>>>>> >+  -
>>>>>>> >+    type: enum
>>>>>>> >+    name: mode
>>>>>>> >+    doc: |
>>>>>>> >+      working-modes a dpll can support, differentiate if and how dpll
>>>>>>>selects
>>>>>>> >+      one of its sources to syntonize with it, valid values for
>>>>>>>DPLL_A_MODE
>>>>>>> >+      attribute
>>>>>>> >+    entries:
>>>>>>> >+      -
>>>>>>> >+        name: unspec
>>>>>>>
>>>>>>> In general, why exactly do we need unspec values in enums and CMDs?
>>>>>>> What is the usecase. If there isn't please remove.
>>>>>>
>>>>>>+1
>>>>>>
>>>>>
>>>>>Sure, fixed.
>>>>>
>>>>>>> >+        doc: unspecified value
>>>>>>> >+      -
>>>>>>> >+        name: manual
>>>>>>
>>>>>>I think the documentation calls this "forced", still.
>>>>>>
>>>>>
>>>>>Yes, good catch, fixed docs.
>>>>>
>>>>>>> >+        doc: source can be only selected by sending a request to dpll
>>>>>>> >+      -
>>>>>>> >+        name: automatic
>>>>>>> >+        doc: highest prio, valid source, auto selected by dpll
>>>>>>> >+      -
>>>>>>> >+        name: holdover
>>>>>>> >+        doc: dpll forced into holdover mode
>>>>>>> >+      -
>>>>>>> >+        name: freerun
>>>>>>> >+        doc: dpll driven on system clk, no holdover available
>>>>>>>
>>>>>>> Remove "no holdover available". This is not a state, this is a mode
>>>>>>> configuration. If holdover is or isn't available, is a runtime info.
>>>>>>
>>>>>>Agreed, seems a little confusing now. Should we expose the system clk
>>>>>>as a pin to be able to force lock to it? Or there's some extra magic
>>>>>>at play here?
>>>>>
>>>>>In freerun you cannot lock to anything it, it just uses system clock from
>>>>>one of designated chip wires (which is not a part of source pins pool) to
>>>>>feed the dpll. Dpll would only stabilize that signal and pass it further.
>>>>>Locking itself is some kind of magic, as it usually takes at least ~15
>>>>>seconds before it locks to a signal once it is selected.
>>>>>
>>>>>>
>>>>>>> >+      -
>>>>>>> >+        name: nco
>>>>>>> >+        doc: dpll driven by Numerically Controlled Oscillator
>>>>>>
>>>>>>Noob question, what is NCO in terms of implementation?
>>>>>>We source the signal from an arbitrary pin and FW / driver does
>>>>>>the control? Or we always use system refclk and then tune?
>>>>>>
>>>>>
>>>>>Documentation of chip we are using, stated NCO as similar to FREERUN, and
>>>>>it
>>>>
>>>>So how exactly this is different to freerun? Does user care or he would
>>>>be fine with "freerun" in this case? My point is, isn't "NCO" some
>>>>device specific thing that should be abstracted out here?
>>>>
>>>
>>>Sure, it is device specific, some synchronizing circuits would have this
>>>capability, while others would not.
>>>Should be abstracted out? It is a good question.. shall user know that he is
>>>in
>>>freerun with possibility to control the frequency or not?
>>>Let's say we remove NCO, and have dpll with enabled FREERUN mode and pins
>>>supporting multiple output frequencies.
>>>How the one would know if those frequencies are supported only in
>>>MANUAL/AUTOMATIC modes or also in the FREERUN mode?
>>>In other words: As the user can I change a frequency of a dpll if active
>>>mode is FREERUN?
>>
>>Okay, I think I'm deep in the DPLL infra you are pushing, but my
>>understanding that you can control frequency in NCO mode is not present
>>:/ That only means it may be confusing and not described properly.
>>How do you control this frequency exactly? I see no such knob.
>>
>
>The set frequency is there already, although we miss phase offset I guess.

Yeah, but on a pin, right?



>
>But I have changed my mind on having this in the kernel..
>Initially I have added this mode as our HW supports it, while thinking that
>dpll subsystem shall have this, and we will implement it one day..
>But as we have not implemented it yet, let's leave work and discussion on
>this mode for the future, when someone will actually try to implement it.

Yeah, let's drop it then. One less confusing thing to wrap a head around :)


>
>>Can't the oscilator be modeled as a pin and then you are not in freerun
>>but locked this "internal pin"? We know how to control frequency there.
>>
>
>Hmm, yeah probably could work this way.
>
>
>Thank you!
>Arkadiusz
>
>>
>>>
>>>I would say it is better to have such mode, we could argue on naming though.
>>>
>>>>
>>>>>runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
>>>>>dividers before it reaches the output).
>>>>>It doesn't count as an source pin, it uses signal form dedicated wire for
>>>>>SYSTEM CLOCK.
>>>>>In this case control over output frequency is done by synchronizer chip
>>>>>firmware, but still it will not lock to any source pin signal.
>>>>>
>>>>>>> >+    render-max: true
>>>>>>> >+  -
>>>>>>> >+    type: enum
>>>>>>> >+    name: lock-status
>>>>>>> >+    doc: |
>>>>>>> >+      provides information of dpll device lock status, valid values for
>>>>>>> >+      DPLL_A_LOCK_STATUS attribute
>>>>>>> >+    entries:
>>>>>>> >+      -
>>>>>>> >+        name: unspec
>>>>>>> >+        doc: unspecified value
>>>>>>> >+      -
>>>>>>> >+        name: unlocked
>>>>>>> >+        doc: |
>>>>>>> >+          dpll was not yet locked to any valid source (or is in one of
>>>>>>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>>>>>> >+      -
>>>>>>> >+        name: calibrating
>>>>>>> >+        doc: dpll is trying to lock to a valid signal
>>>>>>> >+      -
>>>>>>> >+        name: locked
>>>>>>> >+        doc: dpll is locked
>>>>>>> >+      -
>>>>>>> >+        name: holdover
>>>>>>> >+        doc: |
>>>>>>> >+          dpll is in holdover state - lost a valid lock or was forced by
>>>>>>> >+          selecting DPLL_MODE_HOLDOVER mode
>>>>>>>
>>>>>>> Is it needed to mention the holdover mode. It's slightly confusing,
>>>>>>> because user might understand that the lock-status is always "holdover"
>>>>>>> in case of "holdover" mode. But it could be "unlocked", can't it?
>>>>>>> Perhaps I don't understand the flows there correctly :/
>>>>>>
>>>>>>Hm, if we want to make sure that holdover mode must result in holdover
>>>>>>state then we need some extra atomicity requirements on the SET
>>>>>>operation. To me it seems logical enough that after setting holdover
>>>>>>mode we'll end up either in holdover or unlocked status, depending on
>>>>>>lock status when request reached the HW.
>>>>>>
>>>>>
>>>>>Improved the docs:
>>>>>        name: holdover
>>>>>        doc: |
>>>>>          dpll is in holdover state - lost a valid lock or was forced
>>>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>>>	  if it was not, the dpll's lock-status will remain
>>>>
>>>>"if it was not" does not really cope with the sentence above that. Could
>>>>you iron-out the phrasing a bit please?
>>>
>>>
>>>Hmmm,
>>>        name: holdover
>>>        doc: |
>>>          dpll is in holdover state - lost a valid lock or was forced
>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>          if dpll lock-state was not DPLL_LOCK_STATUS_LOCKED, the
>>>          dpll's lock-state shall remain DPLL_LOCK_STATUS_UNLOCKED
>>>          even if DPLL_MODE_HOLDOVER was requested)
>>>
>>>Hope this is better?
>>
>>Okay.
>>
>>>
>>>
>>>Thank you!
>>>Arkadiusz
>>>
>>>[...]

