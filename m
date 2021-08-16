Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1013EDE5C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhHPUB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhHPUBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 16:01:25 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBEFC061764;
        Mon, 16 Aug 2021 13:00:53 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id m21so2539702qkm.13;
        Mon, 16 Aug 2021 13:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S024hRAwZqlJE/Rl2lsZHRUCOODC0zD4/XZWLet2bQQ=;
        b=GNIitcpUAd0ASrW8iDAORWU40UX72s1eM3K//3nuYzs0xOvhp1Et0v+nT2GmKO3jxM
         ZejRh6+ATl07LCdYqfQteLMEfX/OvavaNfGvwXairPq+ajl6F5PHkyvjF1HK/FsbiKC5
         eGeuO+GVwgBPvT4mr9++G4OwwQDPAJ0rkI60NLZ1bfDx83IEpGCAPt0OL0iLg1f7khoR
         weX5/cgedfSMtHlJHUUl4CjH0gloLwtGU8C42jAT2xlNYY8Z+LBB2/i2WPBVo4Wmm3FO
         lzSOFIr6iTmvZYOJwbfI96MpbIjI3VWPIHnbNhCn80C3WP6NGVrxGw7PjwgWYOPvmU6c
         3BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S024hRAwZqlJE/Rl2lsZHRUCOODC0zD4/XZWLet2bQQ=;
        b=oQwvWTS8q0TfaaEjhzTGRGS4wuVrQHkNruJ9qrHuyTTmzDk8jGe9NSsySZNeJfOiVK
         5Loi78rYb3a0nwJNQOGobOG/89chPWNS0oVQRhynO9/osVndkMBj23PJFxZdcAqafwR9
         ukXSi5EMVjVEthbPHI8XRsCpuSigO8ECQKb8wS51cped4twuMm7pCXCSm3nMS+IAh7nc
         bHte+WUMnm8l3h7w9tTYTqtIetqockAhlp36xZYLa/V6Pv/O97BGMPJoKqG3OR15DCse
         +mSSqRc9jR0OTmwDqUQ0LQ2H+kGZz6sTZwMoVs4bwgwdJfhR8OZVD3vwgDFvTX6uIxH4
         YGKg==
X-Gm-Message-State: AOAM533LKwFGn2oq36t6E/mga7CP+fdjEFvvGxoU1QKJ57aj0eYepIRi
        yAzGz1YniObtWyLp7dLHOA8=
X-Google-Smtp-Source: ABdhPJxn+UXtjMPUeak2q65o73HH2b0PfsE6ZbXa0l93A6AVbjbzthMcZDuZiUzsoj/wEzCSM3mRVg==
X-Received: by 2002:a05:620a:c04:: with SMTP id l4mr60244qki.86.1629144052730;
        Mon, 16 Aug 2021 13:00:52 -0700 (PDT)
Received: from [192.168.1.49] (c-67-187-90-124.hsd1.tn.comcast.net. [67.187.90.124])
        by smtp.gmail.com with ESMTPSA id 75sm126914qko.100.2021.08.16.13.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 13:00:52 -0700 (PDT)
Subject: Re: of_node_put() usage is buggy all over drivers/of/base.c?!
From:   Frank Rowand <frowand.list@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20210814010139.kzryimmp4rizlznt@skbuf>
 <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
 <20210816144622.tgslast6sbblclda@skbuf>
 <4cad28e0-d6b4-800d-787b-936ffaca7be3@gmail.com>
 <CAL_JsqKYd288Th2cfOp0_HD1C8xtgKjyJfUW4JLpyn0NkGdU5w@mail.gmail.com>
 <2e98373f-c37c-0d26-5c9a-1f15ade243c1@gmail.com>
Message-ID: <84ccd797-c307-d724-0292-ee74aba43de2@gmail.com>
Date:   Mon, 16 Aug 2021 15:00:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2e98373f-c37c-0d26-5c9a-1f15ade243c1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hit send too soon, a couple of cleanups:

On 8/16/21 2:56 PM, Frank Rowand wrote:
> On 8/16/21 2:20 PM, Rob Herring wrote:
>> On Mon, Aug 16, 2021 at 10:14 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>>
>>> On 8/16/21 9:46 AM, Vladimir Oltean wrote:
>>>> Hi Frank,
>>>>
>>>> On Mon, Aug 16, 2021 at 09:33:03AM -0500, Frank Rowand wrote:
>>>>> Hi Vladimir,
>>>>>
>>>>> On 8/13/21 8:01 PM, Vladimir Oltean wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I was debugging an RCU stall which happened during the probing of a
>>>>>> driver. Activating lock debugging, I see:
>>>>>
>>>>> I took a quick look at sja1105_mdiobus_register() in v5.14-rc1 and v5.14-rc6.
>>>>>
>>>>> Looking at the following stack trace, I did not see any calls to
>>>>> of_find_compatible_node() in sja1105_mdiobus_register().  I am
>>>>> guessing that maybe there is an inlined function that calls
>>>>> of_find_compatible_node().  This would likely be either
>>>>> sja1105_mdiobus_base_tx_register() or sja1105_mdioux_base_t1_register().
>>>>
>>>> Yes, it is sja1105_mdiobus_base_t1_register which is inlined.
>>>>
>>>>>>
>>>>>> [  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
>>>>>> [  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
>>>>>> [  101.726763] INFO: lockdep is turned off.
>>>>>> [  101.730674] irq event stamp: 0
>>>>>> [  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>>>>>> [  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
>>>>>> [  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
>>>>>> [  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
>>>>>> [  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
>>>>>> [  101.774558] Call trace:
>>>>>> [  101.794734]  __might_sleep+0x50/0x88
>>>>>> [  101.798297]  __mutex_lock+0x60/0x938
>>>>>> [  101.801863]  mutex_lock_nested+0x38/0x50
>>>>>> [  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
>>>>>> [  101.809341]  sysfs_remove_dir+0x54/0x70
>>>>>
>>>>> The __kobject_del() occurs only if the refcount on the node
>>>>> becomes zero.  This should never be true when of_find_compatible_node()
>>>>> calls of_node_put() unless a "from" node is passed to of_find_compatible_node().
>>>>
>>>> I figured that was the assumption, that the of_node_put would never
>>>> trigger a sysfs file / kobject deletion from there.
>>>>
>>>>> In both sja1105_mdiobus_base_tx_register() and sja1105_mdioux_base_t1_register()
>>>>> a from node ("mdio") is passed to of_find_compatible_node() without first doing an
>>>>> of_node_get(mdio).  If you add the of_node_get() calls the problem should be fixed.
>>>>
>>>> The answer seems simple enough, but stupid question, but why does
>>>> of_find_compatible_node call of_node_put on "from" in the first place?
>>>
>>> Actually a good question.
>>>
>>> I do not know why of_find_compatible_node() calls of_node_put() instead of making
>>> the caller of of_find_compatible_node() responsible.  That pattern was created
>>> long before I was involved in devicetree and I have not gone back to read the
>>> review comments of when that code was created.
>>
> 
>> Because it is an iterator function and they all drop the ref from the
>> prior iteration.
> 
> That is what I was expecting before reading through the code.  But instead
> I found of_find_compatible_node():
> 
>         raw_spin_lock_irqsave(&devtree_lock, flags);
>         for_each_of_allnodes_from(from, np)
>                 if (__of_device_is_compatible(np, compatible, type, NULL) &&
>                     of_node_get(np))
>                         break;
>         of_node_put(from);
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
> 
> 
> for_each_of_allnodes_fromir:

  for_each_of_allnodes_from():

> 
> #define for_each_of_allnodes_from(from, dn) \
>         for (dn = __of_find_all_nodes(from); dn; dn = __of_find_all_nodes(dn))
> 
> 
> and __of_find_all_nodes() is:
> 
> struct device_node *__of_find_all_nodes(struct device_node *prev)
> {
>         struct device_node *np;
>         if (!prev) {
>                 np = of_root;
>         } else if (prev->child) {
>                 np = prev->child;
>         } else {
>                 /* Walk back up looking for a sibling, or the end of the structure */
>                 np = prev;
>                 while (np->parent && !np->sibling)
>                         np = np->parent;
>                 np = np->sibling; /* Might be null at the end of the tree */
>         }
>         return np;
> }
> 
> 
> So the iterator is not using of_node_get() and of_node_put() for each
> node that is traversed.  The protection against a node disappearing
> during the iteration is provided by holding devtree_lock.
> 
>>
>> I would say any open coded call where from is not NULL is an error.
> 
> I assume you mean any open coded call of of_find_compatible_node().  There are
> at least a couple of instances of that.  I did only a partial grep while looking
> at Vladimir's issue.
> 
> Doing the full grep now, I see 13 instances of architecture and driver code calling
> of_find_compatible_node().

  of_find_compatible_node() with parameter "from" not NULL.

> 
>> It's not reliable because the DT search order is not defined and could
>> change. Someone want to write a coccinelle script to check that?
>>
> 
>> The above code should be using of_get_compatible_child() instead.
> 
> Yes, of_get_compatible_child() should be used here.  Thanks for pointing
> that out.
> 
> There are 13 instances of architecture and driver code calling
> of_find_compatible_node().  If possible, it would be good to change all of
> them to of_get_compatible_child().  If we could replace all driver
> usage of of_find_compatible_node() with a from parameter of NULL to
> a new wrapper without a from parameter, where the wrapper calls
> of_find_compatible_node() with the from parameter set to NULL, then
> we could prevent this problem from recurring.
> 
> (I did not look at all 13 instances yet, to see if this can be done.)
> 
>>
>> Rob
>>
> 

