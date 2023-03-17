Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2BA6BEDEF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCQQUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjCQQUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:20:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B5619F0A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:20:35 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id x22so3705664wmj.3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679070034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uj0Ji6SFEFiCTyrUHIikvucoF3n2iEqieGmTbLBoFA8=;
        b=sOp3zKdFj5j9+TFF3ggiHVQVFy6gqmTvV7SJY+e9EbYDjE4coZR+mgcwfWQA2UYdNg
         L+nfRxJAMsD22HC25FTMODyXqAXXq2U4Wxi7l9cdchg2wlXbpj8KnuZc0EiWJjjNs9q2
         Qzn5JoitVtYibiZKSdU/6UA/L0cdD0k6t4uY1Tl4rjZIoSaFtRCjP/aGhn+j6z/A8zcv
         czJleQUgiEp4uE5BquvsoMLGW9cBPL/lWd6LcDwFTBn+fcXhtaPyz9rlssjcbR2x8jxH
         5ib1cY/gi6lk61brZmnOMvPSVuC/WzHrkYgebDTL7D2U3xqjsogRNOYbfAOF8R14On2w
         B96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uj0Ji6SFEFiCTyrUHIikvucoF3n2iEqieGmTbLBoFA8=;
        b=JPXW+LCK14jvIQndh0ijD61091O9E9wB9bSuQjZzKSpLQseHBe1+Ep6ENAVMGRP0eV
         R/l58EB8TCB9WAlgpsUVmtVE+YsNV/hch8zsTWvQyXhryVk1771LLnPqydztQQb8wX5E
         xR1DWK15l6r10arti7IIwhJ/oTmVKbtsyp+qcqQofOZNaiFzOavA20zjuNSbSC9Cpp6P
         6cQpqabnKa7LQRM5gquBaMZTklH/ghwmd/N4+bPRcUhU8ht8JClqGmOKN9J+b7BrDyDS
         80R/3CvLcC/jqBs4jrre0BuIa9P0ZHztGJeSZBClNu57BVCKgHcRp6feZwjF5ip4rWY/
         bhvw==
X-Gm-Message-State: AO0yUKUFuIdxOChTU6W8uR8mVejcoOh+7bWdKO6UidnU3ecs1oZ8uLJ9
        FvGDQcUEhswBswy4vCKiHgOkNA==
X-Google-Smtp-Source: AK7set/OEvIQP1BQE8TqinNJ1p3pSfBIgtO8Er1/19efauPxMWuWOhIuQAh6Q4B/EgKEIDKGMCnAPQ==
X-Received: by 2002:a05:600c:4709:b0:3eb:3998:36f1 with SMTP id v9-20020a05600c470900b003eb399836f1mr26447870wmo.41.1679070034205;
        Fri, 17 Mar 2023 09:20:34 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k22-20020a05600c0b5600b003ed2987690dsm2407566wmr.26.2023.03.17.09.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 09:20:33 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:20:32 +0100
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
Message-ID: <ZBSTUB7q8EsfhHSL@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
 <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
 <DM6PR11MB465709625C2C391D470C33F49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBQ7ZuJSXRfFOy1b@nanopsycho>
 <DM6PR11MB4657F48649CFEB92D28D4ED49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657F48649CFEB92D28D4ED49BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 17, 2023 at 04:14:45PM CET, arkadiusz.kubalewski@intel.com wrote:
