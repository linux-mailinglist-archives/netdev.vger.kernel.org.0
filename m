Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B208A648762
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLIRLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLIRLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:11:39 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458E25592;
        Fri,  9 Dec 2022 09:11:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670605877; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=dqUmU4kn+tGnxur6vul1RsbGF+ZGkf/TW1CzDjDU2gHsRdn9BH8PGq6Ai/Tb78TO4aUqG80aQVNUM/AfbWbx4wbw8a0JPLb3lqgpws8ajzDkqbGstQW+oBZllCVG/jo9mtRDS0uAIEPmiACWOLjrXW6IMlXILHF5Y0/wTiscUWo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670605877; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9sVUNE7ZtDhPsg6xptOB+v9evo1nUx2EigI2yxXDtJo=; 
        b=SBUpTpW3D0hNnhJmrPWkEYrNYVl6yvrT3USwiNbYAq+OKRkysE5WuMSjbESbc+OFCMkefTRkQpVfUYRRxdWOoOgsMUXN4X7KxhFQBX01T6n/w2G050a6ymTsGf8jX+XPd26qVqt77b7bon1OrGwZtY+fiIRyDK/hENZwVejJzBc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=machnikowski.net;
        spf=pass  smtp.mailfrom=maciek@machnikowski.net;
        dmarc=pass header.from=<maciek@machnikowski.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1670605877;
        s=zoho; d=machnikowski.net; i=maciek@machnikowski.net;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9sVUNE7ZtDhPsg6xptOB+v9evo1nUx2EigI2yxXDtJo=;
        b=sP1NhS6HVTkKev+zD8zP+vQxfGI+RTy6GNYKJZ9LTIkhKVmfjEV7HojzI8pyk3j3
        4w55ctrTWgn77hLsSqdjYjb96fldy0fkYOZ1dXjcpaOzBVdxFIm7QyeKrE+zQHK9SfX
        YkJBOU4hDfPMpAgIsUwu+nacq/L0nHs2e2899yVJBswfYBhaZAWKkXrUe4uasORNGj5
        aqqD3U2knN0b6fBWNMa0gwuPDQo+wvSPalulYGbCR0z4v3UYgps/o8j5YqDo6alxc2I
        UBvyNyUtF3py6AWiR8pqQW1tlh15aWbH5qPb1DSHo70gRKLHG0yWrsOfvBzIY1+JMwd
        Tv3bGZxyCQ==
Received: from [192.168.1.227] (83.8.188.9.ipv4.supernova.orange.pl [83.8.188.9]) by mx.zohomail.com
        with SMTPS id 167060587605489.14790061976214; Fri, 9 Dec 2022 09:11:16 -0800 (PST)
