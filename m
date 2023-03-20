Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A726C0BD0
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 09:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCTILB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 04:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCTIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 04:10:59 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA7B18168
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 01:10:53 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d17so991208wrb.11
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 01:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679299851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9QaCCr5qOD+a1NrjFAQNpaZDwnLW2R0U0UJg4O231ZA=;
        b=Zzl0XwjfSGnfXNcCgNwd6zwQBbTIqV9nGyyFqAhwEPqp5lUK1mNo0G9akBTmsUTY1M
         ul7XMtjFX7o4uGRldrro53RMfhNU48J3S4tV74Guw6oDCSGsL7oXTJmApgg6nNmDq6Mm
         BaNfNESxdJddurQhSOTpWZH+UuiTZs9rf2PbkztKIKHmfkG96bqcXWJHX/rzvoRbx9BG
         BH077yVJ7waUBwNwN+2OrSEBm/ApothC74zDvfjojgSwgUXG8xTmFyA11EE4eyZeHnRB
         niHJJYQB4ZRysEh85LaYlvRPgss7EBQbRGrdMhPvsugzpczVFfmssVIrFA8O4+/60pyM
         JdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679299851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QaCCr5qOD+a1NrjFAQNpaZDwnLW2R0U0UJg4O231ZA=;
        b=iXP75Yy3hEX0VZtCECKoGK7MR4IX2FBbP5X/X/E/LDrkB23U1RmqBXF7po6QCzSq9v
         n4Pgqb3m/CIQJ7/EwYSgBxkQNsoW7ZgS/FWOWNHM7hNla2MiAY1eZ61kD5aXEN/VY69V
         6d/kkSOpIeHhMwyt/skOOnqeQ3u8++We0XDz3lmJIbGdXdvvK0foNGFk/G7doO0sWQVj
         R5a0LmgihNCmx76wQIYLUvxYxppbVgU1W4wcEY4DBKE/7yaK4HeFJOVnRATDzDDxg3uf
         igfFybb4AbxHM4qroO7OOXFD0ZyGflLzzHiUpebahQEsSrzINTdzPEvHlsDMFsITKtG5
         M1Yw==
X-Gm-Message-State: AO0yUKVHstqQkv0Ui14sAbDPcfHtDSXzaqEYuprEXCkJ8mxny6Rcxfib
        UiekMijaKq5YzTmPgU+ThUrazQ==
X-Google-Smtp-Source: AK7set/VddU3lyc4scA3tkqtYGHDB1K/9ha2QKq1BwZRfr4yK3oEtr1qukKvqAKFkyZHb9lrB+Djgw==
X-Received: by 2002:adf:eb4c:0:b0:2d7:452f:79ec with SMTP id u12-20020adfeb4c000000b002d7452f79ecmr1376104wrn.7.1679299851386;
        Mon, 20 Mar 2023 01:10:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y16-20020a056000109000b002c56013c07fsm8195105wrw.109.2023.03.20.01.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 01:10:50 -0700 (PDT)
Date:   Mon, 20 Mar 2023 09:10:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBgVCaUgcZMmZBw4@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
 <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
 <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBQ7ZuJSXRfFOy1b@nanopsycho>
 <DM6PR11MB4657F48649CFEB92D28D4ED49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBSTUB7q8EsfhHSL@nanopsycho>
 <DM6PR11MB465709F2E30586AFCCE1461E9BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB465709F2E30586AFCCE1461E9BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 17, 2023 at 07:22:46PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Friday, March 17, 2023 5:21 PM
