Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EFD5FD545
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJMGzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJMGzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:55:40 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249FCD0CFB
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:55:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u21so1284521edi.9
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9bgNN7X2bMAPvjWH29NOgtDY27vanw717rBtzJJwDbg=;
        b=Ktc61kE9Kv6nh7yMDKWn1BqjT2xoztkpay/J/uSQP50IGWNBGXKmPQ9ciUP9Z2T26k
         0icBep1Uz5i0A+DYVEK4d+kQWpnBgN/rAQFy41npkCbGeXh9FdL1Eq4hurFqr6dlWLaC
         5lott/W5CHuL3CsfLnbVY8Tt9ELskSwun+f9raN68k4VE1BOe3gwrFyJ/XAjH+cUGx5D
         V8Cn9n1QatYvFKGct6knXI3P6mlY38GeNQxg/mhgTBGu4N839FzSm2WJ1mgdEjnY5W/2
         s230v3eQq/cfmIeyI3J4G4dtdJbi1E7qcjJkEPUz98t127EDk3nZbUT3U3by/och4EEp
         q1Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9bgNN7X2bMAPvjWH29NOgtDY27vanw717rBtzJJwDbg=;
        b=iB63JvBVzMh9JtexzaZ2QJ6jG6ON//LY2CWeTCzLtBBmL1UIS6Y02Yl9uNKoJILnzl
         Yf9tgbzAw9l3owWVC/OukdhPcR5mFKV3rcanayEIw/lWp0iAJrApTkxAfL2WHEWr3sjr
         fWYj12POM1lebAhI3Oo3sAy0VXtKsm+MdwvFl2N5fwO5iDN8unGV3jLD5Oe61q6WlvIH
         GgoDQ769lT+vkSZ4UWtL0eoZ4DTbde3I67auznEqD3yxL6k+vNFxstckUrlYMmH8bh/r
         DQpzV0wL4zvuPJ4eTJiS3GI54wWThHomCXdHTMJ/KTiQcrghqxUQ5ygQFojiQRr4Enyo
         exKw==
X-Gm-Message-State: ACrzQf1rQ/LBjyGK7Itcf6ZwT+jl/AfvCx/58SLsewf5fVfRtfCGykcl
        JSvgUr5gX6YXB2HV1BToHQ85Bg==
X-Google-Smtp-Source: AMsMyM6JUAOH69tO0WMYoFMsBQaKPo/jHOKhwzMRRQ4YgwYSCeBg0GqdzQRG/qtNzqnA3SjB+QnABA==
X-Received: by 2002:a50:fd8b:0:b0:459:31f9:d3b with SMTP id o11-20020a50fd8b000000b0045931f90d3bmr30883080edt.304.1665644136573;
        Wed, 12 Oct 2022 23:55:36 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q2-20020a1709063d4200b0078b1ff41f05sm2460243ejf.43.2022.10.12.23.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 23:55:35 -0700 (PDT)
Date:   Thu, 13 Oct 2022 08:55:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Message-ID: <Y0e2Zn4pbhPnKGQJ@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-2-vfedorenko@novek.ru>
 <Y0PjULbYQf1WbI9w@nanopsycho>
 <24d1d750-7fd0-44e2-318c-62f6a4a23ea5@novek.ru>
 <Y0UqFml6tEdFt0rj@nanopsycho>
 <Y0UtiBRcc8aBS4tD@nanopsycho>
 <ecf59dda-2d6a-2c56-668b-5377ae107439@novek.ru>
 <Y0ZiQbqQ+DsHinOf@nanopsycho>
 <9a3608cf-21bb-18b1-796a-7325a613b641@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a3608cf-21bb-18b1-796a-7325a613b641@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 12, 2022 at 10:12:43PM CEST, vfedorenko@novek.ru wrote:
>On 12.10.2022 07:44, Jiri Pirko wrote:
>> Tue, Oct 11, 2022 at 11:31:25PM CEST, vfedorenko@novek.ru wrote:
>> > On 11.10.2022 09:47, Jiri Pirko wrote:
>> > > Tue, Oct 11, 2022 at 10:32:22AM CEST, jiri@resnulli.us wrote:
>> > > > Mon, Oct 10, 2022 at 09:54:26PM CEST, vfedorenko@novek.ru wrote:
>> > > > > On 10.10.2022 10:18, Jiri Pirko wrote:
>> > > > > > Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>> > > > > > > From: Vadim Fedorenko <vadfed@fb.com>
>> > > 
>> > > [...]
>> > > 
>> > > 
>> > > > > I see your point. We do have hardware which allows changing type of SMA
>> > > > > connector, and even the direction, each SMA could be used as input/source or
>> > > > > output of different signals. But there are limitation, like not all SMAs can
>> > > > > produce IRIG-B signal or only some of them can be used to get GNSS 1PPS. The
>> > > > 
>> > > > Okay, so that is not the *type* of source, but rather attribute of it.
>> > > > Example:
>> > > > 
>> > > > $ dpll X show
>> > > > index 0
>> > > >    type EXT
>> > > >    signal 1PPS
>> > > >    supported_signals
>> > > >       1PPS 10MHz
>> > > > 
>> > > > $ dpll X set source index 1 signal_type 10MHz
>> > > > $ dpll X show
>> > > > index 0
>> > > >    type EXT
>> > > >    signal 10MHz
>> > > >    supported_signals
>> > > >       1PPS 10MHz
>> > > > 
>> > > > So one source with index 0 of type "EXT" (could be "SMA", does not
>> > > > matter) supports 1 signal types.
>> > > > 
>> > > > 
>> > > > Thinking about this more and to cover the case when one SMA could be
>> > > > potencially used for input and output. It already occured to me that
>> > > > source/output are quite similar, have similar/same attributes. What if
>> > > > they are merged together to say a "pin" object only with extra
>> > > > PERSONALITY attribute?
>> > > > 
>> > > > Example:
>> > > > 
>> > > > -> DPLL_CMD_PIN_GET - dump
>> > > >        ATTR_DEVICE_ID X
>> > > > 
>> > > > <- DPLL_CMD_PIN_GET
>> > > > 
>> > > >         ATTR_DEVICE_ID X
>> > > >         ATTR_PIN_INDEX 0
>> > > >         ATTR_PIN_TYPE EXT
>> > > >         ATTR_PIN_SIGNAL 1PPS   (selected signal)
>> > > >         ATTR_PIN_SUPPORTED_SIGNALS (nest)
>> > > >           ATTR_PIN_SIGNAL 1PPS
>> > > >           ATTR_PIN_SIGNAL 10MHZ
>> > > >         ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>> > > >         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>> > > >           ATTR_PIN_PERSONALITY DISCONNECTED
>> > > >           ATTR_PIN_PERSONALITY INPUT
>> > > >           ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>> > > > 					  output)
>> > > > 
>> > > >         ATTR_DEVICE_ID X
>> > > >         ATTR_PIN_INDEX 1
>> > > >         ATTR_PIN_TYPE EXT
>> > > >         ATTR_PIN_SIGNAL 10MHz   (selected signal)
>> > > >         ATTR_PIN_SUPPORTED_SIGNALS (nest)
>> > > >           ATTR_PIN_SIGNAL 1PPS
>> > > >           ATTR_PIN_SIGNAL 10MHZ
>> > > >         ATTR_PIN_PERSONALITY DISCONNECTED   (selected personality - not
>> > > > 					    connected currently)
>> > > >         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>> > > >           ATTR_PIN_PERSONALITY DISCONNECTED
>> > > >           ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
>> > > > 
>> > > >         ATTR_DEVICE_ID X
>> > > >         ATTR_PIN_INDEX 2
>> > > >         ATTR_PIN_TYPE GNSS
>> > > >         ATTR_PIN_SIGNAL 1PPS   (selected signal)
>> > > >         ATTR_PIN_SUPPORTED_SIGNALS (nest)
>> > > >           ATTR_PIN_SIGNAL 1PPS
>> > > >         ATTR_PIN_PERSONALITY INPUT   (selected personality - note this is
>> > > > 				     now he selected source, being only
>> > > > 				     pin with INPUT personality)
>> > > >         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>> > > >           ATTR_PIN_PERSONALITY DISCONNECTED
>> > > >           ATTR_PIN_PERSONALITY INPUT      (note this supports only input)
>> > > > 
>> > > >         ATTR_DEVICE_ID X
>> > > >         ATTR_PIN_INDEX 3
>> > > >         ATTR_PIN_TYPE SYNCE_ETH_PORT
>> > > >         ATTR_PIN_NETDEV_IFINDEX 20
>> > > >         ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>> > > >         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>> > > >           ATTR_PIN_PERSONALITY DISCONNECTED
>> > > >           ATTR_PIN_PERSONALITY INPUT
>> > > >           ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>> > > > 					  output)
>> > > > 
>> > > >         ATTR_DEVICE_ID X
>> > > >         ATTR_PIN_INDEX 4
>> > > >         ATTR_PIN_TYPE SYNCE_ETH_PORT
>> > > >         ATTR_PIN_NETDEV_IFINDEX 30
>> > > >         ATTR_PIN_PERSONALITY OUTPUT   (selected personality)
>> > > >         ATTR_PIN_SUPPORTED_PERSONALITIES (nest)
>> > > >           ATTR_PIN_PERSONALITY DISCONNECTED
>> > > >           ATTR_PIN_PERSONALITY INPUT
>> > > >           ATTR_PIN_PERSONALITY OUTPUT     (note this supports both input and
>> > > > 					  output)
>> > > > 
>> > > > 
>> > > > This allows the user to actually see the full picture:
>> > > > 1) all input/output pins in a single list, no duplicates
>> > > > 2) each pin if of certain type (ATTR_PIN_TYPE) EXT/GNSS/SYNCE_ETH_PORT
>> > > > 3) the pins that can change signal type contain the selected and list of
>> > > >     supported signal types (ATTR_PIN_SIGNAL, ATTR_PIN_SUPPORTED_SIGNALS)
>> > > > 4) direction/connection of the pin to the DPLL is exposed over
>> > > >     ATTR_PIN_PERSONALITY. For each pin, the driver would expose it can
>> > > >     act as INPUT/OUTPUT and even more, it can indicate the pin can
>> > > >     disconnect from DPLL entirely (if possible).
>> > > > 5) user can select the source by setting ATTR_PIN_PERSONALITY of certain
>> > > >     pin to INPUT. Only one pin could be set to INPUT and that is the
>> > > >     souce of DPLL.
>> > > >     In case no pin have personality set to INPUT, the DPLL is
>> > > >     free-running.
>> > > 
>> > > Okay, thinking about it some more, I would leave the source select
>> > > indepentent from the ATTR_PIN_PERSONALITY and selectable using device
>> > > set cmd and separate attribute. It works better even more when consider
>> > > autoselect mode.
>> > > 
>> > > Well of course only pins with ATTR_PIN_PERSONALITY INPUT could be
>> > > selected as source.
>> > > 
>> > 
>> > Overall, I agree with this proposal, and as I've already said, the work is
>> > going exactly the same way - to introduce pin object with separate set of
>> > attributes.
>> > I don't really like 'PERSONALITY' naming, I think we have to find a better
>> > name. It looks like DIRECTION is slightly better. And the
>> > CONNECTED/DISCONNECTED should be different attribute. And we also need
>> 
>> Yeah, it is a matter of implementation. I just thought that this is
>> possible to be done in a single attribute, because when the pin is
>> disconnected, the direction has no meaning.
>> 
>> 
>> > attribute PRIORITY to be able to configure (or hint) auto-select mode. There
>> 
>> Sure, I didn't put the PRIORITY attribute to the example, but I believe
>> it is very straightforward extension to add it.
>> 
>> 
>> > are also special objects called muxes, which consist of several inputs and
>> > one output, but they cannot synthonise signal, only pass one of the inputs to
>> > output. We are still in kind of discussion whether to have them as separate
>> > objects, or extend the amount of pins of DPLL device in this case. The
>> > problem again in the auto-select mode and priorities. It would be great to
>> > hear your thoughts about such objects.
>> 
>> Does the mux have any attribute/configuration valuable for the user.
>> If yes, it might make sense to have it as a separate object. Then we
>> can have it as a tree of object of type MUX with leaves of PIN.
>
>Yes, that was the first thought, but implementation details are not great for now.
>
>> The question really is, if the user needs to know about muxes and work
>> with them, or they can be abstracted out by the driver.
>
>Both ways will work I believe. It's more like our will to give users full
>picture or hide it somehow with the implementation.
>> 
>> Could you elaborate a bit more why auto-select mode and priorities are
>> problematic with muxes in picture?
>
>AFAIU, some mux devices are not smart enough to make a decision suitable for
>autoselect for the pins they have. In this case the autoselect process is
>done in the DPLL device, which selects mux and not the pin directly. At the
>same time there could be muxes that are smart enough to make a decision, and
>it will be autoselect on top of autoselect (and several more layers) and it
>doesn't sound great to me. I believe Arkadiusz will explain the mux a bit
>better.


From what you write in this reply, I have a feeling that these details
are not really interesting for user to see. So I tend to lean forward to
abstract this out and leave the details to HW/FW/driver.


>
>> 
>> 
>> > 
>> > > > 
>> > > > This would introduce quite nice flexibility, exposes source/output
>> > > > capabilities and provides good visilibity of current configuration.
>> > > > 
>> > > > 
>> > > > > interface was created to cover such case. I believe we have to improve it to
>> > > > > cover SyncE configuration better, but I personally don't have SyncE hardware
>> > > > > ready to test and that's why I have to rely on suggestions from yours or
>> > > > > Arkadiusz's experience. From what I can see now there is need for special
>> > > > > attribute to link source to net device, and I'm happy to add it. In case of
>> > > > > fixed configuration of sources, the device should provide only one type as
>> > > > > supported and that's it.
>> > > > > 
>> > > 
>> > > [...]
>> > 
>
