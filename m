Return-Path: <netdev+bounces-1691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 386B96FED57
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE6742815DC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F061B903;
	Thu, 11 May 2023 07:59:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75921B8E2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:59:52 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E3C2D5B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:59:44 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-959a3e2dd27so1464603766b.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683791982; x=1686383982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ve1AsxWOY8XkHeL1xhVZQ8hlEzSI4wGJ8N3UWAx19ow=;
        b=rbW/ekvEJlXOt0JHPV/hdaRMMA3Lr6N9AanQN1RTcNc8vnM9or4tsgzktJdzQROdIs
         69sk2EkBM3iwV2jMzXVJS02KTL2PX3QUmJEbPr2HcIJVkpXbQ4oaxpM2gIJH8miuES3F
         z4NMBMMotSG8C4V1ChMcte8jzrIpCmiJXRJ7VSoJ3jGy3BbWPxXzbx25p06zwI1V23mY
         7/tx7JKE3B+yE8IrOZumni8l+lD+D2YopQUn7GYhiF7B1FcSGl3i7dd2+0Jb9LmBpEIC
         EzSMEY/0XdCHDH8CGpYSsWHAel1pp52SHJzTDqDaw19SBs/f4WlSj3QBuwE5noMaU+YB
         sYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683791982; x=1686383982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ve1AsxWOY8XkHeL1xhVZQ8hlEzSI4wGJ8N3UWAx19ow=;
        b=WCQk+3zQKaFq9RWig0PdJSc/hLhfKw4kxfXoeWLAWiXbaMifJl7G4wMueX9j8Y/8KI
         hE7Hn12jgCV9ZX4Tdzz7a3p878cst+wcojkHpmsBXSn5nu2J4CSrY6cyzarYtGkJDVXj
         TyIlLfRIMh5HCXbkgUqLnDIPAfUQw/O7Vqi88BQj6RUhC8Lh3vv9BE31D2XKyWJ04Frg
         SMUzfskRyKBzoIOLbNEtludqtowHtYmpX8PIuHNyKpgD4qxt5RWa3QFj2Fx+zNVzIsUK
         4eQwqxDUq1Pi0ZHgqi06nYJ5l06orBBkKKsiMuHUMyrkigR/rgZdLm3RFJTLNpdtWXam
         Awyg==
X-Gm-Message-State: AC+VfDx1VMukKocsFrHSimmMInlOtcRxnb6uNy659S3ALHUf18+lu7m6
	1vAtzuEgNIY5Ir5TZOyPWNaxVg==
X-Google-Smtp-Source: ACHHUZ7IRkUG4hUD6SnmhMkyDtumYl+gTlLFaLHd3ObzeeO0ddq7vSKhAf3/TPBj/nJ4ZS0LUhSizQ==
X-Received: by 2002:a17:907:8a29:b0:965:f8b7:b0cd with SMTP id sc41-20020a1709078a2900b00965f8b7b0cdmr24583697ejc.25.1683791982562;
        Thu, 11 May 2023 00:59:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id og16-20020a1709071dd000b0096637a19dcasm3653875ejc.4.2023.05.11.00.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 00:59:42 -0700 (PDT)
Date: Thu, 11 May 2023 09:59:41 +0200
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
Message-ID: <ZFygbd1H+VdvCTyH@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com>
 <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
 <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 11, 2023 at 09:40:26AM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jakub Kicinski <kuba@kernel.org>
>>Sent: Thursday, May 4, 2023 11:25 PM
>>
>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>>> >+definitions:
>>> >+  -
>>> >+    type: enum
>>> >+    name: mode
>>> >+    doc: |
>>> >+      working-modes a dpll can support, differentiate if and how dpll
>>>selects
>>> >+      one of its sources to syntonize with it, valid values for
>>>DPLL_A_MODE
>>> >+      attribute
>>> >+    entries:
>>> >+      -
>>> >+        name: unspec
>>>
>>> In general, why exactly do we need unspec values in enums and CMDs?
>>> What is the usecase. If there isn't please remove.
>>
>>+1
>>
>
>Sure, fixed.
>
>>> >+        doc: unspecified value
>>> >+      -
>>> >+        name: manual
>>
>>I think the documentation calls this "forced", still.
>>
>
>Yes, good catch, fixed docs.
>
>>> >+        doc: source can be only selected by sending a request to dpll
>>> >+      -
>>> >+        name: automatic
>>> >+        doc: highest prio, valid source, auto selected by dpll
>>> >+      -
>>> >+        name: holdover
>>> >+        doc: dpll forced into holdover mode
>>> >+      -
>>> >+        name: freerun
>>> >+        doc: dpll driven on system clk, no holdover available
>>>
>>> Remove "no holdover available". This is not a state, this is a mode
>>> configuration. If holdover is or isn't available, is a runtime info.
>>
>>Agreed, seems a little confusing now. Should we expose the system clk
>>as a pin to be able to force lock to it? Or there's some extra magic
>>at play here?
>
>In freerun you cannot lock to anything it, it just uses system clock from
>one of designated chip wires (which is not a part of source pins pool) to feed
>the dpll. Dpll would only stabilize that signal and pass it further.
>Locking itself is some kind of magic, as it usually takes at least ~15 seconds
>before it locks to a signal once it is selected.
>
>>
>>> >+      -
>>> >+        name: nco
>>> >+        doc: dpll driven by Numerically Controlled Oscillator
>>
>>Noob question, what is NCO in terms of implementation?
>>We source the signal from an arbitrary pin and FW / driver does
>>the control? Or we always use system refclk and then tune?
>>
>
>Documentation of chip we are using, stated NCO as similar to FREERUN, and it