>
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Friday, March 17, 2023 11:05 AM
>>
>>Fri, Mar 17, 2023 at 01:52:44AM CET, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Thursday, March 16, 2023 2:45 PM
>>>>
>>>
>>>[...]
>>>
>>>>>>>+attribute-sets:
>>>>>>>+  -
>>>>>>>+    name: dpll
>>>>>>>+    enum-name: dplla
>>>>>>>+    attributes:
>>>>>>>+      -
>>>>>>>+        name: device
>>>>>>>+        type: nest
>>>>>>>+        value: 1
>>>>>>>+        multi-attr: true
>>>>>>>+        nested-attributes: device
>>>>>>
>>>>>>What is this "device" and what is it good for? Smells like some leftover
>>>>>>and with the nested scheme looks quite odd.
>>>>>>
>>>>>
>>>>>No, it is nested attribute type, used when multiple devices are returned
>>>>>with netlink:
>>>>>
>>>>>- dump of device-get command where all devices are returned, each one
>>>>>nested
>>>>>inside it:
>>>>>[{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0', 'id': 0},
>>>>>             {'bus-name': 'pci', 'dev-name': '0000:21:00.0_1', 'id':
>>>>>1}]}]
>>>>
>>>>Okay, why is it nested here? The is one netlink msg per dpll device
>>>>instance. Is this the real output of you made that up?
>>>>
>>>>Device nest should not be there for DEVICE_GET, does not make sense.
>>>>
>>>
>>>This was returned by CLI parser on ice with cmd:
>>>$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml /
>>>--dump device-get
>>>
>>>Please note this relates to 'dump' request , it is rather expected that
>>there
>>>are multiple dplls returned, thus we need a nest attribute for each one.
>>
>>No, you definitelly don't need to nest them. Dump format and get format
>>should be exactly the same. Please remove the nest.
>>
>>See how that is done in devlink for example: devlink_nl_fill()
>>This functions fills up one object in the dump. No nesting.
>>I'm not aware of such nesting approach anywhere in kernel dumps, does
>>not make sense at all.
>>
>
>Yeah it make sense to have same output on `do` and `dump`, but this is also
>achievable with nest DPLL_A_DEVICE, still don't need put extra header for it.
>The difference would be that on `dump` multiple DPLL_A_DEVICE are provided,
>on `do` only one.

Please don't. This root nesting is not correct.


>
>Will try to fix it.
>Although could you please explain why it make sense to put extra header
>(exactly the same header) multiple times in one netlink response message? 

This is how it's done for all netlink dumps as far as I know.
The reason might be that the userspace is parsing exactly the same
message as if it would be DOIT message.