Message-ID: <c4498ff8-74b0-a01f-d029-6e6df226bc1b@machnikowski.net>
Date:   Fri, 9 Dec 2022 18:11:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Maciek Machnikowski <maciek@machnikowski.net>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho> <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org>
From:   Maciek Machnikowski <maciek@machnikowski.net>
In-Reply-To: <20221209083104.2469ebd6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/2022 5:31 PM, Jakub Kicinski wrote:
> On Fri, 9 Dec 2022 15:09:08 +0100 Maciek Machnikowski wrote:
>> On 12/9/2022 12:07 PM, Jiri Pirko wrote:
>>> Looking at the documentation of the chips, they all have mupltiple DPLLs
>>> on a die. Arkadiusz, in your proposed implementation, do you model each
>>> DPLL separatelly? If yes, then I understand the urgency of need of a
>>> shared pin. So all DPLLs sharing the pin are part of the same chip?
>>>
>>> Question: can we have an entity, that would be 1:1 mapped to the actual
>>> device/chip here? Let's call is "a synchronizer". It would contain
>>> multiple DPLLs, user-facing-sources(input_connector),
>>> user-facing-outputs(output_connector), i/o pins.
>>>
>>> An example:
>>>                                SYNCHRONIZER
>>>
>>>                               ┌───────────────────────────────────────┐
>>>                               │                                       │
>>>                               │                                       │
>>>   SyncE in connector          │              ┌─────────┐              │     SyncE out connector
>>>                 ┌───┐         │in pin 1      │DPLL_1   │     out pin 1│    ┌───┐
>>>                 │   ├─────────┼──────────────┤         ├──────────────┼────┤   │
>>>                 │   │         │              │         │              │    │   │
>>>                 └───┘         │              │         │              │    └───┘
>>>                               │              │         │              │
>>>                               │           ┌──┤         │              │
>>>    GNSS in connector          │           │  └─────────┘              │
>>>                 ┌───┐         │in pin 2   │                  out pin 2│     EXT SMA connector
>>>                 │   ├─────────┼───────────┘                           │    ┌───┐
>>>                 │   │         │                           ┌───────────┼────┤   │
>>>                 └───┘         │                           │           │    │   │
>>>                               │                           │           │    └───┘
>>>                               │                           │           │
>>>    EXT SMA connector          │                           │           │
>>>                 ┌───┐   mux   │in pin 3      ┌─────────┐  │           │
>>>                 │   ├────┬────┼───────────┐  │         │  │           │
>>>                 │   │    │    │           │  │DPLL_2   │  │           │
>>>                 └───┘    │    │           │  │         │  │           │
>>>                          │    │           └──┤         ├──┘           │
>>>                          │    │              │         │              │
>>>    EXT SMA connector     │    │              │         │              │
>>>                 ┌───┐    │    │              │         │              │
>>>                 │   ├────┘    │              └─────────┘              │
>>>                 │   │         │                                       │
>>>                 └───┘         └───────────────────────────────────────┘
>>>
>>> Do I get that remotelly correct?  
>>
>> It looks goot, hence two corrections are needed:
>> - all inputs can go to all DPLLs, and a single source can drive more
>>   than one DPLL
>> - The external mux for SMA connector should not be a part of the
>>   Synchronizer subsystem - I believe there's already a separate MUX
>>   subsystem in the kernel and all external connections should be handled
>>   by a devtree or a similar concept.
>>
>> The only "muxing" thing that could potentially be modeled is a
>> synchronizer output to synchronizer input relation. Some synchronizers
>> does that internally and can use the output of one DPLL as a source for
>> another.
> 
> My experience with DT and muxes is rapidly aging, have you worked with
> those recently? From what I remember the muxes were really.. "embedded"
> and static compared to what we want here.
> 
> Using DT may work nicely for defining the topology, but for config we
> still need a different mechanism.
> 
>>> synch
>>> synchronizer_register(synch)
>>>    dpll_1
>>>    synchronizer_dpll_register(synch, dpll_1)
>>>    dpll_2
>>>    synchronizer_dpll_register(synch, dpll_2)
>>>    source_pin_1
>>>    synchronizer_pin_register(synch, source_pin_1)
>>>    output_pin_1
>>>    synchronizer_pin_register(synch, output_pin_1)
>>>    output_pin_2
>>>    synchronizer_pin_register(synch, output_pin_2)
>>>
>>> synch_board
>>>    synchronizer_board_register(synch_board)
>>>    synch
>>>    synchronizer_board_sync_register(synch_board, synch)
>>>    source_connector_1
>>>    synchronizer_board_connector_register(synch_board, source_connector_1, source_pin_1)
>>>    output_connector_1
>>>    synchronizer_board_connector_register(synch_board, output_connector_1, output_pin_1)
>>>    output_connector_2
>>>    synchronizer_board_connector_register(synch_board, output_connector_2, output_pin_2)  
>>
>> I'd rather not use pins at all - just stick to sources and outputs. Both
>> can use some labels to be identifiable.
> 
> TBH I can't comprehend your suggestion.
> IIUC you want an object for a source, but my brain can't handle
> modeling an external object. For instance the source could be GNSS, 
> but this is not the GNSS subsystem. We have a pin connected to GNSS,
> not the GNSS itself. 
> Maybe a diagram would help?

A source is just a more generic term for a frequency signal that can be
used by a DPLL. For some solutions it can represent a pin, for others
(integrated) it can represent an internal connection to a different
DPLL/PHY/MAC/embedded oscillator or anything else that can produce
periodic signal.

This object will have a subset of properties listed in a previous mail:
>>>> Sources can configure the expected frequency, input signal
>>>> monitoring (on multiple layers), expected signal levels, input
>>>> termination and so on. Outputs will need the enable flag, signal
>>>> format, frequency, phase offset etc. Multiple DPLLs can reuse a
>>>> single source inside the same package simultaneously.

I'm absolutely not willing to connect the GNSS subsystem there :)

A "pin" is too ambiguous - especially for differential inputs.

