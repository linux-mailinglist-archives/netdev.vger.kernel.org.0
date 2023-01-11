Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C1665FCC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjAKPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbjAKPyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:54:41 -0500
Received: from sender3-of-o58.zoho.com (sender3-of-o58.zoho.com [136.143.184.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD26665FC;
        Wed, 11 Jan 2023 07:54:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1673452459; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=EJZWDT2dX0vEVcfChvfS404SlVwFl5i1McYj3Gm7SE5+QGMXfTKN5m21kaU/kNBE9iV2yw2g2A2kOzJUvXi05iY3czo6wr1aQ73DgUjHvSHYiXdnDTa4FpScvzvPX0T3bwBfqQgWeSlgW5Odu692EE/8LVqGCl8zrOCyWzKxEvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1673452459; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=b7qxqVHHJS3n39YhXE/wgaIVM+N1l4+14b8e4obC3wg=; 
        b=RlAh2sbKCGVrrlGzavQOPrbGucvcZUKqh015KuD8FNk1h02hmmbNbz8vTjSFhB1vtXvhETNcjIJg3IQlPG7jiw0AP01tlMxEcgdButD3PWLhr41gpfPvQtdp9A5tWX3OmfON+WBYYAl1ox9OGF34z8bPFnI8IrnzjjxrgnaLRng=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=machnikowski.net;
        spf=pass  smtp.mailfrom=maciek@machnikowski.net;
        dmarc=pass header.from=<maciek@machnikowski.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1673452459;
        s=zoho; d=machnikowski.net; i=maciek@machnikowski.net;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=b7qxqVHHJS3n39YhXE/wgaIVM+N1l4+14b8e4obC3wg=;
        b=L0QlnEnBULaQApc5G85pcAIESLsek8zGUMFFM8Ksq/oRMaOLTA/FnVjxCY835+6a
        1qGGbGHBrlZN88TkPN44eRTH7jPglSuFnF+FKnMug9pLC95FLcCeg0hgb+X1feQLwKa
        Ss/aOEXWgToqsytC/LstzZmaGOMcNE5mX4ZjxKBJYEWjJ+Nfg+Vou6u1O67Vg5OvlJG
        rtnbBd6ahFeDOOLdvXDfDzV2TXkU4QXJCjDNVNMr8gPLbun8KwPDl4YnV8ZBYBLUKwF
        5pmSJBuGFgvbQO0Tx8x1QwqhnK02NcGFUVfOjtKuYZSKWjw19b5Q6O8bbpa4SvFJSwe
        BV6ARBR+1A==
Received: from [192.168.1.227] (83.8.154.240.ipv4.supernova.orange.pl [83.8.154.240]) by mx.zohomail.com
        with SMTPS id 1673452457607421.05834931876893; Wed, 11 Jan 2023 07:54:17 -0800 (PST)
Message-ID: <c08622be-a054-5204-1875-b54f77626bff@machnikowski.net>
Date:   Wed, 11 Jan 2023 16:54:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Content-Language: en-US
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
References: <Y4oj1q3VtcQdzeb3@nanopsycho> <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org> <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y7xBHtR3XwfAahry@nanopsycho>
 <DM6PR11MB4657E51AD937BBA5DC2B1FF19BFF9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <645a5bfd-0092-2f39-0ff2-3ffb27ccf8fe@machnikowski.net>
 <DM6PR11MB465713F87C83A9BDAC5412FA9BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <e4e84937-7fb6-f715-b33c-4d34a598f9ee@machnikowski.net>
 <DM6PR11MB4657E9C7F64FC9DF713696059BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
From:   Maciek Machnikowski <maciek@machnikowski.net>
In-Reply-To: <DM6PR11MB4657E9C7F64FC9DF713696059BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/2023 4:30 PM, Kubalewski, Arkadiusz wrote:
>> From: Maciek Machnikowski <maciek@machnikowski.net>
>> Sent: Wednesday, January 11, 2023 3:40 PM
>> To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>; Jiri Pirko
>> <jiri@resnulli.us>
>>
>>
>> On 1/11/2023 3:17 PM, Kubalewski, Arkadiusz wrote:
>>>> From: Maciek Machnikowski <maciek@machnikowski.net>
>>>> Sent: Tuesday, January 10, 2023 3:59 PM
>>>> To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>; Jiri Pirko
>>>> <jiri@resnulli.us>
>>>>
>>>> On 1/10/2023 11:54 AM, Kubalewski, Arkadiusz wrote:
>>>>>> From: Jiri Pirko <jiri@resnulli.us>
>>>>>> Sent: Monday, January 9, 2023 5:30 PM
>>>>>>>
>>>>>>> Hi guys,
>>>>>>>
>>>>>>> We have been trying to figure out feasibility of new approach
>> proposed
>>>> on
>>>>>> our
>>>>>>> latest meeting - to have a single object which encapsulates multiple
>>>>>> DPLLs.
>>>>>>>
>>>>>>> Please consider following example:
>>>>>>>
>>>>>>> Shared common inputs:
>>>>>>> i0 - GPS  / external
>>>>>>> i1 - SMA1 / external
>>>>>>> i2 - SMA2 / external
>>>>>>> i3 - MUX0 / clk recovered from PHY0.X driven by MAC0
>>>>>>> i4 - MUX1 / clk recovered from PHY1.X driven by MAC1
>>>>>>>
>>>>>>> +---------------------------------------------------------+
>>>>>>> | Channel A / FW0             +---+                       |
>>>>>>> |                         i0--|   |                       |
>>>>>>> |         +---+               |   |                       |
>>>>>>> | PHY0.0--|   |           i1--| D |                       |
>>>>>>> |         |   |               | P |                       |
>>>>>>> | PHY0.1--| M |           i2--| L |   +---+   +--------+  |
>>>>>>> |         | U |               | L |---|   |---| PHY0.0 |--|
>>>>>>> | PHY0.2--| X |-+---------i3--| 0 |   |   |   +--------+  |
>>>>>>> |         | 0 | |+------+     |   |---| M |---| PHY0.1 |--|
>>>>>>> | ...   --|   | || MUX1 |-i4--|   |   | A |   +--------+  |
>>>>>>> |         |   | |+------+     +---+   | C |---| PHY0.2 |--|
>>>>>>> | PHY0.7--|   | |         i0--|   |   | 0 |   +--------+  |
>>>>>>> |         +---+ |             |   |---|   |---| ...    |--|
>>>>>>> |               |         i1--| D |   |   |   +--------+  |
>>>>>>> |               |             | P |---|   |---| PHY0.7 |--|
>>>>>>> |               |         i2--| L |   +---+   +--------+  |
>>>>>>> |               |             | L |                       |
>>>>>>> |               \---------i3--| 1 |                       |
>>>>>>> |                +------+     |   |                       |
>>>>>>> |                | MUX1 |-i4--|   |                       |
>>>>>>> |                +------+     +---+                       |
>>>>>>> +---------------------------------------------------------+
>>>>>>> | Channel B / FW1             +---+                       |
>>>>>>> |                         i0--|   |                       |
>>>>>>> |                             |   |                       |
>>>>>>> |                         i1--| D |                       |
>>>>>>> |         +---+               | P |                       |
>>>>>>> | PHY1.0--|   |           i2--| L |   +---+   +--------+  |
>>>>>>> |         |   |  +------+     | L |---|   |---| PHY1.0 |--|
>>>>>>> | PHY1.1--| M |  | MUX0 |-i3--| 0 |   |   |   +--------+  |
>>>>>>> |         | U |  +------+     |   |---| M |---| PHY1.1 |--|
>>>>>>> | PHY1.2--| X |-+---------i4--|   |   | A |   +--------+  |
>>>>>>> |         | 1 | |             +---+   | C |---| PHY1.2 |--|
>>>>>>> | ...   --|   | |         i0--|   |   | 1 |   +--------+  |
>>>>>>> |         |   | |             |   |---|   |---| ...    |--|
>>>>>>> | PHY1.7--|   | |         i1--| D |   |   |   +--------+  |
>>>>>>> |         +---+ |             | P |---|   |---| PHY1.7 |--|
>>>>>>> |               |         i2--| L |   +---+   +--------+  |
>>>>>>> |               |+------+     | L |                       |
>>>>>>> |               || MUX0 |-i3--| 1 |                       |
>>>>>>> |               |+------+     |   |                       |
>>>>>>> |               \---------i4--|   |                       |
>>>>>>> |                             +---+                       |
>>>>>>> +---------------------------------------------------------+
>>>>>>
>>>>>> What is "a channel" here? Are these 2 channels part of the same
>> physival
>>>>>> chip? Could you add the synchronizer chip/device entities to your
>>>> drawing?
>>>>>>
>>>>>
>>>>> No.
>>>>> A "Synchronization Channel" on a switch would allow to separate groups
>>>>> of physical ports. Each channel/group has own "Synchronizer Chip",
>> which
>>>> is
>>>>> used to drive PHY clocks of that group.
>>>>>
>>>>> "Synchronizer chip" would be the 2 DPLLs on old draw, something like
>>>> this:
>>>>> +--------------------------------------------------------------+
>>>>> | Channel A / FW0        +-------------+   +---+   +--------+  |
>>>>> |                    i0--|Synchronizer0|---|   |---| PHY0.0 |--|
>>>>> |         +---+          |             |   |   |   +--------+  |
>>>>> | PHY0.0--|   |      i1--|             |---| M |---| PHY0.1 |--|
>>>>> |         |   |          | +-----+     |   | A |   +--------+  |
>>>>> | PHY0.1--| M |      i2--| |DPLL0|     |   | C |---| PHY0.2 |--|
>>>>> |         | U |          | +-----+     |   | 0 |   +--------+  |
>>>>> | PHY0.2--| X |--+---i3--| +-----+     |---|   |---| ...    |--|
>>>>> |         | 0 |  |       | |DPLL1|     |   |   |   +--------+  |
>>>>> | ...   --|   |  | /-i4--| +-----+     |---|   |---| PHY0.7 |--|
>>>>> |         |   |  | |     +-------------+   +---+   +--------+  |
>>>>> | PHY0.7--|   |  | |                                           |
>>>>> |         +---+  | |                                           |
>>>>> +----------------|-|-------------------------------------------+
>>>>> | Channel B / FW1| |     +-------------+   +---+   +--------+  |
>>>>> |                | | i0--|Synchronizer1|---|   |---| PHY1.0 |--|
>>>>> |         +---+  | |     |             |   |   |   +--------+  |
>>>>> | PHY1.0--|   |  | | i1--|             |---| M |---| PHY1.1 |--|
>>>>> |         |   |  | |     | +-----+     |   | A |   +--------+  |
>>>>> | PHY1.1--| M |  | | i2--| |DPLL0|     |   | C |---| PHY1.2 |--|
>>>>> |         | U |  | |     | +-----+     |   | 1 |   +--------+  |
>>>>> | PHY1.2--| X |  \-|-i3--| +-----+     |---|   |---| ...    |--|
>>>>> |         | 1 |    |     | |DPLL1|     |   |   |   +--------+  |
>>>>> | ...   --|   |----+-i4--| +-----+     |---|   |---| PHY1.7 |--|
>>>>> |         |   |          +-------------+   +---+   +--------+  |
>>>>> | PHY1.7--|   |                                                |
>>>>> |         +---+                                                |
>>>>> +--------------------------------------------------------------+
>>>>> Also, please keep in mind that is an example, there could be easily 4
>>>>> (or more) channels wired similarly.
>>>>>
>>>>
>>>>
>>>> Hi,
>>>>
>>>> This model tries to put too much into the synchronizer subsystem. The
>>>> synchronizer device should only model inputs, DPLLs and outputs.
>>>>
>>>> The PHY lane to Synchronizer input muxing should be done in the
>>>> PHY/netdev subsystem. That's why I wanted to start with the full model
>>>> to specifically address this topic.
>>>>
>>>> The netdev should have an assigned list of Synchronizer inputs that it
>>>> can recover its SyncE clocks into. It can be done by having a connection
>>>> between the synchronizer input object(s) and the netdev, just like the
>>>> netdev is connected to PHC clocks in the PHC subsystem. This is the
>>>> model I initially presented about a year ago for solving this specific
>>>> issue.
>>>>
>>>> Analogically, the netdev will be connected to a given output, however
>>>> changing anything in the physical clock configuration sounds dangerous.
>>>>
>>>> Does that sound reasonable?
>>>>
>>>> Regards
>>>> Maciek
>>>
>>> It sounds reasonable to some point.
>>> You have mentioned list of Synchronizer inputs. If there is a list of
>> inputs
>>> it means it was created somewhere. I assume dpll subsystem? If so you
>> would
>>> like to export that list out of dpll subsystem, thus other entities would
>> need
>>> to find such list, then find particular source and somehow register with
>> it.
>>> All of this was proposed as part of netdev, I don't see any benefit in
>> having
>>> this parts separated from dpll, as only dpll would use it, right?
>>> The same behavior is now provided by the MUX type pin, enclosed within
>> dpll
>>> subsystem.
>>>
>>> BR,
>>> Arkadiusz
>>
>> The synchronizer object should expose the list of inputs that represent
>> possible sources of a given chip. The list will be the same for all
>> DPLLs used by the same device, so it can be a single set of sources
>> linked to multiple DPLLs inside the package. A netdev can then point to
>> a given input of a synchronizer that it's connected to.
>> The phy lane->recovered clock (or directly a synchronizer input) muxing
>> should stay in the netdev subsystem, or in the PHY driver.
>>
>> The reason, and benefit, of such split is when you create a board with a
>> netdev X and a synchronizer Y that is not instantiated by the same
>> driver. In this scenario you'd get the ice driver to instantiate
>> connections and the DPLL vendor's driver for the synchronizer. In such
>> case the netdev driver will simply send a netlink message to the
>> input/source with a requested configuration, such as expected frequency,
>> and everything from this point can be handled by a completely different
>> driver creating clean and logical split.
>>
>> If we mix the phy lanes into the DPLL subsystem it'll get very
>> challenging to add PHY lanes to the existing synchronizer exposed by a
>> different driver.
> 
> This is possible right now:
> 1. obtain a dpll object:
> struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
> 						enum dpll_type type, u8 idx);
> 2. register new pin with muxed type pin:
> int dpll_muxed_pin_register(struct dpll_device *dpll,
> 			    const char *parent_pin_description,
> 			    struct dpll_pin *pin,
> 			    struct dpll_pin_ops *ops, void *priv);
> 
> To find dpll driver must know clock_id, type of dpll and its index given
> when dpll was registered.
> To register a pin, parent_pin_description of MUX type pin given on registering
> it with dpll device.

That would mean you need to repeat this process for all the DPLLs that
are co-packaged in a single synchronizer. Some chips have up to 8 DPLLs,
so you'd need to register number of phy lanes x number of DPLL times,
say 8x8 = 64 times - that's simply too messy in the long term.

>> Exporting and link between the synchronizer and the netdev is still a
>> must no matter which way we go. And IMO it's best to link netdev to
>> synchronizer sources, as that's the most natural way.
>>
> 
> The link is now just information for userspace Linux network interface index
> in DPLLA_PIN_NETIFINDEX attribute.

That's not the right way. We need to know:
- which DPLL pins/sources are driven by which netdev (to be able to
  identify a source of frequency that is currently driving a given DPLL)
- which DPLL generates a frequency for a given netdev (to know which
  DPLL to check for a specific netdev)

So we need to have 2 connections.
