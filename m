Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0364757D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLHSXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHSXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:23:36 -0500
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Dec 2022 10:23:34 PST
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3114D5F2;
        Thu,  8 Dec 2022 10:23:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670522891; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=clSJvTgXI3YP5BwKy+RhSSz8KV/7/WlKN8jkv1vgDWLqjKvdw+VxronQE0ilzYXReEAPmrAUT4v1FfIV0wxfEgef9x3veI+5Bcl63iiAfAANKhp7DGDd5SQ1J/P/h1EMA7RcaBJQ7V0Ez32RBcc0+IwprwWlBgGDwGoEPk17XF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670522891; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=lVl0AW6NjKtrDN8pXdhzjnNBt7YZtcamrLdGxj4L9Y4=; 
        b=Ov44NLqvu0uUaN4cxaC5UUWXgDQBLazCzgeGT+8vMQJrJqsVJjSlbYE/0GnykbB+ndtAwJWwluCd45e7p6BIKYmASHCTx1FSJknwcoW2IazukLB/ksssbYR4Z9zVJyIBb8Issk/+689CYYsPzkjd49EY2ybZB959nK/8iklnhBA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=machnikowski.net;
        spf=pass  smtp.mailfrom=maciek@machnikowski.net;
        dmarc=pass header.from=<maciek@machnikowski.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1670522891;
        s=zoho; d=machnikowski.net; i=maciek@machnikowski.net;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=lVl0AW6NjKtrDN8pXdhzjnNBt7YZtcamrLdGxj4L9Y4=;
        b=QVSEZbndRq3Zzufk8gnYWqfmBP3KeMuj09MZEdyjs7ElO+TfjiWSxzi7DOdi4vfb
        6fimYWaP0E0IF4+3opGuV3IRifOrb0hm8miLsNfsqfSUp7eOfKAU/qTfobzqY5AqK7z
        miahNHBuKvfGKHoCFJuPiScgYIY1aQ9ixjeXDzeh5a3WFDu9MkBDjMCvQjdU9QnTD6t
        gEgqsAvDIap4MbXdQJrt4LajvVaoLs2Fou5e/3JDVzB2UN05kNKW427KNLoVCd3g0Da
        Heaa8jXhadYJCI3aTUNNZZZykqqLQ2FFjrXSHjx/OUFgtvnfyFsfMetI6Wes0RKGHip
        RuJbhIUA6w==
Received: from [192.168.1.227] (83.8.188.9.ipv4.supernova.orange.pl [83.8.188.9]) by mx.zohomail.com
        with SMTPS id 167052288851018.2093850153816; Thu, 8 Dec 2022 10:08:08 -0800 (PST)
Message-ID: <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
Date:   Thu, 8 Dec 2022 19:08:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     'Jiri Pirko' <jiri@resnulli.us>,
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
From:   Maciek Machnikowski <maciek@machnikowski.net>
In-Reply-To: <20221207152157.6185b52b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/2022 12:21 AM, Jakub Kicinski wrote:
> On Wed, 7 Dec 2022 15:09:03 +0100 netdev.dump@gmail.com wrote:
>>> -----Original Message-----
>>> From: Jakub Kicinski <kuba@kernel.org>
>> pins between the DPLLs exposed by a single driver, but not really outside of
>> it.
>> And that can be done simply by putting the pin ptr from the DPLLA into the
>> pin
>> list of DPLLB.
> 
> Are you saying within the driver it's somehow easier? The driver state
> is mostly per bus device, so I don't see how.
> 
>> If we want the kitchen-and-sink solution, we need to think about corner
>> cases.
>> Which pin should the API give to the userspace app - original, or
>> muxed/parent?
> 
> IDK if I parse but I think both. If selected pin is not directly
> attached the core should configure muxes.
> 
>> How would a teardown look like - if Driver A registered DPLLA with Pin1 and
>> Driver B added the muxed pin then how should Driver A properly
>> release its pins? Should it just send a message to driver B and trust that
>> it
>> will receive it in time before we tear everything apart?
> 
> Trivial.
> 
>> There are many problems with that approach, and the submitted patch is not
>> explaining any of them. E.g. it contains the dpll_muxed_pin_register but no
>> free 
>> counterpart + no flows.
> 
> SMOC.
> 
>> If we want to get shared pins, we need a good example of how this mechanism
>> can be used.
> 
> Agreed.

My main complaint about the current pins implementation is that they put
everything in a single bag. In a netdev world - it would be like we put
TX queues and RX queues together, named them "Queues", expose a list to
the userspace and let the user figure out which ones which by reading a
"TX" flag.

All DPLLs I know have a Sources block, DPLLs and Output blocks. See:

https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-frequency-translation/8a34044-multichannel-dpll-dco-four-eight-channels#overview

https://ww1.microchip.com/downloads/aemDocuments/documents/TIM/ProductDocuments/ProductBrief/ZL3063x-System-Synchronizers-with-up-to-5-Channels-10-Inputs-20-Outputs-Product-Brief-DS20006634.pdf

https://www.sitime.com/support/resource-library/product-briefs/cascade-sit9514x-clock-system-chip-family

https://www.ti.com/lit/ds/symlink/lmk5b33414.pdf?ts=1670516132647&ref_url=https%253A%252F%252Fwww.ti.com%252Fclocks-timing%252Fjitter-cleaners-synchronizers%252Fproducts.html

If we model everything as "pins" we won't be able to correctly extend
the API to add new features.

Sources can configure the expected frequency, input signal monitoring
(on multiple layers), expected signal levels, input termination and so
on. Outputs will need the enable flag, signal format, frequency, phase
offset etc. Multiple DPLLs can reuse a single source inside the same
package simultaneously.

A source should be able to link to a pin or directly to the netdev for
some embedded solutions. We don't need to go through the pin abstraction
at all.

An optional pin entity should only represent a physical connection with
a name and maybe a 3-state selection of In/Out/HiZ and then link to
sources or output of the DPLL(s).

Finally, the DPLL object should keep track of the source priority list,
have a proper status (locked/unlocked/holdover/freerunning), implement
the NCO mode, lock thresholds, bandwidths, auto-switch mode and so on.

Current implementation creates a lot of ambiguity, mixes input pins with
output pins and assigns priories to pins. Every SW entity will receive a
big list of pins and will need to parse it.

I prefer the approach that the ptp subsystem set - with its abstraction
of input/output channels and pins that can be assigned to them. While
not perfect - it represents reality much closer.

Thanks
Maciek
