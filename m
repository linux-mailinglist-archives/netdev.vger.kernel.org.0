Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158EA64814C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLILHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLILHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:07:49 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1738120BD
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:07:46 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v8so2638833edi.3
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 03:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OcnoIGZrTppFlzmOBBjJDAebpzPmS0Ohb5BPolqx6aM=;
        b=a+6VV6jd6NmoTRh/F+hfoG2ENWqoEKSKlMNNmF+irH5t/JaQLQQkWIn2rGXV/R9103
         WjeUSD20dRZPahkNrZaOE2uL2/fZdt/qgQs1OGEOlC/vi+x1aruQnFOYD9CfKoxAiwZR
         uVsfzEwiPswywykLO05YB4U9ABrWhUvmp7mo2xV+GyNGSxoy/aWhKIzDOtkUFcIao+2+
         K+SLl41iMDAq7WjVevyEmbjoqtsHdruHw2LZYqGsLyh3cjeM2ONBxkldXMTgCjLme5jL
         SJFsZk/kYZohSqieVHYqAC5scn10pJ2nlJsoSHL+heB9yI46M/5vjBlZS52lNu5jYnq1
         9Ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OcnoIGZrTppFlzmOBBjJDAebpzPmS0Ohb5BPolqx6aM=;
        b=Ao7A1w5qvIKm6dCxRRgtPOZtTcKXbu39Q1+uSkNuiGqvWruXueBBu96QVpBZbR00QF
         qdrvI/u44FPjbZGRv1bxSK+T4Tx9sfbEWASnVOU49DlbI8S0UJguZLxHNQ9Bq5M7zhzR
         k2pMHwRk8edtu9sGQN0BQ0A4y+FJR9k/7oIciX5TJdk22B6DDxPaDJ26HK1bQGmOppF+
         W8KnFOo0HmINiQRfFiDZvRVrkqPgZsYWKnoQVogLI4LrvTYC2VgY03hCmeFYcjPruDsz
         lNae672vAaVQ5lF3jjskJ0M9Cu0Zh7BypOAr2rlJ9UV4wKNMHYs8bLbIDtJoT0F3lC6Y
         CrrA==
X-Gm-Message-State: ANoB5pmmluTF0nrBRcIcuoeUNyFByOq0V0yZ6xACPdD6Gwr06Iu/7eNP
        N8fxJR31BCj+yLCRQMJecijO/A==
X-Google-Smtp-Source: AA0mqf40ob1+miZHnUnG0g6zPYH72FvKwRYLvhRTCEDvScOTWIbRabvzSSdqGXNpxYtpb21zDczKKQ==
X-Received: by 2002:a05:6402:3906:b0:461:79d8:f51a with SMTP id fe6-20020a056402390600b0046179d8f51amr4621741edb.10.1670584065099;
        Fri, 09 Dec 2022 03:07:45 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a15-20020a056402168f00b004642b35f89esm277892edv.9.2022.12.09.03.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:07:44 -0800 (PST)
Date:   Fri, 9 Dec 2022 12:07:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maciek Machnikowski <maciek@machnikowski.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y5MW/7jpMUXAGFGX@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 07:08:04PM CET, maciek@machnikowski.net wrote:
>On 12/8/2022 12:21 AM, Jakub Kicinski wrote:
>> On Wed, 7 Dec 2022 15:09:03 +0100 netdev.dump@gmail.com wrote:
>>>> -----Original Message-----
>>>> From: Jakub Kicinski <kuba@kernel.org>
>>> pins between the DPLLs exposed by a single driver, but not really outside of
>>> it.
>>> And that can be done simply by putting the pin ptr from the DPLLA into the
>>> pin
>>> list of DPLLB.
>> 
>> Are you saying within the driver it's somehow easier? The driver state
>> is mostly per bus device, so I don't see how.
>> 
>>> If we want the kitchen-and-sink solution, we need to think about corner
>>> cases.
>>> Which pin should the API give to the userspace app - original, or
>>> muxed/parent?
>> 
>> IDK if I parse but I think both. If selected pin is not directly
>> attached the core should configure muxes.
>> 
>>> How would a teardown look like - if Driver A registered DPLLA with Pin1 and
>>> Driver B added the muxed pin then how should Driver A properly
>>> release its pins? Should it just send a message to driver B and trust that
>>> it
>>> will receive it in time before we tear everything apart?
>> 
>> Trivial.
>> 
>>> There are many problems with that approach, and the submitted patch is not
>>> explaining any of them. E.g. it contains the dpll_muxed_pin_register but no
>>> free 
>>> counterpart + no flows.
>> 
>> SMOC.
>> 
>>> If we want to get shared pins, we need a good example of how this mechanism
>>> can be used.
>> 
>> Agreed.
>
>My main complaint about the current pins implementation is that they put
>everything in a single bag. In a netdev world - it would be like we put
>TX queues and RX queues together, named them "Queues", expose a list to
>the userspace and let the user figure out which ones which by reading a
>"TX" flag.
>
>All DPLLs I know have a Sources block, DPLLs and Output blocks. See:
>
>https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-frequency-translation/8a34044-multichannel-dpll-dco-four-eight-channels#overview
>
>https://ww1.microchip.com/downloads/aemDocuments/documents/TIM/ProductDocuments/ProductBrief/ZL3063x-System-Synchronizers-with-up-to-5-Channels-10-Inputs-20-Outputs-Product-Brief-DS20006634.pdf
>
>https://www.sitime.com/support/resource-library/product-briefs/cascade-sit9514x-clock-system-chip-family
>
>https://www.ti.com/lit/ds/symlink/lmk5b33414.pdf?ts=1670516132647&ref_url=https%253A%252F%252Fwww.ti.com%252Fclocks-timing%252Fjitter-cleaners-synchronizers%252Fproducts.html
>
>If we model everything as "pins" we won't be able to correctly extend
>the API to add new features.
>
>Sources can configure the expected frequency, input signal monitoring
>(on multiple layers), expected signal levels, input termination and so
>on. Outputs will need the enable flag, signal format, frequency, phase
>offset etc. Multiple DPLLs can reuse a single source inside the same
>package simultaneously.


