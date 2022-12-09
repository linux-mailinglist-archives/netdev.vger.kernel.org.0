Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA35648382
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLIONw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiLION2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:13:28 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081BC78697;
        Fri,  9 Dec 2022 06:09:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670594954; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=jnOvki9TrmI+eMrjm3T54AOYQZSvXWLx8TKjJX5NAWxw1O2HszUbhyYjt24sWVGIdzjQo4eV7oec56D+sqGIHPkMAppGCurOY6nLrVwnrwIvP/WJcnkVnQap/MuPfad/odc7gcrxNRjn+bwcc1q3llJAJgBk72LYH9I/3cH9Ym4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670594954; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=F8+cB/N0zNmn7olZOIHjU0tWqdllh9rXI88S3aPtc0Q=; 
        b=SrWP2kGygYy6q/JWdyTkQIhe7Tf8BzNpi99RAQ3EiNHOOV8+w/VPQ9p9+qGzauGUQ6YR7PvflFbpSMfg01yZu28rHhjfm+1+NFJTZwMTLAk2I7Fp3k9XujXJ1HyLN2hhBd6AkDf15O9d4AILkvR0Ezanap7HcTNGp9f2bITGwws=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=machnikowski.net;
        spf=pass  smtp.mailfrom=maciek@machnikowski.net;
        dmarc=pass header.from=<maciek@machnikowski.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1670594954;
        s=zoho; d=machnikowski.net; i=maciek@machnikowski.net;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=F8+cB/N0zNmn7olZOIHjU0tWqdllh9rXI88S3aPtc0Q=;
        b=Vyfudvow/JM85NCk++q6naXT3D4OCTRIX/7C8nw6W50nXbMS2okQeS0yx+F1hk82
        dQRxLIdNOQj2WujEoxSq90ZXhubuKR54/YW/kufAYnBPO2rfzRQBWJAK+/bxca+cnv3
        PDpwACTTWPc6EQfz/4YVtHcEkKprM7ns98jdw/Pk4fat/qafq50eKANCvliMCakHQ67
        kp2hhu9WizdlSQy3LEBM7fGe9iJ/Mg/xHTrz6t/XYMYnZlueVzrjJpyArYYYkNulNV4
        xcMWmM6QNzIjn75NWeqC+To4xuNQ9sShtBB2PVurWb2pK1up8lAOyXGnIvTcCeVgP02
        uY6xZIPdWA==
Received: from [192.168.1.227] (83.8.188.9.ipv4.supernova.orange.pl [83.8.188.9]) by mx.zohomail.com
        with SMTPS id 1670594952370207.56053616816519; Fri, 9 Dec 2022 06:09:12 -0800 (PST)
Message-ID: <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
Date:   Fri, 9 Dec 2022 15:09:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
From:   Maciek Machnikowski <maciek@machnikowski.net>
In-Reply-To: <Y5MW/7jpMUXAGFGX@nanopsycho>
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



On 12/9/2022 12:07 PM, Jiri Pirko wrote:
> Thu, Dec 08, 2022 at 07:08:04PM CET, maciek@machnikowski.net wrote:
>> On 12/8/2022 12:21 AM, Jakub Kicinski wrote:
>> My main complaint about the current pins implementation is that they put
>> everything in a single bag. In a netdev world - it would be like we put
>> TX queues and RX queues together, named them "Queues", expose a list to
>> the userspace and let the user figure out which ones which by reading a
>> "TX" flag.
>>
>> All DPLLs I know have a Sources block, DPLLs and Output blocks. See:
>>
>> https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-frequency-translation/8a34044-multichannel-dpll-dco-four-eight-channels#overview
>>
>> https://ww1.microchip.com/downloads/aemDocuments/documents/TIM/ProductDocuments/ProductBrief/ZL3063x-System-Synchronizers-with-up-to-5-Channels-10-Inputs-20-Outputs-Product-Brief-DS20006634.pdf
>>
>> https://www.sitime.com/support/resource-library/product-briefs/cascade-sit9514x-clock-system-chip-family
>>
>> https://www.ti.com/lit/ds/symlink/lmk5b33414.pdf?ts=1670516132647&ref_url=https%253A%252F%252Fwww.ti.com%252Fclocks-timing%252Fjitter-cleaners-synchronizers%252Fproducts.html
>>
>> If we model everything as "pins" we won't be able to correctly extend
>> the API to add new features.
>>
>> Sources can configure the expected frequency, input signal monitoring
>> (on multiple layers), expected signal levels, input termination and so
>> on. Outputs will need the enable flag, signal format, frequency, phase
>> offset etc. Multiple DPLLs can reuse a single source inside the same
>> package simultaneously.
> 
> 
> Looking at the documentation of the chips, they all have mupltiple DPLLs
> on a die. Arkadiusz, in your proposed implementation, do you model each
> DPLL separatelly? If yes, then I understand the urgency of need of a
> shared pin. So all DPLLs sharing the pin are part of the same chip?
> 
> Question: can we have an entity, that would be 1:1 mapped to the actual
> device/chip here? Let's call is "a synchronizer". It would contain
> multiple DPLLs, user-facing-sources(input_connector),
> user-facing-outputs(output_connector), i/o pins.
> 
> An example:
>                                SYNCHRONIZER
> 
>                               ┌───────────────────────────────────────┐
>                               │                                       │
>                               │                                       │
>   SyncE in connector          │              ┌─────────┐              │     SyncE out connector
>                 ┌───┐         │in pin 1      │DPLL_1   │     out pin 1│    ┌───┐
>                 │   ├─────────┼──────────────┤         ├──────────────┼────┤   │
>                 │   │         │              │         │              │    │   │
>                 └───┘         │              │         │              │    └───┘
>                               │              │         │              │
>                               │           ┌──┤         │              │
>    GNSS in connector          │           │  └─────────┘              │
>                 ┌───┐         │in pin 2   │                  out pin 2│     EXT SMA connector
>                 │   ├─────────┼───────────┘                           │    ┌───┐
>                 │   │         │                           ┌───────────┼────┤   │
>                 └───┘         │                           │           │    │   │
>                               │                           │           │    └───┘
>                               │                           │           │
>    EXT SMA connector          │                           │           │
>                 ┌───┐   mux   │in pin 3      ┌─────────┐  │           │
>                 │   ├────┬────┼───────────┐  │         │  │           │
>                 │   │    │    │           │  │DPLL_2   │  │           │
>                 └───┘    │    │           │  │         │  │           │
>                          │    │           └──┤         ├──┘           │
>                          │    │              │         │              │
>    EXT SMA connector     │    │              │         │              │
>                 ┌───┐    │    │              │         │              │
>                 │   ├────┘    │              └─────────┘              │
>                 │   │         │                                       │
>                 └───┘         └───────────────────────────────────────┘
> 
> Do I get that remotelly correct?