>>
>>Fri, Mar 17, 2023 at 04:14:45PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Friday, March 17, 2023 11:05 AM
>>>>
>>>>Fri, Mar 17, 2023 at 01:52:44AM CET, arkadiusz.kubalewski@intel.com
>>>>wrote:
>>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>>Sent: Thursday, March 16, 2023 2:45 PM
>>>>>>
>>>>>
>>>>>[...]
>>>>>
>>>>>>>>>+attribute-sets:
>>>>>>>>>+  -
>>>>>>>>>+    name: dpll
>>>>>>>>>+    enum-name: dplla
>>>>>>>>>+    attributes:
>>>>>>>>>+      -
>>>>>>>>>+        name: device
>>>>>>>>>+        type: nest
>>>>>>>>>+        value: 1
>>>>>>>>>+        multi-attr: true
>>>>>>>>>+        nested-attributes: device
>>>>>>>>
>>>>>>>>What is this "device" and what is it good for? Smells like some
>>>>>>>>leftover
>>>>>>>>and with the nested scheme looks quite odd.
>>>>>>>>
>>>>>>>
>>>>>>>No, it is nested attribute type, used when multiple devices are returned
>>>>>>>with netlink:
>>>>>>>
>>>>>>>- dump of device-get command where all devices are returned, each one
>>>>>>>nested
>>>>>>>inside it:
>>>>>>>[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id':0},
>>>>>>>             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id':1}]}]
>>>>>>
>>>>>>Okay, why is it nested here? The is one netlink msg per dpll device
>>>>>>instance. Is this the real output of you made that up?
>>>>>>
>>>>>>Device nest should not be there for DEVICE_GET, does not make sense.
>>>>>>
>>>>>
>>>>>This was returned by CLI parser on ice with cmd:
>>>>>$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
>>>>>--dump device-get
>>>>>
>>>>>Please note this relates to 'dump' request , it is rather expected that
>>>>there
>>>>>are multiple dplls returned, thus we need a nest attribute for each one.
>>>>
>>>>No, you definitelly don't need to nest them. Dump format and get format
>>>>should be exactly the same. Please remove the nest.
>>>>
>>>>See how that is done in devlink for example: devlink_nl_fill()
>>>>This functions fills up one object in the dump. No nesting.
>>>>I'm not aware of such nesting approach anywhere in kernel dumps, does
>>>>not make sense at all.
>>>>
>>>
>>>Yeah it make sense to have same output on `do` and `dump`, but this is also
>>>achievable with nest DPLL_A_DEVICE, still don't need put extra header for it.
>>>The difference would be that on `dump` multiple DPLL_A_DEVICE are provided,
>>>on `do` only one.
>>
>>Please don't. This root nesting is not correct.
>>
>>
>>>
>>>Will try to fix it.
>>>Although could you please explain why it make sense to put extra header
>>>(exactly the same header) multiple times in one netlink response message?
>>
>>This is how it's done for all netlink dumps as far as I know.
>
>So we just following something but we cannot explain why?

I thought it is obvious. With what you suggest, each generic netlink
user would have to have all commands that implement both do and dump
with message format of a root nest. Not only that, for the sake of
consistency, all the rest of the commands would have to implement same
root nesting format. Both ways, to and from kernel.
So no matter what, all the messages would look like:

CMD_X MSG:
  SUBSYS_ATTR_ROOT
    SUBSYS_ATTR_1
    SUBSYS_ATTR_2
    ***
    SUBSYS_ATTR_N

What I say, this extra level of nesting is not needed and in fact it is
not good for anything. Remove it and just have:

CMD_X MSG:
  SUBSYS_ATTR_1
  SUBSYS_ATTR_2
  ***
  SUBSYS_ATTR_N

Clear and simple. For dump, you repeat the header, I don't see why that
is problem. All implementations are doing that, all userspace apps are
used to it. It is simple and consistent even if you consider multiple
skbs used for dump. I'm lacking to understand your need to reinvent
the wheel here.



>
>>The reason might be that the userspace is parsing exactly the same
>>message as if it would be DOIT message.
>>
>
>This argument is achievable on both approaches.
>
>[...]
>
>
>>>>>>>>
>>>>>>>>Hmm, shouldn't source-pin-index be here as well?
>>>>>>>
>>>>>>>No, there is no set for this.
>>>>>>>For manual mode user selects the pin by setting enabled state on the
>>one
>>>>>>>he needs to recover signal from.
>>>>>>>
>>>>>>>source-pin-index is read only, returns active source.
>>>>>>
>>>>>>Okay, got it. Then why do we have this assymetric approach? Just have
>>>>>>the enabled state to serve the user to see which one is selected, no?
>>>>>>This would help to avoid confusion (like mine) and allow not to create
>>>>>>inconsistencies (like no pin enabled yet driver to return some source
>>>>>>pin index)
>>>>>>
>>>>>
>>>>>This is due to automatic mode were multiple pins are enabled, but actual
>>>>>selection is done on hardware level with priorities.
>>>>
>>>>Okay, this is confusing and I believe wrong.
>>>>You have dual meaning for pin state attribute with states
>>>>STATE_CONNECTED/DISCONNECTED:
>>>>
>>>>1) Manual mode, MUX pins (both share the same model):
>>>>   There is only one pin with STATE_CONNECTED. The others are in
>>>>   STATE_DISCONNECTED
>>>>   User changes a state of a pin to make the selection.
>>>>
>>>>   Example:
>>>>     $ dplltool pin dump
>>>>       pin 1 state connected
>>>>       pin 2 state disconnected
>>>>     $ dplltool pin 2 set state connected
>>>>     $ dplltool pin dump
>>>>       pin 1 state disconnected
>>>>       pin 2 state connected
>>>>
>>>>2) Automatic mode:
>>>>   The user by setting "state" decides it the pin should be considered
>>>>   by the device for auto selection.
>>>>
>>>>   Example:
>>>>     $ dplltool pin dump:
>>>>       pin 1 state connected prio 10
>>>>       pin 2 state connected prio 15
>>>>     $ dplltool dpll x get:
>>>>       dpll x source-pin-index 1
>>>>
>>>>So in manual mode, STATE_CONNECTED means the dpll is connected to this
>>>>source pin. However, in automatic mode it means something else. It means
>>>>the user allows this pin to be considered for auto selection. The fact
>>>>the pin is selected source is exposed over source-pin-index.
>>>>
>>>>Instead of this, I believe that the semantics of
>>>>STATE_CONNECTED/DISCONNECTED should be the same for automatic mode as
>>>>well. Unlike the manual mode/mux, where the state is written by user, in
>>>>automatic mode the state should be only written by the driver. User
>>>>attemts to set the state should fail with graceful explanation (DPLL
>>>>netlink/core code should handle that, w/o driver interaction)
>>>>
>>>>Suggested automatic mode example:
>>>>     $ dplltool pin dump:
>>>>       pin 1 state connected prio 10 connectable true
>>>>       pin 2 state disconnected prio 15 connectable true
>>>>     $ dplltool pin 1 set connectable false
>>>>     $ dplltool pin dump:
>>>>       pin 1 state disconnected prio 10 connectable false
>>>>       pin 2 state connected prio 15 connectable true
>>>>     $ dplltool pin 1 set state connected
>>>>       -EOPNOTSUPP
>>>>
>>>>Note there is no "source-pin-index" at all. Replaced by pin state here.
>>>>There is a new attribute called "connectable", the user uses this
>>>>attribute to tell the device, if this source pin could be considered for
>>>>auto selection or not.
>>>>
>>>>Could be called perhaps "selectable", does not matter. The point is, the
>>>>meaning of the "state" attribute is consistent for automatic mode,
>>>>manual mode and mux pin.
>>>>
>>>>Makes sense?
>>>>
>>>
>>>Great idea!
>>>I will add third enum for pin-state: DPLL_PIN_STATE_SELECTABLE.
>>>In the end we will have this:
>>>              +--------------------------------+
>>>              | valid DPLL_A_PIN_STATE values  |
>>>	      +---------------+----------------+
>>>+------------+| requested:    | returned:      |
>>>|DPLL_A_MODE:||               |                |
>>>|------------++--------------------------------|
>>>|AUTOMATIC   ||- SELECTABLE   | - SELECTABLE   |
>>>|            ||- DISCONNECTED | - DISCONNECTED |
>>>|            ||               | - CONNECTED    |
>>
>>"selectable" is something the user sets.
>
>Yes.
>
>>"connected"/"disconnected" is in case of auto mode something that driver
>>sets.
>>
>
>No. Not really.
>"CONNECTED" is only set by driver once a pin is choosen.
>"SELECTABLE" is set by the user if he needs to enable a pin for selection,
>it is also default state of a pin if it was not selected ("CONNECTED")
>"DISCONNECTED" is set by the user if he needs to disable a pin from selection.