>
>>
>>>
>>>>
>>>>>
>>>>>- do/dump of pin-get, in case of shared pins, each pin contains number
>>of
>>>>dpll
>>>>>handles it connects with:
>>>>>[{'pin': [{'device': [{'bus-name': 'pci',
>>>>>                       'dev-name': '0000:21:00.0_0',
>>>>>                       'id': 0,
>>>>>                       'pin-prio': 6,
>>>>>                       'pin-state': {'doc': 'pin connected',
>>>>>                                     'name': 'connected'}},
>>>>>                      {'bus-name': 'pci',
>>>>>                       'dev-name': '0000:21:00.0_1',
>>>>>                       'id': 1,
>>>>>                       'pin-prio': 8,
>>>>>                       'pin-state': {'doc': 'pin connected',
>>>>>                                     'name': 'connected'}}],
>>>>
>>>>Okay, here I understand it contains device specific pin items. Makes
>>>>sense!
>>>>
>>>
>>>Good.
>>
>>Make sure you don't nest the pin objects for dump (DPLL_A_PIN). Same
>>reason as above.
>>I don't see a need for DPLL_A_PIN attr existence, please remove it.
>>
>>
>
>Sure, will try.

Cool.


>
>>
>>
>>>
>>>[...]
>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>>+      -
>>>>>>>+        name: pin-prio
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: pin-state
>>>>>>>+        type: u8
>>>>>>>+        enum: pin-state
>>>>>>>+      -
>>>>>>>+        name: pin-parent
>>>>>>>+        type: nest
>>>>>>>+        multi-attr: true
>>>>>>>+        nested-attributes: pin
>>>>>>>+        value: 23
>>>>>>
>>>>>>Value 23? What's this?
>>>>>>You have it specified for some attrs all over the place.
>>>>>>What is the reason for it?
>>>>>>
>>>>>
>>>>>Actually this particular one is not needed (also value: 12 on pin above),
>>>>>I will remove those.
>>>>>But the others you are refering to (the ones in nested attribute list),
>>>>>are required because of cli.py parser issue, maybe Kuba knows a better way
>>>>to
>>>>>prevent the issue?
>>>>>Basically, without those values, cli.py brakes on parsing responses, after
>>>>>every "jump" to nested attribute list it is assigning first attribute
>>>>there
>>>>>with value=0, thus there is a need to assign a proper value, same as it is
>>>>on
>>>>>'main' attribute list.
>>>>
>>>>That's weird. Looks like a bug then?
>>>>
>>>
>>>Guess we could call it a bug, I haven't investigated the parser that much,
>>>AFAIR, other specs are doing the same way.
>>>
>>>>
>>>>>
>>>>>>
>>>>>>>+      -
>>>>>>>+        name: pin-parent-idx
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: pin-rclk-device
>>>>>>>+        type: string
>>>>>>>+      -
>>>>>>>+        name: pin-dpll-caps
>>>>>>>+        type: u32
>>>>>>>+  -
>>>>>>>+    name: device
>>>>>>>+    subset-of: dpll
>>>>>>>+    attributes:
>>>>>>>+      -
>>>>>>>+        name: id
>>>>>>>+        type: u32
>>>>>>>+        value: 2
>>>>>>>+      -
>>>>>>>+        name: dev-name
>>>>>>>+        type: string
>>>>>>>+      -
>>>>>>>+        name: bus-name
>>>>>>>+        type: string
>>>>>>>+      -
>>>>>>>+        name: mode
>>>>>>>+        type: u8
>>>>>>>+        enum: mode
>>>>>>>+      -
>>>>>>>+        name: mode-supported
>>>>>>>+        type: u8
>>>>>>>+        enum: mode
>>>>>>>+        multi-attr: true
>>>>>>>+      -
>>>>>>>+        name: source-pin-idx
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: lock-status
>>>>>>>+        type: u8
>>>>>>>+        enum: lock-status
>>>>>>>+      -
>>>>>>>+        name: temp
>>>>>>>+        type: s32
>>>>>>>+      -
>>>>>>>+        name: clock-id
>>>>>>>+        type: u64
>>>>>>>+      -
>>>>>>>+        name: type
>>>>>>>+        type: u8
>>>>>>>+        enum: type
>>>>>>>+      -
>>>>>>>+        name: pin
>>>>>>>+        type: nest
>>>>>>>+        value: 12
>>>>>>>+        multi-attr: true
>>>>>>>+        nested-attributes: pin
>>>>>>
>>>>>>This does not belong here.
>>>>>>
>>>>>
>>>>>What do you mean?
>>>>>With device-get 'do' request the list of pins connected to the dpll is
>>>>>returned, each pin is nested in this attribute.
>>>>
>>>>No, wait a sec. You have 2 object types: device and pin. Each have
>>>>separate netlink CMDs to get and dump individual objects.
>>>>Don't mix those together like this. I thought it became clear in the
>>>>past. :/
>>>>
>>>
>>>For pins we must, as pins without a handle to a dpll are pointless.
>>
>>I'm not talking about per device specific items for pins (state and
>>prio). That is something else, it's a pin-device tuple. Completely fine.
>>
>>
>>
>>>Same as a dpll without pins, right?
>>>
>>>'do' of DEVICE_GET could just dump it's own status, without the list of
>>pins,
>>
>>Yes please.
>>
>>
>>>but it feels easier for handling it's state on userspace counterpart if
>>>that command also returns currently registered pins. Don't you think so?
>>
>>No, definitelly not. Please make the object separation clear. Device and
>>pins are different objects, they have different commands to work with.
>>Don't mix them together.
>>
>
>It does, since the user app wouldn't have to dump/get pins continuously.

I don't follow. For every pin change there is going to be pin object
dumped over monitoring netlink.


>But yeah, as object separation argument makes sense will try to fix it.

Awesome.


>
>>
>>>
>>>>
>>>>>This is required by parser to work.
>>>>>
>>>>>>
>>>>>>>+      -
>>>>>>>+        name: pin-prio
>>>>>>>+        type: u32
>>>>>>>+        value: 21
>>>>>>>+      -
>>>>>>>+        name: pin-state
>>>>>>>+        type: u8
>>>>>>>+        enum: pin-state
>>>>>>>+      -
>>>>>>>+        name: pin-dpll-caps
>>>>>>>+        type: u32
>>>>>>>+        value: 26
>>>>>>
>>>>>>All these 3 do not belong here are well.
>>>>>>
>>>>>
>>>>>Same as above explanation.
>>>>
>>>>Same as above reply.
>>>>
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>>+  -
>>>>>>>+    name: pin
>>>>>>>+    subset-of: dpll
>>>>>>>+    attributes:
>>>>>>>+      -
>>>>>>>+        name: device
>>>>>>>+        type: nest
>>>>>>>+        value: 1
>>>>>>>+        multi-attr: true
>>>>>>>+        nested-attributes: device
>>>>>>>+      -
>>>>>>>+        name: pin-idx
>>>>>>>+        type: u32
>>>>>>>+        value: 13
>>>>>>>+      -
>>>>>>>+        name: pin-description
>>>>>>>+        type: string
>>>>>>>+      -
>>>>>>>+        name: pin-type
>>>>>>>+        type: u8
>>>>>>>+        enum: pin-type
>>>>>>>+      -
>>>>>>>+        name: pin-direction
>>>>>>>+        type: u8
>>>>>>>+        enum: pin-direction
>>>>>>>+      -
>>>>>>>+        name: pin-frequency
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: pin-frequency-supported
>>>>>>>+        type: u32
>>>>>>>+        multi-attr: true
>>>>>>>+      -
>>>>>>>+        name: pin-any-frequency-min
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: pin-any-frequency-max
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: pin-prio
>>>>>>>+        type: u32
>>>>>>>+      -
>>>>>>>+        name: pin-state
>>>>>>>+        type: u8
>>>>>>>+        enum: pin-state
>>>>>>>+      -
>>>>>>>+        name: pin-parent
>>>>>>>+        type: nest
>>>>>>>+        multi-attr: true
>>>>>>
>>>>>>Multiple parents? How is that supposed to work?
>>>>>>
>>>>>
>>>>>As we have agreed, MUXed pins can have multiple parents.
>>>>>In our case:
>>>>>/tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do
>>>>>pin-get --json '{"id": 0, "pin-idx":13}'
>>>>>{'pin': [{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0',
>>>>>'id': 0},
>>>>>                     {'bus-name': 'pci',
>>>>>                      'dev-name': '0000:21:00.0_1',
>>>>>                      'id': 1}],
>>>>>          'pin-description': '0000:21:00.0',
>>>>>          'pin-direction': {'doc': 'pin used as a source of a signal',
>>>>>                            'name': 'source'},
>>>>>          'pin-idx': 13,
>>>>>          'pin-parent': [{'pin-parent-idx': 2,
>>>>>                          'pin-state': {'doc': 'pin disconnected',
>>>>>                                        'name': 'disconnected'}},
>>>>>                         {'pin-parent-idx': 3,
>>>>>                          'pin-state': {'doc': 'pin disconnected',
>>>>>                                        'name': 'disconnected'}}],
>>>>>          'pin-rclk-device': '0000:21:00.0',
>>>>>          'pin-type': {'doc': "ethernet port PHY's recovered clock",
>>>>>                       'name': 'synce-eth-port'}}]}
>>>>
>>>>Got it, it is still a bit hard to me to follow this. Could you
>>>>perhaps extend the Documentation to describe in more details
>>>>with examples? Would help a lot for slower people like me to understand
>>>>what's what.
>>>>
>>>
>>>Actually this is already explained in "MUX-type pins" paragraph of
>>>Documentation/networking/dpll.rst.
>>>Do we want to duplicate this explanation here?
>>
>>No, please extend the docs. As I wrote above, could you add some
>>examples, like the one you pasted above. Examples always help to
>>undestand things much better.
>>
>
>Sure, fixed.
>
>>
>>>
>>>
>>>>
>>>>>
>>>>>
>>>>>>
>>>>>>>+        nested-attributes: pin-parent
>>>>>>>+        value: 23
>>>>>>>+      -
>>>>>>>+        name: pin-rclk-device
>>>>>>>+        type: string
>>>>>>>+        value: 25
>>>>>>>+      -
>>>>>>>+        name: pin-dpll-caps
>>>>>>>+        type: u32
>>>>>>
>>>>>>Missing "enum: "
>>>>>>
>>>>>
>>>>>It is actually a bitmask, this is why didn't set as enum, with enum type
>>>>>parser won't parse it.
>>>>
>>>>Ah! Got it. Perhaps a docs note with the enum pointer then?
>>>>
>>>
>>>Same as above, explained in Documentation/networking/dpll.rst, do wan't to
>>>duplicate?
>>
>>For this, yes. Some small doc note here would be quite convenient.
>>
>>Also, I almost forgot: Please don't use NLA_U32 for caps flags. Please
>>use NLA_BITFIELD32 which was introduced for exactly this purpose. Allows
>>to do nicer validation as well.
>>
>
>Actually BITFIELD32 is to much for this case, the bit itself would be enough
>as we don't need validity bit.
>But yeah, as there is no BITMASK yet, will try to change to BITFIELD32.
>
>[...]
>
>>>>>>
>>>>>>Hmm, shouldn't source-pin-index be here as well?
>>>>>
>>>>>No, there is no set for this.
>>>>>For manual mode user selects the pin by setting enabled state on the one
>>>>>he needs to recover signal from.
>>>>>
>>>>>source-pin-index is read only, returns active source.
>>>>
>>>>Okay, got it. Then why do we have this assymetric approach? Just have
>>>>the enabled state to serve the user to see which one is selected, no?
>>>>This would help to avoid confusion (like mine) and allow not to create
>>>>inconsistencies (like no pin enabled yet driver to return some source
>>>>pin index)
>>>>
>>>
>>>This is due to automatic mode were multiple pins are enabled, but actual
>>>selection is done on hardware level with priorities.
>>
>>Okay, this is confusing and I believe wrong.
>>You have dual meaning for pin state attribute with states
>>STATE_CONNECTED/DISCONNECTED:
>>
>>1) Manual mode, MUX pins (both share the same model):
>>   There is only one pin with STATE_CONNECTED. The others are in
>>   STATE_DISCONNECTED
>>   User changes a state of a pin to make the selection.
>>
>>   Example:
>>     $ dplltool pin dump
>>       pin 1 state connected
>>       pin 2 state disconnected
>>     $ dplltool pin 2 set state connected
>>     $ dplltool pin dump
>>       pin 1 state disconnected
>>       pin 2 state connected
>>
>>2) Automatic mode:
>>   The user by setting "state" decides it the pin should be considered
>>   by the device for auto selection.
>>
>>   Example:
>>     $ dplltool pin dump:
>>       pin 1 state connected prio 10
>>       pin 2 state connected prio 15
>>     $ dplltool dpll x get:
>>       dpll x source-pin-index 1
>>
>>So in manual mode, STATE_CONNECTED means the dpll is connected to this
>>source pin. However, in automatic mode it means something else. It means
>>the user allows this pin to be considered for auto selection. The fact
>>the pin is selected source is exposed over source-pin-index.
>>
>>Instead of this, I believe that the semantics of
>>STATE_CONNECTED/DISCONNECTED should be the same for automatic mode as
>>well. Unlike the manual mode/mux, where the state is written by user, in
>>automatic mode the state should be only written by the driver. User
>>attemts to set the state should fail with graceful explanation (DPLL
>>netlink/core code should handle that, w/o driver interaction)
>>
>>Suggested automatic mode example:
>>     $ dplltool pin dump:
>>       pin 1 state connected prio 10 connectable true
>>       pin 2 state disconnected prio 15 connectable true
>>     $ dplltool pin 1 set connectable false
>>     $ dplltool pin dump:
>>       pin 1 state disconnected prio 10 connectable false
>>       pin 2 state connected prio 15 connectable true
>>     $ dplltool pin 1 set state connected
>>       -EOPNOTSUPP
>>
>>Note there is no "source-pin-index" at all. Replaced by pin state here.
>>There is a new attribute called "connectable", the user uses this
>>attribute to tell the device, if this source pin could be considered for
>>auto selection or not.
>>
>>Could be called perhaps "selectable", does not matter. The point is, the
>>meaning of the "state" attribute is consistent for automatic mode,
>>manual mode and mux pin.
>>
>>Makes sense?
>>
>
>Great idea!
>I will add third enum for pin-state: DPLL_PIN_STATE_SELECTABLE.
>In the end we will have this:
>              +--------------------------------+
>              | valid DPLL_A_PIN_STATE values  |
>	      +---------------+----------------+
>+------------+| requested:    | returned:      |
>|DPLL_A_MODE:||               |                |
>|------------++--------------------------------|
>|AUTOMATIC   ||- SELECTABLE   | - SELECTABLE   |
>|            ||- DISCONNECTED | - DISCONNECTED |
>|            ||               | - CONNECTED    |