Looking at the documentation of the chips, they all have mupltiple DPLLs
on a die. Arkadiusz, in your proposed implementation, do you model each
DPLL separatelly? If yes, then I understand the urgency of need of a
shared pin. So all DPLLs sharing the pin are part of the same chip?

Question: can we have an entity, that would be 1:1 mapped to the actual
device/chip here? Let's call is "a synchronizer". It would contain
multiple DPLLs, user-facing-sources(input_connector),
user-facing-outputs(output_connector), i/o pins.

An example:
                               SYNCHRONIZER

                              ┌───────────────────────────────────────┐
                              │                                       │
                              │                                       │
  SyncE in connector          │              ┌─────────┐              │     SyncE out connector
                ┌───┐         │in pin 1      │DPLL_1   │     out pin 1│    ┌───┐
                │   ├─────────┼──────────────┤         ├──────────────┼────┤   │
                │   │         │              │         │              │    │   │
                └───┘         │              │         │              │    └───┘
                              │              │         │              │
                              │           ┌──┤         │              │
   GNSS in connector          │           │  └─────────┘              │
                ┌───┐         │in pin 2   │                  out pin 2│     EXT SMA connector
                │   ├─────────┼───────────┘                           │    ┌───┐
                │   │         │                           ┌───────────┼────┤   │
                └───┘         │                           │           │    │   │
                              │                           │           │    └───┘
                              │                           │           │
   EXT SMA connector          │                           │           │
                ┌───┐   mux   │in pin 3      ┌─────────┐  │           │
                │   ├────┬────┼───────────┐  │         │  │           │
                │   │    │    │           │  │DPLL_2   │  │           │
                └───┘    │    │           │  │         │  │           │
                         │    │           └──┤         ├──┘           │
                         │    │              │         │              │
   EXT SMA connector     │    │              │         │              │
                ┌───┐    │    │              │         │              │
                │   ├────┘    │              └─────────┘              │
                │   │         │                                       │
                └───┘         └───────────────────────────────────────┘

Do I get that remotelly correct?

synch
synchronizer_register(synch)
   dpll_1
   synchronizer_dpll_register(synch, dpll_1)
   dpll_2
   synchronizer_dpll_register(synch, dpll_2)
   source_pin_1
   synchronizer_pin_register(synch, source_pin_1)
   output_pin_1
   synchronizer_pin_register(synch, output_pin_1)
   output_pin_2
   synchronizer_pin_register(synch, output_pin_2)

synch_board
   synchronizer_board_register(synch_board)
   synch
   synchronizer_board_sync_register(synch_board, synch)
   source_connector_1
   synchronizer_board_connector_register(synch_board, source_connector_1, source_pin_1)
   output_connector_1
   synchronizer_board_connector_register(synch_board, output_connector_1, output_pin_1)
   output_connector_2
   synchronizer_board_connector_register(synch_board, output_connector_2, output_pin_2)


Thinking about it a bit more, this should be probably good to describe
by device tree. The synchronizer itself dplls and pins it contains
have constanc geometry, according to the synchronizer device type.

The Connector-pin linkages may vary according to the board.

So to divide it, there should be one synchronizer driver. Then probably
some other one to connect/select/mux the connectors to the synchronizer.

Makes sense?