So how exactly this is different to freerun? Does user care or he would
be fine with "freerun" in this case? My point is, isn't "NCO" some
device specific thing that should be abstracted out here?


>runs on a SYSTEM CLOCK provided to the chip (plus some stabilization and
>dividers before it reaches the output).
>It doesn't count as an source pin, it uses signal form dedicated wire for
>SYSTEM CLOCK.
>In this case control over output frequency is done by synchronizer chip
>firmware, but still it will not lock to any source pin signal.
>
>>> >+    render-max: true
>>> >+  -
>>> >+    type: enum
>>> >+    name: lock-status
>>> >+    doc: |
>>> >+      provides information of dpll device lock status, valid values for
>>> >+      DPLL_A_LOCK_STATUS attribute
>>> >+    entries:
>>> >+      -
>>> >+        name: unspec
>>> >+        doc: unspecified value
>>> >+      -
>>> >+        name: unlocked
>>> >+        doc: |
>>> >+          dpll was not yet locked to any valid source (or is in one of
>>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>> >+      -
>>> >+        name: calibrating
>>> >+        doc: dpll is trying to lock to a valid signal
>>> >+      -
>>> >+        name: locked
>>> >+        doc: dpll is locked
>>> >+      -
>>> >+        name: holdover
>>> >+        doc: |
>>> >+          dpll is in holdover state - lost a valid lock or was forced by
>>> >+          selecting DPLL_MODE_HOLDOVER mode
>>>
>>> Is it needed to mention the holdover mode. It's slightly confusing,
>>> because user might understand that the lock-status is always "holdover"
>>> in case of "holdover" mode. But it could be "unlocked", can't it?
>>> Perhaps I don't understand the flows there correctly :/
>>
>>Hm, if we want to make sure that holdover mode must result in holdover
>>state then we need some extra atomicity requirements on the SET
>>operation. To me it seems logical enough that after setting holdover
>>mode we'll end up either in holdover or unlocked status, depending on
>>lock status when request reached the HW.
>>
>
>Improved the docs:
>        name: holdover
>        doc: |
>          dpll is in holdover state - lost a valid lock or was forced
>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>	  if it was not, the dpll's lock-status will remain

"if it was not" does not really cope with the sentence above that. Could
you iron-out the phrasing a bit please?


>          DPLL_LOCK_STATUS_UNLOCKED even if user requests
>          DPLL_MODE_HOLDOVER)
>Is that better?
>
>What extra atomicity you have on your mind?
>Do you suggest to validate and allow (in dpll_netlink.c) only for 'unlocked'
>or 'holdover' states of dpll, once DPLL_MODE_HOLDOVER was successfully
>requested by the user?
>
>>> >+    render-max: true
>>> >+  -
>>> >+    type: const
>>> >+    name: temp-divider
>>> >+    value: 10
>>> >+    doc: |
>>> >+      temperature divider allowing userspace to calculate the
>>> >+      temperature as float with single digit precision.
>>> >+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
>>> >+      tempearture value.
>>>
>>> s/tempearture/temperature/
>>>
>>> Didn't checkpatch warn you?
>>
>>Also can we give it a more healthy engineering margin?
>>DPLL_A_TEMP is u32, silicon melts at around 1400C,
>>so we really can afford to make the divisor 1000.
>>
>
>Sure, fixed.
>
>>> >+    name: device
>>> >+    subset-of: dpll
>>> >+    attributes:
>>> >+      -
>>> >+        name: id
>>> >+        type: u32
>>> >+        value: 2
>>> >+      -
>>> >+        name: dev-name
>>> >+        type: string
>>> >+      -
>>> >+        name: bus-name
>>> >+        type: string
>>> >+      -
>>> >+        name: mode
>>> >+        type: u8
>>> >+        enum: mode
>>> >+      -
>>> >+        name: mode-supported
>>> >+        type: u8
>>> >+        enum: mode
>>> >+        multi-attr: true
>>> >+      -
>>> >+        name: lock-status
>>> >+        type: u8
>>> >+        enum: lock-status
>>> >+      -
>>> >+        name: temp
>>> >+        type: s32
>>> >+      -
>>> >+        name: clock-id
>>> >+        type: u64
>>> >+      -
>>> >+        name: type
>>> >+        type: u8
>>> >+        enum: type
>>> >+      -
>>> >+        name: pin-prio
>>> >+        type: u32
>>> >+        value: 19
>>>
>>> Do you still need to pass values for a subset? That is odd. Well, I
>>> think is is odd to pass anything other than names in subset definition,
>>> the rest of the info is in the original attribute set definition,
>>> isn't it?
>>> Jakub?
>>
>>Probably stale code, related bug was fixed in YNL a few months back.
>>Explicit value should no longer be needed.
>
>Yes, checked it works without them, I am removing values for next version.
>
>Thanks!
>Arkadiusz