"selectable" is something the user sets.
"connected"/"disconnected" is in case of auto mode something that driver
sets.

Looks a bit odd to mix them together. That is why I suggested
to have sepectable as a separate attr. But up to you. Please make sure
you sanitize the user/driver set of this attr in dpll code.


>|------------++--------------------------------|
>|MANUAL      ||- CONNECTED    | - CONNECTED    |
>|            ||- DISCONNECTED | - DISCONNECTED |
>+------------++---------------+----------------+
>
>Thank you,
>Arkadiusz
>
>>
>>>
>>>[...]
>>>
>>>>>>>+
>>>>>>>+/* DPLL_CMD_DEVICE_SET - do */
>>>>>>>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE +
>>>>>>>1]
>>>>>>>= {
>>>>>>>+	[DPLL_A_ID] = { .type = NLA_U32, },
>>>>>>>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>>>>>>>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>>>>>>>+	[DPLL_A_MODE] = NLA_POLICY_MAX(NLA_U8, 5),
>>>>>>
>>>>>>Hmm, any idea why the generator does not put define name
>>>>>>here instead of "5"?
>>>>>>
>>>>>
>>>>>Not really, it probably needs a fix for this.
>>>>
>>>>Yeah.
>>>>
>>>
>>>Well, once we done with review maybe we could also fix those, or ask
>>>Jakub if he could help :)
>>>
>>>
>>>[...]
>>>
>>>>>>
>>>>>>>+	DPLL_A_PIN_PRIO,
>>>>>>>+	DPLL_A_PIN_STATE,
>>>>>>>+	DPLL_A_PIN_PARENT,
>>>>>>>+	DPLL_A_PIN_PARENT_IDX,
>>>>>>>+	DPLL_A_PIN_RCLK_DEVICE,
>>>>>>>+	DPLL_A_PIN_DPLL_CAPS,
>>>>>>
>>>>>>Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
>>>>>>enum name.
>>>>>
>>>>>Sure, fixed.
>>>>
>>>>
>>>>Thanks for all your work on this!
>>>
>>>Thanks for a great review! :)
>>
>>Glad to help.