Sure.


>
>>Looks a bit odd to mix them together. That is why I suggested
>>to have sepectable as a separate attr. But up to you. Please make sure
>>you sanitize the user/driver set of this attr in dpll code.
>>
>
>What is odd?

To mix them together in a single attr. But I'm fine with that.


>What do you mean by "sanitize the user/driver set of this attr in dpll code"?

What I mean is that in each mode there has to be clearly documented
which entity changes state, how and under which circumstance. This
behaviour needs to be enforced in the dpll code.


>
>
>Thank you,
>Arkadiusz
>
>>
>>>|------------++--------------------------------|
>>>|MANUAL      ||- CONNECTED    | - CONNECTED    |
>>>|            ||- DISCONNECTED | - DISCONNECTED |
>>>+------------++---------------+----------------+
>>>
>>>Thank you,
>>>Arkadiusz
>>>
>>>>
>>>>>
>>>>>[...]
>>>>>
>>>>>>>>>+
>>>>>>>>>+/* DPLL_CMD_DEVICE_SET - do */
>>>>>>>>>+static const struct nla_policy
>>dpll_device_set_nl_policy[DPLL_A_MODE +
>>>>>>>>>1]
>>>>>>>>>= {
>>>>>>>>>+	[DPLL_A_ID] = { .type = NLA_U32, },
>>>>>>>>>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>>>>>>>>>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>>>>>>>>>+	[DPLL_A_MODE] = NLA_POLICY_MAX(NLA_U8, 5),
>>>>>>>>
>>>>>>>>Hmm, any idea why the generator does not put define name
>>>>>>>>here instead of "5"?
>>>>>>>>
>>>>>>>
>>>>>>>Not really, it probably needs a fix for this.
>>>>>>
>>>>>>Yeah.
>>>>>>
>>>>>
>>>>>Well, once we done with review maybe we could also fix those, or ask
>>>>>Jakub if he could help :)
>>>>>
>>>>>
>>>>>[...]
>>>>>
>>>>>>>>
>>>>>>>>>+	DPLL_A_PIN_PRIO,
>>>>>>>>>+	DPLL_A_PIN_STATE,
>>>>>>>>>+	DPLL_A_PIN_PARENT,
>>>>>>>>>+	DPLL_A_PIN_PARENT_IDX,
>>>>>>>>>+	DPLL_A_PIN_RCLK_DEVICE,
>>>>>>>>>+	DPLL_A_PIN_DPLL_CAPS,
>>>>>>>>
>>>>>>>>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
>>>>>>>>enum name.
>>>>>>>
>>>>>>>Sure, fixed.
>>>>>>
>>>>>>
>>>>>>Thanks for all your work on this!
>>>>>
>>>>>Thanks for a great review! :)
>>>>
>>>>Glad to help.