It looks goot, hence two corrections are needed:
- all inputs can go to all DPLLs, and a single source can drive more
  than one DPLL
- The external mux for SMA connector should not be a part of the
  Synchronizer subsystem - I believe there's already a separate MUX
  subsystem in the kernel and all external connections should be handled
  by a devtree or a similar concept.

The only "muxing" thing that could potentially be modeled is a
synchronizer output to synchronizer input relation. Some synchronizers
does that internally and can use the output of one DPLL as a source for
another.

Also, in theory, the DPLL->output relation may change, however I assume
we can skip support for that at the beginning.

So something like this would be roughly correct:
       ┌───────────────────────────┐
       │                           │
┌──┐   │ src0   ┌─────────┐   out0 │    ┌──┐
│  ├───┼────────┤ DPLL1   ├────────┼────┤  │
└──┘   │        │         │        │    └──┘
       │        │         │        │
       │        │         │   out1 │    ┌──┐
┌──┐   │ src1   │         ├───┬────┼────┤  │
│  ├───┼──┬─────┤         │   │    │    └──┘
└──┘   │  │     └─────────┘   │    │
       │  │   ┌───────────────┘    │
       │  │   │   src_dpll1        │
       │  │   │ ┌─────────┐   out2 │    ┌──┐
       │  │   └─┤ DPLL2   ├────────┼────┤  │
       │  │     │         │        │    └──┘
       │  └─────┤         │        │
┌──┐   │ src2   │         │        │
│  ├───┼────────┤         │        │
└──┘   │        │         │        │
       │        └─────────┘        │
       │                           │
       │                           │
       │                           │
       └───────────────────────────┘

> synch
> synchronizer_register(synch)
>    dpll_1
>    synchronizer_dpll_register(synch, dpll_1)
>    dpll_2
>    synchronizer_dpll_register(synch, dpll_2)
>    source_pin_1
>    synchronizer_pin_register(synch, source_pin_1)
>    output_pin_1
>    synchronizer_pin_register(synch, output_pin_1)
>    output_pin_2
>    synchronizer_pin_register(synch, output_pin_2)
> 
> synch_board
>    synchronizer_board_register(synch_board)
>    synch
>    synchronizer_board_sync_register(synch_board, synch)
>    source_connector_1
>    synchronizer_board_connector_register(synch_board, source_connector_1, source_pin_1)
>    output_connector_1
>    synchronizer_board_connector_register(synch_board, output_connector_1, output_pin_1)
>    output_connector_2
>    synchronizer_board_connector_register(synch_board, output_connector_2, output_pin_2)

I'd rather not use pins at all - just stick to sources and outputs. Both
can use some labels to be identifiable.


> Thinking about it a bit more, this should be probably good to describe
> by device tree. The synchronizer itself dplls and pins it contains
> have constanc geometry, according to the synchronizer device type.
> 
> The Connector-pin linkages may vary according to the board.
> 
> So to divide it, there should be one synchronizer driver. Then probably
> some other one to connect/select/mux the connectors to the synchronizer.

Agreed - we should not model external board connections inside the
synchronizer driver subsystem.
-Maciek

